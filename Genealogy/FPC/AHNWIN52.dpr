Program AHNWIN52;

Uses
  Unit2 in 'Unit2.pas' {TDataModule2},
  Unit15 in 'Unit15.pas' {TForm15},
  Unit5 in 'Unit5.pas' {TForm5},
  Unit38 in 'Unit38.pas' {TForm38},
  Unit33 in 'Unit33.pas' {TForm33},
  Unit14 in 'Unit14.pas' {TForm14},
  Unit17 in 'Unit17.pas' {TForm17},
  Unit18 in 'Unit18.pas' {TForm18},
  Unit27 in 'Unit27.pas' {TOKBottomDlg1},
  Unit22 in 'Unit22.pas' {TOKBottomDlg},
  Unit26 in 'Unit26.pas' {TForm26},
  Unit19 in 'Unit19.pas' {TForm19},
  Unit32 in 'Unit32.pas' {TForm32},
  Unit10 in 'Unit10.pas' {TForm10},
  Unit16 in 'Unit16.pas' {TForm16},
  Unit24 in 'Unit24.pas' {TForm24},
  Unit25 in 'Unit25.pas' {TForm25},
  Unit30 in 'Unit30.pas' {TForm30},
  Unit29 in 'Unit29.pas' {TForm29},
  Unit12 in 'Unit12.pas' {TForm12},
  Unit31 in 'Unit31.pas' {TForm31},
  Unit13 in 'Unit13.pas' {TForm13},
  Unit34 in 'Unit34.pas' {TForm34},
  Unit28 in 'Unit28.pas' {TForm28},
  Unit37 in 'Unit37.pas' {TForm37},
  Unit36 in 'Unit36.pas' {TForm36},
  Unit40 in 'Unit40.pas' {TForm40},
  Unit39 in 'Unit39.pas' {TForm39},
  Unit3 in 'Unit3.pas' {TForm3},
  PersonEntryChoiceForm in '..\Source\AhnWin52\Forms\PersonEntryChoiceForm.pas' {TPersonEntryChoiceForm},
  AboutForm in '..\Source\AhnWin52\Forms\AboutForm.pas' {TAboutForm},
  Unit11 in 'Unit11.pas' {TForm11},
  Unit23 in 'Unit23.pas' {TForm23},
  Unit21 in 'Unit21.pas' {TForm21},
  Unit20 in 'Unit20.pas' {TForm20},
  GregorianCalendar in '..\Source\AhnWin52\Forms\GregorianCalendar.pas' {TGregorianCalendarForm},
  Unit7 in 'Unit7.pas' {TForm7},
  Unit35 in 'Unit35.pas' {TForm35},
  frm_Splash in '.\Forms\frm_Splash.pas' {TFrmSplash};

{$R *.RES}

begin
{
00618528   55                     push    ebp
00618529   8BEC                   mov     ebp, esp
0061852B   83C4F0                 add     esp, -$10
0061852E   53                     push    ebx
0061852F   B870806100             mov     eax, $00618070

* Reference to: SysInit.@InitExe(Pointer);
|
00618534   E87BECDEFF             call    004071B4

* Reference to TApplication instance
|
00618539   8B1D0CC96100           mov     ebx, [$0061C90C]
0061853F   8B03                   mov     eax, [ebx]

* Reference to: Forms.TApplication.Initialize(TApplication);
|
00618541   E8624BE5FF             call    0046D0A8
00618546   8B0B                   mov     ecx, [ebx]
00618548   B201                   mov     dl, $01

* Reference to class TForm8
|
0061854A   A1DCFA5C00             mov     eax, dword ptr [$005CFADC]

* Reference to: Forms.TCustomForm.Create(TCustomForm;boolean;TComponent);
|
0061854F   E868D1E4FF             call    004656BC

* Reference to TForm8 instance
|
00618554   8B153CC46100           mov     edx, [$0061C43C]
0061855A   8902                   mov     [edx], eax

* Reference to TForm8 instance
|
0061855C   A13CC46100             mov     eax, dword ptr [$0061C43C]
00618561   8B00                   mov     eax, [eax]

* Reference to: Forms.TCustomForm.Show(TCustomForm);
|
00618563   E8D416E5FF             call    00469C3C

* Reference to TForm8 instance
|
00618568   A13CC46100             mov     eax, dword ptr [$0061C43C]
0061856D   8B00                   mov     eax, [eax]
0061856F   8B10                   mov     edx, [eax]

* Reference to method TForm8.Update()
|
00618571   FF9288000000           call    dword ptr [edx+$0088]
00618577   8B03                   mov     eax, [ebx]

* Possible String Reference to: 'AHNENWIN 5.1'
|
00618579   BA20886100             mov     edx, $00618820

* Reference to: Forms.TApplication.SetTitle(TApplication;AnsiString);
|
0061857E   E83147E5FF             call    0046CCB4

* Reference to TForm1 instance
|
00618583   8B0DD4CB6100           mov     ecx, [$0061CBD4]
00618589   8B03                   mov     eax, [ebx]

* Reference to class TForm1
|
0061858B   8B1500FD5C00           mov     edx, [$005CFD00]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618591   E82A4BE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_025353D8
|
00618596   8B0D68C86100           mov     ecx, [$0061C868]
0061859C   8B03                   mov     eax, [ebx]

* Reference to class TForm3
|
0061859E   8B15B4695700           mov     edx, [$005769B4]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006185A4   E8174BE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_02535878
|
006185A9   8B0D80C56100           mov     ecx, [$0061C580]
006185AF   8B03                   mov     eax, [ebx]

* Reference to class TForm4
|
006185B1   8B1590675C00           mov     edx, [$005C6790]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006185B7   E8044BE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061DF9C
|
006185BC   8B0D68CA6100           mov     ecx, [$0061CA68]
006185C2   8B03                   mov     eax, [ebx]

* Reference to class TForm5
|
006185C4   8B15189B5300           mov     edx, [$00539B18]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006185CA   E8F14AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_02535880
|
006185CF   8B0DD4C96100           mov     ecx, [$0061C9D4]
006185D5   8B03                   mov     eax, [ebx]

* Reference to class TForm9
|
006185D7   8B15586A5C00           mov     edx, [$005C6A58]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006185DD   E8DE4AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061E0AC
|
006185E2   8B0DD0CC6100           mov     ecx, [$0061CCD0]
006185E8   8B03                   mov     eax, [ebx]

* Reference to class TForm10
|
006185EA   8B15A09D5500           mov     edx, [$00559DA0]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006185F0   E8CB4AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_02535890
|
006185F5   8B0D24C96100           mov     ecx, [$0061C924]
006185FB   8B03                   mov     eax, [ebx]

* Reference to class TForm11
|
006185FD   8B15B86E5C00           mov     edx, [$005C6EB8]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618603   E8B84AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061E0F8
|
00618608   8B0DB0C96100           mov     ecx, [$0061C9B0]
0061860E   8B03                   mov     eax, [ebx]

* Reference to class TForm12
|
00618610   8B15D4225600           mov     edx, [$005622D4]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618616   E8A54AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061E10C
|
0061861B   8B0DD0C56100           mov     ecx, [$0061C5D0]
00618621   8B03                   mov     eax, [ebx]

* Reference to class TForm13
|
00618623   8B1540315600           mov     edx, [$00563140]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618629   E8924AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061DF10
|
0061862E   8B0DF4C76100           mov     ecx, [$0061C7F4]
00618634   8B03                   mov     eax, [ebx]

* Reference to class TForm15
|
00618636   8B151C355300           mov     edx, [$0053351C]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
0061863C   E87F4AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061E0B4
|
00618641   8B0DECC66100           mov     ecx, [$0061C6EC]
00618647   8B03                   mov     eax, [ebx]

* Reference to class TForm16
|
00618649   8B15ECB25500           mov     edx, [$0055B2EC]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
0061864F   E86C4AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061DFC8
|
00618654   8B0D9CCC6100           mov     ecx, [$0061CC9C]
0061865A   8B03                   mov     eax, [ebx]

* Reference to class TForm17
|
0061865C   8B15C8C85300           mov     edx, [$0053C8C8]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618662   E8594AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_025358DC
|
00618667   8B0D98C16100           mov     ecx, [$0061C198]
0061866D   8B03                   mov     eax, [ebx]

* Reference to class TForm20
|
0061866F   8B1544C45C00           mov     edx, [$005CC444]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618675   E8464AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_025358D4
|
0061867A   8B0DACC96100           mov     ecx, [$0061C9AC]
00618680   8B03                   mov     eax, [ebx]

* Reference to class TForm21
|
00618682   8B1578B95C00           mov     edx, [$005CB978]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618688   E8334AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061DFF4
|
0061868D   8B0DC8C76100           mov     ecx, [$0061C7C8]
00618693   8B03                   mov     eax, [ebx]

* Reference to class TOKBottomDlg
|
00618695   8B157CDD5400           mov     edx, [$0054DD7C]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
0061869B   E8204AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_025358CC
|
006186A0   8B0D48C66100           mov     ecx, [$0061C648]
006186A6   8B03                   mov     eax, [ebx]

* Reference to class TForm23
|
006186A8   8B15C8B55C00           mov     edx, [$005CB5C8]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006186AE   E80D4AE5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061E0C8
|
006186B3   8B0D30C36100           mov     ecx, [$0061C330]
006186B9   8B03                   mov     eax, [ebx]

* Reference to class TForm24
|
006186BB   8B15F4E55500           mov     edx, [$0055E5F4]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006186C1   E8FA49E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061E0D8
|
006186C6   8B0D54C86100           mov     ecx, [$0061C854]
006186CC   8B03                   mov     eax, [ebx]

* Reference to class TForm25
|
006186CE   8B15D0FA5500           mov     edx, [$0055FAD0]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006186D4   E8E749E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061DFFC
|
006186D9   8B0D80C76100           mov     ecx, [$0061C780]
006186DF   8B03                   mov     eax, [ebx]

* Reference to class TForm26
|
006186E1   8B15ACF55400           mov     edx, [$0054F5AC]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006186E7   E8D449E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061DFEC
|
006186EC   8B0DBCC46100           mov     ecx, [$0061C4BC]
006186F2   8B03                   mov     eax, [ebx]

* Reference to class TOKBottomDlg1
|
006186F4   8B15BCD85400           mov     edx, [$0054D8BC]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006186FA   E8C149E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061E104
|
006186FF   8B0DCCC56100           mov     ecx, [$0061C5CC]
00618705   8B03                   mov     eax, [ebx]

* Reference to class TForm31
|
00618707   8B15E82B5600           mov     edx, [$00562BE8]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
0061870D   E8AE49E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061E060
|
00618712   8B0D4CC66100           mov     ecx, [$0061C64C]
00618718   8B03                   mov     eax, [ebx]

* Reference to class TForm32
|
0061871A   8B15C48A5500           mov     edx, [$00558AC4]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618720   E89B49E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061DFB4
|
00618725   8B0DC8C26100           mov     ecx, [$0061C2C8]
0061872B   8B03                   mov     eax, [ebx]

* Reference to class TForm14
|
0061872D   8B15FCB65300           mov     edx, [$0053B6FC]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618733   E88849E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_02535398
|
00618738   8B0D20C26100           mov     ecx, [$0061C220]
0061873E   8B03                   mov     eax, [ebx]

* Reference to class TForm28
|
00618740   8B15BC3E5700           mov     edx, [$00573EBC]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618746   E87549E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061E0E8
|
0061874B   8B0DCCC76100           mov     ecx, [$0061C7CC]
00618751   8B03                   mov     eax, [ebx]

* Reference to class TForm29
|
00618753   8B15D8115600           mov     edx, [$005611D8]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618759   E86249E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061DFAC
|
0061875E   8B0D34C26100           mov     ecx, [$0061C234]
00618764   8B03                   mov     eax, [ebx]

* Reference to class TForm33
|
00618766   8B15BCA15300           mov     edx, [$0053A1BC]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
0061876C   E84F49E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_02535390
|
00618771   8B0DE4CA6100           mov     ecx, [$0061CAE4]
00618777   8B03                   mov     eax, [ebx]

* Reference to class TForm34
|
00618779   8B1568395700           mov     edx, [$00573968]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
0061877F   E83C49E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_025358F8
|
00618784   8B0D24C46100           mov     ecx, [$0061C424]
0061878A   8B03                   mov     eax, [ebx]

* Reference to class TForm35
|
0061878C   8B1564F35C00           mov     edx, [$005CF364]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618792   E82949E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_025353B0
|
00618797   8B0D44C36100           mov     ecx, [$0061C344]
0061879D   8B03                   mov     eax, [ebx]

* Reference to class TForm36
|
0061879F   8B15DC4F5700           mov     edx, [$00574FDC]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006187A5   E81649E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_025353A8
|
006187AA   8B0D40C96100           mov     ecx, [$0061C940]
006187B0   8B03                   mov     eax, [ebx]

* Reference to class TForm37
|
006187B2   8B15104B5700           mov     edx, [$00574B10]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006187B8   E80349E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061E0E0
|
006187BD   8B0D64C96100           mov     ecx, [$0061C964]
006187C3   8B03                   mov     eax, [ebx]

* Reference to class TForm30
|
006187C5   8B15DCFD5500           mov     edx, [$0055FDDC]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006187CB   E8F048E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_0061DFA4
|
006187D0   8B0D00CA6100           mov     ecx, [$0061CA00]
006187D6   8B03                   mov     eax, [ebx]

* Reference to class TForm38
|
006187D8   8B15C49E5300           mov     edx, [$00539EC4]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006187DE   E8DD48E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_025353C8
|
006187E3   8B0D8CC36100           mov     ecx, [$0061C38C]
006187E9   8B03                   mov     eax, [ebx]

* Reference to class TForm39
|
006187EB   8B15585F5700           mov     edx, [$00575F58]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
006187F1   E8CA48E5FF             call    0046D0C0

* Reference to pointer to GlobalVar_025353C0
|
006187F6   8B0DA4C66100           mov     ecx, [$0061C6A4]
006187FC   8B03                   mov     eax, [ebx]

* Reference to class TForm40
|
006187FE   8B155C5A5700           mov     edx, [$00575A5C]

* Reference to: Forms.TApplication.CreateForm(TApplication;TComponentClass;void;void);
|
00618804   E8B748E5FF             call    0046D0C0
00618809   8B03                   mov     eax, [ebx]

* Reference to: Forms.TApplication.Run(TApplication);
|
0061880B   E83049E5FF             call    0046D140
00618810   5B                     pop     ebx

* Reference to: System.@Halt0;
|
00618811   E862C2DEFF             call    00404A78
00618816   0000                   add     [eax], al

}
end.
