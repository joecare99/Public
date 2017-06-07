unit unt_DataTransform;

{*v 1.50.00}

interface

uses Forms,sysutils;

type TAob = packed array of Byte;
     PAOB = ^Taob;
     TAoBchEvent = Procedure(const Sender:TObject;const OldValue,NewValue:TAoB) of object;
     TCompResult=(cr_Lower,cr_equal,cr_Higher);
     TComparefunc = function(data1,data2:variant):TCompResult ;
     TDataAlign=(DAL_Intel,DAL_Motorola);

const CompareResult:array[TCompResult] of shortint = (-1,0,1);

procedure delay( msec:integer);

function TimeDifferenz(time0,time1:TDateTime):integer;


procedure XChange(var data1,data2:variant);
// tauscht den Inhalt der Variablen Data1, Data2

function min(data1,data2:integer):integer; overload;
function min(data1,data2:variant;CompProc:TComparefunc):variant; overload;
// Liefert das Minimum von Data1 und Data2

function max(data1,data2:integer):integer;overload;
function max(data1,data2:variant;CompProc:TComparefunc):variant;overload;
// Liefert das Maximum von Data1 und Data2

procedure Sort_Bubblesort(var DataArr:array of variant);
// Sortiert ein array

Function set2word(const X):int64;
// wandelt ein set of XXX in ein Bitarray in form eines Words um

Procedure Word2set(var X,data;l:int64);
//wandelt einen Longint

function crc32(crc:cardinal;const buf:paob; len:integer):cardinal;overload;
// function crc32(const data:variant):cardinal;overload;

procedure Makepath(npath:string);
// Erstelle falls nötig den npath

procedure MultiReName(OldName, NewName:string);
// Benenne oder Verschiebe mehrere dateien

//function GetVersion: String;

Function smult(m1, m2:longword):longword;
// Führt eine Multiplikation im dword-Ring aus

Function sPlus(m1, m2:longword):longword;
// Führt eine Multiplikation im dword-Ring aus


const msecperday = 60000*60*24;


implementation

{
Generate a table for a byte-wise 32-bit CRC calculation on the polynomial:
x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x+1.

Polynomials over GF(2) are represented in binary, one bit per coefficient,
with the lowest powers in the most significant bit.  Then adding polynomials
is just exclusive-or, and multiplying a polynomial by x is a right shift by
one.  If we call the above polynomial p, and represent a byte as the
polynomial q, also with the lowest power in the most significant bit (so the
byte 0xb1 is the polynomial x^7+x^3+x+1), then the CRC is (q*x^32) mod p,
where a mod b means the remainder after dividing a by b.

This calculation is done using the shift-register method of multiplying and
taking the remainder.  The register is initialized to zero, and for each
incoming bit, x^32 is added mod p to the register if the bit is a one (where
x^32 mod p is p+x^32 = x^26+...+1), and the register is multiplied mod p by
x (which is shifting right by one and adding x^32 mod p if the bit shifted
out is a one).  We start with the highest power (least significant bit) of
q and repeat for all eight bits of q.

The table is simply the CRC of all possible eight bit values.  This is all
the information needed to generate CRC's on data a byte at a time for all
combinations of CRC register values and incoming bytes.
}
{
Legen Sie eine Tabelle für eine Byte-weise 32-bit zyklische Blockprüfungs
Berechnung auf dem Polynom
x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x+1 fest:.

Polynome über GF(2) werden binär  dargestellt, ein Bit pro Koeffizienten, mit der
niedrigsten Potenz im MSB. Dann ist das Addieren vom Polynomen einfach eine
exklusiv-oder Verknüpfung, und ein Polynom mit x zu multiplizieren ist
ein Rechtsshift um 1. Wenn wir das oben genannte Polynom p nennen und ein
Byte als das Polynom q darstellen, auch mit der niedrigsten Potenz im MSB
(also entspricht das Byte $b1 (10110001) dem Polynom x^7+x^3+x+1), dann ist die
zyklische Blockprüfung (q*x^32) MOD p, in dem ein MOD b den Rest bedeutet,
nachdem es a durch b geteilt hat.

Diese Berechnung erfolgt durch das Verwenden verschieben-registrieren Methode
des Multiplizierens und des Nehmens des Restes. Das Register wir mit null
initialisiert, und für jedes ankommend Bit, x^32 sein hinzufügen MOD p zu d
Register wenn d Bit sein ein ein (wo x^32 MOD p sein p+x^32 = x^26+... +1), und
d Register sein multiplizieren MOD p durch x (welch sein verschieben nach rechts
durch ein und hinzufügen x^32 MOD p wenn d Bit verschieben heraus sein ein
ein). Wir beginnen mit der höchsten Energie (wenig bedeutendes Bit) von q und
wiederholen für alle acht Bits von q.

Die Tabelle ist einfach die zyklische Blockprüfung aller möglichen acht Bitwerte.
Von dieses ist alle Informationen, die benötigt werden, um RCC's auf Daten
hintereinander festzulegen ein Byte für alle Kombinationen zyklische Blockprüfung
Register Werte und ankommende Bytes.



}

{$ifndef DYNAMIC_CRC_TABLE}
const crc_table:array[byte] of cardinal =
 ($00000000, $77073096, $ee0e612c, $990951ba, $076dc419,  $706af48f, $e963a535, $9e6495a3, $0edb8832, $79dcb8a4,
  $e0d5e91e, $97d2d988, $09b64c2b, $7eb17cbd, $e7b82d07,  $90bf1d91, $1db71064, $6ab020f2, $f3b97148, $84be41de,
  $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7, $136c9856,  $646ba8c0, $fd62f97a, $8a65c9ec, $14015c4f, $63066cd9,
  $fa0f3d63, $8d080df5, $3b6e20c8, $4c69105e, $d56041e4,  $a2677172, $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b,
  $35b5a8fa, $42b2986c, $dbbbc9d6, $acbcf940, $32d86ce3,  $45df5c75, $dcd60dcf, $abd13d59, $26d930ac, $51de003a,
  $c8d75180, $bfd06116, $21b4f4b5, $56b3c423, $cfba9599,  $b8bda50f, $2802b89e, $5f058808, $c60cd9b2, $b10be924,
  $2f6f7c87, $58684c11, $c1611dab, $b6662d3d, $76dc4190,  $01db7106, $98d220bc, $efd5102a, $71b18589, $06b6b51f,
  $9fbfe4a5, $e8b8d433, $7807c9a2, $0f00f934, $9609a88e,  $e10e9818, $7f6a0dbb, $086d3d2d, $91646c97, $e6635c01,
  $6b6b51f4, $1c6c6162, $856530d8, $f262004e, $6c0695ed,  $1b01a57b, $8208f4c1, $f50fc457, $65b0d9c6, $12b7e950,
  $8bbeb8ea, $fcb9887c, $62dd1ddf, $15da2d49, $8cd37cf3,  $fbd44c65, $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2,
  $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb, $4369e96a,  $346ed9fc, $ad678846, $da60b8d0, $44042d73, $33031de5,
  $aa0a4c5f, $dd0d7cc9, $5005713c, $270241aa, $be0b1010,  $c90c2086, $5768b525, $206f85b3, $b966d409, $ce61e49f,
  $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4, $59b33d17,  $2eb40d81, $b7bd5c3b, $c0ba6cad, $edb88320, $9abfb3b6,
  $03b6e20c, $74b1d29a, $ead54739, $9dd277af, $04db2615,  $73dc1683, $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8,
  $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1, $f00f9344,  $8708a3d2, $1e01f268, $6906c2fe, $f762575d, $806567cb,
  $196c3671, $6e6b06e7, $fed41b76, $89d32be0, $10da7a5a,  $67dd4acc, $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5,
  $d6d6a3e8, $a1d1937e, $38d8c2c4, $4fdff252, $d1bb67f1,  $a6bc5767, $3fb506dd, $48b2364b, $d80d2bda, $af0a1b4c,
  $36034af6, $41047a60, $df60efc3, $a867df55, $316e8eef,  $4669be79, $cb61b38c, $bc66831a, $256fd2a0, $5268e236,
  $cc0c7795, $bb0b4703, $220216b9, $5505262f, $c5ba3bbe,  $b2bd0b28, $2bb45a92, $5cb36a04, $c2d7ffa7, $b5d0cf31,
  $2cd99e8b, $5bdeae1d, $9b64c2b0, $ec63f226, $756aa39c,  $026d930a, $9c0906a9, $eb0e363f, $72076785, $05005713,
  $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38, $92d28e9b,  $e5d5be0d, $7cdcefb7, $0bdbdf21, $86d3d2d4, $f1d4e242,
  $68ddb3f8, $1fda836e, $81be16cd, $f6b9265b, $6fb077e1,  $18b74777, $88085ae6, $ff0f6a70, $66063bca, $11010b5c,
  $8f659eff, $f862ae69, $616bffd3, $166ccf45, $a00ae278,  $d70dd2ee, $4e048354, $3903b3c2, $a7672661, $d06016f7,
  $4969474d, $3e6e77db, $aed16a4a, $d9d65adc, $40df0b66,  $37d83bf0, $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9,
  $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6, $bad03605,  $cdd70693, $54de5729, $23d967bf, $b3667a2e, $c4614ab8,
  $5d681b02, $2a6f2b94, $b40bbe37, $c30c8ea1, $5a05df1b,  $2d02ef8d);

{$else}
var crc_table:array of cardinal;


var crc_table_empty:boolean;

procedure make_crc_table;

var c : Cardinal;
    n,k: integer;
    poly: cardinal;          // polynomial exclusive-or pattern */

// terms of polynomial defining this crc (except x^32):
const  p:array[0..13] of byte = (0,1,2,4,5,7,8,10,11,12,16,22,23,26);

begin
  // make exclusive-or pattern from polynomial $edb88320 */
  poly := 0;
  for n := 0 to (sizeof(p) div sizeof(Byte))-1 do
      poly := poly or (1 shl (31 - p[n]));

  for n := 0 to  255 do
  begin
    c := n;
    for k := 0 to  7 do
      if (c and 1) = 1 then c := poly xor (c shr 1) else c := (c shr 1);
    crc_table[n] := c;
  end;
  crc_table_empty := false;
end;
{$endif}

function crc32(crc:cardinal;const buf:paob; len:integer):cardinal;

var i:integer;

begin
 if (buf = nil) then crc32:=0
 else
   begin
{$ifdef DYNAMIC_CRC_TABLE}
    if (crc_table_empty)
      make_crc_table();
{$endif}
    crc := crc xor $ffffffff;
    for i :=0 to len-1 do
       crc := crc_table[(crc xor buf^[i]) and $ff] xor (crc shr 8);
    crc32:= crc xor $ffffffff;
  end;
end;



procedure XChange(var data1,data2:variant);
// tauscht den Inhalt der Variablen Data1, Data2

var data3 : Variant;

begin
  data3 := data1;
  data1 := data2;
  data2 := data3;
end;

function min(data1,data2:integer):integer;
// Liefert das Minimum von Data1 und Data2
begin
   if data1 < Data2 then min:= data1 else min :=data2;
end;

function min(data1,data2:variant;CompProc:TComparefunc):variant;
// Liefert das Minimum von Data1 und Data2
var cr:TCompResult;

begin
   if assigned(compProc) then
     begin
       cr:=CompProc(data1, Data2);
       if cr=cr_Lower then min:= data1 else min :=data2
     end
   else
     if data1 < Data2 then min:= data1 else min :=data2;
end;

function max(data1,data2:integer):integer;
// Liefert das Maximum von Data1 und Data2
begin
   if data1 > Data2 then max:= data1 else max :=data2;
end;

function max(data1,data2:variant;CompProc:TComparefunc):variant;
// Liefert das Maximum von Data1 und Data2
begin
   if assigned(compProc) then
     if CompProc(data1, Data2)=cr_Higher then max:= data1 else max :=data2
   else
     if data1 > Data2 then max:= data1 else max :=data2;
end;

procedure Sort_Bubblesort(var DataArr:array of variant);
// Sortiert ein array
// O(x*x);

var i,j :integer;

begin
  for i := low(dataarr) to pred(high(dataarr)) do
     for j :=  pred(high(dataarr)) downto i do
       if dataarr[j] > dataarr[succ(j)] then
         XChange (dataarr[j], dataarr[succ(j)]);
end;
///// -- Laufzeitfunktionen ///////////////////////////////////////////////////

procedure delay( msec:integer);

var Starttime:TDateTime;

begin
  startTime:=Now;
  while TimeDifferenz(StartTime,now) < msec do
    Application.ProcessMessages;
end;

///////////// Zeitfunktionen //////////////////////////////////////////////////

function TimeDifferenz(time0,time1:TDateTime):integer;

var t0,t1,dt:TTimeStamp;

begin
  T0:=DateTimeToTimeStamp(time0);
  T1:=DateTimeToTimeStamp(time1);
  dt.time:=t1.time-t0.time;
  dt.date:=t1.date-t0.date;
  TimeDifferenz := dt.Date * msecperday+dt.time;
end;

procedure Makepath(npath:string);
// Erstelle falls nötig den npath

var CPath:string;
   flag:boolean;

begin
CPath := '';
flag := True;
While (CPath + '\' <> npath) And flag do
  begin
    CPath := copy(npath,1, pos( '\', copy (npath,Length(CPath) + 2,length(npath)))+Length(CPath) + 1);
    flag := FileExists(CPath);
  end;
If Not flag Then
  begin
    MkDir (CPath );
    While (CPath + '\' <> npath) do
      begin
        CPath := copy(npath,1, pos( '\', copy (npath,Length(CPath) + 2,length(npath)))+Length(CPath) + 1);
        MkDir (CPath);
      end;
  End;

end;

// Diese Procedure Hat Die Aufgabe Mehrere Dateien Umzubenennen
procedure MultiReName(OldName, NewName:string);
// benutzt DIR --> unterbricht vorhergehende dir - Abfragen

var OldFName, oFp, oFn, oFe,
        NFp, NFn, NFe:string;
    NFAttr:integer;
    movemode:boolean;
    dimc, I:integer;
    files: array of string;
    sr:TSearchRec;

begin
  If (pos('*',OldName) > 0) Or (pos('?',OldName) > 0) or
     (pos('*',OldName) > 0) or (pos('?',OldName) > 0) Then
      begin
        // Joker-zeichen angegeben --> Multi ren erforderlich
        ofp:=ExtractFilePath (oldname);
        ofn:=ExtractFileName (oldname);
        ofe:=ExtractFileExt (oldname);
        nfp:=ExtractFilePath (newname);
        nfn:=ExtractFileName (newname);
        nfe:=ExtractFileExt (newname);

  if findfirst(OldName, faDirectory,sr) = 0 then OldFName :=sr.Name else oldfname:='';
  dimc := 0;
  While OldFName <> '' do
    begin
     If (OldFName <> '.') And (OldFName <> '..') Then
       dimc := dimc + 1;
      if findnext(sr) = 0 then OldFName :=sr.Name else oldfname:='';

  end; //  wend
  setlength (files, dimc );
  if findfirst(OldName, faDirectory,sr) = 0 then OldFName :=sr.Name else oldfname:='';
  I := 0;
  While OldFName <> '' do
    begin
     If (OldFName <> '.') And (OldFName <> '..') then begin
       files[I] := OldFName;
       I := I + 1;
     end; //  If ...
     if findnext(sr) = 0 then OldFName :=sr.Name else oldfname:='';
  end; //  wend

  // Mylist.Show
  If Not FileExists(NewName) then
    begin
     If NewName[length(newname)] = '\' then begin
       makepath (NewName);
       movemode := True
     end else begin
       movemode := False
     end; //  If ...
   end
  else
   begin
     NFAttr := FileGetAttr (newname);
     movemode := (NFAttr And faDirectory) <> 0;
     If Not movemode Then
       runerror(255);
  end; //  If ...
  If movemode then begin
    If NewName[length(newname)] <> '\' Then
      NewName := NewName + '\';
    For I := low(files) To high(files) do
      ReNamefile (oFp + files[I], NewName + files[I])
  end else begin
    runerror (255);
  end; //  If ...
  end; //  If ...
End;



Function smult(m1, m2:longword):longword;
// Führt eine Multiplikation im dword-Ring aus
var  h,dv : int64;


begin
  dv := int64(longword(-1))+2;
  h := (m1 + 1);
  h := (h * ((m2+1) div 2)) mod dv;
  h := h+ ((h * ((m2+2) div 2)) mod dv);
  h := h mod dv - 1;
  smult := h;
End;

Function splus(m1, m2:longword):longword;
// Führt eine Addition im dword-Ring aus
var  h : int64;


begin
  h := m1;
  h := h + m2;
  h := h and $ffffffff;
  splus := h;
End;


Function set2word(const X):int64;
// wandelt ein set of XXX in ein Bitarray in form eines Words um

var //i :byte;
    flag:word;
begin
  flag := int64(x);
  set2word:=flag;
end;

Procedure Word2set(var X,data;l:int64);
// wandelt ein Word in ein vorgegebenes set of XXX um

begin
  int64(x):=l;
end;

end.
