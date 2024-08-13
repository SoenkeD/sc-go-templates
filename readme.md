# SC Golang Templates
This repository contains the templates to use the sc CLI tool 
to generate Golang state machines.

## Install sc CLI
`go install github.com/SoenkeD/sc`

Ensure `~/go/bin` is in your path. 

## Setup

<div style="border-left: 5px solid #007bff; padding: 10px; margin: 20px 0;">
    <strong style="color: #007bff;">ℹ️ Requirements</strong>
    <p style="margin: 5px 0 0 0;">
        A container runtime such as Docker is required.
    </p>
	<p style="margin: 5px 0 0 0;">
        Install <a href="https://onsi.github.io/ginkgo/">Ginkgo</a> to execute the tests
    </p>
</div>

## Getting started
To get started [read the guide](docs/getting_started.md) which
goes through the features and intended usage of this tool
on an example.

### Setup a new project

1. Navigate to the directory where the project should be created in
2. Set the desired parameters and execute the command below 
```bash
sc init --setup https://github.com/SoenkeD/sc-go-templates/main/sc/setup \
	--name myctl \
	--root $PWD/demo  \
	--module demo
```
See further information for the command
[here](https://github.com/SoenkeD/sc/blob/main/docs/features.md) 

3. Navigate into the project
4. Modify the `Print` action to print the first argument
5. Run `make run` to see the first running state machine



### Add to existing code
<div style="border-left: 5px solid #007bff; padding: 10px; margin: 20px 0;">
    <strong style="color: #007bff;">
    ℹ️ The directory "{ROOT}/sc" is required to not exist
    </strong>
</div>

1. Navigate to the go root directory in your project 
(where `go.mod` is located)
2. Set the desired parameters and execute the command below 
```bash
sc init --setup https://github.com/SoenkeD/sc-go-templates/main/sc/add \
	--name myctl \
	--root $PWD/demo  \
	--module demo  \
    --ctl src/controller
```

Change `--ctl` to the directory the state machine code should be located.
See further information for the command
[here](https://github.com/SoenkeD/sc/blob/main/docs/features.md) 

3. Consider adding the [Makefile](sc/setup//Makefile.tpl). 
Then run `make sc` to generate the code. 

4. To use the generated code access it e.g. by
```golang
package main

import (
	"log"

	"demo/src/controller/myctl"
	"demo/src/controller/myctl/controller"
	"demo/src/controller/myctl/state"
)

func main() {
	ctl := myctl.InitCtl(
		&state.Ctx{},
		controller.ControllerSettingsInput{
			AfterInit: &controller.DefaultAfterInitHandler{
				State: state.ExtendedState{
					Hello: "world",
				},
			},
		},
	)

	res, err := ctl.Run()
	if err != nil {
		log.Fatalln(err.PanicErr, err.StateErr)
	}

	log.Println(res)
}
```
and add to `Hello string` to `ExtendedState` 
in `src/controller/myctl/state/ExtendedState.go`.