unit Unt_CalcSHA;

interface

function SHA1(Msg: String): String;
function SHA224(Msg: String): String;
function SHA256(Msg: String): String;

implementation

{
  // Beachte: Alle Variablen sind vorzeichenlose 32-Bit-Werte und
  // verhalten sich bei Berechnungen kongruent (?) modulo 2^32

  // Initialisiere die Variablen:
  var int h0 := 0x67452301
  var int h1 := 0xEFCDAB89
  var int h2 := 0x98BADCFE
  var int h3 := 0x10325476
  var int h4 := 0xC3D2E1F0

  // Vorbereitung der Nachricht 'message':
  var int message_laenge := bit_length(message)
  erweitere message um bit "1"
  erweitere message um bits "0" bis Länge von message in bits ? 448 (mod 512)
  erweitere message um message_laenge als 64-Bit big-endian Integer

  // Verarbeite die Nachricht in aufeinander folgenden 512-Bit-Blöcken:
  für alle 512-Bit Block von message
  unterteile Block in 16 32-bit big-endian Worte w(i), 0 ? i ? 15

  // erweitere die 16 32-bit-Worte auf 80 32-bit-Worte:
  für alle i von 16 bis 79
  w(i) := (w(i-3) xor w(i-8) xor w(i-14) xor w(i-16)) leftrotate 1

  // Initialisiere den Hash-Wert für diesen Block:
  var int a := h0
  var int b := h1
  var int c := h2
  var int d := h3
  var int e := h4

  // Hauptschleife:
  für alle i von 0 bis 79
  wenn 0 ? i ? 19 dann
  f := (b and c) or ((not b) and d)
  k := 0x5A827999
  sonst wenn 20 ? i ? 39 dann
  f := b xor c xor d
  k := 0x6ED9EBA1
  sonst wenn 40 ? i ? 59 dann
  f := (b and c) or (b and d) or (c and d)
  k := 0x8F1BBCDC
  sonst wenn 60 ? i ? 79  dann
  f := b xor c xor d
  k := 0xCA62C1D6
  wenn_ende

  temp := (a leftrotate 5) + f + e + k + w(i)
  e := d
  d := c
  c := b leftrotate 30
  b := a
  a := temp

  // Addiere den Hash-Wert des Blocks zur Summe der vorherigen Hashes:
  h0 := h0 + a
  h1 := h1 + b
  h2 := h2 + c
  h3 := h3 + d
  h4 := h4 + e

  digest = hash = h0 append h1 append h2 append h3 append h4 //(Darstellung als big-endian)
  Beachte: Anstatt der Original-Formulierung aus dem FIPS PUB 180-1 können alternativ auch folgende Formulierungen verwendet werden:

  (0  ? i ? 19): f := d xor (b and (c xor d))         (Alternative)

  (40 ? i ? 59): f := (b and c) or (d and (b or c))   (Alternative 1)
  (40 ? i ? 59): f := (b and c) or (d and (b xor c))  (Alternative 2)
  (40 ? i ? 59): f := (b and c) + (d and (b xor c))   (Alternative 3)
}

Type
  tMsgWords = array of Cardinal;

Function bit_Length(Msg: String): int64;

begin
  result := Length(Msg) * 8 * sizeof(char);
end;

Function GetMsgBlock(Msg: String; BlockNo, ByteCount: integer): tMsgWords;

begin
Setlength(result,16);
  if ByteCount >= sizeof(result) then
    move(Msg[1 + (BlockNo div sizeof(char)) * sizeof(result)], result, sizeof
        (result))
  else
  begin
    fillchar(result, sizeof(result), 0);
    if ByteCount > 0 then
      move(Msg[1 + (BlockNo div sizeof(char)) * sizeof(result)], result,
        ByteCount);
    result[ByteCount div 4] := result[ByteCount div 4] or
      ($80 shl (ByteCount mod 4) * 8);
  end;
end;

function SHA1(Msg: String): String;

const
  H: array [0 .. 4] of Cardinal = ($67452301, $EFCDAB89, $98BADCFE, $10325476,
    $C3D2E1F0);

var
  message_laenge: int64;
  I,J: integer;
  w: tMsgWords ;

function LeftRot1(x:cardinal):cardinal;assembler;

asm
  ror eax,1
end;

begin
  // Beachte: Alle Variablen sind vorzeichenlose 32-Bit-Werte und
  // verhalten sich bei Berechnungen kongruent (?) modulo 2^32

  // Initialisiere die Variablen:

  // Vorbereitung der Nachricht 'message':
  message_laenge := bit_Length(Msg);

  // Verarbeite die Nachricht in aufeinander folgenden 512-Bit-Blöcken:
  for I := 0 to (message_laenge + 448) div 512 do
  begin
//      für alle 512-Bit Block von Msg
//      unterteile Block in 16 32-bit big-endian Worte w(i), 0 ? i ? 15
  //
   w := GetMsgBlock(Msg, (message_laenge - I * 512) div 8,64);

   Setlength(w,80);
      // erweitere die 16 32-bit-Worte auf 80 32-bit-Worte:
      for J := 16 to 79 do

      w[i] := (w[(i-3)] xor w[(i-8)] xor w[(i-14)] xor w[(i-16)]);
      w[i] := (w[i] shl 1) or (w[i] shl 1 );


    {


      // Initialisiere den Hash-Wert für diesen Block:
      var int a := h0
      var int b := h1
      var int c := h2
      var int d := h3
      var int e := h4

      // Hauptschleife:
      für alle i von 0 bis 79
      wenn 0 <= i <= 19 dann
      f := (b and c) or ((not b) and d)
      k := 0x5A827999
      sonst wenn 20 <= i <= 39 dann
      f := b xor c xor d
      k := 0x6ED9EBA1
      sonst wenn 40 <= i <= 59 dann
      f := (b and c) or (b and d) or (c and d)
      k := 0x8F1BBCDC
      sonst wenn 60 <= i <= 79  dann
      f := b xor c xor d
      k := 0xCA62C1D6
      wenn_ende

      temp := (a leftrotate 5) + f + e + k + w(i)
      e := d
      d := c
      c := b leftrotate 30
      b := a
      a := temp

      // Addiere den Hash-Wert des Blocks zur Summe der vorherigen Hashes:
      h0 := h0 + a
      h1 := h1 + b
      h2 := h2 + c
      h3 := h3 + d
      h4 := h4 + e
      }
  end;
end;

function SHA224(Msg: String): String;

begin

end;

function SHA256(Msg: String): String;

begin

end;

end.
