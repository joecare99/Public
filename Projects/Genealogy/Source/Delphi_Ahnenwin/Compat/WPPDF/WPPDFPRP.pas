unit WPPDFPRP;

{-------------------------------------------------------------------------------
  WPPDFPRP - WPPDFDelphi 5.0 properties dialog helper (compatibility stub).

  The original WPPDFDelphi 5.0 ships a non-visual helper component that
  carries the settings of the PDF export properties dialog
  (TWPPDFProperties). AHNENWIN 5.1 streams it into Unit13 and Unit16 as
  "WPPDFProperties1".

  The decompiled Source\Projects_AhnenWin\WPPDFPRP.pas is a 431 byte shell;
  the original library is not installed in this environment. This stub
  reproduces the component surface recovered from the decompilation:

    PDFPrinter      : the associated export component
    ShowStartButton : whether the dialog shows the start button
    ShowInputModes  : whether the dialog offers the input-file modes

  Dependency direction: WPPDFPRP references WPPDFR1, never the other way round.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, WPPDFR1;

type
  TWPPDFProperties = class(TComponent)
  private
    FPDFPrinter: TWPCustomPDFExport;
    FShowStartButton: Boolean;
    FShowInputModes: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { The AHNENWIN resources stream these properties on the helper
      component. }
    property PDFPrinter: TWPCustomPDFExport read FPDFPrinter write FPDFPrinter;
    property ShowStartButton: Boolean
      read FShowStartButton write FShowStartButton;
    property ShowInputModes: Boolean
      read FShowInputModes write FShowInputModes;
  end;

implementation

constructor TWPPDFProperties.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowStartButton := True;
  FShowInputModes := False;
end;

destructor TWPPDFProperties.Destroy;
begin
  inherited Destroy;
end;

end.
