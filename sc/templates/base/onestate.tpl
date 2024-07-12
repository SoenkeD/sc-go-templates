const {{ .Name }}StateKey = "{{ .Name }}State"

func init() {
	AllStates[{{ .Name }}StateKey] = State{
		Actions: []StateAction{
			{{- range $idx, $action := $.State.Actions }}
			{
				Action: {{ $action.Action }}ActionKey,
				ActionArgs: []string{ 
				{{- range $argIdx, $arg := $action.ActionParams }}
					"{{ $arg }}",
				{{- end }}
				},

			},
			{{- end }}
		},
		Transitions: []Transition{
			{{- range $idx, $transition := $.State.Transitions }}
			{
				Type: {{- trans $transition.Type }}, 
				Next: {{- replaceAll $transition.Target "/" "" }}StateKey,
				{{- if $transition.Action }}
				Action: {{ $transition.Action }}ActionKey,
				{{- end }}
				{{- if $transition.ActionParams }}
				ActionArgs: []string{ 
				{{- range $argIdx, $arg := $transition.ActionParams }}
					"{{ $arg }}",
				{{- end }}
				},
				{{- end }} 
				{{- if $transition.Guard }}
				Guard: {{ $transition.Guard }}GuardKey,
				{{- end }}
				{{- if $transition.GuardParams }}
				GuardArgs: []string{ 
				{{- range $argIdx, $arg := $transition.GuardParams }}
					"{{ $arg }}",
				{{- end }}
				},
				{{- end }}
				Negation: {{ $transition.Negation }},
			},
			{{- end }}
		},
	}
}