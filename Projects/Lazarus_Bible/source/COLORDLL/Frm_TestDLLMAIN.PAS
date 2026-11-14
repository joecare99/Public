unit Frm_TestDLLMAIN;

{ Testdll, plattformneutral: laedt die Shared Library Colorlib zur Laufzeit
  (FPC: DynLibs = dlopen/LoadLibrary) und ruft FBGetColors auf, das den
  Farbdialog zeigt. Unter Delphi bleibt der statische DLL-Aufruf. }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, DynLibs,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
{$IFDEF FPC}
  { Signatur der aus der Shared Library exportierten Funktion. }
  TFBGetColorsProc = function(var FColor, BColor: LongWord): LongBool; cdecl;
{$ENDIF}

  TMainForm = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{$IFnDEF FPC}
{- Declare external function in the Colorlib.Dll }
function FBGetColors(var FColor, BColor: TColor): LongBool; cdecl;
  external 'Colorlib.dll';
{$ENDIF}

{$IFDEF FPC}
{ Moegliche Namen der Shared Library je nach Plattform und Toolchain. }
const
  ColorLibCandidates: array[0..3] of string =
    ('Colorlib.so', 'Colorlib.dll', 'Colorlib', 'Colorlib.exe');

{- Laedt die Shared Library aus dem Programmverzeichnis. }
function LoadColorLib(out ALibName: string): TLibHandle;
var
  Dir: string;
  I: Integer;
  Candidate: string;
begin
  Result := NilHandle;
  ALibName := '';
  Dir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  for I := Low(ColorLibCandidates) to High(ColorLibCandidates) do
  begin
    Candidate := Dir + ColorLibCandidates[I];
    if not FileExists(Candidate) then
      Continue;
    Result := LoadLibrary(Candidate);
    if Result <> NilHandle then
    begin
      ALibName := Candidate;
      Exit;
    end;
  end;
end;
{$ENDIF}

{- Activate color dialog in the Colorlib library. }
procedure TMainForm.Button1Click(Sender: TObject);
var
  FColor, BColor: LongWord;
{$IFDEF FPC}
  Lib: TLibHandle;
  FBGetColors: TFBGetColorsProc;
  LibName: string;
{$ENDIF}
begin
  FColor := LongWord(Font.Color);    { Form's text color }
  BColor := LongWord(Color);         { Window background color }
{$IFDEF FPC}
  { Shared Library aus dem Programmverzeichnis laden. }
  Lib := LoadColorLib(LibName);
  if Lib = NilHandle then
  begin
    ShowMessage('Konnte die Shared Library Colorlib nicht laden.');
    Exit;
  end;
  try
    FBGetColors := TFBGetColorsProc(GetProcedureAddress(Lib, 'FBGetColors'));
    if not Assigned(FBGetColors) then
    begin
      ShowMessage('FBGetColors nicht gefunden in ' + LibName + '.');
      Exit;
    end;
    if FBGetColors(FColor, BColor) then  { Call the library ! }
    begin
      Memo1.Color := TColor(BColor);       { Assign window color }
      Memo1.Font.Color := TColor(FColor);  { Assign text color }
    end;
  finally
    UnloadLibrary(Lib);
  end;
{$ELSE}
  if FBGetColors(FColor, BColor) then  { Call DLL ! }
  begin
    Memo1.Color := TColor(BColor);       { Assign window color }
    Memo1.Font.Color := TColor(FColor);  { Assign text color }
  end;
{$ENDIF}
end;

end.
