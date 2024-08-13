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
	go run main.go

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
		$(if $(wildcard $(dir)/*), sc gen --root $(PWD) --name $(notdir $(dir));))

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
$(CTL_DIR)/%.svg: $(CTL_DIR)/%.plantuml
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