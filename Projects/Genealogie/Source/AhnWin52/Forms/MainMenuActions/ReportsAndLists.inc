{ TForm1 menu-area implementations: ReportsAndLists; LFM-bound method names remain on TForm1. }

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Label1 (TLabel); TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl);
    TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.Append(TDataSet);; DB.TDataSet.Close(TDataSet);;
    DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);; DB.TDataSet.Open(TDataSet);;
    DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.EmptyTable(TTable);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_0061DF10; GlobalVar_0061DF9C; GlobalVar_0061E0B4
Unresolved field offsets: OFFS_005C; OFFS_0098; OFFS_00A4; OFFS_00E0; OFFS_01E8; OFFS_02BC;
    OFFS_0360; OFFS_07B0
Project calls: TForm1.druck(); TForm1.speich1(); Unit_00408494.Proc_00409448
Framework/API calls: class TStringList; Classes.TStringList.SetSorted(TStringList;Boolean);;
    ComCtrls.TPageControl.GetPageCount(TPageControl):Integer;;
    ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.GetText(TControl):TCaption;; Controls.TControl.Refresh(TControl);;
    Controls.TControl.SetText(TControl;TCaption);;
    Dialogs.InputQuery(AnsiString;AnsiString;AnsiString;AnsiString):Boolean;;
    Dialogs.ShowMessage(AnsiString);; Forms.TScreen.SetCursor(TScreen;TCursor);; method
    TMenuItem.Click(); method TStringList.Add(string); method TStringList.Delete(Integer); method
    TStringList.Get(Integer); method TStringList.GetCount();
    QuickRpt.TCustomQuickRep.Preview(TCustomQuickRep);;
    QuickRpt.TQRPage.SetColumns(TQRPage;Integer);; System.Proc_00404EE0;
    System.TObject.Create(TObject;Boolean);; System.TObject.Free(TObject);; TScreen instance
Strings/files/dialog text: ' gefunden.'; '_^[��]�'; 'A 4'; 'Keine Daten verf�gbar.'; 'Keine Namen
    f�r "'; 'Namensliste (alle Personen)'; 'Namensliste f�r den Ort'; 'namgeb'; 'NLAP'; 'NLBO';
    'num'; '��F���_^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.frbestimmtenOrt1Click(Sender : TObject);
begin
(*
005EF73C   55                     push    ebp
005EF73D   8BEC                   mov     ebp, esp
005EF73F   B910000000             mov     ecx, $00000010
005EF744   6A00                   push    $00
005EF746   6A00                   push    $00
005EF748   49                     dec     ecx
005EF749   75F9                   jnz     005EF744
005EF74B   51                     push    ecx
005EF74C   53                     push    ebx
005EF74D   56                     push    esi
005EF74E   57                     push    edi
005EF74F   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005EF751   8B1D3CCC6100           mov     ebx, [$0061CC3C]
005EF757   33C0                   xor     eax, eax
005EF759   55                     push    ebp

* Possible String Reference to: '��F���_^[��]�'
|
005EF75A   6805FE5E00             push    $005EFE05

***** TRY
|
005EF75F   64FF30                 push    dword ptr fs:[eax]
005EF762   648920                 mov     fs:[eax], esp
005EF765   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'NLAP'
|
005EF76A   BA1CFE5E00             mov     edx, $005EFE1C

* Reference to: System.@LStrCmp;
|
005EF76F   E8F057E1FF             call    00404F64
005EF774   740F                   jz      005EF785
005EF776   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'NLBO'
|
005EF77B   BA2CFE5E00             mov     edx, $005EFE2C

* Reference to: System.@LStrAsg(void;void;void;void);
|
005EF780   E83754E1FF             call    00404BBC
005EF785   8BC6                   mov     eax, esi

* Reference to : TForm1.speich1()
|
005EF787   E81082FEFF             call    005D799C

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EF78C   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EF792   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EF798   E81B06E9FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005EF79D   8B861C060000           mov     eax, [esi+$061C]
005EF7A3   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005EF7A5   FF5244                 call    dword ptr [edx+$44]
005EF7A8   8B03                   mov     eax, [ebx]

* Reference to field TMenuItem.OFFS_005C
|
005EF7AA   8B405C                 mov     eax, [eax+$5C]
005EF7AD   8B10                   mov     edx, [eax]
005EF7AF   FF924C010000           call    dword ptr [edx+$014C]
005EF7B5   48                     dec     eax
005EF7B6   7F0F                   jnle    005EF7C7

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005EF7B8   B83CFE5E00             mov     eax, $005EFE3C

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005EF7BD   E82260E5FF             call    004457E4
005EF7C2   E9F6050000             jmp     005EFDBD
005EF7C7   8D45F8                 lea     eax, [ebp-$08]

* Reference to: System.@LStrClr(void;void);
|
005EF7CA   E89953E1FF             call    00404B68
005EF7CF   8D45F4                 lea     eax, [ebp-$0C]

* Reference to: System.@LStrClr(void;void);
|
005EF7D2   E89153E1FF             call    00404B68
005EF7D7   8D55DC                 lea     edx, [ebp-$24]
005EF7DA   8B03                   mov     eax, [ebx]
005EF7DC   8B80D0070000           mov     eax, [eax+$07D0]
005EF7E2   8B08                   mov     ecx, [eax]
005EF7E4   FF5160                 call    dword ptr [ecx+$60]
005EF7E7   8B55DC                 mov     edx, [ebp-$24]
005EF7EA   8B45F8                 mov     eax, [ebp-$08]

* Reference to: System.@LStrPos;
|
005EF7ED   E86A59E1FF             call    0040515C
005EF7F2   85C0                   test    eax, eax
005EF7F4   0F8F80000000           jnle    005EF87A
005EF7FA   8D55D8                 lea     edx, [ebp-$28]
005EF7FD   8B03                   mov     eax, [ebx]
005EF7FF   8B80E0070000           mov     eax, [eax+$07E0]
005EF805   8B08                   mov     ecx, [eax]
005EF807   FF5160                 call    dword ptr [ecx+$60]
005EF80A   8B55D8                 mov     edx, [ebp-$28]
005EF80D   8B45F8                 mov     eax, [ebp-$08]

* Reference to: System.@LStrPos;
|
005EF810   E84759E1FF             call    0040515C
005EF815   85C0                   test    eax, eax
005EF817   7F61                   jnle    005EF87A
005EF819   8D55D4                 lea     edx, [ebp-$2C]
005EF81C   8B03                   mov     eax, [ebx]
005EF81E   8B80F8070000           mov     eax, [eax+$07F8]
005EF824   8B08                   mov     ecx, [eax]
005EF826   FF5160                 call    dword ptr [ecx+$60]
005EF829   8B55D4                 mov     edx, [ebp-$2C]
005EF82C   8B45F8                 mov     eax, [ebp-$08]

* Reference to: System.@LStrPos;
|
005EF82F   E82859E1FF             call    0040515C
005EF834   85C0                   test    eax, eax
005EF836   7F42                   jnle    005EF87A
005EF838   8D55D0                 lea     edx, [ebp-$30]
005EF83B   8B03                   mov     eax, [ebx]
005EF83D   8B800C080000           mov     eax, [eax+$080C]
005EF843   8B08                   mov     ecx, [eax]
005EF845   FF5160                 call    dword ptr [ecx+$60]
005EF848   8B55D0                 mov     edx, [ebp-$30]
005EF84B   8B45F8                 mov     eax, [ebp-$08]

* Reference to: System.@LStrPos;
|
005EF84E   E80959E1FF             call    0040515C
005EF853   85C0                   test    eax, eax
005EF855   7F23                   jnle    005EF87A
005EF857   8D55CC                 lea     edx, [ebp-$34]
005EF85A   8B03                   mov     eax, [ebx]
005EF85C   8B80E8070000           mov     eax, [eax+$07E8]
005EF862   8B08                   mov     ecx, [eax]
005EF864   FF5160                 call    dword ptr [ecx+$60]
005EF867   8B55CC                 mov     edx, [ebp-$34]
005EF86A   8B45F8                 mov     eax, [ebp-$08]

* Reference to: System.@LStrPos;
|
005EF86D   E8EA58E1FF             call    0040515C
005EF872   85C0                   test    eax, eax
005EF874   7F04                   jnle    005EF87A
005EF876   33C0                   xor     eax, eax
005EF878   EB02                   jmp     005EF87C
005EF87A   B001                   mov     al, $01
005EF87C   8D45EC                 lea     eax, [ebp-$14]

* Possible String Reference to: 'Namensliste f�r den Ort'
|
005EF87F   BA5CFE5E00             mov     edx, $005EFE5C

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005EF884   E87753E1FF             call    00404C00
005EF889   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'NLAP'
|
005EF88E   BA1CFE5E00             mov     edx, $005EFE1C

* Reference to: System.@LStrCmp;
|
005EF893   E8CC56E1FF             call    00404F64
005EF898   7528                   jnz     005EF8C2
005EF89A   8D45F8                 lea     eax, [ebp-$08]

* Reference to: System.@LStrClr(void;void);
|
005EF89D   E8C652E1FF             call    00404B68
005EF8A2   8D45EC                 lea     eax, [ebp-$14]

* Possible String Reference to: 'Namensliste (alle Personen)'
|
005EF8A5   BA7CFE5E00             mov     edx, $005EFE7C

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005EF8AA   E85153E1FF             call    00404C00

* Reference to pointer to GlobalVar_0061DF9C
|
005EF8AF   A168CA6100             mov     eax, dword ptr [$0061CA68]
005EF8B4   8B00                   mov     eax, [eax]
005EF8B6   8B55EC                 mov     edx, [ebp-$14]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EF8B9   E876D1E5FF             call    0044CA34
005EF8BE   C645E701               mov     byte ptr [ebp-$19], $01
005EF8C2   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'NLAP'
|
005EF8C7   BA1CFE5E00             mov     edx, $005EFE1C

* Reference to: System.@LStrCmp;
|
005EF8CC   E89356E1FF             call    00404F64
005EF8D1   7410                   jz      005EF8E3
005EF8D3   8D4DF8                 lea     ecx, [ebp-$08]
005EF8D6   33D2                   xor     edx, edx
005EF8D8   8B45EC                 mov     eax, [ebp-$14]

* Reference to: Dialogs.InputQuery(AnsiString;AnsiString;AnsiString;AnsiString):Boolean;
|
005EF8DB   E8285FE5FF             call    00445808
005EF8E0   8845E7                 mov     [ebp-$19], al
005EF8E3   807DE700               cmp     byte ptr [ebp-$19], $00
005EF8E7   0F84D0040000           jz      005EFDBD
005EF8ED   8D45F4                 lea     eax, [ebp-$0C]
005EF8F0   8B55F8                 mov     edx, [ebp-$08]

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005EF8F3   E80853E1FF             call    00404C00

* Reference to Form1
|
005EF8F8   A108595302             mov     eax, dword ptr [$02535908]

* Reference to: Controls.TControl.Refresh(TControl);
|
005EF8FD   E886D6E5FF             call    0044CF88

* Reference to control TForm1.PageControl1 : TPageControl
|
005EF902   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.GetPageCount(TPageControl):Integer;
|
005EF908   E80F03E9FF             call    0047FC1C
005EF90D   83F802                 cmp     eax, +$02
005EF910   7411                   jz      005EF923

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EF912   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EF918   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EF91E   E89504E9FF             call    0047FDB8
005EF923   FF75EC                 push    dword ptr [ebp-$14]
005EF926   68A0FE5E00             push    $005EFEA0
005EF92B   FF75F8                 push    dword ptr [ebp-$08]
005EF92E   B830595302             mov     eax, $02535930
005EF933   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005EF938   E8A355E1FF             call    00404EE0
005EF93D   8D45F0                 lea     eax, [ebp-$10]

* Reference to: System.@LStrClr(void;void);
|
005EF940   E82352E1FF             call    00404B68
005EF945   B201                   mov     dl, $01

* Reference to class TStringList
|
005EF947   A1D8794100             mov     eax, dword ptr [$004179D8]

* Reference to: System.TObject.Create(TObject;Boolean);
|
005EF94C   E8B743E1FF             call    00403D08
005EF951   8945FC                 mov     [ebp-$04], eax
005EF954   B201                   mov     dl, $01
005EF956   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Classes.TStringList.SetSorted(TStringList;Boolean);
|
005EF959   E8F6CEE2FF             call    0041C854
005EF95E   8B45FC                 mov     eax, [ebp-$04]

* Reference to field TStringList.Duplicates : TDuplicates
|
005EF961   C6401D00               mov     byte ptr [eax+$1D], $00
005EF965   8B03                   mov     eax, [ebx]

* Reference to field TStringList.OFFS_0098
|
005EF967   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EF96D   E816D3EBFF             call    004ACC88
005EF972   8B03                   mov     eax, [ebx]
005EF974   8B8098000000           mov     eax, [eax+$0098]

* Possible String Reference to: 'namgeb'
|
005EF97A   BAACFE5E00             mov     edx, $005EFEAC

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EF97F   E8D831EEFF             call    004D2B5C
005EF984   8B03                   mov     eax, [ebx]
005EF986   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EF98C   E843F8EBFF             call    004AF1D4
005EF991   8B03                   mov     eax, [ebx]
005EF993   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EF999   E8EAD2EBFF             call    004ACC88
005EF99E   8B03                   mov     eax, [ebx]
005EF9A0   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
005EF9A6   BABCFE5E00             mov     edx, $005EFEBC

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EF9AB   E8AC31EEFF             call    004D2B5C
005EF9B0   8B03                   mov     eax, [ebx]
005EF9B2   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EF9B8   E817F8EBFF             call    004AF1D4

* Reference to TScreen instance
|
005EF9BD   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005EF9C2   8B00                   mov     eax, [eax]
005EF9C4   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005EF9C8   E8CFB7E7FF             call    0046B19C
005EF9CD   E917020000             jmp     005EFBE9
005EF9D2   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'NLAP'
|
005EF9D7   BA1CFE5E00             mov     edx, $005EFE1C

* Reference to: System.@LStrCmp;
|
005EF9DC   E88355E1FF             call    00404F64
005EF9E1   0F84B0000000           jz      005EFA97
005EF9E7   8D55C8                 lea     edx, [ebp-$38]
005EF9EA   8B03                   mov     eax, [ebx]
005EF9EC   8B80D0070000           mov     eax, [eax+$07D0]
005EF9F2   8B08                   mov     ecx, [eax]
005EF9F4   FF5160                 call    dword ptr [ecx+$60]
005EF9F7   8B45C8                 mov     eax, [ebp-$38]
005EF9FA   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrCmp;
|
005EF9FD   E86255E1FF             call    00404F64
005EFA02   7476                   jz      005EFA7A
005EFA04   8D55C4                 lea     edx, [ebp-$3C]
005EFA07   8B03                   mov     eax, [ebx]
005EFA09   8B80E0070000           mov     eax, [eax+$07E0]
005EFA0F   8B08                   mov     ecx, [eax]
005EFA11   FF5160                 call    dword ptr [ecx+$60]
005EFA14   8B45C4                 mov     eax, [ebp-$3C]
005EFA17   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrCmp;
|
005EFA1A   E84555E1FF             call    00404F64
005EFA1F   7459                   jz      005EFA7A
005EFA21   8D55C0                 lea     edx, [ebp-$40]
005EFA24   8B03                   mov     eax, [ebx]
005EFA26   8B80F8070000           mov     eax, [eax+$07F8]
005EFA2C   8B08                   mov     ecx, [eax]
005EFA2E   FF5160                 call    dword ptr [ecx+$60]
005EFA31   8B45C0                 mov     eax, [ebp-$40]
005EFA34   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrCmp;
|
005EFA37   E82855E1FF             call    00404F64
005EFA3C   743C                   jz      005EFA7A
005EFA3E   8D55BC                 lea     edx, [ebp-$44]
005EFA41   8B03                   mov     eax, [ebx]
005EFA43   8B800C080000           mov     eax, [eax+$080C]
005EFA49   8B08                   mov     ecx, [eax]
005EFA4B   FF5160                 call    dword ptr [ecx+$60]
005EFA4E   8B45BC                 mov     eax, [ebp-$44]
005EFA51   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrCmp;
|
005EFA54   E80B55E1FF             call    00404F64
005EFA59   741F                   jz      005EFA7A
005EFA5B   8D55B8                 lea     edx, [ebp-$48]
005EFA5E   8B03                   mov     eax, [ebx]
005EFA60   8B80E8070000           mov     eax, [eax+$07E8]
005EFA66   8B08                   mov     ecx, [eax]
005EFA68   FF5160                 call    dword ptr [ecx+$60]
005EFA6B   8B55B8                 mov     edx, [ebp-$48]
005EFA6E   8B45F8                 mov     eax, [ebp-$08]

* Reference to: System.@LStrPos;
|
005EFA71   E8E656E1FF             call    0040515C
005EFA76   85C0                   test    eax, eax
005EFA78   7E59                   jle     005EFAD3
005EFA7A   8D55B4                 lea     edx, [ebp-$4C]
005EFA7D   8B03                   mov     eax, [ebx]
005EFA7F   8B80B0070000           mov     eax, [eax+$07B0]
005EFA85   8B08                   mov     ecx, [eax]
005EFA87   FF5160                 call    dword ptr [ecx+$60]
005EFA8A   8B55B4                 mov     edx, [ebp-$4C]
005EFA8D   8B45FC                 mov     eax, [ebp-$04]
005EFA90   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005EFA92   FF5138                 call    dword ptr [ecx+$38]
005EFA95   EB3C                   jmp     005EFAD3
005EFA97   8D55AC                 lea     edx, [ebp-$54]
005EFA9A   8B03                   mov     eax, [ebx]

* Reference to field TStringList.OFFS_07B0
|
005EFA9C   8B80B0070000           mov     eax, [eax+$07B0]
005EFAA2   8B08                   mov     ecx, [eax]
005EFAA4   FF5160                 call    dword ptr [ecx+$60]
005EFAA7   8B45AC                 mov     eax, [ebp-$54]
005EFAAA   8D55B0                 lea     edx, [ebp-$50]

* Reference to: Unit_00408494.Proc_00409448
|
005EFAAD   E89699E1FF             call    00409448
005EFAB2   837DB000               cmp     dword ptr [ebp-$50], +$00
005EFAB6   761B                   jbe     005EFAD3
005EFAB8   8D55A8                 lea     edx, [ebp-$58]
005EFABB   8B03                   mov     eax, [ebx]
005EFABD   8B80B0070000           mov     eax, [eax+$07B0]
005EFAC3   8B08                   mov     ecx, [eax]
005EFAC5   FF5160                 call    dword ptr [ecx+$60]
005EFAC8   8B55A8                 mov     edx, [ebp-$58]
005EFACB   8B45FC                 mov     eax, [ebp-$04]
005EFACE   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005EFAD0   FF5138                 call    dword ptr [ecx+$38]
005EFAD3   8B03                   mov     eax, [ebx]

* Reference to field TStringList.OFFS_00A4
|
005EFAD5   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EFADB   E8F4F6EBFF             call    004AF1D4
005EFAE0   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'NLAP'
|
005EFAE5   BA1CFE5E00             mov     edx, $005EFE1C

* Reference to: System.@LStrCmp;
|
005EFAEA   E87554E1FF             call    00404F64
005EFAEF   0F84E7000000           jz      005EFBDC
005EFAF5   8B03                   mov     eax, [ebx]
005EFAF7   8B80A4070000           mov     eax, [eax+$07A4]
005EFAFD   8B10                   mov     edx, [eax]
005EFAFF   FF5258                 call    dword ptr [edx+$58]
005EFB02   8945A0                 mov     [ebp-$60], eax
005EFB05   C645A400               mov     byte ptr [ebp-$5C], $00
005EFB09   8D55A0                 lea     edx, [ebp-$60]
005EFB0C   8B03                   mov     eax, [ebx]
005EFB0E   8B80A4000000           mov     eax, [eax+$00A4]
005EFB14   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005EFB16   E84937EEFF             call    004D3264
005EFB1B   84C0                   test    al, al
005EFB1D   0F84B9000000           jz      005EFBDC
005EFB23   E990000000             jmp     005EFBB8
005EFB28   8D559C                 lea     edx, [ebp-$64]
005EFB2B   8B03                   mov     eax, [ebx]
005EFB2D   8B80C8030000           mov     eax, [eax+$03C8]
005EFB33   8B08                   mov     ecx, [eax]
005EFB35   FF5160                 call    dword ptr [ecx+$60]
005EFB38   8B459C                 mov     eax, [ebp-$64]
005EFB3B   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrCmp;
|
005EFB3E   E82154E1FF             call    00404F64
005EFB43   743A                   jz      005EFB7F
005EFB45   8D5598                 lea     edx, [ebp-$68]
005EFB48   8B03                   mov     eax, [ebx]
005EFB4A   8B80DC030000           mov     eax, [eax+$03DC]
005EFB50   8B08                   mov     ecx, [eax]
005EFB52   FF5160                 call    dword ptr [ecx+$60]
005EFB55   8B4598                 mov     eax, [ebp-$68]
005EFB58   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrCmp;
|
005EFB5B   E80454E1FF             call    00404F64
005EFB60   741D                   jz      005EFB7F
005EFB62   8D5594                 lea     edx, [ebp-$6C]
005EFB65   8B03                   mov     eax, [ebx]
005EFB67   8B80F4030000           mov     eax, [eax+$03F4]
005EFB6D   8B08                   mov     ecx, [eax]
005EFB6F   FF5160                 call    dword ptr [ecx+$60]
005EFB72   8B4594                 mov     eax, [ebp-$6C]
005EFB75   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrCmp;
|
005EFB78   E8E753E1FF             call    00404F64
005EFB7D   751B                   jnz     005EFB9A
005EFB7F   8D5590                 lea     edx, [ebp-$70]
005EFB82   8B03                   mov     eax, [ebx]
005EFB84   8B80B0070000           mov     eax, [eax+$07B0]
005EFB8A   8B08                   mov     ecx, [eax]
005EFB8C   FF5160                 call    dword ptr [ecx+$60]
005EFB8F   8B5590                 mov     edx, [ebp-$70]
005EFB92   8B45FC                 mov     eax, [ebp-$04]
005EFB95   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005EFB97   FF5138                 call    dword ptr [ecx+$38]
005EFB9A   8B03                   mov     eax, [ebx]

* Reference to field TStringList.OFFS_00A4
|
005EFB9C   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005EFBA2   E845F9EBFF             call    004AF4EC
005EFBA7   8B03                   mov     eax, [ebx]
005EFBA9   8B80A4000000           mov     eax, [eax+$00A4]
005EFBAF   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EFBB6   7524                   jnz     005EFBDC
005EFBB8   8B03                   mov     eax, [ebx]
005EFBBA   8B80B4030000           mov     eax, [eax+$03B4]
005EFBC0   8B10                   mov     edx, [eax]
005EFBC2   FF5258                 call    dword ptr [edx+$58]
005EFBC5   8BF8                   mov     edi, eax
005EFBC7   8B03                   mov     eax, [ebx]
005EFBC9   8B80A4070000           mov     eax, [eax+$07A4]
005EFBCF   8B10                   mov     edx, [eax]
005EFBD1   FF5258                 call    dword ptr [edx+$58]
005EFBD4   3BF8                   cmp     edi, eax
005EFBD6   0F844CFFFFFF           jz      005EFB28
005EFBDC   8B03                   mov     eax, [ebx]
005EFBDE   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005EFBE4   E803F9EBFF             call    004AF4EC
005EFBE9   8B03                   mov     eax, [ebx]
005EFBEB   8B8098000000           mov     eax, [eax+$0098]
005EFBF1   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EFBF8   0F84D4FDFFFF           jz      005EF9D2
005EFBFE   8B45FC                 mov     eax, [ebp-$04]
005EFC01   8B10                   mov     edx, [eax]

* Reference to method TStringList.GetCount()
|
005EFC03   FF5214                 call    dword ptr [edx+$14]
005EFC06   85C0                   test    eax, eax
005EFC08   0F8E4A010000           jle     005EFD58
005EFC0E   8D4D88                 lea     ecx, [ebp-$78]
005EFC11   33D2                   xor     edx, edx
005EFC13   8B45FC                 mov     eax, [ebp-$04]
005EFC16   8B38                   mov     edi, [eax]

* Reference to method TStringList.Get(Integer)
|
005EFC18   FF570C                 call    dword ptr [edi+$0C]
005EFC1B   8B4588                 mov     eax, [ebp-$78]
005EFC1E   8D558C                 lea     edx, [ebp-$74]

* Reference to: Unit_00408494.Proc_00409448
|
005EFC21   E82298E1FF             call    00409448
005EFC26   837D8C00               cmp     dword ptr [ebp-$74], +$00
005EFC2A   750A                   jnz     005EFC36
005EFC2C   33D2                   xor     edx, edx
005EFC2E   8B45FC                 mov     eax, [ebp-$04]
005EFC31   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Delete(Integer)
|
005EFC33   FF5148                 call    dword ptr [ecx+$48]
005EFC36   8B03                   mov     eax, [ebx]

* Reference to field TStringList.OFFS_00E0
|
005EFC38   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EFC3E   E845D0EBFF             call    004ACC88
005EFC43   8B03                   mov     eax, [ebx]
005EFC45   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005EFC4B   E844D0EBFF             call    004ACC94
005EFC50   8B03                   mov     eax, [ebx]
005EFC52   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005EFC58   E87F43EEFF             call    004D3FDC
005EFC5D   8B03                   mov     eax, [ebx]
005EFC5F   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EFC65   E81ED0EBFF             call    004ACC88
005EFC6A   8B45FC                 mov     eax, [ebp-$04]
005EFC6D   8B10                   mov     edx, [eax]

* Reference to method TStringList.GetCount()
|
005EFC6F   FF5214                 call    dword ptr [edx+$14]
005EFC72   48                     dec     eax
005EFC73   85C0                   test    eax, eax
005EFC75   7C51                   jl      005EFCC8
005EFC77   40                     inc     eax
005EFC78   8945E0                 mov     [ebp-$20], eax
005EFC7B   C745E800000000         mov     dword ptr [ebp-$18], $00000000
005EFC82   8B03                   mov     eax, [ebx]
005EFC84   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005EFC8A   E895FAEBFF             call    004AF724
005EFC8F   8D4D84                 lea     ecx, [ebp-$7C]
005EFC92   8B55E8                 mov     edx, [ebp-$18]
005EFC95   8B45FC                 mov     eax, [ebp-$04]
005EFC98   8B38                   mov     edi, [eax]

* Reference to method TStringList.Get(Integer)
|
005EFC9A   FF570C                 call    dword ptr [edi+$0C]
005EFC9D   8B5584                 mov     edx, [ebp-$7C]
005EFCA0   8B03                   mov     eax, [ebx]

* Reference to field TStringList.OFFS_01E8
|
005EFCA2   8B80E8010000           mov     eax, [eax+$01E8]
005EFCA8   8B08                   mov     ecx, [eax]
005EFCAA   FF91B0000000           call    dword ptr [ecx+$00B0]
005EFCB0   8B03                   mov     eax, [ebx]
005EFCB2   8B80E0000000           mov     eax, [eax+$00E0]
005EFCB8   8B10                   mov     edx, [eax]
005EFCBA   FF9248020000           call    dword ptr [edx+$0248]
005EFCC0   FF45E8                 inc     dword ptr [ebp-$18]
005EFCC3   FF4DE0                 dec     dword ptr [ebp-$20]
005EFCC6   75BA                   jnz     005EFC82

* Reference to pointer to GlobalVar_0061DF10
|
005EFCC8   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005EFCCD   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
005EFCCF   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to field TLabel.OFFS_02BC
|
005EFCD5   8B80BC020000           mov     eax, [eax+$02BC]
005EFCDB   BA03000000             mov     edx, $00000003

* Reference to: QuickRpt.TQRPage.SetColumns(TQRPage;Integer);
|
005EFCE0   E8B35AF2FF             call    00515798
005EFCE5   8D5580                 lea     edx, [ebp-$80]

* Reference to pointer to GlobalVar_0061E0B4
|
005EFCE8   A1ECC66100             mov     eax, dword ptr [$0061C6EC]
005EFCED   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0B4.OFFS_0360
|
005EFCEF   8B8060030000           mov     eax, [eax+$0360]

* Reference to: Controls.TControl.GetText(TControl):TCaption;
|
005EFCF5   E80ACDE5FF             call    0044CA04
005EFCFA   8B4580                 mov     eax, [ebp-$80]

* Possible String Reference to: 'A 4'
|
005EFCFD   BAC8FE5E00             mov     edx, $005EFEC8

* Reference to: System.@LStrCmp;
|
005EFD02   E85D52E1FF             call    00404F64
005EFD07   751D                   jnz     005EFD26

* Reference to pointer to GlobalVar_0061DF10
|
005EFD09   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005EFD0E   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
005EFD10   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to field TLabel.OFFS_02BC
|
005EFD16   8B80BC020000           mov     eax, [eax+$02BC]
005EFD1C   BA04000000             mov     edx, $00000004

* Reference to: QuickRpt.TQRPage.SetColumns(TQRPage;Integer);
|
005EFD21   E8725AF2FF             call    00515798
005EFD26   8B4DF0                 mov     ecx, [ebp-$10]
005EFD29   8B1530595302           mov     edx, [$02535930]
005EFD2F   8BC6                   mov     eax, esi

* Reference to : TForm1.druck()
|
005EFD31   E85EF6FFFF             call    005EF394

* Reference to TScreen instance
|
005EFD36   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005EFD3B   8B00                   mov     eax, [eax]
005EFD3D   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005EFD3F   E858B4E7FF             call    0046B19C

* Reference to pointer to GlobalVar_0061DF10
|
005EFD44   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005EFD49   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
005EFD4B   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to: QuickRpt.TCustomQuickRep.Preview(TCustomQuickRep);
|
005EFD51   E8FA99F2FF             call    00519750
005EFD56   EB2D                   jmp     005EFD85

* Possible String Reference to: 'Keine Namen f�r "'
|
005EFD58   68D4FE5E00             push    $005EFED4
005EFD5D   FF75F8                 push    dword ptr [ebp-$08]
005EFD60   68F0FE5E00             push    $005EFEF0

* Possible String Reference to: ' gefunden.'
|
005EFD65   68FCFE5E00             push    $005EFEFC
005EFD6A   8D857CFFFFFF           lea     eax, [ebp+$FFFFFF7C]
005EFD70   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005EFD75   E86651E1FF             call    00404EE0
005EFD7A   8B857CFFFFFF           mov     eax, [ebp+$FFFFFF7C]

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005EFD80   E85F5AE5FF             call    004457E4

* Reference to TScreen instance
|
005EFD85   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005EFD8A   8B00                   mov     eax, [eax]
005EFD8C   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005EFD8E   E809B4E7FF             call    0046B19C
005EFD93   33C0                   xor     eax, eax
005EFD95   55                     push    ebp
005EFD96   68B3FD5E00             push    $005EFDB3

***** TRY
|
005EFD9B   64FF30                 push    dword ptr fs:[eax]
005EFD9E   648920                 mov     fs:[eax], esp
005EFDA1   8B45FC                 mov     eax, [ebp-$04]

* Reference to: System.TObject.Free(TObject);
|
005EFDA4   E88F3FE1FF             call    00403D38
005EFDA9   33C0                   xor     eax, eax
005EFDAB   5A                     pop     edx
005EFDAC   59                     pop     ecx
005EFDAD   59                     pop     ecx
005EFDAE   648910                 mov     fs:[eax], edx
005EFDB1   EB0A                   jmp     005EFDBD

* Reference to: System.@HandleAnyException;
|
005EFDB3   E96044E1FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005EFDB8   E88748E1FF             call    00404644

****** END
|
005EFDBD   33C0                   xor     eax, eax
005EFDBF   5A                     pop     edx
005EFDC0   59                     pop     ecx
005EFDC1   59                     pop     ecx
005EFDC2   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005EFDC5   680CFE5E00             push    $005EFE0C
005EFDCA   8D857CFFFFFF           lea     eax, [ebp+$FFFFFF7C]

* Reference to: System.@LStrClr(void;void);
|
005EFDD0   E8934DE1FF             call    00404B68
005EFDD5   8D4580                 lea     eax, [ebp-$80]

* Reference to: System.@LStrClr(void;void);
|
005EFDD8   E88B4DE1FF             call    00404B68
005EFDDD   8D4584                 lea     eax, [ebp-$7C]
005EFDE0   BA07000000             mov     edx, $00000007

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EFDE5   E8A24DE1FF             call    00404B8C
005EFDEA   8D45A8                 lea     eax, [ebp-$58]
005EFDED   BA0E000000             mov     edx, $0000000E

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EFDF2   E8954DE1FF             call    00404B8C
005EFDF7   8D45EC                 lea     eax, [ebp-$14]
005EFDFA   BA04000000             mov     edx, $00000004

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EFDFF   E8884DE1FF             call    00404B8C
005EFE04   C3                     ret


* Reference to: System.@HandleFinally;
|
005EFE05   E9C246E1FF             jmp     004044CC
005EFE0A   EBBE                   jmp     005EFDCA

****** END
|
005EFE0C   5F                     pop     edi
005EFE0D   5E                     pop     esi
005EFE0E   5B                     pop     ebx
005EFE0F   8BE5                   mov     esp, ebp
005EFE11   5D                     pop     ebp
005EFE12   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.frbestimmtenOrt1 (TMenuItem); TForm1.PageControl1
    (TPageControl); TForm1.TabSheet2 (TTabSheet)
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);; method
    TMenuItem.Click()
Strings/files/dialog text: 'NLAP'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.allePersonen1Click(Sender : TObject);
begin
(*
005EFF08   53                     push    ebx
005EFF09   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EFF0B   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EFF11   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EFF17   E89CFEE8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005EFF1C   8B831C060000           mov     eax, [ebx+$061C]
005EFF22   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005EFF24   FF5244                 call    dword ptr [edx+$44]
005EFF27   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'NLAP'
|
005EFF2C   BA4CFF5E00             mov     edx, $005EFF4C

* Reference to: System.@LStrAsg(void;void;void;void);
|
005EFF31   E8864CE1FF             call    00404BBC

* Reference to control TForm1.frbestimmtenOrt1 : TMenuItem
|
005EFF36   8B83A0060000           mov     eax, [ebx+$06A0]
005EFF3C   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005EFF3E   FF5244                 call    dword ptr [edx+$44]
005EFF41   5B                     pop     ebx
005EFF42   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Label1 (TLabel); TForm1.aus1 (TMenuItem); TForm1.ComboBox4 (TComboBox);
    TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.Append(TDataSet);; DB.TDataSet.Close(TDataSet);;
    DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);; DB.TDataSet.Open(TDataSet);;
    DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.EmptyTable(TTable);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_0061DF10; GlobalVar_0061DF9C
Unresolved field offsets: OFFS_005C; OFFS_0098; OFFS_00A4; OFFS_00CC; OFFS_00E0; OFFS_01E8;
    OFFS_02BC; OFFS_03B4; OFFS_03C8; OFFS_03DC; OFFS_03F4; OFFS_0534; OFFS_07A4; OFFS_07B0;
    OFFS_07D0; OFFS_07E0; OFFS_07F8; OFFS_080C; OFFS_0A44
Project calls: TForm1.druck(); TForm1.speich1(); Unit_00408494.Proc_00409448
Framework/API calls: class TStringList; Classes.TStringList.SetSorted(TStringList;Boolean);;
    ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.GetText(TControl):TCaption;; Controls.TControl.SetText(TControl;TCaption);;
    Dialogs.ShowMessage(AnsiString);; Forms.TScreen.SetCursor(TScreen;TCursor);; method
    TMenuItem.Click(); method TStringList.Add(string); method TStringList.Delete(Integer); method
    TStringList.Get(Integer); method TStringList.GetCount();
    QuickRpt.TCustomQuickRep.Preview(TCustomQuickRep);;
    QuickRpt.TQRPage.SetColumns(TQRPage;Integer);; System.TObject.Create(TObject;Boolean);;
    System.TObject.Free(TObject);; TScreen instance
Strings/files/dialog text: '_^[��]�'; 'Keine Daten verf�gbar.'; 'namgeb'; 'num'; 'OLAP'; 'OLPN';
    'ort_'; 'Ortsliste (alle Personen)'; 'Ortsliste f�r Name: '; '� ����$�����a'; '�$������a';
    '���a'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Probandenname1Click(Sender : TObject);
begin
(*
005F1B44   55                     push    ebp
005F1B45   8BEC                   mov     ebp, esp
005F1B47   B909000000             mov     ecx, $00000009
005F1B4C   6A00                   push    $00
005F1B4E   6A00                   push    $00
005F1B50   49                     dec     ecx
005F1B51   75F9                   jnz     005F1B4C
005F1B53   53                     push    ebx
005F1B54   56                     push    esi
005F1B55   57                     push    edi
005F1B56   8945FC                 mov     [ebp-$04], eax
005F1B59   33C0                   xor     eax, eax
005F1B5B   55                     push    ebp
005F1B5C   68C3215F00             push    $005F21C3

***** TRY
|
005F1B61   64FF30                 push    dword ptr fs:[eax]
005F1B64   648920                 mov     fs:[eax], esp
005F1B67   8D55F4                 lea     edx, [ebp-$0C]

* Reference to Form1
|
005F1B6A   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.ComboBox4 : TComboBox
|
005F1B6D   8B8058080000           mov     eax, [eax+$0858]

* Reference to: Controls.TControl.GetText(TControl):TCaption;
|
005F1B73   E88CAEE5FF             call    0044CA04

* Reference to Form1
|
005F1B78   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005F1B7B   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005F1B81   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005F1B84   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005F1B8A   E829E2E8FF             call    0047FDB8

* Reference to pointer to GlobalVar_0061DF08
|
005F1B8F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1B94   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005F1B96   8B8034050000           mov     eax, [eax+$0534]
005F1B9C   8B10                   mov     edx, [eax]
005F1B9E   FF5258                 call    dword ptr [edx+$58]
005F1BA1   8BD8                   mov     ebx, eax

* Reference to Form1
|
005F1BA3   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.aus1 : TMenuItem
|
005F1BA6   8B801C060000           mov     eax, [eax+$061C]
005F1BAC   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005F1BAE   FF5244                 call    dword ptr [edx+$44]

* Reference to Form1
|
005F1BB1   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.speich1()
|
005F1BB4   E8E35DFEFF             call    005D799C
005F1BB9   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'OLAP'
|
005F1BBE   BADC215F00             mov     edx, $005F21DC

* Reference to: System.@LStrCmp;
|
005F1BC3   E89C33E1FF             call    00404F64
005F1BC8   740F                   jz      005F1BD9
005F1BCA   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'OLPN'
|
005F1BCF   BAEC215F00             mov     edx, $005F21EC

* Reference to: System.@LStrAsg(void;void;void;void);
|
005F1BD4   E8E32FE1FF             call    00404BBC

* Reference to pointer to GlobalVar_0061DF08
|
005F1BD9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1BDE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005F1BE0   8B405C                 mov     eax, [eax+$5C]
005F1BE3   8B10                   mov     edx, [eax]
005F1BE5   FF924C010000           call    dword ptr [edx+$014C]
005F1BEB   83F802                 cmp     eax, +$02
005F1BEE   7D0F                   jnl     005F1BFF

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005F1BF0   B8FC215F00             mov     eax, $005F21FC

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005F1BF5   E8EA3BE5FF             call    004457E4
005F1BFA   E99C050000             jmp     005F219B
005F1BFF   895DE8                 mov     [ebp-$18], ebx
005F1C02   C645EC00               mov     byte ptr [ebp-$14], $00
005F1C06   8D55E8                 lea     edx, [ebp-$18]

* Reference to pointer to GlobalVar_0061DF08
|
005F1C09   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1C0E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005F1C10   8B405C                 mov     eax, [eax+$5C]
005F1C13   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005F1C15   E84A16EEFF             call    004D3264
005F1C1A   B830595302             mov     eax, $02535930
005F1C1F   8B4DF4                 mov     ecx, [ebp-$0C]

* Possible String Reference to: 'Ortsliste f�r Name: '
|
005F1C22   BA1C225F00             mov     edx, $005F221C

* Reference to: System.@LStrCat3;
|
005F1C27   E84032E1FF             call    00404E6C
005F1C2C   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'OLAP'
|
005F1C31   BADC215F00             mov     edx, $005F21DC

* Reference to: System.@LStrCmp;
|
005F1C36   E82933E1FF             call    00404F64
005F1C3B   750F                   jnz     005F1C4C
005F1C3D   B830595302             mov     eax, $02535930

* Possible String Reference to: 'Ortsliste (alle Personen)'
|
005F1C42   BA3C225F00             mov     edx, $005F223C

* Reference to: System.@LStrAsg(void;void;void;void);
|
005F1C47   E8702FE1FF             call    00404BBC

* Reference to pointer to GlobalVar_0061DF9C
|
005F1C4C   A168CA6100             mov     eax, dword ptr [$0061CA68]
005F1C51   8B00                   mov     eax, [eax]
005F1C53   8B1530595302           mov     edx, [$02535930]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005F1C59   E8D6ADE5FF             call    0044CA34
005F1C5E   8D45F0                 lea     eax, [ebp-$10]

* Reference to: System.@LStrClr(void;void);
|
005F1C61   E8022FE1FF             call    00404B68
005F1C66   B201                   mov     dl, $01

* Reference to class TStringList
|
005F1C68   A1D8794100             mov     eax, dword ptr [$004179D8]

* Reference to: System.TObject.Create(TObject;Boolean);
|
005F1C6D   E89620E1FF             call    00403D08
005F1C72   8945F8                 mov     [ebp-$08], eax
005F1C75   B201                   mov     dl, $01
005F1C77   8B45F8                 mov     eax, [ebp-$08]

* Reference to: Classes.TStringList.SetSorted(TStringList;Boolean);
|
005F1C7A   E8D5ABE2FF             call    0041C854
005F1C7F   8B45F8                 mov     eax, [ebp-$08]

* Reference to field TStringList.Duplicates : TDuplicates
|
005F1C82   C6401D00               mov     byte ptr [eax+$1D], $00

* Reference to pointer to GlobalVar_0061DF08
|
005F1C86   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1C8B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0098
|
005F1C8D   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005F1C93   E8F0AFEBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005F1C98   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1C9D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0098
|
005F1C9F   8B8098000000           mov     eax, [eax+$0098]

* Possible String Reference to: 'namgeb'
|
005F1CA5   BA60225F00             mov     edx, $005F2260

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005F1CAA   E8AD0EEEFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005F1CAF   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1CB4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0098
|
005F1CB6   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.First(TDataSet);
|
005F1CBC   E813D5EBFF             call    004AF1D4

* Reference to pointer to GlobalVar_0061DF08
|
005F1CC1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1CC6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005F1CC8   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005F1CCE   E8B5AFEBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005F1CD3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1CD8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005F1CDA   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
005F1CE0   BA70225F00             mov     edx, $005F2270

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005F1CE5   E8720EEEFF             call    004D2B5C
005F1CEA   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'OLAP'
|
005F1CEF   BADC215F00             mov     edx, $005F21DC

* Reference to: System.@LStrCmp;
|
005F1CF4   E86B32E1FF             call    00404F64
005F1CF9   0F85CA000000           jnz     005F1DC9

* Reference to TScreen instance
|
005F1CFF   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005F1D04   8B00                   mov     eax, [eax]
005F1D06   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005F1D0A   E88D94E7FF             call    0046B19C
005F1D0F   33C0                   xor     eax, eax
005F1D11   55                     push    ebp
005F1D12   68C21D5F00             push    $005F1DC2

***** TRY
|
005F1D17   64FF30                 push    dword ptr fs:[eax]
005F1D1A   648920                 mov     fs:[eax], esp

* Reference to pointer to GlobalVar_0061DF08
|
005F1D1D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1D22   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005F1D24   8B80CC000000           mov     eax, [eax+$00CC]

* Possible String Reference to: 'ort_'
|
005F1D2A   BA7C225F00             mov     edx, $005F227C

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005F1D2F   E8280EEEFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005F1D34   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1D39   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005F1D3B   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.First(TDataSet);
|
005F1D41   E88ED4EBFF             call    004AF1D4
005F1D46   EB48                   jmp     005F1D90
005F1D48   8D55E4                 lea     edx, [ebp-$1C]

* Reference to pointer to GlobalVar_0061DF08
|
005F1D4B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1D50   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0A44
|
005F1D52   8B80440A0000           mov     eax, [eax+$0A44]
005F1D58   8B08                   mov     ecx, [eax]
005F1D5A   FF5160                 call    dword ptr [ecx+$60]
005F1D5D   8B55E4                 mov     edx, [ebp-$1C]
005F1D60   8B45F8                 mov     eax, [ebp-$08]
005F1D63   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005F1D65   FF5138                 call    dword ptr [ecx+$38]

* Reference to pointer to GlobalVar_0061DF08
|
005F1D68   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1D6D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005F1D6F   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005F1D75   E872D7EBFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005F1D7A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1D7F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005F1D81   8B80CC000000           mov     eax, [eax+$00CC]
005F1D87   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005F1D8E   7516                   jnz     005F1DA6

* Reference to pointer to GlobalVar_0061DF08
|
005F1D90   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1D95   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005F1D97   8B80CC000000           mov     eax, [eax+$00CC]
005F1D9D   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005F1DA4   74A2                   jz      005F1D48
005F1DA6   33C0                   xor     eax, eax
005F1DA8   5A                     pop     edx
005F1DA9   59                     pop     ecx
005F1DAA   59                     pop     ecx
005F1DAB   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '���a'
|
005F1DAE   682F205F00             push    $005F202F

* Reference to TScreen instance
|
005F1DB3   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005F1DB8   8B00                   mov     eax, [eax]
005F1DBA   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005F1DBC   E8DB93E7FF             call    0046B19C
005F1DC1   C3                     ret


* Reference to: System.@HandleFinally;
|
005F1DC2   E90527E1FF             jmp     004044CC
005F1DC7   EBEA                   jmp     005F1DB3
005F1DC9   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'OLPN'
|
005F1DCE   BAEC215F00             mov     edx, $005F21EC

* Reference to: System.@LStrCmp;
|
005F1DD3   E88C31E1FF             call    00404F64
005F1DD8   0F8551020000           jnz     005F202F

* Reference to TScreen instance
|
005F1DDE   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005F1DE3   8B00                   mov     eax, [eax]
005F1DE5   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005F1DE9   E8AE93E7FF             call    0046B19C
005F1DEE   33C0                   xor     eax, eax
005F1DF0   55                     push    ebp

* Possible String Reference to: '�$������a'
|
005F1DF1   6828205F00             push    $005F2028

***** TRY
|
005F1DF6   64FF30                 push    dword ptr fs:[eax]
005F1DF9   648920                 mov     fs:[eax], esp

* Reference to pointer to GlobalVar_0061DF08
|
005F1DFC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1E01   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0098
|
005F1E03   8B8098000000           mov     eax, [eax+$0098]

* Possible String Reference to: 'namgeb'
|
005F1E09   BA60225F00             mov     edx, $005F2260

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005F1E0E   E8490DEEFF             call    004D2B5C
005F1E13   8B45F4                 mov     eax, [ebp-$0C]
005F1E16   8945E8                 mov     [ebp-$18], eax
005F1E19   C645EC0B               mov     byte ptr [ebp-$14], $0B
005F1E1D   8D55E8                 lea     edx, [ebp-$18]

* Reference to pointer to GlobalVar_0061DF08
|
005F1E20   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1E25   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0098
|
005F1E27   8B8098000000           mov     eax, [eax+$0098]
005F1E2D   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005F1E2F   E83014EEFF             call    004D3264
005F1E34   E9AD010000             jmp     005F1FE6
005F1E39   8D55E0                 lea     edx, [ebp-$20]

* Reference to pointer to GlobalVar_0061DF08
|
005F1E3C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1E41   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_07D0
|
005F1E43   8B80D0070000           mov     eax, [eax+$07D0]
005F1E49   8B08                   mov     ecx, [eax]
005F1E4B   FF5160                 call    dword ptr [ecx+$60]
005F1E4E   8B55E0                 mov     edx, [ebp-$20]
005F1E51   8B45F8                 mov     eax, [ebp-$08]
005F1E54   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005F1E56   FF5138                 call    dword ptr [ecx+$38]
005F1E59   8D55DC                 lea     edx, [ebp-$24]

* Reference to pointer to GlobalVar_0061DF08
|
005F1E5C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1E61   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_07E0
|
005F1E63   8B80E0070000           mov     eax, [eax+$07E0]
005F1E69   8B08                   mov     ecx, [eax]
005F1E6B   FF5160                 call    dword ptr [ecx+$60]
005F1E6E   8B55DC                 mov     edx, [ebp-$24]
005F1E71   8B45F8                 mov     eax, [ebp-$08]
005F1E74   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005F1E76   FF5138                 call    dword ptr [ecx+$38]
005F1E79   8D55D8                 lea     edx, [ebp-$28]

* Reference to pointer to GlobalVar_0061DF08
|
005F1E7C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1E81   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_07F8
|
005F1E83   8B80F8070000           mov     eax, [eax+$07F8]
005F1E89   8B08                   mov     ecx, [eax]
005F1E8B   FF5160                 call    dword ptr [ecx+$60]
005F1E8E   8B55D8                 mov     edx, [ebp-$28]
005F1E91   8B45F8                 mov     eax, [ebp-$08]
005F1E94   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005F1E96   FF5138                 call    dword ptr [ecx+$38]
005F1E99   8D55D4                 lea     edx, [ebp-$2C]

* Reference to pointer to GlobalVar_0061DF08
|
005F1E9C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1EA1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_080C
|
005F1EA3   8B800C080000           mov     eax, [eax+$080C]
005F1EA9   8B08                   mov     ecx, [eax]
005F1EAB   FF5160                 call    dword ptr [ecx+$60]
005F1EAE   8B55D4                 mov     edx, [ebp-$2C]
005F1EB1   8B45F8                 mov     eax, [ebp-$08]
005F1EB4   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005F1EB6   FF5138                 call    dword ptr [ecx+$38]

* Reference to pointer to GlobalVar_0061DF08
|
005F1EB9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1EBE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005F1EC0   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.First(TDataSet);
|
005F1EC6   E809D3EBFF             call    004AF1D4

* Reference to pointer to GlobalVar_0061DF08
|
005F1ECB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1ED0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_07A4
|
005F1ED2   8B80A4070000           mov     eax, [eax+$07A4]
005F1ED8   8B10                   mov     edx, [eax]
005F1EDA   FF5258                 call    dword ptr [edx+$58]
005F1EDD   8945E8                 mov     [ebp-$18], eax
005F1EE0   C645EC00               mov     byte ptr [ebp-$14], $00
005F1EE4   8D55E8                 lea     edx, [ebp-$18]

* Reference to pointer to GlobalVar_0061DF08
|
005F1EE7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1EEC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005F1EEE   8B80A4000000           mov     eax, [eax+$00A4]
005F1EF4   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005F1EF6   E86913EEFF             call    004D3264
005F1EFB   84C0                   test    al, al
005F1EFD   0F84BB000000           jz      005F1FBE
005F1F03   E988000000             jmp     005F1F90
005F1F08   8D55D0                 lea     edx, [ebp-$30]

* Reference to pointer to GlobalVar_0061DF08
|
005F1F0B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1F10   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C8
|
005F1F12   8B80C8030000           mov     eax, [eax+$03C8]
005F1F18   8B08                   mov     ecx, [eax]
005F1F1A   FF5160                 call    dword ptr [ecx+$60]
005F1F1D   8B55D0                 mov     edx, [ebp-$30]
005F1F20   8B45F8                 mov     eax, [ebp-$08]
005F1F23   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005F1F25   FF5138                 call    dword ptr [ecx+$38]
005F1F28   8D55CC                 lea     edx, [ebp-$34]

* Reference to pointer to GlobalVar_0061DF08
|
005F1F2B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1F30   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03DC
|
005F1F32   8B80DC030000           mov     eax, [eax+$03DC]
005F1F38   8B08                   mov     ecx, [eax]
005F1F3A   FF5160                 call    dword ptr [ecx+$60]
005F1F3D   8B55CC                 mov     edx, [ebp-$34]
005F1F40   8B45F8                 mov     eax, [ebp-$08]
005F1F43   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005F1F45   FF5138                 call    dword ptr [ecx+$38]
005F1F48   8D55C8                 lea     edx, [ebp-$38]

* Reference to pointer to GlobalVar_0061DF08
|
005F1F4B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1F50   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F4
|
005F1F52   8B80F4030000           mov     eax, [eax+$03F4]
005F1F58   8B08                   mov     ecx, [eax]
005F1F5A   FF5160                 call    dword ptr [ecx+$60]
005F1F5D   8B55C8                 mov     edx, [ebp-$38]
005F1F60   8B45F8                 mov     eax, [ebp-$08]
005F1F63   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Add(string)
|
005F1F65   FF5138                 call    dword ptr [ecx+$38]

* Reference to pointer to GlobalVar_0061DF08
|
005F1F68   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1F6D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005F1F6F   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005F1F75   E872D5EBFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005F1F7A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1F7F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005F1F81   8B80A4000000           mov     eax, [eax+$00A4]
005F1F87   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005F1F8E   752E                   jnz     005F1FBE

* Reference to pointer to GlobalVar_0061DF08
|
005F1F90   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1F95   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03B4
|
005F1F97   8B80B4030000           mov     eax, [eax+$03B4]
005F1F9D   8B10                   mov     edx, [eax]
005F1F9F   FF5258                 call    dword ptr [edx+$58]
005F1FA2   8BD8                   mov     ebx, eax

* Reference to pointer to GlobalVar_0061DF08
|
005F1FA4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1FA9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_07A4
|
005F1FAB   8B80A4070000           mov     eax, [eax+$07A4]
005F1FB1   8B10                   mov     edx, [eax]
005F1FB3   FF5258                 call    dword ptr [edx+$58]
005F1FB6   3BD8                   cmp     ebx, eax
005F1FB8   0F844AFFFFFF           jz      005F1F08

* Reference to pointer to GlobalVar_0061DF08
|
005F1FBE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1FC3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0098
|
005F1FC5   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005F1FCB   E81CD5EBFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005F1FD0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1FD5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0098
|
005F1FD7   8B8098000000           mov     eax, [eax+$0098]
005F1FDD   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005F1FE4   7526                   jnz     005F200C
005F1FE6   8D55C4                 lea     edx, [ebp-$3C]

* Reference to pointer to GlobalVar_0061DF08
|
005F1FE9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F1FEE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_07B0
|
005F1FF0   8B80B0070000           mov     eax, [eax+$07B0]
005F1FF6   8B08                   mov     ecx, [eax]
005F1FF8   FF5160                 call    dword ptr [ecx+$60]
005F1FFB   8B45C4                 mov     eax, [ebp-$3C]
005F1FFE   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrCmp;
|
005F2001   E85E2FE1FF             call    00404F64
005F2006   0F842DFEFFFF           jz      005F1E39
005F200C   33C0                   xor     eax, eax
005F200E   5A                     pop     edx
005F200F   59                     pop     ecx
005F2010   59                     pop     ecx
005F2011   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '���a'
|
005F2014   682F205F00             push    $005F202F

* Reference to TScreen instance
|
005F2019   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005F201E   8B00                   mov     eax, [eax]
005F2020   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005F2022   E87591E7FF             call    0046B19C
005F2027   C3                     ret


* Reference to: System.@HandleFinally;
|
005F2028   E99F24E1FF             jmp     004044CC
005F202D   EBEA                   jmp     005F2019

****** END
|
* Reference to TScreen instance
|
005F202F   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005F2034   8B00                   mov     eax, [eax]
005F2036   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005F203A   E85D91E7FF             call    0046B19C
005F203F   8D4DBC                 lea     ecx, [ebp-$44]
005F2042   33D2                   xor     edx, edx
005F2044   8B45F8                 mov     eax, [ebp-$08]
005F2047   8B18                   mov     ebx, [eax]

* Reference to method TStringList.Get(Integer)
|
005F2049   FF530C                 call    dword ptr [ebx+$0C]
005F204C   8B45BC                 mov     eax, [ebp-$44]
005F204F   8D55C0                 lea     edx, [ebp-$40]

* Reference to: Unit_00408494.Proc_00409448
|
005F2052   E8F173E1FF             call    00409448
005F2057   837DC000               cmp     dword ptr [ebp-$40], +$00
005F205B   750A                   jnz     005F2067
005F205D   33D2                   xor     edx, edx
005F205F   8B45F8                 mov     eax, [ebp-$08]
005F2062   8B08                   mov     ecx, [eax]

* Reference to method TStringList.Delete(Integer)
|
005F2064   FF5148                 call    dword ptr [ecx+$48]

* Reference to pointer to GlobalVar_0061DF08
|
005F2067   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F206C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005F206E   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005F2074   E80FACEBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005F2079   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F207E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005F2080   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005F2086   E809ACEBFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005F208B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F2090   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005F2092   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005F2098   E83F1FEEFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005F209D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F20A2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005F20A4   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005F20AA   E8D9ABEBFF             call    004ACC88
005F20AF   8B45F8                 mov     eax, [ebp-$08]
005F20B2   8B10                   mov     edx, [eax]

* Reference to method TStringList.GetCount()
|
005F20B4   FF5214                 call    dword ptr [edx+$14]
005F20B7   8BD8                   mov     ebx, eax
005F20B9   4B                     dec     ebx
005F20BA   85DB                   test    ebx, ebx
005F20BC   7C53                   jl      005F2111
005F20BE   43                     inc     ebx
005F20BF   33F6                   xor     esi, esi

* Reference to pointer to GlobalVar_0061DF08
|
005F20C1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F20C6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005F20C8   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005F20CE   E851D6EBFF             call    004AF724
005F20D3   8D4DB8                 lea     ecx, [ebp-$48]
005F20D6   8BD6                   mov     edx, esi
005F20D8   8B45F8                 mov     eax, [ebp-$08]
005F20DB   8B38                   mov     edi, [eax]

* Reference to method TStringList.Get(Integer)
|
005F20DD   FF570C                 call    dword ptr [edi+$0C]
005F20E0   8B55B8                 mov     edx, [ebp-$48]

* Reference to pointer to GlobalVar_0061DF08
|
005F20E3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F20E8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01E8
|
005F20EA   8B80E8010000           mov     eax, [eax+$01E8]
005F20F0   8B08                   mov     ecx, [eax]
005F20F2   FF91B0000000           call    dword ptr [ecx+$00B0]

* Reference to pointer to GlobalVar_0061DF08
|
005F20F8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F20FD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005F20FF   8B80E0000000           mov     eax, [eax+$00E0]
005F2105   8B10                   mov     edx, [eax]
005F2107   FF9248020000           call    dword ptr [edx+$0248]
005F210D   46                     inc     esi
005F210E   4B                     dec     ebx
005F210F   75B0                   jnz     005F20C1

* Reference to pointer to GlobalVar_0061DF10
|
005F2111   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005F2116   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
005F2118   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to field TLabel.OFFS_02BC
|
005F211E   8B80BC020000           mov     eax, [eax+$02BC]
005F2124   BA02000000             mov     edx, $00000002

* Reference to: QuickRpt.TQRPage.SetColumns(TQRPage;Integer);
|
005F2129   E86A36F2FF             call    00515798
005F212E   8B4DF0                 mov     ecx, [ebp-$10]
005F2131   8B1530595302           mov     edx, [$02535930]

* Reference to Form1
|
005F2137   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.druck()
|
005F213A   E855D2FFFF             call    005EF394

* Reference to pointer to GlobalVar_0061DF08
|
005F213F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F2144   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005F2146   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005F214C   E837ABEBFF             call    004ACC88
005F2151   33C0                   xor     eax, eax
005F2153   55                     push    ebp

* Possible String Reference to: '� ����$�����a'
|
005F2154   6871215F00             push    $005F2171

***** TRY
|
005F2159   64FF30                 push    dword ptr fs:[eax]
005F215C   648920                 mov     fs:[eax], esp
005F215F   8B45F8                 mov     eax, [ebp-$08]

* Reference to: System.TObject.Free(TObject);
|
005F2162   E8D11BE1FF             call    00403D38
005F2167   33C0                   xor     eax, eax
005F2169   5A                     pop     edx
005F216A   59                     pop     ecx
005F216B   59                     pop     ecx
005F216C   648910                 mov     fs:[eax], edx
005F216F   EB0A                   jmp     005F217B

* Reference to: System.@HandleAnyException;
|
005F2171   E9A220E1FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005F2176   E8C924E1FF             call    00404644

****** END
|
* Reference to TScreen instance
|
005F217B   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005F2180   8B00                   mov     eax, [eax]
005F2182   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005F2184   E81390E7FF             call    0046B19C

* Reference to pointer to GlobalVar_0061DF10
|
005F2189   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005F218E   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
005F2190   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to: QuickRpt.TCustomQuickRep.Preview(TCustomQuickRep);
|
005F2196   E8B575F2FF             call    00519750
005F219B   33C0                   xor     eax, eax
005F219D   5A                     pop     edx
005F219E   59                     pop     ecx
005F219F   59                     pop     ecx
005F21A0   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005F21A3   68CA215F00             push    $005F21CA
005F21A8   8D45B8                 lea     eax, [ebp-$48]
005F21AB   BA0C000000             mov     edx, $0000000C

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005F21B0   E8D729E1FF             call    00404B8C
005F21B5   8D45F0                 lea     eax, [ebp-$10]
005F21B8   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005F21BD   E8CA29E1FF             call    00404B8C
005F21C2   C3                     ret


* Reference to: System.@HandleFinally;
|
005F21C3   E90423E1FF             jmp     004044CC
005F21C8   EBDE                   jmp     005F21A8

****** END
|
005F21CA   5F                     pop     edi
005F21CB   5E                     pop     esi
005F21CC   5B                     pop     ebx
005F21CD   8BE5                   mov     esp, ebp
005F21CF   5D                     pop     ebp
005F21D0   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.Probandenname1
    (TMenuItem); TForm1.TabSheet2 (TTabSheet)
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);; method
    TMenuItem.Click()
Strings/files/dialog text: 'OLAP'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.allePersonen2Click(Sender : TObject);
begin
(*
005F2284   53                     push    ebx
005F2285   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005F2287   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005F228D   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005F2293   E820DBE8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005F2298   8B831C060000           mov     eax, [ebx+$061C]
005F229E   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005F22A0   FF5244                 call    dword ptr [edx+$44]
005F22A3   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'OLAP'
|
005F22A8   BAC8225F00             mov     edx, $005F22C8

* Reference to: System.@LStrAsg(void;void;void;void);
|
005F22AD   E80A29E1FF             call    00404BBC

* Reference to control TForm1.Probandenname1 : TMenuItem
|
005F22B2   8B83AC060000           mov     eax, [ebx+$06AC]
005F22B8   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005F22BA   FF5244                 call    dword ptr [edx+$44]
005F22BD   5B                     pop     ebx
005F22BE   C3                     ret

*)
end;

procedure TForm1.FamGrafik1Click(Sender : TObject);
begin
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  Unit11.Form11.Show;
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.Label19 (TLabel); TForm1.PageControl1 (TPageControl);
    TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Last(TDataSet);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_0534
Project calls: TForm1.anzeigen(); TForm1.listen_akt()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetVisible(TControl;Boolean);; Controls.TControl.Show(TControl);;
    Forms.TScreen.SetCursor(TScreen;TCursor);; method TMenuItem.Click(); TScreen instance
Strings/files/dialog text: '� �����<�a'; '�<�a'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Listenaktualisieren1Click(Sender : TObject);
begin
(*
005FA604   55                     push    ebp
005FA605   8BEC                   mov     ebp, esp
005FA607   83C4F0                 add     esp, -$10
005FA60A   8945FC                 mov     [ebp-$04], eax

* Reference to Form1
|
005FA60D   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FA610   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005FA616   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FA619   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FA61F   E89457E8FF             call    0047FDB8

* Reference to pointer to GlobalVar_0061DF08
|
005FA624   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FA629   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FA62B   8B8034050000           mov     eax, [eax+$0534]
005FA631   8B10                   mov     edx, [eax]
005FA633   FF5258                 call    dword ptr [edx+$58]
005FA636   8945F8                 mov     [ebp-$08], eax

* Reference to Form1
|
005FA639   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.aus1 : TMenuItem
|
005FA63C   8B801C060000           mov     eax, [eax+$061C]
005FA642   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FA644   FF5244                 call    dword ptr [edx+$44]
005FA647   33C0                   xor     eax, eax
005FA649   55                     push    ebp

* Possible String Reference to: '� �����<�a'
|
005FA64A   68A7A65F00             push    $005FA6A7

***** TRY
|
005FA64F   64FF30                 push    dword ptr fs:[eax]
005FA652   648920                 mov     fs:[eax], esp

* Reference to TScreen instance
|
005FA655   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005FA65A   8B00                   mov     eax, [eax]
005FA65C   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005FA660   E8370BE7FF             call    0046B19C

* Reference to Form1
|
005FA665   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005FA668   8B8004040000           mov     eax, [eax+$0404]

* Reference to: Controls.TControl.Show(TControl);
|
005FA66E   E8D128E5FF             call    0044CF44

* Reference to Form1
|
005FA673   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.listen_akt()
|
005FA676   E8D958FFFF             call    005EFF54

* Reference to Form1
|
005FA67B   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005FA67E   8B8004040000           mov     eax, [eax+$0404]
005FA684   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FA686   E89922E5FF             call    0044C924
005FA68B   33C0                   xor     eax, eax
005FA68D   5A                     pop     edx
005FA68E   59                     pop     ecx
005FA68F   59                     pop     ecx
005FA690   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '�<�a'
|
005FA693   68AEA65F00             push    $005FA6AE

* Reference to TScreen instance
|
005FA698   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005FA69D   8B00                   mov     eax, [eax]
005FA69F   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005FA6A1   E8F60AE7FF             call    0046B19C
005FA6A6   C3                     ret


* Reference to: System.@HandleFinally;
|
005FA6A7   E9209EE0FF             jmp     004044CC
005FA6AC   EBEA                   jmp     005FA698

****** END
|
* Reference to pointer to GlobalVar_0061DF08
|
005FA6AE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FA6B3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FA6B5   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Last(TDataSet);
|
005FA6B8   E8EF4BEBFF             call    004AF2AC

* Reference to pointer to GlobalVar_0061DF08
|
005FA6BD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FA6C2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FA6C4   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005FA6C7   E8084BEBFF             call    004AF1D4
005FA6CC   8B45F8                 mov     eax, [ebp-$08]
005FA6CF   8945F0                 mov     [ebp-$10], eax
005FA6D2   C645F400               mov     byte ptr [ebp-$0C], $00
005FA6D6   8D55F0                 lea     edx, [ebp-$10]

* Reference to pointer to GlobalVar_0061DF08
|
005FA6D9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FA6DE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FA6E0   8B405C                 mov     eax, [eax+$5C]
005FA6E3   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FA6E5   E87A8BEDFF             call    004D3264

* Reference to Form1
|
005FA6EA   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.anzeigen()
|
005FA6ED   E8AA9CFDFF             call    005D439C
005FA6F2   8BE5                   mov     esp, ebp
005FA6F4   5D                     pop     ebp
005FA6F5   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem)
Project calls: TForm1.Famblatt()
Framework/API calls: method TMenuItem.Click()
Strings/files/dialog text: 'famb'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Familienblatt2Click(Sender : TObject);
begin
(*
005FA9E4   53                     push    ebx
005FA9E5   56                     push    esi
005FA9E6   8BF2                   mov     esi, edx
005FA9E8   8BD8                   mov     ebx, eax
005FA9EA   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'famb'
|
005FA9EF   BA60AA5F00             mov     edx, $005FAA60

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FA9F4   E8C3A1E0FF             call    00404BBC
005FA9F9   B8585B5302             mov     eax, $02535B58

* Reference to: System.@LStrClr(void;void);
|
005FA9FE   E865A1E0FF             call    00404B68
005FAA03   B8385B5302             mov     eax, $02535B38

* Reference to: System.@LStrClr(void;void);
|
005FAA08   E85BA1E0FF             call    00404B68
005FAA0D   B83C5B5302             mov     eax, $02535B3C

* Reference to: System.@LStrClr(void;void);
|
005FAA12   E851A1E0FF             call    00404B68
005FAA17   B8405B5302             mov     eax, $02535B40

* Reference to: System.@LStrClr(void;void);
|
005FAA1C   E847A1E0FF             call    00404B68
005FAA21   B8445B5302             mov     eax, $02535B44

* Reference to: System.@LStrClr(void;void);
|
005FAA26   E83DA1E0FF             call    00404B68
005FAA2B   B8485B5302             mov     eax, $02535B48

* Reference to: System.@LStrClr(void;void);
|
005FAA30   E833A1E0FF             call    00404B68
005FAA35   B84C5B5302             mov     eax, $02535B4C

* Reference to: System.@LStrClr(void;void);
|
005FAA3A   E829A1E0FF             call    00404B68

* Reference to control TForm1.aus1 : TMenuItem
|
005FAA3F   8B831C060000           mov     eax, [ebx+$061C]
005FAA45   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FAA47   FF5244                 call    dword ptr [edx+$44]
005FAA4A   8BD6                   mov     edx, esi
005FAA4C   8BC3                   mov     eax, ebx

* Reference to : TForm1.Famblatt()
|
005FAA4E   E815000000             call    005FAA68
005FAA53   5E                     pop     esi
005FAA54   5B                     pop     ebx
005FAA55   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061E0BC; GlobalVar_0061E0C0; GlobalVar_0061E0C8; GlobalVar_025353D8
Unresolved field offsets: OFFS_00E8
Project calls: TForm1.speich1(); TForm3.ofb2()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);; method
    TMenuItem.Click()
Strings/files/dialog text: 'butt8'; 'OFB'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.OFBDruck1Click(Sender : TObject);
begin
(*
005FBB64   53                     push    ebx
005FBB65   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FBB67   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FBB6D   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FBB73   E84042E8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005FBB78   8B831C060000           mov     eax, [ebx+$061C]
005FBB7E   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FBB80   FF5244                 call    dword ptr [edx+$44]
005FBB83   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005FBB85   E812BEFDFF             call    005D799C
005FBB8A   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'OFB'
|
005FBB8F   BAE4BB5F00             mov     edx, $005FBBE4

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FBB94   E82390E0FF             call    00404BBC

* Reference to pointer to GlobalVar_0061E0BC
|
005FBB99   A1C0CB6100             mov     eax, dword ptr [$0061CBC0]
005FBB9E   33D2                   xor     edx, edx
005FBBA0   8910                   mov     [eax], edx

* Reference to pointer to GlobalVar_0061E0C0
|
005FBBA2   A110C56100             mov     eax, dword ptr [$0061C510]
005FBBA7   33D2                   xor     edx, edx
005FBBA9   8910                   mov     [eax], edx

* Reference to pointer to GlobalVar_0061E0C8
|
005FBBAB   A130C36100             mov     eax, dword ptr [$0061C330]
005FBBB0   8B00                   mov     eax, [eax]
005FBBB2   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061E0C8.OFFS_00E8
|
005FBBB4   FF92E8000000           call    dword ptr [edx+$00E8]
005FBBBA   A1505B5302             mov     eax, dword ptr [$02535B50]

* Possible String Reference to: 'butt8'
|
005FBBBF   BAF0BB5F00             mov     edx, $005FBBF0

* Reference to: System.@LStrCmp;
|
005FBBC4   E89B93E0FF             call    00404F64
005FBBC9   740C                   jz      005FBBD7

* Reference to pointer to GlobalVar_025353D8
|
005FBBCB   A168C86100             mov     eax, dword ptr [$0061C868]
005FBBD0   8B00                   mov     eax, [eax]

* Reference to : TForm3.ofb2()
|
005FBBD2   E88D0FF9FF             call    0058CB64
005FBBD7   5B                     pop     ebx
005FBBD8   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Label9 (TLabel); TForm1.aus1 (TMenuItem)
Global state: GlobalVar_0061DFC8
Unresolved field offsets: OFFS_00E8; OFFS_0334
Project calls: Unit_00408494.Proc_00409CD0; Unit_00408494.Proc_00409F2C
Framework/API calls: Controls.TControl.Show(TControl);; method TMenuItem.Click()
Strings/files/dialog text: 'fambl.htm'; 'Fbml'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.FamilienblattHTML1Click(Sender : TObject);
begin
(*
00602190   53                     push    ebx
00602191   8BD8                   mov     ebx, eax
00602193   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Fbml'
|
00602198   BA48226000             mov     edx, $00602248

* Reference to: System.@LStrAsg(void;void;void;void);
|
0060219D   E81A2AE0FF             call    00404BBC
006021A2   B8585B5302             mov     eax, $02535B58

* Reference to: System.@LStrClr(void;void);
|
006021A7   E8BC29E0FF             call    00404B68
006021AC   B8385B5302             mov     eax, $02535B38

* Reference to: System.@LStrClr(void;void);
|
006021B1   E8B229E0FF             call    00404B68
006021B6   B83C5B5302             mov     eax, $02535B3C

* Reference to: System.@LStrClr(void;void);
|
006021BB   E8A829E0FF             call    00404B68
006021C0   B8405B5302             mov     eax, $02535B40

* Reference to: System.@LStrClr(void;void);
|
006021C5   E89E29E0FF             call    00404B68
006021CA   B8445B5302             mov     eax, $02535B44

* Reference to: System.@LStrClr(void;void);
|
006021CF   E89429E0FF             call    00404B68
006021D4   B8485B5302             mov     eax, $02535B48

* Reference to: System.@LStrClr(void;void);
|
006021D9   E88A29E0FF             call    00404B68
006021DE   B84C5B5302             mov     eax, $02535B4C

* Reference to: System.@LStrClr(void;void);
|
006021E3   E88029E0FF             call    00404B68

* Reference to control TForm1.aus1 : TMenuItem
|
006021E8   8B831C060000           mov     eax, [ebx+$061C]
006021EE   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
006021F0   FF5244                 call    dword ptr [edx+$44]

* Possible String Reference to: 'fambl.htm'
|
006021F3   B858226000             mov     eax, $00602258

* Reference to: Unit_00408494.Proc_00409CD0
|
006021F8   E8D37AE0FF             call    00409CD0
006021FD   84C0                   test    al, al
006021FF   740A                   jz      0060220B

* Possible String Reference to: 'fambl.htm'
|
00602201   B858226000             mov     eax, $00602258

* Reference to: Unit_00408494.Proc_00409F2C
|
00602206   E8217DE0FF             call    00409F2C

* Reference to pointer to GlobalVar_0061DFC8
|
0060220B   A19CCC6100             mov     eax, dword ptr [$0061CC9C]
00602210   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DFC8.OFFS_0334
|
00602212   8B8034030000           mov     eax, [eax+$0334]

* Reference to: Controls.TControl.Show(TControl);
|
00602218   E827ADE4FF             call    0044CF44

* Reference to pointer to GlobalVar_0061DFC8
|
0060221D   A19CCC6100             mov     eax, dword ptr [$0061CC9C]
00602222   8B00                   mov     eax, [eax]

* Reference to control Label9 : TLabel
|
00602224   8B8010030000           mov     eax, [eax+$0310]

* Reference to: Controls.TControl.Show(TControl);
|
0060222A   E815ADE4FF             call    0044CF44

* Reference to pointer to GlobalVar_0061DFC8
|
0060222F   A19CCC6100             mov     eax, dword ptr [$0061CC9C]
00602234   8B00                   mov     eax, [eax]
00602236   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061DFC8.OFFS_00E8
|
00602238   FF92E8000000           call    dword ptr [edx+$00E8]
0060223E   5B                     pop     ebx
0060223F   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Open(TDataSet);;
    DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_0061DFAC; GlobalVar_0061DFB4
Unresolved field offsets: OFFS_00CC; OFFS_00E8; OFFS_034C
Project calls: Unit_00408494.Proc_00409448
Framework/API calls: Controls.TControl.SetText(TControl;TCaption);;
    Forms.TCustomForm.Show(TCustomForm);
Strings/files/dialog text: 'Aktueller Orts-Name: '; 'ort_'; '�e!�����]�'; '��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.OrtsDatei1Click(Sender : TObject);
begin
(*
00602264   55                     push    ebp
00602265   8BEC                   mov     ebp, esp
00602267   83C4F0                 add     esp, -$10
0060226A   33C9                   xor     ecx, ecx
0060226C   894DF0                 mov     [ebp-$10], ecx
0060226F   894DFC                 mov     [ebp-$04], ecx
00602272   33C0                   xor     eax, eax
00602274   55                     push    ebp

* Possible String Reference to: '�e!�����]�'
|
00602275   6862236000             push    $00602362

***** TRY
|
0060227A   64FF30                 push    dword ptr fs:[eax]
0060227D   648920                 mov     fs:[eax], esp

* Reference to pointer to GlobalVar_0061DF08
|
00602280   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00602285   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
00602287   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
0060228D   E8F6A9EAFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
00602292   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00602297   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
00602299   8B80CC000000           mov     eax, [eax+$00CC]

* Possible String Reference to: 'ort_'
|
0060229F   BA78236000             mov     edx, $00602378

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006022A4   E8B308EDFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
006022A9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
006022AE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
006022B0   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.First(TDataSet);
|
006022B6   E819CFEAFF             call    004AF1D4
006022BB   8D55FC                 lea     edx, [ebp-$04]
006022BE   A1605B5302             mov     eax, dword ptr [$02535B60]

* Reference to: Unit_00408494.Proc_00409448
|
006022C3   E88071E0FF             call    00409448
006022C8   837DFC00               cmp     dword ptr [ebp-$04], +$00
006022CC   765D                   jbe     0060232B
006022CE   A1605B5302             mov     eax, dword ptr [$02535B60]
006022D3   8945F4                 mov     [ebp-$0C], eax
006022D6   C645F80B               mov     byte ptr [ebp-$08], $0B
006022DA   8D55F4                 lea     edx, [ebp-$0C]

* Reference to pointer to GlobalVar_0061DF08
|
006022DD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
006022E2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
006022E4   8B80CC000000           mov     eax, [eax+$00CC]
006022EA   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
006022EC   E8730FEDFF             call    004D3264
006022F1   84C0                   test    al, al
006022F3   7445                   jz      0060233A
006022F5   8D45F0                 lea     eax, [ebp-$10]
006022F8   8B0D605B5302           mov     ecx, [$02535B60]

* Possible String Reference to: 'Aktueller Orts-Name: '
|
006022FE   BA88236000             mov     edx, $00602388

* Reference to: System.@LStrCat3;
|
00602303   E8642BE0FF             call    00404E6C
00602308   8B55F0                 mov     edx, [ebp-$10]

* Reference to pointer to GlobalVar_0061DFAC
|
0060230B   A134C26100             mov     eax, dword ptr [$0061C234]
00602310   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DFAC.OFFS_034C
|
00602312   8B804C030000           mov     eax, [eax+$034C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
00602318   E817A7E4FF             call    0044CA34

* Reference to pointer to GlobalVar_0061DFAC
|
0060231D   A134C26100             mov     eax, dword ptr [$0061C234]
00602322   8B00                   mov     eax, [eax]

* Reference to: Forms.TCustomForm.Show(TCustomForm);
|
00602324   E81379E6FF             call    00469C3C
00602329   EB0F                   jmp     0060233A

* Reference to pointer to GlobalVar_0061DFB4
|
0060232B   A1C8C26100             mov     eax, dword ptr [$0061C2C8]
00602330   8B00                   mov     eax, [eax]
00602332   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061DFB4.OFFS_00E8
|
00602334   FF92E8000000           call    dword ptr [edx+$00E8]
0060233A   B8605B5302             mov     eax, $02535B60

* Reference to: System.@LStrClr(void;void);
|
0060233F   E82428E0FF             call    00404B68
00602344   33C0                   xor     eax, eax
00602346   5A                     pop     edx
00602347   59                     pop     ecx
00602348   59                     pop     ecx
00602349   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '��]�'
|
0060234C   6869236000             push    $00602369
00602351   8D45F0                 lea     eax, [ebp-$10]

* Reference to: System.@LStrClr(void;void);
|
00602354   E80F28E0FF             call    00404B68
00602359   8D45FC                 lea     eax, [ebp-$04]

* Reference to: System.@LStrClr(void;void);
|
0060235C   E80728E0FF             call    00404B68
00602361   C3                     ret


* Reference to: System.@HandleFinally;
|
00602362   E96521E0FF             jmp     004044CC
00602367   EBE8                   jmp     00602351

****** END
|
00602369   8BE5                   mov     esp, ebp
0060236B   5D                     pop     ebp
0060236C   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Open(TDataSet);
Global state: GlobalVar_0061DF08; GlobalVar_02535398
Unresolved field offsets: OFFS_00C8; OFFS_00E8
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.NamensListeeditieren1Click(Sender : TObject);
begin
(*

* Reference to pointer to GlobalVar_0061DF08
|
00602ADC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00602AE1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
00602AE3   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
00602AE9   E89AA1EAFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
00602AEE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00602AF3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
00602AF5   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.First(TDataSet);
|
00602AFB   E8D4C6EAFF             call    004AF1D4

* Reference to pointer to GlobalVar_02535398
|
00602B00   A120C26100             mov     eax, dword ptr [$0061C220]
00602B05   8B00                   mov     eax, [eax]
00602B07   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_02535398.OFFS_00E8
|
00602B09   FF92E8000000           call    dword ptr [edx+$00E8]
00602B0F   C3                     ret

*)
end;

procedure TForm1.QuellenListeeditieren1Click(Sender : TObject);
begin
  Unit29.Form29.Show;
end;

procedure TForm1.BerufeVerwaltung1Click(Sender : TObject);
begin
  Unit36.Form36.Show;
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Label1 (TLabel)
Database/provider: DB.TDataSet.Append(TDataSet);; DB.TDataSet.Close(TDataSet);;
    DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);; DB.TDataSet.Open(TDataSet);;
    DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.EmptyTable(TTable);
Global state: GlobalVar_0061DF08; GlobalVar_0061DF10
Unresolved field offsets: OFFS_02BC; OFFS_0530
Project calls: TForm1.druck()
Framework/API calls: Dialogs.ShowMessage(AnsiString);; Forms.TScreen.SetCursor(TScreen;TCursor);;
    QuickRpt.TCustomQuickRep.Preview(TCustomQuickRep);;
    QuickRpt.TQRPage.SetColumns(TQRPage;Integer);; TScreen instance
Strings/files/dialog text: '^[Y]�'; 'Keine Quellenangaben verf�gbar.'; 'QL'; 'Quellenliste'; 'tit';
    '��e����^[Y]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Quellenliste1Click(Sender : TObject);
begin
(*
0060DCF4   55                     push    ebp
0060DCF5   8BEC                   mov     ebp, esp
0060DCF7   6A00                   push    $00
0060DCF9   53                     push    ebx
0060DCFA   56                     push    esi
0060DCFB   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
0060DCFD   8B1D3CCC6100           mov     ebx, [$0061CC3C]
0060DD03   33C0                   xor     eax, eax
0060DD05   55                     push    ebp

* Possible String Reference to: '��e����^[Y]�'
|
0060DD06   68E2DE6000             push    $0060DEE2

***** TRY
|
0060DD0B   64FF30                 push    dword ptr fs:[eax]
0060DD0E   648920                 mov     fs:[eax], esp
0060DD11   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'QL'
|
0060DD16   BAF8DE6000             mov     edx, $0060DEF8

* Reference to: System.@LStrAsg(void;void;void;void);
|
0060DD1B   E89C6EDFFF             call    00404BBC
0060DD20   B830595302             mov     eax, $02535930

* Possible String Reference to: 'Quellenliste'
|
0060DD25   BA04DF6000             mov     edx, $0060DF04

* Reference to: System.@LStrAsg(void;void;void;void);
|
0060DD2A   E88D6EDFFF             call    00404BBC
0060DD2F   B834595302             mov     eax, $02535934

* Reference to: System.@LStrClr(void;void);
|
0060DD34   E82F6EDFFF             call    00404B68

* Reference to TScreen instance
|
0060DD39   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
0060DD3E   8B00                   mov     eax, [eax]
0060DD40   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
0060DD44   E853D4E5FF             call    0046B19C
0060DD49   8B03                   mov     eax, [ebx]

* Reference to field TScreen.OFFS_0530
|
0060DD4B   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DB.TDataSet.Open(TDataSet);
|
0060DD51   E832EFE9FF             call    004ACC88
0060DD56   8B03                   mov     eax, [ebx]
0060DD58   8B8030050000           mov     eax, [eax+$0530]

* Possible String Reference to: 'tit'
|
0060DD5E   BA1CDF6000             mov     edx, $0060DF1C

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060DD63   E8F44DECFF             call    004D2B5C
0060DD68   8B03                   mov     eax, [ebx]
0060DD6A   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060DD70   E85F14EAFF             call    004AF1D4
0060DD75   8B03                   mov     eax, [ebx]
0060DD77   8B8030050000           mov     eax, [eax+$0530]
0060DD7D   8B10                   mov     edx, [eax]
0060DD7F   FF924C010000           call    dword ptr [edx+$014C]
0060DD85   85C0                   test    eax, eax
0060DD87   750F                   jnz     0060DD98

* Possible String Reference to: 'Keine Quellenangaben verf�gbar.'
|
0060DD89   B828DF6000             mov     eax, $0060DF28

* Reference to: Dialogs.ShowMessage(AnsiString);
|
0060DD8E   E8517AE3FF             call    004457E4
0060DD93   E934010000             jmp     0060DECC
0060DD98   8B03                   mov     eax, [ebx]
0060DD9A   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
0060DDA0   E8E3EEE9FF             call    004ACC88
0060DDA5   8B03                   mov     eax, [ebx]
0060DDA7   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Close(TDataSet);
|
0060DDAD   E8E2EEE9FF             call    004ACC94
0060DDB2   8B03                   mov     eax, [ebx]
0060DDB4   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
0060DDBA   E81D62ECFF             call    004D3FDC
0060DDBF   8B03                   mov     eax, [ebx]
0060DDC1   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
0060DDC7   E8BCEEE9FF             call    004ACC88
0060DDCC   8B03                   mov     eax, [ebx]
0060DDCE   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
0060DDD4   E84B19EAFF             call    004AF724
0060DDD9   8B03                   mov     eax, [ebx]
0060DDDB   8B80E8010000           mov     eax, [eax+$01E8]
0060DDE1   BA50DF6000             mov     edx, $0060DF50
0060DDE6   8B08                   mov     ecx, [eax]
0060DDE8   FF91B0000000           call    dword ptr [ecx+$00B0]
0060DDEE   8B03                   mov     eax, [ebx]
0060DDF0   8B80E0000000           mov     eax, [eax+$00E0]
0060DDF6   8B10                   mov     edx, [eax]
0060DDF8   FF9248020000           call    dword ptr [edx+$0248]
0060DDFE   EB5E                   jmp     0060DE5E
0060DE00   8B03                   mov     eax, [ebx]
0060DE02   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
0060DE08   E81719EAFF             call    004AF724
0060DE0D   8D55FC                 lea     edx, [ebp-$04]
0060DE10   8B03                   mov     eax, [ebx]
0060DE12   8B80180A0000           mov     eax, [eax+$0A18]
0060DE18   8B08                   mov     ecx, [eax]
0060DE1A   FF5160                 call    dword ptr [ecx+$60]
0060DE1D   8B55FC                 mov     edx, [ebp-$04]
0060DE20   8B03                   mov     eax, [ebx]
0060DE22   8B80E8010000           mov     eax, [eax+$01E8]
0060DE28   8B08                   mov     ecx, [eax]
0060DE2A   FF91B0000000           call    dword ptr [ecx+$00B0]
0060DE30   8B03                   mov     eax, [ebx]
0060DE32   8B80E0000000           mov     eax, [eax+$00E0]
0060DE38   8B10                   mov     edx, [eax]
0060DE3A   FF9248020000           call    dword ptr [edx+$0248]
0060DE40   8B03                   mov     eax, [ebx]
0060DE42   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060DE48   E89F16EAFF             call    004AF4EC
0060DE4D   8B03                   mov     eax, [ebx]
0060DE4F   8B8030050000           mov     eax, [eax+$0530]
0060DE55   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060DE5C   7511                   jnz     0060DE6F
0060DE5E   8B03                   mov     eax, [ebx]
0060DE60   8B8030050000           mov     eax, [eax+$0530]
0060DE66   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060DE6D   7491                   jz      0060DE00

* Reference to pointer to GlobalVar_0061DF10
|
0060DE6F   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
0060DE74   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
0060DE76   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to field TLabel.OFFS_02BC
|
0060DE7C   8B80BC020000           mov     eax, [eax+$02BC]
0060DE82   BA01000000             mov     edx, $00000001

* Reference to: QuickRpt.TQRPage.SetColumns(TQRPage;Integer);
|
0060DE87   E80C79F0FF             call    00515798
0060DE8C   8B0D34595302           mov     ecx, [$02535934]
0060DE92   8B1530595302           mov     edx, [$02535930]
0060DE98   8BC6                   mov     eax, esi

* Reference to : TForm1.druck()
|
0060DE9A   E8F514FEFF             call    005EF394
0060DE9F   8B03                   mov     eax, [ebx]

* Reference to field TForm1.OnMouseUp : TMouseEvent
|
0060DEA1   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
0060DEA7   E8DCEDE9FF             call    004ACC88

* Reference to TScreen instance
|
0060DEAC   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
0060DEB1   8B00                   mov     eax, [eax]
0060DEB3   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
0060DEB5   E8E2D2E5FF             call    0046B19C

* Reference to pointer to GlobalVar_0061DF10
|
0060DEBA   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
0060DEBF   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
0060DEC1   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to: QuickRpt.TCustomQuickRep.Preview(TCustomQuickRep);
|
0060DEC7   E884B8F0FF             call    00519750
0060DECC   33C0                   xor     eax, eax
0060DECE   5A                     pop     edx
0060DECF   59                     pop     ecx
0060DED0   59                     pop     ecx
0060DED1   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '^[Y]�'
|
0060DED4   68E9DE6000             push    $0060DEE9
0060DED9   8D45FC                 lea     eax, [ebp-$04]

* Reference to: System.@LStrClr(void;void);
|
0060DEDC   E8876CDFFF             call    00404B68
0060DEE1   C3                     ret


* Reference to: System.@HandleFinally;
|
0060DEE2   E9E565DFFF             jmp     004044CC
0060DEE7   EBF0                   jmp     0060DED9

****** END
|
0060DEE9   5E                     pop     esi
0060DEEA   5B                     pop     ebx
0060DEEB   59                     pop     ecx
0060DEEC   5D                     pop     ebp
0060DEED   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Open(TDataSet);
Global state: GlobalVar_0061DF08; GlobalVar_025353C8
Unresolved field offsets: OFFS_00E8; OFFS_0520
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.HofnamenVerwaltung1Click(Sender : TObject);
begin
(*

* Reference to pointer to GlobalVar_0061DF08
|
0060E364   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
0060E369   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0520
|
0060E36B   8B8020050000           mov     eax, [eax+$0520]

* Reference to: DB.TDataSet.Open(TDataSet);
|
0060E371   E812E9E9FF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
0060E376   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
0060E37B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0520
|
0060E37D   8B8020050000           mov     eax, [eax+$0520]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060E383   E84C0EEAFF             call    004AF1D4

* Reference to pointer to GlobalVar_025353C8
|
0060E388   A18CC36100             mov     eax, dword ptr [$0061C38C]
0060E38D   8B00                   mov     eax, [eax]
0060E38F   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_025353C8.OFFS_00E8
|
0060E391   FF92E8000000           call    dword ptr [edx+$00E8]
0060E397   C3                     ret

*)
end;

