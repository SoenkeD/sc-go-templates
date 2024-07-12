package templates

import (
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/actions"
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/controller"
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/guards"
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/state"
)

func InitCtl(ctx *Ctx, input ControllerSettingsInput) *Ctl {
	return &Ctl{
		Actions:  AllActions,
		Guards:   AllGuards,
		States:   AllStates,
		Ctx:      ctx,
		Settings: ControllerSettingsFromInput(input),
	}
}

var AllStates = map[string]State{}
