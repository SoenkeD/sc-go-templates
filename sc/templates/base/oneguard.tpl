const {{ .Name }}GuardKey = "{{ .Name }}Guard"

func init() {
	AllGuards[{{ .Name }}GuardKey] = {{ .Name }}Guard{}
}

type {{ .Name }}Guard struct{}

func (action {{ .Name }}Guard) Do(state *ExtendedState, args ...string) bool {
	// TODO: implement guard {{ .Name }}
	return false
}