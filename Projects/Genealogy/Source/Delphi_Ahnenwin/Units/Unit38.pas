unit Unit38;

{-------------------------------------------------------------------------------
  Unit38 - TForm38, the FOKO abbreviation list of AHNENWIN 5.1.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit38.pas and the original resource
  Source\Projects_AhnenWin\Form38.dfm.

  When the dialog is shown, the file "foko.abk" next to the program is
  read and shown in the memo.

  Method addresses (original binary):
    0053A054  FormShow
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, StdCtrls, Forms, Controls;

type
  TForm38 = class(TForm)
  published
    Memo1: TMemo; //2F0
    procedure FormShow(Sender: TObject); //0053A054
  end;

var
  Form38: TForm38;

implementation

{$R ..\Forms\Form38.DFM}

// 0053A054
procedure TForm38.FormShow(Sender: TObject);
var
  F: TextFile;
  Line, Dir, FileName: string;
begin
  { The listing builds the name of the abbreviation file from the path of
    the program: ExtractFilePath(ParamStr(0)) + 'foko.abk'. }
  Line := ParamStr(0);
  Dir := ExtractFilePath(Line);
  FileName := Dir + 'foko.abk';

  AssignFile(F, FileName);
  Reset(F);

  { The memo is cleared and then filled line by line. The listing checks
    Eof twice: once as the condition of the loop and once inside the loop
    body, so that a last line without a terminating line break is not
    added. }
  Memo1.Clear;
  while not Eof(F) do
  begin
    ReadLn(F, Line);
    if Eof(F) then
      Break;
    Memo1.Lines.Add(Line);
  end;

  CloseFile(F);
end;

end.
