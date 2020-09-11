unit frm_PicPas2Po;

{$mode delphi}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
    ExtCtrls, Buttons, ActnList, fra_PoFile;

type

    { TfrmPicPas2PoMain }

    TfrmPicPas2PoMain = class(TForm)
        actFileSelectDir: TAction;
        actFileOpenPas: TAction;
        actFileSavePas: TAction;
        actProcessAllPo2Pas: TAction;
        actProcessAllPas2Po: TAction;
        actProcessPo2Pas: TAction;
        actProcessPas2Po: TAction;
        alsPicPas2Po: TActionList;
        btnProcessPas2Po: TBitBtn;
        btnFileOpenPas: TSpeedButton;
        btnFileSavePas: TSpeedButton;
        btnProcessAllPas2Po: TBitBtn;
        btnProcessAllPo2Pas: TSpeedButton;
        btnSelectDir: TSpeedButton;
        cbxSelectFile: TComboBox;
        edtPasFile: TMemo;
        edtSourceDir: TLabeledEdit;
        fraPoFile1: TfraPoFile;
        Label1: TLabel;
        pnlProcessing: TPanel;
        pnlLeft: TPanel;
        pnlLeftTop: TPanel;
        pnlRight: TPanel;
        pnlTopRight: TPanel;
        pnlTop: TPanel;
        SelectDirectoryDialog1: TSelectDirectoryDialog;
        btnProcessPo2Pas: TSpeedButton;
        procedure actFileOpenPasUpdate(Sender: TObject);
        procedure actFileSavePasExecute(Sender: TObject);
        procedure actFileSavePasUpdate(Sender: TObject);
        procedure actProcessPas2PoExecute(Sender: TObject);
        procedure actFileSelectDirExecute(Sender: TObject);
        procedure cbxSelectFileClick(Sender: TObject);
        procedure edtPasFileChange(Sender: TObject);
        procedure edtPasFileKeyUp(Sender: TObject; var {%H-}Key: word; {%H-}Shift: TShiftState);
        procedure edtSourceDirChange(Sender: TObject);
        procedure edtSourceDirExit(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormResize(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure actFileOpenPasExecute(Sender: TObject);
        procedure actProcessPo2PasExecute(Sender: TObject);
        procedure UpdateCombobox(Sender: TObject);
    private
        FChanged: boolean;
        FFileEncoding: string;
        FPasChanged: boolean;
        FPasFilename: string;
        procedure AppendData(const aIdent: string; const aTrans: TStringArray);
        procedure SavePasFile(const aFilename:String);
    public

    end;

var
    frmPicPas2PoMain: TfrmPicPas2PoMain;

implementation

uses LConvEncoding, Unt_FileProcs, LazFileUtils;

{$R *.lfm}


{ TfrmPicPas2PoMain }

procedure TfrmPicPas2PoMain.actFileSelectDirExecute(Sender: TObject);
begin
    if SelectDirectoryDialog1.Execute then
        edtSourceDir.Text := SelectDirectoryDialog1.FileName;
end;

procedure TfrmPicPas2PoMain.cbxSelectFileClick(Sender: TObject);
begin
    if FileExists(edtSourceDir.Text + DirectorySeparator + cbxSelectFile.Text) then
        actFileOpenPasExecute(Sender);
end;

procedure TfrmPicPas2PoMain.edtPasFileChange(Sender: TObject);
begin
    FPasChanged := True;
end;

procedure TfrmPicPas2PoMain.edtPasFileKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
    label1.Caption := format('(%d;%d) %d', [edtPasFile.CaretPos.x,
        edtPasFile.CaretPos.y, ptrint(edtPasFile.Lines.Objects[edtPasFile.CaretPos.y])]);
end;

procedure TfrmPicPas2PoMain.actProcessPas2PoExecute(Sender: TObject);

var
    Line, lsTmp, lIdentifyer: string;
    lcp, Parsemode, i: integer; // Comment Pos
    lpp: SizeInt;
    lAoS: TStringArray;
    cc: char;

begin
    Line := '';
    Parsemode := 0;
    for i := 0 to edtPasFile.Lines.Count - 1 do
      begin
        line := line + edtPasFile.Lines[i];
        lcp := pos('//', line);
        if lcp > 0 then
            Delete(line, lcp, length(line) - lcp);
        while length(Line) > 0 do
            case Parsemode of
                0:
                  begin
                    lpp := pos(':=', line);
                    if lpp > 0 then
                      begin
                        lIdentifyer := trim(copy(line, 1, lpp - 1));
                        Delete(line, 1, lpp + 1);
                        Inc(Parsemode);
                      end
                    else
                        line := '';
                  end; {case 0}
                1:
                  begin
                    lpp := pos('(', line);
                    if lpp > 0 then
                      begin
                        setlength(lAoS, 0);
                        lsTmp := uppercase(trim(copy(line, 1, lpp - 1)));
                        if lsTmp = 'TRANS' then
                          begin
                            Delete(line, 1, lpp);
                            Inc(Parsemode);
                          end;
                      end
                    else
                        line := '';
                  end; {case 1}
                else
                  begin
                    lsTmp := '';
                    lpp := pos('''', line);
                    if lpp > 0 then
                      begin
                        Delete(line, 1, lpp);
                        lpp := 0;
                        while (lpp < 2) and (length(line) > 0) do
                          begin
                            cc := line[1];
                            Delete(line, 1, 1);
                            if cc = '''' then
                                if copy(line, 1, 1) = '''' then
                                    Delete(line, 1, 1)
                                else
                                    lpp := 1;
                            if lpp = 0 then
                                lsTmp := lsTmp + cc
                            else
                            if (cc = ',') then
                                lpp := 2
                            else
                            if (cc = ')') and (copy(trim(line), 1, 1) = ';') then
                                lpp := 3;
                          end; {while}
                        setlength(lAoS, high(lAoS) + 2);
                        lAoS[high(lAoS)] := lsTmp;
                        if lpp = 3 then
                          begin
                            line := trim(line);
                            Delete(line, 1, 1);
                            AppendData(lIdentifyer, lAoS);
                            Parsemode := 0;
                          end;

                      end; {if Lpp>0}
                  end; {else}

              end; {while case}

      end; {for }
    fraPoFile1.UpdateUI(Sender);
end; {Procedure }

procedure TfrmPicPas2PoMain.actFileOpenPasUpdate(Sender: TObject);
begin
    actFileOpenPas.Enabled := DirectoryExists(edtSourceDir.Text);
    actFileSavePas.Enabled := DirectoryExists(edtSourceDir.Text) and FPasChanged;
end;

procedure TfrmPicPas2PoMain.actFileSavePasExecute(Sender: TObject);
begin
    saveFile(SavePasFile,FPasFilename);
    FPasChanged:=false;
end;

procedure TfrmPicPas2PoMain.actFileSavePasUpdate(Sender: TObject);
begin
    actFileSavePas.Enabled := FPasChanged;
end;

procedure TfrmPicPas2PoMain.edtSourceDirChange(Sender: TObject);
begin
    if ActiveControl = edtSourceDir then
        FChanged := True
    else
      begin
        UpdateCombobox(Sender);
        fraPoFile1.BaseDir := edtSourceDir.Text;
      end;
end;

procedure TfrmPicPas2PoMain.edtSourceDirExit(Sender: TObject);
begin
    if Fchanged then
      begin
        UpdateCombobox(Sender);
        fraPoFile1.BaseDir := edtSourceDir.Text;
        Fchanged := False;
      end;
end;

procedure TfrmPicPas2PoMain.FormCreate(Sender: TObject);
begin
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

procedure TfrmPicPas2PoMain.actFileOpenPasExecute(Sender: TObject);
var
    lFs: TFileStream;
    lStr, lFileEncoding: string;
begin
    lFileEncoding:='';
    if FPasChanged then
        case MessageDlg('File changed, Save ?',mtConfirmation,[mbYes,mbNo,mbCancel],0) of
           mrYes: actFileSavePas.Execute;
           mrCancel:exit;
        end;
    FPasFilename := '';
    lFs := TFileStream.Create(edtSourceDir.Text + DirectorySeparator +
        cbxSelectFile.Text, fmOpenRead);
      try
        setlength(lStr, lFs.Size);
        lFs.Read(lstr[1], lFs.Size);
        FFileEncoding := GuessEncoding(lStr);
        edtPasFile.Text := ConvertEncoding(lStr, lFileEncoding, EncodingUTF8);
        FPasFilename := edtSourceDir.Text + DirectorySeparator + cbxSelectFile.Text;
        FPasChanged:=false;
      finally
        FreeAndNil(lFs);
      end;
end;

procedure TfrmPicPas2PoMain.actProcessPo2PasExecute(Sender: TObject);

type
    Tidx = record
        lnNr,
        istart,
        iend: integer;
        iStr: string;
      end;
    TIdxArray = array of Tidx;


    function ParseLineForString(const ActLine: integer; const Line: string; var CharIdx: integer; var AoIdx: TIdxArray; out Ident: string): integer;
    var
        lppn: SizeInt;
        cc: char;
    begin
        Ident := '';
        lppn := pos('''', copy(line, CharIdx, length(line)));
        if lppn > 0 then
          begin
            setlength(AoIdx, high(AoIdx) + 2);
            AoIdx[high(AoIdx)].lnNr := ActLine;
            CharIdx := CharIdx + lppn;
            AoIdx[high(AoIdx)].istart := CharIdx - 1;
            lppn := 0;
            while (lppn < 2) and (length(line) >= CharIdx) do
              begin
                cc := line[CharIdx];
                if cc = '''' then
                    if copy(line, CharIdx + 1, 1) = '''' then
                        Inc(CharIdx)
                    else
                      begin
                        lppn := 1;
                        AoIdx[high(AoIdx)].iend := CharIdx;
                        AoIdx[high(AoIdx)].iStr := Ident;
                      end;
                if lppn = 0 then
                    Ident := Ident + cc
                else
                if (cc = ',') then
                    lppn := 2
                else
                if (cc = ')') and
                    (trim(copy(line, CharIdx + 1, length(line) - CharIdx)) = ';') then
                    lppn := 3;
                Inc(CharIdx);
              end; {While}
          end
        else
            CharIdx := length(line) + 1;
        Result := lppn;
    end;

var
    i, id: integer;
    lpp, lppn, lDebHighAo, lDebLangID: integer;
    line, lsTmp, lnewtext, lIdentifyer: string;
    AoIdx: TIdxArray;

begin
    i := 0;
    if fraPoFile1.LanguageID < 1 then
      begin
        MessageDlg('Can''t Update file',
            'To Update the File you have to select a Language first.', mtError, [mbOK], 0);
        exit;
      end;
    while i < edtPasFile.Lines.Count do
      begin
        line := edtPasFile.Lines[i];
        setlength(AoIdx, 0);
        // Get Identifyer
        lpp := pos(':=', line);
        if lpp > 0 then
            lIdentifyer := trim(copy(line, 1, lpp - 1));
        lpp := pos('TRANS(', uppercase(line));
        if lpp > 0 then
          begin
            lppn := ParseLineForString(i, edtPasFile.Lines[i], lpp, AoIdx, lsTmp);
            id := fraPoFile1.LookUpIdent(copy(ExtractFileNameWithoutExt(ExtractFileName(FPasFilename)), 5,
                length(FPasFilename)) + '.' + lIdentifyer);
            if id>=0 then
            lnewtext := fraPoFile1.GetTranslText(id)
            else
            lnewtext:='';
            repeat
                lppn := ParseLineForString(i, edtPasFile.Lines[i], lpp, AoIdx, lsTmp);
                if lpp > length(line) then
                  begin
                    Inc(i);
                    line := edtPasFile.Lines[i];
                    lpp := 1;
                  end;
            until (lppn = 3) or (i>edtPasFile.Lines.Count);
            lDebHighAo := high(AoIdx);
            lDebLangID := fraPoFile1.LanguageID;
            if (high(AoIdx) >= fraPoFile1.LanguageID - 1) and (AoIdx[fraPoFile1.LanguageID - 1].istr <> lnewtext) then
                with AoIdx[fraPoFile1.LanguageID - 1] do
                  begin
                    line := edtPasFile.Lines[lnNr];
                    Delete(line, istart, iend - istart + 1);
                    insert(QuotedStr(lnewtext), line, istart);
                    if edtPasFile.Lines[lnNr] <> line then
                      edtPasFile.Lines[lnNr] := line;
                  end
             else if  (high(AoIdx) = fraPoFile1.LanguageID-2 ) then
                with AoIdx[high(AoIdx)] do
                  begin
                    line := edtPasFile.Lines[lnNr];
                    insert(','+QuotedStr(lnewtext), line, iend+1);
                    if edtPasFile.Lines[lnNr] <> line then
                      edtPasFile.Lines[lnNr] := line;
                  end;

          end;

        Inc(i);
      end;
end;

procedure TfrmPicPas2PoMain.UpdateCombobox(Sender: TObject);
var
    sResult: longint;
    sr: TSearchRec;
begin
    if DirectoryExists(edtSourceDir.Text) then
      begin
        cbxSelectFile.Clear;
        sResult := Findfirst(edtSourceDir.Text + DirectorySeparator +
            '*.pas', faAnyFile - faDirectory, sr);
        while sResult = 0 do
          begin
            cbxSelectFile.AddItem(sr.Name, nil);
            sResult := FindNext(sr);
          end;
      end;
end;

procedure TfrmPicPas2PoMain.AppendData(const aIdent: string; const aTrans: TStringArray);
begin
    fraPoFile1.AppendData(copy(ExtractFileNameWithoutExt(ExtractFileName(FPasFilename)), 5,
                length(FPasFilename)) + '.' + aIdent, aTrans);
end;

procedure TfrmPicPas2PoMain.SavePasFile(const aFilename: String);
var
  sf: TFileStream;
  s: string;
begin
  sf := TFileStream.Create(aFilename, fmCreate);
    try
      s := ConvertEncoding(edtPasFile.Lines.Text, EncodingUTF8, FFileEncoding);
      sf.WriteBuffer(s[1], Length(s));
    finally
      FreeAndNil(sf);
    end;
end;

end.
