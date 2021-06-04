unit fra_OdfFile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Buttons, Dialogs,
  ComCtrls, ValEdit, ActnList, StdActns,odf_types;

type

  { TFraOdfBrowser }

  TFraOdfBrowser = class(TFrame)
    actDoSomething: TAction;
    actFileLoad: TAction;
    actFileOpen: TFileOpen;
    actFileSave: TAction;
    actFileSaveAs: TFileSaveAs;
    alsXMLFile: TActionList;
    btnOpen: TBitBtn;
    btnFileLoad: TBitBtn;
    btnFileSave: TBitBtn;
    cbxFilename: TComboBox;
    edtXmlFileDetail: TMemo;
    ilsOdfFile: TImageList;
    pnlTop: TPanel;
    pnlClientClient: TPanel;
    SaveDialog1: TSaveDialog;
    Splitter2: TSplitter;
    splXmlFileEntry: TSplitter;
    trvOdfStructure: TTreeView;
    vleXmlFileEntry: TValueListEditor;
    procedure actFileLoadExecute(Sender: TObject);
    procedure actFileOpenAccept(Sender: TObject);
    procedure actFileOpenBeforeExecute(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure trvOdfStructureSelectionChanged(Sender: TObject);
    procedure UpdateTree(Sender: TObject);
 private
    FOdfFileName: String;
    FXMLDocument:TOdfDocument;
    procedure SetXmlDocument(AValue: TOdfDocument);

  public
     destructor Destroy; override;
     procedure Clear;
     procedure AfterConstruction; override;
     procedure LoadXMLFile(aFilename: string);
     property XmlDocument: TOdfDocument read FXmlDocument write SetXmlDocument;
     property Detail: TMemo read edtXmlFileDetail;

  end;

implementation

uses LAZ2_DOM;
{$R *.lfm}

{ TFraOdfBrowser }

procedure TFraOdfBrowser.actFileOpenBeforeExecute(Sender: TObject);
begin
  if FileExists(cbxFilename.Text) then
        actFileOpen.Dialog.FileName := cbxFilename.Text
    else
        actFileOpen.Dialog.FileName := '';
end;

procedure TFraOdfBrowser.BitBtn1Click(Sender: TObject);
begin

end;

procedure TFraOdfBrowser.trvOdfStructureSelectionChanged(Sender: TObject);
var
  i: Integer;
begin
    vleXmlFileEntry.Clear;
    edtXmlFileDetail.Clear;
    if assigned(trvOdfStructure.Selected) and
        Assigned(trvOdfStructure.Selected.Data) then
        if TObject(trvOdfStructure.Selected.Data).InheritsFrom(TXMLDocument) then
            with  TXMLDocument(trvOdfStructure.Selected.Data) do
              begin
                vleXmlFileEntry.strings.Add('ClassName=' +
                    TObject(trvOdfStructure.Selected.Data).ClassName);
                edtXmlFileDetail.Lines.Add(ansistring(TextContent));
                if assigned(Attributes) then
                    for i := 0 to Attributes.Length - 1 do
                        vleXmlFileEntry.strings.Add(
                            ansistring(Attributes.Item[i].NodeName + '=' + Attributes.Item[i].TextContent));
              end
        else if TObject(trvOdfStructure.Selected.Data).InheritsFrom(TDOMNode) then
            with  TDOMNode(trvOdfStructure.Selected.Data) do
              begin
                vleXmlFileEntry.strings.Add('ClassName=' +
                    TObject(trvOdfStructure.Selected.Data).ClassName);
                edtXmlFileDetail.Lines.Add(ansistring(TextContent));
                if assigned(Attributes) then
                    for i := 0 to Attributes.Length - 1 do
                        vleXmlFileEntry.strings.Add(
                            ansistring(Attributes.Item[i].NodeName + '=' + Attributes.Item[i].TextContent));
              end
        else
            vleXmlFileEntry.strings.Add('ClassName=' +
                TObject(trvOdfStructure.Selected.Data).ClassName);
end;

procedure TFraOdfBrowser.UpdateTree(Sender: TObject);
  procedure AppendChilds(Parent: TTreeNode; XMLNodes: TDOMNodeList);

  var
      LNewNode: TTreeNode;
      i: integer;
  begin
      if assigned(XMLNodes) then
          for i := 0 to XMLNodes.Count - 1 do
              if not XMLNodes[i].InheritsFrom(TDOMText) then
                begin
                  LNewNode :=
                      parent.TreeNodes.AddChild(Parent, ansistring(XMLNodes[i].NodeName));
                  with LNewNode do
                    begin
                      Data := XMLNodes[i];
                      AppendChilds(LNewNode, XMLNodes[i].ChildNodes);
                    end;
                end
              else if  XMLNodes.Count >1 then
                begin
                   LNewNode :=
                      parent.TreeNodes.AddChild(Parent, 'text' );
                   LNewNode.Data:=XMLNodes[i];
                end;

  end;

var
  Root, LNewNode: TTreeNode;
begin
  trvOdfStructure.Items.Clear;
  if not assigned(FXMLDocument) then
      exit;
  Root := trvOdfStructure.Items.AddChild(nil, '<ROOT>');
  with Root do
    begin
      Data := FXMLDocument.XmlDocument;
      AppendChilds(root, FXMLDocument.XmlDocument.ChildNodes);
    end;
  with Root do
    begin
      LNewNode :=
          Root.TreeNodes.AddChild(root, '<BODY>');
      with LNewNode do
        begin
          Data := FXMLDocument.body;
          AppendChilds(LNewNode, FXMLDocument.body.ChildNodes);
        end;
    end;
end;

procedure TFraOdfBrowser.SetXmlDocument(AValue: TOdfDocument);
begin
  if FXmlDocument=AValue then Exit;
  FXmlDocument:=AValue;
end;

destructor TFraOdfBrowser.Destroy;
begin
   FreeAndNil(FXMLDocument);
  inherited Destroy;
end;

procedure TFraOdfBrowser.Clear;
begin
  trvOdfStructure.Items.Clear;
  if Assigned(FXMLDocument) then
     FreeAndNil(FXMLDocument);
end;

procedure TFraOdfBrowser.AfterConstruction;
begin
  inherited AfterConstruction;
end;

procedure TFraOdfBrowser.LoadXMLFile(aFilename: string);
begin
   if not FileExists(aFilename) then
        exit;
    if Assigned(FXMLDocument) then
        FreeAndNil(FXMLDocument);
   FOdfFileName:=aFilename;
   FXMLDocument := TOdfTextDocument.LoadFromFile(FOdfFileName);
end;

procedure TFraOdfBrowser.actFileOpenAccept(Sender: TObject);
begin
  FOdfFileName := actFileOpen.Dialog.FileName;
     cbxFilename.Text := FOdfFileName;
     actFileLoad.Execute;
end;

procedure TFraOdfBrowser.actFileLoadExecute(Sender: TObject);
begin
  if not FileExists(FOdfFileName) then
        exit;
    if Assigned(FXMLDocument) then
        FreeAndNil(FXMLDocument);
    FXMLDocument := TOdfTextDocument.LoadFromFile(FOdfFileName);
    UpdateTree(Sender);
end;

end.

