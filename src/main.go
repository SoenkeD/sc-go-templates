package main

import (
	"log"

	"github.com/SoenkeD/sc-go-templates/src/controller/templates"
	"github.com/SoenkeD/sc-go-templates/src/controller/templates/controller"
	"github.com/SoenkeD/sc-go-templates/src/controller/templates/state"
)

func main() {

	ctl := templates.InitCtl(&state.Ctx{}, controller.ControllerSettingsInput{})
	reconciler := controller.InitReconciler(ctl, controller.ReconcilerInput{})

	err := reconciler.Reconcile()
	if err != nil {
		log.Fatal(err)
	}
}
