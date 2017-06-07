unit UserVerwaltung;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,LogUnit,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrm_FormEinst = class(TForm)
    TreeView1: TTreeView;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;



type
  TUserLevChange = Function (Sender:TObject;OldLev,NewLev:Integer):boolean of Object;
  TUser = class(TComponent)
  private
    { Private-Deklarationen }
    AktUserlevel:integer;
    UName,
    DBName,
    Table:packed array[0..255] of char;
    ChULev_Enable:Boolean;

    Proc_ChngeULevel:TUserLevChange;
    Proc_OnLog:TLogEvent;

  protected
    { Protected-Deklarationen }

    Procedure SetUserLevel(NewValue:Integer);

    Function GetUsername:string;

  public
    { Public-Deklarationen }
    Constructor Create(DatenbankName :PChar; TabellenName :PChar);
    procedure Login;
    Procedure Show;

    Procedure SetUserRights(CForm:TForm);
    // Setzt Benutzespezifizierte Rechte auf dem Angegebenen Form
    // Über Zuordnung User(level oder Gruppe) -> (Visible,Enabled);

    Procedure EditUserRights(CForm:TForm);
    // Setzt Benutzespezifizierte Rechte auf dem Angegebenen Form
    // Über Zuordnung User(level oder Gruppe) -> (Visible,Enabled);

  published
    { Published-Deklarationen }
    property Level:integer read aktUserlevel write SetUserlevel;
    property UserName:String read GetUsername;
    property OnUserChanged:TUserLevChange  read Proc_ChngeULevel write Proc_ChngeULevel;
    property Onlog:TLogEvent read Proc_OnLog write Proc_OnLog;

  end;

procedure Register;

var Frm_FormEinst:TFrm_FormEinst;
var User:TUser;

implementation

{$R *.DFM}


{******************************************************************************
*  Funktion UserDlgShow
*
*  Beschreibung:      Funktion öffnet den Dialog zur Benutzerverwaltung
*                     Benutzer hinzufügen, bearbeiten, löschen
*
*  Übergabeparameter: DatenbankName: Datenbankverzeichnis bzw. Aliasname
*                     TabellenName : Name der User-Tabelle
*                     AktPwLevel   : der momentan eingestellte Passwortlevel
*  Rückgabeparameter: 0, <0        : Fehler
*                     1            : kein Fehler
******************************************************************************}

function UserDlgShow(DatenbankName: PChar; TabellenName: PChar;
                     AktPwLevel: Integer): Integer;
  far; external 'UserDLL.DLL' index 1;


{******************************************************************************
*  Funktion UserLogin
*
*  Beschreibung:      Funktion öffnet den Dialog zur Benutzeranmeldung
*
*  Übergabeparameter: DatenbankName: Datenbankverzeichnis bzw. Aliasname
*                     TabellenName : Name der User-Tabelle
*                     AktUser      : der momentan angemeldete Benutzername
*                     AktPwLevel   : der momentan eingestellte Passwortlevel
*                     NewUser      : der neu angemeldete Benutzername
*  Rückgabeparameter: 0, >0        : neuer Passwortlevel
*                     -1           : Abbruch ohne Änderung
******************************************************************************}

function UserLogin(DatenbankName :PChar; TabellenName :PChar;
                   AktUser: PChar; AktPwLevel: Integer;
                   NewUser: PChar): Integer;
  far; external 'USERDLL.DLL' index 2;



Constructor TUser.Create(DatenbankName :PChar; TabellenName :PChar);

begin
   AktUserLevel:= -1;
   strpcopy(@DBName, DatenbankName);
   StrPCopy (@Table , TabellenName);
end;

Procedure TUser.SetUserLevel(NewValue:Integer);

begin
  if newvalue > AktUserlevel then
    begin
      if assigned(Proc_ChngeULevel) then
        Proc_ChngeULevel(self,aktuserLevel,NewValue);
      aktUserLevel:=NewValue;
    end
  else
    if ChULev_Enable then
    begin
      if assigned(Proc_ChngeULevel) then
        begin
          if Proc_ChngeULevel(self,aktuserLevel,NewValue) then
            aktUserLevel:=NewValue;
        end
      else
        aktUserLevel:=NewValue;

    end;
end;


Function TUser.GetUsername;

begin
  GetUsername := strpas ( UName);
end;

procedure TUser.Login;

var NewUsername:packed array[0..255] of char;
    newULevel:INteger;

begin
   NewULevel:=UserLogin(@dbname,@table,@Uname,AktUserlevel,@NewUserName);
   if NewULevel <> -1 Then
     begin
       ChULev_Enable :=true;
       level := NewULevel;
       if level = NewULevel then
         StrCopy(@UName,@NewUsername);
       ChULev_Enable :=false;
     end;
end;

Procedure TUser.Show;


begin
   UserDlgShow(@dbname,@table,AktUserlevel);
end;

Procedure TUser.SetUserRights ;

begin

  Frm_FormEinst.show
end;

Procedure TUser.EditUserRights ;

begin
  if not assigned(frm_formEinst) then
    Frm_FormEinst:=TFrm_FormEinst.create(self.Owner);
  Frm_FormEinst.show;
end;



procedure Register;
begin
  RegisterComponents('Projekt', [TUser]);
end;

procedure TFrm_FormEinst.FormShow(Sender: TObject);

  procedure ListClients (const Basis:TComponent;TN:TTreeNode;items:TTreeNodes;Path:String);

  var i:integer;
      node:TTreeNode;

  begin
    for i := 0 to basis.ComponentCount-1 do
       begin
         node := Items.AddChildObject(TN, Components[i].name,Components[i]);
         if (Components[i] <> self) and (Components[i] <> basis) then
           ListClients (Components[i], node,items,Path+'\'+Components[i].name);
       end;
  end;



var Root:TWinControl;
    Node:TTreeNode ;

{
var
  I: Integer;
  CNode: TTreeNode;
begin
  for I := 0 to ResList.Count - 1 do
    with ResList[I] do
    begin
      CNode := TreeView.Items.AddChildObject(Node, Name, ResList[I]);
      if IsList then
      begin
        CNode.SelectedIndex := 1;
        LoadResources(List, CNode);
      end else
      begin
        CNode.ImageIndex := ImageMap[ResList[I].ResType];
        CNode.SelectedIndex := CNode.ImageIndex;
      end;

    end;
end;
}

begin
  //
  Root:= self ;
  while assigned(root.parent) do
    root:= root.Parent ;
  root.Components
  node := TreeView1.Items.AddChildObject(nil,Root.Name,root);
  ListClients (root, node,TreeView1.Items,Root.Name+'\');
end;

procedure TFrm_FormEinst.BitBtn1Click(Sender: TObject);
begin
//  apply;
  close;
end;

procedure TFrm_FormEinst.BitBtn4Click(Sender: TObject);
begin
  // Daten Anwenden
end;

procedure TFrm_FormEinst.BitBtn3Click(Sender: TObject);
begin
 // Hilfe
end;

end.

