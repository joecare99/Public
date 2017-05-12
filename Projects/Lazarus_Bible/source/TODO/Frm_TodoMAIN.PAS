(* =========================================================== *(
**  todo\main.pas -- To do list application for Delphi         **
** ........................................................... **
**  This program uses two list boxes to create to-do and done  **
**  lists with buttons to transfer items.                      **
** ........................................................... **
**  Copyright (c) 1995,1998 by Tom Swan. All rights reserved.  **
)* =========================================================== *)

unit Frm_TodoMAIN;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Menus, Dialogs, Clipbrd, SysUtils, Printers, Frm_About;

type
  TMainForm = class(TForm)
    SrcList: TListBox;
    DstList: TListBox;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    IncludeBtn: TSpeedButton;
    IncAllBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    ExAllBtn: TSpeedButton;
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    HelpMenu: TMenuItem;
    FileOpen: TMenuItem;
    FileSave: TMenuItem;
    FileSaveAs: TMenuItem;
    N1: TMenuItem;
    FilePrint: TMenuItem;
    N2: TMenuItem;
    FileExit: TMenuItem;
    HelpAbout: TMenuItem;
    FileOpenDialog: TOpenDialog;
    FileSaveDialog: TSaveDialog;
    CloseBitBtn: TBitBtn;
    FileNew: TMenuItem;
    AddBitBtn: TBitBtn;
    EditBitBtn: TBitBtn;
    DeleteBitBtn: TBitBtn;
    EditMenu: TMenuItem;
    EditUndo: TMenuItem;
    EditDelete: TMenuItem;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    FilePrinterSetup: TMenuItem;
    procedure IncludeBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure ExcAllBtnClick(Sender: TObject);
    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
    procedure FileOpenClick(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileSaveAsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FileNewClick(Sender: TObject);
    procedure AddBitBtnClick(Sender: TObject);
    procedure EditBitBtnClick(Sender: TObject);
    procedure DeleteBitBtnClick(Sender: TObject);
    procedure FileMenuClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditUndoClick(Sender: TObject);
    procedure EditMenuClick(Sender: TObject);
    procedure HelpAboutClick(Sender: TObject);
    procedure EditDeleteClick(Sender: TObject);
    procedure FilePrintClick(Sender: TObject);
    procedure FilePrinterSetupClick(Sender: TObject);
  private
    { Private declarations }
    TodoFilename: string;   { If Length=0, no name assigned }
    DoneFilename: string;   { Same as Todo but with .Don ext }
    FileDirty: Boolean;     { True if changes not saved }
    UndoList: TStringList;  { List of deleted strings for undo }
    procedure SetCaption;
    procedure EnableMenu;
    procedure ReadFile;
    procedure WriteFile;
    procedure SaveFile;
    procedure SaveAsFile;
    procedure CloseTodoFile;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

const
  title = 'To Do';

{- Private procedures }

procedure TMainForm.SetCaption;
begin
  if Length(TodoFilename) = 0 then
    MainForm.Caption := title
  else
    MainForm.Caption := title + ' - ' +
      Lowercase(ExtractFilename(TodoFilename));
end;

procedure TMainForm.EnableMenu;
var
  I: Integer;
begin
  with FileMenu do
  begin
    for I := 0 to Count - 1 do        { Enable all File commands }
      Items[I].Enabled := True;
    if not FileDirty then
    begin  {- No edits }
      FileSave.Enabled := False;        { Must use Save as }
      if Length(TodoFilename) = 0 then  { i.e. file not named }
      begin  {- No edits; no name }
        FileSaveAs.Enabled := False;  { Nothing to save }
        FilePrint.Enabled := False;   { Nothing to print }
      end;
    end;
  end;
end;

procedure TMainForm.ReadFile;
begin
  SrcList.Items.LoadFromFile(TodoFilename);
  DstList.Items.LoadFromFile(DoneFilename);
  FileDirty := False;
end;

procedure TMainForm.WriteFile;
begin
  SrcList.Items.SaveToFile(TodoFilename);
  DstList.Items.SaveToFile(DoneFilename);
  FileDirty := False;
end;

procedure TMainForm.SaveAsFile;
begin
  if FileSaveDialog.Execute then
  begin
    TodoFilename := FileSaveDialog.Filename;
    DoneFilename := ChangeFileExt(TodoFilename, '.Don');
    WriteFile;
    SetCaption;
  end;
end;

procedure TMainForm.SaveFile;
begin
  if FileDirty then
  begin
    if Length(TodoFilename) = 0 then
      SaveAsFile
    else
      WriteFile;
  end;
end;

procedure TMainForm.CloseTodoFile;
var
  Result: Word;   { MessageDlg function return result }
begin
  if FileDirty then
  begin
    Result := MessageDlg('Save changes?',
      mtConfirmation, mbYesNoCancel, 0);
    case Result of
      mrYes:
        SaveFile;
      mrNo:
        FileDirty := False;
    end;
  end;
  if not FileDirty then
  begin
    TodoFilename := '';
    DoneFilename := '';
    FileDirty := False;
    Caption := title;
    SrcList.Items.Clear;
    DstList.Items.Clear;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  TodoFilename := '';   { No file currently open }
  DoneFilename := '';
  FileDirty := False;   { Undefined if file not open }
  Caption := title;
  UndoList := TStringList.Create;
end;

procedure TMainForm.IncludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(SrcList);
  MoveSelected(SrcList, DstList.Items);
  SetItem(SrcList, Index);
  FileDirty := True;
end;

procedure TMainForm.ExcludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(DstList);
  MoveSelected(DstList, SrcList.Items);
  SetItem(DstList, Index);
  FileDirty := True;
end;

procedure TMainForm.IncAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to SrcList.Items.Count - 1 do
    DstList.Items.AddObject(SrcList.Items[I],
      SrcList.Items.Objects[I]);
  SrcList.Items.Clear;
  SetItem(SrcList, 0);
  FileDirty := True;
end;

procedure TMainForm.ExcAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to DstList.Items.Count - 1 do
    SrcList.Items.AddObject(DstList.Items[I],
    DstList.Items.Objects[I]);
  DstList.Items.Clear;
  SetItem(DstList, 0);
  FileDirty := True;
end;

procedure TMainForm.MoveSelected(List: TCustomListBox;
          Items: TStrings);
var
  I: Integer;
begin
  for I := List.Items.Count - 1 downto 0 do
    if List.Selected[I] then
    begin
      Items.AddObject(List.Items[I], List.Items.Objects[I]);
      List.Items.Delete(I);
    end;
  FileDirty := True;
end;

procedure TMainForm.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty;
  IncAllBtn.Enabled := not SrcEmpty;
  ExcludeBtn.Enabled := not DstEmpty;
  ExAllBtn.Enabled := not DstEmpty;
end;

function TMainForm.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

procedure TMainForm.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = LB_ERR then Index := 0
    else if Index > MaxIndex then Index := MaxIndex;
    Selected[Index] := True;
  end;
  SetButtons;
end;

procedure TMainForm.FileOpenClick(Sender: TObject);
begin
  if FileOpenDialog.Execute then
  begin
    if FileDirty then CloseTodoFile;
    if not FileDirty then
    begin
      TodoFilename := FileOpenDialog.Filename;
      DoneFilename := ChangeFileExt(TodoFilename, '.Don');
      ReadFile;
      SetCaption;
      SetButtons;
    end;
  end;
end;

procedure TMainForm.FileSaveAsClick(Sender: TObject);
begin
  SaveAsFile;
end;

procedure TMainForm.FileSaveClick(Sender: TObject);
begin
  SaveFile;
end;

procedure TMainForm.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FormCloseQuery( Sender: TObject;
          var CanClose: Boolean);
begin
  CloseTodoFile;
  CanClose := not FileDirty;
end;

procedure TMainForm.FileNewClick(Sender: TObject);
begin
  CloseTodoFile;
end;

procedure TMainForm.AddBitBtnClick(Sender: TObject);
var
  S: string;
begin
  S := '';
  if InputQuery('Add Item', 'Enter new item to do:', S) then
  if Length(S) <> 0 then
  begin
    SrcList.Items.Add(S);
    FileDirty := True;
    SetButtons;
  end;
end;

procedure TMainForm.EditBitBtnClick(Sender: TObject);
var
  S: string;
  I: Integer;
begin
  with SrcList do
  begin
    I := ItemIndex;
    if I > -1 then
    begin
      S := Items.Strings[I];
      if InputQuery('Edit Item', 'Make changes to item:', S) then
      if Length(S) <> 0 then
      begin
        Items.Strings[I] := S;
        FileDirty := True;
        Selected[I] := True;
        Sorted := False;  { Toggle Sorted property to resort }
        Sorted := True;
      end;
    end;
  end;
end;

procedure TMainForm.DeleteBitBtnClick(Sender: TObject);
var
  I: Integer;
begin
  with SrcList do
  for I := Items.count - 1 downto 0 do
  if Selected[I] then
  begin
    UndoList.Add(Items[I]);
    Items.Delete(I);
    FileDirty := True;
  end;
end;

procedure TMainForm.FileMenuClick(Sender: TObject);
begin
  EnableMenu;  { Enable/disable commands before menu opens }
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if UndoList <> nil then
    UndoList.Free;
end;

procedure TMainForm.EditUndoClick(Sender: TObject);
begin
  with UndoList do
  if Count > 0 then
  begin
    SrcList.Items.Add(UndoList[Count - 1]);
    UndoList.Delete(Count - 1);
    FileDirty := True;
  end;
end;

procedure TMainForm.EditMenuClick(Sender: TObject);
begin
  EditUndo.Enabled  := UndoList.Count > 0;
end;

procedure TMainForm.HelpAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.EditDeleteClick(Sender: TObject);
begin
  DeleteBitBtn.Click;
end;

procedure TMainForm.FilePrintClick(Sender: TObject);
var
  FPrn: System.Text;  { Printer output text file }
  I: Integer;
begin
  if PrintDialog1.Execute then
  begin
    AssignPrn(FPrn);  { Direct Write/Writeln to FPrn }
    Rewrite(FPrn);    { Open printer output file }
    try
      Writeln(FPrn, MainForm.Caption);  { Title }
      Writeln(FPrn);  { Print blank line }
      with SrcList do
      for I := 0 to Items.Count - 1 do
        Writeln(FPrn, Items[I]);  { Print line }
    finally
      CloseFile(FPrn);  { Close printer output file }
    end;
  end;
end;

procedure TMainForm.FilePrinterSetupClick(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

end.

(*
// ==============================================================
// Copyright (c) 1995 by Tom Swan. All rights reserved
// Revision 1.00    Date: 8/8/1995   Time: 12:47 pm
*)

