Unit Frm_ShowGedCom;

Interface

Uses
 {$IFDEF FPC}
 {$ELSE}  Windows, Messages,
 {$ENDIF} SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Unt_Config, StdCtrls, Buttons, ComCtrls, ExtCtrls, unt_variantprocs,
  Cmp_GedComFile;

Type

  { TForm1 }

  TForm1 = Class(TForm)
    ApplicationProperties1: TApplicationProperties;
    btnFileSaveAs: TBitBtn;
    Button1: TButton;
    chbVerbose: TCheckBox;
    Label1: TLabel;
    Panel1: TPanel;
    pnlTop: TPanel;
    SaveDialog1: TSaveDialog;
    Splitter1: TSplitter;
    TreeView1: TTreeView;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    btnBrowseFile: TBitBtn;
    cbxFilename: TComboBox;
    Config1: TConfig;
    btnOpenFile: TBitBtn;
    mmLog: TMemo;
    procedure ApplicationProperties1Idle(Sender: TObject; var Done: Boolean);
    Procedure btnBrowseFileClick(Sender: TObject);
    procedure btnFileSaveAsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure btnOpenFileClick(Sender: TObject);
    procedure TreeView1SelectionChanged(Sender: TObject);
  Private
    { Private-Deklarationen }
    FStatistics:record
      Individuals,
      Families,
      Notes,
      Places,
      Objects,
      Sources,
      Repositories:integer;
      Changed:boolean;
    end;
    FGedVar: variant;
    FGedComFile: TGedComFile;
    procedure GedComLongOp(Sender: TObject);
    procedure LogEvent(s: String);
    procedure OnGedComReadUpdate(Sender: TObject);
  Public
    { Public-Deklarationen }
    Procedure ResetStatistics;
  End;

Var
  Form1: TForm1;

Implementation

uses LConvEncoding,Unt_FileProcs;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

resourcestring
  rsStatistics = 'Statistics:'+LineEnding+'Individuals:'#9'%d'+LineEnding+
    'Families:'#9'%d'+LineEnding+
    'Notes:'#9'%d'+LineEnding+
    'Places:'#9'%d'+LineEnding+
    'Sources:'#9'%d'+LineEnding+
    'Repositories:'#9'%d'+LineEnding+
    'Objects:'#9'%d';

procedure Var2treenodes(const Data:variant;Owner:TTreeNodes;base:tTreenode) ;

var hst : string;
    actnode:TTreeNode;
    i:integer;

begin
  case Vartype(Data) of
      varEmpty:hst:='';
      varNull:hst:='';
      varSmallint ,
      varInteger  ,
      varSingle   ,
      varDouble   ,
      varCurrency ,
      varDate     ,
      varDispatch ,
      varError    ,
      varVariant  ,
      varUnknown  ,
      varByte     :HST:=varastype(Data,varstring);
      varBoolean  :if data then hst:='TRUE' else hst:='FALSE';
      varOleStr   ,
      varString   : hst:=Data;
      varArray..varArray+vartypeMask:
          begin
            for i := VarArrayLowBound(data,1)to VarArrayHighBound(data,1) div 2 do
              begin
                actnode:=Owner.AddChild(base,var2string(data[i*2]));
                Var2treenodes(Data[i*2+1],Owner,Actnode);
              end;
            hst :='';
          end;
    end;
   if hst <> ''  then
     begin
       actnode:=Owner.AddChild(base,hst);
     end;

end;

procedure GedCom2treenodes(const iData:IGedParent;Owner:TTreeNodes;base:tTreenode);

var
  i: LongInt;
  lActChild: TGedComObj;
  lActNode: TTreeNode;
begin
  if not assigned(iData) then exit;
  for i := 0 to iData.ChildCount-1 do
    begin
      lActChild := iData.GetChild(i);
      lActNode:=Owner.AddChildObject(base,lActChild.ToString,lActChild);
//      GedCom2treenodes(lActChild,Owner,lActNode);
    end;
end;

procedure TForm1.btnBrowseFileClick(Sender: TObject);
  Var
    ix, i: Integer;
  Begin
    OpenDialog1.Filter := FGedComFile.FileOpenFilter +'|'+rsAllFilesFilter;
    If OpenDialog1.Execute Then
      Begin
        ix := cbxFilename.Items.IndexOf(OpenDialog1.FileName);
        If ix = -1 Then
          Begin
            cbxFilename.Items.Add(OpenDialog1.FileName);
            ix := cbxFilename.Items.count - 1;
            Config1.Value[cbxFilename, 'ICount'] := cbxFilename.Items.count;
            For i := 0 To cbxFilename.Items.count - 1 Do
              Config1.Value[cbxFilename, inttostr(i)] := cbxFilename.Items[i];
          End;
        cbxFilename.ItemIndex := ix;
      End;

  End;

procedure TForm1.ApplicationProperties1Idle(Sender: TObject; var Done: Boolean);
begin
  with FStatistics do
  If Changed then
    begin
      Label1.caption:=format(rsStatistics,[Individuals,Families,Notes,Places,
        Sources,Repositories,Objects]);
      Changed := false;
    end;
end;

procedure TForm1.btnFileSaveAsClick(Sender: TObject);
  Var
    lFilename: String;
    lst: TFileStream;

const
   cNewExt='.new';
   cBakExt='.bak';
begin
  SaveDialog1.Filter:=FGedComFile.FileOpenFilter +'|'+rsAllFilesFilter;
  SaveDialog1.FileName:=cbxFilename.text;
  if SaveDialog1.Execute then
    begin
      lFilename:=SaveDialog1.FileName;
      if fileexists(ChangeFileExt(lFilename,cNewExt)) then
        DeleteFile(ChangeFileExt(lFilename,cNewExt));
      lst:=TFileStream.Create(ChangeFileExt(lFilename,cNewExt),fmCreate);
      try
      FGedComFile.WriteToStream(lst);
      finally
        freeandnil(lst);
      end;
      if lowercase(ExtractFileExt(lFilename))=cNewExt then exit;
      if fileexists(lFilename) then
        Begin
      if fileexists(ChangeFileExt(lFilename,cBakExt)) then
        DeleteFile(ChangeFileExt(lFilename,cbakExt));
          RenameFile(lFilename,ChangeFileExt(lFilename,cbakExt));
        end;
      RenameFile(ChangeFileExt(lFilename,cNewExt),lFilename);
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  lActChild, lSubch: TGedComObj;
  FReffn, Fplace: String;
  j, i: Integer;
begin
   for lActChild in FGedComFile do
    begin
      FReffn := '';
      Fplace := '';
      if lActChild.NodeType = 'INDI' then
        for lSubch in lActChild do
          if lSubch.NodeType='REFN' then
            FReffn:=lSubch.Data
          else if lSubch.NodeType='DEAT' then
             if assigned(TGedEvent(lSubch).Place) then
               Fplace:=TGedEvent(lSubch).Place.Data;
      if FReffn<> '' then
        mmLog.append(FReffn+', '+Fplace);
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FGedcomFile:=TGedComFile.Create;
  FGedComFile.OnLongOp:=@GedComLongOp;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  freeandnil(FGedComFile);
end;

procedure TForm1.btnOpenFileClick(Sender: TObject);

  Var
    lStream: TStream;
  Begin
    If FileExists(cbxFilename.Text) Then
      Begin
        ResetStatistics;
        FGedComFile.OnUpdate:=@OnGedComReadUpdate;
        if cbxFilename.ItemIndex = -1 then
          cbxFilename.Items.add(cbxFilename.Text);
        lStream := TFileStream.Create(cbxFilename.Text,fmOpenRead);
        try
          FGedComFile.LoadFromStream(lStream);
        finally
          lStream.free;
        end;

        LogEvent( var2string(FGedVar,false));
        TreeView1.Items.Clear;
        GedCom2treenodes(FGedComFile,TreeView1.Items,nil);
      End;
  End;

procedure TForm1.TreeView1SelectionChanged(Sender: TObject);
var
  lActNode: TGedComObj;
  lMaster :IGedParent;
  lPath: String;
  lSelNode: TTreeNode;
begin
  lSelNode:=TreeView1.Selected;
  if assigned(lSelNode) and  assigned(lSelNode.Data) and Tobject(lSelNode.Data).InheritsFrom(TGedComObj) then
    begin
      lActNode := TGedComObj( TreeView1.Selected.Data);
      if lActNode.Count <> lSelNode.Count then
        GedCom2treenodes(lactnode,lSelNode.Owner,lSelNode);
      mmLog.Append('ActNode:'+lActNode.Description);
      // Find Master
      lMaster := lActNode ;
      lPath:= lactNode.NodeType;
//      mmLog.Append('ActMaster:'+TGedComObj(lMaster).ToString);
    end;
end;

procedure TForm1.LogEvent( s: String);
begin
  if chbVerbose.Checked then
    mmLog.Lines.Add(s);
end;

procedure TForm1.GedComLongOp(Sender: TObject);
var
  Done: Boolean;
begin
  ApplicationProperties1Idle(sender,Done);
  Application.ProcessMessages;
end;

procedure TForm1.OnGedComReadUpdate(Sender: TObject);
var
  lNType: String;
  lc: Boolean;
begin
  if Sender.InheritsFrom(TGedComObj) then
    begin
      lNType := (sender as TGedComObj).NodeType;
      lc:=true;
      with FStatistics do
      if lNType = 'INDI' then
         inc(Individuals)
      else if lNType = 'FAM' then
        inc(Families)
      else if lNType = 'NOTE' then
        inc(Notes)
      else if lNType = 'PLAC' then
        inc(Places)
      else if lNType = 'SOUR' then
        inc(Sources)
      else if lNType = 'REPO' then
        inc(Repositories)
      else if lNType = 'OBJE' then
        inc(Objects)
      else
        lc:=false;
      if lc then
        FStatistics.Changed := true;
    end;
 // Application.ProcessMessages;
end;

procedure TForm1.ResetStatistics;
begin
  fillchar(FStatistics,sizeof(FStatistics),0);
end;

procedure TForm1.FormShow(Sender: TObject);
  Var
    CBCount, i: Integer;
  Begin
    CBCount := Config1.getValue(cbxFilename, 'ICount', 0);
    For i := 0 To CBCount - 1 Do
      cbxFilename.Items.Add(Config1.getValue(cbxFilename, inttostr(i), ''))
  End;


End.
