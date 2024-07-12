package {{ .Name }}

import (
	. "{{ .ImportRoot }}/actions"
	. "{{ .ImportRoot }}/controller"
	. "{{ .ImportRoot }}/guards"
)

{{- range $idx, $state := .States }}

{{ $state }}

{{- end }}