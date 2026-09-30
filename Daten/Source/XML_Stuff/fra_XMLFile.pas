unit fra_XMLFile;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, Buttons, StdCtrls,
    ComCtrls, Dialogs, ActnList, Menus, StdActns, ValEdit, DOM;

type

    { TfraXmlFile }

    TfraXmlFile = class(TFrame)
        actFileSave: TAction;
        actFileLoad: TAction;
        alsXMLFile: TActionList;
        actFileOpen: TFileOpen;
        actFileSaveAs: TFileSaveAs;
        ilsXmlFile: TImageList;
        lblCompiledOn: TLabel;
        edtXmlFilename: TLabeledEdit;
        edtXmlFileDetail: TMemo;
        OpenDialog1: TOpenDialog;
        pnlClientClient: TPanel;
        pnlTopRight: TPanel;
        pnlRightTop: TPanel;
        pnlTop: TPanel;
        PopupMenu1: TPopupMenu;
        SaveDialog1: TSaveDialog;
        btnXmlFileOpen: TSpeedButton;
        btnXmlFileSave_: TSpeedButton;
        btnXmlFileLoad: TSpeedButton;
        splXmlFileEntry: TSplitter;
        Splitter2: TSplitter;
        trvXmlStructure: TTreeView;
        vleXmlFileEntry: TValueListEditor;
        procedure actFileLoadExecute(Sender: TObject);
        procedure actFileOpenAccept(Sender: TObject);
        procedure actFileOpenBeforeExecute(Sender: TObject);
        procedure actFileSaveAsBeforeExecute(Sender: TObject);
        procedure actFileSaveExecute(Sender: TObject);
        procedure edtXmlFilenameExit(Sender: TObject);
        procedure trvXmlStructureSelectionChanged(Sender: TObject);
        procedure UpdateTree(Sender: TObject);
    private
        { private declarations }
        FXMLDocument: TXMLDocument;
        FXmlFileName: string;
        procedure SetXmlDocument(AValue: TXMLDocument);
    protected
    public
        destructor Destroy; override;
        procedure Clear;
        procedure AfterConstruction; override;
        procedure LoadXMLFile(aFilename: string);
        property XmlDocument: TXMLDocument read FXmlDocument write SetXmlDocument;
        property Detail: TMemo read edtXmlFileDetail;
    end;

implementation

{$R *.lfm}

uses XMLRead, XMLWrite, unt_CDate;

procedure ReadXMLFile(out TheDoc: TXMLDocument; AFileName: string);
var
    Parser: TDOMParser;
    Src: TXMLInputSource;
    AStream: TStream;

begin
      try
        AStream := TFileStream.Create(AFilename, fmOpenRead + fmShareDenyWrite);
        Parser := TDOMParser.Create;
        Src := TXMLInputSource.Create(AStream);
        Parser.Options.Validate := True;
        Parser.Options.PreserveWhitespace := True;
        // Festlegen einer Methode, die bei Fehlern aufgerufen wird
        //    Parser.OnError := @ErrorHandler;
        Parser.Parse(Src, TheDoc);
      finally
        Src.Free;
        Parser.Free;
        AStream.Free;
      end;
end;

{ TfraXmlFile }

procedure TfraXmlFile.trvXmlStructureSelectionChanged(Sender: TObject);
var
    i: integer;
begin
    vleXmlFileEntry.Clear;
    edtXmlFileDetail.Clear;
    if assigned(trvXmlStructure.Selected) and
        Assigned(trvXmlStructure.Selected.Data) then
        if TObject(trvXmlStructure.Selected.Data).InheritsFrom(TXMLDocument) then
            with  TXMLDocument(trvXmlStructure.Selected.Data) do
              begin
                vleXmlFileEntry.strings.Add('ClassName=' +
                    TObject(trvXmlStructure.Selected.Data).ClassName);
                edtXmlFileDetail.Lines.Add(ansistring(TextContent));
                if assigned(Attributes) then
                    for i := 0 to Attributes.Length - 1 do
                        vleXmlFileEntry.strings.Add(
                            ansistring(Attributes.Item[i].NodeName + '=' + Attributes.Item[i].TextContent));
              end
        else if TObject(trvXmlStructure.Selected.Data).InheritsFrom(TDOMNode) then
            with  TDOMNode(trvXmlStructure.Selected.Data) do
              begin
                vleXmlFileEntry.strings.Add('ClassName=' +
                    TObject(trvXmlStructure.Selected.Data).ClassName);
                edtXmlFileDetail.Lines.Add(ansistring(TextContent));
                if assigned(Attributes) then
                    for i := 0 to Attributes.Length - 1 do
                        vleXmlFileEntry.strings.Add(
                            ansistring(Attributes.Item[i].NodeName + '=' + Attributes.Item[i].TextContent));
              end
        else
            vleXmlFileEntry.strings.Add('ClassName=' +
                TObject(trvXmlStructure.Selected.Data).ClassName);
end;

procedure TfraXmlFile.actFileSaveExecute(Sender: TObject);

const
    cBackUpExt = '.bak';
    cNewExt = '.new';
begin
    if Fileexists(ChangeFileExt(FXmlFilename, cNewExt)) then
        DeleteFile(ChangeFileExt(FXmlFilename, cNewExt));
    WriteXMLFile(FXMLDocument, ChangeFileExt(FXmlFilename, cNewExt));
    if FileExists(FXmlFilename) then
      begin
        if Fileexists(ChangeFileExt(FXmlFilename, cBackUpExt)) then
            DeleteFile(ChangeFileExt(FXmlFilename, cBackUpExt));
        RenameFile(FXmlFilename, ChangeFileExt(FXmlFilename, cBackUpExt));
      end;
    RenameFile(ChangeFileExt(FXmlFilename, cNewExt), FXmlFilename);
end;

procedure TfraXmlFile.edtXmlFilenameExit(Sender: TObject);
begin
    FXmlFileName := edtXmlFilename.Text;
end;

procedure TfraXmlFile.actFileSaveAsBeforeExecute(Sender: TObject);
begin
    SaveDialog1.FileName := edtXmlFilename.Text;
    if SaveDialog1.Execute then
      begin
        FXmlFileName := SaveDialog1.FileName;
        edtXmlFilename.Text := FXmlFileName;
        actFileSave.Execute;
      end;
end;

procedure TfraXmlFile.actFileOpenBeforeExecute(Sender: TObject);
begin
    if FileExists(edtXmlFilename.Text) then
        actFileOpen.Dialog.FileName := edtXmlFilename.Text
    else
        actFileOpen.Dialog.FileName := '';
end;

procedure TfraXmlFile.actFileLoadExecute(Sender: TObject);
begin
    if not FileExists(FXmlFileName) then
        exit;
    if Assigned(FXMLDocument) then
        FreeAndNil(FXMLDocument);

    ReadXMLFile(FXMLDocument, FXmlFileName);
    UpdateTree(Sender);
end;

procedure TfraXmlFile.actFileOpenAccept(Sender: TObject);
begin
    FXmlFileName := actFileOpen.Dialog.FileName;
    edtXmlFilename.Text := FXmlFileName;
    actFileLoad.Execute;
end;

procedure TfraXmlFile.UpdateTree(Sender: TObject);

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
                  end;
    end;

var
    Root: TTreeNode;
begin
    trvXmlStructure.Items.Clear;
    if not assigned(FXMLDocument) then
        exit;
    Root := trvXmlStructure.Items.AddChild(nil, '<ROOT>');
    with Root do
      begin
        Data := FXMLDocument;
        AppendChilds(root, FXMLDocument.ChildNodes);
      end;
end;

procedure TfraXmlFile.SetXmlDocument(AValue: TXMLDocument);
begin
    if FXmlDocument = AValue then
        Exit;
    FXmlDocument := AValue;
    UpdateTree(self);
end;

procedure TfraXmlFile.AfterConstruction;
begin
    inherited AfterConstruction;
    lblCompiledOn.Caption := format(lblCompiledOn.Caption, [CDate, CName]);
end;

procedure TfraXmlFile.LoadXMLFile(aFilename: string);
begin
    FXmlFileName := aFilename;
    edtXmlFilename.Text := FXmlFileName;
    actFileLoad.Execute;
end;

destructor TfraXmlFile.Destroy;
begin
    trvXmlStructure.Items.Clear;
    if assigned(FXMLDocument) then
        FreeAndNil(FXMLDocument);
    inherited Destroy;
end;

procedure TfraXmlFile.Clear;
begin
    FreeAndNil(FXMLDocument);
    FXmlFileName := '';
    edtXmlFilename.Text := '';
    trvXmlStructure.Items.Clear;
    vleXmlFileEntry.Clear;
    edtXmlFileDetail.Clear;
end;

end.
