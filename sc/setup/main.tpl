package main

import (
	"log"

	"{{ .Cfg.Module }}{{ .Cfg.CtlRoot }}/{{ .InitCtl }}"
	"{{ .Cfg.Module }}{{ .Cfg.CtlRoot }}/{{ .InitCtl }}/controller"
	"{{ .Cfg.Module }}{{ .Cfg.CtlRoot }}/{{ .InitCtl }}/state"
)

func main() {

	ctl := {{ .InitCtl }}.InitCtl(&state.Ctx{}, controller.ControllerSettingsInput{})
	reconciler := controller.InitReconciler(ctl, controller.ReconcilerInput{})

	err := reconciler.Reconcile()
	if err != nil {
		log.Fatal(err)
	}
}