Unit Unt_Allgfunklib;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

{ *V 2.02.00 }
{ *H 2.01.00 IndexOfMax }
{ *H 2.00.05 Erweitere Zweihoch bis 2^31 }
{ *H 2.00.04 Aob2String }
{ *H 2.00.03 Multirename 6 Makepath -> Fileprocs }
{ *H 2.00.02 XBool2Byte Consts }
{ *H 2.00.01 CRC64 }
{ *H 2.00.00 Search }
{ *h 1.50.01 Clear interface from uses ...
  Move makedir & Multirename to Unt_FileProcs
  Zweihoch &  Bool2Byte }
{ *h 1.50.00 Uses Windows in implementation }
Interface

Type
  TAob = Packed Array Of Byte;
  PAOB = ^TAob;
  /// <author>Rosewich</author>
  /// <version>2.01.00</version>
  /// <stereotype>Event</stereotype>
  TAoBchEvent = Procedure(Const Sender: TObject; Const OldValue, NewValue: TAob)
    Of Object;

  /// <author>Rosewich</author>
  /// <version>2.01.00</version>
  TCompResult = (cr_Lower = -1, cr_equal = 0, cr_Higher = 1);
  /// <author>Rosewich</author>
  /// <version>2.01.00</version>
  TComparefunc = Function(data1, data2: variant): TCompResult;

  /// <author>Rosewich</author>
  /// <version>2.01.00</version>
  TDataAlign = (DAL_Intel, DAL_Motorola);

Const
  /// <author>Rosewich</author>
  CompareResult: Array [TCompResult] Of shortint = (-1, 0, 1);
  /// <author>Rosewich</author>
  Zweihoch: Array [0 .. 31] Of longword = ($1, $2, $4, $8, $10, $20, $40, $80,
    $100, $200, $400, $800, $1000, $2000, $4000, $8000, $10000, $20000, $40000,
    $80000, $100000, $200000, $400000, $800000, $1000000, $2000000, $4000000,
    $8000000, $10000000, $20000000, $40000000, $80000000);
  /// <author>Rosewich</author>
  Bool2Str: Array [boolean] Of String = ('False', 'True');
  /// <author>Rosewich</author>
  // Boolean nach Byte-Konvertierung False->0 True->1
  Bool2byte: Array [boolean] Of Byte = (0, 1);
  /// <author>Rosewich</author>
  // Doppel-Boolean nach Byte-Konvertierung  result =[0..3]
  DBool2byte: Array [boolean, boolean] Of Byte = ((0, 1), (2, 3));
  /// <author>Rosewich</author>
  // Trippel-Boolean nach Byte-Konvertierung  result =[0..7]
  TBool2byte: Array [boolean, boolean, boolean] Of Byte = (((0, 1), (2, 3)),
    ((4, 5), (6, 7)));

  /// <author>Rosewich</author>
Procedure delay(msec: integer);

/// <author>Rosewich</author>
Function TimeDifferenz(time0, time1: TDateTime): integer;

/// <author>Rosewich</author>
// <description> tauscht den Inhalt der Variablen Data1, Data2 </description>
Procedure XChange(Var data1, data2: variant);

/// <author>Rosewich</author>
/// <description> tauscht die Byte-Order In der Variablen Data1</description>
/// <output>Byte-Order-gedrehter Wert</output>
Function lsbxmsb(data1: integer): integer; Overload;

/// <author>Rosewich</author>
/// <description> Liefert das Minimum von Data1 und Data2 </description>
/// <output>Minimum von Data1 und Data2</output>
Function min(data1, data2: integer): integer; overload;

/// <author>Rosewich</author>
/// <description> Liefert das Minimum von Data1 und Data2 </description>
/// <output>Minimum von Data1 und Data2</output>
Function min(data1, data2: variant; CompProc: TComparefunc): variant; overload;

/// <author>Rosewich</author>
/// <description> Liefert das Maximum von Data1 und Data2  </description>
/// <output>Maximum von Data1 und Data2</output>
Function max(data1, data2: integer): integer; overload;

/// <author>Rosewich</author>
/// <description> Liefert das Maximum von Data1 und Data2  </description>
/// <output>Maximum von Data1 und Data2</output>
Function max(data1, data2: variant; CompProc: TComparefunc): variant; overload;
/// <author>Rosewich</author>
/// <description> Sortiert ein array  </description>
/// <preconditions>Unsortiertes Feld</preconditions>
/// <postconditions>Sortiertes Feld</postconditions>
Procedure Sort_Bubblesort(Var DataArr: variant);

/// <author>Rosewich</author>
/// <description> wandelt ein set of XXX in ein Bitarray in form eines Words um  </description>
Function set2word(Const X): int64;

/// <author>Rosewich</author>
Procedure Word2set(Var X; l: int64);
// wandelt einen Longint

/// <author>Rosewich</author>
Function crc32(crc: cardinal; Const buf: TAob; len: integer = -1;
  start: integer = 0): cardinal; overload;
/// <author>Rosewich</author>
Function crc32(crc: cardinal; Const buf: String; len: integer = -1;
  start: integer = 1): cardinal; overload;
// function crc32(const data:variant):cardinal;overload;

/// <author>Rosewich</author>
Function crc64(crc: uint64; Const buf: TAob; len: integer = -1;
  start: integer = 0): uint64; overload;
/// <author>Rosewich</author>
/// <description> Berechnet einen CRC64 aus 'Buf' </description>
Function crc64(crc: uint64; Const buf: String; len: integer = -1;
  start: integer = 1): uint64; overload;

/// <author>Rosewich</author>
/// <description> Durchsucht ein TAoB Buf nach einer Kennung src </description>
/// <output>Startposition des gesuchten 'Src'</output>
/// <input>Src: Die Suchkennung; Buf: das zu durchsuchende Feld; die Größe; und die Startposition</input>
Function search(src: Array Of Byte; Const buf: TAob; size: integer;
  start: integer = 0): integer;

/// <author>Rosewich</author>
/// <description>Stellt ein Array of Byte  in Hex-Editor -Schreibweise Dar</description>
Function AoB2String(aob: TAob): String;

/// <author>Rosewich</author>
/// <description>Führt eine Multiplikation im dword-Ring aus</description>
Function smult(m1, m2: longword): longword; overload;

// ToDo -oRosewich: Function smult64(m1, m2:Int64):int64;
/// <description>Führt eine Multiplikation im int64-Ring aus</description>

/// <author>Rosewich</author>
/// <description>Führt eine Addition im dword-Ring aus</description>
Function sPlus(m1, m2: longword): longword;

/// <description>Führt eine Addition im int64-Ring aus</description>
// ToDo -oRosewich: Function sPlus64(m1, m2:int64):int64;

/// <author>Rosewich</author>
/// <description>Sucht den index des Eintrags mit dem hoechsten Wert</description>
Function IndexOfMax(Const param: Array Of integer): integer;
/// <author>Rosewich</author>
/// <description>Sucht den index des Eintrags mit dem hoechsten Wert</description>
Function IndexOfMaxExt(Const param: Array Of extended): integer;

Const
  /// <author>Rosewich</author>
  msecperday = 60000 * 60 * 24; // ~ 86400000

Var
  /// <author>Rosewich</author>
  crc64_table: Array [Byte] Of int64;
  /// <author>Rosewich</author>
  crc64_table_empty: boolean;

  /// <author>Rosewich</author>
Procedure make_crc64_table;

{$IFDEF DYNAMIC_CRC_TABLE}

Var
  /// <author>Rosewich</author>
  crc_table: Array Of cardinal;
  /// <author>Rosewich</author>
  crc_table_empty: boolean;

{$ELSE}

/// <author>Rosewich</author>
const
  crc_table_empty = true;
{$ENDIF}
  /// <author>Rosewich</author>
Procedure make_crc_table;
/// <author>Rosewich</author>
Function Get_crc_table(i: Byte): cardinal;

Implementation

Uses
{$IFNDEF FPC}
  // windows,
  Forms,
{$ENDIF}
  variants,
  sysutils;

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

{$IFNDEF DYNAMIC_CRC_TABLE}

Const
  crc_table: Array [Byte] Of cardinal = ($00000000, $77073096, $EE0E612C,
    $990951BA, $076DC419, $706AF48F, $E963A535, $9E6495A3, $0EDB8832, $79DCB8A4,
    $E0D5E91E, $97D2D988, $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91, $1DB71064,
    $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63,
    $8D080DF5, $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447,
    $D20D85FD, $A50AB56B, $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3,
    $45DF5C75, $DCD60DCF, $ABD13D59, $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F, $2802B89E, $5F058808, $C60CD9B2,
    $B10BE924, $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D, $76DC4190, $01DB7106,
    $98D220BC, $EFD5102A, $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433, $7807C9A2,
    $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1,
    $F50FC457, $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49,
    $8CD37CF3, $FBD44C65, $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541,
    $3DD895D7, $A4D1C46D, $D3D6F4FB, $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
    $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9, $5005713C, $270241AA, $BE0B1010,
    $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F, $5EDEF90E, $29D9C998,
    $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD, $EDB88320,
    $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D, $0A00AE27,
    $7D079EB1, $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB,
    $196C3671, $6E6B06E7, $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F,
    $8EBEEFF9, $17B7BE43, $60B08ED5, $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
    $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B, $D80D2BDA, $AF0A1B4C, $36034AF6,
    $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79, $CB61B38C, $BC66831A,
    $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F, $C5BA3BBE,
    $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $026D930A, $9C0906A9, $EB0E363F, $72076785,
    $05005713, $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38, $92D28E9B, $E5D5BE0D,
    $7CDCEFB7, $0BDBDF21, $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD,
    $F6B9265B, $6FB077E1, $18B74777, $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45, $A00AE278, $D70DD2EE, $4E048354,
    $3903B3C2, $A7672661, $D06016F7, $4969474D, $3E6E77DB, $AED16A4A, $D9D65ADC,
    $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9, $BDBDF21C,
    $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B,
    $2D02EF8D);

  { CRC64_Table:array[byte] of int64 =
    ($0000000000000000, $6C0E612D22814492, $D81CC25A45028924, $B412A3776783CDB6,
    $06DB88321A411009, $6AD5E91F38C0549B, $DEC74A685F43992D, $B2C92B457DC2DDBF,
    $0DB7106434822012, $61B9714916036480, $D5ABD23E7180A936, $B9A5B3135301EDA4,
    $0B6C98562EC3301B, $6762F97B0C427489, $D3705A0C6BC1B93F, $BF7E3B214940FDAD,
    $1B6E20C869044024, $776041E54B8504B6, $C372E2922C06C900, $AF7C83BF0E878D92,
    $1DB5A8FA7345502D, $71BBC9D751C414BF, $C5A96AA03647D909, $A9A70B8D14C69D9B,
    $16D930AC5D866036, $7AD751817F0724A4, $CEC5F2F61884E912, $A2CB93DB3A05AD80,
    $1002B89E47C7703F, $7C0CD9B3654634AD, $C81E7AC402C5F91B, $A4101BE92044BD89,
    $36DC4190D2088048, $5AD220BDF089C4DA, $EEC083CA970A096C, $82CEE2E7B58B4DFE,
    $3007C9A2C8499041, $5C09A88FEAC8D4D3, $E81B0BF88D4B1965, $84156AD5AFCA5DF7,
    $3B6B51F4E68AA05A, $576530D9C40BE4C8, $E37793AEA388297E, $8F79F28381096DEC,
    $3DB0D9C6FCCBB053, $51BEB8EBDE4AF4C1, $E5AC1B9CB9C93977, $89A27AB19B487DE5,
    $2DB26158BB0CC06C, $41BC0075998D84FE, $F5AEA302FE0E4948, $99A0C22FDC8F0DDA,
    $2B69E96AA14DD065, $4767884783CC94F7, $F3752B30E44F5941, $9F7B4A1DC6CE1DD3,
    $2005713C8F8EE07E, $4C0B1011AD0FA4EC, $F819B366CA8C695A, $9417D24BE80D2DC8,
    $26DEF90E95CFF077, $4AD09823B74EB4E5, $FEC23B54D0CD7953, $92CC5A79F24C3DC1,
    $6DB88321A4110090, $01B6E20C86904402, $B5A4417BE11389B4, $D9AA2056C392CD26,
    $6B630B13BE501099, $076D6A3E9CD1540B, $B37FC949FB5299BD, $DF71A864D9D3DD2F,
    $600F934590932082, $0C01F268B2126410, $B813511FD591A9A6, $D41D3032F710ED34,
    $66D41B778AD2308B, $0ADA7A5AA8537419, $BEC8D92DCFD0B9AF, $D2C6B800ED51FD3D,
    $76D6A3E9CD1540B4, $1AD8C2C4EF940426, $AECA61B38817C990, $C2C4009EAA968D02,
    $700D2BDBD75450BD, $1C034AF6F5D5142F, $A811E9819256D999, $C41F88ACB0D79D0B,
    $7B61B38DF99760A6, $176FD2A0DB162434, $A37D71D7BC95E982, $CF7310FA9E14AD10,
    $7DBA3BBFE3D670AF, $11B45A92C157343D, $A5A6F9E5A6D4F98B, $C9A898C88455BD19,
    $5B64C2B1761980D8, $376AA39C5498C44A, $837800EB331B09FC, $EF7661C6119A4D6E,
    $5DBF4A836C5890D1, $31B12BAE4ED9D443, $85A388D9295A19F5, $E9ADE9F40BDB5D67,
    $56D3D2D5429BA0CA, $3ADDB3F8601AE458, $8ECF108F079929EE, $E2C171A225186D7C,
    $50085AE758DAB0C3, $3C063BCA7A5BF451, $881498BD1DD839E7, $E41AF9903F597D75,
    $400AE2791F1DC0FC, $2C0483543D9C846E, $981620235A1F49D8, $F418410E789E0D4A,
    $46D16A4B055CD0F5, $2ADF0B6627DD9467, $9ECDA811405E59D1, $F2C3C93C62DF1D43,
    $4DBDF21D2B9FE0EE, $21B39330091EA47C, $95A130476E9D69CA, $F9AF516A4C1C2D58,
    $4B667A2F31DEF0E7, $27681B02135FB475, $937AB87574DC79C3, $FF74D958565D3D51,
    $DB71064348220120, $B77F676E6AA345B2, $036DC4190D208804, $6F63A5342FA1CC96,
    $DDAA8E7152631129, $B1A4EF5C70E255BB, $05B64C2B1761980D, $69B82D0635E0DC9F,
    $D6C616277CA02132, $BAC8770A5E2165A0, $0EDAD47D39A2A816, $62D4B5501B23EC84,
    $D01D9E1566E1313B, $BC13FF38446075A9, $08015C4F23E3B81F, $640F3D620162FC8D,
    $C01F268B21264104, $AC1147A603A70596, $1803E4D16424C820, $740D85FC46A58CB2,
    $C6C4AEB93B67510D, $AACACF9419E6159F, $1ED86CE37E65D829, $72D60DCE5CE49CBB,
    $CDA836EF15A46116, $A1A657C237252584, $15B4F4B550A6E832, $79BA95987227ACA0,
    $CB73BEDD0FE5711F, $A77DDFF02D64358D, $136F7C874AE7F83B, $7F611DAA6866BCA9,
    $EDAD47D39A2A8168, $81A326FEB8ABC5FA, $35B18589DF28084C, $59BFE4A4FDA94CDE,
    $EB76CFE1806B9161, $8778AECCA2EAD5F3, $336A0DBBC5691845, $5F646C96E7E85CD7,
    $E01A57B7AEA8A17A, $8C14369A8C29E5E8, $380695EDEBAA285E, $5408F4C0C92B6CCC,
    $E6C1DF85B4E9B173, $8ACFBEA89668F5E1, $3EDD1DDFF1EB3857, $52D37CF2D36A7CC5,
    $F6C3671BF32EC14C, $9ACD0636D1AF85DE, $2EDFA541B62C4868, $42D1C46C94AD0CFA,
    $F018EF29E96FD145, $9C168E04CBEE95D7, $28042D73AC6D5861, $440A4C5E8EEC1CF3,
    $FB74777FC7ACE15E, $977A1652E52DA5CC, $2368B52582AE687A, $4F66D408A02F2CE8,
    $FDAFFF4DDDEDF157, $91A19E60FF6CB5C5, $25B33D1798EF7873, $49BD5C3ABA6E3CE1,
    $B6C98562EC3301B0, $DAC7E44FCEB24522, $6ED54738A9318894, $02DB26158BB0CC06,
    $B0120D50F67211B9, $DC1C6C7DD4F3552B, $680ECF0AB370989D, $0400AE2791F1DC0F,
    $BB7E9506D8B121A2, $D770F42BFA306530, $6362575C9DB3A886, $0F6C3671BF32EC14,
    $BDA51D34C2F031AB, $D1AB7C19E0717539, $65B9DF6E87F2B88F, $09B7BE43A573FC1D,
    $ADA7A5AA85374194, $C1A9C487A7B60506, $75BB67F0C035C8B0, $19B506DDE2B48C22,
    $AB7C2D989F76519D, $C7724CB5BDF7150F, $7360EFC2DA74D8B9, $1F6E8EEFF8F59C2B,
    $A010B5CEB1B56186, $CC1ED4E393342514, $780C7794F4B7E8A2, $140216B9D636AC30,
    $A6CB3DFCABF4718F, $CAC55CD18975351D, $7ED7FFA6EEF6F8AB, $12D99E8BCC77BC39,
    $8015C4F23E3B81F8, $EC1BA5DF1CBAC56A, $580906A87B3908DC, $3407678559B84C4E,
    $86CE4CC0247A91F1, $EAC02DED06FBD563, $5ED28E9A617818D5, $32DCEFB743F95C47,
    $8DA2D4960AB9A1EA, $E1ACB5BB2838E578, $55BE16CC4FBB28CE, $39B077E16D3A6C5C,
    $8B795CA410F8B1E3, $E7773D893279F571, $53659EFE55FA38C7, $3F6BFFD3777B7C55,
    $9B7BE43A573FC1DC, $F775851775BE854E, $43672660123D48F8, $2F69474D30BC0C6A,
    $9DA06C084D7ED1D5, $F1AE0D256FFF9547, $45BCAE52087C58F1, $29B2CF7F2AFD1C63,
    $96CCF45E63BDE1CE, $FAC29573413CA55C, $4ED0360426BF68EA, $22DE5729043E2C78,
    $90177C6C79FCF1C7, $FC191D415B7DB555, $480BBE363CFE78E3, $2405DF1B1E7F3C71);
  }
Procedure make_crc_table;

begin
  // Do nothing;
end;
{$ELSE}

Procedure make_crc_table;

Var
  c: cardinal;
  n, k: integer;
  poly: cardinal; // polynomial exclusive-or pattern */

  // terms of polynomial defining this crc (except x^32):
Const
  p: Set Of Byte = [0, 1, 2, 4, 5, 7, 8, 10, 11, 12, 16, 22, 23, 26];
  // 3   6   9     13,14,15
Begin
  // make exclusive-or pattern from polynomial $edb88320 */
  poly := 0;
  For n In p Do
    poly := poly Or (1 Shl (31 - n));

  For n := 0 To 255 Do
  Begin
    c := n;
    For k := 0 To 7 Do
      If (c And 1) = 1 Then
        c := poly Xor (c Shr 1)
      Else
        c := (c Shr 1);
    crc_table[n] := c;
  End;
  crc_table_empty := false;
End;
{$ENDIF}

Procedure make_crc64_table;

Var
  c: cardinal;
  n, k: integer;
  poly: int64; // polynomial exclusive-or pattern */

  // terms of polynomial defining this crc (except x^32):

Const
  p: Set Of Byte = [0, 1, 2, 4, 5, 7, 8, 10, 11, 12, 16, 22, 23, 26,
  // 3   6   9     13,14,15
  31, 32, 34, 37, 43, 47, 56, 59];
Begin
  // make exclusive-or pattern from polynomial $edcb a988 6543 2110 */
  poly := 0;
{$IFDEF FPC}
  For n := 0 to 63 Do
    if n in p then
{$ELSE}
  For n In p Do
{$ENDIF}
    poly := poly Or (uint64(1) Shl (64 - n));

  For n := 0 To 255 Do
  Begin
    c := n;
    For k := 0 To 7 Do
      If (c And 1) = 1 Then
        c := poly Xor (c Shr 1)
      Else
        c := (c Shr 1);
    crc64_table[n] := c;
  End;
  crc64_table_empty := false;
End;

Function crc32(crc: cardinal; Const buf: String; len, start: integer)
  : cardinal; overload;

Var
  i: integer;

Begin
  If (buf = '') Then
    result := 0
  Else
  Begin
{$IFDEF DYNAMIC_CRC_TABLE}
    If (crc_table_empty) Then
      make_crc_table;
{$ENDIF}
    If len = -1 Then
      len := length(buf) + 2 - start;

    crc := crc Xor $FFFFFFFF;
    For i := start To start + len - 1 Do
      crc := crc_table[(crc Xor ord(buf[i])) And $FF] Xor (crc Shr 8);
    result := crc Xor $FFFFFFFF;
  End;
End;

Function crc64(crc: uint64; Const buf: String; len, start: integer)
  : uint64; overload;

Var
  i: integer;

Begin
  If (buf = '') Then
    result := 0
  Else
  Begin
    If (crc64_table_empty) Then
      make_crc64_table;
    If len = -1 Then
      len := length(buf) + 2 - start;

    crc := crc Xor int64(-1);
    For i := start To start + len - 1 Do
      crc := crc64_table[(crc Xor ord(buf[i])) And $FF] Xor (crc Shr 8);
    result := crc Xor int64(-1);
  End;
End;

Function crc32(crc: cardinal; Const buf: TAob; len, start: integer): cardinal;

Var
  i: integer;

Begin
  If (buf = Nil) Then
    crc32 := 0
  Else
  Begin
{$IFDEF DYNAMIC_CRC_TABLE}
    If (crc_table_empty) Then
      make_crc_table;
{$ENDIF}
    If len = -1 Then
      len := vararrayhighbound(buf, 1) + 1 - start;

    crc := crc Xor $FFFFFFFF;
    For i := start To start + len - 1 Do
      crc := crc_table[(crc Xor buf[i]) And $FF] Xor (crc Shr 8);
    result := crc Xor $FFFFFFFF;
  End;
End;

Function crc64(crc: uint64; Const buf: TAob; len, start: integer)
  : uint64; overload;

Var
  i: integer;

Begin
  If (buf = Nil) Then
    result := 0
  Else
  Begin
    If (crc64_table_empty) Then
      make_crc64_table;
    If len = -1 Then
      len := vararrayhighbound(buf, 1) + 1 - start;

    crc := crc Xor int64(-1);
    For i := start To start + len - 1 Do
      crc := crc64_table[(crc Xor buf[i]) And $FF] Xor (crc Shr 8);
    result := crc Xor int64(-1);
  End;
End;

Function Get_crc_table;

begin
  result := crc_table[i];
end;

Function search(src: Array Of Byte; Const buf: TAob; size: integer;
  start: integer = 0): integer;

Var
  i, j: integer;

Begin
  i := start;
  j := 0;
  result := -1;
  While (i < size - high(src)) And (j <= high(src)) Do
  Begin
    j := 0;
    While j <= high(src) Do
      If src[j] = buf[i + j] Then
        inc(j)
      Else
        break;
    If j <= high(src) Then
      inc(i)
    Else
      result := i;
  End
End;

Function AoB2String(aob: TAob): String;
Var
  i: integer;
  klartext: String;

Const
  vbTab = #9;
  vbNewLine = #13#10;

  Function replicate(st: String; anz: integer): String;
  Var
    i: integer;
  Begin
    result := '';
    For i := 0 To anz - 1 Do
      result := result + st;
  End;

Begin
  result := '';
  klartext := '';
  For i := low(aob) To high(aob) Do
  Begin
    If i Mod 16 = 0 Then
    Begin
      result := result + inttohex(i, 4) + ':' + vbTab;
    End;
    result := result + inttohex(aob[i], 2) + ' ';
    If aob[i] In [32 .. 126] Then
      klartext := klartext + chr(aob[i])
    Else
      klartext := klartext + '·';
    If i Mod 16 = 7 Then
      result := result + ':' + vbTab;
    If i Mod 16 = 15 Then
    Begin
      result := result + vbTab + klartext + vbNewLine;
      klartext := '';
    End;
  End;
  If klartext <> '' Then
    result := result + replicate('   ', 16 - length(klartext)) + vbTab +
      klartext + vbNewLine;
End;

Procedure XChange(Var data1, data2: variant);
// tauscht den Inhalt der Variablen Data1, Data2

Var
  data3: variant;

Begin
  data3 := data1;
  data1 := data2;
  data2 := data3;
End;

{$IFDEF FPC}

function hiword(i: integer): Word; inline;
begin
  result := (i and $FFFF0000) shr 16;
end;

function Loword(i: integer): Word; inline;
begin
  result := (i and $FFFF);
end;
{$ENDIF}

Function lsbxmsb(data1: integer): integer;  overload;

type
  tt = record
    case integer of
      0:
        (i: integer);
      1:
        (Loword, highword: Word);
      2:
        (b1, b2, b3, b4: Byte);
  end;

Begin
  with tt(result) do
  begin
    b1 := tt(data1).b4;
    b2 := tt(data1).b3;
    b3 := tt(data1).b2;
    b4 := tt(data1).b1;
  end;
End;

Function min(data1, data2: integer): integer;
// Liefert das Minimum von Data1 und Data2
Begin
  If data1 < data2 Then
    min := data1
  Else
    min := data2;
End;

Function min(data1, data2: variant; CompProc: TComparefunc): variant;
// Liefert das Minimum von Data1 und Data2
Var
  cr: TCompResult;

Begin
  If assigned(CompProc) Then
  Begin
    cr := CompProc(data1, data2);
    If cr = cr_Lower Then
      min := data1
    Else
      min := data2
  End
  Else If data1 < data2 Then
    min := data1
  Else
    min := data2;
End;

Function max(data1, data2: integer): integer;
// Liefert das Maximum von Data1 und Data2
Begin
  If data1 > data2 Then
    max := data1
  Else
    max := data2;
End;

Function max(data1, data2: variant; CompProc: TComparefunc): variant;
// Liefert das Maximum von Data1 und Data2
Begin
  If assigned(CompProc) Then
    If CompProc(data1, data2) = cr_Higher Then
      max := data1
    Else
      max := data2
  Else If data1 > data2 Then
    max := data1
  Else
    max := data2;
End;

Procedure Sort_Bubblesort(Var DataArr: variant);
// Sortiert ein array
// O(x*x);

Var
  i, j: integer;
  v: variant;
Begin
  For i := vararraylowbound(DataArr, 1)
    To pred(vararrayhighbound(DataArr, 1)) Do
    For j := pred(vararrayhighbound(DataArr, 1)) Downto i Do
      If DataArr[j] > DataArr[succ(j)] Then
      Begin
        v := DataArr[j];
        DataArr[j] := DataArr[succ(j)];
        DataArr[succ(j)] := v;
      End;
End;
/// // -- Laufzeitfunktionen ///////////////////////////////////////////////////

Procedure delay(msec: integer);

{$IFNDEF FPC}
Var
  StartTime: TDateTime;
{$ENDIF}
Begin
{$IFNDEF FPC}
  StartTime := Now;
  While TimeDifferenz(StartTime, Now) < msec Do
    Application.Handlemessage;
{$ELSE}
  sleep(msec);
{$ENDIF}
End;

/// ////////// Zeitfunktionen //////////////////////////////////////////////////

Function TimeDifferenz(time0, time1: TDateTime): integer;

Var
  t0, t1, dt: TTimeStamp;

Begin
  t0 := DateTimeToTimeStamp(time0);
  t1 := DateTimeToTimeStamp(time1);
  dt.time := t1.time - t0.time;
  dt.date := t1.date - t0.date;
  TimeDifferenz := dt.date * msecperday + dt.time;
End;

// procedure Makepath(npath:string);
/// / Erstelle falls nötig den npath
// Jetzt in Fileprocs
//
// var CPath:string;
// flag:boolean;
//
// begin
// CPath := '';
// flag := True;
// While (CPath + '\' <> npath) And flag do
// begin
// CPath := copy(npath,1, pos( '\', copy (npath,Length(CPath) + 2,length(npath)))+Length(CPath) + 1);
// flag := FileExists(CPath);
// end;
// If Not flag Then
// begin
// MkDir (CPath );
// While (CPath + '\' <> npath) do
// begin
// CPath := copy(npath,1, pos( '\', copy (npath,Length(CPath) + 2,length(npath)))+Length(CPath) + 1);
// MkDir (CPath);
// end;
// End;
//
// end;

// Diese Procedure Hat Die Aufgabe Mehrere Dateien Umzubenennen

// Procedure MultiReName(OldName, NewName: String); // Private
/// / benutzt DIR --> unterbricht vorhergehende dir - Abfragen
/// / Jetzt in Fileprocs
//
// var OldFName, oFp, oFn, oFe,
// NFp, NFn, NFe: String;
// NFAttr: integer;
// movemode: boolean;
// dimc, I: integer;
// files: array of string;
// sr: TSearchRec;
//
// Begin
// If (pos('*', OldName) > 0) Or (pos('?', OldName) > 0) Or
// (pos('*', OldName) > 0) Or (pos('?', OldName) > 0) Then
// Begin
// // Joker-zeichen angegeben --> Multi ren erforderlich
// ofp := ExtractFilePath(oldname);
// ofn := ExtractFileName(oldname);
// ofe := ExtractFileExt(oldname);
// nfp := ExtractFilePath(newname);
// nfn := ExtractFileName(newname);
// nfe := ExtractFileExt(newname);
//
// If findfirst(OldName, faDirectory, sr) = 0 Then
// OldFName := sr.Name
// Else
// oldfname := '';
// dimc := 0;
// While OldFName <> '' Do
// Begin
// If (OldFName <> '.') And (OldFName <> '..') Then
// dimc := dimc + 1;
// If findnext(sr) = 0 Then
// OldFName := sr.Name
// Else
// oldfname := '';
//
// End; //  wend
// setlength(files, dimc);
// If findfirst(OldName, faDirectory, sr) = 0 Then
// OldFName := sr.Name
// Else
// oldfname := '';
// I := 0;
// While OldFName <> '' Do
// Begin
// If (OldFName <> '.') And (OldFName <> '..') Then
// Begin
// files[I] := OldFName;
// I := I + 1;
// End; //  If ...
// If findnext(sr) = 0 Then
// OldFName := sr.Name
// Else
// oldfname := '';
// End; //  wend
//
// // Mylist.Show
// If Not FileExists(NewName) Then
// Begin
// If NewName[length(newname)] = '\' Then
// Begin
// makepath(NewName);
// movemode := True
// end
// else
// begin
// movemode := False
// End; //  If ...
// End
// Else
// Begin
// {$IFDEF MSWINDOWS}
// {$WARN SYMBOL_PLATFORM OFF}
// NFAttr := FileGetAttr(newname);
// {$WARN SYMBOL_PLATFORM ON}
// {$ELSE}
// NFAttr := iuow;
// {$ENDIF}
// movemode := (NFAttr And faDirectory) <> 0;
// If Not movemode Then
// runerror(255);
// end; //  If ...
// If movemode Then
// Begin
// If NewName[length(newname)] <> '\' Then
// NewName := NewName + '\';
// For I := low(files) To high(files) do
// sysutils.ReNamefile(oFp + files[I], NewName + files[I])
// End
// Else
// Begin
// runerror(255);
// end; //  If ...
// end; //  If ...
// End;

Function smult(m1, m2: longword): longword; overload;
// Führt eine Multiplikation im dword-Ring aus
Var
  h, dv: int64;

Begin
  dv := int64(longword(-1)) + 2;
  h := (int64(m1) + 1);
  h := (h * ((int64(m2) + 1) Div 2)) Mod dv;
  h := h + (((int64(m1) + 1) * ((int64(m2) + 2) Div 2)) Mod dv);
  h := h Mod dv - 1;
  result := h;
End;

Function OverTopAdd(a1, a2: uint64): boolean;

Begin
  result := (a2 + a1) < a2;
End;

Function smult(m1, m2: uint64): uint64; overload;
// Führt eine Multiplikation im dword-Ring aus
Var
  mm1, mm2, hh: Array [0 .. 4] Of int64;
  h: int64;
  i, j: integer;

Begin
  mm1[0] := (m1 + 1) And $FFFFFFFF;
  mm1[1] := (m1 + 1) Shr 32;
  If m1 = uint64(-1) Then
    mm1[2] := 1
  Else
    mm1[2] := 0;

  mm2[0] := (m2 + 1) And $FFFFFFFF;
  mm2[1] := (m2 + 1) Shr 32;
  If m1 = uint64(-1) Then
    mm2[2] := 1
  Else
    mm2[2] := 0;
  { 1234*9876=
    36 }
  For i := 0 To 4 Do
    hh[i] := 0;

  For i := 0 To 2 Do
    For j := 0 To 2 Do
    Begin
      h := mm1[i] * mm2[j];
      If OverTopAdd(hh[i + j], h) Then
        inc(hh[i + j + 1]);
      hh[i + j] := hh[i + j] + h;
    End;

  For i := 0 To 3 Do
  Begin
    If OverTopAdd(hh[i + 1], hh[i] Shr 32) Then
      inc(hh[i + 2]);
    hh[i + 1] := hh[i + 1] + (hh[i] Shr 32);
    hh[i] := hh[i] And $FFFFFFFF
  End;

  hh[0] := hh[0] Or (hh[1] Shl 32);
  hh[2] := hh[2] Or (hh[3] Shl 32);

  If (hh[0] > 0) And (hh[2] > 0) Then
    If hh[0] - hh[2] < 0 Then
      result := hh[0] - hh[2]
    Else
      result := hh[0] - hh[2] - 1
  Else If (hh[0] < 0) And (hh[2] < 0) Then
    If hh[0] - hh[2] < 0 Then
      result := hh[0] - hh[2]
    Else
      result := hh[0] - hh[2] - 1
  Else If hh[0] < 0 Then
    result := hh[0] - hh[2] - 1
  Else
    result := hh[0] - hh[2];
End;

Function sPlus(m1, m2: longword): longword;
// Führt eine Addition im dword-Ring aus
Var
  h: int64;

Begin
  h := m1;
  h := h + m2;
  h := h And $FFFFFFFF;
  result := h;
End;

Function set2word(Const X): int64;
// wandelt ein set of XXX in ein Bitarray in form eines Words um

Var // i :byte;
  flag: Word;
Begin
  flag := int64(X);
  result := flag;
End;

Procedure Word2set(Var X; l: int64);
// wandelt ein Word in ein vorgegebenes set of XXX um

Begin
  int64(X) := l;
End;

Function IndexOfMax(Const param: Array Of integer): integer;
Var
  i: integer;
  test: integer;

Begin
  result := -1;
  If high(param) >= 0 Then
  Begin
    test := param[0];
    result := 0;
    For i := 1 To high(param) Do
      If param[i] > test Then
      Begin
        test := param[i];
        result := i;
      End;
  End;
End;

Function IndexOfMaxExt(Const param: Array Of extended): integer;
Var
  i: integer;
  test: extended;

Begin
  result := -1;
  If high(param) >= 0 Then
  Begin
    test := param[0];
    result := 0;
    For i := 1 To high(param) Do
      If param[i] > test Then
      Begin
        test := param[i];
        result := i;
      End;
  End;
End;

Initialization

crc64_table_empty := true;
{$IFDEF DYNAMIC_CRC_TABLE}
crc_table_empty := true;
{$ENDIF}

End.
