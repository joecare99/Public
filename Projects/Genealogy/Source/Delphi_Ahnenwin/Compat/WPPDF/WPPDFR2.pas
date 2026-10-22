unit WPPDFR2;

{-------------------------------------------------------------------------------
  WPPDFR2 - WPPDFDelphi 5.0 printer component (compatibility stub).

  In the original WPPDFDelphi 5.0, WPPDFR2 declares the concrete PDF
  *printer* component TWPPDFPrinter that descends from the abstract export
  component of WPPDFR1. The decompiled Source\Projects_AhnenWin\WPPDFR2.pas
  is only a 306 byte shell (the class body was not recovered), and the
  library itself is not installed in this environment.

  This stub therefore declares TWPPDFPrinter as a descendant of
  TWPCustomPDFExport, which is exactly the relationship that the decompiled
  WPPDFR2 shows, and which the AHNENWIN units rely on.

  Dependency direction: WPPDFR2 references WPPDFR1, never the other way round.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, WPPDFR1;

type
  TWPPDFPrinter = class(TWPCustomPDFExport)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TWPPDFPrinter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
