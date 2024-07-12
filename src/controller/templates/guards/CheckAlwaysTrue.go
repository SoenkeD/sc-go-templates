package guards

import (
	. "github.com/SoenkeD/sc-go-templates/src/controller/templates/state"
)

const CheckAlwaysTrueGuardKey = "CheckAlwaysTrueGuard"

func init() {
	AllGuards[CheckAlwaysTrueGuardKey] = CheckAlwaysTrueGuard{}
}

type CheckAlwaysTrueGuard struct{}

func (action CheckAlwaysTrueGuard) Do(state *ExtendedState, args ...string) bool {
	return true
}
