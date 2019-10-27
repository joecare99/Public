unit Frm_WriteOdfMain;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
    ExtCtrls, RichMemoFrame, odf_types;

type

    { TFrmWriteOdfMain }

    TFrmWriteOdfMain = class(TForm)
        Button1: TButton;
        Panel1: TPanel;
        RTFEditFrame1: TRTFEditFrame;
        Splitter1: TSplitter;
        procedure Button1Click(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
    private
        FOdfTextDocument: TOdfTextDocument;
    public

    end;

var
    FrmWriteOdfMain: TFrmWriteOdfMain;

implementation

{$R *.lfm}

{ TFrmWriteOdfMain }

procedure TFrmWriteOdfMain.FormCreate(Sender: TObject);
begin
    FOdfTextDocument := TOdfTextDocument.Create;
end;

procedure TFrmWriteOdfMain.Button1Click(Sender: TObject);

const
    cStyleName = 'Standard';
    cTextStyles: array[TFontStyle] of string =
        ('fett', 'kursiv', 'unterstrichen', 'durchgestrichen');
var
    lPara: TOdfParagraph;
    lFS: TFontStyles;
    lFsi: TFontStyle;
    lText, lFont, lFirstChar: string;
    i: integer;
    aFont: TFont;
    lSpan: TSpan;
    w: ValReal;

begin
    FOdfTextDocument.Clear;
    FOdfTextDocument.AddHeadline(1).AppendText('Demonstration von fpOdf');
    FOdfTextDocument.AddHeadline(2).AppendText('Überschriften');
    for i := 3 to 8 do
        FOdfTextDocument.AddHeadline(i).AppendText('Überschrift ' + IntToStr(i));
    FOdfTextDocument.AddHeadline(2).AppendText('Ein paar Textstile');
    lPara := FOdfTextDocument.AddParagraph(cStyleName);
    lpara.AddSpan('Hello', [fsBold]);
    lpara.AppendOdfElement(oetTextLineBreak);
    lpara.AddSpan('World', [fsItalic]);
    lPara := FOdfTextDocument.AddParagraph(cStyleName);
    lpara.AddSpan('Hello', [fsUnderline]);
    lpara.AppendOdfElement(oetTextLineBreak);
    lpara.AddSpan('World', [fsStrikeOut]);

    FOdfTextDocument.AddHeadline(2).AppendText('Alle Textstile, Links und Buchzeichen');
    for i := 0 to 15 do
      begin
        lFS := [];
        lText := '';
        for lFsi in TFontStyle do
            if (i and (1 shl Ord(lFsi))) <> 0 then
              begin
                lfs += [lfsi];
                if ltext = '' then
                    lText := cTextStyles[lfsi]
                else
                if ltext.IndexOf(' und ') >= 0 then
                    ltext := cTextStyles[lfsi] + ', ' + lText
                else
                    ltext := cTextStyles[lfsi] + ' und ' + lText;
              end;
        if ltext = '' then
            lText := 'Dieser Text ist normal'
        else
            lText := 'Dieser Text ist ' + lText;
        lPara := FOdfTextDocument.AddParagraph(cStyleName);
        lPara.AddBookmark(lText, lFS, 'F' + IntToStr(i));
      end;

    for i := 0 to 15 do
      begin
        lPara := FOdfTextDocument.AddParagraph(cStyleName);
        lPara.AddLink('Gehe zu ' + IntToStr(i), [], 'F' + IntToStr(i));
      end;

    FOdfTextDocument.AddHeadline(2).AppendText('Schriftarten');
    lFirstChar := '!';
    aFont := TFont.Create;
      try
        for lFont in Screen.Fonts do
          begin
            if copy(lfont, 1, 1) <> lFirstChar then
              begin
                FOdfTextDocument.AddHeadline(4).AppendText(copy(lfont, 1, 1));
                lFirstChar := copy(lfont, 1, 1);
              end;
            lPara := FOdfTextDocument.AddParagraph(cStyleName);
            aFont.Name := lFont;
            lpara.AddSpan('Dies ist die Schriftart: "' + lFont + '"', []);
            lPara.AppendOdfElement(oetTextLineBreak);
            lSpan := lpara.AddSpan('ABCDEF abcdef 12345', aFont, FOdfTextDocument);
            lSpan.AppendOdfElement(oetTextLineBreak);
            lSpan.AppendText('Franz jagt im komplett verwarlosten Taxi quer durch Berlin !');
          end;
      finally
        FreeAndNil(aFont)
      end;
    FOdfTextDocument.AddHeadline(2).AppendText('Schriftfarben');
    lText := 'Bringt mehr Farben ins Leben, denn Farben machen das Leben bunt, und streicheln das Gemüt.';
    lPara := FOdfTextDocument.AddParagraph(cStyleName);
    aFont := TFont.Create;
    aFont.Name := 'default';
      try
        i := 1;
        while i <= length(lText) do
          begin
            w := i / length(lText) * pi * 2;
            afont.Color :=
                RGBToColor(96 + trunc(cos(w) * 96), 96 + trunc(sin(w - pi / 3) * 96), 96 + trunc(sin(w + 4 * pi / 3) * 96));
            if lText[i] <> 'ü'[1] then
                lpara.AddSpan(lText[i], aFont, FOdfTextDocument)
            else
              begin
                lpara.AddSpan(copy(lText, i, 2), aFont, FOdfTextDocument);
                Inc(i);
              end;
            Inc(i);
          end;
      finally;
        FreeAndNil(aFont)
      end;

    {--------------  schreibe Datei ----------------------}
    FOdfTextDocument.SaveToSingleXml('Hello_world.fodt');
end;

procedure TFrmWriteOdfMain.FormDestroy(Sender: TObject);
begin
    FreeAndNil(FOdfTextDocument);
end;

end.
