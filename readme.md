# SC Golang Templates
This repository contains the templates to use the sc CLI tool 
to generate Golang state machines.

## Install sc CLI
`go install github.com/SoenkeD/sc`

Ensure `~/go/bin` is in your path. 

## Setup
1. Navigate to the directory where the project should be created
2. Set the desired parameters and execute the command below 
```bash
sc init --setup https://github.com/SoenkeD/sc-go-templates/main/sc/setup \ 
	--name myctl \
	--root $PWD/demo  \
	--module demo
```
`--name` is the name of the first controller to create \
`--root` is the desired root of the project (the directory should not exist) \
`--module` is the name of the desired Golang module e.g. `github.com/SoenkeD/sc`

3. Navigate into the project
4. Modify the `Print` action to print the first argument
5. Run `make run` to see the first running state machine

## Setup a new Golang sc project (manually)

1. Create sc folder `mkdir ./sc`
2. Create `sc.yaml' with the following content
```yaml
module: "example.com/example/example-sc"
language: "go"
EnableGeneratedFilePrefix: true
importPathSeparator: "/"
ctlDir: "src/controller"
imports:
- repoOwner: "SoenkeD"
  repoName: "sc-go-templates"
  repoPath: "sc/templates/"
  localPath: "sc/templates/"
templates:
  - dir: "sc/templates"
```

3. Create controller folder `mkdir -p ./src/controller/myctl`
4. Create PlantUML file `./src/controller/myctl/myctl.plantuml`
(must have the same name as the controller) with the following content
```
@startuml Demo

[*] --> DemoState: [ CheckAlwaysTrue ]
[*] -[bold]-> [*]: / Print(The guard needs to be implemented)

DemoState: do / AddMsg(Hello)
DemoState: do / AddMsg(World)
DemoState: do / AddMsg(!)
DemoState --> BurnState: [ CheckAlwaysTrue ] / Print(Go to BurnState)
DemoState -[bold]-> [*]


BurnState: do / Print(Got messages)
BurnState: do / PrintMsgs
BurnState -[bold]-> [*]
```
5. (optional) Create a Makefile with the following content
```
CTL_DIR=src/controller

#############################
#############################
### Exec 
#############################
#############################

.PHONY: test
test: vet fmt
	~/go/bin/ginkgo -r -cover -coverprofile=coverage.out

.PHONY: run
run:
	go run src/main.go

#############################
#############################
### Golang 
#############################
#############################
.PHONY: fmt
fmt:
	go fmt ./...

.PHONY: vet
vet:
	go vet ./...


#############################
#############################
### SC 
#############################
#############################
sc=~/go/bin/sc
.PHONY: sc-gen
sc-gen:
	$(foreach dir,$(wildcard $(CTL_DIR)/*), \
		sc gen --root $(PWD) --name $(notdir $(dir));)

.PHONY: sc
sc: plantuml-gen sc-gen

.PHONY: export
export:
	$(sc) export --root $(PWD)

.PHONY: import
import:
	$(sc) import --root $(PWD)

#############################
#############################
### PlantUML 
#############################
#############################
PLANTUML_PORT=8054
PLANTUML_CONTAINER_NAME=sc-plantuml-server

.PHONY: plantuml-gen
plantuml-gen: plantuml-start $(patsubst $(CTL_DIR)/%.plantuml,$(CTL_DIR)/%.svg,$(wildcard $(CTL_DIR)/*/*.plantuml))
$(CTL_DIR)/%.svg: src/controller/%.plantuml
	curl -X POST \
		-H "Content-Type: text/plain" \
		--data-binary "@$<" \
		http://localhost:$(PLANTUML_PORT)/svg \
		> $@

.PHONY: plantuml-start
plantuml-start:
	@if [ ! $$(docker ps -q -f name=$(PLANTUML_CONTAINER_NAME)) ]; then \
		docker run --rm -d --name $(PLANTUML_CONTAINER_NAME) \
			-p $(PLANTUML_PORT):8080 \
			plantuml/plantuml-server; \
	fi

.PHONY: plantuml-stop
plantuml-stop:
	docker stop $(PLANTUML_CONTAINER_NAME)
```

6. Run `go mod init example.com/example/example-sc`
7. Install Gomega dependencies `go get github.com/onsi/gomega/...`
8. Install Ginkgo dependencies `go get github.com/onsi/ginkgo/v2`
9. Create `src/main.go` with the following content
```go
package main

import (
	"log"

	"example.com/example/example-sc/src/controller/myctl"
	"example.com/example/example-sc/src/controller/myctl/controller"
	"example.com/example/example-sc/src/controller/myctl/state"
)

func main() {

	ctl := myctl.InitCtl(&state.Ctx{}, controller.ControllerSettingsInput{})
	reconciler := controller.InitReconciler(ctl, controller.ReconcilerInput{})

	err := reconciler.Reconcile()
	if err != nil {
		log.Fatal(err)
	}
}
```
10. Import the base templates `make import`
11. Generate the state machine by running `make sc`
12. Implement at least the Print action in `src/controller/myctl/actions/Print.go`
13. Execute your first running state machine with `make run`