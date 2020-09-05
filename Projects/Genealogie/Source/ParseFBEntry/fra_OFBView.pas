unit fra_OFBView;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, odf_types, Unt_IData;

type

    { TFraOFBView }

    TFraOFBView = class(TFrame, IDataRO)
        ListBox1: TListBox;
        Memo1: TMemo;
        Splitter1: TSplitter;
        procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    private
        fOdfFile: TOdfDocument;
        FOnUpdate: TNotifyEvent;
        FStringlist:Tstringlist;
        procedure ExtractEntry(Idx: Integer; const lStr: TStrings);
        function GetCount: integer;
        function GetLines: TStrings; overload;
        function GetSelCount: integer;
        function GetSelected(Index: integer): boolean;
        procedure SetSelected(Index: integer; AValue: boolean);
    public
        constructor Create(TheOwner: TComponent); override;
        destructor Destroy; override;
        procedure LoadFile(Filename: string);
        /// <INFO>GetData liefert einen (den aktellen) kompletten Datensatz.</INFO>
        function getdata: variant;
        function GetLines(Index: integer): TStrings; overload;
        procedure First(Sender: TObject = nil);
        procedure Last(Sender: TObject = nil);
        procedure Next(Sender: TObject = nil);
        procedure Previous(Sender: TObject = nil);
        procedure Seek(aID: integer);
        function GetActID: integer;
        function GetOnUpdate: TNotifyEvent;
        procedure SetOnUpdate(AValue: TNotifyEvent);
        function EOF: boolean;
        function BOF: boolean;
        property Data: variant read getdata;
        property Lines: TStrings read GetLines;
        property Count: integer read GetCount;
        property SelCount: integer read GetSelCount;
        property Selected[Index: integer]: boolean read GetSelected write SetSelected;
    end;

implementation

uses Laz2_DOM, Unt_StringProcs;

{$R *.lfm}

{ TFraOFBView }

procedure TFraOFBView.ListBox1SelectionChange(Sender: TObject; User: boolean);
var
    lStr: TStrings;

begin
    lStr := Memo1.Lines;
    ExtractEntry(ListBox1.itemindex,lStr);
    if assigned(FOnUpdate) then
        FOnUpdate(self);
end;

function TFraOFBView.GetLines: TStrings;
begin
    Result := memo1.Lines;
end;

procedure TFraOFBView.ExtractEntry(Idx:Integer;const lStr: TStrings);
var
  lLine,lTc: string;
  lNextNode: TDOMNode;
  lTestNode: TDOMNode;
  lNodeName: DOMString;
begin
  lstr.Clear;
  lTestNode := TDOMNode(listbox1.Items.Objects[Idx]);
  if Idx < Listbox1.Items.Count - 1 then
      lNextNode := TDOMNode(listbox1.Items.Objects[Idx + 1])
  else
      lnextNode := TDOMNode(lTestNode.GetNextNodeSkipChildren);
  lLine := '';
  while assigned(ltestnode) and (ltestnode <> lnextnode) and
      (lTestNode.textcontent <> '§') and (lTestNode.NodeName <> 'text:h') do
    begin
      lNodeName := lTestnode.Nodename;
      lTc := lTestNode.TextContent;
      if lTestnode.ClassNameIs('TDOMText') then
          lLine := lLine + lTestNode.TextContent;
      if lTestnode.Nodename = 'text:tab' then
          lline := lline + #9;
      if (lTestnode.Nodename = 'text:line-break') or
          (lTestnode.Nodename = 'text:p') and (lLine <> '') then
        begin
          lStr.Append(lline);
          lline := '';
        end;
      lTestNode := TDOMNode(lTestNode.GetNextNode);
    end;
  if lline <> '' then
      lStr.Append(lline);
end;

function TFraOFBView.GetCount: integer;
begin
  result := ListBox1.Count;
end;

function TFraOFBView.GetSelCount: integer;
begin
  Result := ListBox1.SelCount;
end;

function TFraOFBView.GetSelected(Index: integer): boolean;
begin
  result := ListBox1.Selected[Index];
end;

procedure TFraOFBView.SetSelected(Index: integer; AValue: boolean);
begin
  ListBox1.Selected[Index]:=AValue;
end;

constructor TFraOFBView.Create(TheOwner: TComponent);
begin
    inherited Create(TheOwner);
    FStringlist:=TStringList.Create;
    fOdfFile := nil;
end;

destructor TFraOFBView.Destroy;
begin
    FOnUpdate := nil;
    FreeAndNil(fOdfFile);
    freeandnil(FStringlist);
    inherited Destroy;
end;

procedure TFraOFBView.LoadFile(Filename: string);
var
    lParas: TDOMNodeList;
    lTestNode: TDOMNode;
    i: integer;
    lNodeValue: string;
    lEntryFlag: boolean;
begin
    ListBox1.Clear;
    FreeAndNil(fOdfFile);
    fOdfFile := TOdfTextDocument.LoadFromFile(Filename);
    lParas := fOdfFile.Body.FindNode('office:text').ChildNodes;
    if (lParas.Count < 6) and (lParas.Count > 3) then
        lparas := lparas.item[3].ChildNodes;
    lEntryFlag := False;
    for i := 0 to lParas.Count - 1 do
      begin
        lTestNode := lParas.Item[i];
        lNodeValue := lTestNode.TextContent;
        if (lTestNode.NodeName = 'text:p') and (length(lNodeValue) > 3) and
            (lNodeValue[1] in Ziffern + [#9, ' '[1]]) and
            (lNodeValue[2] <> ')') and (lNodeValue[2] <> '.') and (lNodeValue[2] <> '●'[2]) and
            (lNodeValue[3] <> ')') then
          begin
            listbox1.AddItem(lNodeValue, lTestNode);
            lEntryFlag := True;
          end;
        if lEntryFlag and (lTestNode.NodeName = 'text:h') and
            (lTestNode.TextContent = 'A') then
            break; // Todo: Register
      end;
end;

function TFraOFBView.getdata: variant;
begin
    Result := memo1.Text;
end;

function TFraOFBView.GetLines(Index: integer): TStrings;
begin
  ExtractEntry(Index,FStringlist);
  result := FStringlist;
end;

procedure TFraOFBView.First(Sender: TObject);
begin
    listbox1.ItemIndex := 0;
end;

procedure TFraOFBView.Last(Sender: TObject);
begin
    listbox1.ItemIndex := listbox1.Items.Count - 1;
end;

procedure TFraOFBView.Next(Sender: TObject);
begin
    if not EOF then
        listbox1.ItemIndex := listbox1.ItemIndex + 1;
end;

procedure TFraOFBView.Previous(Sender: TObject);
begin
    if not BOF then
        listbox1.ItemIndex := listbox1.ItemIndex - 1;
end;

procedure TFraOFBView.Seek(aID: integer);
begin
    if listbox1.ItemIndex = aID then
        exit;
    listbox1.ItemIndex := aID;
end;

function TFraOFBView.GetActID: integer;
begin
    Result := listbox1.ItemIndex;
end;

function TFraOFBView.GetOnUpdate: TNotifyEvent;
begin
    Result := FOnUpdate;
end;

procedure TFraOFBView.SetOnUpdate(AValue: TNotifyEvent);
begin
    if AValue = FOnUpdate then
        exit;
    FOnUpdate := AValue;
end;

function TFraOFBView.EOF: boolean;
begin
    Result := listbox1.ItemIndex >= listbox1.Items.Count - 1;
end;

function TFraOFBView.BOF: boolean;
begin
    Result := listbox1.ItemIndex <= 0;
end;

end.
