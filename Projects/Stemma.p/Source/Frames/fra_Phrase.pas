unit fra_Phrase;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls;

type

    { TfraPhrase }

    TfraPhrase = class(TFrame)
        lblPhrase: TLabel;
        lblPhraseDefault: TLabel;
        edtPhrase: TMemo;
        pnlPhraseLeft: TPanel;
        procedure edtPhraseDblClick(Sender: TObject);
        procedure edtPhraseEditingDone(Sender: TObject);
    private
        FFullPhrase: string;
        FidLink: integer;
        FText: string;
        FtfVisible: boolean;
        FTypeCode: string;
        FTypePhrase: string;
        FWType: string;
        function GetIsDefault: boolean;
        procedure SetFullPhrase(AValue: string);
        procedure SetidLink(AValue: integer);
        procedure SetIsDefault(AValue: boolean);
        procedure SetText(AValue: string);
        procedure SetTypeCode(AValue: string);
        procedure SetTypePhrase(AValue: string);
        procedure SetWType(AValue: string);

    public
        procedure Clear;
        property isDefault: boolean read GetIsDefault write SetIsDefault;
        property Text: string read FText write SetText;
        property TypePhrase: string read FTypePhrase write SetTypePhrase;
        property FullPhrase: string read FFullPhrase write SetFullPhrase;
        property WType: string read FWType write SetWType;
        property TypeCode: string read FTypeCode write SetTypeCode;
        property idLink: integer read FidLink write SetidLink;
    end;

implementation

uses Graphics, FMUtils, frm_main;

{$R *.lfm}

{ TfraPhrase }

procedure TfraPhrase.edtPhraseDblClick(Sender: TObject);
begin
    FtfVisible := not FtfVisible;
    edtPhrase.ReadOnly := FtfVisible;
    if FtfVisible then
      begin
        Ftext := edtPhrase.Text;
        edtPhrase.Text := FFullPhrase;
      end
    else
        edtPhrase.Text := FText;
end;

procedure TfraPhrase.edtPhraseEditingDone(Sender: TObject);
begin
    if length(edtPhrase.Text) = 0 then
        FText := FTypePhrase
    else
        Ftext := edtPhrase.Text;
    isDefault := (FText = FTypePhrase);
    FFullPhrase := DecodePhrase(frmStemmaMainForm.iID, FWType, FText, FTypeCode, FidLink);
    frmStemmaMainForm.AppendHistoryData('P', Ftext);
end;

function TfraPhrase.GetIsDefault: boolean;
begin
    Result := lblPhraseDefault.Visible;
end;

procedure TfraPhrase.SetFullPhrase(AValue: string);
begin
    if FFullPhrase = AValue then
        Exit;
    FFullPhrase := AValue;
end;

procedure TfraPhrase.SetidLink(AValue: integer);
begin
    if FidLink = AValue then
        Exit;
    FidLink := AValue;
end;

procedure TfraPhrase.SetIsDefault(AValue: boolean);
begin
    if lblPhraseDefault.Visible = AValue then
        exit;
    lblPhraseDefault.Visible := AValue;
    if lblPhraseDefault.Visible then
      begin
        edtPhrase.ParentFont := False;
        edtPhrase.Font.Color := clDkGray;
      end
    else
        edtPhrase.ParentFont := True;
end;

procedure TfraPhrase.SetText(AValue: string);
begin
    if FText = AValue then
        Exit;
    FText := AValue;
    edtPhrase.Hint := AValue;
    if lblPhraseDefault.Visible then
      begin
        edtPhrase.ParentFont := False;
        edtPhrase.Font.Color := clDkGray;
      end
    else
        edtPhrase.ParentFont := True;
end;

procedure TfraPhrase.SetTypeCode(AValue: string);
begin
    if FTypeCode = AValue then
        Exit;
    FTypeCode := AValue;
end;

procedure TfraPhrase.SetTypePhrase(AValue: string);
begin
    if FTypePhrase = AValue then
        Exit;
    FTypePhrase := AValue;
end;

procedure TfraPhrase.SetWType(AValue: string);
begin
    if FWType = AValue then
        Exit;
    FWType := AValue;
end;

procedure TfraPhrase.Clear;
begin
    FText := '';
    FTypePhrase:='';
    FFullPhrase:='';
    FidLink:=0;
    edtPhrase.Text := '';
end;

end.
