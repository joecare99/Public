unit frm_ShaTestMain;

{$mode objfpc}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;

type

  { TfrmSha1 }

  TfrmSha1 = class(TForm)
    cmdSha1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    cmdLoadFileSha1: TButton;
    oOpen: TOpenDialog;
    memSha: TMemo;
    memInput: TMemo;
    edSha1: TEdit;
    chkAnzeige: TCheckBox;
    cmdLoadFileMD5: TButton;
    cmdMD5: TButton;
    procedure cmdSha1Click(Sender: TObject);
    procedure cmdLoadFileSha1Click(Sender: TObject);
    procedure cmdMD5Click(Sender: TObject);
    procedure cmdLoadFileMD5Click(Sender: TObject);
    procedure edSha1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    XArr: array of uint32;
    function UTF8Bytes(const s: UTF8String): TBytes;
    function HashSha1(IntArray: array of uint32): string;
    function HashMD5(var IntArray: array of uint32): string;
    procedure FieldPreparationsSha1(cAnsiInput: ansistring);
    procedure FieldPreparationsMD5(cAnsiInput: ansistring);
    procedure SwapEndiannessOfBits(var Value: uint32); overload;
    procedure SwapEndiannessOfBits(var Value: uint64); overload;
    function UIntToStr(Value: uint32): string; overload;
    function UIntToStr(Value: UInt64): string; overload;
    function F(Xl, Y, Z: uint32): uint32;
    function G(Xl, Y, Z: uint32): uint32;
    function H(Xl, Y, Z: uint32): uint32;
    function J(Xl, Y, Z: uint32): uint32;
    function SwapLittleBigEndianInteger(Value: uint32): uint32;
    function SwapLittleBigEndianuInt64(Value: uint64): uint64;

    procedure R1(var A: uint32; B, C, D: uint32; k, s, i: integer);
    procedure R2(var A: uint32; B, C, D: uint32; k, s, i: integer);
    procedure R3(var A: uint32; B, C, D: uint32; k, s, i: integer);
    procedure R4(var A: uint32; B, C, D: uint32; k, s, i: integer);

  public
    { Public-Deklarationen }
  end;

var
  frmSha1: TfrmSha1;

const
  T: array[1..64] of uint32 =
    (
    $d76aa478, $e8c7b756, $242070db, $c1bdceee,
    $f57c0faf, $4787c62a, $a8304613, $fd469501,
    $698098d8, $8b44f7af, $ffff5bb1, $895cd7be,
    $6b901122, $fd987193, $a679438e, $49b40821,
    $f61e2562, $c040b340, $265e5a51, $e9b6c7aa,
    $d62f105d, $02441453, $d8a1e681, $e7d3fbc8,
    $21e1cde6, $c33707d6, $f4d50d87, $455a14ed,
    $a9e3e905, $fcefa3f8, $676f02d9, $8d2a4c8a,
    $fffa3942, $8771f681, $6d9d6122, $fde5380c,
    $a4beea44, $4bdecfa9, $f6bb4b60, $bebfbc70,
    $289b7ec6, $eaa127fa, $d4ef3085, $04881d05,
    $d9d4d039, $e6db99e5, $1fa27cf8, $c4ac5665,
    $f4292244, $432aff97, $ab9423a7, $fc93a039,
    $655b59c3, $8f0ccc92, $ffeff47d, $85845dd1,
    $6fa87e4f, $fe2ce6e0, $a3014314, $4e0811a1,
    $f7537e82, $bd3af235, $2ad7d2bb, $eb86d391
    );

implementation

uses
  Math;

{$R *.lfm}

function TfrmSha1.SwapLittleBigEndianuInt64(Value: uint64): uint64;
var
  i: integer;
  temp: uint64;
begin
  Temp := Value;
  Value := 0;
  for i := 0 to 7 do
  begin
    Value := (Value shl 8) or (Temp and $FF);
    Temp := Temp shr 8;
  end;
  Result := Value;
end;

function TfrmSha1.SwapLittleBigEndianInteger(Value: uint32): uint32;
var
  i: integer;
  temp: uint32;
begin
  Temp := Value;
  Value := 0;
  for i := 0 to 3 do
  begin
    Value := (Value shl 8) or (Temp and $FF);
    Temp := Temp shr 8;
  end;
  Result := Value;
end;

procedure TfrmSha1.R1(var A: uint32; B, C, D: uint32; k, s, i: integer);
begin
  A := B + (((A + F(B, C, D) + XArr[k] + T[i]) shl (s)) or
    ((A + F(B, C, D) + XArr[k] + T[i]) shr (32 - s)));
end;

procedure TfrmSha1.R2(var A: uint32; B, C, D: uint32; k, s, i: integer);
begin
  A := B + (((A + G(B, C, D) + XArr[k] + T[i]) shl (s)) or
    ((A + G(B, C, D) + XArr[k] + T[i]) shr (32 - s)));
end;

procedure TfrmSha1.R3(var A: uint32; B, C, D: uint32; k, s, i: integer);
begin
  A := B + (((A + H(B, C, D) + XArr[k] + T[i]) shl (s)) or
    ((A + H(B, C, D) + XArr[k] + T[i]) shr (32 - s)));
end;

procedure TfrmSha1.R4(var A: uint32; B, C, D: uint32; k, s, i: integer);
begin
  A := B + (((A + J(B, C, D) + XArr[k] + T[i]) shl (s)) or
    ((A + J(B, C, D) + XArr[k] + T[i]) shr (32 - s)));
end;


procedure TfrmSha1.cmdLoadFileMD5Click(Sender: TObject);
var
  by: PByte;
  nLen: integer;
  cAnsiInput: ansistring;
  cAnsi: ansistring;
  i: integer;
  tby: TBytes;
  sStream: TMemoryStream;
begin

  edSha1.Text := '';
  memSha.Clear;
  memInput.Clear;

  if not (oOpen.Execute()) then
    exit;
  cAnsiInput := '';
  sStream := TMemoryStream.Create();
  sStream.LoadFromFile(oOpen.FileName);
  nLen := sStream.Size;
  sStream.Seek(0, soFromBeginning);
  SetLength(tby, nLen);
  sStream.ReadBuffer(tby[0], nLen);
  FreeAndNil(sStream);
  nLen := Length(tby);
  for i := 0 to nLen - 1 do
  begin  // String in AnsiString umwandeln, indem nur das erste Byte vom jeweiligen char
    // genommen wird - bei ASCII kein Problem
    cAnsi := '';
    //by := @cInput[i];
    by := @tby[i];
    SetString(cAnsi, PAnsiChar(by), 1);
    cAnsiInput := cAnsiInput + cAnsi;
  end;
  //cAnsiInput := UnicodeStringToAnsiString(cInput, 1252);
  if chkAnzeige.Checked then
  begin
    memInput.Clear;
    memInput.Lines.Add(string(cAnsiInput));
  end;

  FieldPreparationsMD5(cAnsiInput);
end;

procedure TfrmSha1.edSha1Change(Sender: TObject);
begin

end;

procedure TfrmSha1.FormCreate(Sender: TObject);
begin

end;

procedure TfrmSha1.cmdLoadFileSha1Click(Sender: TObject);
var
  by: PByte;
  nLen: integer;
  cAnsiInput: ansistring;
  cAnsi: ansistring;
  i: integer;
  tby: TBytes;
  sStream: TMemoryStream;
begin

  edSha1.Text := '';
  memSha.Clear;
  memInput.Clear;

  if not (oOpen.Execute()) then
    exit;
  cAnsiInput := '';
  sStream := TMemoryStream.Create();
  sStream.LoadFromFile(oOpen.FileName);
  nLen := sStream.Size;
  sStream.Seek(0, soFromBeginning);
  SetLength(tby, nLen);
  sStream.ReadBuffer(tby[0], nLen);
  FreeAndNil(sStream);
  nLen := Length(tby);
  for i := 0 to nLen - 1 do
  begin  // String in AnsiString umwandeln, indem nur das erste Byte vom jeweiligen char
    // genommen wird - bei ASCII kein Problem
    cAnsi := '';
    //by := @cInput[i];
    by := @tby[i];
    SetString(cAnsi, PAnsiChar(by), 1);
    cAnsiInput := cAnsiInput + cAnsi;
  end;
  //cAnsiInput := UnicodeStringToAnsiString(cInput, 1252);
  if chkAnzeige.Checked then
  begin
    memInput.Clear;
    memInput.Lines.Add(string(cAnsiInput));
  end;
  FieldPreparationsSha1(cAnsiInput);
end;

procedure TfrmSha1.cmdMD5Click(Sender: TObject);
var
  by: PByte;
  cInput: string;
  nLen: integer;
  cAnsiInput: ansistring;
  cAnsi: ansistring;
  i: integer;
  tby: TBytes;
begin
  cAnsiInput := '';
  cInput := trim(memInput.Text);
  //nLen := Length(cInput);
  //cAnsi := '';
  tby := UTF8Bytes(cInput);
  nLen := Length(tby);
  for i := 0 to nLen - 1 do
  begin  // String in AnsiString umwandeln, indem nur das erste Byte vom jeweiligen char
    // genommen wird - bei ASCII kein Problem
    cAnsi := '';
    //by := @cInput[i];
    by := @tby[i];
    SetString(cAnsi, PAnsiChar(by), 1);
    cAnsiInput := cAnsiInput + cAnsi;
  end;

  //cAnsiInput := UnicodeStringToAnsiString(cInput, 1252);
  FieldPreparationsMD5(cAnsiInput);
end;

function TfrmSha1.UTF8Bytes(const s: UTF8String): TBytes;
begin
  //Assert(StringElementSize(s)=1);
  SetLength(Result, Length(s));
  if Length(Result) > 0 then
    Move(s[1], Result[0], Length(s));
end;

procedure TfrmSha1.cmdSha1Click(Sender: TObject);
var
  by: PByte;
  cInput: string;
  nLen: integer;
  cAnsiInput: ansistring;
  cAnsi: ansistring;
  i: integer;
  tby: TBytes;
begin
  cInput := trim(memInput.Text);
  //nLen := Length(cInput);
  //cAnsi := '';
  cAnsiInput := '';
  tby := UTF8Bytes(cInput);
  nLen := Length(tby);
  for i := 0 to nLen - 1 do
  begin  // String in AnsiString umwandeln, indem nur das erste Byte vom jeweiligen char
    // genommen wird - bei ASCII kein Problem
    cAnsi := '';
    //by := @cInput[i];
    by := @tby[i];
    SetString(cAnsi, PAnsiChar(by), 1);
    cAnsiInput := cAnsiInput + cAnsi;
  end;
  //cAnsiInput := UnicodeStringToAnsiString(cInput, 1252);
  FieldPreparationsSha1(cAnsiInput);
end;

procedure TfrmSha1.FieldPreparationsMD5(cAnsiInput: ansistring);
var
  AnzahlBytes: uint32;
  Anzahl512BitBloecke: uint32;
  AnzahlVollstaendigeInteger: uint32;
  AnzahlRestInteger: uint32;
  AnzahlGesamtInteger: uint32;
  IntegerArray: array of uint32;
  n, n1, n2: integer;
  hex: string;
  messagelaenge: uint64;
  inthigh, intlow: uint32;
  cHash: string;
  i: integer;
begin
  AnzahlBytes := Length(cAnsiInput);
  // 8 Bit pro Byte

  Anzahl512BitBloecke := Floor(((AnzahlBytes) * 8 + 64) / 512) + 1;
  // 16 4Byte - Integer pro 512BitBlock
  AnzahlVollstaendigeInteger := Floor(AnzahlBytes / 4);
  AnzahlRestInteger := AnzahlBytes mod 4;
  AnzahlGesamtInteger := Anzahl512BitBloecke * 16;
  SetLength(IntegerArray, AnzahlGesamtInteger);
  n := AnzahlVollstaendigeInteger - 1;

  for i := 0 to n do
  begin
    n1 := i * 4;
    IntegerArray[i] :=
      16777216 * Ord(cAnsiInput[n1 + 1]) + 65536 *
      Ord(cAnsiInput[n1 + 2]) + 256 * Ord(cAnsiInput[n1 + 3]) +
      Ord(cAnsiInput[n1 + 4]);
  end;
  n1 := AnzahlVollstaendigeInteger * 4;
  //n3 := ord(cAnsiInput[n1+1]);
  case AnzahlRestInteger of
    0:
    begin
      hex := '80000000';
      IntegerArray[AnzahlVollstaendigeInteger] := StrToInt('$' + hex);
    end;
    1:
    begin
      hex := '800000';
      IntegerArray[AnzahlVollstaendigeInteger] :=
        16777216 * Ord(cAnsiInput[n1 + 1]) + StrToInt('$' + hex);
    end;
    2:
    begin
      hex := '8000';
      IntegerArray[AnzahlVollstaendigeInteger] :=
        16777216 * Ord(cAnsiInput[n1 + 1]) + 65536 *
        Ord(cAnsiInput[n1 + 2]) + StrToInt('$' + hex);
    end;
    3:
    begin
      hex := '80';
      IntegerArray[AnzahlVollstaendigeInteger] :=
        16777216 * Ord(cAnsiInput[n1 + 1]) + 65536 *
        Ord(cAnsiInput[n1 + 2]) + 256 * Ord(cAnsiInput[n1 + 3]) + StrToInt('$' + hex);
    end;
  end;
  n1 := AnzahlVollstaendigeInteger + 1;
  n2 := AnzahlGesamtInteger - 3;
  for i := n1 to n2 do
  begin
    IntegerArray[i] := 0;
  end;
  messagelaenge := AnzahlBytes * 8;
  // aus Big - Endian einen Little - Endian machen
  messagelaenge := SwapLittleBigEndianuInt64(messagelaenge);

  inthigh := Floor((messagelaenge / 2147483648) / 2);
  intlow := messagelaenge - inthigh * 2 * 2147483648;
  IntegerArray[AnzahlGesamtInteger - 2] := inthigh;
  IntegerArray[AnzahlGesamtInteger - 1] := intlow;

  if chkAnzeige.Checked then
  begin
    memSha.Lines.Clear;
    memSha.Lines.Add(string(cAnsiInput));
    n := AnzahlGesamtInteger - 1;
    for i := 0 to n do
    begin
      memSha.Lines.Add(FormatFloat('00', i) + ' : ' + IntToStr(IntegerArray[i]));
    end;
    memSha.Lines.Add('#########################');
  end;

  cHash := HashMD5(IntegerArray);

  if chkAnzeige.Checked then
  begin
    //memSha.Lines.Clear;
    memSha.Lines.Add(string(cAnsiInput));
    n := AnzahlGesamtInteger - 1;
    for i := 0 to n do
    begin
      memSha.Lines.Add(FormatFloat('00', i) + ' : ' + IntToStr(IntegerArray[i]));
    end;
  end;
  edSha1.Text := cHash;
end;

procedure TfrmSha1.FieldPreparationsSha1(cAnsiInput: ansistring);
var
  AnzahlBytes: uint32;
  Anzahl512BitBloecke: uint32;
  AnzahlVollstaendigeInteger: uint32;
  AnzahlRestInteger: uint32;
  AnzahlGesamtInteger: uint32;
  IntegerArray: array of uint32;
  n, n1, n2: integer;
  hex: string;
  messagelaenge: uint64;
  inthigh, intlow: uint32;
  cHash: string;
  i: integer;
begin
  AnzahlBytes := Length(cAnsiInput);
  // 8 Bit pro Byte

  Anzahl512BitBloecke := Floor(((AnzahlBytes) * 8 + 64) / 512) + 1;
  // 16 4Byte - Integer pro 512BitBlock
  AnzahlVollstaendigeInteger := Floor(AnzahlBytes / 4);
  AnzahlRestInteger := AnzahlBytes mod 4;
  AnzahlGesamtInteger := Anzahl512BitBloecke * 16;
  SetLength(IntegerArray, AnzahlGesamtInteger);
  n := AnzahlVollstaendigeInteger - 1;

  for i := 0 to n do
  begin
    n1 := i * 4;
    IntegerArray[i] :=
      16777216 * Ord(cAnsiInput[n1 + 1]) + 65536 *
      Ord(cAnsiInput[n1 + 2]) + 256 * Ord(cAnsiInput[n1 + 3]) +
      Ord(cAnsiInput[n1 + 4]);
  end;
  n1 := AnzahlVollstaendigeInteger * 4;
  //n3 := ord(cAnsiInput[n1+1]);
  case AnzahlRestInteger of
    0:
    begin
      hex := '80000000';
      IntegerArray[AnzahlVollstaendigeInteger] := StrToInt('$' + hex);
    end;
    1:
    begin
      hex := '800000';
      IntegerArray[AnzahlVollstaendigeInteger] :=
        16777216 * Ord(cAnsiInput[n1 + 1]) + StrToInt('$' + hex);
    end;
    2:
    begin
      hex := '8000';
      IntegerArray[AnzahlVollstaendigeInteger] :=
        16777216 * Ord(cAnsiInput[n1 + 1]) + 65536 *
        Ord(cAnsiInput[n1 + 2]) + StrToInt('$' + hex);
    end;
    3:
    begin
      hex := '80';
      IntegerArray[AnzahlVollstaendigeInteger] :=
        16777216 * Ord(cAnsiInput[n1 + 1]) + 65536 *
        Ord(cAnsiInput[n1 + 2]) + 256 * Ord(cAnsiInput[n1 + 3]) + StrToInt('$' + hex);
    end;
  end;
  n1 := AnzahlVollstaendigeInteger + 1;
  n2 := AnzahlGesamtInteger - 3;
  for i := n1 to n2 do
  begin
    IntegerArray[i] := 0;
  end;
  messagelaenge := AnzahlBytes * 8;
  inthigh := Floor((messagelaenge / 2147483648) / 2);
  intlow := messagelaenge - inthigh * 2 * 2147483648;
  IntegerArray[AnzahlGesamtInteger - 2] := inthigh;
  IntegerArray[AnzahlGesamtInteger - 1] := intlow;

  cHash := HashSha1(IntegerArray);
  if chkAnzeige.Checked then
  begin
    memSha.Lines.Clear;
    memSha.Lines.Add(string(cAnsiInput));
    n := AnzahlGesamtInteger - 1;
    for i := 0 to n do
    begin
      memSha.Lines.Add(FormatFloat('00', i) + ' : ' + IntToStr(IntegerArray[i]));
    end;
  end;
  edSha1.Text := cHash;
end;

function TfrmSha1.HashMD5(var IntArray: array of uint32): string;
var
  i, jl, nLen: integer;
  nIntArrayLength, n512BlockAnzahl: integer;
  A, B, C, D, AA, BB, CC, DD: uint32;
begin

  // Werte aus IntArray in LittleEndian verwandeln
  //(auch den 64 Bit (messagelaenge) - also noch mal konvertieren?
  nLen := Length(IntArray);
  for i := 0 to (nLen - 1) do
  begin
    IntArray[i] := SwapLittleBigEndianInteger(IntArray[i]);
  end;

  A := $01234567;
  B := $89abcdef;
  C := $fedcba98;
  D := $76543210;

  A := SwapLittleBigEndianInteger(A);
  B := SwapLittleBigEndianInteger(B);
  C := SwapLittleBigEndianInteger(C);
  D := SwapLittleBigEndianInteger(D);


  nIntArrayLength := Length(IntArray);
  n512BlockAnzahl := round(nIntArrayLength / 16);
  SetLength(XArr, 16);
  for i := 0 to (n512BlockAnzahl - 1) do
  begin
    for jl := 0 to 15 do
    begin
      XArr[jl] := IntArray[16 * i + jl];
    end;

    AA := A;
    BB := B;
    CC := C;
    DD := D;

    R1(A, B, C, D, 0, 7, 1);
    R1(D, A, B, C, 1, 12, 2);
    R1(C, D, A, B, 2, 17, 3);
    R1(B, C, D, A, 3, 22, 4);

    R1(A, B, C, D, 4, 7, 5);
    R1(D, A, B, C, 5, 12, 6);
    R1(C, D, A, B, 6, 17, 7);
    R1(B, C, D, A, 7, 22, 8);

    R1(A, B, C, D, 8, 7, 9);
    R1(D, A, B, C, 9, 12, 10);
    R1(C, D, A, B, 10, 17, 11);
    R1(B, C, D, A, 11, 22, 12);

    R1(A, B, C, D, 12, 7, 13);
    R1(D, A, B, C, 13, 12, 14);
    R1(C, D, A, B, 14, 17, 15);
    R1(B, C, D, A, 15, 22, 16);

    R2(A, B, C, D, 1, 5, 17);
    R2(D, A, B, C, 6, 9, 18);
    R2(C, D, A, B, 11, 14, 19);
    R2(B, C, D, A, 0, 20, 20);

    R2(A, B, C, D, 5, 5, 21);
    R2(D, A, B, C, 10, 9, 22);
    R2(C, D, A, B, 15, 14, 23);
    R2(B, C, D, A, 4, 20, 24);

    R2(A, B, C, D, 9, 5, 25);
    R2(D, A, B, C, 14, 9, 26);
    R2(C, D, A, B, 3, 14, 27);
    R2(B, C, D, A, 8, 20, 28);

    R2(A, B, C, D, 13, 5, 29);
    R2(D, A, B, C, 2, 9, 30);
    R2(C, D, A, B, 7, 14, 31);
    R2(B, C, D, A, 12, 20, 32);

    R3(A, B, C, D, 5, 4, 33);
    R3(D, A, B, C, 8, 11, 34);
    R3(C, D, A, B, 11, 16, 35);
    R3(B, C, D, A, 14, 23, 36);

    R3(A, B, C, D, 1, 4, 37);
    R3(D, A, B, C, 4, 11, 38);
    R3(C, D, A, B, 7, 16, 39);
    R3(B, C, D, A, 10, 23, 40);

    R3(A, B, C, D, 13, 4, 41);
    R3(D, A, B, C, 0, 11, 42);
    R3(C, D, A, B, 3, 16, 43);
    R3(B, C, D, A, 6, 23, 44);

    R3(A, B, C, D, 9, 4, 45);
    R3(D, A, B, C, 12, 11, 46);
    R3(C, D, A, B, 15, 16, 47);
    R3(B, C, D, A, 2, 23, 48);

    R4(A, B, C, D, 0, 6, 49);
    R4(D, A, B, C, 7, 10, 50);
    R4(C, D, A, B, 14, 15, 51);
    R4(B, C, D, A, 5, 21, 52);

    R4(A, B, C, D, 12, 6, 53);
    R4(D, A, B, C, 3, 10, 54);
    R4(C, D, A, B, 10, 15, 55);
    R4(B, C, D, A, 1, 21, 56);

    R4(A, B, C, D, 8, 6, 57);
    R4(D, A, B, C, 15, 10, 58);
    R4(C, D, A, B, 6, 15, 59);
    R4(B, C, D, A, 13, 21, 60);

    R4(A, B, C, D, 4, 6, 61);
    R4(D, A, B, C, 11, 10, 62);
    R4(C, D, A, B, 2, 15, 63);
    R4(B, C, D, A, 9, 21, 64);


    A := A + AA;
    B := B + BB;
    C := C + CC;
    D := D + DD;
  end;


  A := SwapLittleBigEndianInteger(A);
  B := SwapLittleBigEndianInteger(B);
  C := SwapLittleBigEndianInteger(C);
  D := SwapLittleBigEndianInteger(D);


  Result := IntToHex(A, 8) + IntToHex(B, 8) +
    IntToHex(C, 8) + IntToHex(D, 8);
end;

function TfrmSha1.HashSha1(IntArray: array of uint32): string;
var
  h0, h1, h2, h3, h4: uint32;
  a, b, c, d, e, fl, k: uint32;
  nIntArrayLength, n512BlockAnzahl: integer;
  blockArray: array of uint32;
  i, jk: integer;
  temp: uint32;
begin
  h0 := $67452301;
  h1 := $EFCDAB89;
  h2 := $98BADCFE;
  h3 := $10325476;
  h4 := $C3D2E1F0;

  nIntArrayLength := Length(IntArray);
  n512BlockAnzahl := round(nIntArrayLength / 16);
  SetLength(blockArray, 80);
  for i := 0 to (n512BlockAnzahl - 1) do
  begin
    for jk := 0 to 15 do
    begin
      blockArray[jk] := IntArray[16 * i + jk];

    end;
    for jk := 16 to 79 do
    begin
      blockArray[jk] := ((blockarray[jk - 3] xor blockarray[jk - 8] xor
        blockarray[jk - 14] xor
        blockarray[jk - 16]) shl 1) or
        ((blockarray[jk - 3] xor blockarray[jk - 8] xor
        blockarray[jk - 14] xor
        blockarray[jk - 16]) shr 31);
    end;
    a := h0;
    b := h1;
    c := h2;
    d := h3;
    e := h4;

    fl := $00000000;
    k := $00000000;

    for jk := 0 to 79 do
    begin
      if (0 <= jk) and (jk <= 19) then
      begin
        fl := (b and c) or ((not b) and d);
        k := $5A827999;
      end;
      if (20 <= jk) and (jk <= 39) then
      begin
        fl := b xor c xor d;
        k := $6ED9EBA1;
      end;
      if (40 <= jk) and (jk <= 59) then
      begin
        fl := (b and c) or (b and d) or (c and d);
        k := $8F1BBCDC;
      end;
      if (60 <= jk) and (jk <= 79) then
      begin
        fl := b xor c xor d;
        k := $CA62C1D6;
      end;

      temp := (a shl 5) or (a shr 27) + fl + e + k + blockArray[jk];
      e := d;
      d := c;
      c := (b shl 30) or (b shr 2);
      b := a;
      a := temp;

    end;

    h0 := h0 + a;
    h1 := h1 + b;
    h2 := h2 + c;
    h3 := h3 + d;
    h4 := h4 + e;
  end;

  Result := IntToHex(h0, 8) + IntToHex(h1, 8) +
    IntToHex(h2, 8) + IntToHex(h3, 8) + IntToHex(h4, 8);
end;

function TfrmSha1.UIntToStr(Value: uint32): string;
begin
  FmtStr(Result, '%u', [Value]);
end;

function TfrmSha1.UIntToStr(Value: UInt64): string;
begin
  FmtStr(Result, '%u', [Value]);
end;


procedure TfrmSha1.SwapEndiannessOfBits(var Value: uint32);
var
  tmp: uint32;
  i: integer;
begin
  tmp := 0;
  // ii := sizeof(Value);

  // for i := 0 to 8*sizeof(Value) - 1 do
  for i := 0 to 32 - 1 do
    //    inc(tmp, ((Value shr i) and $1) shl (8*sizeof(Value) - i - 1));
    Inc(tmp, ((Value shr i) and $1) shl (32 - i - 1));
  Value := tmp;
end;

procedure TfrmSha1.SwapEndiannessOfBits(var Value: uint64);
var
  tmp: uint64;
  i: integer;
begin
  tmp := 0;
  //  for i := 0 to 8*sizeof(Value) - 1 do
  //  inc(tmp, ((Value shr i) and $1) shl (8*sizeof(Value) - i - 1));
  for i := 0 to 64 - 1 do
    Inc(tmp, ((Value shr i) and $1) shl (64 - i - 1));
  Value := tmp;
end;

function TfrmSha1.F(Xl, Y, Z: uint32): uint32;
begin
  Result := (Xl and Y) or ((not Xl) and Z);
end;

function TfrmSha1.G(Xl, Y, Z: uint32): uint32;
begin
  Result := (Xl and Z) or (Y and (not Z));
end;

function TfrmSha1.H(Xl, Y, Z: uint32): uint32;
begin
  Result := Xl xor Y xor Z;
end;

function TfrmSha1.J(Xl, Y, Z: uint32): uint32;
begin
  Result := Y xor (Xl or (not Z));
end;

end.
