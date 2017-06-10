unit frm_PicPas2Po;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ActnList, unt_PoFile;

type

  { TfrmPicPas2PoMain }

  TfrmPicPas2PoMain = class(TForm)
    actFileSelectDir: TAction;
    actFileOpenPas: TAction;
    actFileSavePas: TAction;
    actFileOpenPo: TAction;
    actFileSavePo: TAction;
    actProcessPo2Pas: TAction;
    actProcessPas2Po: TAction;
    alsPicPas2Po: TActionList;
    btnProcessPas2Po: TBitBtn;
    btnFileOpenPas: TSpeedButton;
    btnFileSavePas: TSpeedButton;
    btnSelectDir: TSpeedButton;
    cbxSelectFile: TComboBox;
    cbxSelectLanguage: TComboBox;
    edtPasFile: TMemo;
    edtPoFile: TMemo;
    edtProjectName: TEdit;
    edtSourceDir: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    pnlProcessing: TPanel;
    pnlLeft: TPanel;
    pnlLeftTop: TPanel;
    pnlRight: TPanel;
    pnlRightTop: TPanel;
    pnlTopRight: TPanel;
    pnlTop: TPanel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    btnProcessPo2Pas: TSpeedButton;
    btnFileOpenPo: TSpeedButton;
    btnFileSavePo: TSpeedButton;
    procedure actFileOpenPasUpdate(Sender: TObject);
    procedure actProcessPas2PoExecute(Sender: TObject);
    procedure actFileSelectDirExecute(Sender: TObject);
    procedure cbxSelectFileClick(Sender: TObject);
    procedure edtPasFileKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtSourceDirChange(Sender: TObject);
    procedure edtSourceDirExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actFileOpenPasExecute(Sender: TObject);
    procedure actProcessPo2PasExecute(Sender: TObject);
    procedure actFileOpenPoExecute(Sender: TObject);
    procedure actFileSavePoExecute(Sender: TObject);
    procedure UpdateCombobox(Sender: TObject);
  private
    FChanged: boolean;
    FPasChanged :boolean;
    FPoFile: TPoFile;
    FPasFilename: string;
    procedure AppendData(const aIdent: string; const aTrans: TStringArray);
  public

  end;

var
  frmPicPas2PoMain: TfrmPicPas2PoMain;

implementation

uses LConvEncoding;

{$R *.lfm}


{ TfrmPicPas2PoMain }

procedure TfrmPicPas2PoMain.actFileSelectDirExecute(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
  begin
    edtSourceDir.Text := SelectDirectoryDialog1.FileName;
  end;
end;

procedure TfrmPicPas2PoMain.cbxSelectFileClick(Sender: TObject);
begin
  if FileExists(edtSourceDir.Text + DirectorySeparator + cbxSelectFile.Text) then
    actFileOpenPasExecute(Sender);
end;

procedure TfrmPicPas2PoMain.edtPasFileKeyUp(Sender: TObject; var Key: word;
  Shift: TShiftState);
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
              begin
                if (cc = ',') then
                  lpp := 2
                else
                if (cc = ')') and (copy(trim(line), 1, 1) = ';') then
                  lpp := 3;
              end;
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
end; {Procedure }

procedure TfrmPicPas2PoMain.actFileOpenPasUpdate(Sender: TObject);
begin
  actFileOpenPas.Enabled := DirectoryExists(edtSourceDir.text);
  actFileSavePas.Enabled := DirectoryExists(edtSourceDir.text) and FPasChanged;
end;

procedure TfrmPicPas2PoMain.edtSourceDirChange(Sender: TObject);
begin
  if ActiveControl = edtSourceDir then
    FChanged := True
  else
    UpdateCombobox(Sender);
end;

procedure TfrmPicPas2PoMain.edtSourceDirExit(Sender: TObject);
begin
  if Fchanged then
  begin
    UpdateCombobox(Sender);
    Fchanged := False;
  end;
end;

procedure TfrmPicPas2PoMain.FormCreate(Sender: TObject);
begin
  FPoFile := TPoFile.Create(self);
end;

procedure TfrmPicPas2PoMain.FormResize(Sender: TObject);
var
  lWidth: Integer;
begin
 lWidth := (ClientWidth - 30) div 2;
 pnlRight.Width:=lWidth;
 pnlleft.Width:=lWidth;
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
  FPasFilename := '';
  lFs := TFileStream.Create(edtSourceDir.Text + DirectorySeparator +
    cbxSelectFile.Text, fmOpenRead);
  try
    setlength(lStr, lFs.Size);
    lFs.Read(lstr[1], lFs.Size);
    lFileEncoding := GuessEncoding(lStr);
    edtPasFile.Text := ConvertEncoding(lStr, lFileEncoding, EncodingUTF8);
    FPasFilename := cbxSelectFile.Text;
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
    iStr:string;
  end;
  TIdxArray = array of Tidx;


  function ParseLineForString(const ActLine: integer; const Line: string;
  var CharIdx: integer; var AoIdx: TIdxArray; out Ident: string): integer;
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
            AoIdx[high(AoIdx)].iStr:=Ident;
          end;
        if lppn = 0 then
          Ident := Ident + cc
        else
        begin
          if (cc = ',') then
            lppn := 2
          else
          if (cc = ')') and
            (trim(copy(line, CharIdx + 1, length(line) - CharIdx)) = ';') then
            lppn := 3;
        end;
        Inc(CharIdx);
      end; {While}
    end
    else
      CharIdx := length(line) + 1;
    Result := lppn;
  end;

var
  i, id: integer;
  lpp, lppn: integer;
  line, lsTmp, lnewtext: string;
  cc: char;
  id2: PtrInt;
  AoIdx: TIdxArray;

begin
  i := 0;
  if cbxSelectLanguage.ItemIndex < 1 then
  begin
    MessageDlg('Can''t Update file',
      'To Update the File you have to select a Language first.', mtError, [mbOK], 0);
    exit;
  end;
  while i < edtPasFile.Lines.Count do
  begin
    line := edtPasFile.Lines[i];
    setlength(AoIdx, 0);
    lpp := pos('TRANS(', uppercase(line));
    if lpp > 0 then
    begin
      lppn := ParseLineForString(i, edtPasFile.Lines[i], lpp, AoIdx, lsTmp);
      id := FPoFile.LookUpIdent(lsTmp);
      lnewtext := FPoFile.GetTranslText(id);
      repeat
        lppn := ParseLineForString(i, edtPasFile.Lines[i], lpp, AoIdx, lsTmp);
        if lpp > length(line) then
        begin
          Inc(i);
          line := edtPasFile.Lines[i];
          lpp := 1;
        end;
      until lppn = 3;
      if (high(AoIdx) >= cbxSelectLanguage.ItemIndex - 1)
        and (AoIdx[cbxSelectLanguage.ItemIndex - 1].istr <> lnewtext) then
        with AoIdx[cbxSelectLanguage.ItemIndex - 1] do
        begin
          line := edtPasFile.Lines[lnNr];
          Delete(line, istart, iend - istart + 1);
          insert(QuotedStr(lnewtext), line, istart);
          edtPasFile.Lines[lnNr] := line;
        end;
    end;

    Inc(i);
  end;
end;

procedure TfrmPicPas2PoMain.actFileOpenPoExecute(Sender: TObject);
var
  lFilename: string;
begin
  lFilename := edtProjectName.Text;
  if pos(',', cbxSelectLanguage.Text) > 0 then
    lFilename := lFilename + ExtensionSeparator + copy(cbxSelectLanguage.Text,
      pos(',', cbxSelectLanguage.Text) + 1, 4);
  lFilename := lFilename + ExtensionSeparator + 'po';
  if fileexists(edtSourceDir.Text + DirectorySeparator + lFilename) then
  begin
    FpoFile.LoadFromFile(edtSourceDir.Text + DirectorySeparator + lFilename);
    edtPoFile.Lines.Assign(FpoFile.Lines);
  end;
end;

procedure TfrmPicPas2PoMain.actFileSavePoExecute(Sender: TObject);
var
  lFilename: string;
begin
  lFilename := edtProjectName.Text;
  if pos(',', cbxSelectLanguage.Text) > 0 then
    lFilename := lFilename + ExtensionSeparator + copy(cbxSelectLanguage.Text,
      pos(',', cbxSelectLanguage.Text) + 1, 4);
  lFilename := lFilename + ExtensionSeparator + 'po';
  if fileexists(edtSourceDir.Text + DirectorySeparator + lFilename) and
    (MessageDlg('Confirmatione', format(
    'File "%s" exists !\nDo you want to replace it ?', [lFilename]),
    mtConfirmation, mbYesNo, 0) = mrNo) then
    exit;
  lFilename := edtSourceDir.Text + DirectorySeparator + lFilename;
  FpoFile.SaveToFile(ChangeFileExt(lFilename, '.new'));
  if fileexists(lFilename) then
  begin
    if fileexists(ChangeFileExt(lFilename, '.bak')) then
      DeleteFile(ChangeFileExt(lFilename, '.bak'));
    RenameFile(lFilename, ChangeFileExt(lFilename, '.bak'));
  end;
  RenameFile(ChangeFileExt(lFilename, '.new'), lFilename);
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

procedure TfrmPicPas2PoMain.AppendData(const aIdent: string;
  const aTrans: TStringArray);
var
  lReference, lTranslStr, lFullindex: string;
begin
  lReference := copy(ExtractFileNameWithoutExt(FPasFilename), 5,
    length(FPasFilename)) + '.' + aIdent;
  lFullindex := aTrans[0];
  if cbxSelectLanguage.ItemIndex > 0 then
    lTranslStr := aTrans[cbxSelectLanguage.ItemIndex - 1]
  else
    lTranslStr := '';
  FPoFile.AppendData(lReference, lFullindex, lTranslStr);
end;


end.
