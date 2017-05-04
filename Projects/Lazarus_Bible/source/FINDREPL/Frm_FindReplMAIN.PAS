unit Frm_FindReplMAIN;

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
  TMainForm = class(TForm)
    ListBox1: TListBox;
    FindDialog: TFindDialog;
    FindBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    ReplaceBitBtn: TBitBtn;
    ReplaceDialog: TReplaceDialog;
    procedure FindBitBtnClick(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure ReplaceBitBtnClick(Sender: TObject);
    procedure ReplaceDialogFind(Sender: TObject);
    procedure ReplaceDialogReplace(Sender: TObject);
  private
    FindIndex, FoundPos, FoundLen: Integer;
    FoundItem: Boolean;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{- Begin a FindDialog operation }
procedure TMainForm.FindBitBtnClick(Sender: TObject);
begin
  FindDialog.Execute;
  FindIndex := 0;
  ListBox1.ItemIndex := -1;
end;

{- Continue a FindDialog operation }
procedure TMainForm.FindDialogFind(Sender: TObject);
var
  S: String;
begin
  while FindIndex < ListBox1.Items.Count do
  begin
    S := ListBox1.Items[FindIndex];
    Inc(FindIndex);
    if Pos(FindDialog.FindText, S) <> 0 then
    begin
      ListBox1.ItemIndex := FindIndex - 1;
      Exit;
    end;
  end;
  ShowMessage('No more matches!');
  FindDialog.CloseDialog;
end;

{- Start a ReplaceDialog operation }
procedure TMainForm.ReplaceBitBtnClick(Sender: TObject);
begin
  ReplaceDialog.Execute;
  FindIndex := 0;
  ListBox1.ItemIndex := -1;
  FoundItem := False;
end;

{- Continue a ReplaceDialog operation }
procedure TMainForm.ReplaceDialogFind(Sender: TObject);
var
  S: String;
begin
  while FindIndex < ListBox1.Items.Count do
  begin
    S := ListBox1.Items[FindIndex];
    Inc(FindIndex);
    FoundPos := Pos(ReplaceDialog.FindText, S);
    if FoundPos <> 0 then
    begin
      ListBox1.ItemIndex := FindIndex - 1;
      FoundLen := Length(ReplaceDialog.FindText);
      FoundItem := True;
      Exit;
    end;
  end;
  ShowMessage('No more matches!');
  ReplaceDialog.CloseDialog;
end;

{- Perform replacement for a ReplaceDialog operation }
procedure TMainForm.ReplaceDialogReplace(Sender: TObject);
var
  S: String;
begin
  if frReplaceAll in ReplaceDialog.Options then
    ShowMessage('Replace All not implemented')
  else if not FoundItem then
    ShowMessage('Click Find to begin/continue search')
  else begin
    S := ListBox1.Items[FindIndex - 1];
    Delete(S, FoundPos, FoundLen);
    Insert(ReplaceDialog.ReplaceText, S, FoundPos);
    ListBox1.Items[FindIndex - 1] := S;
    FoundItem := False;
  end;
end;

end.
