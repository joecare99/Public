unit Frm_ObjListMAIN;

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
  SysUtils,  Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    OnOffButton: TButton;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OnOffButtonClick(Sender: TObject);
  private
    { Private declarations }
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
  numCheckBoxes = 6;

type
  PObjectArray = ^TObjectArray;
  TObjectArray = array[0..65520 div SizeOf(TObject)] of TObject;

var
  CheckBoxArray: PObjectArray;  { Pointer to array of CheckBoxes }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  GetMem(CheckBoxArray, numCheckBoxes * SizeOf(TObject));
  CheckBoxArray^[0] := CheckBox1;
  CheckBoxArray^[1] := CheckBox2;
  CheckBoxArray^[2] := CheckBox3;
  CheckBoxArray^[3] := CheckBox4;
  CheckBoxArray^[4] := CheckBox5;
  CheckBoxArray^[5] := CheckBox6;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeMem(CheckBoxArray, numCheckBoxes * SizeOf(TObject));
end;

procedure TMainForm.OnOffButtonClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to numCheckBoxes - 1 do
    with CheckBoxArray^[I] as TCheckBox do
      Enabled := not Enabled;
end;

end.
