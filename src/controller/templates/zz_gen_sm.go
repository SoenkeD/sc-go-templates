package templates

import (
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/actions"
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/controller"
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/guards"
)

const BurnStateStateKey = "BurnStateState"

func init() {
	AllStates[BurnStateStateKey] = State{
		Actions: []StateAction{
			{
				Action: PrintActionKey,
				ActionArgs: []string{
					"Got messages",
				},
			},
			{
				Action:     PrintMsgsActionKey,
				ActionArgs: []string{},
			},
		},
		Transitions: []Transition{
			{
				Type:     TransitionTypeHappy,
				Next:     EndStateKey,
				Negation: false,
			},
		},
	}
}

const DemoStateStateKey = "DemoStateState"

func init() {
	AllStates[DemoStateStateKey] = State{
		Actions: []StateAction{
			{
				Action: AddMsgActionKey,
				ActionArgs: []string{
					"Hello",
				},
			},
			{
				Action: AddMsgActionKey,
				ActionArgs: []string{
					"World",
				},
			},
			{
				Action: AddMsgActionKey,
				ActionArgs: []string{
					"!",
				},
			},
		},
		Transitions: []Transition{
			{
				Type:   TransitionTypeNormal,
				Next:   BurnStateStateKey,
				Action: PrintActionKey,
				ActionArgs: []string{
					"Go to BurnState",
				},
				Guard:    CheckAlwaysTrueGuardKey,
				Negation: false,
			},
			{
				Type:     TransitionTypeHappy,
				Next:     EndStateKey,
				Negation: false,
			},
		},
	}
}

const EndStateKey = "EndState"

func init() {
	AllStates[EndStateKey] = State{
		Actions:     []StateAction{},
		Transitions: []Transition{},
	}
}

const StartStateKey = "StartState"

func init() {
	AllStates[StartStateKey] = State{
		Actions: []StateAction{},
		Transitions: []Transition{
			{
				Type:     TransitionTypeNormal,
				Next:     DemoStateStateKey,
				Guard:    CheckAlwaysTrueGuardKey,
				Negation: false,
			},
			{
				Type:   TransitionTypeHappy,
				Next:   EndStateKey,
				Action: PrintActionKey,
				ActionArgs: []string{
					"The guards needs to be implemented",
				},
				Negation: false,
			},
		},
	}
}
