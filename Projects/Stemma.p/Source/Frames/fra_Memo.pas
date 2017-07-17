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
    function GetText: string;
    procedure SetText(AValue: string);

  public
    property text:string read GetText write SetText;
  end;

implementation

uses frm_main;
{$R *.lfm}

{ TfraMemo }

procedure TfraMemo.edtMemoTextEditingDone(Sender: TObject);
begin
  frmStemmaMainForm.AppendHistoryData('M',edtMemoText.Text);
end;

function TfraMemo.GetText: string;
begin
  result := edtMemoText.Text;
end;

procedure TfraMemo.SetText(AValue: string);
begin
  if text = edtMemoText.text then exit;
  edtMemoText.text := text;
end;

end.

