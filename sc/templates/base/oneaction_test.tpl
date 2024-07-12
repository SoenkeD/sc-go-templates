var _ = Describe("{{ .Name }} action test", func() {

	var action {{ .Name }}Action
	var ctx *Ctx
	var state *ExtendedState

	BeforeEach(func() {
		ctx = &Ctx{}
		state = &ExtendedState{}
	})

	It("Successfully execute action", func() {
		Expect(action.Do(ctx, state)).To(Succeed())
	})

	It("Forward error", func() {
		Expect(action.Do(ctx, state)).ToNot(Succeed())
	})
})