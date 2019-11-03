unit Frm_TestExpFileInt;

interface

uses
  SysUtils, Types, Classes, Variants,cmp_SewFile,
  Controls, Forms, Dialogs,
  {$IFNDEF FMx}

    ComCtrls, StdCtrls, ExtCtrls, Buttons
{$ELSE}
  Memo,
  Edit,
  ListBox
  {$ENDIF}
;

type
  TfrmTestExpComp = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmTestExpComp: TfrmTestExpComp;

implementation

{$R *.dfm}

procedure TfrmTestExpComp.Button1Click(Sender: TObject);
 VAR ParseMode: TParseMode ;
     indent :integer;
begin
  Indent := 4;
  Parsemode := psm_normal;
  cmp_SewFile.Push(psm_Normal, 0);
  memo1.Lines.Add(cmp_SewFile.FormatCode(Edit1.Text,indent,Parsemode ) );
end;

end.
