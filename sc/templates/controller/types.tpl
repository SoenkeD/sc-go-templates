package controller

import (
	"log"
	"strings"
	"time"

	. "{{ .ImportRoot }}/state"
)

type Action interface {
	Do(ctx *Ctx, state *ExtendedState, args ...string) error
}

type Guard interface {
	Do(state *ExtendedState, args ...string) bool
}

type State struct {
	Actions     []StateAction
	Transitions []Transition
}

type TransitionType string

const (
	TransitionTypeNormal TransitionType = "normal"
	TransitionTypeError  TransitionType = "error"
	TransitionTypeHappy  TransitionType = "happy"
)

const (
	KeyStartState = "StartState"
	KeyEndState   = "EndState"
)

type Transition struct {
	Guard      string
	GuardArgs  []string
	Action     string
	ActionArgs []string
	Next       string
	Negation   bool
	Type       TransitionType
}

func (tr *Transition) GetId() string {

	negationStr := "false"
	if tr.Negation {
		negationStr = "true"
	}

	return strings.Join(
		[]string{
			strings.TrimSuffix(tr.Action, "Action"),
			strings.Join(tr.ActionArgs, ","),
			strings.TrimSuffix(tr.Guard, "Guard"),
			strings.Join(tr.GuardArgs, ","),
			string(tr.Type),
			strings.ReplaceAll(strings.TrimSuffix(tr.Next, "State"), "/", "\\"),
			negationStr,
		},
		"/",
	)
}

type StateAction struct {
	Action     string
	ActionArgs []string
}

type PanicErr struct {
	Err        string
	Route      []string
	StackTrace []string
}

type StateErr struct {
	State     string
	ActionErr ActionErr
}

type ActionErr struct {
	Err    error
	Action string
}

type CtlErr struct {
	StateErr *StateErr
	PanicErr *PanicErr
	Route    []string
}

type CtlRes struct {
	Route []string
}

type ReconcilerInput struct {
	DefaultBetweenReconcile time.Duration
	PanicHandler            PanicHandler
	ErrorHandler            ErrorHandler
	AfterReconcileHandler   AfterReconcileHandler
}

type PanicHandler interface {
	React(err PanicErr) (next bool)
}

type DefaultPanicHandler struct{}

func (rec *DefaultPanicHandler) React(err PanicErr) (next bool) {
	next = true
	return
}

type ErrorHandler interface {
	React(err CtlErr) (next bool)
}

type DefaultErrorHandler struct{}

func (rec *DefaultErrorHandler) React(err CtlErr) (next bool) {
	log.Println("INFO: An error occured\n", err)
	next = true
	return
}

type AfterReconcileHandler interface {
	React(res CtlRes) (next bool)
}

type DefaultAfterReconcileHandler struct{}

func (rec *DefaultAfterReconcileHandler) React(res CtlRes) (next bool) {
	next = true
	return
}

type AfterActionHandler interface {
	React(state ExtendedState) (next bool)
}

type DefaultAfterActionHandler struct{}

func (rec *DefaultAfterActionHandler) React(state ExtendedState) (next bool) {
	next = true
	return
}

type AfterStateHandler interface {
	React(state ExtendedState) (next bool)
}

type DefaultAfterStateHandler struct{}

func (rec *DefaultAfterStateHandler) React(state ExtendedState) (next bool) {
	next = true
	return
}

type ControllerSettingsInput struct {
	AfterAction AfterActionHandler
	AfterState  AfterStateHandler
}

type ControllerSettings struct {
	AfterAction AfterActionHandler
	AfterState  AfterActionHandler
}

func ControllerSettingsFromInput(input ControllerSettingsInput) (set ControllerSettings) {

	if input.AfterAction != nil {
		set.AfterAction = input.AfterAction
	} else {
		set.AfterAction = &DefaultAfterActionHandler{}
	}

	if input.AfterState != nil {
		set.AfterState = input.AfterState
	} else {
		set.AfterState = &DefaultAfterStateHandler{}
	}

	return
}
