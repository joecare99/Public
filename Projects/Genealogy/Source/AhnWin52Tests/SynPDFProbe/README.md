# SynPDF compiler/output probe

This standalone probe uses the provider-neutral report PDF contract and the
SynPDF writer with synthetic vector and text drawing commands. It creates a
two-page A4 PDF, one portrait and one landscape, with document metadata and
rendered canvas content. It does not access Ahnw50, LazReport, QuickReport,
application forms, or genealogy data.

Compile `SynPDFProbe.dpr` with DCC32 and the RAD Studio/VCL library path.
Include `Source\AhnWin52\Reports` and
`Source\AhnWin52\ThirdParty\SynPDF` in the unit search path. Define
`NO_USE_SYNZIP` and `NO_USE_PDFSECURITY` to keep optional upstream precompiled
object-code paths out of the probe. Bitmap support remains enabled because
SynPDF's EMF bitmap handlers reference it even when `NO_USE_BITMAP` is set.
The Lazarus/FPC backend uses the separately pinned mORMot2 PDF unit; see
`ThirdParty\mORMot2\NOTICE.md`. Run the Delphi probe with a temporary output
path, then verify the file using:

```powershell
python validate_pdf.py <temporary-output.pdf>
```

Keep compiler outputs and generated PDFs outside the working copy. SynPDF
source licensing and the LGPL redistribution gate are documented in the
third-party notice.
