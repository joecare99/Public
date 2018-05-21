unit frm_TestFileFormMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, fra_MiniTestFrame, Unt_Config;

type

  { TfrmMainForm }

  TfrmMainForm = class(TForm)
    btnClose: TBitBtn;
    btnLoadFile: TBitBtn;
    cbxFilename: TComboBox;
    Config1: TConfig;
    fraMiniTestFrame1: TfraMiniTestFrame;
    OpenDialog1: TOpenDialog;
    pnlLeft: TPanel;
    pnlBottom: TPanel;
    pnlTop: TPanel;
    btnSelectFile: TSpeedButton;
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnSelectFileClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FDatapath:string;
    FNewFileFlag:boolean;
  public

  end;

var
  frmMainForm: TfrmMainForm;

implementation

{$R *.lfm}

{ TfrmMainForm }

procedure TfrmMainForm.btnSelectFileClick(Sender: TObject);
begin
  OpenDialog1.FileName := cbxFilename.Text;
  if OpenDialog1.Execute then
     begin
       cbxFilename.Text := OpenDialog1.FileName;
       btnLoadFileClick(Sender);
     end;
end;

procedure TfrmMainForm.FormShow(Sender: TObject);
  var
    CBCount, i: integer;
begin
    CBCount := Config1.getValue(cbxFilename, 'ICount', 0);
    for i := 0 to CBCount - 1 do
      begin
        cbxFilename.Items.Add(Config1.getValue(cbxFilename, IntToStr(i), ''));
        if cbxFilename.Text = cbxFilename.Items[i] then
            cbxFilename.ItemIndex := i;
      end;
    if (cbxFilename.ItemIndex = -1) and (cbxFilename.Items.Count > 0) then
        cbxFilename.ItemIndex := 0;
    FDatapath := 'Data';
    for i := 0 to 2 do
        if DirectoryExists(FDataPath) then
            Break
        else
            FDataPath := '..' + DirectorySeparator + FDataPath;
end;

procedure TfrmMainForm.btnLoadFileClick(Sender: TObject);
  var
      sf: TFileStream;
      s: string;
      lEncoded: boolean;
      i: integer;
  begin
      if not FileExists(cbxFilename.Text) then
        begin
          MessageDlg('Datei kann nicht geladen werden', Format(
              'Datei "%s" nicht gefunden', [cbxFilename.Text]), mtError, [mbOK], 0);
          FNewFileFlag := False;
      //Todo: chbAutocontinue.Checked := False;
          exit; (* !!!!!!!!!!!!! *)
        end;
        try
          btnLoadFile.Enabled := False;
          if not FNewFileFlag and (cbxFilename.ItemIndex = -1) then
            begin
              cbxFilename.Items.add(cbxFilename.Text);
              Config1.Value[cbxFilename, 'ICount'] := cbxFilename.Items.Count;
              for i := 0 to cbxFilename.Items.Count - 1 do
                  config1.Value[cbxFilename, IntToStr(i)] := cbxFilename.Items[i];
            end;
          // Optional if Frame takes a String
          sf := TFileStream.Create(cbxFilename.Text, fmOpenRead);
            try
              setlength(s, sf.Size);
              sf.ReadBuffer(s[1], sf.Size);
            finally
              FreeAndNil(sf);
            end;
          // Trigger Frame-Load Data Method.
          fraMiniTestFrame1.LoadString(s);
        finally
          btnLoadFile.Enabled := True;
        end;
end;

end.

