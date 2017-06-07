unit Frm_FileUnt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, unt_fileprocs,
  Dialogs,  StdCtrls ,unt_stringprocs, unt_allgfunklib, ComCtrls, Menus; // , unt_M3ULib

type
  TForm1 = class(TForm)
    btn_GetFiles: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    Edit3: TEdit;
    btn_GetSoundEx: TButton;
    OpenDialog1: TOpenDialog;
    btn_BrowseDir: TButton;
    Memo2: TMemo;
    Label4: TLabel;
    TreeView1: TTreeView;
    PopupMenu1: TPopupMenu;
    Open1: TMenuItem;
    btn_WriteFile: TButton;
    btn_WriteFile2: TButton;
    procedure btn_GetFilesClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btn_GetSoundExClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1GetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure Open1Click(Sender: TObject);
    procedure TreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure btn_BrowseDirClick(Sender: TObject);
    procedure btn_WriteFileClick(Sender: TObject);
    procedure btn_WriteFile2Click(Sender: TObject);
  private
    { Private-Deklarationen }
     function OnReply(perc: real; apath: string):boolean;
   public
   { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses Unt_LinList;

{$R *.DFM}


procedure TForm1.btn_GetFilesClick(Sender: TObject);

var fls,p:Tfiles;
    oldnode:TTreeNode;
    oldpath:string;
    Gsize:int64;

begin
  button2.Enabled := true;
  TreeView1.Items.Clear;
  fls:=getfiles(edit1.text,edit2.text,onreply,0,20000);
  p:=fls;
  oldpath:='';
  oldnode:=nil;
  Gsize:=0;
  while assigned(p) do
    begin
      if oldpath <> ExtractFilePath(p.pfad) then
        begin
          oldpath:= ExtractFilePath(p.pfad);
          oldnode:=TreeView1.Items.Add(nil,oldpath);
        end;
      TreeView1.Items.AddChildObject(oldnode,p.Name,p);
      inc(GSize,p.size);
      p:=p.getnext as TFiles;
    end;
 // TreeView1.SaveToFile('d:\tree1.txt');
  label3.caption:=inttostr(fls.count);
  label4.caption:=inttostr(Gsize);
  fls.free;
end;

function TForm1.OnReply;
begin
  label1.caption:=apath;
  label2.caption:=inttostr(trunc(perc / 200))+','+inttostr(trunc(perc/2) mod 100) +'%';
  Application.ProcessMessages;
  result := not button2.enabled;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  button2.Enabled :=false;
end;

procedure TForm1.btn_GetSoundExClick(Sender: TObject);
begin
  label1.caption:= GetSoundex (edit3.text);
end;

procedure TForm1.TreeView1Click(Sender: TObject);
begin
  if assigned(treeview1.Selected.Data) then
    try
    if Tobject(treeview1.Selected.Data).InheritsFrom(TFiles) then
    with Tfiles(treeview1.Selected.Data) do
    begin
      Label1.Caption :=Name ;
      label2.Caption := pfad;
      label3.Caption := inttostr(size);
      memo2.text:=getFileInfo(pfad)
    end;
    except
    end
end;

var oldsel:TTreenode;

procedure TForm1.TreeView1GetSelectedIndex(Sender: TObject;
  Node: TTreeNode);

  var i:integer;
       pme:TMenuItem;
begin
  if oldsel <> treeview1.Selected then
    begin
      oldsel := treeview1.Selected ;
  if assigned(treeview1.Selected.Data) then
    try
    if Tobject(treeview1.Selected.Data).InheritsFrom(TFiles) then
    with Tfiles(treeview1.Selected.Data) do
    begin
      Label1.Caption :=Name ;
      label2.Caption := pfad;
      label3.Caption := inttostr(size);
      memo2.text:=getFileInfo(pfad);
      PopupMenu1.Items.Clear;
      for i := 1 to strtoint(memo2.lines.values['shellcount']) do
        begin
          pme:=TMenuItem.Create(nil);
          pme.Default:=memo2.lines.values['shell'+inttostr(i-1)]=memo2.lines.values['defaultshell'] ;
          pme.Hint:=memo2.lines.values['cmd'+inttostr(i-1)];
          pme.Caption := memo2.lines.values['info'+inttostr(i-1)];
          pme.OnClick := Open1Click;
          pme.tag:=i;
          popupmenu1.items.add(pme);
        end;
    end;
    except
    end
   end;
end;



procedure TForm1.Open1Click(Sender: TObject);

var cmd:string;
begin
  if Sender.InheritsFrom(TMenuItem) then
    begin
      cmd:=TMenuitem(sender).hint;
      cmd:=strreplace(cmd,'%1',label2.caption);
      winexec(Pansichar(cmd),sw_normal);
    end
end;

procedure TForm1.TreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  PopupMenu1.Popup(mousepos.X,mousepos.y);
end;

procedure TForm1.btn_BrowseDirClick(Sender: TObject);
begin
  if right(edit2.text,1)='\' then
    opendialog1.FileName :=edit2.Text+edit1.Text
  else
    opendialog1.FileName :=edit2.Text+'\'+edit1.Text;
  if opendialog1.Execute then
    begin
      edit1.Text:='*'+ExtractFileExt(OpenDialog1.FileName)  ;
      edit2.Text:=ExtractFilePath(OpenDialog1.FileName)
    end;
end;

procedure TForm1.btn_WriteFileClick(Sender: TObject);
begin
  //M3ULib.WriteFile('d:\test.m3u',Memo2.text);
end;

procedure TForm1.btn_WriteFile2Click(Sender: TObject);
begin
  //M3ULib.WriteFile(label2.Caption,Memo2.text);
end;

end.
