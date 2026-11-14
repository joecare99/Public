unit Frm_GedCom2OdfMain;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ComCtrls, Spin, Unt_Config, Cmp_GedComFile, cls_GenealogieHelper,
  cmp_GedComDocumentWriter, fra_GenShowIndivid;

type

  { TfrmGedCom2OdfMain }

  TfrmGedCom2OdfMain = class(TForm)
    ApplicationProperties1: TApplicationProperties;
    btnAutoEstBirth: TButton;
    btnAutoSetName: TButton;
    btnBrowseFile: TBitBtn;
    btnFileSaveAs: TBitBtn;
    btnGotoLink: TSpeedButton;
    btnOpenFile: TBitBtn;
    btnCreateOdf: TButton;
    btnClearLists: TButton;
    cbxFilename: TComboBox;
    Config1: TConfig;
    lblEstBirthResult: TLabel;
    lblSetNameResult: TLabel;
    lblStatistics: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    pnlClTop: TPanel;
    pnlClient: TPanel;
    pnlBottom: TPanel;
    pnlDetail: TPanel;
    pnlLeft: TPanel;
    pnlTop: TPanel;
    ProgressBar1: TProgressBar;
    edtOffset: TSpinEdit;
    edtCount: TSpinEdit;
    SaveDialog1: TSaveDialog;
    Splitter1: TSplitter;
    TreeView1: TTreeView;
    procedure ApplicationProperties1Idle(Sender: TObject; var Done: Boolean);
    procedure btnAutoEstBirthClick(Sender: TObject);
    procedure btnAutoSetNameClick(Sender: TObject);
    procedure btnBrowseFileClick(Sender: TObject);
    procedure btnClearListsClick(Sender: TObject);
    procedure btnFileSaveAsClick(Sender: TObject);
    procedure btnGotoLinkClick(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnCreateOdfClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblSetNameResultClick(Sender: TObject);
    procedure TreeView1CustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TreeView1SelectionChanged(Sender: TObject);
  private
    FoldGedObj: TGedComObj;
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
    FActGedObj: TGedComObj;
    FGedComFile: TGedComFile;
    FGenealogieHelper:TGenealogyHelper;
    FGenealogieWriter:TGenDocumentWriter;
     FFraShowIndiv: TFraShowIndiv;
    procedure ChildUpdate(Sender: TObject);
    procedure GedComLongOp(Sender: TObject);
    procedure LogEvent(s: String);
    procedure OnGedComReadUpdate(Sender: TObject);
  Public
    { Public-Deklarationen }
    Procedure ResetStatistics;
    Procedure UpdateStatistics;
  end;

var
  frmGedCom2OdfMain: TfrmGedCom2OdfMain;

implementation

uses Unt_FileProcs,Cls_GedComExt,unt_IGenBase2;
{$R *.lfm}

resourcestring
  rsStatistics = 'Statistics:'+LineEnding+'Individuals:'#9'%d'+LineEnding+
    'Families:'#9'%d'+LineEnding+
    'Notes:'#9'%d'+LineEnding+
    'Places:'#9'%d'+LineEnding+
    'Sources:'#9'%d'+LineEnding+
    'Repositories:'#9'%d'+LineEnding+
    'Objects:'#9'%d';

{ TfrmGedCom2OdfMain }

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

procedure TfrmGedCom2OdfMain.btnBrowseFileClick(Sender: TObject);
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

procedure TfrmGedCom2OdfMain.btnClearListsClick(Sender: TObject);
begin
  FGenealogieWriter.ClearLists;
end;

procedure TfrmGedCom2OdfMain.btnFileSaveAsClick(Sender: TObject);
begin

end;


procedure TfrmGedCom2OdfMain.btnAutoEstBirthClick(Sender: TObject);
begin
FGenealogieHelper.AutoEstimateBirth;
 lblEstBirthResult.Caption:=inttostr(FGenealogieHelper.pResult)+
   ' ('+IntToStr(FGenealogieHelper.mResult)+')';
end;

procedure TfrmGedCom2OdfMain.btnAutoSetNameClick(Sender: TObject);
begin
  FGenealogieHelper.autoSetName;
  lblSetNameResult.Caption:=inttostr(FGenealogieHelper.pResult)+
    ' ('+IntToStr(FGenealogieHelper.mResult)+')';
end;

procedure TfrmGedCom2OdfMain.ApplicationProperties1Idle(Sender: TObject;
  var Done: Boolean);
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
//          StatusBar1.Panels[0].Text:= FActGedObj.Classname + ': '+FActGedObj.ToString;
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
        end;
//      else
//        StatusBar1.Panels[0].Text:='';
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

procedure TfrmGedCom2OdfMain.btnOpenFileClick(Sender: TObject);
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
       GedCom2treenodes(FGedComFile,TreeView1.Items,nil);
     End;
end;

procedure TfrmGedCom2OdfMain.btnCreateOdfClick(Sender: TObject);
var
  lChlds: TGedComObj;
  lCount: Integer;

var DebugMin,
      DebugCount:integer;
begin
  lCount := 0;
  DebugMin:=edtOffset.Value;
  DebugCount:=edtCount.Value;
  SaveDialog1.filename := ChangeFileExt(cbxFilename.Text,'.fodt');
  if SaveDialog1.execute() then
    begin
  FGenealogieWriter.PrepareDocument;
  for lChlds in FGedComFile do
      if lChlds.inheritsfrom(TGedFamily) then
         begin
           inc(lCount);
           if (lCount>=DebugMin) and (lcount <DebugMin+DebugCount) then
             FGenealogieWriter.AppendFamily(lChlds as IGenFamily);
         end
      else if lChlds.inheritsfrom(TGedIndividual) then
         if (TGedIndividual(lChlds).FamCount=0) and
            not assigned(TGedIndividual(lChlds).ParentFamily) then
            FGenealogieWriter.AppendSingleInd(lChlds as IGenIndividual);
  FGenealogieWriter.WritePreamble;
  FGenealogieWriter.SortAndRenumberFamiliies;
  FGenealogieWriter.SaveToSingleXml(ChangeFileExt(SaveDialog1.FileName,'0.fodt'));
  FGenealogieWriter.FamList.SaveToFile(ChangeFileExt(SaveDialog1.FileName,'f.txt'));
  FGenealogieWriter.indList.SaveToFile(ChangeFileExt(SaveDialog1.FileName,'i.txt'));
  FGenealogieWriter.OccuList.SaveToFile(ChangeFileExt(SaveDialog1.FileName,'o.txt'));
  FGenealogieWriter.PropList.SaveToFile(ChangeFileExt(SaveDialog1.FileName,'pr.txt'));
  FGenealogieWriter.ReligList.SaveToFile(ChangeFileExt(SaveDialog1.FileName,'r.txt'));
  FGenealogieWriter.PlacList.SaveToFile(ChangeFileExt(SaveDialog1.FileName,'p.txt'));
  FGenealogieWriter.Plac2List.SaveToFile(ChangeFileExt(SaveDialog1.FileName,'p2.txt'));
  FGenealogieWriter.FamClusterList_SaveToFile(ChangeFileExt(SaveDialog1.FileName,'fc.txt'));
  FGenealogieWriter.WriteIndIndex;
  FGenealogieWriter.SaveToSingleXml(ChangeFileExt(SaveDialog1.FileName,'1.fodt'));
  FGenealogieWriter.WriteOccIndex;
  FGenealogieWriter.WritePropIndex;
  FGenealogieWriter.WritePlaceIndex;
  FGenealogieWriter.WritePlace2Index;
     SaveFile(FGenealogieWriter.SaveToSingleXml,SaveDialog1.FileName);

    end;
end;

procedure TfrmGedCom2OdfMain.FormCreate(Sender: TObject);
begin
  FGedcomFile:=TGedComFile.Create;
  FGedComFile.OnLongOp:=GedComLongOp;
  FGedComFile.OnChildUpdate:=ChildUpdate;

  FGenealogieHelper:=TGenealogyHelper.Create;
  FGenealogieHelper.OnLongOp:=GedComLongOp;
  FGenealogieHelper.GedComFile:=FGedComFile;

  FGenealogieWriter:=TGenDocumentWriter.Create(self);
  FGenealogieWriter.OnLongOp:=GedComLongOp;
  FGenealogieWriter.Genealogy:=FGedComFile;

  FFraShowIndiv :=  TFraShowIndiv.Create(self);
  FFraShowIndiv.Parent := pnlDetail;
  FFraShowIndiv.Align:=alClient;
  FFraShowIndiv.OnFamBrowse:=btnGotoLinkClick;
  FFraShowIndiv.OnIndBrowse:=btnGotoLinkClick;
end;

procedure TfrmGedCom2OdfMain.FormDestroy(Sender: TObject);
begin
  FActGedObj:=nil;
  FreeAndNil(FGenealogieWriter);
  freeandnil(FGenealogieHelper);
  freeandnil(FGedComFile);

end;

procedure TfrmGedCom2OdfMain.FormShow(Sender: TObject);
Var
  CBCount, i: Integer;
Begin
  CBCount := Config1.getValue(cbxFilename, 'ICount', 0);
  For i := 0 To CBCount - 1 Do
    cbxFilename.Items.Add(Config1.getValue(cbxFilename, inttostr(i), ''))
End;

procedure TfrmGedCom2OdfMain.lblSetNameResultClick(Sender: TObject);
begin
  FGenealogieHelper.autoSetName;
    lblSetNameResult.Caption:=inttostr(FGenealogieHelper.pResult)+
      ' ('+IntToStr(FGenealogieHelper.mResult)+')';
end;

procedure TfrmGedCom2OdfMain.TreeView1CustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Node.Count=0 then
    GedCom2treenodes(Tgedcomobj(Node.Data),node.Owner,Node);
  DefaultDraw:=true;
end;

procedure TfrmGedCom2OdfMain.TreeView1SelectionChanged(Sender: TObject);
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
//      mmLog.Append('ActNode:'+lActNode.Description);
      // Find Master
//      lMaster := lActNode ;
//      lPath:= lactNode.NodeType;
//      mmLog.Append('ActMaster:'+TGedComObj(lMaster).ToString);
    end;
end;

procedure TfrmGedCom2OdfMain.ChildUpdate(Sender: TObject);
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

procedure TfrmGedCom2OdfMain.btnGotoLinkClick(Sender: TObject);
var
  lTn: TTreeNode;
begin
  lTn := TreeView1.Items.FindNodeWithData(Tobject(TControl(Sender).Tag));
  if assigned(lTn) then TreeView1.Select(ltn);
end;

procedure TfrmGedCom2OdfMain.GedComLongOp(Sender: TObject);
var
  Done: Boolean;
begin
  ProgressBar1.Max := FGedComFile.Count;
  if sender.InheritsFrom(TGedComObj) then
    ProgressBar1.Position:=ProgressBar1.Max-TGedComObj(sender).ID;
  ApplicationProperties1Idle(sender,Done{%H-});
  Application.ProcessMessages;
end;

procedure TfrmGedCom2OdfMain.LogEvent(s: String);
begin

end;

procedure TfrmGedCom2OdfMain.OnGedComReadUpdate(Sender: TObject);
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
end;

procedure TfrmGedCom2OdfMain.ResetStatistics;
begin
  fillchar(FStatistics,sizeof(FStatistics),0);
end;

procedure TfrmGedCom2OdfMain.UpdateStatistics;
  var
    lGobj: TGedComObj;
  begin
    ResetStatistics;
    for lGobj in FGedComFile do
      OnGedComReadUpdate(lGobj);
end;


end.

