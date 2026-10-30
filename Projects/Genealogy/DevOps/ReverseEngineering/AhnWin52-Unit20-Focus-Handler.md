# Unit20 lookup focus handler

The DFM and LFM both bind `dblookupcombobox1Click` to the lookup control's
`OnClick` event. The complete independent IDR listing at `005CC5A4` calls
`TCustomForm.SetActiveControl(Edit1)`. The current Pascal implementation
assigns `ActiveControl := Edit1`, preserving that control-focus effect.

Added a synthetic test that builds an unstreamed `TForm20` with a lookup
control and membership-number edit, makes the lookup active, invokes the
handler, and verifies that `Edit1` becomes active. It exercises no form
activation, provider, or database.

`TForm20.FormActivate` is a separate database/UI binding: its listing at
`005CC5B0` assigns the DataModule's `DataSource19` to the lookup's
`ListSource`. It remains unchanged and unexecuted; restoring it safely needs a
synthetic data-source contract and must not implicitly open a provider.

The focused Unit20 test passes 1/1, and the full FPCUnit suite passes
553/553.
