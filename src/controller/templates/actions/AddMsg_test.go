package actions_test

import (
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/actions"
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/state"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("AddMsg action test", func() {

	var action AddMsgAction
	var ctx *Ctx
	var state *ExtendedState

	BeforeEach(func() {
		ctx = &Ctx{}
		state = &ExtendedState{}
	})

	It("Add the first message", func() {
		Expect(action.Do(ctx, state, "msg")).To(Succeed())
		Expect(state.Msg).To(Equal("msg"))
	})

	It("Add the first message", func() {
		state.Msg = "msg1"
		Expect(action.Do(ctx, state, "msg")).To(Succeed())
		Expect(state.Msg).To(Equal("msg1 msg"))
	})
})
