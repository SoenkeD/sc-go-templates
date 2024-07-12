var _ = Describe("{{ .Name }} guard test", func() {

	var guard {{ .Name }}Guard
	var state *ExtendedState

	BeforeEach(func() {
		state = &ExtendedState{}
	})

	It("Guard deny", func() {
		Expect(guard.Do(state)).To(BeFalse())
	})
})