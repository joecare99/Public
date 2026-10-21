unit AHNGlobals;

{-------------------------------------------------------------------------------
  AHNGlobals - the application-wide global variables of AHNENWIN 5.1.

  The IDR disassembly names these variables gvar_<ADDRESS>; the names are
  kept verbatim so that every reference stays traceable to the original
  binary. The comment behind each declaration records the type that the
  disassembly shows and the units that use the variable.

  The form instances are deliberately NOT in this unit: they belong to
  the unit that declares the corresponding class, because
  Application.CreateForm needs them by reference.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, DB, DBTables, DBCommon, Controls, Graphics, Forms;

var
  gvar_0054F9C4: Integer; //0054F9C4  used by Unit26
  gvar_0055AEC8: Integer; //0055AEC8  used by Unit10
  gvar_0055D720: Integer; //0055D720  used by Unit16
  gvar_0055DA64: Integer; //0055DA64  used by Unit16
  gvar_0055E0FC: Integer; //0055E0FC  used by Unit16
  gvar_005679EC: Integer; //005679EC  used by Unit13
  gvar_005679F0: Integer; //005679F0  used by Unit13
  gvar_0056A95C: Integer; //0056A95C  used by Unit13
  gvar_0056EAE8: Integer; //0056EAE8  used by Unit13
  gvar_0056EAEC: Integer; //0056EAEC  used by Unit13
  gvar_00570274: Integer; //00570274  used by Unit13
  gvar_00570C00: Integer; //00570C00  used by Unit13
  gvar_005723EC: Integer; //005723EC  used by Unit13
  gvar_00572958: Integer; //00572958  used by Unit13
  gvar_00582408: Integer; //00582408  used by Unit3
  gvar_005AF168: Integer; //005AF168  used by Unit3
  gvar_005B2120: Integer; //005B2120  used by Unit3
  gvar_005B2124: Integer; //005B2124  used by Unit3
  gvar_005BBD24: Integer; //005BBD24  used by Unit3
  gvar_005C5468: Integer; //005C5468  used by Unit3
  gvar_005C546C: Integer; //005C546C  used by Unit3
  gvar_005CB1D0: Integer; //005CB1D0  used by Unit11
  gvar_005CB208: Integer; //005CB208  used by Unit11
  gvar_005CBC40: Integer; //005CBC40  used by Unit21
  gvar_005CBD60: Integer; //005CBD60  used by Unit21
  gvar_005CC2D8: Integer; //005CC2D8  used by Unit21
  gvar_005D6558: Integer; //005D6558  used by Unit1
  gvar_005D8B08: Integer; //005D8B08  used by Unit1
  gvar_005D924C: Integer; //005D924C  used by Unit1
  gvar_005DF4B8: Integer; //005DF4B8  used by Unit1
  gvar_005DF510: Integer; //005DF510  used by Unit1
  gvar_005E2860: Integer; //005E2860  used by Unit1
  gvar_005E5318: Integer; //005E5318  used by Unit1
  gvar_005E55E8: Integer; //005E55E8  used by Unit1
  gvar_005E62D0: Integer; //005E62D0  used by Unit1
  gvar_005E7A10: Integer; //005E7A10  used by Unit1
  gvar_005EBA68: Integer; //005EBA68  used by Unit1
  gvar_005EBB54: Integer; //005EBB54  used by Unit1
  gvar_005EEAF0: Integer; //005EEAF0  used by Unit1
  gvar_005EEB3C: Integer; //005EEB3C  used by Unit1
  gvar_005F02D4: Integer; //005F02D4  used by Unit1
  gvar_005FC568: Integer; //005FC568  used by Unit1
  gvar_006052CC: Integer; //006052CC  used by Unit1
  gvar_0060C610: Integer; //0060C610  used by Unit1
  gvar_0060E584: Integer; //0060E584  used by Unit1
  gvar_00615FC8: Integer; //00615FC8  used by Unit1
  gvar_00618924: Integer; //00618924  used by Unit1
  gvar_0061E858: Variant; //0061E858  used by Unit1
  gvar_0061EC3C: TScreen; //0061EC3C  used by Unit1, Unit11, Unit13, Unit16, Unit18, Unit19, Unit20, Unit22, Unit26, Unit27, Unit29, Unit3, Unit33, Unit6, Unit7
  gvar_0061ED68: Integer; //0061ED68  used by Unit1
  gvar_0061EFB8: AnsiString; //0061EFB8  used by Unit14
  gvar_0061EFBC: AnsiString; //0061EFBC  used by Unit14
  gvar_0061EFC0: Integer; //0061EFC0  used by Unit14
  gvar_0061EFCC: AnsiString; //0061EFCC  used by Unit1, Unit17
  gvar_0061EFD0: Integer; //0061EFD0  used by Unit1, Unit17
  gvar_0061EFD4: Integer; //0061EFD4  used by Unit17
  gvar_0061EFE0: AnsiString; //0061EFE0  used by Unit18, Unit27
  gvar_0061EFE4: AnsiString; //0061EFE4  used by Unit18
  gvar_0061F000: Integer; //0061F000  used by Unit26
  gvar_0061F004: Integer; //0061F004  used by Unit26
  gvar_0061F008: AnsiString; //0061F008  used by Unit26, Unit27
  gvar_0061F014: AnsiString; //0061F014  used by Unit19
  gvar_0061F018: AnsiString; //0061F018  used by Unit19
  gvar_0061F01C: AnsiString; //0061F01C  used by Unit19
  gvar_0061F020: AnsiString; //0061F020  used by Unit19
  gvar_0061F024: AnsiString; //0061F024  used by Unit19
  gvar_0061F028: AnsiString; //0061F028  used by Unit1, Unit16, Unit16.Speichernunter1Click, Unit19
  gvar_0061F02C: AnsiString; //0061F02C  used by Unit19
  gvar_0061F030: AnsiString; //0061F030  used by Unit19
  gvar_0061F034: AnsiString; //0061F034  used by Unit16, Unit19
  gvar_0061F038: AnsiString; //0061F038  used by Unit19
  gvar_0061F03C: AnsiString; //0061F03C  used by Unit19
  gvar_0061F040: AnsiString; //0061F040  used by Unit19
  gvar_0061F044: Integer; //0061F044  used by Unit19
  gvar_0061F048: Integer; //0061F048  used by Unit19, Unit3
  gvar_0061F04C: Integer; //0061F04C  used by Unit19
  gvar_0061F050: TStringList; //0061F050  used by Unit1, Unit16, Unit19
  gvar_0061F054: TStringList; //0061F054  used by Unit1, Unit16, Unit19
  gvar_0061F058: Integer; //0061F058  used by Unit19
  gvar_0061F064: AnsiString; //0061F064  used by Unit32
  gvar_0061F068: AnsiString; //0061F068  used by Unit32
  gvar_0061F06C: AnsiString; //0061F06C  used by Unit32
  gvar_0061F070: AnsiString; //0061F070  used by Unit32
  gvar_0061F074: AnsiString; //0061F074  used by Unit32
  gvar_0061F078: AnsiString; //0061F078  used by Unit32
  gvar_0061F07C: AnsiString; //0061F07C  used by Unit32
  gvar_0061F080: AnsiString; //0061F080  used by Unit32
  gvar_0061F084: AnsiString; //0061F084  used by Unit32
  gvar_0061F088: AnsiString; //0061F088  used by Unit32
  gvar_0061F08C: AnsiString; //0061F08C  used by Unit32
  gvar_0061F090: AnsiString; //0061F090  used by Unit32
  gvar_0061F094: AnsiString; //0061F094  used by Unit32
  gvar_0061F098: AnsiString; //0061F098  used by Unit32
  gvar_0061F09C: AnsiString; //0061F09C  used by Unit32
  gvar_0061F0A0: AnsiString; //0061F0A0  used by Unit1, Unit32
  gvar_0061F0A4: AnsiString; //0061F0A4  used by Unit1, Unit32
  gvar_0061F0B8: Integer; //0061F0B8  used by Unit1, Unit16, Unit3
  gvar_0061F0BC: Integer; //0061F0BC  used by Unit1, Unit16
  gvar_0061F0C0: Integer; //0061F0C0  used by Unit1, Unit16
  gvar_0061F0CC: AnsiString; //0061F0CC  used by Unit24
  gvar_0061F0D0: AnsiString; //0061F0D0  used by Unit24
  gvar_0061F0EC: AnsiString; //0061F0EC  used by Unit29, Unit30
  gvar_0061F0F0: Integer; //0061F0F0  used by Unit29
  gvar_0061F0FC: Integer; //0061F0FC  used by Unit1
  gvar_0061F110: Integer; //0061F110  used by Unit13
  gvar_0061F114: Single; //0061F114  used by Unit13
  gvar_0061F118: Single; //0061F118  used by Unit13
  gvar_0061F11C: Integer; //0061F11C  used by Unit1, Unit13
  gvar_0061F120: Extended; //0061F120  used by Unit1, Unit13
  gvar_0061F124: Integer; //0061F124  used by Unit13
  gvar_0061F128: Integer; //0061F128  used by Unit13
  gvar_0061F12C: TStringList; //0061F12C  used by Unit13
  gvar_0061F1F0: Integer; //0061F1F0  used by Unit13
  gvar_0061F1F4: AnsiString; //0061F1F4  used by Unit13
  gvar_0061F2BC: Integer; //0061F2BC  used by Unit12, Unit13
  gvar_0061F2C0: Integer; //0061F2C0  used by Unit12, Unit13
  gvar_0061F2C4: Integer; //0061F2C4  used by Unit12, Unit13
  gvar_0061F2C8: Integer; //0061F2C8  used by Unit12, Unit13
  gvar_0061F2CC: Integer; //0061F2CC  used by Unit12, Unit13
  gvar_0061F2D0: Integer; //0061F2D0  used by Unit12, Unit13
  gvar_0061F2D4: Integer; //0061F2D4  used by Unit12, Unit13
  gvar_0061F2D8: Integer; //0061F2D8  used by Unit12
  gvar_0061F2DC: Integer; //0061F2DC  used by Unit13
  gvar_0061F2E0: AnsiString; //0061F2E0  used by Unit13
  gvar_0061F2E4: AnsiString; //0061F2E4  used by Unit13
  gvar_0061F2E8: AnsiString; //0061F2E8  used by Unit13
  gvar_0061F2EC: AnsiString; //0061F2EC  used by Unit13
  gvar_0061F2F0: Integer; //0061F2F0  used by Unit13
  gvar_0061F2F4: Integer; //0061F2F4  used by Unit13
  gvar_0061F2F8: Integer; //0061F2F8  used by Unit13
  gvar_0061F30C: Integer; //0061F30C  used by Unit13
  gvar_0061F314: Integer; //0061F314  used by Unit13
  gvar_01044CEC: Integer; //01044CEC  used by Unit13
  gvar_01044CF8: Integer; //01044CF8  used by Unit13
  gvar_01044D14: Integer; //01044D14  used by Unit13
  gvar_01044D47: Integer; //01044D47  used by Unit13
  gvar_01044D7C: Integer; //01044D7C  used by Unit13
  gvar_011AE038: Integer; //011AE038  used by Unit13
  gvar_011AE1C4: Integer; //011AE1C4  used by Unit13
  gvar_011AE1C8: Integer; //011AE1C8  used by Unit13
  gvar_011AE1CC: Integer; //011AE1CC  used by Unit13
  gvar_011AE1D0: Integer; //011AE1D0  used by Unit13
  gvar_011AE1D8: Integer; //011AE1D8  used by Unit13
  gvar_011AE1E0: Integer; //011AE1E0  used by Unit13
  gvar_011AE1E4: Integer; //011AE1E4  used by Unit13
  gvar_011AE1E8: Integer; //011AE1E8  used by Unit13
  gvar_011AE1EC: Integer; //011AE1EC  used by Unit13
  gvar_011AE1F0: Integer; //011AE1F0  used by Unit13
  gvar_011AE1F4: Integer; //011AE1F4  used by Unit13
  gvar_011AE1FC: Integer; //011AE1FC  used by Unit13
  gvar_011AE200: Integer; //011AE200  used by Unit13
  gvar_011AE204: Integer; //011AE204  used by Unit13
  gvar_011AE208: Integer; //011AE208  used by Unit13
  gvar_011AE20C: Integer; //011AE20C  used by Unit13
  gvar_011AE25C: Integer; //011AE25C  used by Unit13
  gvar_011AE285: Integer; //011AE285  used by Unit13
  gvar_011AE2BC: AnsiString; //011AE2BC  used by Unit13
  gvar_011AE2C0: AnsiString; //011AE2C0  used by Unit13
  gvar_011AE2C4: Integer; //011AE2C4  used by Unit1, Unit13, Unit3
  gvar_011AE2C8: AnsiString; //011AE2C8  used by Unit13
  gvar_011AE2CC: Integer; //011AE2CC  used by Unit13
  gvar_011AE300: Integer; //011AE300  used by Unit13
  gvar_011AE302: Integer; //011AE302  used by Unit13
  gvar_011AE304: Integer; //011AE304  used by Unit13
  gvar_011AE306: Integer; //011AE306  used by Unit13
  gvar_011AE318: Integer; //011AE318  used by Unit13
  gvar_011AE31C: Integer; //011AE31C  used by Unit13
  gvar_011AE320: Integer; //011AE320  used by Unit13
  gvar_011AE324: Integer; //011AE324  used by Unit13
  gvar_011AE328: Single; //011AE328  used by Unit13
  gvar_011AE32C: TCanvas; //011AE32C  used by Unit13
  gvar_011AE330: Integer; //011AE330  used by Unit13
  gvar_011AE334: Single; //011AE334  used by Unit13
  gvar_011AE338: Integer; //011AE338  used by Unit13
  gvar_011AE33C: Integer; //011AE33C  used by Unit13
  gvar_011AE340: Integer; //011AE340  used by Unit13
  gvar_011AE344: Integer; //011AE344  used by Unit13
  gvar_011AE348: Single; //011AE348  used by Unit13
  gvar_011AE34C: Extended; //011AE34C  used by Unit13
  gvar_011AE358: TBitmap; //011AE358  used by Unit13
  gvar_011AE35C: TStringList; //011AE35C  used by Unit13
  gvar_011AE360: Integer; //011AE360  used by Unit13
  gvar_011AE364: Integer; //011AE364  used by Unit13
  gvar_011AE368: Integer; //011AE368  used by Unit13
  gvar_011AE370: Integer; //011AE370  used by Unit13
  gvar_011AE378: Integer; //011AE378  used by Unit13
  gvar_015924DC: TStringList; //015924DC  used by Unit13
  gvar_015924E4: Integer; //015924E4  used by Unit13
  gvar_019764C4: Integer; //019764C4  used by Unit13
  gvar_019764C8: Integer; //019764C8  used by Unit13
  gvar_019764D8: Integer; //019764D8  used by Unit13
  gvar_019764E0: Integer; //019764E0  used by Unit13
  gvar_0197665C: TStringList; //0197665C  used by Unit13
  gvar_01976664: Integer; //01976664  used by Unit13
  gvar_01976668: Integer; //01976668  used by Unit13
  gvar_01976670: Integer; //01976670  used by Unit13
  gvar_01D5A7DC: TStringList; //01D5A7DC  used by Unit13
  gvar_0213E95C: TStringList; //0213E95C  used by Unit13
  gvar_02522AD8: Integer; //02522AD8  used by Unit13
  gvar_0252C718: Integer; //0252C718  used by Unit13
  gvar_0253635C: Integer; //0253635C  used by Unit13
  gvar_02536360: Integer; //02536360  used by Unit13
  gvar_02536364: Integer; //02536364  used by Unit13
  gvar_02536368: Integer; //02536368  used by Unit13
  gvar_0253636C: Extended; //0253636C  used by Unit13
  gvar_02536370: Integer; //02536370  used by Unit13
  gvar_02536374: Integer; //02536374  used by Unit13
  gvar_02536378: Integer; //02536378  used by Unit13
  gvar_0253637C: Integer; //0253637C  used by Unit13
  gvar_02536380: Integer; //02536380  used by Unit13
  gvar_02536384: Integer; //02536384  used by Unit13
  gvar_02536388: Integer; //02536388  used by Unit13
  gvar_0253639C: AnsiString; //0253639C  used by Unit28, Unit34
  gvar_025363A0: Integer; //025363A0  used by Unit28
  gvar_025363B4: AnsiString; //025363B4  used by Unit36, Unit37
  gvar_025363B8: Integer; //025363B8  used by Unit36
  gvar_025363CC: AnsiString; //025363CC  used by Unit39, Unit40
  gvar_025363D0: Integer; //025363D0  used by Unit39
  gvar_025363DC: Integer; //025363DC  used by Unit3
  gvar_025363E0: Integer; //025363E0  used by Unit24, Unit3
  gvar_025363E4: Integer; //025363E4  used by Unit24, Unit3
  gvar_025363E8: Integer; //025363E8  used by Unit24, Unit3
  gvar_025363EC: Integer; //025363EC  used by Unit24, Unit3
  gvar_025363F0: Integer; //025363F0  used by Unit24, Unit3
  gvar_025363F4: Integer; //025363F4  used by Unit24, Unit3
  gvar_025363F8: Integer; //025363F8  used by Unit24, Unit3
  gvar_025363FC: Integer; //025363FC  used by Unit24, Unit3
  gvar_02536400: Integer; //02536400  used by Unit24, Unit3
  gvar_02536404: Integer; //02536404  used by Unit24, Unit3
  gvar_02536408: Integer; //02536408  used by Unit24
  gvar_0253640C: Integer; //0253640C  used by Unit24
  gvar_02536410: Integer; //02536410  used by Unit24, Unit3
  gvar_02536414: Integer; //02536414  used by Unit24, Unit3
  gvar_02536418: Integer; //02536418  used by Unit24, Unit3
  gvar_0253641C: Integer; //0253641C  used by Unit24, Unit3
  gvar_02536420: Integer; //02536420  used by Unit24, Unit3
  gvar_02536424: Integer; //02536424  used by Unit24, Unit3
  gvar_02536428: AnsiString; //02536428  used by Unit3
  gvar_0253642C: AnsiString; //0253642C  used by Unit3
  gvar_02536430: AnsiString; //02536430  used by Unit3
  gvar_02536434: AnsiString; //02536434  used by Unit19, Unit3
  gvar_02536438: AnsiString; //02536438  used by Unit16, Unit16.Speichernunter1Click, Unit3
  gvar_0253643C: AnsiString; //0253643C  used by Unit3
  gvar_02536440: TStringList; //02536440  used by Unit16, Unit3
  gvar_02536444: TStringList; //02536444  used by Unit16, Unit3
  gvar_02536448: TStringList; //02536448  used by Unit3
  gvar_0253644C: TStringList; //0253644C  used by Unit3
  gvar_02536450: AnsiString; //02536450  used by Unit3
  gvar_02536454: AnsiString; //02536454  used by Unit3
  gvar_02536458: TTextRec; //02536458  used by Unit3
  gvar_02536624: AnsiString; //02536624  used by Unit3
  gvar_02536628: AnsiString; //02536628  used by Unit3
  gvar_0253662C: AnsiString; //0253662C  used by Unit3
  gvar_02536630: AnsiString; //02536630  used by Unit3
  gvar_02536634: AnsiString; //02536634  used by Unit3
  gvar_02536638: AnsiString; //02536638  used by Unit3
  gvar_0253663C: Integer; //0253663C  used by Unit3
  gvar_02536640: Integer; //02536640  used by Unit3
  gvar_02536644: Single; //02536644  used by Unit3
  gvar_02536648: Integer; //02536648  used by Unit3
  gvar_0253664C: Integer; //0253664C  used by Unit3
  gvar_02536650: Integer; //02536650  used by Unit3
  gvar_02536654: Integer; //02536654  used by Unit3
  gvar_02536658: Integer; //02536658  used by Unit3
  gvar_0253665C: AnsiString; //0253665C  used by Unit3
  gvar_02536660: AnsiString; //02536660  used by Unit3
  gvar_02536664: AnsiString; //02536664  used by Unit3
  gvar_02536668: Single; //02536668  used by Unit3
  gvar_0253666C: Single; //0253666C  used by Unit3
  gvar_02536670: TTextRec; //02536670  used by Unit3
  gvar_0253683C: Integer; //0253683C  used by Unit3
  gvar_02536840: Integer; //02536840  used by Unit3
  gvar_02536844: Integer; //02536844  used by Unit3
  gvar_02536848: AnsiString; //02536848  used by Unit3
  gvar_0253684C: AnsiString; //0253684C  used by Unit3
  gvar_02536850: AnsiString; //02536850  used by Unit3
  gvar_02536854: AnsiString; //02536854  used by Unit3
  gvar_02536858: AnsiString; //02536858  used by Unit3
  gvar_0253685C: AnsiString; //0253685C  used by Unit3
  gvar_02536860: TTable; //02536860  used by Unit3
  gvar_02536864: Integer; //02536864  used by Unit3
  gvar_02536868: Integer; //02536868  used by Unit3
  gvar_0253686C: Integer; //0253686C  used by Unit1, Unit3
  gvar_02536870: AnsiString; //02536870  used by Unit3
  gvar_02536884: Integer; //02536884  used by Unit9
  gvar_02536888: Integer; //02536888  used by Unit9
  gvar_02536894: TCanvas; //02536894  used by Unit11
  gvar_02536898: Double; //02536898  used by Unit11
  gvar_0253689C: Integer; //0253689C  used by Unit11
  gvar_025368A0: Single; //025368A0  used by Unit11
  gvar_025368A4: Single; //025368A4  used by Unit11
  gvar_025368A8: Integer; //025368A8  used by Unit11
  gvar_025368AC: AnsiString; //025368AC  used by Unit11
  gvar_025368B0: Integer; //025368B0  used by Unit11
  gvar_025368B4: Integer; //025368B4  used by Unit11
  gvar_025368B8: Integer; //025368B8  used by Unit11
  gvar_025368BC: Integer; //025368BC  used by Unit11
  gvar_025368C0: Integer; //025368C0  used by Unit11
  gvar_025368C4: Integer; //025368C4  used by Unit11
  gvar_025368E8: Integer; //025368E8  used by Unit6
  gvar_0253690C: Integer; //0253690C  used by Unit1
  gvar_02536910: Integer; //02536910  used by Unit1
  gvar_02536914: Integer; //02536914  used by Unit1
  gvar_02536918: Integer; //02536918  used by Unit1
  gvar_0253691C: Double; //0253691C  used by Unit1, Unit9
  gvar_02536924: Double; //02536924  used by Unit1, Unit9
  gvar_0253692C: AnsiString; //0253692C  used by Unit1, Unit10, Unit12, Unit13, Unit16, Unit16.Speichernunter1Click, Unit17, Unit19, Unit3
  gvar_02536930: AnsiString; //02536930  used by Unit1, Unit16, Unit16.Speichernunter1Click, Unit17, Unit22
  gvar_02536934: AnsiString; //02536934  used by Unit1, Unit16, Unit16.Speichernunter1Click, Unit17, Unit19, Unit22
  gvar_02536938: AnsiString; //02536938  used by Unit1
  gvar_0253693C: AnsiString; //0253693C  used by Unit1, Unit18
  gvar_02536940: Integer; //02536940  used by Unit1, Unit3
  gvar_02536944: Integer; //02536944  used by Unit1, Unit3
  gvar_02536948: Integer; //02536948  used by Unit1, Unit12
  gvar_0253694C: Integer; //0253694C  used by Unit1, Unit26
  gvar_02536950: AnsiString; //02536950  used by Unit1
  gvar_02536954: AnsiString; //02536954  used by Unit1
  gvar_02536958: AnsiString; //02536958  used by Unit1
  gvar_0253695C: AnsiString; //0253695C  used by Unit1
  gvar_02536960: TTextRec; //02536960  used by Unit1
  gvar_02536B2C: Integer; //02536B2C  used by Unit1
  gvar_02536B30: AnsiString; //02536B30  used by Unit1
  gvar_02536B34: AnsiString; //02536B34  used by Unit1
  gvar_02536B38: AnsiString; //02536B38  used by Unit1
  gvar_02536B3C: AnsiString; //02536B3C  used by Unit1
  gvar_02536B40: AnsiString; //02536B40  used by Unit1
  gvar_02536B44: AnsiString; //02536B44  used by Unit1
  gvar_02536B48: AnsiString; //02536B48  used by Unit1
  gvar_02536B4C: AnsiString; //02536B4C  used by Unit1
  gvar_02536B50: AnsiString; //02536B50  used by Unit1, Unit24
  gvar_02536B54: Integer; //02536B54  used by Unit1
  gvar_02536B58: AnsiString; //02536B58  used by Unit1, Unit32
  gvar_02536B5C: AnsiString; //02536B5C  used by Unit1
  gvar_02536B60: AnsiString; //02536B60  used by Unit1
  gvar_02536B64: Integer; //02536B64  used by Unit1
  gvar_02536B68: Integer; //02536B68  used by Unit1, Unit35
  gvar_02536B6C: Integer; //02536B6C  used by Unit1, Unit35
  gvar_02536B70: Integer; //02536B70  used by Unit1, Unit35
  gvar_02536B74: Integer; //02536B74  used by Unit1, Unit35
  gvar_02536B78: Integer; //02536B78  used by Unit1, Unit35
  gvar_02536B7C: Integer; //02536B7C  used by Unit1, Unit35
  gvar_02536B80: Integer; //02536B80  used by Unit1, Unit35
  gvar_02536B84: Integer; //02536B84  used by Unit1, Unit35
  gvar_02536B88: Integer; //02536B88  used by Unit1, Unit35
  gvar_02536B8C: Integer; //02536B8C  used by Unit1, Unit35
  gvar_02536B90: Integer; //02536B90  used by Unit1, Unit35
  gvar_02536B94: Integer; //02536B94  used by Unit13
  gvar_02536B98: AnsiString; //02536B98  used by Unit1, Unit35
  gvar_02536B9C: AnsiString; //02536B9C  used by Unit1, Unit10, Unit13, Unit3, Unit32
  gvar_02536BA0: Integer; //02536BA0  used by Unit1, Unit10, Unit11, Unit13, Unit16, Unit18, Unit19, Unit26, Unit3
  gvar_02536BA4: Integer; //02536BA4  used by Unit1
  gvar_02536BA8: Integer; //02536BA8  used by Unit1, Unit11
  gvar_02536BAC: Integer; //02536BAC  used by Unit1, Unit11
  gvar_02536BB0: TFileStream; //02536BB0  used by Unit1
  gvar_02536BB4: PShortString; //02536BB4  used by Unit1

implementation

end.
