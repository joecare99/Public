{ TForm1 menu-area implementations: FilterAndInfo; LFM-bound method names remain on TForm1. }

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.DBText1 (TDBText); TForm1.ID1 (TMenuItem);
    TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_05C0
Project calls: TForm1.anzeigen(); TForm1.tabdisab(); TForm1.tabenab(); Unit_00408494.Proc_00409448;
    Unit_00408494.Proc_00409500
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetColor(TControl;TColor);; Dialogs.ShowMessage(AnsiString);;
    Menus.TMenuItem.SetChecked(TMenuItem;Boolean);; method TMenuItem.Click(); System.Proc_00404EE0;
    TMessageForm._PROC_00445B24()
Strings/files/dialog text: '" nicht gefunden.'; '_^[��]�'; 'Filter'; 'Filterkriterium ID="';
    'ID-Nr.'; 'idnr='
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.ID1Click(Sender : TObject);
begin
(*
005E9990   55                     push    ebp
005E9991   8BEC                   mov     ebp, esp
005E9993   B906000000             mov     ecx, $00000006
005E9998   6A00                   push    $00
005E999A   6A00                   push    $00
005E999C   49                     dec     ecx
005E999D   75F9                   jnz     005E9998
005E999F   51                     push    ecx
005E99A0   53                     push    ebx
005E99A1   56                     push    esi
005E99A2   57                     push    edi
005E99A3   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005E99A5   8B3D3CCC6100           mov     edi, [$0061CC3C]
005E99AB   33C0                   xor     eax, eax
005E99AD   55                     push    ebp
005E99AE   68B79B5E00             push    $005E9BB7

***** TRY
|
005E99B3   64FF30                 push    dword ptr fs:[eax]
005E99B6   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005E99B9   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005E99BF   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005E99C5   E8EE63E9FF             call    0047FDB8
005E99CA   8D45FC                 lea     eax, [ebp-$04]
005E99CD   50                     push    eax
005E99CE   33C9                   xor     ecx, ecx

* Possible String Reference to: 'ID-Nr.'
|
005E99D0   BAD09B5E00             mov     edx, $005E9BD0

* Possible String Reference to: 'Filter'
|
005E99D5   B8E09B5E00             mov     eax, $005E9BE0

* Reference to : TMessageForm._PROC_00445B24()
|
005E99DA   E845C1E5FF             call    00445B24
005E99DF   8D55F4                 lea     edx, [ebp-$0C]
005E99E2   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409448
|
005E99E5   E85EFAE1FF             call    00409448
005E99EA   837DF400               cmp     dword ptr [ebp-$0C], +$00
005E99EE   0F8693010000           jbe     005E9B87
005E99F4   33DB                   xor     ebx, ebx
005E99F6   8B07                   mov     eax, [edi]
005E99F8   8B8034050000           mov     eax, [eax+$0534]
005E99FE   8B10                   mov     edx, [eax]
005E9A00   FF5258                 call    dword ptr [edx+$58]
005E9A03   8945F8                 mov     [ebp-$08], eax
005E9A06   8BC6                   mov     eax, esi

* Reference to : TForm1.tabdisab()
|
005E9A08   E827EEFEFF             call    005D8834
005E9A0D   8B07                   mov     eax, [edi]

* Reference to field TForm1.AutoSize : Boolean
|
005E9A0F   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005E9A12   E8BD57ECFF             call    004AF1D4
005E9A17   EB51                   jmp     005E9A6A
005E9A19   8D55EC                 lea     edx, [ebp-$14]
005E9A1C   8B07                   mov     eax, [edi]

* Reference to field Boolean.OFFS_05C0
|
005E9A1E   8B80C0050000           mov     eax, [eax+$05C0]
005E9A24   8B08                   mov     ecx, [eax]
005E9A26   FF5160                 call    dword ptr [ecx+$60]
005E9A29   8B45EC                 mov     eax, [ebp-$14]
005E9A2C   8D55F0                 lea     edx, [ebp-$10]

* Reference to: Unit_00408494.Proc_00409448
|
005E9A2F   E814FAE1FF             call    00409448
005E9A34   8B45F0                 mov     eax, [ebp-$10]
005E9A37   50                     push    eax
005E9A38   8D55E8                 lea     edx, [ebp-$18]
005E9A3B   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409448
|
005E9A3E   E805FAE1FF             call    00409448
005E9A43   8B55E8                 mov     edx, [ebp-$18]
005E9A46   58                     pop     eax

* Reference to: System.@LStrCmp;
|
005E9A47   E818B5E1FF             call    00404F64
005E9A4C   7504                   jnz     005E9A52
005E9A4E   B301                   mov     bl, $01
005E9A50   EB26                   jmp     005E9A78
005E9A52   8B07                   mov     eax, [edi]
005E9A54   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005E9A57   E8905AECFF             call    004AF4EC
005E9A5C   8B07                   mov     eax, [edi]
005E9A5E   8B405C                 mov     eax, [eax+$5C]
005E9A61   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005E9A68   750E                   jnz     005E9A78
005E9A6A   8B07                   mov     eax, [edi]
005E9A6C   8B405C                 mov     eax, [eax+$5C]
005E9A6F   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005E9A76   74A1                   jz      005E9A19
005E9A78   8BC6                   mov     eax, esi

* Reference to : TForm1.tabenab()
|
005E9A7A   E8D9EDFEFF             call    005D8858

* Reference to Form1
|
005E9A7F   8B45F8                 mov     eax, [ebp-$08]
005E9A82   8945E0                 mov     [ebp-$20], eax
005E9A85   C645E400               mov     byte ptr [ebp-$1C], $00
005E9A89   8D55E0                 lea     edx, [ebp-$20]
005E9A8C   8B07                   mov     eax, [edi]

* Reference to field Form1.OFFS_005C
|
005E9A8E   8B405C                 mov     eax, [eax+$5C]
005E9A91   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005E9A93   E8CC97EEFF             call    004D3264
005E9A98   80FB01                 cmp     bl, $01
005E9A9B   0F85AB000000           jnz     005E9B4C

* Reference to control TForm1.aus1 : TMenuItem
|
005E9AA1   8B861C060000           mov     eax, [esi+$061C]
005E9AA7   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005E9AA9   FF5244                 call    dword ptr [edx+$44]
005E9AAC   B201                   mov     dl, $01

* Reference to control TForm1.ID1 : TMenuItem
|
005E9AAE   8B8614060000           mov     eax, [esi+$0614]

* Reference to: Menus.TMenuItem.SetChecked(TMenuItem;Boolean);
|
005E9AB4   E8C34CE7FF             call    0045E77C
005E9AB9   8D55D8                 lea     edx, [ebp-$28]
005E9ABC   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409500
|
005E9ABF   E83CFAE1FF             call    00409500
005E9AC4   8B4DD8                 mov     ecx, [ebp-$28]
005E9AC7   8D45DC                 lea     eax, [ebp-$24]

* Possible String Reference to: 'idnr='
|
005E9ACA   BAF09B5E00             mov     edx, $005E9BF0

* Reference to: System.@LStrCat3;
|
005E9ACF   E898B3E1FF             call    00404E6C
005E9AD4   8B55DC                 mov     edx, [ebp-$24]
005E9AD7   8B07                   mov     eax, [edi]
005E9AD9   8B405C                 mov     eax, [eax+$5C]
005E9ADC   8B08                   mov     ecx, [eax]
005E9ADE   FF9198010000           call    dword ptr [ecx+$0198]
005E9AE4   8B07                   mov     eax, [edi]
005E9AE6   8B405C                 mov     eax, [eax+$5C]
005E9AE9   B201                   mov     dl, $01
005E9AEB   8B08                   mov     ecx, [eax]
005E9AED   FF9190010000           call    dword ptr [ecx+$0190]
005E9AF3   8D55D0                 lea     edx, [ebp-$30]
005E9AF6   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409500
|
005E9AF9   E802FAE1FF             call    00409500
005E9AFE   8B4DD0                 mov     ecx, [ebp-$30]
005E9B01   8D45D4                 lea     eax, [ebp-$2C]

* Possible String Reference to: 'idnr='
|
005E9B04   BAF09B5E00             mov     edx, $005E9BF0

* Reference to: System.@LStrCat3;
|
005E9B09   E85EB3E1FF             call    00404E6C
005E9B0E   8B55D4                 mov     edx, [ebp-$2C]
005E9B11   8B07                   mov     eax, [edi]
005E9B13   8B809C000000           mov     eax, [eax+$009C]
005E9B19   8B08                   mov     ecx, [eax]
005E9B1B   FF9198010000           call    dword ptr [ecx+$0198]
005E9B21   8B07                   mov     eax, [edi]
005E9B23   8B809C000000           mov     eax, [eax+$009C]
005E9B29   B201                   mov     dl, $01
005E9B2B   8B08                   mov     ecx, [eax]
005E9B2D   FF9190010000           call    dword ptr [ecx+$0190]
005E9B33   BAFF000000             mov     edx, $000000FF

* Reference to control TForm1.DBText1 : TDBText
|
005E9B38   8B86B4070000           mov     eax, [esi+$07B4]

* Reference to: Controls.TControl.SetColor(TControl;TColor);
|
005E9B3E   E86130E6FF             call    0044CBA4
005E9B43   8BC6                   mov     eax, esi

* Reference to : TForm1.anzeigen()
|
005E9B45   E852A8FEFF             call    005D439C
005E9B4A   EB3B                   jmp     005E9B87

* Possible String Reference to: 'Filterkriterium ID="'
|
005E9B4C   68009C5E00             push    $005E9C00
005E9B51   FF75FC                 push    dword ptr [ebp-$04]

* Possible String Reference to: '" nicht gefunden.'
|
005E9B54   68209C5E00             push    $005E9C20
005E9B59   8D45CC                 lea     eax, [ebp-$34]
005E9B5C   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005E9B61   E87AB3E1FF             call    00404EE0
005E9B66   8B45CC                 mov     eax, [ebp-$34]

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005E9B69   E876BCE5FF             call    004457E4

* Reference to Form1
|
005E9B6E   8B45F8                 mov     eax, [ebp-$08]
005E9B71   8945E0                 mov     [ebp-$20], eax
005E9B74   C645E400               mov     byte ptr [ebp-$1C], $00
005E9B78   8D55E0                 lea     edx, [ebp-$20]
005E9B7B   8B07                   mov     eax, [edi]

* Reference to field Form1.OFFS_005C
|
005E9B7D   8B405C                 mov     eax, [eax+$5C]
005E9B80   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005E9B82   E8DD96EEFF             call    004D3264
005E9B87   33C0                   xor     eax, eax
005E9B89   5A                     pop     edx
005E9B8A   59                     pop     ecx
005E9B8B   59                     pop     ecx
005E9B8C   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005E9B8F   68BE9B5E00             push    $005E9BBE
005E9B94   8D45CC                 lea     eax, [ebp-$34]
005E9B97   BA05000000             mov     edx, $00000005

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E9B9C   E8EBAFE1FF             call    00404B8C
005E9BA1   8D45E8                 lea     eax, [ebp-$18]
005E9BA4   BA04000000             mov     edx, $00000004

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E9BA9   E8DEAFE1FF             call    00404B8C
005E9BAE   8D45FC                 lea     eax, [ebp-$04]

* Reference to: System.@LStrClr(void;void);
|
005E9BB1   E8B2AFE1FF             call    00404B68
005E9BB6   C3                     ret


* Reference to: System.@HandleFinally;
|
005E9BB7   E910A9E1FF             jmp     004044CC
005E9BBC   EBD6                   jmp     005E9B94

****** END
|
005E9BBE   5F                     pop     edi
005E9BBF   5E                     pop     esi
005E9BC0   5B                     pop     ebx
005E9BC1   8BE5                   mov     esp, ebp
005E9BC3   5D                     pop     ebp
005E9BC4   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.DBText1 (TDBText); TForm1.Hausname1 (TMenuItem); TForm1.ID1 (TMenuItem);
    TForm1.Label50 (TLabel); TForm1.MainMenu1 (TMainMenu); TForm1.Name1 (TMenuItem);
    TForm1.PageControl1 (TPageControl); TForm1.StringGrid5 (TStringGrid); TForm1.TabSheet2
    (TTabSheet)
Database/provider: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Unresolved field offsets: OFFS_0090; OFFS_0198
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetColor(TControl;TColor);; Controls.TControl.SetVisible(TControl;Boolean);;
    Menus.TMenuItem.GetCount(TMenuItem):Integer;;
    Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;;
    Menus.TMenuItem.SetChecked(TMenuItem;Boolean);; method TLabel.GetFloatingDockSiteClass();
    System.TObject.Free(TObject);
Strings/files/dialog text: 'drucken'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.aus1Click(Sender : TObject);
begin
(*
005E9C34   53                     push    ebx
005E9C35   56                     push    esi
005E9C36   57                     push    edi
005E9C37   55                     push    ebp
005E9C38   83C4F4                 add     esp, -$0C
005E9C3B   8BD8                   mov     ebx, eax
005E9C3D   8B2D3CCC6100           mov     ebp, [$0061CC3C]
005E9C43   8B4500                 mov     eax, [ebp+$00]

* Reference to control TForm1.Label50 : TLabel
|
005E9C46   8B8034050000           mov     eax, [eax+$0534]
005E9C4C   8B10                   mov     edx, [eax]

* Reference to method TLabel.GetFloatingDockSiteClass()
|
005E9C4E   FF5258                 call    dword ptr [edx+$58]
005E9C51   890424                 mov     [esp], eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005E9C54   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005E9C5A   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005E9C60   E85361E9FF             call    0047FDB8
005E9C65   33D2                   xor     edx, edx

* Reference to control TForm1.ID1 : TMenuItem
|
005E9C67   8B8314060000           mov     eax, [ebx+$0614]

* Reference to: Menus.TMenuItem.SetChecked(TMenuItem;Boolean);
|
005E9C6D   E80A4BE7FF             call    0045E77C
005E9C72   33D2                   xor     edx, edx

* Reference to control TForm1.Name1 : TMenuItem
|
005E9C74   8B8354060000           mov     eax, [ebx+$0654]

* Reference to: Menus.TMenuItem.SetChecked(TMenuItem;Boolean);
|
005E9C7A   E8FD4AE7FF             call    0045E77C
005E9C7F   33D2                   xor     edx, edx

* Reference to control TForm1.Hausname1 : TMenuItem
|
005E9C81   8B8390060000           mov     eax, [ebx+$0690]

* Reference to: Menus.TMenuItem.SetChecked(TMenuItem;Boolean);
|
005E9C87   E8F04AE7FF             call    0045E77C
005E9C8C   33D2                   xor     edx, edx

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005E9C8E   8B8374060000           mov     eax, [ebx+$0674]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005E9C94   E88B2CE6FF             call    0044C924
005E9C99   8B4500                 mov     eax, [ebp+$00]

* Reference to field TStringGrid.AutoSize : Boolean
|
005E9C9C   8B405C                 mov     eax, [eax+$5C]
005E9C9F   33D2                   xor     edx, edx
005E9CA1   8B08                   mov     ecx, [eax]

* Possible reference to virtual method TBoolean.OFFS_0198
|
005E9CA3   FF9198010000           call    dword ptr [ecx+$0198]
005E9CA9   8B4500                 mov     eax, [ebp+$00]

* Reference to field Boolean.OFFS_0090
|
005E9CAC   8B8090000000           mov     eax, [eax+$0090]
005E9CB2   33D2                   xor     edx, edx
005E9CB4   8B08                   mov     ecx, [eax]
005E9CB6   FF9198010000           call    dword ptr [ecx+$0198]
005E9CBC   8B4500                 mov     eax, [ebp+$00]
005E9CBF   8B809C000000           mov     eax, [eax+$009C]
005E9CC5   33D2                   xor     edx, edx
005E9CC7   8B08                   mov     ecx, [eax]
005E9CC9   FF9198010000           call    dword ptr [ecx+$0198]
005E9CCF   8B4500                 mov     eax, [ebp+$00]
005E9CD2   8B803C010000           mov     eax, [eax+$013C]
005E9CD8   33D2                   xor     edx, edx
005E9CDA   8B08                   mov     ecx, [eax]
005E9CDC   FF9198010000           call    dword ptr [ecx+$0198]
005E9CE2   8B4500                 mov     eax, [ebp+$00]
005E9CE5   8B405C                 mov     eax, [eax+$5C]
005E9CE8   33D2                   xor     edx, edx
005E9CEA   8B08                   mov     ecx, [eax]
005E9CEC   FF9190010000           call    dword ptr [ecx+$0190]
005E9CF2   8B4500                 mov     eax, [ebp+$00]
005E9CF5   8B8090000000           mov     eax, [eax+$0090]
005E9CFB   33D2                   xor     edx, edx
005E9CFD   8B08                   mov     ecx, [eax]
005E9CFF   FF9190010000           call    dword ptr [ecx+$0190]
005E9D05   8B4500                 mov     eax, [ebp+$00]
005E9D08   8B809C000000           mov     eax, [eax+$009C]
005E9D0E   33D2                   xor     edx, edx
005E9D10   8B08                   mov     ecx, [eax]
005E9D12   FF9190010000           call    dword ptr [ecx+$0190]
005E9D18   8B4500                 mov     eax, [ebp+$00]
005E9D1B   8B803C010000           mov     eax, [eax+$013C]
005E9D21   33D2                   xor     edx, edx
005E9D23   8B08                   mov     ecx, [eax]
005E9D25   FF9190010000           call    dword ptr [ecx+$0190]
005E9D2B   BAC0C0C000             mov     edx, $00C0C0C0

* Reference to control TForm1.DBText1 : TDBText
|
005E9D30   8B83B4070000           mov     eax, [ebx+$07B4]

* Reference to: Controls.TControl.SetColor(TControl;TColor);
|
005E9D36   E8692EE6FF             call    0044CBA4

* Reference to control TForm1.MainMenu1 : TMainMenu
|
005E9D3B   8B83F0020000           mov     eax, [ebx+$02F0]

* Reference to field TMainMenu.Items : TMenuItem
|
005E9D41   8B4034                 mov     eax, [eax+$34]
005E9D44   BA0A000000             mov     edx, $0000000A

* Reference to: Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;
|
005E9D49   E8664BE7FF             call    0045E8B4

* Reference to: Menus.TMenuItem.GetCount(TMenuItem):Integer;
|
005E9D4E   E8514BE7FF             call    0045E8A4
005E9D53   83E803                 sub     eax, +$03
005E9D56   8BF8                   mov     edi, eax
005E9D58   85FF                   test    edi, edi
005E9D5A   7C51                   jl      005E9DAD
005E9D5C   47                     inc     edi
005E9D5D   33F6                   xor     esi, esi

* Reference to control TForm1.MainMenu1 : TMainMenu
|
005E9D5F   8B83F0020000           mov     eax, [ebx+$02F0]

* Reference to field TMainMenu.Items : TMenuItem
|
005E9D65   8B4034                 mov     eax, [eax+$34]
005E9D68   BA0A000000             mov     edx, $0000000A

* Reference to: Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;
|
005E9D6D   E8424BE7FF             call    0045E8B4
005E9D72   8BD6                   mov     edx, esi

* Reference to: Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;
|
005E9D74   E83B4BE7FF             call    0045E8B4

* Reference to field TMenuItem.Caption : string
|
005E9D79   8B5030                 mov     edx, [eax+$30]

* Possible String Reference to: 'drucken'
|
005E9D7C   B8DC9D5E00             mov     eax, $005E9DDC

* Reference to: System.@LStrPos;
|
005E9D81   E8D6B3E1FF             call    0040515C
005E9D86   85C0                   test    eax, eax
005E9D88   7E1F                   jle     005E9DA9

* Reference to control TForm1.MainMenu1 : TMainMenu
|
005E9D8A   8B83F0020000           mov     eax, [ebx+$02F0]

* Reference to field TMainMenu.Items : TMenuItem
|
005E9D90   8B4034                 mov     eax, [eax+$34]
005E9D93   BA0A000000             mov     edx, $0000000A

* Reference to: Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;
|
005E9D98   E8174BE7FF             call    0045E8B4
005E9D9D   8BD6                   mov     edx, esi

* Reference to: Menus.TMenuItem.GetItem(TMenuItem;Integer):TMenuItem;
|
005E9D9F   E8104BE7FF             call    0045E8B4

* Reference to: System.TObject.Free(TObject);
|
005E9DA4   E88F9FE1FF             call    00403D38
005E9DA9   46                     inc     esi
005E9DAA   4F                     dec     edi
005E9DAB   75B2                   jnz     005E9D5F
005E9DAD   8B0424                 mov     eax, [esp]
005E9DB0   89442404               mov     [esp+$04], eax
005E9DB4   C644240800             mov     byte ptr [esp+$08], $00
005E9DB9   8D542404               lea     edx, [esp+$04]
005E9DBD   8B4500                 mov     eax, [ebp+$00]
005E9DC0   8B405C                 mov     eax, [eax+$5C]
005E9DC3   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005E9DC5   E89A94EEFF             call    004D3264
005E9DCA   83C40C                 add     esp, +$0C
005E9DCD   5D                     pop     ebp
005E9DCE   5F                     pop     edi
005E9DCF   5E                     pop     esi
005E9DD0   5B                     pop     ebx
005E9DD1   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.DBText1 (TDBText); TForm1.Name1 (TMenuItem);
    TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_0540
Project calls: TForm1.anzeigen(); TForm1.tabdisab(); TForm1.tabenab(); Unit_00408494.Proc_00409448;
    Unit_00408494.Proc_00409500
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetColor(TControl;TColor);; Dialogs.ShowMessage(AnsiString);;
    Menus.TMenuItem.SetChecked(TMenuItem;Boolean);; method TMenuItem.Click(); System.Proc_00404EE0;
    TMessageForm._PROC_00445B24()
Strings/files/dialog text: '" nicht gefunden.'; '_^[��]�'; 'Filter'; 'Filterkriterium Name = "';
    'Name '; 'name='; '��)����_^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Name1Click(Sender : TObject);
begin
(*
005EC4D4   55                     push    ebp
005EC4D5   8BEC                   mov     ebp, esp
005EC4D7   B906000000             mov     ecx, $00000006
005EC4DC   6A00                   push    $00
005EC4DE   6A00                   push    $00
005EC4E0   49                     dec     ecx
005EC4E1   75F9                   jnz     005EC4DC
005EC4E3   51                     push    ecx
005EC4E4   53                     push    ebx
005EC4E5   56                     push    esi
005EC4E6   57                     push    edi
005EC4E7   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005EC4E9   8B3D3CCC6100           mov     edi, [$0061CC3C]
005EC4EF   33C0                   xor     eax, eax
005EC4F1   55                     push    ebp

* Possible String Reference to: '��}����_^[��]�'
|
005EC4F2   68FBC65E00             push    $005EC6FB

***** TRY
|
005EC4F7   64FF30                 push    dword ptr fs:[eax]
005EC4FA   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EC4FD   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EC503   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EC509   E8AA38E9FF             call    0047FDB8
005EC50E   8D45FC                 lea     eax, [ebp-$04]
005EC511   50                     push    eax
005EC512   33C9                   xor     ecx, ecx

* Possible String Reference to: 'Name '
|
005EC514   BA14C75E00             mov     edx, $005EC714

* Possible String Reference to: 'Filter'
|
005EC519   B824C75E00             mov     eax, $005EC724

* Reference to : TMessageForm._PROC_00445B24()
|
005EC51E   E80196E5FF             call    00445B24
005EC523   8D55F4                 lea     edx, [ebp-$0C]
005EC526   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409448
|
005EC529   E81ACFE1FF             call    00409448
005EC52E   837DF400               cmp     dword ptr [ebp-$0C], +$00
005EC532   0F8693010000           jbe     005EC6CB
005EC538   33DB                   xor     ebx, ebx
005EC53A   8B07                   mov     eax, [edi]
005EC53C   8B8034050000           mov     eax, [eax+$0534]
005EC542   8B10                   mov     edx, [eax]
005EC544   FF5258                 call    dword ptr [edx+$58]
005EC547   8945F8                 mov     [ebp-$08], eax
005EC54A   8BC6                   mov     eax, esi

* Reference to : TForm1.tabdisab()
|
005EC54C   E8E3C2FEFF             call    005D8834
005EC551   8B07                   mov     eax, [edi]

* Reference to field TForm1.AutoSize : Boolean
|
005EC553   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EC556   E8792CECFF             call    004AF1D4
005EC55B   EB51                   jmp     005EC5AE
005EC55D   8D55EC                 lea     edx, [ebp-$14]
005EC560   8B07                   mov     eax, [edi]

* Reference to field Boolean.OFFS_0540
|
005EC562   8B8040050000           mov     eax, [eax+$0540]
005EC568   8B08                   mov     ecx, [eax]
005EC56A   FF5160                 call    dword ptr [ecx+$60]
005EC56D   8B45EC                 mov     eax, [ebp-$14]
005EC570   8D55F0                 lea     edx, [ebp-$10]

* Reference to: Unit_00408494.Proc_00409448
|
005EC573   E8D0CEE1FF             call    00409448
005EC578   8B45F0                 mov     eax, [ebp-$10]
005EC57B   50                     push    eax
005EC57C   8D55E8                 lea     edx, [ebp-$18]
005EC57F   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409448
|
005EC582   E8C1CEE1FF             call    00409448
005EC587   8B55E8                 mov     edx, [ebp-$18]
005EC58A   58                     pop     eax

* Reference to: System.@LStrCmp;
|
005EC58B   E8D489E1FF             call    00404F64
005EC590   7504                   jnz     005EC596
005EC592   B301                   mov     bl, $01
005EC594   EB26                   jmp     005EC5BC
005EC596   8B07                   mov     eax, [edi]
005EC598   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005EC59B   E84C2FECFF             call    004AF4EC
005EC5A0   8B07                   mov     eax, [edi]
005EC5A2   8B405C                 mov     eax, [eax+$5C]
005EC5A5   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EC5AC   750E                   jnz     005EC5BC
005EC5AE   8B07                   mov     eax, [edi]
005EC5B0   8B405C                 mov     eax, [eax+$5C]
005EC5B3   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EC5BA   74A1                   jz      005EC55D
005EC5BC   8BC6                   mov     eax, esi

* Reference to : TForm1.tabenab()
|
005EC5BE   E895C2FEFF             call    005D8858

* Reference to Form1
|
005EC5C3   8B45F8                 mov     eax, [ebp-$08]
005EC5C6   8945E0                 mov     [ebp-$20], eax
005EC5C9   C645E400               mov     byte ptr [ebp-$1C], $00
005EC5CD   8D55E0                 lea     edx, [ebp-$20]
005EC5D0   8B07                   mov     eax, [edi]

* Reference to field Form1.OFFS_005C
|
005EC5D2   8B405C                 mov     eax, [eax+$5C]
005EC5D5   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005EC5D7   E8886CEEFF             call    004D3264
005EC5DC   80FB01                 cmp     bl, $01
005EC5DF   0F85AB000000           jnz     005EC690

* Reference to control TForm1.aus1 : TMenuItem
|
005EC5E5   8B861C060000           mov     eax, [esi+$061C]
005EC5EB   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005EC5ED   FF5244                 call    dword ptr [edx+$44]
005EC5F0   B201                   mov     dl, $01

* Reference to control TForm1.Name1 : TMenuItem
|
005EC5F2   8B8654060000           mov     eax, [esi+$0654]

* Reference to: Menus.TMenuItem.SetChecked(TMenuItem;Boolean);
|
005EC5F8   E87F21E7FF             call    0045E77C
005EC5FD   8D55D8                 lea     edx, [ebp-$28]
005EC600   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409500
|
005EC603   E8F8CEE1FF             call    00409500
005EC608   8B4DD8                 mov     ecx, [ebp-$28]
005EC60B   8D45DC                 lea     eax, [ebp-$24]

* Possible String Reference to: 'name='
|
005EC60E   BA34C75E00             mov     edx, $005EC734

* Reference to: System.@LStrCat3;
|
005EC613   E85488E1FF             call    00404E6C
005EC618   8B55DC                 mov     edx, [ebp-$24]
005EC61B   8B07                   mov     eax, [edi]
005EC61D   8B405C                 mov     eax, [eax+$5C]
005EC620   8B08                   mov     ecx, [eax]
005EC622   FF9198010000           call    dword ptr [ecx+$0198]
005EC628   8B07                   mov     eax, [edi]
005EC62A   8B405C                 mov     eax, [eax+$5C]
005EC62D   B201                   mov     dl, $01
005EC62F   8B08                   mov     ecx, [eax]
005EC631   FF9190010000           call    dword ptr [ecx+$0190]
005EC637   8D55D0                 lea     edx, [ebp-$30]
005EC63A   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409500
|
005EC63D   E8BECEE1FF             call    00409500
005EC642   8B4DD0                 mov     ecx, [ebp-$30]
005EC645   8D45D4                 lea     eax, [ebp-$2C]

* Possible String Reference to: 'name='
|
005EC648   BA34C75E00             mov     edx, $005EC734

* Reference to: System.@LStrCat3;
|
005EC64D   E81A88E1FF             call    00404E6C
005EC652   8B55D4                 mov     edx, [ebp-$2C]
005EC655   8B07                   mov     eax, [edi]
005EC657   8B809C000000           mov     eax, [eax+$009C]
005EC65D   8B08                   mov     ecx, [eax]
005EC65F   FF9198010000           call    dword ptr [ecx+$0198]
005EC665   8B07                   mov     eax, [edi]
005EC667   8B809C000000           mov     eax, [eax+$009C]
005EC66D   B201                   mov     dl, $01
005EC66F   8B08                   mov     ecx, [eax]
005EC671   FF9190010000           call    dword ptr [ecx+$0190]
005EC677   BAFF000000             mov     edx, $000000FF

* Reference to control TForm1.DBText1 : TDBText
|
005EC67C   8B86B4070000           mov     eax, [esi+$07B4]

* Reference to: Controls.TControl.SetColor(TControl;TColor);
|
005EC682   E81D05E6FF             call    0044CBA4
005EC687   8BC6                   mov     eax, esi

* Reference to : TForm1.anzeigen()
|
005EC689   E80E7DFEFF             call    005D439C
005EC68E   EB3B                   jmp     005EC6CB

* Possible String Reference to: 'Filterkriterium Name = "'
|
005EC690   6844C75E00             push    $005EC744
005EC695   FF75FC                 push    dword ptr [ebp-$04]

* Possible String Reference to: '" nicht gefunden.'
|
005EC698   6868C75E00             push    $005EC768
005EC69D   8D45CC                 lea     eax, [ebp-$34]
005EC6A0   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005EC6A5   E83688E1FF             call    00404EE0
005EC6AA   8B45CC                 mov     eax, [ebp-$34]

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005EC6AD   E83291E5FF             call    004457E4

* Reference to Form1
|
005EC6B2   8B45F8                 mov     eax, [ebp-$08]
005EC6B5   8945E0                 mov     [ebp-$20], eax
005EC6B8   C645E400               mov     byte ptr [ebp-$1C], $00
005EC6BC   8D55E0                 lea     edx, [ebp-$20]
005EC6BF   8B07                   mov     eax, [edi]

* Reference to field Form1.OFFS_005C
|
005EC6C1   8B405C                 mov     eax, [eax+$5C]
005EC6C4   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005EC6C6   E8996BEEFF             call    004D3264
005EC6CB   33C0                   xor     eax, eax
005EC6CD   5A                     pop     edx
005EC6CE   59                     pop     ecx
005EC6CF   59                     pop     ecx
005EC6D0   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005EC6D3   6802C75E00             push    $005EC702
005EC6D8   8D45CC                 lea     eax, [ebp-$34]
005EC6DB   BA05000000             mov     edx, $00000005

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EC6E0   E8A784E1FF             call    00404B8C
005EC6E5   8D45E8                 lea     eax, [ebp-$18]
005EC6E8   BA04000000             mov     edx, $00000004

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EC6ED   E89A84E1FF             call    00404B8C
005EC6F2   8D45FC                 lea     eax, [ebp-$04]

* Reference to: System.@LStrClr(void;void);
|
005EC6F5   E86E84E1FF             call    00404B68
005EC6FA   C3                     ret


* Reference to: System.@HandleFinally;
|
005EC6FB   E9CC7DE1FF             jmp     004044CC
005EC700   EBD6                   jmp     005EC6D8

****** END
|
005EC702   5F                     pop     edi
005EC703   5E                     pop     esi
005EC704   5B                     pop     ebx
005EC705   8BE5                   mov     esp, ebp
005EC707   5D                     pop     ebp
005EC708   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Label10 (TLabel)
Global state: GlobalVar_0061DF08; GlobalVar_02535880
Unresolved field offsets: OFFS_005C
Project calls: Unit_00408494.Proc_00409950; Unit_00408494.Proc_0040C84C
Framework/API calls: Controls.TControl.SetText(TControl;TCaption);; System.Proc_00404EE0
Strings/files/dialog text: ' Datens�tze'; '(Ausgabe vom '; '[��]�'; '�fW����[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.zuAHNENWIN1Click(Sender : TObject);
begin
(*
005EEC54   55                     push    ebp
005EEC55   8BEC                   mov     ebp, esp
005EEC57   6A00                   push    $00
005EEC59   6A00                   push    $00
005EEC5B   6A00                   push    $00
005EEC5D   53                     push    ebx
005EEC5E   8BD8                   mov     ebx, eax
005EEC60   33C0                   xor     eax, eax
005EEC62   55                     push    ebp

* Possible String Reference to: '�fW����[��]�'
|
005EEC63   6861ED5E00             push    $005EED61

***** TRY
|
005EEC68   64FF30                 push    dword ptr fs:[eax]
005EEC6B   648920                 mov     fs:[eax], esp *)

PageControl1.ActivePage := Tabsheet2;
speich1(Sender);
if PageControl1.PageCount = 2 then
  PageControl1.ActivePage := Tabsheet2;

(* Possible String Reference to: '(Ausgabe vom '
|
005EECA7   6878ED5E00             push    $005EED78
005EECAC   FF3528595302           push    dword ptr [$02535928]
005EECB2   FF3524595302           push    dword ptr [$02535924]
005EECB8   8D45F8                 lea     eax, [ebp-$08]

* Reference to: Unit_00408494.Proc_0040C84C
|
005EECBB   E88CDBE1FF             call    0040C84C
005EECC0   FF75F8                 push    dword ptr [ebp-$08]
005EECC3   6890ED5E00             push    $005EED90
005EECC8   8D45FC                 lea     eax, [ebp-$04]
005EECCB   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005EECD0   E80B62E1FF             call    00404EE0
005EECD5   8B55FC                 mov     edx, [ebp-$04]  *)

AboutDialog.Label8.Caption :='(Ausgabe vom 11.01.2019)';
AboutDialog.Label10.Visible := true;

(* Reference to pointer to GlobalVar_0061DF08
|
005EECFE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EED03   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EED05   8B405C                 mov     eax, [eax+$5C]
005EED08   8B10                   mov     edx, [eax]
005EED0A   FF924C010000           call    dword ptr [edx+$014C]
005EED10   8D55F4                 lea     edx, [ebp-$0C]

* Reference to: Unit_00408494.Proc_00409950
|
005EED13   E838ACE1FF             call    00409950
005EED18   8D45F4                 lea     eax, [ebp-$0C]

* Possible String Reference to: ' Datens�tze'
|
005EED1B   BA9CED5E00             mov     edx, $005EED9C

* Reference to: System.@LStrCat;
|
005EED20   E80361E1FF             call    00404E28
005EED25   8B55F4                 mov     edx, [ebp-$0C]

* Reference to pointer to GlobalVar_02535880
|
005EED28   A1D4C96100             mov     eax, dword ptr [$0061C9D4]
005EED2D   8B00                   mov     eax, [eax]

* Reference to control Label10 : TLabel
|
005EED2F   8B8014030000           mov     eax, [eax+$0314]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EED35   E8FADCE5FF             call    0044CA34 *)

AboutDialog.Label10.Caption:='0 Datens�tze';
AboutDialog.Show;
(*
005EED46   33C0                   xor     eax, eax
005EED48   5A                     pop     edx
005EED49   59                     pop     ecx
005EED4A   59                     pop     ecx
005EED4B   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '[��]�'
|
005EED4E   6868ED5E00             push    $005EED68
005EED53   8D45F4                 lea     eax, [ebp-$0C]
005EED56   BA03000000             mov     edx, $00000003

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EED5B   E82C5EE1FF             call    00404B8C
005EED60   C3                     ret


* Reference to: System.@HandleFinally;
|
005EED61   E96657E1FF             jmp     004044CC
005EED66   EBEB                   jmp     005EED53

****** END
|
005EED68   5B                     pop     ebx
005EED69   8BE5                   mov     esp, ebp
005EED6B   5D                     pop     ebp
005EED6C   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.DBText1 (TDBText); TForm1.Hausname1 (TMenuItem);
    TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_05C8
Project calls: TForm1.anzeigen(); TForm1.tabdisab(); TForm1.tabenab(); Unit_00408494.Proc_00409448;
    Unit_00408494.Proc_00409500
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetColor(TControl;TColor);; Dialogs.ShowMessage(AnsiString);;
    Menus.TMenuItem.SetChecked(TMenuItem;Boolean);; method TMenuItem.Click(); System.Proc_00404EE0;
    TMessageForm._PROC_00445B24()
Strings/files/dialog text: '" nicht gefunden.'; '_^[��]�'; 'Filter'; 'Filterkriterium Hofname = "';
    'hausname='; 'Hofname '; '��T����_^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Hausname1Click(Sender : TObject);
begin
(*
005EEDA8   55                     push    ebp
005EEDA9   8BEC                   mov     ebp, esp
005EEDAB   B906000000             mov     ecx, $00000006
005EEDB0   6A00                   push    $00
005EEDB2   6A00                   push    $00
005EEDB4   49                     dec     ecx
005EEDB5   75F9                   jnz     005EEDB0
005EEDB7   51                     push    ecx
005EEDB8   53                     push    ebx
005EEDB9   56                     push    esi
005EEDBA   57                     push    edi
005EEDBB   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005EEDBD   8B3D3CCC6100           mov     edi, [$0061CC3C]
005EEDC3   33C0                   xor     eax, eax
005EEDC5   55                     push    ebp

* Possible String Reference to: '��T����_^[��]�'
|
005EEDC6   68CFEF5E00             push    $005EEFCF

***** TRY
|
005EEDCB   64FF30                 push    dword ptr fs:[eax]
005EEDCE   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EEDD1   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EEDD7   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EEDDD   E8D60FE9FF             call    0047FDB8
005EEDE2   8D45FC                 lea     eax, [ebp-$04]
005EEDE5   50                     push    eax
005EEDE6   33C9                   xor     ecx, ecx

* Possible String Reference to: 'Hofname '
|
005EEDE8   BAE8EF5E00             mov     edx, $005EEFE8

* Possible String Reference to: 'Filter'
|
005EEDED   B8FCEF5E00             mov     eax, $005EEFFC

* Reference to : TMessageForm._PROC_00445B24()
|
005EEDF2   E82D6DE5FF             call    00445B24
005EEDF7   8D55F4                 lea     edx, [ebp-$0C]
005EEDFA   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409448
|
005EEDFD   E846A6E1FF             call    00409448
005EEE02   837DF400               cmp     dword ptr [ebp-$0C], +$00
005EEE06   0F8693010000           jbe     005EEF9F
005EEE0C   33DB                   xor     ebx, ebx
005EEE0E   8B07                   mov     eax, [edi]
005EEE10   8B8034050000           mov     eax, [eax+$0534]
005EEE16   8B10                   mov     edx, [eax]
005EEE18   FF5258                 call    dword ptr [edx+$58]
005EEE1B   8945F8                 mov     [ebp-$08], eax
005EEE1E   8BC6                   mov     eax, esi

* Reference to : TForm1.tabdisab()
|
005EEE20   E80F9AFEFF             call    005D8834
005EEE25   8B07                   mov     eax, [edi]

* Reference to field TForm1.AutoSize : Boolean
|
005EEE27   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EEE2A   E8A503ECFF             call    004AF1D4
005EEE2F   EB51                   jmp     005EEE82
005EEE31   8D55EC                 lea     edx, [ebp-$14]
005EEE34   8B07                   mov     eax, [edi]

* Reference to field Boolean.OFFS_05C8
|
005EEE36   8B80C8050000           mov     eax, [eax+$05C8]
005EEE3C   8B08                   mov     ecx, [eax]
005EEE3E   FF5160                 call    dword ptr [ecx+$60]
005EEE41   8B45EC                 mov     eax, [ebp-$14]
005EEE44   8D55F0                 lea     edx, [ebp-$10]

* Reference to: Unit_00408494.Proc_00409448
|
005EEE47   E8FCA5E1FF             call    00409448
005EEE4C   8B45F0                 mov     eax, [ebp-$10]
005EEE4F   50                     push    eax
005EEE50   8D55E8                 lea     edx, [ebp-$18]
005EEE53   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409448
|
005EEE56   E8EDA5E1FF             call    00409448
005EEE5B   8B55E8                 mov     edx, [ebp-$18]
005EEE5E   58                     pop     eax

* Reference to: System.@LStrCmp;
|
005EEE5F   E80061E1FF             call    00404F64
005EEE64   7504                   jnz     005EEE6A
005EEE66   B301                   mov     bl, $01
005EEE68   EB26                   jmp     005EEE90
005EEE6A   8B07                   mov     eax, [edi]
005EEE6C   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005EEE6F   E87806ECFF             call    004AF4EC
005EEE74   8B07                   mov     eax, [edi]
005EEE76   8B405C                 mov     eax, [eax+$5C]
005EEE79   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EEE80   750E                   jnz     005EEE90
005EEE82   8B07                   mov     eax, [edi]
005EEE84   8B405C                 mov     eax, [eax+$5C]
005EEE87   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EEE8E   74A1                   jz      005EEE31
005EEE90   8BC6                   mov     eax, esi

* Reference to : TForm1.tabenab()
|
005EEE92   E8C199FEFF             call    005D8858

* Reference to Form1
|
005EEE97   8B45F8                 mov     eax, [ebp-$08]
005EEE9A   8945E0                 mov     [ebp-$20], eax
005EEE9D   C645E400               mov     byte ptr [ebp-$1C], $00
005EEEA1   8D55E0                 lea     edx, [ebp-$20]
005EEEA4   8B07                   mov     eax, [edi]

* Reference to field Form1.OFFS_005C
|
005EEEA6   8B405C                 mov     eax, [eax+$5C]
005EEEA9   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005EEEAB   E8B443EEFF             call    004D3264
005EEEB0   80FB01                 cmp     bl, $01
005EEEB3   0F85AB000000           jnz     005EEF64

* Reference to control TForm1.aus1 : TMenuItem
|
005EEEB9   8B861C060000           mov     eax, [esi+$061C]
005EEEBF   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005EEEC1   FF5244                 call    dword ptr [edx+$44]
005EEEC4   B201                   mov     dl, $01

* Reference to control TForm1.Hausname1 : TMenuItem
|
005EEEC6   8B8690060000           mov     eax, [esi+$0690]

* Reference to: Menus.TMenuItem.SetChecked(TMenuItem;Boolean);
|
005EEECC   E8ABF8E6FF             call    0045E77C
005EEED1   8D55D8                 lea     edx, [ebp-$28]
005EEED4   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409500
|
005EEED7   E824A6E1FF             call    00409500
005EEEDC   8B4DD8                 mov     ecx, [ebp-$28]
005EEEDF   8D45DC                 lea     eax, [ebp-$24]

* Possible String Reference to: 'hausname='
|
005EEEE2   BA0CF05E00             mov     edx, $005EF00C

* Reference to: System.@LStrCat3;
|
005EEEE7   E8805FE1FF             call    00404E6C
005EEEEC   8B55DC                 mov     edx, [ebp-$24]
005EEEEF   8B07                   mov     eax, [edi]
005EEEF1   8B405C                 mov     eax, [eax+$5C]
005EEEF4   8B08                   mov     ecx, [eax]
005EEEF6   FF9198010000           call    dword ptr [ecx+$0198]
005EEEFC   8B07                   mov     eax, [edi]
005EEEFE   8B405C                 mov     eax, [eax+$5C]
005EEF01   B201                   mov     dl, $01
005EEF03   8B08                   mov     ecx, [eax]
005EEF05   FF9190010000           call    dword ptr [ecx+$0190]
005EEF0B   8D55D0                 lea     edx, [ebp-$30]
005EEF0E   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409500
|
005EEF11   E8EAA5E1FF             call    00409500
005EEF16   8B4DD0                 mov     ecx, [ebp-$30]
005EEF19   8D45D4                 lea     eax, [ebp-$2C]

* Possible String Reference to: 'hausname='
|
005EEF1C   BA0CF05E00             mov     edx, $005EF00C

* Reference to: System.@LStrCat3;
|
005EEF21   E8465FE1FF             call    00404E6C
005EEF26   8B55D4                 mov     edx, [ebp-$2C]
005EEF29   8B07                   mov     eax, [edi]
005EEF2B   8B809C000000           mov     eax, [eax+$009C]
005EEF31   8B08                   mov     ecx, [eax]
005EEF33   FF9198010000           call    dword ptr [ecx+$0198]
005EEF39   8B07                   mov     eax, [edi]
005EEF3B   8B809C000000           mov     eax, [eax+$009C]
005EEF41   B201                   mov     dl, $01
005EEF43   8B08                   mov     ecx, [eax]
005EEF45   FF9190010000           call    dword ptr [ecx+$0190]
005EEF4B   BAFF000000             mov     edx, $000000FF

* Reference to control TForm1.DBText1 : TDBText
|
005EEF50   8B86B4070000           mov     eax, [esi+$07B4]

* Reference to: Controls.TControl.SetColor(TControl;TColor);
|
005EEF56   E849DCE5FF             call    0044CBA4
005EEF5B   8BC6                   mov     eax, esi

* Reference to : TForm1.anzeigen()
|
005EEF5D   E83A54FEFF             call    005D439C
005EEF62   EB3B                   jmp     005EEF9F

* Possible String Reference to: 'Filterkriterium Hofname = "'
|
005EEF64   6820F05E00             push    $005EF020
005EEF69   FF75FC                 push    dword ptr [ebp-$04]

* Possible String Reference to: '" nicht gefunden.'
|
005EEF6C   6844F05E00             push    $005EF044
005EEF71   8D45CC                 lea     eax, [ebp-$34]
005EEF74   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005EEF79   E8625FE1FF             call    00404EE0
005EEF7E   8B45CC                 mov     eax, [ebp-$34]

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005EEF81   E85E68E5FF             call    004457E4

* Reference to Form1
|
005EEF86   8B45F8                 mov     eax, [ebp-$08]
005EEF89   8945E0                 mov     [ebp-$20], eax
005EEF8C   C645E400               mov     byte ptr [ebp-$1C], $00
005EEF90   8D55E0                 lea     edx, [ebp-$20]
005EEF93   8B07                   mov     eax, [edi]

* Reference to field Form1.OFFS_005C
|
005EEF95   8B405C                 mov     eax, [eax+$5C]
005EEF98   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005EEF9A   E8C542EEFF             call    004D3264
005EEF9F   33C0                   xor     eax, eax
005EEFA1   5A                     pop     edx
005EEFA2   59                     pop     ecx
005EEFA3   59                     pop     ecx
005EEFA4   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005EEFA7   68D6EF5E00             push    $005EEFD6
005EEFAC   8D45CC                 lea     eax, [ebp-$34]
005EEFAF   BA05000000             mov     edx, $00000005

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EEFB4   E8D35BE1FF             call    00404B8C
005EEFB9   8D45E8                 lea     eax, [ebp-$18]
005EEFBC   BA04000000             mov     edx, $00000004

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EEFC1   E8C65BE1FF             call    00404B8C
005EEFC6   8D45FC                 lea     eax, [ebp-$04]

* Reference to: System.@LStrClr(void;void);
|
005EEFC9   E89A5BE1FF             call    00404B68
005EEFCE   C3                     ret


* Reference to: System.@HandleFinally;
|
005EEFCF   E9F854E1FF             jmp     004044CC
005EEFD4   EBD6                   jmp     005EEFAC

****** END
|
005EEFD6   5F                     pop     edi
005EEFD7   5E                     pop     esi
005EEFD8   5B                     pop     ebx
005EEFD9   8BE5                   mov     esp, ebp
005EEFDB   5D                     pop     ebp
005EEFDC   C3                     ret

*)
end;

procedure TForm1.Hilfe1Click(Sender : TObject);
begin
  ShowMessage('Bitte die beiliegende Datei "Handbuch.pdf" benützen');
end;

procedure TForm1.Fenstertitelndern1Click(Sender : TObject);
begin
  fcapt(Sender);
end;

