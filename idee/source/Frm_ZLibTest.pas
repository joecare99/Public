unit Frm_ZLibTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdZLibCompressorBase, IdCompressorZLib;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    btnCompress: TButton;
    btnDecompress: TButton;
    Label1: TLabel;
    cbxComprLevel: TComboBox;
    cbxHexBreak: TComboBox;
    btnLoadSource: TButton;
    btnLoadCompr: TButton;
    CheckBox1: TCheckBox;
    btnSaveCompr: TButton;
    CheckBox2: TCheckBox;
    btnSaveDest: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    IdCompressorZLib1: TIdCompressorZLib;
    btnCompress2: TButton;
    btnDecompress2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonCompressClick(Sender: TObject);
    procedure ButtonDecompressClick(Sender: TObject);
    procedure btnLoadSourceClick(Sender: TObject);
    procedure btnSaveDestClick(Sender: TObject);
    procedure btnLoadComprClick(Sender: TObject);
    procedure btnSaveComprClick(Sender: TObject);
    procedure btnCompress2Click(Sender: TObject);
    procedure btnDecompress2Click(Sender: TObject);
  private
    SourceStream, DestStream, ZipDataStream: TStream;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses ZLib;
{$R *.dfm}

Procedure Stream2TStrings(Source: TStream; lines: TStrings; LineBrAt: integer);
var
  b: byte;
  Adr: integer;
  hexStr, ClearStr: String;
begin
  Source.Position := 0;
  lines.clear;
  Adr := 0;
  hexStr := '';
  ClearStr := '';
  while Source.Read(b, 1) = 1 do
  begin
    inc(Adr);
    hexStr := hexStr + IntToHex(b, 2) + ' ';
    if (b > 32) then
      ClearStr := ClearStr + Ansichar(b)
    else
      ClearStr := ClearStr + '.';
    if Adr mod LineBrAt = 0 then
    begin
      lines.Add(IntToHex(Adr - LineBrAt, 4)
          + ':'#9 + hexStr + ':'#9 + ClearStr);
      hexStr := '';
      ClearStr := '';
    end;
  end;
  if hexStr <> '' then
  begin
    lines.Add(IntToHex((Adr div LineBrAt) * LineBrAt, 4)
        + ':'#9 + hexStr + StringOfChar(' ', (LineBrAt - length(hexStr) div 3)
          * 5) + ':'#9 + ClearStr);
  end;

end;

const
  ZCLevelText: array [TZCompressionLevel] of String =
    ('None', 'Fast', 'Default', 'Max');

procedure TForm1.FormCreate(Sender: TObject);
var
  lzcCompLevel: TZCompressionLevel;
begin
  ZipDataStream := TMemoryStream.Create();
  SourceStream := nil;
  DestStream := TMemoryStream.Create();
  cbxComprLevel.Items.clear;
  for lzcCompLevel := low(TZCompressionLevel) to High(TZCompressionLevel) do
    cbxComprLevel.Items.AddObject(ZCLevelText[lzcCompLevel], TObject
        (lzcCompLevel));
  cbxComprLevel.ItemIndex := 2;
  cbxHexBreak.Items.clear;
  cbxHexBreak.Items.AddObject('8', TObject(integer(8)));
  cbxHexBreak.Items.AddObject('16', TObject(integer(16)));
  cbxHexBreak.ItemIndex := 1;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ZipDataStream.Free;
end;

// Compress Source, using the ID-Component
procedure TForm1.btnCompress2Click(Sender: TObject);
   var freeSource:boolean;
       SourceSize:int64;
       LineBrAt:integer;
begin

  ZipDataStream.Size := 0;
  if not assigned(SourceStream) then
  begin
    SourceStream := TStringStream.Create(Memo1.Text);
    freeSource := true;
  end
  else
    freeSource := false;

  SourceSize := SourceStream.Size;

  IdCompressorZLib1.CompressStream(SourceStream,ZipDataStream,1,1,9,0);

  if freeSource then
      SourceStream.Free;


  Label1.Caption := Format('%d Bytes komprimiert zu %d Bytes.',
    [SourceSize, ZipDataStream.Size]);

  LineBrAt := 16;
  if cbxHexBreak.ItemIndex >= 0 then
    LineBrAt := integer(cbxHexBreak.Items.Objects[cbxHexBreak.ItemIndex]);
  Stream2TStrings(ZipDataStream, Memo2.lines, LineBrAt);
end;


procedure TForm1.btnDecompress2Click(Sender: TObject);
begin
  DestStream.Size:=0;

  IdCompressorZLib1.DecompressGZipStream(ZipDataStream,DestStream);

  Stream2TStrings(DestStream,Memo3.Lines,8);
end;

procedure TForm1.btnLoadComprClick(Sender: TObject);
var
  fs: TStream;
  b: byte;
  LineBrAt: integer;
begin
  OpenDialog1.FileName := '*.*';
  if OpenDialog1.Execute then
  begin

    fs := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);
    ZipDataStream.Size := 0;
    try
      if CheckBox1.Checked then
      begin
        ZipDataStream.Position := 0;
        b := $78;
        ZipDataStream.Write(b, 1);
        b := $9C;
        ZipDataStream.Write(b, 1);
        fs.Position := 10;
      ZipDataStream.CopyFrom(fs, fs.Size-fs.Position-8);
      end
      else
      begin
        ZipDataStream.Position := 0;
        fs.Position := 0;
        ZipDataStream.CopyFrom(fs, fs.Size-fs.Position);
      end;
    finally
      fs.Free;
    end;

    LineBrAt := 16;
    if cbxHexBreak.ItemIndex >= 0 then
      LineBrAt := integer(cbxHexBreak.Items.Objects[cbxHexBreak.ItemIndex]);
    Stream2TStrings(ZipDataStream, Memo2.lines, LineBrAt);
  end;
end;

procedure TForm1.btnLoadSourceClick(Sender: TObject);

begin
  OpenDialog1.FileName := '*.txt';
  if OpenDialog1.Execute then
  begin
    SourceStream := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);

    Stream2TStrings(SourceStream, Memo1.lines, 8);
  end;
end;

procedure TForm1.btnSaveComprClick(Sender: TObject);
var
  fs: TStream;
begin
  SaveDialog1.FileName := '*.z';
  if SaveDialog1.Execute then
  begin
    // test Fileexists
    // make BAK if so
    if CheckBox2.Checked then
      ZipDataStream.Position := 2
    else
      ZipDataStream.Position := 0;

    try
      fs := TFileStream.Create(SaveDialog1.FileName, fmOpenWrite+fmCreate);
      fs.CopyFrom(ZipDataStream, ZipDataStream.Size-ZipDataStream.Position);
    finally
      fs.Free;
    end;

  end;
end;

procedure TForm1.btnSaveDestClick(Sender: TObject);
begin
  SaveDialog1.FileName := '*.txt';
  if SaveDialog1.Execute then
  begin
    // test Fileexists
    // make BAK if so
    Memo3.lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TForm1.ButtonCompressClick(Sender: TObject);
var
  CompStream: ZLib.TCompressionStream;

  SourceSize: int64;
  LineBrAt: integer;
  freeSource: boolean;

begin
  ZipDataStream.Size := 0;
  if not assigned(SourceStream) then
  begin
    SourceStream := TStringStream.Create(Memo1.Text);
    freeSource := true;
  end
  else
    freeSource := false;

  SourceSize := SourceStream.Size;

  if cbxComprLevel.ItemIndex >= 0 then
    CompStream := ZLib.TCompressionStream.Create(ZipDataStream,
      TZCompressionLevel(cbxComprLevel.Items.Objects[cbxComprLevel.ItemIndex]))
  else
    CompStream := ZLib.TCompressionStream.Create(ZipDataStream, zcDefault);

  try
    SourceStream.Position := 0;
    CompStream.CopyFrom(SourceStream, 0);
  finally
    CompStream.Free;
    if freeSource then
      SourceStream.Free;
  end;

  Label1.Caption := Format('%d Bytes komprimiert zu %d Bytes.',
    [SourceSize, ZipDataStream.Size]);

  LineBrAt := 16;
  if cbxHexBreak.ItemIndex >= 0 then
    LineBrAt := integer(cbxHexBreak.Items.Objects[cbxHexBreak.ItemIndex]);
  Stream2TStrings(ZipDataStream, Memo2.lines, LineBrAt);
end;

procedure TForm1.ButtonDecompressClick(Sender: TObject);
var
  DeCompStream: ZLib.TDeCompressionStream;
  TargetStream: TStringStream;
  s: String;
  c: Ansichar;
begin
  ZipDataStream.Position := 0;
  TargetStream := TStringStream.Create('');
  DeCompStream := ZLib.TDeCompressionStream.Create(ZipDataStream);

  DestStream.Size:=0;


  try
    DestStream.CopyFrom(DeCompStream,DeCompStream.Size);

    Stream2TStrings(DestStream,memo3.Lines,8);

    DeCompStream.Position:=0;
    s := Memo3.Text;
    while DeCompStream.Read(c, SizeOf(c)) = SizeOf(c) do
      s := s + c;
    Memo3.Text := s;
  finally
    DeCompStream.Free;
    TargetStream.Free;
  end;
end;

end.
