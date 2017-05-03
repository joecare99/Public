unit frm_CompStrmMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, FileUtil,
{$ENDIF}
  SysUtils,  Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, StdCtrls;

type
  TMainForm = class(TForm)
    CreateButton: TButton;
    WriteButton: TButton;
    ReadButton: TButton;
    CloseBitBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure CreateButtonClick(Sender: TObject);
    procedure WriteButtonClick(Sender: TObject);
    procedure ReadButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FDataDir :String;
    procedure EnableButtons;
    procedure BOnClick1(Sender: TObject);
    procedure BOnClick2(Sender: TObject);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
const DirectorySeparator='\';
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  DataDefDir = 'Data';  { The stream's Directory }
  fileName = 'Test.stm';  { The stream's file name }

var
  B: TButton;  { Object to be streamed to and from disk }

{- OnClick event handler before writing Button to stream }
procedure TMainForm.BOnClick1(Sender: TObject);
begin
  ShowMessage('Thanks. I needed that!');
end;

{- OnClick event handler after reading Button from stream }
procedure TMainForm.BOnClick2(Sender: TObject);
begin
  ShowMessage('Hello. It''s nice to be back!');
end;

{- Enable and disable buttons depending on whether the Button
object and Test.Strm file exist }
procedure TMainForm.EnableButtons;
begin
  CreateButton.Enabled := False;  { Disable all buttons }
  WriteButton.Enabled := False;
  ReadButton.Enabled := False;
  if B <> nil then
    WriteButton.Enabled := True   { Allow write if B exists }
  else begin
    CreateButton.Enabled := True; { Allow create if B doesn't exist}
    if FileExists(FdataDir +DirectorySeparator+ fileName)  then
      ReadButton.Enabled := True  { Allow read if file exists }
  end;
end;

{- Initialize other buttons to control clicking order }
procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FDataDir:=DataDefDir;
  for i := 0 to 3 do
    if not DirectoryExists(FDataDir) then
      FDataDir:='..'+DirectorySeparator+FDataDir
    else
      break;
  EnableButtons;
end;

{- Create Button object entirely under program control }
procedure TMainForm.CreateButtonClick(Sender: TObject);
begin
  B := TButton.Create(Self);      { Create the Button object }
  B.Parent := Self;               { Assign parent object }
  B.Left := 240;                  { Assign left position }
  B.Top := 72;                    { Assign top position }
  B.Caption := 'Click me!';       { Assign label }
  B.OnClick := BOnClick1;         { Assign first event handler }
  EnableButtons;                  { Update operation order }
end;

{- Write Button object to file stream, and then destroy it }
procedure TMainForm.WriteButtonClick(Sender: TObject);
var
  Stream: TStream;
begin
{- Create a new disk file stream }
  Stream := TFileStream.Create(FdataDir +DirectorySeparator+fileName, fmCreate);
  try
    Stream.WriteComponent(B);      { Write Button object }
    B.Free;                        { Destroy Button object }
    B := nil;  { Prevent form's OnDestroy from Freeing again }
    EnableButtons;                 { Update operation order }
  finally
    Stream.Free;  { Destroy the file stream object }
  end;
end;

{- Read Button object from stream }
procedure TMainForm.ReadButtonClick(Sender: TObject);
var
  Stream: TStream;
begin
{- Create stream object in read-only mode }
  Stream := TFileStream.Create(FdataDir +DirectorySeparator+fileName, fmOpenRead);
  try
    B := TButton(Stream.ReadComponent(nil));  { Read & Create B }
    B.Parent := Self;              { Always assign parent! }
    B.OnClick := BOnClick2;        { Assign second event handler }
    EnableButtons;                 { Update operation order }
  finally
    Stream.Free;  { Destroy the file stream object }
  end;
end;

{- Destroy button if user closes app before completing test }
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if B <> nil then B.Free;
end;

{- Register the TButton class with Delphi stream system }
begin
  RegisterClass(TButton);
end.
