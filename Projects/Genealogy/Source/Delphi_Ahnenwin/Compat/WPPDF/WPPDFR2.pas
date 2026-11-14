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

  The page/canvas machinery recovered from the IDR decompilation of the
  AHNENWIN units (Unit13.SpeedButton3Click and its nested procs
  sub_00573314/sub_0057316C, Unit16.SpeedButton4Click) uses the following
  WPPDF printer entry points, which are stubbed here under recovered/
  semantic names (original addresses in comments):

    GetCanvas          (005373F4) - page canvas factory
    StartPage          (vmt+4C, called 005731B9 with 5 params)
    EndDoc / FinishDoc (vmt+48=00538C98, vmt+54=00538D00)

  Dependency direction: WPPDFR2 references WPPDFR1, never the other way round.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Graphics, Classes, WPPDFR1;

type
  TWPPDFPrinter = class(TWPCustomPDFExport)
  private
    FCanvasBitmap: TBitmap;
    function GetCanvas: TCanvas;
  public
    { 005731C4-5731CF (Unit13.WritePage), 005373F4: liefert die Zeichen-
      oberflaeche der laufenden PDF-Seite; Kompatibilitaet: TBitmap. }
    property Canvas: TCanvas read GetCanvas;
    { 0057319D-5731E2 / [vmt+4C]: neue Seite (Inhaltshoehe, Seitenhoehe
      und drei vom Aufrufer gepushte Setups) beginnen. }
    procedure StartPage(AContentHeight, APageHeight: Integer;
      AStack3, AStack4, AStack5: Integer);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

constructor TWPPDFPrinter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvasBitmap := TBitmap.Create;
end;

destructor TWPPDFPrinter.Destroy;
begin
  FCanvasBitmap.Free;
  inherited Destroy;
end;

function TWPPDFPrinter.GetCanvas: TCanvas;
begin
  Result := FCanvasBitmap.Canvas;
end;

procedure TWPPDFPrinter.StartPage(AContentHeight, APageHeight: Integer;
  AStack3, AStack4, AStack5: Integer);
begin
  { Kompatibilitaet: im Original werden hier PDF-Seitengroesse und
    Renderingmasstab ([vmt+4C] Aufruf in Unit13.WritePage 00573199)
    gesetzt; die Shell-Klasse rendert nicht. }
end;

end.
