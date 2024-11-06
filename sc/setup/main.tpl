package main

import (
	"log"

	"{{ .Cfg.Module }}/{{ .Cfg.CtlDir }}/{{ .InitCtl }}"
	"{{ .Cfg.Module }}/{{ .Cfg.CtlDir }}/{{ .InitCtl }}/controller"
	"{{ .Cfg.Module }}/{{ .Cfg.CtlDir }}/{{ .InitCtl }}/state"
)

func main() {

	ctl := {{ .InitCtl }}.InitCtl(&state.Ctx{}, controller.ControllerSettingsInput{})

	res, err := ctl.Run()
	if err != nil {
		log.Fatal(err)
	}
	log.Println(res)
}