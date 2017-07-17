unit frm_XMLDoc2po;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DOM, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ActnList, fra_XMLFile, fra_PoFile;

type
  TChapters = array[1..4] of integer;
  { TfrmXml2PoMain }

  TfrmXml2PoMain = class(TForm)
    actXmlProcessX2Po: TAction;
    actXmlProcessPo2X: TAction;
    alsXmlProcess: TActionList;
    btnProcessXml2Po: TBitBtn;
    btnProcessPo2Pas: TSpeedButton;
    btnSelectDir: TSpeedButton;
    edtSourceDir: TLabeledEdit;
    fraPoFile1: TfraPoFile;
    fraXmlFile1: TfraXmlFile;
    pnlLeft: TPanel;
    pnlProcessing: TPanel;
    pnlTop: TPanel;
    pnlTopRight: TPanel;
    procedure actXmlProcessPo2XExecute(Sender: TObject);
    procedure actXmlProcessX2PoExecute(Sender: TObject);
    procedure edtSourceDirChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure parsePhrase(Path, Phrase: String; Chapter: TChapters);
    function SetNewPhrase(Path: string; Phrase: DOMString; Chapter: TChapters
      ): DOMString;
  public
    function AnalyzePhrase(Phr:String;out Excepts:TStringArray):String;
    Function BuildPhrase(PhrStmp:String;Const Excepts:TStringArray):String;
  end;

var
  frmXml2PoMain: TfrmXml2PoMain;

implementation

{$R *.lfm}

{ TfrmXml2PoMain }

procedure TfrmXml2PoMain.edtSourceDirChange(Sender: TObject);
begin
  fraPoFile1.BaseDir := edtSourceDir.Text;
end;


Procedure TfrmXml2PoMain.parsePhrase(Path,Phrase:String;Chapter:TChapters);

var
  exc, lTrans: TStringArray;
  lPhraseStumb: String;

begin
  lPhraseStumb := AnalyzePhrase(Phrase,exc);
  SetLength(lTrans,4);
  lTrans[0]:=lPhraseStumb;
  lTrans[1]:=lPhraseStumb;
  fraPoFile1.AppendData(path,lTrans);
end;

Function TfrmXml2PoMain.SetNewPhrase(Path:string;Phrase:DOMString;Chapter:TChapters):DOMString;

var
  exc: TStringArray;
  {%H-}lPhraseStumb, lTransStumb: String;
  lid: Integer;
begin
  lPhraseStumb := AnalyzePhrase(ansistring(Phrase),exc);
  lid := fraPoFile1.LookUpIdent(path);
  if lid <0 then
     lid := fraPoFile1.LookUpSource(lPhraseStumb);
  if lid >=0 then
    lTransStumb:=fraPoFile1.GetTranslText(lid);
  if lTransStumb <> ''  then
    result :=DOMString( BuildPhrase(lTransStumb,exc))
  else
    result := Phrase;
end;

procedure TfrmXml2PoMain.actXmlProcessX2PoExecute(Sender: TObject);

var Chapter:TChapters;

  procedure ParseChilds(Parent: String;Flag1,Flag2:boolean; XMLNodes: TDOMNodeList);

  var
      LNewNode: string;
      i: integer;
      lBailout, lInterest1, lInterest2, lInterest3, lBailout2: Boolean;
      lOutlLev, j: Longint;
  begin
      if assigned(XMLNodes) then
          for i := 0 to XMLNodes.Count - 1 do
              if not XMLNodes[i].InheritsFrom(TDOMText) then
                begin
                  LNewNode := Parent+'['+IntToStr(i)+']'+DirectorySeparator+ ansistring(XMLNodes[i].NodeName);
                  lBailout := ansistring(XMLNodes[i].NodeName) = 'draw:image';
                  lBailout2 := ansistring(XMLNodes[i].NodeName) = 'text:span';
                  lInterest1:= ansistring(XMLNodes[i].NodeName) = 'office:text';
                  lInterest2:= ansistring(XMLNodes[i].NodeName) = 'text:p';
                  lInterest3:= ansistring(XMLNodes[i].NodeName) = 'text:h';
                  if lInterest3 then
                    begin
                      trystrtoint( XMLNodes[i].Attributes.GetNamedItem('text:outline-level').TextContent{%H-},lOutlLev);
                      inc(Chapter[lOutlLev]);
                      for j := lOutlLev+1 to 4 do Chapter[j]:=0;
                    end;
                  if lBailout or lBailout2 then break;
                  if assigned(XMLNodes[i].ChildNodes) and  (XMLNodes[i].ChildNodes.Count>0)  then
                    ParseChilds(LNewNode,Flag1 or lInterest1,Flag2 or lInterest2, XMLNodes[i].ChildNodes)

                end
             else
               if Flag1 and Flag2  and (trim(XMLNodes[i].TextContent) <> '')   then
                  begin
                    if not lInterest3 then inc(Chapter[4]);
                    ParsePhrase(parent,trim(ansistring(TDOMText(XMLNodes[i]).Data)),Chapter);
                  end;


  end;


begin
  Chapter[1]:=0;
  ParseChilds('',false,false,fraXMLFile1.XmlDocument.ChildNodes);
end;

procedure TfrmXml2PoMain.actXmlProcessPo2XExecute(Sender: TObject);

var Chapter:TChapters;

  procedure ParseChilds(Parent: String;Flag1,Flag2:boolean; XMLNodes: TDOMNodeList);

  var
      LNewNode: string;
      i: integer;
      lBailout, lInterest1, lInterest2, lInterest3, lBailout2,
        lBailout2b: Boolean;
      lOutlLev, j: Longint;
  begin
      if assigned(XMLNodes) then
          for i := 0 to XMLNodes.Count - 1 do
              if not XMLNodes[i].InheritsFrom(TDOMText) then
                begin
                  LNewNode := Parent+'['+IntToStr(i)+']'+DirectorySeparator+ ansistring(XMLNodes[i].NodeName);
                  lBailout := ansistring(XMLNodes[i].NodeName) = 'draw:image';
                  lBailout2 := ansistring(XMLNodes[i].NodeName) = 'text:span';
                  lBailout2b := (i<XMLNodes.Count-1) and  (ansistring(XMLNodes[i+1].NodeName) = 'text:span');
                  lInterest1:= ansistring(XMLNodes[i].NodeName) = 'office:text';
                  lInterest2:= ansistring(XMLNodes[i].NodeName) = 'text:p';
                  lInterest3:= ansistring(XMLNodes[i].NodeName) = 'text:h';
                  if lInterest3 then
                    begin
                      trystrtoint( XMLNodes[i].Attributes.GetNamedItem('text:outline-level').TextContent,lOutlLev);
                      inc(Chapter[lOutlLev]);
                      for j := lOutlLev+1 to 4 do Chapter[j]:=0;
                    end;
                  if lBailout or (lBailout2 or lBailout2b) then
                   else
                  if assigned(XMLNodes[i].ChildNodes) and  (XMLNodes[i].ChildNodes.Count>0) then
                    ParseChilds(LNewNode,Flag1 or lInterest1,Flag2 or lInterest2 or lInterest3, XMLNodes[i].ChildNodes);
                end
              else    if (trim(TDOMText(XMLNodes[i]).Data) <> '') and (flag1 or Flag2)  then
                begin
                  if not lInterest3 then inc(Chapter[4]);
                  XMLNodes[i].TextContent:=SetNewPhrase(Parent,XMLNodes[i].TextContent,Chapter);
                end;
  end;


begin
  Chapter[1]:=0;
   ParseChilds('',false,false,fraXMLFile1.XmlDocument.ChildNodes);
end;

procedure TfrmXml2PoMain.FormResize(Sender: TObject);
var
  lWidth: Integer;
begin
    lWidth := (ClientWidth - 30) div 3;
    fraPoFile1.Width := lWidth;
    pnlleft.Width := lWidth*2;
end;

procedure TfrmXml2PoMain.FormShow(Sender: TObject);
begin
  edtSourceDirChange(Sender);
end;

function TfrmXml2PoMain.AnalyzePhrase(Phr: String; out Excepts: TStringArray
  ): String;
var
  copyMode: Boolean;
  i: Integer;
begin
  setlength(Excepts,0);
  result := '';
  copyMode:=true;
  Phr:=StringReplace(Phr,'/','//',[rfReplaceAll]);
  Phr:=StringReplace(Phr,'%','/%',[rfReplaceAll]);
  for i := 1 to length(Phr) do
    if copymode then
    begin
      if charinset(copy(phr,i,1)[1],['0'..'9']) or
        ((copy(phr,i,1)='-') and (i<length(Phr)) and charinset(copy(phr,i+1,1)[i],['0'..'9'])) then
        begin
          CopyMode := false;
          setlength(Excepts,high(Excepts)+2);
          Excepts[high(Excepts)] += copy(phr,i,1);
          result +='%'+inttostr(high(Excepts))+':s';
        end
      else
        result += copy(phr,i,1);
    end
    else
      if charinset(copy(phr,i,1)[1],['%','.','0'..'9']) or
        (charinset(copy(phr,i,1)[1],['-','/',':']) and (i<length(Phr)) and charinset(copy(phr,i+1,1)[1],['/','%','0'..'9'])) then
          Excepts[high(Excepts)] += copy(phr,i,1)
        else
          begin
            copymode := true;
            result += copy(phr,i,1);
          end;
end;

function TfrmXml2PoMain.BuildPhrase(PhrStmp: String; const Excepts: TStringArray
  ): String;


var
  phr: String;
  i: Integer;
begin
  phr := PhrStmp;
  for i := 0 to high(Excepts) do
     Phr:=StringReplace(Phr,'%'+inttostr(i)+':s',Excepts[i],[rfReplaceAll]);
  Phr:=StringReplace(Phr,'/%','%',[rfReplaceAll]);
  result:=StringReplace(Phr,'//','/',[rfReplaceAll]);
end;

end.

