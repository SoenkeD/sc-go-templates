package actions

import (
	"log"

	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/state"
)

const PrintMsgsActionKey = "PrintMsgsAction"

func init() {
	AllActions[PrintMsgsActionKey] = PrintMsgsAction{}
}

type PrintMsgsAction struct{}

func (action PrintMsgsAction) Do(ctx *Ctx, state *ExtendedState, args ...string) error {
	log.Println(state.Msg)
	return nil
}
