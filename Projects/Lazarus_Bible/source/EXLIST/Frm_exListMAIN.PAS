unit Frm_exListMAIN;

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
  SysUtils,  Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, StdCtrls;

type
  TMainForm = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
{ 1. Declare the OnException event handler }
    procedure NewOnException(Sender: TObject;
      E: Exception);
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

{ 2. Implement the OnException event handler }
procedure TMainForm.NewOnException(Sender: TObject;
  E: Exception);
begin
  Application.ShowException(E);
  ListBox1.Items.Add(E.Message);
end;

{ 3. Assign the event handler to Application.OnException }
procedure TMainForm.FormCreate(Sender: TObject);
begin
  Application.OnException := NewOnException;
end;

{ Raise a divide-by-zero exception }
procedure TMainForm.Button1Click(Sender: TObject);
var
  I, J, K: Integer;
begin
  I := 0;
  J := 10;
  try
    K := J div I;  { Divide by zero! }
    { The following statement doesn't execute, but it is
      needed so the optimizer in Object Pascal, which notices
      that K isn't used in this procedure, doesn't strip
      out the preceding statement. Smart compiler. }
    ShowMessage('K=' + IntToStr(K));
  except
    raise;
  end;
end;

{ Raise a file-not-found exception }
procedure TMainForm.Button2Click(Sender: TObject);
var
  T: TextFile;
begin
  AssignFile(T, 'XXXX.$$$');
  Reset(T);  { Open a non-existent file! }
  try
    { You would normally use T here }
  finally
    CloseFile(T);  { For safety's sake }
  end;
end;

{ Raise an index-out-of-bounds exception }
procedure TMainForm.Button3Click(Sender: TObject);
var
  I: Integer;
begin
  with ListBox1.Items do
  for I := 0 to Count do  { Should be Count - 1! }
    Strings[I] := Uppercase(Strings[I]);
end;

end.
