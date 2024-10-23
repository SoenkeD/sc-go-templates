package main

import (
	"log"

	"github.com/SoenkeD/sc-go-templates/src/controller/templates"
	"github.com/SoenkeD/sc-go-templates/src/controller/templates/controller"
	"github.com/SoenkeD/sc-go-templates/src/controller/templates/state"
)

func main() {

	ctl := templates.InitCtl(&state.Ctx{}, controller.ControllerSettingsInput{})

	res, err := ctl.Run()
	if err != nil {
		log.Fatal(err)
	}

	log.Println(res)
}
