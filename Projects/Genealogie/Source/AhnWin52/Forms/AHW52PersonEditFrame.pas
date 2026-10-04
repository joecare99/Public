unit AHW52PersonEditFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LCLType, Forms, Controls, ComCtrls, ExtCtrls, StdCtrls,
  Grids, FileCtrl, DbCtrls, DBGrids, GenealogyDataModule;

type
  TPersonEditTabHostAction = (
  peaTabSheet2Enter,
  peaDBEdit69Change);

  TPersonEditTabHostActionEvent = procedure(Sender: TObject;
    Action: TPersonEditTabHostAction) of object;
  TPersonEditTabFocusRequestEvent = procedure(Sender: TObject;
    Target: TWinControl) of object;

  TAHW52PersonEditFrame = class(TFrame)
  published
    Shape3: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Shape2: TShape;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label28: TLabel;
    Image1: TImage;
    Label3: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label79: TLabel;
    DBText1: TDBText;
    Label80: TLabel;
    Label81: TLabel;
    Edit7: TEdit;
    FileListBox2: TFileListBox;
    FileListBox1: TFileListBox;
    Memo1: TMemo;
    DBNavigator1: TDBNavigator;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    Edit1: TEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit4: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    UpDown1: TUpDown;
    DBEdit69: TDBEdit;
    DBComboBox2: TDBComboBox;
    DBGrid3: TDBGrid;
    DBComboBox3: TDBComboBox;
    ComboBox4: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    Edit11: TEdit;
    StringGrid5: TStringGrid;
    Edit2: TEdit;
    procedure DBNavigator1BeforeAction(Sender: TObject; Button: TDBNavButtonType);
    procedure DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
    procedure DBEdit2Exit(Sender: TObject);
    procedure DBEdit3Exit(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid2DblClick(Sender: TObject);
    procedure DBEdit5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DBEdit6Exit(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure DBEdit7Exit(Sender: TObject);
    procedure DBEdit8Change(Sender: TObject);
    procedure DBEdit8Exit(Sender: TObject);
    procedure DBEdit9Change(Sender: TObject);
    procedure DBEdit9Exit(Sender: TObject);
    procedure DBEdit10Change(Sender: TObject);
    procedure DBEdit10Exit(Sender: TObject);
    procedure DBEdit12Exit(Sender: TObject);
    procedure DBEdit13Exit(Sender: TObject);
    procedure DBEdit14Exit(Sender: TObject);
    procedure DBEdit16Exit(Sender: TObject);
    procedure DBEdit17Exit(Sender: TObject);
    procedure DBEdit18Exit(Sender: TObject);
    procedure DBEdit20Exit(Sender: TObject);
    procedure DBEdit21Exit(Sender: TObject);
    procedure DBEdit22Exit(Sender: TObject);
    procedure DBCheckBox1Exit(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure DBEdit69Change(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure DBGrid3Exit(Sender: TObject);
    procedure DBGrid3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBComboBox3Change(Sender: TObject);
    procedure DBComboBox3Exit(Sender: TObject);
    procedure ComboBox4DblClick(Sender: TObject);
    procedure ComboBox4Exit(Sender: TObject);
    procedure StringGrid5DblClick(Sender: TObject);
    procedure StringGrid5KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StringGrid5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TabSheet2Enter(Sender: TObject);
    procedure TabSheet2Exit(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
  private
    FOnHostAction: TPersonEditTabHostActionEvent;
    FOnNavigatorBeforeAction: TDBNavClickEvent;
    FOnFocusRequest: TPersonEditTabFocusRequestEvent;
    function GetFatherSearchText: string;
    function GetMotherSearchText: string;
    procedure RequestFocus(Target: TWinControl);
  public
    procedure FocusPrimaryField;
    procedure ShowSearchGrid;
    procedure ShowProgress;
    procedure AppendSearchGridRow(const TextCol0, TextCol1: string;
      var RowIndex: Integer);
    property OnHostAction: TPersonEditTabHostActionEvent
      read FOnHostAction write FOnHostAction;
    property OnNavigatorBeforeAction: TDBNavClickEvent
      read FOnNavigatorBeforeAction write FOnNavigatorBeforeAction;
    property OnFocusRequest: TPersonEditTabFocusRequestEvent
      read FOnFocusRequest write FOnFocusRequest;
    property FatherSearchText: string read GetFatherSearchText;
    property MotherSearchText: string read GetMotherSearchText;
  end;

implementation

{$R *.lfm}

function TAHW52PersonEditFrame.GetFatherSearchText: string;
begin
  Result := Edit1.Text;
end;

function TAHW52PersonEditFrame.GetMotherSearchText: string;
begin
  Result := Edit2.Text;
end;

procedure TAHW52PersonEditFrame.RequestFocus(Target: TWinControl);
begin
  if Assigned(FOnFocusRequest) then
    FOnFocusRequest(Self, Target);
end;

procedure TAHW52PersonEditFrame.FocusPrimaryField;
begin
  RequestFocus(DBEdit2);
end;

procedure TAHW52PersonEditFrame.ShowSearchGrid;
begin
  StringGrid5.Show;
end;

procedure TAHW52PersonEditFrame.ShowProgress;
begin
  Label18.Show;
  Label18.Caption := '0 %';
  Label18.Refresh;
  Label19.Show;
  Label19.Refresh;
end;

procedure TAHW52PersonEditFrame.AppendSearchGridRow(const TextCol0,
  TextCol1: string; var RowIndex: Integer);
begin
  Inc(RowIndex);
  StringGrid5.RowCount := StringGrid5.RowCount + 1;
  StringGrid5.Cells[0, RowIndex] := TextCol0;
  StringGrid5.Cells[1, RowIndex] := TextCol1;
end;

procedure TAHW52PersonEditFrame.DBNavigator1BeforeAction(Sender: TObject; Button: TDBNavButtonType);
begin
  if Assigned(FOnNavigatorBeforeAction) then
    FOnNavigatorBeforeAction(Sender, Button);
end;

procedure TAHW52PersonEditFrame.DBNavigator1Click(Sender: TObject; Button: TDBNavButtonType);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit2Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit3Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.StringGrid1DblClick(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.StringGrid2DblClick(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit6Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.Edit1DblClick(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit7Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit8Change(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit8Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit9Change(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit9Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit10Change(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit10Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit12Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit13Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit14Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit16Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit17Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit18Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit20Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit21Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit22Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBCheckBox1Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
end;

procedure TAHW52PersonEditFrame.DBEdit69Change(Sender: TObject);
begin
  if Assigned(FOnHostAction) then
    FOnHostAction(Sender, peaDBEdit69Change);
end;

procedure TAHW52PersonEditFrame.DBGrid3DblClick(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBGrid3Exit(Sender: TObject);
begin
  DBGrid3.Visible := False;
  Label81.Visible := False;
  RequestFocus(DBComboBox3);
end;

procedure TAHW52PersonEditFrame.DBGrid3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    DBComboBox3.Text := '';
    DBGrid3.Visible := False;
    Label81.Visible := False;
    RequestFocus(DBComboBox3);
  end;
end;

procedure TAHW52PersonEditFrame.DBComboBox3Change(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.DBComboBox3Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.ComboBox4DblClick(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.ComboBox4Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.StringGrid5DblClick(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.StringGrid5KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    StringGrid5.Visible := False;
end;

procedure TAHW52PersonEditFrame.StringGrid5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TAHW52PersonEditFrame.TabSheet2Enter(Sender: TObject);
begin
  if Assigned(FOnHostAction) then
    FOnHostAction(Sender, peaTabSheet2Enter);
end;

procedure TAHW52PersonEditFrame.TabSheet2Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonEditFrame.TabSheet2Show(Sender: TObject);
begin
  FocusPrimaryField;
end;

end.
