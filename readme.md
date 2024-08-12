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

1. Navigate to the directory where the project should be created in
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
`--container` can be used to enable podman (defaults to docker) 

3. Navigate into the project
4. Modify the `Print` action to print the first argument
5. Run `make run` to see the first running state machine

## Getting started
To get started [read the guide](docs/getting_started.md) which
goes through the features and intended usage of this tool
on an example.