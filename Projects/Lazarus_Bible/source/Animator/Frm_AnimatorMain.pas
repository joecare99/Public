Unit Frm_AnimatorMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,CmpAnimator,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

Type
  TMainForm = Class(TForm)
    Animate1: TAnimate;
    RadioGroup1: TRadioGroup;
    GoBitBtn: TBitBtn;
    StopBitBtn: TBitBtn;
    BitBtn1: TBitBtn;
    StatusText: TStaticText;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    Procedure GoBitBtnClick(Sender: TObject);
    Procedure StopBitBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  End;

Var
  MainForm: TMainForm;

Implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ Define array types for easier assignments of the
  Animate object's CommonAvi property, and also the
  StatusText object that shows which animation is running. }
Type

  aviStringArray = Array[TCommonAvi] Of String;

{ Define constant arrays containing the TCommonAvi values
  in the same order they appear in the RadioGroup object,
  and also strings for displaying in the StatusText object
  that shows which animation is running. }
Const

  aviStrings: aviStringArray =
  ('aviNone',
    'aviFindFolder',
    'aviFindFile',
    'aviFindComputer',
    'aviCopyFiles',
    'aviCopyFile',
    'aviRecycleFile',
    'aviEmptyRecycle',
    'aviDeleteFile' );

{ Start selected animation. This event handler is assigned
  to the OnClick event for both the Go button and the
  RadioGroup1. Clicking Go or clicking a radio button starts
  the animation immediately. }

procedure TMainForm.FormCreate(Sender: TObject);

var i:TcommonAvi;
begin
  RadioGroup1.Items.Clear;
  for I := low(TcommonAvi) to high(TcommonAvi) do
    RadioGroup1.Items.Add(avistrings[i]);
  RadioGroup1.ItemIndex:=0; 
end;

Procedure TMainForm.GoBitBtnClick(Sender: TObject);
Var
  AnimIndex: TCommonAvi; // Index of selected animation
Begin
  AnimIndex := TCommonAvi(radioGroup1.ItemIndex);
  With Animate1 Do
    Begin
      StatusText.Caption := aviStrings[AnimIndex];
      CommonAVI := AnimIndex;
      if animindex<>avinone then
        Play(1, FrameCount, 0); // Start the animation
    End;
End;

{ Halt the animation when user clicks the Stop button. }

Procedure TMainForm.StopBitBtnClick(Sender: TObject);
Begin
  Animate1.Stop;
  StatusText.Caption := '(stopped)';
End;

End.

