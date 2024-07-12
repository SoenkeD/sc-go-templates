package {{ .Name }}

import (
	. "{{ .ImportRoot }}/actions"
	. "{{ .ImportRoot }}/controller"
	. "{{ .ImportRoot }}/guards"
	. "{{ .ImportRoot }}/state"
)

func InitCtl(ctx *Ctx, input ControllerSettingsInput) *Ctl {
	return &Ctl{
		Actions:  AllActions,
		Guards:   AllGuards,
		States:   AllStates,
		Ctx:	  ctx,
		Settings: ControllerSettingsFromInput(input),
	}
}

var AllStates = map[string]State{}