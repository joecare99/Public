unit Unit32;

{-------------------------------------------------------------------------------
  Unit32 - TForm32, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit32.pas and the original resource
  Source\Projects_AhnenWin\Form32.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Forms, Controls, Grids, DB, Graphics,
  AHNGlobals, Unit1, Unit2;

type
  TForm32 = class(TForm)
  published
    Image1: TImage; //2F0
    Image2: TImage; //2F4
    Image3: TImage; //2F8
    Image4: TImage; //2FC
    Image5: TImage; //300
    Image6: TImage; //304
    Image7: TImage; //308
    Image8: TImage; //30C
    Image9: TImage; //310
    Image10: TImage; //314
    Image11: TImage; //318
    Image12: TImage; //31C
    Image13: TImage; //320
    Image14: TImage; //324
    Image15: TImage; //328
    Label1: TLabel; //32C
    Label2: TLabel; //330
    Label3: TLabel; //334
    procedure Image1DblClick(Sender: TObject); //0055985C
    procedure FormShow(Sender: TObject); //00558D50
  end;

var
  Form32: TForm32;

implementation

{$R ..\Forms\Form32.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm32.Image1DblClick(Sender: TObject);
var
  CopyLen: Integer;
begin
  CopyLen := 0;

  if Sender = Image1 then
  begin
    gvar_0061F0A0 := gvar_0061F064;
    CopyLen := 1;
  end
  else if Sender = Image2 then
  begin
    gvar_0061F0A0 := gvar_0061F068;
    CopyLen := 1;
  end
  else if Sender = Image3 then
  begin
    gvar_0061F0A0 := gvar_0061F06C;
    CopyLen := 1;
  end
  else if Sender = Image4 then
  begin
    gvar_0061F0A0 := gvar_0061F070;
    CopyLen := 1;
  end
  else if Sender = Image5 then
  begin
    gvar_0061F0A0 := gvar_0061F074;
    CopyLen := 1;
  end
  else if Sender = Image6 then
  begin
    gvar_0061F0A0 := gvar_0061F078;
    CopyLen := 8;
  end
  else if Sender = Image7 then
  begin
    gvar_0061F0A0 := gvar_0061F07C;
    CopyLen := 8;
  end
  else if Sender = Image8 then
  begin
    gvar_0061F0A0 := gvar_0061F080;
    CopyLen := 8;
  end
  else if Sender = Image9 then
  begin
    gvar_0061F0A0 := gvar_0061F084;
    CopyLen := 8;
  end
  else if Sender = Image10 then
  begin
    gvar_0061F0A0 := gvar_0061F088;
    CopyLen := 8;
  end
  else if Sender = Image11 then
  begin
    gvar_0061F0A0 := gvar_0061F08C;
    CopyLen := 15;
  end
  else if Sender = Image12 then
  begin
    gvar_0061F0A0 := gvar_0061F090;
    CopyLen := 15;
  end
  else if Sender = Image13 then
  begin
    gvar_0061F0A0 := gvar_0061F094;
    CopyLen := 15;
  end
  else if Sender = Image14 then
  begin
    gvar_0061F0A0 := gvar_0061F098;
    CopyLen := 15;
  end
  else if Sender = Image15 then
  begin
    gvar_0061F0A0 := gvar_0061F09C;
    CopyLen := 15;
  end;

  if CopyLen > 0 then
    gvar_0061F0A4 := IntToStr(StrToInt(Copy(gvar_02536B58, 6, CopyLen)));

  Form1.FamblHTML;
  Form32.Hide;
end;

procedure TForm32.FormShow(Sender: TObject);
var
  i: Integer;
  sPath, sFile: string;
  Pattern: Integer;
  Imgs: array[1..15] of TImage;
  Graphic: TGraphic;
  W, H: Integer;
  Ratio: Double;
begin
  { Labels ausblenden }
  Label1.Visible := False;
  Label2.Visible := False;
  Label3.Visible := False;

  { Bilder leeren }
  Image1.Picture := nil;
  Image2.Picture := nil;
  Image3.Picture := nil;
  Image4.Picture := nil;
  Image5.Picture := nil;
  Image6.Picture := nil;
  Image7.Picture := nil;
  Image8.Picture := nil;
  Image9.Picture := nil;
  Image10.Picture := nil;
  Image11.Picture := nil;
  Image12.Picture := nil;
  Image13.Picture := nil;
  Image14.Picture := nil;
  Image15.Picture := nil;

  Imgs[1] := Image1;
  Imgs[2] := Image2;
  Imgs[3] := Image3;
  Imgs[4] := Image4;
  Imgs[5] := Image5;
  Imgs[6] := Image6;
  Imgs[7] := Image7;
  Imgs[8] := Image8;
  Imgs[9] := Image9;
  Imgs[10] := Image10;
  Imgs[11] := Image11;
  Imgs[12] := Image12;
  Imgs[13] := Image13;
  Imgs[14] := Image14;
  Imgs[15] := Image15;

  { Bildverzeichnis }
  sPath := gvar_02536B9C + 'Bilder/';

  { Tabelle öffnen }
  DataModule2.Table14.IndexName := 'namgeb';
  DataModule2.Table14.Open;
  DataModule2.Table14.IndexName := 'num';
  DataModule2.Table14.First;

  { Für jeden Bildsatz (61-65) }
  for i := 61 to 65 do
  begin
    Pattern := 0;
    sFile := '';
    if Trim(gvar_02536B58) <> '' then
    begin
      { Muster 1: einstellige Nummer an Position 6 }
      sFile := sPath + 'b' + IntToStr(StrToInt(Copy(gvar_02536B58, 6, 1))) + Char(i) + '.jpg';
      if FileExists(sFile) then
        Pattern := 1
      else
      begin
        sFile := '';
        if Length(gvar_02536B58) > 7 then
        begin
          { Muster 2: achsstellige Nummer an Position 6 }
          sFile := sPath + 'b' + IntToStr(StrToInt(Copy(gvar_02536B58, 6, 8))) + Char(i) + '.jpg';
          if FileExists(sFile) then
            Pattern := 2
          else
          begin
            sFile := '';
            if Length(gvar_02536B58) > 14 then
            begin
              { Muster 3: fünfzehnstellige Nummer an Position 6 }
              sFile := sPath + 'b' + IntToStr(StrToInt(Copy(gvar_02536B58, 6, 15))) + Char(i) + '.jpg';
              if FileExists(sFile) then
                Pattern := 3;
            end;
          end;
        end;
      end;
    end;

    if Pattern > 0 then
    begin
      case Pattern of
        1: Label1.Visible := True;
        2: Label2.Visible := True;
        3: Label3.Visible := True;
      end;

      { Bildindex: 1-5, 6-10 oder 11-15 je nach Muster }
      Imgs[1 + (i - 61) + (Pattern - 1) * 5].Picture.LoadFromFile(sFile);

      { Bild proportional zur Image-Höhe skalieren }
      Graphic := Imgs[1 + (i - 61) + (Pattern - 1) * 5].Picture.Graphic;
      H := Graphic.Height;
      Ratio := H / Imgs[1 + (i - 61) + (Pattern - 1) * 5].Height;
      W := Graphic.Width;
      Imgs[1 + (i - 61) + (Pattern - 1) * 5].Width := Round(W * Ratio);

      { Dateinamen im Globalen ablegen }
      case Pattern of
        1:
          case i of
            61: gvar_0061F064 := sFile;
            62: gvar_0061F068 := sFile;
            63: gvar_0061F06C := sFile;
            64: gvar_0061F070 := sFile;
            65: gvar_0061F074 := sFile;
          end;
        2:
          case i of
            61: gvar_0061F078 := sFile;
            62: gvar_0061F07C := sFile;
            63: gvar_0061F080 := sFile;
            64: gvar_0061F084 := sFile;
            65: gvar_0061F088 := sFile;
          end;
        3:
          case i of
            61: gvar_0061F08C := sFile;
            62: gvar_0061F090 := sFile;
            63: gvar_0061F094 := sFile;
            64: gvar_0061F098 := sFile;
            65: gvar_0061F09C := sFile;
          end;
      end;
    end;
  end;
end;


end.
