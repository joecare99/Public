{ TForm1 menu-area implementations: FileRecordBackup; LFM-bound method names remain on TForm1. }

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.ComboBox11 (TComboBox); TForm1.ComboBox12 (TComboBox);
    TForm1.ComboBox13 (TComboBox); TForm1.ComboBox14 (TComboBox); TForm1.ComboBox15 (TComboBox);
    TForm1.ComboBox4 (TComboBox); TForm1.ComboBox6 (TComboBox); TForm1.ComboBox7 (TComboBox);
    TForm1.ComboBox8 (TComboBox); TForm1.ComboBox9 (TComboBox); TForm1.DBCheckBox1 (TDBCheckBox);
    TForm1.Edit1 (TEdit); TForm1.Edit2 (TDBEdit); TForm1.Image1 (TImage); TForm1.Label20 (TLabel);
    TForm1.Label22 (TLabel); TForm1.Label23 (TLabel); TForm1.Label24 (TLabel); TForm1.Label25
    (TLabel); TForm1.Label6 (TLabel); TForm1.Label7 (TLabel); TForm1.PageControl1 (TPageControl);
    TForm1.StringGrid1 (TStringGrid); TForm1.StringGrid2 (TStringGrid); TForm1.TabSheet2 (TTabSheet)
Database/provider: DB.TDataSet.Append(TDataSet);;
    DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_05B4
Project calls: TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; ExtCtrls.TImage.SetPicture(TImage;TPicture);;
    Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);;
    Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);;
    Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);; method
    TDBCheckBox.SetChecked(Boolean); method TMenuItem.Click()
Strings/files/dialog text: rsDSNeu; rsNum
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.neu1Click(Sender : TObject);
begin
(*
005D8C40   53                     push    ebx
005D8C41   56                     push    esi
005D8C42   57                     push    edi
005D8C43   55                     push    ebp
005D8C44   51                     push    ecx
005D8C45   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005D8C47   8B1D3CCC6100           mov     ebx, [$0061CC3C]
005D8C4D   B82C595302             mov     eax, $0253592C

* Possible String Reference to: rsDSNeu
|
005D8C52   BAF08E5D00             mov     edx, $005D8EF0

* Reference to: System.@LStrAsg(void;void;void;void);
|
005D8C57   E860BFE2FF             call    00404BBC
005D8C5C   8B03                   mov     eax, [ebx]
005D8C5E   8B405C                 mov     eax, [eax+$5C]
005D8C61   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D8C63   E8F49EEFFF             call    004D2B5C
005D8C68   8B03                   mov     eax, [ebx]
005D8C6A   8B8080000000           mov     eax, [eax+$0080]

* Possible String Reference to: rsNum
|
005D8C70   BA008F5D00             mov     edx, $005D8F00

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D8C75   E8E29EEFFF             call    004D2B5C

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005D8C7A   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005D8C80   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005D8C86   E82D71EAFF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005D8C8B   8B861C060000           mov     eax, [esi+$061C]
005D8C91   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005D8C93   FF5244                 call    dword ptr [edx+$44]
005D8C96   8BC6                   mov     eax, esi

* Reference to : TForm1.speich1()
|
005D8C98   E8FFECFFFF             call    005D799C
005D8C9D   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox4 : TComboBox
|
005D8C9F   8B8658080000           mov     eax, [esi+$0858]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8CA5   E88A3DE7FF             call    0044CA34
005D8CAA   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox6 : TComboBox
|
005D8CAC   8B865C080000           mov     eax, [esi+$085C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8CB2   E87D3DE7FF             call    0044CA34
005D8CB7   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox7 : TComboBox
|
005D8CB9   8B8660080000           mov     eax, [esi+$0860]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8CBF   E8703DE7FF             call    0044CA34
005D8CC4   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox8 : TComboBox
|
005D8CC6   8B8664080000           mov     eax, [esi+$0864]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8CCC   E8633DE7FF             call    0044CA34
005D8CD1   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox9 : TComboBox
|
005D8CD3   8B8668080000           mov     eax, [esi+$0868]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8CD9   E8563DE7FF             call    0044CA34
005D8CDE   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox11 : TComboBox
|
005D8CE0   8B8670080000           mov     eax, [esi+$0870]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8CE6   E8493DE7FF             call    0044CA34
005D8CEB   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox12 : TComboBox
|
005D8CED   8B8674080000           mov     eax, [esi+$0874]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8CF3   E83C3DE7FF             call    0044CA34
005D8CF8   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox13 : TComboBox
|
005D8CFA   8B8678080000           mov     eax, [esi+$0878]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8D00   E82F3DE7FF             call    0044CA34
005D8D05   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox14 : TComboBox
|
005D8D07   8B867C080000           mov     eax, [esi+$087C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8D0D   E8223DE7FF             call    0044CA34
005D8D12   33D2                   xor     edx, edx

* Reference to control TForm1.ComboBox15 : TComboBox
|
005D8D14   8B8680080000           mov     eax, [esi+$0880]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8D1A   E8153DE7FF             call    0044CA34
005D8D1F   8B03                   mov     eax, [ebx]

* Reference to field TComboBox.AutoSize : Boolean
|
005D8D21   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005D8D24   E8FB69EDFF             call    004AF724
005D8D29   8B03                   mov     eax, [ebx]

* Reference to field Boolean.OFFS_05B4
|
005D8D2B   8B80B4050000           mov     eax, [eax+$05B4]
005D8D31   BA0C8F5D00             mov     edx, $005D8F0C
005D8D36   8B08                   mov     ecx, [eax]
005D8D38   FF91B0000000           call    dword ptr [ecx+$00B0]
005D8D3E   8B03                   mov     eax, [ebx]
005D8D40   8B80A0050000           mov     eax, [eax+$05A0]
005D8D46   33D2                   xor     edx, edx
005D8D48   8B08                   mov     ecx, [eax]
005D8D4A   FF91B0000000           call    dword ptr [ecx+$00B0]
005D8D50   8B03                   mov     eax, [ebx]
005D8D52   8B80A4050000           mov     eax, [eax+$05A4]
005D8D58   33D2                   xor     edx, edx
005D8D5A   8B08                   mov     ecx, [eax]
005D8D5C   FF91B0000000           call    dword ptr [ecx+$00B0]
005D8D62   8B03                   mov     eax, [ebx]
005D8D64   8B80A8050000           mov     eax, [eax+$05A8]
005D8D6A   33D2                   xor     edx, edx
005D8D6C   8B08                   mov     ecx, [eax]
005D8D6E   FF91B0000000           call    dword ptr [ecx+$00B0]
005D8D74   8B03                   mov     eax, [ebx]
005D8D76   8B80AC050000           mov     eax, [eax+$05AC]
005D8D7C   33D2                   xor     edx, edx
005D8D7E   8B08                   mov     ecx, [eax]
005D8D80   FF91B0000000           call    dword ptr [ecx+$00B0]
005D8D86   8B03                   mov     eax, [ebx]
005D8D88   8B80FC050000           mov     eax, [eax+$05FC]
005D8D8E   33D2                   xor     edx, edx
005D8D90   8B08                   mov     ecx, [eax]
005D8D92   FF91B0000000           call    dword ptr [ecx+$00B0]
005D8D98   33D2                   xor     edx, edx

* Reference to control TForm1.DBCheckBox1 : TDBCheckBox
|
005D8D9A   8B862C060000           mov     eax, [esi+$062C]
005D8DA0   8B08                   mov     ecx, [eax]

* Reference to method TDBCheckBox.SetChecked(Boolean)
|
005D8DA2   FF91C8000000           call    dword ptr [ecx+$00C8]
005D8DA8   33D2                   xor     edx, edx

* Reference to control TForm1.Edit1 : TEdit
|
005D8DAA   8B86A8030000           mov     eax, [esi+$03A8]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8DB0   E87F3CE7FF             call    0044CA34
005D8DB5   33D2                   xor     edx, edx

* Reference to control TForm1.Edit2 : TDBEdit
|
005D8DB7   8B86AC030000           mov     eax, [esi+$03AC]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8DBD   E8723CE7FF             call    0044CA34
005D8DC2   33D2                   xor     edx, edx

* Reference to control TForm1.Label22 : TLabel
|
005D8DC4   8B864C040000           mov     eax, [esi+$044C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8DCA   E8653CE7FF             call    0044CA34
005D8DCF   33D2                   xor     edx, edx

* Reference to control TForm1.Label23 : TLabel
|
005D8DD1   8B8650040000           mov     eax, [esi+$0450]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8DD7   E8583CE7FF             call    0044CA34
005D8DDC   33D2                   xor     edx, edx

* Reference to control TForm1.Label24 : TLabel
|
005D8DDE   8B8654040000           mov     eax, [esi+$0454]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8DE4   E84B3CE7FF             call    0044CA34
005D8DE9   33D2                   xor     edx, edx

* Reference to control TForm1.Label25 : TLabel
|
005D8DEB   8B8658040000           mov     eax, [esi+$0458]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8DF1   E83E3CE7FF             call    0044CA34
005D8DF6   33D2                   xor     edx, edx

* Reference to control TForm1.Label6 : TLabel
|
005D8DF8   8B8678030000           mov     eax, [esi+$0378]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8DFE   E8313CE7FF             call    0044CA34
005D8E03   33D2                   xor     edx, edx

* Reference to control TForm1.Label7 : TLabel
|
005D8E05   8B867C030000           mov     eax, [esi+$037C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8E0B   E8243CE7FF             call    0044CA34
005D8E10   33D2                   xor     edx, edx

* Reference to control TForm1.Image1 : TImage
|
005D8E12   8B86B8060000           mov     eax, [esi+$06B8]

* Reference to: ExtCtrls.TImage.SetPicture(TImage;TPicture);
|
005D8E18   E8C784E6FF             call    004412E4

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005D8E1D   8B8670030000           mov     eax, [esi+$0370]

* Reference to field TStringGrid.ColCount : Longint
|
005D8E23   8B801C020000           mov     eax, [eax+$021C]
005D8E29   85C0                   test    eax, eax
005D8E2B   7C34                   jl      005D8E61
005D8E2D   40                     inc     eax
005D8E2E   890424                 mov     [esp], eax
005D8E31   33ED                   xor     ebp, ebp

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005D8E33   8B8670030000           mov     eax, [esi+$0370]

* Reference to field TStringGrid.RowCount : Longint
|
005D8E39   8B984C020000           mov     ebx, [eax+$024C]
005D8E3F   85DB                   test    ebx, ebx
005D8E41   7C18                   jl      005D8E5B
005D8E43   43                     inc     ebx
005D8E44   33FF                   xor     edi, edi
005D8E46   6A00                   push    $00
005D8E48   8BCF                   mov     ecx, edi
005D8E4A   8BD5                   mov     edx, ebp

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005D8E4C   8B8670030000           mov     eax, [esi+$0370]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005D8E52   E8A56CF0FF             call    004DFAFC
005D8E57   47                     inc     edi
005D8E58   4B                     dec     ebx
005D8E59   75EB                   jnz     005D8E46
005D8E5B   45                     inc     ebp
005D8E5C   FF0C24                 dec     dword ptr [esp]
005D8E5F   75D2                   jnz     005D8E33
005D8E61   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid1 : TStringGrid
|
005D8E66   8B8670030000           mov     eax, [esi+$0370]

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
005D8E6C   E85F4AF0FF             call    004DD8D0

* Reference to control TForm1.StringGrid2 : TStringGrid
|
005D8E71   8B8674030000           mov     eax, [esi+$0374]

* Reference to field TStringGrid.ColCount : Longint
|
005D8E77   8B801C020000           mov     eax, [eax+$021C]
005D8E7D   85C0                   test    eax, eax
005D8E7F   7C34                   jl      005D8EB5
005D8E81   40                     inc     eax
005D8E82   890424                 mov     [esp], eax
005D8E85   33ED                   xor     ebp, ebp

* Reference to control TForm1.StringGrid2 : TStringGrid
|
005D8E87   8B8674030000           mov     eax, [esi+$0374]

* Reference to field TStringGrid.RowCount : Longint
|
005D8E8D   8B984C020000           mov     ebx, [eax+$024C]
005D8E93   85DB                   test    ebx, ebx
005D8E95   7C18                   jl      005D8EAF
005D8E97   43                     inc     ebx
005D8E98   33FF                   xor     edi, edi
005D8E9A   6A00                   push    $00
005D8E9C   8BCF                   mov     ecx, edi
005D8E9E   8BD5                   mov     edx, ebp

* Reference to control TForm1.StringGrid2 : TStringGrid
|
005D8EA0   8B8674030000           mov     eax, [esi+$0374]

* Reference to: Grids.TStringGrid.SetCells(TStringGrid;Integer;Integer;AnsiString);
|
005D8EA6   E8516CF0FF             call    004DFAFC
005D8EAB   47                     inc     edi
005D8EAC   4B                     dec     ebx
005D8EAD   75EB                   jnz     005D8E9A
005D8EAF   45                     inc     ebp
005D8EB0   FF0C24                 dec     dword ptr [esp]
005D8EB3   75D2                   jnz     005D8E87
005D8EB5   BA01000000             mov     edx, $00000001

* Reference to control TForm1.StringGrid2 : TStringGrid
|
005D8EBA   8B8674030000           mov     eax, [esi+$0374]

* Reference to: Grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
005D8EC0   E80B4AF0FF             call    004DD8D0
005D8EC5   33D2                   xor     edx, edx

* Reference to control TForm1.Label20 : TLabel
|
005D8EC7   8B861C040000           mov     eax, [esi+$041C]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005D8ECD   E8623BE7FF             call    0044CA34

* Reference to control TForm1.ComboBox4 : TComboBox
|
005D8ED2   8B9658080000           mov     edx, [esi+$0858]
005D8ED8   8BC6                   mov     eax, esi

* Reference to: Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);
|
005D8EDA   E811EFE8FF             call    00467DF0
005D8EDF   5A                     pop     edx
005D8EE0   5D                     pop     ebp
005D8EE1   5F                     pop     edi
005D8EE2   5E                     pop     esi
005D8EE3   5B                     pop     ebx
005D8EE4   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.Label50 (TLabel); TForm1.PageControl1 (TPageControl);
    TForm1.TabSheet2 (TTabSheet)
Database/provider: DB.TDataSet.Append(TDataSet);; DB.TDataSet.Delete(TDataSet);;
    DB.TDataSet.Edit(TDataSet);; DB.TDataSet.First(TDataSet);; DB.TDataSet.Open(TDataSet);;
    DB.TDataSet.Refresh(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;;
    DBTables.TTable.SetDataSource(TTable;TDataSource);
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_009C; OFFS_0548
Project calls: TForm1.anzeigen(); TForm1.speich1(); Unit_00408494.Proc_004091D8
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Dialogs.Proc_004456EC; method TLabel.GetFloatingDockSiteClass(); method TMenuItem.Click()
Strings/files/dialog text: '_^[��]�'; 'ep'; '骱����_^[��]�'; rsDatensatzLoeschen; rsMutter; rsNum;
    rsVater
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.schen1Click(Sender : TObject);
begin
(*
005D8F10   55                     push    ebp
005D8F11   8BEC                   mov     ebp, esp
005D8F13   81C4ECFEFFFF           add     esp, $FFFFFEEC
005D8F19   53                     push    ebx
005D8F1A   56                     push    esi
005D8F1B   57                     push    edi
005D8F1C   33C9                   xor     ecx, ecx
005D8F1E   898DF8FEFFFF           mov     [ebp+$FFFFFEF8], ecx
005D8F24   898DF4FEFFFF           mov     [ebp+$FFFFFEF4], ecx
005D8F2A   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005D8F2C   8B1D3CCC6100           mov     ebx, [$0061CC3C]
005D8F32   33C0                   xor     eax, eax
005D8F34   55                     push    ebp

* Possible String Reference to: '骱����_^[��]�'
|
005D8F35   681D935D00             push    $005D931D

***** TRY
|
005D8F3A   64FF30                 push    dword ptr fs:[eax]
005D8F3D   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005D8F40   8B9640030000           mov     edx, [esi+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005D8F46   8B8638030000           mov     eax, [esi+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005D8F4C   E8676EEAFF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005D8F51   8B861C060000           mov     eax, [esi+$061C]
005D8F57   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005D8F59   FF5244                 call    dword ptr [edx+$44]
005D8F5C   8BC6                   mov     eax, esi

* Reference to : TForm1.speich1()
|
005D8F5E   E839EAFFFF             call    005D799C
005D8F63   8B03                   mov     eax, [ebx]

* Reference to control TForm1.Label50 : TLabel
|
005D8F65   8B8034050000           mov     eax, [eax+$0534]
005D8F6B   8B10                   mov     edx, [eax]

* Reference to method TLabel.GetFloatingDockSiteClass()
|
005D8F6D   FF5258                 call    dword ptr [edx+$58]
005D8F70   8BF8                   mov     edi, eax
005D8F72   8D95F4FEFFFF           lea     edx, [ebp+$FFFFFEF4]
005D8F78   8B03                   mov     eax, [ebx]

* Reference to field TLabel.OFFS_0548
|
005D8F7A   8B8048050000           mov     eax, [eax+$0548]
005D8F80   8B08                   mov     ecx, [eax]
005D8F82   FF5160                 call    dword ptr [ecx+$60]
005D8F85   8B85F4FEFFFF           mov     eax, [ebp+$FFFFFEF4]
005D8F8B   8D95F8FEFFFF           lea     edx, [ebp+$FFFFFEF8]

* Reference to: Unit_00408494.Proc_004091D8
|
005D8F91   E84202E3FF             call    004091D8
005D8F96   8B95F8FEFFFF           mov     edx, [ebp+$FFFFFEF8]
005D8F9C   8D85FCFEFFFF           lea     eax, [ebp+$FFFFFEFC]
005D8FA2   B9FF000000             mov     ecx, $000000FF

* Reference to: System.@LStrToString;
|
005D8FA7   E850BEE2FF             call    00404DFC
005D8FAC   8D95FCFEFFFF           lea     edx, [ebp+$FFFFFEFC]
005D8FB2   8D45FE                 lea     eax, [ebp-$02]
005D8FB5   B101                   mov     cl, $01

* Reference to: System.@PStrNCpy(PShortString;PShortString;Byte);
|
005D8FB7   E8E4A1E2FF             call    004031A0
005D8FBC   6A00                   push    $00
005D8FBE   668B0D2C935D00         mov     cx, word ptr [$005D932C]
005D8FC5   B203                   mov     dl, $03

* Possible String Reference to: rsDatensatzLoeschen
|
005D8FC7   B838935D00             mov     eax, $005D9338

* Reference to: Dialogs.Proc_004456EC
|
005D8FCC   E81BC7E6FF             call    004456EC
005D8FD1   83F806                 cmp     eax, +$06
005D8FD4   0F85D7020000           jnz     005D92B1
005D8FDA   8B03                   mov     eax, [ebx]
005D8FDC   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.First(TDataSet);
|
005D8FE2   E8ED61EDFF             call    004AF1D4
005D8FE7   EB05                   jmp     005D8FEE

* Reference to: DB.TDataSet.Delete(TDataSet);
|
005D8FE9   E82A69EDFF             call    004AF918
005D8FEE   8B03                   mov     eax, [ebx]
005D8FF0   8B8080000000           mov     eax, [eax+$0080]
005D8FF6   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005D8FFD   74EA                   jz      005D8FE9
005D8FFF   8B03                   mov     eax, [ebx]
005D9001   8B8080000000           mov     eax, [eax+$0080]
005D9007   33D2                   xor     edx, edx

* Reference to: DBTables.TTable.SetDataSource(TTable;TDataSource);
|
005D9009   E89AA8EFFF             call    004D38A8
005D900E   8B03                   mov     eax, [ebx]
005D9010   8B8080000000           mov     eax, [eax+$0080]

* Possible String Reference to: 'ep'
|
005D9016   BA54935D00             mov     edx, $005D9354

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D901B   E83C9BEFFF             call    004D2B5C
005D9020   8B03                   mov     eax, [ebx]
005D9022   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.First(TDataSet);
|
005D9028   E8A761EDFF             call    004AF1D4
005D902D   8B03                   mov     eax, [ebx]
005D902F   8B8034050000           mov     eax, [eax+$0534]
005D9035   8B10                   mov     edx, [eax]
005D9037   FF5258                 call    dword ptr [edx+$58]
005D903A   8985ECFEFFFF           mov     [ebp+$FFFFFEEC], eax
005D9040   C685F0FEFFFF00         mov     byte ptr [ebp+$FFFFFEF0], $00
005D9047   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]
005D904D   8B03                   mov     eax, [ebx]
005D904F   8B8080000000           mov     eax, [eax+$0080]
005D9055   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005D9057   E808A2EFFF             call    004D3264
005D905C   84C0                   test    al, al
005D905E   742F                   jz      005D908F
005D9060   EB0D                   jmp     005D906F
005D9062   8B03                   mov     eax, [ebx]
005D9064   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Delete(TDataSet);
|
005D906A   E8A968EDFF             call    004AF918
005D906F   8B03                   mov     eax, [ebx]
005D9071   8B8014040000           mov     eax, [eax+$0414]
005D9077   8B10                   mov     edx, [eax]
005D9079   FF5258                 call    dword ptr [edx+$58]
005D907C   50                     push    eax
005D907D   8B03                   mov     eax, [ebx]
005D907F   8B8034050000           mov     eax, [eax+$0534]
005D9085   8B10                   mov     edx, [eax]
005D9087   FF5258                 call    dword ptr [edx+$58]
005D908A   5A                     pop     edx
005D908B   3BD0                   cmp     edx, eax
005D908D   74D3                   jz      005D9062
005D908F   8B03                   mov     eax, [ebx]
005D9091   8B8080000000           mov     eax, [eax+$0080]

* Possible String Reference to: rsNum
|
005D9097   BA60935D00             mov     edx, $005D9360

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D909C   E8BB9AEFFF             call    004D2B5C
005D90A1   8B03                   mov     eax, [ebx]
005D90A3   8B5058                 mov     edx, [eax+$58]
005D90A6   8B03                   mov     eax, [ebx]
005D90A8   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DBTables.TTable.SetDataSource(TTable;TDataSource);
|
005D90AE   E8F5A7EFFF             call    004D38A8
005D90B3   8D45FE                 lea     eax, [ebp-$02]
005D90B6   BA64935D00             mov     edx, $005D9364
005D90BB   33C9                   xor     ecx, ecx
005D90BD   8A08                   mov     cl, byte ptr [eax]
005D90BF   41                     inc     ecx

* Reference to: System.@AStrCmp;
|
005D90C0   E87BA1E2FF             call    00403240
005D90C5   0F85AD000000           jnz     005D9178
005D90CB   8B03                   mov     eax, [ebx]
005D90CD   8B405C                 mov     eax, [eax+$5C]

* Possible String Reference to: rsVater
|
005D90D0   BA70935D00             mov     edx, $005D9370

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D90D5   E8829AEFFF             call    004D2B5C
005D90DA   8B03                   mov     eax, [ebx]
005D90DC   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005D90DF   E8F060EDFF             call    004AF1D4
005D90E4   89BDECFEFFFF           mov     [ebp+$FFFFFEEC], edi
005D90EA   C685F0FEFFFF00         mov     byte ptr [ebp+$FFFFFEF0], $00
005D90F1   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]
005D90F7   8B03                   mov     eax, [ebx]
005D90F9   8B405C                 mov     eax, [eax+$5C]
005D90FC   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005D90FE   E861A1EFFF             call    004D3264
005D9103   84C0                   test    al, al
005D9105   0F8421010000           jz      005D922C
005D910B   EB55                   jmp     005D9162
005D910D   8B03                   mov     eax, [ebx]
005D910F   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
005D9112   E8C964EDFF             call    004AF5E0
005D9117   8B03                   mov     eax, [ebx]
005D9119   8B8038050000           mov     eax, [eax+$0538]
005D911F   33D2                   xor     edx, edx
005D9121   8B08                   mov     ecx, [eax]
005D9123   FF91A8000000           call    dword ptr [ecx+$00A8]
005D9129   89BDECFEFFFF           mov     [ebp+$FFFFFEEC], edi
005D912F   C685F0FEFFFF00         mov     byte ptr [ebp+$FFFFFEF0], $00
005D9136   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]
005D913C   8B03                   mov     eax, [ebx]
005D913E   8B405C                 mov     eax, [eax+$5C]
005D9141   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005D9143   E81CA1EFFF             call    004D3264
005D9148   84C0                   test    al, al
005D914A   0F84DC000000           jz      005D922C
005D9150   8B03                   mov     eax, [ebx]
005D9152   8B405C                 mov     eax, [eax+$5C]
005D9155   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005D915C   0F85CA000000           jnz     005D922C
005D9162   8B03                   mov     eax, [ebx]
005D9164   8B8038050000           mov     eax, [eax+$0538]
005D916A   8B10                   mov     edx, [eax]
005D916C   FF5258                 call    dword ptr [edx+$58]
005D916F   3BF8                   cmp     edi, eax
005D9171   749A                   jz      005D910D
005D9173   E9B4000000             jmp     005D922C
005D9178   8D45FE                 lea     eax, [ebp-$02]
005D917B   BA74935D00             mov     edx, $005D9374
005D9180   33C9                   xor     ecx, ecx
005D9182   8A08                   mov     cl, byte ptr [eax]
005D9184   41                     inc     ecx

* Reference to: System.@AStrCmp;
|
005D9185   E8B6A0E2FF             call    00403240
005D918A   0F859C000000           jnz     005D922C
005D9190   8B03                   mov     eax, [ebx]
005D9192   8B405C                 mov     eax, [eax+$5C]

* Possible String Reference to: rsMutter
|
005D9195   BA80935D00             mov     edx, $005D9380

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D919A   E8BD99EFFF             call    004D2B5C
005D919F   8B03                   mov     eax, [ebx]
005D91A1   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005D91A4   E82B60EDFF             call    004AF1D4
005D91A9   89BDECFEFFFF           mov     [ebp+$FFFFFEEC], edi
005D91AF   C685F0FEFFFF00         mov     byte ptr [ebp+$FFFFFEF0], $00
005D91B6   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]
005D91BC   8B03                   mov     eax, [ebx]
005D91BE   8B405C                 mov     eax, [eax+$5C]
005D91C1   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005D91C3   E89CA0EFFF             call    004D3264
005D91C8   84C0                   test    al, al
005D91CA   7460                   jz      005D922C
005D91CC   EB4D                   jmp     005D921B
005D91CE   8B03                   mov     eax, [ebx]
005D91D0   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
005D91D3   E80864EDFF             call    004AF5E0
005D91D8   8B03                   mov     eax, [ebx]
005D91DA   8B803C050000           mov     eax, [eax+$053C]
005D91E0   33D2                   xor     edx, edx
005D91E2   8B08                   mov     ecx, [eax]
005D91E4   FF91A8000000           call    dword ptr [ecx+$00A8]
005D91EA   89BDECFEFFFF           mov     [ebp+$FFFFFEEC], edi
005D91F0   C685F0FEFFFF00         mov     byte ptr [ebp+$FFFFFEF0], $00
005D91F7   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]
005D91FD   8B03                   mov     eax, [ebx]
005D91FF   8B405C                 mov     eax, [eax+$5C]
005D9202   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005D9204   E85BA0EFFF             call    004D3264
005D9209   84C0                   test    al, al
005D920B   741F                   jz      005D922C
005D920D   8B03                   mov     eax, [ebx]
005D920F   8B405C                 mov     eax, [eax+$5C]
005D9212   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005D9219   7511                   jnz     005D922C
005D921B   8B03                   mov     eax, [ebx]
005D921D   8B803C050000           mov     eax, [eax+$053C]
005D9223   8B10                   mov     edx, [eax]
005D9225   FF5258                 call    dword ptr [edx+$58]
005D9228   3BF8                   cmp     edi, eax
005D922A   74A2                   jz      005D91CE
005D922C   8B03                   mov     eax, [ebx]
005D922E   8B405C                 mov     eax, [eax+$5C]
005D9231   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005D9233   E82499EFFF             call    004D2B5C
005D9238   89BDECFEFFFF           mov     [ebp+$FFFFFEEC], edi
005D923E   C685F0FEFFFF00         mov     byte ptr [ebp+$FFFFFEF0], $00
005D9245   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]
005D924B   8B03                   mov     eax, [ebx]
005D924D   8B4074                 mov     eax, [eax+$74]
005D9250   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005D9252   E80DA0EFFF             call    004D3264
005D9257   84C0                   test    al, al
005D9259   7526                   jnz     005D9281
005D925B   8B03                   mov     eax, [ebx]
005D925D   8B4074                 mov     eax, [eax+$74]

* Reference to: DB.TDataSet.Append(TDataSet);
|
005D9260   E8BF64EDFF             call    004AF724
005D9265   8B03                   mov     eax, [ebx]
005D9267   8B4078                 mov     eax, [eax+$78]
005D926A   8BD7                   mov     edx, edi
005D926C   8B08                   mov     ecx, [eax]
005D926E   FF91A8000000           call    dword ptr [ecx+$00A8]
005D9274   8B03                   mov     eax, [ebx]
005D9276   8B4074                 mov     eax, [eax+$74]
005D9279   8B10                   mov     edx, [eax]
005D927B   FF9248020000           call    dword ptr [edx+$0248]
005D9281   89BDECFEFFFF           mov     [ebp+$FFFFFEEC], edi
005D9287   C685F0FEFFFF00         mov     byte ptr [ebp+$FFFFFEF0], $00
005D928E   8D95ECFEFFFF           lea     edx, [ebp+$FFFFFEEC]
005D9294   8B03                   mov     eax, [ebx]
005D9296   8B405C                 mov     eax, [eax+$5C]
005D9299   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005D929B   E8C49FEFFF             call    004D3264
005D92A0   8B03                   mov     eax, [ebx]
005D92A2   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Delete(TDataSet);
|
005D92A5   E86E66EDFF             call    004AF918
005D92AA   8BC6                   mov     eax, esi

* Reference to : TForm1.anzeigen()
|
005D92AC   E8EBB0FFFF             call    005D439C
005D92B1   8B03                   mov     eax, [ebx]

* Reference to field TForm1.DockOrientation : TDockOrientation
|
005D92B3   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005D92B9   E8CA39EDFF             call    004ACC88
005D92BE   8B03                   mov     eax, [ebx]

* Reference to field TDockOrientation.OFFS_009C
|
005D92C0   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Refresh(TDataSet);
|
005D92C6   E85562EDFF             call    004AF520
005D92CB   8B03                   mov     eax, [ebx]
005D92CD   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005D92D3   E8B039EDFF             call    004ACC88
005D92D8   8B03                   mov     eax, [ebx]
005D92DA   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Refresh(TDataSet);
|
005D92E0   E83B62EDFF             call    004AF520
005D92E5   8B03                   mov     eax, [ebx]
005D92E7   8B803C010000           mov     eax, [eax+$013C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005D92ED   E89639EDFF             call    004ACC88
005D92F2   8B03                   mov     eax, [ebx]
005D92F4   8B803C010000           mov     eax, [eax+$013C]

* Reference to: DB.TDataSet.Refresh(TDataSet);
|
005D92FA   E82162EDFF             call    004AF520
005D92FF   33C0                   xor     eax, eax
005D9301   5A                     pop     edx
005D9302   59                     pop     ecx
005D9303   59                     pop     ecx
005D9304   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005D9307   6824935D00             push    $005D9324
005D930C   8D85F4FEFFFF           lea     eax, [ebp+$FFFFFEF4]
005D9312   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005D9317   E870B8E2FF             call    00404B8C
005D931C   C3                     ret


* Reference to: System.@HandleFinally;
|
005D931D   E9AAB1E2FF             jmp     004044CC
005D9322   EBE8                   jmp     005D930C

****** END
|
005D9324   5F                     pop     edi
005D9325   5E                     pop     esi
005D9326   5B                     pop     ebx
005D9327   8BE5                   mov     esp, ebp
005D9329   5D                     pop     ebp
005D932A   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.neu1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Last(TDataSet);
Global state: GlobalVar_0061DF08; GlobalVar_0253590C; GlobalVar_02535944
Unresolved field offsets: OFFS_005C; OFFS_0534
Project calls: TForm1.anzeigen(); TForm1.Sikoein()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Menus.TMenuItem.SetEnabled(TMenuItem;Boolean);
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.SicherungsDateieinlesen1Click(Sender : TObject);
begin
(*
005E1E0C   53                     push    ebx
005E1E0D   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005E1E0F   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005E1E15   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005E1E1B   E898DFE9FF             call    0047FDB8
005E1E20   8BC3                   mov     eax, ebx

* Reference to : TForm1.Sikoein()
|
005E1E22   E8A5D8FFFF             call    005DF6CC

* Reference to pointer to GlobalVar_0061DF08
|
005E1E27   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E1E2C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E1E2E   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Last(TDataSet);
|
005E1E31   E876D4ECFF             call    004AF2AC

* Reference to pointer to GlobalVar_0061DF08
|
005E1E36   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E1E3B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005E1E3D   8B8034050000           mov     eax, [eax+$0534]
005E1E43   8B10                   mov     edx, [eax]
005E1E45   FF5258                 call    dword ptr [edx+$58]
005E1E48   40                     inc     eax

* Reference to GlobalVar_0253590C
|
005E1E49   A30C595302             mov     dword ptr [$0253590C], eax

* Reference to pointer to GlobalVar_0061DF08
|
005E1E4E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E1E53   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005E1E55   8B8034050000           mov     eax, [eax+$0534]
005E1E5B   8B10                   mov     edx, [eax]
005E1E5D   FF5258                 call    dword ptr [edx+$58]

* Reference to GlobalVar_02535944
|
005E1E60   A344595302             mov     dword ptr [$02535944], eax

* Reference to pointer to GlobalVar_0061DF08
|
005E1E65   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E1E6A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E1E6C   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005E1E6F   E860D3ECFF             call    004AF1D4

* Reference to pointer to GlobalVar_0061DF08
|
005E1E74   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E1E79   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005E1E7B   8B8034050000           mov     eax, [eax+$0534]
005E1E81   8B10                   mov     edx, [eax]
005E1E83   FF5258                 call    dword ptr [edx+$58]
005E1E86   85C0                   test    eax, eax
005E1E88   7E0D                   jle     005E1E97
005E1E8A   B201                   mov     dl, $01

* Reference to control TForm1.neu1 : TMenuItem
|
005E1E8C   8B83FC020000           mov     eax, [ebx+$02FC]

* Reference to: Menus.TMenuItem.SetEnabled(TMenuItem;Boolean);
|
005E1E92   E839C9E7FF             call    0045E7D0
005E1E97   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005E1E99   E8FE24FFFF             call    005D439C
005E1E9E   5B                     pop     ebx
005E1E9F   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.DBEdit2 (TDBEdit); TForm1.PageControl1 (TPageControl);
    TForm1.TabSheet2 (TTabSheet); Form1
Project calls: TForm1.datsich()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);; method TMenuItem.Click()
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Datensichern1Click(Sender : TObject);
begin
(*
005E1EA0   53                     push    ebx
005E1EA1   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005E1EA3   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005E1EA9   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005E1EAF   E804DFE9FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005E1EB4   8B831C060000           mov     eax, [ebx+$061C]
005E1EBA   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005E1EBC   FF5244                 call    dword ptr [edx+$44]
005E1EBF   8BC3                   mov     eax, ebx

* Reference to : TForm1.datsich()
|
005E1EC1   E86EAFFFFF             call    005DCE34

* Reference to control TForm1.DBEdit2 : TDBEdit
|
005E1EC6   8B9364030000           mov     edx, [ebx+$0364]

* Reference to Form1
|
005E1ECC   A108595302             mov     eax, dword ptr [$02535908]

* Reference to: Forms.TCustomForm.SetActiveControl(TCustomForm;TWinControl);
|
005E1ED1   E81A5FE8FF             call    00467DF0
005E1ED6   5B                     pop     ebx
005E1ED7   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Label2 (TLabel); Label4 (TLabel); TForm1.aus1 (TMenuItem); TForm1.Label19 (TLabel);
    TForm1.neu1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.schen1 (TMenuItem);
    TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.Close(TDataSet);; DB.TDataSet.Edit(TDataSet);;
    DB.TDataSet.Open(TDataSet);; DBTables.TTable.EmptyTable(TTable);
Global state: GlobalVar_0061DF08; GlobalVar_0061DFB4; GlobalVar_0061E0E8; GlobalVar_02535398;
    GlobalVar_025353B0; GlobalVar_025353C8; GlobalVar_02535944
Unresolved field offsets: OFFS_005C; OFFS_0060; OFFS_006C; OFFS_0074; OFFS_0080; OFFS_0088;
    OFFS_0090; OFFS_0098; OFFS_009C; OFFS_00A4; OFFS_00C8; OFFS_00CC; OFFS_00D4; OFFS_00E0;
    OFFS_00E8; OFFS_0158; OFFS_01DC; OFFS_01E0; OFFS_0248; OFFS_02A4; OFFS_02B8; OFFS_0380;
    OFFS_0530
Project calls: TForm1.bild_entf(); TForm1.listen_akt()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Controls.TControl.SetVisible(TControl;Boolean);;
    Controls.TControl.Show(TControl);; Dialogs.Proc_004456EC; Dialogs.ShowMessage(AnsiString);;
    Forms.TScreen.SetCursor(TScreen;TCursor);; Menus.TMenuItem.SetEnabled(TMenuItem;Boolean);;
    method TMenuItem.Click(); QControls.TGraphicControl.PaintRequest(TGraphicControl);; TScreen
    instance
Strings/files/dialog text: 'Daten l�schen ...'; 'Keine Daten verf�gbar.'; 'sikoein'; 'Wirklich alle
    Datens�tze l�schen ?'; 'Y]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Datenlschen1Click(Sender : TObject);
begin
(*
005E2144   55                     push    ebp
005E2145   8BEC                   mov     ebp, esp
005E2147   51                     push    ecx
005E2148   8945FC                 mov     [ebp-$04], eax

* Reference to Form1
|
005E214B   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005E214E   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005E2154   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005E2157   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005E215D   E856DCE9FF             call    0047FDB8

* Reference to Form1
|
005E2162   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.aus1 : TMenuItem
|
005E2165   8B801C060000           mov     eax, [eax+$061C]
005E216B   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005E216D   FF5244                 call    dword ptr [edx+$44]
005E2170   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'sikoein'
|
005E2175   BA18295E00             mov     edx, $005E2918

* Reference to: System.@LStrCmp;
|
005E217A   E8E52DE2FF             call    00404F64
005E217F   7422                   jz      005E21A3

* Reference to pointer to GlobalVar_0061DF08
|
005E2181   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2186   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E2188   8B405C                 mov     eax, [eax+$5C]
005E218B   8B10                   mov     edx, [eax]
005E218D   FF924C010000           call    dword ptr [edx+$014C]
005E2193   48                     dec     eax
005E2194   7D0D                   jnl     005E21A3

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005E2196   B828295E00             mov     eax, $005E2928

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005E219B   E84436E6FF             call    004457E4
005E21A0   59                     pop     ecx
005E21A1   5D                     pop     ebp
005E21A2   C3                     ret

005E21A3   A12C595302             mov     eax, dword ptr [$0253592C]

* Possible String Reference to: 'sikoein'
|
005E21A8   BA18295E00             mov     edx, $005E2918

* Reference to: System.@LStrCmp;
|
005E21AD   E8B22DE2FF             call    00404F64
005E21B2   741E                   jz      005E21D2
005E21B4   6A00                   push    $00
005E21B6   668B0D40295E00         mov     cx, word ptr [$005E2940]
005E21BD   B203                   mov     dl, $03

* Possible String Reference to: 'Wirklich alle Datens�tze l�schen ?'
|
005E21BF   B84C295E00             mov     eax, $005E294C

* Reference to: Dialogs.Proc_004456EC
|
005E21C4   E82335E6FF             call    004456EC
005E21C9   83F806                 cmp     eax, +$06
005E21CC   0F85E2060000           jnz     005E28B4
005E21D2   33C0                   xor     eax, eax
005E21D4   55                     push    ebp
005E21D5   68AD285E00             push    $005E28AD

***** TRY
|
005E21DA   64FF30                 push    dword ptr fs:[eax]
005E21DD   648920                 mov     fs:[eax], esp

* Reference to TScreen instance
|
005E21E0   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005E21E5   8B00                   mov     eax, [eax]
005E21E7   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005E21EB   E8AC8FE8FF             call    0046B19C

* Reference to Form1
|
005E21F0   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.bild_entf()
|
005E21F3   E8009A0100             call    005FBBF8

* Reference to Form1
|
005E21F8   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005E21FB   8B8004040000           mov     eax, [eax+$0404]

* Possible String Reference to: 'Daten l�schen ...'
|
005E2201   BA78295E00             mov     edx, $005E2978

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E2206   E829A8E6FF             call    0044CA34

* Reference to Form1
|
005E220B   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005E220E   8B8004040000           mov     eax, [eax+$0404]

* Reference to: Controls.TControl.Show(TControl);
|
005E2214   E82BADE6FF             call    0044CF44

* Reference to Form1
|
005E2219   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005E221C   8B8004040000           mov     eax, [eax+$0404]

* Reference to: QControls.TGraphicControl.PaintRequest(TGraphicControl);
|
005E2222   E861ADE6FF             call    0044CF88

* Reference to pointer to GlobalVar_0061DFB4
|
005E2227   A1C8C26100             mov     eax, dword ptr [$0061C2C8]
005E222C   8B00                   mov     eax, [eax]

* Reference to control Label4 : TLabel
|
005E222E   8B8000030000           mov     eax, [eax+$0300]
005E2234   8B10                   mov     edx, [eax]

* Possible reference to virtual method TLabel.OFFS_00D4
|
005E2236   FF92D4000000           call    dword ptr [edx+$00D4]

* Reference to pointer to GlobalVar_02535398
|
005E223C   A120C26100             mov     eax, dword ptr [$0061C220]
005E2241   8B00                   mov     eax, [eax]

* Reference to control Label4 : TLabel
|
005E2243   8B8000030000           mov     eax, [eax+$0300]
005E2249   8B10                   mov     edx, [eax]

* Possible reference to virtual method TLabel.OFFS_00D4
|
005E224B   FF92D4000000           call    dword ptr [edx+$00D4]

* Reference to pointer to GlobalVar_0061E0E8
|
005E2251   A1CCC76100             mov     eax, dword ptr [$0061C7CC]
005E2256   8B00                   mov     eax, [eax]

* Reference to control Label2 : TLabel
|
005E2258   8B80F8020000           mov     eax, [eax+$02F8]
005E225E   8B10                   mov     edx, [eax]

* Possible reference to virtual method TLabel.OFFS_00D4
|
005E2260   FF92D4000000           call    dword ptr [edx+$00D4]

* Reference to pointer to GlobalVar_025353B0
|
005E2266   A144C36100             mov     eax, dword ptr [$0061C344]
005E226B   8B00                   mov     eax, [eax]

* Reference to control Label4 : TLabel
|
005E226D   8B8000030000           mov     eax, [eax+$0300]
005E2273   8B10                   mov     edx, [eax]

* Possible reference to virtual method TLabel.OFFS_00D4
|
005E2275   FF92D4000000           call    dword ptr [edx+$00D4]

* Reference to pointer to GlobalVar_025353C8
|
005E227B   A18CC36100             mov     eax, dword ptr [$0061C38C]
005E2280   8B00                   mov     eax, [eax]

* Reference to control Label4 : TLabel
|
005E2282   8B8000030000           mov     eax, [eax+$0300]
005E2288   8B10                   mov     edx, [eax]

* Possible reference to virtual method TLabel.OFFS_00D4
|
005E228A   FF92D4000000           call    dword ptr [edx+$00D4]

* Reference to pointer to GlobalVar_0061DF08
|
005E2290   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2295   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0060
|
005E2297   8B4060                 mov     eax, [eax+$60]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E229A   E8E9A9ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E229F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E22A4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0060
|
005E22A6   8B4060                 mov     eax, [eax+$60]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E22A9   E8E6A9ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E22AE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E22B3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_006C
|
005E22B5   8B406C                 mov     eax, [eax+$6C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E22B8   E8CBA9ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E22BD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E22C2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_006C
|
005E22C4   8B406C                 mov     eax, [eax+$6C]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E22C7   E8C8A9ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E22CC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E22D1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0074
|
005E22D3   8B4074                 mov     eax, [eax+$74]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E22D6   E8ADA9ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E22DB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E22E0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0074
|
005E22E2   8B4074                 mov     eax, [eax+$74]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E22E5   E8AAA9ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E22EA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E22EF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0074
|
005E22F1   8B4074                 mov     eax, [eax+$74]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E22F4   E8E31CEFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E22F9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E22FE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0074
|
005E2300   8B4074                 mov     eax, [eax+$74]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2303   E880A9ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2308   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E230D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0088
|
005E230F   8B8088000000           mov     eax, [eax+$0088]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2315   E86EA9ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E231A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E231F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0088
|
005E2321   8B8088000000           mov     eax, [eax+$0088]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E2327   E868A9ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E232C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2331   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0090
|
005E2333   8B8090000000           mov     eax, [eax+$0090]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2339   E84AA9ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E233E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2343   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0090
|
005E2345   8B8090000000           mov     eax, [eax+$0090]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E234B   E844A9ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E2350   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2355   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0098
|
005E2357   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E235D   E826A9ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2362   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2367   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0098
|
005E2369   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E236F   E820A9ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E2374   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2379   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005E237B   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2381   E802A9ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2386   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E238B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005E238D   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E2393   E8FCA8ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E2398   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E239D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005E239F   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E23A5   E8DEA8ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E23AA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E23AF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005E23B1   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E23B7   E8D8A8ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E23BC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E23C1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005E23C3   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E23C9   E8BAA8ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E23CE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E23D3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005E23D5   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E23DB   E8B4A8ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E23E0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E23E5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005E23E7   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E23ED   E8EA1BEFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E23F2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E23F7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005E23F9   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E23FF   E884A8ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2404   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2409   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0158
|
005E240B   8B8058010000           mov     eax, [eax+$0158]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2411   E872A8ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2416   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E241B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0158
|
005E241D   8B8058010000           mov     eax, [eax+$0158]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E2423   E86CA8ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E2428   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E242D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0158
|
005E242F   8B8058010000           mov     eax, [eax+$0158]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E2435   E8A21BEFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E243A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E243F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0248
|
005E2441   8B8048020000           mov     eax, [eax+$0248]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2447   E83CA8ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E244C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2451   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0248
|
005E2453   8B8048020000           mov     eax, [eax+$0248]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E2459   E836A8ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E245E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2463   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0248
|
005E2465   8B8048020000           mov     eax, [eax+$0248]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E246B   E86C1BEFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E2470   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2475   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0248
|
005E2477   8B8048020000           mov     eax, [eax+$0248]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E247D   E806A8ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2482   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2487   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_02A4
|
005E2489   8B80A4020000           mov     eax, [eax+$02A4]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E248F   E8F4A7ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2494   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2499   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_02A4
|
005E249B   8B80A4020000           mov     eax, [eax+$02A4]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E24A1   E8EEA7ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E24A6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E24AB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_02A4
|
005E24AD   8B80A4020000           mov     eax, [eax+$02A4]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E24B3   E8241BEFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E24B8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E24BD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_02A4
|
005E24BF   8B80A4020000           mov     eax, [eax+$02A4]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E24C5   E8BEA7ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E24CA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E24CF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_02B8
|
005E24D1   8B80B8020000           mov     eax, [eax+$02B8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E24D7   E8ACA7ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E24DC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E24E1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0530
|
005E24E3   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E24E9   E89AA7ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E24EE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E24F3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0530
|
005E24F5   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E24FB   E894A7ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E2500   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2505   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0530
|
005E2507   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E250D   E8CA1AEFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E2512   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2517   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0530
|
005E2519   8B8030050000           mov     eax, [eax+$0530]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E251F   E864A7ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2524   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2529   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005E252B   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2531   E852A7ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2536   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E253B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005E253D   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E2543   E84CA7ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E2548   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E254D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005E254F   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E2555   E8821AEFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E255A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E255F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005E2561   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2567   E81CA7ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E256C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2571   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E2573   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2576   E80DA7ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E257B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2580   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E2582   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E2585   E80AA7ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E258A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E258F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E2591   8B405C                 mov     eax, [eax+$5C]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E2594   E8431AEFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E2599   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E259E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E25A0   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E25A3   E8E0A6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E25A8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E25AD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0060
|
005E25AF   8B4060                 mov     eax, [eax+$60]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E25B2   E8D1A6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E25B7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E25BC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_006C
|
005E25BE   8B406C                 mov     eax, [eax+$6C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E25C1   E8C2A6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E25C6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E25CB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0074
|
005E25CD   8B4074                 mov     eax, [eax+$74]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E25D0   E8B3A6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E25D5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E25DA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0088
|
005E25DC   8B8088000000           mov     eax, [eax+$0088]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E25E2   E8A1A6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E25E7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E25EC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0090
|
005E25EE   8B8090000000           mov     eax, [eax+$0090]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E25F4   E88FA6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E25F9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E25FE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0098
|
005E2600   8B8098000000           mov     eax, [eax+$0098]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2606   E87DA6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E260B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2610   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005E2612   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2618   E86BA6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E261D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2622   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005E2624   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E262A   E859A6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E262F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2634   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
005E2636   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E263C   E847A6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2641   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2646   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
005E2648   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E264E   E841A6ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E2653   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2658   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
005E265A   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E2660   E87719EFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E2665   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E266A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00C8
|
005E266C   8B80C8000000           mov     eax, [eax+$00C8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2672   E811A6ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2677   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E267C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005E267E   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2684   E8FFA5ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2689   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E268E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005E2690   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E2696   E8F9A5ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E269B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E26A0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005E26A2   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E26A8   E82F19EFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E26AD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E26B2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005E26B4   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E26BA   E8C9A5ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E26BF   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E26C4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005E26C6   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E26CC   E8B7A5ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E26D1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E26D6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005E26D8   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E26DE   E8B1A5ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E26E3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E26E8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005E26EA   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E26F0   E8E718EFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E26F5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E26FA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E0
|
005E26FC   8B80E0000000           mov     eax, [eax+$00E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2702   E881A5ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2707   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E270C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005E270E   8B80E8000000           mov     eax, [eax+$00E8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2714   E86FA5ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2719   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E271E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005E2720   8B80E8000000           mov     eax, [eax+$00E8]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E2726   E869A5ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E272B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2730   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005E2732   8B80E8000000           mov     eax, [eax+$00E8]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E2738   E89F18EFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E273D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2742   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00E8
|
005E2744   8B80E8000000           mov     eax, [eax+$00E8]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E274A   E839A5ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E274F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2754   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01DC
|
005E2756   8B80DC010000           mov     eax, [eax+$01DC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E275C   E827A5ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2761   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2766   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01DC
|
005E2768   8B80DC010000           mov     eax, [eax+$01DC]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E276E   E821A5ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E2773   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2778   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01DC
|
005E277A   8B80DC010000           mov     eax, [eax+$01DC]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E2780   E85718EFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E2785   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E278A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01DC
|
005E278C   8B80DC010000           mov     eax, [eax+$01DC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2792   E8F1A4ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E2797   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E279C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01E0
|
005E279E   8B80E0010000           mov     eax, [eax+$01E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E27A4   E8DFA4ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E27A9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E27AE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01E0
|
005E27B0   8B80E0010000           mov     eax, [eax+$01E0]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E27B6   E8D9A4ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E27BB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E27C0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01E0
|
005E27C2   8B80E0010000           mov     eax, [eax+$01E0]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E27C8   E80F18EFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E27CD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E27D2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_01E0
|
005E27D4   8B80E0010000           mov     eax, [eax+$01E0]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E27DA   E8A9A4ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E27DF   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E27E4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0380
|
005E27E6   8B8080030000           mov     eax, [eax+$0380]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E27EC   E897A4ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005E27F1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E27F6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0380
|
005E27F8   8B8080030000           mov     eax, [eax+$0380]

* Reference to: DB.TDataSet.Close(TDataSet);
|
005E27FE   E891A4ECFF             call    004ACC94

* Reference to pointer to GlobalVar_0061DF08
|
005E2803   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2808   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0380
|
005E280A   8B8080030000           mov     eax, [eax+$0380]

* Reference to: DBTables.TTable.EmptyTable(TTable);
|
005E2810   E8C717EFFF             call    004D3FDC

* Reference to pointer to GlobalVar_0061DF08
|
005E2815   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E281A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0380
|
005E281C   8B8080030000           mov     eax, [eax+$0380]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005E2822   E861A4ECFF             call    004ACC88

* Reference to Form1
|
005E2827   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.listen_akt()
|
005E282A   E825D70000             call    005EFF54

* Reference to Form1
|
005E282F   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.neu1 : TMenuItem
|
005E2832   8B80FC020000           mov     eax, [eax+$02FC]
005E2838   33D2                   xor     edx, edx

* Reference to: Menus.TMenuItem.SetEnabled(TMenuItem;Boolean);
|
005E283A   E891BFE7FF             call    0045E7D0

* Reference to Form1
|
005E283F   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.schen1 : TMenuItem
|
005E2842   8B8004030000           mov     eax, [eax+$0304]
005E2848   33D2                   xor     edx, edx

* Reference to: Menus.TMenuItem.SetEnabled(TMenuItem;Boolean);
|
005E284A   E881BFE7FF             call    0045E7D0
005E284F   C7050C59530201000000   mov     dword ptr [$0253590C], $00000001
005E2859   33C0                   xor     eax, eax

* Reference to GlobalVar_02535944
|
005E285B   A344595302             mov     dword ptr [$02535944], eax
005E2860   33C0                   xor     eax, eax
005E2862   5A                     pop     edx
005E2863   59                     pop     ecx
005E2864   59                     pop     ecx
005E2865   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: 'Y]�'
|
005E2868   680A295E00             push    $005E290A

* Reference to TScreen instance
|
005E286D   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005E2872   8B00                   mov     eax, [eax]
005E2874   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005E2876   E82189E8FF             call    0046B19C

* Reference to Form1
|
005E287B   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005E287E   8B8004040000           mov     eax, [eax+$0404]
005E2884   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005E2886   E899A0E6FF             call    0044C924

* Reference to pointer to GlobalVar_0061DF08
|
005E288B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E2890   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E2892   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
005E2895   E846CDECFF             call    004AF5E0

* Reference to pointer to GlobalVar_0061DF08
|
005E289A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E289F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005E28A1   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
005E28A7   E834CDECFF             call    004AF5E0
005E28AC   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.Label18 (TLabel); TForm1.Label19 (TLabel);
    TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.Edit(TDataSet);; DB.TDataSet.First(TDataSet);;
    DB.TDataSet.Next(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_0534; OFFS_05C0
Project calls: TForm1.anzeigen(); TForm1.lab18ein(); TForm1.speich1(); TForm1.tabdisab();
    TForm1.tabenab(); Unit_00408494.Proc_00409448; Unit_00408494.Proc_00409950
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Controls.TControl.SetVisible(TControl;Boolean);;
    Dialogs.Proc_004456EC; Dialogs.ShowMessage(AnsiString);; method TMenuItem.Click();
    QControls.TGraphicControl.PaintRequest(TGraphicControl);; System.Proc_00404EE0
Strings/files/dialog text: '_^[��]�'; 'Bisherige IDs �berschreiben ?'; 'Datensatz-Nr. nach ID
    schreiben ?'; 'IDs erg�nzen '; 'IDs ersetzen '; 'Keine Daten verf�gbar.'; '�������_^[��]�';
    '����������<�a'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.IDSatznr1Click(Sender : TObject);
begin
(*
005E50A4   55                     push    ebp
005E50A5   8BEC                   mov     ebp, esp
005E50A7   B907000000             mov     ecx, $00000007
005E50AC   6A00                   push    $00
005E50AE   6A00                   push    $00
005E50B0   49                     dec     ecx
005E50B1   75F9                   jnz     005E50AC
005E50B3   53                     push    ebx
005E50B4   56                     push    esi
005E50B5   57                     push    edi
005E50B6   8945FC                 mov     [ebp-$04], eax
005E50B9   33C0                   xor     eax, eax
005E50BB   55                     push    ebp

* Possible String Reference to: '�������_^[��]�'
|
005E50BC   68C9535E00             push    $005E53C9

***** TRY
|
005E50C1   64FF30                 push    dword ptr fs:[eax]
005E50C4   648920                 mov     fs:[eax], esp

* Reference to Form1
|
005E50C7   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.speich1()
|
005E50CA   E8CD28FFFF             call    005D799C

* Reference to pointer to GlobalVar_0061DF08
|
005E50CF   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E50D4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E50D6   8B405C                 mov     eax, [eax+$5C]
005E50D9   8B10                   mov     edx, [eax]
005E50DB   FF924C010000           call    dword ptr [edx+$014C]
005E50E1   85C0                   test    eax, eax
005E50E3   750F                   jnz     005E50F4

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005E50E5   B8E0535E00             mov     eax, $005E53E0

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005E50EA   E8F506E6FF             call    004457E4
005E50EF   E9BA020000             jmp     005E53AE

* Reference to Form1
|
005E50F4   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005E50F7   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005E50FD   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005E5100   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005E5106   E8ADACE9FF             call    0047FDB8

* Reference to Form1
|
005E510B   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.aus1 : TMenuItem
|
005E510E   8B801C060000           mov     eax, [eax+$061C]
005E5114   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005E5116   FF5244                 call    dword ptr [edx+$44]
005E5119   C645F300               mov     byte ptr [ebp-$0D], $00
005E511D   6A00                   push    $00
005E511F   668B0DF8535E00         mov     cx, word ptr [$005E53F8]
005E5126   B203                   mov     dl, $03

* Possible String Reference to: 'Datensatz-Nr. nach ID schreiben ?'
|
005E5128   B804545E00             mov     eax, $005E5404

* Reference to: Dialogs.Proc_004456EC
|
005E512D   E8BA05E6FF             call    004456EC
005E5132   83F806                 cmp     eax, +$06
005E5135   0F8573020000           jnz     005E53AE
005E513B   6A00                   push    $00
005E513D   668B0DF8535E00         mov     cx, word ptr [$005E53F8]
005E5144   B203                   mov     dl, $03

* Possible String Reference to: 'Bisherige IDs �berschreiben ?'
|
005E5146   B830545E00             mov     eax, $005E5430

* Reference to: Dialogs.Proc_004456EC
|
005E514B   E89C05E6FF             call    004456EC
005E5150   83F806                 cmp     eax, +$06
005E5153   7504                   jnz     005E5159
005E5155   C645F301               mov     byte ptr [ebp-$0D], $01
005E5159   C745F401000000         mov     dword ptr [ebp-$0C], $00000001
005E5160   807DF300               cmp     byte ptr [ebp-$0D], $00
005E5164   7415                   jz      005E517B

* Reference to Form1
|
005E5166   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005E5169   8B8004040000           mov     eax, [eax+$0404]

* Possible String Reference to: 'IDs ersetzen    '
|
005E516F   BA58545E00             mov     edx, $005E5458

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E5174   E8BB78E6FF             call    0044CA34
005E5179   EB13                   jmp     005E518E

* Reference to Form1
|
005E517B   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005E517E   8B8004040000           mov     eax, [eax+$0404]

* Possible String Reference to: 'IDs erg�nzen    '
|
005E5184   BA74545E00             mov     edx, $005E5474

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E5189   E8A678E6FF             call    0044CA34

* Reference to Form1
|
005E518E   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.lab18ein()
|
005E5191   E84E36FFFF             call    005D87E4

* Reference to pointer to GlobalVar_0061DF08
|
005E5196   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E519B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005E519D   8B8034050000           mov     eax, [eax+$0534]
005E51A3   8B10                   mov     edx, [eax]
005E51A5   FF5258                 call    dword ptr [edx+$58]
005E51A8   8945F8                 mov     [ebp-$08], eax

* Reference to pointer to GlobalVar_0061DF08
|
005E51AB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E51B0   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E51B2   8B405C                 mov     eax, [eax+$5C]
005E51B5   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005E51B7   E8A0D9EEFF             call    004D2B5C

* Reference to Form1
|
005E51BC   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabdisab()
|
005E51BF   E87036FFFF             call    005D8834

* Reference to pointer to GlobalVar_0061DF08
|
005E51C4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E51C9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E51CB   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005E51CE   E801A0ECFF             call    004AF1D4
005E51D3   E971010000             jmp     005E5349
005E51D8   8D55EC                 lea     edx, [ebp-$14]
005E51DB   8B45F4                 mov     eax, [ebp-$0C]

* Reference to: Unit_00408494.Proc_00409950
|
005E51DE   E86D47E2FF             call    00409950
005E51E3   8B55EC                 mov     edx, [ebp-$14]

* Reference to Form1
|
005E51E6   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005E51E9   8B8000040000           mov     eax, [eax+$0400]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E51EF   E84078E6FF             call    0044CA34

* Reference to Form1
|
005E51F4   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005E51F7   8B8000040000           mov     eax, [eax+$0400]

* Reference to: QControls.TGraphicControl.PaintRequest(TGraphicControl);
|
005E51FD   E8867DE6FF             call    0044CF88
005E5202   FF45F4                 inc     dword ptr [ebp-$0C]

* Reference to pointer to GlobalVar_0061DF08
|
005E5205   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E520A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E520C   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
005E520F   E8CCA3ECFF             call    004AF5E0
005E5214   807DF300               cmp     byte ptr [ebp-$0D], $00
005E5218   7437                   jz      005E5251

* Reference to pointer to GlobalVar_0061DF08
|
005E521A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E521F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005E5221   8B8034050000           mov     eax, [eax+$0534]
005E5227   8B10                   mov     edx, [eax]
005E5229   FF5258                 call    dword ptr [edx+$58]
005E522C   8D55E8                 lea     edx, [ebp-$18]

* Reference to: Unit_00408494.Proc_00409950
|
005E522F   E81C47E2FF             call    00409950
005E5234   8B55E8                 mov     edx, [ebp-$18]

* Reference to pointer to GlobalVar_0061DF08
|
005E5237   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E523C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05C0
|
005E523E   8B80C0050000           mov     eax, [eax+$05C0]
005E5244   8B08                   mov     ecx, [eax]
005E5246   FF91B0000000           call    dword ptr [ecx+$00B0]
005E524C   E9B5000000             jmp     005E5306
005E5251   8D55E0                 lea     edx, [ebp-$20]

* Reference to pointer to GlobalVar_0061DF08
|
005E5254   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E5259   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05C0
|
005E525B   8B80C0050000           mov     eax, [eax+$05C0]
005E5261   8B08                   mov     ecx, [eax]
005E5263   FF5160                 call    dword ptr [ecx+$60]
005E5266   8B45E0                 mov     eax, [ebp-$20]
005E5269   8D55E4                 lea     edx, [ebp-$1C]

* Reference to: Unit_00408494.Proc_00409448
|
005E526C   E8D741E2FF             call    00409448
005E5271   837DE400               cmp     dword ptr [ebp-$1C], +$00
005E5275   765D                   jbe     005E52D4
005E5277   8D55D8                 lea     edx, [ebp-$28]

* Reference to pointer to GlobalVar_0061DF08
|
005E527A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E527F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05C0
|
005E5281   8B98C0050000           mov     ebx, [eax+$05C0]
005E5287   8BC3                   mov     eax, ebx
005E5289   8B08                   mov     ecx, [eax]
005E528B   FF5160                 call    dword ptr [ecx+$60]
005E528E   FF75D8                 push    dword ptr [ebp-$28]
005E5291   6890545E00             push    $005E5490

* Reference to pointer to GlobalVar_0061DF08
|
005E5296   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E529B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005E529D   8B8034050000           mov     eax, [eax+$0534]
005E52A3   8B10                   mov     edx, [eax]
005E52A5   FF5258                 call    dword ptr [edx+$58]
005E52A8   8D55D4                 lea     edx, [ebp-$2C]

* Reference to: Unit_00408494.Proc_00409950
|
005E52AB   E8A046E2FF             call    00409950
005E52B0   FF75D4                 push    dword ptr [ebp-$2C]
005E52B3   8D45DC                 lea     eax, [ebp-$24]
005E52B6   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005E52BB   E820FCE1FF             call    00404EE0
005E52C0   8B55DC                 mov     edx, [ebp-$24]

* Reference to pointer to GlobalVar_0061DF08
|
005E52C3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E52C8   8BC3                   mov     eax, ebx
005E52CA   8B08                   mov     ecx, [eax]
005E52CC   FF91B0000000           call    dword ptr [ecx+$00B0]
005E52D2   EB32                   jmp     005E5306

* Reference to pointer to GlobalVar_0061DF08
|
005E52D4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E52D9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005E52DB   8B8034050000           mov     eax, [eax+$0534]
005E52E1   8B10                   mov     edx, [eax]
005E52E3   FF5258                 call    dword ptr [edx+$58]
005E52E6   8D55D0                 lea     edx, [ebp-$30]

* Reference to: Unit_00408494.Proc_00409950
|
005E52E9   E86246E2FF             call    00409950
005E52EE   8B55D0                 mov     edx, [ebp-$30]

* Reference to pointer to GlobalVar_0061DF08
|
005E52F1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E52F6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05C0
|
005E52F8   8B80C0050000           mov     eax, [eax+$05C0]
005E52FE   8B08                   mov     ecx, [eax]
005E5300   FF91B0000000           call    dword ptr [ecx+$00B0]
005E5306   33C0                   xor     eax, eax
005E5308   55                     push    ebp

* Possible String Reference to: '����������<�a'
|
005E5309   6830535E00             push    $005E5330

***** TRY
|
005E530E   64FF30                 push    dword ptr fs:[eax]
005E5311   648920                 mov     fs:[eax], esp

* Reference to pointer to GlobalVar_0061DF08
|
005E5314   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E5319   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E531B   8B405C                 mov     eax, [eax+$5C]
005E531E   8B10                   mov     edx, [eax]
005E5320   FF9248020000           call    dword ptr [edx+$0248]
005E5326   33C0                   xor     eax, eax
005E5328   5A                     pop     edx
005E5329   59                     pop     ecx
005E532A   59                     pop     ecx
005E532B   648910                 mov     fs:[eax], edx
005E532E   EB0A                   jmp     005E533A

* Reference to: System.@HandleAnyException;
|
005E5330   E9E3EEE1FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005E5335   E80AF3E1FF             call    00404644

****** END
|
* Reference to pointer to GlobalVar_0061DF08
|
005E533A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E533F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E5341   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005E5344   E8A3A1ECFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005E5349   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E534E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E5350   8B405C                 mov     eax, [eax+$5C]
005E5353   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005E535A   0F8478FEFFFF           jz      005E51D8

* Reference to Form1
|
005E5360   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005E5363   8B8000040000           mov     eax, [eax+$0400]
005E5369   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005E536B   E8B475E6FF             call    0044C924

* Reference to Form1
|
005E5370   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005E5373   8B8004040000           mov     eax, [eax+$0404]
005E5379   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005E537B   E8A475E6FF             call    0044C924
005E5380   8B45F8                 mov     eax, [ebp-$08]
005E5383   8945C8                 mov     [ebp-$38], eax
005E5386   C645CC00               mov     byte ptr [ebp-$34], $00
005E538A   8D55C8                 lea     edx, [ebp-$38]

* Reference to pointer to GlobalVar_0061DF08
|
005E538D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E5392   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E5394   8B405C                 mov     eax, [eax+$5C]
005E5397   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005E5399   E8C6DEEEFF             call    004D3264

* Reference to Form1
|
005E539E   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabenab()
|
005E53A1   E8B234FFFF             call    005D8858

* Reference to Form1
|
005E53A6   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.anzeigen()
|
005E53A9   E8EEEFFEFF             call    005D439C
005E53AE   33C0                   xor     eax, eax
005E53B0   5A                     pop     edx
005E53B1   59                     pop     ecx
005E53B2   59                     pop     ecx
005E53B3   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005E53B6   68D0535E00             push    $005E53D0
005E53BB   8D45D0                 lea     eax, [ebp-$30]
005E53BE   BA08000000             mov     edx, $00000008

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005E53C3   E8C4F7E1FF             call    00404B8C
005E53C8   C3                     ret


* Reference to: System.@HandleFinally;
|
005E53C9   E9FEF0E1FF             jmp     004044CC
005E53CE   EBEB                   jmp     005E53BB

****** END
|
005E53D0   5F                     pop     edi
005E53D1   5E                     pop     esi
005E53D2   5B                     pop     ebx
005E53D3   8BE5                   mov     esp, ebp
005E53D5   5D                     pop     ebp
005E53D6   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.Label18 (TLabel); TForm1.Label19 (TLabel);
    TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.Edit(TDataSet);; DB.TDataSet.First(TDataSet);;
    DB.TDataSet.Next(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_0534; OFFS_05C0
Project calls: TForm1.anzeigen(); TForm1.lab18ein(); TForm1.speich1(); TForm1.tabdisab();
    TForm1.tabenab(); Unit_00408494.Proc_00409950
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Controls.TControl.SetVisible(TControl;Boolean);;
    Dialogs.Proc_004456EC; Dialogs.ShowMessage(AnsiString);; method TMenuItem.Click();
    QControls.TGraphicControl.PaintRequest(TGraphicControl);
Strings/files/dialog text: '_^[��]�'; 'Alle IDs l�schen ?'; 'IDs l�schen '; 'Keine Daten
    verf�gbar.'; '�.�����_^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.IDslschen1Click(Sender : TObject);
begin
(*
005E5494   55                     push    ebp
005E5495   8BEC                   mov     ebp, esp
005E5497   83C4E8                 add     esp, -$18
005E549A   53                     push    ebx
005E549B   56                     push    esi
005E549C   57                     push    edi
005E549D   33C9                   xor     ecx, ecx
005E549F   894DF0                 mov     [ebp-$10], ecx
005E54A2   8945FC                 mov     [ebp-$04], eax
005E54A5   33C0                   xor     eax, eax
005E54A7   55                     push    ebp

* Possible String Reference to: '�.�����_^[��]�'
|
005E54A8   6899565E00             push    $005E5699

***** TRY
|
005E54AD   64FF30                 push    dword ptr fs:[eax]
005E54B0   648920                 mov     fs:[eax], esp

* Reference to Form1
|
005E54B3   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005E54B6   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005E54BC   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005E54BF   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005E54C5   E8EEA8E9FF             call    0047FDB8

* Reference to Form1
|
005E54CA   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.aus1 : TMenuItem
|
005E54CD   8B801C060000           mov     eax, [eax+$061C]
005E54D3   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005E54D5   FF5244                 call    dword ptr [edx+$44]

* Reference to Form1
|
005E54D8   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.speich1()
|
005E54DB   E8BC24FFFF             call    005D799C

* Reference to pointer to GlobalVar_0061DF08
|
005E54E0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E54E5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E54E7   8B405C                 mov     eax, [eax+$5C]
005E54EA   8B10                   mov     edx, [eax]
005E54EC   FF924C010000           call    dword ptr [edx+$014C]
005E54F2   83F802                 cmp     eax, +$02
005E54F5   7D0F                   jnl     005E5506

* Possible String Reference to: 'Keine Daten verf�gbar.'
|
005E54F7   B8B0565E00             mov     eax, $005E56B0

* Reference to: Dialogs.ShowMessage(AnsiString);
|
005E54FC   E8E302E6FF             call    004457E4
005E5501   E97D010000             jmp     005E5683
005E5506   6A00                   push    $00
005E5508   668B0DC8565E00         mov     cx, word ptr [$005E56C8]
005E550F   B203                   mov     dl, $03

* Possible String Reference to: 'Alle IDs l�schen ?'
|
005E5511   B8D4565E00             mov     eax, $005E56D4

* Reference to: Dialogs.Proc_004456EC
|
005E5516   E8D101E6FF             call    004456EC
005E551B   83F806                 cmp     eax, +$06
005E551E   0F855F010000           jnz     005E5683
005E5524   C745F401000000         mov     dword ptr [ebp-$0C], $00000001

* Reference to Form1
|
005E552B   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005E552E   8B8004040000           mov     eax, [eax+$0404]

* Possible String Reference to: 'IDs l�schen      '
|
005E5534   BAF0565E00             mov     edx, $005E56F0

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E5539   E8F674E6FF             call    0044CA34

* Reference to Form1
|
005E553E   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.lab18ein()
|
005E5541   E89E32FFFF             call    005D87E4

* Reference to pointer to GlobalVar_0061DF08
|
005E5546   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E554B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005E554D   8B8034050000           mov     eax, [eax+$0534]
005E5553   8B10                   mov     edx, [eax]
005E5555   FF5258                 call    dword ptr [edx+$58]
005E5558   8945F8                 mov     [ebp-$08], eax

* Reference to pointer to GlobalVar_0061DF08
|
005E555B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E5560   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E5562   8B405C                 mov     eax, [eax+$5C]
005E5565   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005E5567   E8F0D5EEFF             call    004D2B5C

* Reference to Form1
|
005E556C   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabdisab()
|
005E556F   E8C032FFFF             call    005D8834

* Reference to pointer to GlobalVar_0061DF08
|
005E5574   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E5579   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E557B   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005E557E   E8519CECFF             call    004AF1D4
005E5583   E996000000             jmp     005E561E
005E5588   8D55F0                 lea     edx, [ebp-$10]
005E558B   8B45F4                 mov     eax, [ebp-$0C]

* Reference to: Unit_00408494.Proc_00409950
|
005E558E   E8BD43E2FF             call    00409950
005E5593   8B55F0                 mov     edx, [ebp-$10]

* Reference to Form1
|
005E5596   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005E5599   8B8000040000           mov     eax, [eax+$0400]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005E559F   E89074E6FF             call    0044CA34

* Reference to Form1
|
005E55A4   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005E55A7   8B8000040000           mov     eax, [eax+$0400]

* Reference to: QControls.TGraphicControl.PaintRequest(TGraphicControl);
|
005E55AD   E8D679E6FF             call    0044CF88
005E55B2   FF45F4                 inc     dword ptr [ebp-$0C]

* Reference to pointer to GlobalVar_0061DF08
|
005E55B5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E55BA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E55BC   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
005E55BF   E81CA0ECFF             call    004AF5E0

* Reference to pointer to GlobalVar_0061DF08
|
005E55C4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E55C9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05C0
|
005E55CB   8B80C0050000           mov     eax, [eax+$05C0]
005E55D1   33D2                   xor     edx, edx
005E55D3   8B08                   mov     ecx, [eax]
005E55D5   FF91B0000000           call    dword ptr [ecx+$00B0]
005E55DB   33C0                   xor     eax, eax
005E55DD   55                     push    ebp
005E55DE   6805565E00             push    $005E5605

***** TRY
|
005E55E3   64FF30                 push    dword ptr fs:[eax]
005E55E6   648920                 mov     fs:[eax], esp

* Reference to pointer to GlobalVar_0061DF08
|
005E55E9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E55EE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E55F0   8B405C                 mov     eax, [eax+$5C]
005E55F3   8B10                   mov     edx, [eax]
005E55F5   FF9248020000           call    dword ptr [edx+$0248]
005E55FB   33C0                   xor     eax, eax
005E55FD   5A                     pop     edx
005E55FE   59                     pop     ecx
005E55FF   59                     pop     ecx
005E5600   648910                 mov     fs:[eax], edx
005E5603   EB0A                   jmp     005E560F

* Reference to: System.@HandleAnyException;
|
005E5605   E90EECE1FF             jmp     00404218

* Reference to: System.@DoneExcept;
|
005E560A   E835F0E1FF             call    00404644

****** END
|
* Reference to pointer to GlobalVar_0061DF08
|
005E560F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E5614   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E5616   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005E5619   E8CE9EECFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005E561E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E5623   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E5625   8B405C                 mov     eax, [eax+$5C]
005E5628   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005E562F   0F8453FFFFFF           jz      005E5588

* Reference to Form1
|
005E5635   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005E5638   8B8000040000           mov     eax, [eax+$0400]
005E563E   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005E5640   E8DF72E6FF             call    0044C924

* Reference to Form1
|
005E5645   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005E5648   8B8004040000           mov     eax, [eax+$0404]
005E564E   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005E5650   E8CF72E6FF             call    0044C924
005E5655   8B45F8                 mov     eax, [ebp-$08]
005E5658   8945E8                 mov     [ebp-$18], eax
005E565B   C645EC00               mov     byte ptr [ebp-$14], $00
005E565F   8D55E8                 lea     edx, [ebp-$18]

* Reference to pointer to GlobalVar_0061DF08
|
005E5662   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005E5667   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005E5669   8B405C                 mov     eax, [eax+$5C]
005E566C   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005E566E   E8F1DBEEFF             call    004D3264

* Reference to Form1
|
005E5673   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabenab()
|
005E5676   E8DD31FFFF             call    005D8858

* Reference to Form1
|
005E567B   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.anzeigen()
|
005E567E   E819EDFEFF             call    005D439C
005E5683   33C0                   xor     eax, eax
005E5685   5A                     pop     edx
005E5686   59                     pop     ecx
005E5687   59                     pop     ecx
005E5688   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
005E568B   68A0565E00             push    $005E56A0
005E5690   8D45F0                 lea     eax, [ebp-$10]

* Reference to: System.@LStrClr(void;void);
|
005E5693   E8D0F4E1FF             call    00404B68
005E5698   C3                     ret


* Reference to: System.@HandleFinally;
|
005E5699   E92EEEE1FF             jmp     004044CC
005E569E   EBF0                   jmp     005E5690

****** END
|
005E56A0   5F                     pop     edi
005E56A1   5E                     pop     esi
005E56A2   5B                     pop     ebx
005E56A3   8BE5                   mov     esp, ebp
005E56A5   5D                     pop     ebp
005E56A6   C3                     ret

*)
end;

procedure TForm1.beenden1Click(Sender : TObject);
begin
  ExecuteMainFormExit(TMainFormExitActions.Create(Self));
end;

procedure TForm1.Datenschutzein1Click(Sender : TObject);
begin
  ExecutePrivacyModeEnable(TMainFormPrivacyModeActions.Create(Self));
end;

procedure TForm1.Datenschutzaus1Click(Sender : TObject);
begin
  ExecutePrivacyModeDisable(TMainFormPrivacyModeActions.Create(Self));
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.PageControl1 (TPageControl); TForm1.PrintDialog1 (TPrintDialog); TForm1.TabSheet2
    (TTabSheet)
Project calls: TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);; method
    TPrintDialog.Execute()
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Druckereinstellung1Click(Sender : TObject);
begin
(*
005EC77C   53                     push    ebx
005EC77D   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EC77F   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EC785   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EC78B   E82836E9FF             call    0047FDB8
005EC790   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005EC792   E805B2FEFF             call    005D799C

* Reference to control TForm1.PrintDialog1 : TPrintDialog
|
005EC797   8B8364060000           mov     eax, [ebx+$0664]
005EC79D   8B10                   mov     edx, [eax]

* Reference to method TPrintDialog.Execute()
|
005EC79F   FF523C                 call    dword ptr [edx+$3C]
005EC7A2   5B                     pop     ebx
005EC7A3   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.Edit11 (TEdit); TForm1.Edit12 (TDBEdit); TForm1.Edit16 (TDBEdit); TForm1.Edit3
    (TDBEdit); TForm1.Edit7 (TEdit); TForm1.PageControl1 (TPageControl); TForm1.PrinterSetupDialog1
    (TPrinterSetupDialog); TForm1.TabSheet2 (TTabSheet)
Project calls: TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.BringToFront(TControl);; Controls.TControl.SendToBack(TControl);;
    Forms.TCustomForm.Print(TCustomForm);; method TPrinterSetupDialog.Execute(); method
    TTabSheet.Invalidate()
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Bildschirmdrucken1Click(Sender : TObject);
begin
(*
005EC7A4   53                     push    ebx
005EC7A5   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EC7A7   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EC7AD   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EC7B3   E80036E9FF             call    0047FDB8
005EC7B8   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005EC7BA   E8DDB1FEFF             call    005D799C

* Reference to control TForm1.PrinterSetupDialog1 : TPrinterSetupDialog
|
005EC7BF   8B83E0080000           mov     eax, [ebx+$08E0]
005EC7C5   8B10                   mov     edx, [eax]

* Reference to method TPrinterSetupDialog.Execute()
|
005EC7C7   FF523C                 call    dword ptr [edx+$3C]
005EC7CA   84C0                   test    al, al
005EC7CC   0F8480000000           jz      005EC852

* Reference to control TForm1.Edit3 : TDBEdit
|
005EC7D2   8B83E4080000           mov     eax, [ebx+$08E4]

* Reference to: Controls.TControl.BringToFront(TControl);
|
005EC7D8   E88704E6FF             call    0044CC64

* Reference to control TForm1.Edit7 : TEdit
|
005EC7DD   8B83E8080000           mov     eax, [ebx+$08E8]

* Reference to: Controls.TControl.BringToFront(TControl);
|
005EC7E3   E87C04E6FF             call    0044CC64

* Reference to control TForm1.Edit11 : TEdit
|
005EC7E8   8B83EC080000           mov     eax, [ebx+$08EC]

* Reference to: Controls.TControl.BringToFront(TControl);
|
005EC7EE   E87104E6FF             call    0044CC64

* Reference to control TForm1.Edit12 : TDBEdit
|
005EC7F3   8B83F0080000           mov     eax, [ebx+$08F0]

* Reference to: Controls.TControl.BringToFront(TControl);
|
005EC7F9   E86604E6FF             call    0044CC64

* Reference to control TForm1.Edit16 : TDBEdit
|
005EC7FE   8B83F4080000           mov     eax, [ebx+$08F4]

* Reference to: Controls.TControl.BringToFront(TControl);
|
005EC804   E85B04E6FF             call    0044CC64
005EC809   8BC3                   mov     eax, ebx

* Reference to: Forms.TCustomForm.Print(TCustomForm);
|
005EC80B   E8F8D1E7FF             call    00469A08

* Reference to control TForm1.Edit3 : TDBEdit
|
005EC810   8B83E4080000           mov     eax, [ebx+$08E4]

* Reference to: Controls.TControl.SendToBack(TControl);
|
005EC816   E85904E6FF             call    0044CC74

* Reference to control TForm1.Edit7 : TEdit
|
005EC81B   8B83E8080000           mov     eax, [ebx+$08E8]

* Reference to: Controls.TControl.SendToBack(TControl);
|
005EC821   E84E04E6FF             call    0044CC74

* Reference to control TForm1.Edit11 : TEdit
|
005EC826   8B83EC080000           mov     eax, [ebx+$08EC]

* Reference to: Controls.TControl.SendToBack(TControl);
|
005EC82C   E84304E6FF             call    0044CC74

* Reference to control TForm1.Edit12 : TDBEdit
|
005EC831   8B83F0080000           mov     eax, [ebx+$08F0]

* Reference to: Controls.TControl.SendToBack(TControl);
|
005EC837   E83804E6FF             call    0044CC74

* Reference to control TForm1.Edit16 : TDBEdit
|
005EC83C   8B83F4080000           mov     eax, [ebx+$08F4]

* Reference to: Controls.TControl.SendToBack(TControl);
|
005EC842   E82D04E6FF             call    0044CC74

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EC847   8B8340030000           mov     eax, [ebx+$0340]
005EC84D   8B10                   mov     edx, [eax]

* Reference to method TTabSheet.Invalidate()
|
005EC84F   FF527C                 call    dword ptr [edx+$7C]
005EC852   5B                     pop     ebx
005EC853   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.Label18 (TLabel); TForm1.Label19 (TLabel); TForm1.PageControl1 (TPageControl);
    TForm1.SaveDialog1 (TSaveDialog); TForm1.TabSheet2 (TTabSheet); Form1
Database/provider: DB.TDataSet.First(TDataSet);; DB.TDataSet.Next(TDataSet);;
    DB.TDataSet.Open(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_0080; OFFS_009C; OFFS_00A4; OFFS_00CC; OFFS_03B4;
    OFFS_03B8; OFFS_03BC; OFFS_03C0; OFFS_03C4; OFFS_03C8; OFFS_03CC; OFFS_03D0; OFFS_03D4;
    OFFS_03D8; OFFS_03DC; OFFS_03E0; OFFS_03E4; OFFS_03E8; OFFS_03EC; OFFS_03F0; OFFS_03F4;
    OFFS_0534; OFFS_0538; OFFS_053C; OFFS_0540; OFFS_0544; OFFS_0548; OFFS_054C; OFFS_0550;
    OFFS_0554; OFFS_0558; OFFS_055C; OFFS_0560; OFFS_0564; OFFS_0568; OFFS_056C; OFFS_0570;
    OFFS_0574; OFFS_0578; OFFS_057C; OFFS_0580; OFFS_0584; OFFS_0588; OFFS_058C; OFFS_0590;
    OFFS_0594; OFFS_0598; OFFS_059C; OFFS_05A0; OFFS_05A4; OFFS_05A8; OFFS_05AC; OFFS_05B4;
    OFFS_05BC; OFFS_05C0; OFFS_05C4; OFFS_05C8; OFFS_05CC; OFFS_05D0; OFFS_05D4; OFFS_05D8;
    OFFS_05DC; OFFS_05EC; OFFS_05FC; OFFS_0600; OFFS_0874; OFFS_0880; OFFS_0884
Project calls: TForm1.anzeigen(); TForm1.lab18ein(); TForm1.tabdisab(); TForm1.tabenab();
    Unit_00408494.Proc_00409448; Unit_00408494.Proc_00409950
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.Refresh(TControl);; Controls.TControl.SetText(TControl;TCaption);;
    Controls.TControl.SetVisible(TControl;Boolean);; Dialogs.Proc_004456EC;
    Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;;
    Forms.TScreen.SetCursor(TScreen;TCursor);; method TSaveDialog.Execute();
    QControls.TGraphicControl.PaintRequest(TGraphicControl);; System.IOResult:Integer;;
    System.Proc_00402988; System.Proc_00404EE0; TScreen instance
Strings/files/dialog text: ' ('; '^[��]�'; 'Excel-Export ?'; 'Export schreiben'; 'num';
    'Text-Dateien (*.txt)|*.txt'; 'txt'; '�e���^[��]�'; '�f���ꍅ,�����R���hK���E���';
    '��,�����R���hK���E���'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.ExcelExport1Click(Sender : TObject);
begin
(*
005EC854   55                     push    ebp
005EC855   8BEC                   mov     ebp, esp
005EC857   B97A000000             mov     ecx, $0000007A
005EC85C   6A00                   push    $00
005EC85E   6A00                   push    $00
005EC860   49                     dec     ecx
005EC861   75F9                   jnz     005EC85C
005EC863   53                     push    ebx
005EC864   56                     push    esi
005EC865   8945FC                 mov     [ebp-$04], eax
005EC868   33C0                   xor     eax, eax
005EC86A   55                     push    ebp

* Possible String Reference to: '�e���^[��]�'
|
005EC86B   6811DF5E00             push    $005EDF11

***** TRY
|
005EC870   64FF30                 push    dword ptr fs:[eax]
005EC873   648920                 mov     fs:[eax], esp

* Reference to Form1
|
005EC876   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EC879   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005EC87F   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EC882   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EC888   E82B35E9FF             call    0047FDB8

* Reference to pointer to GlobalVar_0061DF08
|
005EC88D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EC892   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005EC894   8B8034050000           mov     eax, [eax+$0534]
005EC89A   8B10                   mov     edx, [eax]
005EC89C   FF5258                 call    dword ptr [edx+$58]
005EC89F   8945F8                 mov     [ebp-$08], eax
005EC8A2   6A00                   push    $00
005EC8A4   668B0D20DF5E00         mov     cx, word ptr [$005EDF20]
005EC8AB   B204                   mov     dl, $04

* Possible String Reference to: 'Excel-Export ?'
|
005EC8AD   B82CDF5E00             mov     eax, $005EDF2C

* Reference to: Dialogs.Proc_004456EC
|
005EC8B2   E8358EE5FF             call    004456EC
005EC8B7   83F806                 cmp     eax, +$06
005EC8BA   0F85F8150000           jnz     005EDEB8

* Reference to Form1
|
005EC8C0   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.SaveDialog1 : TSaveDialog
|
005EC8C3   8B80FC030000           mov     eax, [eax+$03FC]
005EC8C9   83C074                 add     eax, +$74

* Possible String Reference to: 'txt'
|
005EC8CC   BA44DF5E00             mov     edx, $005EDF44

* Reference to: System.@LStrAsg(void;void;void;void);
|
005EC8D1   E8E682E1FF             call    00404BBC

* Reference to Form1
|
005EC8D6   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.SaveDialog1 : TSaveDialog
|
005EC8D9   8B80FC030000           mov     eax, [eax+$03FC]
005EC8DF   83C060                 add     eax, +$60

* Possible String Reference to: 'Text-Dateien (*.txt)|*.txt'
|
005EC8E2   BA50DF5E00             mov     edx, $005EDF50

* Reference to: System.@LStrAsg(void;void;void;void);
|
005EC8E7   E8D082E1FF             call    00404BBC

* Reference to Form1
|
005EC8EC   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.SaveDialog1 : TSaveDialog
|
005EC8EF   8B98FC030000           mov     ebx, [eax+$03FC]
005EC8F5   A16CDF5E00             mov     eax, dword ptr [$005EDF6C]

* Reference to field TSaveDialog.Options : TOpenOptions
|
005EC8FA   89435C                 mov     [ebx+$5C], eax
005EC8FD   8BC3                   mov     eax, ebx
005EC8FF   8B10                   mov     edx, [eax]

* Reference to method TSaveDialog.Execute()
|
005EC901   FF523C                 call    dword ptr [edx+$3C]
005EC904   84C0                   test    al, al
005EC906   0F84AC150000           jz      005EDEB8
005EC90C   8D9524FEFFFF           lea     edx, [ebp+$FFFFFE24]

* Reference to Form1
|
005EC912   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.SaveDialog1 : TSaveDialog
|
005EC915   8B80FC030000           mov     eax, [eax+$03FC]

* Reference to: Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;
|
005EC91B   E81075E5FF             call    00443E30
005EC920   8B8524FEFFFF           mov     eax, [ebp+$FFFFFE24]
005EC926   8D9528FEFFFF           lea     edx, [ebp+$FFFFFE28]

* Reference to: Unit_00408494.Proc_00409448
|
005EC92C   E817CBE1FF             call    00409448
005EC931   83BD28FEFFFF00         cmp     dword ptr [ebp+$FFFFFE28], +$00
005EC938   0F86D2140000           jbe     005EDE10
005EC93E   8D9520FEFFFF           lea     edx, [ebp+$FFFFFE20]

* Reference to Form1
|
005EC944   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.SaveDialog1 : TSaveDialog
|
005EC947   8B80FC030000           mov     eax, [eax+$03FC]

* Reference to: Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;
|
005EC94D   E8DE74E5FF             call    00443E30
005EC952   8B9520FEFFFF           mov     edx, [ebp+$FFFFFE20]
005EC958   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Assign(TTextRec;TTextRec;String):Integer;
|
005EC95E   E8E166E1FF             call    00403044
005EC963   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@RewritText(TTextRec;TTextRec):Integer;
|
005EC969   E87264E1FF             call    00402DE0

* Reference to: System.IOResult:Integer;
|
005EC96E   E83961E1FF             call    00402AAC
005EC973   85C0                   test    eax, eax
005EC975   0F853D150000           jnz     005EDEB8

* Reference to Form1
|
005EC97B   A108595302             mov     eax, dword ptr [$02535908]

* Reference to: Controls.TControl.Refresh(TControl);
|
005EC980   E80306E6FF             call    0044CF88

* Reference to Form1
|
005EC985   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabdisab()
|
005EC988   E8A7BEFEFF             call    005D8834

* Reference to pointer to GlobalVar_0061DF08
|
005EC98D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EC992   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EC994   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EC997   E8EC02ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005EC99C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EC9A1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EC9A3   8B405C                 mov     eax, [eax+$5C]
005EC9A6   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EC9A8   E8AF61EEFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005EC9AD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EC9B2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EC9B4   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EC9B7   E81828ECFF             call    004AF1D4

* Reference to pointer to GlobalVar_0061DF08
|
005EC9BC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EC9C1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005EC9C3   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EC9C9   E8BA02ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005EC9CE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EC9D3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005EC9D5   8B80A4000000           mov     eax, [eax+$00A4]

* Possible String Reference to: 'num'
|
005EC9DB   BA78DF5E00             mov     edx, $005EDF78

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EC9E0   E87761EEFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005EC9E5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EC9EA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005EC9EC   8B809C000000           mov     eax, [eax+$009C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EC9F2   E89102ECFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005EC9F7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EC9FC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005EC9FE   8B809C000000           mov     eax, [eax+$009C]
005ECA04   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005ECA06   E85161EEFF             call    004D2B5C

* Reference to pointer to GlobalVar_0061DF08
|
005ECA0B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECA10   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00CC
|
005ECA12   8B80CC000000           mov     eax, [eax+$00CC]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005ECA18   E86B02ECFF             call    004ACC88

* Reference to TScreen instance
|
005ECA1D   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005ECA22   8B00                   mov     eax, [eax]
005ECA24   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005ECA28   E86FE7E7FF             call    0046B19C
005ECA2D   33C0                   xor     eax, eax
005ECA2F   55                     push    ebp

* Possible String Reference to: '�f���ꍅ,�����R���hK���E���'
|
005ECA30   6809DE5E00             push    $005EDE09

***** TRY
|
005ECA35   64FF30                 push    dword ptr fs:[eax]
005ECA38   648920                 mov     fs:[eax], esp

* Reference to Form1
|
005ECA3B   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005ECA3E   8B8004040000           mov     eax, [eax+$0404]

* Possible String Reference to: 'Export schreiben'
|
005ECA44   BA84DF5E00             mov     edx, $005EDF84

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005ECA49   E8E6FFE5FF             call    0044CA34

* Reference to Form1
|
005ECA4E   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.lab18ein()
|
005ECA51   E88EBDFEFF             call    005D87E4
005ECA56   33DB                   xor     ebx, ebx
005ECA58   BAA0DF5E00             mov     edx, $005EDFA0
005ECA5D   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECA63   E8CC87E1FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005ECA68   E8E76CE1FF             call    00403754

* Reference to: System.Proc_00402988
|
005ECA6D   E8165FE1FF             call    00402988
005ECA72   B220                   mov     dl, $20
005ECA74   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Char(TTextRec;TTextRec;Char):Pointer;
|
005ECA7A   E8996CE1FF             call    00403718

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005ECA7F   E8D06CE1FF             call    00403754

* Reference to: System.Proc_00402988
|
005ECA84   E8FF5EE1FF             call    00402988
005ECA89   E948130000             jmp     005EDDD6

* Reference to pointer to GlobalVar_0061DF08
|
005ECA8E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECA93   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005ECA95   8B8034050000           mov     eax, [eax+$0534]
005ECA9B   8B10                   mov     edx, [eax]
005ECA9D   FF5258                 call    dword ptr [edx+$58]
005ECAA0   85C0                   test    eax, eax
005ECAA2   0F8E04130000           jle     005EDDAC
005ECAA8   8D951CFEFFFF           lea     edx, [ebp+$FFFFFE1C]
005ECAAE   8BC3                   mov     eax, ebx

* Reference to: Unit_00408494.Proc_00409950
|
005ECAB0   E89BCEE1FF             call    00409950
005ECAB5   8B951CFEFFFF           mov     edx, [ebp+$FFFFFE1C]

* Reference to Form1
|
005ECABB   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005ECABE   8B8000040000           mov     eax, [eax+$0400]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005ECAC4   E86BFFE5FF             call    0044CA34

* Reference to Form1
|
005ECAC9   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005ECACC   8B8000040000           mov     eax, [eax+$0400]

* Reference to: QControls.TGraphicControl.PaintRequest(TGraphicControl);
|
005ECAD2   E8B104E6FF             call    0044CF88

* Reference to pointer to GlobalVar_0061DF08
|
005ECAD7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECADC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005ECADE   8B8034050000           mov     eax, [eax+$0534]
005ECAE4   8B10                   mov     edx, [eax]
005ECAE6   FF5258                 call    dword ptr [edx+$58]
005ECAE9   8D9518FEFFFF           lea     edx, [ebp+$FFFFFE18]

* Reference to: Unit_00408494.Proc_00409950
|
005ECAEF   E85CCEE1FF             call    00409950
005ECAF4   8B9518FEFFFF           mov     edx, [ebp+$FFFFFE18]
005ECAFA   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECB00   E82F87E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECB05   E8F665E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECB0A   E8795EE1FF             call    00402988

* Reference to pointer to GlobalVar_0061DF08
|
005ECB0F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECB14   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0538
|
005ECB16   8B8038050000           mov     eax, [eax+$0538]
005ECB1C   8B10                   mov     edx, [eax]
005ECB1E   FF5258                 call    dword ptr [edx+$58]
005ECB21   8D9510FEFFFF           lea     edx, [ebp+$FFFFFE10]

* Reference to: Unit_00408494.Proc_00409950
|
005ECB27   E824CEE1FF             call    00409950
005ECB2C   8B8D10FEFFFF           mov     ecx, [ebp+$FFFFFE10]
005ECB32   8D8514FEFFFF           lea     eax, [ebp+$FFFFFE14]
005ECB38   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECB3D   E82A83E1FF             call    00404E6C
005ECB42   8B9514FEFFFF           mov     edx, [ebp+$FFFFFE14]
005ECB48   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECB4E   E8E186E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECB53   E8A865E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECB58   E82B5EE1FF             call    00402988

* Reference to pointer to GlobalVar_0061DF08
|
005ECB5D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECB62   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_053C
|
005ECB64   8B803C050000           mov     eax, [eax+$053C]
005ECB6A   8B10                   mov     edx, [eax]
005ECB6C   FF5258                 call    dword ptr [edx+$58]
005ECB6F   8D9508FEFFFF           lea     edx, [ebp+$FFFFFE08]

* Reference to: Unit_00408494.Proc_00409950
|
005ECB75   E8D6CDE1FF             call    00409950
005ECB7A   8B8D08FEFFFF           mov     ecx, [ebp+$FFFFFE08]
005ECB80   8D850CFEFFFF           lea     eax, [ebp+$FFFFFE0C]
005ECB86   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECB8B   E8DC82E1FF             call    00404E6C
005ECB90   8B950CFEFFFF           mov     edx, [ebp+$FFFFFE0C]
005ECB96   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECB9C   E89386E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECBA1   E85A65E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECBA6   E8DD5DE1FF             call    00402988
005ECBAB   8D9500FEFFFF           lea     edx, [ebp+$FFFFFE00]

* Reference to pointer to GlobalVar_0061DF08
|
005ECBB1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECBB6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0540
|
005ECBB8   8B8040050000           mov     eax, [eax+$0540]
005ECBBE   8B08                   mov     ecx, [eax]
005ECBC0   FF5160                 call    dword ptr [ecx+$60]
005ECBC3   8B8D00FEFFFF           mov     ecx, [ebp+$FFFFFE00]
005ECBC9   8D8504FEFFFF           lea     eax, [ebp+$FFFFFE04]
005ECBCF   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECBD4   E89382E1FF             call    00404E6C
005ECBD9   8B9504FEFFFF           mov     edx, [ebp+$FFFFFE04]
005ECBDF   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECBE5   E84A86E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECBEA   E81165E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECBEF   E8945DE1FF             call    00402988
005ECBF4   8D95F8FDFFFF           lea     edx, [ebp+$FFFFFDF8]

* Reference to pointer to GlobalVar_0061DF08
|
005ECBFA   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECBFF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0544
|
005ECC01   8B8044050000           mov     eax, [eax+$0544]
005ECC07   8B08                   mov     ecx, [eax]
005ECC09   FF5160                 call    dword ptr [ecx+$60]
005ECC0C   8B8DF8FDFFFF           mov     ecx, [ebp+$FFFFFDF8]
005ECC12   8D85FCFDFFFF           lea     eax, [ebp+$FFFFFDFC]
005ECC18   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECC1D   E84A82E1FF             call    00404E6C
005ECC22   8B95FCFDFFFF           mov     edx, [ebp+$FFFFFDFC]
005ECC28   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECC2E   E80186E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECC33   E8C864E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECC38   E84B5DE1FF             call    00402988
005ECC3D   8D95F0FDFFFF           lea     edx, [ebp+$FFFFFDF0]

* Reference to pointer to GlobalVar_0061DF08
|
005ECC43   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECC48   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0600
|
005ECC4A   8B8000060000           mov     eax, [eax+$0600]
005ECC50   8B08                   mov     ecx, [eax]
005ECC52   FF5160                 call    dword ptr [ecx+$60]
005ECC55   8B8DF0FDFFFF           mov     ecx, [ebp+$FFFFFDF0]
005ECC5B   8D85F4FDFFFF           lea     eax, [ebp+$FFFFFDF4]
005ECC61   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECC66   E80182E1FF             call    00404E6C
005ECC6B   8B95F4FDFFFF           mov     edx, [ebp+$FFFFFDF4]
005ECC71   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECC77   E8B885E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECC7C   E87F64E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECC81   E8025DE1FF             call    00402988
005ECC86   8D95E8FDFFFF           lea     edx, [ebp+$FFFFFDE8]

* Reference to pointer to GlobalVar_0061DF08
|
005ECC8C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECC91   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0548
|
005ECC93   8B8048050000           mov     eax, [eax+$0548]
005ECC99   8B08                   mov     ecx, [eax]
005ECC9B   FF5160                 call    dword ptr [ecx+$60]
005ECC9E   8B8DE8FDFFFF           mov     ecx, [ebp+$FFFFFDE8]
005ECCA4   8D85ECFDFFFF           lea     eax, [ebp+$FFFFFDEC]
005ECCAA   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECCAF   E8B881E1FF             call    00404E6C
005ECCB4   8B95ECFDFFFF           mov     edx, [ebp+$FFFFFDEC]
005ECCBA   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECCC0   E86F85E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECCC5   E83664E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECCCA   E8B95CE1FF             call    00402988
005ECCCF   8D95E0FDFFFF           lea     edx, [ebp+$FFFFFDE0]

* Reference to pointer to GlobalVar_0061DF08
|
005ECCD5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECCDA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_054C
|
005ECCDC   8B804C050000           mov     eax, [eax+$054C]
005ECCE2   8B08                   mov     ecx, [eax]
005ECCE4   FF5160                 call    dword ptr [ecx+$60]
005ECCE7   8B8DE0FDFFFF           mov     ecx, [ebp+$FFFFFDE0]
005ECCED   8D85E4FDFFFF           lea     eax, [ebp+$FFFFFDE4]
005ECCF3   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECCF8   E86F81E1FF             call    00404E6C
005ECCFD   8B95E4FDFFFF           mov     edx, [ebp+$FFFFFDE4]
005ECD03   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECD09   E82685E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECD0E   E8ED63E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECD13   E8705CE1FF             call    00402988
005ECD18   8D95D8FDFFFF           lea     edx, [ebp+$FFFFFDD8]

* Reference to pointer to GlobalVar_0061DF08
|
005ECD1E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECD23   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0550
|
005ECD25   8B8050050000           mov     eax, [eax+$0550]
005ECD2B   8B08                   mov     ecx, [eax]
005ECD2D   FF5160                 call    dword ptr [ecx+$60]
005ECD30   8B8DD8FDFFFF           mov     ecx, [ebp+$FFFFFDD8]
005ECD36   8D85DCFDFFFF           lea     eax, [ebp+$FFFFFDDC]
005ECD3C   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECD41   E82681E1FF             call    00404E6C
005ECD46   8B95DCFDFFFF           mov     edx, [ebp+$FFFFFDDC]
005ECD4C   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECD52   E8DD84E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECD57   E8A463E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECD5C   E8275CE1FF             call    00402988
005ECD61   8D95D0FDFFFF           lea     edx, [ebp+$FFFFFDD0]

* Reference to pointer to GlobalVar_0061DF08
|
005ECD67   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECD6C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0554
|
005ECD6E   8B8054050000           mov     eax, [eax+$0554]
005ECD74   8B08                   mov     ecx, [eax]
005ECD76   FF5160                 call    dword ptr [ecx+$60]
005ECD79   8B8DD0FDFFFF           mov     ecx, [ebp+$FFFFFDD0]
005ECD7F   8D85D4FDFFFF           lea     eax, [ebp+$FFFFFDD4]
005ECD85   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECD8A   E8DD80E1FF             call    00404E6C
005ECD8F   8B95D4FDFFFF           mov     edx, [ebp+$FFFFFDD4]
005ECD95   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECD9B   E89484E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECDA0   E85B63E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECDA5   E8DE5BE1FF             call    00402988
005ECDAA   8D95C8FDFFFF           lea     edx, [ebp+$FFFFFDC8]

* Reference to pointer to GlobalVar_0061DF08
|
005ECDB0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECDB5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0558
|
005ECDB7   8B8058050000           mov     eax, [eax+$0558]
005ECDBD   8B08                   mov     ecx, [eax]
005ECDBF   FF5160                 call    dword ptr [ecx+$60]
005ECDC2   8B8DC8FDFFFF           mov     ecx, [ebp+$FFFFFDC8]
005ECDC8   8D85CCFDFFFF           lea     eax, [ebp+$FFFFFDCC]
005ECDCE   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECDD3   E89480E1FF             call    00404E6C
005ECDD8   8B95CCFDFFFF           mov     edx, [ebp+$FFFFFDCC]
005ECDDE   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECDE4   E84B84E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECDE9   E81263E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECDEE   E8955BE1FF             call    00402988
005ECDF3   8D95C0FDFFFF           lea     edx, [ebp+$FFFFFDC0]

* Reference to pointer to GlobalVar_0061DF08
|
005ECDF9   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECDFE   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_055C
|
005ECE00   8B805C050000           mov     eax, [eax+$055C]
005ECE06   8B08                   mov     ecx, [eax]
005ECE08   FF5160                 call    dword ptr [ecx+$60]
005ECE0B   8B8DC0FDFFFF           mov     ecx, [ebp+$FFFFFDC0]
005ECE11   8D85C4FDFFFF           lea     eax, [ebp+$FFFFFDC4]
005ECE17   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECE1C   E84B80E1FF             call    00404E6C
005ECE21   8B95C4FDFFFF           mov     edx, [ebp+$FFFFFDC4]
005ECE27   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECE2D   E80284E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECE32   E8C962E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECE37   E84C5BE1FF             call    00402988
005ECE3C   8D95B8FDFFFF           lea     edx, [ebp+$FFFFFDB8]

* Reference to pointer to GlobalVar_0061DF08
|
005ECE42   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECE47   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0560
|
005ECE49   8B8060050000           mov     eax, [eax+$0560]
005ECE4F   8B08                   mov     ecx, [eax]
005ECE51   FF5160                 call    dword ptr [ecx+$60]
005ECE54   8B8DB8FDFFFF           mov     ecx, [ebp+$FFFFFDB8]
005ECE5A   8D85BCFDFFFF           lea     eax, [ebp+$FFFFFDBC]
005ECE60   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECE65   E80280E1FF             call    00404E6C
005ECE6A   8B95BCFDFFFF           mov     edx, [ebp+$FFFFFDBC]
005ECE70   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECE76   E8B983E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECE7B   E88062E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECE80   E8035BE1FF             call    00402988
005ECE85   8D95B0FDFFFF           lea     edx, [ebp+$FFFFFDB0]

* Reference to pointer to GlobalVar_0061DF08
|
005ECE8B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECE90   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0564
|
005ECE92   8B8064050000           mov     eax, [eax+$0564]
005ECE98   8B08                   mov     ecx, [eax]
005ECE9A   FF5160                 call    dword ptr [ecx+$60]
005ECE9D   8B8DB0FDFFFF           mov     ecx, [ebp+$FFFFFDB0]
005ECEA3   8D85B4FDFFFF           lea     eax, [ebp+$FFFFFDB4]
005ECEA9   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECEAE   E8B97FE1FF             call    00404E6C
005ECEB3   8B95B4FDFFFF           mov     edx, [ebp+$FFFFFDB4]
005ECEB9   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECEBF   E87083E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECEC4   E83762E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECEC9   E8BA5AE1FF             call    00402988
005ECECE   8D95A8FDFFFF           lea     edx, [ebp+$FFFFFDA8]

* Reference to pointer to GlobalVar_0061DF08
|
005ECED4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECED9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0568
|
005ECEDB   8B8068050000           mov     eax, [eax+$0568]
005ECEE1   8B08                   mov     ecx, [eax]
005ECEE3   FF5160                 call    dword ptr [ecx+$60]
005ECEE6   8B8DA8FDFFFF           mov     ecx, [ebp+$FFFFFDA8]
005ECEEC   8D85ACFDFFFF           lea     eax, [ebp+$FFFFFDAC]
005ECEF2   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECEF7   E8707FE1FF             call    00404E6C
005ECEFC   8B95ACFDFFFF           mov     edx, [ebp+$FFFFFDAC]
005ECF02   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECF08   E82783E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECF0D   E8EE61E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECF12   E8715AE1FF             call    00402988
005ECF17   8D95A0FDFFFF           lea     edx, [ebp+$FFFFFDA0]

* Reference to pointer to GlobalVar_0061DF08
|
005ECF1D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECF22   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_056C
|
005ECF24   8B806C050000           mov     eax, [eax+$056C]
005ECF2A   8B08                   mov     ecx, [eax]
005ECF2C   FF5160                 call    dword ptr [ecx+$60]
005ECF2F   8B8DA0FDFFFF           mov     ecx, [ebp+$FFFFFDA0]
005ECF35   8D85A4FDFFFF           lea     eax, [ebp+$FFFFFDA4]
005ECF3B   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECF40   E8277FE1FF             call    00404E6C
005ECF45   8B95A4FDFFFF           mov     edx, [ebp+$FFFFFDA4]
005ECF4B   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECF51   E8DE82E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECF56   E8A561E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECF5B   E8285AE1FF             call    00402988
005ECF60   8D9598FDFFFF           lea     edx, [ebp+$FFFFFD98]

* Reference to pointer to GlobalVar_0061DF08
|
005ECF66   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECF6B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0570
|
005ECF6D   8B8070050000           mov     eax, [eax+$0570]
005ECF73   8B08                   mov     ecx, [eax]
005ECF75   FF5160                 call    dword ptr [ecx+$60]
005ECF78   8B8D98FDFFFF           mov     ecx, [ebp+$FFFFFD98]
005ECF7E   8D859CFDFFFF           lea     eax, [ebp+$FFFFFD9C]
005ECF84   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECF89   E8DE7EE1FF             call    00404E6C
005ECF8E   8B959CFDFFFF           mov     edx, [ebp+$FFFFFD9C]
005ECF94   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECF9A   E89582E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECF9F   E85C61E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECFA4   E8DF59E1FF             call    00402988
005ECFA9   8D9590FDFFFF           lea     edx, [ebp+$FFFFFD90]

* Reference to pointer to GlobalVar_0061DF08
|
005ECFAF   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECFB4   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0574
|
005ECFB6   8B8074050000           mov     eax, [eax+$0574]
005ECFBC   8B08                   mov     ecx, [eax]
005ECFBE   FF5160                 call    dword ptr [ecx+$60]
005ECFC1   8B8D90FDFFFF           mov     ecx, [ebp+$FFFFFD90]
005ECFC7   8D8594FDFFFF           lea     eax, [ebp+$FFFFFD94]
005ECFCD   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ECFD2   E8957EE1FF             call    00404E6C
005ECFD7   8B9594FDFFFF           mov     edx, [ebp+$FFFFFD94]
005ECFDD   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ECFE3   E84C82E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ECFE8   E81361E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ECFED   E89659E1FF             call    00402988
005ECFF2   8D9588FDFFFF           lea     edx, [ebp+$FFFFFD88]

* Reference to pointer to GlobalVar_0061DF08
|
005ECFF8   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ECFFD   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0578
|
005ECFFF   8B8078050000           mov     eax, [eax+$0578]
005ED005   8B08                   mov     ecx, [eax]
005ED007   FF5160                 call    dword ptr [ecx+$60]
005ED00A   8B8D88FDFFFF           mov     ecx, [ebp+$FFFFFD88]
005ED010   8D858CFDFFFF           lea     eax, [ebp+$FFFFFD8C]
005ED016   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED01B   E84C7EE1FF             call    00404E6C
005ED020   8B958CFDFFFF           mov     edx, [ebp+$FFFFFD8C]
005ED026   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED02C   E80382E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED031   E8CA60E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED036   E84D59E1FF             call    00402988
005ED03B   8D9580FDFFFF           lea     edx, [ebp+$FFFFFD80]

* Reference to pointer to GlobalVar_0061DF08
|
005ED041   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED046   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_057C
|
005ED048   8B807C050000           mov     eax, [eax+$057C]
005ED04E   8B08                   mov     ecx, [eax]
005ED050   FF5160                 call    dword ptr [ecx+$60]
005ED053   8B8D80FDFFFF           mov     ecx, [ebp+$FFFFFD80]
005ED059   8D8584FDFFFF           lea     eax, [ebp+$FFFFFD84]
005ED05F   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED064   E8037EE1FF             call    00404E6C
005ED069   8B9584FDFFFF           mov     edx, [ebp+$FFFFFD84]
005ED06F   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED075   E8BA81E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED07A   E88160E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED07F   E80459E1FF             call    00402988
005ED084   8D9578FDFFFF           lea     edx, [ebp+$FFFFFD78]

* Reference to pointer to GlobalVar_0061DF08
|
005ED08A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED08F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0580
|
005ED091   8B8080050000           mov     eax, [eax+$0580]
005ED097   8B08                   mov     ecx, [eax]
005ED099   FF5160                 call    dword ptr [ecx+$60]
005ED09C   8B8D78FDFFFF           mov     ecx, [ebp+$FFFFFD78]
005ED0A2   8D857CFDFFFF           lea     eax, [ebp+$FFFFFD7C]
005ED0A8   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED0AD   E8BA7DE1FF             call    00404E6C
005ED0B2   8B957CFDFFFF           mov     edx, [ebp+$FFFFFD7C]
005ED0B8   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED0BE   E87181E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED0C3   E83860E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED0C8   E8BB58E1FF             call    00402988
005ED0CD   8D9570FDFFFF           lea     edx, [ebp+$FFFFFD70]

* Reference to pointer to GlobalVar_0061DF08
|
005ED0D3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED0D8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0584
|
005ED0DA   8B8084050000           mov     eax, [eax+$0584]
005ED0E0   8B08                   mov     ecx, [eax]
005ED0E2   FF5160                 call    dword ptr [ecx+$60]
005ED0E5   8B8D70FDFFFF           mov     ecx, [ebp+$FFFFFD70]
005ED0EB   8D8574FDFFFF           lea     eax, [ebp+$FFFFFD74]
005ED0F1   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED0F6   E8717DE1FF             call    00404E6C
005ED0FB   8B9574FDFFFF           mov     edx, [ebp+$FFFFFD74]
005ED101   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED107   E82881E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED10C   E8EF5FE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED111   E87258E1FF             call    00402988
005ED116   8D9568FDFFFF           lea     edx, [ebp+$FFFFFD68]

* Reference to pointer to GlobalVar_0061DF08
|
005ED11C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED121   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0588
|
005ED123   8B8088050000           mov     eax, [eax+$0588]
005ED129   8B08                   mov     ecx, [eax]
005ED12B   FF5160                 call    dword ptr [ecx+$60]
005ED12E   8B8D68FDFFFF           mov     ecx, [ebp+$FFFFFD68]
005ED134   8D856CFDFFFF           lea     eax, [ebp+$FFFFFD6C]
005ED13A   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED13F   E8287DE1FF             call    00404E6C
005ED144   8B956CFDFFFF           mov     edx, [ebp+$FFFFFD6C]
005ED14A   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED150   E8DF80E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED155   E8A65FE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED15A   E82958E1FF             call    00402988
005ED15F   8D9560FDFFFF           lea     edx, [ebp+$FFFFFD60]

* Reference to pointer to GlobalVar_0061DF08
|
005ED165   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED16A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_058C
|
005ED16C   8B808C050000           mov     eax, [eax+$058C]
005ED172   8B08                   mov     ecx, [eax]
005ED174   FF5160                 call    dword ptr [ecx+$60]
005ED177   8B8D60FDFFFF           mov     ecx, [ebp+$FFFFFD60]
005ED17D   8D8564FDFFFF           lea     eax, [ebp+$FFFFFD64]
005ED183   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED188   E8DF7CE1FF             call    00404E6C
005ED18D   8B9564FDFFFF           mov     edx, [ebp+$FFFFFD64]
005ED193   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED199   E89680E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED19E   E85D5FE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED1A3   E8E057E1FF             call    00402988
005ED1A8   8D9558FDFFFF           lea     edx, [ebp+$FFFFFD58]

* Reference to pointer to GlobalVar_0061DF08
|
005ED1AE   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED1B3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0590
|
005ED1B5   8B8090050000           mov     eax, [eax+$0590]
005ED1BB   8B08                   mov     ecx, [eax]
005ED1BD   FF5160                 call    dword ptr [ecx+$60]
005ED1C0   8B8D58FDFFFF           mov     ecx, [ebp+$FFFFFD58]
005ED1C6   8D855CFDFFFF           lea     eax, [ebp+$FFFFFD5C]
005ED1CC   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED1D1   E8967CE1FF             call    00404E6C
005ED1D6   8B955CFDFFFF           mov     edx, [ebp+$FFFFFD5C]
005ED1DC   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED1E2   E84D80E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED1E7   E8145FE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED1EC   E89757E1FF             call    00402988
005ED1F1   8D9550FDFFFF           lea     edx, [ebp+$FFFFFD50]

* Reference to pointer to GlobalVar_0061DF08
|
005ED1F7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED1FC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0594
|
005ED1FE   8B8094050000           mov     eax, [eax+$0594]
005ED204   8B08                   mov     ecx, [eax]
005ED206   FF5160                 call    dword ptr [ecx+$60]
005ED209   8B8D50FDFFFF           mov     ecx, [ebp+$FFFFFD50]
005ED20F   8D8554FDFFFF           lea     eax, [ebp+$FFFFFD54]
005ED215   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED21A   E84D7CE1FF             call    00404E6C
005ED21F   8B9554FDFFFF           mov     edx, [ebp+$FFFFFD54]
005ED225   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED22B   E80480E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED230   E8CB5EE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED235   E84E57E1FF             call    00402988
005ED23A   8D9548FDFFFF           lea     edx, [ebp+$FFFFFD48]

* Reference to pointer to GlobalVar_0061DF08
|
005ED240   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED245   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0598
|
005ED247   8B8098050000           mov     eax, [eax+$0598]
005ED24D   8B08                   mov     ecx, [eax]
005ED24F   FF5160                 call    dword ptr [ecx+$60]
005ED252   8B8D48FDFFFF           mov     ecx, [ebp+$FFFFFD48]
005ED258   8D854CFDFFFF           lea     eax, [ebp+$FFFFFD4C]
005ED25E   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED263   E8047CE1FF             call    00404E6C
005ED268   8B954CFDFFFF           mov     edx, [ebp+$FFFFFD4C]
005ED26E   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED274   E8BB7FE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED279   E8825EE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED27E   E80557E1FF             call    00402988
005ED283   8D9540FDFFFF           lea     edx, [ebp+$FFFFFD40]

* Reference to pointer to GlobalVar_0061DF08
|
005ED289   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED28E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_059C
|
005ED290   8B809C050000           mov     eax, [eax+$059C]
005ED296   8B08                   mov     ecx, [eax]
005ED298   FF5160                 call    dword ptr [ecx+$60]
005ED29B   8B8D40FDFFFF           mov     ecx, [ebp+$FFFFFD40]
005ED2A1   8D8544FDFFFF           lea     eax, [ebp+$FFFFFD44]
005ED2A7   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED2AC   E8BB7BE1FF             call    00404E6C
005ED2B1   8B9544FDFFFF           mov     edx, [ebp+$FFFFFD44]
005ED2B7   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED2BD   E8727FE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED2C2   E8395EE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED2C7   E8BC56E1FF             call    00402988
005ED2CC   8D9538FDFFFF           lea     edx, [ebp+$FFFFFD38]

* Reference to pointer to GlobalVar_0061DF08
|
005ED2D2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED2D7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05FC
|
005ED2D9   8B80FC050000           mov     eax, [eax+$05FC]
005ED2DF   8B08                   mov     ecx, [eax]
005ED2E1   FF5160                 call    dword ptr [ecx+$60]
005ED2E4   8B8D38FDFFFF           mov     ecx, [ebp+$FFFFFD38]
005ED2EA   8D853CFDFFFF           lea     eax, [ebp+$FFFFFD3C]
005ED2F0   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED2F5   E8727BE1FF             call    00404E6C
005ED2FA   8B953CFDFFFF           mov     edx, [ebp+$FFFFFD3C]
005ED300   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED306   E8297FE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED30B   E8F05DE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED310   E87356E1FF             call    00402988
005ED315   8D9530FDFFFF           lea     edx, [ebp+$FFFFFD30]

* Reference to pointer to GlobalVar_0061DF08
|
005ED31B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED320   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05A0
|
005ED322   8B80A0050000           mov     eax, [eax+$05A0]
005ED328   8B08                   mov     ecx, [eax]
005ED32A   FF5160                 call    dword ptr [ecx+$60]
005ED32D   8B8D30FDFFFF           mov     ecx, [ebp+$FFFFFD30]
005ED333   8D8534FDFFFF           lea     eax, [ebp+$FFFFFD34]
005ED339   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED33E   E8297BE1FF             call    00404E6C
005ED343   8B9534FDFFFF           mov     edx, [ebp+$FFFFFD34]
005ED349   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED34F   E8E07EE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED354   E8A75DE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED359   E82A56E1FF             call    00402988
005ED35E   8D9528FDFFFF           lea     edx, [ebp+$FFFFFD28]

* Reference to pointer to GlobalVar_0061DF08
|
005ED364   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED369   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05A4
|
005ED36B   8B80A4050000           mov     eax, [eax+$05A4]
005ED371   8B08                   mov     ecx, [eax]
005ED373   FF5160                 call    dword ptr [ecx+$60]
005ED376   8B8D28FDFFFF           mov     ecx, [ebp+$FFFFFD28]
005ED37C   8D852CFDFFFF           lea     eax, [ebp+$FFFFFD2C]
005ED382   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED387   E8E07AE1FF             call    00404E6C
005ED38C   8B952CFDFFFF           mov     edx, [ebp+$FFFFFD2C]
005ED392   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED398   E8977EE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED39D   E85E5DE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED3A2   E8E155E1FF             call    00402988
005ED3A7   8D9520FDFFFF           lea     edx, [ebp+$FFFFFD20]

* Reference to pointer to GlobalVar_0061DF08
|
005ED3AD   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED3B2   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05A8
|
005ED3B4   8B80A8050000           mov     eax, [eax+$05A8]
005ED3BA   8B08                   mov     ecx, [eax]
005ED3BC   FF5160                 call    dword ptr [ecx+$60]
005ED3BF   8B8D20FDFFFF           mov     ecx, [ebp+$FFFFFD20]
005ED3C5   8D8524FDFFFF           lea     eax, [ebp+$FFFFFD24]
005ED3CB   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED3D0   E8977AE1FF             call    00404E6C
005ED3D5   8B9524FDFFFF           mov     edx, [ebp+$FFFFFD24]
005ED3DB   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED3E1   E84E7EE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED3E6   E8155DE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED3EB   E89855E1FF             call    00402988
005ED3F0   8D9518FDFFFF           lea     edx, [ebp+$FFFFFD18]

* Reference to pointer to GlobalVar_0061DF08
|
005ED3F6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED3FB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05AC
|
005ED3FD   8B80AC050000           mov     eax, [eax+$05AC]
005ED403   8B08                   mov     ecx, [eax]
005ED405   FF5160                 call    dword ptr [ecx+$60]
005ED408   8B8D18FDFFFF           mov     ecx, [ebp+$FFFFFD18]
005ED40E   8D851CFDFFFF           lea     eax, [ebp+$FFFFFD1C]
005ED414   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED419   E84E7AE1FF             call    00404E6C
005ED41E   8B951CFDFFFF           mov     edx, [ebp+$FFFFFD1C]
005ED424   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED42A   E8057EE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED42F   E8CC5CE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED434   E84F55E1FF             call    00402988
005ED439   8D9510FDFFFF           lea     edx, [ebp+$FFFFFD10]

* Reference to pointer to GlobalVar_0061DF08
|
005ED43F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED444   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05B4
|
005ED446   8B80B4050000           mov     eax, [eax+$05B4]
005ED44C   8B08                   mov     ecx, [eax]
005ED44E   FF5160                 call    dword ptr [ecx+$60]
005ED451   8B8D10FDFFFF           mov     ecx, [ebp+$FFFFFD10]
005ED457   8D8514FDFFFF           lea     eax, [ebp+$FFFFFD14]
005ED45D   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED462   E8057AE1FF             call    00404E6C
005ED467   8B9514FDFFFF           mov     edx, [ebp+$FFFFFD14]
005ED46D   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED473   E8BC7DE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED478   E8835CE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED47D   E80655E1FF             call    00402988
005ED482   8D9508FDFFFF           lea     edx, [ebp+$FFFFFD08]

* Reference to pointer to GlobalVar_0061DF08
|
005ED488   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED48D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05BC
|
005ED48F   8B80BC050000           mov     eax, [eax+$05BC]
005ED495   8B08                   mov     ecx, [eax]
005ED497   FF5160                 call    dword ptr [ecx+$60]
005ED49A   8B8D08FDFFFF           mov     ecx, [ebp+$FFFFFD08]
005ED4A0   8D850CFDFFFF           lea     eax, [ebp+$FFFFFD0C]
005ED4A6   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED4AB   E8BC79E1FF             call    00404E6C
005ED4B0   8B950CFDFFFF           mov     edx, [ebp+$FFFFFD0C]
005ED4B6   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED4BC   E8737DE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED4C1   E83A5CE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED4C6   E8BD54E1FF             call    00402988
005ED4CB   8D9500FDFFFF           lea     edx, [ebp+$FFFFFD00]

* Reference to pointer to GlobalVar_0061DF08
|
005ED4D1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED4D6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05C0
|
005ED4D8   8B80C0050000           mov     eax, [eax+$05C0]
005ED4DE   8B08                   mov     ecx, [eax]
005ED4E0   FF5160                 call    dword ptr [ecx+$60]
005ED4E3   8B8D00FDFFFF           mov     ecx, [ebp+$FFFFFD00]
005ED4E9   8D8504FDFFFF           lea     eax, [ebp+$FFFFFD04]
005ED4EF   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED4F4   E87379E1FF             call    00404E6C
005ED4F9   8B9504FDFFFF           mov     edx, [ebp+$FFFFFD04]
005ED4FF   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED505   E82A7DE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED50A   E8F15BE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED50F   E87454E1FF             call    00402988
005ED514   8D95F8FCFFFF           lea     edx, [ebp+$FFFFFCF8]

* Reference to pointer to GlobalVar_0061DF08
|
005ED51A   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED51F   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05C4
|
005ED521   8B80C4050000           mov     eax, [eax+$05C4]
005ED527   8B08                   mov     ecx, [eax]
005ED529   FF5160                 call    dword ptr [ecx+$60]
005ED52C   8B8DF8FCFFFF           mov     ecx, [ebp+$FFFFFCF8]
005ED532   8D85FCFCFFFF           lea     eax, [ebp+$FFFFFCFC]
005ED538   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED53D   E82A79E1FF             call    00404E6C
005ED542   8B95FCFCFFFF           mov     edx, [ebp+$FFFFFCFC]
005ED548   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED54E   E8E17CE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED553   E8A85BE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED558   E82B54E1FF             call    00402988
005ED55D   8D95F0FCFFFF           lea     edx, [ebp+$FFFFFCF0]

* Reference to pointer to GlobalVar_0061DF08
|
005ED563   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED568   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05C8
|
005ED56A   8B80C8050000           mov     eax, [eax+$05C8]
005ED570   8B08                   mov     ecx, [eax]
005ED572   FF5160                 call    dword ptr [ecx+$60]
005ED575   8B8DF0FCFFFF           mov     ecx, [ebp+$FFFFFCF0]
005ED57B   8D85F4FCFFFF           lea     eax, [ebp+$FFFFFCF4]
005ED581   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED586   E8E178E1FF             call    00404E6C
005ED58B   8B95F4FCFFFF           mov     edx, [ebp+$FFFFFCF4]
005ED591   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED597   E8987CE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED59C   E85F5BE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED5A1   E8E253E1FF             call    00402988
005ED5A6   8D95E8FCFFFF           lea     edx, [ebp+$FFFFFCE8]

* Reference to pointer to GlobalVar_0061DF08
|
005ED5AC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED5B1   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05CC
|
005ED5B3   8B80CC050000           mov     eax, [eax+$05CC]
005ED5B9   8B08                   mov     ecx, [eax]
005ED5BB   FF5160                 call    dword ptr [ecx+$60]
005ED5BE   8B8DE8FCFFFF           mov     ecx, [ebp+$FFFFFCE8]
005ED5C4   8D85ECFCFFFF           lea     eax, [ebp+$FFFFFCEC]
005ED5CA   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED5CF   E89878E1FF             call    00404E6C
005ED5D4   8B95ECFCFFFF           mov     edx, [ebp+$FFFFFCEC]
005ED5DA   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED5E0   E84F7CE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED5E5   E8165BE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED5EA   E89953E1FF             call    00402988
005ED5EF   8D95E0FCFFFF           lea     edx, [ebp+$FFFFFCE0]

* Reference to pointer to GlobalVar_0061DF08
|
005ED5F5   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED5FA   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05D0
|
005ED5FC   8B80D0050000           mov     eax, [eax+$05D0]
005ED602   8B08                   mov     ecx, [eax]
005ED604   FF5160                 call    dword ptr [ecx+$60]
005ED607   8B8DE0FCFFFF           mov     ecx, [ebp+$FFFFFCE0]
005ED60D   8D85E4FCFFFF           lea     eax, [ebp+$FFFFFCE4]
005ED613   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED618   E84F78E1FF             call    00404E6C
005ED61D   8B95E4FCFFFF           mov     edx, [ebp+$FFFFFCE4]
005ED623   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED629   E8067CE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED62E   E8CD5AE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED633   E85053E1FF             call    00402988
005ED638   8D95D8FCFFFF           lea     edx, [ebp+$FFFFFCD8]

* Reference to pointer to GlobalVar_0061DF08
|
005ED63E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED643   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05D4
|
005ED645   8B80D4050000           mov     eax, [eax+$05D4]
005ED64B   8B08                   mov     ecx, [eax]
005ED64D   FF5160                 call    dword ptr [ecx+$60]
005ED650   8B8DD8FCFFFF           mov     ecx, [ebp+$FFFFFCD8]
005ED656   8D85DCFCFFFF           lea     eax, [ebp+$FFFFFCDC]
005ED65C   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED661   E80678E1FF             call    00404E6C
005ED666   8B95DCFCFFFF           mov     edx, [ebp+$FFFFFCDC]
005ED66C   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED672   E8BD7BE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED677   E8845AE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED67C   E80753E1FF             call    00402988
005ED681   8D95D0FCFFFF           lea     edx, [ebp+$FFFFFCD0]

* Reference to pointer to GlobalVar_0061DF08
|
005ED687   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED68C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05D8
|
005ED68E   8B80D8050000           mov     eax, [eax+$05D8]
005ED694   8B08                   mov     ecx, [eax]
005ED696   FF5160                 call    dword ptr [ecx+$60]
005ED699   8B8DD0FCFFFF           mov     ecx, [ebp+$FFFFFCD0]
005ED69F   8D85D4FCFFFF           lea     eax, [ebp+$FFFFFCD4]
005ED6A5   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED6AA   E8BD77E1FF             call    00404E6C
005ED6AF   8B95D4FCFFFF           mov     edx, [ebp+$FFFFFCD4]
005ED6B5   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED6BB   E8747BE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED6C0   E83B5AE1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED6C5   E8BE52E1FF             call    00402988
005ED6CA   8D95C8FCFFFF           lea     edx, [ebp+$FFFFFCC8]

* Reference to pointer to GlobalVar_0061DF08
|
005ED6D0   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED6D5   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05DC
|
005ED6D7   8B80DC050000           mov     eax, [eax+$05DC]
005ED6DD   8B08                   mov     ecx, [eax]
005ED6DF   FF5160                 call    dword ptr [ecx+$60]
005ED6E2   8B8DC8FCFFFF           mov     ecx, [ebp+$FFFFFCC8]
005ED6E8   8D85CCFCFFFF           lea     eax, [ebp+$FFFFFCCC]
005ED6EE   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED6F3   E87477E1FF             call    00404E6C
005ED6F8   8B95CCFCFFFF           mov     edx, [ebp+$FFFFFCCC]
005ED6FE   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED704   E82B7BE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED709   E8F259E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED70E   E87552E1FF             call    00402988
005ED713   8D95C0FCFFFF           lea     edx, [ebp+$FFFFFCC0]

* Reference to pointer to GlobalVar_0061DF08
|
005ED719   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED71E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_05EC
|
005ED720   8B80EC050000           mov     eax, [eax+$05EC]
005ED726   8B08                   mov     ecx, [eax]
005ED728   FF5160                 call    dword ptr [ecx+$60]
005ED72B   8B8DC0FCFFFF           mov     ecx, [ebp+$FFFFFCC0]
005ED731   8D85C4FCFFFF           lea     eax, [ebp+$FFFFFCC4]
005ED737   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED73C   E82B77E1FF             call    00404E6C
005ED741   8B95C4FCFFFF           mov     edx, [ebp+$FFFFFCC4]
005ED747   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED74D   E8E27AE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED752   E8A959E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED757   E82C52E1FF             call    00402988

* Reference to pointer to GlobalVar_0061DF08
|
005ED75C   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED761   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005ED763   8B8034050000           mov     eax, [eax+$0534]
005ED769   8B10                   mov     edx, [eax]
005ED76B   FF5258                 call    dword ptr [edx+$58]
005ED76E   8985B8FCFFFF           mov     [ebp+$FFFFFCB8], eax
005ED774   C685BCFCFFFF00         mov     byte ptr [ebp+$FFFFFCBC], $00
005ED77B   8D95B8FCFFFF           lea     edx, [ebp+$FFFFFCB8]

* Reference to pointer to GlobalVar_0061DF08
|
005ED781   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED786   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005ED788   8B80A4000000           mov     eax, [eax+$00A4]
005ED78E   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005ED790   E8CF5AEEFF             call    004D3264
005ED795   84C0                   test    al, al
005ED797   0F840F060000           jz      005EDDAC
005ED79D   E9DC050000             jmp     005EDD7E

* Reference to pointer to GlobalVar_0061DF08
|
005ED7A2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED7A7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03B4
|
005ED7A9   8B80B4030000           mov     eax, [eax+$03B4]
005ED7AF   8B10                   mov     edx, [eax]
005ED7B1   FF5258                 call    dword ptr [edx+$58]
005ED7B4   85C0                   test    eax, eax
005ED7B6   0F8E38050000           jle     005EDCF4
005ED7BC   8D95B0FCFFFF           lea     edx, [ebp+$FFFFFCB0]

* Reference to pointer to GlobalVar_0061DF08
|
005ED7C2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED7C7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03E4
|
005ED7C9   8B80E4030000           mov     eax, [eax+$03E4]
005ED7CF   8B08                   mov     ecx, [eax]
005ED7D1   FF5160                 call    dword ptr [ecx+$60]
005ED7D4   8B8DB0FCFFFF           mov     ecx, [ebp+$FFFFFCB0]
005ED7DA   8D85B4FCFFFF           lea     eax, [ebp+$FFFFFCB4]
005ED7E0   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED7E5   E88276E1FF             call    00404E6C
005ED7EA   8B95B4FCFFFF           mov     edx, [ebp+$FFFFFCB4]
005ED7F0   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED7F6   E8397AE1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED7FB   E80059E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED800   E88351E1FF             call    00402988

* Reference to pointer to GlobalVar_0061DF08
|
005ED805   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED80A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03B8
|
005ED80C   8B80B8030000           mov     eax, [eax+$03B8]
005ED812   8B10                   mov     edx, [eax]
005ED814   FF5258                 call    dword ptr [edx+$58]
005ED817   85C0                   test    eax, eax
005ED819   0F8ED7000000           jle     005ED8F6

* Reference to pointer to GlobalVar_0061DF08
|
005ED81F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED824   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03B8
|
005ED826   8B80B8030000           mov     eax, [eax+$03B8]
005ED82C   8B10                   mov     edx, [eax]
005ED82E   FF5258                 call    dword ptr [edx+$58]
005ED831   8985B8FCFFFF           mov     [ebp+$FFFFFCB8], eax
005ED837   C685BCFCFFFF00         mov     byte ptr [ebp+$FFFFFCBC], $00
005ED83E   8D95B8FCFFFF           lea     edx, [ebp+$FFFFFCB8]

* Reference to pointer to GlobalVar_0061DF08
|
005ED844   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED849   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_009C
|
005ED84B   8B809C000000           mov     eax, [eax+$009C]
005ED851   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005ED853   E80C5AEEFF             call    004D3264
005ED858   6828E15E00             push    $005EE128
005ED85D   8D95A8FCFFFF           lea     edx, [ebp+$FFFFFCA8]

* Reference to pointer to GlobalVar_0061DF08
|
005ED863   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED868   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0880
|
005ED86A   8B8080080000           mov     eax, [eax+$0880]
005ED870   8B08                   mov     ecx, [eax]
005ED872   FF5160                 call    dword ptr [ecx+$60]
005ED875   FFB5A8FCFFFF           push    dword ptr [ebp+$FFFFFCA8]
005ED87B   6834E15E00             push    $005EE134
005ED880   8D95A4FCFFFF           lea     edx, [ebp+$FFFFFCA4]

* Reference to pointer to GlobalVar_0061DF08
|
005ED886   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED88B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0884
|
005ED88D   8B8084080000           mov     eax, [eax+$0884]
005ED893   8B08                   mov     ecx, [eax]
005ED895   FF5160                 call    dword ptr [ecx+$60]
005ED898   FFB5A4FCFFFF           push    dword ptr [ebp+$FFFFFCA4]

* Possible String Reference to: ' ('
|
005ED89E   6840E15E00             push    $005EE140

* Reference to pointer to GlobalVar_0061DF08
|
005ED8A3   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED8A8   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0874
|
005ED8AA   8B8074080000           mov     eax, [eax+$0874]
005ED8B0   8B10                   mov     edx, [eax]
005ED8B2   FF5258                 call    dword ptr [edx+$58]
005ED8B5   8D95A0FCFFFF           lea     edx, [ebp+$FFFFFCA0]

* Reference to: Unit_00408494.Proc_00409950
|
005ED8BB   E890C0E1FF             call    00409950
005ED8C0   FFB5A0FCFFFF           push    dword ptr [ebp+$FFFFFCA0]
005ED8C6   684CE15E00             push    $005EE14C
005ED8CB   8D85ACFCFFFF           lea     eax, [ebp+$FFFFFCAC]
005ED8D1   BA07000000             mov     edx, $00000007

* Reference to: System.Proc_00404EE0
|
005ED8D6   E80576E1FF             call    00404EE0
005ED8DB   8B95ACFCFFFF           mov     edx, [ebp+$FFFFFCAC]
005ED8E1   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED8E7   E84879E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED8EC   E80F58E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED8F1   E89250E1FF             call    00402988
005ED8F6   8D9598FCFFFF           lea     edx, [ebp+$FFFFFC98]

* Reference to pointer to GlobalVar_0061DF08
|
005ED8FC   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED901   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03BC
|
005ED903   8B80BC030000           mov     eax, [eax+$03BC]
005ED909   8B08                   mov     ecx, [eax]
005ED90B   FF5160                 call    dword ptr [ecx+$60]
005ED90E   8B8D98FCFFFF           mov     ecx, [ebp+$FFFFFC98]
005ED914   8D859CFCFFFF           lea     eax, [ebp+$FFFFFC9C]
005ED91A   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED91F   E84875E1FF             call    00404E6C
005ED924   8B959CFCFFFF           mov     edx, [ebp+$FFFFFC9C]
005ED92A   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED930   E8FF78E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED935   E8C657E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED93A   E84950E1FF             call    00402988
005ED93F   8D9590FCFFFF           lea     edx, [ebp+$FFFFFC90]

* Reference to pointer to GlobalVar_0061DF08
|
005ED945   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED94A   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C0
|
005ED94C   8B80C0030000           mov     eax, [eax+$03C0]
005ED952   8B08                   mov     ecx, [eax]
005ED954   FF5160                 call    dword ptr [ecx+$60]
005ED957   8B8D90FCFFFF           mov     ecx, [ebp+$FFFFFC90]
005ED95D   8D8594FCFFFF           lea     eax, [ebp+$FFFFFC94]
005ED963   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED968   E8FF74E1FF             call    00404E6C
005ED96D   8B9594FCFFFF           mov     edx, [ebp+$FFFFFC94]
005ED973   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED979   E8B678E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED97E   E87D57E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED983   E80050E1FF             call    00402988
005ED988   8D9588FCFFFF           lea     edx, [ebp+$FFFFFC88]

* Reference to pointer to GlobalVar_0061DF08
|
005ED98E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED993   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C4
|
005ED995   8B80C4030000           mov     eax, [eax+$03C4]
005ED99B   8B08                   mov     ecx, [eax]
005ED99D   FF5160                 call    dword ptr [ecx+$60]
005ED9A0   8B8D88FCFFFF           mov     ecx, [ebp+$FFFFFC88]
005ED9A6   8D858CFCFFFF           lea     eax, [ebp+$FFFFFC8C]
005ED9AC   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED9B1   E8B674E1FF             call    00404E6C
005ED9B6   8B958CFCFFFF           mov     edx, [ebp+$FFFFFC8C]
005ED9BC   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005ED9C2   E86D78E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005ED9C7   E83457E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005ED9CC   E8B74FE1FF             call    00402988
005ED9D1   8D9580FCFFFF           lea     edx, [ebp+$FFFFFC80]

* Reference to pointer to GlobalVar_0061DF08
|
005ED9D7   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005ED9DC   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03C8
|
005ED9DE   8B80C8030000           mov     eax, [eax+$03C8]
005ED9E4   8B08                   mov     ecx, [eax]
005ED9E6   FF5160                 call    dword ptr [ecx+$60]
005ED9E9   8B8D80FCFFFF           mov     ecx, [ebp+$FFFFFC80]
005ED9EF   8D8584FCFFFF           lea     eax, [ebp+$FFFFFC84]
005ED9F5   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005ED9FA   E86D74E1FF             call    00404E6C
005ED9FF   8B9584FCFFFF           mov     edx, [ebp+$FFFFFC84]
005EDA05   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDA0B   E82478E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDA10   E8EB56E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDA15   E86E4FE1FF             call    00402988
005EDA1A   8D9578FCFFFF           lea     edx, [ebp+$FFFFFC78]

* Reference to pointer to GlobalVar_0061DF08
|
005EDA20   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDA25   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03CC
|
005EDA27   8B80CC030000           mov     eax, [eax+$03CC]
005EDA2D   8B08                   mov     ecx, [eax]
005EDA2F   FF5160                 call    dword ptr [ecx+$60]
005EDA32   8B8D78FCFFFF           mov     ecx, [ebp+$FFFFFC78]
005EDA38   8D857CFCFFFF           lea     eax, [ebp+$FFFFFC7C]
005EDA3E   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005EDA43   E82474E1FF             call    00404E6C
005EDA48   8B957CFCFFFF           mov     edx, [ebp+$FFFFFC7C]
005EDA4E   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDA54   E8DB77E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDA59   E8A256E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDA5E   E8254FE1FF             call    00402988
005EDA63   8D9570FCFFFF           lea     edx, [ebp+$FFFFFC70]

* Reference to pointer to GlobalVar_0061DF08
|
005EDA69   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDA6E   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D0
|
005EDA70   8B80D0030000           mov     eax, [eax+$03D0]
005EDA76   8B08                   mov     ecx, [eax]
005EDA78   FF5160                 call    dword ptr [ecx+$60]
005EDA7B   8B8D70FCFFFF           mov     ecx, [ebp+$FFFFFC70]
005EDA81   8D8574FCFFFF           lea     eax, [ebp+$FFFFFC74]
005EDA87   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005EDA8C   E8DB73E1FF             call    00404E6C
005EDA91   8B9574FCFFFF           mov     edx, [ebp+$FFFFFC74]
005EDA97   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDA9D   E89277E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDAA2   E85956E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDAA7   E8DC4EE1FF             call    00402988
005EDAAC   8D9568FCFFFF           lea     edx, [ebp+$FFFFFC68]

* Reference to pointer to GlobalVar_0061DF08
|
005EDAB2   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDAB7   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D4
|
005EDAB9   8B80D4030000           mov     eax, [eax+$03D4]
005EDABF   8B08                   mov     ecx, [eax]
005EDAC1   FF5160                 call    dword ptr [ecx+$60]
005EDAC4   8B8D68FCFFFF           mov     ecx, [ebp+$FFFFFC68]
005EDACA   8D856CFCFFFF           lea     eax, [ebp+$FFFFFC6C]
005EDAD0   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005EDAD5   E89273E1FF             call    00404E6C
005EDADA   8B956CFCFFFF           mov     edx, [ebp+$FFFFFC6C]
005EDAE0   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDAE6   E84977E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDAEB   E81056E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDAF0   E8934EE1FF             call    00402988
005EDAF5   8D9560FCFFFF           lea     edx, [ebp+$FFFFFC60]

* Reference to pointer to GlobalVar_0061DF08
|
005EDAFB   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDB00   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03D8
|
005EDB02   8B80D8030000           mov     eax, [eax+$03D8]
005EDB08   8B08                   mov     ecx, [eax]
005EDB0A   FF5160                 call    dword ptr [ecx+$60]
005EDB0D   8B8D60FCFFFF           mov     ecx, [ebp+$FFFFFC60]
005EDB13   8D8564FCFFFF           lea     eax, [ebp+$FFFFFC64]
005EDB19   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005EDB1E   E84973E1FF             call    00404E6C
005EDB23   8B9564FCFFFF           mov     edx, [ebp+$FFFFFC64]
005EDB29   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDB2F   E80077E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDB34   E8C755E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDB39   E84A4EE1FF             call    00402988
005EDB3E   8D9558FCFFFF           lea     edx, [ebp+$FFFFFC58]

* Reference to pointer to GlobalVar_0061DF08
|
005EDB44   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDB49   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03DC
|
005EDB4B   8B80DC030000           mov     eax, [eax+$03DC]
005EDB51   8B08                   mov     ecx, [eax]
005EDB53   FF5160                 call    dword ptr [ecx+$60]
005EDB56   8B8D58FCFFFF           mov     ecx, [ebp+$FFFFFC58]
005EDB5C   8D855CFCFFFF           lea     eax, [ebp+$FFFFFC5C]
005EDB62   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005EDB67   E80073E1FF             call    00404E6C
005EDB6C   8B955CFCFFFF           mov     edx, [ebp+$FFFFFC5C]
005EDB72   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDB78   E8B776E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDB7D   E87E55E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDB82   E8014EE1FF             call    00402988
005EDB87   8D9550FCFFFF           lea     edx, [ebp+$FFFFFC50]

* Reference to pointer to GlobalVar_0061DF08
|
005EDB8D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDB92   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03E0
|
005EDB94   8B80E0030000           mov     eax, [eax+$03E0]
005EDB9A   8B08                   mov     ecx, [eax]
005EDB9C   FF5160                 call    dword ptr [ecx+$60]
005EDB9F   8B8D50FCFFFF           mov     ecx, [ebp+$FFFFFC50]
005EDBA5   8D8554FCFFFF           lea     eax, [ebp+$FFFFFC54]
005EDBAB   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005EDBB0   E8B772E1FF             call    00404E6C
005EDBB5   8B9554FCFFFF           mov     edx, [ebp+$FFFFFC54]
005EDBBB   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDBC1   E86E76E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDBC6   E83555E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDBCB   E8B84DE1FF             call    00402988
005EDBD0   8D9548FCFFFF           lea     edx, [ebp+$FFFFFC48]

* Reference to pointer to GlobalVar_0061DF08
|
005EDBD6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDBDB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03E8
|
005EDBDD   8B80E8030000           mov     eax, [eax+$03E8]
005EDBE3   8B08                   mov     ecx, [eax]
005EDBE5   FF5160                 call    dword ptr [ecx+$60]
005EDBE8   8B8D48FCFFFF           mov     ecx, [ebp+$FFFFFC48]
005EDBEE   8D854CFCFFFF           lea     eax, [ebp+$FFFFFC4C]
005EDBF4   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005EDBF9   E86E72E1FF             call    00404E6C
005EDBFE   8B954CFCFFFF           mov     edx, [ebp+$FFFFFC4C]
005EDC04   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDC0A   E82576E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDC0F   E8EC54E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDC14   E86F4DE1FF             call    00402988
005EDC19   8D9540FCFFFF           lea     edx, [ebp+$FFFFFC40]

* Reference to pointer to GlobalVar_0061DF08
|
005EDC1F   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDC24   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03EC
|
005EDC26   8B80EC030000           mov     eax, [eax+$03EC]
005EDC2C   8B08                   mov     ecx, [eax]
005EDC2E   FF5160                 call    dword ptr [ecx+$60]
005EDC31   8B8D40FCFFFF           mov     ecx, [ebp+$FFFFFC40]
005EDC37   8D8544FCFFFF           lea     eax, [ebp+$FFFFFC44]
005EDC3D   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005EDC42   E82572E1FF             call    00404E6C
005EDC47   8B9544FCFFFF           mov     edx, [ebp+$FFFFFC44]
005EDC4D   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDC53   E8DC75E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDC58   E8A354E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDC5D   E8264DE1FF             call    00402988
005EDC62   8D9538FCFFFF           lea     edx, [ebp+$FFFFFC38]

* Reference to pointer to GlobalVar_0061DF08
|
005EDC68   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDC6D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F0
|
005EDC6F   8B80F0030000           mov     eax, [eax+$03F0]
005EDC75   8B08                   mov     ecx, [eax]
005EDC77   FF5160                 call    dword ptr [ecx+$60]
005EDC7A   8B8D38FCFFFF           mov     ecx, [ebp+$FFFFFC38]
005EDC80   8D853CFCFFFF           lea     eax, [ebp+$FFFFFC3C]
005EDC86   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005EDC8B   E8DC71E1FF             call    00404E6C
005EDC90   8B953CFCFFFF           mov     edx, [ebp+$FFFFFC3C]
005EDC96   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDC9C   E89375E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDCA1   E85A54E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDCA6   E8DD4CE1FF             call    00402988
005EDCAB   8D9530FCFFFF           lea     edx, [ebp+$FFFFFC30]

* Reference to pointer to GlobalVar_0061DF08
|
005EDCB1   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDCB6   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03F4
|
005EDCB8   8B80F4030000           mov     eax, [eax+$03F4]
005EDCBE   8B08                   mov     ecx, [eax]
005EDCC0   FF5160                 call    dword ptr [ecx+$60]
005EDCC3   8B8D30FCFFFF           mov     ecx, [ebp+$FFFFFC30]
005EDCC9   8D8534FCFFFF           lea     eax, [ebp+$FFFFFC34]
005EDCCF   BA28E15E00             mov     edx, $005EE128

* Reference to: System.@LStrCat3;
|
005EDCD4   E89371E1FF             call    00404E6C
005EDCD9   8B9534FCFFFF           mov     edx, [ebp+$FFFFFC34]
005EDCDF   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDCE5   E84A75E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDCEA   E81154E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDCEF   E8944CE1FF             call    00402988

* Reference to pointer to GlobalVar_0061DF08
|
005EDCF4   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDCF9   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005EDCFB   8B80A4000000           mov     eax, [eax+$00A4]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005EDD01   E8E617ECFF             call    004AF4EC

* Reference to pointer to GlobalVar_0061DF08
|
005EDD06   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDD0B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_00A4
|
005EDD0D   8B80A4000000           mov     eax, [eax+$00A4]
005EDD13   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EDD1A   0F858C000000           jnz     005EDDAC

* Reference to pointer to GlobalVar_0061DF08
|
005EDD20   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDD25   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03B4
|
005EDD27   8B80B4030000           mov     eax, [eax+$03B4]
005EDD2D   8B10                   mov     edx, [eax]
005EDD2F   FF5258                 call    dword ptr [edx+$58]
005EDD32   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005EDD34   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDD39   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005EDD3B   8B8034050000           mov     eax, [eax+$0534]
005EDD41   8B10                   mov     edx, [eax]
005EDD43   FF5258                 call    dword ptr [edx+$58]
005EDD46   3BF0                   cmp     esi, eax
005EDD48   7562                   jnz     005EDDAC
005EDD4A   BA58E15E00             mov     edx, $005EE158
005EDD4F   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDD55   E8DA74E1FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005EDD5A   E8F559E1FF             call    00403754

* Reference to: System.Proc_00402988
|
005EDD5F   E8244CE1FF             call    00402988
005EDD64   BA64E15E00             mov     edx, $005EE164
005EDD69   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDD6F   E8C074E1FF             call    00405234

* Reference to: System.@Flush(TTextRec;TTextRec):Integer;
|
005EDD74   E88753E1FF             call    00403100

* Reference to: System.Proc_00402988
|
005EDD79   E80A4CE1FF             call    00402988

* Reference to pointer to GlobalVar_0061DF08
|
005EDD7E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDD83   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_03B4
|
005EDD85   8B80B4030000           mov     eax, [eax+$03B4]
005EDD8B   8B10                   mov     edx, [eax]
005EDD8D   FF5258                 call    dword ptr [edx+$58]
005EDD90   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
005EDD92   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDD97   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005EDD99   8B8034050000           mov     eax, [eax+$0534]
005EDD9F   8B10                   mov     edx, [eax]
005EDDA1   FF5258                 call    dword ptr [edx+$58]
005EDDA4   3BF0                   cmp     esi, eax
005EDDA6   0F84F6F9FFFF           jz      005ED7A2
005EDDAC   BA58E15E00             mov     edx, $005EE158
005EDDB1   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005EDDB7   E87874E1FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005EDDBC   E89359E1FF             call    00403754

* Reference to: System.Proc_00402988
|
005EDDC1   E8C24BE1FF             call    00402988

* Reference to pointer to GlobalVar_0061DF08
|
005EDDC6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDDCB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EDDCD   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
005EDDD0   E81717ECFF             call    004AF4EC
005EDDD5   43                     inc     ebx

* Reference to pointer to GlobalVar_0061DF08
|
005EDDD6   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDDDB   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EDDDD   8B405C                 mov     eax, [eax+$5C]
005EDDE0   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005EDDE7   0F84A1ECFFFF           jz      005ECA8E
005EDDED   33C0                   xor     eax, eax
005EDDEF   5A                     pop     edx
005EDDF0   59                     pop     ecx
005EDDF1   59                     pop     ecx
005EDDF2   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '��,�����R���hK���E���'
|
005EDDF5   6810DE5E00             push    $005EDE10

* Reference to TScreen instance
|
005EDDFA   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
005EDDFF   8B00                   mov     eax, [eax]
005EDE01   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
005EDE03   E894D3E7FF             call    0046B19C
005EDE08   C3                     ret


* Reference to: System.@HandleFinally;
|
005EDE09   E9BE66E1FF             jmp     004044CC
005EDE0E   EBEA                   jmp     005EDDFA

****** END
|
005EDE10   8D852CFEFFFF           lea     eax, [ebp+$FFFFFE2C]

* Reference to: System.@Close(TTextRec;TTextRec):Integer;
|
005EDE16   E8F152E1FF             call    0040310C

* Reference to: System.Proc_00402988
|
005EDE1B   E8684BE1FF             call    00402988

* Reference to Form1
|
005EDE20   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label18 : TLabel
|
005EDE23   8B8000040000           mov     eax, [eax+$0400]
005EDE29   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005EDE2B   E8F4EAE5FF             call    0044C924

* Reference to Form1
|
005EDE30   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.Label19 : TLabel
|
005EDE33   8B8004040000           mov     eax, [eax+$0404]
005EDE39   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005EDE3B   E8E4EAE5FF             call    0044C924

* Reference to Form1
|
005EDE40   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.tabenab()
|
005EDE43   E810AAFEFF             call    005D8858

* Reference to pointer to GlobalVar_0061DF08
|
005EDE48   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDE4D   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EDE4F   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EDE52   E831EEEBFF             call    004ACC88

* Reference to pointer to GlobalVar_0061DF08
|
005EDE57   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDE5C   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EDE5E   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
005EDE61   E86E13ECFF             call    004AF1D4

* Reference to pointer to GlobalVar_0061DF08
|
005EDE66   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDE6B   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EDE6D   8B405C                 mov     eax, [eax+$5C]
005EDE70   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
005EDE72   E8E54CEEFF             call    004D2B5C
005EDE77   8B45F8                 mov     eax, [ebp-$08]
005EDE7A   8985B8FCFFFF           mov     [ebp+$FFFFFCB8], eax
005EDE80   C685BCFCFFFF00         mov     byte ptr [ebp+$FFFFFCBC], $00
005EDE87   8D95B8FCFFFF           lea     edx, [ebp+$FFFFFCB8]

* Reference to pointer to GlobalVar_0061DF08
|
005EDE8D   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDE92   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_005C
|
005EDE94   8B405C                 mov     eax, [eax+$5C]
005EDE97   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005EDE99   E8C653EEFF             call    004D3264

* Reference to pointer to GlobalVar_0061DF08
|
005EDE9E   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005EDEA3   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0080
|
005EDEA5   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Open(TDataSet);
|
005EDEAB   E8D8EDEBFF             call    004ACC88

* Reference to Form1
|
005EDEB0   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.anzeigen()
|
005EDEB3   E8E464FEFF             call    005D439C
005EDEB8   33C0                   xor     eax, eax
005EDEBA   5A                     pop     edx
005EDEBB   59                     pop     ecx
005EDEBC   59                     pop     ecx
005EDEBD   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '^[��]�'
|
005EDEC0   6818DF5E00             push    $005EDF18
005EDEC5   8D8530FCFFFF           lea     eax, [ebp+$FFFFFC30]
005EDECB   BA22000000             mov     edx, $00000022

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EDED0   E8B76CE1FF             call    00404B8C
005EDED5   8D85C0FCFFFF           lea     eax, [ebp+$FFFFFCC0]
005EDEDB   BA42000000             mov     edx, $00000042

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EDEE0   E8A76CE1FF             call    00404B8C
005EDEE5   8D85C8FDFFFF           lea     eax, [ebp+$FFFFFDC8]
005EDEEB   BA16000000             mov     edx, $00000016

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EDEF0   E8976CE1FF             call    00404B8C
005EDEF5   8D8520FEFFFF           lea     eax, [ebp+$FFFFFE20]
005EDEFB   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005EDF00   E8876CE1FF             call    00404B8C
005EDF05   8D8528FEFFFF           lea     eax, [ebp+$FFFFFE28]

* Reference to: System.@LStrClr(void;void);
|
005EDF0B   E8586CE1FF             call    00404B68
005EDF10   C3                     ret


* Reference to: System.@HandleFinally;
|
005EDF11   E9B665E1FF             jmp     004044CC
005EDF16   EBAD                   jmp     005EDEC5

****** END
|
005EDF18   5E                     pop     esi
005EDF19   5B                     pop     ebx
005EDF1A   8BE5                   mov     esp, ebp
005EDF1C   5D                     pop     ebp
005EDF1D   C3                     ret

*)*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.Label18 (TLabel); TForm1.Label19 (TLabel)
Database/provider: DB.TDataSet.DisableControls(TDataSet);; DB.TDataSet.Edit(TDataSet);;
    DB.TDataSet.EnableControls(TDataSet);; DB.TDataSet.First(TDataSet);;
    DB.TDataSet.Next(TDataSet);; DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;;
    DBTables.TTable.SetDataSource(TTable;TDataSource);
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C; OFFS_0080; OFFS_0410; OFFS_0534; OFFS_0538
Project calls: TForm1.anzeigen(); Unit_00408494.Proc_00409950; Unit_00446399.Proc_0044643C
Framework/API calls: Controls.TControl.SetText(TControl;TCaption);;
    Controls.TControl.SetVisible(TControl;Boolean);; Dialogs.Proc_004456EC;
    Forms.TScreen.SetCursor(TScreen;TCursor);;
    QControls.TGraphicControl.PaintRequest(TGraphicControl);; Screen; TScreen instance
Strings/files/dialog text: '00'; 'Ehen/Ki.ordnen'; 'mh'; 'muto'; 'vato'; 'Wenn Sie fortfahren,
    werden alle Eh
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.EhenKiordnen1Click(Sender : TObject);
begin
(*
0060D208   55                     push    ebp
0060D209   8BEC                   mov     ebp, esp
0060D20B   B915000000             mov     ecx, $00000015
0060D210   6A00                   push    $00
0060D212   6A00                   push    $00
0060D214   49                     dec     ecx
0060D215   75F9                   jnz     0060D210
0060D217   51                     push    ecx
0060D218   53                     push    ebx
0060D219   56                     push    esi
0060D21A   8BF0                   mov     esi, eax

* Reference to pointer to GlobalVar_0061DF08
|
0060D21C   8B1D3CCC6100           mov     ebx, [$0061CC3C]
0060D222   33C0                   xor     eax, eax
0060D224   55                     push    ebp
0060D225   68DBD96000             push    $0060D9DB

***** TRY
|
0060D22A   64FF30                 push    dword ptr fs:[eax]
0060D22D   648920                 mov     fs:[eax], esp
0060D230   6A00                   push    $00
0060D232   668B0DE8D96000         mov     cx, word ptr [$0060D9E8]
0060D239   33D2                   xor     edx, edx

* Possible String Reference to: 'Wenn Sie fortfahren, werden alle Eh
|                                en und Kinder nach Heirats- bzw.Geb
|                                urtsdatum neu geordnet. Dies ist si
|                                nnvoll, wenn Sie z.B. eben eine Sic
|                                herungsdatei aus AHNENWIN 4.0 einge
|                                lesen haben. Wenn Sie die Reihenfol
|                                ge der Ehen bzw. Kinder bereits neu
|                                 festgelegt haben, sollten Sie hier
|                                 abbrechen. Fortfahren ?'
|
0060D23B   B8F4D96000             mov     eax, $0060D9F4

* Reference to: Dialogs.Proc_004456EC
|
0060D240   E8A784E3FF             call    004456EC
0060D245   83F806                 cmp     eax, +$06
0060D248   0F856F070000           jnz     0060D9BD

* Reference to TScreen instance
|
0060D24E   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
0060D253   8B00                   mov     eax, [eax]
0060D255   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
0060D259   E83EDFE5FF             call    0046B19C
0060D25E   8B03                   mov     eax, [ebx]

* Reference to field TScreen.OFFS_0534
|
0060D260   8B8034050000           mov     eax, [eax+$0534]
0060D266   8B10                   mov     edx, [eax]
0060D268   FF5258                 call    dword ptr [edx+$58]
0060D26B   8945F4                 mov     [ebp-$0C], eax
0060D26E   C745F801000000         mov     dword ptr [ebp-$08], $00000001
0060D275   33D2                   xor     edx, edx

* Reference to control TForm1.Label18 : TLabel
|
0060D277   8B8600040000           mov     eax, [esi+$0400]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
0060D27D   E8B2F7E3FF             call    0044CA34

* Reference to control TForm1.Label18 : TLabel
|
0060D282   8B8600040000           mov     eax, [esi+$0400]

* Reference to: QControls.TGraphicControl.PaintRequest(TGraphicControl);
|
0060D288   E8FBFCE3FF             call    0044CF88
0060D28D   B201                   mov     dl, $01

* Reference to control TForm1.Label18 : TLabel
|
0060D28F   8B8600040000           mov     eax, [esi+$0400]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
0060D295   E88AF6E3FF             call    0044C924

* Possible String Reference to: 'Ehen/Ki.ordnen'
|
0060D29A   BA30DB6000             mov     edx, $0060DB30

* Reference to control TForm1.Label19 : TLabel
|
0060D29F   8B8604040000           mov     eax, [esi+$0404]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
0060D2A5   E88AF7E3FF             call    0044CA34
0060D2AA   B201                   mov     dl, $01

* Reference to control TForm1.Label19 : TLabel
|
0060D2AC   8B8604040000           mov     eax, [esi+$0404]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
0060D2B2   E86DF6E3FF             call    0044C924

* Reference to control TForm1.Label19 : TLabel
|
0060D2B7   8B8604040000           mov     eax, [esi+$0404]

* Reference to: QControls.TGraphicControl.PaintRequest(TGraphicControl);
|
0060D2BD   E8C6FCE3FF             call    0044CF88
0060D2C2   8B03                   mov     eax, [ebx]

* Reference to field TLabel.Hint : string
|
0060D2C4   8B8080000000           mov     eax, [eax+$0080]
0060D2CA   33D2                   xor     edx, edx

* Reference to: DBTables.TTable.SetDataSource(TTable;TDataSource);
|
0060D2CC   E8D765ECFF             call    004D38A8
0060D2D1   8B03                   mov     eax, [ebx]

* Reference to field string.OFFS_0080
|
0060D2D3   8B8080000000           mov     eax, [eax+$0080]

* Possible String Reference to: 'mh'
|
0060D2D9   BA48DB6000             mov     edx, $0060DB48

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060D2DE   E87958ECFF             call    004D2B5C
0060D2E3   8B03                   mov     eax, [ebx]
0060D2E5   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060D2EB   E8E41EEAFF             call    004AF1D4
0060D2F0   8B03                   mov     eax, [ebx]
0060D2F2   8B8010040000           mov     eax, [eax+$0410]
0060D2F8   8B10                   mov     edx, [eax]
0060D2FA   FF5258                 call    dword ptr [edx+$58]
0060D2FD   8945F0                 mov     [ebp-$10], eax
0060D300   33C0                   xor     eax, eax
0060D302   8945FC                 mov     [ebp-$04], eax
0060D305   E929010000             jmp     0060D433
0060D30A   8D55EC                 lea     edx, [ebp-$14]
0060D30D   8B45F8                 mov     eax, [ebp-$08]

* Reference to: Unit_00408494.Proc_00409950
|
0060D310   E83BC6DFFF             call    00409950
0060D315   8B55EC                 mov     edx, [ebp-$14]

* Reference to control TForm1.Label18 : TLabel
|
0060D318   8B8600040000           mov     eax, [esi+$0400]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
0060D31E   E811F7E3FF             call    0044CA34

* Reference to control TForm1.Label18 : TLabel
|
0060D323   8B8600040000           mov     eax, [esi+$0400]

* Reference to: QControls.TGraphicControl.PaintRequest(TGraphicControl);
|
0060D329   E85AFCE3FF             call    0044CF88
0060D32E   FF45F8                 inc     dword ptr [ebp-$08]
0060D331   8B03                   mov     eax, [ebx]

* Reference to field TLabel.OFFS_0410
|
0060D333   8B8010040000           mov     eax, [eax+$0410]
0060D339   8B10                   mov     edx, [eax]
0060D33B   FF5258                 call    dword ptr [edx+$58]
0060D33E   3B45F0                 cmp     eax, [ebp-$10]
0060D341   7560                   jnz     0060D3A3
0060D343   FF45FC                 inc     dword ptr [ebp-$04]
0060D346   8B03                   mov     eax, [ebx]
0060D348   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
0060D34E   E88D22EAFF             call    004AF5E0
0060D353   8D55E0                 lea     edx, [ebp-$20]

* Reference to Screen
|
0060D356   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409950
|
0060D359   E8F2C5DFFF             call    00409950
0060D35E   8B4DE0                 mov     ecx, [ebp-$20]
0060D361   8D45E4                 lea     eax, [ebp-$1C]

* Possible String Reference to: '00'
|
0060D364   BA54DB6000             mov     edx, $0060DB54

* Reference to: System.@LStrCat3;
|
0060D369   E8FE7ADFFF             call    00404E6C
0060D36E   8B45E4                 mov     eax, [ebp-$1C]
0060D371   8D4DE8                 lea     ecx, [ebp-$18]
0060D374   BA02000000             mov     edx, $00000002

* Reference to: Unit_00446399.Proc_0044643C
|
0060D379   E8BE90E3FF             call    0044643C
0060D37E   8B55E8                 mov     edx, [ebp-$18]
0060D381   8B03                   mov     eax, [ebx]
0060D383   8B8064040000           mov     eax, [eax+$0464]
0060D389   8B08                   mov     ecx, [eax]
0060D38B   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D391   8B03                   mov     eax, [ebx]
0060D393   8B8080000000           mov     eax, [eax+$0080]
0060D399   8B10                   mov     edx, [eax]
0060D39B   FF9248020000           call    dword ptr [edx+$0248]
0060D3A1   EB72                   jmp     0060D415
0060D3A3   C745FC01000000         mov     dword ptr [ebp-$04], $00000001
0060D3AA   8B03                   mov     eax, [ebx]
0060D3AC   8B8010040000           mov     eax, [eax+$0410]
0060D3B2   8B10                   mov     edx, [eax]
0060D3B4   FF5258                 call    dword ptr [edx+$58]
0060D3B7   8945F0                 mov     [ebp-$10], eax
0060D3BA   8B03                   mov     eax, [ebx]
0060D3BC   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
0060D3C2   E81922EAFF             call    004AF5E0
0060D3C7   8D55D4                 lea     edx, [ebp-$2C]

* Reference to Screen
|
0060D3CA   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409950
|
0060D3CD   E87EC5DFFF             call    00409950
0060D3D2   8B4DD4                 mov     ecx, [ebp-$2C]
0060D3D5   8D45D8                 lea     eax, [ebp-$28]

* Possible String Reference to: '00'
|
0060D3D8   BA54DB6000             mov     edx, $0060DB54

* Reference to: System.@LStrCat3;
|
0060D3DD   E88A7ADFFF             call    00404E6C
0060D3E2   8B45D8                 mov     eax, [ebp-$28]
0060D3E5   8D4DDC                 lea     ecx, [ebp-$24]
0060D3E8   BA02000000             mov     edx, $00000002

* Reference to: Unit_00446399.Proc_0044643C
|
0060D3ED   E84A90E3FF             call    0044643C
0060D3F2   8B55DC                 mov     edx, [ebp-$24]
0060D3F5   8B03                   mov     eax, [ebx]
0060D3F7   8B8064040000           mov     eax, [eax+$0464]
0060D3FD   8B08                   mov     ecx, [eax]
0060D3FF   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D405   8B03                   mov     eax, [ebx]
0060D407   8B8080000000           mov     eax, [eax+$0080]
0060D40D   8B10                   mov     edx, [eax]
0060D40F   FF9248020000           call    dword ptr [edx+$0248]
0060D415   8B03                   mov     eax, [ebx]
0060D417   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060D41D   E8CA20EAFF             call    004AF4EC
0060D422   8B03                   mov     eax, [ebx]
0060D424   8B8080000000           mov     eax, [eax+$0080]
0060D42A   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060D431   7515                   jnz     0060D448
0060D433   8B03                   mov     eax, [ebx]
0060D435   8B8080000000           mov     eax, [eax+$0080]
0060D43B   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060D442   0F84C2FEFFFF           jz      0060D30A
0060D448   8B03                   mov     eax, [ebx]
0060D44A   8B5058                 mov     edx, [eax+$58]
0060D44D   8B03                   mov     eax, [ebx]
0060D44F   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DBTables.TTable.SetDataSource(TTable;TDataSource);
|
0060D455   E84E64ECFF             call    004D38A8
0060D45A   8B03                   mov     eax, [ebx]
0060D45C   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.DisableControls(TDataSet);
|
0060D45F   E8EC12EAFF             call    004AE750
0060D464   8B03                   mov     eax, [ebx]
0060D466   8B405C                 mov     eax, [eax+$5C]

* Possible String Reference to: 'vato'
|
0060D469   BA60DB6000             mov     edx, $0060DB60

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060D46E   E8E956ECFF             call    004D2B5C
0060D473   8B03                   mov     eax, [ebx]
0060D475   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060D478   E8571DEAFF             call    004AF1D4
0060D47D   8B03                   mov     eax, [ebx]
0060D47F   8B8038050000           mov     eax, [eax+$0538]
0060D485   8B10                   mov     edx, [eax]
0060D487   FF5258                 call    dword ptr [edx+$58]
0060D48A   8945F0                 mov     [ebp-$10], eax
0060D48D   33C0                   xor     eax, eax
0060D48F   8945FC                 mov     [ebp-$04], eax
0060D492   E908020000             jmp     0060D69F
0060D497   8D55D0                 lea     edx, [ebp-$30]
0060D49A   8B45F8                 mov     eax, [ebp-$08]

* Reference to: Unit_00408494.Proc_00409950
|
0060D49D   E8AEC4DFFF             call    00409950
0060D4A2   8B55D0                 mov     edx, [ebp-$30]

* Reference to control TForm1.Label18 : TLabel
|
0060D4A5   8B8600040000           mov     eax, [esi+$0400]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
0060D4AB   E884F5E3FF             call    0044CA34

* Reference to control TForm1.Label18 : TLabel
|
0060D4B0   8B8600040000           mov     eax, [esi+$0400]

* Reference to: QControls.TGraphicControl.PaintRequest(TGraphicControl);
|
0060D4B6   E8CDFAE3FF             call    0044CF88
0060D4BB   FF45F8                 inc     dword ptr [ebp-$08]
0060D4BE   8B03                   mov     eax, [ebx]

* Reference to field TLabel.OFFS_0538
|
0060D4C0   8B8038050000           mov     eax, [eax+$0538]
0060D4C6   8B10                   mov     edx, [eax]
0060D4C8   FF5258                 call    dword ptr [edx+$58]
0060D4CB   3B45F0                 cmp     eax, [ebp-$10]
0060D4CE   0F85D2000000           jnz     0060D5A6
0060D4D4   FF45FC                 inc     dword ptr [ebp-$04]
0060D4D7   8B03                   mov     eax, [ebx]
0060D4D9   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
0060D4DC   E8FF20EAFF             call    004AF5E0
0060D4E1   8D55CC                 lea     edx, [ebp-$34]
0060D4E4   8B03                   mov     eax, [ebx]
0060D4E6   8B805C050000           mov     eax, [eax+$055C]
0060D4EC   8B08                   mov     ecx, [eax]
0060D4EE   FF5160                 call    dword ptr [ecx+$60]
0060D4F1   8B55CC                 mov     edx, [ebp-$34]
0060D4F4   8B03                   mov     eax, [ebx]
0060D4F6   8B80E0050000           mov     eax, [eax+$05E0]
0060D4FC   8B08                   mov     ecx, [eax]
0060D4FE   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D504   8D55C8                 lea     edx, [ebp-$38]
0060D507   8B03                   mov     eax, [ebx]
0060D509   8B806C050000           mov     eax, [eax+$056C]
0060D50F   8B08                   mov     ecx, [eax]
0060D511   FF5160                 call    dword ptr [ecx+$60]
0060D514   8B45C8                 mov     eax, [ebp-$38]
0060D517   50                     push    eax
0060D518   8D55C4                 lea     edx, [ebp-$3C]
0060D51B   8B03                   mov     eax, [ebx]
0060D51D   8B805C050000           mov     eax, [eax+$055C]
0060D523   8B08                   mov     ecx, [eax]
0060D525   FF5160                 call    dword ptr [ecx+$60]
0060D528   8B55C4                 mov     edx, [ebp-$3C]
0060D52B   58                     pop     eax

* Reference to: System.@LStrCmp;
|
0060D52C   E8337ADFFF             call    00404F64
0060D531   7623                   jbe     0060D556
0060D533   8D55C0                 lea     edx, [ebp-$40]
0060D536   8B03                   mov     eax, [ebx]
0060D538   8B806C050000           mov     eax, [eax+$056C]
0060D53E   8B08                   mov     ecx, [eax]
0060D540   FF5160                 call    dword ptr [ecx+$60]
0060D543   8B55C0                 mov     edx, [ebp-$40]
0060D546   8B03                   mov     eax, [ebx]
0060D548   8B80E0050000           mov     eax, [eax+$05E0]
0060D54E   8B08                   mov     ecx, [eax]
0060D550   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D556   8D55B4                 lea     edx, [ebp-$4C]
0060D559   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409950
|
0060D55C   E8EFC3DFFF             call    00409950
0060D561   8B4DB4                 mov     ecx, [ebp-$4C]
0060D564   8D45B8                 lea     eax, [ebp-$48]

* Possible String Reference to: '00'
|
0060D567   BA54DB6000             mov     edx, $0060DB54

* Reference to: System.@LStrCat3;
|
0060D56C   E8FB78DFFF             call    00404E6C
0060D571   8B45B8                 mov     eax, [ebp-$48]
0060D574   8D4DBC                 lea     ecx, [ebp-$44]
0060D577   BA02000000             mov     edx, $00000002

* Reference to: Unit_00446399.Proc_0044643C
|
0060D57C   E8BB8EE3FF             call    0044643C
0060D581   8B55BC                 mov     edx, [ebp-$44]
0060D584   8B03                   mov     eax, [ebx]
0060D586   8B80E8050000           mov     eax, [eax+$05E8]
0060D58C   8B08                   mov     ecx, [eax]
0060D58E   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D594   8B03                   mov     eax, [ebx]
0060D596   8B405C                 mov     eax, [eax+$5C]
0060D599   8B10                   mov     edx, [eax]
0060D59B   FF9248020000           call    dword ptr [edx+$0248]
0060D5A1   E9E1000000             jmp     0060D687
0060D5A6   C745FC01000000         mov     dword ptr [ebp-$04], $00000001
0060D5AD   8B03                   mov     eax, [ebx]
0060D5AF   8B8038050000           mov     eax, [eax+$0538]
0060D5B5   8B10                   mov     edx, [eax]
0060D5B7   FF5258                 call    dword ptr [edx+$58]
0060D5BA   8945F0                 mov     [ebp-$10], eax
0060D5BD   8B03                   mov     eax, [ebx]
0060D5BF   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
0060D5C2   E81920EAFF             call    004AF5E0
0060D5C7   8D55B0                 lea     edx, [ebp-$50]
0060D5CA   8B03                   mov     eax, [ebx]
0060D5CC   8B805C050000           mov     eax, [eax+$055C]
0060D5D2   8B08                   mov     ecx, [eax]
0060D5D4   FF5160                 call    dword ptr [ecx+$60]
0060D5D7   8B55B0                 mov     edx, [ebp-$50]
0060D5DA   8B03                   mov     eax, [ebx]
0060D5DC   8B80E0050000           mov     eax, [eax+$05E0]
0060D5E2   8B08                   mov     ecx, [eax]
0060D5E4   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D5EA   8D55AC                 lea     edx, [ebp-$54]
0060D5ED   8B03                   mov     eax, [ebx]
0060D5EF   8B806C050000           mov     eax, [eax+$056C]
0060D5F5   8B08                   mov     ecx, [eax]
0060D5F7   FF5160                 call    dword ptr [ecx+$60]
0060D5FA   8B45AC                 mov     eax, [ebp-$54]
0060D5FD   50                     push    eax
0060D5FE   8D55A8                 lea     edx, [ebp-$58]
0060D601   8B03                   mov     eax, [ebx]
0060D603   8B805C050000           mov     eax, [eax+$055C]
0060D609   8B08                   mov     ecx, [eax]
0060D60B   FF5160                 call    dword ptr [ecx+$60]
0060D60E   8B55A8                 mov     edx, [ebp-$58]
0060D611   58                     pop     eax

* Reference to: System.@LStrCmp;
|
0060D612   E84D79DFFF             call    00404F64
0060D617   7623                   jbe     0060D63C
0060D619   8D55A4                 lea     edx, [ebp-$5C]
0060D61C   8B03                   mov     eax, [ebx]
0060D61E   8B806C050000           mov     eax, [eax+$056C]
0060D624   8B08                   mov     ecx, [eax]
0060D626   FF5160                 call    dword ptr [ecx+$60]
0060D629   8B55A4                 mov     edx, [ebp-$5C]
0060D62C   8B03                   mov     eax, [ebx]
0060D62E   8B80E0050000           mov     eax, [eax+$05E0]
0060D634   8B08                   mov     ecx, [eax]
0060D636   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D63C   8D5598                 lea     edx, [ebp-$68]
0060D63F   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409950
|
0060D642   E809C3DFFF             call    00409950
0060D647   8B4D98                 mov     ecx, [ebp-$68]
0060D64A   8D459C                 lea     eax, [ebp-$64]

* Possible String Reference to: '00'
|
0060D64D   BA54DB6000             mov     edx, $0060DB54

* Reference to: System.@LStrCat3;
|
0060D652   E81578DFFF             call    00404E6C
0060D657   8B459C                 mov     eax, [ebp-$64]
0060D65A   8D4DA0                 lea     ecx, [ebp-$60]
0060D65D   BA02000000             mov     edx, $00000002

* Reference to: Unit_00446399.Proc_0044643C
|
0060D662   E8D58DE3FF             call    0044643C
0060D667   8B55A0                 mov     edx, [ebp-$60]
0060D66A   8B03                   mov     eax, [ebx]
0060D66C   8B80E8050000           mov     eax, [eax+$05E8]
0060D672   8B08                   mov     ecx, [eax]
0060D674   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D67A   8B03                   mov     eax, [ebx]
0060D67C   8B405C                 mov     eax, [eax+$5C]
0060D67F   8B10                   mov     edx, [eax]
0060D681   FF9248020000           call    dword ptr [edx+$0248]
0060D687   8B03                   mov     eax, [ebx]
0060D689   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060D68C   E85B1EEAFF             call    004AF4EC
0060D691   8B03                   mov     eax, [ebx]
0060D693   8B405C                 mov     eax, [eax+$5C]
0060D696   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060D69D   7512                   jnz     0060D6B1
0060D69F   8B03                   mov     eax, [ebx]
0060D6A1   8B405C                 mov     eax, [eax+$5C]
0060D6A4   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060D6AB   0F84E6FDFFFF           jz      0060D497
0060D6B1   8B03                   mov     eax, [ebx]
0060D6B3   8B405C                 mov     eax, [eax+$5C]

* Possible String Reference to: 'muto'
|
0060D6B6   BA70DB6000             mov     edx, $0060DB70

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060D6BB   E89C54ECFF             call    004D2B5C
0060D6C0   8B03                   mov     eax, [ebx]
0060D6C2   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
0060D6C5   E80A1BEAFF             call    004AF1D4
0060D6CA   8B03                   mov     eax, [ebx]
0060D6CC   8B803C050000           mov     eax, [eax+$053C]
0060D6D2   8B10                   mov     edx, [eax]
0060D6D4   FF5258                 call    dword ptr [edx+$58]
0060D6D7   8945F0                 mov     [ebp-$10], eax
0060D6DA   33C0                   xor     eax, eax
0060D6DC   8945FC                 mov     [ebp-$04], eax
0060D6DF   E953020000             jmp     0060D937
0060D6E4   8D5594                 lea     edx, [ebp-$6C]
0060D6E7   8B45F8                 mov     eax, [ebp-$08]

* Reference to: Unit_00408494.Proc_00409950
|
0060D6EA   E861C2DFFF             call    00409950
0060D6EF   8B5594                 mov     edx, [ebp-$6C]

* Reference to control TForm1.Label18 : TLabel
|
0060D6F2   8B8600040000           mov     eax, [esi+$0400]

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
0060D6F8   E837F3E3FF             call    0044CA34

* Reference to control TForm1.Label18 : TLabel
|
0060D6FD   8B8600040000           mov     eax, [esi+$0400]

* Reference to: QControls.TGraphicControl.PaintRequest(TGraphicControl);
|
0060D703   E880F8E3FF             call    0044CF88
0060D708   FF45F8                 inc     dword ptr [ebp-$08]
0060D70B   8B03                   mov     eax, [ebx]

* Reference to field TLabel.OFFS_0538
|
0060D70D   8B8038050000           mov     eax, [eax+$0538]
0060D713   8B10                   mov     edx, [eax]
0060D715   FF5258                 call    dword ptr [edx+$58]
0060D718   85C0                   test    eax, eax
0060D71A   0F85FF010000           jnz     0060D91F
0060D720   8B03                   mov     eax, [ebx]
0060D722   8B803C050000           mov     eax, [eax+$053C]
0060D728   8B10                   mov     edx, [eax]
0060D72A   FF5258                 call    dword ptr [edx+$58]
0060D72D   3B45F0                 cmp     eax, [ebp-$10]
0060D730   0F85DE000000           jnz     0060D814
0060D736   FF45FC                 inc     dword ptr [ebp-$04]
0060D739   8B03                   mov     eax, [ebx]
0060D73B   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
0060D73E   E89D1EEAFF             call    004AF5E0
0060D743   8D5590                 lea     edx, [ebp-$70]
0060D746   8B03                   mov     eax, [ebx]
0060D748   8B805C050000           mov     eax, [eax+$055C]
0060D74E   8B08                   mov     ecx, [eax]
0060D750   FF5160                 call    dword ptr [ecx+$60]
0060D753   8B5590                 mov     edx, [ebp-$70]
0060D756   8B03                   mov     eax, [ebx]
0060D758   8B80E0050000           mov     eax, [eax+$05E0]
0060D75E   8B08                   mov     ecx, [eax]
0060D760   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D766   8D558C                 lea     edx, [ebp-$74]
0060D769   8B03                   mov     eax, [ebx]
0060D76B   8B806C050000           mov     eax, [eax+$056C]
0060D771   8B08                   mov     ecx, [eax]
0060D773   FF5160                 call    dword ptr [ecx+$60]
0060D776   8B458C                 mov     eax, [ebp-$74]
0060D779   50                     push    eax
0060D77A   8D5588                 lea     edx, [ebp-$78]
0060D77D   8B03                   mov     eax, [ebx]
0060D77F   8B805C050000           mov     eax, [eax+$055C]
0060D785   8B08                   mov     ecx, [eax]
0060D787   FF5160                 call    dword ptr [ecx+$60]
0060D78A   8B5588                 mov     edx, [ebp-$78]
0060D78D   58                     pop     eax

* Reference to: System.@LStrCmp;
|
0060D78E   E8D177DFFF             call    00404F64
0060D793   7623                   jbe     0060D7B8
0060D795   8D5584                 lea     edx, [ebp-$7C]
0060D798   8B03                   mov     eax, [ebx]
0060D79A   8B806C050000           mov     eax, [eax+$056C]
0060D7A0   8B08                   mov     ecx, [eax]
0060D7A2   FF5160                 call    dword ptr [ecx+$60]
0060D7A5   8B5584                 mov     edx, [ebp-$7C]
0060D7A8   8B03                   mov     eax, [ebx]
0060D7AA   8B80E0050000           mov     eax, [eax+$05E0]
0060D7B0   8B08                   mov     ecx, [eax]
0060D7B2   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D7B8   8D9578FFFFFF           lea     edx, [ebp+$FFFFFF78]
0060D7BE   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409950
|
0060D7C1   E88AC1DFFF             call    00409950
0060D7C6   8B8D78FFFFFF           mov     ecx, [ebp+$FFFFFF78]
0060D7CC   8D857CFFFFFF           lea     eax, [ebp+$FFFFFF7C]

* Possible String Reference to: '00'
|
0060D7D2   BA54DB6000             mov     edx, $0060DB54

* Reference to: System.@LStrCat3;
|
0060D7D7   E89076DFFF             call    00404E6C
0060D7DC   8B857CFFFFFF           mov     eax, [ebp+$FFFFFF7C]
0060D7E2   8D4D80                 lea     ecx, [ebp-$80]
0060D7E5   BA02000000             mov     edx, $00000002

* Reference to: Unit_00446399.Proc_0044643C
|
0060D7EA   E84D8CE3FF             call    0044643C
0060D7EF   8B5580                 mov     edx, [ebp-$80]
0060D7F2   8B03                   mov     eax, [ebx]
0060D7F4   8B80E8050000           mov     eax, [eax+$05E8]
0060D7FA   8B08                   mov     ecx, [eax]
0060D7FC   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D802   8B03                   mov     eax, [ebx]
0060D804   8B405C                 mov     eax, [eax+$5C]
0060D807   8B10                   mov     edx, [eax]
0060D809   FF9248020000           call    dword ptr [edx+$0248]
0060D80F   E90B010000             jmp     0060D91F
0060D814   C745FC01000000         mov     dword ptr [ebp-$04], $00000001
0060D81B   8B03                   mov     eax, [ebx]
0060D81D   8B803C050000           mov     eax, [eax+$053C]
0060D823   8B10                   mov     edx, [eax]
0060D825   FF5258                 call    dword ptr [edx+$58]
0060D828   8945F0                 mov     [ebp-$10], eax
0060D82B   8B03                   mov     eax, [ebx]
0060D82D   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
0060D830   E8AB1DEAFF             call    004AF5E0
0060D835   8D9574FFFFFF           lea     edx, [ebp+$FFFFFF74]
0060D83B   8B03                   mov     eax, [ebx]
0060D83D   8B805C050000           mov     eax, [eax+$055C]
0060D843   8B08                   mov     ecx, [eax]
0060D845   FF5160                 call    dword ptr [ecx+$60]
0060D848   8B9574FFFFFF           mov     edx, [ebp+$FFFFFF74]
0060D84E   8B03                   mov     eax, [ebx]
0060D850   8B80E0050000           mov     eax, [eax+$05E0]
0060D856   8B08                   mov     ecx, [eax]
0060D858   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D85E   8D9570FFFFFF           lea     edx, [ebp+$FFFFFF70]
0060D864   8B03                   mov     eax, [ebx]
0060D866   8B806C050000           mov     eax, [eax+$056C]
0060D86C   8B08                   mov     ecx, [eax]
0060D86E   FF5160                 call    dword ptr [ecx+$60]
0060D871   8B8570FFFFFF           mov     eax, [ebp+$FFFFFF70]
0060D877   50                     push    eax
0060D878   8D956CFFFFFF           lea     edx, [ebp+$FFFFFF6C]
0060D87E   8B03                   mov     eax, [ebx]
0060D880   8B805C050000           mov     eax, [eax+$055C]
0060D886   8B08                   mov     ecx, [eax]
0060D888   FF5160                 call    dword ptr [ecx+$60]
0060D88B   8B956CFFFFFF           mov     edx, [ebp+$FFFFFF6C]
0060D891   58                     pop     eax

* Reference to: System.@LStrCmp;
|
0060D892   E8CD76DFFF             call    00404F64
0060D897   7629                   jbe     0060D8C2
0060D899   8D9568FFFFFF           lea     edx, [ebp+$FFFFFF68]
0060D89F   8B03                   mov     eax, [ebx]
0060D8A1   8B806C050000           mov     eax, [eax+$056C]
0060D8A7   8B08                   mov     ecx, [eax]
0060D8A9   FF5160                 call    dword ptr [ecx+$60]
0060D8AC   8B9568FFFFFF           mov     edx, [ebp+$FFFFFF68]
0060D8B2   8B03                   mov     eax, [ebx]
0060D8B4   8B80E0050000           mov     eax, [eax+$05E0]
0060D8BA   8B08                   mov     ecx, [eax]
0060D8BC   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D8C2   8D955CFFFFFF           lea     edx, [ebp+$FFFFFF5C]
0060D8C8   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409950
|
0060D8CB   E880C0DFFF             call    00409950
0060D8D0   8B8D5CFFFFFF           mov     ecx, [ebp+$FFFFFF5C]
0060D8D6   8D8560FFFFFF           lea     eax, [ebp+$FFFFFF60]

* Possible String Reference to: '00'
|
0060D8DC   BA54DB6000             mov     edx, $0060DB54

* Reference to: System.@LStrCat3;
|
0060D8E1   E88675DFFF             call    00404E6C
0060D8E6   8B8560FFFFFF           mov     eax, [ebp+$FFFFFF60]
0060D8EC   8D8D64FFFFFF           lea     ecx, [ebp+$FFFFFF64]
0060D8F2   BA02000000             mov     edx, $00000002

* Reference to: Unit_00446399.Proc_0044643C
|
0060D8F7   E8408BE3FF             call    0044643C
0060D8FC   8B9564FFFFFF           mov     edx, [ebp+$FFFFFF64]
0060D902   8B03                   mov     eax, [ebx]
0060D904   8B80E8050000           mov     eax, [eax+$05E8]
0060D90A   8B08                   mov     ecx, [eax]
0060D90C   FF91B0000000           call    dword ptr [ecx+$00B0]
0060D912   8B03                   mov     eax, [ebx]
0060D914   8B405C                 mov     eax, [eax+$5C]
0060D917   8B10                   mov     edx, [eax]
0060D919   FF9248020000           call    dword ptr [edx+$0248]
0060D91F   8B03                   mov     eax, [ebx]
0060D921   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0060D924   E8C31BEAFF             call    004AF4EC
0060D929   8B03                   mov     eax, [ebx]
0060D92B   8B405C                 mov     eax, [eax+$5C]
0060D92E   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060D935   7512                   jnz     0060D949
0060D937   8B03                   mov     eax, [ebx]
0060D939   8B405C                 mov     eax, [eax+$5C]
0060D93C   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0060D943   0F849BFDFFFF           jz      0060D6E4
0060D949   8B03                   mov     eax, [ebx]
0060D94B   8B405C                 mov     eax, [eax+$5C]
0060D94E   33D2                   xor     edx, edx

* Reference to: DBTables.TSession.OpenDatabase(TSession;AnsiString):TDatabase;
|
0060D950   E80752ECFF             call    004D2B5C

* Reference to Screen
|
0060D955   8B45F4                 mov     eax, [ebp-$0C]
0060D958   898554FFFFFF           mov     [ebp+$FFFFFF54], eax
0060D95E   C68558FFFFFF00         mov     byte ptr [ebp+$FFFFFF58], $00
0060D965   8D9554FFFFFF           lea     edx, [ebp+$FFFFFF54]
0060D96B   8B03                   mov     eax, [ebx]

* Reference to field Screen.OFFS_005C
|
0060D96D   8B405C                 mov     eax, [eax+$5C]
0060D970   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
0060D972   E8ED58ECFF             call    004D3264
0060D977   8B03                   mov     eax, [ebx]
0060D979   8B8080000000           mov     eax, [eax+$0080]

* Reference to: DB.TDataSet.EnableControls(TDataSet);
|
0060D97F   E8EC0DEAFF             call    004AE770
0060D984   8B03                   mov     eax, [ebx]
0060D986   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.EnableControls(TDataSet);
|
0060D989   E8E20DEAFF             call    004AE770
0060D98E   33D2                   xor     edx, edx

* Reference to control TForm1.Label18 : TLabel
|
0060D990   8B8600040000           mov     eax, [esi+$0400]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
0060D996   E889EFE3FF             call    0044C924
0060D99B   33D2                   xor     edx, edx

* Reference to control TForm1.Label19 : TLabel
|
0060D99D   8B8604040000           mov     eax, [esi+$0404]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
0060D9A3   E87CEFE3FF             call    0044C924

* Reference to TScreen instance
|
0060D9A8   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
0060D9AD   8B00                   mov     eax, [eax]
0060D9AF   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
0060D9B1   E8E6D7E5FF             call    0046B19C
0060D9B6   8BC6                   mov     eax, esi

* Reference to : TForm1.anzeigen()
|
0060D9B8   E8DF69FCFF             call    005D439C
0060D9BD   33C0                   xor     eax, eax
0060D9BF   5A                     pop     edx
0060D9C0   59                     pop     ecx
0060D9C1   59                     pop     ecx
0060D9C2   648910                 mov     fs:[eax], edx

****** FINALLY
|
0060D9C5   68E2D96000             push    $0060D9E2
0060D9CA   8D855CFFFFFF           lea     eax, [ebp+$FFFFFF5C]
0060D9D0   BA25000000             mov     edx, $00000025

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
0060D9D5   E8B271DFFF             call    00404B8C
0060D9DA   C3                     ret


* Reference to: System.@HandleFinally;
|
0060D9DB   E9EC6ADFFF             jmp     004044CC
0060D9E0   EBE8                   jmp     0060D9CA

****** END
|
0060D9E2   5E                     pop     esi
0060D9E3   5B                     pop     ebx
0060D9E4   8BE5                   mov     esp, ebp
0060D9E6   5D                     pop     ebp
0060D9E7   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.Label50 (TLabel)
Database/provider: DB.TDataSet.DisableControls(TDataSet);; DB.TDataSet.Edit(TDataSet);;
    DB.TDataSet.EnableControls(TDataSet);; DB.TDataSet.First(TDataSet);;
    DB.TDataSet.Next(TDataSet);; DB.TDataSet.Open(TDataSet);
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_005C
Project calls: Unit_00408494.Proc_00409448
Framework/API calls: Forms.TScreen.SetCursor(TScreen;TCursor);; method
    TLabel.GetFloatingDockSiteClass(); TScreen instance
Strings/files/dialog text: '[��]�'; 'Arzbach'; 'T�lz'; 'Wackersberg'; '�P�����[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.GebDatumTaufdatum1Click(Sender : TObject);
begin
(*
0061753C   55                     push    ebp
0061753D   8BEC                   mov     ebp, esp
0061753F   33C9                   xor     ecx, ecx
00617541   51                     push    ecx
00617542   51                     push    ecx
00617543   51                     push    ecx
00617544   51                     push    ecx
00617545   53                     push    ebx

* Reference to pointer to GlobalVar_0061DF08
|
00617546   8B1D3CCC6100           mov     ebx, [$0061CC3C]
0061754C   33C0                   xor     eax, eax
0061754E   55                     push    ebp

* Possible String Reference to: '�P�����[��]�'
|
0061754F   6877766100             push    $00617677

***** TRY
|
00617554   64FF30                 push    dword ptr fs:[eax]
00617557   648920                 mov     fs:[eax], esp
0061755A   8B03                   mov     eax, [ebx]

* Reference to control TForm1.Label50 : TLabel
|
0061755C   8B8034050000           mov     eax, [eax+$0534]
00617562   8B10                   mov     edx, [eax]

* Reference to method TLabel.GetFloatingDockSiteClass()
|
00617564   FF5258                 call    dword ptr [edx+$58]
00617567   8B03                   mov     eax, [ebx]

* Reference to field TLabel.OFFS_005C
|
00617569   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Open(TDataSet);
|
0061756C   E81757E9FF             call    004ACC88
00617571   8B03                   mov     eax, [ebx]
00617573   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.First(TDataSet);
|
00617576   E8597CE9FF             call    004AF1D4

* Reference to TScreen instance
|
0061757B   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
00617580   8B00                   mov     eax, [eax]
00617582   66BAF5FF               mov     dx, $FFF5

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
00617586   E8113CE5FF             call    0046B19C
0061758B   8B03                   mov     eax, [ebx]

* Reference to field TScreen.OFFS_005C
|
0061758D   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.DisableControls(TDataSet);
|
00617590   E8BB71E9FF             call    004AE750
00617595   E998000000             jmp     00617632
0061759A   8D55F8                 lea     edx, [ebp-$08]
0061759D   8B03                   mov     eax, [ebx]
0061759F   8B8070050000           mov     eax, [eax+$0570]
006175A5   8B08                   mov     ecx, [eax]
006175A7   FF5160                 call    dword ptr [ecx+$60]
006175AA   8B45F8                 mov     eax, [ebp-$08]
006175AD   8D55FC                 lea     edx, [ebp-$04]

* Reference to: Unit_00408494.Proc_00409448
|
006175B0   E8931EDFFF             call    00409448
006175B5   8B45FC                 mov     eax, [ebp-$04]

* Possible String Reference to: 'Arzbach'
|
006175B8   BA8C766100             mov     edx, $0061768C

* Reference to: System.@LStrCmp;
|
006175BD   E8A2D9DEFF             call    00404F64
006175C2   742A                   jz      006175EE
006175C4   8D55F0                 lea     edx, [ebp-$10]
006175C7   8B03                   mov     eax, [ebx]
006175C9   8B8070050000           mov     eax, [eax+$0570]
006175CF   8B08                   mov     ecx, [eax]
006175D1   FF5160                 call    dword ptr [ecx+$60]
006175D4   8B45F0                 mov     eax, [ebp-$10]
006175D7   8D55F4                 lea     edx, [ebp-$0C]

* Reference to: Unit_00408494.Proc_00409448
|
006175DA   E8691EDFFF             call    00409448
006175DF   8B45F4                 mov     eax, [ebp-$0C]

* Possible String Reference to: 'Wackersberg'
|
006175E2   BA9C766100             mov     edx, $0061769C

* Reference to: System.@LStrCmp;
|
006175E7   E878D9DEFF             call    00404F64
006175EC   752C                   jnz     0061761A
006175EE   8B03                   mov     eax, [ebx]
006175F0   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Edit(TDataSet);
|
006175F3   E8E87FE9FF             call    004AF5E0
006175F8   8B03                   mov     eax, [ebx]
006175FA   8B8070050000           mov     eax, [eax+$0570]

* Possible String Reference to: 'T�lz'
|
00617600   BAB0766100             mov     edx, $006176B0
00617605   8B08                   mov     ecx, [eax]
00617607   FF91B0000000           call    dword ptr [ecx+$00B0]
0061760D   8B03                   mov     eax, [ebx]
0061760F   8B405C                 mov     eax, [eax+$5C]
00617612   8B10                   mov     edx, [eax]
00617614   FF9248020000           call    dword ptr [edx+$0248]
0061761A   8B03                   mov     eax, [ebx]
0061761C   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.Next(TDataSet);
|
0061761F   E8C87EE9FF             call    004AF4EC
00617624   8B03                   mov     eax, [ebx]
00617626   8B405C                 mov     eax, [eax+$5C]
00617629   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
00617630   7512                   jnz     00617644
00617632   8B03                   mov     eax, [ebx]
00617634   8B405C                 mov     eax, [eax+$5C]
00617637   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
0061763E   0F8456FFFFFF           jz      0061759A
00617644   8B03                   mov     eax, [ebx]
00617646   8B405C                 mov     eax, [eax+$5C]

* Reference to: DB.TDataSet.EnableControls(TDataSet);
|
00617649   E82271E9FF             call    004AE770

* Reference to TScreen instance
|
0061764E   A1C8CC6100             mov     eax, dword ptr [$0061CCC8]
00617653   8B00                   mov     eax, [eax]
00617655   33D2                   xor     edx, edx

* Reference to: Forms.TScreen.SetCursor(TScreen;TCursor);
|
00617657   E8403BE5FF             call    0046B19C
0061765C   33C0                   xor     eax, eax
0061765E   5A                     pop     edx
0061765F   59                     pop     ecx
00617660   59                     pop     ecx
00617661   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '[��]�'
|
00617664   687E766100             push    $0061767E
00617669   8D45F0                 lea     eax, [ebp-$10]
0061766C   BA04000000             mov     edx, $00000004

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
00617671   E816D5DEFF             call    00404B8C
00617676   C3                     ret


* Reference to: System.@HandleFinally;
|
00617677   E950CEDEFF             jmp     004044CC
0061767C   EBEB                   jmp     00617669

****** END
|
0061767E   5B                     pop     ebx
0061767F   8BE5                   mov     esp, ebp
00617681   5D                     pop     ebp
00617682   C3                     ret

*)
end;

