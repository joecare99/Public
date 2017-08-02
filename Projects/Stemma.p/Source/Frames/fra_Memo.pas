unit fra_Memo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, StdCtrls;

type

  { TfraMemo }

  TfraMemo = class(TFrame)
    lblMemo: TLabel;
    edtMemoText: TMemo;
    pnlMemoLeft: TPanel;
    procedure edtMemoTextEditingDone(Sender: TObject);
  private
    function GetCaption: string;
    function GetText: string;
    procedure SetCaption(AValue: string);
    procedure SetText(AValue: string);
  public
    property text:string read GetText write SetText;
    property caption:string read GetCaption write SetCaption;
  end;

implementation

uses frm_main;
{$R *.lfm}

{ TfraMemo }

procedure TfraMemo.edtMemoTextEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.AppendHistoryData('M',edtMemoText.Text);
end;

function TfraMemo.GetCaption: string;
begin
  result := lblMemo.Caption;
end;

function TfraMemo.GetText: string;
begin
  result := edtMemoText.Text;
end;

procedure TfraMemo.SetCaption(AValue: string);
begin
  if lblMemo.Caption = AValue then exit;
  lblMemo.Caption := AValue;
end;

procedure TfraMemo.SetText(AValue: string);
begin
  if AValue = edtMemoText.text then exit;
  edtMemoText.text := AValue;
end;

end.

