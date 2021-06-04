unit fra_PdfXmlView;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, Buttons, StdCtrls,
    ComCtrls, Dialogs, ActnList, Menus, StdActns,  DOM;

type

    { TfraXmlView }

    TfraXmlView = class(TFrame)
        actDoSomething: TAction;
        actFileSave: TAction;
        actFileLoad: TAction;
        actFileOpen: TFileOpen;
        actFileSaveAs: TFileSaveAs;
        PaintBox1: TPaintBox;
        procedure actFileLoadExecute(Sender: TObject);
        procedure actFileOpenAccept(Sender: TObject);
        procedure PaintBox1Paint(Sender: TObject);
    private
        { private declarations }
        FXMLDocument: TXMLDocument;
        FXmlFileName: string;
        function GetText: string;
        procedure SetXmlDocument(AValue: TXMLDocument);
    protected
    public
        destructor Destroy; override;
        procedure Clear;
        procedure AfterConstruction; override;
        procedure LoadXMLFile(aFilename: string);
        property XmlDocument: TXMLDocument read FXmlDocument write SetXmlDocument;
        property Text: string read GetText;
    end;

implementation

{$R *.lfm}

uses XMLRead, Graphics;

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

{ TfraXmlView }

procedure TfraXmlView.PaintBox1Paint(Sender: TObject);
var
    lxPage, lChnode: TDOMNode;
    lWidth, lFaktor, lHeight, lChHeight, lChWidth, lChY, lChX: extended;
    lFormatsetting: TFormatSettings;
    i, J: integer;
    sNodeText: string;

 function WideStrToFloat(aWS:WideString;fs:TFormatSettings):Extended;inline;
 begin
       result:= StrToFloat(AnsiString(aWS),fs);
 end;

begin
    if assigned(FXMLDocument) then
      begin
        lxPage := FXMLDocument.FindNode('DOCUMENT').FindNode('PAGE');
        lFormatsetting.DecimalSeparator := '.';
        lWidth := WideStrToFloat(lxPage.Attributes.GetNamedItem(
            'width').NodeValue, lFormatsetting);
        lHeight := StrToFloat(
            ansistring(lxPage.Attributes.GetNamedItem('height').NodeValue),
            lFormatsetting);
        lFaktor := PaintBox1.Width / lWidth;
        if (PaintBox1.Height / lHeight) < lFaktor then
            lFaktor := PaintBox1.Height / lHeight;
        PaintBox1.Canvas.Rectangle(0, 0, trunc(lWidth * lFaktor),
            trunc(lHeight * lFaktor));
        for i := 0 to lxPage.ChildNodes.Count - 1 do
            if lxPage.ChildNodes[i].NodeName = 'IMAGE' then
              begin
                lChnode := lxPage.ChildNodes[i];
                lChX := WideStrToFloat(lChnode.Attributes.GetNamedItem(
                    'x').NodeValue, lFormatsetting);
                lChY := WideStrToFloat(lChnode.Attributes.GetNamedItem(
                    'y').NodeValue, lFormatsetting);
                lChWidth := WideStrToFloat(lChnode.Attributes.GetNamedItem(
                    'width').NodeValue, lFormatsetting);
                lChHeight := WideStrToFloat(lChnode.Attributes.GetNamedItem(
                    'height').NodeValue, lFormatsetting);
                PaintBox1.Canvas.Rectangle(trunc(lChX * lFaktor),
                    trunc(lchy * lFaktor), trunc((lchx + lchWidth) * lFaktor),
                    trunc((lChy + lChHeight) * lFaktor));
              end
            else if lxPage.ChildNodes[i].NodeName = 'TEXT' then
              begin
                for J := 0 to lxPage.ChildNodes[i].ChildNodes.Count - 1 do
                  begin
                    lChnode := lxPage.ChildNodes[i].ChildNodes[j];
                    lChX := WideStrToFloat(lChnode.Attributes.GetNamedItem('x').NodeValue,
                        lFormatsetting);
                    lChY := WideStrToFloat(lChnode.Attributes.GetNamedItem(
                        'y').NodeValue, lFormatsetting);
                    lChWidth :=
                        WideStrToFloat(lChnode.Attributes.GetNamedItem('width').NodeValue,
                        lFormatsetting);
                    lChHeight :=
                        WideStrToFloat(lChnode.Attributes.GetNamedItem('height').NodeValue,
                        lFormatsetting);
                    if assigned(lChnode.Attributes.GetNamedItem('serif')) and
                        (lChnode.Attributes.GetNamedItem('serif').NodeValue = 'yes') then
                        PaintBox1.Canvas.Font.Name := 'Times New Roman'
                    else
                        PaintBox1.Canvas.Font.Name := 'Arial';
                    PaintBox1.Canvas.Font.Bold :=
                        (lChnode.Attributes.GetNamedItem('bold').NodeValue = 'yes');
                    PaintBox1.Canvas.Font.Italic :=
                        (lChnode.Attributes.GetNamedItem('italic').NodeValue = 'yes');
                    PaintBox1.Canvas.Font.Height := trunc((lChHeight) * lFaktor * 0.95);
                    PaintBox1.canvas.Font.Color := clBlack;
                    PaintBox1.Canvas.Brush.Style := bsSolid;
                    sNodeText := UnicodeString(lChnode.TextContent);
                    PaintBox1.Canvas.TextOut(trunc(lChX * lFaktor),
                        trunc(lchy * lFaktor), sNodetext);
                  end;
              end;

      end;
end;

procedure TfraXmlView.actFileLoadExecute(Sender: TObject);
begin
    if not FileExists(FXmlFileName) then
        exit;
    if Assigned(FXMLDocument) then
        FreeAndNil(FXMLDocument);

    ReadXMLFile(FXMLDocument, FXmlFileName);
    PaintBox1.Invalidate;
end;

procedure TfraXmlView.actFileOpenAccept(Sender: TObject);
begin
    FXmlFileName := actFileOpen.Dialog.FileName;
    actFileLoad.Execute;
end;

procedure TfraXmlView.SetXmlDocument(AValue: TXMLDocument);
begin
    if FXmlDocument = AValue then
        Exit;
    FXmlDocument := AValue;
end;

function TfraXmlView.GetText: string;
var
    lxPage, lChnode: TDOMNode;
    i, J: integer;
    sNodeText, lYtext: string;
    lFormatsetting: TFormatSettings;
    lActY, lLastY: extended;
begin
    Result := '';
    lLastY:= -1;
    if assigned(FXMLDocument) then
      begin
        lxPage := FXMLDocument.FindNode('DOCUMENT').FindNode('PAGE');
        lFormatsetting.DecimalSeparator := '.';
        for i := 0 to lxPage.ChildNodes.Count - 1 do
            if lxPage.ChildNodes[i].NodeName = 'TEXT' then
              begin
                lChnode := lxPage.ChildNodes[i];
                lYtext:=ansistring(lChnode.Attributes.GetNamedItem(
                    'y').NodeValue);
                if TryStrToFloat(lYtext,lActY, lFormatsetting)then
                  begin
                if (Result <> '') and (abs(lacty - lLastY) > 0.1) then
                    Result := Result + LineEnding;
                lLastY := lActY;
                for J := 0 to lxPage.ChildNodes[i].ChildNodes.Count - 1 do
                  begin
                    lChnode := lxPage.ChildNodes[i].ChildNodes[j];
                    sNodeText := UnicodeString(lChnode.TextContent);
                    if (i > 0) and (length(sNodeText) > 0) and
                        ((length(sNodeText) > 2)or ((length(sNodeText) = 2) and
                        (copy(sNodeText, 2, 1)[1] in ['a'..'z'])) or
                        not (copy(sNodeText, 1, 1)[1] in ['a'..'z'])) then
                        Result := Result + ' ';
                    Result := Result + sNodeText;
                  end;

                  end;
              end;

      end;
end;

procedure TfraXmlView.AfterConstruction;
begin
    inherited AfterConstruction;
    //   lblCompiledOn.Caption := format(lblCompiledOn.Caption, [CDate, CName]);
end;

procedure TfraXmlView.LoadXMLFile(aFilename: string);
begin
    FXmlFileName := aFilename;
    actFileLoadExecute(self);
end;

destructor TfraXmlView.Destroy;
begin
    if assigned(FXMLDocument) then
        FreeAndNil(FXMLDocument);
    inherited Destroy;
end;

procedure TfraXmlView.Clear;
begin
    FreeAndNil(FXMLDocument);
    FXmlFileName := '';
end;

end.
