unit Frm_CalcABOUT;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type

  { TfrmCalcAbout }

  TfrmCalcAbout = class(TForm)
    Panel1: TPanel;
    OKButton: TBitBtn;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure VersionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCalcAbout: TfrmCalcAbout;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ TfrmCalcAbout }

procedure TfrmCalcAbout.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCalcAbout.VersionClick(Sender: TObject);
begin

end;

end.
 
