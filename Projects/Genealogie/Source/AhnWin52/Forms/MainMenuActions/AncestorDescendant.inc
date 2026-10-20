{ TForm1 menu-area implementations: AncestorDescendant; LFM-bound method names remain on TForm1. }

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061DF08; GlobalVar_0061E0F8; GlobalVar_0061E0FC; GlobalVar_0061E10C
Unresolved field offsets: OFFS_005C; OFFS_00E8; OFFS_0538; OFFS_053C
Project calls: TForm1.anzeigen(); TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Dialogs.ShowMessage(AnsiString);; method
    TMenuItem.Click()
Strings/files/dialog text: 'Keine Daten verf�gbar.'; 'Keine Vorfahren gefunden.'; 'Vorfahren-Grafik
    II'; 'Vorgr2'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Grafik1Click(Sender : TObject);
begin
(*
005FA6F8   53                     push    ebx
005FA6F9   8BD8                   mov     ebx, eax
005FA6FB   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005FA6FD   E89AD2FDFF             call    005D799C

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FA702   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FA708   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FA70E   E8A556E8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005FA713   8B831C060000           mov     eax, [ebx+$061C]
005FA719   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FA71B   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
005FA71E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FA723   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FA725   8B405C                 mov     eax, [eax+$5C]
005FA728   8B10                   mov     edx, [eax]
005FA72A   FF924C010000           call    dword ptr [edx+$014C]
005FA730   83F802                 cmp     eax, +$02
005FA733   7D0C                   jnl     005FA741

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005FA735   B8C8A75F00             mov     eax, $005FA7C8

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FA73A   E8A5B0E4FF             call    004457E4
005FA73F   5B                     pop     ebx
005FA740   C3                     ret


* Reference to pointer to GlobalVar_0061DF08
|
005FA741   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FA746   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0538
|
005FA748   8B8038050000           mov     eax, [eax+$0538]
005FA74E   8B10                   mov     edx, [eax]
005FA750   FF5258                 call    dword ptr [edx+$58]
005FA753   85C0                   test    eax, eax
005FA755   7522                   jnz     005FA779

* Reference to pointer to GlobalVar_0061DF08
|
005FA757   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FA75C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_053C
|
005FA75E   8B803C050000           mov     eax, [eax+$053C]
005FA764   8B10                   mov     edx, [eax]
005FA766   FF5258                 call    dword ptr [edx+$58]
005FA769   85C0                   test    eax, eax
005FA76B   750C                   jnz     005FA779

* Possible String Reference to: 'Keine Vorfahren gefunden.'
|
005FA76D   B8E8A75F00             mov     eax, $005FA7E8

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FA772   E86DB0E4FF             call    004457E4
005FA777   5B                     pop     ebx
005FA778   C3                     ret

005FA779   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Vorgr2'
|
005FA77E   BA0CA85F00             mov     edx, $005FA80C

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FA783   E834A4E0FF             call    00404BBC

* Reference to pointer to GlobalVar_0061E10C
|
005FA788   A1D0C56100             mov     eax, dword ptr [$0061C5D0]
005FA78D   8B00                   mov     eax, [eax]

* Reference to pointer to GlobalVar_0061E0FC
|
005FA78F   8B15B8C16100           mov     edx, [$0061C1B8]
005FA795   8902                   mov     [edx], eax

* Reference to pointer to GlobalVar_0061E0F8
|
005FA797   A1B0C96100             mov     eax, dword ptr [$0061C9B0]
005FA79C   8B00                   mov     eax, [eax]

* Possible String Reference to: 'Vorfahren-Grafik II'
|
005FA79E   BA1CA85F00             mov     edx, $005FA81C

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005FA7A3   E88C22E5FF             call    0044CA34

* Reference to pointer to GlobalVar_0061E0F8
|
005FA7A8   A1B0C96100             mov     eax, dword ptr [$0061C9B0]
005FA7AD   8B00                   mov     eax, [eax]
005FA7AF   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061E0F8.OFFS_00E8
|
005FA7B1   FF92E8000000           call    dword ptr [edx+$00E8]
005FA7B7   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005FA7B9   E8DE9BFDFF             call    005D439C
005FA7BE   5B                     pop     ebx
005FA7BF   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Label7 (TLabel); TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl);
    TForm1.StringGrid2 (TStringGrid); TForm1.TabSheet2 (TTabSheet)
Database/provider: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_0061E0F8; GlobalVar_0061E10C
Unresolved field offsets: OFFS_005C; OFFS_00E8; OFFS_0534
Project calls: TForm1.anzeigen(); TForm1.speich1(); Unit_00408494.Proc_00409448
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Dialogs.ShowMessage(AnsiString);;
    Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;; method
    TLabel.SetEnabled(Boolean); method TMenuItem.Click()
Strings/files/dialog text: '^[��]�'; 'Keine Daten verf�gbar.'; 'Keine Nachfahren gefunden.';
    'Nachfahren-Grafik II'; 'Nachgr2'; '�g�����^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Grafikneu1Click(Sender : TObject);
begin
(*
005FA830   55                     push    ebp
005FA831   8BEC                   mov     ebp, esp
005FA833   83C4F0                 add     esp, -$10
005FA836   53                     push    ebx
005FA837   56                     push    esi
005FA838   33C9                   xor     ecx, ecx
005FA83A   894DFC                 mov     [ebp-$04], ecx
005FA83D   894DF8                 mov     [ebp-$08], ecx
005FA840   8BD8                   mov     ebx, eax
005FA842   33C0                   xor     eax, eax
005FA844   55                     push    ebp

* Possible String Reference to: '�g�����^[��]�'
|
005FA845   6860A95F00             push    $005FA960

***** TRY
|
005FA84A   64FF30                 push    dword ptr fs:[eax]
005FA84D   648920                 mov     fs:[eax], esp
005FA850   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005FA852   E845D1FDFF             call    005D799C

* Reference to pointer to GlobalVar_0061DF08
|
005FA857   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FA85C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FA85E   8B8034050000           mov     eax, [eax+$0534]
005FA864   8B10                   mov     edx, [eax]
005FA866   FF5258                 call    dword ptr [edx+$58]
005FA869   8BF0                   mov     esi, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FA86B   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FA871   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FA877   E83C55E8FF             call    0047FDB8

* Reference to pointer to GlobalVar_0061E10C
|
005FA87C   A1D0C56100             mov     eax, dword ptr [$0061C5D0]
005FA881   8B00                   mov     eax, [eax]

* Reference to control Label7 : TLabel
|
005FA883   8B8008030000           mov     eax, [eax+$0308]
005FA889   33D2                   xor     edx, edx
005FA88B   8B08                   mov     ecx, [eax]

* Reference to method TLabel.SetEnabled(Boolean)
|
005FA88D   FF5164                 call    dword ptr [ecx+$64]

* Reference to control TForm1.aus1 : TMenuItem
|
005FA890   8B831C060000           mov     eax, [ebx+$061C]
005FA896   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FA898   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
005FA89B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FA8A0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FA8A2   8B405C                 mov     eax, [eax+$5C]
005FA8A5   8B10                   mov     edx, [eax]
005FA8A7   FF924C010000           call    dword ptr [edx+$014C]
005FA8AD   83F802                 cmp     eax, +$02
005FA8B0   7D0F                   jnl     005FA8C1

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005FA8B2   B878A95F00             mov     eax, $005FA978

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FA8B7   E828AFE4FF             call    004457E4
005FA8BC   E984000000             jmp     005FA945
005FA8C1   8D45F8                 lea     eax, [ebp-$08]
005FA8C4   50                     push    eax
005FA8C5   33C9                   xor     ecx, ecx
005FA8C7   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid2 : TStringGrid
|
005FA8CC   8B8374030000           mov     eax, [ebx+$0374]

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005FA8D2   E8B551EEFF             call    004DFA8C
005FA8D7   8B45F8                 mov     eax, [ebp-$08]
005FA8DA   8D55FC                 lea     edx, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409448
|
005FA8DD   E866EBE0FF             call    00409448
005FA8E2   837DFC00               cmp     dword ptr [ebp-$04], +$00
005FA8E6   750C                   jnz     005FA8F4

* Possible String Reference to: 'Keine Nachfahren gefunden.'
|
005FA8E8   B898A95F00             mov     eax, $005FA998

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FA8ED   E8F2AEE4FF             call    004457E4
005FA8F2   EB51                   jmp     005FA945
005FA8F4   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Nachgr2'
|
005FA8F9   BABCA95F00             mov     edx, $005FA9BC

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FA8FE   E8B9A2E0FF             call    00404BBC

* Reference to pointer to GlobalVar_0061E0F8
|
005FA903   A1B0C96100             mov     eax, dword ptr [$0061C9B0]
005FA908   8B00                   mov     eax, [eax]

* Possible String Reference to: 'Nachfahren-Grafik II'
|
005FA90A   BACCA95F00             mov     edx, $005FA9CC

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005FA90F   E82021E5FF             call    0044CA34

* Reference to pointer to GlobalVar_0061E0F8
|
005FA914   A1B0C96100             mov     eax, dword ptr [$0061C9B0]
005FA919   8B00                   mov     eax, [eax]
005FA91B   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061E0F8.OFFS_00E8
|
005FA91D   FF92E8000000           call    dword ptr [edx+$00E8]
005FA923   8975F0                 mov     [ebp-$10], esi
005FA926   C645F400               mov     byte ptr [ebp-$0C], $00
005FA92A   8D55F0                 lea     edx, [ebp-$10]

* Reference to pointer to GlobalVar_0061DF08
|
005FA92D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FA932   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FA934   8B405C                 mov     eax, [eax+$5C]
005FA937   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FA939   E82689EDFF             call    004D3264
005FA93E   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005FA940   E8579AFDFF             call    005D439C
005FA945   33C0                   xor     eax, eax
005FA947   5A                     pop     edx
005FA948   59                     pop     ecx
005FA949   59                     pop     ecx
005FA94A   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '^[��]�'
|
005FA94D   6867A95F00             push    $005FA967
005FA952   8D45F8                 lea     eax, [ebp-$08]
005FA955   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FA95A   E82DA2E0FF             call    00404B8C
005FA95F   C3                     ret


* Reference to: System.@HandleFinally;
|
005FA960   E9679BE0FF             jmp     004044CC
005FA965   EBEB                   jmp     005FA952

****** END
|
005FA967   5E                     pop     esi
005FA968   5B                     pop     ebx
005FA969   8BE5                   mov     esp, ebp
005FA96B   5D                     pop     ebp
005FA96C   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061E0BC; GlobalVar_0061E0C0
Project calls: TForm1.Listen()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);; method
    TMenuItem.Click()
Strings/files/dialog text: 'Nach'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Liste1Click(Sender : TObject);
begin
(*
005FB310   53                     push    ebx
005FB311   56                     push    esi
005FB312   8BF2                   mov     esi, edx
005FB314   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FB316   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FB31C   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FB322   E8914AE8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005FB327   8B831C060000           mov     eax, [ebx+$061C]
005FB32D   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FB32F   FF5244                 call    dword ptr [edx+$44]
005FB332   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Nach'
|
005FB337   BA68B35F00             mov     edx, $005FB368

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FB33C   E87B98E0FF             call    00404BBC

* Reference to pointer to GlobalVar_0061E0BC
|
005FB341   A1C0CB6100             mov     eax, dword ptr [$0061CBC0]
005FB346   33D2                   xor     edx, edx
005FB348   8910                   mov     [eax], edx

* Reference to pointer to GlobalVar_0061E0C0
|
005FB34A   A110C56100             mov     eax, dword ptr [$0061C510]
005FB34F   33D2                   xor     edx, edx
005FB351   8910                   mov     [eax], edx
005FB353   8BD6                   mov     edx, esi
005FB355   8BC3                   mov     eax, ebx

* Reference to : TForm1.Listen()
|
005FB357   E814000000             call    005FB370
005FB35C   5E                     pop     esi
005FB35D   5B                     pop     ebx
005FB35E   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061E0BC; GlobalVar_0061E0C0
Project calls: TForm1.Vorlist()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);; method
    TMenuItem.Click()
Strings/files/dialog text: 'Vorf'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Listen2Click(Sender : TObject);
begin
(*
005FCAA4   53                     push    ebx
005FCAA5   56                     push    esi
005FCAA6   8BF2                   mov     esi, edx
005FCAA8   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FCAAA   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FCAB0   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FCAB6   E8FD32E8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005FCABB   8B831C060000           mov     eax, [ebx+$061C]
005FCAC1   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FCAC3   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061E0BC
|
005FCAC6   A1C0CB6100             mov     eax, dword ptr [$0061CBC0]
005FCACB   33D2                   xor     edx, edx
005FCACD   8910                   mov     [eax], edx

* Reference to pointer to GlobalVar_0061E0C0
|
005FCACF   A110C56100             mov     eax, dword ptr [$0061C510]
005FCAD4   33D2                   xor     edx, edx
005FCAD6   8910                   mov     [eax], edx
005FCAD8   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Vorf'
|
005FCADD   BAFCCA5F00             mov     edx, $005FCAFC

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FCAE2   E8D580E0FF             call    00404BBC
005FCAE7   8BD6                   mov     edx, esi
005FCAE9   8BC3                   mov     eax, ebx

* Reference to : TForm1.Vorlist()
|
005FCAEB   E8ECA50000             call    006070DC
005FCAF0   5E                     pop     esi
005FCAF1   5B                     pop     ebx
005FCAF2   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Label1 (TLabel); Label2 (TLabel); Label3 (TLabel); Label9 (TLabel); TForm1.aus1
    (TMenuItem); TForm1.DBText1 (TDBText); TForm1.Image11 (TImage); TForm1.Label47 (TLabel);
    TForm1.PageControl1 (TPageControl); TForm1.StringGrid2 (TStringGrid); TForm1.TabSheet2
    (TTabSheet); TApplication instance
Database/provider: DB.TDataSet.Append(TDataSet);; DB.TDataSet.Close(TDataSet);;
    DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;; DB.TDataSet.Next(TDataSet);;
    DB.TDataSet.Open(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.EmptyTable(TTable);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;;
    QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);;
    QuickRpt.TQuickRep.SetDataSet(TQuickRep;TDataSet);
Global state: GlobalVar_0061DF08; GlobalVar_0061DF10; GlobalVar_0061E0B4
Unresolved field offsets: OFFS_005C; OFFS_009C; OFFS_013C; OFFS_014C; OFFS_0258; OFFS_02A8;
    OFFS_02AC; OFFS_02BC; OFFS_034C; OFFS_0350; OFFS_0354; OFFS_0368; OFFS_0550
Project calls: TForm1.ehtest(); TForm1.geb_sterb(); TForm1.Proc_005D3228(); TForm1.Proc_005D32CC();
    TForm1.QRDefault(); TForm1.speich1(); TForm1.ucase(); Unit_00408494.Proc_004091D8;
    Unit_00408494.Proc_00409448; Unit_00408494.Proc_00409950; Unit_00408494.Proc_004099B4
Framework/API calls: Application; ComCtrls.TPageControl.GetPageCount(TPageControl):Integer;;
    ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetColor(TControl;TColor);; Controls.TControl.SetLeft(TControl;Integer);;
    Controls.TControl.SetVisible(TControl;Boolean);; Controls.TControl.SetWidth(TControl;Integer);;
    Dialogs.ShowMessage(AnsiString);;
    Forms.TApplication.MessageBox(TApplication;PChar;PChar;Longint):Integer;;
    Graphics.TFont.SetName(TFont;TFontName);; Graphics.TFont.SetSize(TFont;Integer);;
    Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;; method
    TImage.SetDragMode(TDragMode); method TLabel.SetDragMode(TDragMode); method TMenuItem.Click();
    QRCtrls.TQRCustomLabel.SetCaption(TQRCustomLabel;AnsiString);;
    QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);;
    QuickRpt.TCustomQuickRep.Preview(TCustomQuickRep);;
    QuickRpt.TQRPage.SetColumns(TQRPage;Integer);; System.Proc_00404EE0
Strings/files/dialog text: ' '; ' ( - '; ' ('; ' * '; ' + '; ' - '; ' : '; ' and taufjahr<='; ' ~ ';
    ', '; '- - '; '- - - '; '- - - - '; '_^[��]�'; 'Arial'; 'gebjahr<='; 'Keine Daten verf�gbar.';
    'Keine Nachfahren gefunden.'; 'mut'; 'Mutter'; 'Nachfahren von'; 'Nachfahren'; 'num'; 'Schacht';
    'Schade ... '; 'vat'; 'Vater'; 'zeile'; '�E���i���_^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.geschachtelt1Click(Sender : TObject);
begin
(*
005FDCA8   55                     push    ebp
005FDCA9   8BEC                   mov     ebp, esp
005FDCAB   B980000000             mov     ecx, $00000080
005FDCB0   6A00                   push    $00
005FDCB2   6A00                   push    $00
005FDCB4   49                     dec     ecx
005FDCB5   75F9                   jnz     005FDCB0
005FDCB7   51                     push    ecx
005FDCB8   53                     push    ebx
005FDCB9   56                     push    esi
005FDCBA   57                     push    edi
005FDCBB   8955FC                 mov     [ebp-$04], edx
005FDCBE   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005FDCC0   8B1D3CCC6100           mov     ebx, [$0061CC3C]
005FDCC6   33C0                   xor     eax, eax
005FDCC8   55                     push    ebp

* Possible String Reference to: '�E���i���_^[��]�'
|
005FDCC9   683AFF5F00             push    $005FFF3A

***** TRY
|
005FDCCE   64FF30                 push    dword ptr fs:[eax]
005FDCD1   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FDCD4   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FDCDA   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FDCE0   E8D320E8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005FDCE5   8B861C060000           mov     eax, [esi+$061C]
005FDCEB   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FDCED   FF5244                 call    dword ptr [edx+$44]
005FDCF0   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Schacht'
|
005FDCF5   BA54FF5F00             mov     edx, $005FFF54

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FDCFA   E8BD6EE0FF             call    00404BBC
005FDCFF   8BC6                   mov     eax, esi

* Reference to : TForm1.speich1()
|
005FDD01   E8969CFDFF             call    005D799C
005FDD06   8B03                   mov     eax, [ebx]

* Reference to field TForm1.AutoSize : Boolean
|
005FDD08   8B405C                 mov     eax, [eax+$5C]
005FDD0B   8B10                   mov     edx, [eax]

* Possible reference to virtual method TBoolean.OFFS_014C
|
005FDD0D   FF924C010000           call    dword ptr [edx+$014C]
005FDD13   83F802                 cmp     eax, +$02
005FDD16   7D0F                   jnl     005FDD27

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005FDD18   B864FF5F00             mov     eax, $005FFF64

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FDD1D   E8C27AE4FF             call    004457E4
005FDD22   E979210000             jmp     005FFEA0

* Reference to control TForm1.PageControl1 : TPageControl
|
005FDD27   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.GetPageCount(TPageControl):Integer;
|
005FDD2D   E8EA1EE8FF             call    0047FC1C
005FDD32   83F802                 cmp     eax, +$02
005FDD35   7411                   jz      005FDD48

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FDD37   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FDD3D   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FDD43   E87020E8FF             call    0047FDB8
005FDD48   8D8554FFFFFF           lea     eax, [ebp+$FFFFFF54]
005FDD4E   50                     push    eax
005FDD4F   33C9                   xor     ecx, ecx
005FDD51   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid2 : TStringGrid
|
005FDD56   8B8674030000           mov     eax, [esi+$0374]

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
005FDD5C   E82B1DEEFF             call    004DFA8C
005FDD61   83BD54FFFFFF00         cmp     dword ptr [ebp+$FFFFFF54], +$00
005FDD68   751D                   jnz     005FDD87
005FDD6A   6A00                   push    $00

* Possible String Reference to: 'Schade ... '
|
005FDD6C   B97CFF5F00             mov     ecx, $005FFF7C

* Possible String Reference to: 'Keine Nachfahren gefunden.'
|
005FDD71   BA88FF5F00             mov     edx, $005FFF88

* Reference to TApplication instance
|
005FDD76   A10CC96100             mov     eax, dword ptr [$0061C90C]
005FDD7B   8B00                   mov     eax, [eax]

* Reference to: Forms.TApplication.MessageBox(TApplication;PChar;PChar;Longint):Integer;
|
005FDD7D   E84EF5E6FF             call    0046D2D0
005FDD82   E919210000             jmp     005FFEA0
005FDD87   8D4598                 lea     eax, [ebp-$68]

* Reference to: System.@LStrClr(void;void);
|
005FDD8A   E8D96DE0FF             call    00404B68
005FDD8F   8D954CFEFFFF           lea     edx, [ebp+$FFFFFE4C]
005FDD95   8B03                   mov     eax, [ebx]
005FDD97   8B8048050000           mov     eax, [eax+$0548]
005FDD9D   8B08                   mov     ecx, [eax]
005FDD9F   FF5160                 call    dword ptr [ecx+$60]
005FDDA2   8B854CFEFFFF           mov     eax, [ebp+$FFFFFE4C]
005FDDA8   8D9550FEFFFF           lea     edx, [ebp+$FFFFFE50]

* Reference to: Unit_00408494.Proc_004091D8
|
005FDDAE   E825B4E0FF             call    004091D8
005FDDB3   8B9550FEFFFF           mov     edx, [ebp+$FFFFFE50]
005FDDB9   8D8554FEFFFF           lea     eax, [ebp+$FFFFFE54]
005FDDBF   B9FF000000             mov     ecx, $000000FF

* Reference to: System.@LStrToString;
|
005FDDC4   E83370E0FF             call    00404DFC
005FDDC9   8D9554FEFFFF           lea     edx, [ebp+$FFFFFE54]
005FDDCF   8D8576FFFFFF           lea     eax, [ebp+$FFFFFF76]
005FDDD5   B101                   mov     cl, $01

* Reference to: System.@PStrNCpy(PShortString;PShortString;Byte);
|
005FDDD7   E8C453E0FF             call    004031A0
005FDDDC   8B03                   mov     eax, [ebx]
005FDDDE   8B8034050000           mov     eax, [eax+$0534]
005FDDE4   8B10                   mov     edx, [eax]
005FDDE6   FF5258                 call    dword ptr [edx+$58]
005FDDE9   8945E0                 mov     [ebp-$20], eax
005FDDEC   833DA05B530201         cmp     dword ptr [$02535BA0], +$01
005FDDF3   0F8E54010000           jle     005FDF4D

* Possible String Reference to: 'gebjahr<='
|
005FDDF9   68ACFF5F00             push    $005FFFAC
005FDDFE   8D9544FEFFFF           lea     edx, [ebp+$FFFFFE44]
005FDE04   A1A05B5302             mov     eax, dword ptr [$02535BA0]

* Reference to: Unit_00408494.Proc_00409950
|
005FDE09   E842BBE0FF             call    00409950
005FDE0E   FFB544FEFFFF           push    dword ptr [ebp+$FFFFFE44]

* Possible String Reference to: ' and taufjahr<='
|
005FDE14   68C0FF5F00             push    $005FFFC0
005FDE19   8D9540FEFFFF           lea     edx, [ebp+$FFFFFE40]
005FDE1F   A1A05B5302             mov     eax, dword ptr [$02535BA0]

* Reference to: Unit_00408494.Proc_00409950
|
005FDE24   E827BBE0FF             call    00409950
005FDE29   FFB540FEFFFF           push    dword ptr [ebp+$FFFFFE40]
005FDE2F   8D8548FEFFFF           lea     eax, [ebp+$FFFFFE48]
005FDE35   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005FDE3A   E8A170E0FF             call    00404EE0
005FDE3F   8B9548FEFFFF           mov     edx, [ebp+$FFFFFE48]
005FDE45   8B03                   mov     eax, [ebx]
005FDE47   8B405C                 mov     eax, [eax+$5C]
005FDE4A   8B08                   mov     ecx, [eax]
005FDE4C   FF9198010000           call    dword ptr [ecx+$0198]
005FDE52   8B03                   mov     eax, [ebx]
005FDE54   8B405C                 mov     eax, [eax+$5C]
005FDE57   B201                   mov     dl, $01
005FDE59   8B08                   mov     ecx, [eax]
005FDE5B   FF9190010000           call    dword ptr [ecx+$0190]

* Possible String Reference to: 'gebjahr<='
|
005FDE61   68ACFF5F00             push    $005FFFAC
005FDE66   8D9538FEFFFF           lea     edx, [ebp+$FFFFFE38]
005FDE6C   A1A05B5302             mov     eax, dword ptr [$02535BA0]

* Reference to: Unit_00408494.Proc_00409950
|
005FDE71   E8DABAE0FF             call    00409950
005FDE76   FFB538FEFFFF           push    dword ptr [ebp+$FFFFFE38]

* Possible String Reference to: ' and taufjahr<='
|
005FDE7C   68C0FF5F00             push    $005FFFC0
005FDE81   8D9534FEFFFF           lea     edx, [ebp+$FFFFFE34]
005FDE87   A1A05B5302             mov     eax, dword ptr [$02535BA0]

* Reference to: Unit_00408494.Proc_00409950
|
005FDE8C   E8BFBAE0FF             call    00409950
005FDE91   FFB534FEFFFF           push    dword ptr [ebp+$FFFFFE34]
005FDE97   8D853CFEFFFF           lea     eax, [ebp+$FFFFFE3C]
005FDE9D   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005FDEA2   E83970E0FF             call    00404EE0
005FDEA7   8B953CFEFFFF           mov     edx, [ebp+$FFFFFE3C]
005FDEAD   8B03                   mov     eax, [ebx]
005FDEAF   8B809C000000           mov     eax, [eax+$009C]
005FDEB5   8B08                   mov     ecx, [eax]
005FDEB7   FF9198010000           call    dword ptr [ecx+$0198]
005FDEBD   8B03                   mov     eax, [ebx]
005FDEBF   8B809C000000           mov     eax, [eax+$009C]
005FDEC5   B201                   mov     dl, $01
005FDEC7   8B08                   mov     ecx, [eax]
005FDEC9   FF9190010000           call    dword ptr [ecx+$0190]

* Possible String Reference to: 'gebjahr<='
|
005FDECF   68ACFF5F00             push    $005FFFAC
005FDED4   8D952CFEFFFF           lea     edx, [ebp+$FFFFFE2C]
005FDEDA   A1A05B5302             mov     eax, dword ptr [$02535BA0]

* Reference to: Unit_00408494.Proc_00409950
|
005FDEDF   E86CBAE0FF             call    00409950
005FDEE4   FFB52CFEFFFF           push    dword ptr [ebp+$FFFFFE2C]

* Possible String Reference to: ' and taufjahr<='
|
005FDEEA   68C0FF5F00             push    $005FFFC0
005FDEEF   8D9528FEFFFF           lea     edx, [ebp+$FFFFFE28]
005FDEF5   A1A05B5302             mov     eax, dword ptr [$02535BA0]

* Reference to: Unit_00408494.Proc_00409950
|
005FDEFA   E851BAE0FF             call    00409950
005FDEFF   FFB528FEFFFF           push    dword ptr [ebp+$FFFFFE28]
005FDF05   8D8530FEFFFF           lea     eax, [ebp+$FFFFFE30]
005FDF0B   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005FDF10   E8CB6FE0FF             call    00404EE0
005FDF15   8B9530FEFFFF           mov     edx, [ebp+$FFFFFE30]
005FDF1B   8B03                   mov     eax, [ebx]
005FDF1D   8B803C010000           mov     eax, [eax+$013C]
005FDF23   8B08                   mov     ecx, [eax]
005FDF25   FF9198010000           call    dword ptr [ecx+$0198]
005FDF2B   8B03                   mov     eax, [ebx]
005FDF2D   8B803C010000           mov     eax, [eax+$013C]
005FDF33   B201                   mov     dl, $01
005FDF35   8B08                   mov     ecx, [eax]
005FDF37   FF9190010000           call    dword ptr [ecx+$0190]
005FDF3D   BAFFFF0000             mov     edx, $0000FFFF

* Reference to control TForm1.DBText1 : TDBText
|
005FDF42   8B86B4070000           mov     eax, [esi+$07B4]

* Reference to: Controls.TControl.SetColor(TControl;TColor);
|
005FDF48   E857ECE4FF             call    0044CBA4

* Reference to Application
|
005FDF4D   8B45E0                 mov     eax, [ebp-$20]
005FDF50   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FDF56   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FDF5D   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FDF63   8B03                   mov     eax, [ebx]

* Reference to field Application.OFFS_005C
|
005FDF65   8B405C                 mov     eax, [eax+$5C]
005FDF68   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FDF6A   E8F552EDFF             call    004D3264
005FDF6F   8B03                   mov     eax, [ebx]
005FDF71   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FDF77   E80CEDEAFF             call    004ACC88
005FDF7C   8B03                   mov     eax, [ebx]
005FDF7E   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005FDF84   E80BEDEAFF             call    004ACC94
005FDF89   8B03                   mov     eax, [ebx]
005FDF8B   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005FDF91   E84660EDFF             call    004D3FDC
005FDF96   8B03                   mov     eax, [ebx]
005FDF98   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FDF9E   E8E5ECEAFF             call    004ACC88
005FDFA3   8B03                   mov     eax, [ebx]
005FDFA5   8B803C010000           mov     eax, [eax+$013C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FDFAB   E8D8ECEAFF             call    004ACC88
005FDFB0   8B03                   mov     eax, [ebx]
005FDFB2   8B8040010000           mov     eax, [eax+$0140]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FDFB8   E8CBECEAFF             call    004ACC88
005FDFBD   B830595302             mov     eax, $02535930

* Possible String Reference to: 'Nachfahren von'
|
005FDFC2   BAD8FF5F00             mov     edx, $005FFFD8

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FDFC7   E8F06BE0FF             call    00404BBC
005FDFCC   8D9518FEFFFF           lea     edx, [ebp+$FFFFFE18]
005FDFD2   8B03                   mov     eax, [ebx]
005FDFD4   8B8040050000           mov     eax, [eax+$0540]
005FDFDA   8B08                   mov     ecx, [eax]
005FDFDC   FF5160                 call    dword ptr [ecx+$60]
005FDFDF   8B9518FEFFFF           mov     edx, [ebp+$FFFFFE18]
005FDFE5   8D8D1CFEFFFF           lea     ecx, [ebp+$FFFFFE1C]
005FDFEB   8BC6                   mov     eax, esi

* Reference to : TForm1.ucase()
|
005FDFED   E8969BFDFF             call    005D7B88
005FDFF2   FFB51CFEFFFF           push    dword ptr [ebp+$FFFFFE1C]
005FDFF8   68F0FF5F00             push    $005FFFF0
005FDFFD   8D9514FEFFFF           lea     edx, [ebp+$FFFFFE14]
005FE003   8B03                   mov     eax, [ebx]

* Reference to control TForm1.Label47 : TLabel
|
005FE005   8B8044050000           mov     eax, [eax+$0544]
005FE00B   8B08                   mov     ecx, [eax]

* Reference to method TLabel.SetDragMode(TDragMode)
|
005FE00D   FF5160                 call    dword ptr [ecx+$60]
005FE010   FFB514FEFFFF           push    dword ptr [ebp+$FFFFFE14]

* Possible String Reference to: ', '
|
005FE016   68FCFF5F00             push    $005FFFFC
005FE01B   8D9510FEFFFF           lea     edx, [ebp+$FFFFFE10]
005FE021   8B03                   mov     eax, [ebx]

* Reference to field TLabel.OFFS_0550
|
005FE023   8B8050050000           mov     eax, [eax+$0550]
005FE029   8B08                   mov     ecx, [eax]
005FE02B   FF5160                 call    dword ptr [ecx+$60]
005FE02E   FFB510FEFFFF           push    dword ptr [ebp+$FFFFFE10]

* Possible String Reference to: '  '
|
005FE034   6808006000             push    $00600008
005FE039   8D950CFEFFFF           lea     edx, [ebp+$FFFFFE0C]
005FE03F   8B03                   mov     eax, [ebx]
005FE041   8B804C050000           mov     eax, [eax+$054C]
005FE047   8B08                   mov     ecx, [eax]
005FE049   FF5160                 call    dword ptr [ecx+$60]
005FE04C   FFB50CFEFFFF           push    dword ptr [ebp+$FFFFFE0C]
005FE052   B834595302             mov     eax, $02535934
005FE057   BA07000000             mov     edx, $00000007

* Reference to: System.Proc_00404EE0
|
005FE05C   E87F6EE0FF             call    00404EE0
005FE061   8D9508FEFFFF           lea     edx, [ebp+$FFFFFE08]
005FE067   8B03                   mov     eax, [ebx]
005FE069   8B805C050000           mov     eax, [eax+$055C]
005FE06F   8B08                   mov     ecx, [eax]
005FE071   FF5160                 call    dword ptr [ecx+$60]
005FE074   83BD08FEFFFF00         cmp     dword ptr [ebp+$FFFFFE08], +$00
005FE07B   0F869F000000           jbe     005FE120
005FE081   8D95F8FDFFFF           lea     edx, [ebp+$FFFFFDF8]
005FE087   8B03                   mov     eax, [ebx]
005FE089   8B8054050000           mov     eax, [eax+$0554]
005FE08F   8B08                   mov     ecx, [eax]
005FE091   FF5160                 call    dword ptr [ecx+$60]
005FE094   FFB5F8FDFFFF           push    dword ptr [ebp+$FFFFFDF8]
005FE09A   6814006000             push    $00600014
005FE09F   8D95F4FDFFFF           lea     edx, [ebp+$FFFFFDF4]
005FE0A5   8B03                   mov     eax, [ebx]
005FE0A7   8B8058050000           mov     eax, [eax+$0558]
005FE0AD   8B08                   mov     ecx, [eax]
005FE0AF   FF5160                 call    dword ptr [ecx+$60]
005FE0B2   FFB5F4FDFFFF           push    dword ptr [ebp+$FFFFFDF4]
005FE0B8   6814006000             push    $00600014
005FE0BD   8D95F0FDFFFF           lea     edx, [ebp+$FFFFFDF0]
005FE0C3   8B03                   mov     eax, [ebx]
005FE0C5   8B805C050000           mov     eax, [eax+$055C]
005FE0CB   8B08                   mov     ecx, [eax]
005FE0CD   FF5160                 call    dword ptr [ecx+$60]
005FE0D0   FFB5F0FDFFFF           push    dword ptr [ebp+$FFFFFDF0]
005FE0D6   8D85FCFDFFFF           lea     eax, [ebp+$FFFFFDFC]
005FE0DC   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005FE0E1   E8FA6DE0FF             call    00404EE0
005FE0E6   8B85FCFDFFFF           mov     eax, [ebp+$FFFFFDFC]
005FE0EC   8D9500FEFFFF           lea     edx, [ebp+$FFFFFE00]

* Reference to : TForm1.Proc_005D32CC()
|
005FE0F2   E8D551FDFF             call    005D32CC
005FE0F7   8B8500FEFFFF           mov     eax, [ebp+$FFFFFE00]
005FE0FD   8D9504FEFFFF           lea     edx, [ebp+$FFFFFE04]

* Reference to: Unit_00408494.Proc_00409448
|
005FE103   E840B3E0FF             call    00409448
005FE108   8B8D04FEFFFF           mov     ecx, [ebp+$FFFFFE04]
005FE10E   8D4598                 lea     eax, [ebp-$68]

* Possible String Reference to: ' * '
|
005FE111   BA20006000             mov     edx, $00600020

* Reference to: System.@LStrCat3;
|
005FE116   E8516DE0FF             call    00404E6C
005FE11B   E9BA000000             jmp     005FE1DA
005FE120   8D95ECFDFFFF           lea     edx, [ebp+$FFFFFDEC]
005FE126   8B03                   mov     eax, [ebx]
005FE128   8B806C050000           mov     eax, [eax+$056C]
005FE12E   8B08                   mov     ecx, [eax]
005FE130   FF5160                 call    dword ptr [ecx+$60]
005FE133   83BDECFDFFFF00         cmp     dword ptr [ebp+$FFFFFDEC], +$00
005FE13A   0F869A000000           jbe     005FE1DA
005FE140   8D95DCFDFFFF           lea     edx, [ebp+$FFFFFDDC]
005FE146   8B03                   mov     eax, [ebx]
005FE148   8B8064050000           mov     eax, [eax+$0564]
005FE14E   8B08                   mov     ecx, [eax]
005FE150   FF5160                 call    dword ptr [ecx+$60]
005FE153   FFB5DCFDFFFF           push    dword ptr [ebp+$FFFFFDDC]
005FE159   6814006000             push    $00600014
005FE15E   8D95D8FDFFFF           lea     edx, [ebp+$FFFFFDD8]
005FE164   8B03                   mov     eax, [ebx]
005FE166   8B8068050000           mov     eax, [eax+$0568]
005FE16C   8B08                   mov     ecx, [eax]
005FE16E   FF5160                 call    dword ptr [ecx+$60]
005FE171   FFB5D8FDFFFF           push    dword ptr [ebp+$FFFFFDD8]
005FE177   6814006000             push    $00600014
005FE17C   8D95D4FDFFFF           lea     edx, [ebp+$FFFFFDD4]
005FE182   8B03                   mov     eax, [ebx]
005FE184   8B806C050000           mov     eax, [eax+$056C]
005FE18A   8B08                   mov     ecx, [eax]
005FE18C   FF5160                 call    dword ptr [ecx+$60]
005FE18F   FFB5D4FDFFFF           push    dword ptr [ebp+$FFFFFDD4]
005FE195   8D85E0FDFFFF           lea     eax, [ebp+$FFFFFDE0]
005FE19B   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005FE1A0   E83B6DE0FF             call    00404EE0
005FE1A5   8B85E0FDFFFF           mov     eax, [ebp+$FFFFFDE0]
005FE1AB   8D95E4FDFFFF           lea     edx, [ebp+$FFFFFDE4]

* Reference to : TForm1.Proc_005D32CC()
|
005FE1B1   E81651FDFF             call    005D32CC
005FE1B6   8B85E4FDFFFF           mov     eax, [ebp+$FFFFFDE4]
005FE1BC   8D95E8FDFFFF           lea     edx, [ebp+$FFFFFDE8]

* Reference to: Unit_00408494.Proc_00409448
|
005FE1C2   E881B2E0FF             call    00409448
005FE1C7   8B8DE8FDFFFF           mov     ecx, [ebp+$FFFFFDE8]
005FE1CD   8D4598                 lea     eax, [ebp-$68]

* Possible String Reference to: ' ~ '
|
005FE1D0   BA2C006000             mov     edx, $0060002C

* Reference to: System.@LStrCat3;
|
005FE1D5   E8926CE0FF             call    00404E6C
005FE1DA   8D95D0FDFFFF           lea     edx, [ebp+$FFFFFDD0]
005FE1E0   8B03                   mov     eax, [ebx]
005FE1E2   8B8084050000           mov     eax, [eax+$0584]
005FE1E8   8B08                   mov     ecx, [eax]
005FE1EA   FF5160                 call    dword ptr [ecx+$60]
005FE1ED   83BDD0FDFFFF00         cmp     dword ptr [ebp+$FFFFFDD0], +$00
005FE1F4   0F86A2000000           jbe     005FE29C
005FE1FA   FF7598                 push    dword ptr [ebp-$68]

* Possible String Reference to: ' + '
|
005FE1FD   6838006000             push    $00600038
005FE202   8D95C0FDFFFF           lea     edx, [ebp+$FFFFFDC0]
005FE208   8B03                   mov     eax, [ebx]
005FE20A   8B807C050000           mov     eax, [eax+$057C]
005FE210   8B08                   mov     ecx, [eax]
005FE212   FF5160                 call    dword ptr [ecx+$60]
005FE215   FFB5C0FDFFFF           push    dword ptr [ebp+$FFFFFDC0]
005FE21B   6814006000             push    $00600014
005FE220   8D95BCFDFFFF           lea     edx, [ebp+$FFFFFDBC]
005FE226   8B03                   mov     eax, [ebx]
005FE228   8B8080050000           mov     eax, [eax+$0580]
005FE22E   8B08                   mov     ecx, [eax]
005FE230   FF5160                 call    dword ptr [ecx+$60]
005FE233   FFB5BCFDFFFF           push    dword ptr [ebp+$FFFFFDBC]
005FE239   6814006000             push    $00600014
005FE23E   8D95B8FDFFFF           lea     edx, [ebp+$FFFFFDB8]
005FE244   8B03                   mov     eax, [ebx]
005FE246   8B8084050000           mov     eax, [eax+$0584]
005FE24C   8B08                   mov     ecx, [eax]
005FE24E   FF5160                 call    dword ptr [ecx+$60]
005FE251   FFB5B8FDFFFF           push    dword ptr [ebp+$FFFFFDB8]
005FE257   8D85C4FDFFFF           lea     eax, [ebp+$FFFFFDC4]
005FE25D   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005FE262   E8796CE0FF             call    00404EE0
005FE267   8B85C4FDFFFF           mov     eax, [ebp+$FFFFFDC4]
005FE26D   8D95C8FDFFFF           lea     edx, [ebp+$FFFFFDC8]

* Reference to : TForm1.Proc_005D32CC()
|
005FE273   E85450FDFF             call    005D32CC
005FE278   8B85C8FDFFFF           mov     eax, [ebp+$FFFFFDC8]
005FE27E   8D95CCFDFFFF           lea     edx, [ebp+$FFFFFDCC]

* Reference to: Unit_00408494.Proc_00409448
|
005FE284   E8BFB1E0FF             call    00409448
005FE289   FFB5CCFDFFFF           push    dword ptr [ebp+$FFFFFDCC]
005FE28F   8D4598                 lea     eax, [ebp-$68]
005FE292   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005FE297   E8446CE0FF             call    00404EE0
005FE29C   8B03                   mov     eax, [ebx]
005FE29E   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005FE2A4   E87B14EBFF             call    004AF724
005FE2A9   8D85B4FDFFFF           lea     eax, [ebp+$FFFFFDB4]
005FE2AF   8B4D98                 mov     ecx, [ebp-$68]
005FE2B2   8B1534595302           mov     edx, [$02535934]

* Reference to: System.@LStrCat3;
|
005FE2B8   E8AF6BE0FF             call    00404E6C
005FE2BD   8B95B4FDFFFF           mov     edx, [ebp+$FFFFFDB4]
005FE2C3   8B03                   mov     eax, [ebx]
005FE2C5   8B80E8010000           mov     eax, [eax+$01E8]
005FE2CB   8B08                   mov     ecx, [eax]
005FE2CD   FF91B0000000           call    dword ptr [ecx+$00B0]
005FE2D3   8B03                   mov     eax, [ebx]
005FE2D5   8B80E0000000           mov     eax, [eax+$00E0]
005FE2DB   8B10                   mov     edx, [eax]
005FE2DD   FF9248020000           call    dword ptr [edx+$0248]
005FE2E3   8D95B0FDFFFF           lea     edx, [ebp+$FFFFFDB0]
005FE2E9   8B03                   mov     eax, [ebx]
005FE2EB   8B805C050000           mov     eax, [eax+$055C]
005FE2F1   8B08                   mov     ecx, [eax]
005FE2F3   FF5160                 call    dword ptr [ecx+$60]
005FE2F6   83BDB0FDFFFF00         cmp     dword ptr [ebp+$FFFFFDB0], +$00
005FE2FD   763A                   jbe     005FE339
005FE2FF   FF3534595302           push    dword ptr [$02535934]

* Possible String Reference to: ' ('
|
005FE305   6844006000             push    $00600044
005FE30A   8D95ACFDFFFF           lea     edx, [ebp+$FFFFFDAC]
005FE310   8B03                   mov     eax, [ebx]
005FE312   8B805C050000           mov     eax, [eax+$055C]
005FE318   8B08                   mov     ecx, [eax]
005FE31A   FF5160                 call    dword ptr [ecx+$60]
005FE31D   FFB5ACFDFFFF           push    dword ptr [ebp+$FFFFFDAC]

* Possible String Reference to: ' - '
|
005FE323   6850006000             push    $00600050
005FE328   B834595302             mov     eax, $02535934
005FE32D   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
005FE332   E8A96BE0FF             call    00404EE0
005FE337   EB0F                   jmp     005FE348
005FE339   B834595302             mov     eax, $02535934

* Possible String Reference to: ' ( - '
|
005FE33E   BA5C006000             mov     edx, $0060005C

* Reference to: System.@LStrCat;
|
005FE343   E8E06AE0FF             call    00404E28
005FE348   8D95A8FDFFFF           lea     edx, [ebp+$FFFFFDA8]
005FE34E   8B03                   mov     eax, [ebx]
005FE350   8B8084050000           mov     eax, [eax+$0584]
005FE356   8B08                   mov     ecx, [eax]
005FE358   FF5160                 call    dword ptr [ecx+$60]
005FE35B   83BDA8FDFFFF00         cmp     dword ptr [ebp+$FFFFFDA8], +$00
005FE362   7635                   jbe     005FE399
005FE364   FF3534595302           push    dword ptr [$02535934]
005FE36A   8D95A4FDFFFF           lea     edx, [ebp+$FFFFFDA4]
005FE370   8B03                   mov     eax, [ebx]
005FE372   8B8084050000           mov     eax, [eax+$0584]
005FE378   8B08                   mov     ecx, [eax]
005FE37A   FF5160                 call    dword ptr [ecx+$60]
005FE37D   FFB5A4FDFFFF           push    dword ptr [ebp+$FFFFFDA4]
005FE383   686C006000             push    $0060006C
005FE388   B834595302             mov     eax, $02535934
005FE38D   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005FE392   E8496BE0FF             call    00404EE0
005FE397   EB0F                   jmp     005FE3A8
005FE399   B834595302             mov     eax, $02535934
005FE39E   BA6C006000             mov     edx, $0060006C

* Reference to: System.@LStrCat;
|
005FE3A3   E8806AE0FF             call    00404E28
005FE3A8   8B03                   mov     eax, [ebx]
005FE3AA   8B8040010000           mov     eax, [eax+$0140]

* Possible String Reference to: 'num'
|
005FE3B0   BA78006000             mov     edx, $00600078

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FE3B5   E8A247EDFF             call    004D2B5C
005FE3BA   8B03                   mov     eax, [ebx]
005FE3BC   8B803C010000           mov     eax, [eax+$013C]
005FE3C2   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FE3C4   E89347EDFF             call    004D2B5C
005FE3C9   8B03                   mov     eax, [ebx]
005FE3CB   8B809C000000           mov     eax, [eax+$009C]
005FE3D1   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FE3D3   E88447EDFF             call    004D2B5C
005FE3D8   8D45D0                 lea     eax, [ebp-$30]

* Reference to: System.@LStrClr(void;void);
|
005FE3DB   E88867E0FF             call    00404B68
005FE3E0   8D45CC                 lea     eax, [ebp-$34]

* Reference to: System.@LStrClr(void;void);
|
005FE3E3   E88067E0FF             call    00404B68
005FE3E8   8D45C8                 lea     eax, [ebp-$38]

* Reference to: System.@LStrClr(void;void);
|
005FE3EB   E87867E0FF             call    00404B68
005FE3F0   8D45C4                 lea     eax, [ebp-$3C]

* Reference to: System.@LStrClr(void;void);
|
005FE3F3   E87067E0FF             call    00404B68
005FE3F8   8D45C0                 lea     eax, [ebp-$40]

* Reference to: System.@LStrClr(void;void);
|
005FE3FB   E86867E0FF             call    00404B68
005FE400   8D45BC                 lea     eax, [ebp-$44]

* Possible String Reference to: '- -     '
|
005FE403   BA84006000             mov     edx, $00600084

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE408   E8F367E0FF             call    00404C00
005FE40D   8D45B8                 lea     eax, [ebp-$48]

* Possible String Reference to: '- - -       '
|
005FE410   BA98006000             mov     edx, $00600098

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE415   E8E667E0FF             call    00404C00
005FE41A   8D45B4                 lea     eax, [ebp-$4C]

* Possible String Reference to: '- - - -         '
|
005FE41D   BAB0006000             mov     edx, $006000B0

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE422   E8D967E0FF             call    00404C00
005FE427   8D45B0                 lea     eax, [ebp-$50]

* Reference to: System.@LStrClr(void;void);
|
005FE42A   E83967E0FF             call    00404B68
005FE42F   8D45AC                 lea     eax, [ebp-$54]

* Possible String Reference to: '        '
|
005FE432   BACC006000             mov     edx, $006000CC

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE437   E8C467E0FF             call    00404C00
005FE43C   8D45A8                 lea     eax, [ebp-$58]

* Possible String Reference to: '             '
|
005FE43F   BAE0006000             mov     edx, $006000E0

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE444   E8B767E0FF             call    00404C00
005FE449   8D45A4                 lea     eax, [ebp-$5C]

* Possible String Reference to: '                   '
|
005FE44C   BAF8006000             mov     edx, $006000F8

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE451   E8AA67E0FF             call    00404C00
005FE456   8D4594                 lea     eax, [ebp-$6C]

* Reference to: System.@LStrClr(void;void);
|
005FE459   E80A67E0FF             call    00404B68
005FE45E   8D4590                 lea     eax, [ebp-$70]

* Reference to: System.@LStrClr(void;void);
|
005FE461   E80267E0FF             call    00404B68
005FE466   8D458C                 lea     eax, [ebp-$74]

* Reference to: System.@LStrClr(void;void);
|
005FE469   E8FA66E0FF             call    00404B68
005FE46E   8D4588                 lea     eax, [ebp-$78]

* Reference to: System.@LStrClr(void;void);
|
005FE471   E8F266E0FF             call    00404B68
005FE476   8D8576FFFFFF           lea     eax, [ebp+$FFFFFF76]
005FE47C   BA0C016000             mov     edx, $0060010C
005FE481   33C9                   xor     ecx, ecx
005FE483   8A08                   mov     cl, byte ptr [eax]
005FE485   41                     inc     ecx

* Reference to: System.@AStrCmp;
|
005FE486   E8B54DE0FF             call    00403240
005FE48B   752E                   jnz     005FE4BB
005FE48D   8B03                   mov     eax, [ebx]
005FE48F   8B803C010000           mov     eax, [eax+$013C]

* Possible String Reference to: 'vat'
|
005FE495   BA18016000             mov     edx, $00600118

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FE49A   E8BD46EDFF             call    004D2B5C
005FE49F   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Vater'
|
005FE4A2   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE4A7   E85467E0FF             call    00404C00
005FE4AC   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Mutter'
|
005FE4AF   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE4B4   E84767E0FF             call    00404C00
005FE4B9   EB43                   jmp     005FE4FE
005FE4BB   8D8576FFFFFF           lea     eax, [ebp+$FFFFFF76]
005FE4C1   BA3C016000             mov     edx, $0060013C
005FE4C6   33C9                   xor     ecx, ecx
005FE4C8   8A08                   mov     cl, byte ptr [eax]
005FE4CA   41                     inc     ecx

* Reference to: System.@AStrCmp;
|
005FE4CB   E8704DE0FF             call    00403240
005FE4D0   752C                   jnz     005FE4FE
005FE4D2   8B03                   mov     eax, [ebx]
005FE4D4   8B803C010000           mov     eax, [eax+$013C]

* Possible String Reference to: 'mut'
|
005FE4DA   BA48016000             mov     edx, $00600148

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FE4DF   E87846EDFF             call    004D2B5C
005FE4E4   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Mutter'
|
005FE4E7   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE4EC   E80F67E0FF             call    00404C00
005FE4F1   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Vater'
|
005FE4F4   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE4F9   E80267E0FF             call    00404C00

* Reference to Application
|
005FE4FE   8B45E0                 mov     eax, [ebp-$20]
005FE501   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FE507   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FE50E   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FE514   8B03                   mov     eax, [ebx]

* Reference to field Application.OFFS_013C
|
005FE516   8B803C010000           mov     eax, [eax+$013C]
005FE51C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FE51E   E8414DEDFF             call    004D3264
005FE523   84C0                   test    al, al
005FE525   0F842C010000           jz      005FE657
005FE52B   E909010000             jmp     005FE639
005FE530   8B03                   mov     eax, [ebx]
005FE532   8B803C010000           mov     eax, [eax+$013C]
005FE538   8B559C                 mov     edx, [ebp-$64]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FE53B   E804F9EAFF             call    004ADE44
005FE540   8B10                   mov     edx, [eax]
005FE542   FF5258                 call    dword ptr [edx+$58]
005FE545   85C0                   test    eax, eax
005FE547   0F85CE000000           jnz     005FE61B
005FE54D   8B03                   mov     eax, [ebx]
005FE54F   8B8044090000           mov     eax, [eax+$0944]
005FE555   8B10                   mov     edx, [eax]
005FE557   FF5258                 call    dword ptr [edx+$58]
005FE55A   8D95A0FDFFFF           lea     edx, [ebp+$FFFFFDA0]

* Reference to : TForm1.Proc_005D3228()
|
005FE560   E8C34CFDFF             call    005D3228
005FE565   8B95A0FDFFFF           mov     edx, [ebp+$FFFFFDA0]
005FE56B   8D45CC                 lea     eax, [ebp-$34]

* Reference to: System.@LStrCat;
|
005FE56E   E8B568E0FF             call    00404E28
005FE573   8B03                   mov     eax, [ebx]
005FE575   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005FE57B   E8A411EBFF             call    004AF724
005FE580   FF75BC                 push    dword ptr [ebp-$44]
005FE583   8D9594FDFFFF           lea     edx, [ebp+$FFFFFD94]
005FE589   8B03                   mov     eax, [ebx]
005FE58B   8B8050090000           mov     eax, [eax+$0950]
005FE591   8B08                   mov     ecx, [eax]
005FE593   FF5160                 call    dword ptr [ecx+$60]
005FE596   8B9594FDFFFF           mov     edx, [ebp+$FFFFFD94]
005FE59C   8D8D98FDFFFF           lea     ecx, [ebp+$FFFFFD98]
005FE5A2   8BC6                   mov     eax, esi

* Reference to : TForm1.ucase()
|
005FE5A4   E8DF95FDFF             call    005D7B88
005FE5A9   FFB598FDFFFF           push    dword ptr [ebp+$FFFFFD98]
005FE5AF   68F0FF5F00             push    $005FFFF0
005FE5B4   8D9590FDFFFF           lea     edx, [ebp+$FFFFFD90]
005FE5BA   8B03                   mov     eax, [ebx]

* Reference to control TForm1.Image11 : TImage
|
005FE5BC   8B8054090000           mov     eax, [eax+$0954]
005FE5C2   8B08                   mov     ecx, [eax]

* Reference to method TImage.SetDragMode(TDragMode)
|
005FE5C4   FF5160                 call    dword ptr [ecx+$60]
005FE5C7   FFB590FDFFFF           push    dword ptr [ebp+$FFFFFD90]
005FE5CD   68F0FF5F00             push    $005FFFF0
005FE5D2   8D958CFDFFFF           lea     edx, [ebp+$FFFFFD8C]
005FE5D8   8BC6                   mov     eax, esi

* Reference to : TForm1.geb_sterb()
|
005FE5DA   E8EDEDFFFF             call    005FD3CC
005FE5DF   FFB58CFDFFFF           push    dword ptr [ebp+$FFFFFD8C]
005FE5E5   8D859CFDFFFF           lea     eax, [ebp+$FFFFFD9C]
005FE5EB   BA06000000             mov     edx, $00000006

* Reference to: System.Proc_00404EE0
|
005FE5F0   E8EB68E0FF             call    00404EE0
005FE5F5   8B959CFDFFFF           mov     edx, [ebp+$FFFFFD9C]
005FE5FB   8B03                   mov     eax, [ebx]
005FE5FD   8B80E8010000           mov     eax, [eax+$01E8]
005FE603   8B08                   mov     ecx, [eax]
005FE605   FF91B0000000           call    dword ptr [ecx+$00B0]
005FE60B   8B03                   mov     eax, [ebx]
005FE60D   8B80E0000000           mov     eax, [eax+$00E0]
005FE613   8B10                   mov     edx, [eax]
005FE615   FF9248020000           call    dword ptr [edx+$0248]
005FE61B   8B03                   mov     eax, [ebx]
005FE61D   8B803C010000           mov     eax, [eax+$013C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005FE623   E8C40EEBFF             call    004AF4EC
005FE628   8B03                   mov     eax, [ebx]
005FE62A   8B803C010000           mov     eax, [eax+$013C]
005FE630   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005FE637   751E                   jnz     005FE657
005FE639   8B03                   mov     eax, [ebx]
005FE63B   8B803C010000           mov     eax, [eax+$013C]
005FE641   8B55A0                 mov     edx, [ebp-$60]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FE644   E8FBF7EAFF             call    004ADE44
005FE649   8B10                   mov     edx, [eax]
005FE64B   FF5258                 call    dword ptr [edx+$58]
005FE64E   3B45E0                 cmp     eax, [ebp-$20]
005FE651   0F84D9FEFFFF           jz      005FE530
005FE657   8B03                   mov     eax, [ebx]
005FE659   8B803C010000           mov     eax, [eax+$013C]
005FE65F   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FE661   E8F644EDFF             call    004D2B5C
005FE666   8D4D94                 lea     ecx, [ebp-$6C]

* Reference to Application
|
005FE669   8B55E0                 mov     edx, [ebp-$20]
005FE66C   8BC6                   mov     eax, esi

* Reference to : TForm1.ehtest()
|
005FE66E   E81DF2FFFF             call    005FD890
005FE673   8B4594                 mov     eax, [ebp-$6C]

* Reference to: System.@LStrLen(String):Integer;
|
005FE676   E8A567E0FF             call    00404E20
005FE67B   898588FDFFFF           mov     [ebp+$FFFFFD88], eax
005FE681   DB8588FDFFFF           fild    dword ptr [ebp+$FFFFFD88]
005FE687   D8354C016000           fdiv    dword ptr [$0060014C]

* Reference to: System.@ROUND;
|
005FE68D   E89E46E0FF             call    00402D30
005FE692   85C0                   test    eax, eax
005FE694   0F8EE8150000           jle     005FFC82
005FE69A   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005FE6A0   C745F801000000         mov     dword ptr [ebp-$08], $00000001
005FE6A7   8D45CC                 lea     eax, [ebp-$34]

* Reference to: System.@LStrClr(void;void);
|
005FE6AA   E8B964E0FF             call    00404B68
005FE6AF   8D45C8                 lea     eax, [ebp-$38]

* Reference to: System.@LStrClr(void;void);
|
005FE6B2   E8B164E0FF             call    00404B68
005FE6B7   8D45C4                 lea     eax, [ebp-$3C]

* Reference to: System.@LStrClr(void;void);
|
005FE6BA   E8A964E0FF             call    00404B68
005FE6BF   8D8584FDFFFF           lea     eax, [ebp+$FFFFFD84]
005FE6C5   50                     push    eax
005FE6C6   8B45F8                 mov     eax, [ebp-$08]
005FE6C9   48                     dec     eax
005FE6CA   8BD0                   mov     edx, eax
005FE6CC   C1E204                 shl     edx, $04
005FE6CF   03D0                   add     edx, eax
005FE6D1   42                     inc     edx
005FE6D2   B906000000             mov     ecx, $00000006
005FE6D7   8B4594                 mov     eax, [ebp-$6C]

* Reference to: System.@LStrCopy;
|
005FE6DA   E89969E0FF             call    00405078
005FE6DF   8B8584FDFFFF           mov     eax, [ebp+$FFFFFD84]

* Reference to: Unit_00408494.Proc_004099B4
|
005FE6E5   E8CAB2E0FF             call    004099B4
005FE6EA   8945D4                 mov     [ebp-$2C], eax
005FE6ED   8D8580FDFFFF           lea     eax, [ebp+$FFFFFD80]
005FE6F3   50                     push    eax
005FE6F4   8B45F8                 mov     eax, [ebp-$08]
005FE6F7   48                     dec     eax
005FE6F8   8BD0                   mov     edx, eax
005FE6FA   C1E204                 shl     edx, $04
005FE6FD   03D0                   add     edx, eax
005FE6FF   83C211                 add     edx, +$11
005FE702   B901000000             mov     ecx, $00000001
005FE707   8B4594                 mov     eax, [ebp-$6C]

* Reference to: System.@LStrCopy;
|
005FE70A   E86969E0FF             call    00405078
005FE70F   8B8580FDFFFF           mov     eax, [ebp+$FFFFFD80]
005FE715   BA58016000             mov     edx, $00600158

* Reference to: System.@LStrCmp;
|
005FE71A   E84568E0FF             call    00404F64
005FE71F   7512                   jnz     005FE733
005FE721   56                     push    esi
005FE722   BE5C016000             mov     esi, $0060015C
005FE727   8DBD72FFFFFF           lea     edi, [ebp+$FFFFFF72]
005FE72D   66A5                   movsw
005FE72F   A4                     movsb
005FE730   5E                     pop     esi
005FE731   EB0A                   jmp     005FE73D
005FE733   C78572FFFFFF036F2D6F   mov     dword ptr [ebp+$FFFFFF72], $6F2D6F03
005FE73D   8B45D4                 mov     eax, [ebp-$2C]
005FE740   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FE746   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FE74D   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FE753   8B03                   mov     eax, [ebx]
005FE755   8B803C010000           mov     eax, [eax+$013C]
005FE75B   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FE75D   E8024BEDFF             call    004D3264
005FE762   8B03                   mov     eax, [ebx]
005FE764   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005FE76A   E8B50FEBFF             call    004AF724
005FE76F   8D9572FFFFFF           lea     edx, [ebp+$FFFFFF72]
005FE775   8D8570FDFFFF           lea     eax, [ebp+$FFFFFD70]

* Reference to: System.@PStrCpy(PShortString;PShortString);
|
005FE77B   E8144AE0FF             call    00403194
005FE780   BA60016000             mov     edx, $00600160
005FE785   8D8570FDFFFF           lea     eax, [ebp+$FFFFFD70]
005FE78B   B104                   mov     cl, $04

* Reference to: System.@PStrNCat;
|
005FE78D   E8D249E0FF             call    00403164
005FE792   8D9570FDFFFF           lea     edx, [ebp+$FFFFFD70]
005FE798   8D8578FDFFFF           lea     eax, [ebp+$FFFFFD78]

* Reference to: System.@LStrFromString(String;String;ShortString;ShortString);
|
005FE79E   E82166E0FF             call    00404DC4
005FE7A3   FFB578FDFFFF           push    dword ptr [ebp+$FFFFFD78]
005FE7A9   8D856CFDFFFF           lea     eax, [ebp+$FFFFFD6C]
005FE7AF   50                     push    eax
005FE7B0   8B45F8                 mov     eax, [ebp-$08]
005FE7B3   48                     dec     eax
005FE7B4   8BD0                   mov     edx, eax
005FE7B6   C1E204                 shl     edx, $04
005FE7B9   03D0                   add     edx, eax
005FE7BB   83C207                 add     edx, +$07
005FE7BE   B90A000000             mov     ecx, $0000000A
005FE7C3   8B4594                 mov     eax, [ebp-$6C]

* Reference to: System.@LStrCopy;
|
005FE7C6   E8AD68E0FF             call    00405078
005FE7CB   FFB56CFDFFFF           push    dword ptr [ebp+$FFFFFD6C]

* Possible String Reference to: ' : '
|
005FE7D1   686C016000             push    $0060016C
005FE7D6   8D9564FDFFFF           lea     edx, [ebp+$FFFFFD64]
005FE7DC   8B03                   mov     eax, [ebx]
005FE7DE   8B8050090000           mov     eax, [eax+$0950]
005FE7E4   8B08                   mov     ecx, [eax]
005FE7E6   FF5160                 call    dword ptr [ecx+$60]
005FE7E9   8B9564FDFFFF           mov     edx, [ebp+$FFFFFD64]
005FE7EF   8D8D68FDFFFF           lea     ecx, [ebp+$FFFFFD68]
005FE7F5   8BC6                   mov     eax, esi

* Reference to : TForm1.ucase()
|
005FE7F7   E88C93FDFF             call    005D7B88
005FE7FC   FFB568FDFFFF           push    dword ptr [ebp+$FFFFFD68]
005FE802   68F0FF5F00             push    $005FFFF0
005FE807   8D9560FDFFFF           lea     edx, [ebp+$FFFFFD60]
005FE80D   8B03                   mov     eax, [ebx]
005FE80F   8B8054090000           mov     eax, [eax+$0954]
005FE815   8B08                   mov     ecx, [eax]
005FE817   FF5160                 call    dword ptr [ecx+$60]
005FE81A   FFB560FDFFFF           push    dword ptr [ebp+$FFFFFD60]
005FE820   68F0FF5F00             push    $005FFFF0
005FE825   8D955CFDFFFF           lea     edx, [ebp+$FFFFFD5C]
005FE82B   8BC6                   mov     eax, esi

* Reference to : TForm1.geb_sterb()
|
005FE82D   E89AEBFFFF             call    005FD3CC
005FE832   FFB55CFDFFFF           push    dword ptr [ebp+$FFFFFD5C]
005FE838   8D857CFDFFFF           lea     eax, [ebp+$FFFFFD7C]
005FE83E   BA08000000             mov     edx, $00000008

* Reference to: System.Proc_00404EE0
|
005FE843   E89866E0FF             call    00404EE0
005FE848   8B957CFDFFFF           mov     edx, [ebp+$FFFFFD7C]
005FE84E   8B03                   mov     eax, [ebx]
005FE850   8B80E8010000           mov     eax, [eax+$01E8]
005FE856   8B08                   mov     ecx, [eax]
005FE858   FF91B0000000           call    dword ptr [ecx+$00B0]
005FE85E   8B03                   mov     eax, [ebx]
005FE860   8B80E0000000           mov     eax, [eax+$00E0]
005FE866   8B10                   mov     edx, [eax]
005FE868   FF9248020000           call    dword ptr [edx+$0248]
005FE86E   8D9554FDFFFF           lea     edx, [ebp+$FFFFFD54]
005FE874   8B03                   mov     eax, [ebx]
005FE876   8B8058090000           mov     eax, [eax+$0958]
005FE87C   8B08                   mov     ecx, [eax]
005FE87E   FF5160                 call    dword ptr [ecx+$60]
005FE881   8B8554FDFFFF           mov     eax, [ebp+$FFFFFD54]
005FE887   8D9558FDFFFF           lea     edx, [ebp+$FFFFFD58]

* Reference to: Unit_00408494.Proc_004091D8
|
005FE88D   E846A9E0FF             call    004091D8
005FE892   8B8558FDFFFF           mov     eax, [ebp+$FFFFFD58]
005FE898   BA78016000             mov     edx, $00600178

* Reference to: System.@LStrCmp;
|
005FE89D   E8C266E0FF             call    00404F64
005FE8A2   752C                   jnz     005FE8D0
005FE8A4   8B03                   mov     eax, [ebx]
005FE8A6   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
005FE8AC   BA48016000             mov     edx, $00600148

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FE8B1   E8A642EDFF             call    004D2B5C
005FE8B6   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Mutter'
|
005FE8B9   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE8BE   E83D63E0FF             call    00404C00
005FE8C3   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Vater'
|
005FE8C6   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE8CB   E83063E0FF             call    00404C00
005FE8D0   8D954CFDFFFF           lea     edx, [ebp+$FFFFFD4C]
005FE8D6   8B03                   mov     eax, [ebx]
005FE8D8   8B8058090000           mov     eax, [eax+$0958]
005FE8DE   8B08                   mov     ecx, [eax]
005FE8E0   FF5160                 call    dword ptr [ecx+$60]
005FE8E3   8B854CFDFFFF           mov     eax, [ebp+$FFFFFD4C]
005FE8E9   8D9550FDFFFF           lea     edx, [ebp+$FFFFFD50]

* Reference to: Unit_00408494.Proc_004091D8
|
005FE8EF   E8E4A8E0FF             call    004091D8
005FE8F4   8B8550FDFFFF           mov     eax, [ebp+$FFFFFD50]
005FE8FA   BA84016000             mov     edx, $00600184

* Reference to: System.@LStrCmp;
|
005FE8FF   E86066E0FF             call    00404F64
005FE904   752C                   jnz     005FE932
005FE906   8B03                   mov     eax, [ebx]
005FE908   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
005FE90E   BA18016000             mov     edx, $00600118

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FE913   E84442EDFF             call    004D2B5C
005FE918   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Vater'
|
005FE91B   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE920   E8DB62E0FF             call    00404C00
005FE925   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Mutter'
|
005FE928   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FE92D   E8CE62E0FF             call    00404C00

* Reference to Application
|
005FE932   8B45E0                 mov     eax, [ebp-$20]
005FE935   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FE93B   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FE942   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FE948   8B03                   mov     eax, [ebx]

* Reference to field Application.OFFS_009C
|
005FE94A   8B809C000000           mov     eax, [eax+$009C]
005FE950   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FE952   E80D49EDFF             call    004D3264
005FE957   84C0                   test    al, al
005FE959   0F84B0000000           jz      005FEA0F
005FE95F   E98D000000             jmp     005FE9F1
005FE964   8B03                   mov     eax, [ebx]
005FE966   8B809C000000           mov     eax, [eax+$009C]
005FE96C   8B559C                 mov     edx, [ebp-$64]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FE96F   E8D0F4EAFF             call    004ADE44
005FE974   8B10                   mov     edx, [eax]
005FE976   FF5258                 call    dword ptr [edx+$58]
005FE979   3B45D4                 cmp     eax, [ebp-$2C]
005FE97C   7555                   jnz     005FE9D3
005FE97E   8B03                   mov     eax, [ebx]
005FE980   8B8074080000           mov     eax, [eax+$0874]
005FE986   8B10                   mov     edx, [eax]
005FE988   FF5258                 call    dword ptr [edx+$58]
005FE98B   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FE991   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FE998   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FE99E   8B03                   mov     eax, [ebx]
005FE9A0   8B803C010000           mov     eax, [eax+$013C]
005FE9A6   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FE9A8   E8B748EDFF             call    004D3264
005FE9AD   8B03                   mov     eax, [ebx]
005FE9AF   8B8044090000           mov     eax, [eax+$0944]
005FE9B5   8B10                   mov     edx, [eax]
005FE9B7   FF5258                 call    dword ptr [edx+$58]
005FE9BA   8D9548FDFFFF           lea     edx, [ebp+$FFFFFD48]

* Reference to : TForm1.Proc_005D3228()
|
005FE9C0   E86348FDFF             call    005D3228
005FE9C5   8B9548FDFFFF           mov     edx, [ebp+$FFFFFD48]
005FE9CB   8D45CC                 lea     eax, [ebp-$34]

* Reference to: System.@LStrCat;
|
005FE9CE   E85564E0FF             call    00404E28
005FE9D3   8B03                   mov     eax, [ebx]
005FE9D5   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005FE9DB   E80C0BEBFF             call    004AF4EC
005FE9E0   8B03                   mov     eax, [ebx]
005FE9E2   8B809C000000           mov     eax, [eax+$009C]
005FE9E8   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005FE9EF   751E                   jnz     005FEA0F
005FE9F1   8B03                   mov     eax, [ebx]
005FE9F3   8B809C000000           mov     eax, [eax+$009C]
005FE9F9   8B55A0                 mov     edx, [ebp-$60]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FE9FC   E843F4EAFF             call    004ADE44
005FEA01   8B10                   mov     edx, [eax]
005FEA03   FF5258                 call    dword ptr [edx+$58]
005FEA06   3B45E0                 cmp     eax, [ebp-$20]
005FEA09   0F8455FFFFFF           jz      005FE964
005FEA0F   837DCC00               cmp     dword ptr [ebp-$34], +$00
005FEA13   0F863C120000           jbe     005FFC55
005FEA19   8B45CC                 mov     eax, [ebp-$34]

* Reference to: System.@LStrLen(String):Integer;
|
005FEA1C   E8FF63E0FF             call    00404E20
005FEA21   B906000000             mov     ecx, $00000006
005FEA26   99                     cdq
005FEA27   F7F9                   idiv    ecx 
005FEA29   85C0                   test    eax, eax
005FEA2B   0F8E24120000           jle     005FFC55
005FEA31   898568FFFFFF           mov     [ebp+$FFFFFF68], eax
005FEA37   C745F401000000         mov     dword ptr [ebp-$0C], $00000001
005FEA3E   8D8544FDFFFF           lea     eax, [ebp+$FFFFFD44]
005FEA44   50                     push    eax
005FEA45   8B45F4                 mov     eax, [ebp-$0C]
005FEA48   48                     dec     eax
005FEA49   8BD0                   mov     edx, eax
005FEA4B   03D2                   add     edx, edx
005FEA4D   8D1452                 lea     edx, [edx+edx*2]
005FEA50   42                     inc     edx
005FEA51   B906000000             mov     ecx, $00000006
005FEA56   8B45CC                 mov     eax, [ebp-$34]

* Reference to: System.@LStrCopy;
|
005FEA59   E81A66E0FF             call    00405078
005FEA5E   8B8544FDFFFF           mov     eax, [ebp+$FFFFFD44]

* Reference to: Unit_00408494.Proc_004099B4
|
005FEA64   E84BAFE0FF             call    004099B4
005FEA69   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FEA6F   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FEA76   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FEA7C   8B03                   mov     eax, [ebx]
005FEA7E   8B803C010000           mov     eax, [eax+$013C]
005FEA84   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FEA86   E8D947EDFF             call    004D3264
005FEA8B   8B03                   mov     eax, [ebx]
005FEA8D   8B8044090000           mov     eax, [eax+$0944]
005FEA93   8B10                   mov     edx, [eax]
005FEA95   FF5258                 call    dword ptr [edx+$58]
005FEA98   8945DC                 mov     [ebp-$24], eax
005FEA9B   8B03                   mov     eax, [ebx]
005FEA9D   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005FEAA3   E87C0CEBFF             call    004AF724
005FEAA8   FF75BC                 push    dword ptr [ebp-$44]
005FEAAB   8D9538FDFFFF           lea     edx, [ebp+$FFFFFD38]
005FEAB1   8B03                   mov     eax, [ebx]
005FEAB3   8B8050090000           mov     eax, [eax+$0950]
005FEAB9   8B08                   mov     ecx, [eax]
005FEABB   FF5160                 call    dword ptr [ecx+$60]
005FEABE   8B9538FDFFFF           mov     edx, [ebp+$FFFFFD38]
005FEAC4   8D8D3CFDFFFF           lea     ecx, [ebp+$FFFFFD3C]
005FEACA   8BC6                   mov     eax, esi

* Reference to : TForm1.ucase()
|
005FEACC   E8B790FDFF             call    005D7B88
005FEAD1   FFB53CFDFFFF           push    dword ptr [ebp+$FFFFFD3C]
005FEAD7   68F0FF5F00             push    $005FFFF0
005FEADC   8D9534FDFFFF           lea     edx, [ebp+$FFFFFD34]
005FEAE2   8B03                   mov     eax, [ebx]
005FEAE4   8B8054090000           mov     eax, [eax+$0954]
005FEAEA   8B08                   mov     ecx, [eax]
005FEAEC   FF5160                 call    dword ptr [ecx+$60]
005FEAEF   FFB534FDFFFF           push    dword ptr [ebp+$FFFFFD34]
005FEAF5   68F0FF5F00             push    $005FFFF0
005FEAFA   8D9530FDFFFF           lea     edx, [ebp+$FFFFFD30]
005FEB00   8BC6                   mov     eax, esi

* Reference to : TForm1.geb_sterb()
|
005FEB02   E8C5E8FFFF             call    005FD3CC
005FEB07   FFB530FDFFFF           push    dword ptr [ebp+$FFFFFD30]
005FEB0D   8D8540FDFFFF           lea     eax, [ebp+$FFFFFD40]
005FEB13   BA06000000             mov     edx, $00000006

* Reference to: System.Proc_00404EE0
|
005FEB18   E8C363E0FF             call    00404EE0
005FEB1D   8B9540FDFFFF           mov     edx, [ebp+$FFFFFD40]
005FEB23   8B03                   mov     eax, [ebx]
005FEB25   8B80E8010000           mov     eax, [eax+$01E8]
005FEB2B   8B08                   mov     ecx, [eax]
005FEB2D   FF91B0000000           call    dword ptr [ecx+$00B0]
005FEB33   8B03                   mov     eax, [ebx]
005FEB35   8B80E0000000           mov     eax, [eax+$00E0]
005FEB3B   8B10                   mov     edx, [eax]
005FEB3D   FF9248020000           call    dword ptr [edx+$0248]
005FEB43   8D9528FDFFFF           lea     edx, [ebp+$FFFFFD28]
005FEB49   8B03                   mov     eax, [ebx]
005FEB4B   8B8058090000           mov     eax, [eax+$0958]
005FEB51   8B08                   mov     ecx, [eax]
005FEB53   FF5160                 call    dword ptr [ecx+$60]
005FEB56   8B8528FDFFFF           mov     eax, [ebp+$FFFFFD28]
005FEB5C   8D952CFDFFFF           lea     edx, [ebp+$FFFFFD2C]

* Reference to: Unit_00408494.Proc_004091D8
|
005FEB62   E871A6E0FF             call    004091D8
005FEB67   8B852CFDFFFF           mov     eax, [ebp+$FFFFFD2C]
005FEB6D   BA78016000             mov     edx, $00600178

* Reference to: System.@LStrCmp;
|
005FEB72   E8ED63E0FF             call    00404F64
005FEB77   752E                   jnz     005FEBA7
005FEB79   8B03                   mov     eax, [ebx]
005FEB7B   8B803C010000           mov     eax, [eax+$013C]

* Possible String Reference to: 'vat'
|
005FEB81   BA18016000             mov     edx, $00600118

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FEB86   E8D13FEDFF             call    004D2B5C
005FEB8B   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Vater'
|
005FEB8E   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FEB93   E86860E0FF             call    00404C00
005FEB98   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Mutter'
|
005FEB9B   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FEBA0   E85B60E0FF             call    00404C00
005FEBA5   EB62                   jmp     005FEC09
005FEBA7   8D9520FDFFFF           lea     edx, [ebp+$FFFFFD20]
005FEBAD   8B03                   mov     eax, [ebx]
005FEBAF   8B8058090000           mov     eax, [eax+$0958]
005FEBB5   8B08                   mov     ecx, [eax]
005FEBB7   FF5160                 call    dword ptr [ecx+$60]
005FEBBA   8B8520FDFFFF           mov     eax, [ebp+$FFFFFD20]
005FEBC0   8D9524FDFFFF           lea     edx, [ebp+$FFFFFD24]

* Reference to: Unit_00408494.Proc_004091D8
|
005FEBC6   E80DA6E0FF             call    004091D8
005FEBCB   8B8524FDFFFF           mov     eax, [ebp+$FFFFFD24]
005FEBD1   BA84016000             mov     edx, $00600184

* Reference to: System.@LStrCmp;
|
005FEBD6   E88963E0FF             call    00404F64
005FEBDB   752C                   jnz     005FEC09
005FEBDD   8B03                   mov     eax, [ebx]
005FEBDF   8B803C010000           mov     eax, [eax+$013C]

* Possible String Reference to: 'mut'
|
005FEBE5   BA48016000             mov     edx, $00600148

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FEBEA   E86D3FEDFF             call    004D2B5C
005FEBEF   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Mutter'
|
005FEBF2   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FEBF7   E80460E0FF             call    00404C00
005FEBFC   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Vater'
|
005FEBFF   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FEC04   E8F75FE0FF             call    00404C00
005FEC09   8D851CFDFFFF           lea     eax, [ebp+$FFFFFD1C]
005FEC0F   50                     push    eax
005FEC10   8B45F4                 mov     eax, [ebp-$0C]
005FEC13   48                     dec     eax
005FEC14   8BD0                   mov     edx, eax
005FEC16   03D2                   add     edx, edx
005FEC18   8D1452                 lea     edx, [edx+edx*2]
005FEC1B   42                     inc     edx
005FEC1C   B906000000             mov     ecx, $00000006
005FEC21   8B45CC                 mov     eax, [ebp-$34]

* Reference to: System.@LStrCopy;
|
005FEC24   E84F64E0FF             call    00405078
005FEC29   8B851CFDFFFF           mov     eax, [ebp+$FFFFFD1C]

* Reference to: Unit_00408494.Proc_004099B4
|
005FEC2F   E880ADE0FF             call    004099B4
005FEC34   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FEC3A   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FEC41   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FEC47   8B03                   mov     eax, [ebx]
005FEC49   8B803C010000           mov     eax, [eax+$013C]
005FEC4F   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FEC51   E80E46EDFF             call    004D3264
005FEC56   84C0                   test    al, al
005FEC58   0F8458010000           jz      005FEDB6
005FEC5E   E909010000             jmp     005FED6C
005FEC63   8B03                   mov     eax, [ebx]
005FEC65   8B803C010000           mov     eax, [eax+$013C]
005FEC6B   8B559C                 mov     edx, [ebp-$64]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FEC6E   E8D1F1EAFF             call    004ADE44
005FEC73   8B10                   mov     edx, [eax]
005FEC75   FF5258                 call    dword ptr [edx+$58]
005FEC78   85C0                   test    eax, eax
005FEC7A   0F85CE000000           jnz     005FED4E
005FEC80   8B03                   mov     eax, [ebx]
005FEC82   8B8044090000           mov     eax, [eax+$0944]
005FEC88   8B10                   mov     edx, [eax]
005FEC8A   FF5258                 call    dword ptr [edx+$58]
005FEC8D   8D9518FDFFFF           lea     edx, [ebp+$FFFFFD18]

* Reference to : TForm1.Proc_005D3228()
|
005FEC93   E89045FDFF             call    005D3228
005FEC98   8B9518FDFFFF           mov     edx, [ebp+$FFFFFD18]
005FEC9E   8D45C8                 lea     eax, [ebp-$38]

* Reference to: System.@LStrCat;
|
005FECA1   E88261E0FF             call    00404E28
005FECA6   8B03                   mov     eax, [ebx]
005FECA8   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005FECAE   E8710AEBFF             call    004AF724
005FECB3   FF75B8                 push    dword ptr [ebp-$48]
005FECB6   8D950CFDFFFF           lea     edx, [ebp+$FFFFFD0C]
005FECBC   8B03                   mov     eax, [ebx]
005FECBE   8B8050090000           mov     eax, [eax+$0950]
005FECC4   8B08                   mov     ecx, [eax]
005FECC6   FF5160                 call    dword ptr [ecx+$60]
005FECC9   8B950CFDFFFF           mov     edx, [ebp+$FFFFFD0C]
005FECCF   8D8D10FDFFFF           lea     ecx, [ebp+$FFFFFD10]
005FECD5   8BC6                   mov     eax, esi

* Reference to : TForm1.ucase()
|
005FECD7   E8AC8EFDFF             call    005D7B88
005FECDC   FFB510FDFFFF           push    dword ptr [ebp+$FFFFFD10]
005FECE2   68F0FF5F00             push    $005FFFF0
005FECE7   8D9508FDFFFF           lea     edx, [ebp+$FFFFFD08]
005FECED   8B03                   mov     eax, [ebx]
005FECEF   8B8054090000           mov     eax, [eax+$0954]
005FECF5   8B08                   mov     ecx, [eax]
005FECF7   FF5160                 call    dword ptr [ecx+$60]
005FECFA   FFB508FDFFFF           push    dword ptr [ebp+$FFFFFD08]
005FED00   68F0FF5F00             push    $005FFFF0
005FED05   8D9504FDFFFF           lea     edx, [ebp+$FFFFFD04]
005FED0B   8BC6                   mov     eax, esi

* Reference to : TForm1.geb_sterb()
|
005FED0D   E8BAE6FFFF             call    005FD3CC
005FED12   FFB504FDFFFF           push    dword ptr [ebp+$FFFFFD04]
005FED18   8D8514FDFFFF           lea     eax, [ebp+$FFFFFD14]
005FED1E   BA06000000             mov     edx, $00000006

* Reference to: System.Proc_00404EE0
|
005FED23   E8B861E0FF             call    00404EE0
005FED28   8B9514FDFFFF           mov     edx, [ebp+$FFFFFD14]
005FED2E   8B03                   mov     eax, [ebx]
005FED30   8B80E8010000           mov     eax, [eax+$01E8]
005FED36   8B08                   mov     ecx, [eax]
005FED38   FF91B0000000           call    dword ptr [ecx+$00B0]
005FED3E   8B03                   mov     eax, [ebx]
005FED40   8B80E0000000           mov     eax, [eax+$00E0]
005FED46   8B10                   mov     edx, [eax]
005FED48   FF9248020000           call    dword ptr [edx+$0248]
005FED4E   8B03                   mov     eax, [ebx]
005FED50   8B803C010000           mov     eax, [eax+$013C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005FED56   E89107EBFF             call    004AF4EC
005FED5B   8B03                   mov     eax, [ebx]
005FED5D   8B803C010000           mov     eax, [eax+$013C]
005FED63   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005FED6A   754A                   jnz     005FEDB6
005FED6C   8B03                   mov     eax, [ebx]
005FED6E   8B803C010000           mov     eax, [eax+$013C]
005FED74   8B55A0                 mov     edx, [ebp-$60]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FED77   E8C8F0EAFF             call    004ADE44
005FED7C   8B10                   mov     edx, [eax]
005FED7E   FF5258                 call    dword ptr [edx+$58]
005FED81   8BF8                   mov     edi, eax
005FED83   8D8500FDFFFF           lea     eax, [ebp+$FFFFFD00]
005FED89   50                     push    eax
005FED8A   8B45F4                 mov     eax, [ebp-$0C]
005FED8D   48                     dec     eax
005FED8E   8BD0                   mov     edx, eax
005FED90   03D2                   add     edx, edx
005FED92   8D1452                 lea     edx, [edx+edx*2]
005FED95   42                     inc     edx
005FED96   B906000000             mov     ecx, $00000006
005FED9B   8B45CC                 mov     eax, [ebp-$34]

* Reference to: System.@LStrCopy;
|
005FED9E   E8D562E0FF             call    00405078
005FEDA3   8B8500FDFFFF           mov     eax, [ebp+$FFFFFD00]

* Reference to: Unit_00408494.Proc_004099B4
|
005FEDA9   E806ACE0FF             call    004099B4
005FEDAE   3BF8                   cmp     edi, eax
005FEDB0   0F84ADFEFFFF           jz      005FEC63
005FEDB6   8B03                   mov     eax, [ebx]
005FEDB8   8B803C010000           mov     eax, [eax+$013C]
005FEDBE   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FEDC0   E8973DEDFF             call    004D2B5C
005FEDC5   8D85FCFCFFFF           lea     eax, [ebp+$FFFFFCFC]
005FEDCB   50                     push    eax
005FEDCC   8B45F4                 mov     eax, [ebp-$0C]
005FEDCF   48                     dec     eax
005FEDD0   8BF8                   mov     edi, eax
005FEDD2   03FF                   add     edi, edi
005FEDD4   8D3C7F                 lea     edi, [edi+edi*2]
005FEDD7   47                     inc     edi
005FEDD8   8BD7                   mov     edx, edi
005FEDDA   B906000000             mov     ecx, $00000006
005FEDDF   8B45CC                 mov     eax, [ebp-$34]

* Reference to: System.@LStrCopy;
|
005FEDE2   E89162E0FF             call    00405078
005FEDE7   8B85FCFCFFFF           mov     eax, [ebp+$FFFFFCFC]

* Reference to: Unit_00408494.Proc_004099B4
|
005FEDED   E8C2ABE0FF             call    004099B4
005FEDF2   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FEDF8   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FEDFF   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FEE05   8B03                   mov     eax, [ebx]
005FEE07   8B803C010000           mov     eax, [eax+$013C]
005FEE0D   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FEE0F   E85044EDFF             call    004D3264
005FEE14   8D95F4FCFFFF           lea     edx, [ebp+$FFFFFCF4]
005FEE1A   8B03                   mov     eax, [ebx]
005FEE1C   8B8058090000           mov     eax, [eax+$0958]
005FEE22   8B08                   mov     ecx, [eax]
005FEE24   FF5160                 call    dword ptr [ecx+$60]
005FEE27   8B85F4FCFFFF           mov     eax, [ebp+$FFFFFCF4]
005FEE2D   8D95F8FCFFFF           lea     edx, [ebp+$FFFFFCF8]

* Reference to: Unit_00408494.Proc_004091D8
|
005FEE33   E8A0A3E0FF             call    004091D8
005FEE38   8B85F8FCFFFF           mov     eax, [ebp+$FFFFFCF8]
005FEE3E   BA78016000             mov     edx, $00600178

* Reference to: System.@LStrCmp;
|
005FEE43   E81C61E0FF             call    00404F64
005FEE48   752C                   jnz     005FEE76
005FEE4A   8B03                   mov     eax, [ebx]
005FEE4C   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
005FEE52   BA48016000             mov     edx, $00600148

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FEE57   E8003DEDFF             call    004D2B5C
005FEE5C   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Mutter'
|
005FEE5F   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FEE64   E8975DE0FF             call    00404C00
005FEE69   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Vater'
|
005FEE6C   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FEE71   E88A5DE0FF             call    00404C00
005FEE76   8D95ECFCFFFF           lea     edx, [ebp+$FFFFFCEC]
005FEE7C   8B03                   mov     eax, [ebx]
005FEE7E   8B8058090000           mov     eax, [eax+$0958]
005FEE84   8B08                   mov     ecx, [eax]
005FEE86   FF5160                 call    dword ptr [ecx+$60]
005FEE89   8B85ECFCFFFF           mov     eax, [ebp+$FFFFFCEC]
005FEE8F   8D95F0FCFFFF           lea     edx, [ebp+$FFFFFCF0]

* Reference to: Unit_00408494.Proc_004091D8
|
005FEE95   E83EA3E0FF             call    004091D8
005FEE9A   8B85F0FCFFFF           mov     eax, [ebp+$FFFFFCF0]
005FEEA0   BA84016000             mov     edx, $00600184

* Reference to: System.@LStrCmp;
|
005FEEA5   E8BA60E0FF             call    00404F64
005FEEAA   752C                   jnz     005FEED8
005FEEAC   8B03                   mov     eax, [ebx]
005FEEAE   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
005FEEB4   BA18016000             mov     edx, $00600118

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FEEB9   E89E3CEDFF             call    004D2B5C
005FEEBE   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Vater'
|
005FEEC1   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FEEC6   E8355DE0FF             call    00404C00
005FEECB   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Mutter'
|
005FEECE   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FEED3   E8285DE0FF             call    00404C00
005FEED8   8D4590                 lea     eax, [ebp-$70]

* Reference to: System.@LStrClr(void;void);
|
005FEEDB   E8885CE0FF             call    00404B68
005FEEE0   8D85E8FCFFFF           lea     eax, [ebp+$FFFFFCE8]
005FEEE6   50                     push    eax
005FEEE7   8BD7                   mov     edx, edi
005FEEE9   B906000000             mov     ecx, $00000006
005FEEEE   8B45CC                 mov     eax, [ebp-$34]

* Reference to: System.@LStrCopy;
|
005FEEF1   E88261E0FF             call    00405078
005FEEF6   8B85E8FCFFFF           mov     eax, [ebp+$FFFFFCE8]

* Reference to: Unit_00408494.Proc_004099B4
|
005FEEFC   E8B3AAE0FF             call    004099B4
005FEF01   8BD0                   mov     edx, eax
005FEF03   8D4D90                 lea     ecx, [ebp-$70]
005FEF06   8BC6                   mov     eax, esi

* Reference to : TForm1.ehtest()
|
005FEF08   E883E9FFFF             call    005FD890
005FEF0D   837D9000               cmp     dword ptr [ebp-$70], +$00
005FEF11   0F862F0D0000           jbe     005FFC46
005FEF17   8B4590                 mov     eax, [ebp-$70]

* Reference to: System.@LStrLen(String):Integer;
|
005FEF1A   E8015FE0FF             call    00404E20
005FEF1F   85C0                   test    eax, eax
005FEF21   7903                   jns     005FEF26
005FEF23   83C00F                 add     eax, +$0F
005FEF26   C1F804                 sar     eax, $04
005FEF29   85C0                   test    eax, eax
005FEF2B   0F8E150D0000           jle     005FFC46
005FEF31   898564FFFFFF           mov     [ebp+$FFFFFF64], eax
005FEF37   C745F001000000         mov     dword ptr [ebp-$10], $00000001
005FEF3E   8D45C8                 lea     eax, [ebp-$38]

* Reference to: System.@LStrClr(void;void);
|
005FEF41   E8225CE0FF             call    00404B68
005FEF46   8D45C4                 lea     eax, [ebp-$3C]

* Reference to: System.@LStrClr(void;void);
|
005FEF49   E81A5CE0FF             call    00404B68
005FEF4E   8D85E4FCFFFF           lea     eax, [ebp+$FFFFFCE4]
005FEF54   50                     push    eax
005FEF55   8B45F0                 mov     eax, [ebp-$10]
005FEF58   48                     dec     eax
005FEF59   8BF8                   mov     edi, eax
005FEF5B   C1E704                 shl     edi, $04
005FEF5E   03F8                   add     edi, eax
005FEF60   8BD7                   mov     edx, edi
005FEF62   42                     inc     edx
005FEF63   B906000000             mov     ecx, $00000006
005FEF68   8B4590                 mov     eax, [ebp-$70]

* Reference to: System.@LStrCopy;
|
005FEF6B   E80861E0FF             call    00405078
005FEF70   8B85E4FCFFFF           mov     eax, [ebp+$FFFFFCE4]

* Reference to: Unit_00408494.Proc_004099B4
|
005FEF76   E839AAE0FF             call    004099B4
005FEF7B   8945D4                 mov     [ebp-$2C], eax
005FEF7E   8B45D4                 mov     eax, [ebp-$2C]
005FEF81   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FEF87   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FEF8E   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FEF94   8B03                   mov     eax, [ebx]
005FEF96   8B803C010000           mov     eax, [eax+$013C]
005FEF9C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FEF9E   E8C142EDFF             call    004D3264
005FEFA3   8D85E0FCFFFF           lea     eax, [ebp+$FFFFFCE0]
005FEFA9   50                     push    eax
005FEFAA   8BD7                   mov     edx, edi
005FEFAC   83C211                 add     edx, +$11
005FEFAF   B901000000             mov     ecx, $00000001
005FEFB4   8B4590                 mov     eax, [ebp-$70]

* Reference to: System.@LStrCopy;
|
005FEFB7   E8BC60E0FF             call    00405078
005FEFBC   8B85E0FCFFFF           mov     eax, [ebp+$FFFFFCE0]
005FEFC2   BA58016000             mov     edx, $00600158

* Reference to: System.@LStrCmp;
|
005FEFC7   E8985FE0FF             call    00404F64
005FEFCC   7514                   jnz     005FEFE2
005FEFCE   56                     push    esi
005FEFCF   57                     push    edi
005FEFD0   BE5C016000             mov     esi, $0060015C
005FEFD5   8DBD72FFFFFF           lea     edi, [ebp+$FFFFFF72]
005FEFDB   66A5                   movsw
005FEFDD   A4                     movsb
005FEFDE   5F                     pop     edi
005FEFDF   5E                     pop     esi
005FEFE0   EB0A                   jmp     005FEFEC
005FEFE2   C78572FFFFFF036F2D6F   mov     dword ptr [ebp+$FFFFFF72], $6F2D6F03
005FEFEC   8B03                   mov     eax, [ebx]
005FEFEE   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005FEFF4   E82B07EBFF             call    004AF724
005FEFF9   FF75AC                 push    dword ptr [ebp-$54]
005FEFFC   8D85D8FCFFFF           lea     eax, [ebp+$FFFFFCD8]
005FF002   8D9572FFFFFF           lea     edx, [ebp+$FFFFFF72]

* Reference to: System.@LStrFromString(String;String;ShortString;ShortString);
|
005FF008   E8B75DE0FF             call    00404DC4
005FF00D   FFB5D8FCFFFF           push    dword ptr [ebp+$FFFFFCD8]
005FF013   68F0FF5F00             push    $005FFFF0
005FF018   8D85D4FCFFFF           lea     eax, [ebp+$FFFFFCD4]
005FF01E   50                     push    eax
005FF01F   8BD7                   mov     edx, edi
005FF021   83C207                 add     edx, +$07
005FF024   B90A000000             mov     ecx, $0000000A
005FF029   8B4590                 mov     eax, [ebp-$70]

* Reference to: System.@LStrCopy;
|
005FF02C   E84760E0FF             call    00405078
005FF031   FFB5D4FCFFFF           push    dword ptr [ebp+$FFFFFCD4]

* Possible String Reference to: ' : '
|
005FF037   686C016000             push    $0060016C
005FF03C   8D95CCFCFFFF           lea     edx, [ebp+$FFFFFCCC]
005FF042   8B03                   mov     eax, [ebx]
005FF044   8B8050090000           mov     eax, [eax+$0950]
005FF04A   8B08                   mov     ecx, [eax]
005FF04C   FF5160                 call    dword ptr [ecx+$60]
005FF04F   8B95CCFCFFFF           mov     edx, [ebp+$FFFFFCCC]
005FF055   8D8DD0FCFFFF           lea     ecx, [ebp+$FFFFFCD0]
005FF05B   8BC6                   mov     eax, esi

* Reference to : TForm1.ucase()
|
005FF05D   E8268BFDFF             call    005D7B88
005FF062   FFB5D0FCFFFF           push    dword ptr [ebp+$FFFFFCD0]
005FF068   68F0FF5F00             push    $005FFFF0
005FF06D   8D95C8FCFFFF           lea     edx, [ebp+$FFFFFCC8]
005FF073   8B03                   mov     eax, [ebx]
005FF075   8B8054090000           mov     eax, [eax+$0954]
005FF07B   8B08                   mov     ecx, [eax]
005FF07D   FF5160                 call    dword ptr [ecx+$60]
005FF080   FFB5C8FCFFFF           push    dword ptr [ebp+$FFFFFCC8]
005FF086   68F0FF5F00             push    $005FFFF0
005FF08B   8D95C4FCFFFF           lea     edx, [ebp+$FFFFFCC4]
005FF091   8BC6                   mov     eax, esi

* Reference to : TForm1.geb_sterb()
|
005FF093   E834E3FFFF             call    005FD3CC
005FF098   FFB5C4FCFFFF           push    dword ptr [ebp+$FFFFFCC4]
005FF09E   8D85DCFCFFFF           lea     eax, [ebp+$FFFFFCDC]
005FF0A4   BA0A000000             mov     edx, $0000000A

* Reference to: System.Proc_00404EE0
|
005FF0A9   E8325EE0FF             call    00404EE0
005FF0AE   8B95DCFCFFFF           mov     edx, [ebp+$FFFFFCDC]
005FF0B4   8B03                   mov     eax, [ebx]
005FF0B6   8B80E8010000           mov     eax, [eax+$01E8]
005FF0BC   8B08                   mov     ecx, [eax]
005FF0BE   FF91B0000000           call    dword ptr [ecx+$00B0]
005FF0C4   8B03                   mov     eax, [ebx]
005FF0C6   8B80E0000000           mov     eax, [eax+$00E0]
005FF0CC   8B10                   mov     edx, [eax]
005FF0CE   FF9248020000           call    dword ptr [edx+$0248]
005FF0D4   8D95BCFCFFFF           lea     edx, [ebp+$FFFFFCBC]
005FF0DA   8B03                   mov     eax, [ebx]
005FF0DC   8B8058090000           mov     eax, [eax+$0958]
005FF0E2   8B08                   mov     ecx, [eax]
005FF0E4   FF5160                 call    dword ptr [ecx+$60]
005FF0E7   8B85BCFCFFFF           mov     eax, [ebp+$FFFFFCBC]
005FF0ED   8D95C0FCFFFF           lea     edx, [ebp+$FFFFFCC0]

* Reference to: Unit_00408494.Proc_004091D8
|
005FF0F3   E8E0A0E0FF             call    004091D8
005FF0F8   8B85C0FCFFFF           mov     eax, [ebp+$FFFFFCC0]
005FF0FE   BA78016000             mov     edx, $00600178

* Reference to: System.@LStrCmp;
|
005FF103   E85C5EE0FF             call    00404F64
005FF108   752C                   jnz     005FF136
005FF10A   8B03                   mov     eax, [ebx]
005FF10C   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
005FF112   BA48016000             mov     edx, $00600148

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FF117   E8403AEDFF             call    004D2B5C
005FF11C   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Mutter'
|
005FF11F   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF124   E8D75AE0FF             call    00404C00
005FF129   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Vater'
|
005FF12C   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF131   E8CA5AE0FF             call    00404C00
005FF136   8D95B4FCFFFF           lea     edx, [ebp+$FFFFFCB4]
005FF13C   8B03                   mov     eax, [ebx]
005FF13E   8B8058090000           mov     eax, [eax+$0958]
005FF144   8B08                   mov     ecx, [eax]
005FF146   FF5160                 call    dword ptr [ecx+$60]
005FF149   8B85B4FCFFFF           mov     eax, [ebp+$FFFFFCB4]
005FF14F   8D95B8FCFFFF           lea     edx, [ebp+$FFFFFCB8]

* Reference to: Unit_00408494.Proc_004091D8
|
005FF155   E87EA0E0FF             call    004091D8
005FF15A   8B85B8FCFFFF           mov     eax, [ebp+$FFFFFCB8]
005FF160   BA84016000             mov     edx, $00600184

* Reference to: System.@LStrCmp;
|
005FF165   E8FA5DE0FF             call    00404F64
005FF16A   752C                   jnz     005FF198
005FF16C   8B03                   mov     eax, [ebx]
005FF16E   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
005FF174   BA18016000             mov     edx, $00600118

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FF179   E8DE39EDFF             call    004D2B5C
005FF17E   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Vater'
|
005FF181   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF186   E8755AE0FF             call    00404C00
005FF18B   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Mutter'
|
005FF18E   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF193   E8685AE0FF             call    00404C00
005FF198   8B45DC                 mov     eax, [ebp-$24]
005FF19B   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FF1A1   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FF1A8   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FF1AE   8B03                   mov     eax, [ebx]
005FF1B0   8B809C000000           mov     eax, [eax+$009C]
005FF1B6   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FF1B8   E8A740EDFF             call    004D3264
005FF1BD   84C0                   test    al, al
005FF1BF   0F84B0000000           jz      005FF275
005FF1C5   E98D000000             jmp     005FF257
005FF1CA   8B03                   mov     eax, [ebx]
005FF1CC   8B809C000000           mov     eax, [eax+$009C]
005FF1D2   8B559C                 mov     edx, [ebp-$64]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FF1D5   E86AECEAFF             call    004ADE44
005FF1DA   8B10                   mov     edx, [eax]
005FF1DC   FF5258                 call    dword ptr [edx+$58]
005FF1DF   3B45D4                 cmp     eax, [ebp-$2C]
005FF1E2   7555                   jnz     005FF239
005FF1E4   8B03                   mov     eax, [ebx]
005FF1E6   8B8074080000           mov     eax, [eax+$0874]
005FF1EC   8B10                   mov     edx, [eax]
005FF1EE   FF5258                 call    dword ptr [edx+$58]
005FF1F1   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FF1F7   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FF1FE   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FF204   8B03                   mov     eax, [ebx]
005FF206   8B803C010000           mov     eax, [eax+$013C]
005FF20C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FF20E   E85140EDFF             call    004D3264
005FF213   8B03                   mov     eax, [ebx]
005FF215   8B8044090000           mov     eax, [eax+$0944]
005FF21B   8B10                   mov     edx, [eax]
005FF21D   FF5258                 call    dword ptr [edx+$58]
005FF220   8D95B0FCFFFF           lea     edx, [ebp+$FFFFFCB0]

* Reference to : TForm1.Proc_005D3228()
|
005FF226   E8FD3FFDFF             call    005D3228
005FF22B   8B95B0FCFFFF           mov     edx, [ebp+$FFFFFCB0]
005FF231   8D45C8                 lea     eax, [ebp-$38]

* Reference to: System.@LStrCat;
|
005FF234   E8EF5BE0FF             call    00404E28
005FF239   8B03                   mov     eax, [ebx]
005FF23B   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005FF241   E8A602EBFF             call    004AF4EC
005FF246   8B03                   mov     eax, [ebx]
005FF248   8B809C000000           mov     eax, [eax+$009C]
005FF24E   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005FF255   751E                   jnz     005FF275
005FF257   8B03                   mov     eax, [ebx]
005FF259   8B809C000000           mov     eax, [eax+$009C]
005FF25F   8B55A0                 mov     edx, [ebp-$60]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FF262   E8DDEBEAFF             call    004ADE44
005FF267   8B10                   mov     edx, [eax]
005FF269   FF5258                 call    dword ptr [edx+$58]
005FF26C   3B45DC                 cmp     eax, [ebp-$24]
005FF26F   0F8455FFFFFF           jz      005FF1CA
005FF275   837DC800               cmp     dword ptr [ebp-$38], +$00
005FF279   0F86B8090000           jbe     005FFC37
005FF27F   8B45C8                 mov     eax, [ebp-$38]

* Reference to: System.@LStrLen(String):Integer;
|
005FF282   E8995BE0FF             call    00404E20
005FF287   B906000000             mov     ecx, $00000006
005FF28C   99                     cdq
005FF28D   F7F9                   idiv    ecx 
005FF28F   85C0                   test    eax, eax
005FF291   0F8EA0090000           jle     005FFC37
005FF297   898560FFFFFF           mov     [ebp+$FFFFFF60], eax
005FF29D   C745EC01000000         mov     dword ptr [ebp-$14], $00000001
005FF2A4   8D85ACFCFFFF           lea     eax, [ebp+$FFFFFCAC]
005FF2AA   50                     push    eax
005FF2AB   8B45EC                 mov     eax, [ebp-$14]
005FF2AE   48                     dec     eax
005FF2AF   8BD0                   mov     edx, eax
005FF2B1   03D2                   add     edx, edx
005FF2B3   8D1452                 lea     edx, [edx+edx*2]
005FF2B6   42                     inc     edx
005FF2B7   B906000000             mov     ecx, $00000006
005FF2BC   8B45C8                 mov     eax, [ebp-$38]

* Reference to: System.@LStrCopy;
|
005FF2BF   E8B45DE0FF             call    00405078
005FF2C4   8B85ACFCFFFF           mov     eax, [ebp+$FFFFFCAC]

* Reference to: Unit_00408494.Proc_004099B4
|
005FF2CA   E8E5A6E0FF             call    004099B4
005FF2CF   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FF2D5   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FF2DC   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FF2E2   8B03                   mov     eax, [ebx]
005FF2E4   8B803C010000           mov     eax, [eax+$013C]
005FF2EA   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FF2EC   E8733FEDFF             call    004D3264
005FF2F1   8B03                   mov     eax, [ebx]
005FF2F3   8B8044090000           mov     eax, [eax+$0944]
005FF2F9   8B10                   mov     edx, [eax]
005FF2FB   FF5258                 call    dword ptr [edx+$58]
005FF2FE   8945D8                 mov     [ebp-$28], eax
005FF301   8B03                   mov     eax, [ebx]
005FF303   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005FF309   E81604EBFF             call    004AF724
005FF30E   FF75B8                 push    dword ptr [ebp-$48]
005FF311   8D95A0FCFFFF           lea     edx, [ebp+$FFFFFCA0]
005FF317   8B03                   mov     eax, [ebx]
005FF319   8B8050090000           mov     eax, [eax+$0950]
005FF31F   8B08                   mov     ecx, [eax]
005FF321   FF5160                 call    dword ptr [ecx+$60]
005FF324   8B95A0FCFFFF           mov     edx, [ebp+$FFFFFCA0]
005FF32A   8D8DA4FCFFFF           lea     ecx, [ebp+$FFFFFCA4]
005FF330   8BC6                   mov     eax, esi

* Reference to : TForm1.ucase()
|
005FF332   E85188FDFF             call    005D7B88
005FF337   FFB5A4FCFFFF           push    dword ptr [ebp+$FFFFFCA4]
005FF33D   68F0FF5F00             push    $005FFFF0
005FF342   8D959CFCFFFF           lea     edx, [ebp+$FFFFFC9C]
005FF348   8B03                   mov     eax, [ebx]
005FF34A   8B8054090000           mov     eax, [eax+$0954]
005FF350   8B08                   mov     ecx, [eax]
005FF352   FF5160                 call    dword ptr [ecx+$60]
005FF355   FFB59CFCFFFF           push    dword ptr [ebp+$FFFFFC9C]
005FF35B   68F0FF5F00             push    $005FFFF0
005FF360   8D9598FCFFFF           lea     edx, [ebp+$FFFFFC98]
005FF366   8BC6                   mov     eax, esi

* Reference to : TForm1.geb_sterb()
|
005FF368   E85FE0FFFF             call    005FD3CC
005FF36D   FFB598FCFFFF           push    dword ptr [ebp+$FFFFFC98]
005FF373   8D85A8FCFFFF           lea     eax, [ebp+$FFFFFCA8]
005FF379   BA06000000             mov     edx, $00000006

* Reference to: System.Proc_00404EE0
|
005FF37E   E85D5BE0FF             call    00404EE0
005FF383   8B95A8FCFFFF           mov     edx, [ebp+$FFFFFCA8]
005FF389   8B03                   mov     eax, [ebx]
005FF38B   8B80E8010000           mov     eax, [eax+$01E8]
005FF391   8B08                   mov     ecx, [eax]
005FF393   FF91B0000000           call    dword ptr [ecx+$00B0]
005FF399   8B03                   mov     eax, [ebx]
005FF39B   8B80E0000000           mov     eax, [eax+$00E0]
005FF3A1   8B10                   mov     edx, [eax]
005FF3A3   FF9248020000           call    dword ptr [edx+$0248]
005FF3A9   8D9590FCFFFF           lea     edx, [ebp+$FFFFFC90]
005FF3AF   8B03                   mov     eax, [ebx]
005FF3B1   8B8058090000           mov     eax, [eax+$0958]
005FF3B7   8B08                   mov     ecx, [eax]
005FF3B9   FF5160                 call    dword ptr [ecx+$60]
005FF3BC   8B8590FCFFFF           mov     eax, [ebp+$FFFFFC90]
005FF3C2   8D9594FCFFFF           lea     edx, [ebp+$FFFFFC94]

* Reference to: Unit_00408494.Proc_004091D8
|
005FF3C8   E80B9EE0FF             call    004091D8
005FF3CD   8B8594FCFFFF           mov     eax, [ebp+$FFFFFC94]
005FF3D3   BA78016000             mov     edx, $00600178

* Reference to: System.@LStrCmp;
|
005FF3D8   E8875BE0FF             call    00404F64
005FF3DD   752E                   jnz     005FF40D
005FF3DF   8B03                   mov     eax, [ebx]
005FF3E1   8B803C010000           mov     eax, [eax+$013C]

* Possible String Reference to: 'vat'
|
005FF3E7   BA18016000             mov     edx, $00600118

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FF3EC   E86B37EDFF             call    004D2B5C
005FF3F1   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Vater'
|
005FF3F4   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF3F9   E80258E0FF             call    00404C00
005FF3FE   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Mutter'
|
005FF401   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF406   E8F557E0FF             call    00404C00
005FF40B   EB62                   jmp     005FF46F
005FF40D   8D9588FCFFFF           lea     edx, [ebp+$FFFFFC88]
005FF413   8B03                   mov     eax, [ebx]
005FF415   8B8058090000           mov     eax, [eax+$0958]
005FF41B   8B08                   mov     ecx, [eax]
005FF41D   FF5160                 call    dword ptr [ecx+$60]
005FF420   8B8588FCFFFF           mov     eax, [ebp+$FFFFFC88]
005FF426   8D958CFCFFFF           lea     edx, [ebp+$FFFFFC8C]

* Reference to: Unit_00408494.Proc_004091D8
|
005FF42C   E8A79DE0FF             call    004091D8
005FF431   8B858CFCFFFF           mov     eax, [ebp+$FFFFFC8C]
005FF437   BA84016000             mov     edx, $00600184

* Reference to: System.@LStrCmp;
|
005FF43C   E8235BE0FF             call    00404F64
005FF441   752C                   jnz     005FF46F
005FF443   8B03                   mov     eax, [ebx]
005FF445   8B803C010000           mov     eax, [eax+$013C]

* Possible String Reference to: 'mut'
|
005FF44B   BA48016000             mov     edx, $00600148

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FF450   E80737EDFF             call    004D2B5C
005FF455   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Mutter'
|
005FF458   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF45D   E89E57E0FF             call    00404C00
005FF462   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Vater'
|
005FF465   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF46A   E89157E0FF             call    00404C00
005FF46F   8D8584FCFFFF           lea     eax, [ebp+$FFFFFC84]
005FF475   50                     push    eax
005FF476   8B45EC                 mov     eax, [ebp-$14]
005FF479   48                     dec     eax
005FF47A   8BD0                   mov     edx, eax
005FF47C   03D2                   add     edx, edx
005FF47E   8D1452                 lea     edx, [edx+edx*2]
005FF481   42                     inc     edx
005FF482   B906000000             mov     ecx, $00000006
005FF487   8B45C8                 mov     eax, [ebp-$38]

* Reference to: System.@LStrCopy;
|
005FF48A   E8E95BE0FF             call    00405078
005FF48F   8B8584FCFFFF           mov     eax, [ebp+$FFFFFC84]

* Reference to: Unit_00408494.Proc_004099B4
|
005FF495   E81AA5E0FF             call    004099B4
005FF49A   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FF4A0   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FF4A7   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FF4AD   8B03                   mov     eax, [ebx]
005FF4AF   8B803C010000           mov     eax, [eax+$013C]
005FF4B5   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FF4B7   E8A83DEDFF             call    004D3264
005FF4BC   84C0                   test    al, al
005FF4BE   0F8458010000           jz      005FF61C
005FF4C4   E909010000             jmp     005FF5D2
005FF4C9   8B03                   mov     eax, [ebx]
005FF4CB   8B803C010000           mov     eax, [eax+$013C]
005FF4D1   8B559C                 mov     edx, [ebp-$64]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FF4D4   E86BE9EAFF             call    004ADE44
005FF4D9   8B10                   mov     edx, [eax]
005FF4DB   FF5258                 call    dword ptr [edx+$58]
005FF4DE   85C0                   test    eax, eax
005FF4E0   0F85CE000000           jnz     005FF5B4
005FF4E6   8B03                   mov     eax, [ebx]
005FF4E8   8B8044090000           mov     eax, [eax+$0944]
005FF4EE   8B10                   mov     edx, [eax]
005FF4F0   FF5258                 call    dword ptr [edx+$58]
005FF4F3   8D9580FCFFFF           lea     edx, [ebp+$FFFFFC80]

* Reference to : TForm1.Proc_005D3228()
|
005FF4F9   E82A3DFDFF             call    005D3228
005FF4FE   8B9580FCFFFF           mov     edx, [ebp+$FFFFFC80]
005FF504   8D45C4                 lea     eax, [ebp-$3C]

* Reference to: System.@LStrCat;
|
005FF507   E81C59E0FF             call    00404E28
005FF50C   8B03                   mov     eax, [ebx]
005FF50E   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005FF514   E80B02EBFF             call    004AF724
005FF519   FF75B4                 push    dword ptr [ebp-$4C]
005FF51C   8D9574FCFFFF           lea     edx, [ebp+$FFFFFC74]
005FF522   8B03                   mov     eax, [ebx]
005FF524   8B8050090000           mov     eax, [eax+$0950]
005FF52A   8B08                   mov     ecx, [eax]
005FF52C   FF5160                 call    dword ptr [ecx+$60]
005FF52F   8B9574FCFFFF           mov     edx, [ebp+$FFFFFC74]
005FF535   8D8D78FCFFFF           lea     ecx, [ebp+$FFFFFC78]
005FF53B   8BC6                   mov     eax, esi

* Reference to : TForm1.ucase()
|
005FF53D   E84686FDFF             call    005D7B88
005FF542   FFB578FCFFFF           push    dword ptr [ebp+$FFFFFC78]
005FF548   68F0FF5F00             push    $005FFFF0
005FF54D   8D9570FCFFFF           lea     edx, [ebp+$FFFFFC70]
005FF553   8B03                   mov     eax, [ebx]
005FF555   8B8054090000           mov     eax, [eax+$0954]
005FF55B   8B08                   mov     ecx, [eax]
005FF55D   FF5160                 call    dword ptr [ecx+$60]
005FF560   FFB570FCFFFF           push    dword ptr [ebp+$FFFFFC70]
005FF566   68F0FF5F00             push    $005FFFF0
005FF56B   8D956CFCFFFF           lea     edx, [ebp+$FFFFFC6C]
005FF571   8BC6                   mov     eax, esi

* Reference to : TForm1.geb_sterb()
|
005FF573   E854DEFFFF             call    005FD3CC
005FF578   FFB56CFCFFFF           push    dword ptr [ebp+$FFFFFC6C]
005FF57E   8D857CFCFFFF           lea     eax, [ebp+$FFFFFC7C]
005FF584   BA06000000             mov     edx, $00000006

* Reference to: System.Proc_00404EE0
|
005FF589   E85259E0FF             call    00404EE0
005FF58E   8B957CFCFFFF           mov     edx, [ebp+$FFFFFC7C]
005FF594   8B03                   mov     eax, [ebx]
005FF596   8B80E8010000           mov     eax, [eax+$01E8]
005FF59C   8B08                   mov     ecx, [eax]
005FF59E   FF91B0000000           call    dword ptr [ecx+$00B0]
005FF5A4   8B03                   mov     eax, [ebx]
005FF5A6   8B80E0000000           mov     eax, [eax+$00E0]
005FF5AC   8B10                   mov     edx, [eax]
005FF5AE   FF9248020000           call    dword ptr [edx+$0248]
005FF5B4   8B03                   mov     eax, [ebx]
005FF5B6   8B803C010000           mov     eax, [eax+$013C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005FF5BC   E82BFFEAFF             call    004AF4EC
005FF5C1   8B03                   mov     eax, [ebx]
005FF5C3   8B803C010000           mov     eax, [eax+$013C]
005FF5C9   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005FF5D0   754A                   jnz     005FF61C
005FF5D2   8B03                   mov     eax, [ebx]
005FF5D4   8B803C010000           mov     eax, [eax+$013C]
005FF5DA   8B55A0                 mov     edx, [ebp-$60]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FF5DD   E862E8EAFF             call    004ADE44
005FF5E2   8B10                   mov     edx, [eax]
005FF5E4   FF5258                 call    dword ptr [edx+$58]
005FF5E7   8BF8                   mov     edi, eax
005FF5E9   8D8568FCFFFF           lea     eax, [ebp+$FFFFFC68]
005FF5EF   50                     push    eax
005FF5F0   8B45EC                 mov     eax, [ebp-$14]
005FF5F3   48                     dec     eax
005FF5F4   8BD0                   mov     edx, eax
005FF5F6   03D2                   add     edx, edx
005FF5F8   8D1452                 lea     edx, [edx+edx*2]
005FF5FB   42                     inc     edx
005FF5FC   B906000000             mov     ecx, $00000006
005FF601   8B45C8                 mov     eax, [ebp-$38]

* Reference to: System.@LStrCopy;
|
005FF604   E86F5AE0FF             call    00405078
005FF609   8B8568FCFFFF           mov     eax, [ebp+$FFFFFC68]

* Reference to: Unit_00408494.Proc_004099B4
|
005FF60F   E8A0A3E0FF             call    004099B4
005FF614   3BF8                   cmp     edi, eax
005FF616   0F84ADFEFFFF           jz      005FF4C9
005FF61C   8B03                   mov     eax, [ebx]
005FF61E   8B803C010000           mov     eax, [eax+$013C]
005FF624   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FF626   E83135EDFF             call    004D2B5C
005FF62B   8D8564FCFFFF           lea     eax, [ebp+$FFFFFC64]
005FF631   50                     push    eax
005FF632   8B45EC                 mov     eax, [ebp-$14]
005FF635   48                     dec     eax
005FF636   8BF8                   mov     edi, eax
005FF638   03FF                   add     edi, edi
005FF63A   8D3C7F                 lea     edi, [edi+edi*2]
005FF63D   47                     inc     edi
005FF63E   8BD7                   mov     edx, edi
005FF640   B906000000             mov     ecx, $00000006
005FF645   8B45C8                 mov     eax, [ebp-$38]

* Reference to: System.@LStrCopy;
|
005FF648   E82B5AE0FF             call    00405078
005FF64D   8B8564FCFFFF           mov     eax, [ebp+$FFFFFC64]

* Reference to: Unit_00408494.Proc_004099B4
|
005FF653   E85CA3E0FF             call    004099B4
005FF658   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FF65E   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FF665   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FF66B   8B03                   mov     eax, [ebx]
005FF66D   8B803C010000           mov     eax, [eax+$013C]
005FF673   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FF675   E8EA3BEDFF             call    004D3264
005FF67A   8D955CFCFFFF           lea     edx, [ebp+$FFFFFC5C]
005FF680   8B03                   mov     eax, [ebx]
005FF682   8B8058090000           mov     eax, [eax+$0958]
005FF688   8B08                   mov     ecx, [eax]
005FF68A   FF5160                 call    dword ptr [ecx+$60]
005FF68D   8B855CFCFFFF           mov     eax, [ebp+$FFFFFC5C]
005FF693   8D9560FCFFFF           lea     edx, [ebp+$FFFFFC60]

* Reference to: Unit_00408494.Proc_004091D8
|
005FF699   E83A9BE0FF             call    004091D8
005FF69E   8B8560FCFFFF           mov     eax, [ebp+$FFFFFC60]
005FF6A4   BA78016000             mov     edx, $00600178

* Reference to: System.@LStrCmp;
|
005FF6A9   E8B658E0FF             call    00404F64
005FF6AE   752C                   jnz     005FF6DC
005FF6B0   8B03                   mov     eax, [ebx]
005FF6B2   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
005FF6B8   BA48016000             mov     edx, $00600148

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FF6BD   E89A34EDFF             call    004D2B5C
005FF6C2   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Mutter'
|
005FF6C5   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF6CA   E83155E0FF             call    00404C00
005FF6CF   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Vater'
|
005FF6D2   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF6D7   E82455E0FF             call    00404C00
005FF6DC   8D9554FCFFFF           lea     edx, [ebp+$FFFFFC54]
005FF6E2   8B03                   mov     eax, [ebx]
005FF6E4   8B8058090000           mov     eax, [eax+$0958]
005FF6EA   8B08                   mov     ecx, [eax]
005FF6EC   FF5160                 call    dword ptr [ecx+$60]
005FF6EF   8B8554FCFFFF           mov     eax, [ebp+$FFFFFC54]
005FF6F5   8D9558FCFFFF           lea     edx, [ebp+$FFFFFC58]

* Reference to: Unit_00408494.Proc_004091D8
|
005FF6FB   E8D89AE0FF             call    004091D8
005FF700   8B8558FCFFFF           mov     eax, [ebp+$FFFFFC58]
005FF706   BA84016000             mov     edx, $00600184

* Reference to: System.@LStrCmp;
|
005FF70B   E85458E0FF             call    00404F64
005FF710   752C                   jnz     005FF73E
005FF712   8B03                   mov     eax, [ebx]
005FF714   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
005FF71A   BA18016000             mov     edx, $00600118

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FF71F   E83834EDFF             call    004D2B5C
005FF724   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Vater'
|
005FF727   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF72C   E8CF54E0FF             call    00404C00
005FF731   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Mutter'
|
005FF734   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF739   E8C254E0FF             call    00404C00
005FF73E   8D458C                 lea     eax, [ebp-$74]

* Reference to: System.@LStrClr(void;void);
|
005FF741   E82254E0FF             call    00404B68
005FF746   8D8550FCFFFF           lea     eax, [ebp+$FFFFFC50]
005FF74C   50                     push    eax
005FF74D   8BD7                   mov     edx, edi
005FF74F   B906000000             mov     ecx, $00000006
005FF754   8B45C8                 mov     eax, [ebp-$38]

* Reference to: System.@LStrCopy;
|
005FF757   E81C59E0FF             call    00405078
005FF75C   8B8550FCFFFF           mov     eax, [ebp+$FFFFFC50]

* Reference to: Unit_00408494.Proc_004099B4
|
005FF762   E84DA2E0FF             call    004099B4
005FF767   8BD0                   mov     edx, eax
005FF769   8D4D8C                 lea     ecx, [ebp-$74]
005FF76C   8BC6                   mov     eax, esi

* Reference to : TForm1.ehtest()
|
005FF76E   E81DE1FFFF             call    005FD890
005FF773   8D954CFCFFFF           lea     edx, [ebp+$FFFFFC4C]
005FF779   8B458C                 mov     eax, [ebp-$74]

* Reference to: Unit_00408494.Proc_00409448
|
005FF77C   E8C79CE0FF             call    00409448
005FF781   83BD4CFCFFFF00         cmp     dword ptr [ebp+$FFFFFC4C], +$00
005FF788   0F869A040000           jbe     005FFC28
005FF78E   8B458C                 mov     eax, [ebp-$74]

* Reference to: System.@LStrLen(String):Integer;
|
005FF791   E88A56E0FF             call    00404E20
005FF796   B911000000             mov     ecx, $00000011
005FF79B   99                     cdq
005FF79C   F7F9                   idiv    ecx 
005FF79E   85C0                   test    eax, eax
005FF7A0   0F8E82040000           jle     005FFC28
005FF7A6   89855CFFFFFF           mov     [ebp+$FFFFFF5C], eax
005FF7AC   C745E801000000         mov     dword ptr [ebp-$18], $00000001
005FF7B3   8D45C4                 lea     eax, [ebp-$3C]

* Reference to: System.@LStrClr(void;void);
|
005FF7B6   E8AD53E0FF             call    00404B68
005FF7BB   8D8548FCFFFF           lea     eax, [ebp+$FFFFFC48]
005FF7C1   50                     push    eax
005FF7C2   8B45E8                 mov     eax, [ebp-$18]
005FF7C5   48                     dec     eax
005FF7C6   8BF8                   mov     edi, eax
005FF7C8   C1E704                 shl     edi, $04
005FF7CB   03F8                   add     edi, eax
005FF7CD   8BD7                   mov     edx, edi
005FF7CF   42                     inc     edx
005FF7D0   B906000000             mov     ecx, $00000006
005FF7D5   8B458C                 mov     eax, [ebp-$74]

* Reference to: System.@LStrCopy;
|
005FF7D8   E89B58E0FF             call    00405078
005FF7DD   8B8548FCFFFF           mov     eax, [ebp+$FFFFFC48]

* Reference to: Unit_00408494.Proc_004099B4
|
005FF7E3   E8CCA1E0FF             call    004099B4
005FF7E8   8945D4                 mov     [ebp-$2C], eax
005FF7EB   8B45D4                 mov     eax, [ebp-$2C]
005FF7EE   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FF7F4   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FF7FB   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FF801   8B03                   mov     eax, [ebx]
005FF803   8B803C010000           mov     eax, [eax+$013C]
005FF809   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FF80B   E8543AEDFF             call    004D3264
005FF810   8D8544FCFFFF           lea     eax, [ebp+$FFFFFC44]
005FF816   50                     push    eax
005FF817   8BD7                   mov     edx, edi
005FF819   83C211                 add     edx, +$11
005FF81C   B901000000             mov     ecx, $00000001
005FF821   8B458C                 mov     eax, [ebp-$74]

* Reference to: System.@LStrCopy;
|
005FF824   E84F58E0FF             call    00405078
005FF829   8B8544FCFFFF           mov     eax, [ebp+$FFFFFC44]
005FF82F   BA58016000             mov     edx, $00600158

* Reference to: System.@LStrCmp;
|
005FF834   E82B57E0FF             call    00404F64
005FF839   7514                   jnz     005FF84F
005FF83B   56                     push    esi
005FF83C   57                     push    edi
005FF83D   BE5C016000             mov     esi, $0060015C
005FF842   8DBD72FFFFFF           lea     edi, [ebp+$FFFFFF72]
005FF848   66A5                   movsw
005FF84A   A4                     movsb
005FF84B   5F                     pop     edi
005FF84C   5E                     pop     esi
005FF84D   EB0A                   jmp     005FF859
005FF84F   C78572FFFFFF036F2D6F   mov     dword ptr [ebp+$FFFFFF72], $6F2D6F03
005FF859   8B03                   mov     eax, [ebx]
005FF85B   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005FF861   E8BEFEEAFF             call    004AF724
005FF866   FF75A8                 push    dword ptr [ebp-$58]
005FF869   8D853CFCFFFF           lea     eax, [ebp+$FFFFFC3C]
005FF86F   8D9572FFFFFF           lea     edx, [ebp+$FFFFFF72]

* Reference to: System.@LStrFromString(String;String;ShortString;ShortString);
|
005FF875   E84A55E0FF             call    00404DC4
005FF87A   FFB53CFCFFFF           push    dword ptr [ebp+$FFFFFC3C]
005FF880   68F0FF5F00             push    $005FFFF0
005FF885   8D8538FCFFFF           lea     eax, [ebp+$FFFFFC38]
005FF88B   50                     push    eax
005FF88C   8BD7                   mov     edx, edi
005FF88E   83C207                 add     edx, +$07
005FF891   B90A000000             mov     ecx, $0000000A
005FF896   8B458C                 mov     eax, [ebp-$74]

* Reference to: System.@LStrCopy;
|
005FF899   E8DA57E0FF             call    00405078
005FF89E   FFB538FCFFFF           push    dword ptr [ebp+$FFFFFC38]

* Possible String Reference to: ' : '
|
005FF8A4   686C016000             push    $0060016C
005FF8A9   8D9530FCFFFF           lea     edx, [ebp+$FFFFFC30]
005FF8AF   8B03                   mov     eax, [ebx]
005FF8B1   8B8050090000           mov     eax, [eax+$0950]
005FF8B7   8B08                   mov     ecx, [eax]
005FF8B9   FF5160                 call    dword ptr [ecx+$60]
005FF8BC   8B9530FCFFFF           mov     edx, [ebp+$FFFFFC30]
005FF8C2   8D8D34FCFFFF           lea     ecx, [ebp+$FFFFFC34]
005FF8C8   8BC6                   mov     eax, esi

* Reference to : TForm1.ucase()
|
005FF8CA   E8B982FDFF             call    005D7B88
005FF8CF   FFB534FCFFFF           push    dword ptr [ebp+$FFFFFC34]
005FF8D5   68F0FF5F00             push    $005FFFF0
005FF8DA   8D952CFCFFFF           lea     edx, [ebp+$FFFFFC2C]
005FF8E0   8B03                   mov     eax, [ebx]
005FF8E2   8B8054090000           mov     eax, [eax+$0954]
005FF8E8   8B08                   mov     ecx, [eax]
005FF8EA   FF5160                 call    dword ptr [ecx+$60]
005FF8ED   FFB52CFCFFFF           push    dword ptr [ebp+$FFFFFC2C]
005FF8F3   68F0FF5F00             push    $005FFFF0
005FF8F8   8D9528FCFFFF           lea     edx, [ebp+$FFFFFC28]
005FF8FE   8BC6                   mov     eax, esi

* Reference to : TForm1.geb_sterb()
|
005FF900   E8C7DAFFFF             call    005FD3CC
005FF905   FFB528FCFFFF           push    dword ptr [ebp+$FFFFFC28]
005FF90B   8D8540FCFFFF           lea     eax, [ebp+$FFFFFC40]
005FF911   BA0A000000             mov     edx, $0000000A

* Reference to: System.Proc_00404EE0
|
005FF916   E8C555E0FF             call    00404EE0
005FF91B   8B9540FCFFFF           mov     edx, [ebp+$FFFFFC40]
005FF921   8B03                   mov     eax, [ebx]
005FF923   8B80E8010000           mov     eax, [eax+$01E8]
005FF929   8B08                   mov     ecx, [eax]
005FF92B   FF91B0000000           call    dword ptr [ecx+$00B0]
005FF931   8B03                   mov     eax, [ebx]
005FF933   8B80E0000000           mov     eax, [eax+$00E0]
005FF939   8B10                   mov     edx, [eax]
005FF93B   FF9248020000           call    dword ptr [edx+$0248]
005FF941   8D9520FCFFFF           lea     edx, [ebp+$FFFFFC20]
005FF947   8B03                   mov     eax, [ebx]
005FF949   8B8058090000           mov     eax, [eax+$0958]
005FF94F   8B08                   mov     ecx, [eax]
005FF951   FF5160                 call    dword ptr [ecx+$60]
005FF954   8B8520FCFFFF           mov     eax, [ebp+$FFFFFC20]
005FF95A   8D9524FCFFFF           lea     edx, [ebp+$FFFFFC24]

* Reference to: Unit_00408494.Proc_004091D8
|
005FF960   E87398E0FF             call    004091D8
005FF965   8B8524FCFFFF           mov     eax, [ebp+$FFFFFC24]
005FF96B   BA78016000             mov     edx, $00600178

* Reference to: System.@LStrCmp;
|
005FF970   E8EF55E0FF             call    00404F64
005FF975   752C                   jnz     005FF9A3
005FF977   8B03                   mov     eax, [ebx]
005FF979   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'mut'
|
005FF97F   BA48016000             mov     edx, $00600148

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FF984   E8D331EDFF             call    004D2B5C
005FF989   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Mutter'
|
005FF98C   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF991   E86A52E0FF             call    00404C00
005FF996   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Vater'
|
005FF999   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF99E   E85D52E0FF             call    00404C00
005FF9A3   8D9518FCFFFF           lea     edx, [ebp+$FFFFFC18]
005FF9A9   8B03                   mov     eax, [ebx]
005FF9AB   8B8058090000           mov     eax, [eax+$0958]
005FF9B1   8B08                   mov     ecx, [eax]
005FF9B3   FF5160                 call    dword ptr [ecx+$60]
005FF9B6   8B8518FCFFFF           mov     eax, [ebp+$FFFFFC18]
005FF9BC   8D951CFCFFFF           lea     edx, [ebp+$FFFFFC1C]

* Reference to: Unit_00408494.Proc_004091D8
|
005FF9C2   E81198E0FF             call    004091D8
005FF9C7   8B851CFCFFFF           mov     eax, [ebp+$FFFFFC1C]
005FF9CD   BA84016000             mov     edx, $00600184

* Reference to: System.@LStrCmp;
|
005FF9D2   E88D55E0FF             call    00404F64
005FF9D7   752C                   jnz     005FFA05
005FF9D9   8B03                   mov     eax, [ebx]
005FF9DB   8B809C000000           mov     eax, [eax+$009C]

* Possible String Reference to: 'vat'
|
005FF9E1   BA18016000             mov     edx, $00600118

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FF9E6   E87131EDFF             call    004D2B5C
005FF9EB   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'Vater'
|
005FF9EE   BA24016000             mov     edx, $00600124

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FF9F3   E80852E0FF             call    00404C00
005FF9F8   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: 'Mutter'
|
005FF9FB   BA34016000             mov     edx, $00600134

* Reference to: System.@LStrLAsg(void;void;void;void);
|
005FFA00   E8FB51E0FF             call    00404C00
005FFA05   8B45D8                 mov     eax, [ebp-$28]
005FFA08   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FFA0E   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FFA15   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FFA1B   8B03                   mov     eax, [ebx]
005FFA1D   8B809C000000           mov     eax, [eax+$009C]
005FFA23   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FFA25   E83A38EDFF             call    004D3264
005FFA2A   84C0                   test    al, al
005FFA2C   0F84B4000000           jz      005FFAE6
005FFA32   E991000000             jmp     005FFAC8
005FFA37   8B03                   mov     eax, [ebx]
005FFA39   8B809C000000           mov     eax, [eax+$009C]
005FFA3F   8B559C                 mov     edx, [ebp-$64]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FFA42   E8FDE3EAFF             call    004ADE44
005FFA47   8B10                   mov     edx, [eax]
005FFA49   FF5258                 call    dword ptr [edx+$58]
005FFA4C   3B45D4                 cmp     eax, [ebp-$2C]
005FFA4F   7559                   jnz     005FFAAA
005FFA51   8B03                   mov     eax, [ebx]
005FFA53   8B8074080000           mov     eax, [eax+$0874]
005FFA59   8B10                   mov     edx, [eax]
005FFA5B   FF5258                 call    dword ptr [edx+$58]
005FFA5E   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FFA64   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FFA6B   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FFA71   8B03                   mov     eax, [ebx]
005FFA73   8B803C010000           mov     eax, [eax+$013C]
005FFA79   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FFA7B   E8E437EDFF             call    004D3264
005FFA80   84C0                   test    al, al
005FFA82   7426                   jz      005FFAAA
005FFA84   8B03                   mov     eax, [ebx]
005FFA86   8B8044090000           mov     eax, [eax+$0944]
005FFA8C   8B10                   mov     edx, [eax]
005FFA8E   FF5258                 call    dword ptr [edx+$58]
005FFA91   8D9514FCFFFF           lea     edx, [ebp+$FFFFFC14]

* Reference to : TForm1.Proc_005D3228()
|
005FFA97   E88C37FDFF             call    005D3228
005FFA9C   8B9514FCFFFF           mov     edx, [ebp+$FFFFFC14]
005FFAA2   8D45C4                 lea     eax, [ebp-$3C]

* Reference to: System.@LStrCat;
|
005FFAA5   E87E53E0FF             call    00404E28
005FFAAA   8B03                   mov     eax, [ebx]
005FFAAC   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005FFAB2   E835FAEAFF             call    004AF4EC
005FFAB7   8B03                   mov     eax, [ebx]
005FFAB9   8B809C000000           mov     eax, [eax+$009C]
005FFABF   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005FFAC6   751E                   jnz     005FFAE6
005FFAC8   8B03                   mov     eax, [ebx]
005FFACA   8B809C000000           mov     eax, [eax+$009C]
005FFAD0   8B55A0                 mov     edx, [ebp-$60]

* Reference to: DB.TDataSet.FieldByName(TDataSet;AnsiString):TField;
|
005FFAD3   E86CE3EAFF             call    004ADE44
005FFAD8   8B10                   mov     edx, [eax]
005FFADA   FF5258                 call    dword ptr [edx+$58]
005FFADD   3B45D8                 cmp     eax, [ebp-$28]
005FFAE0   0F8451FFFFFF           jz      005FFA37
005FFAE6   837DC400               cmp     dword ptr [ebp-$3C], +$00
005FFAEA   0F8629010000           jbe     005FFC19
005FFAF0   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrLen(String):Integer;
|
005FFAF3   E82853E0FF             call    00404E20
005FFAF8   B906000000             mov     ecx, $00000006
005FFAFD   99                     cdq
005FFAFE   F7F9                   idiv    ecx 
005FFB00   85C0                   test    eax, eax
005FFB02   0F8E11010000           jle     005FFC19
005FFB08   898558FFFFFF           mov     [ebp+$FFFFFF58], eax
005FFB0E   C745E401000000         mov     dword ptr [ebp-$1C], $00000001
005FFB15   8D8510FCFFFF           lea     eax, [ebp+$FFFFFC10]
005FFB1B   50                     push    eax
005FFB1C   8B45E4                 mov     eax, [ebp-$1C]
005FFB1F   48                     dec     eax
005FFB20   8BD0                   mov     edx, eax
005FFB22   03D2                   add     edx, edx
005FFB24   8D1452                 lea     edx, [edx+edx*2]
005FFB27   42                     inc     edx
005FFB28   B906000000             mov     ecx, $00000006
005FFB2D   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrCopy;
|
005FFB30   E84355E0FF             call    00405078
005FFB35   8B8510FCFFFF           mov     eax, [ebp+$FFFFFC10]

* Reference to: Unit_00408494.Proc_004099B4
|
005FFB3B   E8749EE0FF             call    004099B4
005FFB40   898520FEFFFF           mov     [ebp+$FFFFFE20], eax
005FFB46   C68524FEFFFF00         mov     byte ptr [ebp+$FFFFFE24], $00
005FFB4D   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]
005FFB53   8B03                   mov     eax, [ebx]
005FFB55   8B803C010000           mov     eax, [eax+$013C]
005FFB5B   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FFB5D   E80237EDFF             call    004D3264
005FFB62   8B03                   mov     eax, [ebx]
005FFB64   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005FFB6A   E8B5FBEAFF             call    004AF724
005FFB6F   FF75B4                 push    dword ptr [ebp-$4C]
005FFB72   8D9504FCFFFF           lea     edx, [ebp+$FFFFFC04]
005FFB78   8B03                   mov     eax, [ebx]
005FFB7A   8B8050090000           mov     eax, [eax+$0950]
005FFB80   8B08                   mov     ecx, [eax]
005FFB82   FF5160                 call    dword ptr [ecx+$60]
005FFB85   8B9504FCFFFF           mov     edx, [ebp+$FFFFFC04]
005FFB8B   8D8D08FCFFFF           lea     ecx, [ebp+$FFFFFC08]
005FFB91   8BC6                   mov     eax, esi

* Reference to : TForm1.ucase()
|
005FFB93   E8F07FFDFF             call    005D7B88
005FFB98   FFB508FCFFFF           push    dword ptr [ebp+$FFFFFC08]
005FFB9E   68F0FF5F00             push    $005FFFF0
005FFBA3   8D9500FCFFFF           lea     edx, [ebp+$FFFFFC00]
005FFBA9   8B03                   mov     eax, [ebx]
005FFBAB   8B8054090000           mov     eax, [eax+$0954]
005FFBB1   8B08                   mov     ecx, [eax]
005FFBB3   FF5160                 call    dword ptr [ecx+$60]
005FFBB6   FFB500FCFFFF           push    dword ptr [ebp+$FFFFFC00]
005FFBBC   68F0FF5F00             push    $005FFFF0
005FFBC1   8D95FCFBFFFF           lea     edx, [ebp+$FFFFFBFC]
005FFBC7   8BC6                   mov     eax, esi

* Reference to : TForm1.geb_sterb()
|
005FFBC9   E8FED7FFFF             call    005FD3CC
005FFBCE   FFB5FCFBFFFF           push    dword ptr [ebp+$FFFFFBFC]
005FFBD4   8D850CFCFFFF           lea     eax, [ebp+$FFFFFC0C]
005FFBDA   BA06000000             mov     edx, $00000006

* Reference to: System.Proc_00404EE0
|
005FFBDF   E8FC52E0FF             call    00404EE0
005FFBE4   8B950CFCFFFF           mov     edx, [ebp+$FFFFFC0C]
005FFBEA   8B03                   mov     eax, [ebx]
005FFBEC   8B80E8010000           mov     eax, [eax+$01E8]
005FFBF2   8B08                   mov     ecx, [eax]
005FFBF4   FF91B0000000           call    dword ptr [ecx+$00B0]
005FFBFA   8B03                   mov     eax, [ebx]
005FFBFC   8B80E0000000           mov     eax, [eax+$00E0]
005FFC02   8B10                   mov     edx, [eax]
005FFC04   FF9248020000           call    dword ptr [edx+$0248]
005FFC0A   FF45E4                 inc     dword ptr [ebp-$1C]
005FFC0D   FF8D58FFFFFF           dec     dword ptr [ebp+$FFFFFF58]
005FFC13   0F85FCFEFFFF           jnz     005FFB15
005FFC19   FF45E8                 inc     dword ptr [ebp-$18]
005FFC1C   FF8D5CFFFFFF           dec     dword ptr [ebp+$FFFFFF5C]
005FFC22   0F858BFBFFFF           jnz     005FF7B3
005FFC28   FF45EC                 inc     dword ptr [ebp-$14]
005FFC2B   FF8D60FFFFFF           dec     dword ptr [ebp+$FFFFFF60]
005FFC31   0F856DF6FFFF           jnz     005FF2A4
005FFC37   FF45F0                 inc     dword ptr [ebp-$10]
005FFC3A   FF8D64FFFFFF           dec     dword ptr [ebp+$FFFFFF64]
005FFC40   0F85F8F2FFFF           jnz     005FEF3E
005FFC46   FF45F4                 inc     dword ptr [ebp-$0C]
005FFC49   FF8D68FFFFFF           dec     dword ptr [ebp+$FFFFFF68]
005FFC4F   0F85E9EDFFFF           jnz     005FEA3E
005FFC55   8B03                   mov     eax, [ebx]
005FFC57   8B8040010000           mov     eax, [eax+$0140]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005FFC5D   E88AF8EAFF             call    004AF4EC
005FFC62   8B03                   mov     eax, [ebx]
005FFC64   8B8040010000           mov     eax, [eax+$0140]
005FFC6A   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005FFC71   750F                   jnz     005FFC82
005FFC73   FF45F8                 inc     dword ptr [ebp-$08]
005FFC76   FF8D6CFFFFFF           dec     dword ptr [ebp+$FFFFFF6C]
005FFC7C   0F8525EAFFFF           jnz     005FE6A7

* Reference to pointer to GlobalVar_0061E0B4
|
005FFC82   A1ECC66100             mov     eax, dword ptr [$0061C6EC]
005FFC87   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0B4.OFFS_034C
|
005FFC89   8B804C030000           mov     eax, [eax+$034C]
005FFC8F   B201                   mov     dl, $01

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FFC91   E88ECCE4FF             call    0044C924

* Reference to pointer to GlobalVar_0061E0B4
|
005FFC96   A1ECC66100             mov     eax, dword ptr [$0061C6EC]
005FFC9B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0B4.OFFS_0350
|
005FFC9D   8B8050030000           mov     eax, [eax+$0350]
005FFCA3   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FFCA5   E87ACCE4FF             call    0044C924
005FFCAA   8BC6                   mov     eax, esi

* Reference to : TForm1.QRDefault()
|
005FFCAC   E823F9FEFF             call    005EF5D4

* Reference to pointer to GlobalVar_0061DF10
|
005FFCB1   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFCB6   8B00                   mov     eax, [eax]

* Reference to control Label9 : TLabel
|
005FFCB8   8B8010030000           mov     eax, [eax+$0310]

* Reference to field TLabel.OFFS_0258
|
005FFCBE   8B8058020000           mov     eax, [eax+$0258]
005FFCC4   8B10                   mov     edx, [eax]
005FFCC6   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF10
|
005FFCC9   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFCCE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0350
|
005FFCD0   8B8050030000           mov     eax, [eax+$0350]
005FFCD6   33D2                   xor     edx, edx

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
005FFCD8   E8A3E6F0FF             call    0050E380

* Reference to pointer to GlobalVar_0061DF10
|
005FFCDD   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFCE2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0354
|
005FFCE4   8B8054030000           mov     eax, [eax+$0354]
005FFCEA   33D2                   xor     edx, edx

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
005FFCEC   E88FE6F0FF             call    0050E380
005FFCF1   8B03                   mov     eax, [ebx]
005FFCF3   8B90E0000000           mov     edx, [eax+$00E0]

* Reference to pointer to GlobalVar_0061DF10
|
005FFCF9   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFCFE   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
005FFD00   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to: QuickRpt.TQuickRep.SetDataSet(TQuickRep;TDataSet);
|
005FFD06   E8FDB2F1FF             call    0051B008
005FFD0B   8B03                   mov     eax, [ebx]

* Reference to field TLabel.OnMouseUp : TMouseEvent
|
005FFD0D   8B90E0000000           mov     edx, [eax+$00E0]

* Reference to pointer to GlobalVar_0061DF10
|
005FFD13   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFD18   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0350
|
005FFD1A   8B8050030000           mov     eax, [eax+$0350]

* Reference to: QRCtrls.TQRDBText.SetDataSet(TQRDBText;TDataSet);
|
005FFD20   E83BE6F0FF             call    0050E360

* Reference to pointer to GlobalVar_0061DF10
|
005FFD25   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFD2A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0350
|
005FFD2C   8B8050030000           mov     eax, [eax+$0350]

* Possible String Reference to: 'zeile'
|
005FFD32   BA90016000             mov     edx, $00600190

* Reference to: QRCtrls.TQRDBText.SetDataField(TQRDBText;AnsiString);
|
005FFD37   E844E6F0FF             call    0050E380

* Reference to pointer to GlobalVar_0061DF10
|
005FFD3C   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFD41   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0350
|
005FFD43   8B8050030000           mov     eax, [eax+$0350]
005FFD49   B201                   mov     dl, $01
005FFD4B   8B08                   mov     ecx, [eax]
005FFD4D   FF5164                 call    dword ptr [ecx+$64]

* Reference to pointer to GlobalVar_0061DF10
|
005FFD50   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFD55   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0354
|
005FFD57   8B8054030000           mov     eax, [eax+$0354]
005FFD5D   33D2                   xor     edx, edx
005FFD5F   8B08                   mov     ecx, [eax]
005FFD61   FF5164                 call    dword ptr [ecx+$64]

* Reference to pointer to GlobalVar_0061DF10
|
005FFD64   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFD69   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0350
|
005FFD6B   8B8050030000           mov     eax, [eax+$0350]
005FFD71   8B4068                 mov     eax, [eax+$68]

* Possible String Reference to: 'Arial'
|
005FFD74   BAA0016000             mov     edx, $006001A0

* Reference to: Graphics.TFont.SetName(TFont;TFontName);
|
005FFD79   E8D261E2FF             call    00425F50

* Reference to pointer to GlobalVar_0061DF10
|
005FFD7E   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFD83   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0354
|
005FFD85   8B8054030000           mov     eax, [eax+$0354]
005FFD8B   8B4068                 mov     eax, [eax+$68]

* Possible String Reference to: 'Arial'
|
005FFD8E   BAA0016000             mov     edx, $006001A0

* Reference to: Graphics.TFont.SetName(TFont;TFontName);
|
005FFD93   E8B861E2FF             call    00425F50

* Reference to pointer to GlobalVar_0061DF10
|
005FFD98   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFD9D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0350
|
005FFD9F   8B8050030000           mov     eax, [eax+$0350]
005FFDA5   8B4068                 mov     eax, [eax+$68]
005FFDA8   BA0A000000             mov     edx, $0000000A

* Reference to: Graphics.TFont.SetSize(TFont;Integer);
|
005FFDAD   E81662E2FF             call    00425FC8

* Reference to pointer to GlobalVar_0061DF10
|
005FFDB2   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFDB7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0350
|
005FFDB9   8B8050030000           mov     eax, [eax+$0350]
005FFDBF   33D2                   xor     edx, edx
005FFDC1   8B08                   mov     ecx, [eax]
005FFDC3   FF91E0000000           call    dword ptr [ecx+$00E0]

* Reference to pointer to GlobalVar_0061DF10
|
005FFDC9   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFDCE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0350
|
005FFDD0   8B8050030000           mov     eax, [eax+$0350]
005FFDD6   BA0A000000             mov     edx, $0000000A

* Reference to: Controls.TControl.SetLeft(TControl;Integer);
|
005FFDDB   E86CC3E4FF             call    0044C14C

* Reference to pointer to GlobalVar_0061DF10
|
005FFDE0   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFDE5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0350
|
005FFDE7   8B8050030000           mov     eax, [eax+$0350]
005FFDED   BA58020000             mov     edx, $00000258

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
005FFDF2   E8A1C3E4FF             call    0044C198

* Reference to pointer to GlobalVar_0061DF10
|
005FFDF7   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFDFC   8B00                   mov     eax, [eax]

* Reference to control Label2 : TLabel
|
005FFDFE   8B80F8020000           mov     eax, [eax+$02F8]
005FFE04   8B1530595302           mov     edx, [$02535930]

* Reference to: QRCtrls.TQRCustomLabel.SetCaption(TQRCustomLabel;AnsiString);
|
005FFE0A   E845E3F0FF             call    0050E154

* Reference to pointer to GlobalVar_0061DF10
|
005FFE0F   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFE14   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF10.OFFS_0368
|
005FFE16   8B8068030000           mov     eax, [eax+$0368]

* Possible String Reference to: 'Nachfahren'
|
005FFE1C   BAB0016000             mov     edx, $006001B0

* Reference to: QRCtrls.TQRCustomLabel.SetCaption(TQRCustomLabel;AnsiString);
|
005FFE21   E82EE3F0FF             call    0050E154
005FFE26   8B03                   mov     eax, [ebx]
005FFE28   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FFE2E   E855CEEAFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF10
|
005FFE33   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFE38   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
005FFE3A   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to field TLabel.OFFS_02BC
|
005FFE40   8B80BC020000           mov     eax, [eax+$02BC]
005FFE46   BA01000000             mov     edx, $00000001

* Reference to: QuickRpt.TQRPage.SetColumns(TQRPage;Integer);
|
005FFE4B   E84859F1FF             call    00515798
005FFE50   833D3459530200         cmp     dword ptr [$02535934], +$00
005FFE57   7618                   jbe     005FFE71

* Reference to pointer to GlobalVar_0061DF10
|
005FFE59   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFE5E   8B00                   mov     eax, [eax]

* Reference to control Label3 : TLabel
|
005FFE60   8B80FC020000           mov     eax, [eax+$02FC]
005FFE66   8B1534595302           mov     edx, [$02535934]

* Reference to: QRCtrls.TQRCustomLabel.SetCaption(TQRCustomLabel;AnsiString);
|
005FFE6C   E8E3E2F0FF             call    0050E154

* Reference to pointer to GlobalVar_0061DF10
|
005FFE71   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFE76   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
005FFE78   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to field TLabel.OFFS_02AC
|
005FFE7E   89B0AC020000           mov     [eax+$02AC], esi

* Reference to field TLabel.OFFS_02A8
|
005FFE84   C780A8020000C0B15F00   mov     dword ptr [eax+$02A8], $005FB1C0

* Reference to pointer to GlobalVar_0061DF10
|
005FFE8E   A1F4C76100             mov     eax, dword ptr [$0061C7F4]
005FFE93   8B00                   mov     eax, [eax]

* Reference to control Label1 : TLabel
|
005FFE95   8B80F0020000           mov     eax, [eax+$02F0]

* Reference to: QuickRpt.TCustomQuickRep.Preview(TCustomQuickRep);
|
005FFE9B   E8B098F1FF             call    00519750
005FFEA0   33C0                   xor     eax, eax
005FFEA2   5A                     pop     edx
005FFEA3   59                     pop     ecx
005FFEA4   59                     pop     ecx
005FFEA5   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005FFEA8   6844FF5F00             push    $005FFF44
005FFEAD   8D85FCFBFFFF           lea     eax, [ebp+$FFFFFBFC]
005FFEB3   BA5D000000             mov     edx, $0000005D

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FFEB8   E8CF4CE0FF             call    00404B8C
005FFEBD   8D8578FDFFFF           lea     eax, [ebp+$FFFFFD78]
005FFEC3   BA04000000             mov     edx, $00000004

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FFEC8   E8BF4CE0FF             call    00404B8C
005FFECD   8D8590FDFFFF           lea     eax, [ebp+$FFFFFD90]

* Reference to: System.@LStrClr(void;void);
|
005FFED3   E8904CE0FF             call    00404B68
005FFED8   8D8598FDFFFF           lea     eax, [ebp+$FFFFFD98]
005FFEDE   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FFEE3   E8A44CE0FF             call    00404B8C
005FFEE8   8D858CFDFFFF           lea     eax, [ebp+$FFFFFD8C]

* Reference to: System.@LStrClr(void;void);
|
005FFEEE   E8754CE0FF             call    00404B68
005FFEF3   8D8594FDFFFF           lea     eax, [ebp+$FFFFFD94]

* Reference to: System.@LStrClr(void;void);
|
005FFEF9   E86A4CE0FF             call    00404B68
005FFEFE   8D85A0FDFFFF           lea     eax, [ebp+$FFFFFDA0]
005FFF04   BA20000000             mov     edx, $00000020

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FFF09   E87E4CE0FF             call    00404B8C
005FFF0E   8D8528FEFFFF           lea     eax, [ebp+$FFFFFE28]
005FFF14   BA0B000000             mov     edx, $0000000B

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FFF19   E86E4CE0FF             call    00404B8C
005FFF1E   8D8554FFFFFF           lea     eax, [ebp+$FFFFFF54]

* Reference to: System.@LStrClr(void;void);
|
005FFF24   E83F4CE0FF             call    00404B68
005FFF29   8D8578FFFFFF           lea     eax, [ebp+$FFFFFF78]
005FFF2F   BA17000000             mov     edx, $00000017

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FFF34   E8534CE0FF             call    00404B8C
005FFF39   C3                     ret


* Reference to: System.@HandleFinally;
|
005FFF3A   E98D45E0FF             jmp     004044CC
005FFF3F   E969FFFFFF             jmp     005FFEAD

****** END
|
005FFF44   5F                     pop     edi
005FFF45   5E                     pop     esi
005FFF46   5B                     pop     ebx
005FFF47   8BE5                   mov     esp, ebp
005FFF49   5D                     pop     ebp
005FFF4A   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.StringGrid2
    (TStringGrid); TForm1.TabSheet2 (TTabSheet)
Database/provider: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_0061DFB4; GlobalVar_0061E0F8; GlobalVar_0061E0FC;
    GlobalVar_02535948
Unresolved field offsets: OFFS_005C; OFFS_00E8; OFFS_024C; OFFS_0324; OFFS_0534
Project calls: TForm1.anzeigen(); TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Dialogs.ShowMessage(AnsiString);;
    Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;; method TMenuItem.Click();
    Spin.TSpinEdit.GetValue(TSpinEdit):Longint;
Strings/files/dialog text: '^[��]�'; 'Keine Daten verf�gbar.'; 'Keine Nachfahren gefunden.';
    'Nachfahren-Grafik I'; 'Nachgr1'; '�A����^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.GrafikI1Click(Sender : TObject);
begin
(*
006001BC   55                     push    ebp
006001BD   8BEC                   mov     ebp, esp
006001BF   83C4F4                 add     esp, -$0C
006001C2   53                     push    ebx
006001C3   56                     push    esi
006001C4   33C9                   xor     ecx, ecx
006001C6   894DFC                 mov     [ebp-$04], ecx
006001C9   8BD8                   mov     ebx, eax
006001CB   33C0                   xor     eax, eax
006001CD   55                     push    ebp

* Possible String Reference to: '�A����^[��]�'
|
006001CE   6828036000             push    $00600328

***** TRY
|
006001D3   64FF30                 push    dword ptr fs:[eax]
006001D6   648920                 mov     fs:[eax], esp

* Reference to pointer to GlobalVar_0061DF08
|
006001D9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
006001DE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
006001E0   8B8034050000           mov     eax, [eax+$0534]
006001E6   8B10                   mov     edx, [eax]
006001E8   FF5258                 call    dword ptr [edx+$58]
006001EB   8BF0                   mov     esi, eax
006001ED   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
006001EF   E8A877FDFF             call    005D799C

* Reference to control TForm1.TabSheet2 : TTabSheet
|
006001F4   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
006001FA   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
00600200   E8B3FBE7FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
00600205   8B831C060000           mov     eax, [ebx+$061C]
0060020B   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
0060020D   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
00600210   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00600215   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
00600217   8B405C                 mov     eax, [eax+$5C]
0060021A   8B10                   mov     edx, [eax]
0060021C   FF924C010000           call    dword ptr [edx+$014C]
00600222   83F802                 cmp     eax, +$02
00600225   7D0F                   jnl     00600236

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
00600227   B840036000             mov     eax, $00600340

* Reference to: Dialogs.ShowMessage(AnsiString);
|
0060022C   E8B355E4FF             call    004457E4
00600231   E9DC000000             jmp     00600312
00600236   8D45FC                 lea     eax, [ebp-$04]
00600239   50                     push    eax
0060023A   33C9                   xor     ecx, ecx
0060023C   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid2 : TStringGrid
|
00600241   8B8374030000           mov     eax, [ebx+$0374]

* Reference to: Grids.TStringGrid.GetCells(TStringGrid;Integer;Integer):AnsiString;
|
00600247   E840F8EDFF             call    004DFA8C
0060024C   837DFC00               cmp     dword ptr [ebp-$04], +$00
00600250   750F                   jnz     00600261

* Possible String Reference to: 'Keine Nachfahren gefunden.'
|
00600252   B860036000             mov     eax, $00600360

* Reference to: Dialogs.ShowMessage(AnsiString);
|
00600257   E88855E4FF             call    004457E4
0060025C   E9B1000000             jmp     00600312
00600261   33C0                   xor     eax, eax

* Reference to GlobalVar_02535948
|
00600263   A348595302             mov     dword ptr [$02535948], eax
00600268   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Nachgr1'
|
0060026D   BA84036000             mov     edx, $00600384

* Reference to: System.@LStrAsg(void;void;void;void);
|
00600272   E84549E0FF             call    00404BBC

* Reference to pointer to GlobalVar_0061DFB4
|
00600277   A1C8C26100             mov     eax, dword ptr [$0061C2C8]
0060027C   8B00                   mov     eax, [eax]

* Reference to pointer to GlobalVar_0061E0FC
|
0060027E   8B15B8C16100           mov     edx, [$0061C1B8]
00600284   8902                   mov     [edx], eax

* Reference to pointer to GlobalVar_0061E0F8
|
00600286   A1B0C96100             mov     eax, dword ptr [$0061C9B0]
0060028B   8B00                   mov     eax, [eax]

* Possible String Reference to: 'Nachfahren-Grafik I'
|
0060028D   BA94036000             mov     edx, $00600394

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
00600292   E89DC7E4FF             call    0044CA34

* Reference to pointer to GlobalVar_0061E0F8
|
00600297   A1B0C96100             mov     eax, dword ptr [$0061C9B0]
0060029C   8B00                   mov     eax, [eax]
0060029E   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061E0F8.OFFS_00E8
|
006002A0   FF92E8000000           call    dword ptr [edx+$00E8]
006002A6   B858595302             mov     eax, $02535958
006002AB   BAB0036000             mov     edx, $006003B0

* Reference to: System.@LStrAsg(void;void;void;void);
|
006002B0   E80749E0FF             call    00404BBC

* Reference to pointer to GlobalVar_0061E0F8
|
006002B5   A1B0C96100             mov     eax, dword ptr [$0061C9B0]
006002BA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0F8.OFFS_0324
|
006002BC   8B8024030000           mov     eax, [eax+$0324]

* Reference to: Spin.TSpinEdit.GetValue(TSpinEdit):Longint;
|
006002C2   E8A94EF3FF             call    00535170
006002C7   48                     dec     eax
006002C8   7C09                   jl      006002D3
006002CA   833D4859530201         cmp     dword ptr [$02535948], +$01
006002D1   751D                   jnz     006002F0

* Reference to pointer to GlobalVar_0061E0F8
|
006002D3   A1B0C96100             mov     eax, dword ptr [$0061C9B0]
006002D8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0F8.OFFS_024C
|
006002DA   C7804C02000002000000   mov     dword ptr [eax+$024C], $00000002
006002E4   C7054859530201000000   mov     dword ptr [$02535948], $00000001
006002EE   EB22                   jmp     00600312
006002F0   8975F4                 mov     [ebp-$0C], esi
006002F3   C645F800               mov     byte ptr [ebp-$08], $00
006002F7   8D55F4                 lea     edx, [ebp-$0C]

* Reference to pointer to GlobalVar_0061DF08
|
006002FA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
006002FF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
00600301   8B405C                 mov     eax, [eax+$5C]
00600304   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00600306   E8592FEDFF             call    004D3264
0060030B   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
0060030D   E88A40FDFF             call    005D439C
00600312   33C0                   xor     eax, eax
00600314   5A                     pop     edx
00600315   59                     pop     ecx
00600316   59                     pop     ecx
00600317   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '^[��]�'
|
0060031A   682F036000             push    $0060032F
0060031F   8D45FC                 lea     eax, [ebp-$04]

* Reference to: System.@LStrClr(void;void);
|
00600322   E84148E0FF             call    00404B68
00600327   C3                     ret


* Reference to: System.@HandleFinally;
|
00600328   E99F41E0FF             jmp     004044CC
0060032D   EBF0                   jmp     0060031F

****** END
|
0060032F   5E                     pop     esi
00600330   5B                     pop     ebx
00600331   8BE5                   mov     esp, ebp
00600333   5D                     pop     ebp
00600334   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061DF08; GlobalVar_0061E0F8; GlobalVar_0061E0FC; GlobalVar_0061E10C
Unresolved field offsets: OFFS_005C; OFFS_00E8; OFFS_0538; OFFS_053C
Project calls: TForm1.anzeigen(); TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Dialogs.ShowMessage(AnsiString);; method
    TMenuItem.Click()
Strings/files/dialog text: 'Keine Daten verf�gbar.'; 'Keine Vorfahren gefunden.'; 'Vorfahren-Grafik
    I'; 'Vorgr1'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Grafikalt1Click(Sender : TObject);
begin
(*
00601720   53                     push    ebx
00601721   8BD8                   mov     ebx, eax
00601723   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
00601725   E87262FDFF             call    005D799C

* Reference to control TForm1.TabSheet2 : TTabSheet
|
0060172A   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
00601730   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
00601736   E87DE6E7FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
0060173B   8B831C060000           mov     eax, [ebx+$061C]
00601741   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
00601743   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
00601746   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
0060174B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
0060174D   8B405C                 mov     eax, [eax+$5C]
00601750   8B10                   mov     edx, [eax]
00601752   FF924C010000           call    dword ptr [edx+$014C]
00601758   83F802                 cmp     eax, +$02
0060175B   7D0C                   jnl     00601769

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
0060175D   B8F0176000             mov     eax, $006017F0

* Reference to: Dialogs.ShowMessage(AnsiString);
|
00601762   E87D40E4FF             call    004457E4
00601767   5B                     pop     ebx
00601768   C3                     ret


* Reference to pointer to GlobalVar_0061DF08
|
00601769   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
0060176E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0538
|
00601770   8B8038050000           mov     eax, [eax+$0538]
00601776   8B10                   mov     edx, [eax]
00601778   FF5258                 call    dword ptr [edx+$58]
0060177B   85C0                   test    eax, eax
0060177D   7522                   jnz     006017A1

* Reference to pointer to GlobalVar_0061DF08
|
0060177F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
00601784   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_053C
|
00601786   8B803C050000           mov     eax, [eax+$053C]
0060178C   8B10                   mov     edx, [eax]
0060178E   FF5258                 call    dword ptr [edx+$58]
00601791   85C0                   test    eax, eax
00601793   750C                   jnz     006017A1

* Possible String Reference to: 'Keine Vorfahren gefunden.'
|
00601795   B810186000             mov     eax, $00601810

* Reference to: Dialogs.ShowMessage(AnsiString);
|
0060179A   E84540E4FF             call    004457E4
0060179F   5B                     pop     ebx
006017A0   C3                     ret

006017A1   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Vorgr1'
|
006017A6   BA34186000             mov     edx, $00601834

* Reference to: System.@LStrAsg(void;void;void;void);
|
006017AB   E80C34E0FF             call    00404BBC

* Reference to pointer to GlobalVar_0061E10C
|
006017B0   A1D0C56100             mov     eax, dword ptr [$0061C5D0]
006017B5   8B00                   mov     eax, [eax]

* Reference to pointer to GlobalVar_0061E0FC
|
006017B7   8B15B8C16100           mov     edx, [$0061C1B8]
006017BD   8902                   mov     [edx], eax

* Reference to pointer to GlobalVar_0061E0F8
|
006017BF   A1B0C96100             mov     eax, dword ptr [$0061C9B0]
006017C4   8B00                   mov     eax, [eax]

* Possible String Reference to: 'Vorfahren-Grafik I'
|
006017C6   BA44186000             mov     edx, $00601844

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
006017CB   E864B2E4FF             call    0044CA34

* Reference to pointer to GlobalVar_0061E0F8
|
006017D0   A1B0C96100             mov     eax, dword ptr [$0061C9B0]
006017D5   8B00                   mov     eax, [eax]
006017D7   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061E0F8.OFFS_00E8
|
006017D9   FF92E8000000           call    dword ptr [edx+$00E8]
006017DF   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
006017E1   E8B62BFDFF             call    005D439C
006017E6   5B                     pop     ebx
006017E7   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C
Project calls: TForm1.pspitz()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Dialogs.ShowMessage(AnsiString);; method TMenuItem.Click()
Strings/files/dialog text: 'Keine Daten verf�gbar.'; 'Sppr'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Proband1Click(Sender : TObject);
begin
(*
006018A0   53                     push    ebx
006018A1   56                     push    esi
006018A2   8BF2                   mov     esi, edx
006018A4   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
006018A6   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
006018AC   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
006018B2   E801E5E7FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
006018B7   8B831C060000           mov     eax, [ebx+$061C]
006018BD   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
006018BF   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
006018C2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
006018C7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
006018C9   8B405C                 mov     eax, [eax+$5C]
006018CC   8B10                   mov     edx, [eax]
006018CE   FF924C010000           call    dword ptr [edx+$014C]
006018D4   83F802                 cmp     eax, +$02
006018D7   7D0D                   jnl     006018E6

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
006018D9   B80C196000             mov     eax, $0060190C

* Reference to: Dialogs.ShowMessage(AnsiString);
|
006018DE   E8013FE4FF             call    004457E4
006018E3   5E                     pop     esi
006018E4   5B                     pop     ebx
006018E5   C3                     ret

006018E6   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Sppr'
|
006018EB   BA2C196000             mov     edx, $0060192C

* Reference to: System.@LStrAsg(void;void;void;void);
|
006018F0   E8C732E0FF             call    00404BBC
006018F5   8BD6                   mov     edx, esi
006018F7   8BC3                   mov     eax, ebx

* Reference to : TForm1.pspitz()
|
006018F9   E84235FEFF             call    005E4E40
006018FE   5E                     pop     esi
006018FF   5B                     pop     ebx
00601900   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C
Project calls: TForm1.aspitz()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Dialogs.ShowMessage(AnsiString);; method TMenuItem.Click()
Strings/files/dialog text: 'Keine Daten verf�gbar.'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.allePersonen3Click(Sender : TObject);
begin
(*
00601934   53                     push    ebx
00601935   56                     push    esi
00601936   8BF2                   mov     esi, edx
00601938   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
0060193A   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
00601940   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
00601946   E86DE4E7FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
0060194B   8B831C060000           mov     eax, [ebx+$061C]
00601951   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
00601953   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
00601956   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
0060195B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
0060195D   8B405C                 mov     eax, [eax+$5C]
00601960   8B10                   mov     edx, [eax]
00601962   FF924C010000           call    dword ptr [edx+$014C]
00601968   83F802                 cmp     eax, +$02
0060196B   7D0D                   jnl     0060197A

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
0060196D   B890196000             mov     eax, $00601990

* Reference to: Dialogs.ShowMessage(AnsiString);
|
00601972   E86D3EE4FF             call    004457E4
00601977   5E                     pop     esi
00601978   5B                     pop     ebx
00601979   C3                     ret

0060197A   8BD6                   mov     edx, esi
0060197C   8BC3                   mov     eax, ebx

* Reference to : TForm1.aspitz()
|
0060197E   E88D33FEFF             call    005E4D10
00601983   5E                     pop     esi
00601984   5B                     pop     ebx
00601985   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C
Project calls: TForm1.basahnen()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Dialogs.ShowMessage(AnsiString);; method TMenuItem.Click()
Strings/files/dialog text: 'Keine Daten verf�gbar.'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Basisahnen1Click(Sender : TObject);
begin
(*
006019A8   53                     push    ebx
006019A9   56                     push    esi
006019AA   8BF2                   mov     esi, edx
006019AC   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
006019AE   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
006019B4   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
006019BA   E8F9E3E7FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
006019BF   8B831C060000           mov     eax, [ebx+$061C]
006019C5   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
006019C7   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
006019CA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
006019CF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
006019D1   8B405C                 mov     eax, [eax+$5C]
006019D4   8B10                   mov     edx, [eax]
006019D6   FF924C010000           call    dword ptr [edx+$014C]
006019DC   83F802                 cmp     eax, +$02
006019DF   7D0D                   jnl     006019EE

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
006019E1   B8041A6000             mov     eax, $00601A04

* Reference to: Dialogs.ShowMessage(AnsiString);
|
006019E6   E8F93DE4FF             call    004457E4
006019EB   5E                     pop     esi
006019EC   5B                     pop     ebx
006019ED   C3                     ret

006019EE   8BD6                   mov     edx, esi
006019F0   8BC3                   mov     eax, ebx

* Reference to : TForm1.basahnen()
|
006019F2   E8A131FEFF             call    005E4B98
006019F7   5E                     pop     esi
006019F8   5B                     pop     ebx
006019F9   C3                     ret

*)
end;

