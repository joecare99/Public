# Unit20 cancel handler

The DFM and LFM both bind `BitBtn2Click` to the `Abbruch` button. The complete
IDR listing at `005CC5CC` writes modal result value `2` to the global
`TForm20` instance, rather than to the method receiver. The current Pascal
body likewise assigns `Form20.ModalResult := mrCancel`.

Added synthetic coverage with separate global-target and event-receiver
forms. The test verifies that the global form receives `mrCancel` while a
distinct receiver remains at `mrNone`; it restores the global variable and
does not show either form.

This intentionally preserves the legacy global-target behavior rather than
silently changing it to `Self`. `BitBtn1Click` remains excluded: its complete
listing includes dataset opening, `EmptyTable`, indexed traversal, and
provider-dependent work.

The focused Unit20 suite passes 2/2, and the full FPCUnit suite passes
554/554.
