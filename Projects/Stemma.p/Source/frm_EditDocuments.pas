unit frm_EditDocuments;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus, StrUtils, IniFiles, Process;

type

  { TfrmEditDocuments }

  TfrmEditDocuments = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Z: TMemo;
    Label3: TLabel;
    Description: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    Type1: TEdit;
    OpenDialog: TOpenDialog;
    Titre: TEdit;
    Label2: TLabel;
    Primaire: TCheckBox;
    No: TEdit;
    Label1: TLabel;
    Fichier: TEdit;
    N: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FichierDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmEditDocuments: TfrmEditDocuments;

implementation

uses
  frm_Main,Traduction, dm_GenData, frm_ShowImage, frm_Names;

{ TfrmEditDocuments }

procedure TfrmEditDocuments.FormShow(Sender: TObject);
var
  code,nocode:string;
begin
  frmEditDocuments.ActiveControl:=frmEditDocuments.Titre;
  Caption:=Traduction.Items[178];
  Label2.Caption:=Traduction.Items[179];
  Label3.Caption:=Traduction.Items[162];
  Label4.Caption:=Traduction.Items[180];
  Button1.Caption:=Traduction.Items[152];
  Button2.Caption:=Traduction.Items[164];
  Button3.Caption:=Traduction.Items[181];
  dmGenData.GetCode(code,nocode);
  N.Text:=nocode;
  if code='A' then
     begin
     frmEditDocuments.Caption:=Traduction.Items[33];
     No.Text:='0';
     Titre.text:='';
     Description.Text:='';
     Fichier.Text:='';
     Primaire.Checked:=false;
     dmGenData.GetCode(code,nocode);
     Type1.Text:=code;
     Z.Text:='';
     end
  else
     begin
     dmGenData.Query1.SQL.Clear;
     dmGenData.Query1.SQL.add('SELECT X.no, X.X, X.T, X.D, X.F, X.Z, X.A FROM X WHERE (X.no='+
                               N.Text+')');
     dmGenData.Query1.Open;
     dmGenData.Query1.First;
     No.Text:=dmGenData.Query1.Fields[0].AsString;
     Primaire.Checked:=dmGenData.Query1.Fields[1].AsBoolean;
     Titre.Text:=dmGenData.Query1.Fields[2].AsString;
     Description.Text:=dmGenData.Query1.Fields[3].AsString;
     Fichier.Text:=dmGenData.Query1.Fields[4].AsString;
     Type1.Text:=dmGenData.Query1.Fields[6].AsString;
     Z.Text:=dmGenData.Query1.Fields[5].AsString;
  end;
end;

procedure TfrmEditDocuments.MenuItem1Click(Sender: TObject);
begin
  Button1Click(Sender);
  ModalResult:=mrOk;
end;

procedure TfrmEditDocuments.FichierDblClick(Sender: TObject);
begin
  OpenDialog.FileName:=Fichier.Text;
  OpenDialog.InitialDir:=ExtractFilePath(Fichier.Text);
  if OpenDialog.Execute then
     Fichier.Text:=OpenDialog.FileName;
end;

procedure TfrmEditDocuments.Button3Click(Sender: TObject);
var
  ini:TIniFile;
  pdf:string;
begin
  if length(Fichier.Text)=0 then
     begin
     frmShowImage.Caption:=Traduction.Items[34];
     frmShowImage.Image.Visible:=false;
     frmShowImage.Memo.Visible:=true;
     frmShowImage.btnOK.Visible:=true;
     frmShowImage.btnCancel.Visible:=true;
     if no.text='0' then
        frmShowImage.Memo.Text:=''
     else
        frmShowImage.Memo.Text:=Z.Text;
     if frmShowImage.Showmodal=mrOk then
        begin
        if no.text='0' then
           Button1Click(Sender);
        Z.Text:=frmShowImage.Memo.Text;
        dmGenData.Query2.SQL.Clear;
        dmGenData.Query2.SQL.Add('UPDATE X SET Z='''+
           AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(frmShowImage.Memo.Text),'"','\"'),'''','\''')+
           ''' WHERE X.no='+no.text);
        dmGenData.Query2.ExecSQL;
        // Enregistrer la date de la dernière modification pour tout les individus reliés
        // à cet exhibits.
        if type1.Text='I' then
           begin
           dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
        end;
        if type1.Text='E' then
           begin
           dmGenData.Query3.SQL.Clear;
           dmGenData.Query3.SQL.Add('SELECT W.I FROM (W JOIN E on W.E=E.no) JOIN X on X.N=E.no WHERE X.no='+
                                     no.Text);
           dmGenData.Query3.Open;
           dmGenData.Query3.First;
           while not dmGenData.Query3.EOF do
              begin
              dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
              dmGenData.Query3.Next;
           end;
           frmNames.PopulateNom(Sender);
        end;
     end;
  end
  else
        begin
        if AnsiPos('.PDF',Fichier.Text)>0 then
           begin
           Ini := TIniFile.Create(iniFileName);
           pdf := ini.ReadString('Parametres','PDF','C:\Program Files (x86)\Adobe\Reader 10.0\Reader\AcroRd32.exe');
           with TProcess.Create(nil) do
           try
              Parameters.text:=pdf+' '+Fichier.Text;
              Execute;
              ini.WriteString('Parametres','PDF',pdf);
           finally
              Free;
           end;
           Ini.Free;
        end
        else
           begin
           frmShowImage.Caption:=Fichier.Text;
           frmShowImage.Memo.Visible:=false;
           frmShowImage.btnOK.Visible:=false;
           frmShowImage.btnCancel.Visible:=false;
           frmShowImage.Image.Visible:=true;
           frmShowImage.Image.Picture.LoadFromFile(Fichier.Text);
           frmShowImage.Showmodal;
        end;
     end;
end;

procedure TfrmEditDocuments.Button1Click(Sender: TObject);
begin
  dmGenData.Query1.SQL.Clear;
  if no.text='0' then
     dmGenData.Query1.SQL.Add('INSERT INTO X (X, T, D, F, A, N) VALUES ( 0, '''+
       AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Titre.Text),'"','\"'),'''','\''')+
       ''', '''+AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Description.Text),'"','\"'),'''','\''')+
       ''', '''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Fichier.Text),'\','\\'),'"','\"'),'''','\''')+
       ''', '''+Type1.text+''', '+N.Text+')')
  else
     dmGenData.Query1.SQL.Add('UPDATE X SET T='''+
       AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Titre.Text),'"','\"'),'''','\''')+
       ''', D='''+AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Description.Text),'"','\"'),'''','\''')+
       ''', F='''+AnsiReplaceStr(AnsiReplaceStr(AnsiReplaceStr(UTF8toANSI(Fichier.Text),'\','\\'),'"','\"'),'''','\''')+
       ''' WHERE X.no='+no.text);
  dmGenData.Query1.ExecSQL;
  // Enregistrer la date de la dernière modification pour tout les individus reliés
  // à cet exhibits.
  if no.text='0' then
     begin
     no.text:=InttoStr(dmGenData.GetLastIDOfTable('X'));
  end;
  if type1.Text='I' then
     begin
     dmGenData.SaveModificationTime(frmStemmaMainForm.iID);
  end;
  if type1.Text='E' then
     begin
     dmGenData.Query3.SQL.Clear;
     dmGenData.Query3.SQL.Add('SELECT W.I FROM (W JOIN E on W.E=E.no) JOIN X on X.N=E.no WHERE X.no='+
                                no.Text);
     dmGenData.Query3.Open;
     dmGenData.Query3.First;
     while not dmGenData.Query3.EOF do
       begin
       dmGenData.SaveModificationTime(dmGenData.Query3.Fields[0].AsInteger);
       dmGenData.Query3.Next;
       end;
       frmNames.PopulateNom(Sender);
  end;
end;

{ TfrmEditDocuments }


{$R *.lfm}

end.

