# SynPDF third-party notice

This directory contains the SynPDF source subset from
[synopse/SynPDF](https://github.com/synopse/SynPDF), pinned to upstream commit
`15749968e294f5e86fe1a36b117827ee9fdd648a` (2025-11-13).

The included source files retain their upstream copyright, contributor, and
license headers. The selected license option for this integration is GNU LGPL
version 2.1 or later; the complete LGPL 2.1 text is in `Licenses\LGPL-2.1.txt`.
The upstream headers also offer MPL 1.1 and GPL 2.0-or-later alternatives.

The vendored subset contains the PDF unit and its source/include dependencies:
`SynPdf.pas`, `SynCommons.pas`, `SynCrypto.pas`, `SynGdiPlus.pas`, `SynLZ.pas`,
`SynZip.pas`, `SynFPCTypInfo.pas`, `SynDoubleToText.inc`, `Synopse.inc`, and
`SynopseCommit.inc`, plus `SynCrypto.pas` and `SynTable.pas` for the optional
security feature. `README.md` is the upstream README at the same revision.
Unrelated upstream report units and precompiled object files are not included.

The validated Delphi compiler profile defines `NO_USE_SYNZIP` and
`NO_USE_PDFSECURITY`; it does not enable PDF encryption or the optimized ZIP
path. Bitmap support remains enabled because SynPDF's EMF bitmap handlers
reference it even when `NO_USE_BITMAP` is set. The upstream default optimized
ZIP/security paths reference precompiled object files; those optional paths
have not been vendored or validated and must not be enabled using this source
subset. For the FPC/Lazarus build, the SynPDF README recommends the newer
`mormot.ui.pdf` unit; its separately pinned LGPL-compatible source subset is
documented in `ThirdParty\mORMot2\NOTICE.md`.

No upstream source file has been modified. Keep this notice, the original
source headers, and the license text with any redistribution of these files.
Before distributing an executable linked with SynPDF, review LGPL 2.1 section
6 requirements, including notices, license delivery, modification/reverse
engineering permissions, and an applicable way for recipients to replace or
relink the library. The current compiler probe is not a distribution approval.

Upstream source: <https://github.com/synopse/SynPDF/tree/15749968e294f5e86fe1a36b117827ee9fdd648a>
License source: <https://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt>
