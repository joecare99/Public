unit Frm_SpinButtonMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Spin, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
  {$IFNDEF FPC}
    UpDown1: TSpinButton;
   {$ELSE}
    UpDown1: TUpDown;
   {$ENDIF}
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit: TLabel;
    SpinLabel: TLabel;
    BitBtn1: TBitBtn;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure UpDown1DownClick(Sender: TObject);
    procedure UpDown1UpClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SetSpinButtonCaption;
    procedure UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
  private
    { Private declarations }
    Count: Integer;
    procedure ResetCount;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  minCount = -99;
  maxCount = 99;

procedure TMainForm.SetSpinButtonCaption;
begin
  {$IFnDEF FPC}
  SpinLabel.Caption := IntToStr(Count);
  {$ELSE}
  SpinLabel.Caption := IntToStr(UpDown1.Position);
  {$ENDIF}
end;

procedure TMainForm.ResetCount;
begin
  {$IFnDEF FPC}
  Count := 0;
  {$ELSE}
  UpDown1.Position := 0;
  {$ENDIF}
end;

procedure TMainForm.UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  SetSpinButtonCaption;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ResetCount;
end;

procedure TMainForm.UpDown1DownClick(Sender: TObject);
begin
  if Count > minCount then Dec(Count);
  SetSpinButtonCaption;
end;

procedure TMainForm.UpDown1UpClick(Sender: TObject);
begin
  if Count < maxCount then Inc(Count);
  SetSpinButtonCaption;
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
  ResetCount;
  SetSpinButtonCaption;
end;

end.

