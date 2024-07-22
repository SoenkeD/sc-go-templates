package main

import (
	"log"

	"{{ .Cfg.Module }}{{ .Cfg.RepoRoot }}/{{ .InitCtl }}"
	"{{ .Cfg.Module }}{{ .Cfg.RepoRoot }}/{{ .InitCtl }}/controller"
	"{{ .Cfg.Module }}{{ .Cfg.RepoRoot }}/{{ .InitCtl }}/state"
)

func main() {

	ctl := {{ .InitCtl }}.InitCtl(&state.Ctx{}, controller.ControllerSettingsInput{})
	reconciler := controller.InitReconciler(ctl, controller.ReconcilerInput{})

	err := reconciler.Reconcile()
	if err != nil {
		log.Fatal(err)
	}
}