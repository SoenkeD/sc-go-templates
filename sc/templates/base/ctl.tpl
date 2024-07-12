package controller

import (
	"fmt"
	"log"
	"strings"

	. "{{ .ImportRoot }}/state"
)

type Ctl struct {
	Actions map[string]Action
	Guards  map[string]Guard
	States  map[string]State

	state    *ExtendedState
	Ctx      *Ctx
	Settings ControllerSettings

	nextState  string
	stateStack []string
	panic      *PanicErr
}

func (ctl *Ctl) init() {
	ctl.nextState = KeyStartState
	ctl.state = new(ExtendedState)
	ctl.stateStack = []string{}
	ctl.panic = nil
}

func (ctl *Ctl) findErrorHandling() error {

	// find state which caused error
	var errorState string
	for idx := len(ctl.state.Route); idx > 0; idx-- {

		if !strings.HasSuffix(ctl.state.Route[idx-1], "State") {
			continue
		}

		errorState = ctl.state.Route[idx]
		break
	}

	// check if error state has error handling
	state := ctl.States[errorState]
	for _, ta := range state.Transitions {
		if ta.Type == TransitionTypeError {
			executed, stateErr := ctl.doTransition(ta)
			if !executed {
				continue
			}

			if stateErr != nil {
				ctl.state.Error = stateErr.ActionErr.Err
				noErrHandling := ctl.findErrorHandling()
				if noErrHandling != nil {
					break
				}
			}

			return nil
		}
	}

	// check if compound states have error handling
	for idx := len(ctl.stateStack); idx > 0; idx++ {

		startStateName := ctl.stateStack[idx-1]
		endStateName := strings.ReplaceAll(startStateName, KeyStartState, KeyEndState)

		compoundState := ctl.States[endStateName]
		for _, ta := range compoundState.Transitions {
			if ta.Type == TransitionTypeError {
				executed, stateErr := ctl.doTransition(ta)
				if !executed {
					continue
				}

				if stateErr != nil {
					ctl.state.Error = stateErr.ActionErr.Err
					noErrHandling := ctl.findErrorHandling()
					if noErrHandling != nil {
						idx = -1
						continue
					}
				}

				return nil
			}
		}
	}

	return fmt.Errorf("cannot find any error handling")
}

func (ctl *Ctl) Run() (res CtlRes, err *CtlErr) {

	ctl.init()

	for ctl.nextState != KeyEndState {
		stateErr := ctl.doNextState()

		if ctl.panic != nil {
			err = &CtlErr{
				PanicErr: ctl.panic,
				Route:    ctl.state.Route,
			}
			return
		}

		if stateErr != nil {
			ctl.state.Error = stateErr.ActionErr.Err
			noErrHandling := ctl.findErrorHandling()
			if noErrHandling == nil {
				continue
			}

			err = &CtlErr{
				StateErr: stateErr,
				Route:    ctl.state.Route,
			}
			return
		}

		nextState := ctl.Settings.AfterState.React(*ctl.state)
		if !nextState {
			err = &CtlErr{
				StateErr: &StateErr{
					State: ctl.nextState,
					ActionErr: ActionErr{
						Err: fmt.Errorf("AfterStateHandler: decided to not continue"),
					},
				},
				Route: ctl.state.Route,
			}
		}
	}

	ctl.state.Route = append(ctl.state.Route, KeyEndState)
	res = CtlRes{
		Route: ctl.state.Route,
	}

	return
}

func (ctl *Ctl) doTransition(transition Transition) (executed bool, err *StateErr) {

	if transition.Type == TransitionTypeHappy && transition.Guard != "" {
		log.Fatalln("FATAL: Happy path transition has the guard '" + transition.Guard + "' - this might cause the state machine to get stuck")
	}

	if transition.Guard != "" {
		guard := ctl.Guards[transition.Guard]
		if xor(!guard.Do(ctl.state, transition.GuardArgs...), transition.Negation) {
			return false, nil
		}
		ctl.state.Route = append(ctl.state.Route, transition.Guard)
	}

	if transition.Action != "" {
		err := ctl.doAction(transition.Action, transition.ActionArgs)
		if ctl.panic != nil {
			return true, &StateErr{
				State: ctl.nextState,
			}
		}
		if err != nil {
			return true, &StateErr{
				State:     ctl.nextState,
				ActionErr: *err,
			}
		}
		nextAction := ctl.Settings.AfterAction.React(*ctl.state)
		if !nextAction {
			return true, &StateErr{
				State: ctl.nextState,
				ActionErr: ActionErr{
					Action: transition.Action,
					Err:    fmt.Errorf("AfterTransitionActionHandler: decided to not continue"),
				},
			}
		}
	}

	ctl.nextState = transition.Next

	return true, nil
}

func xor(a, b bool) bool {
	return (a || b) && !(a && b)
}

func (ctl *Ctl) doNextState() *StateErr {

	ctl.state.Route = append(ctl.state.Route, ctl.nextState)

	if strings.HasSuffix(ctl.nextState, KeyStartState) {
		ctl.stateStack = append(ctl.stateStack, ctl.nextState)
	}

	if strings.HasSuffix(ctl.nextState, "EndState") {
		if len(ctl.stateStack) < 2 {
			ctl.stateStack = []string{}
		} else {
			ctl.stateStack = ctl.stateStack[:len(ctl.stateStack)-2]
		}
	}

	state := ctl.States[ctl.nextState]

	for _, action := range state.Actions {
		err := ctl.doAction(action.Action, action.ActionArgs)
		if ctl.panic != nil {
			return &StateErr{
				State: ctl.nextState,
			}
		}
		if err != nil || ctl.panic != nil {
			return &StateErr{
				State:     ctl.nextState,
				ActionErr: *err,
			}
		}

		nextAction := ctl.Settings.AfterAction.React(*ctl.state)
		if !nextAction {
			return &StateErr{
				State: ctl.nextState,
				ActionErr: ActionErr{
					Action: action.Action,
					Err:    fmt.Errorf("AfterStateAction: decided to not continue"),
				},
			}
		}
	}

	for _, transition := range state.Transitions {

		executed, stateErr := ctl.doTransition(transition)
		if !executed {
			continue
		}

		if stateErr != nil {
			return stateErr
		}

		break
	}

	return nil
}

func (ctl *Ctl) doAction(actionID string, actionParams []string) *ActionErr {

	defer func() {
		if err := recover(); err != nil {
			ctl.panic = &PanicErr{
				Err:        fmt.Sprintf("%s", err),
				Route:      ctl.state.Route,
				StackTrace: getStackTrace(2),
			}
		}
	}()

	ctl.state.Route = append(ctl.state.Route, actionID)

	action := ctl.Actions[actionID]
	err := action.Do(ctl.Ctx, ctl.state, actionParams...)
	if err != nil {
		return &ActionErr{
			Action: actionID,
			Err:    err,
		}
	}

	return nil
}
