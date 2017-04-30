unit LevInfoUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  StdCtrls, Forms, Controls, Classes;

type
  TfrmLevInfo = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    LevName: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    LevCopyright: TLabel;
    Label8: TLabel;
    LevMail: TLabel;
    DescMem: TMemo;
    procedure Button1Click(Sender: TObject);
  end;

var
  frmLevInfo: TfrmLevInfo;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmLevInfo.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
