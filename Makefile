sc=~/go/bin/sc

.PHONY: sc
sc:
	$(sc) gen --root $(PWD) --name templates

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
	~/go/bin/ginkgo -r -cover -coverprofile=coverage.out

.PHONY: run
run:
	go run src/main.go