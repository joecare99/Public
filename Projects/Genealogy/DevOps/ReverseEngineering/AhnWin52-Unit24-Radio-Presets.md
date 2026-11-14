# Unit24 radio-button checkbox presets

## Evidence and ownership

The original `Projects_AhnenWin\Unit24.pas` listings for
`TForm24.RadioButton4Click` (`0055F528`) and
`TForm24.RadioButton5Click` (`0055F5E0`) contain only direct checkbox state
assignments. Independent component-offset evidence in `Projects_AhnenWin\Unit2.pas`
maps those fields to `TForm24.CheckBox1..CheckBox11`. Both the original DFM
and current Lazarus LFM bind the corresponding radio-button `OnClick`
handlers.

The current `OrtsfamilienbuchOptionsForm` implementation matches the complete
listing:

- `RadioButton4Click` sets `CheckBox1..CheckBox11.Checked` to `True`.
- `RadioButton5Click` sets the same eleven checkboxes to `False`.
- Neither handler assigns the other streamed checkboxes such as
  `CheckBox14`, `CheckBox16`, `CheckBox17`, or `CheckBox18`.

## Synthetic regression tests

Added `tst_AHW52_Unit24RadioPresetTests.pas` with in-memory `CreateNew` form
fixtures. The tests invoke the handlers directly and verify every one of the
eleven target fields, then check that unrelated checkboxes are left unchanged.
They do not stream or show the original form, call `listanz`, open a dataset,
or activate the database/report routes.

The focused suite passes 3/3. The FPCUnit project builds, and the full suite
passes 586/586 after this addition.

## CheckBox17/CheckBox18 linked-state handlers

The complete retained listings for `TForm24.CheckBox17Click` (`0055F7BC`)
and `CheckBox18Click` (`0055F7E4`) and the DFM/LFM event bindings show the
same guard in both methods: when `CheckBox17.Checked` is false, assign
`CheckBox18.Checked := False`; when it is true, preserve CheckBox18's current
state. Neither handler writes any unrelated checkbox.

Added branch tests to `tst_AHW52_Unit24RadioPresetTests.pas` for both handlers.
They cover checked and unchecked CheckBox17 states plus unrelated control
state, using in-memory controls without showing a form or touching a provider.
The focused Unit24 suite now passes 5/5; the full FPCUnit suite passes
588/588.

## Next boundary

These are test-only checks of already reconstructed, provider-free handlers;
they do not change behavior. The other Unit24 event routes include
provider-backed list refresh, user confirmation, parameter dispatch, and
report/database work. Keep those paths separate until their complete caller,
state, and provider contracts are established.
