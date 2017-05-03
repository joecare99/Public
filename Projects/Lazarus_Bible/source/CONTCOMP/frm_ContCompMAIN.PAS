unit frm_ContCompMAIN;

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
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    ScrollBoxComponents: TListBox;
    ScrollBoxControls: TListBox;
    FormComponents: TListBox;
    FormControls: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CloseBitBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
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

procedure ListControls(ListBox: TListBox; Control: TWinControl);
var
  I: Integer;
begin
  with Control do
  for I := 0 to ControlCount - 1 do
    ListBox.Items.Add(Controls[I].Name);
end;

procedure ListComponents(ListBox: TListBox; Component: TComponent);
var
  I: Integer;
begin
  with Component do
  for I := 0 to ComponentCount - 1 do
    ListBox.Items.Add(Components[I].Name);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ListControls(ScrollBoxControls, ScrollBox1);
  ListComponents(ScrollBoxComponents, ScrollBox1);
  ListControls(FormControls, MainForm);
  ListComponents(FormComponents, MainForm);
end;

end.
