package actions

import (
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/state"
)

const AddMsgActionKey = "AddMsgAction"

func init() {
	AllActions[AddMsgActionKey] = AddMsgAction{}
}

type AddMsgAction struct{}

func (action AddMsgAction) Do(ctx *Ctx, state *ExtendedState, args ...string) error {
	if len(state.Msg) > 0 {
		state.Msg += " "
	}

	state.Msg += args[0]

	return nil
}
