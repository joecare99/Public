unit frm_AesTestMain;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, {$IFDEF FPC}FileUtil,{$ENDIF} Forms, Controls, Dialogs,
  StdCtrls;

type

  { TfrmAES }

   THex = record
    hx: smallint;
    hy: smallint;
  end;

  TWords = record
    b0: integer;
    b1: integer;
    b2: integer;
    b3: integer;
  end;

  TBits = record
    bi: array[0..7] of smallint;
  end;

  TfrmAES = class(TForm)
    Label1: TLabel;
    memKey: TMemo;
    Label2: TLabel;
    memText: TMemo;
    Label3: TLabel;
    memEncrypt: TMemo;
    Label4: TLabel;
    memDecrypt: TMemo;
    cmdStart: TButton;
    cmdEncrypt: TButton;
    oOpen: TOpenDialog;
    oSave: TSaveDialog;
    procedure cmdStartClick(Sender: TObject);
    procedure cmdEncryptClick(Sender: TObject);
  private
    { Private-Deklarationen }
    nAnzahlInputBloecke: integer;
    nAnzahlInputByte: integer;
    inp, outp, s: array[0..3, 0..3] of Byte;
    wo, w1, w2, w3 : Cardinal;
    w: array[0..59] of Cardinal;
    key: array[0..31] of Byte;
    procedure AddToMemEncryptMemo();// Schlechter Stil: Eingabevariablen/Konstanten Ausgabevariablen
    procedure AddToMemDecryptMemo();
    procedure AddIntEncryptMemo(n:Cardinal);
    procedure Encrypt();  // Schlechter Stil: Eingabevariablen/Konstanten Ausgabevariablen
    procedure KeyExpansion();
    procedure SubBytes();
    procedure ShiftRows();
    procedure MixColumns();
    procedure AddRoundKey(rd: integer);
    procedure Cipher();
    function ZerlegeHex(a:Byte): THex;
    function ZerlegeBit(a:Byte): TBits;
    function ZerlegeWords(a:Cardinal): TWords;
    function CardinalausBytes(h: TWords): Cardinal;
    function ByteausBit(h: TBits): Byte;
    function ByteausHex(h: THex): Byte;
    function ByteAdd(a, b: Byte): Byte;
    function ByteMult(a, b: Byte): Byte;
    function xtime(a: Cardinal): Byte;
    function RotWord(a: Cardinal): Cardinal;
    function IntMult(a, b: Cardinal): Cardinal;
    function SubByte(a: Byte):Byte;
    function SubWord(a: Cardinal):Cardinal;

    function InvRotWord(a: Cardinal): Cardinal;
    procedure InvShiftRows(); // Schlechter Stil: Eingabevariablen/Konstanten Ausgabevariablen
    procedure InvSubBytes();
    function InvSubByte(a: Byte):Byte;
    procedure InvMixColumns();
    procedure InvCipher();

  public
    { Public-Deklarationen }
  end;
const // x^i - Multiplikation gemaess Spezifikation - mehr als 10 Werte nicht noetig
  RCon: array[1..10] of cardinal= ($01,$02,$04,$08,$10,$20,$40,$80,$1b,$36);

const
  SBox: array[0..255] of byte =
   ($63, $7c, $77, $7b, $f2, $6b, $6f, $c5, $30, $01, $67, $2b, $fe, $d7, $ab, $76,
    $ca, $82, $c9, $7d, $fa, $59, $47, $f0, $ad, $d4, $a2, $af, $9c, $a4, $72, $c0,
    $b7, $fd, $93, $26, $36, $3f, $f7, $cc, $34, $a5, $e5, $f1, $71, $d8, $31, $15,
    $04, $c7, $23, $c3, $18, $96, $05, $9a, $07, $12, $80, $e2, $eb, $27, $b2, $75,
    $09, $83, $2c, $1a, $1b, $6e, $5a, $a0, $52, $3b, $d6, $b3, $29, $e3, $2f, $84,
    $53, $d1, $00, $ed, $20, $fc, $b1, $5b, $6a, $cb, $be, $39, $4a, $4c, $58, $cf,
    $d0, $ef, $aa, $fb, $43, $4d, $33, $85, $45, $f9, $02, $7f, $50, $3c, $9f, $a8,
    $51, $a3, $40, $8f, $92, $9d, $38, $f5, $bc, $b6, $da, $21, $10, $ff, $f3, $d2,
    $cd, $0c, $13, $ec, $5f, $97, $44, $17, $c4, $a7, $7e, $3d, $64, $5d, $19, $73,
    $60, $81, $4f, $dc, $22, $2a, $90, $88, $46, $ee, $b8, $14, $de, $5e, $0b, $db,
    $e0, $32, $3a, $0a, $49, $06, $24, $5c, $c2, $d3, $ac, $62, $91, $95, $e4, $79,
    $e7, $c8, $37, $6d, $8d, $d5, $4e, $a9, $6c, $56, $f4, $ea, $65, $7a, $ae, $08,
    $ba, $78, $25, $2e, $1c, $a6, $b4, $c6, $e8, $dd, $74, $1f, $4b, $bd, $8b, $8a,
    $70, $3e, $b5, $66, $48, $03, $f6, $0e, $61, $35, $57, $b9, $86, $c1, $1d, $9e,
    $e1, $f8, $98, $11, $69, $d9, $8e, $94, $9b, $1e, $87, $e9, $ce, $55, $28, $df,
    $8c, $a1, $89, $0d, $bf, $e6, $42, $68, $41, $99, $2d, $0f, $b0, $54, $bb, $16);


const
  InvSBox: array[0..255] of byte =
   ($52, $09, $6a, $d5, $30, $36, $a5, $38, $bf, $40, $a3, $9e, $81, $f3, $d7, $fb,
    $7c, $e3, $39, $82, $9b, $2f, $ff, $87, $34, $8e, $43, $44, $c4, $de, $e9, $cb,
    $54, $7b, $94, $32, $a6, $c2, $23, $3d, $ee, $4c, $95, $0b, $42, $fa, $c3, $4e,
    $08, $2e, $a1, $66, $28, $d9, $24, $b2, $76, $5b, $a2, $49, $6d, $8b, $d1, $25,
    $72, $f8, $f6, $64, $86, $68, $98, $16, $d4, $a4, $5c, $cc, $5d, $65, $b6, $92,
    $6c, $70, $48, $50, $fd, $ed, $b9, $da, $5e, $15, $46, $57, $a7, $8d, $9d, $84,
    $90, $d8, $ab, $00, $8c, $bc, $d3, $0a, $f7, $e4, $58, $05, $b8, $b3, $45, $06,
    $d0, $2c, $1e, $8f, $ca, $3f, $0f, $02, $c1, $af, $bd, $03, $01, $13, $8a, $6b,
    $3a, $91, $11, $41, $4f, $67, $dc, $ea, $97, $f2, $cf, $ce, $f0, $b4, $e6, $73,
    $96, $ac, $74, $22, $e7, $ad, $35, $85, $e2, $f9, $37, $e8, $1c, $75, $df, $6e,
    $47, $f1, $1a, $71, $1d, $29, $c5, $89, $6f, $b7, $62, $0e, $aa, $18, $be, $1b,
    $fc, $56, $3e, $4b, $c6, $d2, $79, $20, $9a, $db, $c0, $fe, $78, $cd, $5a, $f4,
    $1f, $dd, $a8, $33, $88, $07, $c7, $31, $b1, $12, $10, $59, $27, $80, $ec, $5f,
    $60, $51, $7f, $a9, $19, $b5, $4a, $0d, $2d, $e5, $7a, $9f, $93, $c9, $9c, $ef,
    $a0, $e0, $3b, $4d, $ae, $2a, $f5, $b0, $c8, $eb, $bb, $3c, $83, $53, $99, $61,
    $17, $2b, $04, $7e, $ba, $77, $d6, $26, $e1, $69, $14, $63, $55, $21, $0c, $7d);

const
  KEYLENGTH   = 256;
  BLOCKLENGTH = 128; // 128 Bit = 16 Byte = 4 4Byte-Integer
  NB = 4;   // Blocksize in 4 - Byte - Integers
  NK = 8; //4  // KeySize in 4 - Byte - Integers
  NR = 14;//10  // Number of Rounds


var
  frmAES: TfrmAES;

implementation

uses
  math;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

procedure TfrmAES.cmdEncryptClick(Sender: TObject);
var
  by: PByte;
  i, j, m, n, nLen, nMod: integer;
  tby, tbKey, tbKrypt, tbDekrypt : TBytes;
  sStream: TMemoryStream;
  nBlockAnzahl : integer;
  nOffSet, nOff, nx, ny: integer;
  cInput, cAnsiKey, cAnsi: AnsiString;
  nHelpA, nHelpB: integer;
  cKrypt, cDekrypt: String;
  sl: TStringList;
begin

  if not (oOpen.Execute()) then
    exit;

  sStream := TMemoryStream.Create();
  sStream.LoadFromFile(oOpen.FileName);
  nLen := sStream.Size ;
  sStream.Seek(0, soFromBeginning);
  SetLength(tby,nLen);
  sStream.ReadBuffer(tby[0],nLen);
  FreeAndNil(sStream);



  // Schlüssel einlesen
  cInput := trim(memKey.Text);
  tbKey := TEncoding.utf8.GetBytes(cInput);
  nLen := Length(tby);
  cAnsiKey := '';
  if nLen > NK * 4 then
  begin // 256er Schlüssel - AES 256
    nLen := NK * 4;
  end;
  for i := 0 to nLen - 1 do
    begin
      cAnsi := '';
      by  := @tbKey[i];
      SetString(cAnsi, PAnsiChar(by), 1);
      cAnsiKey := cAnsiKey + cAnsi;
    end;
  nLen := Length(cAnsiKey);
  for i := nLen to (NK * 4 - 1) do
  begin
    cAnsiKey := cAnsiKey + '1';
  end;
  nLen := Length(cAnsiKey);
  if nLen <> NK * 4 then
  begin
    ShowMessage('Key hat falsche Länge - Abbruch');
    exit;
  end;
  for i := 0 to (NK * 4 - 1) do
    begin // Feld mit SchluesselBytes fuellen
       key[i] := Byte(cAnsiKey[i+1]);
    end;



  nLen := Length(tby);

  // Text auf Vielfaches von 16 erweitern

  nMod := nLen mod 16;
  // 16Byte - Blöcke
  if nMod = 0 then
    nBlockanzahl := Floor(nLen / 16)
  else
    nBlockanzahl := Floor(nLen / 16) + 1;
  if nMod > 0 then
  begin
    SetLength(tby,nBlockAnzahl * 16);
    for i := nLen to nBlockAnzahl * 16 - 1 do
      begin
        tby[i] := $61;
      end;
  end;
  SetLength(tbKrypt,nBlockAnzahl * 16);
  SetLength(tbDekrypt,nBlockAnzahl * 16);

  nOffSet := 0;
  //memEncrypt.Lines.Clear;
  nHelpA := 0;
  nHelpB := 0;
  for i := 1 to nBlockanzahl do
    begin
      for j := nOffSet* 16  to (nOffSet * 16 + 15) do
        begin
          nOff := j - nOffSet * 16;
          nx := nOff mod 4;
          ny := Floor(nOff / 4);
          inp[nx,ny]:= tby[j];
          s[nx, ny] := inp[nx, ny];
          outp[nx,ny] := $00;
        end;
      cipher();
      for m := 0 to 3 do
        begin
          for n := 0 to 3 do
            begin
               tbKrypt[nHelpA]:= s[n,m];
               nHelpA := nHelpA + 1;
            end;
        end;
      InvCipher;
      for m := 0 to 3 do
        begin
          for n := 0 to 3 do
            begin
               tbDekrypt[nHelpB]:= s[n,m];
               nHelpB := nHelpB + 1;
            end;
        end;
      nOffSet := nOffSet + 1;
    end;
  cKrypt := '';
  cDekrypt := '';
  sl := TStringList.Create();
  sl.Clear;

  for i := 0 to Length(tbKrypt) -1 do
    begin
      cKrypt := cKrypt + ' ' + IntToHex(tbKrypt[i],2);
    end;
  for i := 0 to Length(tbDekrypt) -1 do
    begin
      cDekrypt := cDekrypt +  char(tbDekrypt[i]);
    end;
  if not oSave.Execute then
    exit;
  sl.Add(cKrypt);
  sl.Add('');
  sl.Add(cDekrypt);
  sl.SaveToFile(oSave.FileName);
  FreeAndNil(sl);


  if not oSave.Execute then
    exit;
  sStream := TMemoryStream.Create();
  sStream.LoadFromFile(oOpen.FileName);
  nLen := sStream.Size ;
  sStream.Seek(0, soFromBeginning);
  sStream.Write(tbDekrypt, Length(tbDekrypt));
  sStream.SaveToFile(oSave.FileName);
  FreeAndNil(sStream);

end;

procedure TfrmAES.cmdStartClick(Sender: TObject);
var
  by: PByte;
  cInput: String;
  nLen: integer;
  cAnsiInput, cAnsiKey: AnsiString;
  cAnsi:AnsiString;
  i, j, nx, ny, nOff: integer;
  tby : TBytes;
  nAnzahl16: integer;
  nOffSet: integer;
begin

  // Schlüssel einlesen
  cInput := trim(memKey.Text);
  tby := TEncoding.utf8.GetBytes(cInput);
  nLen := Length(tby);
  cAnsiKey := '';
  if nLen > NK * 4 then
  begin // 256er Schlüssel - AES 256
    nLen := NK * 4;
  end;
  for i := 0 to nLen - 1 do
    begin
      cAnsi := '';
      by  := @tby[i];
      SetString(cAnsi, PAnsiChar(by), 1);
      cAnsiKey := cAnsiKey + cAnsi;
    end;
  nLen := Length(cAnsiKey);
  for i := nLen to (NK * 4 - 1) do
  begin
    cAnsiKey := cAnsiKey + '1';
  end;
  nLen := Length(cAnsiKey);
  if nLen <> NK * 4 then
  begin
    ShowMessage('Key hat falsche Länge - Abbruch');
    exit;
  end;
  for i := 0 to (NK * 4 - 1) do
    begin // Feld mit SchluesselBytes fuellen
       key[i] := Byte(cAnsiKey[i+1]);
    end;
    {
    key[0]  := $2b;
    key[1]  := $7e;
    key[2]  := $15;
    key[3]  := $16;
    key[4]  := $28;
    key[5]  := $ae;
    key[6]  := $d2;
    key[7]  := $a6;
    key[8]  := $ab;
    key[9]  := $f7;
    key[10] := $15;
    key[11] := $88;
    key[12] := $09;
    key[13] := $cf;
    key[14] := $4f;
    key[15] := $3c;

    key[0]  := $00;
    key[1]  := $01;
    key[2]  := $02;
    key[3]  := $03;
    key[4]  := $04;
    key[5]  := $05;
    key[6]  := $06;
    key[7]  := $07;
    key[8]  := $08;
    key[9]  := $09;
    key[10] := $0a;
    key[11] := $0b;
    key[12] := $0c;
    key[13] := $0d;
    key[14] := $0e;
    key[15] := $0f;
    }

  KeyExpansion();

  cInput := trim(memText.Text);
  tby := TEncoding.utf8.GetBytes(cInput);
  nLen := Length(tby);
  nAnzahl16 := Floor(nLen/16) ;
  // 16 Byte sind 128 Bit ! Hier Blocklaenge
  if (nAnzahl16 * 16) < nLen then
    nAnzahlInputBloecke := nAnzahl16 + 1
  else
    nAnzahlInputBloecke := nAnzahl16;
  nAnzahlInputByte := nAnzahlInputBloecke * 16;
  for i := 0 to nLen - 1 do
    begin
      cAnsi := '';
      by  := @tby[i];
      SetString(cAnsi, PAnsiChar(by), 1);
      cAnsiInput := cAnsiInput + cAnsi;
    end;
  for i := nLen to nAnzahlInputByte - 1 do
     cAnsiInput := cAnsiInput + '1';


  nOffSet := 0;
  //memEncrypt.Lines.Clear;
  for i := 1 to nAnzahlInputBloecke do
    begin
      for j := nOffSet* 16 +1 to (nOffSet * 16 + 16) do
        begin
          nOff := j - nOffSet * 16 - 1;
          nx := nOff mod 4;
          ny := Floor(nOff / 4);
          inp[nx,ny]:= Byte(cAnsiInput[j]);
          s[nx, ny] := inp[nx, ny];
          outp[nx,ny] := $00;
        end;
      {
      s[0,0] := $32;
      s[1,0] := $43;
      s[2,0] := $f6;
      s[3,0] := $a8;
      s[0,1] := $88;
      s[1,1] := $5a;
      s[2,1] := $30;
      s[3,1] := $8d;
      s[0,2] := $31;
      s[1,2] := $31;
      s[2,2] := $98;
      s[3,2] := $a2;
      s[0,3] := $e0;
      s[1,3] := $37;
      s[2,3] := $07;
      s[3,3] := $34;

      s[0,0] := $00;
      s[1,0] := $11;
      s[2,0] := $22;
      s[3,0] := $33;
      s[0,1] := $44;
      s[1,1] := $55;
      s[2,1] := $66;
      s[3,1] := $77;
      s[0,2] := $88;
      s[1,2] := $99;
      s[2,2] := $aa;
      s[3,2] := $bb;
      s[0,3] := $cc;
      s[1,3] := $dd;
      s[2,3] := $ee;
      s[3,3] := $ff;
      }
      AddToMemEncryptMemo();
      Cipher();
      AddToMemEncryptMemo();
    {
    key[0]  := $2b;
    key[1]  := $7e;
    key[2]  := $15;
    key[3]  := $16;
    key[4]  := $28;
    key[5]  := $ae;
    key[6]  := $d2;
    key[7]  := $a6;
    key[8]  := $ab;
    key[9]  := $f7;
    key[10] := $15;
    key[11] := $88;
    key[12] := $09;
    key[13] := $cf;
    key[14] := $4f;
    key[15] := $3c;

    key[0]  := $00;
    key[1]  := $01;
    key[2]  := $02;
    key[3]  := $03;
    key[4]  := $04;
    key[5]  := $05;
    key[6]  := $06;
    key[7]  := $07;
    key[8]  := $08;
    key[9]  := $09;
    key[10] := $0a;
    key[11] := $0b;
    key[12] := $0c;
    key[13] := $0d;
    key[14] := $0e;
    key[15] := $0f;

  KeyExpansion();
    }
      InvCipher();
      AddToMemEncryptMemo();
      AddToMemDecryptMemo();

      nOffSet := nOffSet + 1;
    end;

  //memDecrypt.Clear;
  memDecrypt.Lines.Add(cAnsiInput);
end;

procedure TfrmAES.Encrypt();
var
  a, b, c :Byte;
  ha, hb,hc : THex;
begin
  wo := s[3,0] + s[2,0] * 256 + s[1,0] * 256 * 256 + s[0,0] * 256 * 256 * 256;
  w1 := s[3,1] + s[2,1] * 256 + s[1,1] * 256 * 256 + s[0,1] * 256 * 256 * 256;
  w2 := s[3,2] + s[2,2] * 256 + s[1,2] * 256 * 256 + s[0,2] * 256 * 256 * 256;
  w3 := s[3,3] + s[2,3] * 256 + s[1,3] * 256 * 256 + s[0,3] * 256 * 256 * 256;
  // Testfunktionen ?
  ha.hx := 2;
  ha.hy := 0;
  a := ByteausHex(ha);
  hb.hx := 4;
  hb.hy := 13;
  b := ByteausHex(hb);
  c := ByteMult(a,b);
  hc := ZerlegeHex(c);
  hb := ZerlegeHex(c);
end;


function TfrmAES.ByteAdd(a, b: Byte): Byte;
begin
  result := a Xor b;
end;

function TfrmAES.xtime(a: Cardinal): Byte;
var
  k: integer;
begin
  k := a shl 1;
  if k >= 256 then
    result := k Xor $11b
  else
    result := k;
{  if result >= 256 then  // Result :Byte kann nicht größer als 255 werden
    showmessage('Fehler in xtime'); }
end;

function TfrmAES.ZerlegeHex(a:Byte): THex;
var
 h: THex;
begin
  h.hy := Floor(a / 16);
  h.hx := a - h.hy * 16;
  result := h;
end;

function TfrmAES.ByteausHex(h:THex): Byte;
begin
  result := 16 * h.hy + h.hx;
end;

function TfrmAES.ByteMult(a, b: Byte): Byte;
var
  bHex: THex;
  bBits: TBits;
  nu, i , j: integer;
  bRes, Res: Byte;
begin
  bHex := ZerlegeHex(b);
  bBits := ZerlegeBit(b);
  Res := $00;
  //bRes := a;
  for i := 1 to 7 do
    begin
      bRes := a;
      if bBits.bi[i] <>  0 then
      begin
        for j := 1 to i do
          begin
             bRes := xtime(bRes);
          end;
        Res := ByteAdd(bRes,Res) ;
      end;
    end;
  nu := bHex.hx mod 2;
  for i := 0 to nu - 1 do
  begin
    Res := ByteAdd(Res,a);
  end;
  result := Res;
end;

function TfrmAES.ZerlegeBit(a:Byte): TBits;
var
  bRes: TBits;
  n: integer;
begin
  n := a; // 0 bis 255 als Byte
  bRes.bi[7] := Floor(n / 128);
  n := n - bRes.bi[7] * 128;
  bRes.bi[6] := Floor(n / 64);
  n := n - bRes.bi[6] * 64;
  bRes.bi[5] := Floor(n / 32);
  n := n - bRes.bi[5] * 32;
  bRes.bi[4] := Floor(n / 16);
  n := n - bRes.bi[4] * 16;
  bRes.bi[3] := Floor(n / 8);
  n := n - bRes.bi[3] * 8;
  bRes.bi[2] := Floor(n / 4);
  n := n - bRes.bi[2] * 4;
  bRes.bi[1] := Floor(n / 2);
  n := n - bRes.bi[1] * 2;
  bRes.bi[0] := Floor(n);
  result := bRes;
end;
function TfrmAES.ByteausBit(h: TBits): Byte;
begin
  result := h.bi[7] * 128 + h.bi[6] *  64 + h.bi[5] *  32 + h.bi[4] *  16 +
            h.bi[3] *   8 + h.bi[2] *   4 + h.bi[1] *   2 + h.bi[0];
end;

function TfrmAES.ZerlegeWords(a:Cardinal): TWords;
var
  cRes: TWords;
  n: Cardinal;
begin
  n := a;
  cRes.b3 := Floor(n / 256 / 256 / 256);
  n  :=  n - cRes.b3 * 256 * 256 * 256;
  cRes.b2 := Floor(n / 256 / 256);
  n  :=  n - cRes.b2 * 256 * 256 ;
  cRes.b1 := Floor(n / 256);
  n  :=  n - cRes.b1 * 256;
  cRes.b0 := Floor(n);
  result := cRes;
end;
function TfrmAES.CardinalausBytes(h: TWords): Cardinal;
begin
  Result := h.b3 * 256 * 256 * 256 + h.b2 * 256 * 256 +
            h.b1 * 256             + h.b0;
end;

function TfrmAES.RotWord(a: Cardinal): Cardinal;
var
 c1, c2: TWords;
begin
 c1 := ZerlegeWords(a);
 c2.b0 := c1.b1;
 c2.b1 := c1.b2;
 c2.b2 := c1.b3;
 c2.b3 := c1.b0;
 result := CardinalausBytes(c2);
end;
function TfrmAES.InvRotWord(a: Cardinal): Cardinal;
var
 c1, c2: TWords;
begin
 c1 := ZerlegeWords(a);
 c2.b0 := c1.b3;
 c2.b1 := c1.b0;
 c2.b2 := c1.b1;
 c2.b3 := c1.b2;
 result := CardinalausBytes(c2);
end;

function TfrmAES.IntMult(a, b: Cardinal): Cardinal;
var
 ca, cb, cd : TWords;
{ wm, xm, ym, zm : Byte;}
begin
 ca := ZerlegeWords(a);
 cb := ZerlegeWords(b);
{  ist dieser teil nötig ?
 zm := ByteMult(ca.b1,cb.b3);
 ym := ByteMult(ca.b2,cb.b2);
 xm := ByteMult(ca.b3,cb.b1);
 wm := ByteMult(ca.b0,cb.b0); }

 cd.b0 := ByteAdd(ByteMult(ca.b0,cb.b0),
             ByteAdd(ByteMult(ca.b3,cb.b1),
                        ByteAdd(ByteMult(ca.b2,cb.b2),ByteMult(ca.b1,cb.b3))
                    )
              );
 cd.b1 := ByteAdd(ByteMult(ca.b1,cb.b0),
             ByteAdd(ByteMult(ca.b0,cb.b1),
                        ByteAdd(ByteMult(ca.b3,cb.b2),ByteMult(ca.b2,cb.b3))
                    )
              );
 cd.b2 := ByteAdd(ByteMult(ca.b2,cb.b0),
             ByteAdd(ByteMult(ca.b1,cb.b1),
                        ByteAdd(ByteMult(ca.b0,cb.b2),ByteMult(ca.b3,cb.b3))
                    )
              );
 cd.b3 := ByteAdd(ByteMult(ca.b3,cb.b0),
             ByteAdd(ByteMult(ca.b2,cb.b1),
                        ByteAdd(ByteMult(ca.b1,cb.b2),ByteMult(ca.b0,cb.b3))
                    )
              );
 result := CardinalausBytes(cd);
end;

function TfrmAES.SubByte(a: Byte):Byte;
var
  ha : THex;
begin
  ha := ZerlegeHex(a);
  result := SBox[ha.hy * 16 + ha.hx];
end;

function TfrmAES.InvSubByte(a: Byte):Byte;
var
  ha : THex;
begin
  ha := ZerlegeHex(a);
  result := InvSBox[ha.hy * 16 + ha.hx];
end;

function TfrmAES.SubWord(a: Cardinal):Cardinal;
var
  wa: TWords;
begin
  wa := ZerlegeWords(a);
  wa.b0 := SubByte(wa.b0);
  wa.b1 := SubByte(wa.b1);
  wa.b2 := SubByte(wa.b2);
  wa.b3 := SubByte(wa.b3);
  result := CardinalausBytes(wa);;
end;

procedure TfrmAES.KeyExpansion();
var
  temp: Cardinal;
  i: integer;
  ww: TWords;
begin
  for i := 0 to NK-1 do
  begin
    ww.b0 := key[4 * i];
    ww.b1 := key[4 * i + 1];
    ww.b2 := key[4 * i + 2];
    ww.b3 := key[4 * i + 3];
    w[i] := CardinalausBytes(ww);
  end;
  i := NK;
  while (i < NB * (NR + 1))  do
  begin
    temp := w[i-1];
    //AddIntEncryptMemo(temp);

    if ((i mod NK) = 0) then
      temp := SubWord(RotWord(temp)) Xor RCon[Floor(i/NK)]
    else if ((NK > 6) and ((i mod NK) = 4)) then
      temp := SubWord(temp);

    w[i] := w[i-NK] Xor temp;

    //AddIntEncryptMemo(w[i]);
    i:= i + 1;
  end;
end;

procedure TfrmAES.SubBytes();
var
  i,j : integer;
begin
  for i := 0 to 3 do
    begin
      for j := 0 to NB - 1 do
      begin
        s[i,j] := SubByte(s[i,j]);
      end;
    end;
end;
procedure TfrmAES.InvSubBytes();
var
  i,j : integer;
begin
  for i := 0 to 3 do
    begin
      for j := 0 to NB - 1 do
      begin
        s[i,j] := InvSubByte(s[i,j]);
      end;
    end;
end;

procedure TfrmAES.ShiftRows();
var
  nRot: Cardinal;
  hw: TWords;
begin
  hw.b0 := s[1,0];
  hw.b1 := s[1,1];
  hw.b2 := s[1,2];
  hw.b3 := s[1,3];
  nRot := CardinalausBytes(hw);
  nRot := RotWord(nRot);
  hw := ZerlegeWords(nRot);
  s[1,0] := hw.b0;
  s[1,1] := hw.b1;
  s[1,2] := hw.b2;
  s[1,3] := hw.b3;

  hw.b0 := s[2,0];
  hw.b1 := s[2,1];
  hw.b2 := s[2,2];
  hw.b3 := s[2,3];
  nRot := CardinalausBytes(hw);
  nRot := RotWord(nRot);
  nRot := RotWord(nRot);
  hw := ZerlegeWords(nRot);
  s[2,0] := hw.b0;
  s[2,1] := hw.b1;
  s[2,2] := hw.b2;
  s[2,3] := hw.b3;

  hw.b0 := s[3,0];
  hw.b1 := s[3,1];
  hw.b2 := s[3,2];
  hw.b3 := s[3,3];
  nRot := CardinalausBytes(hw);
  nRot := RotWord(nRot);
  nRot := RotWord(nRot);
  nRot := RotWord(nRot);
  hw := ZerlegeWords(nRot);
  s[3,0] := hw.b0;
  s[3,1] := hw.b1;
  s[3,2] := hw.b2;
  s[3,3] := hw.b3;
end;
procedure TfrmAES.InvShiftRows();
var
  nRot: Cardinal;
  hw: TWords;
begin
  hw.b0 := s[1,0];
  hw.b1 := s[1,1];
  hw.b2 := s[1,2];
  hw.b3 := s[1,3];
  nRot := CardinalausBytes(hw);
  nRot := InvRotWord(nRot);
  hw := ZerlegeWords(nRot);
  s[1,0] := hw.b0;
  s[1,1] := hw.b1;
  s[1,2] := hw.b2;
  s[1,3] := hw.b3;

  hw.b0 := s[2,0];
  hw.b1 := s[2,1];
  hw.b2 := s[2,2];
  hw.b3 := s[2,3];
  nRot := CardinalausBytes(hw);
  nRot := InvRotWord(nRot);
  nRot := InvRotWord(nRot);
  hw := ZerlegeWords(nRot);
  s[2,0] := hw.b0;
  s[2,1] := hw.b1;
  s[2,2] := hw.b2;
  s[2,3] := hw.b3;

  hw.b0 := s[3,0];
  hw.b1 := s[3,1];
  hw.b2 := s[3,2];
  hw.b3 := s[3,3];
  nRot := CardinalausBytes(hw);
  nRot := InvRotWord(nRot);
  nRot := InvRotWord(nRot);
  nRot := InvRotWord(nRot);
  hw := ZerlegeWords(nRot);
  s[3,0] := hw.b0;
  s[3,1] := hw.b1;
  s[3,2] := hw.b2;
  s[3,3] := hw.b3;
end;

procedure TfrmAES.MixColumns();
var
  i: integer;
  hw, hs, hRes: TWords;
  ms, sc, nRes: Cardinal;
begin
  hw.b0 := $02;
  hw.b1 := $01;
  hw.b2 := $01;
  hw.b3 := $03;
  ms := CardinalausBytes(hw);
  for i := 0 to NB - 1 do
    begin
      hs.b0 := s[0,i];
      hs.b1 := s[1,i];
      hs.b2 := s[2,i];
      hs.b3 := s[3,i];
      sc := CardinalausBytes(hs);
      nRes := IntMult(sc,ms);
      hRes := ZerlegeWords(nRes);
      s[0,i] := hRes.b0;
      s[1,i] := hRes.b1;
      s[2,i] := hRes.b2;
      s[3,i] := hRes.b3;
    end;
end;

procedure TfrmAES.AddRoundKey(rd: integer);  // rd: round
var
  i: integer;
  hw: TWords;
begin
  for i := 0 to NB - 1 do
  begin
      hw := ZerlegeWords(w[rd * NB + i]);
      s[0,i] := ByteAdd(s[0,i], hw.b0);
      s[1,i] := ByteAdd(s[1,i], hw.b1);
      s[2,i] := ByteAdd(s[2,i], hw.b2);
      s[3,i] := ByteAdd(s[3,i], hw.b3);
  end;

end;



procedure TfrmAES.Cipher();
var
  rd : integer;
begin
  AddRoundKey(0);

  //AddToMemEncryptMemo();

  for rd := 1 to NR - 1 do
  begin
    SubBytes;
    //AddToMemEncryptMemo();
    ShiftRows;
    //AddToMemEncryptMemo();
    MixColumns;
    //AddToMemEncryptMemo();
    AddRoundKey(rd);
    //AddToMemEncryptMemo();

    //memEncrypt.Lines.Add('');

  end;
  SubBytes;
  ShiftRows;
  AddRoundKey(NR);
  //AddToMemEncryptMemo();
  //memEncrypt.Lines.Add('');
end;


procedure TfrmAES.InvCipher();
var
  rd : integer;
begin
  AddRoundKey(NR);

  //AddToMemEncryptMemo();

  for rd := (NR - 1) downto 1 do
  begin
    InvShiftRows;
    //AddToMemEncryptMemo();
    InvSubBytes;
    //AddToMemEncryptMemo();
    //memEncrypt.Lines.Add('');

    AddRoundKey(rd);
    //AddToMemEncryptMemo();
    //memEncrypt.Lines.Add('RoundKey');

    InvMixColumns;
    //memEncrypt.Lines.Add('MixColumns');
    //AddToMemEncryptMemo();

    //memEncrypt.Lines.Add('');

  end;
  InvShiftRows;
  InvSubBytes;
  AddRoundKey(0);
  //memEncrypt.Lines.Add('Result');
  //AddToMemEncryptMemo();
end;

procedure TfrmAES.InvMixColumns();
var
  i: integer;
  hw, hs, hRes: TWords;
  ms, sc, nRes: Cardinal;
begin
  hw.b0 := $0e;
  hw.b1 := $09;
  hw.b2 := $0d;
  hw.b3 := $0b;
  ms := CardinalausBytes(hw);
  for i := 0 to NB - 1 do
    begin
      hs.b0 := s[0,i];
      hs.b1 := s[1,i];
      hs.b2 := s[2,i];
      hs.b3 := s[3,i];
      sc := CardinalausBytes(hs);
      nRes := IntMult(sc,ms);
      hRes := ZerlegeWords(nRes);
      s[0,i] := hRes.b0;
      s[1,i] := hRes.b1;
      s[2,i] := hRes.b2;
      s[3,i] := hRes.b3;
    end;
end;

procedure TfrmAES.AddToMemEncryptMemo();
var
 i,j: integer;
 cString: String;
begin
  cString := '';
  for i := 0 to 3 do
    begin
      for j := 0 to 3 do
        begin
          cString := cString + ' ' + IntToHex(s[j,i],2);
        end;
    end;
   memEncrypt.Lines.Add(cString);
end;
procedure TfrmAES.AddToMemDecryptMemo();
var
 i,j: integer;
 cString: String;
begin
  cString := '';
  for i := 0 to 3 do
    begin
      for j := 0 to 3 do
        begin
          cString := cString + char(s[j,i]);
        end;
    end;
   memDecrypt.Lines.Add(cString);
end;
procedure TfrmAES.AddIntEncryptMemo(n:Cardinal);
var
 cString: String;
 hn: TWords;
begin
  cString := '';
  hn := ZerlegeWords(n);
  cString := cString + IntToHex(hn.b0,2) + ' ' +
                       IntToHex(hn.b1,2) + ' ' +
                       IntToHex(hn.b2,2) + ' ' +
                       IntToHex(hn.b3,2);
   memEncrypt.Lines.Add(cString);
end;

end.
