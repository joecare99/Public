unit fra_PicPasFile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons, ActnList,
  unt_PicPasFile;

type

  { TfraPicPasFile }

  TfraPicPasFile = class(TFrame)
    actFileOpenPas: TAction;
    actFileSavePas: TAction;
    Action3: TAction;
    ActionList1: TActionList;
    btnFileOpenPas: TSpeedButton;
    btnFileSavePas: TSpeedButton;
    cbxSelectFile: TComboBox;
    edtPasFile: TMemo;
    Label1: TLabel;
    pnlLeftTop: TPanel;
    procedure actFileOpenPasExecute(Sender: TObject);
    procedure actFileOpenPasUpdate(Sender: TObject);
    procedure actFileSavePasExecute(Sender: TObject);
    procedure actFileSavePasUpdate(Sender: TObject);
    procedure cbxSelectFileClick(Sender: TObject);
    procedure edtPasFileClick(Sender: TObject);
    procedure edtPasFileKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure UpdateUI(Sender: TObject);
  private
    FBaseDir: string;
    FDirty: Boolean;
    FPasFilename: String;
    FPicPasFile: TPicPasFile;
    procedure DoUpdateUI({%H-}Data: PtrInt);
    function GetExpCount: integer;
    function GetTranslation(IdTrans, IdLang: integer): String;
    procedure SetBaseDir(AValue: string);
    procedure SetTranslation(IdTrans, IdLang: integer; AValue: String);
    procedure UpdateCaretPos;
    procedure UpdateCombobox(Sender: TObject);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    function GetIdentifyer(Index:integer):String;
    property Translation[IdTrans,IdLang:integer]:String read GetTranslation write SetTranslation;
    property PicPasFile: TPicPasFile read FPicPasFile;
    property Count:integer read GetExpCount;
    property BaseDir: string read FBaseDir write SetBaseDir;
  end;

implementation

uses Dialogs,LConvEncoding,Unt_FileProcs;

{$R *.lfm}

{ TfraPicPasFile }

procedure TfraPicPasFile.actFileOpenPasExecute(Sender: TObject);
  begin
      if FPicPasFile.Changed then
          case MessageDlg('File changed, Save ?',mtConfirmation,[mbYes,mbNo,mbCancel],0) of
             mrYes: actFileSavePas.Execute;
             mrCancel:exit;
          end;

      FPasFilename := FBaseDir + DirectorySeparator + cbxSelectFile.Text;
      if FileExists(FPasFilename) then;
        begin
          FPicPasFile.LoadFromFile(FPasFilename);
          UpdateUI(Sender);
        end;
end;

procedure TfraPicPasFile.actFileOpenPasUpdate(Sender: TObject);
begin
      actFileOpenPas.Enabled := DirectoryExists(FBaseDir);
end;

procedure TfraPicPasFile.actFileSavePasExecute(Sender: TObject);
begin
  saveFile(@FPicPasFile.SaveToFile,FPasFilename);
end;

procedure TfraPicPasFile.actFileSavePasUpdate(Sender: TObject);
begin
  actFileSavePas.Enabled := DirectoryExists(FBaseDir) and FPicPasFile.Changed;
end;

procedure TfraPicPasFile.cbxSelectFileClick(Sender: TObject);
begin
  if cbxSelectFile.ItemIndex>=0 then
    actFileOpenPas.Execute;
end;

procedure TfraPicPasFile.UpdateCombobox(Sender: TObject);
var
    sResult: longint;
    sr: TSearchRec;
begin
    if DirectoryExists(FBaseDir) then
      begin
        cbxSelectFile.Clear;
        sResult := Findfirst(FBaseDir + DirectorySeparator +
            '*.pas', faAnyFile - faDirectory, sr);
        while sResult = 0 do
          begin
            cbxSelectFile.AddItem(sr.Name, nil);
            sResult := FindNext(sr);
          end;
        if cbxSelectFile.ItemIndex<0 then
          cbxSelectFile.ItemIndex:=0;
      end;
end;

procedure TfraPicPasFile.edtPasFileClick(Sender: TObject);
begin
  UpdateCaretPos;
end;

procedure TfraPicPasFile.edtPasFileKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateCaretPos;
end;

procedure TfraPicPasFile.UpdateUI(Sender: TObject);
begin
  edtPasFile.Lines.Assign(FPicPasFile.Lines);
  FDirty:=false;;
end;

procedure TfraPicPasFile.DoUpdateUI(Data: PtrInt);

begin
  UpdateUI(Self);
end;

function TfraPicPasFile.GetExpCount: integer;
begin
  result := FPicPasFile.TranslCount;
end;

function TfraPicPasFile.GetTranslation(IdTrans, IdLang: integer): String;
begin
  Result := FPicPasFile.Translation[IdTrans,IdLang];
end;

procedure TfraPicPasFile.SetBaseDir(AValue: string);
begin
  if FBaseDir=AValue then Exit;
  FBaseDir:=AValue;
  UpdateCombobox(Self);
end;

procedure TfraPicPasFile.SetTranslation(IdTrans, IdLang: integer; AValue: String
  );
begin
  FPicPasFile.Translation[IdTrans,IdLang] := AValue;
end;

procedure TfraPicPasFile.UpdateCaretPos;
begin
  label1.Caption := format('(%d;%d) %d', [edtPasFile.CaretPos.x,
      edtPasFile.CaretPos.y, ptrint(edtPasFile.Lines.Objects[
        edtPasFile.CaretPos.y])]);
end;

constructor TfraPicPasFile.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FPicPasFile:=TPicPasFile.create(self);
end;

destructor TfraPicPasFile.Destroy;
begin
  FreeAndNil(FPicPasFile);
  inherited Destroy;
end;

function TfraPicPasFile.GetIdentifyer(Index: integer): String;
begin
  result := FPicPasFile.GetIdentifyer(Index);
end;

end.

