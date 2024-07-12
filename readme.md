## Setup a new Golang sc project

1. Create sc folder `mkdir ./sc`
2. Create `sc.yaml' with the following content
```yaml
module: "example.com/example/example-templates"
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
[*] -[bold]-> [*]: / Print(The guards needs to be implemented)

DemoState: do / AddMsg(Hello)
DemoState: do / AddMsg(World1)
DemoState: do / AddMsg(!)
DemoState --> BurnState: [ CheckAlwaysTrue ] / Print(Go to BurnState)
DemoState -[bold]-> [*]


BurnState: do / Print(Got messages)
BurnState: do / PrintMsgs
BurnState -[bold]-> [*]
```
5. (optional) Create a Makefile with the following content
```
sc=~/go/bin/sc

.PHONY: sc
sc:
	$(sc) gen --root $(PWD) --name templates

.PHONY: import
import:
	$(sc) import --root $(PWD)

.PHONY: export
export:
	$(sc) export --root $(PWD)

.PHONY: fmt
fmt:
	go fmt ./...

.PHONY: vet
vet:
	go vet ./...

.PHONY: test
test: vet fmt
	~/go/bin/ginkgo -r

.PHONY: run
run:
	go run src/main.go
```

6. Run `go mod init example.com/example/example-sc`
7. Install Gomega dependencies `go get github.com/onsi/gomega/...`
8. Install Ginkgo dependencies `go get github.com/onsi/ginkgo/v2`
9. Create `src/main.go` with the following content
```go
package main

import (
	"log"

	"example.com/example/example-templates/src/controller/templates"
	"example.com/example/example-templates/src/controller/templates/controller"
	"example.com/example/example-templates/src/controller/templates/state"
)

func main() {

	ctl := templates.InitCtl(&state.Ctx{}, controller.ControllerSettingsInput{})
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