unit Frm_PageTabMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, DateTimePicker,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons;

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    TabControl1: TTabControl;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    BitBtn1: TBitBtn;
    TabSheet3: TTabSheet;
    DateTimePicker1: TDateTimePicker;
    Button2: TButton;
    RadioButton3: TRadioButton;
    Button1: TButton;
    procedure TabControl1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

procedure TMainForm.TabControl1Change(Sender: TObject);
var
  S: String;
begin
  S := IntToStr(TabControl1.TabIndex + 1);
  Edit1.Text := 'Edit1 Tab ' + S;
  Edit2.Text := 'Edit2 Tab ' + S;
  Edit3.Text := 'Edit3 Tab ' + S;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet3;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
end;

end.
