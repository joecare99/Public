Unit Frm_ShowGedCom;

Interface

Uses
 {$IFDEF FPC}
 {$ELSE}  Windows, Messages,
 {$ENDIF} SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Unt_Config, StdCtrls, Buttons, ComCtrls, ExtCtrls, unt_variantprocs,
  Cmp_GedComFile, cls_GenealogieHelper, fra_GenShowIndivid;

Type

  { TFrmShowGedCom }

  TFrmShowGedCom = Class(TForm)
    ApplicationProperties1: TApplicationProperties;
    btnAutoSetName: TButton;
    btnAutoRemoveInd: TButton;
    btnFileSaveAs: TBitBtn;
    Button1: TButton;
    btnAutoEstBirth: TButton;
    chbVerbose: TCheckBox;
    CheckBox1: TCheckBox;
    lblStatistics: TLabel;
    lblEstBirthResult: TLabel;
    lblSetNameResult: TLabel;
    lblRemoveIndResult: TLabel;
    pnlDetail: TPanel;
    pnlLeft: TPanel;
    pnlBottom: TPanel;
    pnlTop: TPanel;
    ProgressBar1: TProgressBar;
    SaveDialog1: TSaveDialog;
    btnGotoLink: TSpeedButton;
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
    procedure btnAutoRemoveIndClick(Sender: TObject);
    procedure btnAutoSetNameClick(Sender: TObject);
    Procedure btnBrowseFileClick(Sender: TObject);
    procedure btnFileSaveAsClick(Sender: TObject);
    procedure btnGotoLinkClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnAutoEstBirthClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure btnOpenFileClick(Sender: TObject);
    procedure TreeView1CustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TreeView1SelectionChanged(Sender: TObject);
  Private
    FActGedObj: TGedComObj;
    FFraShowIndiv: TFraShowIndiv;
    FoldGedObj: TGedComObj;
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
    FGenealogieHelper:TGenealogyHelper;
    procedure ChildUpdate(Sender: TObject);
    procedure GedComLongOp(Sender: TObject);
    procedure LogEvent(s: String);
    procedure OnGedComReadUpdate(Sender: TObject);
  Public
    { Public-Deklarationen }
    Procedure ResetStatistics;
    Procedure UpdateStatistics;
  End;

Var
  FrmShowGedCom: TFrmShowGedCom;

Implementation

uses LConvEncoding,Cls_GedComExt,Unt_FileProcs,unt_IGenBase2;

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

function GedFilter(aObj: TGedComObj): Boolean;
var
  FFiledate: TDateTime;
  lFam: TGedFamily;

  function FilterFamily(aObj:TGedFamily):boolean;

  var
    lChld: TGedIndividual;
  begin
    if not assigned(aObj) then exit(false);
    result := true;
    if assigned(aObj.Husband) and (aObj.Husband.LastChange>=FFiledate-1 )
      then exit;
    if assigned(aObj.Wife) and (aObj.Wife.LastChange>=FFiledate-1 )
      then exit;
    for lChld in aObj.EnumerateChildren do
     if (lChld.LastChange>=FFiledate-1 ) then exit;
    result := false;
  end;

begin
  result := true;
  FFiledate:=Date;
  if aobj.InheritsFrom(TGedIndividual) then
    begin
      result := false;
      if TGedIndividual(aObj).LastChange >=FFiledate-1 then
        exit(true);
      if Assigned(TGedIndividual(aObj).ParentFamily) and FilterFamily(TGedFamily(TGedIndividual(aObj).ParentFamily.self)) then
        exit(true);
      for lFam in  TGedIndividual(aObj).EnumerateFamiliy do
        if FilterFamily(lFam) then
          exit(true);
    end;
  if aobj.InheritsFrom(TGedFamily) then
    exit(FilterFamily(TGedFamily(aObj)));
end;

procedure TFrmShowGedCom.btnBrowseFileClick(Sender: TObject);
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
        btnOpenFileClick(sender);
      End;
  End;

procedure TFrmShowGedCom.ApplicationProperties1Idle(Sender: TObject; var Done: Boolean);

var
  lMainObj: TGedComObj;
begin
  with FStatistics do
  If Changed then
    begin
      lblStatistics.caption:=format(rsStatistics,[Individuals,Families,Notes,Places,
        Sources,Repositories,Objects]);
      Changed := false;
    end;

  if FActGedObj <> FoldGedObj then
    begin
      lMainObj:= nil;
      if assigned(FActGedObj) then
        begin
          StatusBar1.Panels[0].Text:= FActGedObj.Classname + ': '+FActGedObj.ToString;
          lMainObj := FActGedObj;
          while lMainObj.Parent <> lMainObj.Root do
            lMainObj:= TGedComObj(lMainObj.Parent.GetObject);
          if lMainObj.inheritsfrom(TGedIndividual) then
            begin
              FFraShowIndiv.Individual := TGedIndividual(lMainObj);
              FFraShowIndiv.Visible:=true;
            end
        else
      if lMainObj.inheritsfrom(TGedFamily) then
        begin
          FFraShowIndiv.Family := TGedFamily(lMainObj);
          FFraShowIndiv.Visible:=true;
        end
        else  FFraShowIndiv.Visible:=false;
        end
      else
        StatusBar1.Panels[0].Text:='';
  If assigned(FActGedObj) and assigned(FActGedObj.Link) then
    begin
      btnGotoLink.Enabled:=true;
      btnGotoLink.Caption := FActGedObj.data.DeQuotedString('@');
      btnGotoLink.tag := ptrint(FActGedObj.Link);
    end
  else
    begin
      btnGotoLink.Enabled:=false;
      btnGotoLink.Caption := '';
      btnGotoLink.tag := 0;
    end;
       FoldGedObj := FActGedObj;
    end;
end;

procedure TFrmShowGedCom.btnAutoRemoveIndClick(Sender: TObject);
begin
  btnAutoRemoveInd.Enabled:=false;
  TreeView1.Items.Clear;
  FGenealogieHelper.AutoRemoveInds;
  lblRemoveIndResult.Caption:=inttostr(FGenealogieHelper.pResult)+
    ' ('+IntToStr(FGenealogieHelper.mResult)+')';
  btnAutoRemoveInd.Enabled:=true;
  GedCom2treenodes(FGedComFile,TreeView1.Items,nil);
  UpdateStatistics;
end;

procedure TFrmShowGedCom.btnAutoSetNameClick(Sender: TObject);
begin
  FGenealogieHelper.autoSetName;
  lblSetNameResult.Caption:=inttostr(FGenealogieHelper.pResult)+
    ' ('+IntToStr(FGenealogieHelper.mResult)+')';
end;

procedure TFrmShowGedCom.btnFileSaveAsClick(Sender: TObject);
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
      FGedComFile.WriteToStream(lst,@GedFilter);
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

procedure TFrmShowGedCom.btnGotoLinkClick(Sender: TObject);
var
  lTn: TTreeNode;
begin
  lTn := TreeView1.Items.FindNodeWithData(Tobject(TControl(Sender).Tag));
  if assigned(lTn) then TreeView1.Select(ltn);
end;

procedure TFrmShowGedCom.Button1Click(Sender: TObject);
var
  lActChild, lSubch: TGedComObj;
  FReffn, Fplace: String;

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

procedure TFrmShowGedCom.btnAutoEstBirthClick(Sender: TObject);
begin
  FGenealogieHelper.AutoEstimateBirth;
  lblEstBirthResult.Caption:=inttostr(FGenealogieHelper.pResult)+
    ' ('+IntToStr(FGenealogieHelper.mResult)+')';
end;

procedure TFrmShowGedCom.FormCreate(Sender: TObject);
begin
  FGedcomFile:=TGedComFile.Create;
  FGedComFile.OnLongOp:=GedComLongOp;
  FGedComFile.OnChildUpdate:=ChildUpdate;

  FGenealogieHelper:=TGenealogyHelper.Create;
  FGenealogieHelper.OnLongOp:=GedComLongOp;
  FGenealogieHelper.GedComFile:=FGedComFile;

  FFraShowIndiv :=  TFraShowIndiv.Create(self);
  FFraShowIndiv.Parent := pnlDetail;
  FFraShowIndiv.Align:=alClient;
  FFraShowIndiv.OnFamBrowse:=btnGotoLinkClick;
  FFraShowIndiv.OnIndBrowse:=btnGotoLinkClick;

end;

procedure TFrmShowGedCom.FormDestroy(Sender: TObject);
begin
  FActGedObj:=nil;
  freeandnil(FGenealogieHelper);
  freeandnil(FGedComFile);
end;

procedure TFrmShowGedCom.btnOpenFileClick(Sender: TObject);

  Var
    lStream: TStream;
  Begin
    If FileExists(cbxFilename.Text) Then
      Begin
        ResetStatistics;
        TreeView1.Items.Clear;
        FGedComFile.OnUpdate:=OnGedComReadUpdate;
        if cbxFilename.ItemIndex = -1 then
          cbxFilename.Items.add(cbxFilename.Text);
        lStream := TFileStream.Create(cbxFilename.Text,fmOpenRead);
        try
          FGedComFile.LoadFromStream(lStream);
        finally
          lStream.free;
        end;
        LogEvent( var2string(FGedVar,false));
        GedCom2treenodes(FGedComFile,TreeView1.Items,nil);
      End;
  End;

procedure TFrmShowGedCom.TreeView1CustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Node.Count=0 then
    GedCom2treenodes(Tgedcomobj(Node.Data),node.Owner,Node);
  DefaultDraw:=true;
end;

procedure TFrmShowGedCom.TreeView1SelectionChanged(Sender: TObject);
var
  lActNode: TGedComObj;
//  lMaster :IGedParent;
//  lPath: String;
  lSelNode: TTreeNode;
begin
  lSelNode:=TreeView1.Selected;
  if assigned(lSelNode) and  assigned(lSelNode.Data) and Tobject(lSelNode.Data).InheritsFrom(TGedComObj) then
    begin
      lActNode := TGedComObj( TreeView1.Selected.Data);
      FActGedObj:=lActNode;
      if lActNode.Count <> lSelNode.Count then
        GedCom2treenodes(lactnode,lSelNode.Owner,lSelNode);
      mmLog.Append('ActNode:'+lActNode.Description);
      // Find Master
//      lMaster := lActNode ;
//      lPath:= lactNode.NodeType;
//      mmLog.Append('ActMaster:'+TGedComObj(lMaster).ToString);
    end;
end;

procedure TFrmShowGedCom.LogEvent( s: String);
begin
  if chbVerbose.Checked then
    mmLog.Lines.Add(s);
end;

procedure TFrmShowGedCom.GedComLongOp(Sender: TObject);
var
  Done: Boolean;
begin
  ProgressBar1.Max := FGedComFile.Count;
  if sender.InheritsFrom(TGedComObj) then
    ProgressBar1.Position:=ProgressBar1.Max-TGedComObj(sender).ID;
  ApplicationProperties1Idle(sender,Done{%H-});
  Application.ProcessMessages;
end;

procedure TFrmShowGedCom.ChildUpdate(Sender: TObject);
var
  lNode: TTreeNode;
begin
  lNode:= TreeView1.Items.FindNodeWithData(Sender);
  if Assigned(lNode) and assigned(Sender) and Assigned(TGedComObj(Sender).root) then
    try
      lNode.Text:=TGedComObj(Sender).ToString;
      TreeView1.Invalidate;
    except
    end
  else
  if Assigned(lNode) and assigned(Sender) and not Assigned(TGedComObj(Sender).root) then
    begin
      TreeView1.Items.Delete(lnode);
    end;
end;

procedure TFrmShowGedCom.OnGedComReadUpdate(Sender: TObject);
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

procedure TFrmShowGedCom.ResetStatistics;
begin
  fillchar(FStatistics,sizeof(FStatistics),0);
end;

procedure TFrmShowGedCom.UpdateStatistics;
var
  lGobj: TGedComObj;
begin
  ResetStatistics;
  for lGobj in FGedComFile do
    OnGedComReadUpdate(lGobj);
end;

procedure TFrmShowGedCom.FormShow(Sender: TObject);
  Var
    CBCount, i: Integer;
  Begin
    CBCount := Config1.getValue(cbxFilename, 'ICount', 0);
    For i := 0 To CBCount - 1 Do
      cbxFilename.Items.Add(Config1.getValue(cbxFilename, inttostr(i), ''))
  End;


End.
