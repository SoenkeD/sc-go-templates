package guards_test

import (
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/guards"
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/state"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("CheckAlwaysTrue guard test", func() {

	var guard CheckAlwaysTrueGuard
	var state *ExtendedState

	BeforeEach(func() {
		state = &ExtendedState{}
	})

	It("Guard always true", func() {
		Expect(guard.Do(state)).To(BeTrue())
	})
})
