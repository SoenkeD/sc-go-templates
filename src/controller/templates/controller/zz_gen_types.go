package controller

import (
	"strings"

	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/state"
)

type Action interface {
	Do(ctx *Ctx, state *ExtendedState, args ...string) error
}

type Guard interface {
	Do(state *ExtendedState, args ...string) bool
}

type State struct {
	Actions     []StateAction
	Transitions []Transition
}

type TransitionType string

const (
	TransitionTypeNormal TransitionType = "normal"
	TransitionTypeError  TransitionType = "error"
	TransitionTypeHappy  TransitionType = "happy"
)

const (
	KeyStartState = "StartState"
	KeyEndState   = "EndState"
)

type Transition struct {
	Guard      string
	GuardArgs  []string
	Action     string
	ActionArgs []string
	Next       string
	Negation   bool
	Type       TransitionType
}

func (tr *Transition) GetId() string {

	negationStr := "false"
	if tr.Negation {
		negationStr = "true"
	}

	return strings.Join(
		[]string{
			strings.TrimSuffix(tr.Action, "Action"),
			strings.Join(tr.ActionArgs, ","),
			strings.TrimSuffix(tr.Guard, "Guard"),
			strings.Join(tr.GuardArgs, ","),
			string(tr.Type),
			strings.ReplaceAll(strings.TrimSuffix(tr.Next, "State"), "/", "\\"),
			negationStr,
		},
		"/",
	)
}

type StateAction struct {
	Action     string
	ActionArgs []string
}

type PanicErr struct {
	Err        string
	Route      []string
	StackTrace []string
}

type StateErr struct {
	State     string
	ActionErr ActionErr
}

type ActionErr struct {
	Err    error
	Action string
}

type CtlErr struct {
	StateErr *StateErr
	PanicErr *PanicErr
	Route    []string
}

type CtlRes struct {
	Route []string
	State ExtendedState
}

type AfterInitHandler interface {
	React() *ExtendedState
}

type DefaultAfterInitHandler struct {
	State ExtendedState
}

func (rec *DefaultAfterInitHandler) React() *ExtendedState {
	return &rec.State
}

type AfterActionHandler interface {
	React(state ExtendedState) (next bool)
}

type DefaultAfterActionHandler struct{}

func (rec *DefaultAfterActionHandler) React(state ExtendedState) (next bool) {
	next = true
	return
}

type AfterStateHandler interface {
	React(state ExtendedState) (next bool)
}

type DefaultAfterStateHandler struct{}

func (rec *DefaultAfterStateHandler) React(state ExtendedState) (next bool) {
	next = true
	return
}

type ControllerSettingsInput struct {
	AfterInit   AfterInitHandler
	AfterAction AfterActionHandler
	AfterState  AfterStateHandler
}

type ControllerSettings struct {
	AfterInit   AfterInitHandler
	AfterAction AfterActionHandler
	AfterState  AfterActionHandler
}

func ControllerSettingsFromInput(input ControllerSettingsInput) (set ControllerSettings) {

	if input.AfterInit != nil {
		set.AfterInit = input.AfterInit
	} else {
		set.AfterInit = &DefaultAfterInitHandler{}
	}

	if input.AfterAction != nil {
		set.AfterAction = input.AfterAction
	} else {
		set.AfterAction = &DefaultAfterActionHandler{}
	}

	if input.AfterState != nil {
		set.AfterState = input.AfterState
	} else {
		set.AfterState = &DefaultAfterStateHandler{}
	}

	return
}
