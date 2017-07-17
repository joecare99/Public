unit fra_PoFile;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls, Buttons,
    ActnList, StdActns, ComCtrls, unt_PoFile;

type

    { TfraPoFile }

    TfraPoFile = class(TFrame)
        actFileSave: TAction;
        actFileLoad: TAction;
        actFileAutoLoad: TAction;
        alsPoFile: TActionList;
        cbxSelectLanguage: TComboBox;
        edtPoFile: TMemo;
        actFileOpen: TFileOpen;
        actFileSaveAs: TFileSaveAs;
        edtProjectName: TEdit;
        lblBottom: TLabel;
        pnlRightTop: TPanel;
        tlbPoFile: TToolBar;
        ToolButton1: TToolButton;
        ToolButton3: TToolButton;
        ToolButton4: TToolButton;
        procedure actFileLoadExecute(Sender: TObject);
        procedure actFileSaveExecute(Sender: TObject);
        procedure cbxSelectLanguageChange(Sender: TObject);
        procedure UpdateUI(Sender: TObject);
    private
        FBaseDir: string;
        FPoFile: TPoFile;
        function GetLanguageID: integer;
        procedure SetBaseDir(AValue: string);
    public
        constructor Create(TheOwner: TComponent); override;
        destructor Destroy; override;
        property poFile: TpoFile read FPoFile;
        procedure AppendData(const aIdent: string; const aTrans: TStringArray);
        function LookUpIdent(const aIdent: string): integer;
        function LookUpSource(const aIdent: string): integer;
        function GetTranslText(const id: integer): string;
        property LanguageID: integer read GetLanguageID;// write SetLanguageID
        property BaseDir: string read FBaseDir write SetBaseDir;
    end;

implementation

uses Dialogs;

{$R *.lfm}

{ TfraPoFile }

procedure TfraPoFile.cbxSelectLanguageChange(Sender: TObject);

begin
    FPoFile.Lines.Clear;
    if actFileAutoLoad.Checked then
        actFileLoad.Execute;
    UpdateUI(Sender);
end;

procedure TfraPoFile.actFileLoadExecute(Sender: TObject);

var
    lFilename: string;
begin
    lFilename := edtProjectName.Text;
    if pos(',', cbxSelectLanguage.Text) > 0 then
        lFilename := lFilename + ExtensionSeparator + copy(cbxSelectLanguage.Text,
            pos(',', cbxSelectLanguage.Text) + 1, 4);
    lFilename := lFilename + ExtensionSeparator + 'po';
    if fileexists(FBaseDir + DirectorySeparator + lFilename) then
      begin
        FpoFile.LoadFromFile(FBaseDir + DirectorySeparator + lFilename);
        UpdateUI(Sender);
      end;
end;

procedure TfraPoFile.actFileSaveExecute(Sender: TObject);
var
    lFilename: string;
begin
    lFilename := edtProjectName.Text;
    if pos(',', cbxSelectLanguage.Text) > 0 then
        lFilename := lFilename + ExtensionSeparator + copy(cbxSelectLanguage.Text,
            pos(',', cbxSelectLanguage.Text) + 1, 4);
    lFilename := lFilename + ExtensionSeparator + 'po';
    if fileexists(FBaseDir + DirectorySeparator + lFilename) and
        (MessageDlg('Confirmatione', format(
        'File "%s" exists !\nDo you want to replace it ?', [lFilename]),
        mtConfirmation, mbYesNo, 0) = mrNo) then
        exit;
    lFilename := FBaseDir + DirectorySeparator + lFilename;
    FpoFile.SaveToFile(lFilename);
end;

procedure TfraPoFile.UpdateUI(Sender: TObject);
begin
    edtPoFile.Lines.Assign(FPoFile.Lines);
end;

function TfraPoFile.GetLanguageID: integer;
begin
    Result := cbxSelectLanguage.ItemIndex;
end;

procedure TfraPoFile.SetBaseDir(AValue: string);
begin
    if FBaseDir = AValue then
        Exit;
    FBaseDir := AValue;
end;

constructor TfraPoFile.Create(TheOwner: TComponent);
begin
    inherited Create(TheOwner);
    FPoFile := TPoFile.Create(self);
end;

destructor TfraPoFile.Destroy;
begin
    FreeAndNil(FPoFile);
    inherited Destroy;
end;

procedure TfraPoFile.AppendData(const aIdent: string; const aTrans: TStringArray);
var
    lReference, lTranslStr, lFullindex: string;
begin
    lReference := aIdent;
    lFullindex := aTrans[0];
    if cbxSelectLanguage.ItemIndex > 0 then
        lTranslStr := aTrans[cbxSelectLanguage.ItemIndex - 1]
    else
        lTranslStr := '';
    FPoFile.AppendData(lReference, lFullindex, lTranslStr);
end;

function TfraPoFile.LookUpIdent(const aIdent: string): integer;
begin
    Result := FPoFile.LookUpIdent(aIdent);
end;

function TfraPoFile.LookUpSource(const aIdent: string): integer;
begin
    Result := FPoFile.LookUpSource(aIdent);
end;

function TfraPoFile.GetTranslText(const id: integer): string;
begin
    Result := FPoFile.GetTranslText(id);
end;

end.
