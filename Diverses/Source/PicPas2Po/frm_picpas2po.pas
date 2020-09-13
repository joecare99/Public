unit frm_PicPas2Po;

{$mode delphi}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
    ExtCtrls, Buttons, ActnList, fra_PoFile, fra_PicPasFile;

type

    { TfrmPicPas2PoMain }

    TfrmPicPas2PoMain = class(TForm)
        actFileSelectDir: TAction;
        actProcessAllPo2Pas: TAction;
        actProcessAllPas2Po: TAction;
        actProcessPo2Pas: TAction;
        actProcessPas2Po: TAction;
        alsPicPas2Po: TActionList;
        btnProcessPas2Po: TBitBtn;
        btnProcessAllPas2Po: TBitBtn;
        btnProcessAllPo2Pas: TSpeedButton;
        btnSelectDir: TSpeedButton;
        edtSourceDir: TLabeledEdit;
        fraPicPasFile1: TfraPicPasFile;
        fraPoFile1: TfraPoFile;
        pnlProcessing: TPanel;
        pnlLeft: TPanel;
        pnlRight: TPanel;
        pnlTopRight: TPanel;
        pnlTop: TPanel;
        SelectDirectoryDialog1: TSelectDirectoryDialog;
        btnProcessPo2Pas: TSpeedButton;
        procedure actProcessPas2PoExecute(Sender: TObject);
        procedure actFileSelectDirExecute(Sender: TObject);
        procedure edtSourceDirChange(Sender: TObject);
        procedure edtSourceDirExit(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormResize(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure actProcessPo2PasExecute(Sender: TObject);
    private
        FChanged: boolean;
        procedure AppendData(const aIdent: string; const aTrans: TStringArray);
    public

    end;

var
    frmPicPas2PoMain: TfrmPicPas2PoMain;

implementation

uses LConvEncoding, Unt_FileProcs, LazFileUtils, Math;

{$R *.lfm}


{ TfrmPicPas2PoMain }

procedure TfrmPicPas2PoMain.actFileSelectDirExecute(Sender: TObject);
begin
    if SelectDirectoryDialog1.Execute then
        edtSourceDir.Text := SelectDirectoryDialog1.FileName;
end;

procedure TfrmPicPas2PoMain.actProcessPas2PoExecute(Sender: TObject);

var
    lIdentifyer: string;
    i: integer; // Comment Pos
    lAoS: TStringArray;
begin
    for i := 0 to fraPicPasFile1.Count - 1 do
      begin
        lIdentifyer:= fraPicPasFile1.GetIdentifyer(i);
        setlength(lAoS, min(fraPoFile1.LanguageID + 1,1));
        lAoS[0] := fraPicPasFile1.Translation[i,0];
        if fraPoFile1.LanguageID>=0 then
           lAoS[fraPoFile1.LanguageID] := fraPicPasFile1.Translation[i,fraPoFile1.LanguageID];
         fraPoFile1.AppendData( lIdentifyer, lAoS);
      end; {for }
    fraPoFile1.UpdateUI(Sender);
end; {Procedure }

procedure TfrmPicPas2PoMain.edtSourceDirChange(Sender: TObject);
begin
    if ActiveControl = edtSourceDir then
        FChanged := True
    else
      begin
        fraPicPasFile1.BaseDir:=edtSourceDir.Text;
        fraPoFile1.BaseDir := edtSourceDir.Text;
      end;
end;

procedure TfrmPicPas2PoMain.edtSourceDirExit(Sender: TObject);
begin
    if Fchanged then
      begin
        fraPicPasFile1.BaseDir:=edtSourceDir.Text;
        fraPoFile1.BaseDir := edtSourceDir.Text;
        Fchanged := False;
      end;
end;

procedure TfrmPicPas2PoMain.FormCreate(Sender: TObject);
begin
    fraPicPasFile1.BaseDir:=edtSourceDir.Text;
    fraPoFile1.BaseDir := edtSourceDir.Text;
end;

procedure TfrmPicPas2PoMain.FormResize(Sender: TObject);
var
    lWidth: integer;
begin
    lWidth := (ClientWidth - 30) div 2;
    pnlRight.Width := lWidth;
    pnlleft.Width := lWidth;
end;

procedure TfrmPicPas2PoMain.FormShow(Sender: TObject);
begin
    edtSourceDirChange(Sender);
end;

procedure TfrmPicPas2PoMain.actProcessPo2PasExecute(Sender: TObject);

var
    i, id: integer;
    lIdentifyer: string;

begin
    i := 0;
    if fraPoFile1.LanguageID < 1 then
      begin
        MessageDlg('Can''t Update file',
            'To Update the File you have to select a Language first.', mtError, [mbOK], 0);
        exit;
      end;
    for i := 0 to fraPicPasFile1.Count do
      begin
            lIdentifyer := fraPicPasFile1.GetIdentifyer(I);
            id := fraPoFile1.LookUpIdent(lIdentifyer);
            if id>=0 then
              fraPicPasFile1.Translation[i,fraPoFile1.LanguageID] := fraPoFile1.GetTranslText(id)
      end;
end;

procedure TfrmPicPas2PoMain.AppendData(const aIdent: string; const aTrans: TStringArray);
begin
    fraPoFile1.AppendData( aIdent, aTrans);
end;

end.
