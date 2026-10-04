unit AHW52PersonDetailsFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Forms, StdCtrls, ExtCtrls, DBCtrls,
  GenealogyDataModule;

type
  TPersonDetailsTabHostAction = (
    pdaComboBox5Change);

  TPersonDetailsTabHostActionEvent = procedure(Sender: TObject;
    HostAction: TPersonDetailsTabHostAction) of object;

  TAHW52PersonDetailsFrame = class(TFrame)
  published
    Label35: TLabel;
    Label41: TLabel;
    Label63: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label52: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label60: TLabel;
    Label59: TLabel;
    Label58: TLabel;
    Label57: TLabel;
    Label50: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label49: TLabel;
    Label48: TLabel;
    Shape4: TShape;
    Shape5: TShape;
    DBText2: TDBText;
    Label68: TLabel;
    Label53: TLabel;
    Label99: TLabel;
    Edit32: TEdit;
    DBEdit25: TDBEdit;
    DBEdit57: TDBEdit;
    DBEdit56: TDBEdit;
    DBEdit55: TDBEdit;
    DBEdit60: TDBEdit;
    DBEdit52: TDBEdit;
    DBEdit51: TDBEdit;
    DBEdit50: TDBEdit;
    DBEdit59: TDBEdit;
    DBEdit49: TDBEdit;
    DBEdit48: TDBEdit;
    DBEdit47: TDBEdit;
    DBEdit44: TDBEdit;
    DBEdit43: TDBEdit;
    DBEdit42: TDBEdit;
    DBEdit26: TDBEdit;
    DBEdit40: TDBEdit;
    DBComboBox7: TDBComboBox;
    DBCheckBox2: TDBCheckBox;
    DBEdit31: TDBEdit;
    Edit30: TEdit;
    Edit15: TEdit;
    Panel1: TPanel;
    Label64: TLabel;
    ComboBox5: TComboBox;
    DBEdit32: TDBEdit;
    DBEdit33: TDBEdit;
    ComboBox1: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox12: TComboBox;
    ComboBox13: TComboBox;
    ComboBox14: TComboBox;
    ComboBox15: TComboBox;
    ComboBox16: TComboBox;
    ComboBox17: TComboBox;
    ComboBox18: TComboBox;
    ComboBox19: TComboBox;
    DBEdit19: TDBEdit;
    procedure TabSheet3Enter(Sender: TObject);
    procedure TabSheet3Exit(Sender: TObject);
    procedure DBEdit55Exit(Sender: TObject);
    procedure DBEdit52Exit(Sender: TObject);
    procedure DBEdit47Exit(Sender: TObject);
    procedure DBEdit44Exit(Sender: TObject);
    procedure DBEdit40Exit(Sender: TObject);
    procedure DBComboBox7Exit(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox5Exit(Sender: TObject);
    procedure DBEdit32Exit(Sender: TObject);
    procedure DBEdit33Exit(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox10Exit(Sender: TObject);
    procedure ComboBox11Exit(Sender: TObject);
    procedure ComboBox12Exit(Sender: TObject);
    procedure ComboBox13Exit(Sender: TObject);
    procedure ComboBox14Exit(Sender: TObject);
    procedure ComboBox15Exit(Sender: TObject);
    procedure ComboBox16Exit(Sender: TObject);
    procedure ComboBox17Exit(Sender: TObject);
    procedure ComboBox18Exit(Sender: TObject);
    procedure ComboBox19Exit(Sender: TObject);
    procedure DBEdit19Exit(Sender: TObject);
  private
    FOnHostAction: TPersonDetailsTabHostActionEvent;
    procedure DispatchHostAction(Sender: TObject;
      HostAction: TPersonDetailsTabHostAction);
  public
    property OnHostAction: TPersonDetailsTabHostActionEvent
      read FOnHostAction write FOnHostAction;
  end;

implementation

{$R *.lfm}

procedure TAHW52PersonDetailsFrame.DispatchHostAction(Sender: TObject;
  HostAction: TPersonDetailsTabHostAction);
begin
  if Assigned(FOnHostAction) then
    FOnHostAction(Sender, HostAction);
end;

procedure TAHW52PersonDetailsFrame.TabSheet3Enter(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.TabSheet3Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.DBEdit55Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.DBEdit52Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.DBEdit47Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.DBEdit44Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.DBEdit40Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.DBComboBox7Exit(Sender: TObject);
begin
  if Trim(DBComboBox7.Text) <> '' then
    DataModule2.Table1Religion.AsString := DBComboBox7.Text;
end;

procedure TAHW52PersonDetailsFrame.ComboBox5Change(Sender: TObject);
begin
  DispatchHostAction(Sender, pdaComboBox5Change);
end;

procedure TAHW52PersonDetailsFrame.ComboBox5Exit(Sender: TObject);
begin
  if Pos('heschl', ComboBox5.Text) > 0 then
    ComboBox5.Text := 'Eheschliessung';

  if Pos('dere Bez', ComboBox5.Text) > 0 then
    ComboBox5.Text := 'andere Beziehung';
end;

procedure TAHW52PersonDetailsFrame.DBEdit32Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.DBEdit33Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox1Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox1KeyPress(Sender: TObject;
  var Key: Char);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox10Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox11Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox12Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox13Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox14Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox15Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox16Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox17Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox18Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.ComboBox19Exit(Sender: TObject);
begin
end;

procedure TAHW52PersonDetailsFrame.DBEdit19Exit(Sender: TObject);
begin
end;

end.
