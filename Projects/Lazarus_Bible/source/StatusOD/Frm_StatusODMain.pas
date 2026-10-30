unit Frm_StatusODMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
 Messages,
 SysUtils,
 Classes,
 Graphics,
 Controls,

  Forms,
 Dialogs,
 ComCtrls,
 ImgList,
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf,
  LCLType,
  LMessages
{$ENDIF};

type
  TfrmStatusODMain = class(TForm)
    StatusBar1: TStatusBar;
    ImageList1: TImageList;
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStatusODMain: TfrmStatusODMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}
procedure TfrmStatusODMain.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  SavedStyles: TFontStyles;
begin
  with StatusBar, Canvas do
  begin
    SavedStyles := Font.Style;  // Save current font styles
    // Set font style or draw an icon depending
    // on which Panel needs updating.
    case Panel.Index of
      0 : Font.Style := [fsBold];
      1 : Font.Style := [fsItalic];
      2 : ImageList1.Draw(Canvas,
            Rect.Left + 2, Rect.Top + 2, 0);
      3 : Font.Style := [fsBold, fsItalic];
    end;
    // Draw text in all panels except the third,
    // which displays an icon.
    if Panel.Index <> 2 then
      TextRect(Rect, Rect.Left, Rect.Top, Panel.Text);
    Font.Style := SavedStyles;  // Restore saved font styles
  end;
end;

end.
