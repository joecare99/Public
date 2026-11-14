{ TForm1 menu-area implementations: DataValidation; LFM-bound method names remain on TForm1. }

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.StringGrid5
    (TStringGrid); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);;
    DB.TDataSet.Open(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_0080; OFFS_00A4; OFFS_00C8; OFFS_013C; OFFS_03B4;
    OFFS_03C4; OFFS_03C8; OFFS_03D8; OFFS_03DC; OFFS_03F0; OFFS_03F4; OFFS_0400; OFFS_0404;
    OFFS_0410; OFFS_0414; OFFS_0534; OFFS_0538; OFFS_053C; OFFS_0540; OFFS_0544; OFFS_0548;
    OFFS_0558; OFFS_055C; OFFS_0560; OFFS_056C; OFFS_0570; OFFS_057C; OFFS_0580; OFFS_0584;
    OFFS_0588; OFFS_0590; OFFS_0594; OFFS_0598; OFFS_059C; OFFS_05B4; OFFS_0600; OFFS_0674;
    OFFS_0944; OFFS_0958
Project calls: TForm1.anzeigen(); TForm1.lab18ein(); TForm1.Proc_005D97B8(); TForm1.speich1();
    TForm1.tabdisab(); TForm1.tabenab(); TForm1.ucase(); Unit_00408494.Proc_004091D8;
    Unit_00408494.Proc_00409448; Unit_00408494.Proc_00409950; Unit_00408494.Proc_00409980;
    Unit_00408494.Proc_004099B4; Unit_00408494.Proc_0040D094
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.Refresh(TControl);; Controls.TControl.SetText(TControl;TCaption);;
    Controls.TControl.SetVisible(TControl;Boolean);; Dialogs.ShowMessage(AnsiString);;
    Forms.TScreen.SetCursor(TScreen;TCursor);; Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);;
    Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);; method TMenuItem.Click();
    System.Proc_00404EE0; TScreen instance
Strings/files/dialog text: ' %'; ' Fehler gefunden.'; ', in Bestattungsort'; ', in Geburtsort'; ',
    in k.Heiratsort'; ', in Name'; ', in s.Heiratsort'; ', in Scheidungsort'; ', in Sterbeort'; ',
    in Taufort'; ', in Vorname'; '/ in Name'; '/ in Vorname'; '0 %'; '] fehlend oder falsch';
    '_^[��]�'; 'Datenpr�fung '; 'DatP'; 'Geburts-/Bestatt.-Daten �berpr�fen';
    'Geburts-/k.Heirats-Daten �berpr�fen'; 'Geburts-/Scheidungs-Daten �berpr�fe;
    'Geburts-/st.Heirats-Daten �berpr�fe; 'Geburts-/Sterbedaten �berpr�fen (Al;
    'Geburts-/Sterbedaten �berpr�fen'; 'Geschlecht der Mutter [ = '; 'Geschlecht des Vaters [ = ';
    'Geschlecht fehlend oder falsch'; 'k.Heirats-/Bestatt.-Daten �berpr�fe; 'k.Heirats-/Sterbe-Daten
    �berpr�fen'; 'Keine Daten verf�gbar.'; 'Kind vor Mutter geboren'; 'Kind vor Vater geboren';
    'lebt ? ; Sterbe-/Begr.-Daten �berpr; 'Mutter bei Geb.d.Kindes tot ?'; 'Mutter bei Geb.d.Kindes
    tot'; 'Mutter identisch mit Kind'; 'MWX'; 'num'; 'Plausibilit�t'; 'Rufname nicht in Vornamen
    enthalten'; 'Scheidungs-/Bestatt.-Daten �berpr�f; 'Scheidungs-/Sterbe-Daten �berpr�fen';
    'Schreibfehler in Datum o.�.'; 'st.Heirats-/Bestatt.-Daten �berpr�f; 'st.Heirats-/Sterbe-Daten
    �berpr�fen'; 'Sterbe-/Bestattungsdaten �berpr�fen'; 'Tauf-/Bestatt.-Daten �berpr�fen';
    'Tauf-/k.Heirats-Daten �berpr�fen'; 'Tauf-/Scheidungs-Daten �berpr�fen'; 'Tauf-/st.Heirats-Daten
    �berpr�fen'; 'Tauf-/Sterbedaten �berpr�fen'; 'Vater bei Geb.d.Kindes > 9 Mon.tot'; 'Vater bei
    Geb.d.Kindes >= 1 J. tot; 'Vater identisch mit Kind'; 'Warnung: EP gleichgeschlechtlich';
    '锋��軏���E䉅l���ƅp���'; '餘���˜���<�a'; '�Ԁ���ꍕ'; '��'; '��~���<�a'; '�����_^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Prfen1Click(Sender : TObject);
begin
(*
005D9858   55                     push    ebp
005D9859   8BEC                   mov     ebp, esp
005D985B   B980000000             mov     ecx, $00000080
005D9860   6A00                   push    $00
005D9862   6A00                   push    $00
005D9864   49                     dec     ecx
005D9865   75F9                   jnz     005D9860
005D9867   53                     push    ebx
005D9868   56                     push    esi
005D9869   57                     push    edi
005D986A   8945FC                 mov     [ebp-$04], eax
005D986D   33C0                   xor     eax, eax
005D986F   55                     push    ebp

* Possible String Reference to: '�����_^[��]�'
|
005D9870   68F1C45D00             push    $005DC4F1

***** TRY
|
005D9875   64FF30                 push    dword ptr fs:[eax]
005D9878   648920                 mov     fs:[eax], esp
005D987B   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'DatP'
|
005D9880   BA08C55D00             mov     edx, $005DC508

* Reference to: System.@LStrAsg(void;void;void;void);
|
005D9885   E832B3E2FF             call    00404BBC

* Reference to pointer to GlobalVar_0061DF08
|
005D988A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D988F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
005D9891   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005D9897   E8EC33EDFF             call    004ACC88

* Reference to Form1
|
005D989C   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005D989F   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005D98A5   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005D98A8   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005D98AE   E80565EAFF             call    0047FDB8

* Reference to Form1
|
005D98B3   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.aus1 : TMenuItem
|
005D98B6   8B801C060000           mov     eax, [eax+$061C]
005D98BC   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005D98BE   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
005D98C1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D98C6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D98C8   8B8034050000           mov     eax, [eax+$0534]
005D98CE   8B10                   mov     edx, [eax]
005D98D0   FF5258                 call    dword ptr [edx+$58]
005D98D3   8945F8                 mov     [ebp-$08], eax

* Reference to Form1
|
005D98D6   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.speich1()
|
005D98D9   E8BEE0FFFF             call    005D799C

* Reference to pointer to GlobalVar_0061DF08
|
005D98DE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D98E3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D98E5   8B8034050000           mov     eax, [eax+$0534]
005D98EB   8B10                   mov     edx, [eax]
005D98ED   FF5258                 call    dword ptr [edx+$58]
005D98F0   85C0                   test    eax, eax
005D98F2   7E15                   jle     005D9909

* Reference to pointer to GlobalVar_0061DF08
|
005D98F4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D98F9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005D98FB   8B405C                 mov     eax, [eax+$5C]
005D98FE   8B10                   mov     edx, [eax]
005D9900   FF924C010000           call    dword ptr [edx+$014C]
005D9906   48                     dec     eax
005D9907   7D0F                   jnl     005D9918

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005D9909   B818C55D00             mov     eax, $005DC518

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005D990E   E8D1BEE6FF             call    004457E4
005D9913   E95A2B0000             jmp     005DC472

* Reference to pointer to GlobalVar_0061DF08
|
005D9918   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D991D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005D991F   8B405C                 mov     eax, [eax+$5C]
005D9922   80B89D00000000         cmp     byte ptr [eax+$009D], $00
005D9929   740A                   jz      005D9935

* Reference to Form1
|
005D992B   A108595302             mov     eax, dword ptr [$02535908]

* Reference to: Controls.TControl.Refresh(TControl);
|
005D9930   E85336E7FF             call    0044CF88
005D9935   33C0                   xor     eax, eax
005D9937   8945EC                 mov     [ebp-$14], eax

* Reference to Form1
|
005D993A   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabdisab()
|
005D993D   E8F2EEFFFF             call    005D8834

* Reference to pointer to GlobalVar_0061DF08
|
005D9942   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9947   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005D9949   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005D994F   E83433EDFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005D9954   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9959   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005D995B   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
005D9961   BA38C55D00             mov     edx, $005DC538

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D9966   E8F191EFFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005D996B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9970   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005D9972   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005D9975   E80E33EDFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005D997A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D997F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005D9981   8B405C                 mov     eax, [eax+$5C]
005D9984   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D9986   E8D191EFFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005D998B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9990   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005D9992   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005D9995   E83A58EDFF             call    004AF1D4

* Reference to pointer to GlobalVar_0061DF08
|
005D999A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D999F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_013C
|
005D99A1   8B803C010000           mov     eax, [eax+$013C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005D99A7   E8DC32EDFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005D99AC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D99B1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_013C
|
005D99B3   8B803C010000           mov     eax, [eax+$013C]
005D99B9   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D99BB   E89C91EFFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005D99C0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D99C5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_013C
|
005D99C7   8B803C010000           mov     eax, [eax+$013C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005D99CD   E80258EDFF             call    004AF1D4

* Reference to Form1
|
005D99D2   A108595302             mov     eax, dword ptr [$02535908]

* Reference to : TForm1.lab18ein()
|
005D99D7   E808EEFFFF             call    005D87E4

* Reference to Form1
|
005D99DC   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0400
|
005D99E1   8B8000040000           mov     eax, [eax+$0400]

* Possible String Reference to: '0 %'
|
005D99E7   BA44C55D00             mov     edx, $005DC544

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D99EC   E84330E7FF             call    0044CA34

* Reference to Form1
|
005D99F1   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0400
|
005D99F6   8B8000040000           mov     eax, [eax+$0400]

* Reference to: Controls.TControl.Refresh(TControl);
|
005D99FC   E88735E7FF             call    0044CF88

* Reference to Form1
|
005D9A01   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0404
|
005D9A06   8B8004040000           mov     eax, [eax+$0404]

* Possible String Reference to: 'Datenpr�fung            '
|
005D9A0C   BA50C55D00             mov     edx, $005DC550

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D9A11   E81E30E7FF             call    0044CA34

* Reference to Form1
|
005D9A16   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0404
|
005D9A1B   8B8004040000           mov     eax, [eax+$0404]

* Reference to: Controls.TControl.Refresh(TControl);
|
005D9A21   E86235E7FF             call    0044CF88

* Reference to pointer to GlobalVar_0061DF08
|
005D9A26   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9A2B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005D9A2D   8B405C                 mov     eax, [eax+$5C]
005D9A30   8B10                   mov     edx, [eax]
005D9A32   FF924C010000           call    dword ptr [edx+$014C]
005D9A38   8945F4                 mov     [ebp-$0C], eax
005D9A3B   33C0                   xor     eax, eax
005D9A3D   8945F0                 mov     [ebp-$10], eax
005D9A40   DB45F0                 fild    dword ptr [ebp-$10]
005D9A43   DB45F4                 fild    dword ptr [ebp-$0C]
005D9A46   DEF9                   fdivp   st(1), st(0)
005D9A48   D80D6CC55D00           fmul    dword ptr [$005DC56C]

* Reference to: System.@ROUND;
|
005D9A4E   E8DD92E2FF             call    00402D30
005D9A53   52                     push    edx
005D9A54   50                     push    eax
005D9A55   8D45DC                 lea     eax, [ebp-$24]

* Reference to: Unit_00408494.Proc_00409980
|
005D9A58   E823FFE2FF             call    00409980
005D9A5D   8D45DC                 lea     eax, [ebp-$24]

* Possible String Reference to: ' %'
|
005D9A60   BA78C55D00             mov     edx, $005DC578

* Reference to: System.@LStrCat;
|
005D9A65   E8BEB3E2FF             call    00404E28
005D9A6A   8B55DC                 mov     edx, [ebp-$24]

* Reference to Form1
|
005D9A6D   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0400
|
005D9A72   8B8000040000           mov     eax, [eax+$0400]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D9A78   E8B72FE7FF             call    0044CA34

* Reference to Form1
|
005D9A7D   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0400
|
005D9A82   8B8000040000           mov     eax, [eax+$0400]

* Reference to: Controls.TControl.Refresh(TControl);
|
005D9A88   E8FB34E7FF             call    0044CF88
005D9A8D   33C0                   xor     eax, eax
005D9A8F   55                     push    ebp

* Possible String Reference to: '�Ԁ���ꍕ'
|
005D9A90   68F3C35D00             push    $005DC3F3

***** TRY
|
005D9A95   64FF30                 push    dword ptr fs:[eax]
005D9A98   648920                 mov     fs:[eax], esp

* Reference to TScreen instance
|
005D9A9B   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005D9AA0   8B00                   mov     eax, [eax]
005D9AA2   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005D9AA6   E8F116E9FF             call    0046B19C

* Reference to Form1
|
005D9AAB   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.StringGrid5 : TStringGrid
|
005D9AAE   8B8074060000           mov     eax, [eax+$0674]
005D9AB4   BA01000000             mov     edx, $00000001

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
005D9AB9   E8123EF0FF             call    004DD8D0

* Possible String Reference to: 'Plausibilit�t'
|
005D9ABE   6884C55D00             push    $005DC584

* Reference to Form1
|
005D9AC3   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0674
|
005D9AC8   8B8074060000           mov     eax, [eax+$0674]
005D9ACE   33C9                   xor     ecx, ecx
005D9AD0   BA01000000             mov     edx, $00000001

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005D9AD5   E82260F0FF             call    004DFAFC
005D9ADA   689CC55D00             push    $005DC59C

* Reference to Form1
|
005D9ADF   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0674
|
005D9AE4   8B8074060000           mov     eax, [eax+$0674]
005D9AEA   B901000000             mov     ecx, $00000001
005D9AEF   33D2                   xor     edx, edx

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005D9AF1   E80660F0FF             call    004DFAFC
005D9AF6   689CC55D00             push    $005DC59C

* Reference to Form1
|
005D9AFB   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0674
|
005D9B00   8B8074060000           mov     eax, [eax+$0674]
005D9B06   B901000000             mov     ecx, $00000001
005D9B0B   BA01000000             mov     edx, $00000001

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005D9B10   E8E75FF0FF             call    004DFAFC
005D9B15   E982280000             jmp     005DC39C
005D9B1A   33C0                   xor     eax, eax
005D9B1C   55                     push    ebp

* Possible String Reference to: '��~���<�a'
|
005D9B1D   6819C35D00             push    $005DC319

***** TRY
|
005D9B22   64FF30                 push    dword ptr fs:[eax]
005D9B25   648920                 mov     fs:[eax], esp
005D9B28   FF45F0                 inc     dword ptr [ebp-$10]
005D9B2B   DB45F0                 fild    dword ptr [ebp-$10]
005D9B2E   DB45F4                 fild    dword ptr [ebp-$0C]
005D9B31   DEF9                   fdivp   st(1), st(0)
005D9B33   D80D6CC55D00           fmul    dword ptr [$005DC56C]

* Reference to: System.@ROUND;
|
005D9B39   E8F291E2FF             call    00402D30
005D9B3E   52                     push    edx
005D9B3F   50                     push    eax
005D9B40   8D45D8                 lea     eax, [ebp-$28]

* Reference to: Unit_00408494.Proc_00409980
|
005D9B43   E838FEE2FF             call    00409980
005D9B48   8D45D8                 lea     eax, [ebp-$28]

* Possible String Reference to: ' %'
|
005D9B4B   BA78C55D00             mov     edx, $005DC578

* Reference to: System.@LStrCat;
|
005D9B50   E8D3B2E2FF             call    00404E28
005D9B55   8B55D8                 mov     edx, [ebp-$28]

* Reference to Form1
|
005D9B58   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0400
|
005D9B5D   8B8000040000           mov     eax, [eax+$0400]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D9B63   E8CC2EE7FF             call    0044CA34

* Reference to Form1
|
005D9B68   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0400
|
005D9B6D   8B8000040000           mov     eax, [eax+$0400]

* Reference to: Controls.TControl.Refresh(TControl);
|
005D9B73   E81034E7FF             call    0044CF88

* Reference to pointer to GlobalVar_0061DF08
|
005D9B78   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9B7D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9B7F   8B8034050000           mov     eax, [eax+$0534]
005D9B85   8B10                   mov     edx, [eax]
005D9B87   FF5258                 call    dword ptr [edx+$58]
005D9B8A   8945E8                 mov     [ebp-$18], eax
005D9B8D   8D55D4                 lea     edx, [ebp-$2C]

* Reference to pointer to GlobalVar_0061DF08
|
005D9B90   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9B95   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0540
|
005D9B97   8B8040050000           mov     eax, [eax+$0540]
005D9B9D   8B08                   mov     ecx, [eax]
005D9B9F   FF5160                 call    dword ptr [ecx+$60]
005D9BA2   8B55D4                 mov     edx, [ebp-$2C]
005D9BA5   B8A8C55D00             mov     eax, $005DC5A8

* Reference to: System.@LStrPos;
|
005D9BAA   E8ADB5E2FF             call    0040515C
005D9BAF   85C0                   test    eax, eax
005D9BB1   7E2A                   jle     005D9BDD

* Reference to pointer to GlobalVar_0061DF08
|
005D9BB3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9BB8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9BBA   8B8034050000           mov     eax, [eax+$0534]
005D9BC0   8B10                   mov     edx, [eax]
005D9BC2   FF5258                 call    dword ptr [edx+$58]
005D9BC5   8D55D0                 lea     edx, [ebp-$30]

* Reference to: Unit_00408494.Proc_00409950
|
005D9BC8   E883FDE2FF             call    00409950
005D9BCD   8B45D0                 mov     eax, [ebp-$30]
005D9BD0   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: '/ in Name'
|
005D9BD3   BAB4C55D00             mov     edx, $005DC5B4

* Reference to : TForm1.Proc_005D97B8()
|
005D9BD8   E8DBFBFFFF             call    005D97B8
005D9BDD   8D55CC                 lea     edx, [ebp-$34]

* Reference to pointer to GlobalVar_0061DF08
|
005D9BE0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9BE5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0540
|
005D9BE7   8B8040050000           mov     eax, [eax+$0540]
005D9BED   8B08                   mov     ecx, [eax]
005D9BEF   FF5160                 call    dword ptr [ecx+$60]
005D9BF2   8B55CC                 mov     edx, [ebp-$34]
005D9BF5   B8C8C55D00             mov     eax, $005DC5C8

* Reference to: System.@LStrPos;
|
005D9BFA   E85DB5E2FF             call    0040515C
005D9BFF   85C0                   test    eax, eax
005D9C01   7E2A                   jle     005D9C2D

* Reference to pointer to GlobalVar_0061DF08
|
005D9C03   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9C08   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9C0A   8B8034050000           mov     eax, [eax+$0534]
005D9C10   8B10                   mov     edx, [eax]
005D9C12   FF5258                 call    dword ptr [edx+$58]
005D9C15   8D55C8                 lea     edx, [ebp-$38]

* Reference to: Unit_00408494.Proc_00409950
|
005D9C18   E833FDE2FF             call    00409950
005D9C1D   8B45C8                 mov     eax, [ebp-$38]
005D9C20   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: ', in Name'
|
005D9C23   BAD4C55D00             mov     edx, $005DC5D4

* Reference to : TForm1.Proc_005D97B8()
|
005D9C28   E88BFBFFFF             call    005D97B8
005D9C2D   8D55C4                 lea     edx, [ebp-$3C]

* Reference to pointer to GlobalVar_0061DF08
|
005D9C30   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9C35   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0544
|
005D9C37   8B8044050000           mov     eax, [eax+$0544]
005D9C3D   8B08                   mov     ecx, [eax]
005D9C3F   FF5160                 call    dword ptr [ecx+$60]
005D9C42   8B55C4                 mov     edx, [ebp-$3C]
005D9C45   B8A8C55D00             mov     eax, $005DC5A8

* Reference to: System.@LStrPos;
|
005D9C4A   E80DB5E2FF             call    0040515C
005D9C4F   85C0                   test    eax, eax
005D9C51   7E2A                   jle     005D9C7D

* Reference to pointer to GlobalVar_0061DF08
|
005D9C53   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9C58   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9C5A   8B8034050000           mov     eax, [eax+$0534]
005D9C60   8B10                   mov     edx, [eax]
005D9C62   FF5258                 call    dword ptr [edx+$58]
005D9C65   8D55C0                 lea     edx, [ebp-$40]

* Reference to: Unit_00408494.Proc_00409950
|
005D9C68   E8E3FCE2FF             call    00409950
005D9C6D   8B45C0                 mov     eax, [ebp-$40]
005D9C70   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: '/ in Vorname'
|
005D9C73   BAE8C55D00             mov     edx, $005DC5E8

* Reference to : TForm1.Proc_005D97B8()
|
005D9C78   E83BFBFFFF             call    005D97B8
005D9C7D   8D55BC                 lea     edx, [ebp-$44]

* Reference to pointer to GlobalVar_0061DF08
|
005D9C80   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9C85   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0544
|
005D9C87   8B8044050000           mov     eax, [eax+$0544]
005D9C8D   8B08                   mov     ecx, [eax]
005D9C8F   FF5160                 call    dword ptr [ecx+$60]
005D9C92   8B55BC                 mov     edx, [ebp-$44]
005D9C95   B8C8C55D00             mov     eax, $005DC5C8

* Reference to: System.@LStrPos;
|
005D9C9A   E8BDB4E2FF             call    0040515C
005D9C9F   85C0                   test    eax, eax
005D9CA1   7E2A                   jle     005D9CCD

* Reference to pointer to GlobalVar_0061DF08
|
005D9CA3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9CA8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9CAA   8B8034050000           mov     eax, [eax+$0534]
005D9CB0   8B10                   mov     edx, [eax]
005D9CB2   FF5258                 call    dword ptr [edx+$58]
005D9CB5   8D55B8                 lea     edx, [ebp-$48]

* Reference to: Unit_00408494.Proc_00409950
|
005D9CB8   E893FCE2FF             call    00409950
005D9CBD   8B45B8                 mov     eax, [ebp-$48]
005D9CC0   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: ', in Vorname'
|
005D9CC3   BA00C65D00             mov     edx, $005DC600

* Reference to : TForm1.Proc_005D97B8()
|
005D9CC8   E8EBFAFFFF             call    005D97B8
005D9CCD   8D55B4                 lea     edx, [ebp-$4C]

* Reference to pointer to GlobalVar_0061DF08
|
005D9CD0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9CD5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0560
|
005D9CD7   8B8060050000           mov     eax, [eax+$0560]
005D9CDD   8B08                   mov     ecx, [eax]
005D9CDF   FF5160                 call    dword ptr [ecx+$60]
005D9CE2   8B55B4                 mov     edx, [ebp-$4C]
005D9CE5   B8C8C55D00             mov     eax, $005DC5C8

* Reference to: System.@LStrPos;
|
005D9CEA   E86DB4E2FF             call    0040515C
005D9CEF   85C0                   test    eax, eax
005D9CF1   7E2A                   jle     005D9D1D

* Reference to pointer to GlobalVar_0061DF08
|
005D9CF3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9CF8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9CFA   8B8034050000           mov     eax, [eax+$0534]
005D9D00   8B10                   mov     edx, [eax]
005D9D02   FF5258                 call    dword ptr [edx+$58]
005D9D05   8D55B0                 lea     edx, [ebp-$50]

* Reference to: Unit_00408494.Proc_00409950
|
005D9D08   E843FCE2FF             call    00409950
005D9D0D   8B45B0                 mov     eax, [ebp-$50]
005D9D10   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: ', in Geburtsort'
|
005D9D13   BA18C65D00             mov     edx, $005DC618

* Reference to : TForm1.Proc_005D97B8()
|
005D9D18   E89BFAFFFF             call    005D97B8
005D9D1D   8D55AC                 lea     edx, [ebp-$54]

* Reference to pointer to GlobalVar_0061DF08
|
005D9D20   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9D25   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0570
|
005D9D27   8B8070050000           mov     eax, [eax+$0570]
005D9D2D   8B08                   mov     ecx, [eax]
005D9D2F   FF5160                 call    dword ptr [ecx+$60]
005D9D32   8B55AC                 mov     edx, [ebp-$54]
005D9D35   B8C8C55D00             mov     eax, $005DC5C8

* Reference to: System.@LStrPos;
|
005D9D3A   E81DB4E2FF             call    0040515C
005D9D3F   85C0                   test    eax, eax
005D9D41   7E2A                   jle     005D9D6D

* Reference to pointer to GlobalVar_0061DF08
|
005D9D43   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9D48   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9D4A   8B8034050000           mov     eax, [eax+$0534]
005D9D50   8B10                   mov     edx, [eax]
005D9D52   FF5258                 call    dword ptr [edx+$58]
005D9D55   8D55A8                 lea     edx, [ebp-$58]

* Reference to: Unit_00408494.Proc_00409950
|
005D9D58   E8F3FBE2FF             call    00409950
005D9D5D   8B45A8                 mov     eax, [ebp-$58]
005D9D60   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: ', in Taufort'
|
005D9D63   BA30C65D00             mov     edx, $005DC630

* Reference to : TForm1.Proc_005D97B8()
|
005D9D68   E84BFAFFFF             call    005D97B8
005D9D6D   8D55A4                 lea     edx, [ebp-$5C]

* Reference to pointer to GlobalVar_0061DF08
|
005D9D70   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9D75   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0588
|
005D9D77   8B8088050000           mov     eax, [eax+$0588]
005D9D7D   8B08                   mov     ecx, [eax]
005D9D7F   FF5160                 call    dword ptr [ecx+$60]
005D9D82   8B55A4                 mov     edx, [ebp-$5C]
005D9D85   B8C8C55D00             mov     eax, $005DC5C8

* Reference to: System.@LStrPos;
|
005D9D8A   E8CDB3E2FF             call    0040515C
005D9D8F   85C0                   test    eax, eax
005D9D91   7E2A                   jle     005D9DBD

* Reference to pointer to GlobalVar_0061DF08
|
005D9D93   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9D98   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9D9A   8B8034050000           mov     eax, [eax+$0534]
005D9DA0   8B10                   mov     edx, [eax]
005D9DA2   FF5258                 call    dword ptr [edx+$58]
005D9DA5   8D55A0                 lea     edx, [ebp-$60]

* Reference to: Unit_00408494.Proc_00409950
|
005D9DA8   E8A3FBE2FF             call    00409950
005D9DAD   8B45A0                 mov     eax, [ebp-$60]
005D9DB0   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: ', in Sterbeort'
|
005D9DB3   BA48C65D00             mov     edx, $005DC648

* Reference to : TForm1.Proc_005D97B8()
|
005D9DB8   E8FBF9FFFF             call    005D97B8
005D9DBD   8D559C                 lea     edx, [ebp-$64]

* Reference to pointer to GlobalVar_0061DF08
|
005D9DC0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9DC5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_059C
|
005D9DC7   8B809C050000           mov     eax, [eax+$059C]
005D9DCD   8B08                   mov     ecx, [eax]
005D9DCF   FF5160                 call    dword ptr [ecx+$60]
005D9DD2   8B559C                 mov     edx, [ebp-$64]
005D9DD5   B8C8C55D00             mov     eax, $005DC5C8

* Reference to: System.@LStrPos;
|
005D9DDA   E87DB3E2FF             call    0040515C
005D9DDF   85C0                   test    eax, eax
005D9DE1   7E2A                   jle     005D9E0D

* Reference to pointer to GlobalVar_0061DF08
|
005D9DE3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9DE8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9DEA   8B8034050000           mov     eax, [eax+$0534]
005D9DF0   8B10                   mov     edx, [eax]
005D9DF2   FF5258                 call    dword ptr [edx+$58]
005D9DF5   8D5598                 lea     edx, [ebp-$68]

* Reference to: Unit_00408494.Proc_00409950
|
005D9DF8   E853FBE2FF             call    00409950
005D9DFD   8B4598                 mov     eax, [ebp-$68]
005D9E00   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: ', in Bestattungsort'
|
005D9E03   BA60C65D00             mov     edx, $005DC660

* Reference to : TForm1.Proc_005D97B8()
|
005D9E08   E8ABF9FFFF             call    005D97B8
005D9E0D   8D5590                 lea     edx, [ebp-$70]

* Reference to pointer to GlobalVar_0061DF08
|
005D9E10   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9E15   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0548
|
005D9E17   8B8048050000           mov     eax, [eax+$0548]
005D9E1D   8B08                   mov     ecx, [eax]
005D9E1F   FF5160                 call    dword ptr [ecx+$60]
005D9E22   8B4590                 mov     eax, [ebp-$70]
005D9E25   8D5594                 lea     edx, [ebp-$6C]

* Reference to: Unit_00408494.Proc_004091D8
|
005D9E28   E8ABF3E2FF             call    004091D8
005D9E2D   8B4594                 mov     eax, [ebp-$6C]

* Possible String Reference to: 'MWX'
|
005D9E30   BA7CC65D00             mov     edx, $005DC67C

* Reference to: System.@LStrPos;
|
005D9E35   E822B3E2FF             call    0040515C
005D9E3A   85C0                   test    eax, eax
005D9E3C   752A                   jnz     005D9E68

* Reference to pointer to GlobalVar_0061DF08
|
005D9E3E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9E43   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9E45   8B8034050000           mov     eax, [eax+$0534]
005D9E4B   8B10                   mov     edx, [eax]
005D9E4D   FF5258                 call    dword ptr [edx+$58]
005D9E50   8D558C                 lea     edx, [ebp-$74]

* Reference to: Unit_00408494.Proc_00409950
|
005D9E53   E8F8FAE2FF             call    00409950
005D9E58   8B458C                 mov     eax, [ebp-$74]
005D9E5B   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Geschlecht fehlend oder falsch'
|
005D9E5E   BA88C65D00             mov     edx, $005DC688

* Reference to : TForm1.Proc_005D97B8()
|
005D9E63   E850F9FFFF             call    005D97B8
005D9E68   8D5584                 lea     edx, [ebp-$7C]

* Reference to pointer to GlobalVar_0061DF08
|
005D9E6B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9E70   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0600
|
005D9E72   8B8000060000           mov     eax, [eax+$0600]
005D9E78   8B08                   mov     ecx, [eax]
005D9E7A   FF5160                 call    dword ptr [ecx+$60]
005D9E7D   8B4584                 mov     eax, [ebp-$7C]
005D9E80   8D5588                 lea     edx, [ebp-$78]

* Reference to: Unit_00408494.Proc_00409448
|
005D9E83   E8C0F5E2FF             call    00409448
005D9E88   837D8800               cmp     dword ptr [ebp-$78], +$00
005D9E8C   0F8682000000           jbe     005D9F14
005D9E92   8D5580                 lea     edx, [ebp-$80]

* Reference to pointer to GlobalVar_0061DF08
|
005D9E95   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9E9A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0544
|
005D9E9C   8B8044050000           mov     eax, [eax+$0544]
005D9EA2   8B08                   mov     ecx, [eax]
005D9EA4   FF5160                 call    dword ptr [ecx+$60]
005D9EA7   8B4580                 mov     eax, [ebp-$80]
005D9EAA   50                     push    eax
005D9EAB   8D9578FFFFFF           lea     edx, [ebp+$FFFFFF78]

* Reference to pointer to GlobalVar_0061DF08
|
005D9EB1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9EB6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0600
|
005D9EB8   8B8000060000           mov     eax, [eax+$0600]
005D9EBE   8B08                   mov     ecx, [eax]
005D9EC0   FF5160                 call    dword ptr [ecx+$60]
005D9EC3   8B8578FFFFFF           mov     eax, [ebp+$FFFFFF78]
005D9EC9   8D957CFFFFFF           lea     edx, [ebp+$FFFFFF7C]

* Reference to: Unit_00408494.Proc_00409448
|
005D9ECF   E874F5E2FF             call    00409448
005D9ED4   8B857CFFFFFF           mov     eax, [ebp+$FFFFFF7C]
005D9EDA   5A                     pop     edx

* Reference to: System.@LStrPos;
|
005D9EDB   E87CB2E2FF             call    0040515C
005D9EE0   85C0                   test    eax, eax
005D9EE2   7530                   jnz     005D9F14

* Reference to pointer to GlobalVar_0061DF08
|
005D9EE4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9EE9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005D9EEB   8B8034050000           mov     eax, [eax+$0534]
005D9EF1   8B10                   mov     edx, [eax]
005D9EF3   FF5258                 call    dword ptr [edx+$58]
005D9EF6   8D9574FFFFFF           lea     edx, [ebp+$FFFFFF74]

* Reference to: Unit_00408494.Proc_00409950
|
005D9EFC   E84FFAE2FF             call    00409950
005D9F01   8B8574FFFFFF           mov     eax, [ebp+$FFFFFF74]
005D9F07   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Rufname nicht in Vornamen enthalten'
|
005D9F0A   BAB0C65D00             mov     edx, $005DC6B0

* Reference to : TForm1.Proc_005D97B8()
|
005D9F0F   E8A4F8FFFF             call    005D97B8

* Reference to pointer to GlobalVar_0061DF08
|
005D9F14   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9F19   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0538
|
005D9F1B   8B8038050000           mov     eax, [eax+$0538]
005D9F21   8B10                   mov     edx, [eax]
005D9F23   FF5258                 call    dword ptr [edx+$58]
005D9F26   85C0                   test    eax, eax
005D9F28   0F8E1C010000           jle     005DA04A

* Reference to pointer to GlobalVar_0061DF08
|
005D9F2E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9F33   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0538
|
005D9F35   8B8038050000           mov     eax, [eax+$0538]
005D9F3B   8B10                   mov     edx, [eax]
005D9F3D   FF5258                 call    dword ptr [edx+$58]
005D9F40   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005D9F46   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005D9F4D   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005D9F53   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9F58   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_013C
|
005D9F5A   8B803C010000           mov     eax, [eax+$013C]
005D9F60   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005D9F62   E8FD92EFFF             call    004D3264

* Reference to pointer to GlobalVar_0061DF08
|
005D9F67   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9F6C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0538
|
005D9F6E   8B8038050000           mov     eax, [eax+$0538]
005D9F74   8B10                   mov     edx, [eax]
005D9F76   FF5258                 call    dword ptr [edx+$58]
005D9F79   3B45E8                 cmp     eax, [ebp-$18]
005D9F7C   7530                   jnz     005D9FAE

* Reference to pointer to GlobalVar_0061DF08
|
005D9F7E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9F83   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0944
|
005D9F85   8B8044090000           mov     eax, [eax+$0944]
005D9F8B   8B10                   mov     edx, [eax]
005D9F8D   FF5258                 call    dword ptr [edx+$58]
005D9F90   8D9568FFFFFF           lea     edx, [ebp+$FFFFFF68]

* Reference to: Unit_00408494.Proc_00409950
|
005D9F96   E8B5F9E2FF             call    00409950
005D9F9B   8B8568FFFFFF           mov     eax, [ebp+$FFFFFF68]
005D9FA1   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Vater identisch mit Kind'
|
005D9FA4   BADCC65D00             mov     edx, $005DC6DC

* Reference to : TForm1.Proc_005D97B8()
|
005D9FA9   E80AF8FFFF             call    005D97B8
005D9FAE   8D9560FFFFFF           lea     edx, [ebp+$FFFFFF60]

* Reference to pointer to GlobalVar_0061DF08
|
005D9FB4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9FB9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0958
|
005D9FBB   8B8058090000           mov     eax, [eax+$0958]
005D9FC1   8B08                   mov     ecx, [eax]
005D9FC3   FF5160                 call    dword ptr [ecx+$60]
005D9FC6   8B8560FFFFFF           mov     eax, [ebp+$FFFFFF60]
005D9FCC   8D9564FFFFFF           lea     edx, [ebp+$FFFFFF64]

* Reference to: Unit_00408494.Proc_004091D8
|
005D9FD2   E801F2E2FF             call    004091D8
005D9FD7   8B8564FFFFFF           mov     eax, [ebp+$FFFFFF64]
005D9FDD   BA00C75D00             mov     edx, $005DC700

* Reference to: System.@LStrCmp;
|
005D9FE2   E87DAFE2FF             call    00404F64
005D9FE7   7461                   jz      005DA04A

* Possible String Reference to: 'Geschlecht des Vaters [ = '
|
005D9FE9   680CC75D00             push    $005DC70C

* Reference to pointer to GlobalVar_0061DF08
|
005D9FEE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005D9FF3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0944
|
005D9FF5   8B8044090000           mov     eax, [eax+$0944]
005D9FFB   8B10                   mov     edx, [eax]
005D9FFD   FF5258                 call    dword ptr [edx+$58]
005DA000   8D9558FFFFFF           lea     edx, [ebp+$FFFFFF58]

* Reference to: Unit_00408494.Proc_00409950
|
005DA006   E845F9E2FF             call    00409950
005DA00B   FFB558FFFFFF           push    dword ptr [ebp+$FFFFFF58]

* Possible String Reference to: '] fehlend oder falsch'
|
005DA011   6830C75D00             push    $005DC730
005DA016   8D855CFFFFFF           lea     eax, [ebp+$FFFFFF5C]
005DA01C   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005DA021   E8BAAEE2FF             call    00404EE0
005DA026   8B855CFFFFFF           mov     eax, [ebp+$FFFFFF5C]
005DA02C   50                     push    eax
005DA02D   8D9554FFFFFF           lea     edx, [ebp+$FFFFFF54]
005DA033   8B45E8                 mov     eax, [ebp-$18]

* Reference to: Unit_00408494.Proc_00409950
|
005DA036   E815F9E2FF             call    00409950
005DA03B   8B8554FFFFFF           mov     eax, [ebp+$FFFFFF54]
005DA041   8D4DEC                 lea     ecx, [ebp-$14]
005DA044   5A                     pop     edx

* Reference to : TForm1.Proc_005D97B8()
|
005DA045   E86EF7FFFF             call    005D97B8

* Reference to pointer to GlobalVar_0061DF08
|
005DA04A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA04F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_053C
|
005DA051   8B803C050000           mov     eax, [eax+$053C]
005DA057   8B10                   mov     edx, [eax]
005DA059   FF5258                 call    dword ptr [edx+$58]
005DA05C   85C0                   test    eax, eax
005DA05E   0F8E1C010000           jle     005DA180

* Reference to pointer to GlobalVar_0061DF08
|
005DA064   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA069   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_053C
|
005DA06B   8B803C050000           mov     eax, [eax+$053C]
005DA071   8B10                   mov     edx, [eax]
005DA073   FF5258                 call    dword ptr [edx+$58]
005DA076   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DA07C   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DA083   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DA089   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA08E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_013C
|
005DA090   8B803C010000           mov     eax, [eax+$013C]
005DA096   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DA098   E8C791EFFF             call    004D3264

* Reference to pointer to GlobalVar_0061DF08
|
005DA09D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA0A2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_053C
|
005DA0A4   8B803C050000           mov     eax, [eax+$053C]
005DA0AA   8B10                   mov     edx, [eax]
005DA0AC   FF5258                 call    dword ptr [edx+$58]
005DA0AF   3B45E8                 cmp     eax, [ebp-$18]
005DA0B2   7530                   jnz     005DA0E4

* Reference to pointer to GlobalVar_0061DF08
|
005DA0B4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA0B9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0944
|
005DA0BB   8B8044090000           mov     eax, [eax+$0944]
005DA0C1   8B10                   mov     edx, [eax]
005DA0C3   FF5258                 call    dword ptr [edx+$58]
005DA0C6   8D9550FFFFFF           lea     edx, [ebp+$FFFFFF50]

* Reference to: Unit_00408494.Proc_00409950
|
005DA0CC   E87FF8E2FF             call    00409950
005DA0D1   8B8550FFFFFF           mov     eax, [ebp+$FFFFFF50]
005DA0D7   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Mutter identisch mit Kind'
|
005DA0DA   BA50C75D00             mov     edx, $005DC750

* Reference to : TForm1.Proc_005D97B8()
|
005DA0DF   E8D4F6FFFF             call    005D97B8
005DA0E4   8D9548FFFFFF           lea     edx, [ebp+$FFFFFF48]

* Reference to pointer to GlobalVar_0061DF08
|
005DA0EA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA0EF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0958
|
005DA0F1   8B8058090000           mov     eax, [eax+$0958]
005DA0F7   8B08                   mov     ecx, [eax]
005DA0F9   FF5160                 call    dword ptr [ecx+$60]
005DA0FC   8B8548FFFFFF           mov     eax, [ebp+$FFFFFF48]
005DA102   8D954CFFFFFF           lea     edx, [ebp+$FFFFFF4C]

* Reference to: Unit_00408494.Proc_004091D8
|
005DA108   E8CBF0E2FF             call    004091D8
005DA10D   8B854CFFFFFF           mov     eax, [ebp+$FFFFFF4C]
005DA113   BA74C75D00             mov     edx, $005DC774

* Reference to: System.@LStrCmp;
|
005DA118   E847AEE2FF             call    00404F64
005DA11D   7461                   jz      005DA180

* Possible String Reference to: 'Geschlecht der Mutter [ = '
|
005DA11F   6880C75D00             push    $005DC780

* Reference to pointer to GlobalVar_0061DF08
|
005DA124   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA129   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0944
|
005DA12B   8B8044090000           mov     eax, [eax+$0944]
005DA131   8B10                   mov     edx, [eax]
005DA133   FF5258                 call    dword ptr [edx+$58]
005DA136   8D9540FFFFFF           lea     edx, [ebp+$FFFFFF40]

* Reference to: Unit_00408494.Proc_00409950
|
005DA13C   E80FF8E2FF             call    00409950
005DA141   FFB540FFFFFF           push    dword ptr [ebp+$FFFFFF40]

* Possible String Reference to: '] fehlend oder falsch'
|
005DA147   6830C75D00             push    $005DC730
005DA14C   8D8544FFFFFF           lea     eax, [ebp+$FFFFFF44]
005DA152   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005DA157   E884ADE2FF             call    00404EE0
005DA15C   8B8544FFFFFF           mov     eax, [ebp+$FFFFFF44]
005DA162   50                     push    eax
005DA163   8D953CFFFFFF           lea     edx, [ebp+$FFFFFF3C]
005DA169   8B45E8                 mov     eax, [ebp-$18]

* Reference to: Unit_00408494.Proc_00409950
|
005DA16C   E8DFF7E2FF             call    00409950
005DA171   8B853CFFFFFF           mov     eax, [ebp+$FFFFFF3C]
005DA177   8D4DEC                 lea     ecx, [ebp-$14]
005DA17A   5A                     pop     edx

* Reference to : TForm1.Proc_005D97B8()
|
005DA17B   E838F6FFFF             call    005D97B8

* Reference to pointer to GlobalVar_0061DF08
|
005DA180   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA185   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005DA187   8B8080000000           mov     eax, [eax+$0080]
005DA18D   8B10                   mov     edx, [eax]
005DA18F   FF924C010000           call    dword ptr [edx+$014C]
005DA195   85C0                   test    eax, eax
005DA197   0F8E86010000           jle     005DA323
005DA19D   8D9538FFFFFF           lea     edx, [ebp+$FFFFFF38]

* Reference to pointer to GlobalVar_0061DF08
|
005DA1A3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA1A8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0548
|
005DA1AA   8B8048050000           mov     eax, [eax+$0548]
005DA1B0   8B08                   mov     ecx, [eax]
005DA1B2   FF5160                 call    dword ptr [ecx+$60]
005DA1B5   8B9538FFFFFF           mov     edx, [ebp+$FFFFFF38]
005DA1BB   8D4DE0                 lea     ecx, [ebp-$20]

* Reference to Form1
|
005DA1BE   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.ucase()
|
005DA1C1   E8C2D9FFFF             call    005D7B88

* Reference to pointer to GlobalVar_0061DF08
|
005DA1C6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA1CB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005DA1CD   8B8080000000           mov     eax, [eax+$0080]

* Possible String Reference to: 'num'
|
005DA1D3   BA38C55D00             mov     edx, $005DC538

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005DA1D8   E87F89EFFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005DA1DD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA1E2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005DA1E4   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.First(TDataSet);
|
005DA1EA   E8E54FEDFF             call    004AF1D4
005DA1EF   8B45E8                 mov     eax, [ebp-$18]
005DA1F2   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DA1F8   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DA1FF   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DA205   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA20A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005DA20C   8B8080000000           mov     eax, [eax+$0080]
005DA212   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DA214   E84B90EFFF             call    004D3264
005DA219   84C0                   test    al, al
005DA21B   0F84DB000000           jz      005DA2FC
005DA221   E9BB000000             jmp     005DA2E1

* Reference to pointer to GlobalVar_0061DF08
|
005DA226   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA22B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0414
|
005DA22D   8B8014040000           mov     eax, [eax+$0414]
005DA233   8B10                   mov     edx, [eax]
005DA235   FF5258                 call    dword ptr [edx+$58]
005DA238   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DA23E   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DA245   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DA24B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA250   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DA252   8B405C                 mov     eax, [eax+$5C]
005DA255   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DA257   E80890EFFF             call    004D3264
005DA25C   8D9530FFFFFF           lea     edx, [ebp+$FFFFFF30]

* Reference to pointer to GlobalVar_0061DF08
|
005DA262   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA267   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0548
|
005DA269   8B8048050000           mov     eax, [eax+$0548]
005DA26F   8B08                   mov     ecx, [eax]
005DA271   FF5160                 call    dword ptr [ecx+$60]
005DA274   8B9530FFFFFF           mov     edx, [ebp+$FFFFFF30]
005DA27A   8D8D34FFFFFF           lea     ecx, [ebp+$FFFFFF34]

* Reference to Form1
|
005DA280   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.ucase()
|
005DA283   E800D9FFFF             call    005D7B88
005DA288   8B8534FFFFFF           mov     eax, [ebp+$FFFFFF34]
005DA28E   8B55E0                 mov     edx, [ebp-$20]

* Reference to: System.@LStrCmp;
|
005DA291   E8CEACE2FF             call    00404F64
005DA296   7521                   jnz     005DA2B9
005DA298   8D952CFFFFFF           lea     edx, [ebp+$FFFFFF2C]
005DA29E   8B45E8                 mov     eax, [ebp-$18]

* Reference to: Unit_00408494.Proc_00409950
|
005DA2A1   E8AAF6E2FF             call    00409950
005DA2A6   8B852CFFFFFF           mov     eax, [ebp+$FFFFFF2C]
005DA2AC   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Warnung: EP gleichgeschlechtlich'
|
005DA2AF   BAA4C75D00             mov     edx, $005DC7A4

* Reference to : TForm1.Proc_005D97B8()
|
005DA2B4   E8FFF4FFFF             call    005D97B8

* Reference to pointer to GlobalVar_0061DF08
|
005DA2B9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA2BE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005DA2C0   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005DA2C6   E82152EDFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005DA2CB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA2D0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005DA2D2   8B8080000000           mov     eax, [eax+$0080]
005DA2D8   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005DA2DF   751B                   jnz     005DA2FC

* Reference to pointer to GlobalVar_0061DF08
|
005DA2E1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA2E6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0410
|
005DA2E8   8B8010040000           mov     eax, [eax+$0410]
005DA2EE   8B10                   mov     edx, [eax]
005DA2F0   FF5258                 call    dword ptr [edx+$58]
005DA2F3   3B45E8                 cmp     eax, [ebp-$18]
005DA2F6   0F842AFFFFFF           jz      005DA226
005DA2FC   8B45E8                 mov     eax, [ebp-$18]
005DA2FF   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DA305   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DA30C   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DA312   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA317   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DA319   8B405C                 mov     eax, [eax+$5C]
005DA31C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DA31E   E8418FEFFF             call    004D3264
005DA323   8D9524FFFFFF           lea     edx, [ebp+$FFFFFF24]

* Reference to pointer to GlobalVar_0061DF08
|
005DA329   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA32E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05B4
|
005DA330   8B80B4050000           mov     eax, [eax+$05B4]
005DA336   8B08                   mov     ecx, [eax]
005DA338   FF5160                 call    dword ptr [ecx+$60]
005DA33B   8B8524FFFFFF           mov     eax, [ebp+$FFFFFF24]
005DA341   8D9528FFFFFF           lea     edx, [ebp+$FFFFFF28]

* Reference to: Unit_00408494.Proc_004091D8
|
005DA347   E88CEEE2FF             call    004091D8
005DA34C   8B8528FFFFFF           mov     eax, [ebp+$FFFFFF28]
005DA352   BAD0C75D00             mov     edx, $005DC7D0

* Reference to: System.@LStrCmp;
|
005DA357   E808ACE2FF             call    00404F64
005DA35C   0F85B4000000           jnz     005DA416
005DA362   8D9520FFFFFF           lea     edx, [ebp+$FFFFFF20]

* Reference to pointer to GlobalVar_0061DF08
|
005DA368   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA36D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DA36F   8B8084050000           mov     eax, [eax+$0584]
005DA375   8B08                   mov     ecx, [eax]
005DA377   FF5160                 call    dword ptr [ecx+$60]
005DA37A   83BD20FFFFFF00         cmp     dword ptr [ebp+$FFFFFF20], +$00
005DA381   7763                   jnbe    005DA3E6
005DA383   8D951CFFFFFF           lea     edx, [ebp+$FFFFFF1C]

* Reference to pointer to GlobalVar_0061DF08
|
005DA389   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA38E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0588
|
005DA390   8B8088050000           mov     eax, [eax+$0588]
005DA396   8B08                   mov     ecx, [eax]
005DA398   FF5160                 call    dword ptr [ecx+$60]
005DA39B   83BD1CFFFFFF00         cmp     dword ptr [ebp+$FFFFFF1C], +$00
005DA3A2   7742                   jnbe    005DA3E6
005DA3A4   8D9518FFFFFF           lea     edx, [ebp+$FFFFFF18]

* Reference to pointer to GlobalVar_0061DF08
|
005DA3AA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA3AF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DA3B1   8B8098050000           mov     eax, [eax+$0598]
005DA3B7   8B08                   mov     ecx, [eax]
005DA3B9   FF5160                 call    dword ptr [ecx+$60]
005DA3BC   83BD18FFFFFF00         cmp     dword ptr [ebp+$FFFFFF18], +$00
005DA3C3   7721                   jnbe    005DA3E6
005DA3C5   8D9514FFFFFF           lea     edx, [ebp+$FFFFFF14]

* Reference to pointer to GlobalVar_0061DF08
|
005DA3CB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA3D0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_059C
|
005DA3D2   8B809C050000           mov     eax, [eax+$059C]
005DA3D8   8B08                   mov     ecx, [eax]
005DA3DA   FF5160                 call    dword ptr [ecx+$60]
005DA3DD   83BD14FFFFFF00         cmp     dword ptr [ebp+$FFFFFF14], +$00
005DA3E4   7630                   jbe     005DA416

* Reference to pointer to GlobalVar_0061DF08
|
005DA3E6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA3EB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DA3ED   8B8034050000           mov     eax, [eax+$0534]
005DA3F3   8B10                   mov     edx, [eax]
005DA3F5   FF5258                 call    dword ptr [edx+$58]
005DA3F8   8D9510FFFFFF           lea     edx, [ebp+$FFFFFF10]

* Reference to: Unit_00408494.Proc_00409950
|
005DA3FE   E84DF5E2FF             call    00409950
005DA403   8B8510FFFFFF           mov     eax, [ebp+$FFFFFF10]
005DA409   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'lebt ? ; Sterbe-/Begr.-Daten �berpr
|                                �fen'
|
005DA40C   BADCC75D00             mov     edx, $005DC7DC

* Reference to : TForm1.Proc_005D97B8()
|
005DA411   E8A2F3FFFF             call    005D97B8
005DA416   8D950CFFFFFF           lea     edx, [ebp+$FFFFFF0C]

* Reference to pointer to GlobalVar_0061DF08
|
005DA41C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA421   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DA423   8B805C050000           mov     eax, [eax+$055C]
005DA429   8B08                   mov     ecx, [eax]
005DA42B   FF5160                 call    dword ptr [ecx+$60]
005DA42E   83BD0CFFFFFF00         cmp     dword ptr [ebp+$FFFFFF0C], +$00
005DA435   0F8696000000           jbe     005DA4D1
005DA43B   8D9508FFFFFF           lea     edx, [ebp+$FFFFFF08]

* Reference to pointer to GlobalVar_0061DF08
|
005DA441   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA446   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DA448   8B8084050000           mov     eax, [eax+$0584]
005DA44E   8B08                   mov     ecx, [eax]
005DA450   FF5160                 call    dword ptr [ecx+$60]
005DA453   83BD08FFFFFF00         cmp     dword ptr [ebp+$FFFFFF08], +$00
005DA45A   7675                   jbe     005DA4D1
005DA45C   8D9504FFFFFF           lea     edx, [ebp+$FFFFFF04]

* Reference to pointer to GlobalVar_0061DF08
|
005DA462   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA467   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DA469   8B805C050000           mov     eax, [eax+$055C]
005DA46F   8B08                   mov     ecx, [eax]
005DA471   FF5160                 call    dword ptr [ecx+$60]
005DA474   8B8504FFFFFF           mov     eax, [ebp+$FFFFFF04]
005DA47A   50                     push    eax
005DA47B   8D9500FFFFFF           lea     edx, [ebp+$FFFFFF00]

* Reference to pointer to GlobalVar_0061DF08
|
005DA481   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA486   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DA488   8B8084050000           mov     eax, [eax+$0584]
005DA48E   8B08                   mov     ecx, [eax]
005DA490   FF5160                 call    dword ptr [ecx+$60]
005DA493   8B9500FFFFFF           mov     edx, [ebp+$FFFFFF00]
005DA499   58                     pop     eax

* Reference to: System.@LStrCmp;
|
005DA49A   E8C5AAE2FF             call    00404F64
005DA49F   7630                   jbe     005DA4D1

* Reference to pointer to GlobalVar_0061DF08
|
005DA4A1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA4A6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DA4A8   8B8034050000           mov     eax, [eax+$0534]
005DA4AE   8B10                   mov     edx, [eax]
005DA4B0   FF5258                 call    dword ptr [edx+$58]
005DA4B3   8D95FCFEFFFF           lea     edx, [ebp+$FFFFFEFC]

* Reference to: Unit_00408494.Proc_00409950
|
005DA4B9   E892F4E2FF             call    00409950
005DA4BE   8B85FCFEFFFF           mov     eax, [ebp+$FFFFFEFC]
005DA4C4   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Geburts-/Sterbedaten �berpr�fen'
|
005DA4C7   BA0CC85D00             mov     edx, $005DC80C

* Reference to : TForm1.Proc_005D97B8()
|
005DA4CC   E8E7F2FFFF             call    005D97B8
005DA4D1   8D95F8FEFFFF           lea     edx, [ebp+$FFFFFEF8]

* Reference to pointer to GlobalVar_0061DF08
|
005DA4D7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA4DC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DA4DE   8B805C050000           mov     eax, [eax+$055C]
005DA4E4   8B08                   mov     ecx, [eax]
005DA4E6   FF5160                 call    dword ptr [ecx+$60]
005DA4E9   83BDF8FEFFFF00         cmp     dword ptr [ebp+$FFFFFEF8], +$00
005DA4F0   0F8696000000           jbe     005DA58C
005DA4F6   8D95F4FEFFFF           lea     edx, [ebp+$FFFFFEF4]

* Reference to pointer to GlobalVar_0061DF08
|
005DA4FC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA501   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DA503   8B8098050000           mov     eax, [eax+$0598]
005DA509   8B08                   mov     ecx, [eax]
005DA50B   FF5160                 call    dword ptr [ecx+$60]
005DA50E   83BDF4FEFFFF00         cmp     dword ptr [ebp+$FFFFFEF4], +$00
005DA515   7675                   jbe     005DA58C
005DA517   8D95F0FEFFFF           lea     edx, [ebp+$FFFFFEF0]

* Reference to pointer to GlobalVar_0061DF08
|
005DA51D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA522   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DA524   8B805C050000           mov     eax, [eax+$055C]
005DA52A   8B08                   mov     ecx, [eax]
005DA52C   FF5160                 call    dword ptr [ecx+$60]
005DA52F   8B85F0FEFFFF           mov     eax, [ebp+$FFFFFEF0]
005DA535   50                     push    eax
005DA536   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]

* Reference to pointer to GlobalVar_0061DF08
|
005DA53C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA541   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DA543   8B8098050000           mov     eax, [eax+$0598]
005DA549   8B08                   mov     ecx, [eax]
005DA54B   FF5160                 call    dword ptr [ecx+$60]
005DA54E   8B95ECFEFFFF           mov     edx, [ebp+$FFFFFEEC]
005DA554   58                     pop     eax

* Reference to: System.@LStrCmp;
|
005DA555   E80AAAE2FF             call    00404F64
005DA55A   7630                   jbe     005DA58C

* Reference to pointer to GlobalVar_0061DF08
|
005DA55C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA561   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DA563   8B8034050000           mov     eax, [eax+$0534]
005DA569   8B10                   mov     edx, [eax]
005DA56B   FF5258                 call    dword ptr [edx+$58]
005DA56E   8D95E8FEFFFF           lea     edx, [ebp+$FFFFFEE8]

* Reference to: Unit_00408494.Proc_00409950
|
005DA574   E8D7F3E2FF             call    00409950
005DA579   8B85E8FEFFFF           mov     eax, [ebp+$FFFFFEE8]
005DA57F   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Geburts-/Bestatt.-Daten �berpr�fen'
|
005DA582   BA34C85D00             mov     edx, $005DC834

* Reference to : TForm1.Proc_005D97B8()
|
005DA587   E82CF2FFFF             call    005D97B8
005DA58C   8D95E4FEFFFF           lea     edx, [ebp+$FFFFFEE4]

* Reference to pointer to GlobalVar_0061DF08
|
005DA592   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA597   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005DA599   8B806C050000           mov     eax, [eax+$056C]
005DA59F   8B08                   mov     ecx, [eax]
005DA5A1   FF5160                 call    dword ptr [ecx+$60]
005DA5A4   83BDE4FEFFFF00         cmp     dword ptr [ebp+$FFFFFEE4], +$00
005DA5AB   0F8696000000           jbe     005DA647
005DA5B1   8D95E0FEFFFF           lea     edx, [ebp+$FFFFFEE0]

* Reference to pointer to GlobalVar_0061DF08
|
005DA5B7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA5BC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DA5BE   8B8084050000           mov     eax, [eax+$0584]
005DA5C4   8B08                   mov     ecx, [eax]
005DA5C6   FF5160                 call    dword ptr [ecx+$60]
005DA5C9   83BDE0FEFFFF00         cmp     dword ptr [ebp+$FFFFFEE0], +$00
005DA5D0   7675                   jbe     005DA647
005DA5D2   8D95DCFEFFFF           lea     edx, [ebp+$FFFFFEDC]

* Reference to pointer to GlobalVar_0061DF08
|
005DA5D8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA5DD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005DA5DF   8B806C050000           mov     eax, [eax+$056C]
005DA5E5   8B08                   mov     ecx, [eax]
005DA5E7   FF5160                 call    dword ptr [ecx+$60]
005DA5EA   8B85DCFEFFFF           mov     eax, [ebp+$FFFFFEDC]
005DA5F0   50                     push    eax
005DA5F1   8D95D8FEFFFF           lea     edx, [ebp+$FFFFFED8]

* Reference to pointer to GlobalVar_0061DF08
|
005DA5F7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA5FC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DA5FE   8B8084050000           mov     eax, [eax+$0584]
005DA604   8B08                   mov     ecx, [eax]
005DA606   FF5160                 call    dword ptr [ecx+$60]
005DA609   8B95D8FEFFFF           mov     edx, [ebp+$FFFFFED8]
005DA60F   58                     pop     eax

* Reference to: System.@LStrCmp;
|
005DA610   E84FA9E2FF             call    00404F64
005DA615   7630                   jbe     005DA647

* Reference to pointer to GlobalVar_0061DF08
|
005DA617   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA61C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DA61E   8B8034050000           mov     eax, [eax+$0534]
005DA624   8B10                   mov     edx, [eax]
005DA626   FF5258                 call    dword ptr [edx+$58]
005DA629   8D95D4FEFFFF           lea     edx, [ebp+$FFFFFED4]

* Reference to: Unit_00408494.Proc_00409950
|
005DA62F   E81CF3E2FF             call    00409950
005DA634   8B85D4FEFFFF           mov     eax, [ebp+$FFFFFED4]
005DA63A   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Tauf-/Sterbedaten �berpr�fen'
|
005DA63D   BA60C85D00             mov     edx, $005DC860

* Reference to : TForm1.Proc_005D97B8()
|
005DA642   E871F1FFFF             call    005D97B8
005DA647   8D95D0FEFFFF           lea     edx, [ebp+$FFFFFED0]

* Reference to pointer to GlobalVar_0061DF08
|
005DA64D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA652   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005DA654   8B806C050000           mov     eax, [eax+$056C]
005DA65A   8B08                   mov     ecx, [eax]
005DA65C   FF5160                 call    dword ptr [ecx+$60]
005DA65F   83BDD0FEFFFF00         cmp     dword ptr [ebp+$FFFFFED0], +$00
005DA666   0F8696000000           jbe     005DA702
005DA66C   8D95CCFEFFFF           lea     edx, [ebp+$FFFFFECC]

* Reference to pointer to GlobalVar_0061DF08
|
005DA672   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA677   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DA679   8B8098050000           mov     eax, [eax+$0598]
005DA67F   8B08                   mov     ecx, [eax]
005DA681   FF5160                 call    dword ptr [ecx+$60]
005DA684   83BDCCFEFFFF00         cmp     dword ptr [ebp+$FFFFFECC], +$00
005DA68B   7675                   jbe     005DA702
005DA68D   8D95C8FEFFFF           lea     edx, [ebp+$FFFFFEC8]

* Reference to pointer to GlobalVar_0061DF08
|
005DA693   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA698   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005DA69A   8B806C050000           mov     eax, [eax+$056C]
005DA6A0   8B08                   mov     ecx, [eax]
005DA6A2   FF5160                 call    dword ptr [ecx+$60]
005DA6A5   8B85C8FEFFFF           mov     eax, [ebp+$FFFFFEC8]
005DA6AB   50                     push    eax
005DA6AC   8D95C4FEFFFF           lea     edx, [ebp+$FFFFFEC4]

* Reference to pointer to GlobalVar_0061DF08
|
005DA6B2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA6B7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DA6B9   8B8098050000           mov     eax, [eax+$0598]
005DA6BF   8B08                   mov     ecx, [eax]
005DA6C1   FF5160                 call    dword ptr [ecx+$60]
005DA6C4   8B95C4FEFFFF           mov     edx, [ebp+$FFFFFEC4]
005DA6CA   58                     pop     eax

* Reference to: System.@LStrCmp;
|
005DA6CB   E894A8E2FF             call    00404F64
005DA6D0   7630                   jbe     005DA702

* Reference to pointer to GlobalVar_0061DF08
|
005DA6D2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA6D7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DA6D9   8B8034050000           mov     eax, [eax+$0534]
005DA6DF   8B10                   mov     edx, [eax]
005DA6E1   FF5258                 call    dword ptr [edx+$58]
005DA6E4   8D95C0FEFFFF           lea     edx, [ebp+$FFFFFEC0]

* Reference to: Unit_00408494.Proc_00409950
|
005DA6EA   E861F2E2FF             call    00409950
005DA6EF   8B85C0FEFFFF           mov     eax, [ebp+$FFFFFEC0]
005DA6F5   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Tauf-/Bestatt.-Daten �berpr�fen'
|
005DA6F8   BA88C85D00             mov     edx, $005DC888

* Reference to : TForm1.Proc_005D97B8()
|
005DA6FD   E8B6F0FFFF             call    005D97B8
005DA702   8D95BCFEFFFF           lea     edx, [ebp+$FFFFFEBC]

* Reference to pointer to GlobalVar_0061DF08
|
005DA708   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA70D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DA70F   8B805C050000           mov     eax, [eax+$055C]
005DA715   8B08                   mov     ecx, [eax]
005DA717   FF5160                 call    dword ptr [ecx+$60]
005DA71A   83BDBCFEFFFF00         cmp     dword ptr [ebp+$FFFFFEBC], +$00
005DA721   0F86A0000000           jbe     005DA7C7
005DA727   8D95B8FEFFFF           lea     edx, [ebp+$FFFFFEB8]

* Reference to pointer to GlobalVar_0061DF08
|
005DA72D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA732   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DA734   8B8084050000           mov     eax, [eax+$0584]
005DA73A   8B08                   mov     ecx, [eax]
005DA73C   FF5160                 call    dword ptr [ecx+$60]
005DA73F   83BDB8FEFFFF00         cmp     dword ptr [ebp+$FFFFFEB8], +$00
005DA746   767F                   jbe     005DA7C7
005DA748   8D95B4FEFFFF           lea     edx, [ebp+$FFFFFEB4]

* Reference to pointer to GlobalVar_0061DF08
|
005DA74E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA753   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DA755   8B8084050000           mov     eax, [eax+$0584]
005DA75B   8B08                   mov     ecx, [eax]
005DA75D   FF5160                 call    dword ptr [ecx+$60]
005DA760   8B85B4FEFFFF           mov     eax, [ebp+$FFFFFEB4]

* Reference to: Unit_00408494.Proc_004099B4
|
005DA766   E849F2E2FF             call    004099B4
005DA76B   8BD8                   mov     ebx, eax
005DA76D   8D95B0FEFFFF           lea     edx, [ebp+$FFFFFEB0]

* Reference to pointer to GlobalVar_0061DF08
|
005DA773   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA778   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DA77A   8B805C050000           mov     eax, [eax+$055C]
005DA780   8B08                   mov     ecx, [eax]
005DA782   FF5160                 call    dword ptr [ecx+$60]
005DA785   8B85B0FEFFFF           mov     eax, [ebp+$FFFFFEB0]

* Reference to: Unit_00408494.Proc_004099B4
|
005DA78B   E824F2E2FF             call    004099B4
005DA790   2BD8                   sub     ebx, eax
005DA792   83FB6E                 cmp     ebx, +$6E
005DA795   7E30                   jle     005DA7C7

* Reference to pointer to GlobalVar_0061DF08
|
005DA797   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA79C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DA79E   8B8034050000           mov     eax, [eax+$0534]
005DA7A4   8B10                   mov     edx, [eax]
005DA7A6   FF5258                 call    dword ptr [edx+$58]
005DA7A9   8D95ACFEFFFF           lea     edx, [ebp+$FFFFFEAC]

* Reference to: Unit_00408494.Proc_00409950
|
005DA7AF   E89CF1E2FF             call    00409950
005DA7B4   8B85ACFEFFFF           mov     eax, [ebp+$FFFFFEAC]
005DA7BA   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Geburts-/Sterbedaten �berpr�fen (Al
|                                ter)'
|
005DA7BD   BAB0C85D00             mov     edx, $005DC8B0

* Reference to : TForm1.Proc_005D97B8()
|
005DA7C2   E8F1EFFFFF             call    005D97B8
005DA7C7   8D95A8FEFFFF           lea     edx, [ebp+$FFFFFEA8]

* Reference to pointer to GlobalVar_0061DF08
|
005DA7CD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA7D2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DA7D4   8B8084050000           mov     eax, [eax+$0584]
005DA7DA   8B08                   mov     ecx, [eax]
005DA7DC   FF5160                 call    dword ptr [ecx+$60]
005DA7DF   83BDA8FEFFFF00         cmp     dword ptr [ebp+$FFFFFEA8], +$00
005DA7E6   0F868D010000           jbe     005DA979
005DA7EC   8D95A4FEFFFF           lea     edx, [ebp+$FFFFFEA4]

* Reference to pointer to GlobalVar_0061DF08
|
005DA7F2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA7F7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DA7F9   8B8098050000           mov     eax, [eax+$0598]
005DA7FF   8B08                   mov     ecx, [eax]
005DA801   FF5160                 call    dword ptr [ecx+$60]
005DA804   83BDA4FEFFFF00         cmp     dword ptr [ebp+$FFFFFEA4], +$00
005DA80B   0F8668010000           jbe     005DA979
005DA811   33C0                   xor     eax, eax
005DA813   55                     push    ebp

* Possible String Reference to: '餘���˜���<�a'
|
005DA814   686FA95D00             push    $005DA96F

***** TRY
|
005DA819   64FF30                 push    dword ptr fs:[eax]
005DA81C   648920                 mov     fs:[eax], esp
005DA81F   8D959CFEFFFF           lea     edx, [ebp+$FFFFFE9C]

* Reference to pointer to GlobalVar_0061DF08
|
005DA825   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA82A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0590
|
005DA82C   8B8090050000           mov     eax, [eax+$0590]
005DA832   8B08                   mov     ecx, [eax]
005DA834   FF5160                 call    dword ptr [ecx+$60]
005DA837   FFB59CFEFFFF           push    dword ptr [ebp+$FFFFFE9C]
005DA83D   68E0C85D00             push    $005DC8E0
005DA842   8D9598FEFFFF           lea     edx, [ebp+$FFFFFE98]

* Reference to pointer to GlobalVar_0061DF08
|
005DA848   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA84D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0594
|
005DA84F   8B8094050000           mov     eax, [eax+$0594]
005DA855   8B08                   mov     ecx, [eax]
005DA857   FF5160                 call    dword ptr [ecx+$60]
005DA85A   FFB598FEFFFF           push    dword ptr [ebp+$FFFFFE98]
005DA860   68E0C85D00             push    $005DC8E0
005DA865   8D9594FEFFFF           lea     edx, [ebp+$FFFFFE94]

* Reference to pointer to GlobalVar_0061DF08
|
005DA86B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA870   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DA872   8B8098050000           mov     eax, [eax+$0598]
005DA878   8B08                   mov     ecx, [eax]
005DA87A   FF5160                 call    dword ptr [ecx+$60]
005DA87D   FFB594FEFFFF           push    dword ptr [ebp+$FFFFFE94]
005DA883   8D85A0FEFFFF           lea     eax, [ebp+$FFFFFEA0]
005DA889   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005DA88E   E84DA6E2FF             call    00404EE0
005DA893   8B85A0FEFFFF           mov     eax, [ebp+$FFFFFEA0]

* Reference to: Unit_00408494.Proc_0040D094
|
005DA899   E8F627E3FF             call    0040D094
005DA89E   DD9D6CFFFFFF           fstp    qword ptr [ebp+$FFFFFF6C]
005DA8A4   9B                     wait
005DA8A5   8D958CFEFFFF           lea     edx, [ebp+$FFFFFE8C]

* Reference to pointer to GlobalVar_0061DF08
|
005DA8AB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA8B0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_057C
|
005DA8B2   8B807C050000           mov     eax, [eax+$057C]
005DA8B8   8B08                   mov     ecx, [eax]
005DA8BA   FF5160                 call    dword ptr [ecx+$60]
005DA8BD   FFB58CFEFFFF           push    dword ptr [ebp+$FFFFFE8C]
005DA8C3   68E0C85D00             push    $005DC8E0
005DA8C8   8D9588FEFFFF           lea     edx, [ebp+$FFFFFE88]

* Reference to pointer to GlobalVar_0061DF08
|
005DA8CE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA8D3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0580
|
005DA8D5   8B8080050000           mov     eax, [eax+$0580]
005DA8DB   8B08                   mov     ecx, [eax]
005DA8DD   FF5160                 call    dword ptr [ecx+$60]
005DA8E0   FFB588FEFFFF           push    dword ptr [ebp+$FFFFFE88]
005DA8E6   68E0C85D00             push    $005DC8E0
005DA8EB   8D9584FEFFFF           lea     edx, [ebp+$FFFFFE84]

* Reference to pointer to GlobalVar_0061DF08
|
005DA8F1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA8F6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DA8F8   8B8084050000           mov     eax, [eax+$0584]
005DA8FE   8B08                   mov     ecx, [eax]
005DA900   FF5160                 call    dword ptr [ecx+$60]
005DA903   FFB584FEFFFF           push    dword ptr [ebp+$FFFFFE84]
005DA909   8D8590FEFFFF           lea     eax, [ebp+$FFFFFE90]
005DA90F   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005DA914   E8C7A5E2FF             call    00404EE0
005DA919   8B8590FEFFFF           mov     eax, [ebp+$FFFFFE90]

* Reference to: Unit_00408494.Proc_0040D094
|
005DA91F   E87027E3FF             call    0040D094
005DA924   DCAD6CFFFFFF           fsubr   qword ptr [ebp+$FFFFFF6C]
005DA92A   D81DE4C85D00           fcomp   dword ptr [$005DC8E4]
005DA930   DFE0                   fstsw   ax
005DA932   9E                     sahf
005DA933   7330                   jnb     005DA965

* Reference to pointer to GlobalVar_0061DF08
|
005DA935   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA93A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DA93C   8B8034050000           mov     eax, [eax+$0534]
005DA942   8B10                   mov     edx, [eax]
005DA944   FF5258                 call    dword ptr [edx+$58]
005DA947   8D9580FEFFFF           lea     edx, [ebp+$FFFFFE80]

* Reference to: Unit_00408494.Proc_00409950
|
005DA94D   E8FEEFE2FF             call    00409950
005DA952   8B8580FEFFFF           mov     eax, [ebp+$FFFFFE80]
005DA958   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Sterbe-/Bestattungsdaten �berpr�fen'
|
005DA95B   BAF0C85D00             mov     edx, $005DC8F0

* Reference to : TForm1.Proc_005D97B8()
|
005DA960   E853EEFFFF             call    005D97B8
005DA965   33C0                   xor     eax, eax
005DA967   5A                     pop     edx
005DA968   59                     pop     ecx
005DA969   59                     pop     ecx
005DA96A   648910                 mov     fs:[eax], edx
005DA96D   EB0A                   jmp     005DA979

* Reference to: System.@HandleAnyException;
|
005DA96F   E9A498E2FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005DA974   E8CB9CE2FF             call    00404644

****** END
|
* Reference to pointer to GlobalVar_0061DF08
|
005DA979   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA97E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DA980   8B8034050000           mov     eax, [eax+$0534]
005DA986   8B10                   mov     edx, [eax]
005DA988   FF5258                 call    dword ptr [edx+$58]
005DA98B   8945E4                 mov     [ebp-$1C], eax

* Reference to pointer to GlobalVar_0061DF08
|
005DA98E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA993   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0538
|
005DA995   8B8038050000           mov     eax, [eax+$0538]
005DA99B   8B10                   mov     edx, [eax]
005DA99D   FF5258                 call    dword ptr [edx+$58]
005DA9A0   85C0                   test    eax, eax
005DA9A2   0F8E83060000           jle     005DB02B
005DA9A8   8D9578FEFFFF           lea     edx, [ebp+$FFFFFE78]

* Reference to pointer to GlobalVar_0061DF08
|
005DA9AE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA9B3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DA9B5   8B805C050000           mov     eax, [eax+$055C]
005DA9BB   8B08                   mov     ecx, [eax]
005DA9BD   FF5160                 call    dword ptr [ecx+$60]
005DA9C0   8B8578FEFFFF           mov     eax, [ebp+$FFFFFE78]
005DA9C6   8D957CFEFFFF           lea     edx, [ebp+$FFFFFE7C]

* Reference to: Unit_00408494.Proc_00409448
|
005DA9CC   E877EAE2FF             call    00409448
005DA9D1   83BD7CFEFFFF00         cmp     dword ptr [ebp+$FFFFFE7C], +$00
005DA9D8   0F864D060000           jbe     005DB02B
005DA9DE   8D9574FEFFFF           lea     edx, [ebp+$FFFFFE74]

* Reference to pointer to GlobalVar_0061DF08
|
005DA9E4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DA9E9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DA9EB   8B805C050000           mov     eax, [eax+$055C]
005DA9F1   8B08                   mov     ecx, [eax]
005DA9F3   FF5160                 call    dword ptr [ecx+$60]
005DA9F6   8B8574FEFFFF           mov     eax, [ebp+$FFFFFE74]

* Reference to: Unit_00408494.Proc_004099B4
|
005DA9FC   E8B3EFE2FF             call    004099B4
005DAA01   8BD8                   mov     ebx, eax
005DAA03   8D956CFEFFFF           lea     edx, [ebp+$FFFFFE6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAA09   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAA0E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0558
|
005DAA10   8B8058050000           mov     eax, [eax+$0558]
005DAA16   8B08                   mov     ecx, [eax]
005DAA18   FF5160                 call    dword ptr [ecx+$60]
005DAA1B   8B856CFEFFFF           mov     eax, [ebp+$FFFFFE6C]
005DAA21   8D9570FEFFFF           lea     edx, [ebp+$FFFFFE70]

* Reference to: Unit_00408494.Proc_00409448
|
005DAA27   E81CEAE2FF             call    00409448
005DAA2C   83BD70FEFFFF00         cmp     dword ptr [ebp+$FFFFFE70], +$00
005DAA33   0F861F040000           jbe     005DAE58

* Reference to pointer to GlobalVar_0061DF08
|
005DAA39   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAA3E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0538
|
005DAA40   8B8038050000           mov     eax, [eax+$0538]
005DAA46   8B10                   mov     edx, [eax]
005DAA48   FF5258                 call    dword ptr [edx+$58]
005DAA4B   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DAA51   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DAA58   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAA5E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAA63   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DAA65   8B405C                 mov     eax, [eax+$5C]
005DAA68   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DAA6A   E8F587EFFF             call    004D3264
005DAA6F   8D9564FEFFFF           lea     edx, [ebp+$FFFFFE64]

* Reference to pointer to GlobalVar_0061DF08
|
005DAA75   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAA7A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DAA7C   8B805C050000           mov     eax, [eax+$055C]
005DAA82   8B08                   mov     ecx, [eax]
005DAA84   FF5160                 call    dword ptr [ecx+$60]
005DAA87   8B8564FEFFFF           mov     eax, [ebp+$FFFFFE64]
005DAA8D   8D9568FEFFFF           lea     edx, [ebp+$FFFFFE68]

* Reference to: Unit_00408494.Proc_00409448
|
005DAA93   E8B0E9E2FF             call    00409448
005DAA98   83BD68FEFFFF00         cmp     dword ptr [ebp+$FFFFFE68], +$00
005DAA9F   7648                   jbe     005DAAE9
005DAAA1   8D9560FEFFFF           lea     edx, [ebp+$FFFFFE60]

* Reference to pointer to GlobalVar_0061DF08
|
005DAAA7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAAAC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DAAAE   8B805C050000           mov     eax, [eax+$055C]
005DAAB4   8B08                   mov     ecx, [eax]
005DAAB6   FF5160                 call    dword ptr [ecx+$60]
005DAAB9   8B8560FEFFFF           mov     eax, [ebp+$FFFFFE60]

* Reference to: Unit_00408494.Proc_004099B4
|
005DAABF   E8F0EEE2FF             call    004099B4
005DAAC4   3BD8                   cmp     ebx, eax
005DAAC6   7F21                   jnle    005DAAE9
005DAAC8   8D955CFEFFFF           lea     edx, [ebp+$FFFFFE5C]
005DAACE   8B45E4                 mov     eax, [ebp-$1C]

* Reference to: Unit_00408494.Proc_00409950
|
005DAAD1   E87AEEE2FF             call    00409950
005DAAD6   8B855CFEFFFF           mov     eax, [ebp+$FFFFFE5C]
005DAADC   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Kind vor Vater geboren'
|
005DAADF   BA1CC95D00             mov     edx, $005DC91C

* Reference to : TForm1.Proc_005D97B8()
|
005DAAE4   E8CFECFFFF             call    005D97B8
005DAAE9   8D9554FEFFFF           lea     edx, [ebp+$FFFFFE54]

* Reference to pointer to GlobalVar_0061DF08
|
005DAAEF   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAAF4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DAAF6   8B8084050000           mov     eax, [eax+$0584]
005DAAFC   8B08                   mov     ecx, [eax]
005DAAFE   FF5160                 call    dword ptr [ecx+$60]
005DAB01   8B8554FEFFFF           mov     eax, [ebp+$FFFFFE54]
005DAB07   8D9558FEFFFF           lea     edx, [ebp+$FFFFFE58]

* Reference to: Unit_00408494.Proc_00409448
|
005DAB0D   E836E9E2FF             call    00409448
005DAB12   83BD58FEFFFF00         cmp     dword ptr [ebp+$FFFFFE58], +$00
005DAB19   0F860C050000           jbe     005DB02B
005DAB1F   8D954CFEFFFF           lea     edx, [ebp+$FFFFFE4C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAB25   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAB2A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0580
|
005DAB2C   8B8080050000           mov     eax, [eax+$0580]
005DAB32   8B08                   mov     ecx, [eax]
005DAB34   FF5160                 call    dword ptr [ecx+$60]
005DAB37   8B854CFEFFFF           mov     eax, [ebp+$FFFFFE4C]
005DAB3D   8D9550FEFFFF           lea     edx, [ebp+$FFFFFE50]

* Reference to: Unit_00408494.Proc_00409448
|
005DAB43   E800E9E2FF             call    00409448
005DAB48   83BD50FEFFFF00         cmp     dword ptr [ebp+$FFFFFE50], +$00
005DAB4F   0F8628010000           jbe     005DAC7D
005DAB55   33C0                   xor     eax, eax
005DAB57   55                     push    ebp
005DAB58   686EAC5D00             push    $005DAC6E

***** TRY
|
005DAB5D   64FF30                 push    dword ptr fs:[eax]
005DAB60   648920                 mov     fs:[eax], esp
005DAB63   8D9548FEFFFF           lea     edx, [ebp+$FFFFFE48]

* Reference to pointer to GlobalVar_0061DF08
|
005DAB69   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAB6E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DAB70   8B8084050000           mov     eax, [eax+$0584]
005DAB76   8B08                   mov     ecx, [eax]
005DAB78   FF5160                 call    dword ptr [ecx+$60]
005DAB7B   8B8548FEFFFF           mov     eax, [ebp+$FFFFFE48]

* Reference to: Unit_00408494.Proc_004099B4
|
005DAB81   E82EEEE2FF             call    004099B4
005DAB86   8BD8                   mov     ebx, eax
005DAB88   C1E302                 shl     ebx, $02
005DAB8B   8D1C5B                 lea     ebx, [ebx+ebx*2]
005DAB8E   8D9544FEFFFF           lea     edx, [ebp+$FFFFFE44]

* Reference to pointer to GlobalVar_0061DF08
|
005DAB94   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAB99   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0580
|
005DAB9B   8B8080050000           mov     eax, [eax+$0580]
005DABA1   8B08                   mov     ecx, [eax]
005DABA3   FF5160                 call    dword ptr [ecx+$60]
005DABA6   8B8544FEFFFF           mov     eax, [ebp+$FFFFFE44]

* Reference to: Unit_00408494.Proc_004099B4
|
005DABAC   E803EEE2FF             call    004099B4
005DABB1   03D8                   add     ebx, eax
005DABB3   8B45E4                 mov     eax, [ebp-$1C]
005DABB6   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DABBC   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DABC3   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DABC9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DABCE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DABD0   8B405C                 mov     eax, [eax+$5C]
005DABD3   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DABD5   E88A86EFFF             call    004D3264
005DABDA   8D9540FEFFFF           lea     edx, [ebp+$FFFFFE40]

* Reference to pointer to GlobalVar_0061DF08
|
005DABE0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DABE5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DABE7   8B805C050000           mov     eax, [eax+$055C]
005DABED   8B08                   mov     ecx, [eax]
005DABEF   FF5160                 call    dword ptr [ecx+$60]
005DABF2   8B8540FEFFFF           mov     eax, [ebp+$FFFFFE40]

* Reference to: Unit_00408494.Proc_004099B4
|
005DABF8   E8B7EDE2FF             call    004099B4
005DABFD   8BF0                   mov     esi, eax
005DABFF   C1E602                 shl     esi, $02
005DAC02   8D3476                 lea     esi, [esi+esi*2]
005DAC05   8D953CFEFFFF           lea     edx, [ebp+$FFFFFE3C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAC0B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAC10   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0558
|
005DAC12   8B8058050000           mov     eax, [eax+$0558]
005DAC18   8B08                   mov     ecx, [eax]
005DAC1A   FF5160                 call    dword ptr [ecx+$60]
005DAC1D   8B853CFEFFFF           mov     eax, [ebp+$FFFFFE3C]

* Reference to: Unit_00408494.Proc_004099B4
|
005DAC23   E88CEDE2FF             call    004099B4
005DAC28   03F0                   add     esi, eax
005DAC2A   2BF3                   sub     esi, ebx
005DAC2C   83FE09                 cmp     esi, +$09
005DAC2F   7E30                   jle     005DAC61

* Reference to pointer to GlobalVar_0061DF08
|
005DAC31   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAC36   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DAC38   8B8034050000           mov     eax, [eax+$0534]
005DAC3E   8B10                   mov     edx, [eax]
005DAC40   FF5258                 call    dword ptr [edx+$58]
005DAC43   8D9538FEFFFF           lea     edx, [ebp+$FFFFFE38]

* Reference to: Unit_00408494.Proc_00409950
|
005DAC49   E802EDE2FF             call    00409950
005DAC4E   8B8538FEFFFF           mov     eax, [ebp+$FFFFFE38]
005DAC54   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Vater bei Geb.d.Kindes > 9 Mon.tot'
|
005DAC57   BA3CC95D00             mov     edx, $005DC93C

* Reference to : TForm1.Proc_005D97B8()
|
005DAC5C   E857EBFFFF             call    005D97B8
005DAC61   33C0                   xor     eax, eax
005DAC63   5A                     pop     edx
005DAC64   59                     pop     ecx
005DAC65   59                     pop     ecx
005DAC66   648910                 mov     fs:[eax], edx
005DAC69   E9BD030000             jmp     005DB02B

* Reference to: System.@HandleAnyException;
|
005DAC6E   E9A595E2FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005DAC73   E8CC99E2FF             call    00404644
005DAC78   E9AE030000             jmp     005DB02B
005DAC7D   8B45E4                 mov     eax, [ebp-$1C]
005DAC80   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DAC86   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DAC8D   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAC93   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAC98   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DAC9A   8B405C                 mov     eax, [eax+$5C]
005DAC9D   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DAC9F   E8C085EFFF             call    004D3264

* Reference to pointer to GlobalVar_0061DF08
|
005DACA4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DACA9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0538
|
005DACAB   8B8038050000           mov     eax, [eax+$0538]
005DACB1   8B10                   mov     edx, [eax]
005DACB3   FF5258                 call    dword ptr [edx+$58]
005DACB6   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DACBC   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DACC3   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DACC9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DACCE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DACD0   8B405C                 mov     eax, [eax+$5C]
005DACD3   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DACD5   E88A85EFFF             call    004D3264
005DACDA   8D9530FEFFFF           lea     edx, [ebp+$FFFFFE30]

* Reference to pointer to GlobalVar_0061DF08
|
005DACE0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DACE5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DACE7   8B805C050000           mov     eax, [eax+$055C]
005DACED   8B08                   mov     ecx, [eax]
005DACEF   FF5160                 call    dword ptr [ecx+$60]
005DACF2   8B8530FEFFFF           mov     eax, [ebp+$FFFFFE30]
005DACF8   8D9534FEFFFF           lea     edx, [ebp+$FFFFFE34]

* Reference to: Unit_00408494.Proc_00409448
|
005DACFE   E845E7E2FF             call    00409448
005DAD03   83BD34FEFFFF00         cmp     dword ptr [ebp+$FFFFFE34], +$00
005DAD0A   7648                   jbe     005DAD54
005DAD0C   8D952CFEFFFF           lea     edx, [ebp+$FFFFFE2C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAD12   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAD17   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DAD19   8B805C050000           mov     eax, [eax+$055C]
005DAD1F   8B08                   mov     ecx, [eax]
005DAD21   FF5160                 call    dword ptr [ecx+$60]
005DAD24   8B852CFEFFFF           mov     eax, [ebp+$FFFFFE2C]

* Reference to: Unit_00408494.Proc_004099B4
|
005DAD2A   E885ECE2FF             call    004099B4
005DAD2F   3BD8                   cmp     ebx, eax
005DAD31   7F21                   jnle    005DAD54
005DAD33   8D9528FEFFFF           lea     edx, [ebp+$FFFFFE28]
005DAD39   8B45E4                 mov     eax, [ebp-$1C]

* Reference to: Unit_00408494.Proc_00409950
|
005DAD3C   E80FECE2FF             call    00409950
005DAD41   8B8528FEFFFF           mov     eax, [ebp+$FFFFFE28]
005DAD47   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Kind vor Vater geboren'
|
005DAD4A   BA1CC95D00             mov     edx, $005DC91C

* Reference to : TForm1.Proc_005D97B8()
|
005DAD4F   E864EAFFFF             call    005D97B8
005DAD54   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]

* Reference to pointer to GlobalVar_0061DF08
|
005DAD5A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAD5F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DAD61   8B8084050000           mov     eax, [eax+$0584]
005DAD67   8B08                   mov     ecx, [eax]
005DAD69   FF5160                 call    dword ptr [ecx+$60]
005DAD6C   8B8520FEFFFF           mov     eax, [ebp+$FFFFFE20]
005DAD72   8D9524FEFFFF           lea     edx, [ebp+$FFFFFE24]

* Reference to: Unit_00408494.Proc_00409448
|
005DAD78   E8CBE6E2FF             call    00409448
005DAD7D   83BD24FEFFFF00         cmp     dword ptr [ebp+$FFFFFE24], +$00
005DAD84   0F86A1020000           jbe     005DB02B
005DAD8A   33C0                   xor     eax, eax
005DAD8C   55                     push    ebp
005DAD8D   6849AE5D00             push    $005DAE49

***** TRY
|
005DAD92   64FF30                 push    dword ptr fs:[eax]
005DAD95   648920                 mov     fs:[eax], esp
005DAD98   8D951CFEFFFF           lea     edx, [ebp+$FFFFFE1C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAD9E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DADA3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DADA5   8B8084050000           mov     eax, [eax+$0584]
005DADAB   8B08                   mov     ecx, [eax]
005DADAD   FF5160                 call    dword ptr [ecx+$60]
005DADB0   8B851CFEFFFF           mov     eax, [ebp+$FFFFFE1C]

* Reference to: Unit_00408494.Proc_004099B4
|
005DADB6   E8F9EBE2FF             call    004099B4
005DADBB   8BD8                   mov     ebx, eax
005DADBD   8B45E4                 mov     eax, [ebp-$1C]
005DADC0   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DADC6   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DADCD   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DADD3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DADD8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DADDA   8B405C                 mov     eax, [eax+$5C]
005DADDD   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DADDF   E88084EFFF             call    004D3264
005DADE4   8D9518FEFFFF           lea     edx, [ebp+$FFFFFE18]

* Reference to pointer to GlobalVar_0061DF08
|
005DADEA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DADEF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DADF1   8B805C050000           mov     eax, [eax+$055C]
005DADF7   8B08                   mov     ecx, [eax]
005DADF9   FF5160                 call    dword ptr [ecx+$60]
005DADFC   8B8518FEFFFF           mov     eax, [ebp+$FFFFFE18]

* Reference to: Unit_00408494.Proc_004099B4
|
005DAE02   E8ADEBE2FF             call    004099B4
005DAE07   2BC3                   sub     eax, ebx
005DAE09   48                     dec     eax
005DAE0A   7C30                   jl      005DAE3C

* Reference to pointer to GlobalVar_0061DF08
|
005DAE0C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAE11   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DAE13   8B8034050000           mov     eax, [eax+$0534]
005DAE19   8B10                   mov     edx, [eax]
005DAE1B   FF5258                 call    dword ptr [edx+$58]
005DAE1E   8D9514FEFFFF           lea     edx, [ebp+$FFFFFE14]

* Reference to: Unit_00408494.Proc_00409950
|
005DAE24   E827EBE2FF             call    00409950
005DAE29   8B8514FEFFFF           mov     eax, [ebp+$FFFFFE14]
005DAE2F   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Vater bei Geb.d.Kindes >= 1 J. tot 
|                                ?'
|
005DAE32   BA68C95D00             mov     edx, $005DC968

* Reference to : TForm1.Proc_005D97B8()
|
005DAE37   E87CE9FFFF             call    005D97B8
005DAE3C   33C0                   xor     eax, eax
005DAE3E   5A                     pop     edx
005DAE3F   59                     pop     ecx
005DAE40   59                     pop     ecx
005DAE41   648910                 mov     fs:[eax], edx
005DAE44   E9E2010000             jmp     005DB02B

* Reference to: System.@HandleAnyException;
|
005DAE49   E9CA93E2FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005DAE4E   E8F197E2FF             call    00404644
005DAE53   E9D3010000             jmp     005DB02B
005DAE58   8B45E4                 mov     eax, [ebp-$1C]
005DAE5B   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DAE61   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DAE68   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAE6E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAE73   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DAE75   8B405C                 mov     eax, [eax+$5C]
005DAE78   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DAE7A   E8E583EFFF             call    004D3264

* Reference to pointer to GlobalVar_0061DF08
|
005DAE7F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAE84   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0538
|
005DAE86   8B8038050000           mov     eax, [eax+$0538]
005DAE8C   8B10                   mov     edx, [eax]
005DAE8E   FF5258                 call    dword ptr [edx+$58]
005DAE91   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DAE97   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DAE9E   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAEA4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAEA9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DAEAB   8B405C                 mov     eax, [eax+$5C]
005DAEAE   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DAEB0   E8AF83EFFF             call    004D3264
005DAEB5   8D950CFEFFFF           lea     edx, [ebp+$FFFFFE0C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAEBB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAEC0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DAEC2   8B805C050000           mov     eax, [eax+$055C]
005DAEC8   8B08                   mov     ecx, [eax]
005DAECA   FF5160                 call    dword ptr [ecx+$60]
005DAECD   8B850CFEFFFF           mov     eax, [ebp+$FFFFFE0C]
005DAED3   8D9510FEFFFF           lea     edx, [ebp+$FFFFFE10]

* Reference to: Unit_00408494.Proc_00409448
|
005DAED9   E86AE5E2FF             call    00409448
005DAEDE   83BD10FEFFFF00         cmp     dword ptr [ebp+$FFFFFE10], +$00
005DAEE5   7648                   jbe     005DAF2F
005DAEE7   8D9508FEFFFF           lea     edx, [ebp+$FFFFFE08]

* Reference to pointer to GlobalVar_0061DF08
|
005DAEED   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAEF2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DAEF4   8B805C050000           mov     eax, [eax+$055C]
005DAEFA   8B08                   mov     ecx, [eax]
005DAEFC   FF5160                 call    dword ptr [ecx+$60]
005DAEFF   8B8508FEFFFF           mov     eax, [ebp+$FFFFFE08]

* Reference to: Unit_00408494.Proc_004099B4
|
005DAF05   E8AAEAE2FF             call    004099B4
005DAF0A   3BD8                   cmp     ebx, eax
005DAF0C   7F21                   jnle    005DAF2F
005DAF0E   8D9504FEFFFF           lea     edx, [ebp+$FFFFFE04]
005DAF14   8B45E4                 mov     eax, [ebp-$1C]

* Reference to: Unit_00408494.Proc_00409950
|
005DAF17   E834EAE2FF             call    00409950
005DAF1C   8B8504FEFFFF           mov     eax, [ebp+$FFFFFE04]
005DAF22   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Kind vor Vater geboren'
|
005DAF25   BA1CC95D00             mov     edx, $005DC91C

* Reference to : TForm1.Proc_005D97B8()
|
005DAF2A   E889E8FFFF             call    005D97B8
005DAF2F   8D95FCFDFFFF           lea     edx, [ebp+$FFFFFDFC]

* Reference to pointer to GlobalVar_0061DF08
|
005DAF35   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAF3A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DAF3C   8B8084050000           mov     eax, [eax+$0584]
005DAF42   8B08                   mov     ecx, [eax]
005DAF44   FF5160                 call    dword ptr [ecx+$60]
005DAF47   8B85FCFDFFFF           mov     eax, [ebp+$FFFFFDFC]
005DAF4D   8D9500FEFFFF           lea     edx, [ebp+$FFFFFE00]

* Reference to: Unit_00408494.Proc_00409448
|
005DAF53   E8F0E4E2FF             call    00409448
005DAF58   83BD00FEFFFF00         cmp     dword ptr [ebp+$FFFFFE00], +$00
005DAF5F   0F86C6000000           jbe     005DB02B
005DAF65   33C0                   xor     eax, eax
005DAF67   55                     push    ebp
005DAF68   6821B05D00             push    $005DB021

***** TRY
|
005DAF6D   64FF30                 push    dword ptr fs:[eax]
005DAF70   648920                 mov     fs:[eax], esp
005DAF73   8D95F8FDFFFF           lea     edx, [ebp+$FFFFFDF8]

* Reference to pointer to GlobalVar_0061DF08
|
005DAF79   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAF7E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DAF80   8B8084050000           mov     eax, [eax+$0584]
005DAF86   8B08                   mov     ecx, [eax]
005DAF88   FF5160                 call    dword ptr [ecx+$60]
005DAF8B   8B85F8FDFFFF           mov     eax, [ebp+$FFFFFDF8]

* Reference to: Unit_00408494.Proc_004099B4
|
005DAF91   E81EEAE2FF             call    004099B4
005DAF96   8BD8                   mov     ebx, eax
005DAF98   8B45E4                 mov     eax, [ebp-$1C]
005DAF9B   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DAFA1   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DAFA8   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DAFAE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAFB3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DAFB5   8B405C                 mov     eax, [eax+$5C]
005DAFB8   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DAFBA   E8A582EFFF             call    004D3264
005DAFBF   8D95F4FDFFFF           lea     edx, [ebp+$FFFFFDF4]

* Reference to pointer to GlobalVar_0061DF08
|
005DAFC5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAFCA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DAFCC   8B805C050000           mov     eax, [eax+$055C]
005DAFD2   8B08                   mov     ecx, [eax]
005DAFD4   FF5160                 call    dword ptr [ecx+$60]
005DAFD7   8B85F4FDFFFF           mov     eax, [ebp+$FFFFFDF4]

* Reference to: Unit_00408494.Proc_004099B4
|
005DAFDD   E8D2E9E2FF             call    004099B4
005DAFE2   2BC3                   sub     eax, ebx
005DAFE4   48                     dec     eax
005DAFE5   7C30                   jl      005DB017

* Reference to pointer to GlobalVar_0061DF08
|
005DAFE7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DAFEC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DAFEE   8B8034050000           mov     eax, [eax+$0534]
005DAFF4   8B10                   mov     edx, [eax]
005DAFF6   FF5258                 call    dword ptr [edx+$58]
005DAFF9   8D95F0FDFFFF           lea     edx, [ebp+$FFFFFDF0]

* Reference to: Unit_00408494.Proc_00409950
|
005DAFFF   E84CE9E2FF             call    00409950
005DB004   8B85F0FDFFFF           mov     eax, [ebp+$FFFFFDF0]
005DB00A   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Vater bei Geb.d.Kindes >= 1 J. tot 
|                                ?'
|
005DB00D   BA68C95D00             mov     edx, $005DC968

* Reference to : TForm1.Proc_005D97B8()
|
005DB012   E8A1E7FFFF             call    005D97B8
005DB017   33C0                   xor     eax, eax
005DB019   5A                     pop     edx
005DB01A   59                     pop     ecx
005DB01B   59                     pop     ecx
005DB01C   648910                 mov     fs:[eax], edx
005DB01F   EB0A                   jmp     005DB02B

* Reference to: System.@HandleAnyException;
|
005DB021   E9F291E2FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005DB026   E81996E2FF             call    00404644

****** END
|
005DB02B   8B45E8                 mov     eax, [ebp-$18]
005DB02E   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB034   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB03B   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB041   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB046   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DB048   8B405C                 mov     eax, [eax+$5C]
005DB04B   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB04D   E81282EFFF             call    004D3264

* Reference to pointer to GlobalVar_0061DF08
|
005DB052   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB057   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DB059   8B8034050000           mov     eax, [eax+$0534]
005DB05F   8B10                   mov     edx, [eax]
005DB061   FF5258                 call    dword ptr [edx+$58]
005DB064   8945E4                 mov     [ebp-$1C], eax

* Reference to pointer to GlobalVar_0061DF08
|
005DB067   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB06C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_053C
|
005DB06E   8B803C050000           mov     eax, [eax+$053C]
005DB074   8B10                   mov     edx, [eax]
005DB076   FF5258                 call    dword ptr [edx+$58]
005DB079   85C0                   test    eax, eax
005DB07B   0F8E08060000           jle     005DB689
005DB081   8D95E8FDFFFF           lea     edx, [ebp+$FFFFFDE8]

* Reference to pointer to GlobalVar_0061DF08
|
005DB087   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB08C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB08E   8B805C050000           mov     eax, [eax+$055C]
005DB094   8B08                   mov     ecx, [eax]
005DB096   FF5160                 call    dword ptr [ecx+$60]
005DB099   8B85E8FDFFFF           mov     eax, [ebp+$FFFFFDE8]
005DB09F   8D95ECFDFFFF           lea     edx, [ebp+$FFFFFDEC]

* Reference to: Unit_00408494.Proc_00409448
|
005DB0A5   E89EE3E2FF             call    00409448
005DB0AA   83BDECFDFFFF00         cmp     dword ptr [ebp+$FFFFFDEC], +$00
005DB0B1   0F86D2050000           jbe     005DB689
005DB0B7   8D95E4FDFFFF           lea     edx, [ebp+$FFFFFDE4]

* Reference to pointer to GlobalVar_0061DF08
|
005DB0BD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB0C2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB0C4   8B805C050000           mov     eax, [eax+$055C]
005DB0CA   8B08                   mov     ecx, [eax]
005DB0CC   FF5160                 call    dword ptr [ecx+$60]
005DB0CF   8B85E4FDFFFF           mov     eax, [ebp+$FFFFFDE4]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB0D5   E8DAE8E2FF             call    004099B4
005DB0DA   8BD8                   mov     ebx, eax
005DB0DC   8D95DCFDFFFF           lea     edx, [ebp+$FFFFFDDC]

* Reference to pointer to GlobalVar_0061DF08
|
005DB0E2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB0E7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0558
|
005DB0E9   8B8058050000           mov     eax, [eax+$0558]
005DB0EF   8B08                   mov     ecx, [eax]
005DB0F1   FF5160                 call    dword ptr [ecx+$60]
005DB0F4   8B85DCFDFFFF           mov     eax, [ebp+$FFFFFDDC]
005DB0FA   8D95E0FDFFFF           lea     edx, [ebp+$FFFFFDE0]

* Reference to: Unit_00408494.Proc_00409448
|
005DB100   E843E3E2FF             call    00409448
005DB105   83BDE0FDFFFF00         cmp     dword ptr [ebp+$FFFFFDE0], +$00
005DB10C   0F86A4030000           jbe     005DB4B6

* Reference to pointer to GlobalVar_0061DF08
|
005DB112   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB117   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_053C
|
005DB119   8B803C050000           mov     eax, [eax+$053C]
005DB11F   8B10                   mov     edx, [eax]
005DB121   FF5258                 call    dword ptr [edx+$58]
005DB124   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB12A   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB131   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB137   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB13C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DB13E   8B405C                 mov     eax, [eax+$5C]
005DB141   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB143   E81C81EFFF             call    004D3264
005DB148   8D95D4FDFFFF           lea     edx, [ebp+$FFFFFDD4]

* Reference to pointer to GlobalVar_0061DF08
|
005DB14E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB153   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB155   8B805C050000           mov     eax, [eax+$055C]
005DB15B   8B08                   mov     ecx, [eax]
005DB15D   FF5160                 call    dword ptr [ecx+$60]
005DB160   8B85D4FDFFFF           mov     eax, [ebp+$FFFFFDD4]
005DB166   8D95D8FDFFFF           lea     edx, [ebp+$FFFFFDD8]

* Reference to: Unit_00408494.Proc_00409448
|
005DB16C   E8D7E2E2FF             call    00409448
005DB171   83BDD8FDFFFF00         cmp     dword ptr [ebp+$FFFFFDD8], +$00
005DB178   7648                   jbe     005DB1C2
005DB17A   8D95D0FDFFFF           lea     edx, [ebp+$FFFFFDD0]

* Reference to pointer to GlobalVar_0061DF08
|
005DB180   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB185   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB187   8B805C050000           mov     eax, [eax+$055C]
005DB18D   8B08                   mov     ecx, [eax]
005DB18F   FF5160                 call    dword ptr [ecx+$60]
005DB192   8B85D0FDFFFF           mov     eax, [ebp+$FFFFFDD0]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB198   E817E8E2FF             call    004099B4
005DB19D   3BD8                   cmp     ebx, eax
005DB19F   7F21                   jnle    005DB1C2
005DB1A1   8D95CCFDFFFF           lea     edx, [ebp+$FFFFFDCC]
005DB1A7   8B45E4                 mov     eax, [ebp-$1C]

* Reference to: Unit_00408494.Proc_00409950
|
005DB1AA   E8A1E7E2FF             call    00409950
005DB1AF   8B85CCFDFFFF           mov     eax, [ebp+$FFFFFDCC]
005DB1B5   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Kind vor Mutter geboren'
|
005DB1B8   BA98C95D00             mov     edx, $005DC998

* Reference to : TForm1.Proc_005D97B8()
|
005DB1BD   E8F6E5FFFF             call    005D97B8
005DB1C2   8D95C4FDFFFF           lea     edx, [ebp+$FFFFFDC4]

* Reference to pointer to GlobalVar_0061DF08
|
005DB1C8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB1CD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DB1CF   8B8084050000           mov     eax, [eax+$0584]
005DB1D5   8B08                   mov     ecx, [eax]
005DB1D7   FF5160                 call    dword ptr [ecx+$60]
005DB1DA   8B85C4FDFFFF           mov     eax, [ebp+$FFFFFDC4]
005DB1E0   8D95C8FDFFFF           lea     edx, [ebp+$FFFFFDC8]

* Reference to: Unit_00408494.Proc_00409448
|
005DB1E6   E85DE2E2FF             call    00409448
005DB1EB   83BDC8FDFFFF00         cmp     dword ptr [ebp+$FFFFFDC8], +$00
005DB1F2   0F8691040000           jbe     005DB689
005DB1F8   8D95BCFDFFFF           lea     edx, [ebp+$FFFFFDBC]

* Reference to pointer to GlobalVar_0061DF08
|
005DB1FE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB203   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0580
|
005DB205   8B8080050000           mov     eax, [eax+$0580]
005DB20B   8B08                   mov     ecx, [eax]
005DB20D   FF5160                 call    dword ptr [ecx+$60]
005DB210   8B85BCFDFFFF           mov     eax, [ebp+$FFFFFDBC]
005DB216   8D95C0FDFFFF           lea     edx, [ebp+$FFFFFDC0]

* Reference to: Unit_00408494.Proc_00409448
|
005DB21C   E827E2E2FF             call    00409448
005DB221   83BDC0FDFFFF00         cmp     dword ptr [ebp+$FFFFFDC0], +$00
005DB228   0F8627010000           jbe     005DB355
005DB22E   33C0                   xor     eax, eax
005DB230   55                     push    ebp
005DB231   6846B35D00             push    $005DB346

***** TRY
|
005DB236   64FF30                 push    dword ptr fs:[eax]
005DB239   648920                 mov     fs:[eax], esp
005DB23C   8D95B8FDFFFF           lea     edx, [ebp+$FFFFFDB8]

* Reference to pointer to GlobalVar_0061DF08
|
005DB242   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB247   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DB249   8B8084050000           mov     eax, [eax+$0584]
005DB24F   8B08                   mov     ecx, [eax]
005DB251   FF5160                 call    dword ptr [ecx+$60]
005DB254   8B85B8FDFFFF           mov     eax, [ebp+$FFFFFDB8]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB25A   E855E7E2FF             call    004099B4
005DB25F   8BD8                   mov     ebx, eax
005DB261   C1E302                 shl     ebx, $02
005DB264   8D1C5B                 lea     ebx, [ebx+ebx*2]
005DB267   8D95B4FDFFFF           lea     edx, [ebp+$FFFFFDB4]

* Reference to pointer to GlobalVar_0061DF08
|
005DB26D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB272   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0580
|
005DB274   8B8080050000           mov     eax, [eax+$0580]
005DB27A   8B08                   mov     ecx, [eax]
005DB27C   FF5160                 call    dword ptr [ecx+$60]
005DB27F   8B85B4FDFFFF           mov     eax, [ebp+$FFFFFDB4]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB285   E82AE7E2FF             call    004099B4
005DB28A   03D8                   add     ebx, eax
005DB28C   8B45E4                 mov     eax, [ebp-$1C]
005DB28F   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB295   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB29C   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB2A2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB2A7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DB2A9   8B405C                 mov     eax, [eax+$5C]
005DB2AC   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB2AE   E8B17FEFFF             call    004D3264
005DB2B3   8D95B0FDFFFF           lea     edx, [ebp+$FFFFFDB0]

* Reference to pointer to GlobalVar_0061DF08
|
005DB2B9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB2BE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB2C0   8B805C050000           mov     eax, [eax+$055C]
005DB2C6   8B08                   mov     ecx, [eax]
005DB2C8   FF5160                 call    dword ptr [ecx+$60]
005DB2CB   8B85B0FDFFFF           mov     eax, [ebp+$FFFFFDB0]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB2D1   E8DEE6E2FF             call    004099B4
005DB2D6   8BF0                   mov     esi, eax
005DB2D8   C1E602                 shl     esi, $02
005DB2DB   8D3476                 lea     esi, [esi+esi*2]
005DB2DE   8D95ACFDFFFF           lea     edx, [ebp+$FFFFFDAC]

* Reference to pointer to GlobalVar_0061DF08
|
005DB2E4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB2E9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0558
|
005DB2EB   8B8058050000           mov     eax, [eax+$0558]
005DB2F1   8B08                   mov     ecx, [eax]
005DB2F3   FF5160                 call    dword ptr [ecx+$60]
005DB2F6   8B85ACFDFFFF           mov     eax, [ebp+$FFFFFDAC]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB2FC   E8B3E6E2FF             call    004099B4
005DB301   03F0                   add     esi, eax
005DB303   2BF3                   sub     esi, ebx
005DB305   85F6                   test    esi, esi
005DB307   7E30                   jle     005DB339

* Reference to pointer to GlobalVar_0061DF08
|
005DB309   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB30E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DB310   8B8034050000           mov     eax, [eax+$0534]
005DB316   8B10                   mov     edx, [eax]
005DB318   FF5258                 call    dword ptr [edx+$58]
005DB31B   8D95A8FDFFFF           lea     edx, [ebp+$FFFFFDA8]

* Reference to: Unit_00408494.Proc_00409950
|
005DB321   E82AE6E2FF             call    00409950
005DB326   8B85A8FDFFFF           mov     eax, [ebp+$FFFFFDA8]
005DB32C   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Mutter bei Geb.d.Kindes tot'
|
005DB32F   BAB8C95D00             mov     edx, $005DC9B8

* Reference to : TForm1.Proc_005D97B8()
|
005DB334   E87FE4FFFF             call    005D97B8
005DB339   33C0                   xor     eax, eax
005DB33B   5A                     pop     edx
005DB33C   59                     pop     ecx
005DB33D   59                     pop     ecx
005DB33E   648910                 mov     fs:[eax], edx
005DB341   E943030000             jmp     005DB689

* Reference to: System.@HandleAnyException;
|
005DB346   E9CD8EE2FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005DB34B   E8F492E2FF             call    00404644
005DB350   E934030000             jmp     005DB689
005DB355   8B45E4                 mov     eax, [ebp-$1C]
005DB358   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB35E   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB365   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB36B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB370   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DB372   8B405C                 mov     eax, [eax+$5C]
005DB375   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB377   E8E87EEFFF             call    004D3264

* Reference to pointer to GlobalVar_0061DF08
|
005DB37C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB381   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_053C
|
005DB383   8B803C050000           mov     eax, [eax+$053C]
005DB389   8B10                   mov     edx, [eax]
005DB38B   FF5258                 call    dword ptr [edx+$58]
005DB38E   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB394   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB39B   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB3A1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB3A6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DB3A8   8B405C                 mov     eax, [eax+$5C]
005DB3AB   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB3AD   E8B27EEFFF             call    004D3264
005DB3B2   8D95A0FDFFFF           lea     edx, [ebp+$FFFFFDA0]

* Reference to pointer to GlobalVar_0061DF08
|
005DB3B8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB3BD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DB3BF   8B8084050000           mov     eax, [eax+$0584]
005DB3C5   8B08                   mov     ecx, [eax]
005DB3C7   FF5160                 call    dword ptr [ecx+$60]
005DB3CA   8B85A0FDFFFF           mov     eax, [ebp+$FFFFFDA0]
005DB3D0   8D95A4FDFFFF           lea     edx, [ebp+$FFFFFDA4]

* Reference to: Unit_00408494.Proc_00409448
|
005DB3D6   E86DE0E2FF             call    00409448
005DB3DB   83BDA4FDFFFF00         cmp     dword ptr [ebp+$FFFFFDA4], +$00
005DB3E2   0F86A1020000           jbe     005DB689
005DB3E8   33C0                   xor     eax, eax
005DB3EA   55                     push    ebp
005DB3EB   68A7B45D00             push    $005DB4A7

***** TRY
|
005DB3F0   64FF30                 push    dword ptr fs:[eax]
005DB3F3   648920                 mov     fs:[eax], esp
005DB3F6   8D959CFDFFFF           lea     edx, [ebp+$FFFFFD9C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB3FC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB401   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DB403   8B8084050000           mov     eax, [eax+$0584]
005DB409   8B08                   mov     ecx, [eax]
005DB40B   FF5160                 call    dword ptr [ecx+$60]
005DB40E   8B859CFDFFFF           mov     eax, [ebp+$FFFFFD9C]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB414   E89BE5E2FF             call    004099B4
005DB419   8BD8                   mov     ebx, eax
005DB41B   8B45E4                 mov     eax, [ebp-$1C]
005DB41E   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB424   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB42B   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB431   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB436   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DB438   8B405C                 mov     eax, [eax+$5C]
005DB43B   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB43D   E8227EEFFF             call    004D3264
005DB442   8D9598FDFFFF           lea     edx, [ebp+$FFFFFD98]

* Reference to pointer to GlobalVar_0061DF08
|
005DB448   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB44D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB44F   8B805C050000           mov     eax, [eax+$055C]
005DB455   8B08                   mov     ecx, [eax]
005DB457   FF5160                 call    dword ptr [ecx+$60]
005DB45A   8B8598FDFFFF           mov     eax, [ebp+$FFFFFD98]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB460   E84FE5E2FF             call    004099B4
005DB465   2BC3                   sub     eax, ebx
005DB467   48                     dec     eax
005DB468   7C30                   jl      005DB49A

* Reference to pointer to GlobalVar_0061DF08
|
005DB46A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB46F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DB471   8B8034050000           mov     eax, [eax+$0534]
005DB477   8B10                   mov     edx, [eax]
005DB479   FF5258                 call    dword ptr [edx+$58]
005DB47C   8D9594FDFFFF           lea     edx, [ebp+$FFFFFD94]

* Reference to: Unit_00408494.Proc_00409950
|
005DB482   E8C9E4E2FF             call    00409950
005DB487   8B8594FDFFFF           mov     eax, [ebp+$FFFFFD94]
005DB48D   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Mutter bei Geb.d.Kindes tot ?'
|
005DB490   BADCC95D00             mov     edx, $005DC9DC

* Reference to : TForm1.Proc_005D97B8()
|
005DB495   E81EE3FFFF             call    005D97B8
005DB49A   33C0                   xor     eax, eax
005DB49C   5A                     pop     edx
005DB49D   59                     pop     ecx
005DB49E   59                     pop     ecx
005DB49F   648910                 mov     fs:[eax], edx
005DB4A2   E9E2010000             jmp     005DB689

* Reference to: System.@HandleAnyException;
|
005DB4A7   E96C8DE2FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005DB4AC   E89391E2FF             call    00404644
005DB4B1   E9D3010000             jmp     005DB689
005DB4B6   8B45E4                 mov     eax, [ebp-$1C]
005DB4B9   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB4BF   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB4C6   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB4CC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB4D1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DB4D3   8B405C                 mov     eax, [eax+$5C]
005DB4D6   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB4D8   E8877DEFFF             call    004D3264

* Reference to pointer to GlobalVar_0061DF08
|
005DB4DD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB4E2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_053C
|
005DB4E4   8B803C050000           mov     eax, [eax+$053C]
005DB4EA   8B10                   mov     edx, [eax]
005DB4EC   FF5258                 call    dword ptr [edx+$58]
005DB4EF   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB4F5   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB4FC   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB502   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB507   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DB509   8B405C                 mov     eax, [eax+$5C]
005DB50C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB50E   E8517DEFFF             call    004D3264
005DB513   8D958CFDFFFF           lea     edx, [ebp+$FFFFFD8C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB519   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB51E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB520   8B805C050000           mov     eax, [eax+$055C]
005DB526   8B08                   mov     ecx, [eax]
005DB528   FF5160                 call    dword ptr [ecx+$60]
005DB52B   8B858CFDFFFF           mov     eax, [ebp+$FFFFFD8C]
005DB531   8D9590FDFFFF           lea     edx, [ebp+$FFFFFD90]

* Reference to: Unit_00408494.Proc_00409448
|
005DB537   E80CDFE2FF             call    00409448
005DB53C   83BD90FDFFFF00         cmp     dword ptr [ebp+$FFFFFD90], +$00
005DB543   7648                   jbe     005DB58D
005DB545   8D9588FDFFFF           lea     edx, [ebp+$FFFFFD88]

* Reference to pointer to GlobalVar_0061DF08
|
005DB54B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB550   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB552   8B805C050000           mov     eax, [eax+$055C]
005DB558   8B08                   mov     ecx, [eax]
005DB55A   FF5160                 call    dword ptr [ecx+$60]
005DB55D   8B8588FDFFFF           mov     eax, [ebp+$FFFFFD88]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB563   E84CE4E2FF             call    004099B4
005DB568   3BD8                   cmp     ebx, eax
005DB56A   7F21                   jnle    005DB58D
005DB56C   8D9584FDFFFF           lea     edx, [ebp+$FFFFFD84]
005DB572   8B45E4                 mov     eax, [ebp-$1C]

* Reference to: Unit_00408494.Proc_00409950
|
005DB575   E8D6E3E2FF             call    00409950
005DB57A   8B8584FDFFFF           mov     eax, [ebp+$FFFFFD84]
005DB580   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Kind vor Mutter geboren'
|
005DB583   BA98C95D00             mov     edx, $005DC998

* Reference to : TForm1.Proc_005D97B8()
|
005DB588   E82BE2FFFF             call    005D97B8
005DB58D   8D957CFDFFFF           lea     edx, [ebp+$FFFFFD7C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB593   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB598   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DB59A   8B8084050000           mov     eax, [eax+$0584]
005DB5A0   8B08                   mov     ecx, [eax]
005DB5A2   FF5160                 call    dword ptr [ecx+$60]
005DB5A5   8B857CFDFFFF           mov     eax, [ebp+$FFFFFD7C]
005DB5AB   8D9580FDFFFF           lea     edx, [ebp+$FFFFFD80]

* Reference to: Unit_00408494.Proc_00409448
|
005DB5B1   E892DEE2FF             call    00409448
005DB5B6   83BD80FDFFFF00         cmp     dword ptr [ebp+$FFFFFD80], +$00
005DB5BD   0F86C6000000           jbe     005DB689
005DB5C3   33C0                   xor     eax, eax
005DB5C5   55                     push    ebp

* Possible String Reference to: '锋��軏���E䉅l���ƅp���'
|
005DB5C6   687FB65D00             push    $005DB67F

***** TRY
|
005DB5CB   64FF30                 push    dword ptr fs:[eax]
005DB5CE   648920                 mov     fs:[eax], esp
005DB5D1   8D9578FDFFFF           lea     edx, [ebp+$FFFFFD78]

* Reference to pointer to GlobalVar_0061DF08
|
005DB5D7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB5DC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DB5DE   8B8084050000           mov     eax, [eax+$0584]
005DB5E4   8B08                   mov     ecx, [eax]
005DB5E6   FF5160                 call    dword ptr [ecx+$60]
005DB5E9   8B8578FDFFFF           mov     eax, [ebp+$FFFFFD78]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB5EF   E8C0E3E2FF             call    004099B4
005DB5F4   8BD8                   mov     ebx, eax
005DB5F6   8B45E4                 mov     eax, [ebp-$1C]
005DB5F9   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB5FF   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB606   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB60C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB611   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DB613   8B405C                 mov     eax, [eax+$5C]
005DB616   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB618   E8477CEFFF             call    004D3264
005DB61D   8D9574FDFFFF           lea     edx, [ebp+$FFFFFD74]

* Reference to pointer to GlobalVar_0061DF08
|
005DB623   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB628   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB62A   8B805C050000           mov     eax, [eax+$055C]
005DB630   8B08                   mov     ecx, [eax]
005DB632   FF5160                 call    dword ptr [ecx+$60]
005DB635   8B8574FDFFFF           mov     eax, [ebp+$FFFFFD74]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB63B   E874E3E2FF             call    004099B4
005DB640   2BC3                   sub     eax, ebx
005DB642   48                     dec     eax
005DB643   7C30                   jl      005DB675

* Reference to pointer to GlobalVar_0061DF08
|
005DB645   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB64A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DB64C   8B8034050000           mov     eax, [eax+$0534]
005DB652   8B10                   mov     edx, [eax]
005DB654   FF5258                 call    dword ptr [edx+$58]
005DB657   8D9570FDFFFF           lea     edx, [ebp+$FFFFFD70]

* Reference to: Unit_00408494.Proc_00409950
|
005DB65D   E8EEE2E2FF             call    00409950
005DB662   8B8570FDFFFF           mov     eax, [ebp+$FFFFFD70]
005DB668   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Mutter bei Geb.d.Kindes tot ?'
|
005DB66B   BADCC95D00             mov     edx, $005DC9DC

* Reference to : TForm1.Proc_005D97B8()
|
005DB670   E843E1FFFF             call    005D97B8
005DB675   33C0                   xor     eax, eax
005DB677   5A                     pop     edx
005DB678   59                     pop     ecx
005DB679   59                     pop     ecx
005DB67A   648910                 mov     fs:[eax], edx
005DB67D   EB0A                   jmp     005DB689

* Reference to: System.@HandleAnyException;
|
005DB67F   E9948BE2FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005DB684   E8BB8FE2FF             call    00404644

****** END
|
005DB689   8B45E4                 mov     eax, [ebp-$1C]
005DB68C   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB692   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB699   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB69F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB6A4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DB6A6   8B405C                 mov     eax, [eax+$5C]
005DB6A9   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB6AB   E8B47BEFFF             call    004D3264

* Reference to pointer to GlobalVar_0061DF08
|
005DB6B0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB6B5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DB6B7   8B8034050000           mov     eax, [eax+$0534]
005DB6BD   8B10                   mov     edx, [eax]
005DB6BF   FF5258                 call    dword ptr [edx+$58]
005DB6C2   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DB6C8   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DB6CF   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB6D5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB6DA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005DB6DC   8B80A4000000           mov     eax, [eax+$00A4]
005DB6E2   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DB6E4   E87B7BEFFF             call    004D3264
005DB6E9   84C0                   test    al, al
005DB6EB   0F841E0C0000           jz      005DC30F
005DB6F1   E9FE0B0000             jmp     005DC2F4
005DB6F6   8D956CFDFFFF           lea     edx, [ebp+$FFFFFD6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB6FC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB701   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C8
|
005DB703   8B80C8030000           mov     eax, [eax+$03C8]
005DB709   8B08                   mov     ecx, [eax]
005DB70B   FF5160                 call    dword ptr [ecx+$60]
005DB70E   8B956CFDFFFF           mov     edx, [ebp+$FFFFFD6C]
005DB714   B8C8C55D00             mov     eax, $005DC5C8

* Reference to: System.@LStrPos;
|
005DB719   E83E9AE2FF             call    0040515C
005DB71E   85C0                   test    eax, eax
005DB720   7E30                   jle     005DB752

* Reference to pointer to GlobalVar_0061DF08
|
005DB722   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB727   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DB729   8B8034050000           mov     eax, [eax+$0534]
005DB72F   8B10                   mov     edx, [eax]
005DB731   FF5258                 call    dword ptr [edx+$58]
005DB734   8D9568FDFFFF           lea     edx, [ebp+$FFFFFD68]

* Reference to: Unit_00408494.Proc_00409950
|
005DB73A   E811E2E2FF             call    00409950
005DB73F   8B8568FDFFFF           mov     eax, [ebp+$FFFFFD68]
005DB745   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: ', in k.Heiratsort'
|
005DB748   BA04CA5D00             mov     edx, $005DCA04

* Reference to : TForm1.Proc_005D97B8()
|
005DB74D   E866E0FFFF             call    005D97B8
005DB752   8D9564FDFFFF           lea     edx, [ebp+$FFFFFD64]

* Reference to pointer to GlobalVar_0061DF08
|
005DB758   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB75D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03DC
|
005DB75F   8B80DC030000           mov     eax, [eax+$03DC]
005DB765   8B08                   mov     ecx, [eax]
005DB767   FF5160                 call    dword ptr [ecx+$60]
005DB76A   8B9564FDFFFF           mov     edx, [ebp+$FFFFFD64]
005DB770   B8C8C55D00             mov     eax, $005DC5C8

* Reference to: System.@LStrPos;
|
005DB775   E8E299E2FF             call    0040515C
005DB77A   85C0                   test    eax, eax
005DB77C   7E30                   jle     005DB7AE

* Reference to pointer to GlobalVar_0061DF08
|
005DB77E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB783   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DB785   8B8034050000           mov     eax, [eax+$0534]
005DB78B   8B10                   mov     edx, [eax]
005DB78D   FF5258                 call    dword ptr [edx+$58]
005DB790   8D9560FDFFFF           lea     edx, [ebp+$FFFFFD60]

* Reference to: Unit_00408494.Proc_00409950
|
005DB796   E8B5E1E2FF             call    00409950
005DB79B   8B8560FDFFFF           mov     eax, [ebp+$FFFFFD60]
005DB7A1   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: ', in s.Heiratsort'
|
005DB7A4   BA20CA5D00             mov     edx, $005DCA20

* Reference to : TForm1.Proc_005D97B8()
|
005DB7A9   E80AE0FFFF             call    005D97B8
005DB7AE   8D955CFDFFFF           lea     edx, [ebp+$FFFFFD5C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB7B4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB7B9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F4
|
005DB7BB   8B80F4030000           mov     eax, [eax+$03F4]
005DB7C1   8B08                   mov     ecx, [eax]
005DB7C3   FF5160                 call    dword ptr [ecx+$60]
005DB7C6   8B955CFDFFFF           mov     edx, [ebp+$FFFFFD5C]
005DB7CC   B8C8C55D00             mov     eax, $005DC5C8

* Reference to: System.@LStrPos;
|
005DB7D1   E88699E2FF             call    0040515C
005DB7D6   85C0                   test    eax, eax
005DB7D8   7E30                   jle     005DB80A

* Reference to pointer to GlobalVar_0061DF08
|
005DB7DA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB7DF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DB7E1   8B8034050000           mov     eax, [eax+$0534]
005DB7E7   8B10                   mov     edx, [eax]
005DB7E9   FF5258                 call    dword ptr [edx+$58]
005DB7EC   8D9558FDFFFF           lea     edx, [ebp+$FFFFFD58]

* Reference to: Unit_00408494.Proc_00409950
|
005DB7F2   E859E1E2FF             call    00409950
005DB7F7   8B8558FDFFFF           mov     eax, [ebp+$FFFFFD58]
005DB7FD   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: ', in Scheidungsort'
|
005DB800   BA3CCA5D00             mov     edx, $005DCA3C

* Reference to : TForm1.Proc_005D97B8()
|
005DB805   E8AEDFFFFF             call    005D97B8
005DB80A   8D9550FDFFFF           lea     edx, [ebp+$FFFFFD50]

* Reference to pointer to GlobalVar_0061DF08
|
005DB810   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB815   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB817   8B805C050000           mov     eax, [eax+$055C]
005DB81D   8B08                   mov     ecx, [eax]
005DB81F   FF5160                 call    dword ptr [ecx+$60]
005DB822   8B8550FDFFFF           mov     eax, [ebp+$FFFFFD50]
005DB828   8D9554FDFFFF           lea     edx, [ebp+$FFFFFD54]

* Reference to: Unit_00408494.Proc_00409448
|
005DB82E   E815DCE2FF             call    00409448
005DB833   83BD54FDFFFF00         cmp     dword ptr [ebp+$FFFFFD54], +$00
005DB83A   0F86B1000000           jbe     005DB8F1
005DB840   8D9548FDFFFF           lea     edx, [ebp+$FFFFFD48]

* Reference to pointer to GlobalVar_0061DF08
|
005DB846   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB84B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C4
|
005DB84D   8B80C4030000           mov     eax, [eax+$03C4]
005DB853   8B08                   mov     ecx, [eax]
005DB855   FF5160                 call    dword ptr [ecx+$60]
005DB858   8B8548FDFFFF           mov     eax, [ebp+$FFFFFD48]
005DB85E   8D954CFDFFFF           lea     edx, [ebp+$FFFFFD4C]

* Reference to: Unit_00408494.Proc_00409448
|
005DB864   E8DFDBE2FF             call    00409448
005DB869   83BD4CFDFFFF00         cmp     dword ptr [ebp+$FFFFFD4C], +$00
005DB870   767F                   jbe     005DB8F1
005DB872   8D9544FDFFFF           lea     edx, [ebp+$FFFFFD44]

* Reference to pointer to GlobalVar_0061DF08
|
005DB878   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB87D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C4
|
005DB87F   8B80C4030000           mov     eax, [eax+$03C4]
005DB885   8B08                   mov     ecx, [eax]
005DB887   FF5160                 call    dword ptr [ecx+$60]
005DB88A   8B8544FDFFFF           mov     eax, [ebp+$FFFFFD44]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB890   E81FE1E2FF             call    004099B4
005DB895   8BD8                   mov     ebx, eax
005DB897   8D9540FDFFFF           lea     edx, [ebp+$FFFFFD40]

* Reference to pointer to GlobalVar_0061DF08
|
005DB89D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB8A2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB8A4   8B805C050000           mov     eax, [eax+$055C]
005DB8AA   8B08                   mov     ecx, [eax]
005DB8AC   FF5160                 call    dword ptr [ecx+$60]
005DB8AF   8B8540FDFFFF           mov     eax, [ebp+$FFFFFD40]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB8B5   E8FAE0E2FF             call    004099B4
005DB8BA   2BD8                   sub     ebx, eax
005DB8BC   83FB0B                 cmp     ebx, +$0B
005DB8BF   7F30                   jnle    005DB8F1

* Reference to pointer to GlobalVar_0061DF08
|
005DB8C1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB8C6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DB8C8   8B8034050000           mov     eax, [eax+$0534]
005DB8CE   8B10                   mov     edx, [eax]
005DB8D0   FF5258                 call    dword ptr [edx+$58]
005DB8D3   8D953CFDFFFF           lea     edx, [ebp+$FFFFFD3C]

* Reference to: Unit_00408494.Proc_00409950
|
005DB8D9   E872E0E2FF             call    00409950
005DB8DE   8B853CFDFFFF           mov     eax, [ebp+$FFFFFD3C]
005DB8E4   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Geburts-/k.Heirats-Daten �berpr�fen'
|
005DB8E7   BA58CA5D00             mov     edx, $005DCA58

* Reference to : TForm1.Proc_005D97B8()
|
005DB8EC   E8C7DEFFFF             call    005D97B8
005DB8F1   8D9534FDFFFF           lea     edx, [ebp+$FFFFFD34]

* Reference to pointer to GlobalVar_0061DF08
|
005DB8F7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB8FC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB8FE   8B805C050000           mov     eax, [eax+$055C]
005DB904   8B08                   mov     ecx, [eax]
005DB906   FF5160                 call    dword ptr [ecx+$60]
005DB909   8B8534FDFFFF           mov     eax, [ebp+$FFFFFD34]
005DB90F   8D9538FDFFFF           lea     edx, [ebp+$FFFFFD38]

* Reference to: Unit_00408494.Proc_00409448
|
005DB915   E82EDBE2FF             call    00409448
005DB91A   83BD38FDFFFF00         cmp     dword ptr [ebp+$FFFFFD38], +$00
005DB921   0F86B1000000           jbe     005DB9D8
005DB927   8D952CFDFFFF           lea     edx, [ebp+$FFFFFD2C]

* Reference to pointer to GlobalVar_0061DF08
|
005DB92D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB932   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D8
|
005DB934   8B80D8030000           mov     eax, [eax+$03D8]
005DB93A   8B08                   mov     ecx, [eax]
005DB93C   FF5160                 call    dword ptr [ecx+$60]
005DB93F   8B852CFDFFFF           mov     eax, [ebp+$FFFFFD2C]
005DB945   8D9530FDFFFF           lea     edx, [ebp+$FFFFFD30]

* Reference to: Unit_00408494.Proc_00409448
|
005DB94B   E8F8DAE2FF             call    00409448
005DB950   83BD30FDFFFF00         cmp     dword ptr [ebp+$FFFFFD30], +$00
005DB957   767F                   jbe     005DB9D8
005DB959   8D9528FDFFFF           lea     edx, [ebp+$FFFFFD28]

* Reference to pointer to GlobalVar_0061DF08
|
005DB95F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB964   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D8
|
005DB966   8B80D8030000           mov     eax, [eax+$03D8]
005DB96C   8B08                   mov     ecx, [eax]
005DB96E   FF5160                 call    dword ptr [ecx+$60]
005DB971   8B8528FDFFFF           mov     eax, [ebp+$FFFFFD28]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB977   E838E0E2FF             call    004099B4
005DB97C   8BD8                   mov     ebx, eax
005DB97E   8D9524FDFFFF           lea     edx, [ebp+$FFFFFD24]

* Reference to pointer to GlobalVar_0061DF08
|
005DB984   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB989   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB98B   8B805C050000           mov     eax, [eax+$055C]
005DB991   8B08                   mov     ecx, [eax]
005DB993   FF5160                 call    dword ptr [ecx+$60]
005DB996   8B8524FDFFFF           mov     eax, [ebp+$FFFFFD24]

* Reference to: Unit_00408494.Proc_004099B4
|
005DB99C   E813E0E2FF             call    004099B4
005DB9A1   2BD8                   sub     ebx, eax
005DB9A3   83FB0B                 cmp     ebx, +$0B
005DB9A6   7F30                   jnle    005DB9D8

* Reference to pointer to GlobalVar_0061DF08
|
005DB9A8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB9AD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DB9AF   8B8034050000           mov     eax, [eax+$0534]
005DB9B5   8B10                   mov     edx, [eax]
005DB9B7   FF5258                 call    dword ptr [edx+$58]
005DB9BA   8D9520FDFFFF           lea     edx, [ebp+$FFFFFD20]

* Reference to: Unit_00408494.Proc_00409950
|
005DB9C0   E88BDFE2FF             call    00409950
005DB9C5   8B8520FDFFFF           mov     eax, [ebp+$FFFFFD20]
005DB9CB   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Geburts-/st.Heirats-Daten �berpr�fe
|                                n'
|
005DB9CE   BA84CA5D00             mov     edx, $005DCA84

* Reference to : TForm1.Proc_005D97B8()
|
005DB9D3   E8E0DDFFFF             call    005D97B8
005DB9D8   8D9518FDFFFF           lea     edx, [ebp+$FFFFFD18]

* Reference to pointer to GlobalVar_0061DF08
|
005DB9DE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DB9E3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DB9E5   8B805C050000           mov     eax, [eax+$055C]
005DB9EB   8B08                   mov     ecx, [eax]
005DB9ED   FF5160                 call    dword ptr [ecx+$60]
005DB9F0   8B8518FDFFFF           mov     eax, [ebp+$FFFFFD18]
005DB9F6   8D951CFDFFFF           lea     edx, [ebp+$FFFFFD1C]

* Reference to: Unit_00408494.Proc_00409448
|
005DB9FC   E847DAE2FF             call    00409448
005DBA01   83BD1CFDFFFF00         cmp     dword ptr [ebp+$FFFFFD1C], +$00
005DBA08   0F86B1000000           jbe     005DBABF
005DBA0E   8D9510FDFFFF           lea     edx, [ebp+$FFFFFD10]

* Reference to pointer to GlobalVar_0061DF08
|
005DBA14   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBA19   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F0
|
005DBA1B   8B80F0030000           mov     eax, [eax+$03F0]
005DBA21   8B08                   mov     ecx, [eax]
005DBA23   FF5160                 call    dword ptr [ecx+$60]
005DBA26   8B8510FDFFFF           mov     eax, [ebp+$FFFFFD10]
005DBA2C   8D9514FDFFFF           lea     edx, [ebp+$FFFFFD14]

* Reference to: Unit_00408494.Proc_00409448
|
005DBA32   E811DAE2FF             call    00409448
005DBA37   83BD14FDFFFF00         cmp     dword ptr [ebp+$FFFFFD14], +$00
005DBA3E   767F                   jbe     005DBABF
005DBA40   8D950CFDFFFF           lea     edx, [ebp+$FFFFFD0C]

* Reference to pointer to GlobalVar_0061DF08
|
005DBA46   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBA4B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F0
|
005DBA4D   8B80F0030000           mov     eax, [eax+$03F0]
005DBA53   8B08                   mov     ecx, [eax]
005DBA55   FF5160                 call    dword ptr [ecx+$60]
005DBA58   8B850CFDFFFF           mov     eax, [ebp+$FFFFFD0C]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBA5E   E851DFE2FF             call    004099B4
005DBA63   8BD8                   mov     ebx, eax
005DBA65   8D9508FDFFFF           lea     edx, [ebp+$FFFFFD08]

* Reference to pointer to GlobalVar_0061DF08
|
005DBA6B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBA70   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005DBA72   8B805C050000           mov     eax, [eax+$055C]
005DBA78   8B08                   mov     ecx, [eax]
005DBA7A   FF5160                 call    dword ptr [ecx+$60]
005DBA7D   8B8508FDFFFF           mov     eax, [ebp+$FFFFFD08]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBA83   E82CDFE2FF             call    004099B4
005DBA88   2BD8                   sub     ebx, eax
005DBA8A   83FB0B                 cmp     ebx, +$0B
005DBA8D   7F30                   jnle    005DBABF

* Reference to pointer to GlobalVar_0061DF08
|
005DBA8F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBA94   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DBA96   8B8034050000           mov     eax, [eax+$0534]
005DBA9C   8B10                   mov     edx, [eax]
005DBA9E   FF5258                 call    dword ptr [edx+$58]
005DBAA1   8D9504FDFFFF           lea     edx, [ebp+$FFFFFD04]

* Reference to: Unit_00408494.Proc_00409950
|
005DBAA7   E8A4DEE2FF             call    00409950
005DBAAC   8B8504FDFFFF           mov     eax, [ebp+$FFFFFD04]
005DBAB2   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Geburts-/Scheidungs-Daten �berpr�fe
|                                n'
|
005DBAB5   BAB4CA5D00             mov     edx, $005DCAB4

* Reference to : TForm1.Proc_005D97B8()
|
005DBABA   E8F9DCFFFF             call    005D97B8
005DBABF   8D95FCFCFFFF           lea     edx, [ebp+$FFFFFCFC]

* Reference to pointer to GlobalVar_0061DF08
|
005DBAC5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBACA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005DBACC   8B806C050000           mov     eax, [eax+$056C]
005DBAD2   8B08                   mov     ecx, [eax]
005DBAD4   FF5160                 call    dword ptr [ecx+$60]
005DBAD7   8B85FCFCFFFF           mov     eax, [ebp+$FFFFFCFC]
005DBADD   8D9500FDFFFF           lea     edx, [ebp+$FFFFFD00]

* Reference to: Unit_00408494.Proc_00409448
|
005DBAE3   E860D9E2FF             call    00409448
005DBAE8   83BD00FDFFFF00         cmp     dword ptr [ebp+$FFFFFD00], +$00
005DBAEF   0F86B1000000           jbe     005DBBA6
005DBAF5   8D95F4FCFFFF           lea     edx, [ebp+$FFFFFCF4]

* Reference to pointer to GlobalVar_0061DF08
|
005DBAFB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBB00   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C4
|
005DBB02   8B80C4030000           mov     eax, [eax+$03C4]
005DBB08   8B08                   mov     ecx, [eax]
005DBB0A   FF5160                 call    dword ptr [ecx+$60]
005DBB0D   8B85F4FCFFFF           mov     eax, [ebp+$FFFFFCF4]
005DBB13   8D95F8FCFFFF           lea     edx, [ebp+$FFFFFCF8]

* Reference to: Unit_00408494.Proc_00409448
|
005DBB19   E82AD9E2FF             call    00409448
005DBB1E   83BDF8FCFFFF00         cmp     dword ptr [ebp+$FFFFFCF8], +$00
005DBB25   767F                   jbe     005DBBA6
005DBB27   8D95F0FCFFFF           lea     edx, [ebp+$FFFFFCF0]

* Reference to pointer to GlobalVar_0061DF08
|
005DBB2D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBB32   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C4
|
005DBB34   8B80C4030000           mov     eax, [eax+$03C4]
005DBB3A   8B08                   mov     ecx, [eax]
005DBB3C   FF5160                 call    dword ptr [ecx+$60]
005DBB3F   8B85F0FCFFFF           mov     eax, [ebp+$FFFFFCF0]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBB45   E86ADEE2FF             call    004099B4
005DBB4A   8BD8                   mov     ebx, eax
005DBB4C   8D95ECFCFFFF           lea     edx, [ebp+$FFFFFCEC]

* Reference to pointer to GlobalVar_0061DF08
|
005DBB52   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBB57   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005DBB59   8B806C050000           mov     eax, [eax+$056C]
005DBB5F   8B08                   mov     ecx, [eax]
005DBB61   FF5160                 call    dword ptr [ecx+$60]
005DBB64   8B85ECFCFFFF           mov     eax, [ebp+$FFFFFCEC]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBB6A   E845DEE2FF             call    004099B4
005DBB6F   2BD8                   sub     ebx, eax
005DBB71   83FB0B                 cmp     ebx, +$0B
005DBB74   7F30                   jnle    005DBBA6

* Reference to pointer to GlobalVar_0061DF08
|
005DBB76   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBB7B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DBB7D   8B8034050000           mov     eax, [eax+$0534]
005DBB83   8B10                   mov     edx, [eax]
005DBB85   FF5258                 call    dword ptr [edx+$58]
005DBB88   8D95E8FCFFFF           lea     edx, [ebp+$FFFFFCE8]

* Reference to: Unit_00408494.Proc_00409950
|
005DBB8E   E8BDDDE2FF             call    00409950
005DBB93   8B85E8FCFFFF           mov     eax, [ebp+$FFFFFCE8]
005DBB99   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Tauf-/k.Heirats-Daten �berpr�fen'
|
005DBB9C   BAE4CA5D00             mov     edx, $005DCAE4

* Reference to : TForm1.Proc_005D97B8()
|
005DBBA1   E812DCFFFF             call    005D97B8
005DBBA6   8D95E0FCFFFF           lea     edx, [ebp+$FFFFFCE0]

* Reference to pointer to GlobalVar_0061DF08
|
005DBBAC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBBB1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005DBBB3   8B806C050000           mov     eax, [eax+$056C]
005DBBB9   8B08                   mov     ecx, [eax]
005DBBBB   FF5160                 call    dword ptr [ecx+$60]
005DBBBE   8B85E0FCFFFF           mov     eax, [ebp+$FFFFFCE0]
005DBBC4   8D95E4FCFFFF           lea     edx, [ebp+$FFFFFCE4]

* Reference to: Unit_00408494.Proc_00409448
|
005DBBCA   E879D8E2FF             call    00409448
005DBBCF   83BDE4FCFFFF00         cmp     dword ptr [ebp+$FFFFFCE4], +$00
005DBBD6   0F86B1000000           jbe     005DBC8D
005DBBDC   8D95D8FCFFFF           lea     edx, [ebp+$FFFFFCD8]

* Reference to pointer to GlobalVar_0061DF08
|
005DBBE2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBBE7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D8
|
005DBBE9   8B80D8030000           mov     eax, [eax+$03D8]
005DBBEF   8B08                   mov     ecx, [eax]
005DBBF1   FF5160                 call    dword ptr [ecx+$60]
005DBBF4   8B85D8FCFFFF           mov     eax, [ebp+$FFFFFCD8]
005DBBFA   8D95DCFCFFFF           lea     edx, [ebp+$FFFFFCDC]

* Reference to: Unit_00408494.Proc_00409448
|
005DBC00   E843D8E2FF             call    00409448
005DBC05   83BDDCFCFFFF00         cmp     dword ptr [ebp+$FFFFFCDC], +$00
005DBC0C   767F                   jbe     005DBC8D
005DBC0E   8D95D4FCFFFF           lea     edx, [ebp+$FFFFFCD4]

* Reference to pointer to GlobalVar_0061DF08
|
005DBC14   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBC19   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D8
|
005DBC1B   8B80D8030000           mov     eax, [eax+$03D8]
005DBC21   8B08                   mov     ecx, [eax]
005DBC23   FF5160                 call    dword ptr [ecx+$60]
005DBC26   8B85D4FCFFFF           mov     eax, [ebp+$FFFFFCD4]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBC2C   E883DDE2FF             call    004099B4
005DBC31   8BD8                   mov     ebx, eax
005DBC33   8D95D0FCFFFF           lea     edx, [ebp+$FFFFFCD0]

* Reference to pointer to GlobalVar_0061DF08
|
005DBC39   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBC3E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005DBC40   8B806C050000           mov     eax, [eax+$056C]
005DBC46   8B08                   mov     ecx, [eax]
005DBC48   FF5160                 call    dword ptr [ecx+$60]
005DBC4B   8B85D0FCFFFF           mov     eax, [ebp+$FFFFFCD0]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBC51   E85EDDE2FF             call    004099B4
005DBC56   2BD8                   sub     ebx, eax
005DBC58   83FB0B                 cmp     ebx, +$0B
005DBC5B   7F30                   jnle    005DBC8D

* Reference to pointer to GlobalVar_0061DF08
|
005DBC5D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBC62   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DBC64   8B8034050000           mov     eax, [eax+$0534]
005DBC6A   8B10                   mov     edx, [eax]
005DBC6C   FF5258                 call    dword ptr [edx+$58]
005DBC6F   8D95CCFCFFFF           lea     edx, [ebp+$FFFFFCCC]

* Reference to: Unit_00408494.Proc_00409950
|
005DBC75   E8D6DCE2FF             call    00409950
005DBC7A   8B85CCFCFFFF           mov     eax, [ebp+$FFFFFCCC]
005DBC80   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Tauf-/st.Heirats-Daten �berpr�fen'
|
005DBC83   BA10CB5D00             mov     edx, $005DCB10

* Reference to : TForm1.Proc_005D97B8()
|
005DBC88   E82BDBFFFF             call    005D97B8
005DBC8D   8D95C4FCFFFF           lea     edx, [ebp+$FFFFFCC4]

* Reference to pointer to GlobalVar_0061DF08
|
005DBC93   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBC98   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005DBC9A   8B806C050000           mov     eax, [eax+$056C]
005DBCA0   8B08                   mov     ecx, [eax]
005DBCA2   FF5160                 call    dword ptr [ecx+$60]
005DBCA5   8B85C4FCFFFF           mov     eax, [ebp+$FFFFFCC4]
005DBCAB   8D95C8FCFFFF           lea     edx, [ebp+$FFFFFCC8]

* Reference to: Unit_00408494.Proc_00409448
|
005DBCB1   E892D7E2FF             call    00409448
005DBCB6   83BDC8FCFFFF00         cmp     dword ptr [ebp+$FFFFFCC8], +$00
005DBCBD   0F86B1000000           jbe     005DBD74
005DBCC3   8D95BCFCFFFF           lea     edx, [ebp+$FFFFFCBC]

* Reference to pointer to GlobalVar_0061DF08
|
005DBCC9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBCCE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F0
|
005DBCD0   8B80F0030000           mov     eax, [eax+$03F0]
005DBCD6   8B08                   mov     ecx, [eax]
005DBCD8   FF5160                 call    dword ptr [ecx+$60]
005DBCDB   8B85BCFCFFFF           mov     eax, [ebp+$FFFFFCBC]
005DBCE1   8D95C0FCFFFF           lea     edx, [ebp+$FFFFFCC0]

* Reference to: Unit_00408494.Proc_00409448
|
005DBCE7   E85CD7E2FF             call    00409448
005DBCEC   83BDC0FCFFFF00         cmp     dword ptr [ebp+$FFFFFCC0], +$00
005DBCF3   767F                   jbe     005DBD74
005DBCF5   8D95B8FCFFFF           lea     edx, [ebp+$FFFFFCB8]

* Reference to pointer to GlobalVar_0061DF08
|
005DBCFB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBD00   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F0
|
005DBD02   8B80F0030000           mov     eax, [eax+$03F0]
005DBD08   8B08                   mov     ecx, [eax]
005DBD0A   FF5160                 call    dword ptr [ecx+$60]
005DBD0D   8B85B8FCFFFF           mov     eax, [ebp+$FFFFFCB8]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBD13   E89CDCE2FF             call    004099B4
005DBD18   8BD8                   mov     ebx, eax
005DBD1A   8D95B4FCFFFF           lea     edx, [ebp+$FFFFFCB4]

* Reference to pointer to GlobalVar_0061DF08
|
005DBD20   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBD25   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005DBD27   8B806C050000           mov     eax, [eax+$056C]
005DBD2D   8B08                   mov     ecx, [eax]
005DBD2F   FF5160                 call    dword ptr [ecx+$60]
005DBD32   8B85B4FCFFFF           mov     eax, [ebp+$FFFFFCB4]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBD38   E877DCE2FF             call    004099B4
005DBD3D   2BD8                   sub     ebx, eax
005DBD3F   83FB0B                 cmp     ebx, +$0B
005DBD42   7F30                   jnle    005DBD74

* Reference to pointer to GlobalVar_0061DF08
|
005DBD44   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBD49   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DBD4B   8B8034050000           mov     eax, [eax+$0534]
005DBD51   8B10                   mov     edx, [eax]
005DBD53   FF5258                 call    dword ptr [edx+$58]
005DBD56   8D95B0FCFFFF           lea     edx, [ebp+$FFFFFCB0]

* Reference to: Unit_00408494.Proc_00409950
|
005DBD5C   E8EFDBE2FF             call    00409950
005DBD61   8B85B0FCFFFF           mov     eax, [ebp+$FFFFFCB0]
005DBD67   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Tauf-/Scheidungs-Daten �berpr�fen'
|
005DBD6A   BA3CCB5D00             mov     edx, $005DCB3C

* Reference to : TForm1.Proc_005D97B8()
|
005DBD6F   E844DAFFFF             call    005D97B8
005DBD74   8D95A8FCFFFF           lea     edx, [ebp+$FFFFFCA8]

* Reference to pointer to GlobalVar_0061DF08
|
005DBD7A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBD7F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DBD81   8B8084050000           mov     eax, [eax+$0584]
005DBD87   8B08                   mov     ecx, [eax]
005DBD89   FF5160                 call    dword ptr [ecx+$60]
005DBD8C   8B85A8FCFFFF           mov     eax, [ebp+$FFFFFCA8]
005DBD92   8D95ACFCFFFF           lea     edx, [ebp+$FFFFFCAC]

* Reference to: Unit_00408494.Proc_00409448
|
005DBD98   E8ABD6E2FF             call    00409448
005DBD9D   83BDACFCFFFF00         cmp     dword ptr [ebp+$FFFFFCAC], +$00
005DBDA4   0F86AE000000           jbe     005DBE58
005DBDAA   8D95A0FCFFFF           lea     edx, [ebp+$FFFFFCA0]

* Reference to pointer to GlobalVar_0061DF08
|
005DBDB0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBDB5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C4
|
005DBDB7   8B80C4030000           mov     eax, [eax+$03C4]
005DBDBD   8B08                   mov     ecx, [eax]
005DBDBF   FF5160                 call    dword ptr [ecx+$60]
005DBDC2   8B85A0FCFFFF           mov     eax, [ebp+$FFFFFCA0]
005DBDC8   8D95A4FCFFFF           lea     edx, [ebp+$FFFFFCA4]

* Reference to: Unit_00408494.Proc_00409448
|
005DBDCE   E875D6E2FF             call    00409448
005DBDD3   83BDA4FCFFFF00         cmp     dword ptr [ebp+$FFFFFCA4], +$00
005DBDDA   767C                   jbe     005DBE58
005DBDDC   8D959CFCFFFF           lea     edx, [ebp+$FFFFFC9C]

* Reference to pointer to GlobalVar_0061DF08
|
005DBDE2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBDE7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DBDE9   8B8084050000           mov     eax, [eax+$0584]
005DBDEF   8B08                   mov     ecx, [eax]
005DBDF1   FF5160                 call    dword ptr [ecx+$60]
005DBDF4   8B859CFCFFFF           mov     eax, [ebp+$FFFFFC9C]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBDFA   E8B5DBE2FF             call    004099B4
005DBDFF   8BD8                   mov     ebx, eax
005DBE01   8D9598FCFFFF           lea     edx, [ebp+$FFFFFC98]

* Reference to pointer to GlobalVar_0061DF08
|
005DBE07   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBE0C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C4
|
005DBE0E   8B80C4030000           mov     eax, [eax+$03C4]
005DBE14   8B08                   mov     ecx, [eax]
005DBE16   FF5160                 call    dword ptr [ecx+$60]
005DBE19   8B8598FCFFFF           mov     eax, [ebp+$FFFFFC98]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBE1F   E890DBE2FF             call    004099B4
005DBE24   2BD8                   sub     ebx, eax
005DBE26   7930                   jns     005DBE58

* Reference to pointer to GlobalVar_0061DF08
|
005DBE28   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBE2D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DBE2F   8B8034050000           mov     eax, [eax+$0534]
005DBE35   8B10                   mov     edx, [eax]
005DBE37   FF5258                 call    dword ptr [edx+$58]
005DBE3A   8D9594FCFFFF           lea     edx, [ebp+$FFFFFC94]

* Reference to: Unit_00408494.Proc_00409950
|
005DBE40   E80BDBE2FF             call    00409950
005DBE45   8B8594FCFFFF           mov     eax, [ebp+$FFFFFC94]
005DBE4B   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'k.Heirats-/Sterbe-Daten �berpr�fen'
|
005DBE4E   BA68CB5D00             mov     edx, $005DCB68

* Reference to : TForm1.Proc_005D97B8()
|
005DBE53   E860D9FFFF             call    005D97B8
005DBE58   8D958CFCFFFF           lea     edx, [ebp+$FFFFFC8C]

* Reference to pointer to GlobalVar_0061DF08
|
005DBE5E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBE63   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DBE65   8B8084050000           mov     eax, [eax+$0584]
005DBE6B   8B08                   mov     ecx, [eax]
005DBE6D   FF5160                 call    dword ptr [ecx+$60]
005DBE70   8B858CFCFFFF           mov     eax, [ebp+$FFFFFC8C]
005DBE76   8D9590FCFFFF           lea     edx, [ebp+$FFFFFC90]

* Reference to: Unit_00408494.Proc_00409448
|
005DBE7C   E8C7D5E2FF             call    00409448
005DBE81   83BD90FCFFFF00         cmp     dword ptr [ebp+$FFFFFC90], +$00
005DBE88   0F86AE000000           jbe     005DBF3C
005DBE8E   8D9584FCFFFF           lea     edx, [ebp+$FFFFFC84]

* Reference to pointer to GlobalVar_0061DF08
|
005DBE94   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBE99   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D8
|
005DBE9B   8B80D8030000           mov     eax, [eax+$03D8]
005DBEA1   8B08                   mov     ecx, [eax]
005DBEA3   FF5160                 call    dword ptr [ecx+$60]
005DBEA6   8B8584FCFFFF           mov     eax, [ebp+$FFFFFC84]
005DBEAC   8D9588FCFFFF           lea     edx, [ebp+$FFFFFC88]

* Reference to: Unit_00408494.Proc_00409448
|
005DBEB2   E891D5E2FF             call    00409448
005DBEB7   83BD88FCFFFF00         cmp     dword ptr [ebp+$FFFFFC88], +$00
005DBEBE   767C                   jbe     005DBF3C
005DBEC0   8D9580FCFFFF           lea     edx, [ebp+$FFFFFC80]

* Reference to pointer to GlobalVar_0061DF08
|
005DBEC6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBECB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DBECD   8B8084050000           mov     eax, [eax+$0584]
005DBED3   8B08                   mov     ecx, [eax]
005DBED5   FF5160                 call    dword ptr [ecx+$60]
005DBED8   8B8580FCFFFF           mov     eax, [ebp+$FFFFFC80]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBEDE   E8D1DAE2FF             call    004099B4
005DBEE3   8BD8                   mov     ebx, eax
005DBEE5   8D957CFCFFFF           lea     edx, [ebp+$FFFFFC7C]

* Reference to pointer to GlobalVar_0061DF08
|
005DBEEB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBEF0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D8
|
005DBEF2   8B80D8030000           mov     eax, [eax+$03D8]
005DBEF8   8B08                   mov     ecx, [eax]
005DBEFA   FF5160                 call    dword ptr [ecx+$60]
005DBEFD   8B857CFCFFFF           mov     eax, [ebp+$FFFFFC7C]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBF03   E8ACDAE2FF             call    004099B4
005DBF08   2BD8                   sub     ebx, eax
005DBF0A   7930                   jns     005DBF3C

* Reference to pointer to GlobalVar_0061DF08
|
005DBF0C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBF11   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DBF13   8B8034050000           mov     eax, [eax+$0534]
005DBF19   8B10                   mov     edx, [eax]
005DBF1B   FF5258                 call    dword ptr [edx+$58]
005DBF1E   8D9578FCFFFF           lea     edx, [ebp+$FFFFFC78]

* Reference to: Unit_00408494.Proc_00409950
|
005DBF24   E827DAE2FF             call    00409950
005DBF29   8B8578FCFFFF           mov     eax, [ebp+$FFFFFC78]
005DBF2F   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'st.Heirats-/Sterbe-Daten �berpr�fen'
|
005DBF32   BA94CB5D00             mov     edx, $005DCB94

* Reference to : TForm1.Proc_005D97B8()
|
005DBF37   E87CD8FFFF             call    005D97B8
005DBF3C   8D9570FCFFFF           lea     edx, [ebp+$FFFFFC70]

* Reference to pointer to GlobalVar_0061DF08
|
005DBF42   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBF47   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DBF49   8B8084050000           mov     eax, [eax+$0584]
005DBF4F   8B08                   mov     ecx, [eax]
005DBF51   FF5160                 call    dword ptr [ecx+$60]
005DBF54   8B8570FCFFFF           mov     eax, [ebp+$FFFFFC70]
005DBF5A   8D9574FCFFFF           lea     edx, [ebp+$FFFFFC74]

* Reference to: Unit_00408494.Proc_00409448
|
005DBF60   E8E3D4E2FF             call    00409448
005DBF65   83BD74FCFFFF00         cmp     dword ptr [ebp+$FFFFFC74], +$00
005DBF6C   0F86AE000000           jbe     005DC020
005DBF72   8D9568FCFFFF           lea     edx, [ebp+$FFFFFC68]

* Reference to pointer to GlobalVar_0061DF08
|
005DBF78   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBF7D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F0
|
005DBF7F   8B80F0030000           mov     eax, [eax+$03F0]
005DBF85   8B08                   mov     ecx, [eax]
005DBF87   FF5160                 call    dword ptr [ecx+$60]
005DBF8A   8B8568FCFFFF           mov     eax, [ebp+$FFFFFC68]
005DBF90   8D956CFCFFFF           lea     edx, [ebp+$FFFFFC6C]

* Reference to: Unit_00408494.Proc_00409448
|
005DBF96   E8ADD4E2FF             call    00409448
005DBF9B   83BD6CFCFFFF00         cmp     dword ptr [ebp+$FFFFFC6C], +$00
005DBFA2   767C                   jbe     005DC020
005DBFA4   8D9564FCFFFF           lea     edx, [ebp+$FFFFFC64]

* Reference to pointer to GlobalVar_0061DF08
|
005DBFAA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBFAF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005DBFB1   8B8084050000           mov     eax, [eax+$0584]
005DBFB7   8B08                   mov     ecx, [eax]
005DBFB9   FF5160                 call    dword ptr [ecx+$60]
005DBFBC   8B8564FCFFFF           mov     eax, [ebp+$FFFFFC64]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBFC2   E8EDD9E2FF             call    004099B4
005DBFC7   8BD8                   mov     ebx, eax
005DBFC9   8D9560FCFFFF           lea     edx, [ebp+$FFFFFC60]

* Reference to pointer to GlobalVar_0061DF08
|
005DBFCF   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBFD4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F0
|
005DBFD6   8B80F0030000           mov     eax, [eax+$03F0]
005DBFDC   8B08                   mov     ecx, [eax]
005DBFDE   FF5160                 call    dword ptr [ecx+$60]
005DBFE1   8B8560FCFFFF           mov     eax, [ebp+$FFFFFC60]

* Reference to: Unit_00408494.Proc_004099B4
|
005DBFE7   E8C8D9E2FF             call    004099B4
005DBFEC   2BD8                   sub     ebx, eax
005DBFEE   7930                   jns     005DC020

* Reference to pointer to GlobalVar_0061DF08
|
005DBFF0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DBFF5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DBFF7   8B8034050000           mov     eax, [eax+$0534]
005DBFFD   8B10                   mov     edx, [eax]
005DBFFF   FF5258                 call    dword ptr [edx+$58]
005DC002   8D955CFCFFFF           lea     edx, [ebp+$FFFFFC5C]

* Reference to: Unit_00408494.Proc_00409950
|
005DC008   E843D9E2FF             call    00409950
005DC00D   8B855CFCFFFF           mov     eax, [ebp+$FFFFFC5C]
005DC013   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Scheidungs-/Sterbe-Daten �berpr�fen'
|
005DC016   BAC0CB5D00             mov     edx, $005DCBC0

* Reference to : TForm1.Proc_005D97B8()
|
005DC01B   E898D7FFFF             call    005D97B8
005DC020   8D9554FCFFFF           lea     edx, [ebp+$FFFFFC54]

* Reference to pointer to GlobalVar_0061DF08
|
005DC026   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC02B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DC02D   8B8098050000           mov     eax, [eax+$0598]
005DC033   8B08                   mov     ecx, [eax]
005DC035   FF5160                 call    dword ptr [ecx+$60]
005DC038   8B8554FCFFFF           mov     eax, [ebp+$FFFFFC54]
005DC03E   8D9558FCFFFF           lea     edx, [ebp+$FFFFFC58]

* Reference to: Unit_00408494.Proc_00409448
|
005DC044   E8FFD3E2FF             call    00409448
005DC049   83BD58FCFFFF00         cmp     dword ptr [ebp+$FFFFFC58], +$00
005DC050   0F86AE000000           jbe     005DC104
005DC056   8D954CFCFFFF           lea     edx, [ebp+$FFFFFC4C]

* Reference to pointer to GlobalVar_0061DF08
|
005DC05C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC061   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C4
|
005DC063   8B80C4030000           mov     eax, [eax+$03C4]
005DC069   8B08                   mov     ecx, [eax]
005DC06B   FF5160                 call    dword ptr [ecx+$60]
005DC06E   8B854CFCFFFF           mov     eax, [ebp+$FFFFFC4C]
005DC074   8D9550FCFFFF           lea     edx, [ebp+$FFFFFC50]

* Reference to: Unit_00408494.Proc_00409448
|
005DC07A   E8C9D3E2FF             call    00409448
005DC07F   83BD50FCFFFF00         cmp     dword ptr [ebp+$FFFFFC50], +$00
005DC086   767C                   jbe     005DC104
005DC088   8D9548FCFFFF           lea     edx, [ebp+$FFFFFC48]

* Reference to pointer to GlobalVar_0061DF08
|
005DC08E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC093   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DC095   8B8098050000           mov     eax, [eax+$0598]
005DC09B   8B08                   mov     ecx, [eax]
005DC09D   FF5160                 call    dword ptr [ecx+$60]
005DC0A0   8B8548FCFFFF           mov     eax, [ebp+$FFFFFC48]

* Reference to: Unit_00408494.Proc_004099B4
|
005DC0A6   E809D9E2FF             call    004099B4
005DC0AB   8BD8                   mov     ebx, eax
005DC0AD   8D9544FCFFFF           lea     edx, [ebp+$FFFFFC44]

* Reference to pointer to GlobalVar_0061DF08
|
005DC0B3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC0B8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C4
|
005DC0BA   8B80C4030000           mov     eax, [eax+$03C4]
005DC0C0   8B08                   mov     ecx, [eax]
005DC0C2   FF5160                 call    dword ptr [ecx+$60]
005DC0C5   8B8544FCFFFF           mov     eax, [ebp+$FFFFFC44]

* Reference to: Unit_00408494.Proc_004099B4
|
005DC0CB   E8E4D8E2FF             call    004099B4
005DC0D0   2BD8                   sub     ebx, eax
005DC0D2   7930                   jns     005DC104

* Reference to pointer to GlobalVar_0061DF08
|
005DC0D4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC0D9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DC0DB   8B8034050000           mov     eax, [eax+$0534]
005DC0E1   8B10                   mov     edx, [eax]
005DC0E3   FF5258                 call    dword ptr [edx+$58]
005DC0E6   8D9540FCFFFF           lea     edx, [ebp+$FFFFFC40]

* Reference to: Unit_00408494.Proc_00409950
|
005DC0EC   E85FD8E2FF             call    00409950
005DC0F1   8B8540FCFFFF           mov     eax, [ebp+$FFFFFC40]
005DC0F7   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'k.Heirats-/Bestatt.-Daten �berpr�fe
|                                n'
|
005DC0FA   BAECCB5D00             mov     edx, $005DCBEC

* Reference to : TForm1.Proc_005D97B8()
|
005DC0FF   E8B4D6FFFF             call    005D97B8
005DC104   8D9538FCFFFF           lea     edx, [ebp+$FFFFFC38]

* Reference to pointer to GlobalVar_0061DF08
|
005DC10A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC10F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DC111   8B8098050000           mov     eax, [eax+$0598]
005DC117   8B08                   mov     ecx, [eax]
005DC119   FF5160                 call    dword ptr [ecx+$60]
005DC11C   8B8538FCFFFF           mov     eax, [ebp+$FFFFFC38]
005DC122   8D953CFCFFFF           lea     edx, [ebp+$FFFFFC3C]

* Reference to: Unit_00408494.Proc_00409448
|
005DC128   E81BD3E2FF             call    00409448
005DC12D   83BD3CFCFFFF00         cmp     dword ptr [ebp+$FFFFFC3C], +$00
005DC134   0F86AE000000           jbe     005DC1E8
005DC13A   8D9530FCFFFF           lea     edx, [ebp+$FFFFFC30]

* Reference to pointer to GlobalVar_0061DF08
|
005DC140   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC145   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D8
|
005DC147   8B80D8030000           mov     eax, [eax+$03D8]
005DC14D   8B08                   mov     ecx, [eax]
005DC14F   FF5160                 call    dword ptr [ecx+$60]
005DC152   8B8530FCFFFF           mov     eax, [ebp+$FFFFFC30]
005DC158   8D9534FCFFFF           lea     edx, [ebp+$FFFFFC34]

* Reference to: Unit_00408494.Proc_00409448
|
005DC15E   E8E5D2E2FF             call    00409448
005DC163   83BD34FCFFFF00         cmp     dword ptr [ebp+$FFFFFC34], +$00
005DC16A   767C                   jbe     005DC1E8
005DC16C   8D952CFCFFFF           lea     edx, [ebp+$FFFFFC2C]

* Reference to pointer to GlobalVar_0061DF08
|
005DC172   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC177   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DC179   8B8098050000           mov     eax, [eax+$0598]
005DC17F   8B08                   mov     ecx, [eax]
005DC181   FF5160                 call    dword ptr [ecx+$60]
005DC184   8B852CFCFFFF           mov     eax, [ebp+$FFFFFC2C]

* Reference to: Unit_00408494.Proc_004099B4
|
005DC18A   E825D8E2FF             call    004099B4
005DC18F   8BD8                   mov     ebx, eax
005DC191   8D9528FCFFFF           lea     edx, [ebp+$FFFFFC28]

* Reference to pointer to GlobalVar_0061DF08
|
005DC197   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC19C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D8
|
005DC19E   8B80D8030000           mov     eax, [eax+$03D8]
005DC1A4   8B08                   mov     ecx, [eax]
005DC1A6   FF5160                 call    dword ptr [ecx+$60]
005DC1A9   8B8528FCFFFF           mov     eax, [ebp+$FFFFFC28]

* Reference to: Unit_00408494.Proc_004099B4
|
005DC1AF   E800D8E2FF             call    004099B4
005DC1B4   2BD8                   sub     ebx, eax
005DC1B6   7930                   jns     005DC1E8

* Reference to pointer to GlobalVar_0061DF08
|
005DC1B8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC1BD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DC1BF   8B8034050000           mov     eax, [eax+$0534]
005DC1C5   8B10                   mov     edx, [eax]
005DC1C7   FF5258                 call    dword ptr [edx+$58]
005DC1CA   8D9524FCFFFF           lea     edx, [ebp+$FFFFFC24]

* Reference to: Unit_00408494.Proc_00409950
|
005DC1D0   E87BD7E2FF             call    00409950
005DC1D5   8B8524FCFFFF           mov     eax, [ebp+$FFFFFC24]
005DC1DB   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'st.Heirats-/Bestatt.-Daten �berpr�f
|                                en'
|
005DC1DE   BA1CCC5D00             mov     edx, $005DCC1C

* Reference to : TForm1.Proc_005D97B8()
|
005DC1E3   E8D0D5FFFF             call    005D97B8
005DC1E8   8D951CFCFFFF           lea     edx, [ebp+$FFFFFC1C]

* Reference to pointer to GlobalVar_0061DF08
|
005DC1EE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC1F3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DC1F5   8B8098050000           mov     eax, [eax+$0598]
005DC1FB   8B08                   mov     ecx, [eax]
005DC1FD   FF5160                 call    dword ptr [ecx+$60]
005DC200   8B851CFCFFFF           mov     eax, [ebp+$FFFFFC1C]
005DC206   8D9520FCFFFF           lea     edx, [ebp+$FFFFFC20]

* Reference to: Unit_00408494.Proc_00409448
|
005DC20C   E837D2E2FF             call    00409448
005DC211   83BD20FCFFFF00         cmp     dword ptr [ebp+$FFFFFC20], +$00
005DC218   0F86AE000000           jbe     005DC2CC
005DC21E   8D9514FCFFFF           lea     edx, [ebp+$FFFFFC14]

* Reference to pointer to GlobalVar_0061DF08
|
005DC224   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC229   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F0
|
005DC22B   8B80F0030000           mov     eax, [eax+$03F0]
005DC231   8B08                   mov     ecx, [eax]
005DC233   FF5160                 call    dword ptr [ecx+$60]
005DC236   8B8514FCFFFF           mov     eax, [ebp+$FFFFFC14]
005DC23C   8D9518FCFFFF           lea     edx, [ebp+$FFFFFC18]

* Reference to: Unit_00408494.Proc_00409448
|
005DC242   E801D2E2FF             call    00409448
005DC247   83BD18FCFFFF00         cmp     dword ptr [ebp+$FFFFFC18], +$00
005DC24E   767C                   jbe     005DC2CC
005DC250   8D9510FCFFFF           lea     edx, [ebp+$FFFFFC10]

* Reference to pointer to GlobalVar_0061DF08
|
005DC256   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC25B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005DC25D   8B8098050000           mov     eax, [eax+$0598]
005DC263   8B08                   mov     ecx, [eax]
005DC265   FF5160                 call    dword ptr [ecx+$60]
005DC268   8B8510FCFFFF           mov     eax, [ebp+$FFFFFC10]

* Reference to: Unit_00408494.Proc_004099B4
|
005DC26E   E841D7E2FF             call    004099B4
005DC273   8BD8                   mov     ebx, eax
005DC275   8D950CFCFFFF           lea     edx, [ebp+$FFFFFC0C]

* Reference to pointer to GlobalVar_0061DF08
|
005DC27B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC280   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F0
|
005DC282   8B80F0030000           mov     eax, [eax+$03F0]
005DC288   8B08                   mov     ecx, [eax]
005DC28A   FF5160                 call    dword ptr [ecx+$60]
005DC28D   8B850CFCFFFF           mov     eax, [ebp+$FFFFFC0C]

* Reference to: Unit_00408494.Proc_004099B4
|
005DC293   E81CD7E2FF             call    004099B4
005DC298   2BD8                   sub     ebx, eax
005DC29A   7930                   jns     005DC2CC

* Reference to pointer to GlobalVar_0061DF08
|
005DC29C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC2A1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DC2A3   8B8034050000           mov     eax, [eax+$0534]
005DC2A9   8B10                   mov     edx, [eax]
005DC2AB   FF5258                 call    dword ptr [edx+$58]
005DC2AE   8D9508FCFFFF           lea     edx, [ebp+$FFFFFC08]

* Reference to: Unit_00408494.Proc_00409950
|
005DC2B4   E897D6E2FF             call    00409950
005DC2B9   8B8508FCFFFF           mov     eax, [ebp+$FFFFFC08]
005DC2BF   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Scheidungs-/Bestatt.-Daten �berpr�f
|                                en'
|
005DC2C2   BA4CCC5D00             mov     edx, $005DCC4C

* Reference to : TForm1.Proc_005D97B8()
|
005DC2C7   E8ECD4FFFF             call    005D97B8

* Reference to pointer to GlobalVar_0061DF08
|
005DC2CC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC2D1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005DC2D3   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005DC2D9   E80E32EDFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005DC2DE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC2E3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005DC2E5   8B80A4000000           mov     eax, [eax+$00A4]
005DC2EB   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005DC2F2   751B                   jnz     005DC30F

* Reference to pointer to GlobalVar_0061DF08
|
005DC2F4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC2F9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03B4
|
005DC2FB   8B80B4030000           mov     eax, [eax+$03B4]
005DC301   8B10                   mov     edx, [eax]
005DC303   FF5258                 call    dword ptr [edx+$58]
005DC306   3B45E8                 cmp     eax, [ebp-$18]
005DC309   0F84E7F3FFFF           jz      005DB6F6
005DC30F   33C0                   xor     eax, eax
005DC311   5A                     pop     edx
005DC312   59                     pop     ecx
005DC313   59                     pop     ecx
005DC314   648910                 mov     fs:[eax], edx
005DC317   EB3A                   jmp     005DC353

* Reference to: System.@HandleAnyException;
|
005DC319   E9FA7EE2FF             jmp     00404218

* Reference to pointer to GlobalVar_0061DF08
|
005DC31E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC323   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005DC325   8B8034050000           mov     eax, [eax+$0534]
005DC32B   8B10                   mov     edx, [eax]
005DC32D   FF5258                 call    dword ptr [edx+$58]
005DC330   8D9504FCFFFF           lea     edx, [ebp+$FFFFFC04]

* Reference to: Unit_00408494.Proc_00409950
|
005DC336   E815D6E2FF             call    00409950
005DC33B   8B8504FCFFFF           mov     eax, [ebp+$FFFFFC04]
005DC341   8D4DEC                 lea     ecx, [ebp-$14]

* Possible String Reference to: 'Schreibfehler in Datum o.�.'
|
005DC344   BA7CCC5D00             mov     edx, $005DCC7C

* Reference to : TForm1.Proc_005D97B8()
|
005DC349   E86AD4FFFF             call    005D97B8

* Reference to: System.@DoneExcept;
|
005DC34E   E8F182E2FF             call    00404644

****** END
|
005DC353   8B45E8                 mov     eax, [ebp-$18]
005DC356   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DC35C   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DC363   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DC369   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC36E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DC370   8B405C                 mov     eax, [eax+$5C]
005DC373   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DC375   E8EA6EEFFF             call    004D3264

* Reference to pointer to GlobalVar_0061DF08
|
005DC37A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC37F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DC381   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005DC384   E86331EDFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005DC389   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC38E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DC390   8B405C                 mov     eax, [eax+$5C]
005DC393   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005DC39A   7517                   jnz     005DC3B3

* Reference to pointer to GlobalVar_0061DF08
|
005DC39C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC3A1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DC3A3   8B405C                 mov     eax, [eax+$5C]
005DC3A6   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005DC3AD   0F8467D7FFFF           jz      005D9B1A

* Reference to Form1
|
005DC3B3   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0400
|
005DC3B8   8B8000040000           mov     eax, [eax+$0400]
005DC3BE   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005DC3C0   E85F05E7FF             call    0044C924

* Reference to Form1
|
005DC3C5   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0404
|
005DC3CA   8B8004040000           mov     eax, [eax+$0404]
005DC3D0   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005DC3D2   E84D05E7FF             call    0044C924
005DC3D7   33C0                   xor     eax, eax
005DC3D9   5A                     pop     edx
005DC3DA   59                     pop     ecx
005DC3DB   59                     pop     ecx
005DC3DC   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '��'
|
005DC3DF   68FAC35D00             push    $005DC3FA

* Reference to TScreen instance
|
005DC3E4   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005DC3E9   8B00                   mov     eax, [eax]
005DC3EB   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005DC3ED   E8AAEDE8FF             call    0046B19C
005DC3F2   C3                     ret


* Reference to: System.@HandleFinally;
|
005DC3F3   E9D480E2FF             jmp     004044CC
005DC3F8   EBEA                   jmp     005DC3E4

****** END
|
005DC3FA   8D9500FCFFFF           lea     edx, [ebp+$FFFFFC00]
005DC400   8B45EC                 mov     eax, [ebp-$14]

* Reference to: Unit_00408494.Proc_00409950
|
005DC403   E848D5E2FF             call    00409950
005DC408   8D8500FCFFFF           lea     eax, [ebp+$FFFFFC00]

* Possible String Reference to: ' Fehler gefunden.'
|
005DC40E   BAA0CC5D00             mov     edx, $005DCCA0

* Reference to: System.@LStrCat;
|
005DC413   E8108AE2FF             call    00404E28
005DC418   8B8500FCFFFF           mov     eax, [ebp+$FFFFFC00]

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005DC41E   E8C193E6FF             call    004457E4
005DC423   837DEC00               cmp     dword ptr [ebp-$14], +$00
005DC427   7E12                   jle     005DC43B

* Reference to Form1
|
005DC429   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0674
|
005DC42E   8B8074060000           mov     eax, [eax+$0674]
005DC434   B201                   mov     dl, $01

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005DC436   E8E904E7FF             call    0044C924

* Reference to Form1
|
005DC43B   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabenab()
|
005DC43E   E815C4FFFF             call    005D8858
005DC443   8B45F8                 mov     eax, [ebp-$08]
005DC446   89856CFFFFFF           mov     [ebp+$FFFFFF6C], eax
005DC44C   C68570FFFFFF00         mov     byte ptr [ebp+$FFFFFF70], $00
005DC453   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]

* Reference to pointer to GlobalVar_0061DF08
|
005DC459   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005DC45E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005DC460   8B405C                 mov     eax, [eax+$5C]
005DC463   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005DC465   E8FA6DEFFF             call    004D3264

* Reference to Form1
|
005DC46A   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.anzeigen()
|
005DC46D   E82A7FFFFF             call    005D439C
005DC472   33C0                   xor     eax, eax
005DC474   5A                     pop     edx
005DC475   59                     pop     ecx
005DC476   59                     pop     ecx
005DC477   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005DC47A   68F8C45D00             push    $005DC4F8
005DC47F   8D8500FCFFFF           lea     eax, [ebp+$FFFFFC00]
005DC485   BA63000000             mov     edx, $00000063

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005DC48A   E8FD86E2FF             call    00404B8C
005DC48F   8D8590FDFFFF           lea     eax, [ebp+$FFFFFD90]

* Reference to: System.@LStrClr(void;void);
|
005DC495   E8CE86E2FF             call    00404B68
005DC49A   8D858CFDFFFF           lea     eax, [ebp+$FFFFFD8C]

* Reference to: System.@LStrClr(void;void);
|
005DC4A0   E8C386E2FF             call    00404B68
005DC4A5   8D8594FDFFFF           lea     eax, [ebp+$FFFFFD94]
005DC4AB   BA60000000             mov     edx, $00000060

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005DC4B0   E8D786E2FF             call    00404B8C
005DC4B5   8D8518FFFFFF           lea     eax, [ebp+$FFFFFF18]
005DC4BB   BA03000000             mov     edx, $00000003

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005DC4C0   E8C786E2FF             call    00404B8C
005DC4C5   8D8514FFFFFF           lea     eax, [ebp+$FFFFFF14]

* Reference to: System.@LStrClr(void;void);
|
005DC4CB   E89886E2FF             call    00404B68
005DC4D0   8D8524FFFFFF           lea     eax, [ebp+$FFFFFF24]
005DC4D6   BA12000000             mov     edx, $00000012

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005DC4DB   E8AC86E2FF             call    00404B8C
005DC4E0   8D8574FFFFFF           lea     eax, [ebp+$FFFFFF74]
005DC4E6   BA1C000000             mov     edx, $0000001C

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005DC4EB   E89C86E2FF             call    00404B8C
005DC4F0   C3                     ret


* Reference to: System.@HandleFinally;
|
005DC4F1   E9D67FE2FF             jmp     004044CC
005DC4F6   EB87                   jmp     005DC47F

****** END
|
005DC4F8   5F                     pop     edi
005DC4F9   5E                     pop     esi
005DC4FA   5B                     pop     ebx
005DC4FB   8BE5                   mov     esp, ebp
005DC4FD   5D                     pop     ebp
005DC4FE   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.StringGrid5
    (TStringGrid); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.Close(TDataSet);; DB.TDataSet.First(TDataSet);;
    DB.TDataSet.Next(TDataSet);; DB.TDataSet.Open(TDataSet);;
    DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.EmptyTable(TTable);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_0534; OFFS_0674
Project calls: TForm1.anzeigen(); TForm1.Proc_005D97B8(); TForm1.tabdisab(); TForm1.tabenab();
    Unit_00408494.Proc_00409950; Unit_00408494.Proc_00409CD0; Unit_00408494.Proc_00409F2C
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetVisible(TControl;Boolean);; Dialogs.ShowMessage(AnsiString);;
    Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);;
    Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);; method TMenuItem.Click();
    System.Proc_00404EE0
Strings/files/dialog text: ' und '; 'Alle Beziehungen sind verkn�pft.'; 'nicht verkn�pfte
    Beziehungen'; 'num'; 'nvbez.HTM'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.NichtverknpfteBeziehungen1Click(Sender : TObject);
begin
(*
00606210   55                     push    ebp
00606211   8BEC                   mov     ebp, esp
00606213   B90A000000             mov     ecx, $0000000A
00606218   6A00                   push    $00
0060621A   6A00                   push    $00
0060621C   49                     dec     ecx
0060621D   75F9                   jnz     00606218
0060621F   51                     push    ecx
00606220   53                     push    ebx
00606221   56                     push    esi
00606222   57                     push    edi
00606223   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
00606225   8B1D3CCC6100           mov     ebx, [$0061CC3C]
0060622B   33C0                   xor     eax, eax
0060622D   55                     push    ebp
0060622E   68CA666000             push    $006066CA

***** TRY
|
00606233   64FF30                 push    dword ptr fs:[eax]
00606236   648920                 mov     fs:[eax], esp

* Reference to control TForm1.aus1 : TMenuItem
|
00606239   8B861C060000           mov     eax, [esi+$061C]
0060623F   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
00606241   FF5244                 call    dword ptr [edx+$44]
00606244   8B03                   mov     eax, [ebx]

* Reference to field TMenuItem.OFFS_0534
|
00606246   8B8034050000           mov     eax, [eax+$0534]
0060624C   8B10                   mov     edx, [eax]
0060624E   FF5258                 call    dword ptr [edx+$58]
00606251   8945FC                 mov     [ebp-$04], eax
00606254   8B03                   mov     eax, [ebx]
00606256   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Close(TDataSet);
|
0060625C   E8336AEAFF             call    004ACC94
00606261   8B03                   mov     eax, [ebx]
00606263   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
00606269   E86EDDECFF             call    004D3FDC
0060626E   8B03                   mov     eax, [ebx]
00606270   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
00606276   E80D6AEAFF             call    004ACC88
0060627B   8B03                   mov     eax, [ebx]
0060627D   8B8040010000           mov     eax, [eax+$0140]

* Reference to: DB.TDataSet.Open(TDataSet);
|
00606283   E8006AEAFF             call    004ACC88
00606288   8B03                   mov     eax, [ebx]
0060628A   8B8040010000           mov     eax, [eax+$0140]

* Possible String Reference to: 'num'
|
00606290   BAE0666000             mov     edx, $006066E0

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
00606295   E8C2C8ECFF             call    004D2B5C
0060629A   8B03                   mov     eax, [ebx]
0060629C   8B8040010000           mov     eax, [eax+$0140]

* Reference to: DB.TDataSet.First(TDataSet);
|
006062A2   E82D8FEAFF             call    004AF1D4
006062A7   8BC6                   mov     eax, esi

* Reference to : TForm1.tabdisab()
|
006062A9   E88625FDFF             call    005D8834
006062AE   8B03                   mov     eax, [ebx]

* Reference to field TForm1.AutoSize : Boolean
|
006062B0   8B405C                 mov     eax, [eax+$5C]
006062B3   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
006062B5   E8A2C8ECFF             call    004D2B5C
006062BA   8B03                   mov     eax, [ebx]

* Reference to field Boolean.OFFS_005C
|
006062BC   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
006062BF   E8108FEAFF             call    004AF1D4
006062C4   8D45F4                 lea     eax, [ebp-$0C]

* Reference to: System.@LStrClr(void;void);
|
006062C7   E89CE8DFFF             call    00404B68
006062CC   33C0                   xor     eax, eax
006062CE   8945F8                 mov     [ebp-$08], eax
006062D1   8D45F0                 lea     eax, [ebp-$10]

* Reference to: System.@LStrClr(void;void);
|
006062D4   E88FE8DFFF             call    00404B68
006062D9   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid5 : TStringGrid
|
006062DE   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
006062E4   E8E775EDFF             call    004DD8D0

* Possible String Reference to: 'nicht verkn�pfte Beziehungen'
|
006062E9   68EC666000             push    $006066EC

* Reference to Form1
|
006062EE   A108595302             mov     eax, dword ptr [$02535908]

* Reference to field Form1.OFFS_0674
|
006062F3   8B8074060000           mov     eax, [eax+$0674]
006062F9   33C9                   xor     ecx, ecx
006062FB   BA01000000             mov     edx, $00000001

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
00606300   E8F797EDFF             call    004DFAFC
00606305   E917030000             jmp     00606621
0060630A   8B03                   mov     eax, [ebx]
0060630C   8B8038050000           mov     eax, [eax+$0538]
00606312   8B10                   mov     edx, [eax]
00606314   FF5258                 call    dword ptr [edx+$58]
00606317   85C0                   test    eax, eax
00606319   0F8EEA020000           jle     00606609
0060631F   8B03                   mov     eax, [ebx]
00606321   8B803C050000           mov     eax, [eax+$053C]
00606327   8B10                   mov     edx, [eax]
00606329   FF5258                 call    dword ptr [edx+$58]
0060632C   85C0                   test    eax, eax
0060632E   0F8ED5020000           jle     00606609
00606334   33FF                   xor     edi, edi
00606336   8B03                   mov     eax, [ebx]
00606338   8B8038050000           mov     eax, [eax+$0538]
0060633E   8B10                   mov     edx, [eax]
00606340   FF5258                 call    dword ptr [edx+$58]
00606343   8945E8                 mov     [ebp-$18], eax
00606346   C645EC00               mov     byte ptr [ebp-$14], $00
0060634A   8D55E8                 lea     edx, [ebp-$18]
0060634D   8B03                   mov     eax, [ebx]
0060634F   8B8040010000           mov     eax, [eax+$0140]
00606355   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00606357   E808CFECFF             call    004D3264
0060635C   84C0                   test    al, al
0060635E   7467                   jz      006063C7
00606360   EB45                   jmp     006063A7
00606362   8B03                   mov     eax, [ebx]
00606364   8B80CC040000           mov     eax, [eax+$04CC]
0060636A   8B10                   mov     edx, [eax]
0060636C   FF5258                 call    dword ptr [edx+$58]
0060636F   50                     push    eax
00606370   8B03                   mov     eax, [ebx]
00606372   8B803C050000           mov     eax, [eax+$053C]
00606378   8B10                   mov     edx, [eax]
0060637A   FF5258                 call    dword ptr [edx+$58]
0060637D   5A                     pop     edx
0060637E   3BD0                   cmp     edx, eax
00606380   7507                   jnz     00606389
00606382   BF01000000             mov     edi, $00000001
00606387   EB3E                   jmp     006063C7
00606389   8B03                   mov     eax, [ebx]
0060638B   8B8040010000           mov     eax, [eax+$0140]

* Reference to: DB.TDataSet.Next(TDataSet);
|
00606391   E85691EAFF             call    004AF4EC
00606396   8B03                   mov     eax, [ebx]
00606398   8B8040010000           mov     eax, [eax+$0140]
0060639E   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
006063A5   7520                   jnz     006063C7
006063A7   8B03                   mov     eax, [ebx]
006063A9   8B80C8040000           mov     eax, [eax+$04C8]
006063AF   8B10                   mov     edx, [eax]
006063B1   FF5258                 call    dword ptr [edx+$58]
006063B4   50                     push    eax
006063B5   8B03                   mov     eax, [ebx]
006063B7   8B8038050000           mov     eax, [eax+$0538]
006063BD   8B10                   mov     edx, [eax]
006063BF   FF5258                 call    dword ptr [edx+$58]
006063C2   5A                     pop     edx
006063C3   3BD0                   cmp     edx, eax
006063C5   749B                   jz      00606362
006063C7   85FF                   test    edi, edi
006063C9   0F853A020000           jnz     00606609
006063CF   8B03                   mov     eax, [ebx]
006063D1   8B8038050000           mov     eax, [eax+$0538]
006063D7   8B10                   mov     edx, [eax]
006063D9   FF5258                 call    dword ptr [edx+$58]
006063DC   8D55E0                 lea     edx, [ebp-$20]

* Reference to: Unit_00408494.Proc_00409950
|
006063DF   E86C35E0FF             call    00409950
006063E4   FF75E0                 push    dword ptr [ebp-$20]

* Possible String Reference to: ' und '
|
006063E7   6814676000             push    $00606714
006063EC   8B03                   mov     eax, [ebx]
006063EE   8B803C050000           mov     eax, [eax+$053C]
006063F4   8B10                   mov     edx, [eax]
006063F6   FF5258                 call    dword ptr [edx+$58]
006063F9   8D55DC                 lea     edx, [ebp-$24]

* Reference to: Unit_00408494.Proc_00409950
|
006063FC   E84F35E0FF             call    00409950
00606401   FF75DC                 push    dword ptr [ebp-$24]
00606404   8D45E4                 lea     eax, [ebp-$1C]
00606407   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
0060640C   E8CFEADFFF             call    00404EE0
00606411   8B45E4                 mov     eax, [ebp-$1C]
00606414   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrPos;
|
00606417   E840EDDFFF             call    0040515C
0060641C   85C0                   test    eax, eax
0060641E   0F85E5010000           jnz     00606609
00606424   8B03                   mov     eax, [ebx]
00606426   8B8034050000           mov     eax, [eax+$0534]
0060642C   8B10                   mov     edx, [eax]
0060642E   FF5258                 call    dword ptr [edx+$58]
00606431   8BF8                   mov     edi, eax
00606433   8B03                   mov     eax, [ebx]
00606435   8B8038050000           mov     eax, [eax+$0538]
0060643B   8B10                   mov     edx, [eax]
0060643D   FF5258                 call    dword ptr [edx+$58]
00606440   8945E8                 mov     [ebp-$18], eax
00606443   C645EC00               mov     byte ptr [ebp-$14], $00
00606447   8D55E8                 lea     edx, [ebp-$18]
0060644A   8B03                   mov     eax, [ebx]
0060644C   8B405C                 mov     eax, [eax+$5C]
0060644F   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00606451   E80ECEECFF             call    004D3264
00606456   8B03                   mov     eax, [ebx]
00606458   8B8034050000           mov     eax, [eax+$0534]
0060645E   8B10                   mov     edx, [eax]
00606460   FF5258                 call    dword ptr [edx+$58]
00606463   8D55D8                 lea     edx, [ebp-$28]

* Reference to: Unit_00408494.Proc_00409950
|
00606466   E8E534E0FF             call    00409950
0060646B   8B45D8                 mov     eax, [ebp-$28]
0060646E   8B55F0                 mov     edx, [ebp-$10]

* Reference to: System.@LStrPos;
|
00606471   E8E6ECDFFF             call    0040515C
00606476   85C0                   test    eax, eax
00606478   0F858A000000           jnz     00606508
0060647E   FF75F0                 push    dword ptr [ebp-$10]
00606481   8B03                   mov     eax, [ebx]
00606483   8B8034050000           mov     eax, [eax+$0534]
00606489   8B10                   mov     edx, [eax]
0060648B   FF5258                 call    dword ptr [edx+$58]
0060648E   8D55D4                 lea     edx, [ebp-$2C]

* Reference to: Unit_00408494.Proc_00409950
|
00606491   E8BA34E0FF             call    00409950
00606496   FF75D4                 push    dword ptr [ebp-$2C]
00606499   6824676000             push    $00606724
0060649E   8D45F0                 lea     eax, [ebp-$10]
006064A1   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006064A6   E835EADFFF             call    00404EE0
006064AB   8D55CC                 lea     edx, [ebp-$34]
006064AE   8B03                   mov     eax, [ebx]
006064B0   8B8040050000           mov     eax, [eax+$0540]
006064B6   8B08                   mov     ecx, [eax]
006064B8   FF5160                 call    dword ptr [ecx+$60]
006064BB   FF75CC                 push    dword ptr [ebp-$34]
006064BE   6830676000             push    $00606730
006064C3   8D55C8                 lea     edx, [ebp-$38]
006064C6   8B03                   mov     eax, [ebx]
006064C8   8B8044050000           mov     eax, [eax+$0544]
006064CE   8B08                   mov     ecx, [eax]
006064D0   FF5160                 call    dword ptr [ecx+$60]
006064D3   FF75C8                 push    dword ptr [ebp-$38]
006064D6   8D45D0                 lea     eax, [ebp-$30]
006064D9   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006064DE   E8FDE9DFFF             call    00404EE0
006064E3   8B45D0                 mov     eax, [ebp-$30]
006064E6   50                     push    eax
006064E7   8B03                   mov     eax, [ebx]
006064E9   8B8034050000           mov     eax, [eax+$0534]
006064EF   8B10                   mov     edx, [eax]
006064F1   FF5258                 call    dword ptr [edx+$58]
006064F4   8D55C4                 lea     edx, [ebp-$3C]

* Reference to: Unit_00408494.Proc_00409950
|
006064F7   E85434E0FF             call    00409950
006064FC   8B45C4                 mov     eax, [ebp-$3C]
006064FF   8D4DF8                 lea     ecx, [ebp-$08]
00606502   5A                     pop     edx

* Reference to : TForm1.Proc_005D97B8()
|
00606503   E8B032FDFF             call    005D97B8
00606508   897DE8                 mov     [ebp-$18], edi
0060650B   C645EC00               mov     byte ptr [ebp-$14], $00
0060650F   8D55E8                 lea     edx, [ebp-$18]
00606512   8B03                   mov     eax, [ebx]
00606514   8B405C                 mov     eax, [eax+$5C]
00606517   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00606519   E846CDECFF             call    004D3264
0060651E   8B03                   mov     eax, [ebx]
00606520   8B803C050000           mov     eax, [eax+$053C]
00606526   8B10                   mov     edx, [eax]
00606528   FF5258                 call    dword ptr [edx+$58]
0060652B   8945E8                 mov     [ebp-$18], eax
0060652E   C645EC00               mov     byte ptr [ebp-$14], $00
00606532   8D55E8                 lea     edx, [ebp-$18]
00606535   8B03                   mov     eax, [ebx]
00606537   8B405C                 mov     eax, [eax+$5C]
0060653A   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060653C   E823CDECFF             call    004D3264
00606541   8B03                   mov     eax, [ebx]
00606543   8B8034050000           mov     eax, [eax+$0534]
00606549   8B10                   mov     edx, [eax]
0060654B   FF5258                 call    dword ptr [edx+$58]
0060654E   8D55C0                 lea     edx, [ebp-$40]

* Reference to: Unit_00408494.Proc_00409950
|
00606551   E8FA33E0FF             call    00409950
00606556   8B45C0                 mov     eax, [ebp-$40]
00606559   8B55F0                 mov     edx, [ebp-$10]

* Reference to: System.@LStrPos;
|
0060655C   E8FBEBDFFF             call    0040515C
00606561   85C0                   test    eax, eax
00606563   0F858A000000           jnz     006065F3
00606569   FF75F0                 push    dword ptr [ebp-$10]
0060656C   8B03                   mov     eax, [ebx]
0060656E   8B8034050000           mov     eax, [eax+$0534]
00606574   8B10                   mov     edx, [eax]
00606576   FF5258                 call    dword ptr [edx+$58]
00606579   8D55BC                 lea     edx, [ebp-$44]

* Reference to: Unit_00408494.Proc_00409950
|
0060657C   E8CF33E0FF             call    00409950
00606581   FF75BC                 push    dword ptr [ebp-$44]
00606584   6824676000             push    $00606724
00606589   8D45F0                 lea     eax, [ebp-$10]
0060658C   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00606591   E84AE9DFFF             call    00404EE0
00606596   8D55B4                 lea     edx, [ebp-$4C]
00606599   8B03                   mov     eax, [ebx]
0060659B   8B8040050000           mov     eax, [eax+$0540]
006065A1   8B08                   mov     ecx, [eax]
006065A3   FF5160                 call    dword ptr [ecx+$60]
006065A6   FF75B4                 push    dword ptr [ebp-$4C]
006065A9   6830676000             push    $00606730
006065AE   8D55B0                 lea     edx, [ebp-$50]
006065B1   8B03                   mov     eax, [ebx]
006065B3   8B8044050000           mov     eax, [eax+$0544]
006065B9   8B08                   mov     ecx, [eax]
006065BB   FF5160                 call    dword ptr [ecx+$60]
006065BE   FF75B0                 push    dword ptr [ebp-$50]
006065C1   8D45B8                 lea     eax, [ebp-$48]
006065C4   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
006065C9   E812E9DFFF             call    00404EE0
006065CE   8B45B8                 mov     eax, [ebp-$48]
006065D1   50                     push    eax
006065D2   8B03                   mov     eax, [ebx]
006065D4   8B8034050000           mov     eax, [eax+$0534]
006065DA   8B10                   mov     edx, [eax]
006065DC   FF5258                 call    dword ptr [edx+$58]
006065DF   8D55AC                 lea     edx, [ebp-$54]

* Reference to: Unit_00408494.Proc_00409950
|
006065E2   E86933E0FF             call    00409950
006065E7   8B45AC                 mov     eax, [ebp-$54]
006065EA   8D4DF8                 lea     ecx, [ebp-$08]
006065ED   5A                     pop     edx

* Reference to : TForm1.Proc_005D97B8()
|
006065EE   E8C531FDFF             call    005D97B8
006065F3   897DE8                 mov     [ebp-$18], edi
006065F6   C645EC00               mov     byte ptr [ebp-$14], $00
006065FA   8D55E8                 lea     edx, [ebp-$18]
006065FD   8B03                   mov     eax, [ebx]
006065FF   8B405C                 mov     eax, [eax+$5C]
00606602   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00606604   E85BCCECFF             call    004D3264
00606609   8B03                   mov     eax, [ebx]
0060660B   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060660E   E8D98EEAFF             call    004AF4EC
00606613   8B03                   mov     eax, [ebx]
00606615   8B405C                 mov     eax, [eax+$5C]
00606618   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060661F   7512                   jnz     00606633
00606621   8B03                   mov     eax, [ebx]
00606623   8B405C                 mov     eax, [eax+$5C]
00606626   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060662D   0F84D7FCFFFF           jz      0060630A

* Reference to Form1
|
00606633   8B45FC                 mov     eax, [ebp-$04]
00606636   8945E8                 mov     [ebp-$18], eax
00606639   C645EC00               mov     byte ptr [ebp-$14], $00
0060663D   8D55E8                 lea     edx, [ebp-$18]
00606640   8B03                   mov     eax, [ebx]

* Reference to field Form1.OFFS_005C
|
00606642   8B405C                 mov     eax, [eax+$5C]
00606645   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
00606647   E818CCECFF             call    004D3264
0060664C   8BC6                   mov     eax, esi

* Reference to : TForm1.tabenab()
|
0060664E   E80522FDFF             call    005D8858
00606653   837DF800               cmp     dword ptr [ebp-$08], +$00
00606657   750C                   jnz     00606665

* Possible String Reference to: 'Alle Beziehungen sind verkn�pft.'
|
00606659   B83C676000             mov     eax, $0060673C

* Reference to: Dialogs.ShowMessage(AnsiString);
|
0060665E   E881F1E3FF             call    004457E4
00606663   EB0D                   jmp     00606672
00606665   B201                   mov     dl, $01

* Reference to control TForm1.StringGrid5 : TStringGrid
|
00606667   8B8674060000           mov     eax, [esi+$0674]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
0060666D   E8B262E4FF             call    0044C924

* Reference to control TForm1.TabSheet2 : TTabSheet
|
00606672   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
00606678   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
0060667E   E83597E7FF             call    0047FDB8

* Possible String Reference to: 'nvbez.HTM'
|
00606683   B868676000             mov     eax, $00606768

* Reference to: Unit_00408494.Proc_00409CD0
|
00606688   E84336E0FF             call    00409CD0
0060668D   84C0                   test    al, al
0060668F   740A                   jz      0060669B

* Possible String Reference to: 'nvbez.HTM'
|
00606691   B868676000             mov     eax, $00606768

* Reference to: Unit_00408494.Proc_00409F2C
|
00606696   E89138E0FF             call    00409F2C
0060669B   8BC6                   mov     eax, esi

* Reference to : TForm1.anzeigen()
|
0060669D   E8FADCFCFF             call    005D439C
006066A2   33C0                   xor     eax, eax
006066A4   5A                     pop     edx
006066A5   59                     pop     ecx
006066A6   59                     pop     ecx
006066A7   648910                 mov     fs:[eax], edx

****** FINALLY
|
006066AA   68D1666000             push    $006066D1
006066AF   8D45AC                 lea     eax, [ebp-$54]
006066B2   BA0F000000             mov     edx, $0000000F

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
006066B7   E8D0E4DFFF             call    00404B8C
006066BC   8D45F0                 lea     eax, [ebp-$10]
006066BF   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
006066C4   E8C3E4DFFF             call    00404B8C
006066C9   C3                     ret


* Reference to: System.@HandleFinally;
|
006066CA   E9FDDDDFFF             jmp     004044CC
006066CF   EBDE                   jmp     006066AF

****** END
|
006066D1   5F                     pop     edi
006066D2   5E                     pop     esi
006066D3   5B                     pop     ebx
006066D4   8BE5                   mov     esp, ebp
006066D6   5D                     pop     ebp
006066D7   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Form1
Global state: GlobalVar_025358F8; GlobalVar_02535B68; GlobalVar_02535B6C; GlobalVar_02535B70;
    GlobalVar_02535B74; GlobalVar_02535B78; GlobalVar_02535B7C; GlobalVar_02535B80;
    GlobalVar_02535B84; GlobalVar_02535B88; GlobalVar_02535B8C; GlobalVar_02535B90
Unresolved field offsets: OFFS_00E8
Project calls: TForm1.Einzelpersonenmarkieren1Click()
Framework/API calls: Controls.TControl.Refresh(TControl);
Strings/files/dialog text: 'Dopp'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.DoppelteEintrge1Click(Sender : TObject);
begin
(*
00606774   53                     push    ebx
00606775   56                     push    esi
00606776   8BF2                   mov     esi, edx
00606778   8BD8                   mov     ebx, eax
0060677A   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B68
|
0060677C   A3685B5302             mov     dword ptr [$02535B68], eax
00606781   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B6C
|
00606783   A36C5B5302             mov     dword ptr [$02535B6C], eax
00606788   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B70
|
0060678A   A3705B5302             mov     dword ptr [$02535B70], eax
0060678F   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B74
|
00606791   A3745B5302             mov     dword ptr [$02535B74], eax
00606796   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B78
|
00606798   A3785B5302             mov     dword ptr [$02535B78], eax
0060679D   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B7C
|
0060679F   A37C5B5302             mov     dword ptr [$02535B7C], eax
006067A4   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B80
|
006067A6   A3805B5302             mov     dword ptr [$02535B80], eax
006067AB   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B84
|
006067AD   A3845B5302             mov     dword ptr [$02535B84], eax
006067B2   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B84
|
006067B4   A3845B5302             mov     dword ptr [$02535B84], eax
006067B9   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B88
|
006067BB   A3885B5302             mov     dword ptr [$02535B88], eax
006067C0   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B8C
|
006067C2   A38C5B5302             mov     dword ptr [$02535B8C], eax
006067C7   33C0                   xor     eax, eax

* Reference to GlobalVar_02535B90
|
006067C9   A3905B5302             mov     dword ptr [$02535B90], eax
006067CE   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Dopp'
|
006067D3   BA14686000             mov     edx, $00606814

* Reference to: System.@LStrAsg(void;void;void;void);
|
006067D8   E8DFE3DFFF             call    00404BBC

* Reference to pointer to GlobalVar_025358F8
|
006067DD   A124C46100             mov     eax, dword ptr [$0061C424]
006067E2   8B00                   mov     eax, [eax]
006067E4   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_025358F8.OFFS_00E8
|
006067E6   FF92E8000000           call    dword ptr [edx+$00E8]

* Reference to Form1
|
006067EC   A108595302             mov     eax, dword ptr [$02535908]

* Reference to: Controls.TControl.Refresh(TControl);
|
006067F1   E89267E4FF             call    0044CF88
006067F6   833D905B530200         cmp     dword ptr [$02535B90], +$00
006067FD   7E09                   jle     00606808
006067FF   8BD6                   mov     edx, esi
00606801   8BC3                   mov     eax, ebx

* Reference to : TForm1.Einzelpersonenmarkieren1Click()
|
00606803   E888E6FFFF             call    00604E90
00606808   5E                     pop     esi
00606809   5B                     pop     ebx
0060680A   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
Project calls: TForm1.Einzelpersonenmarkieren1Click()
Strings/files/dialog text: 'Einz'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Einzelpersonen1Click(Sender : TObject);
begin
(*
0060681C   53                     push    ebx
0060681D   56                     push    esi
0060681E   8BF2                   mov     esi, edx
00606820   8BD8                   mov     ebx, eax
00606822   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Einz'
|
00606827   BA48686000             mov     edx, $00606848

* Reference to: System.@LStrAsg(void;void;void;void);
|
0060682C   E88BE3DFFF             call    00404BBC
00606831   8BD6                   mov     edx, esi
00606833   8BC3                   mov     eax, ebx

* Reference to : TForm1.Einzelpersonenmarkieren1Click()
|
00606835   E856E6FFFF             call    00604E90
0060683A   5E                     pop     esi
0060683B   5B                     pop     ebx
0060683C   C3                     ret

*)
end;

