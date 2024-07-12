const {{ .Name }}ActionKey = "{{ .Name }}Action"

func init() {
	AllActions[{{ .Name }}ActionKey] = {{ .Name }}Action{}
}

type {{ .Name }}Action struct{}
	
func (action {{ .Name }}Action) Do(ctx *Ctx, state *ExtendedState, args ...string) error {
	// TODO: implement action {{ .Name }}
	return nil
}