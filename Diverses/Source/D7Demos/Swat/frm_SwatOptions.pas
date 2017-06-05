unit frm_SwatOptions;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,  Messages,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons;

type

  { TfrmSwatOptionDlg }

  TfrmSwatOptionDlg = class(TForm)
    btnOK: TBitBtn;
    bvlValues: TBevel;
    CancelBtn: TBitBtn;
    lblSlow: TLabel;
    lblFast: TLabel;
    lblLow: TLabel;
    lblHigh: TLabel;
    lblSpeed: TLabel;
    lblPopulation: TLabel;
    lblGameTime: TLabel;
    pnlRight: TPanel;
    SpeedSet: TTrackBar;
    PopulationSet: TTrackBar;
    GameTimeSet: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSwatOptionDlg: TfrmSwatOptionDlg;

implementation

uses frm_SwatMain;

{$IFDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.dfm}
{$ENDIF}

procedure TfrmSwatOptionDlg.btnOKClick(Sender: TObject);
begin
  frmSwatMain.LiveTime := SpeedSet.Max + 1 - SpeedSet.Position;
  frmSwatMain.Frequence := PopulationSet.Position;
  frmSwatMain.GameTime := StrToInt(GameTimeSet.Text);

  // limit the value of GameTime to a reasonable length
  if (frmSwatMain.GameTime < 1) then
    frmSwatMain.GameTime := 150;
  if (frmSwatMain.GameTime > 9999) then
    frmSwatMain.GameTime := 9999;
end;

procedure TfrmSwatOptionDlg.FormShow(Sender: TObject);
begin
  SpeedSet.Position := SpeedSet.Max + 1 - frmSwatMain.LiveTime;
  PopulationSet.Position := frmSwatMain.Frequence;
  GameTimeSet.Text := inttoStr(frmSwatMain.GameTime);
end;

end.
