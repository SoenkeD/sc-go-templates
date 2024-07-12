package actions_test

import (
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/actions"
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/state"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("Print action test", func() {

	var action PrintAction
	var ctx *Ctx
	var state *ExtendedState

	BeforeEach(func() {
		ctx = &Ctx{}
		state = &ExtendedState{}
	})

	It("Successfully execute action", func() {
		Expect(action.Do(ctx, state, "msg")).To(Succeed())
	})
})
