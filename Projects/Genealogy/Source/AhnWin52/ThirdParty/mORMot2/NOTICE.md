# mORMot2 PDF third-party notice

This directory contains the minimal source subset required by
`mormot.ui.pdf` from [synopse/mORMot2](https://github.com/synopse/mORMot2),
pinned to commit `1f37f3a44bef4f9c2f935b9d3a11855b50a7fe86`.

The subset was selected for the Windows Lazarus/FPC PDF backend. It contains
the PDF, UI, graphics, core, compression, and include units required to build
the provider, plus the upstream `LICENCE.md`. All included Pascal source files
retain their upstream copyright and licensing headers. The framework offers a
disjunctive MPL 1.1/GPL 2.0/LGPL 2.1 license; this integration selects the LGPL
2.1 option, including the FPC modified-LGPL linking exception described in
`LICENCE.md`. The LGPL 2.1 text is included in the sibling
`..\SynPDF\Licenses\LGPL-2.1.txt`.

The SynPDF README explicitly recommends `mormot.ui.pdf` for long-term/FPC
compatibility. The report contract therefore uses the original SynPDF source
for Delphi and this maintained successor unit for FPC/Lazarus. Both providers
consume the same prepared report pages and write through the same atomic file
publisher; neither uses Ahnw50 or its licensing path.

The validated FPC profile defines `NO_USE_PDFSECURITY`, `NO_USE_UNISCRIBE`,
`ZLIBPAS`, and `NOLIBDEFLATESTATIC`. PDF encryption and Uniscribe shaping are
not enabled; Pascal zlib is used instead of upstream precompiled object files.
The Windows GDI+ drawing path remains enabled. No precompiled objects are
included.

Keep this notice, `LICENCE.md`, all upstream source headers, and the LGPL text
with any redistribution. Before distributing a linked executable, review the
selected LGPL terms and applicable linking exception, source/notice delivery,
modification rights, and the recipient's ability to replace or relink the
library. The synthetic probe does not constitute distribution approval.

Upstream source:
<https://github.com/synopse/mORMot2/tree/1f37f3a44bef4f9c2f935b9d3a11855b50a7fe86/src/ui/mormot.ui.pdf.pas>
