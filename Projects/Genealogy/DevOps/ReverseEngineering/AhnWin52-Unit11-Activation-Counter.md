# Unit11 activation counter reset

The independent IDR listing for `TForm11.FormActivate` (`005CB49C`) consists
of one state operation: set `GlobalVar_025368A8` to zero and return. The
current AhnWin52 name for the same global is `GlobalVar_025358A8`; the DFM and
LFM both bind the form's `OnActivate` event to this handler.

The current Pascal implementation already matches that complete listing.
Added a synthetic regression test that seeds the counter with a nonzero value,
invokes the event on an unstreamed form, verifies the reset, and restores the
process-global value during cleanup. It does not invoke painting, printer
metrics, report generation, or application startup.

The focused Unit11 metrics suite passes 6/6, and the full FPCUnit suite passes
551/551.

This confirms only the activation handler's global counter reset. The chart
drawing and print workflows remain separate and are not exercised by this
test.
