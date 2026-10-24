{ TForm1 menu-area implementations: Search; LFM-bound method names remain on TForm1. }

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.DatensatzNr1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2
    (TTabSheet); Form1
Database/provider: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C
Project calls: TForm1.anzeigen(); Unit_00408494.Proc_004099B4
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Dialogs.InputQuery(AnsiString;AnsiString;AnsiString;AnsiString):Boolean;;
    Dialogs.ShowMessage(AnsiString);; method TMenuItem.Click()
Strings/files/dialog text: '_^[��]�'; 'Bitte Zahlenwert eingeben.'; 'Datensatz suchen';
    'Datensatz-Nr.: '; '�w�����_^[��]�'; '��������]'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.DatensatzNr1Click(Sender : TObject);
begin
(*
005D9678   55                     push    ebp
005D9679   8BEC                   mov     ebp, esp
005D967B   83C4F0                 add     esp, -$10
005D967E   53                     push    ebx
005D967F   56                     push    esi
005D9680   57                     push    edi
005D9681   33C9                   xor     ecx, ecx
005D9683   894DF8                 mov     [ebp-$08], ecx
005D9686   8945FC                 mov     [ebp-$04], eax
005D9689   33C0                   xor     eax, eax
005D968B   55                     push    ebp

* Possible String Reference to: '�w�����_^[��]�'
|
005D968C   6850975D00             push    $005D9750

***** TRY
|
005D9691   64FF30                 push    dword ptr fs:[eax]
005D9694   648920                 mov     fs:[eax], esp

* Reference to Form1
|
005D9697   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005D969A   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005D96A0   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005D96A3   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005D96A9   E80A67EAFF             call    0047FDB8
005D96AE   8D4DF8                 lea     ecx, [ebp-$08]

* Possible String Reference to: 'Datensatz-Nr.: '
|
005D96B1   BA68975D00             mov     edx, $005D9768

* Possible String Reference to: 'Datensatz suchen'
|
005D96B6   B880975D00             mov     eax, $005D9780

* Reference to: Dialogs.InputQuery(AnsiString;AnsiString;AnsiString;AnsiString):Boolean;
|
005D96BB   E848C1E6FF             call    00445808
005D96C0   3C01                   cmp     al, $01
005D96C2   7576                   jnz     005D973A
005D96C4   33C0                   xor     eax, eax
005D96C6   55                     push    ebp

* Possible String Reference to: '��������]'
|
005D96C7   6818975D00             push    $005D9718

***** TRY
|
005D96CC   64FF30                 push    dword ptr fs:[eax]
005D96CF   648920                 mov     fs:[eax], esp

* Reference to pointer to GlobalVar_0061DF08
|
005D96D2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D96D7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005D96D9   8B405C                 mov     eax, [eax+$5C]
005D96DC   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D96DE   E87994EFFF             call    004D2B5C
005D96E3   8B45F8                 mov     eax, [ebp-$08]

* Reference to: Unit_00408494.Proc_004099B4
|
005D96E6   E8C902E3FF             call    004099B4
005D96EB   8945F0                 mov     [ebp-$10], eax
005D96EE   C645F400               mov     byte ptr [ebp-$0C], $00
005D96F2   8D55F0                 lea     edx, [ebp-$10]

* Reference to pointer to GlobalVar_0061DF08
|
005D96F5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D96FA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005D96FC   8B405C                 mov     eax, [eax+$5C]
005D96FF   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005D9701   E85E9BEFFF             call    004D3264

* Reference to Form1
|
005D9706   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.anzeigen()
|
005D9709   E88EACFFFF             call    005D439C
005D970E   33C0                   xor     eax, eax
005D9710   5A                     pop     edx
005D9711   59                     pop     ecx
005D9712   59                     pop     ecx
005D9713   648910                 mov     fs:[eax], edx
005D9716   EB22                   jmp     005D973A

* Reference to: System.@HandleAnyException;
|
005D9718   E9FBAAE2FF             jmp     00404218

* Possible String Reference to: 'Bitte Zahlenwert eingeben.'
|
005D971D   B89C975D00             mov     eax, $005D979C

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005D9722   E8BDC0E6FF             call    004457E4

* Reference to Form1
|
005D9727   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.DatensatzNr1 : TMenuItem
|
005D972A   8B8010030000           mov     eax, [eax+$0310]
005D9730   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005D9732   FF5244                 call    dword ptr [edx+$44]

* Reference to: System.@DoneExcept;
|
005D9735   E80AAFE2FF             call    00404644

****** END
|
005D973A   33C0                   xor     eax, eax
005D973C   5A                     pop     edx
005D973D   59                     pop     ecx
005D973E   59                     pop     ecx
005D973F   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005D9742   6857975D00             push    $005D9757
005D9747   8D45F8                 lea     eax, [ebp-$08]

* Reference to: System.@LStrClr(void;void);
|
005D974A   E819B4E2FF             call    00404B68
005D974F   C3                     ret


* Reference to: System.@HandleFinally;
|
005D9750   E977ADE2FF             jmp     004044CC
005D9755   EBF0                   jmp     005D9747

****** END
|
005D9757   5F                     pop     edi
005D9758   5E                     pop     esi
005D9759   5B                     pop     ebx
005D975A   8BE5                   mov     esp, ebp
005D975C   5D                     pop     ebp
005D975D   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.MainMenu1 (TMainMenu); TForm1.PageControl1 (TPageControl);
    TForm1.StringGrid5 (TStringGrid); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);;
    DB.TDataSet.Open(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;;
    DBTables.TTable.SetDataSource(TTable;TDataSource);;
    DBTables.TTable.SetMasterFields(TTable;AnsiString);
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_009C; OFFS_00A0; OFFS_00E8; OFFS_013C; OFFS_0470;
    OFFS_047C; OFFS_0490; OFFS_049C; OFFS_0534; OFFS_0880; OFFS_0888; OFFS_0944; OFFS_0950;
    OFFS_0954; OFFS_096C; OFFS_097C
Project calls: TForm1.anzeigen(); Unit_00408494.Proc_004091D8; Unit_00408494.Proc_00409448;
    Unit_00408494.Proc_00409950
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.Refresh(TControl);; Controls.TControl.Show(TControl);;
    Dialogs.InputQuery(AnsiString;AnsiString;AnsiString;AnsiString):Boolean;;
    Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);;
    Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;;
    Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);;
    Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;;
    Menus.TMenuItem.SetVisible(TMenuItem;Boolean);; method TMenuItem.Click(); System.Proc_00404EE0
Strings/files/dialog text: '* '; 'Ehes'; 'Heiratsname der Frau'; 'nichts gefunden'; 'num'; 'nummer';
    'o-o '; 'ooK '; 'ooS '; 'Partner suchen'; 'Vorname der Frau'; '~ '
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Partnersuche1Click(Sender : TObject);
begin
(*
005EE190   55                     push    ebp
005EE191   8BEC                   mov     ebp, esp
005EE193   B913000000             mov     ecx, $00000013
005EE198   6A00                   push    $00
005EE19A   6A00                   push    $00
005EE19C   49                     dec     ecx
005EE19D   75F9                   jnz     005EE198
005EE19F   51                     push    ecx
005EE1A0   53                     push    ebx
005EE1A1   56                     push    esi
005EE1A2   57                     push    edi
005EE1A3   8BD8                   mov     ebx, eax
005EE1A5   33C0                   xor     eax, eax
005EE1A7   55                     push    ebp
005EE1A8   6856E95E00             push    $005EE956

***** TRY
|
005EE1AD   64FF30                 push    dword ptr fs:[eax]
005EE1B0   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EE1B3   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EE1B9   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EE1BF   E8F41BE9FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005EE1C4   8B831C060000           mov     eax, [ebx+$061C]
005EE1CA   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005EE1CC   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
005EE1CF   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE1D4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005EE1D6   8B8034050000           mov     eax, [eax+$0534]
005EE1DC   8B10                   mov     edx, [eax]
005EE1DE   FF5258                 call    dword ptr [edx+$58]
005EE1E1   8945F4                 mov     [ebp-$0C], eax

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE1E4   8B8374060000           mov     eax, [ebx+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
005EE1EA   8BB84C020000           mov     edi, [eax+$024C]
005EE1F0   4F                     dec     edi
005EE1F1   85FF                   test    edi, edi
005EE1F3   7C68                   jl      005EE25D
005EE1F5   47                     inc     edi
005EE1F6   33F6                   xor     esi, esi
005EE1F8   6A00                   push    $00
005EE1FA   8BCE                   mov     ecx, esi
005EE1FC   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE1FE   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE204   E8F318EFFF             call    004DFAFC
005EE209   6A00                   push    $00
005EE20B   8BCE                   mov     ecx, esi
005EE20D   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE212   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE218   E8DF18EFFF             call    004DFAFC
005EE21D   6A00                   push    $00
005EE21F   8BCE                   mov     ecx, esi
005EE221   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE226   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE22C   E8CB18EFFF             call    004DFAFC
005EE231   6A00                   push    $00
005EE233   8BCE                   mov     ecx, esi
005EE235   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE23A   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE240   E8B718EFFF             call    004DFAFC
005EE245   6A00                   push    $00
005EE247   8BCE                   mov     ecx, esi
005EE249   BA04000000             mov     edx, $00000004

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE24E   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE254   E8A318EFFF             call    004DFAFC
005EE259   46                     inc     esi
005EE25A   4F                     dec     edi
005EE25B   759B                   jnz     005EE1F8
005EE25D   8D45FC                 lea     eax, [ebp-$04]

* Reference to: System.@LStrClr(void;void);
|
005EE260   E80369E1FF             call    00404B68
005EE265   8D45F8                 lea     eax, [ebp-$08]

* Reference to: System.@LStrClr(void;void);
|
005EE268   E8FB68E1FF             call    00404B68
005EE26D   8D4DFC                 lea     ecx, [ebp-$04]

* Possible String Reference to: 'Heiratsname der Frau'
|
005EE270   BA6CE95E00             mov     edx, $005EE96C

* Possible String Reference to: 'Partner suchen'
|
005EE275   B88CE95E00             mov     eax, $005EE98C

* Reference to: Dialogs.InputQuery(AnsiString;AnsiString;AnsiString;AnsiString):Boolean;
|
005EE27A   E88975E5FF             call    00445808
005EE27F   84C0                   test    al, al
005EE281   0F8470050000           jz      005EE7F7
005EE287   8D4DF8                 lea     ecx, [ebp-$08]

* Possible String Reference to: 'Vorname der Frau'
|
005EE28A   BAA4E95E00             mov     edx, $005EE9A4

* Possible String Reference to: 'Partner suchen'
|
005EE28F   B88CE95E00             mov     eax, $005EE98C

* Reference to: Dialogs.InputQuery(AnsiString;AnsiString;AnsiString;AnsiString):Boolean;
|
005EE294   E86F75E5FF             call    00445808
005EE299   84C0                   test    al, al
005EE29B   0F8456050000           jz      005EE7F7

* Reference to pointer to GlobalVar_0061DF08
|
005EE2A1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE2A6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005EE2A8   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EE2AE   E8D5E9EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005EE2B3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE2B8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005EE2BA   8B809C000000           mov     eax, [eax+$009C]
005EE2C0   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EE2C2   E89548EEFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005EE2C7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE2CC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005EE2CE   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EE2D4   E8FB0EECFF             call    004AF1D4

* Reference to pointer to GlobalVar_0061DF08
|
005EE2D9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE2DE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE2E0   8B80E8000000           mov     eax, [eax+$00E8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EE2E6   E89DE9EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005EE2EB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE2F0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A0
|
005EE2F2   8B90A0000000           mov     edx, [eax+$00A0]

* Reference to pointer to GlobalVar_0061DF08
|
005EE2F8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE2FD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE2FF   8B80E8000000           mov     eax, [eax+$00E8]

* Reference to: DBTables.TTable.SetDataSource(TTable;TDataSource);
|
005EE305   E89E55EEFF             call    004D38A8

* Reference to pointer to GlobalVar_0061DF08
|
005EE30A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE30F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE311   8B80E8000000           mov     eax, [eax+$00E8]

* Possible String Reference to: 'nummer'
|
005EE317   BAC0E95E00             mov     edx, $005EE9C0

* Reference to: DBTables.TTable.SetMasterFields(TTable;AnsiString);
|
005EE31C   E80F56EEFF             call    004D3930

* Reference to pointer to GlobalVar_0061DF08
|
005EE321   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE326   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE328   8B80E8000000           mov     eax, [eax+$00E8]

* Possible String Reference to: 'num'
|
005EE32E   BAD0E95E00             mov     edx, $005EE9D0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EE333   E82448EEFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005EE338   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE33D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE33F   8B80E8000000           mov     eax, [eax+$00E8]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EE345   E88A0EECFF             call    004AF1D4

* Reference to pointer to GlobalVar_0061DF08
|
005EE34A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE34F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_013C
|
005EE351   8B803C010000           mov     eax, [eax+$013C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EE357   E82CE9EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005EE35C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE361   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_013C
|
005EE363   8B803C010000           mov     eax, [eax+$013C]
005EE369   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EE36B   E8EC47EEFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005EE370   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE375   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_013C
|
005EE377   8B803C010000           mov     eax, [eax+$013C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EE37D   E8520EECFF             call    004AF1D4

* Reference to Form1
|
005EE382   A108595302             mov     eax, dword ptr [$02535908]

* Reference to: Controls.TControl.Refresh(TControl);
|
005EE387   E8FCEBE5FF             call    0044CF88
005EE38C   BE02000000             mov     esi, $00000002
005EE391   68DCE95E00             push    $005EE9DC
005EE396   FF75FC                 push    dword ptr [ebp-$04]
005EE399   68E8E95E00             push    $005EE9E8
005EE39E   FF75F8                 push    dword ptr [ebp-$08]
005EE3A1   68DCE95E00             push    $005EE9DC
005EE3A6   8D45F0                 lea     eax, [ebp-$10]
005EE3A9   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005EE3AE   E82D6BE1FF             call    00404EE0
005EE3B3   8B45F0                 mov     eax, [ebp-$10]
005EE3B6   50                     push    eax
005EE3B7   33C9                   xor     ecx, ecx
005EE3B9   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE3BE   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE3C4   E83317EFFF             call    004DFAFC
005EE3C9   8D5601                 lea     edx, [esi+$01]

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE3CC   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
005EE3D2   E8F9F4EEFF             call    004DD8D0

* Reference to pointer to GlobalVar_0061DF08
|
005EE3D7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE3DC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005EE3DE   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EE3E4   E8EB0DECFF             call    004AF1D4
005EE3E9   E9EF030000             jmp     005EE7DD
005EE3EE   8D55E8                 lea     edx, [ebp-$18]

* Reference to pointer to GlobalVar_0061DF08
|
005EE3F1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE3F6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0880
|
005EE3F8   8B8080080000           mov     eax, [eax+$0880]
005EE3FE   8B08                   mov     ecx, [eax]
005EE400   FF5160                 call    dword ptr [ecx+$60]
005EE403   8B45E8                 mov     eax, [ebp-$18]
005EE406   8D55EC                 lea     edx, [ebp-$14]

* Reference to: Unit_00408494.Proc_004091D8
|
005EE409   E8CAADE1FF             call    004091D8
005EE40E   8B45EC                 mov     eax, [ebp-$14]
005EE411   50                     push    eax
005EE412   8D55E4                 lea     edx, [ebp-$1C]
005EE415   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_004091D8
|
005EE418   E8BBADE1FF             call    004091D8
005EE41D   8B45E4                 mov     eax, [ebp-$1C]
005EE420   5A                     pop     edx

* Reference to: System.@LStrPos;
|
005EE421   E8366DE1FF             call    0040515C
005EE426   85C0                   test    eax, eax
005EE428   0F8E87030000           jle     005EE7B5
005EE42E   8D55DC                 lea     edx, [ebp-$24]

* Reference to pointer to GlobalVar_0061DF08
|
005EE431   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE436   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0888
|
005EE438   8B8088080000           mov     eax, [eax+$0888]
005EE43E   8B08                   mov     ecx, [eax]
005EE440   FF5160                 call    dword ptr [ecx+$60]
005EE443   8B45DC                 mov     eax, [ebp-$24]
005EE446   8D55E0                 lea     edx, [ebp-$20]

* Reference to: Unit_00408494.Proc_004091D8
|
005EE449   E88AADE1FF             call    004091D8
005EE44E   8B45E0                 mov     eax, [ebp-$20]
005EE451   BAF4E95E00             mov     edx, $005EE9F4

* Reference to: System.@LStrCmp;
|
005EE456   E8096BE1FF             call    00404F64
005EE45B   0F8554030000           jnz     005EE7B5

* Reference to pointer to GlobalVar_0061DF08
|
005EE461   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE466   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE468   8B80E8000000           mov     eax, [eax+$00E8]
005EE46E   8B10                   mov     edx, [eax]
005EE470   FF924C010000           call    dword ptr [edx+$014C]
005EE476   85C0                   test    eax, eax
005EE478   0F8E37030000           jle     005EE7B5

* Reference to pointer to GlobalVar_0061DF08
|
005EE47E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE483   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE485   8B80E8000000           mov     eax, [eax+$00E8]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EE48B   E8440DECFF             call    004AF1D4
005EE490   E906030000             jmp     005EE79B

* Reference to pointer to GlobalVar_0061DF08
|
005EE495   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE49A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0470
|
005EE49C   8B8070040000           mov     eax, [eax+$0470]
005EE4A2   8B10                   mov     edx, [eax]
005EE4A4   FF5258                 call    dword ptr [edx+$58]
005EE4A7   8945D4                 mov     [ebp-$2C], eax
005EE4AA   C645D800               mov     byte ptr [ebp-$28], $00
005EE4AE   8D55D4                 lea     edx, [ebp-$2C]

* Reference to pointer to GlobalVar_0061DF08
|
005EE4B1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE4B6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_013C
|
005EE4B8   8B803C010000           mov     eax, [eax+$013C]
005EE4BE   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005EE4C0   E89F4DEEFF             call    004D3264
005EE4C5   8D55CC                 lea     edx, [ebp-$34]

* Reference to pointer to GlobalVar_0061DF08
|
005EE4C8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE4CD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0954
|
005EE4CF   8B8054090000           mov     eax, [eax+$0954]
005EE4D5   8B08                   mov     ecx, [eax]
005EE4D7   FF5160                 call    dword ptr [ecx+$60]
005EE4DA   8B45CC                 mov     eax, [ebp-$34]
005EE4DD   8D55D0                 lea     edx, [ebp-$30]

* Reference to: Unit_00408494.Proc_004091D8
|
005EE4E0   E8F3ACE1FF             call    004091D8
005EE4E5   8B45D0                 mov     eax, [ebp-$30]
005EE4E8   50                     push    eax
005EE4E9   8D55C8                 lea     edx, [ebp-$38]
005EE4EC   8B45F8                 mov     eax, [ebp-$08]

* Reference to: Unit_00408494.Proc_004091D8
|
005EE4EF   E8E4ACE1FF             call    004091D8
005EE4F4   8B45C8                 mov     eax, [ebp-$38]
005EE4F7   5A                     pop     edx

* Reference to: System.@LStrPos;
|
005EE4F8   E85F6CE1FF             call    0040515C
005EE4FD   85C0                   test    eax, eax
005EE4FF   0F8E6E020000           jle     005EE773
005EE505   8D5601                 lea     edx, [esi+$01]

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE508   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
005EE50E   E8BDF3EEFF             call    004DD8D0

* Reference to pointer to GlobalVar_0061DF08
|
005EE513   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE518   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0944
|
005EE51A   8B8044090000           mov     eax, [eax+$0944]
005EE520   8B10                   mov     edx, [eax]
005EE522   FF5258                 call    dword ptr [edx+$58]
005EE525   8D55C4                 lea     edx, [ebp-$3C]

* Reference to: Unit_00408494.Proc_00409950
|
005EE528   E823B4E1FF             call    00409950
005EE52D   8B45C4                 mov     eax, [ebp-$3C]
005EE530   50                     push    eax
005EE531   8BCE                   mov     ecx, esi
005EE533   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE535   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE53B   E8BC15EFFF             call    004DFAFC
005EE540   8D55BC                 lea     edx, [ebp-$44]

* Reference to pointer to GlobalVar_0061DF08
|
005EE543   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE548   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0950
|
005EE54A   8B8050090000           mov     eax, [eax+$0950]
005EE550   8B08                   mov     ecx, [eax]
005EE552   FF5160                 call    dword ptr [ecx+$60]
005EE555   FF75BC                 push    dword ptr [ebp-$44]
005EE558   68E8E95E00             push    $005EE9E8
005EE55D   8D55B8                 lea     edx, [ebp-$48]

* Reference to pointer to GlobalVar_0061DF08
|
005EE560   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE565   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0954
|
005EE567   8B8054090000           mov     eax, [eax+$0954]
005EE56D   8B08                   mov     ecx, [eax]
005EE56F   FF5160                 call    dword ptr [ecx+$60]
005EE572   FF75B8                 push    dword ptr [ebp-$48]
005EE575   8D45C0                 lea     eax, [ebp-$40]
005EE578   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005EE57D   E85E69E1FF             call    00404EE0
005EE582   8B45C0                 mov     eax, [ebp-$40]
005EE585   50                     push    eax
005EE586   8BCE                   mov     ecx, esi
005EE588   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE58D   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE593   E86415EFFF             call    004DFAFC
005EE598   8D55B0                 lea     edx, [ebp-$50]

* Reference to pointer to GlobalVar_0061DF08
|
005EE59B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE5A0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_096C
|
005EE5A2   8B806C090000           mov     eax, [eax+$096C]
005EE5A8   8B08                   mov     ecx, [eax]
005EE5AA   FF5160                 call    dword ptr [ecx+$60]
005EE5AD   8B45B0                 mov     eax, [ebp-$50]
005EE5B0   8D55B4                 lea     edx, [ebp-$4C]

* Reference to: Unit_00408494.Proc_00409448
|
005EE5B3   E890AEE1FF             call    00409448
005EE5B8   837DB400               cmp     dword ptr [ebp-$4C], +$00
005EE5BC   763D                   jbe     005EE5FB
005EE5BE   8D55A8                 lea     edx, [ebp-$58]

* Reference to pointer to GlobalVar_0061DF08
|
005EE5C1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE5C6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_096C
|
005EE5C8   8B806C090000           mov     eax, [eax+$096C]
005EE5CE   8B08                   mov     ecx, [eax]
005EE5D0   FF5160                 call    dword ptr [ecx+$60]
005EE5D3   8B4DA8                 mov     ecx, [ebp-$58]
005EE5D6   8D45AC                 lea     eax, [ebp-$54]

* Possible String Reference to: '* '
|
005EE5D9   BA00EA5E00             mov     edx, $005EEA00

* Reference to: System.@LStrCat3;
|
005EE5DE   E88968E1FF             call    00404E6C
005EE5E3   8B45AC                 mov     eax, [ebp-$54]
005EE5E6   50                     push    eax
005EE5E7   8BCE                   mov     ecx, esi
005EE5E9   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE5EE   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE5F4   E80315EFFF             call    004DFAFC
005EE5F9   EB61                   jmp     005EE65C
005EE5FB   8D55A0                 lea     edx, [ebp-$60]

* Reference to pointer to GlobalVar_0061DF08
|
005EE5FE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE603   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_097C
|
005EE605   8B807C090000           mov     eax, [eax+$097C]
005EE60B   8B08                   mov     ecx, [eax]
005EE60D   FF5160                 call    dword ptr [ecx+$60]
005EE610   8B45A0                 mov     eax, [ebp-$60]
005EE613   8D55A4                 lea     edx, [ebp-$5C]

* Reference to: Unit_00408494.Proc_00409448
|
005EE616   E82DAEE1FF             call    00409448
005EE61B   837DA400               cmp     dword ptr [ebp-$5C], +$00
005EE61F   763B                   jbe     005EE65C
005EE621   8D5598                 lea     edx, [ebp-$68]

* Reference to pointer to GlobalVar_0061DF08
|
005EE624   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE629   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_097C
|
005EE62B   8B807C090000           mov     eax, [eax+$097C]
005EE631   8B08                   mov     ecx, [eax]
005EE633   FF5160                 call    dword ptr [ecx+$60]
005EE636   8B4D98                 mov     ecx, [ebp-$68]
005EE639   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: '~ '
|
005EE63C   BA0CEA5E00             mov     edx, $005EEA0C

* Reference to: System.@LStrCat3;
|
005EE641   E82668E1FF             call    00404E6C
005EE646   8B459C                 mov     eax, [ebp-$64]
005EE649   50                     push    eax
005EE64A   8BCE                   mov     ecx, esi
005EE64C   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE651   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE657   E8A014EFFF             call    004DFAFC
005EE65C   8D5590                 lea     edx, [ebp-$70]

* Reference to pointer to GlobalVar_0061DF08
|
005EE65F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE664   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0490
|
005EE666   8B8090040000           mov     eax, [eax+$0490]
005EE66C   8B08                   mov     ecx, [eax]
005EE66E   FF5160                 call    dword ptr [ecx+$60]
005EE671   8B4590                 mov     eax, [ebp-$70]
005EE674   8D5594                 lea     edx, [ebp-$6C]

* Reference to: Unit_00408494.Proc_00409448
|
005EE677   E8CCADE1FF             call    00409448
005EE67C   837D9400               cmp     dword ptr [ebp-$6C], +$00
005EE680   7640                   jbe     005EE6C2
005EE682   8D5588                 lea     edx, [ebp-$78]

* Reference to pointer to GlobalVar_0061DF08
|
005EE685   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE68A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0490
|
005EE68C   8B8090040000           mov     eax, [eax+$0490]
005EE692   8B08                   mov     ecx, [eax]
005EE694   FF5160                 call    dword ptr [ecx+$60]
005EE697   8B4D88                 mov     ecx, [ebp-$78]
005EE69A   8D458C                 lea     eax, [ebp-$74]

* Possible String Reference to: 'ooS '
|
005EE69D   BA18EA5E00             mov     edx, $005EEA18

* Reference to: System.@LStrCat3;
|
005EE6A2   E8C567E1FF             call    00404E6C
005EE6A7   8B458C                 mov     eax, [ebp-$74]
005EE6AA   50                     push    eax
005EE6AB   8BCE                   mov     ecx, esi
005EE6AD   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE6B2   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE6B8   E83F14EFFF             call    004DFAFC
005EE6BD   E9B0000000             jmp     005EE772
005EE6C2   8D5584                 lea     edx, [ebp-$7C]

* Reference to pointer to GlobalVar_0061DF08
|
005EE6C5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE6CA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_049C
|
005EE6CC   8B809C040000           mov     eax, [eax+$049C]
005EE6D2   8B08                   mov     ecx, [eax]
005EE6D4   FF5160                 call    dword ptr [ecx+$60]
005EE6D7   8B5584                 mov     edx, [ebp-$7C]

* Possible String Reference to: 'Ehes'
|
005EE6DA   B828EA5E00             mov     eax, $005EEA28

* Reference to: System.@LStrPos;
|
005EE6DF   E8786AE1FF             call    0040515C
005EE6E4   85C0                   test    eax, eax
005EE6E6   7E43                   jle     005EE72B
005EE6E8   8D957CFFFFFF           lea     edx, [ebp+$FFFFFF7C]

* Reference to pointer to GlobalVar_0061DF08
|
005EE6EE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE6F3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_047C
|
005EE6F5   8B807C040000           mov     eax, [eax+$047C]
005EE6FB   8B08                   mov     ecx, [eax]
005EE6FD   FF5160                 call    dword ptr [ecx+$60]
005EE700   8B8D7CFFFFFF           mov     ecx, [ebp+$FFFFFF7C]
005EE706   8D4580                 lea     eax, [ebp-$80]

* Possible String Reference to: 'ooK '
|
005EE709   BA38EA5E00             mov     edx, $005EEA38

* Reference to: System.@LStrCat3;
|
005EE70E   E85967E1FF             call    00404E6C
005EE713   8B4580                 mov     eax, [ebp-$80]
005EE716   50                     push    eax
005EE717   8BCE                   mov     ecx, esi
005EE719   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE71E   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE724   E8D313EFFF             call    004DFAFC
005EE729   EB47                   jmp     005EE772
005EE72B   8D9574FFFFFF           lea     edx, [ebp+$FFFFFF74]

* Reference to pointer to GlobalVar_0061DF08
|
005EE731   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE736   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_047C
|
005EE738   8B807C040000           mov     eax, [eax+$047C]
005EE73E   8B08                   mov     ecx, [eax]
005EE740   FF5160                 call    dword ptr [ecx+$60]
005EE743   8B8D74FFFFFF           mov     ecx, [ebp+$FFFFFF74]
005EE749   8D8578FFFFFF           lea     eax, [ebp+$FFFFFF78]

* Possible String Reference to: 'o-o '
|
005EE74F   BA48EA5E00             mov     edx, $005EEA48

* Reference to: System.@LStrCat3;
|
005EE754   E81367E1FF             call    00404E6C
005EE759   8B8578FFFFFF           mov     eax, [ebp+$FFFFFF78]
005EE75F   50                     push    eax
005EE760   8BCE                   mov     ecx, esi
005EE762   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE767   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE76D   E88A13EFFF             call    004DFAFC
005EE772   46                     inc     esi

* Reference to pointer to GlobalVar_0061DF08
|
005EE773   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE778   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE77A   8B80E8000000           mov     eax, [eax+$00E8]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005EE780   E8670DECFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005EE785   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE78A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE78C   8B80E8000000           mov     eax, [eax+$00E8]
005EE792   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EE799   751A                   jnz     005EE7B5

* Reference to pointer to GlobalVar_0061DF08
|
005EE79B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE7A0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE7A2   8B80E8000000           mov     eax, [eax+$00E8]
005EE7A8   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EE7AF   0F84E0FCFFFF           jz      005EE495

* Reference to pointer to GlobalVar_0061DF08
|
005EE7B5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE7BA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005EE7BC   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005EE7C2   E8250DECFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005EE7C7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE7CC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005EE7CE   8B809C000000           mov     eax, [eax+$009C]
005EE7D4   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EE7DB   751A                   jnz     005EE7F7

* Reference to pointer to GlobalVar_0061DF08
|
005EE7DD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE7E2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005EE7E4   8B809C000000           mov     eax, [eax+$009C]
005EE7EA   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EE7F1   0F84F7FBFFFF           jz      005EE3EE

* Reference to control TForm1.MainMenu1 : TMainMenu
|
005EE7F7   8B83F0020000           mov     eax, [ebx+$02F0]

* Reference to field TMainMenu.Items : TMenuItem
|
005EE7FD   8B4034                 mov     eax, [eax+$34]
005EE800   BA03000000             mov     edx, $00000003

* Reference to: Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;
|
005EE805   E8AA00E7FF             call    0045E8B4
005EE80A   BA05000000             mov     edx, $00000005

* Reference to: Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;
|
005EE80F   E8A000E7FF             call    0045E8B4
005EE814   33D2                   xor     edx, edx

* Reference to: Menus.TMenuItem.SetVisible(TMenuItem;Boolean);
|
005EE816   E8D100E7FF             call    0045E8EC
005EE81B   8D9570FFFFFF           lea     edx, [ebp+$FFFFFF70]
005EE821   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409448
|
005EE824   E81FACE1FF             call    00409448
005EE829   83BD70FFFFFF00         cmp     dword ptr [ebp+$FFFFFF70], +$00
005EE830   7646                   jbe     005EE878
005EE832   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]
005EE838   8B45F8                 mov     eax, [ebp-$08]

* Reference to: Unit_00408494.Proc_00409448
|
005EE83B   E808ACE1FF             call    00409448
005EE840   83BD6CFFFFFF00         cmp     dword ptr [ebp+$FFFFFF6C], +$00
005EE847   762F                   jbe     005EE878

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE849   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Controls.TControl.Show(TControl);
|
005EE84F   E8F0E6E5FF             call    0044CF44

* Reference to control TForm1.MainMenu1 : TMainMenu
|
005EE854   8B83F0020000           mov     eax, [ebx+$02F0]

* Reference to field TMainMenu.Items : TMenuItem
|
005EE85A   8B4034                 mov     eax, [eax+$34]
005EE85D   BA03000000             mov     edx, $00000003

* Reference to: Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;
|
005EE862   E84D00E7FF             call    0045E8B4
005EE867   BA05000000             mov     edx, $00000005

* Reference to: Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;
|
005EE86C   E84300E7FF             call    0045E8B4
005EE871   B201                   mov     dl, $01

* Reference to: Menus.TMenuItem.SetVisible(TMenuItem;Boolean);
|
005EE873   E87400E7FF             call    0045E8EC
005EE878   8D8564FFFFFF           lea     eax, [ebp+$FFFFFF64]
005EE87E   50                     push    eax
005EE87F   B902000000             mov     ecx, $00000002
005EE884   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE886   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005EE88C   E8FB11EFFF             call    004DFA8C
005EE891   8B8564FFFFFF           mov     eax, [ebp+$FFFFFF64]
005EE897   8D9568FFFFFF           lea     edx, [ebp+$FFFFFF68]

* Reference to: Unit_00408494.Proc_00409448
|
005EE89D   E8A6ABE1FF             call    00409448
005EE8A2   83BD68FFFFFF00         cmp     dword ptr [ebp+$FFFFFF68], +$00
005EE8A9   751A                   jnz     005EE8C5

* Possible String Reference to: 'nichts gefunden'
|
005EE8AB   6858EA5E00             push    $005EEA58
005EE8B0   B902000000             mov     ecx, $00000002
005EE8B5   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005EE8BA   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005EE8C0   E83712EFFF             call    004DFAFC

* Reference to pointer to GlobalVar_0061DF08
|
005EE8C5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE8CA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005EE8CC   8B80E8000000           mov     eax, [eax+$00E8]
005EE8D2   33D2                   xor     edx, edx

* Reference to: DBTables.TTable.SetDataSource(TTable;TDataSource);
|
005EE8D4   E8CF4FEEFF             call    004D38A8

* Reference to pointer to GlobalVar_0061DF08
|
005EE8D9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE8DE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EE8E0   8B405C                 mov     eax, [eax+$5C]
005EE8E3   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EE8E5   E87242EEFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005EE8EA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE8EF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EE8F1   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EE8F4   E8DB08ECFF             call    004AF1D4
005EE8F9   8B45F4                 mov     eax, [ebp-$0C]
005EE8FC   8945D4                 mov     [ebp-$2C], eax
005EE8FF   C645D800               mov     byte ptr [ebp-$28], $00
005EE903   8D55D4                 lea     edx, [ebp-$2C]

* Reference to pointer to GlobalVar_0061DF08
|
005EE906   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EE90B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EE90D   8B405C                 mov     eax, [eax+$5C]
005EE910   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005EE912   E84D49EEFF             call    004D3264
005EE917   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005EE919   E87E5AFEFF             call    005D439C
005EE91E   33C0                   xor     eax, eax
005EE920   5A                     pop     edx
005EE921   59                     pop     ecx
005EE922   59                     pop     ecx
005EE923   648910                 mov     fs:[eax], edx

****** FINALLY
|
005EE926   685DE95E00             push    $005EE95D
005EE92B   8D8564FFFFFF           lea     eax, [ebp+$FFFFFF64]
005EE931   BA1C000000             mov     edx, $0000001C

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EE936   E85162E1FF             call    00404B8C
005EE93B   8D45DC                 lea     eax, [ebp-$24]
005EE93E   BA06000000             mov     edx, $00000006

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EE943   E84462E1FF             call    00404B8C
005EE948   8D45F8                 lea     eax, [ebp-$08]
005EE94B   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EE950   E83762E1FF             call    00404B8C
005EE955   C3                     ret


* Reference to: System.@HandleFinally;
|
005EE956   E9715BE1FF             jmp     004044CC
005EE95B   EBCE                   jmp     005EE92B

****** END
|
005EE95D   5F                     pop     edi
005EE95E   5E                     pop     esi
005EE95F   5B                     pop     ebx
005EE960   8BE5                   mov     esp, ebp
005EE962   5D                     pop     ebp
005EE963   C3                     ret

*)
end;

procedure TForm1.anzeigen1Click(Sender : TObject);
begin
  PageControl1.ActivePage := TabSheet2;
  PersonEditFrame.ShowSearchGrid;
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061DF08; GlobalVar_0061DFDC; GlobalVar_0061E0B4
Unresolved field offsets: OFFS_005C; OFFS_00E8; OFFS_0350
Project calls: class TForm18; TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetVisible(TControl;Boolean);; Dialogs.ShowMessage(AnsiString);;
    Forms.TCustomForm.Create(TCustomForm;boolean;TComponent);;
    Forms.TCustomForm.Release(TCustomForm);; method TMenuItem.Click()
Strings/files/dialog text: 'Keine Daten verf�gbar.'; 'Over'; '���a'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.GlobaleSuche1Click(Sender : TObject);
begin
(*
005FB1FC   55                     push    ebp
005FB1FD   8BEC                   mov     ebp, esp
005FB1FF   53                     push    ebx
005FB200   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FB202   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FB208   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FB20E   E8A54BE8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005FB213   8B831C060000           mov     eax, [ebx+$061C]
005FB219   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FB21B   FF5244                 call    dword ptr [edx+$44]
005FB21E   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005FB220   E877C7FDFF             call    005D799C

* Reference to pointer to GlobalVar_0061E0B4
|
005FB225   A1ECC66100             mov     eax, dword ptr [$0061C6EC]
005FB22A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0B4.OFFS_0350
|
005FB22C   8B8050030000           mov     eax, [eax+$0350]
005FB232   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FB234   E8EB16E5FF             call    0044C924

* Reference to pointer to GlobalVar_0061DF08
|
005FB239   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FB23E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FB240   8B405C                 mov     eax, [eax+$5C]
005FB243   8B10                   mov     edx, [eax]
005FB245   FF924C010000           call    dword ptr [edx+$014C]
005FB24B   48                     dec     eax
005FB24C   7F0D                   jnle    005FB25B

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005FB24E   B8E8B25F00             mov     eax, $005FB2E8

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FB253   E88CA5E4FF             call    004457E4
005FB258   5B                     pop     ebx
005FB259   5D                     pop     ebp
005FB25A   C3                     ret

005FB25B   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Over'
|
005FB260   BA08B35F00             mov     edx, $005FB308

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FB265   E85299E0FF             call    00404BBC
005FB26A   33C0                   xor     eax, eax
005FB26C   55                     push    ebp
005FB26D   68B7B25F00             push    $005FB2B7

***** TRY
|
005FB272   64FF30                 push    dword ptr fs:[eax]
005FB275   648920                 mov     fs:[eax], esp
005FB278   8BCB                   mov     ecx, ebx
005FB27A   B201                   mov     dl, $01

* Reference to class TForm18
|
005FB27C   A184525400             mov     eax, dword ptr [$00545284]

* Reference to: Forms.TCustomForm.Create(TCustomForm;boolean;TComponent);
|
005FB281   E836A4E6FF             call    004656BC

* Reference to pointer to GlobalVar_0061DFDC
|
005FB286   8B15B4C16100           mov     edx, [$0061C1B4]
005FB28C   8902                   mov     [edx], eax

* Reference to pointer to GlobalVar_0061DFDC
|
005FB28E   A1B4C16100             mov     eax, dword ptr [$0061C1B4]
005FB293   8B00                   mov     eax, [eax]
005FB295   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061DFDC.OFFS_00E8
|
005FB297   FF92E8000000           call    dword ptr [edx+$00E8]
005FB29D   33C0                   xor     eax, eax
005FB29F   5A                     pop     edx
005FB2A0   59                     pop     ecx
005FB2A1   59                     pop     ecx
005FB2A2   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '���a'
|
005FB2A5   68BEB25F00             push    $005FB2BE

* Reference to pointer to GlobalVar_0061DFDC
|
005FB2AA   A1B4C16100             mov     eax, dword ptr [$0061C1B4]
005FB2AF   8B00                   mov     eax, [eax]

* Reference to: Forms.TCustomForm.Release(TCustomForm);
|
005FB2B1   E81AEAE6FF             call    00469CD0
005FB2B6   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Image1 (TImage); Image2 (TImage); Label1 (TLabel); Label2 (TLabel); Label3 (TLabel);
    Label4 (TLabel); Label5 (TLabel); Label7 (TLabel); Label8 (TLabel); Label9 (TLabel); Timer1
    (N.A.); Form1
Database/provider: DB.TDataSet.Close(TDataSet);; DB.TDataSet.Open(TDataSet);;
    QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);;
    QuickRpt.TQuickRep.SetDataSet(TQuickRep;TDataSet);
Global state: GlobalVar_0061DF08; GlobalVar_0061DF10; GlobalVar_0061E0B4
Unresolved field offsets: OFFS_0068; OFFS_00EC; OFFS_0258; OFFS_02A8; OFFS_02AC; OFFS_02BC;
    OFFS_0324; OFFS_0328; OFFS_032C; OFFS_0330; OFFS_0334; OFFS_0338; OFFS_033C; OFFS_0340;
    OFFS_0344; OFFS_0348; OFFS_0350; OFFS_0354; OFFS_0358; OFFS_035C; OFFS_0360; OFFS_0364;
    OFFS_0368; OFFS_64
Framework/API calls: Controls.TControl.SetHeight(TControl;Integer);;
    Controls.TControl.SetLeft(TControl;Integer);; Controls.TControl.SetTop(TControl;Integer);;
    Controls.TControl.SetVisible(TControl;Boolean);; Controls.TControl.SetWidth(TControl;Integer);;
    Dialogs.InputQuery(AnsiString;AnsiString;AnsiString;AnsiString):Boolean;;
    Dialogs.ShowMessage(AnsiString);; Graphics.TFont.SetSize(TFont;Integer);;
    Graphics.TFont.SetStyle(TFont;TFontStyles);; method TImage.SetEnabled(Boolean); method
    TLabel.SetEnabled(Boolean); QRCtrls.TQRCustomLabel.SetCaption(TQRCustomLabel;AnsiString);;
    QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);;
    QuickRpt.TCustomQuickRep.Preview(TCustomQuickRep);;
    QuickRpt.TQRPage.SetColumns(TQRPage;Integer);;
    QuickRpt.TQRPage.SetOrientation(TQRPage;TPrinterOrientation);
Strings/files/dialog text: '[Y]�'; 'gebjahr'; 'gebmonat'; 'gebort'; 'gebtag'; 'Globale Suche';
    'hjahr'; 'hmonat'; 'hname'; 'hort'; 'htag'; 'Keine Suchergebnisse vorhanden.'; 'name'; 'Nr.
    Name; 'nummer'; 'Over'; 'stjahr'; 'stmonat'; 'stort'; 'sttag'; '�berschrift: '; '������[Y]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.drucken1Click(Sender : TObject);
begin
(*
00603C90   55                     push    ebp
00603C91   8BEC                   mov     ebp, esp
00603C93   6A00                   push    $00
00603C95   53                     push    ebx

* Reference to pointer to GlobalVar_0061DF10
|
00603C96   8B1DF4C76100           mov     ebx, [$0061C7F4]
00603C9C   33C0                   xor     eax, eax
00603C9E   55                     push    ebp

* Possible String Reference to: '������[Y]�'
|
00603C9F   681F466000             push    $0060461F

***** TRY
|
00603CA4   64FF30                 push    dword ptr fs:[eax]
00603CA7   648920                 mov     fs:[eax], esp
00603CAA   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Over'
|
00603CAF   BA34466000             mov     edx, $00604634

* Reference to: System.@LStrAsg(void;void;void;void);
|
00603CB4   E8030FE0FF             call    00404BBC
00603CB9   8D45FC                 lea     eax, [ebp-$04]

* Reference to: System.@LStrClr(void;void);
|
00603CBC   E8A70EE0FF             call    00404B68

* Reference to pointer to GlobalVar_0061DF08
|
00603CC1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603CC6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603CC8   8B80EC000000           mov     eax, [eax+$00EC]
00603CCE   8B10                   mov     edx, [eax]
00603CD0   FF924C010000           call    dword ptr [edx+$014C]
00603CD6   85C0                   test    eax, eax
00603CD8   0F8E21090000           jle     006045FF
00603CDE   8D4DFC                 lea     ecx, [ebp-$04]

* Possible String Reference to: '�berschrift: '
|
00603CE1   BA44466000             mov     edx, $00604644

* Possible String Reference to: 'Globale Suche'
|
00603CE6   B85C466000             mov     eax, $0060465C

* Reference to: Dialogs.InputQuery(AnsiString;AnsiString;AnsiString;AnsiString):Boolean;
|
00603CEB   E8181BE4FF             call    00445808
00603CF0   84C0                   test    al, al
00603CF2   0F8411090000           jz      00604609
00603CF8   B830595302             mov     eax, $02535930
00603CFD   8B55FC                 mov     edx, [ebp-$04]

* Reference to: System.@LStrAsg(void;void;void;void);
|
00603D00   E8B70EE0FF             call    00404BBC
00603D05   B834595302             mov     eax, $02535934

* Possible String Reference to: 'Nr.       Name                     
|                                            geb.am     in          
|                                                   gest.am     in  
|                                                          geh.am.  
|                                      in                           
|                                  den/die'
|
00603D0A   BA74466000             mov     edx, $00604674

* Reference to: System.@LStrAsg(void;void;void;void);
|
00603D0F   E8A80EE0FF             call    00404BBC

* Reference to pointer to GlobalVar_0061DF08
|
00603D14   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603D19   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603D1B   8B80EC000000           mov     eax, [eax+$00EC]

* Reference to: DB.TDataSet.Close(TDataSet);
|
00603D21   E86E8FEAFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
00603D26   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603D2B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603D2D   8B90EC000000           mov     edx, [eax+$00EC]
00603D33   8B03                   mov     eax, [ebx]

* Reference to control Label1 : TLabel
|
00603D35   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to: QuickRpt.TQuickRep.SetDataSet(TQuickRep;TDataSet);
|
00603D3B   E8C872F1FF             call    0051B008
00603D40   8B03                   mov     eax, [ebx]

* Reference to control Label1 : TLabel
|
00603D42   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to field TLabel.OFFS_02BC
|
00603D48   8B80BC020000           mov     eax, [eax+$02BC]
00603D4E   B201                   mov     dl, $01

* Reference to: QuickRpt.TQRPage.SetOrientation(TQRPage;TPrinterOrientation);
|
00603D50   E80F1BF1FF             call    00515864
00603D55   8B03                   mov     eax, [ebx]

* Reference to control Label1 : TLabel
|
00603D57   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to field TLabel.OFFS_02BC
|
00603D5D   8B80BC020000           mov     eax, [eax+$02BC]
00603D63   BA01000000             mov     edx, $00000001

* Reference to: QuickRpt.TQRPage.SetColumns(TQRPage;Integer);
|
00603D68   E82B1AF1FF             call    00515798
00603D6D   8B03                   mov     eax, [ebx]

* Reference to control Label9 : TLabel
|
00603D6F   8B8010030000           mov     eax, [eax+$0310]
00603D75   33D2                   xor     edx, edx
00603D77   8B08                   mov     ecx, [eax]

* Reference to method TLabel.SetEnabled(Boolean)
|
00603D79   FF5164                 call    dword ptr [ecx+$64]
00603D7C   8B03                   mov     eax, [ebx]

* Reference to control Label9 : TLabel
|
00603D7E   8B8010030000           mov     eax, [eax+$0310]

* Reference to field TLabel.OFFS_0258
|
00603D84   8B8058020000           mov     eax, [eax+$0258]
00603D8A   8B10                   mov     edx, [eax]
00603D8C   FF5244                 call    dword ptr [edx+$44]
00603D8F   8B03                   mov     eax, [ebx]

* Reference to control Label3 : TLabel
|
00603D91   8B80FC020000           mov     eax, [eax+$02FC]

* Reference to field TLabel.Font : TFont
|
00603D97   8B4068                 mov     eax, [eax+$68]
00603D9A   8A1530476000           mov     dl, byte ptr [$00604730]

* Reference to: Graphics.TFont.SetStyle(TFont;TFontStyles);
|
00603DA0   E84F22E2FF             call    00425FF4
00603DA5   8B03                   mov     eax, [ebx]

* Reference to field TFont.OFFS_0350
|
00603DA7   8B8050030000           mov     eax, [eax+$0350]
00603DAD   B201                   mov     dl, $01
00603DAF   8B08                   mov     ecx, [eax]
00603DB1   FF5164                 call    dword ptr [ecx+$64]
00603DB4   8B03                   mov     eax, [ebx]
00603DB6   8B8054030000           mov     eax, [eax+$0354]
00603DBC   B201                   mov     dl, $01
00603DBE   8B08                   mov     ecx, [eax]
00603DC0   FF5164                 call    dword ptr [ecx+$64]
00603DC3   8B03                   mov     eax, [ebx]

* Reference to control Image2 : TImage
|
00603DC5   8B800C030000           mov     eax, [eax+$030C]
00603DCB   B201                   mov     dl, $01
00603DCD   8B08                   mov     ecx, [eax]

* Reference to method TImage.SetEnabled(Boolean)
|
00603DCF   FF5164                 call    dword ptr [ecx+$64]
00603DD2   8B03                   mov     eax, [ebx]

* Reference to control Label8 : TLabel
|
00603DD4   8B801C030000           mov     eax, [eax+$031C]
00603DDA   B201                   mov     dl, $01
00603DDC   8B08                   mov     ecx, [eax]

* Reference to method TLabel.SetEnabled(Boolean)
|
00603DDE   FF5164                 call    dword ptr [ecx+$64]
00603DE1   8B03                   mov     eax, [ebx]

* Reference to control Timer1 : N.A.
|
00603DE3   8B8020030000           mov     eax, [eax+$0320]
00603DE9   B201                   mov     dl, $01
00603DEB   8B08                   mov     ecx, [eax]

* Possible reference to virtual method TN.A..OFFS_64
|
00603DED   FF5164                 call    dword ptr [ecx+$64]
00603DF0   8B03                   mov     eax, [ebx]

* Reference to field N.A..OFFS_0324
|
00603DF2   8B8024030000           mov     eax, [eax+$0324]
00603DF8   B201                   mov     dl, $01
00603DFA   8B08                   mov     ecx, [eax]
00603DFC   FF5164                 call    dword ptr [ecx+$64]
00603DFF   8B03                   mov     eax, [ebx]
00603E01   8B8028030000           mov     eax, [eax+$0328]
00603E07   B201                   mov     dl, $01
00603E09   8B08                   mov     ecx, [eax]
00603E0B   FF5164                 call    dword ptr [ecx+$64]
00603E0E   8B03                   mov     eax, [ebx]
00603E10   8B802C030000           mov     eax, [eax+$032C]
00603E16   B201                   mov     dl, $01
00603E18   8B08                   mov     ecx, [eax]
00603E1A   FF5164                 call    dword ptr [ecx+$64]
00603E1D   8B03                   mov     eax, [ebx]
00603E1F   8B8030030000           mov     eax, [eax+$0330]
00603E25   B201                   mov     dl, $01
00603E27   8B08                   mov     ecx, [eax]
00603E29   FF5164                 call    dword ptr [ecx+$64]
00603E2C   8B03                   mov     eax, [ebx]
00603E2E   8B8034030000           mov     eax, [eax+$0334]
00603E34   B201                   mov     dl, $01
00603E36   8B08                   mov     ecx, [eax]
00603E38   FF5164                 call    dword ptr [ecx+$64]
00603E3B   8B03                   mov     eax, [ebx]
00603E3D   8B8038030000           mov     eax, [eax+$0338]
00603E43   B201                   mov     dl, $01
00603E45   8B08                   mov     ecx, [eax]
00603E47   FF5164                 call    dword ptr [ecx+$64]
00603E4A   8B03                   mov     eax, [ebx]
00603E4C   8B803C030000           mov     eax, [eax+$033C]
00603E52   B201                   mov     dl, $01
00603E54   8B08                   mov     ecx, [eax]
00603E56   FF5164                 call    dword ptr [ecx+$64]
00603E59   8B03                   mov     eax, [ebx]
00603E5B   8B8040030000           mov     eax, [eax+$0340]
00603E61   B201                   mov     dl, $01
00603E63   8B08                   mov     ecx, [eax]
00603E65   FF5164                 call    dword ptr [ecx+$64]
00603E68   8B03                   mov     eax, [ebx]
00603E6A   8B8044030000           mov     eax, [eax+$0344]
00603E70   B201                   mov     dl, $01
00603E72   8B08                   mov     ecx, [eax]
00603E74   FF5164                 call    dword ptr [ecx+$64]
00603E77   8B03                   mov     eax, [ebx]
00603E79   8B8048030000           mov     eax, [eax+$0348]
00603E7F   B201                   mov     dl, $01
00603E81   8B08                   mov     ecx, [eax]
00603E83   FF5164                 call    dword ptr [ecx+$64]
00603E86   8B03                   mov     eax, [ebx]

* Reference to control Label4 : TLabel
|
00603E88   8B8000030000           mov     eax, [eax+$0300]
00603E8E   BAD4030000             mov     edx, $000003D4

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
00603E93   E80083E4FF             call    0044C198
00603E98   8B03                   mov     eax, [ebx]

* Reference to field TLabel.OFFS_0364
|
00603E9A   8B8064030000           mov     eax, [eax+$0364]
00603EA0   BAD4030000             mov     edx, $000003D4

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
00603EA5   E8EE82E4FF             call    0044C198
00603EAA   8B03                   mov     eax, [ebx]

* Reference to control Label5 : TLabel
|
00603EAC   8B8004030000           mov     eax, [eax+$0304]
00603EB2   B201                   mov     dl, $01
00603EB4   8B08                   mov     ecx, [eax]

* Reference to method TLabel.SetEnabled(Boolean)
|
00603EB6   FF5164                 call    dword ptr [ecx+$64]
00603EB9   8B03                   mov     eax, [ebx]

* Reference to control Label5 : TLabel
|
00603EBB   8B8004030000           mov     eax, [eax+$0304]
00603EC1   BAD4030000             mov     edx, $000003D4

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
00603EC6   E8CD82E4FF             call    0044C198
00603ECB   8B03                   mov     eax, [ebx]

* Reference to field TLabel.OFFS_0368
|
00603ECD   8B8068030000           mov     eax, [eax+$0368]

* Possible String Reference to: 'Globale Suche'
|
00603ED3   BA5C466000             mov     edx, $0060465C

* Reference to: QRCtrls.TQRCustomLabel.SetCaption(TQRCustomLabel;AnsiString);
|
00603ED8   E877A2F0FF             call    0050E154

* Reference to pointer to GlobalVar_0061DF08
|
00603EDD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603EE2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603EE4   8B90EC000000           mov     edx, [eax+$00EC]
00603EEA   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_0350
|
00603EEC   8B8050030000           mov     eax, [eax+$0350]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603EF2   E869A4F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603EF7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603EFC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603EFE   8B90EC000000           mov     edx, [eax+$00EC]
00603F04   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_0354
|
00603F06   8B8054030000           mov     eax, [eax+$0354]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603F0C   E84FA4F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603F11   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603F16   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603F18   8B90EC000000           mov     edx, [eax+$00EC]
00603F1E   8B03                   mov     eax, [ebx]

* Reference to control Image2 : TImage
|
00603F20   8B800C030000           mov     eax, [eax+$030C]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603F26   E835A4F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603F2B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603F30   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603F32   8B90EC000000           mov     edx, [eax+$00EC]
00603F38   8B03                   mov     eax, [ebx]

* Reference to control Label8 : TLabel
|
00603F3A   8B801C030000           mov     eax, [eax+$031C]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603F40   E81BA4F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603F45   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603F4A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603F4C   8B90EC000000           mov     edx, [eax+$00EC]
00603F52   8B03                   mov     eax, [ebx]

* Reference to control Timer1 : N.A.
|
00603F54   8B8020030000           mov     eax, [eax+$0320]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603F5A   E801A4F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603F5F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603F64   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603F66   8B90EC000000           mov     edx, [eax+$00EC]
00603F6C   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_0324
|
00603F6E   8B8024030000           mov     eax, [eax+$0324]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603F74   E8E7A3F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603F79   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603F7E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603F80   8B90EC000000           mov     edx, [eax+$00EC]
00603F86   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_0328
|
00603F88   8B8028030000           mov     eax, [eax+$0328]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603F8E   E8CDA3F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603F93   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603F98   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603F9A   8B90EC000000           mov     edx, [eax+$00EC]
00603FA0   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_032C
|
00603FA2   8B802C030000           mov     eax, [eax+$032C]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603FA8   E8B3A3F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603FAD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603FB2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603FB4   8B90EC000000           mov     edx, [eax+$00EC]
00603FBA   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_0330
|
00603FBC   8B8030030000           mov     eax, [eax+$0330]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603FC2   E899A3F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603FC7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603FCC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603FCE   8B90EC000000           mov     edx, [eax+$00EC]
00603FD4   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_0334
|
00603FD6   8B8034030000           mov     eax, [eax+$0334]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603FDC   E87FA3F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603FE1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00603FE6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00603FE8   8B90EC000000           mov     edx, [eax+$00EC]
00603FEE   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_0338
|
00603FF0   8B8038030000           mov     eax, [eax+$0338]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00603FF6   E865A3F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00603FFB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00604000   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00604002   8B90EC000000           mov     edx, [eax+$00EC]
00604008   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_033C
|
0060400A   8B803C030000           mov     eax, [eax+$033C]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00604010   E84BA3F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00604015   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
0060401A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
0060401C   8B90EC000000           mov     edx, [eax+$00EC]
00604022   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_0340
|
00604024   8B8040030000           mov     eax, [eax+$0340]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
0060402A   E831A3F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
0060402F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00604034   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00604036   8B90EC000000           mov     edx, [eax+$00EC]
0060403C   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_0344
|
0060403E   8B8044030000           mov     eax, [eax+$0344]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
00604044   E817A3F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF08
|
00604049   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
0060404E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
00604050   8B90EC000000           mov     edx, [eax+$00EC]
00604056   8B03                   mov     eax, [ebx]

* Reference to field GlobalVar_0061DF08.OFFS_0348
|
00604058   8B8048030000           mov     eax, [eax+$0348]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
0060405E   E8FDA2F0FF             call    0050E360
00604063   8B03                   mov     eax, [ebx]
00604065   8B8050030000           mov     eax, [eax+$0350]

* Possible String Reference to: 'name'
|
0060406B   BA3C476000             mov     edx, $0060473C

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
00604070   E80BA3F0FF             call    0050E380
00604075   8B03                   mov     eax, [ebx]
00604077   8B8054030000           mov     eax, [eax+$0354]

* Possible String Reference to: 'nummer'
|
0060407D   BA4C476000             mov     edx, $0060474C

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
00604082   E8F9A2F0FF             call    0050E380
00604087   8B03                   mov     eax, [ebx]

* Reference to control Image2 : TImage
|
00604089   8B800C030000           mov     eax, [eax+$030C]

* Possible String Reference to: 'gebtag'
|
0060408F   BA5C476000             mov     edx, $0060475C

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
00604094   E8E7A2F0FF             call    0050E380
00604099   8B03                   mov     eax, [ebx]

* Reference to control Label8 : TLabel
|
0060409B   8B801C030000           mov     eax, [eax+$031C]

* Possible String Reference to: 'gebmonat'
|
006040A1   BA6C476000             mov     edx, $0060476C

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
006040A6   E8D5A2F0FF             call    0050E380
006040AB   8B03                   mov     eax, [ebx]

* Reference to control Timer1 : N.A.
|
006040AD   8B8020030000           mov     eax, [eax+$0320]

* Possible String Reference to: 'gebjahr'
|
006040B3   BA80476000             mov     edx, $00604780

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
006040B8   E8C3A2F0FF             call    0050E380
006040BD   8B03                   mov     eax, [ebx]

* Reference to field N.A..OFFS_0324
|
006040BF   8B8024030000           mov     eax, [eax+$0324]

* Possible String Reference to: 'gebort'
|
006040C5   BA90476000             mov     edx, $00604790

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
006040CA   E8B1A2F0FF             call    0050E380
006040CF   8B03                   mov     eax, [ebx]
006040D1   8B8028030000           mov     eax, [eax+$0328]

* Possible String Reference to: 'sttag'
|
006040D7   BAA0476000             mov     edx, $006047A0

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
006040DC   E89FA2F0FF             call    0050E380
006040E1   8B03                   mov     eax, [ebx]
006040E3   8B802C030000           mov     eax, [eax+$032C]

* Possible String Reference to: 'stmonat'
|
006040E9   BAB0476000             mov     edx, $006047B0

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
006040EE   E88DA2F0FF             call    0050E380
006040F3   8B03                   mov     eax, [ebx]
006040F5   8B8030030000           mov     eax, [eax+$0330]

* Possible String Reference to: 'stjahr'
|
006040FB   BAC0476000             mov     edx, $006047C0

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
00604100   E87BA2F0FF             call    0050E380
00604105   8B03                   mov     eax, [ebx]
00604107   8B8034030000           mov     eax, [eax+$0334]

* Possible String Reference to: 'stort'
|
0060410D   BAD0476000             mov     edx, $006047D0

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
00604112   E869A2F0FF             call    0050E380
00604117   8B03                   mov     eax, [ebx]
00604119   8B8038030000           mov     eax, [eax+$0338]

* Possible String Reference to: 'htag'
|
0060411F   BAE0476000             mov     edx, $006047E0

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
00604124   E857A2F0FF             call    0050E380
00604129   8B03                   mov     eax, [ebx]
0060412B   8B803C030000           mov     eax, [eax+$033C]

* Possible String Reference to: 'hmonat'
|
00604131   BAF0476000             mov     edx, $006047F0

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
00604136   E845A2F0FF             call    0050E380
0060413B   8B03                   mov     eax, [ebx]
0060413D   8B8040030000           mov     eax, [eax+$0340]

* Possible String Reference to: 'hjahr'
|
00604143   BA00486000             mov     edx, $00604800

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
00604148   E833A2F0FF             call    0050E380
0060414D   8B03                   mov     eax, [ebx]
0060414F   8B8044030000           mov     eax, [eax+$0344]

* Possible String Reference to: 'hort'
|
00604155   BA10486000             mov     edx, $00604810

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
0060415A   E821A2F0FF             call    0050E380
0060415F   8B03                   mov     eax, [ebx]
00604161   8B8048030000           mov     eax, [eax+$0348]

* Possible String Reference to: 'hname'
|
00604167   BA20486000             mov     edx, $00604820

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
0060416C   E80FA2F0FF             call    0050E380
00604171   8B03                   mov     eax, [ebx]
00604173   8B8050030000           mov     eax, [eax+$0350]
00604179   8B4068                 mov     eax, [eax+$68]
0060417C   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
00604181   E8421EE2FF             call    00425FC8
00604186   8B03                   mov     eax, [ebx]
00604188   8B8054030000           mov     eax, [eax+$0354]
0060418E   8B4068                 mov     eax, [eax+$68]
00604191   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
00604196   E82D1EE2FF             call    00425FC8
0060419B   8B03                   mov     eax, [ebx]

* Reference to control Image2 : TImage
|
0060419D   8B800C030000           mov     eax, [eax+$030C]

* Reference to field TImage.Font : TFont
|
006041A3   8B4068                 mov     eax, [eax+$68]
006041A6   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
006041AB   E8181EE2FF             call    00425FC8
006041B0   8B03                   mov     eax, [ebx]

* Reference to control Label8 : TLabel
|
006041B2   8B801C030000           mov     eax, [eax+$031C]

* Reference to field TLabel.Font : TFont
|
006041B8   8B4068                 mov     eax, [eax+$68]
006041BB   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
006041C0   E8031EE2FF             call    00425FC8
006041C5   8B03                   mov     eax, [ebx]

* Reference to control Timer1 : N.A.
|
006041C7   8B8020030000           mov     eax, [eax+$0320]

* Reference to field N.A..OFFS_0068
|
006041CD   8B4068                 mov     eax, [eax+$68]
006041D0   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
006041D5   E8EE1DE2FF             call    00425FC8
006041DA   8B03                   mov     eax, [ebx]
006041DC   8B8024030000           mov     eax, [eax+$0324]
006041E2   8B4068                 mov     eax, [eax+$68]
006041E5   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
006041EA   E8D91DE2FF             call    00425FC8
006041EF   8B03                   mov     eax, [ebx]
006041F1   8B8028030000           mov     eax, [eax+$0328]
006041F7   8B4068                 mov     eax, [eax+$68]
006041FA   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
006041FF   E8C41DE2FF             call    00425FC8
00604204   8B03                   mov     eax, [ebx]
00604206   8B802C030000           mov     eax, [eax+$032C]
0060420C   8B4068                 mov     eax, [eax+$68]
0060420F   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
00604214   E8AF1DE2FF             call    00425FC8
00604219   8B03                   mov     eax, [ebx]
0060421B   8B8030030000           mov     eax, [eax+$0330]
00604221   8B4068                 mov     eax, [eax+$68]
00604224   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
00604229   E89A1DE2FF             call    00425FC8
0060422E   8B03                   mov     eax, [ebx]
00604230   8B8034030000           mov     eax, [eax+$0334]
00604236   8B4068                 mov     eax, [eax+$68]
00604239   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
0060423E   E8851DE2FF             call    00425FC8
00604243   8B03                   mov     eax, [ebx]
00604245   8B8038030000           mov     eax, [eax+$0338]
0060424B   8B4068                 mov     eax, [eax+$68]
0060424E   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
00604253   E8701DE2FF             call    00425FC8
00604258   8B03                   mov     eax, [ebx]
0060425A   8B803C030000           mov     eax, [eax+$033C]
00604260   8B4068                 mov     eax, [eax+$68]
00604263   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
00604268   E85B1DE2FF             call    00425FC8
0060426D   8B03                   mov     eax, [ebx]
0060426F   8B8040030000           mov     eax, [eax+$0340]
00604275   8B4068                 mov     eax, [eax+$68]
00604278   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
0060427D   E8461DE2FF             call    00425FC8
00604282   8B03                   mov     eax, [ebx]
00604284   8B8044030000           mov     eax, [eax+$0344]
0060428A   8B4068                 mov     eax, [eax+$68]
0060428D   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
00604292   E8311DE2FF             call    00425FC8
00604297   8B03                   mov     eax, [ebx]
00604299   8B8048030000           mov     eax, [eax+$0348]
0060429F   8B4068                 mov     eax, [eax+$68]
006042A2   BA08000000             mov     edx, $00000008

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
006042A7   E81C1DE2FF             call    00425FC8
006042AC   8B03                   mov     eax, [ebx]
006042AE   8B8050030000           mov     eax, [eax+$0350]
006042B4   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetTop(TControl;Integer);
|
006042B6   E8B57EE4FF             call    0044C170
006042BB   8B03                   mov     eax, [ebx]
006042BD   8B8054030000           mov     eax, [eax+$0354]
006042C3   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetTop(TControl;Integer);
|
006042C5   E8A67EE4FF             call    0044C170
006042CA   8B03                   mov     eax, [ebx]
006042CC   8B8054030000           mov     eax, [eax+$0354]
006042D2   BA0A000000             mov     edx, $0000000A

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
006042D7   E8707EE4FF             call    0044C14C
006042DC   8B03                   mov     eax, [ebx]
006042DE   8B8054030000           mov     eax, [eax+$0354]
006042E4   BA23000000             mov     edx, $00000023

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
006042E9   E8AA7EE4FF             call    0044C198
006042EE   8B03                   mov     eax, [ebx]
006042F0   8B8050030000           mov     eax, [eax+$0350]
006042F6   BA33000000             mov     edx, $00000033

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
006042FB   E84C7EE4FF             call    0044C14C
00604300   8B03                   mov     eax, [ebx]
00604302   8B8050030000           mov     eax, [eax+$0350]
00604308   BA96000000             mov     edx, $00000096

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
0060430D   E8867EE4FF             call    0044C198
00604312   8B03                   mov     eax, [ebx]

* Reference to control Image2 : TImage
|
00604314   8B800C030000           mov     eax, [eax+$030C]
0060431A   BAD2000000             mov     edx, $000000D2

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
0060431F   E8287EE4FF             call    0044C14C
00604324   8B03                   mov     eax, [ebx]

* Reference to control Image2 : TImage
|
00604326   8B800C030000           mov     eax, [eax+$030C]
0060432C   BA15000000             mov     edx, $00000015

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
00604331   E8627EE4FF             call    0044C198
00604336   8B03                   mov     eax, [ebx]

* Reference to control Label8 : TLabel
|
00604338   8B801C030000           mov     eax, [eax+$031C]
0060433E   BAE7000000             mov     edx, $000000E7

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
00604343   E8047EE4FF             call    0044C14C
00604348   8B03                   mov     eax, [ebx]

* Reference to control Label8 : TLabel
|
0060434A   8B801C030000           mov     eax, [eax+$031C]
00604350   BA10000000             mov     edx, $00000010

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
00604355   E83E7EE4FF             call    0044C198
0060435A   8B03                   mov     eax, [ebx]

* Reference to control Timer1 : N.A.
|
0060435C   8B8020030000           mov     eax, [eax+$0320]
00604362   BAF7000000             mov     edx, $000000F7

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
00604367   E8E07DE4FF             call    0044C14C
0060436C   8B03                   mov     eax, [ebx]

* Reference to control Timer1 : N.A.
|
0060436E   8B8020030000           mov     eax, [eax+$0320]
00604374   BA20000000             mov     edx, $00000020

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
00604379   E81A7EE4FF             call    0044C198
0060437E   8B03                   mov     eax, [ebx]

* Reference to field N.A..OFFS_0324
|
00604380   8B8024030000           mov     eax, [eax+$0324]
00604386   BA17010000             mov     edx, $00000117

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
0060438B   E8BC7DE4FF             call    0044C14C
00604390   8B03                   mov     eax, [ebx]
00604392   8B8024030000           mov     eax, [eax+$0324]
00604398   BA78000000             mov     edx, $00000078

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
0060439D   E8F67DE4FF             call    0044C198
006043A2   8B03                   mov     eax, [ebx]
006043A4   8B8028030000           mov     eax, [eax+$0328]
006043AA   BA90010000             mov     edx, $00000190

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
006043AF   E8987DE4FF             call    0044C14C
006043B4   8B03                   mov     eax, [ebx]
006043B6   8B8028030000           mov     eax, [eax+$0328]
006043BC   BA15000000             mov     edx, $00000015

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
006043C1   E8D27DE4FF             call    0044C198
006043C6   8B03                   mov     eax, [ebx]
006043C8   8B802C030000           mov     eax, [eax+$032C]
006043CE   BAA5010000             mov     edx, $000001A5

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
006043D3   E8747DE4FF             call    0044C14C
006043D8   8B03                   mov     eax, [ebx]
006043DA   8B802C030000           mov     eax, [eax+$032C]
006043E0   BA10000000             mov     edx, $00000010

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
006043E5   E8AE7DE4FF             call    0044C198
006043EA   8B03                   mov     eax, [ebx]
006043EC   8B8030030000           mov     eax, [eax+$0330]
006043F2   BAB5010000             mov     edx, $000001B5

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
006043F7   E8507DE4FF             call    0044C14C
006043FC   8B03                   mov     eax, [ebx]
006043FE   8B8030030000           mov     eax, [eax+$0330]
00604404   BA20000000             mov     edx, $00000020

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
00604409   E88A7DE4FF             call    0044C198
0060440E   8B03                   mov     eax, [ebx]
00604410   8B8034030000           mov     eax, [eax+$0334]
00604416   BAD6010000             mov     edx, $000001D6

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
0060441B   E82C7DE4FF             call    0044C14C
00604420   8B03                   mov     eax, [ebx]
00604422   8B8034030000           mov     eax, [eax+$0334]
00604428   BA78000000             mov     edx, $00000078

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
0060442D   E8667DE4FF             call    0044C198
00604432   8B03                   mov     eax, [ebx]
00604434   8B8038030000           mov     eax, [eax+$0338]
0060443A   BA4E020000             mov     edx, $0000024E

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
0060443F   E8087DE4FF             call    0044C14C
00604444   8B03                   mov     eax, [ebx]
00604446   8B8038030000           mov     eax, [eax+$0338]
0060444C   BA27000000             mov     edx, $00000027

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
00604451   E8427DE4FF             call    0044C198
00604456   8B03                   mov     eax, [ebx]
00604458   8B803C030000           mov     eax, [eax+$033C]
0060445E   BA74020000             mov     edx, $00000274

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
00604463   E8E47CE4FF             call    0044C14C
00604468   8B03                   mov     eax, [ebx]
0060446A   8B803C030000           mov     eax, [eax+$033C]
00604470   BA13000000             mov     edx, $00000013

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
00604475   E81E7DE4FF             call    0044C198
0060447A   8B03                   mov     eax, [ebx]
0060447C   8B8040030000           mov     eax, [eax+$0340]
00604482   BA84020000             mov     edx, $00000284

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
00604487   E8C07CE4FF             call    0044C14C
0060448C   8B03                   mov     eax, [ebx]
0060448E   8B8040030000           mov     eax, [eax+$0340]
00604494   BA23000000             mov     edx, $00000023

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
00604499   E8FA7CE4FF             call    0044C198
0060449E   8B03                   mov     eax, [ebx]
006044A0   8B8044030000           mov     eax, [eax+$0344]
006044A6   BAA4020000             mov     edx, $000002A4

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
006044AB   E89C7CE4FF             call    0044C14C
006044B0   8B03                   mov     eax, [ebx]
006044B2   8B8044030000           mov     eax, [eax+$0344]
006044B8   BA7B000000             mov     edx, $0000007B

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
006044BD   E8D67CE4FF             call    0044C198
006044C2   8B03                   mov     eax, [ebx]
006044C4   8B8048030000           mov     eax, [eax+$0348]
006044CA   BA1C030000             mov     edx, $0000031C

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
006044CF   E8787CE4FF             call    0044C14C
006044D4   8B03                   mov     eax, [ebx]
006044D6   8B8048030000           mov     eax, [eax+$0348]
006044DC   BAAF000000             mov     edx, $000000AF

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
006044E1   E8B27CE4FF             call    0044C198

* Reference to pointer to GlobalVar_0061DF08
|
006044E6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
006044EB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00EC
|
006044ED   8B80EC000000           mov     eax, [eax+$00EC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
006044F3   E89087EAFF             call    004ACC88
006044F8   8B03                   mov     eax, [ebx]

* Reference to control Label2 : TLabel
|
006044FA   8B80F8020000           mov     eax, [eax+$02F8]
00604500   8B1530595302           mov     edx, [$02535930]

* Reference to: QRCtrls.TQRCustomLabel.SetCaption(TQRCustomLabel;AnsiString);
|
00604506   E8499CF0FF             call    0050E154
0060450B   833D3459530200         cmp     dword ptr [$02535934], +$00
00604512   7625                   jbe     00604539
00604514   8B03                   mov     eax, [ebx]

* Reference to control Label3 : TLabel
|
00604516   8B80FC020000           mov     eax, [eax+$02FC]
0060451C   8B1534595302           mov     edx, [$02535934]

* Reference to: QRCtrls.TQRCustomLabel.SetCaption(TQRCustomLabel;AnsiString);
|
00604522   E82D9CF0FF             call    0050E154
00604527   8B03                   mov     eax, [ebx]

* Reference to control Image1 : TImage
|
00604529   8B80F4020000           mov     eax, [eax+$02F4]
0060452F   BA37000000             mov     edx, $00000037

* Reference to: Controls.TControl.SetHeight(TControl;Integer);
|
00604534   E8837CE4FF             call    0044C1BC
00604539   8B03                   mov     eax, [ebx]

* Reference to control Label7 : TLabel
|
0060453B   8B8008030000           mov     eax, [eax+$0308]
00604541   BA13000000             mov     edx, $00000013

* Reference to: Controls.TControl.SetHeight(TControl;Integer);
|
00604546   E8717CE4FF             call    0044C1BC
0060454B   8B03                   mov     eax, [ebx]

* Reference to control Label4 : TLabel
|
0060454D   8B8000030000           mov     eax, [eax+$0300]

* Reference to field TLabel.Width : Integer
|
00604553   8B5048                 mov     edx, [eax+$48]
00604556   83EA4B                 sub     edx, +$4B
00604559   8B03                   mov     eax, [ebx]

* Reference to field TLabel.OFFS_0360
|
0060455B   8B8060030000           mov     eax, [eax+$0360]

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
00604561   E8E67BE4FF             call    0044C14C

* Reference to pointer to GlobalVar_0061E0B4
|
00604566   A1ECC66100             mov     eax, dword ptr [$0061C6EC]
0060456B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0B4.OFFS_035C
|
0060456D   8B805C030000           mov     eax, [eax+$035C]
00604573   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
00604575   E8AA83E4FF             call    0044C924

* Reference to pointer to GlobalVar_0061E0B4
|
0060457A   A1ECC66100             mov     eax, dword ptr [$0061C6EC]
0060457F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0B4.OFFS_0358
|
00604581   8B8058030000           mov     eax, [eax+$0358]
00604587   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
00604589   E89683E4FF             call    0044C924

* Reference to pointer to GlobalVar_0061E0B4
|
0060458E   A1ECC66100             mov     eax, dword ptr [$0061C6EC]
00604593   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0B4.OFFS_0360
|
00604595   8B8060030000           mov     eax, [eax+$0360]
0060459B   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
0060459D   E88283E4FF             call    0044C924

* Reference to pointer to GlobalVar_0061E0B4
|
006045A2   A1ECC66100             mov     eax, dword ptr [$0061C6EC]
006045A7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0B4.OFFS_0350
|
006045A9   8B8050030000           mov     eax, [eax+$0350]
006045AF   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
006045B1   E86E83E4FF             call    0044C924
006045B6   8B03                   mov     eax, [ebx]
006045B8   8B8050030000           mov     eax, [eax+$0350]
006045BE   33D2                   xor     edx, edx
006045C0   8B08                   mov     ecx, [eax]
006045C2   FF91E0000000           call    dword ptr [ecx+$00E0]
006045C8   8B03                   mov     eax, [ebx]
006045CA   8B8054030000           mov     eax, [eax+$0354]
006045D0   B201                   mov     dl, $01
006045D2   8B08                   mov     ecx, [eax]
006045D4   FF91E0000000           call    dword ptr [ecx+$00E0]
006045DA   8B03                   mov     eax, [ebx]

* Reference to control Label1 : TLabel
|
006045DC   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to Form1
|
006045E2   8B1508595302           mov     edx, [$02535908]

* Reference to field TLabel.OFFS_02AC
|
006045E8   8990AC020000           mov     [eax+$02AC], edx

* Reference to field TLabel.OFFS_02A8
|
006045EE   C780A8020000C0B15F00   mov     dword ptr [eax+$02A8], $005FB1C0

* Reference to: QuickRpt.TCustomQuickRep.Preview(TCustomQuickRep);
|
006045F8   E85351F1FF             call    00519750
006045FD   EB0A                   jmp     00604609

* Possible String Reference to: 'Keine Suchergebnisse vorhanden.'
|
006045FF   B830486000             mov     eax, $00604830

* Reference to: Dialogs.ShowMessage(AnsiString);
|
00604604   E8DB11E4FF             call    004457E4
00604609   33C0                   xor     eax, eax
0060460B   5A                     pop     edx
0060460C   59                     pop     ecx
0060460D   59                     pop     ecx
0060460E   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '[Y]�'
|
00604611   6826466000             push    $00604626
00604616   8D45FC                 lea     eax, [ebp-$04]

* Reference to: System.@LStrClr(void;void);
|
00604619   E84A05E0FF             call    00404B68
0060461E   C3                     ret


* Reference to: System.@HandleFinally;
|
0060461F   E9A8FEDFFF             jmp     004044CC
00604624   EBF0                   jmp     00604616

****** END
|
00604626   5B                     pop     ebx
00604627   59                     pop     ecx
00604628   5D                     pop     ebp
00604629   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Label3 (TLabel); Form1
Global state: GlobalVar_0061DF08; GlobalVar_025353D8
Unresolved field offsets: OFFS_00E8; OFFS_0480; OFFS_048C; OFFS_0540; OFFS_0544
Project calls: TForm1.elem(); TForm1.ucase()
Framework/API calls: Controls.TControl.SetText(TControl;TCaption);;
    Controls.TControl.Show(TControl);; System.Proc_00404EE0
Strings/files/dialog text: ' blutsverwandt mit:'; '[��]�'; 'aus'; 'Ist '; 'Verw'; '��b����[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Verwandtschaft1Click(Sender : TObject);
begin
(*
0060E0F8   55                     push    ebp
0060E0F9   8BEC                   mov     ebp, esp
0060E0FB   33C9                   xor     ecx, ecx
0060E0FD   51                     push    ecx
0060E0FE   51                     push    ecx
0060E0FF   51                     push    ecx
0060E100   51                     push    ecx
0060E101   53                     push    ebx
0060E102   8BD8                   mov     ebx, eax
0060E104   33C0                   xor     eax, eax
0060E106   55                     push    ebp

* Possible String Reference to: '��b����[��]�'
|
0060E107   68EAE16000             push    $0060E1EA

***** TRY
|
0060E10C   64FF30                 push    dword ptr fs:[eax]
0060E10F   648920                 mov     fs:[eax], esp

* Possible String Reference to: 'aus'
|
0060E112   BA00E26000             mov     edx, $0060E200

* Reference to Form1
|
0060E117   A108595302             mov     eax, dword ptr [$02535908]

* Reference to : TForm1.elem()
|
0060E11C   E843A2FDFF             call    005E8364

* Possible String Reference to: 'Ist '
|
0060E121   680CE26000             push    $0060E20C
0060E126   8D55F4                 lea     edx, [ebp-$0C]

* Reference to pointer to GlobalVar_0061DF08
|
0060E129   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
0060E12E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0540
|
0060E130   8B8040050000           mov     eax, [eax+$0540]
0060E136   8B08                   mov     ecx, [eax]
0060E138   FF5160                 call    dword ptr [ecx+$60]
0060E13B   8B55F4                 mov     edx, [ebp-$0C]
0060E13E   8D4DF8                 lea     ecx, [ebp-$08]
0060E141   8BC3                   mov     eax, ebx

* Reference to : TForm1.ucase()
|
0060E143   E8409AFCFF             call    005D7B88
0060E148   FF75F8                 push    dword ptr [ebp-$08]
0060E14B   681CE26000             push    $0060E21C
0060E150   8D55F0                 lea     edx, [ebp-$10]

* Reference to pointer to GlobalVar_0061DF08
|
0060E153   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
0060E158   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0544
|
0060E15A   8B8044050000           mov     eax, [eax+$0544]
0060E160   8B08                   mov     ecx, [eax]
0060E162   FF5160                 call    dword ptr [ecx+$60]
0060E165   FF75F0                 push    dword ptr [ebp-$10]

* Possible String Reference to: ' blutsverwandt mit:'
|
0060E168   6828E26000             push    $0060E228
0060E16D   8D45FC                 lea     eax, [ebp-$04]
0060E170   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
0060E175   E8666DDFFF             call    00404EE0
0060E17A   8B55FC                 mov     edx, [ebp-$04]

* Reference to Form1
|
0060E17D   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_048C
|
0060E182   8B808C040000           mov     eax, [eax+$048C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
0060E188   E8A7E8E3FF             call    0044CA34

* Reference to Form1
|
0060E18D   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0480
|
0060E192   8B8080040000           mov     eax, [eax+$0480]

* Reference to: Controls.TControl.Show(TControl);
|
0060E198   E8A7EDE3FF             call    0044CF44

* Reference to pointer to GlobalVar_025353D8
|
0060E19D   A168C86100             mov     eax, dword ptr [$0061C868]
0060E1A2   8B00                   mov     eax, [eax]

* Reference to control Label3 : TLabel
|
0060E1A4   8B80FC020000           mov     eax, [eax+$02FC]
0060E1AA   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
0060E1AC   E883E8E3FF             call    0044CA34
0060E1B1   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Verw'
|
0060E1B6   BA44E26000             mov     edx, $0060E244

* Reference to: System.@LStrAsg(void;void;void;void);
|
0060E1BB   E8FC69DFFF             call    00404BBC

* Reference to pointer to GlobalVar_025353D8
|
0060E1C0   A168C86100             mov     eax, dword ptr [$0061C868]
0060E1C5   8B00                   mov     eax, [eax]
0060E1C7   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_025353D8.OFFS_00E8
|
0060E1C9   FF92E8000000           call    dword ptr [edx+$00E8]
0060E1CF   33C0                   xor     eax, eax
0060E1D1   5A                     pop     edx
0060E1D2   59                     pop     ecx
0060E1D3   59                     pop     ecx
0060E1D4   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '[��]�'
|
0060E1D7   68F1E16000             push    $0060E1F1
0060E1DC   8D45F0                 lea     eax, [ebp-$10]
0060E1DF   BA04000000             mov     edx, $00000004

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
0060E1E4   E8A369DFFF             call    00404B8C
0060E1E9   C3                     ret


* Reference to: System.@HandleFinally;
|
0060E1EA   E9DD62DFFF             jmp     004044CC
0060E1EF   EBEB                   jmp     0060E1DC

****** END
|
0060E1F1   5B                     pop     ebx
0060E1F2   8BE5                   mov     esp, ebp
0060E1F4   5D                     pop     ebp
0060E1F5   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.StringGrid5
    (TStringGrid); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);;
    DB.TDataSet.Open(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_009C; OFFS_00A4; OFFS_0534; OFFS_0874; OFFS_0880; OFFS_0888;
    OFFS_089C; OFFS_08AC; OFFS_08C4
Project calls: TForm1.Proc_005D3228(); Unit_00408494.Proc_004091D8; Unit_00408494.Proc_00409448;
    Unit_00408494.Proc_00409950; Unit_00408494.Proc_004099B4
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetVisible(TControl;Boolean);;
    Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);;
    Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);; method TMenuItem.Click();
    System.Proc_00404EE0
Strings/files/dialog text: '* '; '+ '; 'Cousin(s):'; 'mut'; 'Neffe(n):'; 'num'; 'Onkel:'; 'vat';
    'Vetter(n) von '; '~ '
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Vettern1Click(Sender : TObject);
begin
(*
0060E398   55                     push    ebp
0060E399   8BEC                   mov     ebp, esp
0060E39B   B964000000             mov     ecx, $00000064
0060E3A0   6A00                   push    $00
0060E3A2   6A00                   push    $00
0060E3A4   49                     dec     ecx
0060E3A5   75F9                   jnz     0060E3A0
0060E3A7   51                     push    ecx
0060E3A8   53                     push    ebx
0060E3A9   56                     push    esi
0060E3AA   57                     push    edi
0060E3AB   8955FC                 mov     [ebp-$04], edx
0060E3AE   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
0060E3B0   8B1D3CCC6100           mov     ebx, [$0061CC3C]
0060E3B6   33C0                   xor     eax, eax
0060E3B8   55                     push    ebp
0060E3B9   68AA0B6100             push    $00610BAA

***** TRY
|
0060E3BE   64FF30                 push    dword ptr fs:[eax]
0060E3C1   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
0060E3C4   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
0060E3CA   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
0060E3D0   E8E319E7FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
0060E3D5   8B861C060000           mov     eax, [esi+$061C]
0060E3DB   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
0060E3DD   FF5244                 call    dword ptr [edx+$44]
0060E3E0   8B03                   mov     eax, [ebx]

* Reference to field TMenuItem.OFFS_0534
|
0060E3E2   8B8034050000           mov     eax, [eax+$0534]
0060E3E8   8B10                   mov     edx, [eax]
0060E3EA   FF5258                 call    dword ptr [edx+$58]
0060E3ED   8945F8                 mov     [ebp-$08], eax
0060E3F0   8B03                   mov     eax, [ebx]
0060E3F2   8B8038050000           mov     eax, [eax+$0538]
0060E3F8   8B10                   mov     edx, [eax]
0060E3FA   FF5258                 call    dword ptr [edx+$58]
0060E3FD   8945EC                 mov     [ebp-$14], eax
0060E400   8B03                   mov     eax, [ebx]
0060E402   8B803C050000           mov     eax, [eax+$053C]
0060E408   8B10                   mov     edx, [eax]
0060E40A   FF5258                 call    dword ptr [edx+$58]
0060E40D   8945E4                 mov     [ebp-$1C], eax
0060E410   8D45C4                 lea     eax, [ebp-$3C]

* Reference to: System.@LStrClr(void;void);
|
0060E413   E85067DFFF             call    00404B68
0060E418   8D45C0                 lea     eax, [ebp-$40]

* Reference to: System.@LStrClr(void;void);
|
0060E41B   E84867DFFF             call    00404B68
0060E420   8D45B8                 lea     eax, [ebp-$48]

* Reference to: System.@LStrClr(void;void);
|
0060E423   E84067DFFF             call    00404B68

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060E428   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
0060E42E   8B804C020000           mov     eax, [eax+$024C]
0060E434   48                     dec     eax
0060E435   85C0                   test    eax, eax
0060E437   7C6D                   jl      0060E4A6
0060E439   40                     inc     eax
0060E43A   8945A4                 mov     [ebp-$5C], eax
0060E43D   33FF                   xor     edi, edi
0060E43F   6A00                   push    $00
0060E441   8BCF                   mov     ecx, edi
0060E443   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060E445   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060E44B   E8AC16EDFF             call    004DFAFC
0060E450   6A00                   push    $00
0060E452   8BCF                   mov     ecx, edi
0060E454   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060E459   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060E45F   E89816EDFF             call    004DFAFC
0060E464   6A00                   push    $00
0060E466   8BCF                   mov     ecx, edi
0060E468   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060E46D   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060E473   E88416EDFF             call    004DFAFC
0060E478   6A00                   push    $00
0060E47A   8BCF                   mov     ecx, edi
0060E47C   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060E481   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060E487   E87016EDFF             call    004DFAFC
0060E48C   6A00                   push    $00
0060E48E   8BCF                   mov     ecx, edi
0060E490   BA04000000             mov     edx, $00000004

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060E495   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060E49B   E85C16EDFF             call    004DFAFC
0060E4A0   47                     inc     edi
0060E4A1   FF4DA4                 dec     dword ptr [ebp-$5C]
0060E4A4   7599                   jnz     0060E43F
0060E4A6   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060E4AB   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
0060E4B1   E81AF4ECFF             call    004DD8D0
0060E4B6   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.DockOrientation : TDockOrientation
|
0060E4B8   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
0060E4BE   E8C5E7E9FF             call    004ACC88
0060E4C3   837DEC00               cmp     dword ptr [ebp-$14], +$00
0060E4C7   7E58                   jle     0060E521
0060E4C9   8B03                   mov     eax, [ebx]

* Reference to field TDockOrientation.OFFS_009C
|
0060E4CB   8B809C000000           mov     eax, [eax+$009C]
0060E4D1   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060E4D3   E88446ECFF             call    004D2B5C
0060E4D8   8B03                   mov     eax, [ebx]
0060E4DA   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060E4E0   E8EF0CEAFF             call    004AF1D4

* Reference to Form1
|
0060E4E5   8B45EC                 mov     eax, [ebp-$14]
0060E4E8   89459C                 mov     [ebp-$64], eax
0060E4EB   C645A000               mov     byte ptr [ebp-$60], $00
0060E4EF   8D559C                 lea     edx, [ebp-$64]
0060E4F2   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_009C
|
0060E4F4   8B809C000000           mov     eax, [eax+$009C]
0060E4FA   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060E4FC   E8634DECFF             call    004D3264
0060E501   8B03                   mov     eax, [ebx]
0060E503   8B8078080000           mov     eax, [eax+$0878]
0060E509   8B10                   mov     edx, [eax]
0060E50B   FF5258                 call    dword ptr [edx+$58]
0060E50E   8945D8                 mov     [ebp-$28], eax
0060E511   8B03                   mov     eax, [ebx]
0060E513   8B807C080000           mov     eax, [eax+$087C]
0060E519   8B10                   mov     edx, [eax]
0060E51B   FF5258                 call    dword ptr [edx+$58]
0060E51E   8945D4                 mov     [ebp-$2C], eax
0060E521   837DE400               cmp     dword ptr [ebp-$1C], +$00
0060E525   7E58                   jle     0060E57F
0060E527   8B03                   mov     eax, [ebx]
0060E529   8B809C000000           mov     eax, [eax+$009C]
0060E52F   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060E531   E82646ECFF             call    004D2B5C
0060E536   8B03                   mov     eax, [ebx]
0060E538   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060E53E   E8910CEAFF             call    004AF1D4

* Reference to Form1
|
0060E543   8B45E4                 mov     eax, [ebp-$1C]
0060E546   89459C                 mov     [ebp-$64], eax
0060E549   C645A000               mov     byte ptr [ebp-$60], $00
0060E54D   8D559C                 lea     edx, [ebp-$64]
0060E550   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_009C
|
0060E552   8B809C000000           mov     eax, [eax+$009C]
0060E558   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060E55A   E8054DECFF             call    004D3264
0060E55F   8B03                   mov     eax, [ebx]
0060E561   8B8078080000           mov     eax, [eax+$0878]
0060E567   8B10                   mov     edx, [eax]
0060E569   FF5258                 call    dword ptr [edx+$58]
0060E56C   8945D0                 mov     [ebp-$30], eax
0060E56F   8B03                   mov     eax, [ebx]
0060E571   8B807C080000           mov     eax, [eax+$087C]
0060E577   8B10                   mov     edx, [eax]
0060E579   FF5258                 call    dword ptr [edx+$58]
0060E57C   8945CC                 mov     [ebp-$34], eax
0060E57F   8B03                   mov     eax, [ebx]
0060E581   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
0060E587   BAC00B6100             mov     edx, $00610BC0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060E58C   E8CB45ECFF             call    004D2B5C
0060E591   8B03                   mov     eax, [ebx]
0060E593   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060E599   E8360CEAFF             call    004AF1D4
0060E59E   837DD800               cmp     dword ptr [ebp-$28], +$00
0060E5A2   0F8E23010000           jle     0060E6CB
0060E5A8   8B45D8                 mov     eax, [ebp-$28]
0060E5AB   89459C                 mov     [ebp-$64], eax
0060E5AE   C645A000               mov     byte ptr [ebp-$60], $00
0060E5B2   8D559C                 lea     edx, [ebp-$64]
0060E5B5   8B03                   mov     eax, [ebx]
0060E5B7   8B809C000000           mov     eax, [eax+$009C]
0060E5BD   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060E5BF   E8A04CECFF             call    004D3264
0060E5C4   84C0                   test    al, al
0060E5C6   0F84FF000000           jz      0060E6CB
0060E5CC   E9E4000000             jmp     0060E6B5
0060E5D1   8B03                   mov     eax, [ebx]
0060E5D3   8B8074080000           mov     eax, [eax+$0874]
0060E5D9   8B10                   mov     edx, [eax]
0060E5DB   FF5258                 call    dword ptr [edx+$58]
0060E5DE   3B45EC                 cmp     eax, [ebp-$14]
0060E5E1   0F84B0000000           jz      0060E697
0060E5E7   8D5594                 lea     edx, [ebp-$6C]
0060E5EA   8B03                   mov     eax, [ebx]
0060E5EC   8B8088080000           mov     eax, [eax+$0888]
0060E5F2   8B08                   mov     ecx, [eax]
0060E5F4   FF5160                 call    dword ptr [ecx+$60]
0060E5F7   8B4594                 mov     eax, [ebp-$6C]
0060E5FA   8D5598                 lea     edx, [ebp-$68]

* Reference to: Unit_00408494.Proc_004091D8
|
0060E5FD   E8D6ABDFFF             call    004091D8
0060E602   8B4598                 mov     eax, [ebp-$68]
0060E605   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
0060E60A   E85569DFFF             call    00404F64
0060E60F   752F                   jnz     0060E640
0060E611   FF75C4                 push    dword ptr [ebp-$3C]
0060E614   8B03                   mov     eax, [ebx]
0060E616   8B8074080000           mov     eax, [eax+$0874]
0060E61C   8B10                   mov     edx, [eax]
0060E61E   FF5258                 call    dword ptr [edx+$58]
0060E621   8D5590                 lea     edx, [ebp-$70]

* Reference to : TForm1.Proc_005D3228()
|
0060E624   E8FF4BFCFF             call    005D3228
0060E629   FF7590                 push    dword ptr [ebp-$70]
0060E62C   68D80B6100             push    $00610BD8
0060E631   8D45C4                 lea     eax, [ebp-$3C]
0060E634   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060E639   E8A268DFFF             call    00404EE0
0060E63E   EB57                   jmp     0060E697
0060E640   8D5588                 lea     edx, [ebp-$78]
0060E643   8B03                   mov     eax, [ebx]
0060E645   8B8088080000           mov     eax, [eax+$0888]
0060E64B   8B08                   mov     ecx, [eax]
0060E64D   FF5160                 call    dword ptr [ecx+$60]
0060E650   8B4588                 mov     eax, [ebp-$78]
0060E653   8D558C                 lea     edx, [ebp-$74]

* Reference to: Unit_00408494.Proc_004091D8
|
0060E656   E87DABDFFF             call    004091D8
0060E65B   8B458C                 mov     eax, [ebp-$74]
0060E65E   BAE40B6100             mov     edx, $00610BE4

* Reference to: System.@LStrCmp;
|
0060E663   E8FC68DFFF             call    00404F64
0060E668   752D                   jnz     0060E697
0060E66A   FF75C0                 push    dword ptr [ebp-$40]
0060E66D   8B03                   mov     eax, [ebx]
0060E66F   8B8074080000           mov     eax, [eax+$0874]
0060E675   8B10                   mov     edx, [eax]
0060E677   FF5258                 call    dword ptr [edx+$58]
0060E67A   8D5584                 lea     edx, [ebp-$7C]

* Reference to : TForm1.Proc_005D3228()
|
0060E67D   E8A64BFCFF             call    005D3228
0060E682   FF7584                 push    dword ptr [ebp-$7C]
0060E685   68D80B6100             push    $00610BD8
0060E68A   8D45C0                 lea     eax, [ebp-$40]
0060E68D   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060E692   E84968DFFF             call    00404EE0
0060E697   8B03                   mov     eax, [ebx]
0060E699   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060E69F   E8480EEAFF             call    004AF4EC
0060E6A4   8B03                   mov     eax, [ebx]
0060E6A6   8B809C000000           mov     eax, [eax+$009C]
0060E6AC   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060E6B3   7516                   jnz     0060E6CB
0060E6B5   8B03                   mov     eax, [ebx]
0060E6B7   8B8078080000           mov     eax, [eax+$0878]
0060E6BD   8B10                   mov     edx, [eax]
0060E6BF   FF5258                 call    dword ptr [edx+$58]
0060E6C2   3B45D8                 cmp     eax, [ebp-$28]
0060E6C5   0F8406FFFFFF           jz      0060E5D1
0060E6CB   8B03                   mov     eax, [ebx]
0060E6CD   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
0060E6D3   BAF00B6100             mov     edx, $00610BF0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060E6D8   E87F44ECFF             call    004D2B5C
0060E6DD   8B03                   mov     eax, [ebx]
0060E6DF   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060E6E5   E8EA0AEAFF             call    004AF1D4
0060E6EA   837DD400               cmp     dword ptr [ebp-$2C], +$00
0060E6EE   0F8EBC010000           jle     0060E8B0
0060E6F4   8B45D4                 mov     eax, [ebp-$2C]
0060E6F7   89459C                 mov     [ebp-$64], eax
0060E6FA   C645A000               mov     byte ptr [ebp-$60], $00
0060E6FE   8D559C                 lea     edx, [ebp-$64]
0060E701   8B03                   mov     eax, [ebx]
0060E703   8B809C000000           mov     eax, [eax+$009C]
0060E709   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060E70B   E8544BECFF             call    004D3264
0060E710   84C0                   test    al, al
0060E712   0F8498010000           jz      0060E8B0
0060E718   E97D010000             jmp     0060E89A
0060E71D   8B03                   mov     eax, [ebx]
0060E71F   8B8074080000           mov     eax, [eax+$0874]
0060E725   8B10                   mov     edx, [eax]
0060E727   FF5258                 call    dword ptr [edx+$58]
0060E72A   3B45EC                 cmp     eax, [ebp-$14]
0060E72D   0F8449010000           jz      0060E87C
0060E733   8D957CFFFFFF           lea     edx, [ebp+$FFFFFF7C]
0060E739   8B03                   mov     eax, [ebx]
0060E73B   8B8088080000           mov     eax, [eax+$0888]
0060E741   8B08                   mov     ecx, [eax]
0060E743   FF5160                 call    dword ptr [ecx+$60]
0060E746   8B857CFFFFFF           mov     eax, [ebp+$FFFFFF7C]
0060E74C   8D5580                 lea     edx, [ebp-$80]

* Reference to: Unit_00408494.Proc_004091D8
|
0060E74F   E884AADFFF             call    004091D8
0060E754   8B4580                 mov     eax, [ebp-$80]
0060E757   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
0060E75C   E80368DFFF             call    00404F64
0060E761   7576                   jnz     0060E7D9
0060E763   8B03                   mov     eax, [ebx]
0060E765   8B8074080000           mov     eax, [eax+$0874]
0060E76B   8B10                   mov     edx, [eax]
0060E76D   FF5258                 call    dword ptr [edx+$58]
0060E770   8D9578FFFFFF           lea     edx, [ebp+$FFFFFF78]

* Reference to : TForm1.Proc_005D3228()
|
0060E776   E8AD4AFCFF             call    005D3228
0060E77B   8D8578FFFFFF           lea     eax, [ebp+$FFFFFF78]
0060E781   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
0060E786   E89D66DFFF             call    00404E28
0060E78B   8B8578FFFFFF           mov     eax, [ebp+$FFFFFF78]
0060E791   8B55C4                 mov     edx, [ebp-$3C]

* Reference to: System.@LStrPos;
|
0060E794   E8C369DFFF             call    0040515C
0060E799   85C0                   test    eax, eax
0060E79B   0F85DB000000           jnz     0060E87C
0060E7A1   FF75C4                 push    dword ptr [ebp-$3C]
0060E7A4   8B03                   mov     eax, [ebx]
0060E7A6   8B8074080000           mov     eax, [eax+$0874]
0060E7AC   8B10                   mov     edx, [eax]
0060E7AE   FF5258                 call    dword ptr [edx+$58]
0060E7B1   8D9574FFFFFF           lea     edx, [ebp+$FFFFFF74]

* Reference to : TForm1.Proc_005D3228()
|
0060E7B7   E86C4AFCFF             call    005D3228
0060E7BC   FFB574FFFFFF           push    dword ptr [ebp+$FFFFFF74]
0060E7C2   68D80B6100             push    $00610BD8
0060E7C7   8D45C4                 lea     eax, [ebp-$3C]
0060E7CA   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060E7CF   E80C67DFFF             call    00404EE0
0060E7D4   E9A3000000             jmp     0060E87C
0060E7D9   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]
0060E7DF   8B03                   mov     eax, [ebx]
0060E7E1   8B8088080000           mov     eax, [eax+$0888]
0060E7E7   8B08                   mov     ecx, [eax]
0060E7E9   FF5160                 call    dword ptr [ecx+$60]
0060E7EC   8B856CFFFFFF           mov     eax, [ebp+$FFFFFF6C]
0060E7F2   8D9570FFFFFF           lea     edx, [ebp+$FFFFFF70]

* Reference to: Unit_00408494.Proc_004091D8
|
0060E7F8   E8DBA9DFFF             call    004091D8
0060E7FD   8B8570FFFFFF           mov     eax, [ebp+$FFFFFF70]
0060E803   BAE40B6100             mov     edx, $00610BE4

* Reference to: System.@LStrCmp;
|
0060E808   E85767DFFF             call    00404F64
0060E80D   756D                   jnz     0060E87C
0060E80F   8B03                   mov     eax, [ebx]
0060E811   8B8074080000           mov     eax, [eax+$0874]
0060E817   8B10                   mov     edx, [eax]
0060E819   FF5258                 call    dword ptr [edx+$58]
0060E81C   8D9568FFFFFF           lea     edx, [ebp+$FFFFFF68]

* Reference to : TForm1.Proc_005D3228()
|
0060E822   E8014AFCFF             call    005D3228
0060E827   8D8568FFFFFF           lea     eax, [ebp+$FFFFFF68]
0060E82D   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
0060E832   E8F165DFFF             call    00404E28
0060E837   8B8568FFFFFF           mov     eax, [ebp+$FFFFFF68]
0060E83D   8B55C0                 mov     edx, [ebp-$40]

* Reference to: System.@LStrPos;
|
0060E840   E81769DFFF             call    0040515C
0060E845   85C0                   test    eax, eax
0060E847   7533                   jnz     0060E87C
0060E849   FF75C0                 push    dword ptr [ebp-$40]
0060E84C   8B03                   mov     eax, [ebx]
0060E84E   8B8074080000           mov     eax, [eax+$0874]
0060E854   8B10                   mov     edx, [eax]
0060E856   FF5258                 call    dword ptr [edx+$58]
0060E859   8D9564FFFFFF           lea     edx, [ebp+$FFFFFF64]

* Reference to : TForm1.Proc_005D3228()
|
0060E85F   E8C449FCFF             call    005D3228
0060E864   FFB564FFFFFF           push    dword ptr [ebp+$FFFFFF64]
0060E86A   68D80B6100             push    $00610BD8
0060E86F   8D45C0                 lea     eax, [ebp-$40]
0060E872   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060E877   E86466DFFF             call    00404EE0
0060E87C   8B03                   mov     eax, [ebx]
0060E87E   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060E884   E8630CEAFF             call    004AF4EC
0060E889   8B03                   mov     eax, [ebx]
0060E88B   8B809C000000           mov     eax, [eax+$009C]
0060E891   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060E898   7516                   jnz     0060E8B0
0060E89A   8B03                   mov     eax, [ebx]
0060E89C   8B807C080000           mov     eax, [eax+$087C]
0060E8A2   8B10                   mov     edx, [eax]
0060E8A4   FF5258                 call    dword ptr [edx+$58]
0060E8A7   3B45D4                 cmp     eax, [ebp-$2C]
0060E8AA   0F846DFEFFFF           jz      0060E71D
0060E8B0   8B03                   mov     eax, [ebx]
0060E8B2   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
0060E8B8   BAC00B6100             mov     edx, $00610BC0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060E8BD   E89A42ECFF             call    004D2B5C
0060E8C2   8B03                   mov     eax, [ebx]
0060E8C4   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060E8CA   E80509EAFF             call    004AF1D4
0060E8CF   837DD000               cmp     dword ptr [ebp-$30], +$00
0060E8D3   0F8EC2010000           jle     0060EA9B
0060E8D9   8B45D0                 mov     eax, [ebp-$30]
0060E8DC   89459C                 mov     [ebp-$64], eax
0060E8DF   C645A000               mov     byte ptr [ebp-$60], $00
0060E8E3   8D559C                 lea     edx, [ebp-$64]
0060E8E6   8B03                   mov     eax, [ebx]
0060E8E8   8B809C000000           mov     eax, [eax+$009C]
0060E8EE   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060E8F0   E86F49ECFF             call    004D3264
0060E8F5   84C0                   test    al, al
0060E8F7   0F849E010000           jz      0060EA9B
0060E8FD   E983010000             jmp     0060EA85
0060E902   8B03                   mov     eax, [ebx]
0060E904   8B8074080000           mov     eax, [eax+$0874]
0060E90A   8B10                   mov     edx, [eax]
0060E90C   FF5258                 call    dword ptr [edx+$58]
0060E90F   3B45E4                 cmp     eax, [ebp-$1C]
0060E912   0F844F010000           jz      0060EA67
0060E918   8D955CFFFFFF           lea     edx, [ebp+$FFFFFF5C]
0060E91E   8B03                   mov     eax, [ebx]
0060E920   8B8088080000           mov     eax, [eax+$0888]
0060E926   8B08                   mov     ecx, [eax]
0060E928   FF5160                 call    dword ptr [ecx+$60]
0060E92B   8B855CFFFFFF           mov     eax, [ebp+$FFFFFF5C]
0060E931   8D9560FFFFFF           lea     edx, [ebp+$FFFFFF60]

* Reference to: Unit_00408494.Proc_004091D8
|
0060E937   E89CA8DFFF             call    004091D8
0060E93C   8B8560FFFFFF           mov     eax, [ebp+$FFFFFF60]
0060E942   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
0060E947   E81866DFFF             call    00404F64
0060E94C   7576                   jnz     0060E9C4
0060E94E   8B03                   mov     eax, [ebx]
0060E950   8B8074080000           mov     eax, [eax+$0874]
0060E956   8B10                   mov     edx, [eax]
0060E958   FF5258                 call    dword ptr [edx+$58]
0060E95B   8D9558FFFFFF           lea     edx, [ebp+$FFFFFF58]

* Reference to : TForm1.Proc_005D3228()
|
0060E961   E8C248FCFF             call    005D3228
0060E966   8D8558FFFFFF           lea     eax, [ebp+$FFFFFF58]
0060E96C   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
0060E971   E8B264DFFF             call    00404E28
0060E976   8B8558FFFFFF           mov     eax, [ebp+$FFFFFF58]
0060E97C   8B55C4                 mov     edx, [ebp-$3C]

* Reference to: System.@LStrPos;
|
0060E97F   E8D867DFFF             call    0040515C
0060E984   85C0                   test    eax, eax
0060E986   0F85DB000000           jnz     0060EA67
0060E98C   FF75C4                 push    dword ptr [ebp-$3C]
0060E98F   8B03                   mov     eax, [ebx]
0060E991   8B8074080000           mov     eax, [eax+$0874]
0060E997   8B10                   mov     edx, [eax]
0060E999   FF5258                 call    dword ptr [edx+$58]
0060E99C   8D9554FFFFFF           lea     edx, [ebp+$FFFFFF54]

* Reference to : TForm1.Proc_005D3228()
|
0060E9A2   E88148FCFF             call    005D3228
0060E9A7   FFB554FFFFFF           push    dword ptr [ebp+$FFFFFF54]
0060E9AD   68D80B6100             push    $00610BD8
0060E9B2   8D45C4                 lea     eax, [ebp-$3C]
0060E9B5   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060E9BA   E82165DFFF             call    00404EE0
0060E9BF   E9A3000000             jmp     0060EA67
0060E9C4   8D954CFFFFFF           lea     edx, [ebp+$FFFFFF4C]
0060E9CA   8B03                   mov     eax, [ebx]
0060E9CC   8B8088080000           mov     eax, [eax+$0888]
0060E9D2   8B08                   mov     ecx, [eax]
0060E9D4   FF5160                 call    dword ptr [ecx+$60]
0060E9D7   8B854CFFFFFF           mov     eax, [ebp+$FFFFFF4C]
0060E9DD   8D9550FFFFFF           lea     edx, [ebp+$FFFFFF50]

* Reference to: Unit_00408494.Proc_004091D8
|
0060E9E3   E8F0A7DFFF             call    004091D8
0060E9E8   8B8550FFFFFF           mov     eax, [ebp+$FFFFFF50]
0060E9EE   BAE40B6100             mov     edx, $00610BE4

* Reference to: System.@LStrCmp;
|
0060E9F3   E86C65DFFF             call    00404F64
0060E9F8   756D                   jnz     0060EA67
0060E9FA   8B03                   mov     eax, [ebx]
0060E9FC   8B8074080000           mov     eax, [eax+$0874]
0060EA02   8B10                   mov     edx, [eax]
0060EA04   FF5258                 call    dword ptr [edx+$58]
0060EA07   8D9548FFFFFF           lea     edx, [ebp+$FFFFFF48]

* Reference to : TForm1.Proc_005D3228()
|
0060EA0D   E81648FCFF             call    005D3228
0060EA12   8D8548FFFFFF           lea     eax, [ebp+$FFFFFF48]
0060EA18   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
0060EA1D   E80664DFFF             call    00404E28
0060EA22   8B8548FFFFFF           mov     eax, [ebp+$FFFFFF48]
0060EA28   8B55C0                 mov     edx, [ebp-$40]

* Reference to: System.@LStrPos;
|
0060EA2B   E82C67DFFF             call    0040515C
0060EA30   85C0                   test    eax, eax
0060EA32   7533                   jnz     0060EA67
0060EA34   FF75C0                 push    dword ptr [ebp-$40]
0060EA37   8B03                   mov     eax, [ebx]
0060EA39   8B8074080000           mov     eax, [eax+$0874]
0060EA3F   8B10                   mov     edx, [eax]
0060EA41   FF5258                 call    dword ptr [edx+$58]
0060EA44   8D9544FFFFFF           lea     edx, [ebp+$FFFFFF44]

* Reference to : TForm1.Proc_005D3228()
|
0060EA4A   E8D947FCFF             call    005D3228
0060EA4F   FFB544FFFFFF           push    dword ptr [ebp+$FFFFFF44]
0060EA55   68D80B6100             push    $00610BD8
0060EA5A   8D45C0                 lea     eax, [ebp-$40]
0060EA5D   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060EA62   E87964DFFF             call    00404EE0
0060EA67   8B03                   mov     eax, [ebx]
0060EA69   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060EA6F   E8780AEAFF             call    004AF4EC
0060EA74   8B03                   mov     eax, [ebx]
0060EA76   8B809C000000           mov     eax, [eax+$009C]
0060EA7C   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060EA83   7516                   jnz     0060EA9B
0060EA85   8B03                   mov     eax, [ebx]
0060EA87   8B8078080000           mov     eax, [eax+$0878]
0060EA8D   8B10                   mov     edx, [eax]
0060EA8F   FF5258                 call    dword ptr [edx+$58]
0060EA92   3B45D0                 cmp     eax, [ebp-$30]
0060EA95   0F8467FEFFFF           jz      0060E902
0060EA9B   8B03                   mov     eax, [ebx]
0060EA9D   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
0060EAA3   BAF00B6100             mov     edx, $00610BF0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060EAA8   E8AF40ECFF             call    004D2B5C
0060EAAD   8B03                   mov     eax, [ebx]
0060EAAF   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060EAB5   E81A07EAFF             call    004AF1D4
0060EABA   837DCC00               cmp     dword ptr [ebp-$34], +$00
0060EABE   0F8EC2010000           jle     0060EC86
0060EAC4   8B45CC                 mov     eax, [ebp-$34]
0060EAC7   89459C                 mov     [ebp-$64], eax
0060EACA   C645A000               mov     byte ptr [ebp-$60], $00
0060EACE   8D559C                 lea     edx, [ebp-$64]
0060EAD1   8B03                   mov     eax, [ebx]
0060EAD3   8B809C000000           mov     eax, [eax+$009C]
0060EAD9   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060EADB   E88447ECFF             call    004D3264
0060EAE0   84C0                   test    al, al
0060EAE2   0F849E010000           jz      0060EC86
0060EAE8   E983010000             jmp     0060EC70
0060EAED   8B03                   mov     eax, [ebx]
0060EAEF   8B8074080000           mov     eax, [eax+$0874]
0060EAF5   8B10                   mov     edx, [eax]
0060EAF7   FF5258                 call    dword ptr [edx+$58]
0060EAFA   3B45E4                 cmp     eax, [ebp-$1C]
0060EAFD   0F844F010000           jz      0060EC52
0060EB03   8D953CFFFFFF           lea     edx, [ebp+$FFFFFF3C]
0060EB09   8B03                   mov     eax, [ebx]
0060EB0B   8B8088080000           mov     eax, [eax+$0888]
0060EB11   8B08                   mov     ecx, [eax]
0060EB13   FF5160                 call    dword ptr [ecx+$60]
0060EB16   8B853CFFFFFF           mov     eax, [ebp+$FFFFFF3C]
0060EB1C   8D9540FFFFFF           lea     edx, [ebp+$FFFFFF40]

* Reference to: Unit_00408494.Proc_004091D8
|
0060EB22   E8B1A6DFFF             call    004091D8
0060EB27   8B8540FFFFFF           mov     eax, [ebp+$FFFFFF40]
0060EB2D   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
0060EB32   E82D64DFFF             call    00404F64
0060EB37   7576                   jnz     0060EBAF
0060EB39   8B03                   mov     eax, [ebx]
0060EB3B   8B8074080000           mov     eax, [eax+$0874]
0060EB41   8B10                   mov     edx, [eax]
0060EB43   FF5258                 call    dword ptr [edx+$58]
0060EB46   8D9538FFFFFF           lea     edx, [ebp+$FFFFFF38]

* Reference to : TForm1.Proc_005D3228()
|
0060EB4C   E8D746FCFF             call    005D3228
0060EB51   8D8538FFFFFF           lea     eax, [ebp+$FFFFFF38]
0060EB57   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
0060EB5C   E8C762DFFF             call    00404E28
0060EB61   8B8538FFFFFF           mov     eax, [ebp+$FFFFFF38]
0060EB67   8B55C4                 mov     edx, [ebp-$3C]

* Reference to: System.@LStrPos;
|
0060EB6A   E8ED65DFFF             call    0040515C
0060EB6F   85C0                   test    eax, eax
0060EB71   0F85DB000000           jnz     0060EC52
0060EB77   FF75C4                 push    dword ptr [ebp-$3C]
0060EB7A   8B03                   mov     eax, [ebx]
0060EB7C   8B8074080000           mov     eax, [eax+$0874]
0060EB82   8B10                   mov     edx, [eax]
0060EB84   FF5258                 call    dword ptr [edx+$58]
0060EB87   8D9534FFFFFF           lea     edx, [ebp+$FFFFFF34]

* Reference to : TForm1.Proc_005D3228()
|
0060EB8D   E89646FCFF             call    005D3228
0060EB92   FFB534FFFFFF           push    dword ptr [ebp+$FFFFFF34]
0060EB98   68D80B6100             push    $00610BD8
0060EB9D   8D45C4                 lea     eax, [ebp-$3C]
0060EBA0   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060EBA5   E83663DFFF             call    00404EE0
0060EBAA   E9A3000000             jmp     0060EC52
0060EBAF   8D952CFFFFFF           lea     edx, [ebp+$FFFFFF2C]
0060EBB5   8B03                   mov     eax, [ebx]
0060EBB7   8B8088080000           mov     eax, [eax+$0888]
0060EBBD   8B08                   mov     ecx, [eax]
0060EBBF   FF5160                 call    dword ptr [ecx+$60]
0060EBC2   8B852CFFFFFF           mov     eax, [ebp+$FFFFFF2C]
0060EBC8   8D9530FFFFFF           lea     edx, [ebp+$FFFFFF30]

* Reference to: Unit_00408494.Proc_004091D8
|
0060EBCE   E805A6DFFF             call    004091D8
0060EBD3   8B8530FFFFFF           mov     eax, [ebp+$FFFFFF30]
0060EBD9   BAE40B6100             mov     edx, $00610BE4

* Reference to: System.@LStrCmp;
|
0060EBDE   E88163DFFF             call    00404F64
0060EBE3   756D                   jnz     0060EC52
0060EBE5   8B03                   mov     eax, [ebx]
0060EBE7   8B8074080000           mov     eax, [eax+$0874]
0060EBED   8B10                   mov     edx, [eax]
0060EBEF   FF5258                 call    dword ptr [edx+$58]
0060EBF2   8D9528FFFFFF           lea     edx, [ebp+$FFFFFF28]

* Reference to : TForm1.Proc_005D3228()
|
0060EBF8   E82B46FCFF             call    005D3228
0060EBFD   8D8528FFFFFF           lea     eax, [ebp+$FFFFFF28]
0060EC03   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
0060EC08   E81B62DFFF             call    00404E28
0060EC0D   8B8528FFFFFF           mov     eax, [ebp+$FFFFFF28]
0060EC13   8B55C0                 mov     edx, [ebp-$40]

* Reference to: System.@LStrPos;
|
0060EC16   E84165DFFF             call    0040515C
0060EC1B   85C0                   test    eax, eax
0060EC1D   7533                   jnz     0060EC52
0060EC1F   FF75C0                 push    dword ptr [ebp-$40]
0060EC22   8B03                   mov     eax, [ebx]
0060EC24   8B8074080000           mov     eax, [eax+$0874]
0060EC2A   8B10                   mov     edx, [eax]
0060EC2C   FF5258                 call    dword ptr [edx+$58]
0060EC2F   8D9524FFFFFF           lea     edx, [ebp+$FFFFFF24]

* Reference to : TForm1.Proc_005D3228()
|
0060EC35   E8EE45FCFF             call    005D3228
0060EC3A   FFB524FFFFFF           push    dword ptr [ebp+$FFFFFF24]
0060EC40   68D80B6100             push    $00610BD8
0060EC45   8D45C0                 lea     eax, [ebp-$40]
0060EC48   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060EC4D   E88E62DFFF             call    00404EE0
0060EC52   8B03                   mov     eax, [ebx]
0060EC54   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060EC5A   E88D08EAFF             call    004AF4EC
0060EC5F   8B03                   mov     eax, [ebx]
0060EC61   8B809C000000           mov     eax, [eax+$009C]
0060EC67   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060EC6E   7516                   jnz     0060EC86
0060EC70   8B03                   mov     eax, [ebx]
0060EC72   8B807C080000           mov     eax, [eax+$087C]
0060EC78   8B10                   mov     edx, [eax]
0060EC7A   FF5258                 call    dword ptr [edx+$58]
0060EC7D   3B45CC                 cmp     eax, [ebp-$34]
0060EC80   0F8467FEFFFF           jz      0060EAED
0060EC86   8B03                   mov     eax, [ebx]
0060EC88   8B809C000000           mov     eax, [eax+$009C]
0060EC8E   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060EC90   E8C73EECFF             call    004D2B5C

* Reference to Form1
|
0060EC95   8B45F8                 mov     eax, [ebp-$08]
0060EC98   89459C                 mov     [ebp-$64], eax
0060EC9B   C645A000               mov     byte ptr [ebp-$60], $00
0060EC9F   8D559C                 lea     edx, [ebp-$64]
0060ECA2   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_009C
|
0060ECA4   8B809C000000           mov     eax, [eax+$009C]
0060ECAA   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060ECAC   E8B345ECFF             call    004D3264
0060ECB1   B201                   mov     dl, $01

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060ECB3   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
0060ECB9   E866DCE3FF             call    0044C924
0060ECBE   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
0060ECC0   8B8074080000           mov     eax, [eax+$0874]
0060ECC6   8B10                   mov     edx, [eax]
0060ECC8   FF5258                 call    dword ptr [edx+$58]
0060ECCB   8D9520FFFFFF           lea     edx, [ebp+$FFFFFF20]

* Reference to: Unit_00408494.Proc_00409950
|
0060ECD1   E87AACDFFF             call    00409950
0060ECD6   8B8520FFFFFF           mov     eax, [ebp+$FFFFFF20]
0060ECDC   50                     push    eax
0060ECDD   33C9                   xor     ecx, ecx
0060ECDF   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060ECE1   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060ECE7   E8100EEDFF             call    004DFAFC

* Possible String Reference to: 'Vetter(n) von '
|
0060ECEC   68FC0B6100             push    $00610BFC
0060ECF1   8D9518FFFFFF           lea     edx, [ebp+$FFFFFF18]
0060ECF7   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
0060ECF9   8B8080080000           mov     eax, [eax+$0880]
0060ECFF   8B08                   mov     ecx, [eax]
0060ED01   FF5160                 call    dword ptr [ecx+$60]
0060ED04   FFB518FFFFFF           push    dword ptr [ebp+$FFFFFF18]
0060ED0A   68140C6100             push    $00610C14
0060ED0F   8D9514FFFFFF           lea     edx, [ebp+$FFFFFF14]
0060ED15   8B03                   mov     eax, [ebx]
0060ED17   8B8084080000           mov     eax, [eax+$0884]
0060ED1D   8B08                   mov     ecx, [eax]
0060ED1F   FF5160                 call    dword ptr [ecx+$60]
0060ED22   FFB514FFFFFF           push    dword ptr [ebp+$FFFFFF14]
0060ED28   8D851CFFFFFF           lea     eax, [ebp+$FFFFFF1C]
0060ED2E   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
0060ED33   E8A861DFFF             call    00404EE0
0060ED38   8B851CFFFFFF           mov     eax, [ebp+$FFFFFF1C]
0060ED3E   50                     push    eax
0060ED3F   33C9                   xor     ecx, ecx
0060ED41   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060ED46   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060ED4C   E8AB0DEDFF             call    004DFAFC
0060ED51   8D950CFFFFFF           lea     edx, [ebp+$FFFFFF0C]
0060ED57   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
0060ED59   8B809C080000           mov     eax, [eax+$089C]
0060ED5F   8B08                   mov     ecx, [eax]
0060ED61   FF5160                 call    dword ptr [ecx+$60]
0060ED64   8B850CFFFFFF           mov     eax, [ebp+$FFFFFF0C]
0060ED6A   8D9510FFFFFF           lea     edx, [ebp+$FFFFFF10]

* Reference to: Unit_00408494.Proc_00409448
|
0060ED70   E8D3A6DFFF             call    00409448
0060ED75   83BD10FFFFFF00         cmp     dword ptr [ebp+$FFFFFF10], +$00
0060ED7C   7644                   jbe     0060EDC2
0060ED7E   8D9504FFFFFF           lea     edx, [ebp+$FFFFFF04]
0060ED84   8B03                   mov     eax, [ebx]
0060ED86   8B809C080000           mov     eax, [eax+$089C]
0060ED8C   8B08                   mov     ecx, [eax]
0060ED8E   FF5160                 call    dword ptr [ecx+$60]
0060ED91   8B8D04FFFFFF           mov     ecx, [ebp+$FFFFFF04]
0060ED97   8D8508FFFFFF           lea     eax, [ebp+$FFFFFF08]

* Possible String Reference to: '* '
|
0060ED9D   BA200C6100             mov     edx, $00610C20

* Reference to: System.@LStrCat3;
|
0060EDA2   E8C560DFFF             call    00404E6C
0060EDA7   8B8508FFFFFF           mov     eax, [ebp+$FFFFFF08]
0060EDAD   50                     push    eax
0060EDAE   33C9                   xor     ecx, ecx
0060EDB0   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060EDB5   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060EDBB   E83C0DEDFF             call    004DFAFC
0060EDC0   EB6F                   jmp     0060EE31
0060EDC2   8D95FCFEFFFF           lea     edx, [ebp+$FFFFFEFC]
0060EDC8   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
0060EDCA   8B80AC080000           mov     eax, [eax+$08AC]
0060EDD0   8B08                   mov     ecx, [eax]
0060EDD2   FF5160                 call    dword ptr [ecx+$60]
0060EDD5   8B85FCFEFFFF           mov     eax, [ebp+$FFFFFEFC]
0060EDDB   8D9500FFFFFF           lea     edx, [ebp+$FFFFFF00]

* Reference to: Unit_00408494.Proc_00409448
|
0060EDE1   E862A6DFFF             call    00409448
0060EDE6   83BD00FFFFFF00         cmp     dword ptr [ebp+$FFFFFF00], +$00
0060EDED   7642                   jbe     0060EE31
0060EDEF   8D95F4FEFFFF           lea     edx, [ebp+$FFFFFEF4]
0060EDF5   8B03                   mov     eax, [ebx]
0060EDF7   8B80AC080000           mov     eax, [eax+$08AC]
0060EDFD   8B08                   mov     ecx, [eax]
0060EDFF   FF5160                 call    dword ptr [ecx+$60]
0060EE02   8B8DF4FEFFFF           mov     ecx, [ebp+$FFFFFEF4]
0060EE08   8D85F8FEFFFF           lea     eax, [ebp+$FFFFFEF8]

* Possible String Reference to: '~ '
|
0060EE0E   BA2C0C6100             mov     edx, $00610C2C

* Reference to: System.@LStrCat3;
|
0060EE13   E85460DFFF             call    00404E6C
0060EE18   8B85F8FEFFFF           mov     eax, [ebp+$FFFFFEF8]
0060EE1E   50                     push    eax
0060EE1F   33C9                   xor     ecx, ecx
0060EE21   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060EE26   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060EE2C   E8CB0CEDFF             call    004DFAFC
0060EE31   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]
0060EE37   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
0060EE39   8B80C4080000           mov     eax, [eax+$08C4]
0060EE3F   8B08                   mov     ecx, [eax]
0060EE41   FF5160                 call    dword ptr [ecx+$60]
0060EE44   8B85ECFEFFFF           mov     eax, [ebp+$FFFFFEEC]
0060EE4A   8D95F0FEFFFF           lea     edx, [ebp+$FFFFFEF0]

* Reference to: Unit_00408494.Proc_00409448
|
0060EE50   E8F3A5DFFF             call    00409448
0060EE55   83BDF0FEFFFF00         cmp     dword ptr [ebp+$FFFFFEF0], +$00
0060EE5C   7642                   jbe     0060EEA0
0060EE5E   8D95E4FEFFFF           lea     edx, [ebp+$FFFFFEE4]
0060EE64   8B03                   mov     eax, [ebx]
0060EE66   8B80C4080000           mov     eax, [eax+$08C4]
0060EE6C   8B08                   mov     ecx, [eax]
0060EE6E   FF5160                 call    dword ptr [ecx+$60]
0060EE71   8B8DE4FEFFFF           mov     ecx, [ebp+$FFFFFEE4]
0060EE77   8D85E8FEFFFF           lea     eax, [ebp+$FFFFFEE8]

* Possible String Reference to: '+ '
|
0060EE7D   BA380C6100             mov     edx, $00610C38

* Reference to: System.@LStrCat3;
|
0060EE82   E8E55FDFFF             call    00404E6C
0060EE87   8B85E8FEFFFF           mov     eax, [ebp+$FFFFFEE8]
0060EE8D   50                     push    eax
0060EE8E   33C9                   xor     ecx, ecx
0060EE90   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060EE95   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060EE9B   E85C0CEDFF             call    004DFAFC

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060EEA0   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
0060EEA6   8B904C020000           mov     edx, [eax+$024C]
0060EEAC   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
0060EEAD   E81EEAECFF             call    004DD8D0

* Possible String Reference to: 'Onkel:'
|
0060EEB2   68440C6100             push    $00610C44

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060EEB7   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
0060EEBD   8B884C020000           mov     ecx, [eax+$024C]
0060EEC3   49                     dec     ecx
0060EEC4   BA01000000             mov     edx, $00000001

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060EEC9   E82E0CEDFF             call    004DFAFC

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060EECE   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
0060EED4   8BB84C020000           mov     edi, [eax+$024C]
0060EEDA   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.DockOrientation : TDockOrientation
|
0060EEDC   8B809C000000           mov     eax, [eax+$009C]
0060EEE2   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060EEE4   E8733CECFF             call    004D2B5C
0060EEE9   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrLen(String):Integer;
|
0060EEEC   E82F5FDFFF             call    00404E20
0060EEF1   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
0060EEF7   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
0060EEFD   D8354C0C6100           fdiv    dword ptr [$00610C4C]

* Reference to: System.@ROUND;
|
0060EF03   E8283EDFFF             call    00402D30
0060EF08   85C0                   test    eax, eax
0060EF0A   0F8EB9050000           jle     0060F4C9
0060EF10   8945A4                 mov     [ebp-$5C], eax
0060EF13   C745F001000000         mov     dword ptr [ebp-$10], $00000001
0060EF1A   8D85DCFEFFFF           lea     eax, [ebp+$FFFFFEDC]
0060EF20   50                     push    eax
0060EF21   8B45F0                 mov     eax, [ebp-$10]
0060EF24   48                     dec     eax
0060EF25   8BD0                   mov     edx, eax
0060EF27   C1E203                 shl     edx, $03
0060EF2A   2BD0                   sub     edx, eax
0060EF2C   83C207                 add     edx, +$07
0060EF2F   B901000000             mov     ecx, $00000001
0060EF34   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrCopy;
|
0060EF37   E83C61DFFF             call    00405078
0060EF3C   8B85DCFEFFFF           mov     eax, [ebp+$FFFFFEDC]
0060EF42   BA580C6100             mov     edx, $00610C58

* Reference to: System.@LStrCmp;
|
0060EF47   E81860DFFF             call    00404F64
0060EF4C   0F846B050000           jz      0060F4BD
0060EF52   8D85D8FEFFFF           lea     eax, [ebp+$FFFFFED8]
0060EF58   50                     push    eax
0060EF59   8B45F0                 mov     eax, [ebp-$10]
0060EF5C   48                     dec     eax
0060EF5D   8BD0                   mov     edx, eax
0060EF5F   C1E203                 shl     edx, $03
0060EF62   2BD0                   sub     edx, eax
0060EF64   42                     inc     edx
0060EF65   B906000000             mov     ecx, $00000006
0060EF6A   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrCopy;
|
0060EF6D   E80661DFFF             call    00405078
0060EF72   8B85D8FEFFFF           mov     eax, [ebp+$FFFFFED8]

* Reference to: Unit_00408494.Proc_004099B4
|
0060EF78   E837AADFFF             call    004099B4
0060EF7D   89459C                 mov     [ebp-$64], eax
0060EF80   C645A000               mov     byte ptr [ebp-$60], $00
0060EF84   8D559C                 lea     edx, [ebp-$64]
0060EF87   8B03                   mov     eax, [ebx]
0060EF89   8B809C000000           mov     eax, [eax+$009C]
0060EF8F   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060EF91   E8CE42ECFF             call    004D3264
0060EF96   8D95D0FEFFFF           lea     edx, [ebp+$FFFFFED0]
0060EF9C   8B03                   mov     eax, [ebx]
0060EF9E   8B8088080000           mov     eax, [eax+$0888]
0060EFA4   8B08                   mov     ecx, [eax]
0060EFA6   FF5160                 call    dword ptr [ecx+$60]
0060EFA9   8B85D0FEFFFF           mov     eax, [ebp+$FFFFFED0]
0060EFAF   8D95D4FEFFFF           lea     edx, [ebp+$FFFFFED4]

* Reference to: Unit_00408494.Proc_004091D8
|
0060EFB5   E81EA2DFFF             call    004091D8
0060EFBA   8B85D4FEFFFF           mov     eax, [ebp+$FFFFFED4]
0060EFC0   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
0060EFC5   E89A5FDFFF             call    00404F64
0060EFCA   0F85F0010000           jnz     0060F1C0

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060EFD0   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
0060EFD6   8B904C020000           mov     edx, [eax+$024C]
0060EFDC   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
0060EFDD   E8EEE8ECFF             call    004DD8D0
0060EFE2   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
0060EFE4   8B8074080000           mov     eax, [eax+$0874]
0060EFEA   8B10                   mov     edx, [eax]
0060EFEC   FF5258                 call    dword ptr [edx+$58]
0060EFEF   8D95CCFEFFFF           lea     edx, [ebp+$FFFFFECC]

* Reference to: Unit_00408494.Proc_00409950
|
0060EFF5   E856A9DFFF             call    00409950
0060EFFA   8B85CCFEFFFF           mov     eax, [ebp+$FFFFFECC]
0060F000   50                     push    eax
0060F001   8BCF                   mov     ecx, edi
0060F003   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F005   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F00B   E8EC0AEDFF             call    004DFAFC
0060F010   8D95C4FEFFFF           lea     edx, [ebp+$FFFFFEC4]
0060F016   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
0060F018   8B8080080000           mov     eax, [eax+$0880]
0060F01E   8B08                   mov     ecx, [eax]
0060F020   FF5160                 call    dword ptr [ecx+$60]
0060F023   FFB5C4FEFFFF           push    dword ptr [ebp+$FFFFFEC4]
0060F029   68140C6100             push    $00610C14
0060F02E   8D95C0FEFFFF           lea     edx, [ebp+$FFFFFEC0]
0060F034   8B03                   mov     eax, [ebx]
0060F036   8B8084080000           mov     eax, [eax+$0884]
0060F03C   8B08                   mov     ecx, [eax]
0060F03E   FF5160                 call    dword ptr [ecx+$60]
0060F041   FFB5C0FEFFFF           push    dword ptr [ebp+$FFFFFEC0]
0060F047   8D85C8FEFFFF           lea     eax, [ebp+$FFFFFEC8]
0060F04D   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060F052   E8895EDFFF             call    00404EE0
0060F057   8B85C8FEFFFF           mov     eax, [ebp+$FFFFFEC8]
0060F05D   50                     push    eax
0060F05E   8BCF                   mov     ecx, edi
0060F060   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F065   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F06B   E88C0AEDFF             call    004DFAFC
0060F070   8D95B8FEFFFF           lea     edx, [ebp+$FFFFFEB8]
0060F076   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
0060F078   8B809C080000           mov     eax, [eax+$089C]
0060F07E   8B08                   mov     ecx, [eax]
0060F080   FF5160                 call    dword ptr [ecx+$60]
0060F083   8B85B8FEFFFF           mov     eax, [ebp+$FFFFFEB8]
0060F089   8D95BCFEFFFF           lea     edx, [ebp+$FFFFFEBC]

* Reference to: Unit_00408494.Proc_00409448
|
0060F08F   E8B4A3DFFF             call    00409448
0060F094   83BDBCFEFFFF00         cmp     dword ptr [ebp+$FFFFFEBC], +$00
0060F09B   7644                   jbe     0060F0E1
0060F09D   8D95B0FEFFFF           lea     edx, [ebp+$FFFFFEB0]
0060F0A3   8B03                   mov     eax, [ebx]
0060F0A5   8B809C080000           mov     eax, [eax+$089C]
0060F0AB   8B08                   mov     ecx, [eax]
0060F0AD   FF5160                 call    dword ptr [ecx+$60]
0060F0B0   8B8DB0FEFFFF           mov     ecx, [ebp+$FFFFFEB0]
0060F0B6   8D85B4FEFFFF           lea     eax, [ebp+$FFFFFEB4]

* Possible String Reference to: '* '
|
0060F0BC   BA200C6100             mov     edx, $00610C20

* Reference to: System.@LStrCat3;
|
0060F0C1   E8A65DDFFF             call    00404E6C
0060F0C6   8B85B4FEFFFF           mov     eax, [ebp+$FFFFFEB4]
0060F0CC   50                     push    eax
0060F0CD   8BCF                   mov     ecx, edi
0060F0CF   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F0D4   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F0DA   E81D0AEDFF             call    004DFAFC
0060F0DF   EB6F                   jmp     0060F150
0060F0E1   8D95A8FEFFFF           lea     edx, [ebp+$FFFFFEA8]
0060F0E7   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
0060F0E9   8B80AC080000           mov     eax, [eax+$08AC]
0060F0EF   8B08                   mov     ecx, [eax]
0060F0F1   FF5160                 call    dword ptr [ecx+$60]
0060F0F4   8B85A8FEFFFF           mov     eax, [ebp+$FFFFFEA8]
0060F0FA   8D95ACFEFFFF           lea     edx, [ebp+$FFFFFEAC]

* Reference to: Unit_00408494.Proc_00409448
|
0060F100   E843A3DFFF             call    00409448
0060F105   83BDACFEFFFF00         cmp     dword ptr [ebp+$FFFFFEAC], +$00
0060F10C   7642                   jbe     0060F150
0060F10E   8D95A0FEFFFF           lea     edx, [ebp+$FFFFFEA0]
0060F114   8B03                   mov     eax, [ebx]
0060F116   8B80AC080000           mov     eax, [eax+$08AC]
0060F11C   8B08                   mov     ecx, [eax]
0060F11E   FF5160                 call    dword ptr [ecx+$60]
0060F121   8B8DA0FEFFFF           mov     ecx, [ebp+$FFFFFEA0]
0060F127   8D85A4FEFFFF           lea     eax, [ebp+$FFFFFEA4]

* Possible String Reference to: '~ '
|
0060F12D   BA2C0C6100             mov     edx, $00610C2C

* Reference to: System.@LStrCat3;
|
0060F132   E8355DDFFF             call    00404E6C
0060F137   8B85A4FEFFFF           mov     eax, [ebp+$FFFFFEA4]
0060F13D   50                     push    eax
0060F13E   8BCF                   mov     ecx, edi
0060F140   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F145   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F14B   E8AC09EDFF             call    004DFAFC
0060F150   8D9598FEFFFF           lea     edx, [ebp+$FFFFFE98]
0060F156   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
0060F158   8B80C4080000           mov     eax, [eax+$08C4]
0060F15E   8B08                   mov     ecx, [eax]
0060F160   FF5160                 call    dword ptr [ecx+$60]
0060F163   8B8598FEFFFF           mov     eax, [ebp+$FFFFFE98]
0060F169   8D959CFEFFFF           lea     edx, [ebp+$FFFFFE9C]

* Reference to: Unit_00408494.Proc_00409448
|
0060F16F   E8D4A2DFFF             call    00409448
0060F174   83BD9CFEFFFF00         cmp     dword ptr [ebp+$FFFFFE9C], +$00
0060F17B   7642                   jbe     0060F1BF
0060F17D   8D9590FEFFFF           lea     edx, [ebp+$FFFFFE90]
0060F183   8B03                   mov     eax, [ebx]
0060F185   8B80C4080000           mov     eax, [eax+$08C4]
0060F18B   8B08                   mov     ecx, [eax]
0060F18D   FF5160                 call    dword ptr [ecx+$60]
0060F190   8B8D90FEFFFF           mov     ecx, [ebp+$FFFFFE90]
0060F196   8D8594FEFFFF           lea     eax, [ebp+$FFFFFE94]

* Possible String Reference to: '+ '
|
0060F19C   BA380C6100             mov     edx, $00610C38

* Reference to: System.@LStrCat3;
|
0060F1A1   E8C65CDFFF             call    00404E6C
0060F1A6   8B8594FEFFFF           mov     eax, [ebp+$FFFFFE94]
0060F1AC   50                     push    eax
0060F1AD   8BCF                   mov     ecx, edi
0060F1AF   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F1B4   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F1BA   E83D09EDFF             call    004DFAFC
0060F1BF   47                     inc     edi
0060F1C0   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.WheelAccumulator : Integer
|
0060F1C2   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
0060F1C8   BA640C6100             mov     edx, $00610C64

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060F1CD   E88A39ECFF             call    004D2B5C
0060F1D2   8D9588FEFFFF           lea     edx, [ebp+$FFFFFE88]
0060F1D8   8B03                   mov     eax, [ebx]

* Reference to field Integer.OFFS_0888
|
0060F1DA   8B8088080000           mov     eax, [eax+$0888]
0060F1E0   8B08                   mov     ecx, [eax]
0060F1E2   FF5160                 call    dword ptr [ecx+$60]
0060F1E5   8B8588FEFFFF           mov     eax, [ebp+$FFFFFE88]
0060F1EB   8D958CFEFFFF           lea     edx, [ebp+$FFFFFE8C]

* Reference to: Unit_00408494.Proc_004091D8
|
0060F1F1   E8E29FDFFF             call    004091D8
0060F1F6   8B858CFEFFFF           mov     eax, [ebp+$FFFFFE8C]
0060F1FC   BAE40B6100             mov     edx, $00610BE4

* Reference to: System.@LStrCmp;
|
0060F201   E85E5DDFFF             call    00404F64
0060F206   0F85B1020000           jnz     0060F4BD
0060F20C   8B03                   mov     eax, [ebx]
0060F20E   8B8074080000           mov     eax, [eax+$0874]
0060F214   8B10                   mov     edx, [eax]
0060F216   FF5258                 call    dword ptr [edx+$58]
0060F219   89459C                 mov     [ebp-$64], eax
0060F21C   C645A000               mov     byte ptr [ebp-$60], $00
0060F220   8D559C                 lea     edx, [ebp-$64]
0060F223   8B03                   mov     eax, [ebx]
0060F225   8B80A4000000           mov     eax, [eax+$00A4]
0060F22B   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060F22D   E83240ECFF             call    004D3264
0060F232   84C0                   test    al, al
0060F234   0F8483020000           jz      0060F4BD
0060F23A   E95A020000             jmp     0060F499
0060F23F   8B03                   mov     eax, [ebx]
0060F241   8B809C000000           mov     eax, [eax+$009C]
0060F247   8B10                   mov     edx, [eax]
0060F249   FF9250010000           call    dword ptr [edx+$0150]
0060F24F   8945DC                 mov     [ebp-$24], eax
0060F252   8B03                   mov     eax, [ebx]
0060F254   8B80B8030000           mov     eax, [eax+$03B8]
0060F25A   8B10                   mov     edx, [eax]
0060F25C   FF5258                 call    dword ptr [edx+$58]
0060F25F   89459C                 mov     [ebp-$64], eax
0060F262   C645A000               mov     byte ptr [ebp-$60], $00
0060F266   8D559C                 lea     edx, [ebp-$64]
0060F269   8B03                   mov     eax, [ebx]
0060F26B   8B809C000000           mov     eax, [eax+$009C]
0060F271   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060F273   E8EC3FECFF             call    004D3264

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F278   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
0060F27E   8B904C020000           mov     edx, [eax+$024C]
0060F284   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
0060F285   E846E6ECFF             call    004DD8D0
0060F28A   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
0060F28C   8B8074080000           mov     eax, [eax+$0874]
0060F292   8B10                   mov     edx, [eax]
0060F294   FF5258                 call    dword ptr [edx+$58]
0060F297   8D9584FEFFFF           lea     edx, [ebp+$FFFFFE84]

* Reference to: Unit_00408494.Proc_00409950
|
0060F29D   E8AEA6DFFF             call    00409950
0060F2A2   8B8584FEFFFF           mov     eax, [ebp+$FFFFFE84]
0060F2A8   50                     push    eax
0060F2A9   8BCF                   mov     ecx, edi
0060F2AB   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F2AD   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F2B3   E84408EDFF             call    004DFAFC
0060F2B8   8D957CFEFFFF           lea     edx, [ebp+$FFFFFE7C]
0060F2BE   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
0060F2C0   8B8080080000           mov     eax, [eax+$0880]
0060F2C6   8B08                   mov     ecx, [eax]
0060F2C8   FF5160                 call    dword ptr [ecx+$60]
0060F2CB   FFB57CFEFFFF           push    dword ptr [ebp+$FFFFFE7C]
0060F2D1   68140C6100             push    $00610C14
0060F2D6   8D9578FEFFFF           lea     edx, [ebp+$FFFFFE78]
0060F2DC   8B03                   mov     eax, [ebx]
0060F2DE   8B8084080000           mov     eax, [eax+$0884]
0060F2E4   8B08                   mov     ecx, [eax]
0060F2E6   FF5160                 call    dword ptr [ecx+$60]
0060F2E9   FFB578FEFFFF           push    dword ptr [ebp+$FFFFFE78]
0060F2EF   8D8580FEFFFF           lea     eax, [ebp+$FFFFFE80]
0060F2F5   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060F2FA   E8E15BDFFF             call    00404EE0
0060F2FF   8B8580FEFFFF           mov     eax, [ebp+$FFFFFE80]
0060F305   50                     push    eax
0060F306   8BCF                   mov     ecx, edi
0060F308   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F30D   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F313   E8E407EDFF             call    004DFAFC
0060F318   8D9570FEFFFF           lea     edx, [ebp+$FFFFFE70]
0060F31E   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
0060F320   8B809C080000           mov     eax, [eax+$089C]
0060F326   8B08                   mov     ecx, [eax]
0060F328   FF5160                 call    dword ptr [ecx+$60]
0060F32B   8B8570FEFFFF           mov     eax, [ebp+$FFFFFE70]
0060F331   8D9574FEFFFF           lea     edx, [ebp+$FFFFFE74]

* Reference to: Unit_00408494.Proc_00409448
|
0060F337   E80CA1DFFF             call    00409448
0060F33C   83BD74FEFFFF00         cmp     dword ptr [ebp+$FFFFFE74], +$00
0060F343   7644                   jbe     0060F389
0060F345   8D9568FEFFFF           lea     edx, [ebp+$FFFFFE68]
0060F34B   8B03                   mov     eax, [ebx]
0060F34D   8B809C080000           mov     eax, [eax+$089C]
0060F353   8B08                   mov     ecx, [eax]
0060F355   FF5160                 call    dword ptr [ecx+$60]
0060F358   8B8D68FEFFFF           mov     ecx, [ebp+$FFFFFE68]
0060F35E   8D856CFEFFFF           lea     eax, [ebp+$FFFFFE6C]

* Possible String Reference to: '* '
|
0060F364   BA200C6100             mov     edx, $00610C20

* Reference to: System.@LStrCat3;
|
0060F369   E8FE5ADFFF             call    00404E6C
0060F36E   8B856CFEFFFF           mov     eax, [ebp+$FFFFFE6C]
0060F374   50                     push    eax
0060F375   8BCF                   mov     ecx, edi
0060F377   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F37C   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F382   E87507EDFF             call    004DFAFC
0060F387   EB6F                   jmp     0060F3F8
0060F389   8D9560FEFFFF           lea     edx, [ebp+$FFFFFE60]
0060F38F   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
0060F391   8B80AC080000           mov     eax, [eax+$08AC]
0060F397   8B08                   mov     ecx, [eax]
0060F399   FF5160                 call    dword ptr [ecx+$60]
0060F39C   8B8560FEFFFF           mov     eax, [ebp+$FFFFFE60]
0060F3A2   8D9564FEFFFF           lea     edx, [ebp+$FFFFFE64]

* Reference to: Unit_00408494.Proc_00409448
|
0060F3A8   E89BA0DFFF             call    00409448
0060F3AD   83BD64FEFFFF00         cmp     dword ptr [ebp+$FFFFFE64], +$00
0060F3B4   7642                   jbe     0060F3F8
0060F3B6   8D9558FEFFFF           lea     edx, [ebp+$FFFFFE58]
0060F3BC   8B03                   mov     eax, [ebx]
0060F3BE   8B80AC080000           mov     eax, [eax+$08AC]
0060F3C4   8B08                   mov     ecx, [eax]
0060F3C6   FF5160                 call    dword ptr [ecx+$60]
0060F3C9   8B8D58FEFFFF           mov     ecx, [ebp+$FFFFFE58]
0060F3CF   8D855CFEFFFF           lea     eax, [ebp+$FFFFFE5C]

* Possible String Reference to: '~ '
|
0060F3D5   BA2C0C6100             mov     edx, $00610C2C

* Reference to: System.@LStrCat3;
|
0060F3DA   E88D5ADFFF             call    00404E6C
0060F3DF   8B855CFEFFFF           mov     eax, [ebp+$FFFFFE5C]
0060F3E5   50                     push    eax
0060F3E6   8BCF                   mov     ecx, edi
0060F3E8   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F3ED   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F3F3   E80407EDFF             call    004DFAFC
0060F3F8   8D9550FEFFFF           lea     edx, [ebp+$FFFFFE50]
0060F3FE   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
0060F400   8B80C4080000           mov     eax, [eax+$08C4]
0060F406   8B08                   mov     ecx, [eax]
0060F408   FF5160                 call    dword ptr [ecx+$60]
0060F40B   8B8550FEFFFF           mov     eax, [ebp+$FFFFFE50]
0060F411   8D9554FEFFFF           lea     edx, [ebp+$FFFFFE54]

* Reference to: Unit_00408494.Proc_00409448
|
0060F417   E82CA0DFFF             call    00409448
0060F41C   83BD54FEFFFF00         cmp     dword ptr [ebp+$FFFFFE54], +$00
0060F423   7642                   jbe     0060F467
0060F425   8D9548FEFFFF           lea     edx, [ebp+$FFFFFE48]
0060F42B   8B03                   mov     eax, [ebx]
0060F42D   8B80C4080000           mov     eax, [eax+$08C4]
0060F433   8B08                   mov     ecx, [eax]
0060F435   FF5160                 call    dword ptr [ecx+$60]
0060F438   8B8D48FEFFFF           mov     ecx, [ebp+$FFFFFE48]
0060F43E   8D854CFEFFFF           lea     eax, [ebp+$FFFFFE4C]

* Possible String Reference to: '+ '
|
0060F444   BA380C6100             mov     edx, $00610C38

* Reference to: System.@LStrCat3;
|
0060F449   E81E5ADFFF             call    00404E6C
0060F44E   8B854CFEFFFF           mov     eax, [ebp+$FFFFFE4C]
0060F454   50                     push    eax
0060F455   8BCF                   mov     ecx, edi
0060F457   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F45C   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F462   E89506EDFF             call    004DFAFC
0060F467   47                     inc     edi
0060F468   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.WheelAccumulator : Integer
|
0060F46A   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060F470   E87700EAFF             call    004AF4EC
0060F475   8B03                   mov     eax, [ebx]

* Reference to field Integer.OFFS_00A4
|
0060F477   8B80A4000000           mov     eax, [eax+$00A4]
0060F47D   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060F484   7537                   jnz     0060F4BD
0060F486   8B03                   mov     eax, [ebx]
0060F488   8B809C000000           mov     eax, [eax+$009C]
0060F48E   8B55DC                 mov     edx, [ebp-$24]
0060F491   8B08                   mov     ecx, [eax]
0060F493   FF91A0010000           call    dword ptr [ecx+$01A0]
0060F499   8B03                   mov     eax, [ebx]
0060F49B   8B80B4030000           mov     eax, [eax+$03B4]
0060F4A1   8B10                   mov     edx, [eax]
0060F4A3   FF5258                 call    dword ptr [edx+$58]
0060F4A6   50                     push    eax
0060F4A7   8B03                   mov     eax, [ebx]
0060F4A9   8B8074080000           mov     eax, [eax+$0874]
0060F4AF   8B10                   mov     edx, [eax]
0060F4B1   FF5258                 call    dword ptr [edx+$58]
0060F4B4   5A                     pop     edx
0060F4B5   3BD0                   cmp     edx, eax
0060F4B7   0F8482FDFFFF           jz      0060F23F
0060F4BD   FF45F0                 inc     dword ptr [ebp-$10]
0060F4C0   FF4DA4                 dec     dword ptr [ebp-$5C]
0060F4C3   0F8551FAFFFF           jnz     0060EF1A
0060F4C9   8B03                   mov     eax, [ebx]
0060F4CB   8B809C000000           mov     eax, [eax+$009C]
0060F4D1   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060F4D3   E88436ECFF             call    004D2B5C
0060F4D8   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrLen(String):Integer;
|
0060F4DB   E84059DFFF             call    00404E20
0060F4E0   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
0060F4E6   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
0060F4EC   D8354C0C6100           fdiv    dword ptr [$00610C4C]

* Reference to: System.@ROUND;
|
0060F4F2   E83938DFFF             call    00402D30
0060F4F7   85C0                   test    eax, eax
0060F4F9   0F8E1D030000           jle     0060F81C
0060F4FF   8945A4                 mov     [ebp-$5C], eax
0060F502   C745F001000000         mov     dword ptr [ebp-$10], $00000001
0060F509   8D8544FEFFFF           lea     eax, [ebp+$FFFFFE44]
0060F50F   50                     push    eax
0060F510   8B45F0                 mov     eax, [ebp-$10]
0060F513   48                     dec     eax
0060F514   8BD0                   mov     edx, eax
0060F516   C1E203                 shl     edx, $03
0060F519   2BD0                   sub     edx, eax
0060F51B   42                     inc     edx
0060F51C   B906000000             mov     ecx, $00000006
0060F521   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrCopy;
|
0060F524   E84F5BDFFF             call    00405078
0060F529   8B8544FEFFFF           mov     eax, [ebp+$FFFFFE44]

* Reference to: Unit_00408494.Proc_004099B4
|
0060F52F   E880A4DFFF             call    004099B4
0060F534   89459C                 mov     [ebp-$64], eax
0060F537   C645A000               mov     byte ptr [ebp-$60], $00
0060F53B   8D559C                 lea     edx, [ebp-$64]
0060F53E   8B03                   mov     eax, [ebx]
0060F540   8B809C000000           mov     eax, [eax+$009C]
0060F546   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060F548   E8173DECFF             call    004D3264
0060F54D   8B03                   mov     eax, [ebx]
0060F54F   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
0060F555   BA640C6100             mov     edx, $00610C64

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060F55A   E8FD35ECFF             call    004D2B5C
0060F55F   8B03                   mov     eax, [ebx]
0060F561   8B8074080000           mov     eax, [eax+$0874]
0060F567   8B10                   mov     edx, [eax]
0060F569   FF5258                 call    dword ptr [edx+$58]
0060F56C   89459C                 mov     [ebp-$64], eax
0060F56F   C645A000               mov     byte ptr [ebp-$60], $00
0060F573   8D559C                 lea     edx, [ebp-$64]
0060F576   8B03                   mov     eax, [ebx]
0060F578   8B80A4000000           mov     eax, [eax+$00A4]
0060F57E   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060F580   E8DF3CECFF             call    004D3264
0060F585   84C0                   test    al, al
0060F587   0F8483020000           jz      0060F810
0060F58D   E95A020000             jmp     0060F7EC
0060F592   8B03                   mov     eax, [ebx]
0060F594   8B809C000000           mov     eax, [eax+$009C]
0060F59A   8B10                   mov     edx, [eax]
0060F59C   FF9250010000           call    dword ptr [edx+$0150]
0060F5A2   8945DC                 mov     [ebp-$24], eax
0060F5A5   8B03                   mov     eax, [ebx]
0060F5A7   8B80B8030000           mov     eax, [eax+$03B8]
0060F5AD   8B10                   mov     edx, [eax]
0060F5AF   FF5258                 call    dword ptr [edx+$58]
0060F5B2   89459C                 mov     [ebp-$64], eax
0060F5B5   C645A000               mov     byte ptr [ebp-$60], $00
0060F5B9   8D559C                 lea     edx, [ebp-$64]
0060F5BC   8B03                   mov     eax, [ebx]
0060F5BE   8B809C000000           mov     eax, [eax+$009C]
0060F5C4   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060F5C6   E8993CECFF             call    004D3264

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F5CB   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
0060F5D1   8B904C020000           mov     edx, [eax+$024C]
0060F5D7   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
0060F5D8   E8F3E2ECFF             call    004DD8D0
0060F5DD   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
0060F5DF   8B8074080000           mov     eax, [eax+$0874]
0060F5E5   8B10                   mov     edx, [eax]
0060F5E7   FF5258                 call    dword ptr [edx+$58]
0060F5EA   8D9540FEFFFF           lea     edx, [ebp+$FFFFFE40]

* Reference to: Unit_00408494.Proc_00409950
|
0060F5F0   E85BA3DFFF             call    00409950
0060F5F5   8B8540FEFFFF           mov     eax, [ebp+$FFFFFE40]
0060F5FB   50                     push    eax
0060F5FC   8BCF                   mov     ecx, edi
0060F5FE   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F600   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F606   E8F104EDFF             call    004DFAFC
0060F60B   8D9538FEFFFF           lea     edx, [ebp+$FFFFFE38]
0060F611   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
0060F613   8B8080080000           mov     eax, [eax+$0880]
0060F619   8B08                   mov     ecx, [eax]
0060F61B   FF5160                 call    dword ptr [ecx+$60]
0060F61E   FFB538FEFFFF           push    dword ptr [ebp+$FFFFFE38]
0060F624   68140C6100             push    $00610C14
0060F629   8D9534FEFFFF           lea     edx, [ebp+$FFFFFE34]
0060F62F   8B03                   mov     eax, [ebx]
0060F631   8B8084080000           mov     eax, [eax+$0884]
0060F637   8B08                   mov     ecx, [eax]
0060F639   FF5160                 call    dword ptr [ecx+$60]
0060F63C   FFB534FEFFFF           push    dword ptr [ebp+$FFFFFE34]
0060F642   8D853CFEFFFF           lea     eax, [ebp+$FFFFFE3C]
0060F648   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060F64D   E88E58DFFF             call    00404EE0
0060F652   8B853CFEFFFF           mov     eax, [ebp+$FFFFFE3C]
0060F658   50                     push    eax
0060F659   8BCF                   mov     ecx, edi
0060F65B   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F660   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F666   E89104EDFF             call    004DFAFC
0060F66B   8D952CFEFFFF           lea     edx, [ebp+$FFFFFE2C]
0060F671   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
0060F673   8B809C080000           mov     eax, [eax+$089C]
0060F679   8B08                   mov     ecx, [eax]
0060F67B   FF5160                 call    dword ptr [ecx+$60]
0060F67E   8B852CFEFFFF           mov     eax, [ebp+$FFFFFE2C]
0060F684   8D9530FEFFFF           lea     edx, [ebp+$FFFFFE30]

* Reference to: Unit_00408494.Proc_00409448
|
0060F68A   E8B99DDFFF             call    00409448
0060F68F   83BD30FEFFFF00         cmp     dword ptr [ebp+$FFFFFE30], +$00
0060F696   7644                   jbe     0060F6DC
0060F698   8D9524FEFFFF           lea     edx, [ebp+$FFFFFE24]
0060F69E   8B03                   mov     eax, [ebx]
0060F6A0   8B809C080000           mov     eax, [eax+$089C]
0060F6A6   8B08                   mov     ecx, [eax]
0060F6A8   FF5160                 call    dword ptr [ecx+$60]
0060F6AB   8B8D24FEFFFF           mov     ecx, [ebp+$FFFFFE24]
0060F6B1   8D8528FEFFFF           lea     eax, [ebp+$FFFFFE28]

* Possible String Reference to: '* '
|
0060F6B7   BA200C6100             mov     edx, $00610C20

* Reference to: System.@LStrCat3;
|
0060F6BC   E8AB57DFFF             call    00404E6C
0060F6C1   8B8528FEFFFF           mov     eax, [ebp+$FFFFFE28]
0060F6C7   50                     push    eax
0060F6C8   8BCF                   mov     ecx, edi
0060F6CA   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F6CF   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F6D5   E82204EDFF             call    004DFAFC
0060F6DA   EB6F                   jmp     0060F74B
0060F6DC   8D951CFEFFFF           lea     edx, [ebp+$FFFFFE1C]
0060F6E2   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
0060F6E4   8B80AC080000           mov     eax, [eax+$08AC]
0060F6EA   8B08                   mov     ecx, [eax]
0060F6EC   FF5160                 call    dword ptr [ecx+$60]
0060F6EF   8B851CFEFFFF           mov     eax, [ebp+$FFFFFE1C]
0060F6F5   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]

* Reference to: Unit_00408494.Proc_00409448
|
0060F6FB   E8489DDFFF             call    00409448
0060F700   83BD20FEFFFF00         cmp     dword ptr [ebp+$FFFFFE20], +$00
0060F707   7642                   jbe     0060F74B
0060F709   8D9514FEFFFF           lea     edx, [ebp+$FFFFFE14]
0060F70F   8B03                   mov     eax, [ebx]
0060F711   8B80AC080000           mov     eax, [eax+$08AC]
0060F717   8B08                   mov     ecx, [eax]
0060F719   FF5160                 call    dword ptr [ecx+$60]
0060F71C   8B8D14FEFFFF           mov     ecx, [ebp+$FFFFFE14]
0060F722   8D8518FEFFFF           lea     eax, [ebp+$FFFFFE18]

* Possible String Reference to: '~ '
|
0060F728   BA2C0C6100             mov     edx, $00610C2C

* Reference to: System.@LStrCat3;
|
0060F72D   E83A57DFFF             call    00404E6C
0060F732   8B8518FEFFFF           mov     eax, [ebp+$FFFFFE18]
0060F738   50                     push    eax
0060F739   8BCF                   mov     ecx, edi
0060F73B   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F740   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F746   E8B103EDFF             call    004DFAFC
0060F74B   8D950CFEFFFF           lea     edx, [ebp+$FFFFFE0C]
0060F751   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
0060F753   8B80C4080000           mov     eax, [eax+$08C4]
0060F759   8B08                   mov     ecx, [eax]
0060F75B   FF5160                 call    dword ptr [ecx+$60]
0060F75E   8B850CFEFFFF           mov     eax, [ebp+$FFFFFE0C]
0060F764   8D9510FEFFFF           lea     edx, [ebp+$FFFFFE10]

* Reference to: Unit_00408494.Proc_00409448
|
0060F76A   E8D99CDFFF             call    00409448
0060F76F   83BD10FEFFFF00         cmp     dword ptr [ebp+$FFFFFE10], +$00
0060F776   7642                   jbe     0060F7BA
0060F778   8D9504FEFFFF           lea     edx, [ebp+$FFFFFE04]
0060F77E   8B03                   mov     eax, [ebx]
0060F780   8B80C4080000           mov     eax, [eax+$08C4]
0060F786   8B08                   mov     ecx, [eax]
0060F788   FF5160                 call    dword ptr [ecx+$60]
0060F78B   8B8D04FEFFFF           mov     ecx, [ebp+$FFFFFE04]
0060F791   8D8508FEFFFF           lea     eax, [ebp+$FFFFFE08]

* Possible String Reference to: '+ '
|
0060F797   BA380C6100             mov     edx, $00610C38

* Reference to: System.@LStrCat3;
|
0060F79C   E8CB56DFFF             call    00404E6C
0060F7A1   8B8508FEFFFF           mov     eax, [ebp+$FFFFFE08]
0060F7A7   50                     push    eax
0060F7A8   8BCF                   mov     ecx, edi
0060F7AA   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0060F7AF   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0060F7B5   E84203EDFF             call    004DFAFC
0060F7BA   47                     inc     edi
0060F7BB   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.WheelAccumulator : Integer
|
0060F7BD   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060F7C3   E824FDE9FF             call    004AF4EC
0060F7C8   8B03                   mov     eax, [ebx]

* Reference to field Integer.OFFS_00A4
|
0060F7CA   8B80A4000000           mov     eax, [eax+$00A4]
0060F7D0   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060F7D7   7537                   jnz     0060F810
0060F7D9   8B03                   mov     eax, [ebx]
0060F7DB   8B809C000000           mov     eax, [eax+$009C]
0060F7E1   8B55DC                 mov     edx, [ebp-$24]
0060F7E4   8B08                   mov     ecx, [eax]
0060F7E6   FF91A0010000           call    dword ptr [ecx+$01A0]
0060F7EC   8B03                   mov     eax, [ebx]
0060F7EE   8B80B4030000           mov     eax, [eax+$03B4]
0060F7F4   8B10                   mov     edx, [eax]
0060F7F6   FF5258                 call    dword ptr [edx+$58]
0060F7F9   50                     push    eax
0060F7FA   8B03                   mov     eax, [ebx]
0060F7FC   8B8074080000           mov     eax, [eax+$0874]
0060F802   8B10                   mov     edx, [eax]
0060F804   FF5258                 call    dword ptr [edx+$58]
0060F807   5A                     pop     edx
0060F808   3BD0                   cmp     edx, eax
0060F80A   0F8482FDFFFF           jz      0060F592
0060F810   FF45F0                 inc     dword ptr [ebp-$10]
0060F813   FF4DA4                 dec     dword ptr [ebp-$5C]
0060F816   0F85EDFCFFFF           jnz     0060F509
0060F81C   8B03                   mov     eax, [ebx]
0060F81E   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
0060F824   BAC00B6100             mov     edx, $00610BC0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060F829   E82E33ECFF             call    004D2B5C
0060F82E   8B03                   mov     eax, [ebx]
0060F830   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060F836   E899F9E9FF             call    004AF1D4
0060F83B   8D45B0                 lea     eax, [ebp-$50]

* Reference to: System.@LStrClr(void;void);
|
0060F83E   E82553DFFF             call    00404B68
0060F843   837DEC00               cmp     dword ptr [ebp-$14], +$00
0060F847   0F8E93000000           jle     0060F8E0

* Reference to Form1
|
0060F84D   8B45EC                 mov     eax, [ebp-$14]
0060F850   89459C                 mov     [ebp-$64], eax
0060F853   C645A000               mov     byte ptr [ebp-$60], $00
0060F857   8D559C                 lea     edx, [ebp-$64]
0060F85A   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_009C
|
0060F85C   8B809C000000           mov     eax, [eax+$009C]
0060F862   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060F864   E8FB39ECFF             call    004D3264
0060F869   EB63                   jmp     0060F8CE
0060F86B   8B03                   mov     eax, [ebx]
0060F86D   8B8074080000           mov     eax, [eax+$0874]
0060F873   8B10                   mov     edx, [eax]
0060F875   FF5258                 call    dword ptr [edx+$58]
0060F878   3B45F8                 cmp     eax, [ebp-$08]
0060F87B   7433                   jz      0060F8B0
0060F87D   FF75B0                 push    dword ptr [ebp-$50]
0060F880   8B03                   mov     eax, [ebx]
0060F882   8B8074080000           mov     eax, [eax+$0874]
0060F888   8B10                   mov     edx, [eax]
0060F88A   FF5258                 call    dword ptr [edx+$58]
0060F88D   8D9500FEFFFF           lea     edx, [ebp+$FFFFFE00]

* Reference to : TForm1.Proc_005D3228()
|
0060F893   E89039FCFF             call    005D3228
0060F898   FFB500FEFFFF           push    dword ptr [ebp+$FFFFFE00]
0060F89E   68D80B6100             push    $00610BD8
0060F8A3   8D45B0                 lea     eax, [ebp-$50]
0060F8A6   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060F8AB   E83056DFFF             call    00404EE0
0060F8B0   8B03                   mov     eax, [ebx]
0060F8B2   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060F8B8   E82FFCE9FF             call    004AF4EC
0060F8BD   8B03                   mov     eax, [ebx]
0060F8BF   8B809C000000           mov     eax, [eax+$009C]
0060F8C5   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060F8CC   7512                   jnz     0060F8E0
0060F8CE   8B03                   mov     eax, [ebx]
0060F8D0   8B8078080000           mov     eax, [eax+$0878]
0060F8D6   8B10                   mov     edx, [eax]
0060F8D8   FF5258                 call    dword ptr [edx+$58]
0060F8DB   3B45EC                 cmp     eax, [ebp-$14]
0060F8DE   748B                   jz      0060F86B
0060F8E0   8B03                   mov     eax, [ebx]
0060F8E2   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Open(TDataSet);
|
0060F8E8   E89BD3E9FF             call    004ACC88
0060F8ED   8B03                   mov     eax, [ebx]
0060F8EF   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
0060F8F5   BA640C6100             mov     edx, $00610C64

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060F8FA   E85D32ECFF             call    004D2B5C

* Reference to Form1
|
0060F8FF   8B45EC                 mov     eax, [ebp-$14]
0060F902   89459C                 mov     [ebp-$64], eax
0060F905   C645A000               mov     byte ptr [ebp-$60], $00
0060F909   8D559C                 lea     edx, [ebp-$64]
0060F90C   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_00A4
|
0060F90E   8B80A4000000           mov     eax, [eax+$00A4]
0060F914   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060F916   E84939ECFF             call    004D3264
0060F91B   84C0                   test    al, al
0060F91D   0F841D010000           jz      0060FA40
0060F923   E902010000             jmp     0060FA2A
0060F928   8B03                   mov     eax, [ebx]
0060F92A   8B80B8030000           mov     eax, [eax+$03B8]
0060F930   8B10                   mov     edx, [eax]
0060F932   FF5258                 call    dword ptr [edx+$58]
0060F935   3B45E4                 cmp     eax, [ebp-$1C]
0060F938   0F84CE000000           jz      0060FA0C
0060F93E   8B03                   mov     eax, [ebx]
0060F940   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
0060F946   BAF00B6100             mov     edx, $00610BF0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060F94B   E80C32ECFF             call    004D2B5C
0060F950   8B03                   mov     eax, [ebx]
0060F952   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060F958   E877F8E9FF             call    004AF1D4
0060F95D   8B03                   mov     eax, [ebx]
0060F95F   8B80B8030000           mov     eax, [eax+$03B8]
0060F965   8B10                   mov     edx, [eax]
0060F967   FF5258                 call    dword ptr [edx+$58]
0060F96A   89459C                 mov     [ebp-$64], eax
0060F96D   C645A000               mov     byte ptr [ebp-$60], $00
0060F971   8D559C                 lea     edx, [ebp-$64]
0060F974   8B03                   mov     eax, [ebx]
0060F976   8B809C000000           mov     eax, [eax+$009C]
0060F97C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060F97E   E8E138ECFF             call    004D3264
0060F983   EB63                   jmp     0060F9E8
0060F985   8B03                   mov     eax, [ebx]
0060F987   8B8074080000           mov     eax, [eax+$0874]
0060F98D   8B10                   mov     edx, [eax]
0060F98F   FF5258                 call    dword ptr [edx+$58]
0060F992   3B45F8                 cmp     eax, [ebp-$08]
0060F995   7433                   jz      0060F9CA
0060F997   FF75B0                 push    dword ptr [ebp-$50]
0060F99A   8B03                   mov     eax, [ebx]
0060F99C   8B8074080000           mov     eax, [eax+$0874]
0060F9A2   8B10                   mov     edx, [eax]
0060F9A4   FF5258                 call    dword ptr [edx+$58]
0060F9A7   8D95FCFDFFFF           lea     edx, [ebp+$FFFFFDFC]

* Reference to : TForm1.Proc_005D3228()
|
0060F9AD   E87638FCFF             call    005D3228
0060F9B2   FFB5FCFDFFFF           push    dword ptr [ebp+$FFFFFDFC]
0060F9B8   68D80B6100             push    $00610BD8
0060F9BD   8D45B0                 lea     eax, [ebp-$50]
0060F9C0   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060F9C5   E81655DFFF             call    00404EE0
0060F9CA   8B03                   mov     eax, [ebx]
0060F9CC   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060F9D2   E815FBE9FF             call    004AF4EC
0060F9D7   8B03                   mov     eax, [ebx]
0060F9D9   8B809C000000           mov     eax, [eax+$009C]
0060F9DF   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060F9E6   7524                   jnz     0060FA0C
0060F9E8   8B03                   mov     eax, [ebx]
0060F9EA   8B8078080000           mov     eax, [eax+$0878]
0060F9F0   8B10                   mov     edx, [eax]
0060F9F2   FF5258                 call    dword ptr [edx+$58]
0060F9F5   8BF8                   mov     edi, eax
0060F9F7   8B03                   mov     eax, [ebx]
0060F9F9   8B80B8030000           mov     eax, [eax+$03B8]
0060F9FF   8B10                   mov     edx, [eax]
0060FA01   FF5258                 call    dword ptr [edx+$58]
0060FA04   3BF8                   cmp     edi, eax
0060FA06   0F8479FFFFFF           jz      0060F985
0060FA0C   8B03                   mov     eax, [ebx]
0060FA0E   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060FA14   E8D3FAE9FF             call    004AF4EC
0060FA19   8B03                   mov     eax, [ebx]
0060FA1B   8B80A4000000           mov     eax, [eax+$00A4]
0060FA21   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060FA28   7516                   jnz     0060FA40
0060FA2A   8B03                   mov     eax, [ebx]
0060FA2C   8B80B4030000           mov     eax, [eax+$03B4]
0060FA32   8B10                   mov     edx, [eax]
0060FA34   FF5258                 call    dword ptr [edx+$58]
0060FA37   3B45EC                 cmp     eax, [ebp-$14]
0060FA3A   0F84E8FEFFFF           jz      0060F928
0060FA40   8B03                   mov     eax, [ebx]
0060FA42   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
0060FA48   BA640C6100             mov     edx, $00610C64

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060FA4D   E80A31ECFF             call    004D2B5C
0060FA52   8B03                   mov     eax, [ebx]
0060FA54   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060FA5A   E875F7E9FF             call    004AF1D4

* Reference to Form1
|
0060FA5F   8B45F8                 mov     eax, [ebp-$08]
0060FA62   89459C                 mov     [ebp-$64], eax
0060FA65   C645A000               mov     byte ptr [ebp-$60], $00
0060FA69   8D559C                 lea     edx, [ebp-$64]
0060FA6C   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_00A4
|
0060FA6E   8B80A4000000           mov     eax, [eax+$00A4]
0060FA74   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060FA76   E8E937ECFF             call    004D3264
0060FA7B   84C0                   test    al, al
0060FA7D   0F841A030000           jz      0060FD9D
0060FA83   E9FF020000             jmp     0060FD87
0060FA88   8B03                   mov     eax, [ebx]
0060FA8A   8B80B8030000           mov     eax, [eax+$03B8]
0060FA90   8B10                   mov     edx, [eax]
0060FA92   FF5258                 call    dword ptr [edx+$58]
0060FA95   85C0                   test    eax, eax
0060FA97   0F8ECC020000           jle     0060FD69
0060FA9D   8B03                   mov     eax, [ebx]
0060FA9F   8B80B8030000           mov     eax, [eax+$03B8]
0060FAA5   8B10                   mov     edx, [eax]
0060FAA7   FF5258                 call    dword ptr [edx+$58]
0060FAAA   8945C8                 mov     [ebp-$38], eax
0060FAAD   8B03                   mov     eax, [ebx]
0060FAAF   8B809C000000           mov     eax, [eax+$009C]
0060FAB5   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060FAB7   E8A030ECFF             call    004D2B5C
0060FABC   8B03                   mov     eax, [ebx]
0060FABE   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060FAC4   E80BF7E9FF             call    004AF1D4
0060FAC9   8B03                   mov     eax, [ebx]
0060FACB   8B80B8030000           mov     eax, [eax+$03B8]
0060FAD1   8B10                   mov     edx, [eax]
0060FAD3   FF5258                 call    dword ptr [edx+$58]
0060FAD6   89459C                 mov     [ebp-$64], eax
0060FAD9   C645A000               mov     byte ptr [ebp-$60], $00
0060FADD   8D559C                 lea     edx, [ebp-$64]
0060FAE0   8B03                   mov     eax, [ebx]
0060FAE2   8B809C000000           mov     eax, [eax+$009C]
0060FAE8   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060FAEA   E87537ECFF             call    004D3264
0060FAEF   8B03                   mov     eax, [ebx]
0060FAF1   8B8078080000           mov     eax, [eax+$0878]
0060FAF7   8B10                   mov     edx, [eax]
0060FAF9   FF5258                 call    dword ptr [edx+$58]
0060FAFC   85C0                   test    eax, eax
0060FAFE   0F8E10010000           jle     0060FC14
0060FB04   8B03                   mov     eax, [ebx]
0060FB06   8B8078080000           mov     eax, [eax+$0878]
0060FB0C   8B10                   mov     edx, [eax]
0060FB0E   FF5258                 call    dword ptr [edx+$58]
0060FB11   8BF8                   mov     edi, eax
0060FB13   8B03                   mov     eax, [ebx]
0060FB15   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
0060FB1B   BAC00B6100             mov     edx, $00610BC0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060FB20   E83730ECFF             call    004D2B5C
0060FB25   8B03                   mov     eax, [ebx]
0060FB27   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060FB2D   E8A2F6E9FF             call    004AF1D4
0060FB32   897D9C                 mov     [ebp-$64], edi
0060FB35   C645A000               mov     byte ptr [ebp-$60], $00
0060FB39   8D559C                 lea     edx, [ebp-$64]
0060FB3C   8B03                   mov     eax, [ebx]
0060FB3E   8B809C000000           mov     eax, [eax+$009C]
0060FB44   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060FB46   E81937ECFF             call    004D3264
0060FB4B   E9AF000000             jmp     0060FBFF
0060FB50   8B03                   mov     eax, [ebx]
0060FB52   8B807C080000           mov     eax, [eax+$087C]
0060FB58   8B10                   mov     edx, [eax]
0060FB5A   FF5258                 call    dword ptr [edx+$58]
0060FB5D   3B45F8                 cmp     eax, [ebp-$08]
0060FB60   747F                   jz      0060FBE1
0060FB62   8B03                   mov     eax, [ebx]
0060FB64   8B8074080000           mov     eax, [eax+$0874]
0060FB6A   8B10                   mov     edx, [eax]
0060FB6C   FF5258                 call    dword ptr [edx+$58]
0060FB6F   3B45C8                 cmp     eax, [ebp-$38]
0060FB72   746D                   jz      0060FBE1
0060FB74   8B03                   mov     eax, [ebx]
0060FB76   8B8074080000           mov     eax, [eax+$0874]
0060FB7C   8B10                   mov     edx, [eax]
0060FB7E   FF5258                 call    dword ptr [edx+$58]
0060FB81   8D95F8FDFFFF           lea     edx, [ebp+$FFFFFDF8]

* Reference to : TForm1.Proc_005D3228()
|
0060FB87   E89C36FCFF             call    005D3228
0060FB8C   8D85F8FDFFFF           lea     eax, [ebp+$FFFFFDF8]
0060FB92   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
0060FB97   E88C52DFFF             call    00404E28
0060FB9C   8B85F8FDFFFF           mov     eax, [ebp+$FFFFFDF8]
0060FBA2   8B55B0                 mov     edx, [ebp-$50]

* Reference to: System.@LStrPos;
|
0060FBA5   E8B255DFFF             call    0040515C
0060FBAA   85C0                   test    eax, eax
0060FBAC   7533                   jnz     0060FBE1
0060FBAE   FF75B0                 push    dword ptr [ebp-$50]
0060FBB1   8B03                   mov     eax, [ebx]
0060FBB3   8B8074080000           mov     eax, [eax+$0874]
0060FBB9   8B10                   mov     edx, [eax]
0060FBBB   FF5258                 call    dword ptr [edx+$58]
0060FBBE   8D95F4FDFFFF           lea     edx, [ebp+$FFFFFDF4]

* Reference to : TForm1.Proc_005D3228()
|
0060FBC4   E85F36FCFF             call    005D3228
0060FBC9   FFB5F4FDFFFF           push    dword ptr [ebp+$FFFFFDF4]
0060FBCF   68D80B6100             push    $00610BD8
0060FBD4   8D45B0                 lea     eax, [ebp-$50]
0060FBD7   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060FBDC   E8FF52DFFF             call    00404EE0
0060FBE1   8B03                   mov     eax, [ebx]
0060FBE3   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060FBE9   E8FEF8E9FF             call    004AF4EC
0060FBEE   8B03                   mov     eax, [ebx]
0060FBF0   8B809C000000           mov     eax, [eax+$009C]
0060FBF6   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060FBFD   7515                   jnz     0060FC14
0060FBFF   8B03                   mov     eax, [ebx]
0060FC01   8B8078080000           mov     eax, [eax+$0878]
0060FC07   8B10                   mov     edx, [eax]
0060FC09   FF5258                 call    dword ptr [edx+$58]
0060FC0C   3BF8                   cmp     edi, eax
0060FC0E   0F843CFFFFFF           jz      0060FB50
0060FC14   8B03                   mov     eax, [ebx]
0060FC16   8B809C000000           mov     eax, [eax+$009C]
0060FC1C   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060FC1E   E8392FECFF             call    004D2B5C
0060FC23   8B03                   mov     eax, [ebx]
0060FC25   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060FC2B   E8A4F5E9FF             call    004AF1D4
0060FC30   8B03                   mov     eax, [ebx]
0060FC32   8B80B8030000           mov     eax, [eax+$03B8]
0060FC38   8B10                   mov     edx, [eax]
0060FC3A   FF5258                 call    dword ptr [edx+$58]
0060FC3D   89459C                 mov     [ebp-$64], eax
0060FC40   C645A000               mov     byte ptr [ebp-$60], $00
0060FC44   8D559C                 lea     edx, [ebp-$64]
0060FC47   8B03                   mov     eax, [ebx]
0060FC49   8B809C000000           mov     eax, [eax+$009C]
0060FC4F   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060FC51   E80E36ECFF             call    004D3264
0060FC56   8B03                   mov     eax, [ebx]
0060FC58   8B807C080000           mov     eax, [eax+$087C]
0060FC5E   8B10                   mov     edx, [eax]
0060FC60   FF5258                 call    dword ptr [edx+$58]
0060FC63   85C0                   test    eax, eax
0060FC65   0F8EFE000000           jle     0060FD69
0060FC6B   8B03                   mov     eax, [ebx]
0060FC6D   8B807C080000           mov     eax, [eax+$087C]
0060FC73   8B10                   mov     edx, [eax]
0060FC75   FF5258                 call    dword ptr [edx+$58]
0060FC78   8BF8                   mov     edi, eax
0060FC7A   8B03                   mov     eax, [ebx]
0060FC7C   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
0060FC82   BAF00B6100             mov     edx, $00610BF0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060FC87   E8D02EECFF             call    004D2B5C
0060FC8C   8B03                   mov     eax, [ebx]
0060FC8E   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060FC94   E83BF5E9FF             call    004AF1D4
0060FC99   897D9C                 mov     [ebp-$64], edi
0060FC9C   C645A000               mov     byte ptr [ebp-$60], $00
0060FCA0   8D559C                 lea     edx, [ebp-$64]
0060FCA3   8B03                   mov     eax, [ebx]
0060FCA5   8B809C000000           mov     eax, [eax+$009C]
0060FCAB   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060FCAD   E8B235ECFF             call    004D3264
0060FCB2   E99D000000             jmp     0060FD54
0060FCB7   8B03                   mov     eax, [ebx]
0060FCB9   8B8078080000           mov     eax, [eax+$0878]
0060FCBF   8B10                   mov     edx, [eax]
0060FCC1   FF5258                 call    dword ptr [edx+$58]
0060FCC4   3B45F8                 cmp     eax, [ebp-$08]
0060FCC7   746D                   jz      0060FD36
0060FCC9   8B03                   mov     eax, [ebx]
0060FCCB   8B8074080000           mov     eax, [eax+$0874]
0060FCD1   8B10                   mov     edx, [eax]
0060FCD3   FF5258                 call    dword ptr [edx+$58]
0060FCD6   8D95F0FDFFFF           lea     edx, [ebp+$FFFFFDF0]

* Reference to : TForm1.Proc_005D3228()
|
0060FCDC   E84735FCFF             call    005D3228
0060FCE1   8D85F0FDFFFF           lea     eax, [ebp+$FFFFFDF0]
0060FCE7   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
0060FCEC   E83751DFFF             call    00404E28
0060FCF1   8B85F0FDFFFF           mov     eax, [ebp+$FFFFFDF0]
0060FCF7   8B55B0                 mov     edx, [ebp-$50]

* Reference to: System.@LStrPos;
|
0060FCFA   E85D54DFFF             call    0040515C
0060FCFF   85C0                   test    eax, eax
0060FD01   7533                   jnz     0060FD36
0060FD03   FF75B0                 push    dword ptr [ebp-$50]
0060FD06   8B03                   mov     eax, [ebx]
0060FD08   8B8074080000           mov     eax, [eax+$0874]
0060FD0E   8B10                   mov     edx, [eax]
0060FD10   FF5258                 call    dword ptr [edx+$58]
0060FD13   8D95ECFDFFFF           lea     edx, [ebp+$FFFFFDEC]

* Reference to : TForm1.Proc_005D3228()
|
0060FD19   E80A35FCFF             call    005D3228
0060FD1E   FFB5ECFDFFFF           push    dword ptr [ebp+$FFFFFDEC]
0060FD24   68D80B6100             push    $00610BD8
0060FD29   8D45B0                 lea     eax, [ebp-$50]
0060FD2C   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060FD31   E8AA51DFFF             call    00404EE0
0060FD36   8B03                   mov     eax, [ebx]
0060FD38   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060FD3E   E8A9F7E9FF             call    004AF4EC
0060FD43   8B03                   mov     eax, [ebx]
0060FD45   8B809C000000           mov     eax, [eax+$009C]
0060FD4B   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060FD52   7515                   jnz     0060FD69
0060FD54   8B03                   mov     eax, [ebx]
0060FD56   8B807C080000           mov     eax, [eax+$087C]
0060FD5C   8B10                   mov     edx, [eax]
0060FD5E   FF5258                 call    dword ptr [edx+$58]
0060FD61   3BF8                   cmp     edi, eax
0060FD63   0F844EFFFFFF           jz      0060FCB7
0060FD69   8B03                   mov     eax, [ebx]
0060FD6B   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060FD71   E876F7E9FF             call    004AF4EC
0060FD76   8B03                   mov     eax, [ebx]
0060FD78   8B80A4000000           mov     eax, [eax+$00A4]
0060FD7E   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060FD85   7516                   jnz     0060FD9D
0060FD87   8B03                   mov     eax, [ebx]
0060FD89   8B80B4030000           mov     eax, [eax+$03B4]
0060FD8F   8B10                   mov     edx, [eax]
0060FD91   FF5258                 call    dword ptr [edx+$58]
0060FD94   3B45F8                 cmp     eax, [ebp-$08]
0060FD97   0F84EBFCFFFF           jz      0060FA88
0060FD9D   8D45AC                 lea     eax, [ebp-$54]

* Reference to: System.@LStrClr(void;void);
|
0060FDA0   E8C34DDFFF             call    00404B68
0060FDA5   8D95E8FDFFFF           lea     edx, [ebp+$FFFFFDE8]
0060FDAB   8B45B0                 mov     eax, [ebp-$50]

* Reference to: Unit_00408494.Proc_00409448
|
0060FDAE   E89596DFFF             call    00409448
0060FDB3   8B85E8FDFFFF           mov     eax, [ebp+$FFFFFDE8]

* Reference to: System.@LStrLen(String):Integer;
|
0060FDB9   E86250DFFF             call    00404E20
0060FDBE   85C0                   test    eax, eax
0060FDC0   0F8E07040000           jle     006101CD
0060FDC6   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrLen(String):Integer;
|
0060FDC9   E85250DFFF             call    00404E20
0060FDCE   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
0060FDD4   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
0060FDDA   D8354C0C6100           fdiv    dword ptr [$00610C4C]

* Reference to: System.@ROUND;
|
0060FDE0   E84B2FDFFF             call    00402D30
0060FDE5   85C0                   test    eax, eax
0060FDE7   0F8EE0030000           jle     006101CD
0060FDED   8945A4                 mov     [ebp-$5C], eax
0060FDF0   C745F001000000         mov     dword ptr [ebp-$10], $00000001
0060FDF7   8B03                   mov     eax, [ebx]
0060FDF9   8B809C000000           mov     eax, [eax+$009C]
0060FDFF   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060FE01   E8562DECFF             call    004D2B5C
0060FE06   8D85E4FDFFFF           lea     eax, [ebp+$FFFFFDE4]
0060FE0C   50                     push    eax
0060FE0D   8B45F0                 mov     eax, [ebp-$10]
0060FE10   48                     dec     eax
0060FE11   8BF8                   mov     edi, eax
0060FE13   C1E703                 shl     edi, $03
0060FE16   2BF8                   sub     edi, eax
0060FE18   47                     inc     edi
0060FE19   8BD7                   mov     edx, edi
0060FE1B   B906000000             mov     ecx, $00000006
0060FE20   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrCopy;
|
0060FE23   E85052DFFF             call    00405078
0060FE28   8B85E4FDFFFF           mov     eax, [ebp+$FFFFFDE4]

* Reference to: Unit_00408494.Proc_004099B4
|
0060FE2E   E8819BDFFF             call    004099B4
0060FE33   89459C                 mov     [ebp-$64], eax
0060FE36   C645A000               mov     byte ptr [ebp-$60], $00
0060FE3A   8D559C                 lea     edx, [ebp-$64]
0060FE3D   8B03                   mov     eax, [ebx]
0060FE3F   8B809C000000           mov     eax, [eax+$009C]
0060FE45   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060FE47   E81834ECFF             call    004D3264
0060FE4C   8D95DCFDFFFF           lea     edx, [ebp+$FFFFFDDC]
0060FE52   8B03                   mov     eax, [ebx]
0060FE54   8B8088080000           mov     eax, [eax+$0888]
0060FE5A   8B08                   mov     ecx, [eax]
0060FE5C   FF5160                 call    dword ptr [ecx+$60]
0060FE5F   8B85DCFDFFFF           mov     eax, [ebp+$FFFFFDDC]
0060FE65   8D95E0FDFFFF           lea     edx, [ebp+$FFFFFDE0]

* Reference to: Unit_00408494.Proc_004091D8
|
0060FE6B   E86893DFFF             call    004091D8
0060FE70   8B85E0FDFFFF           mov     eax, [ebp+$FFFFFDE0]
0060FE76   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
0060FE7B   E8E450DFFF             call    00404F64
0060FE80   0F8580010000           jnz     00610006
0060FE86   8B03                   mov     eax, [ebx]
0060FE88   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
0060FE8E   BAC00B6100             mov     edx, $00610BC0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060FE93   E8C42CECFF             call    004D2B5C
0060FE98   8B03                   mov     eax, [ebx]
0060FE9A   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060FEA0   E82FF3E9FF             call    004AF1D4
0060FEA5   8D85D8FDFFFF           lea     eax, [ebp+$FFFFFDD8]
0060FEAB   50                     push    eax
0060FEAC   8BD7                   mov     edx, edi
0060FEAE   B906000000             mov     ecx, $00000006
0060FEB3   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrCopy;
|
0060FEB6   E8BD51DFFF             call    00405078
0060FEBB   8B85D8FDFFFF           mov     eax, [ebp+$FFFFFDD8]

* Reference to: Unit_00408494.Proc_004099B4
|
0060FEC1   E8EE9ADFFF             call    004099B4
0060FEC6   89459C                 mov     [ebp-$64], eax
0060FEC9   C645A000               mov     byte ptr [ebp-$60], $00
0060FECD   8D559C                 lea     edx, [ebp-$64]
0060FED0   8B03                   mov     eax, [ebx]
0060FED2   8B809C000000           mov     eax, [eax+$009C]
0060FED8   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060FEDA   E88533ECFF             call    004D3264
0060FEDF   E9DB000000             jmp     0060FFBF
0060FEE4   8B03                   mov     eax, [ebx]
0060FEE6   8B8074080000           mov     eax, [eax+$0874]
0060FEEC   8B10                   mov     edx, [eax]
0060FEEE   FF5258                 call    dword ptr [edx+$58]
0060FEF1   3B45F8                 cmp     eax, [ebp-$08]
0060FEF4   0F84A3000000           jz      0060FF9D
0060FEFA   8D95D0FDFFFF           lea     edx, [ebp+$FFFFFDD0]
0060FF00   8B03                   mov     eax, [ebx]
0060FF02   8B8088080000           mov     eax, [eax+$0888]
0060FF08   8B08                   mov     ecx, [eax]
0060FF0A   FF5160                 call    dword ptr [ecx+$60]
0060FF0D   8B85D0FDFFFF           mov     eax, [ebp+$FFFFFDD0]
0060FF13   8D95D4FDFFFF           lea     edx, [ebp+$FFFFFDD4]

* Reference to: Unit_00408494.Proc_004091D8
|
0060FF19   E8BA92DFFF             call    004091D8
0060FF1E   8B85D4FDFFFF           mov     eax, [ebp+$FFFFFDD4]
0060FF24   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
0060FF29   E83650DFFF             call    00404F64
0060FF2E   756D                   jnz     0060FF9D
0060FF30   8B03                   mov     eax, [ebx]
0060FF32   8B8074080000           mov     eax, [eax+$0874]
0060FF38   8B10                   mov     edx, [eax]
0060FF3A   FF5258                 call    dword ptr [edx+$58]
0060FF3D   8D95CCFDFFFF           lea     edx, [ebp+$FFFFFDCC]

* Reference to : TForm1.Proc_005D3228()
|
0060FF43   E8E032FCFF             call    005D3228
0060FF48   8D85CCFDFFFF           lea     eax, [ebp+$FFFFFDCC]
0060FF4E   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
0060FF53   E8D04EDFFF             call    00404E28
0060FF58   8B85CCFDFFFF           mov     eax, [ebp+$FFFFFDCC]
0060FF5E   8B55AC                 mov     edx, [ebp-$54]

* Reference to: System.@LStrPos;
|
0060FF61   E8F651DFFF             call    0040515C
0060FF66   85C0                   test    eax, eax
0060FF68   7533                   jnz     0060FF9D
0060FF6A   FF75AC                 push    dword ptr [ebp-$54]
0060FF6D   8B03                   mov     eax, [ebx]
0060FF6F   8B8074080000           mov     eax, [eax+$0874]
0060FF75   8B10                   mov     edx, [eax]
0060FF77   FF5258                 call    dword ptr [edx+$58]
0060FF7A   8D95C8FDFFFF           lea     edx, [ebp+$FFFFFDC8]

* Reference to : TForm1.Proc_005D3228()
|
0060FF80   E8A332FCFF             call    005D3228
0060FF85   FFB5C8FDFFFF           push    dword ptr [ebp+$FFFFFDC8]
0060FF8B   68D80B6100             push    $00610BD8
0060FF90   8D45AC                 lea     eax, [ebp-$54]
0060FF93   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060FF98   E8434FDFFF             call    00404EE0
0060FF9D   8B03                   mov     eax, [ebx]
0060FF9F   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060FFA5   E842F5E9FF             call    004AF4EC
0060FFAA   8B03                   mov     eax, [ebx]
0060FFAC   8B809C000000           mov     eax, [eax+$009C]
0060FFB2   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060FFB9   0F8502020000           jnz     006101C1
0060FFBF   8D85C4FDFFFF           lea     eax, [ebp+$FFFFFDC4]
0060FFC5   50                     push    eax
0060FFC6   8B45F0                 mov     eax, [ebp-$10]
0060FFC9   48                     dec     eax
0060FFCA   8BD0                   mov     edx, eax
0060FFCC   C1E203                 shl     edx, $03
0060FFCF   2BD0                   sub     edx, eax
0060FFD1   42                     inc     edx
0060FFD2   B906000000             mov     ecx, $00000006
0060FFD7   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrCopy;
|
0060FFDA   E89950DFFF             call    00405078
0060FFDF   8B85C4FDFFFF           mov     eax, [ebp+$FFFFFDC4]

* Reference to: Unit_00408494.Proc_004099B4
|
0060FFE5   E8CA99DFFF             call    004099B4
0060FFEA   8BF8                   mov     edi, eax
0060FFEC   8B03                   mov     eax, [ebx]
0060FFEE   8B8078080000           mov     eax, [eax+$0878]
0060FFF4   8B10                   mov     edx, [eax]
0060FFF6   FF5258                 call    dword ptr [edx+$58]
0060FFF9   3BF8                   cmp     edi, eax
0060FFFB   0F84E3FEFFFF           jz      0060FEE4
00610001   E9BB010000             jmp     006101C1
00610006   8D95BCFDFFFF           lea     edx, [ebp+$FFFFFDBC]
0061000C   8B03                   mov     eax, [ebx]
0061000E   8B8088080000           mov     eax, [eax+$0888]
00610014   8B08                   mov     ecx, [eax]
00610016   FF5160                 call    dword ptr [ecx+$60]
00610019   8B85BCFDFFFF           mov     eax, [ebp+$FFFFFDBC]
0061001F   8D95C0FDFFFF           lea     edx, [ebp+$FFFFFDC0]

* Reference to: Unit_00408494.Proc_004091D8
|
00610025   E8AE91DFFF             call    004091D8
0061002A   8B85C0FDFFFF           mov     eax, [ebp+$FFFFFDC0]
00610030   BAE40B6100             mov     edx, $00610BE4

* Reference to: System.@LStrCmp;
|
00610035   E82A4FDFFF             call    00404F64
0061003A   0F8581010000           jnz     006101C1
00610040   8B03                   mov     eax, [ebx]
00610042   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
00610048   BAF00B6100             mov     edx, $00610BF0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0061004D   E80A2BECFF             call    004D2B5C
00610052   8B03                   mov     eax, [ebx]
00610054   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0061005A   E875F1E9FF             call    004AF1D4
0061005F   8D85B8FDFFFF           lea     eax, [ebp+$FFFFFDB8]
00610065   50                     push    eax
00610066   8B45F0                 mov     eax, [ebp-$10]
00610069   48                     dec     eax
0061006A   8BD0                   mov     edx, eax
0061006C   C1E203                 shl     edx, $03
0061006F   2BD0                   sub     edx, eax
00610071   42                     inc     edx
00610072   B906000000             mov     ecx, $00000006
00610077   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrCopy;
|
0061007A   E8F94FDFFF             call    00405078
0061007F   8B85B8FDFFFF           mov     eax, [ebp+$FFFFFDB8]

* Reference to: Unit_00408494.Proc_004099B4
|
00610085   E82A99DFFF             call    004099B4
0061008A   89459C                 mov     [ebp-$64], eax
0061008D   C645A000               mov     byte ptr [ebp-$60], $00
00610091   8D559C                 lea     edx, [ebp-$64]
00610094   8B03                   mov     eax, [ebx]
00610096   8B809C000000           mov     eax, [eax+$009C]
0061009C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0061009E   E8C131ECFF             call    004D3264
006100A3   E9D7000000             jmp     0061017F
006100A8   8B03                   mov     eax, [ebx]
006100AA   8B8074080000           mov     eax, [eax+$0874]
006100B0   8B10                   mov     edx, [eax]
006100B2   FF5258                 call    dword ptr [edx+$58]
006100B5   3B45F8                 cmp     eax, [ebp-$08]
006100B8   0F84A3000000           jz      00610161
006100BE   8D95B0FDFFFF           lea     edx, [ebp+$FFFFFDB0]
006100C4   8B03                   mov     eax, [ebx]
006100C6   8B8088080000           mov     eax, [eax+$0888]
006100CC   8B08                   mov     ecx, [eax]
006100CE   FF5160                 call    dword ptr [ecx+$60]
006100D1   8B85B0FDFFFF           mov     eax, [ebp+$FFFFFDB0]
006100D7   8D95B4FDFFFF           lea     edx, [ebp+$FFFFFDB4]

* Reference to: Unit_00408494.Proc_004091D8
|
006100DD   E8F690DFFF             call    004091D8
006100E2   8B85B4FDFFFF           mov     eax, [ebp+$FFFFFDB4]
006100E8   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
006100ED   E8724EDFFF             call    00404F64
006100F2   756D                   jnz     00610161
006100F4   8B03                   mov     eax, [ebx]
006100F6   8B8074080000           mov     eax, [eax+$0874]
006100FC   8B10                   mov     edx, [eax]
006100FE   FF5258                 call    dword ptr [edx+$58]
00610101   8D95ACFDFFFF           lea     edx, [ebp+$FFFFFDAC]

* Reference to : TForm1.Proc_005D3228()
|
00610107   E81C31FCFF             call    005D3228
0061010C   8D85ACFDFFFF           lea     eax, [ebp+$FFFFFDAC]
00610112   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
00610117   E80C4DDFFF             call    00404E28
0061011C   8B85ACFDFFFF           mov     eax, [ebp+$FFFFFDAC]
00610122   8B55AC                 mov     edx, [ebp-$54]

* Reference to: System.@LStrPos;
|
00610125   E83250DFFF             call    0040515C
0061012A   85C0                   test    eax, eax
0061012C   7533                   jnz     00610161
0061012E   FF75AC                 push    dword ptr [ebp-$54]
00610131   8B03                   mov     eax, [ebx]
00610133   8B8074080000           mov     eax, [eax+$0874]
00610139   8B10                   mov     edx, [eax]
0061013B   FF5258                 call    dword ptr [edx+$58]
0061013E   8D95A8FDFFFF           lea     edx, [ebp+$FFFFFDA8]

* Reference to : TForm1.Proc_005D3228()
|
00610144   E8DF30FCFF             call    005D3228
00610149   FFB5A8FDFFFF           push    dword ptr [ebp+$FFFFFDA8]
0061014F   68D80B6100             push    $00610BD8
00610154   8D45AC                 lea     eax, [ebp-$54]
00610157   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0061015C   E87F4DDFFF             call    00404EE0
00610161   8B03                   mov     eax, [ebx]
00610163   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00610169   E87EF3E9FF             call    004AF4EC
0061016E   8B03                   mov     eax, [ebx]
00610170   8B809C000000           mov     eax, [eax+$009C]
00610176   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0061017D   7542                   jnz     006101C1
0061017F   8D85A4FDFFFF           lea     eax, [ebp+$FFFFFDA4]
00610185   50                     push    eax
00610186   8B45F0                 mov     eax, [ebp-$10]
00610189   48                     dec     eax
0061018A   8BD0                   mov     edx, eax
0061018C   C1E203                 shl     edx, $03
0061018F   2BD0                   sub     edx, eax
00610191   42                     inc     edx
00610192   B906000000             mov     ecx, $00000006
00610197   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrCopy;
|
0061019A   E8D94EDFFF             call    00405078
0061019F   8B85A4FDFFFF           mov     eax, [ebp+$FFFFFDA4]

* Reference to: Unit_00408494.Proc_004099B4
|
006101A5   E80A98DFFF             call    004099B4
006101AA   8BF8                   mov     edi, eax
006101AC   8B03                   mov     eax, [ebx]
006101AE   8B8078080000           mov     eax, [eax+$0878]
006101B4   8B10                   mov     edx, [eax]
006101B6   FF5258                 call    dword ptr [edx+$58]
006101B9   3BF8                   cmp     edi, eax
006101BB   0F84E7FEFFFF           jz      006100A8
006101C1   FF45F0                 inc     dword ptr [ebp-$10]
006101C4   FF4DA4                 dec     dword ptr [ebp-$5C]
006101C7   0F852AFCFFFF           jnz     0060FDF7
006101CD   8D95A0FDFFFF           lea     edx, [ebp+$FFFFFDA0]
006101D3   8B45AC                 mov     eax, [ebp-$54]

* Reference to: Unit_00408494.Proc_00409448
|
006101D6   E86D92DFFF             call    00409448
006101DB   8B85A0FDFFFF           mov     eax, [ebp+$FFFFFDA0]

* Reference to: System.@LStrLen(String):Integer;
|
006101E1   E83A4CDFFF             call    00404E20
006101E6   85C0                   test    eax, eax
006101E8   0F8E20030000           jle     0061050E

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006101EE   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
006101F4   8B904C020000           mov     edx, [eax+$024C]
006101FA   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
006101FB   E8D0D6ECFF             call    004DD8D0

* Possible String Reference to: 'Neffe(n):'
|
00610200   68700C6100             push    $00610C70

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610205   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
0061020B   8B884C020000           mov     ecx, [eax+$024C]
00610211   49                     dec     ecx
00610212   BA01000000             mov     edx, $00000001

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00610217   E8E0F8ECFF             call    004DFAFC

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0061021C   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00610222   8BB84C020000           mov     edi, [eax+$024C]
00610228   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.DockOrientation : TDockOrientation
|
0061022A   8B809C000000           mov     eax, [eax+$009C]
00610230   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00610232   E82529ECFF             call    004D2B5C
00610237   8B45AC                 mov     eax, [ebp-$54]

* Reference to: System.@LStrLen(String):Integer;
|
0061023A   E8E14BDFFF             call    00404E20
0061023F   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
00610245   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
0061024B   D8354C0C6100           fdiv    dword ptr [$00610C4C]

* Reference to: System.@ROUND;
|
00610251   E8DA2ADFFF             call    00402D30
00610256   85C0                   test    eax, eax
00610258   0F8EB0020000           jle     0061050E
0061025E   8945A4                 mov     [ebp-$5C], eax
00610261   C745F001000000         mov     dword ptr [ebp-$10], $00000001
00610268   8D859CFDFFFF           lea     eax, [ebp+$FFFFFD9C]
0061026E   50                     push    eax
0061026F   8B45F0                 mov     eax, [ebp-$10]
00610272   48                     dec     eax
00610273   8BD0                   mov     edx, eax
00610275   C1E203                 shl     edx, $03
00610278   2BD0                   sub     edx, eax
0061027A   42                     inc     edx
0061027B   B906000000             mov     ecx, $00000006
00610280   8B45AC                 mov     eax, [ebp-$54]

* Reference to: System.@LStrCopy;
|
00610283   E8F04DDFFF             call    00405078
00610288   8B859CFDFFFF           mov     eax, [ebp+$FFFFFD9C]

* Reference to: Unit_00408494.Proc_004099B4
|
0061028E   E82197DFFF             call    004099B4
00610293   89459C                 mov     [ebp-$64], eax
00610296   C645A000               mov     byte ptr [ebp-$60], $00
0061029A   8D559C                 lea     edx, [ebp-$64]
0061029D   8B03                   mov     eax, [ebx]
0061029F   8B809C000000           mov     eax, [eax+$009C]
006102A5   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
006102A7   E8B82FECFF             call    004D3264
006102AC   8B03                   mov     eax, [ebx]
006102AE   8B807C080000           mov     eax, [eax+$087C]
006102B4   8B10                   mov     edx, [eax]
006102B6   FF5258                 call    dword ptr [edx+$58]
006102B9   3B45F8                 cmp     eax, [ebp-$08]
006102BC   0F8440020000           jz      00610502
006102C2   8B03                   mov     eax, [ebx]
006102C4   8B8078080000           mov     eax, [eax+$0878]
006102CA   8B10                   mov     edx, [eax]
006102CC   FF5258                 call    dword ptr [edx+$58]
006102CF   3B45F8                 cmp     eax, [ebp-$08]
006102D2   0F842A020000           jz      00610502
006102D8   8D9594FDFFFF           lea     edx, [ebp+$FFFFFD94]
006102DE   8B03                   mov     eax, [ebx]
006102E0   8B8088080000           mov     eax, [eax+$0888]
006102E6   8B08                   mov     ecx, [eax]
006102E8   FF5160                 call    dword ptr [ecx+$60]
006102EB   8B8594FDFFFF           mov     eax, [ebp+$FFFFFD94]
006102F1   8D9598FDFFFF           lea     edx, [ebp+$FFFFFD98]

* Reference to: Unit_00408494.Proc_004091D8
|
006102F7   E8DC8EDFFF             call    004091D8
006102FC   8B8598FDFFFF           mov     eax, [ebp+$FFFFFD98]
00610302   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
00610307   E8584CDFFF             call    00404F64
0061030C   0F85F0010000           jnz     00610502

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610312   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00610318   8B904C020000           mov     edx, [eax+$024C]
0061031E   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
0061031F   E8ACD5ECFF             call    004DD8D0
00610324   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
00610326   8B8074080000           mov     eax, [eax+$0874]
0061032C   8B10                   mov     edx, [eax]
0061032E   FF5258                 call    dword ptr [edx+$58]
00610331   8D9590FDFFFF           lea     edx, [ebp+$FFFFFD90]

* Reference to: Unit_00408494.Proc_00409950
|
00610337   E81496DFFF             call    00409950
0061033C   8B8590FDFFFF           mov     eax, [ebp+$FFFFFD90]
00610342   50                     push    eax
00610343   8BCF                   mov     ecx, edi
00610345   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610347   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0061034D   E8AAF7ECFF             call    004DFAFC
00610352   8D9588FDFFFF           lea     edx, [ebp+$FFFFFD88]
00610358   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
0061035A   8B8080080000           mov     eax, [eax+$0880]
00610360   8B08                   mov     ecx, [eax]
00610362   FF5160                 call    dword ptr [ecx+$60]
00610365   FFB588FDFFFF           push    dword ptr [ebp+$FFFFFD88]
0061036B   68140C6100             push    $00610C14
00610370   8D9584FDFFFF           lea     edx, [ebp+$FFFFFD84]
00610376   8B03                   mov     eax, [ebx]
00610378   8B8084080000           mov     eax, [eax+$0884]
0061037E   8B08                   mov     ecx, [eax]
00610380   FF5160                 call    dword ptr [ecx+$60]
00610383   FFB584FDFFFF           push    dword ptr [ebp+$FFFFFD84]
00610389   8D858CFDFFFF           lea     eax, [ebp+$FFFFFD8C]
0061038F   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00610394   E8474BDFFF             call    00404EE0
00610399   8B858CFDFFFF           mov     eax, [ebp+$FFFFFD8C]
0061039F   50                     push    eax
006103A0   8BCF                   mov     ecx, edi
006103A2   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006103A7   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006103AD   E84AF7ECFF             call    004DFAFC
006103B2   8D957CFDFFFF           lea     edx, [ebp+$FFFFFD7C]
006103B8   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
006103BA   8B809C080000           mov     eax, [eax+$089C]
006103C0   8B08                   mov     ecx, [eax]
006103C2   FF5160                 call    dword ptr [ecx+$60]
006103C5   8B857CFDFFFF           mov     eax, [ebp+$FFFFFD7C]
006103CB   8D9580FDFFFF           lea     edx, [ebp+$FFFFFD80]

* Reference to: Unit_00408494.Proc_00409448
|
006103D1   E87290DFFF             call    00409448
006103D6   83BD80FDFFFF00         cmp     dword ptr [ebp+$FFFFFD80], +$00
006103DD   7644                   jbe     00610423
006103DF   8D9574FDFFFF           lea     edx, [ebp+$FFFFFD74]
006103E5   8B03                   mov     eax, [ebx]
006103E7   8B809C080000           mov     eax, [eax+$089C]
006103ED   8B08                   mov     ecx, [eax]
006103EF   FF5160                 call    dword ptr [ecx+$60]
006103F2   8B8D74FDFFFF           mov     ecx, [ebp+$FFFFFD74]
006103F8   8D8578FDFFFF           lea     eax, [ebp+$FFFFFD78]

* Possible String Reference to: '* '
|
006103FE   BA200C6100             mov     edx, $00610C20

* Reference to: System.@LStrCat3;
|
00610403   E8644ADFFF             call    00404E6C
00610408   8B8578FDFFFF           mov     eax, [ebp+$FFFFFD78]
0061040E   50                     push    eax
0061040F   8BCF                   mov     ecx, edi
00610411   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610416   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0061041C   E8DBF6ECFF             call    004DFAFC
00610421   EB6F                   jmp     00610492
00610423   8D956CFDFFFF           lea     edx, [ebp+$FFFFFD6C]
00610429   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
0061042B   8B80AC080000           mov     eax, [eax+$08AC]
00610431   8B08                   mov     ecx, [eax]
00610433   FF5160                 call    dword ptr [ecx+$60]
00610436   8B856CFDFFFF           mov     eax, [ebp+$FFFFFD6C]
0061043C   8D9570FDFFFF           lea     edx, [ebp+$FFFFFD70]

* Reference to: Unit_00408494.Proc_00409448
|
00610442   E80190DFFF             call    00409448
00610447   83BD70FDFFFF00         cmp     dword ptr [ebp+$FFFFFD70], +$00
0061044E   7642                   jbe     00610492
00610450   8D9564FDFFFF           lea     edx, [ebp+$FFFFFD64]
00610456   8B03                   mov     eax, [ebx]
00610458   8B80AC080000           mov     eax, [eax+$08AC]
0061045E   8B08                   mov     ecx, [eax]
00610460   FF5160                 call    dword ptr [ecx+$60]
00610463   8B8D64FDFFFF           mov     ecx, [ebp+$FFFFFD64]
00610469   8D8568FDFFFF           lea     eax, [ebp+$FFFFFD68]

* Possible String Reference to: '~ '
|
0061046F   BA2C0C6100             mov     edx, $00610C2C

* Reference to: System.@LStrCat3;
|
00610474   E8F349DFFF             call    00404E6C
00610479   8B8568FDFFFF           mov     eax, [ebp+$FFFFFD68]
0061047F   50                     push    eax
00610480   8BCF                   mov     ecx, edi
00610482   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610487   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0061048D   E86AF6ECFF             call    004DFAFC
00610492   8D955CFDFFFF           lea     edx, [ebp+$FFFFFD5C]
00610498   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
0061049A   8B80C4080000           mov     eax, [eax+$08C4]
006104A0   8B08                   mov     ecx, [eax]
006104A2   FF5160                 call    dword ptr [ecx+$60]
006104A5   8B855CFDFFFF           mov     eax, [ebp+$FFFFFD5C]
006104AB   8D9560FDFFFF           lea     edx, [ebp+$FFFFFD60]

* Reference to: Unit_00408494.Proc_00409448
|
006104B1   E8928FDFFF             call    00409448
006104B6   83BD60FDFFFF00         cmp     dword ptr [ebp+$FFFFFD60], +$00
006104BD   7642                   jbe     00610501
006104BF   8D9554FDFFFF           lea     edx, [ebp+$FFFFFD54]
006104C5   8B03                   mov     eax, [ebx]
006104C7   8B80C4080000           mov     eax, [eax+$08C4]
006104CD   8B08                   mov     ecx, [eax]
006104CF   FF5160                 call    dword ptr [ecx+$60]
006104D2   8B8D54FDFFFF           mov     ecx, [ebp+$FFFFFD54]
006104D8   8D8558FDFFFF           lea     eax, [ebp+$FFFFFD58]

* Possible String Reference to: '+ '
|
006104DE   BA380C6100             mov     edx, $00610C38

* Reference to: System.@LStrCat3;
|
006104E3   E88449DFFF             call    00404E6C
006104E8   8B8558FDFFFF           mov     eax, [ebp+$FFFFFD58]
006104EE   50                     push    eax
006104EF   8BCF                   mov     ecx, edi
006104F1   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006104F6   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006104FC   E8FBF5ECFF             call    004DFAFC
00610501   47                     inc     edi
00610502   FF45F0                 inc     dword ptr [ebp-$10]
00610505   FF4DA4                 dec     dword ptr [ebp-$5C]
00610508   0F855AFDFFFF           jnz     00610268
0061050E   8D45A8                 lea     eax, [ebp-$58]

* Reference to: System.@LStrClr(void;void);
|
00610511   E85246DFFF             call    00404B68
00610516   8B03                   mov     eax, [ebx]
00610518   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
0061051E   BAC00B6100             mov     edx, $00610BC0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00610523   E83426ECFF             call    004D2B5C
00610528   8B03                   mov     eax, [ebx]
0061052A   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00610530   E89FECE9FF             call    004AF1D4
00610535   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrLen(String):Integer;
|
00610538   E8E348DFFF             call    00404E20
0061053D   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
00610543   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
00610549   D8354C0C6100           fdiv    dword ptr [$00610C4C]

* Reference to: System.@ROUND;
|
0061054F   E8DC27DFFF             call    00402D30
00610554   85C0                   test    eax, eax
00610556   0F8E62010000           jle     006106BE
0061055C   8945A4                 mov     [ebp-$5C], eax
0061055F   C745F001000000         mov     dword ptr [ebp-$10], $00000001
00610566   8D8550FDFFFF           lea     eax, [ebp+$FFFFFD50]
0061056C   50                     push    eax
0061056D   8B45F0                 mov     eax, [ebp-$10]
00610570   48                     dec     eax
00610571   8BD0                   mov     edx, eax
00610573   C1E203                 shl     edx, $03
00610576   2BD0                   sub     edx, eax
00610578   42                     inc     edx
00610579   B906000000             mov     ecx, $00000006
0061057E   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrCopy;
|
00610581   E8F24ADFFF             call    00405078
00610586   8B8550FDFFFF           mov     eax, [ebp+$FFFFFD50]

* Reference to: Unit_00408494.Proc_004099B4
|
0061058C   E82394DFFF             call    004099B4
00610591   89459C                 mov     [ebp-$64], eax
00610594   C645A000               mov     byte ptr [ebp-$60], $00
00610598   8D559C                 lea     edx, [ebp-$64]
0061059B   8B03                   mov     eax, [ebx]
0061059D   8B809C000000           mov     eax, [eax+$009C]
006105A3   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
006105A5   E8BA2CECFF             call    004D3264
006105AA   E9C1000000             jmp     00610670
006105AF   8D9548FDFFFF           lea     edx, [ebp+$FFFFFD48]
006105B5   8B03                   mov     eax, [ebx]
006105B7   8B8088080000           mov     eax, [eax+$0888]
006105BD   8B08                   mov     ecx, [eax]
006105BF   FF5160                 call    dword ptr [ecx+$60]
006105C2   8B8548FDFFFF           mov     eax, [ebp+$FFFFFD48]
006105C8   8D954CFDFFFF           lea     edx, [ebp+$FFFFFD4C]

* Reference to: Unit_00408494.Proc_004091D8
|
006105CE   E8058CDFFF             call    004091D8
006105D3   8B854CFDFFFF           mov     eax, [ebp+$FFFFFD4C]
006105D9   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
006105DE   E88149DFFF             call    00404F64
006105E3   756D                   jnz     00610652
006105E5   8B03                   mov     eax, [ebx]
006105E7   8B8074080000           mov     eax, [eax+$0874]
006105ED   8B10                   mov     edx, [eax]
006105EF   FF5258                 call    dword ptr [edx+$58]
006105F2   8D9544FDFFFF           lea     edx, [ebp+$FFFFFD44]

* Reference to : TForm1.Proc_005D3228()
|
006105F8   E82B2CFCFF             call    005D3228
006105FD   8D8544FDFFFF           lea     eax, [ebp+$FFFFFD44]
00610603   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
00610608   E81B48DFFF             call    00404E28
0061060D   8B8544FDFFFF           mov     eax, [ebp+$FFFFFD44]
00610613   8B55A8                 mov     edx, [ebp-$58]

* Reference to: System.@LStrPos;
|
00610616   E8414BDFFF             call    0040515C
0061061B   85C0                   test    eax, eax
0061061D   7533                   jnz     00610652
0061061F   FF75A8                 push    dword ptr [ebp-$58]
00610622   8B03                   mov     eax, [ebx]
00610624   8B8074080000           mov     eax, [eax+$0874]
0061062A   8B10                   mov     edx, [eax]
0061062C   FF5258                 call    dword ptr [edx+$58]
0061062F   8D9540FDFFFF           lea     edx, [ebp+$FFFFFD40]

* Reference to : TForm1.Proc_005D3228()
|
00610635   E8EE2BFCFF             call    005D3228
0061063A   FFB540FDFFFF           push    dword ptr [ebp+$FFFFFD40]
00610640   68D80B6100             push    $00610BD8
00610645   8D45A8                 lea     eax, [ebp-$58]
00610648   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0061064D   E88E48DFFF             call    00404EE0
00610652   8B03                   mov     eax, [ebx]
00610654   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0061065A   E88DEEE9FF             call    004AF4EC
0061065F   8B03                   mov     eax, [ebx]
00610661   8B809C000000           mov     eax, [eax+$009C]
00610667   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0061066E   7542                   jnz     006106B2
00610670   8D853CFDFFFF           lea     eax, [ebp+$FFFFFD3C]
00610676   50                     push    eax
00610677   8B45F0                 mov     eax, [ebp-$10]
0061067A   48                     dec     eax
0061067B   8BD0                   mov     edx, eax
0061067D   C1E203                 shl     edx, $03
00610680   2BD0                   sub     edx, eax
00610682   42                     inc     edx
00610683   B906000000             mov     ecx, $00000006
00610688   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrCopy;
|
0061068B   E8E849DFFF             call    00405078
00610690   8B853CFDFFFF           mov     eax, [ebp+$FFFFFD3C]

* Reference to: Unit_00408494.Proc_004099B4
|
00610696   E81993DFFF             call    004099B4
0061069B   8BF8                   mov     edi, eax
0061069D   8B03                   mov     eax, [ebx]
0061069F   8B8078080000           mov     eax, [eax+$0878]
006106A5   8B10                   mov     edx, [eax]
006106A7   FF5258                 call    dword ptr [edx+$58]
006106AA   3BF8                   cmp     edi, eax
006106AC   0F84FDFEFFFF           jz      006105AF
006106B2   FF45F0                 inc     dword ptr [ebp-$10]
006106B5   FF4DA4                 dec     dword ptr [ebp-$5C]
006106B8   0F85A8FEFFFF           jnz     00610566
006106BE   8B03                   mov     eax, [ebx]
006106C0   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
006106C6   BAF00B6100             mov     edx, $00610BF0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006106CB   E88C24ECFF             call    004D2B5C
006106D0   8B03                   mov     eax, [ebx]
006106D2   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
006106D8   E8F7EAE9FF             call    004AF1D4
006106DD   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrLen(String):Integer;
|
006106E0   E83B47DFFF             call    00404E20
006106E5   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
006106EB   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
006106F1   D8354C0C6100           fdiv    dword ptr [$00610C4C]

* Reference to: System.@ROUND;
|
006106F7   E83426DFFF             call    00402D30
006106FC   85C0                   test    eax, eax
006106FE   0F8E62010000           jle     00610866
00610704   8945A4                 mov     [ebp-$5C], eax
00610707   C745F001000000         mov     dword ptr [ebp-$10], $00000001
0061070E   8D8538FDFFFF           lea     eax, [ebp+$FFFFFD38]
00610714   50                     push    eax
00610715   8B45F0                 mov     eax, [ebp-$10]
00610718   48                     dec     eax
00610719   8BD0                   mov     edx, eax
0061071B   C1E203                 shl     edx, $03
0061071E   2BD0                   sub     edx, eax
00610720   42                     inc     edx
00610721   B906000000             mov     ecx, $00000006
00610726   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrCopy;
|
00610729   E84A49DFFF             call    00405078
0061072E   8B8538FDFFFF           mov     eax, [ebp+$FFFFFD38]

* Reference to: Unit_00408494.Proc_004099B4
|
00610734   E87B92DFFF             call    004099B4
00610739   89459C                 mov     [ebp-$64], eax
0061073C   C645A000               mov     byte ptr [ebp-$60], $00
00610740   8D559C                 lea     edx, [ebp-$64]
00610743   8B03                   mov     eax, [ebx]
00610745   8B809C000000           mov     eax, [eax+$009C]
0061074B   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0061074D   E8122BECFF             call    004D3264
00610752   E9C1000000             jmp     00610818
00610757   8D9530FDFFFF           lea     edx, [ebp+$FFFFFD30]
0061075D   8B03                   mov     eax, [ebx]
0061075F   8B8088080000           mov     eax, [eax+$0888]
00610765   8B08                   mov     ecx, [eax]
00610767   FF5160                 call    dword ptr [ecx+$60]
0061076A   8B8530FDFFFF           mov     eax, [ebp+$FFFFFD30]
00610770   8D9534FDFFFF           lea     edx, [ebp+$FFFFFD34]

* Reference to: Unit_00408494.Proc_004091D8
|
00610776   E85D8ADFFF             call    004091D8
0061077B   8B8534FDFFFF           mov     eax, [ebp+$FFFFFD34]
00610781   BACC0B6100             mov     edx, $00610BCC

* Reference to: System.@LStrCmp;
|
00610786   E8D947DFFF             call    00404F64
0061078B   756D                   jnz     006107FA
0061078D   8B03                   mov     eax, [ebx]
0061078F   8B8074080000           mov     eax, [eax+$0874]
00610795   8B10                   mov     edx, [eax]
00610797   FF5258                 call    dword ptr [edx+$58]
0061079A   8D952CFDFFFF           lea     edx, [ebp+$FFFFFD2C]

* Reference to : TForm1.Proc_005D3228()
|
006107A0   E8832AFCFF             call    005D3228
006107A5   8D852CFDFFFF           lea     eax, [ebp+$FFFFFD2C]
006107AB   BAD80B6100             mov     edx, $00610BD8

* Reference to: System.@LStrCat;
|
006107B0   E87346DFFF             call    00404E28
006107B5   8B852CFDFFFF           mov     eax, [ebp+$FFFFFD2C]
006107BB   8B55A8                 mov     edx, [ebp-$58]

* Reference to: System.@LStrPos;
|
006107BE   E89949DFFF             call    0040515C
006107C3   85C0                   test    eax, eax
006107C5   7533                   jnz     006107FA
006107C7   FF75A8                 push    dword ptr [ebp-$58]
006107CA   8B03                   mov     eax, [ebx]
006107CC   8B8074080000           mov     eax, [eax+$0874]
006107D2   8B10                   mov     edx, [eax]
006107D4   FF5258                 call    dword ptr [edx+$58]
006107D7   8D9528FDFFFF           lea     edx, [ebp+$FFFFFD28]

* Reference to : TForm1.Proc_005D3228()
|
006107DD   E8462AFCFF             call    005D3228
006107E2   FFB528FDFFFF           push    dword ptr [ebp+$FFFFFD28]
006107E8   68D80B6100             push    $00610BD8
006107ED   8D45A8                 lea     eax, [ebp-$58]
006107F0   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006107F5   E8E646DFFF             call    00404EE0
006107FA   8B03                   mov     eax, [ebx]
006107FC   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00610802   E8E5ECE9FF             call    004AF4EC
00610807   8B03                   mov     eax, [ebx]
00610809   8B809C000000           mov     eax, [eax+$009C]
0061080F   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00610816   7542                   jnz     0061085A
00610818   8D8524FDFFFF           lea     eax, [ebp+$FFFFFD24]
0061081E   50                     push    eax
0061081F   8B45F0                 mov     eax, [ebp-$10]
00610822   48                     dec     eax
00610823   8BD0                   mov     edx, eax
00610825   C1E203                 shl     edx, $03
00610828   2BD0                   sub     edx, eax
0061082A   42                     inc     edx
0061082B   B906000000             mov     ecx, $00000006
00610830   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrCopy;
|
00610833   E84048DFFF             call    00405078
00610838   8B8524FDFFFF           mov     eax, [ebp+$FFFFFD24]

* Reference to: Unit_00408494.Proc_004099B4
|
0061083E   E87191DFFF             call    004099B4
00610843   8BF8                   mov     edi, eax
00610845   8B03                   mov     eax, [ebx]
00610847   8B807C080000           mov     eax, [eax+$087C]
0061084D   8B10                   mov     edx, [eax]
0061084F   FF5258                 call    dword ptr [edx+$58]
00610852   3BF8                   cmp     edi, eax
00610854   0F84FDFEFFFF           jz      00610757
0061085A   FF45F0                 inc     dword ptr [ebp-$10]
0061085D   FF4DA4                 dec     dword ptr [ebp-$5C]
00610860   0F85A8FEFFFF           jnz     0061070E
00610866   8D9520FDFFFF           lea     edx, [ebp+$FFFFFD20]
0061086C   8B45A8                 mov     eax, [ebp-$58]

* Reference to: Unit_00408494.Proc_00409448
|
0061086F   E8D48BDFFF             call    00409448
00610874   8B8520FDFFFF           mov     eax, [ebp+$FFFFFD20]

* Reference to: System.@LStrLen(String):Integer;
|
0061087A   E8A145DFFF             call    00404E20
0061087F   85C0                   test    eax, eax
00610881   7E3A                   jle     006108BD

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610883   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00610889   8B904C020000           mov     edx, [eax+$024C]
0061088F   42                     inc     edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610890   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
00610896   E835D0ECFF             call    004DD8D0

* Possible String Reference to: 'Cousin(s):'
|
0061089B   68840C6100             push    $00610C84

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006108A0   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
006108A6   8B884C020000           mov     ecx, [eax+$024C]
006108AC   49                     dec     ecx
006108AD   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006108B2   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006108B8   E83FF2ECFF             call    004DFAFC

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006108BD   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
006108C3   8BB84C020000           mov     edi, [eax+$024C]
006108C9   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.DockOrientation : TDockOrientation
|
006108CB   8B809C000000           mov     eax, [eax+$009C]
006108D1   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006108D3   E88422ECFF             call    004D2B5C
006108D8   8B45A8                 mov     eax, [ebp-$58]

* Reference to: System.@LStrLen(String):Integer;
|
006108DB   E84045DFFF             call    00404E20
006108E0   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
006108E6   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
006108EC   D8354C0C6100           fdiv    dword ptr [$00610C4C]

* Reference to: System.@ROUND;
|
006108F2   E83924DFFF             call    00402D30
006108F7   85C0                   test    eax, eax
006108F9   0F8E4A020000           jle     00610B49
006108FF   8945A4                 mov     [ebp-$5C], eax
00610902   C745F001000000         mov     dword ptr [ebp-$10], $00000001
00610909   8D851CFDFFFF           lea     eax, [ebp+$FFFFFD1C]
0061090F   50                     push    eax
00610910   8B45F0                 mov     eax, [ebp-$10]
00610913   48                     dec     eax
00610914   8BD0                   mov     edx, eax
00610916   C1E203                 shl     edx, $03
00610919   2BD0                   sub     edx, eax
0061091B   42                     inc     edx
0061091C   B906000000             mov     ecx, $00000006
00610921   8B45A8                 mov     eax, [ebp-$58]

* Reference to: System.@LStrCopy;
|
00610924   E84F47DFFF             call    00405078
00610929   8B851CFDFFFF           mov     eax, [ebp+$FFFFFD1C]

* Reference to: Unit_00408494.Proc_004099B4
|
0061092F   E88090DFFF             call    004099B4
00610934   89459C                 mov     [ebp-$64], eax
00610937   C645A000               mov     byte ptr [ebp-$60], $00
0061093B   8D559C                 lea     edx, [ebp-$64]
0061093E   8B03                   mov     eax, [ebx]
00610940   8B809C000000           mov     eax, [eax+$009C]
00610946   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00610948   E81729ECFF             call    004D3264

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0061094D   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00610953   8B904C020000           mov     edx, [eax+$024C]
00610959   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
0061095A   E871CFECFF             call    004DD8D0
0061095F   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
00610961   8B8074080000           mov     eax, [eax+$0874]
00610967   8B10                   mov     edx, [eax]
00610969   FF5258                 call    dword ptr [edx+$58]
0061096C   8D9518FDFFFF           lea     edx, [ebp+$FFFFFD18]

* Reference to: Unit_00408494.Proc_00409950
|
00610972   E8D98FDFFF             call    00409950
00610977   8B8518FDFFFF           mov     eax, [ebp+$FFFFFD18]
0061097D   50                     push    eax
0061097E   8BCF                   mov     ecx, edi
00610980   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610982   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00610988   E86FF1ECFF             call    004DFAFC
0061098D   8D9510FDFFFF           lea     edx, [ebp+$FFFFFD10]
00610993   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
00610995   8B8080080000           mov     eax, [eax+$0880]
0061099B   8B08                   mov     ecx, [eax]
0061099D   FF5160                 call    dword ptr [ecx+$60]
006109A0   FFB510FDFFFF           push    dword ptr [ebp+$FFFFFD10]
006109A6   68140C6100             push    $00610C14
006109AB   8D950CFDFFFF           lea     edx, [ebp+$FFFFFD0C]
006109B1   8B03                   mov     eax, [ebx]
006109B3   8B8084080000           mov     eax, [eax+$0884]
006109B9   8B08                   mov     ecx, [eax]
006109BB   FF5160                 call    dword ptr [ecx+$60]
006109BE   FFB50CFDFFFF           push    dword ptr [ebp+$FFFFFD0C]
006109C4   8D8514FDFFFF           lea     eax, [ebp+$FFFFFD14]
006109CA   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006109CF   E80C45DFFF             call    00404EE0
006109D4   8B8514FDFFFF           mov     eax, [ebp+$FFFFFD14]
006109DA   50                     push    eax
006109DB   8BCF                   mov     ecx, edi
006109DD   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006109E2   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006109E8   E80FF1ECFF             call    004DFAFC
006109ED   8D9504FDFFFF           lea     edx, [ebp+$FFFFFD04]
006109F3   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
006109F5   8B809C080000           mov     eax, [eax+$089C]
006109FB   8B08                   mov     ecx, [eax]
006109FD   FF5160                 call    dword ptr [ecx+$60]
00610A00   8B8504FDFFFF           mov     eax, [ebp+$FFFFFD04]
00610A06   8D9508FDFFFF           lea     edx, [ebp+$FFFFFD08]

* Reference to: Unit_00408494.Proc_00409448
|
00610A0C   E8378ADFFF             call    00409448
00610A11   83BD08FDFFFF00         cmp     dword ptr [ebp+$FFFFFD08], +$00
00610A18   7644                   jbe     00610A5E
00610A1A   8D95FCFCFFFF           lea     edx, [ebp+$FFFFFCFC]
00610A20   8B03                   mov     eax, [ebx]
00610A22   8B809C080000           mov     eax, [eax+$089C]
00610A28   8B08                   mov     ecx, [eax]
00610A2A   FF5160                 call    dword ptr [ecx+$60]
00610A2D   8B8DFCFCFFFF           mov     ecx, [ebp+$FFFFFCFC]
00610A33   8D8500FDFFFF           lea     eax, [ebp+$FFFFFD00]

* Possible String Reference to: '* '
|
00610A39   BA200C6100             mov     edx, $00610C20

* Reference to: System.@LStrCat3;
|
00610A3E   E82944DFFF             call    00404E6C
00610A43   8B8500FDFFFF           mov     eax, [ebp+$FFFFFD00]
00610A49   50                     push    eax
00610A4A   8BCF                   mov     ecx, edi
00610A4C   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610A51   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00610A57   E8A0F0ECFF             call    004DFAFC
00610A5C   EB6F                   jmp     00610ACD
00610A5E   8D95F4FCFFFF           lea     edx, [ebp+$FFFFFCF4]
00610A64   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
00610A66   8B80AC080000           mov     eax, [eax+$08AC]
00610A6C   8B08                   mov     ecx, [eax]
00610A6E   FF5160                 call    dword ptr [ecx+$60]
00610A71   8B85F4FCFFFF           mov     eax, [ebp+$FFFFFCF4]
00610A77   8D95F8FCFFFF           lea     edx, [ebp+$FFFFFCF8]

* Reference to: Unit_00408494.Proc_00409448
|
00610A7D   E8C689DFFF             call    00409448
00610A82   83BDF8FCFFFF00         cmp     dword ptr [ebp+$FFFFFCF8], +$00
00610A89   7642                   jbe     00610ACD
00610A8B   8D95ECFCFFFF           lea     edx, [ebp+$FFFFFCEC]
00610A91   8B03                   mov     eax, [ebx]
00610A93   8B80AC080000           mov     eax, [eax+$08AC]
00610A99   8B08                   mov     ecx, [eax]
00610A9B   FF5160                 call    dword ptr [ecx+$60]
00610A9E   8B8DECFCFFFF           mov     ecx, [ebp+$FFFFFCEC]
00610AA4   8D85F0FCFFFF           lea     eax, [ebp+$FFFFFCF0]

* Possible String Reference to: '~ '
|
00610AAA   BA2C0C6100             mov     edx, $00610C2C

* Reference to: System.@LStrCat3;
|
00610AAF   E8B843DFFF             call    00404E6C
00610AB4   8B85F0FCFFFF           mov     eax, [ebp+$FFFFFCF0]
00610ABA   50                     push    eax
00610ABB   8BCF                   mov     ecx, edi
00610ABD   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610AC2   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00610AC8   E82FF0ECFF             call    004DFAFC
00610ACD   8D95E4FCFFFF           lea     edx, [ebp+$FFFFFCE4]
00610AD3   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
00610AD5   8B80C4080000           mov     eax, [eax+$08C4]
00610ADB   8B08                   mov     ecx, [eax]
00610ADD   FF5160                 call    dword ptr [ecx+$60]
00610AE0   8B85E4FCFFFF           mov     eax, [ebp+$FFFFFCE4]
00610AE6   8D95E8FCFFFF           lea     edx, [ebp+$FFFFFCE8]

* Reference to: Unit_00408494.Proc_00409448
|
00610AEC   E85789DFFF             call    00409448
00610AF1   83BDE8FCFFFF00         cmp     dword ptr [ebp+$FFFFFCE8], +$00
00610AF8   7642                   jbe     00610B3C
00610AFA   8D95DCFCFFFF           lea     edx, [ebp+$FFFFFCDC]
00610B00   8B03                   mov     eax, [ebx]
00610B02   8B80C4080000           mov     eax, [eax+$08C4]
00610B08   8B08                   mov     ecx, [eax]
00610B0A   FF5160                 call    dword ptr [ecx+$60]
00610B0D   8B8DDCFCFFFF           mov     ecx, [ebp+$FFFFFCDC]
00610B13   8D85E0FCFFFF           lea     eax, [ebp+$FFFFFCE0]

* Possible String Reference to: '+ '
|
00610B19   BA380C6100             mov     edx, $00610C38

* Reference to: System.@LStrCat3;
|
00610B1E   E84943DFFF             call    00404E6C
00610B23   8B85E0FCFFFF           mov     eax, [ebp+$FFFFFCE0]
00610B29   50                     push    eax
00610B2A   8BCF                   mov     ecx, edi
00610B2C   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610B31   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00610B37   E8C0EFECFF             call    004DFAFC
00610B3C   47                     inc     edi
00610B3D   FF45F0                 inc     dword ptr [ebp-$10]
00610B40   FF4DA4                 dec     dword ptr [ebp-$5C]
00610B43   0F85C0FDFFFF           jnz     00610909
00610B49   33C0                   xor     eax, eax
00610B4B   5A                     pop     edx
00610B4C   59                     pop     ecx
00610B4D   59                     pop     ecx
00610B4E   648910                 mov     fs:[eax], edx

****** FINALLY
|
00610B51   68B10B6100             push    $00610BB1
00610B56   8D85DCFCFFFF           lea     eax, [ebp+$FFFFFCDC]
00610B5C   BA63000000             mov     edx, $00000063

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
00610B61   E82640DFFF             call    00404B8C
00610B66   8D856CFEFFFF           lea     eax, [ebp+$FFFFFE6C]

* Reference to: System.@LStrClr(void;void);
|
00610B6C   E8F73FDFFF             call    00404B68
00610B71   8D8568FEFFFF           lea     eax, [ebp+$FFFFFE68]

* Reference to: System.@LStrClr(void;void);
|
00610B77   E8EC3FDFFF             call    00404B68
00610B7C   8D8570FEFFFF           lea     eax, [ebp+$FFFFFE70]
00610B82   BA1C000000             mov     edx, $0000001C

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
00610B87   E80040DFFF             call    00404B8C
00610B8C   8D85E4FEFFFF           lea     eax, [ebp+$FFFFFEE4]
00610B92   BA2E000000             mov     edx, $0000002E

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
00610B97   E8F03FDFFF             call    00404B8C
00610B9C   8D45A8                 lea     eax, [ebp-$58]
00610B9F   BA08000000             mov     edx, $00000008

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
00610BA4   E8E33FDFFF             call    00404B8C
00610BA9   C3                     ret


* Reference to: System.@HandleFinally;
|
00610BAA   E91D39DFFF             jmp     004044CC
00610BAF   EBA5                   jmp     00610B56

****** END
|
00610BB1   5F                     pop     edi
00610BB2   5E                     pop     esi
00610BB3   5B                     pop     ebx
00610BB4   8BE5                   mov     esp, ebp
00610BB6   5D                     pop     ebp
00610BB7   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.StringGrid5
    (TStringGrid); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);;
    DB.TDataSet.Open(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_009C; OFFS_00A4; OFFS_0534; OFFS_0874; OFFS_0880; OFFS_0888;
    OFFS_089C; OFFS_08AC; OFFS_08C4
Project calls: TForm1.Proc_005D3228(); Unit_00408494.Proc_004091D8; Unit_00408494.Proc_00409448;
    Unit_00408494.Proc_00409950; Unit_00408494.Proc_004099B4
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetVisible(TControl;Boolean);;
    Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);;
    Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);; method TMenuItem.Click();
    System.Proc_00404EE0
Strings/files/dialog text: '* '; '+ '; '_^[��]�'; 'Base(n) von '; 'Cousine(n):'; 'mut';
    'Nichte(n):'; 'num'; 'Tante(n):'; 'vat'; '~ '
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Basen1Click(Sender : TObject);
begin
(*
00610C90   55                     push    ebp
00610C91   8BEC                   mov     ebp, esp
00610C93   B962000000             mov     ecx, $00000062
00610C98   6A00                   push    $00
00610C9A   6A00                   push    $00
00610C9C   49                     dec     ecx
00610C9D   75F9                   jnz     00610C98
00610C9F   51                     push    ecx
00610CA0   53                     push    ebx
00610CA1   56                     push    esi
00610CA2   57                     push    edi
00610CA3   8955FC                 mov     [ebp-$04], edx
00610CA6   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
00610CA8   8B1D3CCC6100           mov     ebx, [$0061CC3C]
00610CAE   33C0                   xor     eax, eax
00610CB0   55                     push    ebp
00610CB1   68DF336100             push    $006133DF

***** TRY
|
00610CB6   64FF30                 push    dword ptr fs:[eax]
00610CB9   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
00610CBC   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
00610CC2   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
00610CC8   E8EBF0E6FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
00610CCD   8B861C060000           mov     eax, [esi+$061C]
00610CD3   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
00610CD5   FF5244                 call    dword ptr [edx+$44]
00610CD8   8B03                   mov     eax, [ebx]

* Reference to field TMenuItem.OFFS_0534
|
00610CDA   8B8034050000           mov     eax, [eax+$0534]
00610CE0   8B10                   mov     edx, [eax]
00610CE2   FF5258                 call    dword ptr [edx+$58]
00610CE5   8945F8                 mov     [ebp-$08], eax
00610CE8   8B03                   mov     eax, [ebx]
00610CEA   8B8038050000           mov     eax, [eax+$0538]
00610CF0   8B10                   mov     edx, [eax]
00610CF2   FF5258                 call    dword ptr [edx+$58]
00610CF5   8945EC                 mov     [ebp-$14], eax
00610CF8   8B03                   mov     eax, [ebx]
00610CFA   8B803C050000           mov     eax, [eax+$053C]
00610D00   8B10                   mov     edx, [eax]
00610D02   FF5258                 call    dword ptr [edx+$58]
00610D05   8945E4                 mov     [ebp-$1C], eax
00610D08   8D45C4                 lea     eax, [ebp-$3C]

* Reference to: System.@LStrClr(void;void);
|
00610D0B   E8583EDFFF             call    00404B68
00610D10   8D45C0                 lea     eax, [ebp-$40]

* Reference to: System.@LStrClr(void;void);
|
00610D13   E8503EDFFF             call    00404B68
00610D18   8D45B8                 lea     eax, [ebp-$48]

* Reference to: System.@LStrClr(void;void);
|
00610D1B   E8483EDFFF             call    00404B68

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610D20   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00610D26   8B804C020000           mov     eax, [eax+$024C]
00610D2C   48                     dec     eax
00610D2D   85C0                   test    eax, eax
00610D2F   7C6D                   jl      00610D9E
00610D31   40                     inc     eax
00610D32   8945A4                 mov     [ebp-$5C], eax
00610D35   33FF                   xor     edi, edi
00610D37   6A00                   push    $00
00610D39   8BCF                   mov     ecx, edi
00610D3B   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610D3D   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00610D43   E8B4EDECFF             call    004DFAFC
00610D48   6A00                   push    $00
00610D4A   8BCF                   mov     ecx, edi
00610D4C   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610D51   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00610D57   E8A0EDECFF             call    004DFAFC
00610D5C   6A00                   push    $00
00610D5E   8BCF                   mov     ecx, edi
00610D60   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610D65   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00610D6B   E88CEDECFF             call    004DFAFC
00610D70   6A00                   push    $00
00610D72   8BCF                   mov     ecx, edi
00610D74   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610D79   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00610D7F   E878EDECFF             call    004DFAFC
00610D84   6A00                   push    $00
00610D86   8BCF                   mov     ecx, edi
00610D88   BA04000000             mov     edx, $00000004

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610D8D   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00610D93   E864EDECFF             call    004DFAFC
00610D98   47                     inc     edi
00610D99   FF4DA4                 dec     dword ptr [ebp-$5C]
00610D9C   7599                   jnz     00610D37
00610D9E   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00610DA3   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
00610DA9   E822CBECFF             call    004DD8D0
00610DAE   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.DockOrientation : TDockOrientation
|
00610DB0   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
00610DB6   E8CDBEE9FF             call    004ACC88
00610DBB   837DEC00               cmp     dword ptr [ebp-$14], +$00
00610DBF   7E58                   jle     00610E19
00610DC1   8B03                   mov     eax, [ebx]

* Reference to field TDockOrientation.OFFS_009C
|
00610DC3   8B809C000000           mov     eax, [eax+$009C]
00610DC9   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00610DCB   E88C1DECFF             call    004D2B5C
00610DD0   8B03                   mov     eax, [ebx]
00610DD2   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00610DD8   E8F7E3E9FF             call    004AF1D4

* Reference to Form1
|
00610DDD   8B45EC                 mov     eax, [ebp-$14]
00610DE0   89459C                 mov     [ebp-$64], eax
00610DE3   C645A000               mov     byte ptr [ebp-$60], $00
00610DE7   8D559C                 lea     edx, [ebp-$64]
00610DEA   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_009C
|
00610DEC   8B809C000000           mov     eax, [eax+$009C]
00610DF2   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00610DF4   E86B24ECFF             call    004D3264
00610DF9   8B03                   mov     eax, [ebx]
00610DFB   8B8078080000           mov     eax, [eax+$0878]
00610E01   8B10                   mov     edx, [eax]
00610E03   FF5258                 call    dword ptr [edx+$58]
00610E06   8945D8                 mov     [ebp-$28], eax
00610E09   8B03                   mov     eax, [ebx]
00610E0B   8B807C080000           mov     eax, [eax+$087C]
00610E11   8B10                   mov     edx, [eax]
00610E13   FF5258                 call    dword ptr [edx+$58]
00610E16   8945D4                 mov     [ebp-$2C], eax
00610E19   837DE400               cmp     dword ptr [ebp-$1C], +$00
00610E1D   7E58                   jle     00610E77
00610E1F   8B03                   mov     eax, [ebx]
00610E21   8B809C000000           mov     eax, [eax+$009C]
00610E27   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00610E29   E82E1DECFF             call    004D2B5C
00610E2E   8B03                   mov     eax, [ebx]
00610E30   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00610E36   E899E3E9FF             call    004AF1D4

* Reference to Form1
|
00610E3B   8B45E4                 mov     eax, [ebp-$1C]
00610E3E   89459C                 mov     [ebp-$64], eax
00610E41   C645A000               mov     byte ptr [ebp-$60], $00
00610E45   8D559C                 lea     edx, [ebp-$64]
00610E48   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_009C
|
00610E4A   8B809C000000           mov     eax, [eax+$009C]
00610E50   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00610E52   E80D24ECFF             call    004D3264
00610E57   8B03                   mov     eax, [ebx]
00610E59   8B8078080000           mov     eax, [eax+$0878]
00610E5F   8B10                   mov     edx, [eax]
00610E61   FF5258                 call    dword ptr [edx+$58]
00610E64   8945D0                 mov     [ebp-$30], eax
00610E67   8B03                   mov     eax, [ebx]
00610E69   8B807C080000           mov     eax, [eax+$087C]
00610E6F   8B10                   mov     edx, [eax]
00610E71   FF5258                 call    dword ptr [edx+$58]
00610E74   8945CC                 mov     [ebp-$34], eax
00610E77   8B03                   mov     eax, [ebx]
00610E79   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
00610E7F   BAF8336100             mov     edx, $006133F8

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00610E84   E8D31CECFF             call    004D2B5C
00610E89   8B03                   mov     eax, [ebx]
00610E8B   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00610E91   E83EE3E9FF             call    004AF1D4
00610E96   837DD800               cmp     dword ptr [ebp-$28], +$00
00610E9A   0F8E23010000           jle     00610FC3
00610EA0   8B45D8                 mov     eax, [ebp-$28]
00610EA3   89459C                 mov     [ebp-$64], eax
00610EA6   C645A000               mov     byte ptr [ebp-$60], $00
00610EAA   8D559C                 lea     edx, [ebp-$64]
00610EAD   8B03                   mov     eax, [ebx]
00610EAF   8B809C000000           mov     eax, [eax+$009C]
00610EB5   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00610EB7   E8A823ECFF             call    004D3264
00610EBC   84C0                   test    al, al
00610EBE   0F84FF000000           jz      00610FC3
00610EC4   E9E4000000             jmp     00610FAD
00610EC9   8B03                   mov     eax, [ebx]
00610ECB   8B8074080000           mov     eax, [eax+$0874]
00610ED1   8B10                   mov     edx, [eax]
00610ED3   FF5258                 call    dword ptr [edx+$58]
00610ED6   3B45EC                 cmp     eax, [ebp-$14]
00610ED9   0F84B0000000           jz      00610F8F
00610EDF   8D5594                 lea     edx, [ebp-$6C]
00610EE2   8B03                   mov     eax, [ebx]
00610EE4   8B8088080000           mov     eax, [eax+$0888]
00610EEA   8B08                   mov     ecx, [eax]
00610EEC   FF5160                 call    dword ptr [ecx+$60]
00610EEF   8B4594                 mov     eax, [ebp-$6C]
00610EF2   8D5598                 lea     edx, [ebp-$68]

* Reference to: Unit_00408494.Proc_004091D8
|
00610EF5   E8DE82DFFF             call    004091D8
00610EFA   8B4598                 mov     eax, [ebp-$68]
00610EFD   BA04346100             mov     edx, $00613404

* Reference to: System.@LStrCmp;
|
00610F02   E85D40DFFF             call    00404F64
00610F07   752F                   jnz     00610F38
00610F09   FF75C4                 push    dword ptr [ebp-$3C]
00610F0C   8B03                   mov     eax, [ebx]
00610F0E   8B8074080000           mov     eax, [eax+$0874]
00610F14   8B10                   mov     edx, [eax]
00610F16   FF5258                 call    dword ptr [edx+$58]
00610F19   8D5590                 lea     edx, [ebp-$70]

* Reference to : TForm1.Proc_005D3228()
|
00610F1C   E80723FCFF             call    005D3228
00610F21   FF7590                 push    dword ptr [ebp-$70]
00610F24   6810346100             push    $00613410
00610F29   8D45C4                 lea     eax, [ebp-$3C]
00610F2C   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00610F31   E8AA3FDFFF             call    00404EE0
00610F36   EB57                   jmp     00610F8F
00610F38   8D5588                 lea     edx, [ebp-$78]
00610F3B   8B03                   mov     eax, [ebx]
00610F3D   8B8088080000           mov     eax, [eax+$0888]
00610F43   8B08                   mov     ecx, [eax]
00610F45   FF5160                 call    dword ptr [ecx+$60]
00610F48   8B4588                 mov     eax, [ebp-$78]
00610F4B   8D558C                 lea     edx, [ebp-$74]

* Reference to: Unit_00408494.Proc_004091D8
|
00610F4E   E88582DFFF             call    004091D8
00610F53   8B458C                 mov     eax, [ebp-$74]
00610F56   BA1C346100             mov     edx, $0061341C

* Reference to: System.@LStrCmp;
|
00610F5B   E80440DFFF             call    00404F64
00610F60   752D                   jnz     00610F8F
00610F62   FF75C0                 push    dword ptr [ebp-$40]
00610F65   8B03                   mov     eax, [ebx]
00610F67   8B8074080000           mov     eax, [eax+$0874]
00610F6D   8B10                   mov     edx, [eax]
00610F6F   FF5258                 call    dword ptr [edx+$58]
00610F72   8D5584                 lea     edx, [ebp-$7C]

* Reference to : TForm1.Proc_005D3228()
|
00610F75   E8AE22FCFF             call    005D3228
00610F7A   FF7584                 push    dword ptr [ebp-$7C]
00610F7D   6810346100             push    $00613410
00610F82   8D45C0                 lea     eax, [ebp-$40]
00610F85   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00610F8A   E8513FDFFF             call    00404EE0
00610F8F   8B03                   mov     eax, [ebx]
00610F91   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00610F97   E850E5E9FF             call    004AF4EC
00610F9C   8B03                   mov     eax, [ebx]
00610F9E   8B809C000000           mov     eax, [eax+$009C]
00610FA4   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00610FAB   7516                   jnz     00610FC3
00610FAD   8B03                   mov     eax, [ebx]
00610FAF   8B8078080000           mov     eax, [eax+$0878]
00610FB5   8B10                   mov     edx, [eax]
00610FB7   FF5258                 call    dword ptr [edx+$58]
00610FBA   3B45D8                 cmp     eax, [ebp-$28]
00610FBD   0F8406FFFFFF           jz      00610EC9
00610FC3   8B03                   mov     eax, [ebx]
00610FC5   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
00610FCB   BA28346100             mov     edx, $00613428

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00610FD0   E8871BECFF             call    004D2B5C
00610FD5   8B03                   mov     eax, [ebx]
00610FD7   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00610FDD   E8F2E1E9FF             call    004AF1D4
00610FE2   837DD400               cmp     dword ptr [ebp-$2C], +$00
00610FE6   0F8EBC010000           jle     006111A8
00610FEC   8B45D4                 mov     eax, [ebp-$2C]
00610FEF   89459C                 mov     [ebp-$64], eax
00610FF2   C645A000               mov     byte ptr [ebp-$60], $00
00610FF6   8D559C                 lea     edx, [ebp-$64]
00610FF9   8B03                   mov     eax, [ebx]
00610FFB   8B809C000000           mov     eax, [eax+$009C]
00611001   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00611003   E85C22ECFF             call    004D3264
00611008   84C0                   test    al, al
0061100A   0F8498010000           jz      006111A8
00611010   E97D010000             jmp     00611192
00611015   8B03                   mov     eax, [ebx]
00611017   8B8074080000           mov     eax, [eax+$0874]
0061101D   8B10                   mov     edx, [eax]
0061101F   FF5258                 call    dword ptr [edx+$58]
00611022   3B45EC                 cmp     eax, [ebp-$14]
00611025   0F8449010000           jz      00611174
0061102B   8D957CFFFFFF           lea     edx, [ebp+$FFFFFF7C]
00611031   8B03                   mov     eax, [ebx]
00611033   8B8088080000           mov     eax, [eax+$0888]
00611039   8B08                   mov     ecx, [eax]
0061103B   FF5160                 call    dword ptr [ecx+$60]
0061103E   8B857CFFFFFF           mov     eax, [ebp+$FFFFFF7C]
00611044   8D5580                 lea     edx, [ebp-$80]

* Reference to: Unit_00408494.Proc_004091D8
|
00611047   E88C81DFFF             call    004091D8
0061104C   8B4580                 mov     eax, [ebp-$80]
0061104F   BA04346100             mov     edx, $00613404

* Reference to: System.@LStrCmp;
|
00611054   E80B3FDFFF             call    00404F64
00611059   7576                   jnz     006110D1
0061105B   8B03                   mov     eax, [ebx]
0061105D   8B8074080000           mov     eax, [eax+$0874]
00611063   8B10                   mov     edx, [eax]
00611065   FF5258                 call    dword ptr [edx+$58]
00611068   8D9578FFFFFF           lea     edx, [ebp+$FFFFFF78]

* Reference to : TForm1.Proc_005D3228()
|
0061106E   E8B521FCFF             call    005D3228
00611073   8D8578FFFFFF           lea     eax, [ebp+$FFFFFF78]
00611079   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
0061107E   E8A53DDFFF             call    00404E28
00611083   8B8578FFFFFF           mov     eax, [ebp+$FFFFFF78]
00611089   8B55C4                 mov     edx, [ebp-$3C]

* Reference to: System.@LStrPos;
|
0061108C   E8CB40DFFF             call    0040515C
00611091   85C0                   test    eax, eax
00611093   0F85DB000000           jnz     00611174
00611099   FF75C4                 push    dword ptr [ebp-$3C]
0061109C   8B03                   mov     eax, [ebx]
0061109E   8B8074080000           mov     eax, [eax+$0874]
006110A4   8B10                   mov     edx, [eax]
006110A6   FF5258                 call    dword ptr [edx+$58]
006110A9   8D9574FFFFFF           lea     edx, [ebp+$FFFFFF74]

* Reference to : TForm1.Proc_005D3228()
|
006110AF   E87421FCFF             call    005D3228
006110B4   FFB574FFFFFF           push    dword ptr [ebp+$FFFFFF74]
006110BA   6810346100             push    $00613410
006110BF   8D45C4                 lea     eax, [ebp-$3C]
006110C2   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006110C7   E8143EDFFF             call    00404EE0
006110CC   E9A3000000             jmp     00611174
006110D1   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]
006110D7   8B03                   mov     eax, [ebx]
006110D9   8B8088080000           mov     eax, [eax+$0888]
006110DF   8B08                   mov     ecx, [eax]
006110E1   FF5160                 call    dword ptr [ecx+$60]
006110E4   8B856CFFFFFF           mov     eax, [ebp+$FFFFFF6C]
006110EA   8D9570FFFFFF           lea     edx, [ebp+$FFFFFF70]

* Reference to: Unit_00408494.Proc_004091D8
|
006110F0   E8E380DFFF             call    004091D8
006110F5   8B8570FFFFFF           mov     eax, [ebp+$FFFFFF70]
006110FB   BA1C346100             mov     edx, $0061341C

* Reference to: System.@LStrCmp;
|
00611100   E85F3EDFFF             call    00404F64
00611105   756D                   jnz     00611174
00611107   8B03                   mov     eax, [ebx]
00611109   8B8074080000           mov     eax, [eax+$0874]
0061110F   8B10                   mov     edx, [eax]
00611111   FF5258                 call    dword ptr [edx+$58]
00611114   8D9568FFFFFF           lea     edx, [ebp+$FFFFFF68]

* Reference to : TForm1.Proc_005D3228()
|
0061111A   E80921FCFF             call    005D3228
0061111F   8D8568FFFFFF           lea     eax, [ebp+$FFFFFF68]
00611125   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
0061112A   E8F93CDFFF             call    00404E28
0061112F   8B8568FFFFFF           mov     eax, [ebp+$FFFFFF68]
00611135   8B55C0                 mov     edx, [ebp-$40]

* Reference to: System.@LStrPos;
|
00611138   E81F40DFFF             call    0040515C
0061113D   85C0                   test    eax, eax
0061113F   7533                   jnz     00611174
00611141   FF75C0                 push    dword ptr [ebp-$40]
00611144   8B03                   mov     eax, [ebx]
00611146   8B8074080000           mov     eax, [eax+$0874]
0061114C   8B10                   mov     edx, [eax]
0061114E   FF5258                 call    dword ptr [edx+$58]
00611151   8D9564FFFFFF           lea     edx, [ebp+$FFFFFF64]

* Reference to : TForm1.Proc_005D3228()
|
00611157   E8CC20FCFF             call    005D3228
0061115C   FFB564FFFFFF           push    dword ptr [ebp+$FFFFFF64]
00611162   6810346100             push    $00613410
00611167   8D45C0                 lea     eax, [ebp-$40]
0061116A   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0061116F   E86C3DDFFF             call    00404EE0
00611174   8B03                   mov     eax, [ebx]
00611176   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0061117C   E86BE3E9FF             call    004AF4EC
00611181   8B03                   mov     eax, [ebx]
00611183   8B809C000000           mov     eax, [eax+$009C]
00611189   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00611190   7516                   jnz     006111A8
00611192   8B03                   mov     eax, [ebx]
00611194   8B807C080000           mov     eax, [eax+$087C]
0061119A   8B10                   mov     edx, [eax]
0061119C   FF5258                 call    dword ptr [edx+$58]
0061119F   3B45D4                 cmp     eax, [ebp-$2C]
006111A2   0F846DFEFFFF           jz      00611015
006111A8   8B03                   mov     eax, [ebx]
006111AA   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
006111B0   BAF8336100             mov     edx, $006133F8

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006111B5   E8A219ECFF             call    004D2B5C
006111BA   8B03                   mov     eax, [ebx]
006111BC   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
006111C2   E80DE0E9FF             call    004AF1D4
006111C7   837DD000               cmp     dword ptr [ebp-$30], +$00
006111CB   0F8EC2010000           jle     00611393
006111D1   8B45D0                 mov     eax, [ebp-$30]
006111D4   89459C                 mov     [ebp-$64], eax
006111D7   C645A000               mov     byte ptr [ebp-$60], $00
006111DB   8D559C                 lea     edx, [ebp-$64]
006111DE   8B03                   mov     eax, [ebx]
006111E0   8B809C000000           mov     eax, [eax+$009C]
006111E6   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
006111E8   E87720ECFF             call    004D3264
006111ED   84C0                   test    al, al
006111EF   0F849E010000           jz      00611393
006111F5   E983010000             jmp     0061137D
006111FA   8B03                   mov     eax, [ebx]
006111FC   8B8074080000           mov     eax, [eax+$0874]
00611202   8B10                   mov     edx, [eax]
00611204   FF5258                 call    dword ptr [edx+$58]
00611207   3B45E4                 cmp     eax, [ebp-$1C]
0061120A   0F844F010000           jz      0061135F
00611210   8D955CFFFFFF           lea     edx, [ebp+$FFFFFF5C]
00611216   8B03                   mov     eax, [ebx]
00611218   8B8088080000           mov     eax, [eax+$0888]
0061121E   8B08                   mov     ecx, [eax]
00611220   FF5160                 call    dword ptr [ecx+$60]
00611223   8B855CFFFFFF           mov     eax, [ebp+$FFFFFF5C]
00611229   8D9560FFFFFF           lea     edx, [ebp+$FFFFFF60]

* Reference to: Unit_00408494.Proc_004091D8
|
0061122F   E8A47FDFFF             call    004091D8
00611234   8B8560FFFFFF           mov     eax, [ebp+$FFFFFF60]
0061123A   BA04346100             mov     edx, $00613404

* Reference to: System.@LStrCmp;
|
0061123F   E8203DDFFF             call    00404F64
00611244   7576                   jnz     006112BC
00611246   8B03                   mov     eax, [ebx]
00611248   8B8074080000           mov     eax, [eax+$0874]
0061124E   8B10                   mov     edx, [eax]
00611250   FF5258                 call    dword ptr [edx+$58]
00611253   8D9558FFFFFF           lea     edx, [ebp+$FFFFFF58]

* Reference to : TForm1.Proc_005D3228()
|
00611259   E8CA1FFCFF             call    005D3228
0061125E   8D8558FFFFFF           lea     eax, [ebp+$FFFFFF58]
00611264   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
00611269   E8BA3BDFFF             call    00404E28
0061126E   8B8558FFFFFF           mov     eax, [ebp+$FFFFFF58]
00611274   8B55C4                 mov     edx, [ebp-$3C]

* Reference to: System.@LStrPos;
|
00611277   E8E03EDFFF             call    0040515C
0061127C   85C0                   test    eax, eax
0061127E   0F85DB000000           jnz     0061135F
00611284   FF75C4                 push    dword ptr [ebp-$3C]
00611287   8B03                   mov     eax, [ebx]
00611289   8B8074080000           mov     eax, [eax+$0874]
0061128F   8B10                   mov     edx, [eax]
00611291   FF5258                 call    dword ptr [edx+$58]
00611294   8D9554FFFFFF           lea     edx, [ebp+$FFFFFF54]

* Reference to : TForm1.Proc_005D3228()
|
0061129A   E8891FFCFF             call    005D3228
0061129F   FFB554FFFFFF           push    dword ptr [ebp+$FFFFFF54]
006112A5   6810346100             push    $00613410
006112AA   8D45C4                 lea     eax, [ebp-$3C]
006112AD   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006112B2   E8293CDFFF             call    00404EE0
006112B7   E9A3000000             jmp     0061135F
006112BC   8D954CFFFFFF           lea     edx, [ebp+$FFFFFF4C]
006112C2   8B03                   mov     eax, [ebx]
006112C4   8B8088080000           mov     eax, [eax+$0888]
006112CA   8B08                   mov     ecx, [eax]
006112CC   FF5160                 call    dword ptr [ecx+$60]
006112CF   8B854CFFFFFF           mov     eax, [ebp+$FFFFFF4C]
006112D5   8D9550FFFFFF           lea     edx, [ebp+$FFFFFF50]

* Reference to: Unit_00408494.Proc_004091D8
|
006112DB   E8F87EDFFF             call    004091D8
006112E0   8B8550FFFFFF           mov     eax, [ebp+$FFFFFF50]
006112E6   BA1C346100             mov     edx, $0061341C

* Reference to: System.@LStrCmp;
|
006112EB   E8743CDFFF             call    00404F64
006112F0   756D                   jnz     0061135F
006112F2   8B03                   mov     eax, [ebx]
006112F4   8B8074080000           mov     eax, [eax+$0874]
006112FA   8B10                   mov     edx, [eax]
006112FC   FF5258                 call    dword ptr [edx+$58]
006112FF   8D9548FFFFFF           lea     edx, [ebp+$FFFFFF48]

* Reference to : TForm1.Proc_005D3228()
|
00611305   E81E1FFCFF             call    005D3228
0061130A   8D8548FFFFFF           lea     eax, [ebp+$FFFFFF48]
00611310   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
00611315   E80E3BDFFF             call    00404E28
0061131A   8B8548FFFFFF           mov     eax, [ebp+$FFFFFF48]
00611320   8B55C0                 mov     edx, [ebp-$40]

* Reference to: System.@LStrPos;
|
00611323   E8343EDFFF             call    0040515C
00611328   85C0                   test    eax, eax
0061132A   7533                   jnz     0061135F
0061132C   FF75C0                 push    dword ptr [ebp-$40]
0061132F   8B03                   mov     eax, [ebx]
00611331   8B8074080000           mov     eax, [eax+$0874]
00611337   8B10                   mov     edx, [eax]
00611339   FF5258                 call    dword ptr [edx+$58]
0061133C   8D9544FFFFFF           lea     edx, [ebp+$FFFFFF44]

* Reference to : TForm1.Proc_005D3228()
|
00611342   E8E11EFCFF             call    005D3228
00611347   FFB544FFFFFF           push    dword ptr [ebp+$FFFFFF44]
0061134D   6810346100             push    $00613410
00611352   8D45C0                 lea     eax, [ebp-$40]
00611355   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0061135A   E8813BDFFF             call    00404EE0
0061135F   8B03                   mov     eax, [ebx]
00611361   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00611367   E880E1E9FF             call    004AF4EC
0061136C   8B03                   mov     eax, [ebx]
0061136E   8B809C000000           mov     eax, [eax+$009C]
00611374   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0061137B   7516                   jnz     00611393
0061137D   8B03                   mov     eax, [ebx]
0061137F   8B8078080000           mov     eax, [eax+$0878]
00611385   8B10                   mov     edx, [eax]
00611387   FF5258                 call    dword ptr [edx+$58]
0061138A   3B45D0                 cmp     eax, [ebp-$30]
0061138D   0F8467FEFFFF           jz      006111FA
00611393   8B03                   mov     eax, [ebx]
00611395   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
0061139B   BA28346100             mov     edx, $00613428

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006113A0   E8B717ECFF             call    004D2B5C
006113A5   8B03                   mov     eax, [ebx]
006113A7   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
006113AD   E822DEE9FF             call    004AF1D4
006113B2   837DCC00               cmp     dword ptr [ebp-$34], +$00
006113B6   0F8EC2010000           jle     0061157E
006113BC   8B45CC                 mov     eax, [ebp-$34]
006113BF   89459C                 mov     [ebp-$64], eax
006113C2   C645A000               mov     byte ptr [ebp-$60], $00
006113C6   8D559C                 lea     edx, [ebp-$64]
006113C9   8B03                   mov     eax, [ebx]
006113CB   8B809C000000           mov     eax, [eax+$009C]
006113D1   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
006113D3   E88C1EECFF             call    004D3264
006113D8   84C0                   test    al, al
006113DA   0F849E010000           jz      0061157E
006113E0   E983010000             jmp     00611568
006113E5   8B03                   mov     eax, [ebx]
006113E7   8B8074080000           mov     eax, [eax+$0874]
006113ED   8B10                   mov     edx, [eax]
006113EF   FF5258                 call    dword ptr [edx+$58]
006113F2   3B45E4                 cmp     eax, [ebp-$1C]
006113F5   0F844F010000           jz      0061154A
006113FB   8D953CFFFFFF           lea     edx, [ebp+$FFFFFF3C]
00611401   8B03                   mov     eax, [ebx]
00611403   8B8088080000           mov     eax, [eax+$0888]
00611409   8B08                   mov     ecx, [eax]
0061140B   FF5160                 call    dword ptr [ecx+$60]
0061140E   8B853CFFFFFF           mov     eax, [ebp+$FFFFFF3C]
00611414   8D9540FFFFFF           lea     edx, [ebp+$FFFFFF40]

* Reference to: Unit_00408494.Proc_004091D8
|
0061141A   E8B97DDFFF             call    004091D8
0061141F   8B8540FFFFFF           mov     eax, [ebp+$FFFFFF40]
00611425   BA04346100             mov     edx, $00613404

* Reference to: System.@LStrCmp;
|
0061142A   E8353BDFFF             call    00404F64
0061142F   7576                   jnz     006114A7
00611431   8B03                   mov     eax, [ebx]
00611433   8B8074080000           mov     eax, [eax+$0874]
00611439   8B10                   mov     edx, [eax]
0061143B   FF5258                 call    dword ptr [edx+$58]
0061143E   8D9538FFFFFF           lea     edx, [ebp+$FFFFFF38]

* Reference to : TForm1.Proc_005D3228()
|
00611444   E8DF1DFCFF             call    005D3228
00611449   8D8538FFFFFF           lea     eax, [ebp+$FFFFFF38]
0061144F   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
00611454   E8CF39DFFF             call    00404E28
00611459   8B8538FFFFFF           mov     eax, [ebp+$FFFFFF38]
0061145F   8B55C4                 mov     edx, [ebp-$3C]

* Reference to: System.@LStrPos;
|
00611462   E8F53CDFFF             call    0040515C
00611467   85C0                   test    eax, eax
00611469   0F85DB000000           jnz     0061154A
0061146F   FF75C4                 push    dword ptr [ebp-$3C]
00611472   8B03                   mov     eax, [ebx]
00611474   8B8074080000           mov     eax, [eax+$0874]
0061147A   8B10                   mov     edx, [eax]
0061147C   FF5258                 call    dword ptr [edx+$58]
0061147F   8D9534FFFFFF           lea     edx, [ebp+$FFFFFF34]

* Reference to : TForm1.Proc_005D3228()
|
00611485   E89E1DFCFF             call    005D3228
0061148A   FFB534FFFFFF           push    dword ptr [ebp+$FFFFFF34]
00611490   6810346100             push    $00613410
00611495   8D45C4                 lea     eax, [ebp-$3C]
00611498   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0061149D   E83E3ADFFF             call    00404EE0
006114A2   E9A3000000             jmp     0061154A
006114A7   8D952CFFFFFF           lea     edx, [ebp+$FFFFFF2C]
006114AD   8B03                   mov     eax, [ebx]
006114AF   8B8088080000           mov     eax, [eax+$0888]
006114B5   8B08                   mov     ecx, [eax]
006114B7   FF5160                 call    dword ptr [ecx+$60]
006114BA   8B852CFFFFFF           mov     eax, [ebp+$FFFFFF2C]
006114C0   8D9530FFFFFF           lea     edx, [ebp+$FFFFFF30]

* Reference to: Unit_00408494.Proc_004091D8
|
006114C6   E80D7DDFFF             call    004091D8
006114CB   8B8530FFFFFF           mov     eax, [ebp+$FFFFFF30]
006114D1   BA1C346100             mov     edx, $0061341C

* Reference to: System.@LStrCmp;
|
006114D6   E8893ADFFF             call    00404F64
006114DB   756D                   jnz     0061154A
006114DD   8B03                   mov     eax, [ebx]
006114DF   8B8074080000           mov     eax, [eax+$0874]
006114E5   8B10                   mov     edx, [eax]
006114E7   FF5258                 call    dword ptr [edx+$58]
006114EA   8D9528FFFFFF           lea     edx, [ebp+$FFFFFF28]

* Reference to : TForm1.Proc_005D3228()
|
006114F0   E8331DFCFF             call    005D3228
006114F5   8D8528FFFFFF           lea     eax, [ebp+$FFFFFF28]
006114FB   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
00611500   E82339DFFF             call    00404E28
00611505   8B8528FFFFFF           mov     eax, [ebp+$FFFFFF28]
0061150B   8B55C0                 mov     edx, [ebp-$40]

* Reference to: System.@LStrPos;
|
0061150E   E8493CDFFF             call    0040515C
00611513   85C0                   test    eax, eax
00611515   7533                   jnz     0061154A
00611517   FF75C0                 push    dword ptr [ebp-$40]
0061151A   8B03                   mov     eax, [ebx]
0061151C   8B8074080000           mov     eax, [eax+$0874]
00611522   8B10                   mov     edx, [eax]
00611524   FF5258                 call    dword ptr [edx+$58]
00611527   8D9524FFFFFF           lea     edx, [ebp+$FFFFFF24]

* Reference to : TForm1.Proc_005D3228()
|
0061152D   E8F61CFCFF             call    005D3228
00611532   FFB524FFFFFF           push    dword ptr [ebp+$FFFFFF24]
00611538   6810346100             push    $00613410
0061153D   8D45C0                 lea     eax, [ebp-$40]
00611540   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00611545   E89639DFFF             call    00404EE0
0061154A   8B03                   mov     eax, [ebx]
0061154C   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00611552   E895DFE9FF             call    004AF4EC
00611557   8B03                   mov     eax, [ebx]
00611559   8B809C000000           mov     eax, [eax+$009C]
0061155F   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00611566   7516                   jnz     0061157E
00611568   8B03                   mov     eax, [ebx]
0061156A   8B807C080000           mov     eax, [eax+$087C]
00611570   8B10                   mov     edx, [eax]
00611572   FF5258                 call    dword ptr [edx+$58]
00611575   3B45CC                 cmp     eax, [ebp-$34]
00611578   0F8467FEFFFF           jz      006113E5
0061157E   8B03                   mov     eax, [ebx]
00611580   8B809C000000           mov     eax, [eax+$009C]
00611586   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00611588   E8CF15ECFF             call    004D2B5C

* Reference to Form1
|
0061158D   8B45F8                 mov     eax, [ebp-$08]
00611590   89459C                 mov     [ebp-$64], eax
00611593   C645A000               mov     byte ptr [ebp-$60], $00
00611597   8D559C                 lea     edx, [ebp-$64]
0061159A   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_009C
|
0061159C   8B809C000000           mov     eax, [eax+$009C]
006115A2   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
006115A4   E8BB1CECFF             call    004D3264
006115A9   B201                   mov     dl, $01

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006115AB   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
006115B1   E86EB3E3FF             call    0044C924
006115B6   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
006115B8   8B8074080000           mov     eax, [eax+$0874]
006115BE   8B10                   mov     edx, [eax]
006115C0   FF5258                 call    dword ptr [edx+$58]
006115C3   8D9520FFFFFF           lea     edx, [ebp+$FFFFFF20]

* Reference to: Unit_00408494.Proc_00409950
|
006115C9   E88283DFFF             call    00409950
006115CE   8B8520FFFFFF           mov     eax, [ebp+$FFFFFF20]
006115D4   50                     push    eax
006115D5   33C9                   xor     ecx, ecx
006115D7   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006115D9   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006115DF   E818E5ECFF             call    004DFAFC

* Possible String Reference to: 'Base(n) von '
|
006115E4   6834346100             push    $00613434
006115E9   8D9518FFFFFF           lea     edx, [ebp+$FFFFFF18]
006115EF   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
006115F1   8B8080080000           mov     eax, [eax+$0880]
006115F7   8B08                   mov     ecx, [eax]
006115F9   FF5160                 call    dword ptr [ecx+$60]
006115FC   FFB518FFFFFF           push    dword ptr [ebp+$FFFFFF18]
00611602   684C346100             push    $0061344C
00611607   8D9514FFFFFF           lea     edx, [ebp+$FFFFFF14]
0061160D   8B03                   mov     eax, [ebx]
0061160F   8B8084080000           mov     eax, [eax+$0884]
00611615   8B08                   mov     ecx, [eax]
00611617   FF5160                 call    dword ptr [ecx+$60]
0061161A   FFB514FFFFFF           push    dword ptr [ebp+$FFFFFF14]
00611620   8D851CFFFFFF           lea     eax, [ebp+$FFFFFF1C]
00611626   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
0061162B   E8B038DFFF             call    00404EE0
00611630   8B851CFFFFFF           mov     eax, [ebp+$FFFFFF1C]
00611636   50                     push    eax
00611637   33C9                   xor     ecx, ecx
00611639   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0061163E   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611644   E8B3E4ECFF             call    004DFAFC
00611649   8D950CFFFFFF           lea     edx, [ebp+$FFFFFF0C]
0061164F   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
00611651   8B809C080000           mov     eax, [eax+$089C]
00611657   8B08                   mov     ecx, [eax]
00611659   FF5160                 call    dword ptr [ecx+$60]
0061165C   8B850CFFFFFF           mov     eax, [ebp+$FFFFFF0C]
00611662   8D9510FFFFFF           lea     edx, [ebp+$FFFFFF10]

* Reference to: Unit_00408494.Proc_00409448
|
00611668   E8DB7DDFFF             call    00409448
0061166D   83BD10FFFFFF00         cmp     dword ptr [ebp+$FFFFFF10], +$00
00611674   7644                   jbe     006116BA
00611676   8D9504FFFFFF           lea     edx, [ebp+$FFFFFF04]
0061167C   8B03                   mov     eax, [ebx]
0061167E   8B809C080000           mov     eax, [eax+$089C]
00611684   8B08                   mov     ecx, [eax]
00611686   FF5160                 call    dword ptr [ecx+$60]
00611689   8B8D04FFFFFF           mov     ecx, [ebp+$FFFFFF04]
0061168F   8D8508FFFFFF           lea     eax, [ebp+$FFFFFF08]

* Possible String Reference to: '* '
|
00611695   BA58346100             mov     edx, $00613458

* Reference to: System.@LStrCat3;
|
0061169A   E8CD37DFFF             call    00404E6C
0061169F   8B8508FFFFFF           mov     eax, [ebp+$FFFFFF08]
006116A5   50                     push    eax
006116A6   33C9                   xor     ecx, ecx
006116A8   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006116AD   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006116B3   E844E4ECFF             call    004DFAFC
006116B8   EB6F                   jmp     00611729
006116BA   8D95FCFEFFFF           lea     edx, [ebp+$FFFFFEFC]
006116C0   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
006116C2   8B80AC080000           mov     eax, [eax+$08AC]
006116C8   8B08                   mov     ecx, [eax]
006116CA   FF5160                 call    dword ptr [ecx+$60]
006116CD   8B85FCFEFFFF           mov     eax, [ebp+$FFFFFEFC]
006116D3   8D9500FFFFFF           lea     edx, [ebp+$FFFFFF00]

* Reference to: Unit_00408494.Proc_00409448
|
006116D9   E86A7DDFFF             call    00409448
006116DE   83BD00FFFFFF00         cmp     dword ptr [ebp+$FFFFFF00], +$00
006116E5   7642                   jbe     00611729
006116E7   8D95F4FEFFFF           lea     edx, [ebp+$FFFFFEF4]
006116ED   8B03                   mov     eax, [ebx]
006116EF   8B80AC080000           mov     eax, [eax+$08AC]
006116F5   8B08                   mov     ecx, [eax]
006116F7   FF5160                 call    dword ptr [ecx+$60]
006116FA   8B8DF4FEFFFF           mov     ecx, [ebp+$FFFFFEF4]
00611700   8D85F8FEFFFF           lea     eax, [ebp+$FFFFFEF8]

* Possible String Reference to: '~ '
|
00611706   BA64346100             mov     edx, $00613464

* Reference to: System.@LStrCat3;
|
0061170B   E85C37DFFF             call    00404E6C
00611710   8B85F8FEFFFF           mov     eax, [ebp+$FFFFFEF8]
00611716   50                     push    eax
00611717   33C9                   xor     ecx, ecx
00611719   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0061171E   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611724   E8D3E3ECFF             call    004DFAFC
00611729   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]
0061172F   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
00611731   8B80C4080000           mov     eax, [eax+$08C4]
00611737   8B08                   mov     ecx, [eax]
00611739   FF5160                 call    dword ptr [ecx+$60]
0061173C   8B85ECFEFFFF           mov     eax, [ebp+$FFFFFEEC]
00611742   8D95F0FEFFFF           lea     edx, [ebp+$FFFFFEF0]

* Reference to: Unit_00408494.Proc_00409448
|
00611748   E8FB7CDFFF             call    00409448
0061174D   83BDF0FEFFFF00         cmp     dword ptr [ebp+$FFFFFEF0], +$00
00611754   7642                   jbe     00611798
00611756   8D95E4FEFFFF           lea     edx, [ebp+$FFFFFEE4]
0061175C   8B03                   mov     eax, [ebx]
0061175E   8B80C4080000           mov     eax, [eax+$08C4]
00611764   8B08                   mov     ecx, [eax]
00611766   FF5160                 call    dword ptr [ecx+$60]
00611769   8B8DE4FEFFFF           mov     ecx, [ebp+$FFFFFEE4]
0061176F   8D85E8FEFFFF           lea     eax, [ebp+$FFFFFEE8]

* Possible String Reference to: '+ '
|
00611775   BA70346100             mov     edx, $00613470

* Reference to: System.@LStrCat3;
|
0061177A   E8ED36DFFF             call    00404E6C
0061177F   8B85E8FEFFFF           mov     eax, [ebp+$FFFFFEE8]
00611785   50                     push    eax
00611786   33C9                   xor     ecx, ecx
00611788   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0061178D   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611793   E864E3ECFF             call    004DFAFC

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611798   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
0061179E   8B904C020000           mov     edx, [eax+$024C]
006117A4   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
006117A5   E826C1ECFF             call    004DD8D0

* Possible String Reference to: 'Tante(n):'
|
006117AA   687C346100             push    $0061347C

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006117AF   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
006117B5   8B884C020000           mov     ecx, [eax+$024C]
006117BB   49                     dec     ecx
006117BC   BA01000000             mov     edx, $00000001

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006117C1   E836E3ECFF             call    004DFAFC

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006117C6   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
006117CC   8BB84C020000           mov     edi, [eax+$024C]
006117D2   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.DockOrientation : TDockOrientation
|
006117D4   8B809C000000           mov     eax, [eax+$009C]
006117DA   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006117DC   E87B13ECFF             call    004D2B5C
006117E1   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrLen(String):Integer;
|
006117E4   E83736DFFF             call    00404E20
006117E9   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
006117EF   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
006117F5   D83588346100           fdiv    dword ptr [$00613488]

* Reference to: System.@ROUND;
|
006117FB   E83015DFFF             call    00402D30
00611800   85C0                   test    eax, eax
00611802   0F8EB9050000           jle     00611DC1
00611808   8945A4                 mov     [ebp-$5C], eax
0061180B   C745F001000000         mov     dword ptr [ebp-$10], $00000001
00611812   8D85DCFEFFFF           lea     eax, [ebp+$FFFFFEDC]
00611818   50                     push    eax
00611819   8B45F0                 mov     eax, [ebp-$10]
0061181C   48                     dec     eax
0061181D   8BD0                   mov     edx, eax
0061181F   C1E203                 shl     edx, $03
00611822   2BD0                   sub     edx, eax
00611824   83C207                 add     edx, +$07
00611827   B901000000             mov     ecx, $00000001
0061182C   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrCopy;
|
0061182F   E84438DFFF             call    00405078
00611834   8B85DCFEFFFF           mov     eax, [ebp+$FFFFFEDC]
0061183A   BA94346100             mov     edx, $00613494

* Reference to: System.@LStrCmp;
|
0061183F   E82037DFFF             call    00404F64
00611844   0F846B050000           jz      00611DB5
0061184A   8D85D8FEFFFF           lea     eax, [ebp+$FFFFFED8]
00611850   50                     push    eax
00611851   8B45F0                 mov     eax, [ebp-$10]
00611854   48                     dec     eax
00611855   8BD0                   mov     edx, eax
00611857   C1E203                 shl     edx, $03
0061185A   2BD0                   sub     edx, eax
0061185C   42                     inc     edx
0061185D   B906000000             mov     ecx, $00000006
00611862   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrCopy;
|
00611865   E80E38DFFF             call    00405078
0061186A   8B85D8FEFFFF           mov     eax, [ebp+$FFFFFED8]

* Reference to: Unit_00408494.Proc_004099B4
|
00611870   E83F81DFFF             call    004099B4
00611875   89459C                 mov     [ebp-$64], eax
00611878   C645A000               mov     byte ptr [ebp-$60], $00
0061187C   8D559C                 lea     edx, [ebp-$64]
0061187F   8B03                   mov     eax, [ebx]
00611881   8B809C000000           mov     eax, [eax+$009C]
00611887   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00611889   E8D619ECFF             call    004D3264
0061188E   8D95D0FEFFFF           lea     edx, [ebp+$FFFFFED0]
00611894   8B03                   mov     eax, [ebx]
00611896   8B8088080000           mov     eax, [eax+$0888]
0061189C   8B08                   mov     ecx, [eax]
0061189E   FF5160                 call    dword ptr [ecx+$60]
006118A1   8B85D0FEFFFF           mov     eax, [ebp+$FFFFFED0]
006118A7   8D95D4FEFFFF           lea     edx, [ebp+$FFFFFED4]

* Reference to: Unit_00408494.Proc_004091D8
|
006118AD   E82679DFFF             call    004091D8
006118B2   8B85D4FEFFFF           mov     eax, [ebp+$FFFFFED4]
006118B8   BA1C346100             mov     edx, $0061341C

* Reference to: System.@LStrCmp;
|
006118BD   E8A236DFFF             call    00404F64
006118C2   0F85F0010000           jnz     00611AB8

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006118C8   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
006118CE   8B904C020000           mov     edx, [eax+$024C]
006118D4   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
006118D5   E8F6BFECFF             call    004DD8D0
006118DA   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
006118DC   8B8074080000           mov     eax, [eax+$0874]
006118E2   8B10                   mov     edx, [eax]
006118E4   FF5258                 call    dword ptr [edx+$58]
006118E7   8D95CCFEFFFF           lea     edx, [ebp+$FFFFFECC]

* Reference to: Unit_00408494.Proc_00409950
|
006118ED   E85E80DFFF             call    00409950
006118F2   8B85CCFEFFFF           mov     eax, [ebp+$FFFFFECC]
006118F8   50                     push    eax
006118F9   8BCF                   mov     ecx, edi
006118FB   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006118FD   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611903   E8F4E1ECFF             call    004DFAFC
00611908   8D95C4FEFFFF           lea     edx, [ebp+$FFFFFEC4]
0061190E   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
00611910   8B8080080000           mov     eax, [eax+$0880]
00611916   8B08                   mov     ecx, [eax]
00611918   FF5160                 call    dword ptr [ecx+$60]
0061191B   FFB5C4FEFFFF           push    dword ptr [ebp+$FFFFFEC4]
00611921   684C346100             push    $0061344C
00611926   8D95C0FEFFFF           lea     edx, [ebp+$FFFFFEC0]
0061192C   8B03                   mov     eax, [ebx]
0061192E   8B8084080000           mov     eax, [eax+$0884]
00611934   8B08                   mov     ecx, [eax]
00611936   FF5160                 call    dword ptr [ecx+$60]
00611939   FFB5C0FEFFFF           push    dword ptr [ebp+$FFFFFEC0]
0061193F   8D85C8FEFFFF           lea     eax, [ebp+$FFFFFEC8]
00611945   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0061194A   E89135DFFF             call    00404EE0
0061194F   8B85C8FEFFFF           mov     eax, [ebp+$FFFFFEC8]
00611955   50                     push    eax
00611956   8BCF                   mov     ecx, edi
00611958   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0061195D   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611963   E894E1ECFF             call    004DFAFC
00611968   8D95B8FEFFFF           lea     edx, [ebp+$FFFFFEB8]
0061196E   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
00611970   8B809C080000           mov     eax, [eax+$089C]
00611976   8B08                   mov     ecx, [eax]
00611978   FF5160                 call    dword ptr [ecx+$60]
0061197B   8B85B8FEFFFF           mov     eax, [ebp+$FFFFFEB8]
00611981   8D95BCFEFFFF           lea     edx, [ebp+$FFFFFEBC]

* Reference to: Unit_00408494.Proc_00409448
|
00611987   E8BC7ADFFF             call    00409448
0061198C   83BDBCFEFFFF00         cmp     dword ptr [ebp+$FFFFFEBC], +$00
00611993   7644                   jbe     006119D9
00611995   8D95B0FEFFFF           lea     edx, [ebp+$FFFFFEB0]
0061199B   8B03                   mov     eax, [ebx]
0061199D   8B809C080000           mov     eax, [eax+$089C]
006119A3   8B08                   mov     ecx, [eax]
006119A5   FF5160                 call    dword ptr [ecx+$60]
006119A8   8B8DB0FEFFFF           mov     ecx, [ebp+$FFFFFEB0]
006119AE   8D85B4FEFFFF           lea     eax, [ebp+$FFFFFEB4]

* Possible String Reference to: '* '
|
006119B4   BA58346100             mov     edx, $00613458

* Reference to: System.@LStrCat3;
|
006119B9   E8AE34DFFF             call    00404E6C
006119BE   8B85B4FEFFFF           mov     eax, [ebp+$FFFFFEB4]
006119C4   50                     push    eax
006119C5   8BCF                   mov     ecx, edi
006119C7   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006119CC   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006119D2   E825E1ECFF             call    004DFAFC
006119D7   EB6F                   jmp     00611A48
006119D9   8D95A8FEFFFF           lea     edx, [ebp+$FFFFFEA8]
006119DF   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
006119E1   8B80AC080000           mov     eax, [eax+$08AC]
006119E7   8B08                   mov     ecx, [eax]
006119E9   FF5160                 call    dword ptr [ecx+$60]
006119EC   8B85A8FEFFFF           mov     eax, [ebp+$FFFFFEA8]
006119F2   8D95ACFEFFFF           lea     edx, [ebp+$FFFFFEAC]

* Reference to: Unit_00408494.Proc_00409448
|
006119F8   E84B7ADFFF             call    00409448
006119FD   83BDACFEFFFF00         cmp     dword ptr [ebp+$FFFFFEAC], +$00
00611A04   7642                   jbe     00611A48
00611A06   8D95A0FEFFFF           lea     edx, [ebp+$FFFFFEA0]
00611A0C   8B03                   mov     eax, [ebx]
00611A0E   8B80AC080000           mov     eax, [eax+$08AC]
00611A14   8B08                   mov     ecx, [eax]
00611A16   FF5160                 call    dword ptr [ecx+$60]
00611A19   8B8DA0FEFFFF           mov     ecx, [ebp+$FFFFFEA0]
00611A1F   8D85A4FEFFFF           lea     eax, [ebp+$FFFFFEA4]

* Possible String Reference to: '~ '
|
00611A25   BA64346100             mov     edx, $00613464

* Reference to: System.@LStrCat3;
|
00611A2A   E83D34DFFF             call    00404E6C
00611A2F   8B85A4FEFFFF           mov     eax, [ebp+$FFFFFEA4]
00611A35   50                     push    eax
00611A36   8BCF                   mov     ecx, edi
00611A38   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611A3D   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611A43   E8B4E0ECFF             call    004DFAFC
00611A48   8D9598FEFFFF           lea     edx, [ebp+$FFFFFE98]
00611A4E   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
00611A50   8B80C4080000           mov     eax, [eax+$08C4]
00611A56   8B08                   mov     ecx, [eax]
00611A58   FF5160                 call    dword ptr [ecx+$60]
00611A5B   8B8598FEFFFF           mov     eax, [ebp+$FFFFFE98]
00611A61   8D959CFEFFFF           lea     edx, [ebp+$FFFFFE9C]

* Reference to: Unit_00408494.Proc_00409448
|
00611A67   E8DC79DFFF             call    00409448
00611A6C   83BD9CFEFFFF00         cmp     dword ptr [ebp+$FFFFFE9C], +$00
00611A73   7642                   jbe     00611AB7
00611A75   8D9590FEFFFF           lea     edx, [ebp+$FFFFFE90]
00611A7B   8B03                   mov     eax, [ebx]
00611A7D   8B80C4080000           mov     eax, [eax+$08C4]
00611A83   8B08                   mov     ecx, [eax]
00611A85   FF5160                 call    dword ptr [ecx+$60]
00611A88   8B8D90FEFFFF           mov     ecx, [ebp+$FFFFFE90]
00611A8E   8D8594FEFFFF           lea     eax, [ebp+$FFFFFE94]

* Possible String Reference to: '+ '
|
00611A94   BA70346100             mov     edx, $00613470

* Reference to: System.@LStrCat3;
|
00611A99   E8CE33DFFF             call    00404E6C
00611A9E   8B8594FEFFFF           mov     eax, [ebp+$FFFFFE94]
00611AA4   50                     push    eax
00611AA5   8BCF                   mov     ecx, edi
00611AA7   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611AAC   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611AB2   E845E0ECFF             call    004DFAFC
00611AB7   47                     inc     edi
00611AB8   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.WheelAccumulator : Integer
|
00611ABA   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
00611AC0   BAA0346100             mov     edx, $006134A0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00611AC5   E89210ECFF             call    004D2B5C
00611ACA   8D9588FEFFFF           lea     edx, [ebp+$FFFFFE88]
00611AD0   8B03                   mov     eax, [ebx]

* Reference to field Integer.OFFS_0888
|
00611AD2   8B8088080000           mov     eax, [eax+$0888]
00611AD8   8B08                   mov     ecx, [eax]
00611ADA   FF5160                 call    dword ptr [ecx+$60]
00611ADD   8B8588FEFFFF           mov     eax, [ebp+$FFFFFE88]
00611AE3   8D958CFEFFFF           lea     edx, [ebp+$FFFFFE8C]

* Reference to: Unit_00408494.Proc_004091D8
|
00611AE9   E8EA76DFFF             call    004091D8
00611AEE   8B858CFEFFFF           mov     eax, [ebp+$FFFFFE8C]
00611AF4   BA04346100             mov     edx, $00613404

* Reference to: System.@LStrCmp;
|
00611AF9   E86634DFFF             call    00404F64
00611AFE   0F85B1020000           jnz     00611DB5
00611B04   8B03                   mov     eax, [ebx]
00611B06   8B8074080000           mov     eax, [eax+$0874]
00611B0C   8B10                   mov     edx, [eax]
00611B0E   FF5258                 call    dword ptr [edx+$58]
00611B11   89459C                 mov     [ebp-$64], eax
00611B14   C645A000               mov     byte ptr [ebp-$60], $00
00611B18   8D559C                 lea     edx, [ebp-$64]
00611B1B   8B03                   mov     eax, [ebx]
00611B1D   8B80A4000000           mov     eax, [eax+$00A4]
00611B23   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00611B25   E83A17ECFF             call    004D3264
00611B2A   84C0                   test    al, al
00611B2C   0F8483020000           jz      00611DB5
00611B32   E95A020000             jmp     00611D91
00611B37   8B03                   mov     eax, [ebx]
00611B39   8B809C000000           mov     eax, [eax+$009C]
00611B3F   8B10                   mov     edx, [eax]
00611B41   FF9250010000           call    dword ptr [edx+$0150]
00611B47   8945DC                 mov     [ebp-$24], eax
00611B4A   8B03                   mov     eax, [ebx]
00611B4C   8B80B8030000           mov     eax, [eax+$03B8]
00611B52   8B10                   mov     edx, [eax]
00611B54   FF5258                 call    dword ptr [edx+$58]
00611B57   89459C                 mov     [ebp-$64], eax
00611B5A   C645A000               mov     byte ptr [ebp-$60], $00
00611B5E   8D559C                 lea     edx, [ebp-$64]
00611B61   8B03                   mov     eax, [ebx]
00611B63   8B809C000000           mov     eax, [eax+$009C]
00611B69   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00611B6B   E8F416ECFF             call    004D3264

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611B70   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00611B76   8B904C020000           mov     edx, [eax+$024C]
00611B7C   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
00611B7D   E84EBDECFF             call    004DD8D0
00611B82   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
00611B84   8B8074080000           mov     eax, [eax+$0874]
00611B8A   8B10                   mov     edx, [eax]
00611B8C   FF5258                 call    dword ptr [edx+$58]
00611B8F   8D9584FEFFFF           lea     edx, [ebp+$FFFFFE84]

* Reference to: Unit_00408494.Proc_00409950
|
00611B95   E8B67DDFFF             call    00409950
00611B9A   8B8584FEFFFF           mov     eax, [ebp+$FFFFFE84]
00611BA0   50                     push    eax
00611BA1   8BCF                   mov     ecx, edi
00611BA3   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611BA5   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611BAB   E84CDFECFF             call    004DFAFC
00611BB0   8D957CFEFFFF           lea     edx, [ebp+$FFFFFE7C]
00611BB6   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
00611BB8   8B8080080000           mov     eax, [eax+$0880]
00611BBE   8B08                   mov     ecx, [eax]
00611BC0   FF5160                 call    dword ptr [ecx+$60]
00611BC3   FFB57CFEFFFF           push    dword ptr [ebp+$FFFFFE7C]
00611BC9   684C346100             push    $0061344C
00611BCE   8D9578FEFFFF           lea     edx, [ebp+$FFFFFE78]
00611BD4   8B03                   mov     eax, [ebx]
00611BD6   8B8084080000           mov     eax, [eax+$0884]
00611BDC   8B08                   mov     ecx, [eax]
00611BDE   FF5160                 call    dword ptr [ecx+$60]
00611BE1   FFB578FEFFFF           push    dword ptr [ebp+$FFFFFE78]
00611BE7   8D8580FEFFFF           lea     eax, [ebp+$FFFFFE80]
00611BED   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00611BF2   E8E932DFFF             call    00404EE0
00611BF7   8B8580FEFFFF           mov     eax, [ebp+$FFFFFE80]
00611BFD   50                     push    eax
00611BFE   8BCF                   mov     ecx, edi
00611C00   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611C05   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611C0B   E8ECDEECFF             call    004DFAFC
00611C10   8D9570FEFFFF           lea     edx, [ebp+$FFFFFE70]
00611C16   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
00611C18   8B809C080000           mov     eax, [eax+$089C]
00611C1E   8B08                   mov     ecx, [eax]
00611C20   FF5160                 call    dword ptr [ecx+$60]
00611C23   8B8570FEFFFF           mov     eax, [ebp+$FFFFFE70]
00611C29   8D9574FEFFFF           lea     edx, [ebp+$FFFFFE74]

* Reference to: Unit_00408494.Proc_00409448
|
00611C2F   E81478DFFF             call    00409448
00611C34   83BD74FEFFFF00         cmp     dword ptr [ebp+$FFFFFE74], +$00
00611C3B   7644                   jbe     00611C81
00611C3D   8D9568FEFFFF           lea     edx, [ebp+$FFFFFE68]
00611C43   8B03                   mov     eax, [ebx]
00611C45   8B809C080000           mov     eax, [eax+$089C]
00611C4B   8B08                   mov     ecx, [eax]
00611C4D   FF5160                 call    dword ptr [ecx+$60]
00611C50   8B8D68FEFFFF           mov     ecx, [ebp+$FFFFFE68]
00611C56   8D856CFEFFFF           lea     eax, [ebp+$FFFFFE6C]

* Possible String Reference to: '* '
|
00611C5C   BA58346100             mov     edx, $00613458

* Reference to: System.@LStrCat3;
|
00611C61   E80632DFFF             call    00404E6C
00611C66   8B856CFEFFFF           mov     eax, [ebp+$FFFFFE6C]
00611C6C   50                     push    eax
00611C6D   8BCF                   mov     ecx, edi
00611C6F   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611C74   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611C7A   E87DDEECFF             call    004DFAFC
00611C7F   EB6F                   jmp     00611CF0
00611C81   8D9560FEFFFF           lea     edx, [ebp+$FFFFFE60]
00611C87   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
00611C89   8B80AC080000           mov     eax, [eax+$08AC]
00611C8F   8B08                   mov     ecx, [eax]
00611C91   FF5160                 call    dword ptr [ecx+$60]
00611C94   8B8560FEFFFF           mov     eax, [ebp+$FFFFFE60]
00611C9A   8D9564FEFFFF           lea     edx, [ebp+$FFFFFE64]

* Reference to: Unit_00408494.Proc_00409448
|
00611CA0   E8A377DFFF             call    00409448
00611CA5   83BD64FEFFFF00         cmp     dword ptr [ebp+$FFFFFE64], +$00
00611CAC   7642                   jbe     00611CF0
00611CAE   8D9558FEFFFF           lea     edx, [ebp+$FFFFFE58]
00611CB4   8B03                   mov     eax, [ebx]
00611CB6   8B80AC080000           mov     eax, [eax+$08AC]
00611CBC   8B08                   mov     ecx, [eax]
00611CBE   FF5160                 call    dword ptr [ecx+$60]
00611CC1   8B8D58FEFFFF           mov     ecx, [ebp+$FFFFFE58]
00611CC7   8D855CFEFFFF           lea     eax, [ebp+$FFFFFE5C]

* Possible String Reference to: '~ '
|
00611CCD   BA64346100             mov     edx, $00613464

* Reference to: System.@LStrCat3;
|
00611CD2   E89531DFFF             call    00404E6C
00611CD7   8B855CFEFFFF           mov     eax, [ebp+$FFFFFE5C]
00611CDD   50                     push    eax
00611CDE   8BCF                   mov     ecx, edi
00611CE0   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611CE5   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611CEB   E80CDEECFF             call    004DFAFC
00611CF0   8D9550FEFFFF           lea     edx, [ebp+$FFFFFE50]
00611CF6   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
00611CF8   8B80C4080000           mov     eax, [eax+$08C4]
00611CFE   8B08                   mov     ecx, [eax]
00611D00   FF5160                 call    dword ptr [ecx+$60]
00611D03   8B8550FEFFFF           mov     eax, [ebp+$FFFFFE50]
00611D09   8D9554FEFFFF           lea     edx, [ebp+$FFFFFE54]

* Reference to: Unit_00408494.Proc_00409448
|
00611D0F   E83477DFFF             call    00409448
00611D14   83BD54FEFFFF00         cmp     dword ptr [ebp+$FFFFFE54], +$00
00611D1B   7642                   jbe     00611D5F
00611D1D   8D9548FEFFFF           lea     edx, [ebp+$FFFFFE48]
00611D23   8B03                   mov     eax, [ebx]
00611D25   8B80C4080000           mov     eax, [eax+$08C4]
00611D2B   8B08                   mov     ecx, [eax]
00611D2D   FF5160                 call    dword ptr [ecx+$60]
00611D30   8B8D48FEFFFF           mov     ecx, [ebp+$FFFFFE48]
00611D36   8D854CFEFFFF           lea     eax, [ebp+$FFFFFE4C]

* Possible String Reference to: '+ '
|
00611D3C   BA70346100             mov     edx, $00613470

* Reference to: System.@LStrCat3;
|
00611D41   E82631DFFF             call    00404E6C
00611D46   8B854CFEFFFF           mov     eax, [ebp+$FFFFFE4C]
00611D4C   50                     push    eax
00611D4D   8BCF                   mov     ecx, edi
00611D4F   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611D54   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611D5A   E89DDDECFF             call    004DFAFC
00611D5F   47                     inc     edi
00611D60   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.WheelAccumulator : Integer
|
00611D62   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00611D68   E87FD7E9FF             call    004AF4EC
00611D6D   8B03                   mov     eax, [ebx]

* Reference to field Integer.OFFS_00A4
|
00611D6F   8B80A4000000           mov     eax, [eax+$00A4]
00611D75   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00611D7C   7537                   jnz     00611DB5
00611D7E   8B03                   mov     eax, [ebx]
00611D80   8B809C000000           mov     eax, [eax+$009C]
00611D86   8B55DC                 mov     edx, [ebp-$24]
00611D89   8B08                   mov     ecx, [eax]
00611D8B   FF91A0010000           call    dword ptr [ecx+$01A0]
00611D91   8B03                   mov     eax, [ebx]
00611D93   8B80B4030000           mov     eax, [eax+$03B4]
00611D99   8B10                   mov     edx, [eax]
00611D9B   FF5258                 call    dword ptr [edx+$58]
00611D9E   50                     push    eax
00611D9F   8B03                   mov     eax, [ebx]
00611DA1   8B8074080000           mov     eax, [eax+$0874]
00611DA7   8B10                   mov     edx, [eax]
00611DA9   FF5258                 call    dword ptr [edx+$58]
00611DAC   5A                     pop     edx
00611DAD   3BD0                   cmp     edx, eax
00611DAF   0F8482FDFFFF           jz      00611B37
00611DB5   FF45F0                 inc     dword ptr [ebp-$10]
00611DB8   FF4DA4                 dec     dword ptr [ebp-$5C]
00611DBB   0F8551FAFFFF           jnz     00611812
00611DC1   8B03                   mov     eax, [ebx]
00611DC3   8B809C000000           mov     eax, [eax+$009C]
00611DC9   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00611DCB   E88C0DECFF             call    004D2B5C
00611DD0   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrLen(String):Integer;
|
00611DD3   E84830DFFF             call    00404E20
00611DD8   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
00611DDE   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
00611DE4   D83588346100           fdiv    dword ptr [$00613488]

* Reference to: System.@ROUND;
|
00611DEA   E8410FDFFF             call    00402D30
00611DEF   85C0                   test    eax, eax
00611DF1   0F8E1D030000           jle     00612114
00611DF7   8945A4                 mov     [ebp-$5C], eax
00611DFA   C745F001000000         mov     dword ptr [ebp-$10], $00000001
00611E01   8D8544FEFFFF           lea     eax, [ebp+$FFFFFE44]
00611E07   50                     push    eax
00611E08   8B45F0                 mov     eax, [ebp-$10]
00611E0B   48                     dec     eax
00611E0C   8BD0                   mov     edx, eax
00611E0E   C1E203                 shl     edx, $03
00611E11   2BD0                   sub     edx, eax
00611E13   42                     inc     edx
00611E14   B906000000             mov     ecx, $00000006
00611E19   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrCopy;
|
00611E1C   E85732DFFF             call    00405078
00611E21   8B8544FEFFFF           mov     eax, [ebp+$FFFFFE44]

* Reference to: Unit_00408494.Proc_004099B4
|
00611E27   E8887BDFFF             call    004099B4
00611E2C   89459C                 mov     [ebp-$64], eax
00611E2F   C645A000               mov     byte ptr [ebp-$60], $00
00611E33   8D559C                 lea     edx, [ebp-$64]
00611E36   8B03                   mov     eax, [ebx]
00611E38   8B809C000000           mov     eax, [eax+$009C]
00611E3E   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00611E40   E81F14ECFF             call    004D3264
00611E45   8B03                   mov     eax, [ebx]
00611E47   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
00611E4D   BAA0346100             mov     edx, $006134A0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00611E52   E8050DECFF             call    004D2B5C
00611E57   8B03                   mov     eax, [ebx]
00611E59   8B8074080000           mov     eax, [eax+$0874]
00611E5F   8B10                   mov     edx, [eax]
00611E61   FF5258                 call    dword ptr [edx+$58]
00611E64   89459C                 mov     [ebp-$64], eax
00611E67   C645A000               mov     byte ptr [ebp-$60], $00
00611E6B   8D559C                 lea     edx, [ebp-$64]
00611E6E   8B03                   mov     eax, [ebx]
00611E70   8B80A4000000           mov     eax, [eax+$00A4]
00611E76   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00611E78   E8E713ECFF             call    004D3264
00611E7D   84C0                   test    al, al
00611E7F   0F8483020000           jz      00612108
00611E85   E95A020000             jmp     006120E4
00611E8A   8B03                   mov     eax, [ebx]
00611E8C   8B809C000000           mov     eax, [eax+$009C]
00611E92   8B10                   mov     edx, [eax]
00611E94   FF9250010000           call    dword ptr [edx+$0150]
00611E9A   8945DC                 mov     [ebp-$24], eax
00611E9D   8B03                   mov     eax, [ebx]
00611E9F   8B80B8030000           mov     eax, [eax+$03B8]
00611EA5   8B10                   mov     edx, [eax]
00611EA7   FF5258                 call    dword ptr [edx+$58]
00611EAA   89459C                 mov     [ebp-$64], eax
00611EAD   C645A000               mov     byte ptr [ebp-$60], $00
00611EB1   8D559C                 lea     edx, [ebp-$64]
00611EB4   8B03                   mov     eax, [ebx]
00611EB6   8B809C000000           mov     eax, [eax+$009C]
00611EBC   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00611EBE   E8A113ECFF             call    004D3264

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611EC3   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00611EC9   8B904C020000           mov     edx, [eax+$024C]
00611ECF   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
00611ED0   E8FBB9ECFF             call    004DD8D0
00611ED5   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
00611ED7   8B8074080000           mov     eax, [eax+$0874]
00611EDD   8B10                   mov     edx, [eax]
00611EDF   FF5258                 call    dword ptr [edx+$58]
00611EE2   8D9540FEFFFF           lea     edx, [ebp+$FFFFFE40]

* Reference to: Unit_00408494.Proc_00409950
|
00611EE8   E8637ADFFF             call    00409950
00611EED   8B8540FEFFFF           mov     eax, [ebp+$FFFFFE40]
00611EF3   50                     push    eax
00611EF4   8BCF                   mov     ecx, edi
00611EF6   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611EF8   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611EFE   E8F9DBECFF             call    004DFAFC
00611F03   8D9538FEFFFF           lea     edx, [ebp+$FFFFFE38]
00611F09   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
00611F0B   8B8080080000           mov     eax, [eax+$0880]
00611F11   8B08                   mov     ecx, [eax]
00611F13   FF5160                 call    dword ptr [ecx+$60]
00611F16   FFB538FEFFFF           push    dword ptr [ebp+$FFFFFE38]
00611F1C   684C346100             push    $0061344C
00611F21   8D9534FEFFFF           lea     edx, [ebp+$FFFFFE34]
00611F27   8B03                   mov     eax, [ebx]
00611F29   8B8084080000           mov     eax, [eax+$0884]
00611F2F   8B08                   mov     ecx, [eax]
00611F31   FF5160                 call    dword ptr [ecx+$60]
00611F34   FFB534FEFFFF           push    dword ptr [ebp+$FFFFFE34]
00611F3A   8D853CFEFFFF           lea     eax, [ebp+$FFFFFE3C]
00611F40   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00611F45   E8962FDFFF             call    00404EE0
00611F4A   8B853CFEFFFF           mov     eax, [ebp+$FFFFFE3C]
00611F50   50                     push    eax
00611F51   8BCF                   mov     ecx, edi
00611F53   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611F58   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611F5E   E899DBECFF             call    004DFAFC
00611F63   8D952CFEFFFF           lea     edx, [ebp+$FFFFFE2C]
00611F69   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
00611F6B   8B809C080000           mov     eax, [eax+$089C]
00611F71   8B08                   mov     ecx, [eax]
00611F73   FF5160                 call    dword ptr [ecx+$60]
00611F76   8B852CFEFFFF           mov     eax, [ebp+$FFFFFE2C]
00611F7C   8D9530FEFFFF           lea     edx, [ebp+$FFFFFE30]

* Reference to: Unit_00408494.Proc_00409448
|
00611F82   E8C174DFFF             call    00409448
00611F87   83BD30FEFFFF00         cmp     dword ptr [ebp+$FFFFFE30], +$00
00611F8E   7644                   jbe     00611FD4
00611F90   8D9524FEFFFF           lea     edx, [ebp+$FFFFFE24]
00611F96   8B03                   mov     eax, [ebx]
00611F98   8B809C080000           mov     eax, [eax+$089C]
00611F9E   8B08                   mov     ecx, [eax]
00611FA0   FF5160                 call    dword ptr [ecx+$60]
00611FA3   8B8D24FEFFFF           mov     ecx, [ebp+$FFFFFE24]
00611FA9   8D8528FEFFFF           lea     eax, [ebp+$FFFFFE28]

* Possible String Reference to: '* '
|
00611FAF   BA58346100             mov     edx, $00613458

* Reference to: System.@LStrCat3;
|
00611FB4   E8B32EDFFF             call    00404E6C
00611FB9   8B8528FEFFFF           mov     eax, [ebp+$FFFFFE28]
00611FBF   50                     push    eax
00611FC0   8BCF                   mov     ecx, edi
00611FC2   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00611FC7   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00611FCD   E82ADBECFF             call    004DFAFC
00611FD2   EB6F                   jmp     00612043
00611FD4   8D951CFEFFFF           lea     edx, [ebp+$FFFFFE1C]
00611FDA   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
00611FDC   8B80AC080000           mov     eax, [eax+$08AC]
00611FE2   8B08                   mov     ecx, [eax]
00611FE4   FF5160                 call    dword ptr [ecx+$60]
00611FE7   8B851CFEFFFF           mov     eax, [ebp+$FFFFFE1C]
00611FED   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]

* Reference to: Unit_00408494.Proc_00409448
|
00611FF3   E85074DFFF             call    00409448
00611FF8   83BD20FEFFFF00         cmp     dword ptr [ebp+$FFFFFE20], +$00
00611FFF   7642                   jbe     00612043
00612001   8D9514FEFFFF           lea     edx, [ebp+$FFFFFE14]
00612007   8B03                   mov     eax, [ebx]
00612009   8B80AC080000           mov     eax, [eax+$08AC]
0061200F   8B08                   mov     ecx, [eax]
00612011   FF5160                 call    dword ptr [ecx+$60]
00612014   8B8D14FEFFFF           mov     ecx, [ebp+$FFFFFE14]
0061201A   8D8518FEFFFF           lea     eax, [ebp+$FFFFFE18]

* Possible String Reference to: '~ '
|
00612020   BA64346100             mov     edx, $00613464

* Reference to: System.@LStrCat3;
|
00612025   E8422EDFFF             call    00404E6C
0061202A   8B8518FEFFFF           mov     eax, [ebp+$FFFFFE18]
00612030   50                     push    eax
00612031   8BCF                   mov     ecx, edi
00612033   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00612038   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
0061203E   E8B9DAECFF             call    004DFAFC
00612043   8D950CFEFFFF           lea     edx, [ebp+$FFFFFE0C]
00612049   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
0061204B   8B80C4080000           mov     eax, [eax+$08C4]
00612051   8B08                   mov     ecx, [eax]
00612053   FF5160                 call    dword ptr [ecx+$60]
00612056   8B850CFEFFFF           mov     eax, [ebp+$FFFFFE0C]
0061205C   8D9510FEFFFF           lea     edx, [ebp+$FFFFFE10]

* Reference to: Unit_00408494.Proc_00409448
|
00612062   E8E173DFFF             call    00409448
00612067   83BD10FEFFFF00         cmp     dword ptr [ebp+$FFFFFE10], +$00
0061206E   7642                   jbe     006120B2
00612070   8D9504FEFFFF           lea     edx, [ebp+$FFFFFE04]
00612076   8B03                   mov     eax, [ebx]
00612078   8B80C4080000           mov     eax, [eax+$08C4]
0061207E   8B08                   mov     ecx, [eax]
00612080   FF5160                 call    dword ptr [ecx+$60]
00612083   8B8D04FEFFFF           mov     ecx, [ebp+$FFFFFE04]
00612089   8D8508FEFFFF           lea     eax, [ebp+$FFFFFE08]

* Possible String Reference to: '+ '
|
0061208F   BA70346100             mov     edx, $00613470

* Reference to: System.@LStrCat3;
|
00612094   E8D32DDFFF             call    00404E6C
00612099   8B8508FEFFFF           mov     eax, [ebp+$FFFFFE08]
0061209F   50                     push    eax
006120A0   8BCF                   mov     ecx, edi
006120A2   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006120A7   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006120AD   E84ADAECFF             call    004DFAFC
006120B2   47                     inc     edi
006120B3   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.WheelAccumulator : Integer
|
006120B5   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
006120BB   E82CD4E9FF             call    004AF4EC
006120C0   8B03                   mov     eax, [ebx]

* Reference to field Integer.OFFS_00A4
|
006120C2   8B80A4000000           mov     eax, [eax+$00A4]
006120C8   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
006120CF   7537                   jnz     00612108
006120D1   8B03                   mov     eax, [ebx]
006120D3   8B809C000000           mov     eax, [eax+$009C]
006120D9   8B55DC                 mov     edx, [ebp-$24]
006120DC   8B08                   mov     ecx, [eax]
006120DE   FF91A0010000           call    dword ptr [ecx+$01A0]
006120E4   8B03                   mov     eax, [ebx]
006120E6   8B80B4030000           mov     eax, [eax+$03B4]
006120EC   8B10                   mov     edx, [eax]
006120EE   FF5258                 call    dword ptr [edx+$58]
006120F1   50                     push    eax
006120F2   8B03                   mov     eax, [ebx]
006120F4   8B8074080000           mov     eax, [eax+$0874]
006120FA   8B10                   mov     edx, [eax]
006120FC   FF5258                 call    dword ptr [edx+$58]
006120FF   5A                     pop     edx
00612100   3BD0                   cmp     edx, eax
00612102   0F8482FDFFFF           jz      00611E8A
00612108   FF45F0                 inc     dword ptr [ebp-$10]
0061210B   FF4DA4                 dec     dword ptr [ebp-$5C]
0061210E   0F85EDFCFFFF           jnz     00611E01
00612114   8B03                   mov     eax, [ebx]
00612116   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
0061211C   BAF8336100             mov     edx, $006133F8

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00612121   E8360AECFF             call    004D2B5C
00612126   8B03                   mov     eax, [ebx]
00612128   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0061212E   E8A1D0E9FF             call    004AF1D4
00612133   8D45B0                 lea     eax, [ebp-$50]

* Reference to: System.@LStrClr(void;void);
|
00612136   E82D2ADFFF             call    00404B68
0061213B   837DEC00               cmp     dword ptr [ebp-$14], +$00
0061213F   0F8E93000000           jle     006121D8

* Reference to Form1
|
00612145   8B45EC                 mov     eax, [ebp-$14]
00612148   89459C                 mov     [ebp-$64], eax
0061214B   C645A000               mov     byte ptr [ebp-$60], $00
0061214F   8D559C                 lea     edx, [ebp-$64]
00612152   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_009C
|
00612154   8B809C000000           mov     eax, [eax+$009C]
0061215A   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0061215C   E80311ECFF             call    004D3264
00612161   EB63                   jmp     006121C6
00612163   8B03                   mov     eax, [ebx]
00612165   8B8074080000           mov     eax, [eax+$0874]
0061216B   8B10                   mov     edx, [eax]
0061216D   FF5258                 call    dword ptr [edx+$58]
00612170   3B45F8                 cmp     eax, [ebp-$08]
00612173   7433                   jz      006121A8
00612175   FF75B0                 push    dword ptr [ebp-$50]
00612178   8B03                   mov     eax, [ebx]
0061217A   8B8074080000           mov     eax, [eax+$0874]
00612180   8B10                   mov     edx, [eax]
00612182   FF5258                 call    dword ptr [edx+$58]
00612185   8D9500FEFFFF           lea     edx, [ebp+$FFFFFE00]

* Reference to : TForm1.Proc_005D3228()
|
0061218B   E89810FCFF             call    005D3228
00612190   FFB500FEFFFF           push    dword ptr [ebp+$FFFFFE00]
00612196   6810346100             push    $00613410
0061219B   8D45B0                 lea     eax, [ebp-$50]
0061219E   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006121A3   E8382DDFFF             call    00404EE0
006121A8   8B03                   mov     eax, [ebx]
006121AA   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
006121B0   E837D3E9FF             call    004AF4EC
006121B5   8B03                   mov     eax, [ebx]
006121B7   8B809C000000           mov     eax, [eax+$009C]
006121BD   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
006121C4   7512                   jnz     006121D8
006121C6   8B03                   mov     eax, [ebx]
006121C8   8B8078080000           mov     eax, [eax+$0878]
006121CE   8B10                   mov     edx, [eax]
006121D0   FF5258                 call    dword ptr [edx+$58]
006121D3   3B45EC                 cmp     eax, [ebp-$14]
006121D6   748B                   jz      00612163
006121D8   8B03                   mov     eax, [ebx]
006121DA   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Open(TDataSet);
|
006121E0   E8A3AAE9FF             call    004ACC88
006121E5   8B03                   mov     eax, [ebx]
006121E7   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
006121ED   BAA0346100             mov     edx, $006134A0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006121F2   E86509ECFF             call    004D2B5C

* Reference to Form1
|
006121F7   8B45EC                 mov     eax, [ebp-$14]
006121FA   89459C                 mov     [ebp-$64], eax
006121FD   C645A000               mov     byte ptr [ebp-$60], $00
00612201   8D559C                 lea     edx, [ebp-$64]
00612204   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_00A4
|
00612206   8B80A4000000           mov     eax, [eax+$00A4]
0061220C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0061220E   E85110ECFF             call    004D3264
00612213   84C0                   test    al, al
00612215   0F841D010000           jz      00612338
0061221B   E902010000             jmp     00612322
00612220   8B03                   mov     eax, [ebx]
00612222   8B80B8030000           mov     eax, [eax+$03B8]
00612228   8B10                   mov     edx, [eax]
0061222A   FF5258                 call    dword ptr [edx+$58]
0061222D   3B45E4                 cmp     eax, [ebp-$1C]
00612230   0F84CE000000           jz      00612304
00612236   8B03                   mov     eax, [ebx]
00612238   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
0061223E   BA28346100             mov     edx, $00613428

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00612243   E81409ECFF             call    004D2B5C
00612248   8B03                   mov     eax, [ebx]
0061224A   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00612250   E87FCFE9FF             call    004AF1D4
00612255   8B03                   mov     eax, [ebx]
00612257   8B80B8030000           mov     eax, [eax+$03B8]
0061225D   8B10                   mov     edx, [eax]
0061225F   FF5258                 call    dword ptr [edx+$58]
00612262   89459C                 mov     [ebp-$64], eax
00612265   C645A000               mov     byte ptr [ebp-$60], $00
00612269   8D559C                 lea     edx, [ebp-$64]
0061226C   8B03                   mov     eax, [ebx]
0061226E   8B809C000000           mov     eax, [eax+$009C]
00612274   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00612276   E8E90FECFF             call    004D3264
0061227B   EB63                   jmp     006122E0
0061227D   8B03                   mov     eax, [ebx]
0061227F   8B8074080000           mov     eax, [eax+$0874]
00612285   8B10                   mov     edx, [eax]
00612287   FF5258                 call    dword ptr [edx+$58]
0061228A   3B45F8                 cmp     eax, [ebp-$08]
0061228D   7433                   jz      006122C2
0061228F   FF75B0                 push    dword ptr [ebp-$50]
00612292   8B03                   mov     eax, [ebx]
00612294   8B8074080000           mov     eax, [eax+$0874]
0061229A   8B10                   mov     edx, [eax]
0061229C   FF5258                 call    dword ptr [edx+$58]
0061229F   8D95FCFDFFFF           lea     edx, [ebp+$FFFFFDFC]

* Reference to : TForm1.Proc_005D3228()
|
006122A5   E87E0FFCFF             call    005D3228
006122AA   FFB5FCFDFFFF           push    dword ptr [ebp+$FFFFFDFC]
006122B0   6810346100             push    $00613410
006122B5   8D45B0                 lea     eax, [ebp-$50]
006122B8   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006122BD   E81E2CDFFF             call    00404EE0
006122C2   8B03                   mov     eax, [ebx]
006122C4   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
006122CA   E81DD2E9FF             call    004AF4EC
006122CF   8B03                   mov     eax, [ebx]
006122D1   8B809C000000           mov     eax, [eax+$009C]
006122D7   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
006122DE   7524                   jnz     00612304
006122E0   8B03                   mov     eax, [ebx]
006122E2   8B8078080000           mov     eax, [eax+$0878]
006122E8   8B10                   mov     edx, [eax]
006122EA   FF5258                 call    dword ptr [edx+$58]
006122ED   8BF8                   mov     edi, eax
006122EF   8B03                   mov     eax, [ebx]
006122F1   8B80B8030000           mov     eax, [eax+$03B8]
006122F7   8B10                   mov     edx, [eax]
006122F9   FF5258                 call    dword ptr [edx+$58]
006122FC   3BF8                   cmp     edi, eax
006122FE   0F8479FFFFFF           jz      0061227D
00612304   8B03                   mov     eax, [ebx]
00612306   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0061230C   E8DBD1E9FF             call    004AF4EC
00612311   8B03                   mov     eax, [ebx]
00612313   8B80A4000000           mov     eax, [eax+$00A4]
00612319   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00612320   7516                   jnz     00612338
00612322   8B03                   mov     eax, [ebx]
00612324   8B80B4030000           mov     eax, [eax+$03B4]
0061232A   8B10                   mov     edx, [eax]
0061232C   FF5258                 call    dword ptr [edx+$58]
0061232F   3B45EC                 cmp     eax, [ebp-$14]
00612332   0F84E8FEFFFF           jz      00612220
00612338   8B03                   mov     eax, [ebx]
0061233A   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
00612340   BAA0346100             mov     edx, $006134A0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00612345   E81208ECFF             call    004D2B5C
0061234A   8B03                   mov     eax, [ebx]
0061234C   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.First(TDataSet);
|
00612352   E87DCEE9FF             call    004AF1D4

* Reference to Form1
|
00612357   8B45F8                 mov     eax, [ebp-$08]
0061235A   89459C                 mov     [ebp-$64], eax
0061235D   C645A000               mov     byte ptr [ebp-$60], $00
00612361   8D559C                 lea     edx, [ebp-$64]
00612364   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_00A4
|
00612366   8B80A4000000           mov     eax, [eax+$00A4]
0061236C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0061236E   E8F10EECFF             call    004D3264
00612373   84C0                   test    al, al
00612375   0F84F6020000           jz      00612671
0061237B   E9DB020000             jmp     0061265B
00612380   8B03                   mov     eax, [ebx]
00612382   8B80B8030000           mov     eax, [eax+$03B8]
00612388   8B10                   mov     edx, [eax]
0061238A   FF5258                 call    dword ptr [edx+$58]
0061238D   85C0                   test    eax, eax
0061238F   0F8EA8020000           jle     0061263D
00612395   8B03                   mov     eax, [ebx]
00612397   8B80B8030000           mov     eax, [eax+$03B8]
0061239D   8B10                   mov     edx, [eax]
0061239F   FF5258                 call    dword ptr [edx+$58]
006123A2   8945C8                 mov     [ebp-$38], eax
006123A5   8B03                   mov     eax, [ebx]
006123A7   8B809C000000           mov     eax, [eax+$009C]
006123AD   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006123AF   E8A807ECFF             call    004D2B5C
006123B4   8B03                   mov     eax, [ebx]
006123B6   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
006123BC   E813CEE9FF             call    004AF1D4
006123C1   8B03                   mov     eax, [ebx]
006123C3   8B80B8030000           mov     eax, [eax+$03B8]
006123C9   8B10                   mov     edx, [eax]
006123CB   FF5258                 call    dword ptr [edx+$58]
006123CE   89459C                 mov     [ebp-$64], eax
006123D1   C645A000               mov     byte ptr [ebp-$60], $00
006123D5   8D559C                 lea     edx, [ebp-$64]
006123D8   8B03                   mov     eax, [ebx]
006123DA   8B809C000000           mov     eax, [eax+$009C]
006123E0   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
006123E2   E87D0EECFF             call    004D3264
006123E7   8B03                   mov     eax, [ebx]
006123E9   8B8078080000           mov     eax, [eax+$0878]
006123EF   8B10                   mov     edx, [eax]
006123F1   FF5258                 call    dword ptr [edx+$58]
006123F4   85C0                   test    eax, eax
006123F6   0F8EFE000000           jle     006124FA
006123FC   8B03                   mov     eax, [ebx]
006123FE   8B8078080000           mov     eax, [eax+$0878]
00612404   8B10                   mov     edx, [eax]
00612406   FF5258                 call    dword ptr [edx+$58]
00612409   8BF8                   mov     edi, eax
0061240B   8B03                   mov     eax, [ebx]
0061240D   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
00612413   BAF8336100             mov     edx, $006133F8

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00612418   E83F07ECFF             call    004D2B5C
0061241D   8B03                   mov     eax, [ebx]
0061241F   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00612425   E8AACDE9FF             call    004AF1D4
0061242A   897D9C                 mov     [ebp-$64], edi
0061242D   C645A000               mov     byte ptr [ebp-$60], $00
00612431   8D559C                 lea     edx, [ebp-$64]
00612434   8B03                   mov     eax, [ebx]
00612436   8B809C000000           mov     eax, [eax+$009C]
0061243C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0061243E   E8210EECFF             call    004D3264
00612443   E99D000000             jmp     006124E5
00612448   8B03                   mov     eax, [ebx]
0061244A   8B8074080000           mov     eax, [eax+$0874]
00612450   8B10                   mov     edx, [eax]
00612452   FF5258                 call    dword ptr [edx+$58]
00612455   3B45C8                 cmp     eax, [ebp-$38]
00612458   746D                   jz      006124C7
0061245A   8B03                   mov     eax, [ebx]
0061245C   8B8074080000           mov     eax, [eax+$0874]
00612462   8B10                   mov     edx, [eax]
00612464   FF5258                 call    dword ptr [edx+$58]
00612467   8D95F8FDFFFF           lea     edx, [ebp+$FFFFFDF8]

* Reference to : TForm1.Proc_005D3228()
|
0061246D   E8B60DFCFF             call    005D3228
00612472   8D85F8FDFFFF           lea     eax, [ebp+$FFFFFDF8]
00612478   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
0061247D   E8A629DFFF             call    00404E28
00612482   8B85F8FDFFFF           mov     eax, [ebp+$FFFFFDF8]
00612488   8B55B0                 mov     edx, [ebp-$50]

* Reference to: System.@LStrPos;
|
0061248B   E8CC2CDFFF             call    0040515C
00612490   85C0                   test    eax, eax
00612492   7533                   jnz     006124C7
00612494   FF75B0                 push    dword ptr [ebp-$50]
00612497   8B03                   mov     eax, [ebx]
00612499   8B8074080000           mov     eax, [eax+$0874]
0061249F   8B10                   mov     edx, [eax]
006124A1   FF5258                 call    dword ptr [edx+$58]
006124A4   8D95F4FDFFFF           lea     edx, [ebp+$FFFFFDF4]

* Reference to : TForm1.Proc_005D3228()
|
006124AA   E8790DFCFF             call    005D3228
006124AF   FFB5F4FDFFFF           push    dword ptr [ebp+$FFFFFDF4]
006124B5   6810346100             push    $00613410
006124BA   8D45B0                 lea     eax, [ebp-$50]
006124BD   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006124C2   E8192ADFFF             call    00404EE0
006124C7   8B03                   mov     eax, [ebx]
006124C9   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
006124CF   E818D0E9FF             call    004AF4EC
006124D4   8B03                   mov     eax, [ebx]
006124D6   8B809C000000           mov     eax, [eax+$009C]
006124DC   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
006124E3   7515                   jnz     006124FA
006124E5   8B03                   mov     eax, [ebx]
006124E7   8B8078080000           mov     eax, [eax+$0878]
006124ED   8B10                   mov     edx, [eax]
006124EF   FF5258                 call    dword ptr [edx+$58]
006124F2   3BF8                   cmp     edi, eax
006124F4   0F844EFFFFFF           jz      00612448
006124FA   8B03                   mov     eax, [ebx]
006124FC   8B809C000000           mov     eax, [eax+$009C]
00612502   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00612504   E85306ECFF             call    004D2B5C
00612509   8B03                   mov     eax, [ebx]
0061250B   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00612511   E8BECCE9FF             call    004AF1D4
00612516   8B03                   mov     eax, [ebx]
00612518   8B80B8030000           mov     eax, [eax+$03B8]
0061251E   8B10                   mov     edx, [eax]
00612520   FF5258                 call    dword ptr [edx+$58]
00612523   89459C                 mov     [ebp-$64], eax
00612526   C645A000               mov     byte ptr [ebp-$60], $00
0061252A   8D559C                 lea     edx, [ebp-$64]
0061252D   8B03                   mov     eax, [ebx]
0061252F   8B809C000000           mov     eax, [eax+$009C]
00612535   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00612537   E8280DECFF             call    004D3264
0061253C   8B03                   mov     eax, [ebx]
0061253E   8B807C080000           mov     eax, [eax+$087C]
00612544   8B10                   mov     edx, [eax]
00612546   FF5258                 call    dword ptr [edx+$58]
00612549   85C0                   test    eax, eax
0061254B   0F8EEC000000           jle     0061263D
00612551   8B03                   mov     eax, [ebx]
00612553   8B807C080000           mov     eax, [eax+$087C]
00612559   8B10                   mov     edx, [eax]
0061255B   FF5258                 call    dword ptr [edx+$58]
0061255E   8BF8                   mov     edi, eax
00612560   8B03                   mov     eax, [ebx]
00612562   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
00612568   BA28346100             mov     edx, $00613428

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0061256D   E8EA05ECFF             call    004D2B5C
00612572   8B03                   mov     eax, [ebx]
00612574   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0061257A   E855CCE9FF             call    004AF1D4
0061257F   897D9C                 mov     [ebp-$64], edi
00612582   C645A000               mov     byte ptr [ebp-$60], $00
00612586   8D559C                 lea     edx, [ebp-$64]
00612589   8B03                   mov     eax, [ebx]
0061258B   8B809C000000           mov     eax, [eax+$009C]
00612591   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00612593   E8CC0CECFF             call    004D3264
00612598   E98B000000             jmp     00612628
0061259D   8B03                   mov     eax, [ebx]
0061259F   8B8074080000           mov     eax, [eax+$0874]
006125A5   8B10                   mov     edx, [eax]
006125A7   FF5258                 call    dword ptr [edx+$58]
006125AA   8D95F0FDFFFF           lea     edx, [ebp+$FFFFFDF0]

* Reference to : TForm1.Proc_005D3228()
|
006125B0   E8730CFCFF             call    005D3228
006125B5   8D85F0FDFFFF           lea     eax, [ebp+$FFFFFDF0]
006125BB   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
006125C0   E86328DFFF             call    00404E28
006125C5   8B85F0FDFFFF           mov     eax, [ebp+$FFFFFDF0]
006125CB   8B55B0                 mov     edx, [ebp-$50]

* Reference to: System.@LStrPos;
|
006125CE   E8892BDFFF             call    0040515C
006125D3   85C0                   test    eax, eax
006125D5   7533                   jnz     0061260A
006125D7   FF75B0                 push    dword ptr [ebp-$50]
006125DA   8B03                   mov     eax, [ebx]
006125DC   8B8074080000           mov     eax, [eax+$0874]
006125E2   8B10                   mov     edx, [eax]
006125E4   FF5258                 call    dword ptr [edx+$58]
006125E7   8D95ECFDFFFF           lea     edx, [ebp+$FFFFFDEC]

* Reference to : TForm1.Proc_005D3228()
|
006125ED   E8360CFCFF             call    005D3228
006125F2   FFB5ECFDFFFF           push    dword ptr [ebp+$FFFFFDEC]
006125F8   6810346100             push    $00613410
006125FD   8D45B0                 lea     eax, [ebp-$50]
00612600   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00612605   E8D628DFFF             call    00404EE0
0061260A   8B03                   mov     eax, [ebx]
0061260C   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00612612   E8D5CEE9FF             call    004AF4EC
00612617   8B03                   mov     eax, [ebx]
00612619   8B809C000000           mov     eax, [eax+$009C]
0061261F   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00612626   7515                   jnz     0061263D
00612628   8B03                   mov     eax, [ebx]
0061262A   8B8078080000           mov     eax, [eax+$0878]
00612630   8B10                   mov     edx, [eax]
00612632   FF5258                 call    dword ptr [edx+$58]
00612635   3BF8                   cmp     edi, eax
00612637   0F8460FFFFFF           jz      0061259D
0061263D   8B03                   mov     eax, [ebx]
0061263F   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00612645   E8A2CEE9FF             call    004AF4EC
0061264A   8B03                   mov     eax, [ebx]
0061264C   8B80A4000000           mov     eax, [eax+$00A4]
00612652   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00612659   7516                   jnz     00612671
0061265B   8B03                   mov     eax, [ebx]
0061265D   8B80B4030000           mov     eax, [eax+$03B4]
00612663   8B10                   mov     edx, [eax]
00612665   FF5258                 call    dword ptr [edx+$58]
00612668   3B45F8                 cmp     eax, [ebp-$08]
0061266B   0F840FFDFFFF           jz      00612380
00612671   8D45AC                 lea     eax, [ebp-$54]

* Reference to: System.@LStrClr(void;void);
|
00612674   E8EF24DFFF             call    00404B68
00612679   8D95E8FDFFFF           lea     edx, [ebp+$FFFFFDE8]
0061267F   8B45B0                 mov     eax, [ebp-$50]

* Reference to: Unit_00408494.Proc_00409448
|
00612682   E8C16DDFFF             call    00409448
00612687   8B85E8FDFFFF           mov     eax, [ebp+$FFFFFDE8]

* Reference to: System.@LStrLen(String):Integer;
|
0061268D   E88E27DFFF             call    00404E20
00612692   85C0                   test    eax, eax
00612694   0F8E93030000           jle     00612A2D
0061269A   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrLen(String):Integer;
|
0061269D   E87E27DFFF             call    00404E20
006126A2   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
006126A8   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
006126AE   D83588346100           fdiv    dword ptr [$00613488]

* Reference to: System.@ROUND;
|
006126B4   E87706DFFF             call    00402D30
006126B9   85C0                   test    eax, eax
006126BB   0F8E6C030000           jle     00612A2D
006126C1   8945A4                 mov     [ebp-$5C], eax
006126C4   C745F001000000         mov     dword ptr [ebp-$10], $00000001
006126CB   8B03                   mov     eax, [ebx]
006126CD   8B809C000000           mov     eax, [eax+$009C]
006126D3   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006126D5   E88204ECFF             call    004D2B5C
006126DA   8D85E4FDFFFF           lea     eax, [ebp+$FFFFFDE4]
006126E0   50                     push    eax
006126E1   8B45F0                 mov     eax, [ebp-$10]
006126E4   48                     dec     eax
006126E5   8BF8                   mov     edi, eax
006126E7   C1E703                 shl     edi, $03
006126EA   2BF8                   sub     edi, eax
006126EC   47                     inc     edi
006126ED   8BD7                   mov     edx, edi
006126EF   B906000000             mov     ecx, $00000006
006126F4   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrCopy;
|
006126F7   E87C29DFFF             call    00405078
006126FC   8B85E4FDFFFF           mov     eax, [ebp+$FFFFFDE4]

* Reference to: Unit_00408494.Proc_004099B4
|
00612702   E8AD72DFFF             call    004099B4
00612707   89459C                 mov     [ebp-$64], eax
0061270A   C645A000               mov     byte ptr [ebp-$60], $00
0061270E   8D559C                 lea     edx, [ebp-$64]
00612711   8B03                   mov     eax, [ebx]
00612713   8B809C000000           mov     eax, [eax+$009C]
00612719   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0061271B   E8440BECFF             call    004D3264
00612720   8D95DCFDFFFF           lea     edx, [ebp+$FFFFFDDC]
00612726   8B03                   mov     eax, [ebx]
00612728   8B8088080000           mov     eax, [eax+$0888]
0061272E   8B08                   mov     ecx, [eax]
00612730   FF5160                 call    dword ptr [ecx+$60]
00612733   8B85DCFDFFFF           mov     eax, [ebp+$FFFFFDDC]
00612739   8D95E0FDFFFF           lea     edx, [ebp+$FFFFFDE0]

* Reference to: Unit_00408494.Proc_004091D8
|
0061273F   E8946ADFFF             call    004091D8
00612744   8B85E0FDFFFF           mov     eax, [ebp+$FFFFFDE0]
0061274A   BA04346100             mov     edx, $00613404

* Reference to: System.@LStrCmp;
|
0061274F   E81028DFFF             call    00404F64
00612754   0F8546010000           jnz     006128A0
0061275A   8B03                   mov     eax, [ebx]
0061275C   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
00612762   BAF8336100             mov     edx, $006133F8

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00612767   E8F003ECFF             call    004D2B5C
0061276C   8B03                   mov     eax, [ebx]
0061276E   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00612774   E85BCAE9FF             call    004AF1D4
00612779   8D85D8FDFFFF           lea     eax, [ebp+$FFFFFDD8]
0061277F   50                     push    eax
00612780   8BD7                   mov     edx, edi
00612782   B906000000             mov     ecx, $00000006
00612787   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrCopy;
|
0061278A   E8E928DFFF             call    00405078
0061278F   8B85D8FDFFFF           mov     eax, [ebp+$FFFFFDD8]

* Reference to: Unit_00408494.Proc_004099B4
|
00612795   E81A72DFFF             call    004099B4
0061279A   89459C                 mov     [ebp-$64], eax
0061279D   C645A000               mov     byte ptr [ebp-$60], $00
006127A1   8D559C                 lea     edx, [ebp-$64]
006127A4   8B03                   mov     eax, [ebx]
006127A6   8B809C000000           mov     eax, [eax+$009C]
006127AC   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
006127AE   E8B10AECFF             call    004D3264
006127B3   E9A1000000             jmp     00612859
006127B8   8B03                   mov     eax, [ebx]
006127BA   8B8074080000           mov     eax, [eax+$0874]
006127C0   8B10                   mov     edx, [eax]
006127C2   FF5258                 call    dword ptr [edx+$58]
006127C5   3B45F8                 cmp     eax, [ebp-$08]
006127C8   746D                   jz      00612837
006127CA   8B03                   mov     eax, [ebx]
006127CC   8B8074080000           mov     eax, [eax+$0874]
006127D2   8B10                   mov     edx, [eax]
006127D4   FF5258                 call    dword ptr [edx+$58]
006127D7   8D95D4FDFFFF           lea     edx, [ebp+$FFFFFDD4]

* Reference to : TForm1.Proc_005D3228()
|
006127DD   E8460AFCFF             call    005D3228
006127E2   8D85D4FDFFFF           lea     eax, [ebp+$FFFFFDD4]
006127E8   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
006127ED   E83626DFFF             call    00404E28
006127F2   8B85D4FDFFFF           mov     eax, [ebp+$FFFFFDD4]
006127F8   8B55AC                 mov     edx, [ebp-$54]

* Reference to: System.@LStrPos;
|
006127FB   E85C29DFFF             call    0040515C
00612800   85C0                   test    eax, eax
00612802   7533                   jnz     00612837
00612804   FF75AC                 push    dword ptr [ebp-$54]
00612807   8B03                   mov     eax, [ebx]
00612809   8B8074080000           mov     eax, [eax+$0874]
0061280F   8B10                   mov     edx, [eax]
00612811   FF5258                 call    dword ptr [edx+$58]
00612814   8D95D0FDFFFF           lea     edx, [ebp+$FFFFFDD0]

* Reference to : TForm1.Proc_005D3228()
|
0061281A   E8090AFCFF             call    005D3228
0061281F   FFB5D0FDFFFF           push    dword ptr [ebp+$FFFFFDD0]
00612825   6810346100             push    $00613410
0061282A   8D45AC                 lea     eax, [ebp-$54]
0061282D   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00612832   E8A926DFFF             call    00404EE0
00612837   8B03                   mov     eax, [ebx]
00612839   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0061283F   E8A8CCE9FF             call    004AF4EC
00612844   8B03                   mov     eax, [ebx]
00612846   8B809C000000           mov     eax, [eax+$009C]
0061284C   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00612853   0F85C8010000           jnz     00612A21
00612859   8D85CCFDFFFF           lea     eax, [ebp+$FFFFFDCC]
0061285F   50                     push    eax
00612860   8B45F0                 mov     eax, [ebp-$10]
00612863   48                     dec     eax
00612864   8BD0                   mov     edx, eax
00612866   C1E203                 shl     edx, $03
00612869   2BD0                   sub     edx, eax
0061286B   42                     inc     edx
0061286C   B906000000             mov     ecx, $00000006
00612871   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrCopy;
|
00612874   E8FF27DFFF             call    00405078
00612879   8B85CCFDFFFF           mov     eax, [ebp+$FFFFFDCC]

* Reference to: Unit_00408494.Proc_004099B4
|
0061287F   E83071DFFF             call    004099B4
00612884   8BF8                   mov     edi, eax
00612886   8B03                   mov     eax, [ebx]
00612888   8B8078080000           mov     eax, [eax+$0878]
0061288E   8B10                   mov     edx, [eax]
00612890   FF5258                 call    dword ptr [edx+$58]
00612893   3BF8                   cmp     edi, eax
00612895   0F841DFFFFFF           jz      006127B8
0061289B   E981010000             jmp     00612A21
006128A0   8D95C4FDFFFF           lea     edx, [ebp+$FFFFFDC4]
006128A6   8B03                   mov     eax, [ebx]
006128A8   8B8088080000           mov     eax, [eax+$0888]
006128AE   8B08                   mov     ecx, [eax]
006128B0   FF5160                 call    dword ptr [ecx+$60]
006128B3   8B85C4FDFFFF           mov     eax, [ebp+$FFFFFDC4]
006128B9   8D95C8FDFFFF           lea     edx, [ebp+$FFFFFDC8]

* Reference to: Unit_00408494.Proc_004091D8
|
006128BF   E81469DFFF             call    004091D8
006128C4   8B85C8FDFFFF           mov     eax, [ebp+$FFFFFDC8]
006128CA   BA1C346100             mov     edx, $0061341C

* Reference to: System.@LStrCmp;
|
006128CF   E89026DFFF             call    00404F64
006128D4   0F8547010000           jnz     00612A21
006128DA   8B03                   mov     eax, [ebx]
006128DC   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
006128E2   BA28346100             mov     edx, $00613428

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006128E7   E87002ECFF             call    004D2B5C
006128EC   8B03                   mov     eax, [ebx]
006128EE   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
006128F4   E8DBC8E9FF             call    004AF1D4
006128F9   8D85C0FDFFFF           lea     eax, [ebp+$FFFFFDC0]
006128FF   50                     push    eax
00612900   8B45F0                 mov     eax, [ebp-$10]
00612903   48                     dec     eax
00612904   8BD0                   mov     edx, eax
00612906   C1E203                 shl     edx, $03
00612909   2BD0                   sub     edx, eax
0061290B   42                     inc     edx
0061290C   B906000000             mov     ecx, $00000006
00612911   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrCopy;
|
00612914   E85F27DFFF             call    00405078
00612919   8B85C0FDFFFF           mov     eax, [ebp+$FFFFFDC0]

* Reference to: Unit_00408494.Proc_004099B4
|
0061291F   E89070DFFF             call    004099B4
00612924   89459C                 mov     [ebp-$64], eax
00612927   C645A000               mov     byte ptr [ebp-$60], $00
0061292B   8D559C                 lea     edx, [ebp-$64]
0061292E   8B03                   mov     eax, [ebx]
00612930   8B809C000000           mov     eax, [eax+$009C]
00612936   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00612938   E82709ECFF             call    004D3264
0061293D   E99D000000             jmp     006129DF
00612942   8B03                   mov     eax, [ebx]
00612944   8B8074080000           mov     eax, [eax+$0874]
0061294A   8B10                   mov     edx, [eax]
0061294C   FF5258                 call    dword ptr [edx+$58]
0061294F   3B45F8                 cmp     eax, [ebp-$08]
00612952   746D                   jz      006129C1
00612954   8B03                   mov     eax, [ebx]
00612956   8B8074080000           mov     eax, [eax+$0874]
0061295C   8B10                   mov     edx, [eax]
0061295E   FF5258                 call    dword ptr [edx+$58]
00612961   8D95BCFDFFFF           lea     edx, [ebp+$FFFFFDBC]

* Reference to : TForm1.Proc_005D3228()
|
00612967   E8BC08FCFF             call    005D3228
0061296C   8D85BCFDFFFF           lea     eax, [ebp+$FFFFFDBC]
00612972   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
00612977   E8AC24DFFF             call    00404E28
0061297C   8B85BCFDFFFF           mov     eax, [ebp+$FFFFFDBC]
00612982   8B55AC                 mov     edx, [ebp-$54]

* Reference to: System.@LStrPos;
|
00612985   E8D227DFFF             call    0040515C
0061298A   85C0                   test    eax, eax
0061298C   7533                   jnz     006129C1
0061298E   FF75AC                 push    dword ptr [ebp-$54]
00612991   8B03                   mov     eax, [ebx]
00612993   8B8074080000           mov     eax, [eax+$0874]
00612999   8B10                   mov     edx, [eax]
0061299B   FF5258                 call    dword ptr [edx+$58]
0061299E   8D95B8FDFFFF           lea     edx, [ebp+$FFFFFDB8]

* Reference to : TForm1.Proc_005D3228()
|
006129A4   E87F08FCFF             call    005D3228
006129A9   FFB5B8FDFFFF           push    dword ptr [ebp+$FFFFFDB8]
006129AF   6810346100             push    $00613410
006129B4   8D45AC                 lea     eax, [ebp-$54]
006129B7   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006129BC   E81F25DFFF             call    00404EE0
006129C1   8B03                   mov     eax, [ebx]
006129C3   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
006129C9   E81ECBE9FF             call    004AF4EC
006129CE   8B03                   mov     eax, [ebx]
006129D0   8B809C000000           mov     eax, [eax+$009C]
006129D6   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
006129DD   7542                   jnz     00612A21
006129DF   8D85B4FDFFFF           lea     eax, [ebp+$FFFFFDB4]
006129E5   50                     push    eax
006129E6   8B45F0                 mov     eax, [ebp-$10]
006129E9   48                     dec     eax
006129EA   8BD0                   mov     edx, eax
006129EC   C1E203                 shl     edx, $03
006129EF   2BD0                   sub     edx, eax
006129F1   42                     inc     edx
006129F2   B906000000             mov     ecx, $00000006
006129F7   8B45B0                 mov     eax, [ebp-$50]

* Reference to: System.@LStrCopy;
|
006129FA   E87926DFFF             call    00405078
006129FF   8B85B4FDFFFF           mov     eax, [ebp+$FFFFFDB4]

* Reference to: Unit_00408494.Proc_004099B4
|
00612A05   E8AA6FDFFF             call    004099B4
00612A0A   8BF8                   mov     edi, eax
00612A0C   8B03                   mov     eax, [ebx]
00612A0E   8B8078080000           mov     eax, [eax+$0878]
00612A14   8B10                   mov     edx, [eax]
00612A16   FF5258                 call    dword ptr [edx+$58]
00612A19   3BF8                   cmp     edi, eax
00612A1B   0F8421FFFFFF           jz      00612942
00612A21   FF45F0                 inc     dword ptr [ebp-$10]
00612A24   FF4DA4                 dec     dword ptr [ebp-$5C]
00612A27   0F859EFCFFFF           jnz     006126CB
00612A2D   8D95B0FDFFFF           lea     edx, [ebp+$FFFFFDB0]
00612A33   8B45AC                 mov     eax, [ebp-$54]

* Reference to: Unit_00408494.Proc_00409448
|
00612A36   E80D6ADFFF             call    00409448
00612A3B   8B85B0FDFFFF           mov     eax, [ebp+$FFFFFDB0]

* Reference to: System.@LStrLen(String):Integer;
|
00612A41   E8DA23DFFF             call    00404E20
00612A46   85C0                   test    eax, eax
00612A48   7E2E                   jle     00612A78

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00612A4A   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00612A50   8B904C020000           mov     edx, [eax+$024C]
00612A56   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
00612A57   E874AEECFF             call    004DD8D0

* Possible String Reference to: 'Nichte(n):'
|
00612A5C   68AC346100             push    $006134AC

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00612A61   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00612A67   8B884C020000           mov     ecx, [eax+$024C]
00612A6D   49                     dec     ecx
00612A6E   BA01000000             mov     edx, $00000001

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00612A73   E884D0ECFF             call    004DFAFC

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00612A78   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00612A7E   8BB84C020000           mov     edi, [eax+$024C]
00612A84   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.DockOrientation : TDockOrientation
|
00612A86   8B809C000000           mov     eax, [eax+$009C]
00612A8C   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00612A8E   E8C900ECFF             call    004D2B5C
00612A93   8B45AC                 mov     eax, [ebp-$54]

* Reference to: System.@LStrLen(String):Integer;
|
00612A96   E88523DFFF             call    00404E20
00612A9B   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
00612AA1   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
00612AA7   D83588346100           fdiv    dword ptr [$00613488]

* Reference to: System.@ROUND;
|
00612AAD   E87E02DFFF             call    00402D30
00612AB2   85C0                   test    eax, eax
00612AB4   0F8E84020000           jle     00612D3E
00612ABA   8945A4                 mov     [ebp-$5C], eax
00612ABD   C745F001000000         mov     dword ptr [ebp-$10], $00000001
00612AC4   8D85ACFDFFFF           lea     eax, [ebp+$FFFFFDAC]
00612ACA   50                     push    eax
00612ACB   8B45F0                 mov     eax, [ebp-$10]
00612ACE   48                     dec     eax
00612ACF   8BD0                   mov     edx, eax
00612AD1   C1E203                 shl     edx, $03
00612AD4   2BD0                   sub     edx, eax
00612AD6   42                     inc     edx
00612AD7   B906000000             mov     ecx, $00000006
00612ADC   8B45AC                 mov     eax, [ebp-$54]

* Reference to: System.@LStrCopy;
|
00612ADF   E89425DFFF             call    00405078
00612AE4   8B85ACFDFFFF           mov     eax, [ebp+$FFFFFDAC]

* Reference to: Unit_00408494.Proc_004099B4
|
00612AEA   E8C56EDFFF             call    004099B4
00612AEF   89459C                 mov     [ebp-$64], eax
00612AF2   C645A000               mov     byte ptr [ebp-$60], $00
00612AF6   8D559C                 lea     edx, [ebp-$64]
00612AF9   8B03                   mov     eax, [ebx]
00612AFB   8B809C000000           mov     eax, [eax+$009C]
00612B01   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00612B03   E85C07ECFF             call    004D3264
00612B08   8D95A4FDFFFF           lea     edx, [ebp+$FFFFFDA4]
00612B0E   8B03                   mov     eax, [ebx]
00612B10   8B8088080000           mov     eax, [eax+$0888]
00612B16   8B08                   mov     ecx, [eax]
00612B18   FF5160                 call    dword ptr [ecx+$60]
00612B1B   8B85A4FDFFFF           mov     eax, [ebp+$FFFFFDA4]
00612B21   8D95A8FDFFFF           lea     edx, [ebp+$FFFFFDA8]

* Reference to: Unit_00408494.Proc_004091D8
|
00612B27   E8AC66DFFF             call    004091D8
00612B2C   8B85A8FDFFFF           mov     eax, [ebp+$FFFFFDA8]
00612B32   BA1C346100             mov     edx, $0061341C

* Reference to: System.@LStrCmp;
|
00612B37   E82824DFFF             call    00404F64
00612B3C   0F85F0010000           jnz     00612D32

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00612B42   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00612B48   8B904C020000           mov     edx, [eax+$024C]
00612B4E   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
00612B4F   E87CADECFF             call    004DD8D0
00612B54   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
00612B56   8B8074080000           mov     eax, [eax+$0874]
00612B5C   8B10                   mov     edx, [eax]
00612B5E   FF5258                 call    dword ptr [edx+$58]
00612B61   8D95A0FDFFFF           lea     edx, [ebp+$FFFFFDA0]

* Reference to: Unit_00408494.Proc_00409950
|
00612B67   E8E46DDFFF             call    00409950
00612B6C   8B85A0FDFFFF           mov     eax, [ebp+$FFFFFDA0]
00612B72   50                     push    eax
00612B73   8BCF                   mov     ecx, edi
00612B75   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00612B77   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00612B7D   E87ACFECFF             call    004DFAFC
00612B82   8D9598FDFFFF           lea     edx, [ebp+$FFFFFD98]
00612B88   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
00612B8A   8B8080080000           mov     eax, [eax+$0880]
00612B90   8B08                   mov     ecx, [eax]
00612B92   FF5160                 call    dword ptr [ecx+$60]
00612B95   FFB598FDFFFF           push    dword ptr [ebp+$FFFFFD98]
00612B9B   684C346100             push    $0061344C
00612BA0   8D9594FDFFFF           lea     edx, [ebp+$FFFFFD94]
00612BA6   8B03                   mov     eax, [ebx]
00612BA8   8B8084080000           mov     eax, [eax+$0884]
00612BAE   8B08                   mov     ecx, [eax]
00612BB0   FF5160                 call    dword ptr [ecx+$60]
00612BB3   FFB594FDFFFF           push    dword ptr [ebp+$FFFFFD94]
00612BB9   8D859CFDFFFF           lea     eax, [ebp+$FFFFFD9C]
00612BBF   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00612BC4   E81723DFFF             call    00404EE0
00612BC9   8B859CFDFFFF           mov     eax, [ebp+$FFFFFD9C]
00612BCF   50                     push    eax
00612BD0   8BCF                   mov     ecx, edi
00612BD2   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00612BD7   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00612BDD   E81ACFECFF             call    004DFAFC
00612BE2   8D958CFDFFFF           lea     edx, [ebp+$FFFFFD8C]
00612BE8   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
00612BEA   8B809C080000           mov     eax, [eax+$089C]
00612BF0   8B08                   mov     ecx, [eax]
00612BF2   FF5160                 call    dword ptr [ecx+$60]
00612BF5   8B858CFDFFFF           mov     eax, [ebp+$FFFFFD8C]
00612BFB   8D9590FDFFFF           lea     edx, [ebp+$FFFFFD90]

* Reference to: Unit_00408494.Proc_00409448
|
00612C01   E84268DFFF             call    00409448
00612C06   83BD90FDFFFF00         cmp     dword ptr [ebp+$FFFFFD90], +$00
00612C0D   7644                   jbe     00612C53
00612C0F   8D9584FDFFFF           lea     edx, [ebp+$FFFFFD84]
00612C15   8B03                   mov     eax, [ebx]
00612C17   8B809C080000           mov     eax, [eax+$089C]
00612C1D   8B08                   mov     ecx, [eax]
00612C1F   FF5160                 call    dword ptr [ecx+$60]
00612C22   8B8D84FDFFFF           mov     ecx, [ebp+$FFFFFD84]
00612C28   8D8588FDFFFF           lea     eax, [ebp+$FFFFFD88]

* Possible String Reference to: '* '
|
00612C2E   BA58346100             mov     edx, $00613458

* Reference to: System.@LStrCat3;
|
00612C33   E83422DFFF             call    00404E6C
00612C38   8B8588FDFFFF           mov     eax, [ebp+$FFFFFD88]
00612C3E   50                     push    eax
00612C3F   8BCF                   mov     ecx, edi
00612C41   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00612C46   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00612C4C   E8ABCEECFF             call    004DFAFC
00612C51   EB6F                   jmp     00612CC2
00612C53   8D957CFDFFFF           lea     edx, [ebp+$FFFFFD7C]
00612C59   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
00612C5B   8B80AC080000           mov     eax, [eax+$08AC]
00612C61   8B08                   mov     ecx, [eax]
00612C63   FF5160                 call    dword ptr [ecx+$60]
00612C66   8B857CFDFFFF           mov     eax, [ebp+$FFFFFD7C]
00612C6C   8D9580FDFFFF           lea     edx, [ebp+$FFFFFD80]

* Reference to: Unit_00408494.Proc_00409448
|
00612C72   E8D167DFFF             call    00409448
00612C77   83BD80FDFFFF00         cmp     dword ptr [ebp+$FFFFFD80], +$00
00612C7E   7642                   jbe     00612CC2
00612C80   8D9574FDFFFF           lea     edx, [ebp+$FFFFFD74]
00612C86   8B03                   mov     eax, [ebx]
00612C88   8B80AC080000           mov     eax, [eax+$08AC]
00612C8E   8B08                   mov     ecx, [eax]
00612C90   FF5160                 call    dword ptr [ecx+$60]
00612C93   8B8D74FDFFFF           mov     ecx, [ebp+$FFFFFD74]
00612C99   8D8578FDFFFF           lea     eax, [ebp+$FFFFFD78]

* Possible String Reference to: '~ '
|
00612C9F   BA64346100             mov     edx, $00613464

* Reference to: System.@LStrCat3;
|
00612CA4   E8C321DFFF             call    00404E6C
00612CA9   8B8578FDFFFF           mov     eax, [ebp+$FFFFFD78]
00612CAF   50                     push    eax
00612CB0   8BCF                   mov     ecx, edi
00612CB2   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00612CB7   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00612CBD   E83ACEECFF             call    004DFAFC
00612CC2   8D956CFDFFFF           lea     edx, [ebp+$FFFFFD6C]
00612CC8   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
00612CCA   8B80C4080000           mov     eax, [eax+$08C4]
00612CD0   8B08                   mov     ecx, [eax]
00612CD2   FF5160                 call    dword ptr [ecx+$60]
00612CD5   8B856CFDFFFF           mov     eax, [ebp+$FFFFFD6C]
00612CDB   8D9570FDFFFF           lea     edx, [ebp+$FFFFFD70]

* Reference to: Unit_00408494.Proc_00409448
|
00612CE1   E86267DFFF             call    00409448
00612CE6   83BD70FDFFFF00         cmp     dword ptr [ebp+$FFFFFD70], +$00
00612CED   7642                   jbe     00612D31
00612CEF   8D9564FDFFFF           lea     edx, [ebp+$FFFFFD64]
00612CF5   8B03                   mov     eax, [ebx]
00612CF7   8B80C4080000           mov     eax, [eax+$08C4]
00612CFD   8B08                   mov     ecx, [eax]
00612CFF   FF5160                 call    dword ptr [ecx+$60]
00612D02   8B8D64FDFFFF           mov     ecx, [ebp+$FFFFFD64]
00612D08   8D8568FDFFFF           lea     eax, [ebp+$FFFFFD68]

* Possible String Reference to: '+ '
|
00612D0E   BA70346100             mov     edx, $00613470

* Reference to: System.@LStrCat3;
|
00612D13   E85421DFFF             call    00404E6C
00612D18   8B8568FDFFFF           mov     eax, [ebp+$FFFFFD68]
00612D1E   50                     push    eax
00612D1F   8BCF                   mov     ecx, edi
00612D21   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00612D26   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00612D2C   E8CBCDECFF             call    004DFAFC
00612D31   47                     inc     edi
00612D32   FF45F0                 inc     dword ptr [ebp-$10]
00612D35   FF4DA4                 dec     dword ptr [ebp-$5C]
00612D38   0F8586FDFFFF           jnz     00612AC4
00612D3E   8D45A8                 lea     eax, [ebp-$58]

* Reference to: System.@LStrClr(void;void);
|
00612D41   E8221EDFFF             call    00404B68
00612D46   8B03                   mov     eax, [ebx]
00612D48   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
00612D4E   BAF8336100             mov     edx, $006133F8

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00612D53   E804FEEBFF             call    004D2B5C
00612D58   8B03                   mov     eax, [ebx]
00612D5A   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00612D60   E86FC4E9FF             call    004AF1D4
00612D65   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrLen(String):Integer;
|
00612D68   E8B320DFFF             call    00404E20
00612D6D   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
00612D73   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
00612D79   D83588346100           fdiv    dword ptr [$00613488]

* Reference to: System.@ROUND;
|
00612D7F   E8ACFFDEFF             call    00402D30
00612D84   85C0                   test    eax, eax
00612D86   0F8E62010000           jle     00612EEE
00612D8C   8945A4                 mov     [ebp-$5C], eax
00612D8F   C745F001000000         mov     dword ptr [ebp-$10], $00000001
00612D96   8D8560FDFFFF           lea     eax, [ebp+$FFFFFD60]
00612D9C   50                     push    eax
00612D9D   8B45F0                 mov     eax, [ebp-$10]
00612DA0   48                     dec     eax
00612DA1   8BD0                   mov     edx, eax
00612DA3   C1E203                 shl     edx, $03
00612DA6   2BD0                   sub     edx, eax
00612DA8   42                     inc     edx
00612DA9   B906000000             mov     ecx, $00000006
00612DAE   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrCopy;
|
00612DB1   E8C222DFFF             call    00405078
00612DB6   8B8560FDFFFF           mov     eax, [ebp+$FFFFFD60]

* Reference to: Unit_00408494.Proc_004099B4
|
00612DBC   E8F36BDFFF             call    004099B4
00612DC1   89459C                 mov     [ebp-$64], eax
00612DC4   C645A000               mov     byte ptr [ebp-$60], $00
00612DC8   8D559C                 lea     edx, [ebp-$64]
00612DCB   8B03                   mov     eax, [ebx]
00612DCD   8B809C000000           mov     eax, [eax+$009C]
00612DD3   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00612DD5   E88A04ECFF             call    004D3264
00612DDA   E9C1000000             jmp     00612EA0
00612DDF   8D9558FDFFFF           lea     edx, [ebp+$FFFFFD58]
00612DE5   8B03                   mov     eax, [ebx]
00612DE7   8B8088080000           mov     eax, [eax+$0888]
00612DED   8B08                   mov     ecx, [eax]
00612DEF   FF5160                 call    dword ptr [ecx+$60]
00612DF2   8B8558FDFFFF           mov     eax, [ebp+$FFFFFD58]
00612DF8   8D955CFDFFFF           lea     edx, [ebp+$FFFFFD5C]

* Reference to: Unit_00408494.Proc_004091D8
|
00612DFE   E8D563DFFF             call    004091D8
00612E03   8B855CFDFFFF           mov     eax, [ebp+$FFFFFD5C]
00612E09   BA1C346100             mov     edx, $0061341C

* Reference to: System.@LStrCmp;
|
00612E0E   E85121DFFF             call    00404F64
00612E13   756D                   jnz     00612E82
00612E15   8B03                   mov     eax, [ebx]
00612E17   8B8074080000           mov     eax, [eax+$0874]
00612E1D   8B10                   mov     edx, [eax]
00612E1F   FF5258                 call    dword ptr [edx+$58]
00612E22   8D9554FDFFFF           lea     edx, [ebp+$FFFFFD54]

* Reference to : TForm1.Proc_005D3228()
|
00612E28   E8FB03FCFF             call    005D3228
00612E2D   8D8554FDFFFF           lea     eax, [ebp+$FFFFFD54]
00612E33   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
00612E38   E8EB1FDFFF             call    00404E28
00612E3D   8B8554FDFFFF           mov     eax, [ebp+$FFFFFD54]
00612E43   8B55A8                 mov     edx, [ebp-$58]

* Reference to: System.@LStrPos;
|
00612E46   E81123DFFF             call    0040515C
00612E4B   85C0                   test    eax, eax
00612E4D   7533                   jnz     00612E82
00612E4F   FF75A8                 push    dword ptr [ebp-$58]
00612E52   8B03                   mov     eax, [ebx]
00612E54   8B8074080000           mov     eax, [eax+$0874]
00612E5A   8B10                   mov     edx, [eax]
00612E5C   FF5258                 call    dword ptr [edx+$58]
00612E5F   8D9550FDFFFF           lea     edx, [ebp+$FFFFFD50]

* Reference to : TForm1.Proc_005D3228()
|
00612E65   E8BE03FCFF             call    005D3228
00612E6A   FFB550FDFFFF           push    dword ptr [ebp+$FFFFFD50]
00612E70   6810346100             push    $00613410
00612E75   8D45A8                 lea     eax, [ebp-$58]
00612E78   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00612E7D   E85E20DFFF             call    00404EE0
00612E82   8B03                   mov     eax, [ebx]
00612E84   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00612E8A   E85DC6E9FF             call    004AF4EC
00612E8F   8B03                   mov     eax, [ebx]
00612E91   8B809C000000           mov     eax, [eax+$009C]
00612E97   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00612E9E   7542                   jnz     00612EE2
00612EA0   8D854CFDFFFF           lea     eax, [ebp+$FFFFFD4C]
00612EA6   50                     push    eax
00612EA7   8B45F0                 mov     eax, [ebp-$10]
00612EAA   48                     dec     eax
00612EAB   8BD0                   mov     edx, eax
00612EAD   C1E203                 shl     edx, $03
00612EB0   2BD0                   sub     edx, eax
00612EB2   42                     inc     edx
00612EB3   B906000000             mov     ecx, $00000006
00612EB8   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrCopy;
|
00612EBB   E8B821DFFF             call    00405078
00612EC0   8B854CFDFFFF           mov     eax, [ebp+$FFFFFD4C]

* Reference to: Unit_00408494.Proc_004099B4
|
00612EC6   E8E96ADFFF             call    004099B4
00612ECB   8BF8                   mov     edi, eax
00612ECD   8B03                   mov     eax, [ebx]
00612ECF   8B8078080000           mov     eax, [eax+$0878]
00612ED5   8B10                   mov     edx, [eax]
00612ED7   FF5258                 call    dword ptr [edx+$58]
00612EDA   3BF8                   cmp     edi, eax
00612EDC   0F84FDFEFFFF           jz      00612DDF
00612EE2   FF45F0                 inc     dword ptr [ebp-$10]
00612EE5   FF4DA4                 dec     dword ptr [ebp-$5C]
00612EE8   0F85A8FEFFFF           jnz     00612D96
00612EEE   8B03                   mov     eax, [ebx]
00612EF0   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
00612EF6   BA28346100             mov     edx, $00613428

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00612EFB   E85CFCEBFF             call    004D2B5C
00612F00   8B03                   mov     eax, [ebx]
00612F02   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00612F08   E8C7C2E9FF             call    004AF1D4
00612F0D   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrLen(String):Integer;
|
00612F10   E80B1FDFFF             call    00404E20
00612F15   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
00612F1B   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
00612F21   D83588346100           fdiv    dword ptr [$00613488]

* Reference to: System.@ROUND;
|
00612F27   E804FEDEFF             call    00402D30
00612F2C   85C0                   test    eax, eax
00612F2E   0F8E62010000           jle     00613096
00612F34   8945A4                 mov     [ebp-$5C], eax
00612F37   C745F001000000         mov     dword ptr [ebp-$10], $00000001
00612F3E   8D8548FDFFFF           lea     eax, [ebp+$FFFFFD48]
00612F44   50                     push    eax
00612F45   8B45F0                 mov     eax, [ebp-$10]
00612F48   48                     dec     eax
00612F49   8BD0                   mov     edx, eax
00612F4B   C1E203                 shl     edx, $03
00612F4E   2BD0                   sub     edx, eax
00612F50   42                     inc     edx
00612F51   B906000000             mov     ecx, $00000006
00612F56   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrCopy;
|
00612F59   E81A21DFFF             call    00405078
00612F5E   8B8548FDFFFF           mov     eax, [ebp+$FFFFFD48]

* Reference to: Unit_00408494.Proc_004099B4
|
00612F64   E84B6ADFFF             call    004099B4
00612F69   89459C                 mov     [ebp-$64], eax
00612F6C   C645A000               mov     byte ptr [ebp-$60], $00
00612F70   8D559C                 lea     edx, [ebp-$64]
00612F73   8B03                   mov     eax, [ebx]
00612F75   8B809C000000           mov     eax, [eax+$009C]
00612F7B   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00612F7D   E8E202ECFF             call    004D3264
00612F82   E9C1000000             jmp     00613048
00612F87   8D9540FDFFFF           lea     edx, [ebp+$FFFFFD40]
00612F8D   8B03                   mov     eax, [ebx]
00612F8F   8B8088080000           mov     eax, [eax+$0888]
00612F95   8B08                   mov     ecx, [eax]
00612F97   FF5160                 call    dword ptr [ecx+$60]
00612F9A   8B8540FDFFFF           mov     eax, [ebp+$FFFFFD40]
00612FA0   8D9544FDFFFF           lea     edx, [ebp+$FFFFFD44]

* Reference to: Unit_00408494.Proc_004091D8
|
00612FA6   E82D62DFFF             call    004091D8
00612FAB   8B8544FDFFFF           mov     eax, [ebp+$FFFFFD44]
00612FB1   BA1C346100             mov     edx, $0061341C

* Reference to: System.@LStrCmp;
|
00612FB6   E8A91FDFFF             call    00404F64
00612FBB   756D                   jnz     0061302A
00612FBD   8B03                   mov     eax, [ebx]
00612FBF   8B8074080000           mov     eax, [eax+$0874]
00612FC5   8B10                   mov     edx, [eax]
00612FC7   FF5258                 call    dword ptr [edx+$58]
00612FCA   8D953CFDFFFF           lea     edx, [ebp+$FFFFFD3C]

* Reference to : TForm1.Proc_005D3228()
|
00612FD0   E85302FCFF             call    005D3228
00612FD5   8D853CFDFFFF           lea     eax, [ebp+$FFFFFD3C]
00612FDB   BA10346100             mov     edx, $00613410

* Reference to: System.@LStrCat;
|
00612FE0   E8431EDFFF             call    00404E28
00612FE5   8B853CFDFFFF           mov     eax, [ebp+$FFFFFD3C]
00612FEB   8B55A8                 mov     edx, [ebp-$58]

* Reference to: System.@LStrPos;
|
00612FEE   E86921DFFF             call    0040515C
00612FF3   85C0                   test    eax, eax
00612FF5   7533                   jnz     0061302A
00612FF7   FF75A8                 push    dword ptr [ebp-$58]
00612FFA   8B03                   mov     eax, [ebx]
00612FFC   8B8074080000           mov     eax, [eax+$0874]
00613002   8B10                   mov     edx, [eax]
00613004   FF5258                 call    dword ptr [edx+$58]
00613007   8D9538FDFFFF           lea     edx, [ebp+$FFFFFD38]

* Reference to : TForm1.Proc_005D3228()
|
0061300D   E81602FCFF             call    005D3228
00613012   FFB538FDFFFF           push    dword ptr [ebp+$FFFFFD38]
00613018   6810346100             push    $00613410
0061301D   8D45A8                 lea     eax, [ebp-$58]
00613020   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00613025   E8B61EDFFF             call    00404EE0
0061302A   8B03                   mov     eax, [ebx]
0061302C   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00613032   E8B5C4E9FF             call    004AF4EC
00613037   8B03                   mov     eax, [ebx]
00613039   8B809C000000           mov     eax, [eax+$009C]
0061303F   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00613046   7542                   jnz     0061308A
00613048   8D8534FDFFFF           lea     eax, [ebp+$FFFFFD34]
0061304E   50                     push    eax
0061304F   8B45F0                 mov     eax, [ebp-$10]
00613052   48                     dec     eax
00613053   8BD0                   mov     edx, eax
00613055   C1E203                 shl     edx, $03
00613058   2BD0                   sub     edx, eax
0061305A   42                     inc     edx
0061305B   B906000000             mov     ecx, $00000006
00613060   8B45C0                 mov     eax, [ebp-$40]

* Reference to: System.@LStrCopy;
|
00613063   E81020DFFF             call    00405078
00613068   8B8534FDFFFF           mov     eax, [ebp+$FFFFFD34]

* Reference to: Unit_00408494.Proc_004099B4
|
0061306E   E84169DFFF             call    004099B4
00613073   8BF8                   mov     edi, eax
00613075   8B03                   mov     eax, [ebx]
00613077   8B807C080000           mov     eax, [eax+$087C]
0061307D   8B10                   mov     edx, [eax]
0061307F   FF5258                 call    dword ptr [edx+$58]
00613082   3BF8                   cmp     edi, eax
00613084   0F84FDFEFFFF           jz      00612F87
0061308A   FF45F0                 inc     dword ptr [ebp-$10]
0061308D   FF4DA4                 dec     dword ptr [ebp-$5C]
00613090   0F85A8FEFFFF           jnz     00612F3E
00613096   8D9530FDFFFF           lea     edx, [ebp+$FFFFFD30]
0061309C   8B45A8                 mov     eax, [ebp-$58]

* Reference to: Unit_00408494.Proc_00409448
|
0061309F   E8A463DFFF             call    00409448
006130A4   8B8530FDFFFF           mov     eax, [ebp+$FFFFFD30]

* Reference to: System.@LStrLen(String):Integer;
|
006130AA   E8711DDFFF             call    00404E20
006130AF   85C0                   test    eax, eax
006130B1   7E3A                   jle     006130ED

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006130B3   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
006130B9   8B904C020000           mov     edx, [eax+$024C]
006130BF   42                     inc     edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006130C0   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
006130C6   E805A8ECFF             call    004DD8D0

* Possible String Reference to: 'Cousine(n):'
|
006130CB   68C0346100             push    $006134C0

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006130D0   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
006130D6   8B884C020000           mov     ecx, [eax+$024C]
006130DC   49                     dec     ecx
006130DD   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006130E2   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006130E8   E80FCAECFF             call    004DFAFC

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006130ED   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
006130F3   8BB84C020000           mov     edi, [eax+$024C]
006130F9   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.DockOrientation : TDockOrientation
|
006130FB   8B809C000000           mov     eax, [eax+$009C]
00613101   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00613103   E854FAEBFF             call    004D2B5C
00613108   8B45A8                 mov     eax, [ebp-$58]

* Reference to: System.@LStrLen(String):Integer;
|
0061310B   E8101DDFFF             call    00404E20
00613110   8985E0FEFFFF           mov     [ebp+$FFFFFEE0], eax
00613116   DB85E0FEFFFF           fild    dword ptr [ebp+$FFFFFEE0]
0061311C   D83588346100           fdiv    dword ptr [$00613488]

* Reference to: System.@ROUND;
|
00613122   E809FCDEFF             call    00402D30
00613127   85C0                   test    eax, eax
00613129   0F8E4A020000           jle     00613379
0061312F   8945A4                 mov     [ebp-$5C], eax
00613132   C745F001000000         mov     dword ptr [ebp-$10], $00000001
00613139   8D852CFDFFFF           lea     eax, [ebp+$FFFFFD2C]
0061313F   50                     push    eax
00613140   8B45F0                 mov     eax, [ebp-$10]
00613143   48                     dec     eax
00613144   8BD0                   mov     edx, eax
00613146   C1E203                 shl     edx, $03
00613149   2BD0                   sub     edx, eax
0061314B   42                     inc     edx
0061314C   B906000000             mov     ecx, $00000006
00613151   8B45A8                 mov     eax, [ebp-$58]

* Reference to: System.@LStrCopy;
|
00613154   E81F1FDFFF             call    00405078
00613159   8B852CFDFFFF           mov     eax, [ebp+$FFFFFD2C]

* Reference to: Unit_00408494.Proc_004099B4
|
0061315F   E85068DFFF             call    004099B4
00613164   89459C                 mov     [ebp-$64], eax
00613167   C645A000               mov     byte ptr [ebp-$60], $00
0061316B   8D559C                 lea     edx, [ebp-$64]
0061316E   8B03                   mov     eax, [ebx]
00613170   8B809C000000           mov     eax, [eax+$009C]
00613176   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00613178   E8E700ECFF             call    004D3264

* Reference to control TForm1.StringGrid5 : TStringGrid
|
0061317D   8B8674060000           mov     eax, [esi+$0674]

* Reference to field TStringGrid.RowCount : Longint
|
00613183   8B904C020000           mov     edx, [eax+$024C]
00613189   42                     inc     edx

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
0061318A   E841A7ECFF             call    004DD8D0
0061318F   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0874
|
00613191   8B8074080000           mov     eax, [eax+$0874]
00613197   8B10                   mov     edx, [eax]
00613199   FF5258                 call    dword ptr [edx+$58]
0061319C   8D9528FDFFFF           lea     edx, [ebp+$FFFFFD28]

* Reference to: Unit_00408494.Proc_00409950
|
006131A2   E8A967DFFF             call    00409950
006131A7   8B8528FDFFFF           mov     eax, [ebp+$FFFFFD28]
006131AD   50                     push    eax
006131AE   8BCF                   mov     ecx, edi
006131B0   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006131B2   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006131B8   E83FC9ECFF             call    004DFAFC
006131BD   8D9520FDFFFF           lea     edx, [ebp+$FFFFFD20]
006131C3   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_0880
|
006131C5   8B8080080000           mov     eax, [eax+$0880]
006131CB   8B08                   mov     ecx, [eax]
006131CD   FF5160                 call    dword ptr [ecx+$60]
006131D0   FFB520FDFFFF           push    dword ptr [ebp+$FFFFFD20]
006131D6   684C346100             push    $0061344C
006131DB   8D951CFDFFFF           lea     edx, [ebp+$FFFFFD1C]
006131E1   8B03                   mov     eax, [ebx]
006131E3   8B8084080000           mov     eax, [eax+$0884]
006131E9   8B08                   mov     ecx, [eax]
006131EB   FF5160                 call    dword ptr [ecx+$60]
006131EE   FFB51CFDFFFF           push    dword ptr [ebp+$FFFFFD1C]
006131F4   8D8524FDFFFF           lea     eax, [ebp+$FFFFFD24]
006131FA   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006131FF   E8DC1CDFFF             call    00404EE0
00613204   8B8524FDFFFF           mov     eax, [ebp+$FFFFFD24]
0061320A   50                     push    eax
0061320B   8BCF                   mov     ecx, edi
0061320D   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00613212   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00613218   E8DFC8ECFF             call    004DFAFC
0061321D   8D9514FDFFFF           lea     edx, [ebp+$FFFFFD14]
00613223   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_089C
|
00613225   8B809C080000           mov     eax, [eax+$089C]
0061322B   8B08                   mov     ecx, [eax]
0061322D   FF5160                 call    dword ptr [ecx+$60]
00613230   8B8514FDFFFF           mov     eax, [ebp+$FFFFFD14]
00613236   8D9518FDFFFF           lea     edx, [ebp+$FFFFFD18]

* Reference to: Unit_00408494.Proc_00409448
|
0061323C   E80762DFFF             call    00409448
00613241   83BD18FDFFFF00         cmp     dword ptr [ebp+$FFFFFD18], +$00
00613248   7644                   jbe     0061328E
0061324A   8D950CFDFFFF           lea     edx, [ebp+$FFFFFD0C]
00613250   8B03                   mov     eax, [ebx]
00613252   8B809C080000           mov     eax, [eax+$089C]
00613258   8B08                   mov     ecx, [eax]
0061325A   FF5160                 call    dword ptr [ecx+$60]
0061325D   8B8D0CFDFFFF           mov     ecx, [ebp+$FFFFFD0C]
00613263   8D8510FDFFFF           lea     eax, [ebp+$FFFFFD10]

* Possible String Reference to: '* '
|
00613269   BA58346100             mov     edx, $00613458

* Reference to: System.@LStrCat3;
|
0061326E   E8F91BDFFF             call    00404E6C
00613273   8B8510FDFFFF           mov     eax, [ebp+$FFFFFD10]
00613279   50                     push    eax
0061327A   8BCF                   mov     ecx, edi
0061327C   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00613281   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00613287   E870C8ECFF             call    004DFAFC
0061328C   EB6F                   jmp     006132FD
0061328E   8D9504FDFFFF           lea     edx, [ebp+$FFFFFD04]
00613294   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08AC
|
00613296   8B80AC080000           mov     eax, [eax+$08AC]
0061329C   8B08                   mov     ecx, [eax]
0061329E   FF5160                 call    dword ptr [ecx+$60]
006132A1   8B8504FDFFFF           mov     eax, [ebp+$FFFFFD04]
006132A7   8D9508FDFFFF           lea     edx, [ebp+$FFFFFD08]

* Reference to: Unit_00408494.Proc_00409448
|
006132AD   E89661DFFF             call    00409448
006132B2   83BD08FDFFFF00         cmp     dword ptr [ebp+$FFFFFD08], +$00
006132B9   7642                   jbe     006132FD
006132BB   8D95FCFCFFFF           lea     edx, [ebp+$FFFFFCFC]
006132C1   8B03                   mov     eax, [ebx]
006132C3   8B80AC080000           mov     eax, [eax+$08AC]
006132C9   8B08                   mov     ecx, [eax]
006132CB   FF5160                 call    dword ptr [ecx+$60]
006132CE   8B8DFCFCFFFF           mov     ecx, [ebp+$FFFFFCFC]
006132D4   8D8500FDFFFF           lea     eax, [ebp+$FFFFFD00]

* Possible String Reference to: '~ '
|
006132DA   BA64346100             mov     edx, $00613464

* Reference to: System.@LStrCat3;
|
006132DF   E8881BDFFF             call    00404E6C
006132E4   8B8500FDFFFF           mov     eax, [ebp+$FFFFFD00]
006132EA   50                     push    eax
006132EB   8BCF                   mov     ecx, edi
006132ED   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006132F2   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
006132F8   E8FFC7ECFF             call    004DFAFC
006132FD   8D95F4FCFFFF           lea     edx, [ebp+$FFFFFCF4]
00613303   8B03                   mov     eax, [ebx]

* Reference to field TStringGrid.OFFS_08C4
|
00613305   8B80C4080000           mov     eax, [eax+$08C4]
0061330B   8B08                   mov     ecx, [eax]
0061330D   FF5160                 call    dword ptr [ecx+$60]
00613310   8B85F4FCFFFF           mov     eax, [ebp+$FFFFFCF4]
00613316   8D95F8FCFFFF           lea     edx, [ebp+$FFFFFCF8]

* Reference to: Unit_00408494.Proc_00409448
|
0061331C   E82761DFFF             call    00409448
00613321   83BDF8FCFFFF00         cmp     dword ptr [ebp+$FFFFFCF8], +$00
00613328   7642                   jbe     0061336C
0061332A   8D95ECFCFFFF           lea     edx, [ebp+$FFFFFCEC]
00613330   8B03                   mov     eax, [ebx]
00613332   8B80C4080000           mov     eax, [eax+$08C4]
00613338   8B08                   mov     ecx, [eax]
0061333A   FF5160                 call    dword ptr [ecx+$60]
0061333D   8B8DECFCFFFF           mov     ecx, [ebp+$FFFFFCEC]
00613343   8D85F0FCFFFF           lea     eax, [ebp+$FFFFFCF0]

* Possible String Reference to: '+ '
|
00613349   BA70346100             mov     edx, $00613470

* Reference to: System.@LStrCat3;
|
0061334E   E8191BDFFF             call    00404E6C
00613353   8B85F0FCFFFF           mov     eax, [ebp+$FFFFFCF0]
00613359   50                     push    eax
0061335A   8BCF                   mov     ecx, edi
0061335C   BA03000000             mov     edx, $00000003

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00613361   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00613367   E890C7ECFF             call    004DFAFC
0061336C   47                     inc     edi
0061336D   FF45F0                 inc     dword ptr [ebp-$10]
00613370   FF4DA4                 dec     dword ptr [ebp-$5C]
00613373   0F85C0FDFFFF           jnz     00613139
00613379   33C0                   xor     eax, eax
0061337B   5A                     pop     edx
0061337C   59                     pop     ecx
0061337D   59                     pop     ecx
0061337E   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
00613381   68E6336100             push    $006133E6
00613386   8D85ECFCFFFF           lea     eax, [ebp+$FFFFFCEC]
0061338C   BA63000000             mov     edx, $00000063

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
00613391   E8F617DFFF             call    00404B8C
00613396   8D8580FEFFFF           lea     eax, [ebp+$FFFFFE80]

* Reference to: System.@LStrClr(void;void);
|
0061339C   E8C717DFFF             call    00404B68
006133A1   8D8578FEFFFF           lea     eax, [ebp+$FFFFFE78]
006133A7   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
006133AC   E8DB17DFFF             call    00404B8C
006133B1   8D8584FEFFFF           lea     eax, [ebp+$FFFFFE84]
006133B7   BA17000000             mov     edx, $00000017

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
006133BC   E8CB17DFFF             call    00404B8C
006133C1   8D85E4FEFFFF           lea     eax, [ebp+$FFFFFEE4]
006133C7   BA2E000000             mov     edx, $0000002E

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
006133CC   E8BB17DFFF             call    00404B8C
006133D1   8D45A8                 lea     eax, [ebp-$58]
006133D4   BA08000000             mov     edx, $00000008

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
006133D9   E8AE17DFFF             call    00404B8C
006133DE   C3                     ret


* Reference to: System.@HandleFinally;
|
006133DF   E9E810DFFF             jmp     004044CC
006133E4   EBA0                   jmp     00613386

****** END
|
006133E6   5F                     pop     edi
006133E7   5E                     pop     esi
006133E8   5B                     pop     ebx
006133E9   8BE5                   mov     esp, ebp
006133EB   5D                     pop     ebp
006133EC   C3                     ret

*)
end;

