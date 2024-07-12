package controller

import (
	"time"
)

type Reconciler struct {
	ctl                     *Ctl
	defaultBetweenReconcile time.Duration
	panicHandler            PanicHandler
	errorHandler            ErrorHandler
	afterReconcileHandler   AfterReconcileHandler
}

func InitReconciler(ctl *Ctl, input ReconcilerInput) *Reconciler {

	var defaultBetweenReconcile time.Duration
	if input.DefaultBetweenReconcile > 0 {
		defaultBetweenReconcile = input.DefaultBetweenReconcile
	} else {
		defaultBetweenReconcile = 2 * time.Second
	}

	var panicHandler PanicHandler
	if input.PanicHandler != nil {
		panicHandler = input.PanicHandler
	} else {
		panicHandler = &DefaultPanicHandler{}
	}

	var errorHandler ErrorHandler
	if input.ErrorHandler != nil {
		errorHandler = input.ErrorHandler
	} else {
		errorHandler = &DefaultErrorHandler{}
	}

	var afterReconcileHandler AfterReconcileHandler
	if input.AfterReconcileHandler != nil {
		afterReconcileHandler = input.AfterReconcileHandler
	} else {
		afterReconcileHandler = &DefaultAfterReconcileHandler{}
	}

	return &Reconciler{
		ctl:                     ctl,
		defaultBetweenReconcile: defaultBetweenReconcile,
		panicHandler:            panicHandler,
		errorHandler:            errorHandler,
		afterReconcileHandler:   afterReconcileHandler,
	}
}

func (reconciler *Reconciler) Reconcile() (err *CtlErr) {

	for {
		var res CtlRes
		res, err = reconciler.ctl.Run()
		if err != nil {

			if err.PanicErr != nil {
				next := reconciler.panicHandler.React(*err.PanicErr)
				if !next {
					return
				}
			}

			if err.StateErr != nil {
				next := reconciler.errorHandler.React(*err)
				if !next {
					return
				}
			}
		}

		if err == nil {
			nextReconcile := reconciler.afterReconcileHandler.React(res)
			if !nextReconcile {
				return
			}
		}

		time.Sleep(reconciler.defaultBetweenReconcile)
	}
}
