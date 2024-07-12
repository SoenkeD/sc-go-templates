package actions

import (
	"fmt"

	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/state"
)

const PrintActionKey = "PrintAction"

func init() {
	AllActions[PrintActionKey] = PrintAction{}
}

type PrintAction struct{}

func (action PrintAction) Do(ctx *Ctx, state *ExtendedState, args ...string) error {
	fmt.Print(args[0] + "\n")
	return nil
}
