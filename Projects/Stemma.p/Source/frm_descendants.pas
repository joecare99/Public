unit frm_Descendants;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, FMUtils;

type

  { TFormDescendants }

  TFormDescendants = class(TForm)
    Arbre: TTreeView;
    MenuItem1: TMenuItem;
    PopupMenuParent: TPopupMenu;
    procedure ArbreDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

procedure PopulateDescendants;

var
  FormDescendants: TFormDescendants;

implementation

uses
  frm_Main, cls_Translation, dm_GenData;

{$R *.lfm}

{ TFormDescendants }

procedure TFormDescendants.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if CloseAction <> caMinimize then
     begin
  dmGenData.WriteCfgFormPosition(self);
     end;
end;

procedure TFormDescendants.ArbreDblClick(Sender: TObject);
var
  no,naissance,deces:string;
begin
  if not Arbre.Selected.HasChildren then
  begin
    no:=Copy(Arbre.Selected.Text,AnsiPos('[',Arbre.Selected.Text)+1,AnsiPos(']',Arbre.Selected.Text)-AnsiPos('[',Arbre.Selected.Text)-1);
    dmGenData.Query1.SQL.Text:='SELECT R.A, N.N, N.I3, N.I4 FROM R JOIN N on R.A=N.I WHERE R.X=1 AND N.X=1 AND R.B='
                              +no+' ORDER BY N.I3';
    dmGenData.Query1.Open;
    dmGenData.Query1.First;
    while not dmGenData.Query1.EOF do
       begin
       if Copy(dmGenData.Query1.Fields[2].AsString,1,1)='1' then
          naissance:=Copy(dmGenData.Query1.Fields[2].AsString,2,4)
       else
          naissance:='';
       if Copy(dmGenData.Query1.Fields[3].AsString,1,1)='1' then
          deces:=Copy(dmGenData.Query1.Fields[3].AsString,2,4)
       else
          deces:='';
       Arbre.Items.AddChild(Arbre.Selected,DecodeName(dmGenData.Query1.Fields[1].AsString,1)+
                                                   ' ['+dmGenData.Query1.Fields[0].AsString+'] ('+
                                                   naissance+'-'+deces+')');
       dmGenData.Query1.Next;
    end;
  end;
  Arbre.Selected.Expand(true);
end;

procedure TFormDescendants.FormResize(Sender: TObject);
begin
  Arbre.Width:=FormDescendants.Width;
  Arbre.Height:=Formdescendants.Height;
end;

procedure TFormDescendants.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[159];
  MenuItem1.Caption:=Translation.Items[222];
  dmGenData.ReadCfgFormPosition(Sender as TForm,0,0,200,200);
  PopulateDescendants;
end;

procedure TFormDescendants.MenuItem1Click(Sender: TObject);
begin
  frmStemmaMainForm.sID:=Copy(Arbre.Selected.Text,AnsiPos('[',Arbre.Selected.Text)+1,
                                    AnsiPos(']',Arbre.Selected.Text)-AnsiPos('[',Arbre.Selected.Text)-1);
end;

procedure PopulateDescendants;
begin
  dmGenData.Query1.SQL.Text:='SELECT N FROM N WHERE X=1 AND I='+frmStemmaMainForm.sID;
  dmGenData.Query1.open;
  FormDescendants.Arbre.Items.Clear;
  FormDescendants.Arbre.Items.AddFirst(nil,DecodeName(dmGenData.Query1.Fields[0].AsString,1)+
                                    ' ['+frmStemmaMainForm.sID+']');
  dmGenData.Query1.SQL.Clear;
  FormDescendants.Arbre.Selected:=Formdescendants.Arbre.Items[0];
  FormDescendants.ArbreDblClick(nil);
end;


end.

