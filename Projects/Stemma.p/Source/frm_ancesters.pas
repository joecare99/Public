unit frm_Ancesters;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, FMUtils, LCLType;

type

  { TFormAncetres }

  TFormAncetres = class(TForm)
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

procedure PopulateAncetres;

var
  FormAncetres: TFormAncetres;

implementation

uses
  frm_Main, Traduction, dm_GenData;

{$R *.lfm}

{ TFormAncetres }

procedure TFormAncetres.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if CloseAction <> caMinimize then
     begin
  SaveFormPosition(Sender as TForm);
     end;
end;

procedure TFormAncetres.ArbreDblClick(Sender: TObject);
var
  naissance,deces:string;
  idInd: Integer;
begin
  if not Arbre.Selected.HasChildren then
  begin
    idInd:=ptrint(Tobject(Arbre.Selected.Data));
    dmGenData.Query1.SQL.Text:='SELECT R.B, N.N, N.I3, N.I4 FROM R JOIN N on R.B=N.I WHERE R.X=1 AND N.X=1 AND R.A=:idInd';
    dmGenData.Query1.ParamByName('idInd').AsInteger:=idInd;
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
       Arbre.Items.AddChildObject(Arbre.Selected,DecodeName(dmGenData.Query1.Fields[1].AsString,1)+
                                                   ' ['+dmGenData.Query1.Fields[0].AsString+'] ('+
                                                   naissance+'-'+deces+')',pointer(Tobject(ptrint(dmGenData.Query1.Fields[0].AsInteger))));
       dmGenData.Query1.Next;
    end;
  end;
  Arbre.Selected.Expand(true);
end;

procedure TFormAncetres.FormResize(Sender: TObject);
begin
  Arbre.Width:=FormAncetres.Width;
  Arbre.Height:=FormAncetres.Height;
end;

procedure TFormAncetres.FormShow(Sender: TObject);
begin
  Caption:=Traduction.Items[146];
  MenuItem1.Caption:=Traduction.Items[222];
  GetFormPosition(Sender as TForm,0,0,200,200);
  PopulateAncetres;
end;

procedure TFormAncetres.MenuItem1Click(Sender: TObject);
begin
  frmStemmaMainForm.iID:=ptrint(Tobject(Arbre.Selected.Data));
end;

procedure PopulateAncetres;
begin
  FormAncetres.Arbre.Items.Clear;
  FormAncetres.Arbre.Items.AddChildObjectFirst(nil,dmGenData.GetIndividuumName(frmStemmaMainForm.iID)+
                                    ' ['+frmStemmaMainForm.sID+']',pointer(Tobject(ptrint(frmStemmaMainForm.iID))));
  FormAncetres.Arbre.Selected:=FormAncetres.Arbre.Items[0];
  FormAncetres.ArbreDblClick(nil);
end;

end.

