unit Frm_EnumFonMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type

  { TfrmEnumFontsMain }

  TfrmEnumFontsMain = class(TForm)
    lblTextText: TLabel;
    lbxFonts: TListBox;
    lblFontNames: TLabel;
    btnClose: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure lbxFontsSelectionChange(Sender: TObject; User: boolean);
    procedure lbxFontsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEnumFontsMain: TfrmEnumFontsMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ ======================================================= }

{$IFDEF VER80}  // Delphi 1.x, 16-bit Windows only

function EnumFontsProc(var LogFont: TLogFont;
  var TextMetric: TTextMetric; FontType: Integer;
  Data: TListBox): Integer; export;
begin
  with TStrings(Data) do
    Add(StrPas(LogFont.lfFaceName));
  Result := 1;  { Continue enumeration until done }
end;

procedure TfrmEnumFontsMain.FormCreate(Sender: TObject);
var
  Proc: TFarProc;
begin
  Proc := MakeProcInstance(@EnumFontsProc, HInstance);
  try
    EnumFonts(Canvas.Handle, nil,Proc,Pointer(lbxFonts.Items));
  finally
    FreeProcInstance(Proc);
  end;
end;

{ ======================================================= }

{$ELSE}  // Delphi 2 and higher, 32-bit Windows 95, 98, and NT

{function EnumFontsProc(var LogFont: TLogFont;
  var TextMetric: TTextMetric; FontType: Integer;
  Data: Pointer): Integer; stdcall;
var
  TheList: TStrings;
begin
  TheList := TStrings(Data);  // Get StringList passed in Data
  TheList.Add(LogFont.lfFaceName);  // Add font's name
  Result := 1;                // Continue until done
end;
}
procedure TfrmEnumFontsMain.FormCreate(Sender: TObject);
begin
{  DC := GetDC(0);  // Get a device context handle
  try
    EnumFonts(DC, nil, @EnumFontsProc,
      Pointer(lbxFonts.Items));  // Pass data to callback fn
  finally
    ReleaseDC(0, DC);  // Release system resource
  end;  }
  { The next procedure is *far* simpler than either of
    the preceding methods, and it also works with all versions
    of Delphi and Windows! Remember: Don't work harder than
    you have to; rather than call Windows subroutines and use
    callback functions, look for a Delphi component that
    does what you want. You'll probably find one! }

  lbxFonts.Items := Screen.Fonts;
end;
{$ENDIF}

procedure TfrmEnumFontsMain.lbxFontsClick(Sender: TObject);
begin
  lblTextText.font.Name:=lbxFonts.Items[lbxFonts.ItemIndex];
end;

procedure TfrmEnumFontsMain.lbxFontsSelectionChange(Sender: TObject;
  User: boolean);
begin
  lblTextText.font.Name:=lbxFonts.Items[lbxFonts.ItemIndex];
end;

end.

