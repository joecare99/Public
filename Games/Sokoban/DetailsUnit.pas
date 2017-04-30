unit DetailsUnit;

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
  SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TfrmGameDetails = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    LevelWidthLab: TLabel;
    LevHeightLab: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    StoreLab: TLabel;
    Label7: TLabel;
    CratesLab: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    MovesLab: TLabel;
    PushesLab: TLabel;
  end;

var
  frmGameDetails: TfrmGameDetails;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

end.
