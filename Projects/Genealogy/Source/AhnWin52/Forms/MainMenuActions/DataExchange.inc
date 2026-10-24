{ TForm1 menu-area implementations: DataExchange; LFM-bound method names remain on TForm1. }

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Database/provider: DB.TDataSet.Open(TDataSet);
Global state: GlobalVar_0061DF08; GlobalVar_025358DC
Unresolved field offsets: OFFS_0148; OFFS_0158
Project calls: TForm1.speich1(); TForm20.BitBtn1Click()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Dialogs.Proc_004456EC; method TMenuItem.Click()
Strings/files/dialog text: 'Bestehende FOKO-Datei wird �berschr
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.FOKODateierstellen1Click(Sender : TObject);
begin
(*
005FB954   53                     push    ebx
005FB955   56                     push    esi
005FB956   8BF2                   mov     esi, edx
005FB958   8BD8                   mov     ebx, eax
005FB95A   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005FB95C   E83BC0FDFF             call    005D799C

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FB961   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FB967   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FB96D   E84644E8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005FB972   8B831C060000           mov     eax, [ebx+$061C]
005FB978   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FB97A   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
005FB97D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FB982   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0158
|
005FB984   8B8058010000           mov     eax, [eax+$0158]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FB98A   E8F912EBFF             call    004ACC88
005FB98F   6A00                   push    $00
005FB991   668B0DCCB95F00         mov     cx, word ptr [$005FB9CC]
005FB998   B203                   mov     dl, $03

* Possible String Reference to: 'Bestehende FOKO-Datei wird �berschr
|                                ieben. Dennoch weiter ?'
|
005FB99A   B8D8B95F00             mov     eax, $005FB9D8

* Reference to: Dialogs.Proc_004456EC
|
005FB99F   E8489DE4FF             call    004456EC
005FB9A4   83F806                 cmp     eax, +$06
005FB9A7   7520                   jnz     005FB9C9

* Reference to pointer to GlobalVar_0061DF08
|
005FB9A9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FB9AE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0148
|
005FB9B0   8B8048010000           mov     eax, [eax+$0148]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FB9B6   E8CD12EBFF             call    004ACC88

* Reference to pointer to GlobalVar_025358DC
|
005FB9BB   A198C16100             mov     eax, dword ptr [$0061C198]
005FB9C0   8B00                   mov     eax, [eax]
005FB9C2   8BD6                   mov     edx, esi

* Reference to : TForm20.BitBtn1Click()
|
005FB9C4   E8F30CFDFF             call    005CC6BC
005FB9C9   5E                     pop     esi
005FB9CA   5B                     pop     ebx
005FB9CB   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Database/provider: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
Global state: GlobalVar_0061DF08; GlobalVar_0061DFF4
Unresolved field offsets: OFFS_005C; OFFS_009C
Project calls: TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Dialogs.ShowMessage(AnsiString);; Forms.TCustomForm.Show(TCustomForm);
Strings/files/dialog text: 'Keine Daten verf�gbar.'; 'Tiny'; 'Tiny-Tafel'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.inyTafelerstellen1Click(Sender : TObject);
begin
(*
005FBA14   53                     push    ebx
005FBA15   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FBA17   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FBA1D   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FBA23   E89043E8FF             call    0047FDB8

* Reference to pointer to GlobalVar_0061DF08
|
005FBA28   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FBA2D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FBA2F   8B405C                 mov     eax, [eax+$5C]
005FBA32   8B10                   mov     edx, [eax]
005FBA34   FF924C010000           call    dword ptr [edx+$014C]
005FBA3A   83F802                 cmp     eax, +$02
005FBA3D   7D0C                   jnl     005FBA4B

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005FBA3F   B8A4BA5F00             mov     eax, $005FBAA4

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FBA44   E89B9DE4FF             call    004457E4
005FBA49   5B                     pop     ebx
005FBA4A   C3                     ret

005FBA4B   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005FBA4D   E84ABFFDFF             call    005D799C
005FBA52   B830595302             mov     eax, $02535930

* Possible String Reference to: 'Tiny-Tafel'
|
005FBA57   BAC4BA5F00             mov     edx, $005FBAC4

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FBA5C   E85B91E0FF             call    00404BBC
005FBA61   B834595302             mov     eax, $02535934

* Reference to: System.@LStrClr(void;void);
|
005FBA66   E8FD90E0FF             call    00404B68
005FBA6B   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Tiny'
|
005FBA70   BAD8BA5F00             mov     edx, $005FBAD8

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FBA75   E84291E0FF             call    00404BBC

* Reference to pointer to GlobalVar_0061DFF4
|
005FBA7A   A1C8C76100             mov     eax, dword ptr [$0061C7C8]
005FBA7F   8B00                   mov     eax, [eax]

* Reference to: Forms.TCustomForm.Show(TCustomForm);
|
005FBA81   E8B6E1E6FF             call    00469C3C

* Reference to pointer to GlobalVar_0061DF08
|
005FBA86   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FBA8B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005FBA8D   8B809C000000           mov     eax, [eax+$009C]
005FBA93   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FBA95   E8C270EDFF             call    004D2B5C
005FBA9A   5B                     pop     ebx
005FBA9B   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Database/provider: DB.TDataSet.Open(TDataSet);
Global state: GlobalVar_0061DF08; GlobalVar_025358D4
Unresolved field offsets: OFFS_00E8; OFFS_0158
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Dialogs.ShowMessage(AnsiString);
Strings/files/dialog text: 'Nichts zum Editieren gefunden.'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.FOKODateieditieren1Click(Sender : TObject);
begin
(*
005FBAE0   53                     push    ebx
005FBAE1   8BD8                   mov     ebx, eax

* Reference to pointer to GlobalVar_0061DF08
|
005FBAE3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FBAE8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0158
|
005FBAEA   8B8058010000           mov     eax, [eax+$0158]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FBAF0   E89311EBFF             call    004ACC88

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FBAF5   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FBAFB   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FBB01   E8B242E8FF             call    0047FDB8

* Reference to pointer to GlobalVar_0061DF08
|
005FBB06   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FBB0B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0158
|
005FBB0D   8B8058010000           mov     eax, [eax+$0158]
005FBB13   8B10                   mov     edx, [eax]
005FBB15   FF924C010000           call    dword ptr [edx+$014C]
005FBB1B   48                     dec     eax
005FBB1C   7E11                   jle     005FBB2F

* Reference to pointer to GlobalVar_025358D4
|
005FBB1E   A1ACC96100             mov     eax, dword ptr [$0061C9AC]
005FBB23   8B00                   mov     eax, [eax]
005FBB25   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_025358D4.OFFS_00E8
|
005FBB27   FF92E8000000           call    dword ptr [edx+$00E8]
005FBB2D   5B                     pop     ebx
005FBB2E   C3                     ret


* Possible String Reference to: 'Nichts zum Editieren gefunden.'
|
005FBB2F   B844BB5F00             mov     eax, $005FBB44

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FBB34   E8AB9CE4FF             call    004457E4
005FBB39   5B                     pop     ebx
005FBB3A   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.Label18 (TLabel); TForm1.Label19 (TLabel); TForm1.neu1
    (TMenuItem); TForm1.OpenDialog1 (TOpenDialog); TForm1.PageControl1 (TPageControl);
    TForm1.TabSheet2 (TTabSheet); Form1; TApplication instance
Database/provider: DB.TDataSet.Close(TDataSet);; DB.TDataSet.Edit(TDataSet);;
    DB.TDataSet.First(TDataSet);; DB.TDataSet.Last(TDataSet);; DB.TDataSet.Open(TDataSet);;
    DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.EmptyTable(TTable);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_025353D8; GlobalVar_0253586C; GlobalVar_02535940;
    GlobalVar_02535944; GlobalVar_02535B64
Unresolved field offsets: OFFS_005C; OFFS_0074; OFFS_0080; OFFS_00C8; OFFS_00CC; OFFS_01DC;
    OFFS_0530; OFFS_0534
Project calls: TForm1.anzeigen(); TForm1.Datenlschen1Click(); TForm1.listen_akt(); TForm1.speich1();
    TForm1.tabdisab(); TForm1.tabenab(); TForm3.gedein2(); TForm3.gedein_5()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.Refresh(TControl);; Controls.TControl.SetText(TControl;TCaption);;
    Controls.TControl.SetVisible(TControl;Boolean);;
    Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;;
    Forms.TApplication.MessageBox(TApplication;PChar;PChar;Longint):Integer;;
    Forms.TScreen.SetCursor(TScreen;TCursor);; Menus.TMenuItem.SetEnabled(TMenuItem;Boolean);;
    method TMenuItem.Click(); method TOpenDialog.Execute(); TScreen instance
Strings/files/dialog text: '_^[��]�'; 'Bestehende Daten �berschreiben ?'; 'Gedcom-Datei einlesen';
    'Gedcom-Dateien (*.ged)|*.ged'; 'Listen aktual.'; 'ort_'; 'tit'; '�E������<�a'; '�h(������<�a';
    '��)����_^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.GedcomDateieinlesen1Click(Sender : TObject);
begin
(*
005FC204   55                     push    ebp
005FC205   8BEC                   mov     ebp, esp
005FC207   83C4F0                 add     esp, -$10
005FC20A   53                     push    ebx
005FC20B   56                     push    esi
005FC20C   57                     push    edi
005FC20D   33C9                   xor     ecx, ecx
005FC20F   894DF0                 mov     [ebp-$10], ecx
005FC212   8BF2                   mov     esi, edx
005FC214   8945FC                 mov     [ebp-$04], eax
005FC217   33C0                   xor     eax, eax
005FC219   55                     push    ebp

* Possible String Reference to: '��}����_^[��]�'
|
005FC21A   68ECC65F00             push    $005FC6EC

***** TRY
|
005FC21F   64FF30                 push    dword ptr fs:[eax]
005FC222   648920                 mov     fs:[eax], esp

* Reference to pointer to GlobalVar_0061DF08
|
005FC225   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC22A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FC22C   8B8034050000           mov     eax, [eax+$0534]
005FC232   8B10                   mov     edx, [eax]
005FC234   FF5258                 call    dword ptr [edx+$58]
005FC237   8BD8                   mov     ebx, eax

* Reference to Form1
|
005FC239   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FC23C   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005FC242   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FC245   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FC24B   E8683BE8FF             call    0047FDB8

* Reference to Form1
|
005FC250   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.aus1 : TMenuItem
|
005FC253   8B801C060000           mov     eax, [eax+$061C]
005FC259   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FC25B   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0253586C
|
005FC25E   A118CB6100             mov     eax, dword ptr [$0061CB18]
005FC263   C70002000000           mov     dword ptr [eax], $00000002

* Reference to pointer to GlobalVar_025353D8
|
005FC269   A168C86100             mov     eax, dword ptr [$0061C868]
005FC26E   8B00                   mov     eax, [eax]

* Reference to : TForm3.gedein_5()
|
005FC270   E8473AFCFF             call    005BFCBC
005FC275   895DF4                 mov     [ebp-$0C], ebx
005FC278   C645F800               mov     byte ptr [ebp-$08], $00
005FC27C   8D55F4                 lea     edx, [ebp-$0C]

* Reference to pointer to GlobalVar_0061DF08
|
005FC27F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC284   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FC286   8B405C                 mov     eax, [eax+$5C]
005FC289   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FC28B   E8D46FEDFF             call    004D3264

* Reference to pointer to GlobalVar_0253586C
|
005FC290   A118CB6100             mov     eax, dword ptr [$0061CB18]
005FC295   833802                 cmp     dword ptr [eax], +$02
005FC298   7408                   jz      005FC2A2

* Reference to Form1
|
005FC29A   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.listen_akt()
|
005FC29D   E8B23CFFFF             call    005EFF54

* Reference to pointer to GlobalVar_0061DF08
|
005FC2A2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC2A7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FC2A9   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005FC2AC   E8232FEBFF             call    004AF1D4

* Reference to Form1
|
005FC2B1   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.anzeigen()
|
005FC2B4   E8E380FDFF             call    005D439C
005FC2B9   E918040000             jmp     005FC6D6
005FC2BE   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B64
|
005FC2C0   A3645B5302             mov     dword ptr [$02535B64], eax

* Reference to pointer to GlobalVar_0061DF08
|
005FC2C5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC2CA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FC2CC   8B8034050000           mov     eax, [eax+$0534]
005FC2D2   8B10                   mov     edx, [eax]
005FC2D4   FF5258                 call    dword ptr [edx+$58]
005FC2D7   8BD8                   mov     ebx, eax

* Reference to pointer to GlobalVar_0061DF08
|
005FC2D9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC2DE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FC2E0   8B405C                 mov     eax, [eax+$5C]
005FC2E3   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FC2E5   E87268EDFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005FC2EA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC2EF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FC2F1   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Last(TDataSet);
|
005FC2F4   E8B32FEBFF             call    004AF2AC

* Reference to pointer to GlobalVar_0061DF08
|
005FC2F9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC2FE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FC300   8B8034050000           mov     eax, [eax+$0534]
005FC306   8B10                   mov     edx, [eax]
005FC308   FF5258                 call    dword ptr [edx+$58]

* Reference to GlobalVar_02535944
|
005FC30B   A344595302             mov     dword ptr [$02535944], eax
005FC310   895DF4                 mov     [ebp-$0C], ebx
005FC313   C645F800               mov     byte ptr [ebp-$08], $00
005FC317   8D55F4                 lea     edx, [ebp-$0C]

* Reference to pointer to GlobalVar_0061DF08
|
005FC31A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC31F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FC321   8B405C                 mov     eax, [eax+$5C]
005FC324   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FC326   E8396FEDFF             call    004D3264

* Reference to Form1
|
005FC32B   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.speich1()
|
005FC32E   E869B6FDFF             call    005D799C

* Reference to Form1
|
005FC333   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.OpenDialog1 : TOpenDialog
|
005FC336   8B8014040000           mov     eax, [eax+$0414]
005FC33C   83C060                 add     eax, +$60

* Possible String Reference to: 'Gedcom-Dateien (*.ged)|*.ged'
|
005FC33F   BA04C75F00             mov     edx, $005FC704

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FC344   E87388E0FF             call    00404BBC

* Reference to Form1
|
005FC349   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.OpenDialog1 : TOpenDialog
|
005FC34C   8B8014040000           mov     eax, [eax+$0414]
005FC352   8B10                   mov     edx, [eax]

* Reference to method TOpenDialog.Execute()
|
005FC354   FF523C                 call    dword ptr [edx+$3C]
005FC357   84C0                   test    al, al
005FC359   0F840E030000           jz      005FC66D
005FC35F   8D55F0                 lea     edx, [ebp-$10]

* Reference to Form1
|
005FC362   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.OpenDialog1 : TOpenDialog
|
005FC365   8B8014040000           mov     eax, [eax+$0414]

* Reference to: Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;
|
005FC36B   E8C07AE4FF             call    00443E30
005FC370   837DF000               cmp     dword ptr [ebp-$10], +$00
005FC374   0F84F3020000           jz      005FC66D
005FC37A   33C0                   xor     eax, eax
005FC37C   55                     push    ebp
005FC37D   68ADC55F00             push    $005FC5AD

***** TRY
|
005FC382   64FF30                 push    dword ptr fs:[eax]
005FC385   648920                 mov     fs:[eax], esp
005FC388   33C0                   xor     eax, eax

* Reference to GlobalVar_02535940
|
005FC38A   A340595302             mov     dword ptr [$02535940], eax

* Reference to pointer to GlobalVar_0061DF08
|
005FC38F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC394   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FC396   8B8034050000           mov     eax, [eax+$0534]
005FC39C   8B10                   mov     edx, [eax]
005FC39E   FF5258                 call    dword ptr [edx+$58]
005FC3A1   85C0                   test    eax, eax
005FC3A3   0F8EBA010000           jle     005FC563
005FC3A9   6A04                   push    $04

* Possible String Reference to: 'Gedcom-Datei einlesen'
|
005FC3AB   B924C75F00             mov     ecx, $005FC724

* Possible String Reference to: 'Bestehende Daten �berschreiben ?'
|
005FC3B0   BA3CC75F00             mov     edx, $005FC73C

* Reference to TApplication instance
|
005FC3B5   A10CC96100             mov     eax, dword ptr [$0061C90C]
005FC3BA   8B00                   mov     eax, [eax]

* Reference to: Forms.TApplication.MessageBox(TApplication;PChar;PChar;Longint):Integer;
|
005FC3BC   E80F0FE7FF             call    0046D2D0
005FC3C1   83F806                 cmp     eax, +$06
005FC3C4   0F8599010000           jnz     005FC563
005FC3CA   8BD6                   mov     edx, esi

* Reference to Form1
|
005FC3CC   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.Datenlschen1Click()
|
005FC3CF   E8705DFEFF             call    005E2144
005FC3D4   833D645B530201         cmp     dword ptr [$02535B64], +$01
005FC3DB   7533                   jnz     005FC410

* Reference to TScreen instance
|
005FC3DD   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005FC3E2   8B00                   mov     eax, [eax]
005FC3E4   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005FC3E6   E8B1EDE6FF             call    0046B19C

* Reference to Form1
|
005FC3EB   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005FC3EE   8B8000040000           mov     eax, [eax+$0400]
005FC3F4   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FC3F6   E82905E5FF             call    0044C924

* Reference to Form1
|
005FC3FB   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005FC3FE   8B8004040000           mov     eax, [eax+$0404]
005FC404   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FC406   E81905E5FF             call    0044C924

* Reference to: System.@TryFinallyExit;
|
005FC40B   E86482E0FF             call    00404674
005FC410   33C0                   xor     eax, eax

* Reference to GlobalVar_02535944
|
005FC412   A344595302             mov     dword ptr [$02535944], eax

* Reference to Form1
|
005FC417   A108595302             mov     eax, dword ptr [$02535908]

* Reference to: Controls.TControl.Refresh(TControl);
|
005FC41C   E8670BE5FF             call    0044CF88

* Reference to pointer to GlobalVar_0061DF08
|
005FC421   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC426   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0074
|
005FC428   8B4074                 mov     eax, [eax+$74]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FC42B   E85808EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FC430   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC435   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0074
|
005FC437   8B4074                 mov     eax, [eax+$74]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005FC43A   E85508EBFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005FC43F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC444   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0074
|
005FC446   8B4074                 mov     eax, [eax+$74]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005FC449   E88E7BEDFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005FC44E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC453   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0074
|
005FC455   8B4074                 mov     eax, [eax+$74]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FC458   E82B08EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FC45D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC462   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
005FC464   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FC46A   E81908EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FC46F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC474   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
005FC476   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005FC47C   E81308EBFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005FC481   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC486   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
005FC488   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005FC48E   E8497BEDFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005FC493   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC498   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
005FC49A   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FC4A0   E8E307EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FC4A5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC4AA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005FC4AC   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FC4B2   E8D107EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FC4B7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC4BC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005FC4BE   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005FC4C4   E8CB07EBFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005FC4C9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC4CE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005FC4D0   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005FC4D6   E8017BEDFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005FC4DB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC4E0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005FC4E2   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FC4E8   E89B07EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FC4ED   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC4F2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005FC4F4   8B80CC000000           mov     eax, [eax+$00CC]

* Possible String Reference to: 'ort_'
|
005FC4FA   BA68C75F00             mov     edx, $005FC768

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FC4FF   E85866EDFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005FC504   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC509   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0530
|
005FC50B   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FC511   E87207EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FC516   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC51B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0530
|
005FC51D   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005FC523   E86C07EBFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005FC528   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC52D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0530
|
005FC52F   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005FC535   E8A27AEDFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005FC53A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC53F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0530
|
005FC541   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FC547   E83C07EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FC54C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC551   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0530
|
005FC553   8B8030050000           mov     eax, [eax+$0530]

* Possible String Reference to: 'tit'
|
005FC559   BA78C75F00             mov     edx, $005FC778

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FC55E   E8F965EDFF             call    004D2B5C
005FC563   A144595302             mov     eax, dword ptr [$02535944]

* Reference to GlobalVar_02535940
|
005FC568   A340595302             mov     dword ptr [$02535940], eax

* Reference to Form1
|
005FC56D   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabdisab()
|
005FC570   E8BFC2FDFF             call    005D8834

* Reference to TScreen instance
|
005FC575   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005FC57A   8B00                   mov     eax, [eax]
005FC57C   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005FC580   E817ECE6FF             call    0046B19C

* Reference to pointer to GlobalVar_025353D8
|
005FC585   A168C86100             mov     eax, dword ptr [$0061C868]
005FC58A   8B00                   mov     eax, [eax]

* Reference to : TForm3.gedein2()
|
005FC58C   E8E3A3F9FF             call    00596974
005FC591   33C0                   xor     eax, eax
005FC593   5A                     pop     edx
005FC594   59                     pop     ecx
005FC595   59                     pop     ecx
005FC596   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '�E������<�a'
|
005FC599   68B4C55F00             push    $005FC5B4

* Reference to TScreen instance
|
005FC59E   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005FC5A3   8B00                   mov     eax, [eax]
005FC5A5   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005FC5A7   E8F0EBE6FF             call    0046B19C
005FC5AC   C3                     ret


* Reference to: System.@HandleFinally;
|
005FC5AD   E91A7FE0FF             jmp     004044CC
005FC5B2   EBEA                   jmp     005FC59E

****** END
|
* Reference to Form1
|
005FC5B4   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabenab()
|
005FC5B7   E89CC2FDFF             call    005D8858

* Reference to pointer to GlobalVar_0061DF08
|
005FC5BC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC5C1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FC5C3   8B8034050000           mov     eax, [eax+$0534]
005FC5C9   8B10                   mov     edx, [eax]
005FC5CB   FF5258                 call    dword ptr [edx+$58]
005FC5CE   85C0                   test    eax, eax
005FC5D0   7E10                   jle     005FC5E2

* Reference to Form1
|
005FC5D2   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.neu1 : TMenuItem
|
005FC5D5   8B80FC020000           mov     eax, [eax+$02FC]
005FC5DB   B201                   mov     dl, $01

* Reference to: Menus.TMenuItem.SetEnabled(TMenuItem;Boolean);
|
005FC5DD   E8EE21E6FF             call    0045E7D0

* Reference to Form1
|
005FC5E2   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005FC5E5   8B8000040000           mov     eax, [eax+$0400]
005FC5EB   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FC5ED   E83203E5FF             call    0044C924

* Reference to Form1
|
005FC5F2   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005FC5F5   8B8004040000           mov     eax, [eax+$0404]

* Possible String Reference to: 'Listen aktual.'
|
005FC5FB   BA84C75F00             mov     edx, $005FC784

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005FC600   E82F04E5FF             call    0044CA34

* Reference to Form1
|
005FC605   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.listen_akt()
|
005FC608   E84739FFFF             call    005EFF54

* Reference to Form1
|
005FC60D   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005FC610   8B8004040000           mov     eax, [eax+$0404]
005FC616   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FC618   E80703E5FF             call    0044C924

* Reference to Form1
|
005FC61D   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.anzeigen()
|
005FC620   E8777DFDFF             call    005D439C

* Reference to pointer to GlobalVar_0061DF08
|
005FC625   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC62A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01DC
|
005FC62C   8B80DC010000           mov     eax, [eax+$01DC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FC632   E85106EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FC637   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC63C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01DC
|
005FC63E   8B80DC010000           mov     eax, [eax+$01DC]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005FC644   E84B06EBFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005FC649   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC64E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01DC
|
005FC650   8B80DC010000           mov     eax, [eax+$01DC]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005FC656   E88179EDFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005FC65B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC660   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01DC
|
005FC662   8B80DC010000           mov     eax, [eax+$01DC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FC668   E81B06EBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FC66D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC672   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FC674   8B405C                 mov     eax, [eax+$5C]
005FC677   8A909D000000           mov     dl, byte ptr [eax+$009D]
005FC67D   80C2FE                 add     dl, $FE
005FC680   80EA02                 sub     dl, $02
005FC683   7330                   jnb     005FC6B5
005FC685   33D2                   xor     edx, edx
005FC687   55                     push    ebp

* Possible String Reference to: '�h{������<�a'
|
005FC688   68ABC65F00             push    $005FC6AB

***** TRY
|
005FC68D   64FF32                 push    dword ptr fs:[edx]
005FC690   648922                 mov     fs:[edx], esp

* Reference to pointer to GlobalVar_0061DF08
|
005FC693   8B153CCC6100           mov     edx, [$0061CC3C]
005FC699   8B10                   mov     edx, [eax]
005FC69B   FF9248020000           call    dword ptr [edx+$0248]
005FC6A1   33C0                   xor     eax, eax
005FC6A3   5A                     pop     edx
005FC6A4   59                     pop     ecx
005FC6A5   59                     pop     ecx
005FC6A6   648910                 mov     fs:[eax], edx
005FC6A9   EB0A                   jmp     005FC6B5

* Reference to: System.@HandleAnyException;
|
005FC6AB   E9687BE0FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005FC6B0   E88F7FE0FF             call    00404644

****** END
|
* Reference to pointer to GlobalVar_0061DF08
|
005FC6B5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC6BA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FC6BC   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
005FC6BF   E81C2FEBFF             call    004AF5E0

* Reference to pointer to GlobalVar_0061DF08
|
005FC6C4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FC6C9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005FC6CB   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
005FC6D1   E80A2FEBFF             call    004AF5E0
005FC6D6   33C0                   xor     eax, eax
005FC6D8   5A                     pop     edx
005FC6D9   59                     pop     ecx
005FC6DA   59                     pop     ecx
005FC6DB   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005FC6DE   68F3C65F00             push    $005FC6F3
005FC6E3   8D45F0                 lea     eax, [ebp-$10]

* Reference to: System.@LStrClr(void;void);
|
005FC6E6   E87D84E0FF             call    00404B68
005FC6EB   C3                     ret


* Reference to: System.@HandleFinally;
|
005FC6EC   E9DB7DE0FF             jmp     004044CC
005FC6F1   EBF0                   jmp     005FC6E3

****** END
|
005FC6F3   5F                     pop     edi
005FC6F4   5E                     pop     esi
005FC6F5   5B                     pop     ebx
005FC6F6   8BE5                   mov     esp, ebp
005FC6F8   5D                     pop     ebp
005FC6F9   C3                     ret

*)*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Form1
Database/provider: DB.TDataSet.DisableControls(TDataSet);; DB.TDataSet.EnableControls(TDataSet);;
    DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_0061DFFC
Unresolved field offsets: OFFS_00E8; OFFS_014C; OFFS_024C; OFFS_0404; OFFS_44
Project calls: TForm1.anzeigen(); TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Controls.TControl.SetVisible(TControl;Boolean);;
    Dialogs.ShowMessage(AnsiString);
Strings/files/dialog text: '_^[��]�'; 'Datei enth�lt in Name oder Vorname; 'Keine Daten verf�gbar.';
    'Testen'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.GedcomDateischreiben1Click(Sender : TObject);
begin
(*
005FC794   55                     push    ebp
005FC795   8BEC                   mov     ebp, esp
005FC797   33C9                   xor     ecx, ecx
005FC799   51                     push    ecx
005FC79A   51                     push    ecx
005FC79B   51                     push    ecx
005FC79C   51                     push    ecx
005FC79D   51                     push    ecx
005FC79E   51                     push    ecx
005FC79F   51                     push    ecx
005FC7A0   53                     push    ebx
005FC7A1   56                     push    esi
005FC7A2   57                     push    edi
005FC7A3   8BF8                   mov     edi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005FC7A5   8B1D3CCC6100           mov     ebx, [$0061CC3C]
005FC7AB   33C0                   xor     eax, eax
005FC7AD   55                     push    ebp
005FC7AE   68BBC95F00             push    $005FC9BB

***** TRY
|
005FC7B3   64FF30                 push    dword ptr fs:[eax]
005FC7B6   648920                 mov     fs:[eax], esp
005FC7B9   33F6                   xor     esi, esi
005FC7BB   8B9740030000           mov     edx, [edi+$0340]
005FC7C1   8B8738030000           mov     eax, [edi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FC7C7   E8EC35E8FF             call    0047FDB8

* Reference to Form1
|
005FC7CC   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0404
|
005FC7D1   8B8004040000           mov     eax, [eax+$0404]
005FC7D7   B201                   mov     dl, $01

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FC7D9   E84601E5FF             call    0044C924

* Reference to Form1
|
005FC7DE   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0404
|
005FC7E3   8B8004040000           mov     eax, [eax+$0404]

* Possible String Reference to: 'Testen'
|
005FC7E9   BAD4C95F00             mov     edx, $005FC9D4

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005FC7EE   E84102E5FF             call    0044CA34
005FC7F3   8B03                   mov     eax, [ebx]
005FC7F5   8B8034050000           mov     eax, [eax+$0534]
005FC7FB   8B10                   mov     edx, [eax]
005FC7FD   FF5258                 call    dword ptr [edx+$58]
005FC800   8945FC                 mov     [ebp-$04], eax
005FC803   8B03                   mov     eax, [ebx]
005FC805   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.DisableControls(TDataSet);
|
005FC808   E8431FEBFF             call    004AE750
005FC80D   8B03                   mov     eax, [ebx]
005FC80F   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005FC812   E8BD29EBFF             call    004AF1D4
005FC817   E9A4000000             jmp     005FC8C0
005FC81C   8D55F8                 lea     edx, [ebp-$08]
005FC81F   8B03                   mov     eax, [ebx]
005FC821   8B8040050000           mov     eax, [eax+$0540]
005FC827   8B08                   mov     ecx, [eax]
005FC829   FF5160                 call    dword ptr [ecx+$60]
005FC82C   8B55F8                 mov     edx, [ebp-$08]
005FC82F   B8E4C95F00             mov     eax, $005FC9E4

* Reference to: System.@LStrPos;
|
005FC834   E82389E0FF             call    0040515C
005FC839   85C0                   test    eax, eax
005FC83B   7E01                   jle     005FC83E
005FC83D   46                     inc     esi
005FC83E   8D55F4                 lea     edx, [ebp-$0C]
005FC841   8B03                   mov     eax, [ebx]
005FC843   8B8044050000           mov     eax, [eax+$0544]
005FC849   8B08                   mov     ecx, [eax]
005FC84B   FF5160                 call    dword ptr [ecx+$60]
005FC84E   8B55F4                 mov     edx, [ebp-$0C]
005FC851   B8E4C95F00             mov     eax, $005FC9E4

* Reference to: System.@LStrPos;
|
005FC856   E80189E0FF             call    0040515C
005FC85B   85C0                   test    eax, eax
005FC85D   7E01                   jle     005FC860
005FC85F   46                     inc     esi
005FC860   8D55F0                 lea     edx, [ebp-$10]
005FC863   8B03                   mov     eax, [ebx]
005FC865   8B8040050000           mov     eax, [eax+$0540]
005FC86B   8B08                   mov     ecx, [eax]
005FC86D   FF5160                 call    dword ptr [ecx+$60]
005FC870   8B55F0                 mov     edx, [ebp-$10]
005FC873   B8F0C95F00             mov     eax, $005FC9F0

* Reference to: System.@LStrPos;
|
005FC878   E8DF88E0FF             call    0040515C
005FC87D   85C0                   test    eax, eax
005FC87F   7E01                   jle     005FC882
005FC881   46                     inc     esi
005FC882   8D55EC                 lea     edx, [ebp-$14]
005FC885   8B03                   mov     eax, [ebx]
005FC887   8B8044050000           mov     eax, [eax+$0544]
005FC88D   8B08                   mov     ecx, [eax]
005FC88F   FF5160                 call    dword ptr [ecx+$60]
005FC892   8B55EC                 mov     edx, [ebp-$14]
005FC895   B8F0C95F00             mov     eax, $005FC9F0

* Reference to: System.@LStrPos;
|
005FC89A   E8BD88E0FF             call    0040515C
005FC89F   85C0                   test    eax, eax
005FC8A1   7E01                   jle     005FC8A4
005FC8A3   46                     inc     esi
005FC8A4   85F6                   test    esi, esi
005FC8A6   7F2A                   jnle    005FC8D2
005FC8A8   8B03                   mov     eax, [ebx]
005FC8AA   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005FC8AD   E83A2CEBFF             call    004AF4EC
005FC8B2   8B03                   mov     eax, [ebx]
005FC8B4   8B405C                 mov     eax, [eax+$5C]
005FC8B7   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005FC8BE   7512                   jnz     005FC8D2
005FC8C0   8B03                   mov     eax, [ebx]
005FC8C2   8B405C                 mov     eax, [eax+$5C]
005FC8C5   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005FC8CC   0F844AFFFFFF           jz      005FC81C
005FC8D2   8B45FC                 mov     eax, [ebp-$04]
005FC8D5   8945E4                 mov     [ebp-$1C], eax
005FC8D8   C645E800               mov     byte ptr [ebp-$18], $00
005FC8DC   8D55E4                 lea     edx, [ebp-$1C]
005FC8DF   8B03                   mov     eax, [ebx]
005FC8E1   8B405C                 mov     eax, [eax+$5C]
005FC8E4   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FC8E6   E87969EDFF             call    004D3264
005FC8EB   8B03                   mov     eax, [ebx]
005FC8ED   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.EnableControls(TDataSet);
|
005FC8F0   E87B1EEBFF             call    004AE770

* Reference to Form1
|
005FC8F5   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0404
|
005FC8FA   8B8004040000           mov     eax, [eax+$0404]
005FC900   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FC902   E81D00E5FF             call    0044C924
005FC907   85F6                   test    esi, esi
005FC909   7E0F                   jle     005FC91A

* Possible String Reference to: 'Datei enth�lt in Name oder Vorname 
|                                die Zeichen "," oder "/".Bitte Plau
|                                sibilit�tspr�fung laufen lassen und
|                                 diese Zeichen entfernen.'
|
005FC90B   B8FCC95F00             mov     eax, $005FC9FC

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FC910   E8CF8EE4FF             call    004457E4
005FC915   E986000000             jmp     005FC9A0

* Reference to pointer to GlobalVar_0061DFFC
|
005FC91A   A180C76100             mov     eax, dword ptr [$0061C780]
005FC91F   8B00                   mov     eax, [eax]
005FC921   33D2                   xor     edx, edx

* Reference to field GlobalVar_0061DFFC.OFFS_024C
|
005FC923   89904C020000           mov     [eax+$024C], edx
005FC929   8B871C060000           mov     eax, [edi+$061C]
005FC92F   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061DFFC.OFFS_44
|
005FC931   FF5244                 call    dword ptr [edx+$44]
005FC934   8B45FC                 mov     eax, [ebp-$04]
005FC937   8945E4                 mov     [ebp-$1C], eax
005FC93A   C645E800               mov     byte ptr [ebp-$18], $00
005FC93E   8D55E4                 lea     edx, [ebp-$1C]
005FC941   8B03                   mov     eax, [ebx]
005FC943   8B405C                 mov     eax, [eax+$5C]
005FC946   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005FC948   E81769EDFF             call    004D3264
005FC94D   8BC7                   mov     eax, edi

* Reference to : TForm1.anzeigen()
|
005FC94F   E8487AFDFF             call    005D439C
005FC954   8BC7                   mov     eax, edi

* Reference to : TForm1.speich1()
|
005FC956   E841B0FDFF             call    005D799C
005FC95B   8B03                   mov     eax, [ebx]

* Reference to field TForm1.AutoSize : Boolean
|
005FC95D   8B405C                 mov     eax, [eax+$5C]
005FC960   8B10                   mov     edx, [eax]

* Possible reference to virtual method TBoolean.OFFS_014C
|
005FC962   FF924C010000           call    dword ptr [edx+$014C]
005FC968   83F802                 cmp     eax, +$02
005FC96B   7D0C                   jnl     005FC979

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005FC96D   B88CCA5F00             mov     eax, $005FCA8C

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FC972   E86D8EE4FF             call    004457E4
005FC977   EB27                   jmp     005FC9A0

* Reference to pointer to GlobalVar_0061DFFC
|
005FC979   A180C76100             mov     eax, dword ptr [$0061C780]
005FC97E   8B00                   mov     eax, [eax]
005FC980   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061DFFC.OFFS_00E8
|
005FC982   FF92E8000000           call    dword ptr [edx+$00E8]
005FC988   8BC7                   mov     eax, edi

* Reference to : TForm1.anzeigen()
|
005FC98A   E80D7AFDFF             call    005D439C

* Reference to pointer to GlobalVar_0061DFFC
|
005FC98F   A180C76100             mov     eax, dword ptr [$0061C780]
005FC994   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DFFC.OFFS_024C
|
005FC996   C7804C02000002000000   mov     dword ptr [eax+$024C], $00000002
005FC9A0   33C0                   xor     eax, eax
005FC9A2   5A                     pop     edx
005FC9A3   59                     pop     ecx
005FC9A4   59                     pop     ecx
005FC9A5   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005FC9A8   68C2C95F00             push    $005FC9C2
005FC9AD   8D45EC                 lea     eax, [ebp-$14]
005FC9B0   BA04000000             mov     edx, $00000004

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FC9B5   E8D281E0FF             call    00404B8C
005FC9BA   C3                     ret


* Reference to: System.@HandleFinally;
|
005FC9BB   E90C7BE0FF             jmp     004044CC
005FC9C0   EBEB                   jmp     005FC9AD

****** END
|
005FC9C2   5F                     pop     edi
005FC9C3   5E                     pop     esi
005FC9C4   5B                     pop     ebx
005FC9C5   8BE5                   mov     esp, ebp
005FC9C7   5D                     pop     ebp
005FC9C8   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061DF08; GlobalVar_025353D8
Unresolved field offsets: OFFS_005C
Project calls: TForm1.speich1(); TForm3.adrschreib()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Dialogs.ShowMessage(AnsiString);; method TMenuItem.Click()
Strings/files/dialog text: 'Keine Daten verf�gbar.'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Adressendateischreiben1Click(Sender : TObject);
begin
(*
005FCDC8   53                     push    ebx
005FCDC9   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FCDCB   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FCDD1   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FCDD7   E8DC2FE8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005FCDDC   8B831C060000           mov     eax, [ebx+$061C]
005FCDE2   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FCDE4   FF5244                 call    dword ptr [edx+$44]
005FCDE7   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005FCDE9   E8AEABFDFF             call    005D799C

* Reference to pointer to GlobalVar_0061DF08
|
005FCDEE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FCDF3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FCDF5   8B405C                 mov     eax, [eax+$5C]
005FCDF8   8B10                   mov     edx, [eax]
005FCDFA   FF924C010000           call    dword ptr [edx+$014C]
005FCE00   83F802                 cmp     eax, +$02
005FCE03   7D0C                   jnl     005FCE11

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005FCE05   B828CE5F00             mov     eax, $005FCE28

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005FCE0A   E8D589E4FF             call    004457E4
005FCE0F   5B                     pop     ebx
005FCE10   C3                     ret


* Reference to pointer to GlobalVar_025353D8
|
005FCE11   A168C86100             mov     eax, dword ptr [$0061C868]
005FCE16   8B00                   mov     eax, [eax]

* Reference to : TForm3.adrschreib()
|
005FCE18   E89F6CFBFF             call    005B3ABC
005FCE1D   5B                     pop     ebx
005FCE1E   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.Label10 (TLabel); TForm1.Label11 (TLabel);
    TForm1.OpenDialog1 (TOpenDialog); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2
    (TTabSheet); Form1; TApplication instance
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Last(TDataSet);;
    DB.TDataSet.Open(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
Global state: GlobalVar_0061DF08; GlobalVar_025353D8; GlobalVar_02535940; GlobalVar_02535944
Unresolved field offsets: OFFS_005C; OFFS_0074; OFFS_0080; OFFS_0534
Project calls: method TForm1.Invalidate(); TForm1.anzeigen(); TForm1.Datenlschen1Click();
    TForm1.speich1(); TForm1.tabenab(); TForm3.ahndosein()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetVisible(TControl;Boolean);;
    Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;;
    Forms.TApplication.MessageBox(TApplication;PChar;PChar;Longint):Integer;;
    Forms.TScreen.SetCursor(TScreen;TCursor);; method TMenuItem.Click(); method
    TOpenDialog.Execute(); MMSystem.mci_TMSF_Frame(Longint):Byte;; TScreen instance
Strings/files/dialog text: '^[��]�'; 'AHNEN DOS einlesen'; 'Bestehende Daten �berschreiben ?';
    '�s����^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.AHNENDOSeinlesen1Click(Sender : TObject);
begin
(*
005FCF08   55                     push    ebp
005FCF09   8BEC                   mov     ebp, esp
005FCF0B   6A00                   push    $00
005FCF0D   6A00                   push    $00
005FCF0F   6A00                   push    $00
005FCF11   53                     push    ebx
005FCF12   56                     push    esi
005FCF13   8BF2                   mov     esi, edx
005FCF15   8945FC                 mov     [ebp-$04], eax
005FCF18   33C0                   xor     eax, eax
005FCF1A   55                     push    ebp

* Possible String Reference to: '�s����^[��]�'
|
005FCF1B   681DD15F00             push    $005FD11D

***** TRY
|
005FCF20   64FF30                 push    dword ptr fs:[eax]
005FCF23   648920                 mov     fs:[eax], esp

* Reference to Form1
|
005FCF26   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.speich1()
|
005FCF29   E86EAAFDFF             call    005D799C

* Reference to Form1
|
005FCF2E   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FCF31   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005FCF37   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FCF3A   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FCF40   E8732EE8FF             call    0047FDB8

* Reference to Form1
|
005FCF45   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.aus1 : TMenuItem
|
005FCF48   8B801C060000           mov     eax, [eax+$061C]
005FCF4E   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FCF50   FF5244                 call    dword ptr [edx+$44]
005FCF53   8D55F8                 lea     edx, [ebp-$08]
005FCF56   33C0                   xor     eax, eax

* Reference to: System.@LGetDir(Byte;String;String);
|
005FCF58   E8D75AE0FF             call    00402A34

* Reference to Form1
|
005FCF5D   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.OpenDialog1 : TOpenDialog
|
005FCF60   8B9814040000           mov     ebx, [eax+$0414]

* Reference to field TOpenDialog.FilterIndex : Integer
|
005FCF66   C7436401000000         mov     dword ptr [ebx+$64], $00000001
005FCF6D   8BC3                   mov     eax, ebx
005FCF6F   8B10                   mov     edx, [eax]

* Reference to method TOpenDialog.Execute()
|
005FCF71   FF523C                 call    dword ptr [edx+$3C]
005FCF74   84C0                   test    al, al
005FCF76   0F8483010000           jz      005FD0FF
005FCF7C   8D55F4                 lea     edx, [ebp-$0C]

* Reference to Form1
|
005FCF7F   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.OpenDialog1 : TOpenDialog
|
005FCF82   8B8014040000           mov     eax, [eax+$0414]

* Reference to: Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;
|
005FCF88   E8A36EE4FF             call    00443E30
005FCF8D   8B45F4                 mov     eax, [ebp-$0C]
005FCF90   BA34D15F00             mov     edx, $005FD134

* Reference to: System.@LStrCmp;
|
005FCF95   E8CA7FE0FF             call    00404F64
005FCF9A   0F865F010000           jbe     005FD0FF

* Reference to TScreen instance
|
005FCFA0   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005FCFA5   8B00                   mov     eax, [eax]
005FCFA7   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005FCFAB   E8ECE1E6FF             call    0046B19C
005FCFB0   33C0                   xor     eax, eax
005FCFB2   55                     push    ebp
005FCFB3   684AD05F00             push    $005FD04A

***** TRY
|
005FCFB8   64FF30                 push    dword ptr fs:[eax]
005FCFBB   648920                 mov     fs:[eax], esp
005FCFBE   33C0                   xor     eax, eax

* Reference to GlobalVar_02535940
|
005FCFC0   A340595302             mov     dword ptr [$02535940], eax

* Reference to pointer to GlobalVar_0061DF08
|
005FCFC5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FCFCA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FCFCC   8B8034050000           mov     eax, [eax+$0534]
005FCFD2   8B10                   mov     edx, [eax]
005FCFD4   FF5258                 call    dword ptr [edx+$58]
005FCFD7   85C0                   test    eax, eax
005FCFD9   7E3D                   jle     005FD018
005FCFDB   6A04                   push    $04

* Possible String Reference to: 'AHNEN DOS einlesen'
|
005FCFDD   B938D15F00             mov     ecx, $005FD138

* Possible String Reference to: 'Bestehende Daten �berschreiben ?'
|
005FCFE2   BA4CD15F00             mov     edx, $005FD14C

* Reference to TApplication instance
|
005FCFE7   A10CC96100             mov     eax, dword ptr [$0061C90C]
005FCFEC   8B00                   mov     eax, [eax]

* Reference to: Forms.TApplication.MessageBox(TApplication;PChar;PChar;Longint):Integer;
|
005FCFEE   E8DD02E7FF             call    0046D2D0
005FCFF3   83F806                 cmp     eax, +$06
005FCFF6   7516                   jnz     005FD00E
005FCFF8   8BD6                   mov     edx, esi

* Reference to Form1
|
005FCFFA   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.Datenlschen1Click()
|
005FCFFD   E84251FEFF             call    005E2144

* Reference to Form1
|
005FD002   A108595302             mov     eax, dword ptr [$02535908]
005FD007   8B10                   mov     edx, [eax]

* Reference to method TForm1.Invalidate()
|
005FD009   FF527C                 call    dword ptr [edx+$7C]
005FD00C   EB0A                   jmp     005FD018
005FD00E   A144595302             mov     eax, dword ptr [$02535944]

* Reference to GlobalVar_02535940
|
005FD013   A340595302             mov     dword ptr [$02535940], eax

* Reference to Form1
|
005FD018   A108595302             mov     eax, dword ptr [$02535908]
005FD01D   8B10                   mov     edx, [eax]

* Reference to method TForm1.Invalidate()
|
005FD01F   FF527C                 call    dword ptr [edx+$7C]

* Reference to pointer to GlobalVar_025353D8
|
005FD022   A168C86100             mov     eax, dword ptr [$0061C868]
005FD027   8B00                   mov     eax, [eax]

* Reference to : TForm3.ahndosein()
|
005FD029   E8EE2BFBFF             call    005AFC1C
005FD02E   33C0                   xor     eax, eax
005FD030   5A                     pop     edx
005FD031   59                     pop     ecx
005FD032   59                     pop     ecx
005FD033   648910                 mov     fs:[eax], edx

****** FINALLY
|
005FD036   6851D05F00             push    $005FD051

* Reference to TScreen instance
|
005FD03B   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005FD040   8B00                   mov     eax, [eax]
005FD042   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005FD044   E853E1E6FF             call    0046B19C
005FD049   C3                     ret


* Reference to: System.@HandleFinally;
|
005FD04A   E97D74E0FF             jmp     004044CC
005FD04F   EBEA                   jmp     005FD03B

****** END
|
* Reference to Form1
|
005FD051   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabenab()
|
005FD054   E8FFB7FDFF             call    005D8858
005FD059   8B45F8                 mov     eax, [ebp-$08]

* Reference to: MMSystem.mci_TMSF_Frame(Longint):Byte;
|
005FD05C   E86359E0FF             call    004029C4

* Reference to Form1
|
005FD061   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label10 : TLabel
|
005FD064   8B8090030000           mov     eax, [eax+$0390]
005FD06A   B201                   mov     dl, $01

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FD06C   E8B3F8E4FF             call    0044C924

* Reference to Form1
|
005FD071   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label11 : TLabel
|
005FD074   8B80A0030000           mov     eax, [eax+$03A0]
005FD07A   B201                   mov     dl, $01

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FD07C   E8A3F8E4FF             call    0044C924

* Reference to pointer to GlobalVar_0061DF08
|
005FD081   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD086   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FD088   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FD08B   E8F8FBEAFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FD090   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD095   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FD097   8B405C                 mov     eax, [eax+$5C]
005FD09A   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FD09C   E8BB5AEDFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005FD0A1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD0A6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FD0A8   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Last(TDataSet);
|
005FD0AB   E8FC21EBFF             call    004AF2AC

* Reference to pointer to GlobalVar_0061DF08
|
005FD0B0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD0B5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FD0B7   8B8034050000           mov     eax, [eax+$0534]
005FD0BD   8B10                   mov     edx, [eax]
005FD0BF   FF5258                 call    dword ptr [edx+$58]

* Reference to GlobalVar_02535944
|
005FD0C2   A344595302             mov     dword ptr [$02535944], eax

* Reference to pointer to GlobalVar_0061DF08
|
005FD0C7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD0CC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FD0CE   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005FD0D1   E8FE20EBFF             call    004AF1D4

* Reference to pointer to GlobalVar_0061DF08
|
005FD0D6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD0DB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0074
|
005FD0DD   8B4074                 mov     eax, [eax+$74]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FD0E0   E8A3FBEAFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FD0E5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD0EA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005FD0EC   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FD0F2   E891FBEAFF             call    004ACC88

* Reference to Form1
|
005FD0F7   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.anzeigen()
|
005FD0FA   E89D72FDFF             call    005D439C
005FD0FF   33C0                   xor     eax, eax
005FD101   5A                     pop     edx
005FD102   59                     pop     ecx
005FD103   59                     pop     ecx
005FD104   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '^[��]�'
|
005FD107   6824D15F00             push    $005FD124
005FD10C   8D45F4                 lea     eax, [ebp-$0C]

* Reference to: System.@LStrClr(void;void);
|
005FD10F   E8547AE0FF             call    00404B68
005FD114   8D45F8                 lea     eax, [ebp-$08]

* Reference to: System.@LStrClr(void;void);
|
005FD117   E84C7AE0FF             call    00404B68
005FD11C   C3                     ret


* Reference to: System.@HandleFinally;
|
005FD11D   E9AA73E0FF             jmp     004044CC
005FD122   EBE8                   jmp     005FD10C

****** END
|
005FD124   5E                     pop     esi
005FD125   5B                     pop     ebx
005FD126   8BE5                   mov     esp, ebp
005FD128   5D                     pop     ebp
005FD129   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.Label10 (TLabel); TForm1.Label11 (TLabel);
    TForm1.OpenDialog1 (TOpenDialog); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2
    (TTabSheet); Form1; TApplication instance
Database/provider: DB.TDataSet.Close(TDataSet);; DB.TDataSet.First(TDataSet);;
    DB.TDataSet.Last(TDataSet);; DB.TDataSet.Open(TDataSet);;
    DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
Global state: GlobalVar_0061DF08; GlobalVar_025353D8; GlobalVar_02535940; GlobalVar_02535944
Unresolved field offsets: OFFS_005C; OFFS_0080; OFFS_0534
Project calls: TForm1.anzeigen(); TForm1.Datenlschen1Click(); TForm1.listen_akt(); TForm1.speich1();
    TForm3.osbein()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.Refresh(TControl);; Controls.TControl.SetVisible(TControl;Boolean);;
    Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;;
    Forms.TApplication.MessageBox(TApplication;PChar;PChar;Longint):Integer;;
    Forms.TScreen.SetCursor(TScreen;TCursor);; method TMenuItem.Click(); method
    TOpenDialog.Execute(); MMSystem.mci_TMSF_Frame(Longint):Byte;; TScreen instance
Strings/files/dialog text: '^[��]�'; 'Bestehende Daten �berschreiben ?'; 'OSB einlesen';
    '�E��W���E��,���<�a'; '�Iq����^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.OSBeinlesen1Click(Sender : TObject);
begin
(*
005FD170   55                     push    ebp
005FD171   8BEC                   mov     ebp, esp
005FD173   6A00                   push    $00
005FD175   6A00                   push    $00
005FD177   6A00                   push    $00
005FD179   53                     push    ebx
005FD17A   56                     push    esi
005FD17B   8BF2                   mov     esi, edx
005FD17D   8945FC                 mov     [ebp-$04], eax
005FD180   33C0                   xor     eax, eax
005FD182   55                     push    ebp

* Possible String Reference to: '�Iq����^[��]�'
|
005FD183   687ED35F00             push    $005FD37E

***** TRY
|
005FD188   64FF30                 push    dword ptr fs:[eax]
005FD18B   648920                 mov     fs:[eax], esp

* Reference to Form1
|
005FD18E   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.speich1()
|
005FD191   E806A8FDFF             call    005D799C

* Reference to Form1
|
005FD196   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FD199   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005FD19F   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FD1A2   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FD1A8   E80B2CE8FF             call    0047FDB8

* Reference to Form1
|
005FD1AD   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.aus1 : TMenuItem
|
005FD1B0   8B801C060000           mov     eax, [eax+$061C]
005FD1B6   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FD1B8   FF5244                 call    dword ptr [edx+$44]
005FD1BB   8D55F8                 lea     edx, [ebp-$08]
005FD1BE   33C0                   xor     eax, eax

* Reference to: System.@LGetDir(Byte;String;String);
|
005FD1C0   E86F58E0FF             call    00402A34

* Reference to Form1
|
005FD1C5   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.OpenDialog1 : TOpenDialog
|
005FD1C8   8B9814040000           mov     ebx, [eax+$0414]

* Reference to field TOpenDialog.FilterIndex : Integer
|
005FD1CE   C7436402000000         mov     dword ptr [ebx+$64], $00000002
005FD1D5   8BC3                   mov     eax, ebx
005FD1D7   8B10                   mov     edx, [eax]

* Reference to method TOpenDialog.Execute()
|
005FD1D9   FF523C                 call    dword ptr [edx+$3C]
005FD1DC   84C0                   test    al, al
005FD1DE   0F847C010000           jz      005FD360
005FD1E4   8D55F4                 lea     edx, [ebp-$0C]

* Reference to Form1
|
005FD1E7   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.OpenDialog1 : TOpenDialog
|
005FD1EA   8B8014040000           mov     eax, [eax+$0414]

* Reference to: Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;
|
005FD1F0   E83B6CE4FF             call    00443E30
005FD1F5   8B45F4                 mov     eax, [ebp-$0C]
005FD1F8   BA94D35F00             mov     edx, $005FD394

* Reference to: System.@LStrCmp;
|
005FD1FD   E8627DE0FF             call    00404F64
005FD202   0F8658010000           jbe     005FD360

* Reference to TScreen instance
|
005FD208   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005FD20D   8B00                   mov     eax, [eax]
005FD20F   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005FD213   E884DFE6FF             call    0046B19C
005FD218   33C0                   xor     eax, eax
005FD21A   55                     push    ebp
005FD21B   68A8D25F00             push    $005FD2A8

***** TRY
|
005FD220   64FF30                 push    dword ptr fs:[eax]
005FD223   648920                 mov     fs:[eax], esp
005FD226   33C0                   xor     eax, eax

* Reference to GlobalVar_02535940
|
005FD228   A340595302             mov     dword ptr [$02535940], eax

* Reference to pointer to GlobalVar_0061DF08
|
005FD22D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD232   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FD234   8B8034050000           mov     eax, [eax+$0534]
005FD23A   8B10                   mov     edx, [eax]
005FD23C   FF5258                 call    dword ptr [edx+$58]
005FD23F   85C0                   test    eax, eax
005FD241   7E3D                   jle     005FD280
005FD243   6A04                   push    $04

* Possible String Reference to: 'OSB einlesen'
|
005FD245   B998D35F00             mov     ecx, $005FD398

* Possible String Reference to: 'Bestehende Daten �berschreiben ?'
|
005FD24A   BAA8D35F00             mov     edx, $005FD3A8

* Reference to TApplication instance
|
005FD24F   A10CC96100             mov     eax, dword ptr [$0061C90C]
005FD254   8B00                   mov     eax, [eax]

* Reference to: Forms.TApplication.MessageBox(TApplication;PChar;PChar;Longint):Integer;
|
005FD256   E87500E7FF             call    0046D2D0
005FD25B   83F806                 cmp     eax, +$06
005FD25E   7516                   jnz     005FD276
005FD260   8BD6                   mov     edx, esi

* Reference to Form1
|
005FD262   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.Datenlschen1Click()
|
005FD265   E8DA4EFEFF             call    005E2144

* Reference to Form1
|
005FD26A   A108595302             mov     eax, dword ptr [$02535908]

* Reference to: Controls.TControl.Refresh(TControl);
|
005FD26F   E814FDE4FF             call    0044CF88
005FD274   EB0A                   jmp     005FD280
005FD276   A144595302             mov     eax, dword ptr [$02535944]

* Reference to GlobalVar_02535940
|
005FD27B   A340595302             mov     dword ptr [$02535940], eax

* Reference to pointer to GlobalVar_025353D8
|
005FD280   A168C86100             mov     eax, dword ptr [$0061C868]
005FD285   8B00                   mov     eax, [eax]

* Reference to : TForm3.osbein()
|
005FD287   E89050FBFF             call    005B231C
005FD28C   33C0                   xor     eax, eax
005FD28E   5A                     pop     edx
005FD28F   59                     pop     ecx
005FD290   59                     pop     ecx
005FD291   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '�E��W���E��,���<�a'
|
005FD294   68AFD25F00             push    $005FD2AF

* Reference to TScreen instance
|
005FD299   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005FD29E   8B00                   mov     eax, [eax]
005FD2A0   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005FD2A2   E8F5DEE6FF             call    0046B19C
005FD2A7   C3                     ret


* Reference to: System.@HandleFinally;
|
005FD2A8   E91F72E0FF             jmp     004044CC
005FD2AD   EBEA                   jmp     005FD299

****** END
|
005FD2AF   8B45F8                 mov     eax, [ebp-$08]

* Reference to: MMSystem.mci_TMSF_Frame(Longint):Byte;
|
005FD2B2   E80D57E0FF             call    004029C4

* Reference to Form1
|
005FD2B7   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.listen_akt()
|
005FD2BA   E8952CFFFF             call    005EFF54

* Reference to pointer to GlobalVar_0061DF08
|
005FD2BF   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD2C4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FD2C6   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FD2C9   E8BAF9EAFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005FD2CE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD2D3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FD2D5   8B405C                 mov     eax, [eax+$5C]
005FD2D8   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005FD2DA   E87D58EDFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005FD2DF   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD2E4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FD2E6   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Last(TDataSet);
|
005FD2E9   E8BE1FEBFF             call    004AF2AC

* Reference to pointer to GlobalVar_0061DF08
|
005FD2EE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD2F3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005FD2F5   8B8034050000           mov     eax, [eax+$0534]
005FD2FB   8B10                   mov     edx, [eax]
005FD2FD   FF5258                 call    dword ptr [edx+$58]

* Reference to GlobalVar_02535944
|
005FD300   A344595302             mov     dword ptr [$02535944], eax

* Reference to pointer to GlobalVar_0061DF08
|
005FD305   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD30A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005FD30C   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005FD30F   E8C01EEBFF             call    004AF1D4

* Reference to Form1
|
005FD314   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label10 : TLabel
|
005FD317   8B8090030000           mov     eax, [eax+$0390]
005FD31D   B201                   mov     dl, $01

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FD31F   E800F6E4FF             call    0044C924

* Reference to Form1
|
005FD324   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label11 : TLabel
|
005FD327   8B80A0030000           mov     eax, [eax+$03A0]
005FD32D   B201                   mov     dl, $01

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005FD32F   E8F0F5E4FF             call    0044C924

* Reference to pointer to GlobalVar_0061DF08
|
005FD334   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD339   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005FD33B   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005FD341   E84EF9EAFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005FD346   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005FD34B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005FD34D   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005FD353   E830F9EAFF             call    004ACC88

* Reference to Form1
|
005FD358   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.anzeigen()
|
005FD35B   E83C70FDFF             call    005D439C
005FD360   33C0                   xor     eax, eax
005FD362   5A                     pop     edx
005FD363   59                     pop     ecx
005FD364   59                     pop     ecx
005FD365   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '^[��]�'
|
005FD368   6885D35F00             push    $005FD385
005FD36D   8D45F4                 lea     eax, [ebp-$0C]

* Reference to: System.@LStrClr(void;void);
|
005FD370   E8F377E0FF             call    00404B68
005FD375   8D45F8                 lea     eax, [ebp-$08]

* Reference to: System.@LStrClr(void;void);
|
005FD378   E8EB77E0FF             call    00404B68
005FD37D   C3                     ret


* Reference to: System.@HandleFinally;
|
005FD37E   E94971E0FF             jmp     004044CC
005FD383   EBE8                   jmp     005FD36D

****** END
|
005FD385   5E                     pop     esi
005FD386   5B                     pop     ebx
005FD387   8BE5                   mov     esp, ebp
005FD389   5D                     pop     ebp
005FD38A   C3                     ret

*)
end;

