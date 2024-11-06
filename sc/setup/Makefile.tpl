CTL_DIR=src/controller
CONTAINER_ENGINE=docker

#############################
#############################
### Exec 
#############################
#############################

.PHONY: test
test: vet fmt
	~/go/bin/ginkgo -r

.PHONY: run
run: vet fmt
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

.PHONY: force-generated
force-generated:
	$(eval SC_OPT=$(SC_OPT) --force-generated)

.PHONY: clear
clear:
	$(eval SC_OPT=$(SC_OPT) --clear)

.PHONY: sc-gen
sc-gen:
	$(foreach dir,$(wildcard $(CTL_DIR)/*), \
		$(if $(wildcard $(dir)/*), $(sc) gen --root $(PWD) --name $(notdir $(dir)) $(SC_OPT);))

.PHONY: sc
sc: plantuml-gen sc-gen fmt

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
	@if [ ! $$($(CONTAINER_ENGINE) ps -q -f name=$(PLANTUML_CONTAINER_NAME)) ]; then \
		$(CONTAINER_ENGINE) run --rm -d --name $(PLANTUML_CONTAINER_NAME) \
			-p $(PLANTUML_PORT):8080 \
			docker.io/plantuml/plantuml-server && sleep 2; \
	fi

.PHONY: plantuml-stop
plantuml-stop:
	$(CONTAINER_ENGINE) stop $(PLANTUML_CONTAINER_NAME)

.PHONY: plantuml-one
plantuml-one: plantuml-start
	curl -X POST \
		-H "Content-Type: text/plain" \
		--data-binary "@$(puml)" \
		http://localhost:$(PLANTUML_PORT)/svg \
		> $(output)
