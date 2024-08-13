package {{ .Name }}

import (
	{{- if .HasActions }}
	. "{{ .ImportRoot }}/actions"
	{{- end }}
	. "{{ .ImportRoot }}/controller"
	{{- if .HasGuards }}
	. "{{ .ImportRoot }}/guards"
	{{- end }}
)

{{- range $idx, $state := .States }}

{{ $state }}

{{- end }}