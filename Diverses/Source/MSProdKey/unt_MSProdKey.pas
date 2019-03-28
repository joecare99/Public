UNIT unt_MSProdKey;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

(* Orginal by
 * Copyright (c) 2017 Donald Smith <qffdn@cock.li>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

(*
Example: output:
$ ./mpkdec QFFDN-GRT3P-VKWWX-X7T3R-8B639
Decoded bytes: c70e30000000ccccff4aa31aca2209
Composite: 000-000003
*)

INTERFACE

USES
  Classes, SysUtils;

CONST
  BINARY_LENGTH = 15;

TYPE
  TBinKey = ARRAY[0..BINARY_LENGTH] OF Byte;

FUNCTION IsNewBinKey(binkey: TBinKey): Boolean;
FUNCTION Crc(CONST buf: TBinKey; len: Integer): Longword;
PROCEDURE Decode(key: String; out binkey: TBinKey);
FUNCTION normalize(key: String): String;
FUNCTION strip(key: String): String;
FUNCTION translatealpha(ch: Char): Byte;
FUNCTION Usage: String;
Function Getcomposite(CONST binkey: TBinkey; out s, c:LOngWord;out v:byte;out z: Longword):String;
function VerifyCrc(CONST binkey: TBinkey;out Theirs,Mine:word):boolean;
PROCEDURE Main;


IMPLEMENTATION

CONST
  crctable (* Table for ISO/IEC 8802-3:1996 aka POSIX 1003.2 cksum *): ARRAY [0..255] OF
    Longword = (
    $00000000,
    $04c11db7, $09823b6e, $0d4326d9, $130476dc, $17c56b6b,
    $1a864db2, $1e475005, $2608edb8, $22c9f00f, $2f8ad6d6,
    $2b4bcb61, $350c9b64, $31cd86d3, $3c8ea00a, $384fbdbd,
    $4c11db70, $48d0c6c7, $4593e01e, $4152fda9, $5f15adac,
    $5bd4b01b, $569796c2, $52568b75, $6a1936c8, $6ed82b7f,
    $639b0da6, $675a1011, $791d4014, $7ddc5da3, $709f7b7a,
    $745e66cd, $9823b6e0, $9ce2ab57, $91a18d8e, $95609039,
    $8b27c03c, $8fe6dd8b, $82a5fb52, $8664e6e5, $be2b5b58,
    $baea46ef, $b7a96036, $b3687d81, $ad2f2d84, $a9ee3033,
    $a4ad16ea, $a06c0b5d, $d4326d90, $d0f37027, $ddb056fe,
    $d9714b49, $c7361b4c, $c3f706fb, $ceb42022, $ca753d95,
    $f23a8028, $f6fb9d9f, $fbb8bb46, $ff79a6f1, $e13ef6f4,
    $e5ffeb43, $e8bccd9a, $ec7dd02d, $34867077, $30476dc0,
    $3d044b19, $39c556ae, $278206ab, $23431b1c, $2e003dc5,
    $2ac12072, $128e9dcf, $164f8078, $1b0ca6a1, $1fcdbb16,
    $018aeb13, $054bf6a4, $0808d07d, $0cc9cdca, $7897ab07,
    $7c56b6b0, $71159069, $75d48dde, $6b93dddb, $6f52c06c,
    $6211e6b5, $66d0fb02, $5e9f46bf, $5a5e5b08, $571d7dd1,
    $53dc6066, $4d9b3063, $495a2dd4, $44190b0d, $40d816ba,
    $aca5c697, $a864db20, $a527fdf9, $a1e6e04e, $bfa1b04b,
    $bb60adfc, $b6238b25, $b2e29692, $8aad2b2f, $8e6c3698,
    $832f1041, $87ee0df6, $99a95df3, $9d684044, $902b669d,
    $94ea7b2a, $e0b41de7, $e4750050, $e9362689, $edf73b3e,
    $f3b06b3b, $f771768c, $fa325055, $fef34de2, $c6bcf05f,
    $c27dede8, $cf3ecb31, $cbffd686, $d5b88683, $d1799b34,
    $dc3abded, $d8fba05a, $690ce0ee, $6dcdfd59, $608edb80,
    $644fc637, $7a089632, $7ec98b85, $738aad5c, $774bb0eb,
    $4f040d56, $4bc510e1, $46863638, $42472b8f, $5c007b8a,
    $58c1663d, $558240e4, $51435d53, $251d3b9e, $21dc2629,
    $2c9f00f0, $285e1d47, $36194d42, $32d850f5, $3f9b762c,
    $3b5a6b9b, $0315d626, $07d4cb91, $0a97ed48, $0e56f0ff,
    $1011a0fa, $14d0bd4d, $19939b94, $1d528623, $f12f560e,
    $f5ee4bb9, $f8ad6d60, $fc6c70d7, $e22b20d2, $e6ea3d65,
    $eba91bbc, $ef68060b, $d727bbb6, $d3e6a601, $dea580d8,
    $da649d6f, $c423cd6a, $c0e2d0dd, $cda1f604, $c960ebb3,
    $bd3e8d7e, $b9ff90c9, $b4bcb610, $b07daba7, $ae3afba2,
    $aafbe615, $a7b8c0cc, $a379dd7b, $9b3660c6, $9ff77d71,
    $92b45ba8, $9675461f, $8832161a, $8cf30bad, $81b02d74,
    $857130c3, $5d8a9099, $594b8d2e, $5408abf7, $50c9b640,
    $4e8ee645, $4a4ffbf2, $470cdd2b, $43cdc09c, $7b827d21,
    $7f436096, $7200464f, $76c15bf8, $68860bfd, $6c47164a,
    $61043093, $65c52d24, $119b4be9, $155a565e, $18197087,
    $1cd86d30, $029f3d35, $065e2082, $0b1d065b, $0fdc1bec,
    $3793a651, $3352bbe6, $3e119d3f, $3ad08088, $2497d08d,
    $2056cd3a, $2d15ebe3, $29d4f654, $c5a92679, $c1683bce,
    $cc2b1d17, $c8ea00a0, $d6ad50a5, $d26c4d12, $df2f6bcb,
    $dbee767c, $e3a1cbc1, $e760d676, $ea23f0af, $eee2ed18,
    $f0a5bd1d, $f464a0aa, $f9278673, $fde69bc4, $89b8fd09,
    $8d79e0be, $803ac667, $84fbdbd0, $9abc8bd5, $9e7d9662,
    $933eb0bb, $97ffad0c, $afb010b1, $ab710d06, $a6322bdf,
    $a2f33668, $bcb4666d, $b8757bda, $b5365d03, $b1f740b4);


FUNCTION IsNewBinKey(binkey: TBinKey): Boolean;
BEGIN
  Result := (binkey[14] and $08) <> 0;
END;

FUNCTION Crc(CONST buf: TBinKey; len: Integer): Longword;
VAR
  i: Integer;

BEGIN
  Result := $FFFFFFFF;
  FOR i := 0 TO len - 1 DO
    Result := (Result shl 8) xor crctable[((Result shr 24) xor (buf[i]) and $ff)];
  Result   := not Result;
END;

PROCEDURE Decode(key: String; out binkey: TBinKey);
(*
 * Decodes a product key into its binary form.
 *
 * This does simple base24 decoding.  If an N is found in the product key, the
 * offset of the N in the product key is used as the first character for
 * decoding.  Multiple instances of N are invalid.
 *)
CONST
  alphabet    = 'BCDFGHJKMPQRTVWXY2346789';
  alphabetlen = length(alphabet);
VAR
  c, i, j: Longword;
  newkeymarker: String;
  pp: SizeInt;
BEGIN
  fillchar(binkey, length(binkey), 0);

  pp := Pos('N', key);
  IF pp <> 0 THEN
  BEGIN
    key := alphabet[pp] + copy(key, 1, pp - 1) + copy(key, pp + 1);
//    Writeln('New Key:', key);
  END;

  FOR i := 1 TO 25 DO
  BEGIN
    c := translatealpha(key[i]);

    (*
     * This code should be equivalent to:
     * accumulator = accumulator * base;
     * accumulator += translated_char;
     *)
    FOR j := 0 TO BINARY_LENGTH DO
    BEGIN
      c += binkey[j] * alphabetlen;
      binkey[j] := c and 255;
      c := c shr 8;
    END;


  END;

  IF pp <> 0 THEN
    binkey[14] := binkey[14] or $08;
END;

FUNCTION normalize(key: String): String;
BEGIN
  Result := Uppercase(strip(key));
END;

FUNCTION strip(key: String): String;
BEGIN
  (*
     * Pre-stripped keys are accepted in case of overly cooperative
     * users, but this not hinted in the error message as an attempt
     * to ensure well-formed input and avoid confusion.
     *)
  IF length(key) = 25 THEN
    exit(key)
  ELSE
  IF (key[6] <> '-') or (key[12] <> '-') or (key[18] <> '-') or
    (key[24] <> '-') THEN
    RAISE(Exception.Create('malformed key (dashes missing or misplaced)'));
  //     else
  Result := copy(key, 1, 29);
  Delete(Result, 24, 1);
  Delete(Result, 18, 1);
  Delete(Result, 12, 1);
  Delete(Result, 6, 1);
END;

FUNCTION TranslateAlpha(ch: Char): Byte;
CONST
  cTrans = 'BCDFGHJKMPQRTVWXY2346789';
VAR
  pp: SizeInt;
BEGIN
  pp := pos(ch, cTrans);
  IF pp <> 0 THEN
    Result := pp - 1
  ELSE
    RAISE(Exception.Create(format('Illegal Character "%s"', [ch])));
END;

FUNCTION Usage: String;
(*
 * Prints usage for this program.
 *)
BEGIN
  Result := 'usage: ' + ParamStr(0) + ' productkey';
END;

PROCEDURE printcomposite(CONST binkey: TBinkey);
VAR
  c: Longword;
  s: Longword;
  z:LongWord;
  v: Byte;
BEGIN

  writeln(Getcomposite(binkey,s,c,v,z));
END;

function Getcomposite(const binkey: TBinkey; out s, c:LOngWord;out v:byte;out z: Longword): String;
begin
    s := ((binkey[2] and $f) shl 16) or (binkey[1] shl 8) or binkey[0];
  c := (((binkey[5] shl 24) or (binkey[4] shl 16) or
    (binkey[3] shl 8) or binkey[2]) shr 4) and $3fffffff;
  v := binkey[2] and $f;
  Z := ((binkey[6] ) shl 16) or (binkey[7] shl 8) or binkey[8];
  result := format('Composite: %5.5d %3.3d-%6.6d %2.2d',
    [s, c div 1000000, c mod 1000000, v, z])
end;

function VerifyCrc(CONST binkey: TBinkey;out theirs,Mine:word):Boolean;
VAR
  clamped:      TBinKey;

BEGIN
  move(binkey, clamped, length(binkey));
  clamped[12] := clamped[12] and $7f;
  clamped[13] := 0;
  clamped[14] := clamped[14] and $06;
  (* Microsoft's checksum algorithm expects an extraneous 0 byte *)
  clamped[15] := 0;

  theirs := ((((binkey[14] shl 16) or (binkey[13] shl 8) or (binkey[12]))) shr
    7) and $3ff;
  mine   := crc(clamped, sizeof(clamped)) and $3ff;

  result:= mine = theirs;
END;

PROCEDURE Main;
VAR
  key:    String;
  binkey: TBinKey;
  i:      Integer;
  t, m: word;
BEGIN
  IF ParamCount = 0 THEN
    writeln(Usage)
  ELSE
  BEGIN
    key := ParamStr(1);
    key := normalize(key);
    decode(key, binkey);

    Write('Decoded bytes: ');
    FOR i := 0 TO BINARY_LENGTH - 1 DO
      Write(inttohex(binkey[i], 2) + ' ');
    writeln;

    IF (ISNEWBINKEY(binkey)) THEN
    BEGIN
      if not verifycrc(binkey,t,m) then
            writeln(format('CRC mismatch (calculated: %.4u, in key: %.4u)',
      [m, t]));


      printcomposite(binkey);
    END;

  END;
END;

END.

(*
  mpkdec decodes Microsoft product keys into their binary form and prints the
  decoded binary key as hexadecimal.

  Keys used in newer versions of Windows starting with Windows 8, i.e. those
  containing an N anywhere in them, will also have their built-in checksum
  verified.  An error is printed to stderr if the checksum mismatches.

  The output for keys in the era of Windows Vista and 7 will be garbage.  This
  is because the keys have additional obfuscation.

  It will read and display the composite number for keys containing an N.
  This is not possible for older keys because the composite position varies
  wildly.
 *)



