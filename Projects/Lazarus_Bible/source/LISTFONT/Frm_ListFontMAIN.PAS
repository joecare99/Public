unit Frm_ListFontMAIN;

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
  Forms, Dialogs, StdCtrls, Spin, Buttons, ExtCtrls;

type
  TMainForm = class(TForm)
    FontListBox: TListBox;
    Label1: TLabel;
    SampleLabel: TLabel;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    FontNameLabel: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    CloseBitBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FontListBoxDblClick(Sender: TObject);
    procedure FontListBoxKeyDown(Sender: TObject; var Key: Word;
      {%H-}Shift: TShiftState);
    procedure SpinEdit1Change(Sender: TObject);
    procedure CloseBitBtnClick(Sender: TObject);
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

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FontListBox.Items := Screen.Fonts;
end;

procedure TMainForm.FontListBoxDblClick(Sender: TObject);
begin
  with FontListBox do
  if ItemIndex >= 0 then
  begin
    SampleLabel.Font.Name := FontListBox.Items[ItemIndex];
    FontNameLabel.Caption := SampleLabel.Font.Name;
  end;
end;

procedure TMainForm.FontListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_RETURN, VK_SPACE] then
    FontListBoxDblClick(Sender);
end;

procedure TMainForm.SpinEdit1Change(Sender: TObject);
begin
  SampleLabel.Font.Size := SpinEdit1.Value;
end;

procedure TMainForm.CloseBitBtnClick(Sender: TObject);
begin
  Close;
end;

end.

