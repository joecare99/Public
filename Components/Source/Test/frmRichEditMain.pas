unit frmRichEditMain;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ActnList, RichMemoFrame, RichMemo;

type

  { TForm1 }

  TForm1 = class(TForm)
    actFileSave: TAction;
    ActionList1: TActionList;
    btnCancel: TButton;
    btnClear: TButton;
    btnLoad: TButton;
    btnOk: TButton;
    btnSave: TButton;
    pnlBottom: TPanel;
    RTFEditFrame1: TRTFEditFrame;
    RtfOpenDialog: TOpenDialog;
    RtfSaveDialog: TSaveDialog;
    procedure actFileSaveUpdate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure actFileSaveExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    procedure RTFEditOnChange(Sender: TObject);

  public

  end;

var
  Form1: TForm1;

implementation

uses RichMemoUtils;
{$R *.lfm}

resourcestring
  rsRMCaption='RichEdit: %s';



procedure TForm1.btnClearClick(Sender: TObject);
begin
  RTFEditFrame1.NewFile('New document.rtf');
end;

procedure TForm1.btnCancelClick(Sender: TObject);
begin
  RTFEditFrame1.changed:=false;
  close;
end;

procedure TForm1.actFileSaveUpdate(Sender: TObject);
begin
  actFileSave.Enabled := (RTFEditFrame1.RichMemo1.Lines.Count > 0) and RTFEditFrame1.Changed;
end;

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  if RtfOpenDialog.Execute then
    begin
      RTFEditFrame1.LoadFile(RtfOpenDialog.FileName);
      RtfSaveDialog.FileName := RtfOpenDialog.FileName;
      caption := Format(rsRMCaption,[RtfSaveDialog.FileName]);
    end;
end;

procedure TForm1.btnOkClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.actFileSaveExecute(Sender: TObject);
begin
  if RTFEditFrame1.FileName = '' then
    RTFEditFrame1.FileName := 'New document.rtf';
  RtfSaveDialog.FileName:=RTFEditFrame1.Filename;
  if RtfSaveDialog.Execute and (RtfSaveDialog.FileName <> '') then
    begin
      RTFEditFrame1.SaveFileAs(RtfSaveDialog.FileName);
      caption := Format(rsRMCaption,[RtfSaveDialog.FileName]);
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RTFEditFrame1.OnChange:=RTFEditOnChange;
end;

procedure TForm1.RTFEditOnChange(Sender: TObject);
begin
  actFileSaveUpdate(sender);
end;

end.

