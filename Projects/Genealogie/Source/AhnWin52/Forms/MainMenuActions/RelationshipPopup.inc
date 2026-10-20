{ TForm1 menu-area implementations: RelationshipPopup; LFM-bound method names remain on TForm1. }

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.StringGrid1 (TStringGrid)
Database/provider: DB.TDataSet.Delete(TDataSet);; DB.TDataSet.First(TDataSet);;
    DB.TDataSet.Next(TDataSet);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Project calls: TForm1.anzeigen(); Unit_00408494.Proc_004099B4
Framework/API calls: Dialogs.Proc_004456EC;
    Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;; System.Proc_00404EE0
Strings/files/dialog text: '_^[��]�'; 'als (Ehe-)Partner entfernen ?'; '�f�����_^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Verbindunglschen1Click(Sender : TObject);
begin
(*
005E6198   55                     push    ebp
005E6199   8BEC                   mov     ebp, esp
005E619B   83C4E8                 add     esp, -$18
005E619E   53                     push    ebx
005E619F   56                     push    esi
005E61A0   57                     push    edi
005E61A1   33C9                   xor     ecx, ecx
005E61A3   894DF0                 mov     [ebp-$10], ecx
005E61A6   894DF8                 mov     [ebp-$08], ecx
005E61A9   894DF4                 mov     [ebp-$0C], ecx
005E61AC   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005E61AE   8B1D3CCC6100           mov     ebx, [$0061CC3C]
005E61B4   33C0                   xor     eax, eax
005E61B6   55                     push    ebp

* Possible String Reference to: '�f�����_^[��]�'
|
005E61B7   6861635E00             push    $005E6361

***** TRY
|
005E61BC   64FF30                 push    dword ptr fs:[eax]
005E61BF   648920                 mov     fs:[eax], esp
005E61C2   6A00                   push    $00
005E61C4   8D45F4                 lea     eax, [ebp-$0C]
005E61C7   50                     push    eax

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005E61C8   8B8670030000           mov     eax, [esi+$0370]

* Reference to field TStringGrid.Row : Longint
|
005E61CE   8B882C020000           mov     ecx, [eax+$022C]
005E61D4   BA02000000             mov     edx, $00000002

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005E61D9   8B8670030000           mov     eax, [esi+$0370]

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005E61DF   E8A898EFFF             call    004DFA8C
005E61E4   FF75F4                 push    dword ptr [ebp-$0C]
005E61E7   6878635E00             push    $005E6378
005E61EC   6884635E00             push    $005E6384

* Possible String Reference to: 'als (Ehe-)Partner entfernen ?'
|
005E61F1   6890635E00             push    $005E6390
005E61F6   8D45F8                 lea     eax, [ebp-$08]
005E61F9   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005E61FE   E8DDECE1FF             call    00404EE0
005E6203   8B45F8                 mov     eax, [ebp-$08]
005E6206   668B0DB0635E00         mov     cx, word ptr [$005E63B0]
005E620D   B203                   mov     dl, $03

* Reference to: Dialogs.Proc_004456EC
|
005E620F   E8D8F4E5FF             call    004456EC
005E6214   83F806                 cmp     eax, +$06
005E6217   0F8522010000           jnz     005E633F
005E621D   8D45F0                 lea     eax, [ebp-$10]
005E6220   50                     push    eax

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005E6221   8B8670030000           mov     eax, [esi+$0370]

* Reference to field TStringGrid.Row : Longint
|
005E6227   8B882C020000           mov     ecx, [eax+$022C]
005E622D   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005E6232   8B8670030000           mov     eax, [esi+$0370]

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005E6238   E84F98EFFF             call    004DFA8C
005E623D   8B45F0                 mov     eax, [ebp-$10]

* Reference to: Unit_00408494.Proc_004099B4
|
005E6240   E86F37E2FF             call    004099B4
005E6245   8945FC                 mov     [ebp-$04], eax
005E6248   8B03                   mov     eax, [ebx]
005E624A   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.First(TDataSet);
|
005E6250   E87F8FECFF             call    004AF1D4
005E6255   EB4C                   jmp     005E62A3
005E6257   8B03                   mov     eax, [ebx]
005E6259   8B8014040000           mov     eax, [eax+$0414]
005E625F   8B10                   mov     edx, [eax]
005E6261   FF5258                 call    dword ptr [edx+$58]
005E6264   3B45FC                 cmp     eax, [ebp-$04]
005E6267   751C                   jnz     005E6285
005E6269   8B03                   mov     eax, [ebx]
005E626B   8B8010040000           mov     eax, [eax+$0410]
005E6271   8B10                   mov     edx, [eax]
005E6273   FF5258                 call    dword ptr [edx+$58]
005E6276   8BF8                   mov     edi, eax
005E6278   8B03                   mov     eax, [ebx]
005E627A   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Delete(TDataSet);
|
005E6280   E89396ECFF             call    004AF918
005E6285   8B03                   mov     eax, [ebx]
005E6287   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005E628D   E85A92ECFF             call    004AF4EC
005E6292   8B03                   mov     eax, [ebx]
005E6294   8B8080000000           mov     eax, [eax+$0080]
005E629A   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005E62A1   7511                   jnz     005E62B4
005E62A3   8B03                   mov     eax, [ebx]
005E62A5   8B8080000000           mov     eax, [eax+$0080]
005E62AB   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005E62B2   74A3                   jz      005E6257
005E62B4   8B45FC                 mov     eax, [ebp-$04]
005E62B7   8945E8                 mov     [ebp-$18], eax
005E62BA   C645EC00               mov     byte ptr [ebp-$14], $00
005E62BE   8D55E8                 lea     edx, [ebp-$18]
005E62C1   8B03                   mov     eax, [ebx]
005E62C3   8B405C                 mov     eax, [eax+$5C]
005E62C6   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005E62C8   E897CFEEFF             call    004D3264
005E62CD   8B03                   mov     eax, [ebx]
005E62CF   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.First(TDataSet);
|
005E62D5   E8FA8EECFF             call    004AF1D4
005E62DA   EB3C                   jmp     005E6318
005E62DC   8B03                   mov     eax, [ebx]
005E62DE   8B8014040000           mov     eax, [eax+$0414]
005E62E4   8B10                   mov     edx, [eax]
005E62E6   FF5258                 call    dword ptr [edx+$58]
005E62E9   3BF8                   cmp     edi, eax
005E62EB   750D                   jnz     005E62FA
005E62ED   8B03                   mov     eax, [ebx]
005E62EF   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Delete(TDataSet);
|
005E62F5   E81E96ECFF             call    004AF918
005E62FA   8B03                   mov     eax, [ebx]
005E62FC   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005E6302   E8E591ECFF             call    004AF4EC
005E6307   8B03                   mov     eax, [ebx]
005E6309   8B8080000000           mov     eax, [eax+$0080]
005E630F   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005E6316   7511                   jnz     005E6329
005E6318   8B03                   mov     eax, [ebx]
005E631A   8B8080000000           mov     eax, [eax+$0080]
005E6320   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005E6327   74B3                   jz      005E62DC
005E6329   897DE8                 mov     [ebp-$18], edi
005E632C   C645EC00               mov     byte ptr [ebp-$14], $00
005E6330   8D55E8                 lea     edx, [ebp-$18]
005E6333   8B03                   mov     eax, [ebx]
005E6335   8B405C                 mov     eax, [eax+$5C]
005E6338   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005E633A   E825CFEEFF             call    004D3264
005E633F   8BC6                   mov     eax, esi

* Reference to : TForm1.anzeigen()
|
005E6341   E856E0FEFF             call    005D439C
005E6346   33C0                   xor     eax, eax
005E6348   5A                     pop     edx
005E6349   59                     pop     ecx
005E634A   59                     pop     ecx
005E634B   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005E634E   6868635E00             push    $005E6368
005E6353   8D45F0                 lea     eax, [ebp-$10]
005E6356   BA03000000             mov     edx, $00000003

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E635B   E82CE8E1FF             call    00404B8C
005E6360   C3                     ret


* Reference to: System.@HandleFinally;
|
005E6361   E966E1E1FF             jmp     004044CC
005E6366   EBEB                   jmp     005E6353

****** END
|
005E6368   5F                     pop     edi
005E6369   5E                     pop     esi
005E636A   5B                     pop     ebx
005E636B   8BE5                   mov     esp, ebp
005E636D   5D                     pop     ebp
005E636E   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.StringGrid2 (TStringGrid)
Database/provider: DB.TDataSet.Edit(TDataSet);; DB.TDataSet.First(TDataSet);;
    DB.TDataSet.Next(TDataSet);
Global state: GlobalVar_0061DF08
Project calls: TForm1.anzeigen(); Unit_00408494.Proc_004099B4
Framework/API calls: Dialogs.Proc_004456EC;
    Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;; System.Proc_00404EE0
Strings/files/dialog text: '_^[��]�'; 'als Kind entfernen ?'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Kinderentfernen1Click(Sender : TObject);
begin
(*
005E7950   55                     push    ebp
005E7951   8BEC                   mov     ebp, esp
005E7953   6A00                   push    $00
005E7955   6A00                   push    $00
005E7957   6A00                   push    $00
005E7959   53                     push    ebx
005E795A   56                     push    esi
005E795B   57                     push    edi
005E795C   8BD8                   mov     ebx, eax

* Reference to pointer to GlobalVar_0061DF08
|
005E795E   8B3D3CCC6100           mov     edi, [$0061CC3C]
005E7964   33C0                   xor     eax, eax
005E7966   55                     push    ebp
005E7967   68A87A5E00             push    $005E7AA8

***** TRY
|
005E796C   64FF30                 push    dword ptr fs:[eax]
005E796F   648920                 mov     fs:[eax], esp
005E7972   6A00                   push    $00
005E7974   8D45F8                 lea     eax, [ebp-$08]
005E7977   50                     push    eax

* Reference to control TForm1.StringGrid2 : TStringGrid
|
005E7978   8BB374030000           mov     esi, [ebx+$0374]

* Reference to field TStringGrid.Row : Longint
|
005E797E   8B8E2C020000           mov     ecx, [esi+$022C]
005E7984   BA02000000             mov     edx, $00000002
005E7989   8BC6                   mov     eax, esi

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005E798B   E8FC80EFFF             call    004DFA8C
005E7990   FF75F8                 push    dword ptr [ebp-$08]
005E7993   68C07A5E00             push    $005E7AC0
005E7998   68CC7A5E00             push    $005E7ACC

* Possible String Reference to: 'als Kind entfernen ?'
|
005E799D   68D87A5E00             push    $005E7AD8
005E79A2   8D45FC                 lea     eax, [ebp-$04]
005E79A5   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005E79AA   E831D5E1FF             call    00404EE0
005E79AF   8B45FC                 mov     eax, [ebp-$04]
005E79B2   668B0DF07A5E00         mov     cx, word ptr [$005E7AF0]
005E79B9   B203                   mov     dl, $03

* Reference to: Dialogs.Proc_004456EC
|
005E79BB   E82CDDE5FF             call    004456EC
005E79C0   83F806                 cmp     eax, +$06
005E79C3   0F85BD000000           jnz     005E7A86
005E79C9   8B07                   mov     eax, [edi]
005E79CB   8B8090000000           mov     eax, [eax+$0090]

* Reference to: DB.TDataSet.First(TDataSet);
|
005E79D1   E8FE77ECFF             call    004AF1D4
005E79D6   E996000000             jmp     005E7A71
005E79DB   8D45F4                 lea     eax, [ebp-$0C]
005E79DE   50                     push    eax

* Reference to control TForm1.StringGrid2 : TStringGrid
|
005E79DF   8BB374030000           mov     esi, [ebx+$0374]

* Reference to field TStringGrid.Row : Longint
|
005E79E5   8B8E2C020000           mov     ecx, [esi+$022C]
005E79EB   BA01000000             mov     edx, $00000001
005E79F0   8BC6                   mov     eax, esi

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005E79F2   E89580EFFF             call    004DFA8C
005E79F7   8B45F4                 mov     eax, [ebp-$0C]

* Reference to: Unit_00408494.Proc_004099B4
|
005E79FA   E8B51FE2FF             call    004099B4
005E79FF   50                     push    eax
005E7A00   8B07                   mov     eax, [edi]
005E7A02   8B80780A0000           mov     eax, [eax+$0A78]
005E7A08   8B10                   mov     edx, [eax]
005E7A0A   FF5258                 call    dword ptr [edx+$58]
005E7A0D   5A                     pop     edx
005E7A0E   3BD0                   cmp     edx, eax
005E7A10   7541                   jnz     005E7A53
005E7A12   8B07                   mov     eax, [edi]
005E7A14   8B8090000000           mov     eax, [eax+$0090]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
005E7A1A   E8C17BECFF             call    004AF5E0
005E7A1F   8B07                   mov     eax, [edi]
005E7A21   8B807C0A0000           mov     eax, [eax+$0A7C]
005E7A27   33D2                   xor     edx, edx
005E7A29   8B08                   mov     ecx, [eax]
005E7A2B   FF91A8000000           call    dword ptr [ecx+$00A8]
005E7A31   8B07                   mov     eax, [edi]
005E7A33   8B80800A0000           mov     eax, [eax+$0A80]
005E7A39   33D2                   xor     edx, edx
005E7A3B   8B08                   mov     ecx, [eax]
005E7A3D   FF91A8000000           call    dword ptr [ecx+$00A8]
005E7A43   8B07                   mov     eax, [edi]
005E7A45   8B8090000000           mov     eax, [eax+$0090]
005E7A4B   8B10                   mov     edx, [eax]
005E7A4D   FF9248020000           call    dword ptr [edx+$0248]
005E7A53   8B07                   mov     eax, [edi]
005E7A55   8B8090000000           mov     eax, [eax+$0090]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005E7A5B   E88C7AECFF             call    004AF4EC
005E7A60   8B07                   mov     eax, [edi]
005E7A62   8B8090000000           mov     eax, [eax+$0090]
005E7A68   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005E7A6F   7515                   jnz     005E7A86
005E7A71   8B07                   mov     eax, [edi]
005E7A73   8B8090000000           mov     eax, [eax+$0090]
005E7A79   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005E7A80   0F8455FFFFFF           jz      005E79DB
005E7A86   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005E7A88   E80FC9FEFF             call    005D439C
005E7A8D   33C0                   xor     eax, eax
005E7A8F   5A                     pop     edx
005E7A90   59                     pop     ecx
005E7A91   59                     pop     ecx
005E7A92   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005E7A95   68AF7A5E00             push    $005E7AAF
005E7A9A   8D45F4                 lea     eax, [ebp-$0C]
005E7A9D   BA03000000             mov     edx, $00000003

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E7AA2   E8E5D0E1FF             call    00404B8C
005E7AA7   C3                     ret


* Reference to: System.@HandleFinally;
|
005E7AA8   E91FCAE1FF             jmp     004044CC
005E7AAD   EBEB                   jmp     005E7A9A

****** END
|
005E7AAF   5F                     pop     edi
005E7AB0   5E                     pop     esi
005E7AB1   5B                     pop     ebx
005E7AB2   8BE5                   mov     esp, ebp
005E7AB4   5D                     pop     ebp
005E7AB5   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Image1 (TImage); Label2 (TLabel); Label3 (TLabel); TForm1.ComboBox10 (TComboBox);
    TForm1.ComboBox11 (TComboBox); TForm1.ComboBox12 (TComboBox); TForm1.ComboBox13 (TComboBox);
    TForm1.ComboBox14 (TComboBox); TForm1.ComboBox15 (TComboBox); TForm1.ComboBox16 (TComboBox);
    TForm1.ComboBox17 (TComboBox); TForm1.ComboBox18 (TComboBox); TForm1.ComboBox19 (TComboBox);
    TForm1.ComboBox4 (TComboBox); TForm1.ComboBox6 (TComboBox); TForm1.ComboBox7 (TComboBox);
    TForm1.ComboBox8 (TComboBox); TForm1.ComboBox9 (TComboBox); TForm1.DBCheckBox1 (TDBCheckBox);
    TForm1.DBEdit7 (TDBEdit); TForm1.Edit1 (TEdit); TForm1.Edit2 (TDBEdit); TForm1.Image1 (TImage);
    TForm1.Label22 (TLabel); TForm1.Label23 (TLabel); TForm1.Label24 (TLabel); TForm1.Label25
    (TLabel); TForm1.Label27 (TLabel); TForm1.Label35 (TLabel); TForm1.Label50 (TLabel);
    TForm1.Label6 (TLabel); TForm1.Label7 (TLabel); TForm1.PageControl1 (TPageControl);
    TForm1.StringGrid1 (TStringGrid); TForm1.TabSheet3 (TTabSheet); TForm1.TabSheet7 (TTabSheet)
Database/provider: DB.TDataSet.Append(TDataSet);; DB.TDataSet.Open(TDataSet);;
    DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_025353D8; GlobalVar_02535878; GlobalVar_02535910;
    GlobalVar_02535914
Unresolved field offsets: OFFS_005C; OFFS_0098; OFFS_00C4; OFFS_00E8; OFFS_0540; OFFS_0548;
    OFFS_05B4; OFFS_07B0
Project calls: TForm1.anzeigen(); TForm1.elem(); Unit_00408494.Proc_004091D8;
    Unit_00408494.Proc_00409448; Unit_00408494.Proc_004099B4
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.GetText(TControl):TCaption;; Controls.TControl.SetText(TControl;TCaption);;
    Controls.TControl.SetVisible(TControl;Boolean);; Controls.TControl.Show(TControl);;
    Dialogs.ShowMessage(AnsiString);; ExtCtrls.TImage.SetPicture(TImage;TPicture);;
    Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);;
    Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;; method
    TDBCheckBox.SetChecked(Boolean); method TLabel.GetFloatingDockSiteClass(); System.Proc_00404EE0
Strings/files/dialog text: ' u. '; '_^[��]�'; 'aus'; 'Bitte zuerst Geschlecht eingeben.'; 'Kind
    einf�gen'; 'Kind von '; 'Kind von: '; '������_^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Kindereinfgen1Click(Sender : TObject);
begin
(*
005E7AF4   55                     push    ebp
005E7AF5   8BEC                   mov     ebp, esp
005E7AF7   B910000000             mov     ecx, $00000010
005E7AFC   6A00                   push    $00
005E7AFE   6A00                   push    $00
005E7B00   49                     dec     ecx
005E7B01   75F9                   jnz     005E7AFC
005E7B03   51                     push    ecx
005E7B04   53                     push    ebx
005E7B05   56                     push    esi
005E7B06   57                     push    edi
005E7B07   8BD8                   mov     ebx, eax

* Reference to pointer to GlobalVar_0061DF08
|
005E7B09   8B3D3CCC6100           mov     edi, [$0061CC3C]
005E7B0F   33C0                   xor     eax, eax
005E7B11   55                     push    ebp

* Possible String Reference to: '������_^[��]�'
|
005E7B12   68D5815E00             push    $005E81D5

***** TRY
|
005E7B17   64FF30                 push    dword ptr fs:[eax]
005E7B1A   648920                 mov     fs:[eax], esp
005E7B1D   C7051459530202000000   mov     dword ptr [$02535914], $00000002
005E7B27   8B07                   mov     eax, [edi]

* Reference to control TForm1.Label50 : TLabel
|
005E7B29   8B8034050000           mov     eax, [eax+$0534]
005E7B2F   8B10                   mov     edx, [eax]

* Reference to method TLabel.GetFloatingDockSiteClass()
|
005E7B31   FF5258                 call    dword ptr [edx+$58]

* Reference to GlobalVar_02535910
|
005E7B34   A310595302             mov     dword ptr [$02535910], eax
005E7B39   8D55FC                 lea     edx, [ebp-$04]
005E7B3C   8B07                   mov     eax, [edi]

* Reference to field GlobalVar_02535910.OFFS_0548
|
005E7B3E   8B8048050000           mov     eax, [eax+$0548]
005E7B44   8B08                   mov     ecx, [eax]
005E7B46   FF5160                 call    dword ptr [ecx+$60]
005E7B49   8D55F4                 lea     edx, [ebp-$0C]
005E7B4C   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409448
|
005E7B4F   E8F418E2FF             call    00409448
005E7B54   837DF400               cmp     dword ptr [ebp-$0C], +$00
005E7B58   7523                   jnz     005E7B7D
005E7B5A   33C0                   xor     eax, eax

* Reference to GlobalVar_02535914
|
005E7B5C   A314595302             mov     dword ptr [$02535914], eax

* Possible String Reference to: 'Bitte zuerst Geschlecht eingeben.'
|
005E7B61   B8EC815E00             mov     eax, $005E81EC

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005E7B66   E879DCE5FF             call    004457E4

* Reference to control TForm1.DBEdit7 : TDBEdit
|
005E7B6B   8B93B0030000           mov     edx, [ebx+$03B0]
005E7B71   8BC3                   mov     eax, ebx

* Reference to: Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);
|
005E7B73   E87802E8FF             call    00467DF0
005E7B78   E9F1050000             jmp     005E816E
005E7B7D   8B07                   mov     eax, [edi]

* Reference to control TForm1.Label50 : TLabel
|
005E7B7F   8B8034050000           mov     eax, [eax+$0534]
005E7B85   8B10                   mov     edx, [eax]

* Reference to method TLabel.GetFloatingDockSiteClass()
|
005E7B87   FF5258                 call    dword ptr [edx+$58]
005E7B8A   8945F8                 mov     [ebp-$08], eax

* Reference to pointer to GlobalVar_02535878
|
005E7B8D   A180C56100             mov     eax, dword ptr [$0061C580]
005E7B92   8B00                   mov     eax, [eax]

* Possible String Reference to: 'Kind einf�gen'
|
005E7B94   BA18825E00             mov     edx, $005E8218

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7B99   E8964EE6FF             call    0044CA34

* Reference to pointer to GlobalVar_02535878
|
005E7B9E   A180C56100             mov     eax, dword ptr [$0061C580]
005E7BA3   8B00                   mov     eax, [eax]
005E7BA5   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_02535878.OFFS_00E8
|
005E7BA7   FF92E8000000           call    dword ptr [edx+$00E8]
005E7BAD   33F6                   xor     esi, esi

* Reference to pointer to GlobalVar_02535878
|
005E7BAF   A180C56100             mov     eax, dword ptr [$0061C580]
005E7BB4   8B00                   mov     eax, [eax]

* Reference to control Image1 : TImage
|
005E7BB6   8B80F4020000           mov     eax, [eax+$02F4]
005E7BBC   8B10                   mov     edx, [eax]

* Possible reference to virtual method TImage.OFFS_00C4
|
005E7BBE   FF92C4000000           call    dword ptr [edx+$00C4]
005E7BC4   84C0                   test    al, al
005E7BC6   0F84C2030000           jz      005E7F8E

* Possible String Reference to: 'aus'
|
005E7BCC   BA30825E00             mov     edx, $005E8230
005E7BD1   8BC3                   mov     eax, ebx

* Reference to : TForm1.elem()
|
005E7BD3   E88C070000             call    005E8364
005E7BD8   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox4 : TComboBox
|
005E7BDA   8B8358080000           mov     eax, [ebx+$0858]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7BE0   E84F4EE6FF             call    0044CA34
005E7BE5   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox6 : TComboBox
|
005E7BE7   8B835C080000           mov     eax, [ebx+$085C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7BED   E8424EE6FF             call    0044CA34
005E7BF2   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox7 : TComboBox
|
005E7BF4   8B8360080000           mov     eax, [ebx+$0860]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7BFA   E8354EE6FF             call    0044CA34
005E7BFF   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox8 : TComboBox
|
005E7C01   8B8364080000           mov     eax, [ebx+$0864]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C07   E8284EE6FF             call    0044CA34
005E7C0C   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox9 : TComboBox
|
005E7C0E   8B8368080000           mov     eax, [ebx+$0868]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C14   E81B4EE6FF             call    0044CA34
005E7C19   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox11 : TComboBox
|
005E7C1B   8B8370080000           mov     eax, [ebx+$0870]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C21   E80E4EE6FF             call    0044CA34
005E7C26   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox12 : TComboBox
|
005E7C28   8B8374080000           mov     eax, [ebx+$0874]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C2E   E8014EE6FF             call    0044CA34
005E7C33   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox13 : TComboBox
|
005E7C35   8B8378080000           mov     eax, [ebx+$0878]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C3B   E8F44DE6FF             call    0044CA34
005E7C40   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox14 : TComboBox
|
005E7C42   8B837C080000           mov     eax, [ebx+$087C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C48   E8E74DE6FF             call    0044CA34
005E7C4D   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox15 : TComboBox
|
005E7C4F   8B8380080000           mov     eax, [ebx+$0880]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C55   E8DA4DE6FF             call    0044CA34
005E7C5A   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox16 : TComboBox
|
005E7C5C   8B8384080000           mov     eax, [ebx+$0884]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C62   E8CD4DE6FF             call    0044CA34
005E7C67   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox17 : TComboBox
|
005E7C69   8B8388080000           mov     eax, [ebx+$0888]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C6F   E8C04DE6FF             call    0044CA34
005E7C74   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox18 : TComboBox
|
005E7C76   8B838C080000           mov     eax, [ebx+$088C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C7C   E8B34DE6FF             call    0044CA34
005E7C81   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox19 : TComboBox
|
005E7C83   8B8390080000           mov     eax, [ebx+$0890]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7C89   E8A64DE6FF             call    0044CA34
005E7C8E   33D2                   xor     edx, edx

* Reference to control TForm1.DBCheckBox1 : TDBCheckBox
|
005E7C90   8B832C060000           mov     eax, [ebx+$062C]
005E7C96   8B08                   mov     ecx, [eax]

* Reference to method TDBCheckBox.SetChecked(Boolean)
|
005E7C98   FF91C8000000           call    dword ptr [ecx+$00C8]
005E7C9E   33D2                   xor     edx, edx

* Reference to control TForm1.Edit1 : TEdit
|
005E7CA0   8B83A8030000           mov     eax, [ebx+$03A8]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7CA6   E8894DE6FF             call    0044CA34
005E7CAB   33D2                   xor     edx, edx

* Reference to control TForm1.Edit2 : TDBEdit
|
005E7CAD   8B83AC030000           mov     eax, [ebx+$03AC]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7CB3   E87C4DE6FF             call    0044CA34
005E7CB8   33D2                   xor     edx, edx

* Reference to control TForm1.Label22 : TLabel
|
005E7CBA   8B834C040000           mov     eax, [ebx+$044C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7CC0   E86F4DE6FF             call    0044CA34
005E7CC5   33D2                   xor     edx, edx

* Reference to control TForm1.Label23 : TLabel
|
005E7CC7   8B8350040000           mov     eax, [ebx+$0450]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7CCD   E8624DE6FF             call    0044CA34
005E7CD2   33D2                   xor     edx, edx

* Reference to control TForm1.Label24 : TLabel
|
005E7CD4   8B8354040000           mov     eax, [ebx+$0454]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7CDA   E8554DE6FF             call    0044CA34
005E7CDF   33D2                   xor     edx, edx

* Reference to control TForm1.Label25 : TLabel
|
005E7CE1   8B8358040000           mov     eax, [ebx+$0458]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7CE7   E8484DE6FF             call    0044CA34
005E7CEC   33D2                   xor     edx, edx

* Reference to control TForm1.Label6 : TLabel
|
005E7CEE   8B8378030000           mov     eax, [ebx+$0378]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7CF4   E83B4DE6FF             call    0044CA34
005E7CF9   33D2                   xor     edx, edx

* Reference to control TForm1.Label7 : TLabel
|
005E7CFB   8B837C030000           mov     eax, [ebx+$037C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7D01   E82E4DE6FF             call    0044CA34
005E7D06   33D2                   xor     edx, edx

* Reference to control TForm1.Image1 : TImage
|
005E7D08   8B83B8060000           mov     eax, [ebx+$06B8]

* Reference to: ExtCtrls.TImage.SetPicture(TImage;TPicture);
|
005E7D0E   E8D195E5FF             call    004412E4
005E7D13   8D45EC                 lea     eax, [ebp-$14]
005E7D16   50                     push    eax

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005E7D17   8B8370030000           mov     eax, [ebx+$0370]

* Reference to field TStringGrid.Row : Longint
|
005E7D1D   8B882C020000           mov     ecx, [eax+$022C]
005E7D23   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005E7D28   8B8370030000           mov     eax, [ebx+$0370]

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005E7D2E   E8597DEFFF             call    004DFA8C
005E7D33   8B45EC                 mov     eax, [ebp-$14]
005E7D36   8D55F0                 lea     edx, [ebp-$10]

* Reference to: Unit_00408494.Proc_00409448
|
005E7D39   E80A17E2FF             call    00409448
005E7D3E   837DF000               cmp     dword ptr [ebp-$10], +$00
005E7D42   7626                   jbe     005E7D6A
005E7D44   8D45E8                 lea     eax, [ebp-$18]
005E7D47   50                     push    eax

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005E7D48   8BB370030000           mov     esi, [ebx+$0370]

* Reference to field TStringGrid.Row : Longint
|
005E7D4E   8B8E2C020000           mov     ecx, [esi+$022C]
005E7D54   BA01000000             mov     edx, $00000001
005E7D59   8BC6                   mov     eax, esi

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005E7D5B   E82C7DEFFF             call    004DFA8C
005E7D60   8B45E8                 mov     eax, [ebp-$18]

* Reference to: Unit_00408494.Proc_004099B4
|
005E7D63   E84C1CE2FF             call    004099B4
005E7D68   8BF0                   mov     esi, eax
005E7D6A   8B07                   mov     eax, [edi]

* Reference to field TStringGrid.ScalingFlags : TScalingFlags
|
005E7D6C   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E7D72   E8114FECFF             call    004ACC88
005E7D77   8B07                   mov     eax, [edi]

* Reference to field TScalingFlags.OFFS_0098
|
005E7D79   8B8098000000           mov     eax, [eax+$0098]
005E7D7F   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005E7D81   E8D6ADEEFF             call    004D2B5C
005E7D86   85F6                   test    esi, esi
005E7D88   0F8ECA000000           jle     005E7E58
005E7D8E   8975E0                 mov     [ebp-$20], esi
005E7D91   C645E400               mov     byte ptr [ebp-$1C], $00
005E7D95   8D55E0                 lea     edx, [ebp-$20]
005E7D98   8B07                   mov     eax, [edi]
005E7D9A   8B8098000000           mov     eax, [eax+$0098]
005E7DA0   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005E7DA2   E8BDB4EEFF             call    004D3264
005E7DA7   84C0                   test    al, al
005E7DA9   0F84F4000000           jz      005E7EA3

* Possible String Reference to: 'Kind von: '
|
005E7DAF   683C825E00             push    $005E823C
005E7DB4   8D55D8                 lea     edx, [ebp-$28]
005E7DB7   8B07                   mov     eax, [edi]
005E7DB9   8B8040050000           mov     eax, [eax+$0540]
005E7DBF   8B08                   mov     ecx, [eax]
005E7DC1   FF5160                 call    dword ptr [ecx+$60]
005E7DC4   FF75D8                 push    dword ptr [ebp-$28]
005E7DC7   6850825E00             push    $005E8250
005E7DCC   8D55D4                 lea     edx, [ebp-$2C]
005E7DCF   8B07                   mov     eax, [edi]
005E7DD1   8B8044050000           mov     eax, [eax+$0544]
005E7DD7   8B08                   mov     ecx, [eax]
005E7DD9   FF5160                 call    dword ptr [ecx+$60]
005E7DDC   FF75D4                 push    dword ptr [ebp-$2C]
005E7DDF   8D45DC                 lea     eax, [ebp-$24]
005E7DE2   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005E7DE7   E8F4D0E1FF             call    00404EE0
005E7DEC   8B55DC                 mov     edx, [ebp-$24]

* Reference to control TForm1.Label35 : TLabel
|
005E7DEF   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7DF5   E83A4CE6FF             call    0044CA34
005E7DFA   8D55CC                 lea     edx, [ebp-$34]

* Reference to control TForm1.Label35 : TLabel
|
005E7DFD   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.GetText(TControl):TCaption;
|
005E7E03   E8FC4BE6FF             call    0044CA04
005E7E08   FF75CC                 push    dword ptr [ebp-$34]

* Possible String Reference to: ' u. '
|
005E7E0B   685C825E00             push    $005E825C
005E7E10   8D55C8                 lea     edx, [ebp-$38]
005E7E13   8B07                   mov     eax, [edi]

* Reference to field TLabel.OFFS_07B0
|
005E7E15   8B80B0070000           mov     eax, [eax+$07B0]
005E7E1B   8B08                   mov     ecx, [eax]
005E7E1D   FF5160                 call    dword ptr [ecx+$60]
005E7E20   FF75C8                 push    dword ptr [ebp-$38]
005E7E23   6850825E00             push    $005E8250
005E7E28   8D55C4                 lea     edx, [ebp-$3C]
005E7E2B   8B07                   mov     eax, [edi]
005E7E2D   8B80B4070000           mov     eax, [eax+$07B4]
005E7E33   8B08                   mov     ecx, [eax]
005E7E35   FF5160                 call    dword ptr [ecx+$60]
005E7E38   FF75C4                 push    dword ptr [ebp-$3C]
005E7E3B   8D45D0                 lea     eax, [ebp-$30]
005E7E3E   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005E7E43   E898D0E1FF             call    00404EE0
005E7E48   8B55D0                 mov     edx, [ebp-$30]

* Reference to control TForm1.Label35 : TLabel
|
005E7E4B   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7E51   E8DE4BE6FF             call    0044CA34
005E7E56   EB4B                   jmp     005E7EA3

* Possible String Reference to: 'Kind von '
|
005E7E58   686C825E00             push    $005E826C
005E7E5D   8D55BC                 lea     edx, [ebp-$44]
005E7E60   8B07                   mov     eax, [edi]

* Reference to field TLabel.OFFS_0540
|
005E7E62   8B8040050000           mov     eax, [eax+$0540]
005E7E68   8B08                   mov     ecx, [eax]
005E7E6A   FF5160                 call    dword ptr [ecx+$60]
005E7E6D   FF75BC                 push    dword ptr [ebp-$44]
005E7E70   6850825E00             push    $005E8250
005E7E75   8D55B8                 lea     edx, [ebp-$48]
005E7E78   8B07                   mov     eax, [edi]
005E7E7A   8B8044050000           mov     eax, [eax+$0544]
005E7E80   8B08                   mov     ecx, [eax]
005E7E82   FF5160                 call    dword ptr [ecx+$60]
005E7E85   FF75B8                 push    dword ptr [ebp-$48]
005E7E88   8D45C0                 lea     eax, [ebp-$40]
005E7E8B   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005E7E90   E84BD0E1FF             call    00404EE0
005E7E95   8B55C0                 mov     edx, [ebp-$40]

* Reference to control TForm1.Label35 : TLabel
|
005E7E98   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E7E9E   E8914BE6FF             call    0044CA34
005E7EA3   B201                   mov     dl, $01

* Reference to control TForm1.Label35 : TLabel
|
005E7EA5   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005E7EAB   E8744AE6FF             call    0044C924
005E7EB0   8B07                   mov     eax, [edi]

* Reference to field TLabel.OFFS_005C
|
005E7EB2   8B405C                 mov     eax, [eax+$5C]
005E7EB5   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005E7EB7   E8A0ACEEFF             call    004D2B5C
005E7EBC   8B07                   mov     eax, [edi]
005E7EBE   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005E7EC1   E85E78ECFF             call    004AF724
005E7EC6   33D2                   xor     edx, edx

* Reference to control TForm1.DBCheckBox1 : TDBCheckBox
|
005E7EC8   8B832C060000           mov     eax, [ebx+$062C]
005E7ECE   8B08                   mov     ecx, [eax]

* Reference to method TDBCheckBox.SetChecked(Boolean)
|
005E7ED0   FF91C8000000           call    dword ptr [ecx+$00C8]
005E7ED6   8B07                   mov     eax, [edi]

* Reference to field TDBCheckBox.OFFS_05B4
|
005E7ED8   8B80B4050000           mov     eax, [eax+$05B4]
005E7EDE   BA80825E00             mov     edx, $005E8280
005E7EE3   8B08                   mov     ecx, [eax]
005E7EE5   FF91B0000000           call    dword ptr [ecx+$00B0]
005E7EEB   8D55B4                 lea     edx, [ebp-$4C]
005E7EEE   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_004091D8
|
005E7EF1   E8E212E2FF             call    004091D8
005E7EF6   8B45B4                 mov     eax, [ebp-$4C]
005E7EF9   BA8C825E00             mov     edx, $005E828C

* Reference to: System.@LStrCmp;
|
005E7EFE   E861D0E1FF             call    00404F64
005E7F03   7525                   jnz     005E7F2A
005E7F05   8B07                   mov     eax, [edi]
005E7F07   8B8038050000           mov     eax, [eax+$0538]
005E7F0D   8B55F8                 mov     edx, [ebp-$08]
005E7F10   8B08                   mov     ecx, [eax]
005E7F12   FF91A8000000           call    dword ptr [ecx+$00A8]
005E7F18   8B07                   mov     eax, [edi]
005E7F1A   8B803C050000           mov     eax, [eax+$053C]
005E7F20   8BD6                   mov     edx, esi
005E7F22   8B08                   mov     ecx, [eax]
005E7F24   FF91A8000000           call    dword ptr [ecx+$00A8]
005E7F2A   8D55B0                 lea     edx, [ebp-$50]
005E7F2D   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_004091D8
|
005E7F30   E8A312E2FF             call    004091D8
005E7F35   8B45B0                 mov     eax, [ebp-$50]
005E7F38   BA98825E00             mov     edx, $005E8298

* Reference to: System.@LStrCmp;
|
005E7F3D   E822D0E1FF             call    00404F64
005E7F42   7525                   jnz     005E7F69
005E7F44   8B07                   mov     eax, [edi]
005E7F46   8B803C050000           mov     eax, [eax+$053C]
005E7F4C   8B55F8                 mov     edx, [ebp-$08]
005E7F4F   8B08                   mov     ecx, [eax]
005E7F51   FF91A8000000           call    dword ptr [ecx+$00A8]
005E7F57   8B07                   mov     eax, [edi]
005E7F59   8B8038050000           mov     eax, [eax+$0538]
005E7F5F   8BD6                   mov     edx, esi
005E7F61   8B08                   mov     ecx, [eax]
005E7F63   FF91A8000000           call    dword ptr [ecx+$00A8]

* Reference to control TForm1.TabSheet3 : TTabSheet
|
005E7F69   8B9344030000           mov     edx, [ebx+$0344]

* Reference to control TForm1.PageControl1 : TPageControl
|
005E7F6F   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005E7F75   E83E7EE9FF             call    0047FDB8

* Reference to control TForm1.ComboBox10 : TComboBox
|
005E7F7A   8B936C080000           mov     edx, [ebx+$086C]
005E7F80   8BC3                   mov     eax, ebx

* Reference to: Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);
|
005E7F82   E869FEE7FF             call    00467DF0
005E7F87   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005E7F89   E80EC4FEFF             call    005D439C

* Reference to pointer to GlobalVar_02535878
|
005E7F8E   A180C56100             mov     eax, dword ptr [$0061C580]
005E7F93   8B00                   mov     eax, [eax]

* Reference to control Label2 : TLabel
|
005E7F95   8B80F8020000           mov     eax, [eax+$02F8]
005E7F9B   8B10                   mov     edx, [eax]

* Possible reference to virtual method TLabel.OFFS_00C4
|
005E7F9D   FF92C4000000           call    dword ptr [edx+$00C4]
005E7FA3   84C0                   test    al, al
005E7FA5   0F84BC010000           jz      005E8167

* Possible String Reference to: 'aus'
|
005E7FAB   BA30825E00             mov     edx, $005E8230
005E7FB0   8BC3                   mov     eax, ebx

* Reference to : TForm1.elem()
|
005E7FB2   E8AD030000             call    005E8364
005E7FB7   8B07                   mov     eax, [edi]

* Reference to field TForm1.ScalingFlags : TScalingFlags
|
005E7FB9   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E7FBF   E8C44CECFF             call    004ACC88
005E7FC4   8B07                   mov     eax, [edi]

* Reference to field TScalingFlags.OFFS_0098
|
005E7FC6   8B8098000000           mov     eax, [eax+$0098]
005E7FCC   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005E7FCE   E889ABEEFF             call    004D2B5C
005E7FD3   8D45A8                 lea     eax, [ebp-$58]
005E7FD6   50                     push    eax

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005E7FD7   8BB370030000           mov     esi, [ebx+$0370]

* Reference to field TStringGrid.Row : Longint
|
005E7FDD   8B8E2C020000           mov     ecx, [esi+$022C]
005E7FE3   BA01000000             mov     edx, $00000001
005E7FE8   8BC6                   mov     eax, esi

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005E7FEA   E89D7AEFFF             call    004DFA8C
005E7FEF   8B45A8                 mov     eax, [ebp-$58]
005E7FF2   8D55AC                 lea     edx, [ebp-$54]

* Reference to: Unit_00408494.Proc_00409448
|
005E7FF5   E84E14E2FF             call    00409448
005E7FFA   837DAC00               cmp     dword ptr [ebp-$54], +$00
005E7FFE   0F86E4000000           jbe     005E80E8
005E8004   8D45A4                 lea     eax, [ebp-$5C]
005E8007   50                     push    eax

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005E8008   8BB370030000           mov     esi, [ebx+$0370]

* Reference to field TStringGrid.Row : Longint
|
005E800E   8B8E2C020000           mov     ecx, [esi+$022C]
005E8014   BA01000000             mov     edx, $00000001
005E8019   8BC6                   mov     eax, esi

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005E801B   E86C7AEFFF             call    004DFA8C
005E8020   8B45A4                 mov     eax, [ebp-$5C]

* Reference to: Unit_00408494.Proc_004099B4
|
005E8023   E88C19E2FF             call    004099B4
005E8028   8945E0                 mov     [ebp-$20], eax
005E802B   C645E400               mov     byte ptr [ebp-$1C], $00
005E802F   8D55E0                 lea     edx, [ebp-$20]
005E8032   8B07                   mov     eax, [edi]

* Reference to field TStringGrid.ScalingFlags : TScalingFlags
|
005E8034   8B8098000000           mov     eax, [eax+$0098]
005E803A   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005E803C   E823B2EEFF             call    004D3264

* Possible String Reference to: 'Kind von '
|
005E8041   686C825E00             push    $005E826C
005E8046   8D559C                 lea     edx, [ebp-$64]
005E8049   8B07                   mov     eax, [edi]

* Reference to field TScalingFlags.OFFS_0540
|
005E804B   8B8040050000           mov     eax, [eax+$0540]
005E8051   8B08                   mov     ecx, [eax]
005E8053   FF5160                 call    dword ptr [ecx+$60]
005E8056   FF759C                 push    dword ptr [ebp-$64]
005E8059   6850825E00             push    $005E8250
005E805E   8D5598                 lea     edx, [ebp-$68]
005E8061   8B07                   mov     eax, [edi]
005E8063   8B8044050000           mov     eax, [eax+$0544]
005E8069   8B08                   mov     ecx, [eax]
005E806B   FF5160                 call    dword ptr [ecx+$60]
005E806E   FF7598                 push    dword ptr [ebp-$68]
005E8071   8D45A0                 lea     eax, [ebp-$60]
005E8074   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005E8079   E862CEE1FF             call    00404EE0
005E807E   8B55A0                 mov     edx, [ebp-$60]

* Reference to control TForm1.Label27 : TLabel
|
005E8081   8B838C040000           mov     eax, [ebx+$048C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8087   E8A849E6FF             call    0044CA34
005E808C   8D5590                 lea     edx, [ebp-$70]

* Reference to control TForm1.Label27 : TLabel
|
005E808F   8BB38C040000           mov     esi, [ebx+$048C]
005E8095   8BC6                   mov     eax, esi

* Reference to: Controls.TControl.GetText(TControl):TCaption;
|
005E8097   E86849E6FF             call    0044CA04
005E809C   FF7590                 push    dword ptr [ebp-$70]

* Possible String Reference to: ' u. '
|
005E809F   685C825E00             push    $005E825C
005E80A4   8D558C                 lea     edx, [ebp-$74]
005E80A7   8B07                   mov     eax, [edi]

* Reference to field TLabel.OFFS_07B0
|
005E80A9   8B80B0070000           mov     eax, [eax+$07B0]
005E80AF   8B08                   mov     ecx, [eax]
005E80B1   FF5160                 call    dword ptr [ecx+$60]
005E80B4   FF758C                 push    dword ptr [ebp-$74]
005E80B7   6850825E00             push    $005E8250
005E80BC   8D5588                 lea     edx, [ebp-$78]
005E80BF   8B07                   mov     eax, [edi]
005E80C1   8B80B4070000           mov     eax, [eax+$07B4]
005E80C7   8B08                   mov     ecx, [eax]
005E80C9   FF5160                 call    dword ptr [ecx+$60]
005E80CC   FF7588                 push    dword ptr [ebp-$78]
005E80CF   8D4594                 lea     eax, [ebp-$6C]
005E80D2   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005E80D7   E804CEE1FF             call    00404EE0
005E80DC   8B5594                 mov     edx, [ebp-$6C]
005E80DF   8BC6                   mov     eax, esi

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E80E1   E84E49E6FF             call    0044CA34
005E80E6   EB51                   jmp     005E8139

* Possible String Reference to: 'Kind von '
|
005E80E8   686C825E00             push    $005E826C
005E80ED   8D5580                 lea     edx, [ebp-$80]
005E80F0   8B07                   mov     eax, [edi]

* Reference to field TLabel.OFFS_0540
|
005E80F2   8B8040050000           mov     eax, [eax+$0540]
005E80F8   8B08                   mov     ecx, [eax]
005E80FA   FF5160                 call    dword ptr [ecx+$60]
005E80FD   FF7580                 push    dword ptr [ebp-$80]
005E8100   6850825E00             push    $005E8250
005E8105   8D957CFFFFFF           lea     edx, [ebp+$FFFFFF7C]
005E810B   8B07                   mov     eax, [edi]
005E810D   8B8044050000           mov     eax, [eax+$0544]
005E8113   8B08                   mov     ecx, [eax]
005E8115   FF5160                 call    dword ptr [ecx+$60]
005E8118   FFB57CFFFFFF           push    dword ptr [ebp+$FFFFFF7C]
005E811E   8D4584                 lea     eax, [ebp-$7C]
005E8121   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005E8126   E8B5CDE1FF             call    00404EE0
005E812B   8B5584                 mov     edx, [ebp-$7C]

* Reference to control TForm1.Label27 : TLabel
|
005E812E   8B838C040000           mov     eax, [ebx+$048C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8134   E8FB48E6FF             call    0044CA34

* Reference to control TForm1.TabSheet7 : TTabSheet
|
005E8139   8B8380040000           mov     eax, [ebx+$0480]

* Reference to: Controls.TControl.Show(TControl);
|
005E813F   E8004EE6FF             call    0044CF44

* Reference to pointer to GlobalVar_025353D8
|
005E8144   A168C86100             mov     eax, dword ptr [$0061C868]
005E8149   8B00                   mov     eax, [eax]

* Reference to control Label3 : TLabel
|
005E814B   8B80FC020000           mov     eax, [eax+$02FC]
005E8151   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8153   E8DC48E6FF             call    0044CA34

* Reference to pointer to GlobalVar_025353D8
|
005E8158   A168C86100             mov     eax, dword ptr [$0061C868]
005E815D   8B00                   mov     eax, [eax]
005E815F   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_025353D8.OFFS_00E8
|
005E8161   FF92E8000000           call    dword ptr [edx+$00E8]
005E8167   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005E8169   E82EC2FEFF             call    005D439C
005E816E   33C0                   xor     eax, eax
005E8170   5A                     pop     edx
005E8171   59                     pop     ecx
005E8172   59                     pop     ecx
005E8173   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005E8176   68DC815E00             push    $005E81DC
005E817B   8D857CFFFFFF           lea     eax, [ebp+$FFFFFF7C]
005E8181   BA05000000             mov     edx, $00000005

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E8186   E801CAE1FF             call    00404B8C
005E818B   8D4590                 lea     eax, [ebp-$70]
005E818E   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E8193   E8F4C9E1FF             call    00404B8C
005E8198   8D4598                 lea     eax, [ebp-$68]
005E819B   BA0D000000             mov     edx, $0000000D

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E81A0   E8E7C9E1FF             call    00404B8C
005E81A5   8D45CC                 lea     eax, [ebp-$34]
005E81A8   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E81AD   E8DAC9E1FF             call    00404B8C
005E81B2   8D45D4                 lea     eax, [ebp-$2C]
005E81B5   BA03000000             mov     edx, $00000003

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E81BA   E8CDC9E1FF             call    00404B8C
005E81BF   8D45E8                 lea     eax, [ebp-$18]
005E81C2   BA04000000             mov     edx, $00000004

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E81C7   E8C0C9E1FF             call    00404B8C
005E81CC   8D45FC                 lea     eax, [ebp-$04]

* Reference to: System.@LStrClr(void;void);
|
005E81CF   E894C9E1FF             call    00404B68
005E81D4   C3                     ret


* Reference to: System.@HandleFinally;
|
005E81D5   E9F2C2E1FF             jmp     004044CC
005E81DA   EB9F                   jmp     005E817B

****** END
|
005E81DC   5F                     pop     edi
005E81DD   5E                     pop     esi
005E81DE   5B                     pop     ebx
005E81DF   8BE5                   mov     esp, ebp
005E81E1   5D                     pop     ebp
005E81E2   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Image1 (TImage); Label2 (TLabel); TForm1.ComboBox10 (TComboBox); TForm1.ComboBox11
    (TComboBox); TForm1.ComboBox12 (TComboBox); TForm1.ComboBox13 (TComboBox); TForm1.ComboBox14
    (TComboBox); TForm1.ComboBox15 (TComboBox); TForm1.ComboBox16 (TComboBox); TForm1.ComboBox17
    (TComboBox); TForm1.ComboBox18 (TComboBox); TForm1.ComboBox19 (TComboBox); TForm1.ComboBox23
    (TComboBox); TForm1.ComboBox24 (TComboBox); TForm1.ComboBox25 (TComboBox); TForm1.ComboBox4
    (TComboBox); TForm1.ComboBox6 (TComboBox); TForm1.ComboBox7 (TComboBox); TForm1.ComboBox8
    (TComboBox); TForm1.ComboBox9 (TComboBox); TForm1.DBCheckBox1 (TDBCheckBox); TForm1.DBEdit7
    (TDBEdit); TForm1.DBGrid2 (TDBGrid); TForm1.Edit1 (TEdit); TForm1.Edit2 (TDBEdit); TForm1.Image1
    (TImage); TForm1.Label22 (TLabel); TForm1.Label23 (TLabel); TForm1.Label24 (TLabel);
    TForm1.Label25 (TLabel); TForm1.Label27 (TLabel); TForm1.Label35 (TLabel); TForm1.Label6
    (TLabel); TForm1.Label7 (TLabel); TForm1.PageControl1 (TPageControl); TForm1.TabSheet3
    (TTabSheet); TForm1.TabSheet7 (TTabSheet)
Database/provider: DB.TDataSet.Append(TDataSet);; DB.TDataSet.Open(TDataSet);;
    DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
Global state: GlobalVar_0061DF08; GlobalVar_025353D8; GlobalVar_02535878; GlobalVar_02535910;
    GlobalVar_02535914; GlobalVar_02535918
Unresolved field offsets: OFFS_00C4; OFFS_00E8
Project calls: TForm1.anzeigen(); TForm1.elem(); TForm1.elem_leer(); Unit_00408494.Proc_004091D8;
    Unit_00408494.Proc_00409448
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Controls.TControl.SetVisible(TControl;Boolean);;
    Controls.TControl.Show(TControl);; Dialogs.ShowMessage(AnsiString);;
    ExtCtrls.TImage.SetPicture(TImage;TPicture);;
    Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);; method
    TDBCheckBox.SetChecked(Boolean); QControls.TGraphicControl.PaintRequest(TGraphicControl);;
    System.Proc_00404EE0
Strings/files/dialog text: 'Bitte erst Geschlecht eingeben.'; 'ein'; 'Verbindung einf�gen';
    'Verbindung von '
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Verbindungeinfgen1Click(Sender : TObject);
begin
(*
005E852C   55                     push    ebp
005E852D   8BEC                   mov     ebp, esp
005E852F   B927000000             mov     ecx, $00000027
005E8534   6A00                   push    $00
005E8536   6A00                   push    $00
005E8538   49                     dec     ecx
005E8539   75F9                   jnz     005E8534
005E853B   51                     push    ecx
005E853C   53                     push    ebx
005E853D   56                     push    esi
005E853E   8BD8                   mov     ebx, eax

* Reference to pointer to GlobalVar_0061DF08
|
005E8540   8B353CCC6100           mov     esi, [$0061CC3C]
005E8546   33C0                   xor     eax, eax
005E8548   55                     push    ebp
005E8549   680B8A5E00             push    $005E8A0B

***** TRY
|
005E854E   64FF30                 push    dword ptr fs:[eax]
005E8551   648920                 mov     fs:[eax], esp
005E8554   8B06                   mov     eax, [esi]
005E8556   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E855C   E82747ECFF             call    004ACC88
005E8561   33C0                   xor     eax, eax

* Reference to GlobalVar_02535918
|
005E8563   A318595302             mov     dword ptr [$02535918], eax
005E8568   C7051459530201000000   mov     dword ptr [$02535914], $00000001
005E8572   8B06                   mov     eax, [esi]
005E8574   8B8034050000           mov     eax, [eax+$0534]
005E857A   8B10                   mov     edx, [eax]
005E857C   FF5258                 call    dword ptr [edx+$58]

* Reference to GlobalVar_02535910
|
005E857F   A310595302             mov     dword ptr [$02535910], eax
005E8584   8D55F4                 lea     edx, [ebp-$0C]
005E8587   8B06                   mov     eax, [esi]
005E8589   8B8048050000           mov     eax, [eax+$0548]
005E858F   8B08                   mov     ecx, [eax]
005E8591   FF5160                 call    dword ptr [ecx+$60]
005E8594   8B45F4                 mov     eax, [ebp-$0C]
005E8597   8D55F8                 lea     edx, [ebp-$08]

* Reference to: Unit_00408494.Proc_00409448
|
005E859A   E8A90EE2FF             call    00409448
005E859F   837DF800               cmp     dword ptr [ebp-$08], +$00
005E85A3   7523                   jnz     005E85C8

* Possible String Reference to: 'Bitte erst Geschlecht eingeben.'
|
005E85A5   B8208A5E00             mov     eax, $005E8A20

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005E85AA   E835D2E5FF             call    004457E4

* Reference to control TForm1.DBEdit7 : TDBEdit
|
005E85AF   8B93B0030000           mov     edx, [ebx+$03B0]
005E85B5   8BC3                   mov     eax, ebx

* Reference to: Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);
|
005E85B7   E834F8E7FF             call    00467DF0
005E85BC   33C0                   xor     eax, eax

* Reference to GlobalVar_02535914
|
005E85BE   A314595302             mov     dword ptr [$02535914], eax
005E85C3   E918040000             jmp     005E89E0
005E85C8   8B06                   mov     eax, [esi]
005E85CA   8B8034050000           mov     eax, [eax+$0534]
005E85D0   8B10                   mov     edx, [eax]
005E85D2   FF5258                 call    dword ptr [edx+$58]
005E85D5   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]
005E85DB   8B06                   mov     eax, [esi]
005E85DD   8B8048050000           mov     eax, [eax+$0548]
005E85E3   8B08                   mov     ecx, [eax]
005E85E5   FF5160                 call    dword ptr [ecx+$60]
005E85E8   8B85ECFEFFFF           mov     eax, [ebp+$FFFFFEEC]
005E85EE   8D95F0FEFFFF           lea     edx, [ebp+$FFFFFEF0]

* Reference to: Unit_00408494.Proc_004091D8
|
005E85F4   E8DF0BE2FF             call    004091D8
005E85F9   8B95F0FEFFFF           mov     edx, [ebp+$FFFFFEF0]
005E85FF   8D85F4FEFFFF           lea     eax, [ebp+$FFFFFEF4]
005E8605   B9FF000000             mov     ecx, $000000FF

* Reference to: System.@LStrToString;
|
005E860A   E8EDC7E1FF             call    00404DFC
005E860F   8D95F4FEFFFF           lea     edx, [ebp+$FFFFFEF4]
005E8615   8D45FE                 lea     eax, [ebp-$02]
005E8618   B101                   mov     cl, $01

* Reference to: System.@PStrNCpy(PShortString;PShortString;Byte);
|
005E861A   E881ABE1FF             call    004031A0

* Reference to pointer to GlobalVar_02535878
|
005E861F   A180C56100             mov     eax, dword ptr [$0061C580]
005E8624   8B00                   mov     eax, [eax]

* Possible String Reference to: 'Verbindung einf�gen'
|
005E8626   BA488A5E00             mov     edx, $005E8A48

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E862B   E80444E6FF             call    0044CA34

* Reference to pointer to GlobalVar_02535878
|
005E8630   A180C56100             mov     eax, dword ptr [$0061C580]
005E8635   8B00                   mov     eax, [eax]
005E8637   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_02535878.OFFS_00E8
|
005E8639   FF92E8000000           call    dword ptr [edx+$00E8]

* Reference to pointer to GlobalVar_02535878
|
005E863F   A180C56100             mov     eax, dword ptr [$0061C580]
005E8644   8B00                   mov     eax, [eax]

* Reference to control Image1 : TImage
|
005E8646   8B80F4020000           mov     eax, [eax+$02F4]
005E864C   8B10                   mov     edx, [eax]

* Possible reference to virtual method TImage.OFFS_00C4
|
005E864E   FF92C4000000           call    dword ptr [edx+$00C4]
005E8654   84C0                   test    al, al
005E8656   0F84DC020000           jz      005E8938
005E865C   8BC3                   mov     eax, ebx

* Reference to : TForm1.elem_leer()
|
005E865E   E839FCFFFF             call    005E829C

* Possible String Reference to: 'ein'
|
005E8663   BA648A5E00             mov     edx, $005E8A64
005E8668   8BC3                   mov     eax, ebx

* Reference to : TForm1.elem()
|
005E866A   E8F5FCFFFF             call    005E8364
005E866F   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox4 : TComboBox
|
005E8671   8B8358080000           mov     eax, [ebx+$0858]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8677   E8B843E6FF             call    0044CA34
005E867C   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox6 : TComboBox
|
005E867E   8B835C080000           mov     eax, [ebx+$085C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8684   E8AB43E6FF             call    0044CA34
005E8689   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox7 : TComboBox
|
005E868B   8B8360080000           mov     eax, [ebx+$0860]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8691   E89E43E6FF             call    0044CA34
005E8696   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox8 : TComboBox
|
005E8698   8B8364080000           mov     eax, [ebx+$0864]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E869E   E89143E6FF             call    0044CA34
005E86A3   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox9 : TComboBox
|
005E86A5   8B8368080000           mov     eax, [ebx+$0868]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E86AB   E88443E6FF             call    0044CA34
005E86B0   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox10 : TComboBox
|
005E86B2   8B836C080000           mov     eax, [ebx+$086C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E86B8   E87743E6FF             call    0044CA34
005E86BD   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox11 : TComboBox
|
005E86BF   8B8370080000           mov     eax, [ebx+$0870]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E86C5   E86A43E6FF             call    0044CA34
005E86CA   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox12 : TComboBox
|
005E86CC   8B8374080000           mov     eax, [ebx+$0874]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E86D2   E85D43E6FF             call    0044CA34
005E86D7   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox13 : TComboBox
|
005E86D9   8B8378080000           mov     eax, [ebx+$0878]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E86DF   E85043E6FF             call    0044CA34
005E86E4   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox14 : TComboBox
|
005E86E6   8B837C080000           mov     eax, [ebx+$087C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E86EC   E84343E6FF             call    0044CA34
005E86F1   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox15 : TComboBox
|
005E86F3   8B8380080000           mov     eax, [ebx+$0880]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E86F9   E83643E6FF             call    0044CA34
005E86FE   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox16 : TComboBox
|
005E8700   8B8384080000           mov     eax, [ebx+$0884]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8706   E82943E6FF             call    0044CA34
005E870B   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox17 : TComboBox
|
005E870D   8B8388080000           mov     eax, [ebx+$0888]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8713   E81C43E6FF             call    0044CA34
005E8718   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox18 : TComboBox
|
005E871A   8B838C080000           mov     eax, [ebx+$088C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8720   E80F43E6FF             call    0044CA34
005E8725   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox19 : TComboBox
|
005E8727   8B8390080000           mov     eax, [ebx+$0890]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E872D   E80243E6FF             call    0044CA34
005E8732   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox23 : TComboBox
|
005E8734   8B83A0080000           mov     eax, [ebx+$08A0]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E873A   E8F542E6FF             call    0044CA34
005E873F   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox24 : TComboBox
|
005E8741   8B83A4080000           mov     eax, [ebx+$08A4]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8747   E8E842E6FF             call    0044CA34
005E874C   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox25 : TComboBox
|
005E874E   8B83A8080000           mov     eax, [ebx+$08A8]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8754   E8DB42E6FF             call    0044CA34
005E8759   33D2                   xor     edx, edx

* Reference to control TForm1.DBCheckBox1 : TDBCheckBox
|
005E875B   8B832C060000           mov     eax, [ebx+$062C]
005E8761   8B08                   mov     ecx, [eax]

* Reference to method TDBCheckBox.SetChecked(Boolean)
|
005E8763   FF91C8000000           call    dword ptr [ecx+$00C8]
005E8769   33D2                   xor     edx, edx

* Reference to control TForm1.Edit1 : TEdit
|
005E876B   8B83A8030000           mov     eax, [ebx+$03A8]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8771   E8BE42E6FF             call    0044CA34
005E8776   33D2                   xor     edx, edx

* Reference to control TForm1.Edit2 : TDBEdit
|
005E8778   8B83AC030000           mov     eax, [ebx+$03AC]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E877E   E8B142E6FF             call    0044CA34
005E8783   33D2                   xor     edx, edx

* Reference to control TForm1.Label22 : TLabel
|
005E8785   8B834C040000           mov     eax, [ebx+$044C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E878B   E8A442E6FF             call    0044CA34
005E8790   33D2                   xor     edx, edx

* Reference to control TForm1.Label23 : TLabel
|
005E8792   8B8350040000           mov     eax, [ebx+$0450]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8798   E89742E6FF             call    0044CA34
005E879D   33D2                   xor     edx, edx

* Reference to control TForm1.Label24 : TLabel
|
005E879F   8B8354040000           mov     eax, [ebx+$0454]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E87A5   E88A42E6FF             call    0044CA34
005E87AA   33D2                   xor     edx, edx

* Reference to control TForm1.Label25 : TLabel
|
005E87AC   8B8358040000           mov     eax, [ebx+$0458]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E87B2   E87D42E6FF             call    0044CA34
005E87B7   33D2                   xor     edx, edx

* Reference to control TForm1.Label6 : TLabel
|
005E87B9   8B8378030000           mov     eax, [ebx+$0378]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E87BF   E87042E6FF             call    0044CA34
005E87C4   33D2                   xor     edx, edx

* Reference to control TForm1.Label7 : TLabel
|
005E87C6   8B837C030000           mov     eax, [ebx+$037C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E87CC   E86342E6FF             call    0044CA34
005E87D1   33D2                   xor     edx, edx

* Reference to control TForm1.Image1 : TImage
|
005E87D3   8B83B8060000           mov     eax, [ebx+$06B8]

* Reference to: ExtCtrls.TImage.SetPicture(TImage;TPicture);
|
005E87D9   E8068BE5FF             call    004412E4

* Possible String Reference to: 'Verbindung von '
|
005E87DE   68708A5E00             push    $005E8A70
005E87E3   8D95E4FEFFFF           lea     edx, [ebp+$FFFFFEE4]
005E87E9   8B06                   mov     eax, [esi]
005E87EB   8B8040050000           mov     eax, [eax+$0540]
005E87F1   8B08                   mov     ecx, [eax]
005E87F3   FF5160                 call    dword ptr [ecx+$60]
005E87F6   FFB5E4FEFFFF           push    dword ptr [ebp+$FFFFFEE4]
005E87FC   68888A5E00             push    $005E8A88
005E8801   8D95E0FEFFFF           lea     edx, [ebp+$FFFFFEE0]
005E8807   8B06                   mov     eax, [esi]
005E8809   8B8044050000           mov     eax, [eax+$0544]
005E880F   8B08                   mov     ecx, [eax]
005E8811   FF5160                 call    dword ptr [ecx+$60]
005E8814   FFB5E0FEFFFF           push    dword ptr [ebp+$FFFFFEE0]
005E881A   8D85E8FEFFFF           lea     eax, [ebp+$FFFFFEE8]
005E8820   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005E8825   E8B6C6E1FF             call    00404EE0
005E882A   8B95E8FEFFFF           mov     edx, [ebp+$FFFFFEE8]

* Reference to control TForm1.Label35 : TLabel
|
005E8830   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E8836   E8F941E6FF             call    0044CA34
005E883B   B201                   mov     dl, $01

* Reference to control TForm1.Label35 : TLabel
|
005E883D   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005E8843   E8DC40E6FF             call    0044C924

* Reference to control TForm1.Label35 : TLabel
|
005E8848   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: QControls.TGraphicControl.PaintRequest(TGraphicControl);
|
005E884E   E83547E6FF             call    0044CF88
005E8853   8B06                   mov     eax, [esi]
005E8855   8B405C                 mov     eax, [eax+$5C]
005E8858   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005E885A   E8FDA2EEFF             call    004D2B5C
005E885F   8B06                   mov     eax, [esi]
005E8861   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005E8864   E8BB6EECFF             call    004AF724
005E8869   33D2                   xor     edx, edx

* Reference to control TForm1.DBCheckBox1 : TDBCheckBox
|
005E886B   8B832C060000           mov     eax, [ebx+$062C]
005E8871   8B08                   mov     ecx, [eax]

* Reference to method TDBCheckBox.SetChecked(Boolean)
|
005E8873   FF91C8000000           call    dword ptr [ecx+$00C8]
005E8879   8B06                   mov     eax, [esi]
005E887B   8B80B4050000           mov     eax, [eax+$05B4]
005E8881   BA948A5E00             mov     edx, $005E8A94
005E8886   8B08                   mov     ecx, [eax]
005E8888   FF91B0000000           call    dword ptr [ecx+$00B0]
005E888E   8D85D8FEFFFF           lea     eax, [ebp+$FFFFFED8]
005E8894   8D55FE                 lea     edx, [ebp-$02]

* Reference to: System.@LStrFromString(String;String;ShortString;ShortString);
|
005E8897   E828C5E1FF             call    00404DC4
005E889C   8B85D8FEFFFF           mov     eax, [ebp+$FFFFFED8]
005E88A2   8D95DCFEFFFF           lea     edx, [ebp+$FFFFFEDC]

* Reference to: Unit_00408494.Proc_004091D8
|
005E88A8   E82B09E2FF             call    004091D8
005E88AD   8B85DCFEFFFF           mov     eax, [ebp+$FFFFFEDC]
005E88B3   BAA08A5E00             mov     edx, $005E8AA0

* Reference to: System.@LStrCmp;
|
005E88B8   E8A7C6E1FF             call    00404F64
005E88BD   7515                   jnz     005E88D4
005E88BF   8B06                   mov     eax, [esi]
005E88C1   8B8048050000           mov     eax, [eax+$0548]
005E88C7   BAAC8A5E00             mov     edx, $005E8AAC
005E88CC   8B08                   mov     ecx, [eax]
005E88CE   FF91B0000000           call    dword ptr [ecx+$00B0]
005E88D4   8D85D0FEFFFF           lea     eax, [ebp+$FFFFFED0]
005E88DA   8D55FE                 lea     edx, [ebp-$02]

* Reference to: System.@LStrFromString(String;String;ShortString;ShortString);
|
005E88DD   E8E2C4E1FF             call    00404DC4
005E88E2   8B85D0FEFFFF           mov     eax, [ebp+$FFFFFED0]
005E88E8   8D95D4FEFFFF           lea     edx, [ebp+$FFFFFED4]

* Reference to: Unit_00408494.Proc_004091D8
|
005E88EE   E8E508E2FF             call    004091D8
005E88F3   8B85D4FEFFFF           mov     eax, [ebp+$FFFFFED4]
005E88F9   BAB88A5E00             mov     edx, $005E8AB8

* Reference to: System.@LStrCmp;
|
005E88FE   E861C6E1FF             call    00404F64
005E8903   7515                   jnz     005E891A
005E8905   8B06                   mov     eax, [esi]
005E8907   8B8048050000           mov     eax, [eax+$0548]
005E890D   BAC48A5E00             mov     edx, $005E8AC4
005E8912   8B08                   mov     ecx, [eax]
005E8914   FF91B0000000           call    dword ptr [ecx+$00B0]

* Reference to control TForm1.TabSheet3 : TTabSheet
|
005E891A   8B9344030000           mov     edx, [ebx+$0344]

* Reference to control TForm1.PageControl1 : TPageControl
|
005E8920   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005E8926   E88D74E9FF             call    0047FDB8

* Reference to control TForm1.ComboBox10 : TComboBox
|
005E892B   8B936C080000           mov     edx, [ebx+$086C]
005E8931   8BC3                   mov     eax, ebx

* Reference to: Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);
|
005E8933   E8B8F4E7FF             call    00467DF0

* Reference to pointer to GlobalVar_02535878
|
005E8938   A180C56100             mov     eax, dword ptr [$0061C580]
005E893D   8B00                   mov     eax, [eax]

* Reference to control Label2 : TLabel
|
005E893F   8B80F8020000           mov     eax, [eax+$02F8]
005E8945   8B10                   mov     edx, [eax]

* Possible reference to virtual method TLabel.OFFS_00C4
|
005E8947   FF92C4000000           call    dword ptr [edx+$00C4]
005E894D   84C0                   test    al, al
005E894F   0F848B000000           jz      005E89E0

* Possible String Reference to: 'Verbindung von '
|
005E8955   68708A5E00             push    $005E8A70
005E895A   8D95C8FEFFFF           lea     edx, [ebp+$FFFFFEC8]
005E8960   8B06                   mov     eax, [esi]
005E8962   8B8040050000           mov     eax, [eax+$0540]
005E8968   8B08                   mov     ecx, [eax]
005E896A   FF5160                 call    dword ptr [ecx+$60]
005E896D   FFB5C8FEFFFF           push    dword ptr [ebp+$FFFFFEC8]
005E8973   68888A5E00             push    $005E8A88
005E8978   8D95C4FEFFFF           lea     edx, [ebp+$FFFFFEC4]
005E897E   8B06                   mov     eax, [esi]
005E8980   8B8044050000           mov     eax, [eax+$0544]
005E8986   8B08                   mov     ecx, [eax]
005E8988   FF5160                 call    dword ptr [ecx+$60]
005E898B   FFB5C4FEFFFF           push    dword ptr [ebp+$FFFFFEC4]
005E8991   8D85CCFEFFFF           lea     eax, [ebp+$FFFFFECC]
005E8997   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005E899C   E83FC5E1FF             call    00404EE0
005E89A1   8B95CCFEFFFF           mov     edx, [ebp+$FFFFFECC]

* Reference to control TForm1.Label27 : TLabel
|
005E89A7   8B838C040000           mov     eax, [ebx+$048C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E89AD   E88240E6FF             call    0044CA34

* Reference to control TForm1.TabSheet7 : TTabSheet
|
005E89B2   8B8380040000           mov     eax, [ebx+$0480]

* Reference to: Controls.TControl.Show(TControl);
|
005E89B8   E88745E6FF             call    0044CF44

* Reference to control TForm1.DBGrid2 : TDBGrid
|
005E89BD   8B9388040000           mov     edx, [ebx+$0488]
005E89C3   8BC3                   mov     eax, ebx

* Reference to: Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);
|
005E89C5   E826F4E7FF             call    00467DF0

* Reference to pointer to GlobalVar_025353D8
|
005E89CA   A168C86100             mov     eax, dword ptr [$0061C868]
005E89CF   8B00                   mov     eax, [eax]
005E89D1   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_025353D8.OFFS_00E8
|
005E89D3   FF92E8000000           call    dword ptr [edx+$00E8]
005E89D9   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005E89DB   E8BCB9FEFF             call    005D439C
005E89E0   33C0                   xor     eax, eax
005E89E2   5A                     pop     edx
005E89E3   59                     pop     ecx
005E89E4   59                     pop     ecx
005E89E5   648910                 mov     fs:[eax], edx

****** FINALLY
|
005E89E8   68128A5E00             push    $005E8A12
005E89ED   8D85C4FEFFFF           lea     eax, [ebp+$FFFFFEC4]
005E89F3   BA0C000000             mov     edx, $0000000C

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E89F8   E88FC1E1FF             call    00404B8C
005E89FD   8D45F4                 lea     eax, [ebp-$0C]
005E8A00   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E8A05   E882C1E1FF             call    00404B8C
005E8A0A   C3                     ret


* Reference to: System.@HandleFinally;
|
005E8A0B   E9BCBAE1FF             jmp     004044CC
005E8A10   EBDB                   jmp     005E89ED

****** END
|
005E8A12   5E                     pop     esi
005E8A13   5B                     pop     ebx
005E8A14   8BE5                   mov     esp, ebp
005E8A16   5D                     pop     ebp
005E8A17   C3                     ret

*)
end;

procedure TForm1.Vaterentfernen1Click(Sender : TObject);
begin
  ExecuteParentUnlink(TMainFormParentUnlinkActions.Create(Self), prFather,
    PersonEditFrame.FatherSearchText);
end;

procedure TForm1.Mutterentfernen1Click(Sender : TObject);
begin
  ExecuteParentUnlink(TMainFormParentUnlinkActions.Create(Self), prMother,
    PersonEditFrame.MotherSearchText);
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Image1 (TImage); Label2 (TLabel); Label3 (TLabel); TForm1.ComboBox10 (TComboBox);
    TForm1.ComboBox16 (TComboBox); TForm1.ComboBox17 (TComboBox); TForm1.ComboBox18 (TComboBox);
    TForm1.ComboBox19 (TComboBox); TForm1.DBCheckBox1 (TDBCheckBox); TForm1.Label27 (TLabel);
    TForm1.Label35 (TLabel); TForm1.PageControl1 (TPageControl); TForm1.TabSheet3 (TTabSheet);
    TForm1.TabSheet7 (TTabSheet)
Database/provider: DB.TDataSet.Append(TDataSet);; DB.TDataSet.Delete(TDataSet);;
    DB.TDataSet.Open(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_025353D8; GlobalVar_02535878; GlobalVar_02535910;
    GlobalVar_02535914
Unresolved field offsets: OFFS_00C4; OFFS_00E8
Project calls: TForm1.anzeigen(); TForm1.elem()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Controls.TControl.SetVisible(TControl;Boolean);;
    Controls.TControl.Show(TControl);; Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);;
    method TDBCheckBox.SetChecked(Boolean); System.Proc_00404EE0
Strings/files/dialog text: 'aus'; 'Vater einf�gen'; 'Vater von '
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Vatereinfgen1Click(Sender : TObject);
begin
(*
005EBC38   55                     push    ebp
005EBC39   8BEC                   mov     ebp, esp
005EBC3B   33C9                   xor     ecx, ecx
005EBC3D   51                     push    ecx
005EBC3E   51                     push    ecx
005EBC3F   51                     push    ecx
005EBC40   51                     push    ecx
005EBC41   51                     push    ecx
005EBC42   51                     push    ecx
005EBC43   51                     push    ecx
005EBC44   51                     push    ecx
005EBC45   53                     push    ebx
005EBC46   56                     push    esi
005EBC47   8BD8                   mov     ebx, eax

* Reference to pointer to GlobalVar_0061DF08
|
005EBC49   8B353CCC6100           mov     esi, [$0061CC3C]
005EBC4F   33C0                   xor     eax, eax
005EBC51   55                     push    ebp
005EBC52   6827BF5E00             push    $005EBF27

***** TRY
|
005EBC57   64FF30                 push    dword ptr fs:[eax]
005EBC5A   648920                 mov     fs:[eax], esp
005EBC5D   8B06                   mov     eax, [esi]
005EBC5F   8B405C                 mov     eax, [eax+$5C]
005EBC62   8A809D000000           mov     al, byte ptr [eax+$009D]
005EBC68   04FE                   add     al, -$02
005EBC6A   2C02                   sub     al, $02
005EBC6C   732A                   jnb     005EBC98
005EBC6E   8B06                   mov     eax, [esi]
005EBC70   8B8034050000           mov     eax, [eax+$0534]
005EBC76   8B10                   mov     edx, [eax]
005EBC78   FF5258                 call    dword ptr [edx+$58]
005EBC7B   85C0                   test    eax, eax
005EBC7D   7E0F                   jle     005EBC8E
005EBC7F   8B06                   mov     eax, [esi]
005EBC81   8B405C                 mov     eax, [eax+$5C]
005EBC84   8B10                   mov     edx, [eax]
005EBC86   FF9248020000           call    dword ptr [edx+$0248]
005EBC8C   EB0A                   jmp     005EBC98
005EBC8E   8B06                   mov     eax, [esi]
005EBC90   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Delete(TDataSet);
|
005EBC93   E8803CECFF             call    004AF918
005EBC98   8B06                   mov     eax, [esi]
005EBC9A   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EBCA0   E8E30FECFF             call    004ACC88
005EBCA5   33C0                   xor     eax, eax

* Reference to GlobalVar_02535914
|
005EBCA7   A314595302             mov     dword ptr [$02535914], eax
005EBCAC   C7051859530201000000   mov     dword ptr [$02535918], $00000001
005EBCB6   8B06                   mov     eax, [esi]
005EBCB8   8B8034050000           mov     eax, [eax+$0534]
005EBCBE   8B10                   mov     edx, [eax]
005EBCC0   FF5258                 call    dword ptr [edx+$58]

* Reference to GlobalVar_02535910
|
005EBCC3   A310595302             mov     dword ptr [$02535910], eax

* Reference to pointer to GlobalVar_02535878
|
005EBCC8   A180C56100             mov     eax, dword ptr [$0061C580]
005EBCCD   8B00                   mov     eax, [eax]

* Possible String Reference to: 'Vater einf�gen'
|
005EBCCF   BA3CBF5E00             mov     edx, $005EBF3C

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EBCD4   E85B0DE6FF             call    0044CA34

* Reference to pointer to GlobalVar_02535878
|
005EBCD9   A180C56100             mov     eax, dword ptr [$0061C580]
005EBCDE   8B00                   mov     eax, [eax]
005EBCE0   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_02535878.OFFS_00E8
|
005EBCE2   FF92E8000000           call    dword ptr [edx+$00E8]

* Reference to pointer to GlobalVar_02535878
|
005EBCE8   A180C56100             mov     eax, dword ptr [$0061C580]
005EBCED   8B00                   mov     eax, [eax]

* Reference to control Image1 : TImage
|
005EBCEF   8B80F4020000           mov     eax, [eax+$02F4]
005EBCF5   8B10                   mov     edx, [eax]

* Possible reference to virtual method TImage.OFFS_00C4
|
005EBCF7   FF92C4000000           call    dword ptr [edx+$00C4]
005EBCFD   84C0                   test    al, al
005EBCFF   0F8413010000           jz      005EBE18

* Possible String Reference to: 'aus'
|
005EBD05   BA54BF5E00             mov     edx, $005EBF54
005EBD0A   8BC3                   mov     eax, ebx

* Reference to : TForm1.elem()
|
005EBD0C   E853C6FFFF             call    005E8364

* Possible String Reference to: 'Vater von '
|
005EBD11   6860BF5E00             push    $005EBF60
005EBD16   8D55F8                 lea     edx, [ebp-$08]
005EBD19   8B06                   mov     eax, [esi]
005EBD1B   8B8040050000           mov     eax, [eax+$0540]
005EBD21   8B08                   mov     ecx, [eax]
005EBD23   FF5160                 call    dword ptr [ecx+$60]
005EBD26   FF75F8                 push    dword ptr [ebp-$08]
005EBD29   6874BF5E00             push    $005EBF74
005EBD2E   8D55F4                 lea     edx, [ebp-$0C]
005EBD31   8B06                   mov     eax, [esi]
005EBD33   8B8044050000           mov     eax, [eax+$0544]
005EBD39   8B08                   mov     ecx, [eax]
005EBD3B   FF5160                 call    dword ptr [ecx+$60]
005EBD3E   FF75F4                 push    dword ptr [ebp-$0C]
005EBD41   8D45FC                 lea     eax, [ebp-$04]
005EBD44   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005EBD49   E89291E1FF             call    00404EE0
005EBD4E   8B55FC                 mov     edx, [ebp-$04]

* Reference to control TForm1.Label35 : TLabel
|
005EBD51   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EBD57   E8D80CE6FF             call    0044CA34
005EBD5C   B201                   mov     dl, $01

* Reference to control TForm1.Label35 : TLabel
|
005EBD5E   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005EBD64   E8BB0BE6FF             call    0044C924
005EBD69   8B06                   mov     eax, [esi]
005EBD6B   8B405C                 mov     eax, [eax+$5C]
005EBD6E   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EBD70   E8E76DEEFF             call    004D2B5C
005EBD75   8B06                   mov     eax, [esi]
005EBD77   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005EBD7A   E8A539ECFF             call    004AF724
005EBD7F   33D2                   xor     edx, edx

* Reference to control TForm1.DBCheckBox1 : TDBCheckBox
|
005EBD81   8B832C060000           mov     eax, [ebx+$062C]
005EBD87   8B08                   mov     ecx, [eax]

* Reference to method TDBCheckBox.SetChecked(Boolean)
|
005EBD89   FF91C8000000           call    dword ptr [ecx+$00C8]
005EBD8F   8B06                   mov     eax, [esi]
005EBD91   8B80B4050000           mov     eax, [eax+$05B4]
005EBD97   BA80BF5E00             mov     edx, $005EBF80
005EBD9C   8B08                   mov     ecx, [eax]
005EBD9E   FF91B0000000           call    dword ptr [ecx+$00B0]
005EBDA4   8B06                   mov     eax, [esi]
005EBDA6   8B8048050000           mov     eax, [eax+$0548]
005EBDAC   BA8CBF5E00             mov     edx, $005EBF8C
005EBDB1   8B08                   mov     ecx, [eax]
005EBDB3   FF91B0000000           call    dword ptr [ecx+$00B0]

* Reference to control TForm1.TabSheet3 : TTabSheet
|
005EBDB9   8B9344030000           mov     edx, [ebx+$0344]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EBDBF   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EBDC5   E8EE3FE9FF             call    0047FDB8

* Reference to control TForm1.ComboBox10 : TComboBox
|
005EBDCA   8B936C080000           mov     edx, [ebx+$086C]
005EBDD0   8BC3                   mov     eax, ebx

* Reference to: Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);
|
005EBDD2   E819C0E7FF             call    00467DF0
005EBDD7   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox10 : TComboBox
|
005EBDD9   8B836C080000           mov     eax, [ebx+$086C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EBDDF   E8500CE6FF             call    0044CA34
005EBDE4   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox16 : TComboBox
|
005EBDE6   8B8384080000           mov     eax, [ebx+$0884]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EBDEC   E8430CE6FF             call    0044CA34
005EBDF1   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox17 : TComboBox
|
005EBDF3   8B8388080000           mov     eax, [ebx+$0888]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EBDF9   E8360CE6FF             call    0044CA34
005EBDFE   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox18 : TComboBox
|
005EBE00   8B838C080000           mov     eax, [ebx+$088C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EBE06   E8290CE6FF             call    0044CA34
005EBE0B   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox19 : TComboBox
|
005EBE0D   8B8390080000           mov     eax, [ebx+$0890]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EBE13   E81C0CE6FF             call    0044CA34

* Reference to pointer to GlobalVar_02535878
|
005EBE18   A180C56100             mov     eax, dword ptr [$0061C580]
005EBE1D   8B00                   mov     eax, [eax]

* Reference to control Label2 : TLabel
|
005EBE1F   8B80F8020000           mov     eax, [eax+$02F8]
005EBE25   8B10                   mov     edx, [eax]

* Possible reference to virtual method TLabel.OFFS_00C4
|
005EBE27   FF92C4000000           call    dword ptr [edx+$00C4]
005EBE2D   84C0                   test    al, al
005EBE2F   0F84C3000000           jz      005EBEF8

* Possible String Reference to: 'aus'
|
005EBE35   BA54BF5E00             mov     edx, $005EBF54
005EBE3A   8BC3                   mov     eax, ebx

* Reference to : TForm1.elem()
|
005EBE3C   E823C5FFFF             call    005E8364
005EBE41   8B06                   mov     eax, [esi]
005EBE43   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EBE49   E83A0EECFF             call    004ACC88
005EBE4E   8B06                   mov     eax, [esi]
005EBE50   8B809C000000           mov     eax, [eax+$009C]
005EBE56   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EBE58   E8FF6CEEFF             call    004D2B5C
005EBE5D   A110595302             mov     eax, dword ptr [$02535910]
005EBE62   8945EC                 mov     [ebp-$14], eax
005EBE65   C645F000               mov     byte ptr [ebp-$10], $00
005EBE69   8D55EC                 lea     edx, [ebp-$14]
005EBE6C   8B06                   mov     eax, [esi]
005EBE6E   8B809C000000           mov     eax, [eax+$009C]
005EBE74   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005EBE76   E8E973EEFF             call    004D3264
005EBE7B   84C0                   test    al, al
005EBE7D   744B                   jz      005EBECA

* Possible String Reference to: 'Vater von '
|
005EBE7F   6860BF5E00             push    $005EBF60
005EBE84   8D55E4                 lea     edx, [ebp-$1C]
005EBE87   8B06                   mov     eax, [esi]
005EBE89   8B8040050000           mov     eax, [eax+$0540]
005EBE8F   8B08                   mov     ecx, [eax]
005EBE91   FF5160                 call    dword ptr [ecx+$60]
005EBE94   FF75E4                 push    dword ptr [ebp-$1C]
005EBE97   6874BF5E00             push    $005EBF74
005EBE9C   8D55E0                 lea     edx, [ebp-$20]
005EBE9F   8B06                   mov     eax, [esi]
005EBEA1   8B8044050000           mov     eax, [eax+$0544]
005EBEA7   8B08                   mov     ecx, [eax]
005EBEA9   FF5160                 call    dword ptr [ecx+$60]
005EBEAC   FF75E0                 push    dword ptr [ebp-$20]
005EBEAF   8D45E8                 lea     eax, [ebp-$18]
005EBEB2   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005EBEB7   E82490E1FF             call    00404EE0
005EBEBC   8B55E8                 mov     edx, [ebp-$18]

* Reference to control TForm1.Label27 : TLabel
|
005EBEBF   8B838C040000           mov     eax, [ebx+$048C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EBEC5   E86A0BE6FF             call    0044CA34

* Reference to control TForm1.TabSheet7 : TTabSheet
|
005EBECA   8B8380040000           mov     eax, [ebx+$0480]

* Reference to: Controls.TControl.Show(TControl);
|
005EBED0   E86F10E6FF             call    0044CF44

* Reference to pointer to GlobalVar_025353D8
|
005EBED5   A168C86100             mov     eax, dword ptr [$0061C868]
005EBEDA   8B00                   mov     eax, [eax]

* Reference to control Label3 : TLabel
|
005EBEDC   8B80FC020000           mov     eax, [eax+$02FC]
005EBEE2   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EBEE4   E84B0BE6FF             call    0044CA34

* Reference to pointer to GlobalVar_025353D8
|
005EBEE9   A168C86100             mov     eax, dword ptr [$0061C868]
005EBEEE   8B00                   mov     eax, [eax]
005EBEF0   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_025353D8.OFFS_00E8
|
005EBEF2   FF92E8000000           call    dword ptr [edx+$00E8]
005EBEF8   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005EBEFA   E89D84FEFF             call    005D439C
005EBEFF   33C0                   xor     eax, eax
005EBF01   5A                     pop     edx
005EBF02   59                     pop     ecx
005EBF03   59                     pop     ecx
005EBF04   648910                 mov     fs:[eax], edx

****** FINALLY
|
005EBF07   682EBF5E00             push    $005EBF2E
005EBF0C   8D45E0                 lea     eax, [ebp-$20]
005EBF0F   BA03000000             mov     edx, $00000003

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EBF14   E8738CE1FF             call    00404B8C
005EBF19   8D45F4                 lea     eax, [ebp-$0C]
005EBF1C   BA03000000             mov     edx, $00000003

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EBF21   E8668CE1FF             call    00404B8C
005EBF26   C3                     ret


* Reference to: System.@HandleFinally;
|
005EBF27   E9A085E1FF             jmp     004044CC
005EBF2C   EBDE                   jmp     005EBF0C

****** END
|
005EBF2E   5E                     pop     esi
005EBF2F   5B                     pop     ebx
005EBF30   8BE5                   mov     esp, ebp
005EBF32   5D                     pop     ebp
005EBF33   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Image1 (TImage); Label2 (TLabel); Label3 (TLabel); TForm1.ComboBox10 (TComboBox);
    TForm1.ComboBox16 (TComboBox); TForm1.ComboBox17 (TComboBox); TForm1.ComboBox18 (TComboBox);
    TForm1.ComboBox19 (TComboBox); TForm1.DBCheckBox1 (TDBCheckBox); TForm1.Label27 (TLabel);
    TForm1.Label35 (TLabel); TForm1.PageControl1 (TPageControl); TForm1.TabSheet3 (TTabSheet);
    TForm1.TabSheet7 (TTabSheet)
Database/provider: DB.TDataSet.Append(TDataSet);; DB.TDataSet.Delete(TDataSet);;
    DB.TDataSet.Open(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_025353D8; GlobalVar_02535878; GlobalVar_02535910;
    GlobalVar_02535914
Unresolved field offsets: OFFS_00C4; OFFS_00E8
Project calls: TForm1.anzeigen(); TForm1.elem()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Controls.TControl.SetVisible(TControl;Boolean);;
    Controls.TControl.Show(TControl);; Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);;
    method TDBCheckBox.SetChecked(Boolean); System.Proc_00404EE0
Strings/files/dialog text: 'aus'; 'Mutter einf�gen'; 'Mutter von '
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Muttereinfgen1Click(Sender : TObject);
begin
(*
005EBF90   55                     push    ebp
005EBF91   8BEC                   mov     ebp, esp
005EBF93   33C9                   xor     ecx, ecx
005EBF95   51                     push    ecx
005EBF96   51                     push    ecx
005EBF97   51                     push    ecx
005EBF98   51                     push    ecx
005EBF99   51                     push    ecx
005EBF9A   51                     push    ecx
005EBF9B   51                     push    ecx
005EBF9C   51                     push    ecx
005EBF9D   53                     push    ebx
005EBF9E   56                     push    esi
005EBF9F   8BD8                   mov     ebx, eax

* Reference to pointer to GlobalVar_0061DF08
|
005EBFA1   8B353CCC6100           mov     esi, [$0061CC3C]
005EBFA7   33C0                   xor     eax, eax
005EBFA9   55                     push    ebp
005EBFAA   687FC25E00             push    $005EC27F

***** TRY
|
005EBFAF   64FF30                 push    dword ptr fs:[eax]
005EBFB2   648920                 mov     fs:[eax], esp
005EBFB5   8B06                   mov     eax, [esi]
005EBFB7   8B405C                 mov     eax, [eax+$5C]
005EBFBA   8A809D000000           mov     al, byte ptr [eax+$009D]
005EBFC0   04FE                   add     al, -$02
005EBFC2   2C02                   sub     al, $02
005EBFC4   732A                   jnb     005EBFF0
005EBFC6   8B06                   mov     eax, [esi]
005EBFC8   8B8034050000           mov     eax, [eax+$0534]
005EBFCE   8B10                   mov     edx, [eax]
005EBFD0   FF5258                 call    dword ptr [edx+$58]
005EBFD3   85C0                   test    eax, eax
005EBFD5   7E0F                   jle     005EBFE6
005EBFD7   8B06                   mov     eax, [esi]
005EBFD9   8B405C                 mov     eax, [eax+$5C]
005EBFDC   8B10                   mov     edx, [eax]
005EBFDE   FF9248020000           call    dword ptr [edx+$0248]
005EBFE4   EB0A                   jmp     005EBFF0
005EBFE6   8B06                   mov     eax, [esi]
005EBFE8   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Delete(TDataSet);
|
005EBFEB   E82839ECFF             call    004AF918
005EBFF0   8B06                   mov     eax, [esi]
005EBFF2   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EBFF8   E88B0CECFF             call    004ACC88
005EBFFD   33C0                   xor     eax, eax

* Reference to GlobalVar_02535914
|
005EBFFF   A314595302             mov     dword ptr [$02535914], eax
005EC004   C7051859530201000000   mov     dword ptr [$02535918], $00000001
005EC00E   8B06                   mov     eax, [esi]
005EC010   8B8034050000           mov     eax, [eax+$0534]
005EC016   8B10                   mov     edx, [eax]
005EC018   FF5258                 call    dword ptr [edx+$58]

* Reference to GlobalVar_02535910
|
005EC01B   A310595302             mov     dword ptr [$02535910], eax

* Reference to pointer to GlobalVar_02535878
|
005EC020   A180C56100             mov     eax, dword ptr [$0061C580]
005EC025   8B00                   mov     eax, [eax]

* Possible String Reference to: 'Mutter einf�gen'
|
005EC027   BA94C25E00             mov     edx, $005EC294

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EC02C   E8030AE6FF             call    0044CA34

* Reference to pointer to GlobalVar_02535878
|
005EC031   A180C56100             mov     eax, dword ptr [$0061C580]
005EC036   8B00                   mov     eax, [eax]
005EC038   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_02535878.OFFS_00E8
|
005EC03A   FF92E8000000           call    dword ptr [edx+$00E8]

* Reference to pointer to GlobalVar_02535878
|
005EC040   A180C56100             mov     eax, dword ptr [$0061C580]
005EC045   8B00                   mov     eax, [eax]

* Reference to control Image1 : TImage
|
005EC047   8B80F4020000           mov     eax, [eax+$02F4]
005EC04D   8B10                   mov     edx, [eax]

* Possible reference to virtual method TImage.OFFS_00C4
|
005EC04F   FF92C4000000           call    dword ptr [edx+$00C4]
005EC055   84C0                   test    al, al
005EC057   0F8413010000           jz      005EC170

* Possible String Reference to: 'aus'
|
005EC05D   BAACC25E00             mov     edx, $005EC2AC
005EC062   8BC3                   mov     eax, ebx

* Reference to : TForm1.elem()
|
005EC064   E8FBC2FFFF             call    005E8364

* Possible String Reference to: 'Mutter von '
|
005EC069   68B8C25E00             push    $005EC2B8
005EC06E   8D55F8                 lea     edx, [ebp-$08]
005EC071   8B06                   mov     eax, [esi]
005EC073   8B8040050000           mov     eax, [eax+$0540]
005EC079   8B08                   mov     ecx, [eax]
005EC07B   FF5160                 call    dword ptr [ecx+$60]
005EC07E   FF75F8                 push    dword ptr [ebp-$08]
005EC081   68CCC25E00             push    $005EC2CC
005EC086   8D55F4                 lea     edx, [ebp-$0C]
005EC089   8B06                   mov     eax, [esi]
005EC08B   8B8044050000           mov     eax, [eax+$0544]
005EC091   8B08                   mov     ecx, [eax]
005EC093   FF5160                 call    dword ptr [ecx+$60]
005EC096   FF75F4                 push    dword ptr [ebp-$0C]
005EC099   8D45FC                 lea     eax, [ebp-$04]
005EC09C   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005EC0A1   E83A8EE1FF             call    00404EE0
005EC0A6   8B55FC                 mov     edx, [ebp-$04]

* Reference to control TForm1.Label35 : TLabel
|
005EC0A9   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EC0AF   E88009E6FF             call    0044CA34
005EC0B4   B201                   mov     dl, $01

* Reference to control TForm1.Label35 : TLabel
|
005EC0B6   8B8394040000           mov     eax, [ebx+$0494]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005EC0BC   E86308E6FF             call    0044C924
005EC0C1   8B06                   mov     eax, [esi]
005EC0C3   8B405C                 mov     eax, [eax+$5C]
005EC0C6   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EC0C8   E88F6AEEFF             call    004D2B5C
005EC0CD   8B06                   mov     eax, [esi]
005EC0CF   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005EC0D2   E84D36ECFF             call    004AF724
005EC0D7   33D2                   xor     edx, edx

* Reference to control TForm1.DBCheckBox1 : TDBCheckBox
|
005EC0D9   8B832C060000           mov     eax, [ebx+$062C]
005EC0DF   8B08                   mov     ecx, [eax]

* Reference to method TDBCheckBox.SetChecked(Boolean)
|
005EC0E1   FF91C8000000           call    dword ptr [ecx+$00C8]
005EC0E7   8B06                   mov     eax, [esi]
005EC0E9   8B80B4050000           mov     eax, [eax+$05B4]
005EC0EF   BAD8C25E00             mov     edx, $005EC2D8
005EC0F4   8B08                   mov     ecx, [eax]
005EC0F6   FF91B0000000           call    dword ptr [ecx+$00B0]
005EC0FC   8B06                   mov     eax, [esi]
005EC0FE   8B8048050000           mov     eax, [eax+$0548]
005EC104   BAE4C25E00             mov     edx, $005EC2E4
005EC109   8B08                   mov     ecx, [eax]
005EC10B   FF91B0000000           call    dword ptr [ecx+$00B0]

* Reference to control TForm1.TabSheet3 : TTabSheet
|
005EC111   8B9344030000           mov     edx, [ebx+$0344]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EC117   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EC11D   E8963CE9FF             call    0047FDB8

* Reference to control TForm1.ComboBox10 : TComboBox
|
005EC122   8B936C080000           mov     edx, [ebx+$086C]
005EC128   8BC3                   mov     eax, ebx

* Reference to: Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);
|
005EC12A   E8C1BCE7FF             call    00467DF0
005EC12F   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox10 : TComboBox
|
005EC131   8B836C080000           mov     eax, [ebx+$086C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EC137   E8F808E6FF             call    0044CA34
005EC13C   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox16 : TComboBox
|
005EC13E   8B8384080000           mov     eax, [ebx+$0884]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EC144   E8EB08E6FF             call    0044CA34
005EC149   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox17 : TComboBox
|
005EC14B   8B8388080000           mov     eax, [ebx+$0888]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EC151   E8DE08E6FF             call    0044CA34
005EC156   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox18 : TComboBox
|
005EC158   8B838C080000           mov     eax, [ebx+$088C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EC15E   E8D108E6FF             call    0044CA34
005EC163   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox19 : TComboBox
|
005EC165   8B8390080000           mov     eax, [ebx+$0890]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EC16B   E8C408E6FF             call    0044CA34

* Reference to pointer to GlobalVar_02535878
|
005EC170   A180C56100             mov     eax, dword ptr [$0061C580]
005EC175   8B00                   mov     eax, [eax]

* Reference to control Label2 : TLabel
|
005EC177   8B80F8020000           mov     eax, [eax+$02F8]
005EC17D   8B10                   mov     edx, [eax]

* Possible reference to virtual method TLabel.OFFS_00C4
|
005EC17F   FF92C4000000           call    dword ptr [edx+$00C4]
005EC185   84C0                   test    al, al
005EC187   0F84C3000000           jz      005EC250

* Possible String Reference to: 'aus'
|
005EC18D   BAACC25E00             mov     edx, $005EC2AC
005EC192   8BC3                   mov     eax, ebx

* Reference to : TForm1.elem()
|
005EC194   E8CBC1FFFF             call    005E8364
005EC199   8B06                   mov     eax, [esi]
005EC19B   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EC1A1   E8E20AECFF             call    004ACC88
005EC1A6   8B06                   mov     eax, [esi]
005EC1A8   8B809C000000           mov     eax, [eax+$009C]
005EC1AE   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EC1B0   E8A769EEFF             call    004D2B5C
005EC1B5   A110595302             mov     eax, dword ptr [$02535910]
005EC1BA   8945EC                 mov     [ebp-$14], eax
005EC1BD   C645F000               mov     byte ptr [ebp-$10], $00
005EC1C1   8D55EC                 lea     edx, [ebp-$14]
005EC1C4   8B06                   mov     eax, [esi]
005EC1C6   8B809C000000           mov     eax, [eax+$009C]
005EC1CC   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005EC1CE   E89170EEFF             call    004D3264
005EC1D3   84C0                   test    al, al
005EC1D5   744B                   jz      005EC222

* Possible String Reference to: 'Mutter von '
|
005EC1D7   68B8C25E00             push    $005EC2B8
005EC1DC   8D55E4                 lea     edx, [ebp-$1C]
005EC1DF   8B06                   mov     eax, [esi]
005EC1E1   8B8040050000           mov     eax, [eax+$0540]
005EC1E7   8B08                   mov     ecx, [eax]
005EC1E9   FF5160                 call    dword ptr [ecx+$60]
005EC1EC   FF75E4                 push    dword ptr [ebp-$1C]
005EC1EF   68CCC25E00             push    $005EC2CC
005EC1F4   8D55E0                 lea     edx, [ebp-$20]
005EC1F7   8B06                   mov     eax, [esi]
005EC1F9   8B8044050000           mov     eax, [eax+$0544]
005EC1FF   8B08                   mov     ecx, [eax]
005EC201   FF5160                 call    dword ptr [ecx+$60]
005EC204   FF75E0                 push    dword ptr [ebp-$20]
005EC207   8D45E8                 lea     eax, [ebp-$18]
005EC20A   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005EC20F   E8CC8CE1FF             call    00404EE0
005EC214   8B55E8                 mov     edx, [ebp-$18]

* Reference to control TForm1.Label27 : TLabel
|
005EC217   8B838C040000           mov     eax, [ebx+$048C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EC21D   E81208E6FF             call    0044CA34

* Reference to control TForm1.TabSheet7 : TTabSheet
|
005EC222   8B8380040000           mov     eax, [ebx+$0480]

* Reference to: Controls.TControl.Show(TControl);
|
005EC228   E8170DE6FF             call    0044CF44

* Reference to pointer to GlobalVar_025353D8
|
005EC22D   A168C86100             mov     eax, dword ptr [$0061C868]
005EC232   8B00                   mov     eax, [eax]

* Reference to control Label3 : TLabel
|
005EC234   8B80FC020000           mov     eax, [eax+$02FC]
005EC23A   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005EC23C   E8F307E6FF             call    0044CA34

* Reference to pointer to GlobalVar_025353D8
|
005EC241   A168C86100             mov     eax, dword ptr [$0061C868]
005EC246   8B00                   mov     eax, [eax]
005EC248   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_025353D8.OFFS_00E8
|
005EC24A   FF92E8000000           call    dword ptr [edx+$00E8]
005EC250   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005EC252   E84581FEFF             call    005D439C
005EC257   33C0                   xor     eax, eax
005EC259   5A                     pop     edx
005EC25A   59                     pop     ecx
005EC25B   59                     pop     ecx
005EC25C   648910                 mov     fs:[eax], edx

****** FINALLY
|
005EC25F   6886C25E00             push    $005EC286
005EC264   8D45E0                 lea     eax, [ebp-$20]
005EC267   BA03000000             mov     edx, $00000003

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EC26C   E81B89E1FF             call    00404B8C
005EC271   8D45F4                 lea     eax, [ebp-$0C]
005EC274   BA03000000             mov     edx, $00000003

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EC279   E80E89E1FF             call    00404B8C
005EC27E   C3                     ret


* Reference to: System.@HandleFinally;
|
005EC27F   E94882E1FF             jmp     004044CC
005EC284   EBDE                   jmp     005EC264

****** END
|
005EC286   5E                     pop     esi
005EC287   5B                     pop     ebx
005EC288   8BE5                   mov     esp, ebp
005EC28A   5D                     pop     ebp
005EC28B   C3                     ret

*)
end;

