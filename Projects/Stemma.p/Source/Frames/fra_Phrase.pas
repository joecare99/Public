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
  private
    FText: String;
    function GetIsDefault: boolean;
    procedure SetIsDefault(AValue: boolean);
    procedure SetText(AValue: String);

  public
    Procedure Clear;
    Property isDefault:boolean read GetIsDefault write SetIsDefault;
    Property Text:String read FText write SetText;
  end;

implementation

uses graphics;
{$R *.lfm}

{ TfraPhrase }

procedure TfraPhrase.edtPhraseDblClick(Sender: TObject);
begin
  P.Visible := True;
  P2.Visible := False;
end;

function TfraPhrase.GetIsDefault: boolean;
begin
  Result:=lblPhraseDefault.Visible;
end;

procedure TfraPhrase.SetIsDefault(AValue: boolean);
begin
  if lblPhraseDefault.Visible=AValue then exit;
  lblPhraseDefault.Visible:=AValue;
  if lblPhraseDefault.Visible then
    begin
      edtPhrase.ParentFont:=false;
      edtPhrase.Font.Color:=clDkGray;
    end
  else
    edtPhrase.ParentFont:=true;
end;

procedure TfraPhrase.SetText(AValue: String);
begin
  if FText=AValue then Exit;
  FText:=AValue;
  edtPhrase.Hint:=AValue;
  if lblPhraseDefault.Visible then
    begin
      edtPhrase.ParentFont:=false;
      edtPhrase.Font.Color:=clDkGray;
    end
  else
    edtPhrase.ParentFont:=true;
end;

procedure TfraPhrase.Clear;
begin
  FText:='';
  edtPhrase.Text:='';
end;

end.

