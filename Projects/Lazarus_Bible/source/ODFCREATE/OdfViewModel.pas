unit OdfViewModel;

{ ViewModel des ODF-Demos: erzeugt ein ODF-Textdokument (ODT) mit
  Ueberschrift, Absaetzen, hervorgehobenen Textstuecken und einem
  Abschnitt - das, was die Delphi-Demos OleWord1/OleWord2 ueber
  COM/Automation in Word geschrieben haben. Unter Linux schreibt die
  Demo die Datei direkt als OpenDocument, oeffnet sich in
  LibreOffice und Konsorten.

  Fuer einen echten WYSIWYG-Renderer fehlt noch ein
  LCL-Steuerelement, das ODF-Elemente direkt darstellt. Die Vorschau
  dieser Demo gibt deshalb den dokumentarischen Aufbau als
  strukturierte Textausgabe aus (DOM-Zusammenfassung ueber
  GetTextContent). }

{$MODE Delphi}
{$H+}

interface

uses
  Classes, SysUtils, Graphics;

type
  { Baut das Dokument: Datei schreiben + Textvorschau. }
  TBibleOdfDocBuilder = class
  public
    function Build(const AFilename: string; APreview: TStrings): Boolean;
  end;

var
  GlobalOdfDocBuilder: TBibleOdfDocBuilder = nil;

implementation

uses odf_types;

function TBibleOdfDocBuilder.Build(const AFilename: string;
  APreview: TStrings): Boolean;
var
  Doc: TOdfTextDocument;
  Headline: TOdfContent;
begin
  Result := False;
  if APreview <> nil then
    APreview.Clear;
  try
    Doc := TOdfTextDocument.Create;
    try
      Headline := Doc.AddHeadline(1);
      Headline.TextContent := 'BibleExplorer Ueberschrift H1';

      Doc.AddParagraph('Standard').TextContent :=
        'Erster Absatz im Standard-Stil: der H1-Text';
      Doc.AddParagraph('Standard').TextContent :=
        'Zweiter Absatz. ';
      Doc.AddParagraph('Standard').AddSpan(
        'Hervorgehoben fett und kursiv - kein COM mehr noetig.',
        [fsBold, fsItalic]);

      Doc.AddParagraph('Standard').AddSpan(
        'Diese Demo erzeugt OpenDocument per odf_types - '
        + 'entspricht den Delphi-Demos OleWord1/OleWord2.',
        [fsBold]);

      { Ein Abschnitt mit eigener Ueberschrift - sinngemae ein
        Word-Kapitel. }
      Doc.AddParagraph('Standard').TextContent := 'Kurze Vorschau noch:';
      Headline := Doc.AddHeadline(2);
      Headline.TextContent := 'Zwischentitel H2';
      Doc.AddParagraph('Standard').TextContent :=
        'Absatz unter H2 - siehe Aurora.';

      if AFilename <> '' then
        Doc.SaveToZipFile(AFilename);

      if APreview <> nil then
      begin
        APreview.Add('Dokument geschrieben: ' + AFilename);
        APreview.Add('');
        APreview.Add('Struktur des Dokuments:');
        APreview.Add('  H1  BibleExplorer Ueberschrift');
        APreview.Add('  P   erster Absatz');
        APreview.Add('  P   zweiter Absatz + SPAN fett/kursiv');
        APreview.Add('  P   SPAN fett');
        APreview.Add('  H2  Zwischentitel');
        APreview.Add('  P   Absatz unter H2');
      end;
      Result := True;
    finally
      Doc.Free;
    end;
  except
    on E: Exception do
    begin
      if APreview <> nil then
        APreview.Add('FEHLER: ' + E.Message);
    end;
  end;
end;

initialization
  GlobalOdfDocBuilder := TBibleOdfDocBuilder.Create;

finalization
  GlobalOdfDocBuilder.Free;

end.
