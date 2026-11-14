# Unit6 calendar close-event parity

## Source evidence

`Projects_AhnenWin\Form6.dfm` and the current calendar LFM both bind the
form's `OnClose` event. The original `TForm6.FormClose` listing at
`005CE4C4` sets `WindowState` to `wsNormal` on the global Form6 instance.
The current `TGregorianCalendarForm.FormClose` instead assigns `ModalResult :=
0` (`mrNone`).

The original menu caller creates Form6, invokes its modal display through the
form VMT, ignores the returned modal result, and releases the form in its
finally path. The current menu controller likewise calls `ShowModal` and
disposes the form afterward without using the returned result. Therefore the
current handler's reset affects no caller decision; it leaves the modal
operation in a neutral result state. The original window-state reset applies
only to the closing form instance, which is then released.

## Decision and verification

Keep the current LCL close behavior rather than translating the transient
`WindowState := wsNormal` mutation. On the reconstructed modal route, neither
state is retained after the form is disposed, and no source evidence requires
a nonzero modal result. This is a documented lifecycle adaptation, not a
claim that the two handler bodies are identical.

Added a synthetic form test that seeds `mrOk`, invokes `FormClose`, and
verifies that `ModalResult` is reset to `mrNone`. It does not show the form,
run the main menu, or access application/database state.

The focused Gregorian-calendar print/lifecycle suite passes 3/3, and the
complete FPCUnit suite passes 552/552.
