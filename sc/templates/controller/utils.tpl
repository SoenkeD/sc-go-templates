package controller

import (
	"fmt"
	"runtime"
	"strings"
)

// getStackTrace returns the stacktrace starting from the given skip level count
// +1 for this function is added automatically
func getStackTrace(skippLvl int) (stacktrace []string) {
	for idx := 0; idx < 5; idx++ {
		stacktrace = append(stacktrace, GetCaller(skippLvl+1+idx))
	}
	return
}

func GetCaller(skipCallLvl int) string {
	fpcs := make([]uintptr, 15)
	callerCount := runtime.Callers(skipCallLvl, fpcs) // skip call levels until caller
	if callerCount == 0 {
		return "NOCALLER"
	}

	caller := runtime.FuncForPC(fpcs[0] - 1)
	if caller == nil {
		return "NILCALLER"
	}

	// prepare for output
	filePath, line := caller.FileLine(fpcs[0] - 1)
	fileParts := strings.Split(filePath, "/")
	file := fileParts[len(fileParts)-1]
	return fmt.Sprintf("%s:%d:", file, line)
}
