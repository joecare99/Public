{ TForm1 menu-area implementations: CalendarAndPictures; LFM-bound method names remain on TForm1. }

procedure TForm1.GregorianischerKalender1Click(Sender : TObject);
begin
  ExecuteGregorianCalendarMenuAction(BuildCalendarMenuActions, Sender);
end;

procedure TForm1.ActivateCalendarEditTab;
begin
  PageControl1.ActivePage := TabSheet2;
end;

procedure TForm1.SaveBeforeCalendar(Sender: TObject);
begin
  speich1(Sender);
end;

function TForm1.CreateGregorianCalendarForm: TGregorianCalendarForm;
begin
  Result := TGregorianCalendarForm.Create(Self);
end;

procedure TForm1.ConfigureGregorianCalendarForm(
  CalendarForm: TGregorianCalendarForm);
begin
  CalendarForm.ViewModel := TGregorianCalendarViewModel.Create;
end;

procedure TForm1.ShowGregorianCalendarForm(
  CalendarForm: TGregorianCalendarForm);
begin
  CalendarForm.ShowModal;
end;

procedure TForm1.DisposeGregorianCalendarForm(
  CalendarForm: TGregorianCalendarForm);
begin
  CalendarForm.Free;
end;

function TForm1.BuildCalendarMenuActions: TCalendarMenuActions;
begin
  Result.ActivateEditTab := @ActivateCalendarEditTab;
  Result.SaveCurrentRecord := @SaveBeforeCalendar;
  Result.CreateGregorianForm := @CreateGregorianCalendarForm;
  Result.ConfigureGregorianForm := @ConfigureGregorianCalendarForm;
  Result.ShowGregorianForm := @ShowGregorianCalendarForm;
  Result.DisposeGregorianForm := @DisposeGregorianCalendarForm;
  Result.CreateFrenchForm := @CreateFrenchRepublicanCalendarForm;
  Result.AssignFrenchFormReference := @AssignFrenchCalendarFormReference;
  Result.ShowFrenchForm := @ShowFrenchRepublicanCalendarForm;
  Result.ReleaseFrenchForm := @ReleaseFrenchRepublicanCalendarForm;
  Result.ClearFrenchFormReference := @ClearFrenchCalendarFormReference;
end;

function TForm1.CreateFrenchRepublicanCalendarForm:
  TFrenchRepublicanCalendarForm;
begin
  Result := TFrenchRepublicanCalendarForm.Create(Self);
end;

procedure TForm1.AssignFrenchCalendarFormReference(
  CalendarForm: TFrenchRepublicanCalendarForm);
begin
  FrenchRepublicanCalendarForm.Form7 := CalendarForm;
end;

procedure TForm1.ShowFrenchRepublicanCalendarForm(
  CalendarForm: TFrenchRepublicanCalendarForm);
begin
  CalendarForm.ShowModal;
end;

procedure TForm1.ReleaseFrenchRepublicanCalendarForm(
  CalendarForm: TFrenchRepublicanCalendarForm);
begin
  CalendarForm.Release;
end;

procedure TForm1.ClearFrenchCalendarFormReference;
begin
  FrenchRepublicanCalendarForm.Form7 := nil;
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_025358F0
Unresolved field offsets: OFFS_00E8
Project calls: class TForm7 (reconstructed as TFrenchRepublicanCalendarForm); TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Forms.TCustomForm.Create(TCustomForm;boolean;TComponent);;
    Forms.TCustomForm.Release(TCustomForm)
Strings/files/dialog text: '[]Í@'; '�X����[]Í@'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.FrzRevolutionskalender1Click(Sender : TObject);
begin
  ExecuteFrenchCalendarMenuAction(BuildCalendarMenuActions, Sender);
(* 
005EEBDC   55                     push    ebp
005EEBDD   8BEC                   mov     ebp, esp
005EEBDF   53                     push    ebx
005EEBE0   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005EEBE2   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005EEBE8   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005EEBEE   E8C511E9FF             call    0047FDB8
005EEBF3   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005EEBF5   E8A28DFEFF             call    005D799C
005EEBFA   8BCB                   mov     ecx, ebx
005EEBFC   B201                   mov     dl, $01

* Reference to class TForm7 (reconstructed as TFrenchRepublicanCalendarForm)
|
005EEBFE   A150E65C00             mov     eax, dword ptr [$005CE650]

* Reference to: Forms.TCustomForm.Create(TCustomForm;boolean;TComponent);
|
005EEC03   E8B46AE7FF             call    004656BC

* Reference to pointer to GlobalVar_025358F0
|
005EEC08   8B15B0C36100           mov     edx, [$0061C3B0]
005EEC0E   8902                   mov     [edx], eax
005EEC10   33C0                   xor     eax, eax
005EEC12   55                     push    ebp

* Possible String Reference to: '�X����[]Í@'
|
005EEC13   6847EC5E00             push    $005EEC47

***** TRY
|
005EEC18   64FF30                 push    dword ptr fs:[eax]
005EEC1B   648920                 mov     fs:[eax], esp

* Reference to pointer to GlobalVar_025358F0
|
005EEC1E   A1B0C36100             mov     eax, dword ptr [$0061C3B0]
005EEC23   8B00                   mov     eax, [eax]
005EEC25   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_025358F0.OFFS_00E8
|
005EEC27   FF92E8000000           call    dword ptr [edx+$00E8]
005EEC2D   33C0                   xor     eax, eax
005EEC2F   5A                     pop     edx
005EEC30   59                     pop     ecx
005EEC31   59                     pop     ecx
005EEC32   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '[]Í@'
|
005EEC35   684EEC5E00             push    $005EEC4E

* Reference to pointer to GlobalVar_025358F0
|
005EEC3A   A1B0C36100             mov     eax, dword ptr [$0061C3B0]
005EEC3F   8B00                   mov     eax, [eax]

* Reference to: Forms.TCustomForm.Release(TCustomForm);
|
005EEC41   E88AB0E7FF             call    00469CD0
005EEC46   C3                     ret


* Reference to: System.@HandleFinally;
|
005EEC47   E98058E1FF             jmp     004044CC
005EEC4C   EBEC                   jmp     005EEC3A

****** END
|
005EEC4E   5B                     pop     ebx
005EEC4F   5D                     pop     ebp
005EEC50   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Global state: GlobalVar_0061E0AC
Unresolved field offsets: OFFS_00E8
Project calls: TForm1.speich1()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
Strings/files/dialog text: 'Oster'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.Osterberechnung1Click(Sender : TObject);
begin
(*
005F9550   53                     push    ebx
005F9551   8BD8                   mov     ebx, eax
005F9553   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'Oster'
|
005F9558   BA94955F00             mov     edx, $005F9594

* Reference to: System.@LStrAsg(void;void;void;void);
|
005F955D   E85AB6E0FF             call    00404BBC

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005F9562   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005F9568   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005F956E   E84568E8FF             call    0047FDB8
005F9573   8BC3                   mov     eax, ebx

* Reference to : TForm1.speich1()
|
005F9575   E822E4FDFF             call    005D799C

* Reference to pointer to GlobalVar_0061E0AC
|
005F957A   A1D0CC6100             mov     eax, dword ptr [$0061CCD0]
005F957F   8B00                   mov     eax, [eax]
005F9581   8B10                   mov     edx, [eax]

* Possible reference to virtual method TGlobalVar_0061E0AC.OFFS_00E8
|
005F9583   FF92E8000000           call    dword ptr [edx+$00E8]
005F9589   5B                     pop     ebx
005F958A   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: Image2 (TImage); Label7 (TLabel); Label8 (TLabel); Shape1 (TShape); TForm1.PageControl1
    (TPageControl); TForm1.TabSheet2 (TTabSheet); Timer1 (N.A.); Form1
Database/provider: DB.TDataSet.First(TDataSet);;
    DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
Global state: GlobalVar_0061DF08; GlobalVar_0061E0AC
Unresolved field offsets: OFFS_0324
Project calls: TForm1.Browser(); TForm1.speich1(); Unit_00408494.Proc_0040BC38;
    Unit_00408494.Proc_0040C84C
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetText(TControl;TCaption);; Controls.TControl.SetVisible(TControl;Boolean);;
    System.Proc_00402988; System.Proc_00404EE0
Strings/files/dialog text: '.</tabcnt>'; '.</tabcnt></tblcnt>'; '<!--Converted from AHNENWIN 5.1
    (20; '</tab>'; '</tbcnt>'; '<?xml version="1.0" encoding="ISO-8; '<?xml-StyleSheet
    type="text/css" hr; '<HR></HR>'; '<strich></strich>'; '<tab>'; '<tabcnt>'; '<tbcnt>';
    '<tblcnt><tab>'; '<ues>Christliche Namenstage</ues>'; 'AHNENWIN 5.1 / '; 'CHNT'; 'chnt.xml';
    'Christliche Namenstage'; 'style.css" ?>'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.ChristlicheNamenstage1Click(Sender : TObject);
begin
(*
005F959C   55                     push    ebp
005F959D   8BEC                   mov     ebp, esp
005F959F   B90D000000             mov     ecx, $0000000D
005F95A4   6A00                   push    $00
005F95A6   6A00                   push    $00
005F95A8   49                     dec     ecx
005F95A9   75F9                   jnz     005F95A4
005F95AB   53                     push    ebx
005F95AC   56                     push    esi
005F95AD   57                     push    edi
005F95AE   8955F8                 mov     [ebp-$08], edx
005F95B1   8945FC                 mov     [ebp-$04], eax

* Reference to pointer to GlobalVar_0061DF08
|
005F95B4   8B1D3CCC6100           mov     ebx, [$0061CC3C]
005F95BA   BE60595302             mov     esi, $02535960
005F95BF   33C0                   xor     eax, eax
005F95C1   55                     push    ebp
005F95C2   68929A5F00             push    $005F9A92

***** TRY
|
005F95C7   64FF30                 push    dword ptr fs:[eax]
005F95CA   648920                 mov     fs:[eax], esp
005F95CD   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'CHNT'
|
005F95D2   BAA89A5F00             mov     edx, $005F9AA8

* Reference to: System.@LStrAsg(void;void;void;void);
|
005F95D7   E8E0B5E0FF             call    00404BBC

* Reference to Form1
|
005F95DC   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005F95DF   8B9040030000           mov     edx, [eax+$0340]

* Reference to Form1
|
005F95E5   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TForm1.PageControl1 : TPageControl
|
005F95E8   8B8038030000           mov     eax, [eax+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005F95EE   E8C567E8FF             call    0047FDB8

* Reference to Form1
|
005F95F3   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.speich1()
|
005F95F6   E8A1E3FDFF             call    005D799C

* Possible String Reference to: 'chnt.xml'
|
005F95FB   BAB89A5F00             mov     edx, $005F9AB8
005F9600   8BC6                   mov     eax, esi

* Reference to: System.@Assign(TTextRec;TTextRec;String):Integer;
|
005F9602   E83D9AE0FF             call    00403044
005F9607   8BC6                   mov     eax, esi

* Reference to: System.@RewritText(TTextRec;TTextRec):Integer;
|
005F9609   E8D297E0FF             call    00402DE0

* Reference to: System.Proc_00402988
|
005F960E   E87593E0FF             call    00402988

* Possible String Reference to: '<?xml version="1.0" encoding="ISO-8
|                                859-1"?>'
|
005F9613   BACC9A5F00             mov     edx, $005F9ACC
005F9618   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F961A   E815BCE0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F961F   E830A1E0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F9624   E85F93E0FF             call    00402988

* Possible String Reference to: '<?xml-StyleSheet type="text/css" hr
|                                ef="'
|
005F9629   68009B5F00             push    $005F9B00
005F962E   FF359C5B5302           push    dword ptr [$02535B9C]

* Possible String Reference to: 'style.css" ?>'
|
005F9634   68309B5F00             push    $005F9B30
005F9639   8D45E8                 lea     eax, [ebp-$18]
005F963C   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005F9641   E89AB8E0FF             call    00404EE0
005F9646   8B55E8                 mov     edx, [ebp-$18]
005F9649   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F964B   E8E4BBE0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F9650   E8FFA0E0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F9655   E82E93E0FF             call    00402988

* Possible String Reference to: '<!--Converted from AHNENWIN 5.1 (20
|                                13) by Heribert Reitmeier-->'
|
005F965A   BA489B5F00             mov     edx, $005F9B48
005F965F   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F9661   E8CEBBE0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F9666   E8E9A0E0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F966B   E81893E0FF             call    00402988

* Possible String Reference to: '<tbcnt>'
|
005F9670   BA909B5F00             mov     edx, $005F9B90
005F9675   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F9677   E8B8BBE0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F967C   E8D3A0E0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F9681   E80293E0FF             call    00402988

* Possible String Reference to: '<ues>Christliche Namenstage</ues>'
|
005F9686   BAA09B5F00             mov     edx, $005F9BA0
005F968B   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F968D   E8A2BBE0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F9692   E8BDA0E0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F9697   E8EC92E0FF             call    00402988

* Possible String Reference to: '<strich></strich>'
|
005F969C   BACC9B5F00             mov     edx, $005F9BCC
005F96A1   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F96A3   E88CBBE0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F96A8   E8A7A0E0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F96AD   E8D692E0FF             call    00402988
005F96B2   8B03                   mov     eax, [ebx]
005F96B4   8B80B0000000           mov     eax, [eax+$00B0]

* Reference to: DB.TDataSet.First(TDataSet);
|
005F96BA   E8155BEBFF             call    004AF1D4
005F96BF   8B03                   mov     eax, [ebx]
005F96C1   8B80B0000000           mov     eax, [eax+$00B0]
005F96C7   8B10                   mov     edx, [eax]
005F96C9   FF924C010000           call    dword ptr [edx+$014C]
005F96CF   8945F4                 mov     [ebp-$0C], eax
005F96D2   BF01000000             mov     edi, $00000001
005F96D7   DB45F4                 fild    dword ptr [ebp-$0C]
005F96DA   D835E09B5F00           fdiv    dword ptr [$005F9BE0]

* Reference to: System.@ROUND;
|
005F96E0   E84B96E0FF             call    00402D30
005F96E5   40                     inc     eax
005F96E6   8945F0                 mov     [ebp-$10], eax
005F96E9   DB45F4                 fild    dword ptr [ebp-$0C]
005F96EC   D835E09B5F00           fdiv    dword ptr [$005F9BE0]

* Reference to: System.@ROUND;
|
005F96F2   E83996E0FF             call    00402D30
005F96F7   03C0                   add     eax, eax
005F96F9   40                     inc     eax
005F96FA   8945EC                 mov     [ebp-$14], eax
005F96FD   E925020000             jmp     005F9927
005F9702   897DE0                 mov     [ebp-$20], edi
005F9705   C645E400               mov     byte ptr [ebp-$1C], $00
005F9709   8D55E0                 lea     edx, [ebp-$20]
005F970C   8B03                   mov     eax, [ebx]
005F970E   8B80B0000000           mov     eax, [eax+$00B0]
005F9714   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005F9716   E8499BEDFF             call    004D3264

* Possible String Reference to: '<tblcnt><tab>'
|
005F971B   68EC9B5F00             push    $005F9BEC
005F9720   8D55D8                 lea     edx, [ebp-$28]
005F9723   8B03                   mov     eax, [ebx]
005F9725   8B80B8000000           mov     eax, [eax+$00B8]
005F972B   8B08                   mov     ecx, [eax]
005F972D   FF5160                 call    dword ptr [ecx+$60]
005F9730   FF75D8                 push    dword ptr [ebp-$28]

* Possible String Reference to: '</tab>'
|
005F9733   68049C5F00             push    $005F9C04
005F9738   8D45DC                 lea     eax, [ebp-$24]
005F973B   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005F9740   E89BB7E0FF             call    00404EE0
005F9745   8B55DC                 mov     edx, [ebp-$24]
005F9748   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F974A   E8E5BAE0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F974F   E800A0E0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F9754   E82F92E0FF             call    00402988

* Possible String Reference to: '<tabcnt>'
|
005F9759   68149C5F00             push    $005F9C14
005F975E   8D55D0                 lea     edx, [ebp-$30]
005F9761   8B03                   mov     eax, [ebx]
005F9763   8B80BC000000           mov     eax, [eax+$00BC]
005F9769   8B08                   mov     ecx, [eax]
005F976B   FF5160                 call    dword ptr [ecx+$60]
005F976E   FF75D0                 push    dword ptr [ebp-$30]
005F9771   68289C5F00             push    $005F9C28
005F9776   8D55CC                 lea     edx, [ebp-$34]
005F9779   8B03                   mov     eax, [ebx]
005F977B   8B80C0000000           mov     eax, [eax+$00C0]
005F9781   8B08                   mov     ecx, [eax]
005F9783   FF5160                 call    dword ptr [ecx+$60]
005F9786   FF75CC                 push    dword ptr [ebp-$34]

* Possible String Reference to: '.</tabcnt>'
|
005F9789   68349C5F00             push    $005F9C34
005F978E   8D45D4                 lea     eax, [ebp-$2C]
005F9791   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005F9796   E845B7E0FF             call    00404EE0
005F979B   8B55D4                 mov     edx, [ebp-$2C]
005F979E   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F97A0   E88FBAE0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F97A5   E8AA9FE0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F97AA   E8D991E0FF             call    00402988
005F97AF   47                     inc     edi
005F97B0   8B45F0                 mov     eax, [ebp-$10]
005F97B3   8945E0                 mov     [ebp-$20], eax
005F97B6   C645E400               mov     byte ptr [ebp-$1C], $00
005F97BA   8D55E0                 lea     edx, [ebp-$20]
005F97BD   8B03                   mov     eax, [ebx]
005F97BF   8B80B0000000           mov     eax, [eax+$00B0]
005F97C5   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005F97C7   E8989AEDFF             call    004D3264

* Possible String Reference to: '<tab>'
|
005F97CC   68489C5F00             push    $005F9C48
005F97D1   8D55C4                 lea     edx, [ebp-$3C]
005F97D4   8B03                   mov     eax, [ebx]
005F97D6   8B80B8000000           mov     eax, [eax+$00B8]
005F97DC   8B08                   mov     ecx, [eax]
005F97DE   FF5160                 call    dword ptr [ecx+$60]
005F97E1   FF75C4                 push    dword ptr [ebp-$3C]

* Possible String Reference to: '</tab>'
|
005F97E4   68049C5F00             push    $005F9C04
005F97E9   8D45C8                 lea     eax, [ebp-$38]
005F97EC   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005F97F1   E8EAB6E0FF             call    00404EE0
005F97F6   8B55C8                 mov     edx, [ebp-$38]
005F97F9   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F97FB   E834BAE0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F9800   E84F9FE0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F9805   E87E91E0FF             call    00402988

* Possible String Reference to: '<tabcnt>'
|
005F980A   68149C5F00             push    $005F9C14
005F980F   8D55BC                 lea     edx, [ebp-$44]
005F9812   8B03                   mov     eax, [ebx]
005F9814   8B80BC000000           mov     eax, [eax+$00BC]
005F981A   8B08                   mov     ecx, [eax]
005F981C   FF5160                 call    dword ptr [ecx+$60]
005F981F   FF75BC                 push    dword ptr [ebp-$44]
005F9822   68289C5F00             push    $005F9C28
005F9827   8D55B8                 lea     edx, [ebp-$48]
005F982A   8B03                   mov     eax, [ebx]
005F982C   8B80C0000000           mov     eax, [eax+$00C0]
005F9832   8B08                   mov     ecx, [eax]
005F9834   FF5160                 call    dword ptr [ecx+$60]
005F9837   FF75B8                 push    dword ptr [ebp-$48]

* Possible String Reference to: '.</tabcnt>'
|
005F983A   68349C5F00             push    $005F9C34
005F983F   8D45C0                 lea     eax, [ebp-$40]
005F9842   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005F9847   E894B6E0FF             call    00404EE0
005F984C   8B55C0                 mov     edx, [ebp-$40]
005F984F   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F9851   E8DEB9E0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F9856   E8F99EE0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F985B   E82891E0FF             call    00402988
005F9860   FF45F0                 inc     dword ptr [ebp-$10]
005F9863   8B45EC                 mov     eax, [ebp-$14]
005F9866   8945E0                 mov     [ebp-$20], eax
005F9869   C645E400               mov     byte ptr [ebp-$1C], $00
005F986D   8D55E0                 lea     edx, [ebp-$20]
005F9870   8B03                   mov     eax, [ebx]
005F9872   8B80B0000000           mov     eax, [eax+$00B0]
005F9878   33C9                   xor     ecx, ecx

* Reference to: DBTables.TTable.FindKey(TTable;arrayofTVarRec;arrayofTVarRec;0..-1):Boolean;
|
005F987A   E8E599EDFF             call    004D3264

* Possible String Reference to: '<tab>'
|
005F987F   68489C5F00             push    $005F9C48
005F9884   8D55B0                 lea     edx, [ebp-$50]
005F9887   8B03                   mov     eax, [ebx]
005F9889   8B80B8000000           mov     eax, [eax+$00B8]
005F988F   8B08                   mov     ecx, [eax]
005F9891   FF5160                 call    dword ptr [ecx+$60]
005F9894   FF75B0                 push    dword ptr [ebp-$50]

* Possible String Reference to: '</tab>'
|
005F9897   68049C5F00             push    $005F9C04
005F989C   8D45B4                 lea     eax, [ebp-$4C]
005F989F   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005F98A4   E837B6E0FF             call    00404EE0
005F98A9   8B55B4                 mov     edx, [ebp-$4C]
005F98AC   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F98AE   E881B9E0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F98B3   E89C9EE0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F98B8   E8CB90E0FF             call    00402988

* Possible String Reference to: '<tabcnt>'
|
005F98BD   68149C5F00             push    $005F9C14
005F98C2   8D55A8                 lea     edx, [ebp-$58]
005F98C5   8B03                   mov     eax, [ebx]
005F98C7   8B80BC000000           mov     eax, [eax+$00BC]
005F98CD   8B08                   mov     ecx, [eax]
005F98CF   FF5160                 call    dword ptr [ecx+$60]
005F98D2   FF75A8                 push    dword ptr [ebp-$58]
005F98D5   68289C5F00             push    $005F9C28
005F98DA   8D55A4                 lea     edx, [ebp-$5C]
005F98DD   8B03                   mov     eax, [ebx]
005F98DF   8B80C0000000           mov     eax, [eax+$00C0]
005F98E5   8B08                   mov     ecx, [eax]
005F98E7   FF5160                 call    dword ptr [ecx+$60]
005F98EA   FF75A4                 push    dword ptr [ebp-$5C]

* Possible String Reference to: '.</tabcnt></tblcnt>'
|
005F98ED   68589C5F00             push    $005F9C58
005F98F2   8D45AC                 lea     eax, [ebp-$54]
005F98F5   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005F98FA   E8E1B5E0FF             call    00404EE0
005F98FF   8B55AC                 mov     edx, [ebp-$54]
005F9902   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F9904   E82BB9E0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F9909   E8469EE0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F990E   E87590E0FF             call    00402988
005F9913   FF45EC                 inc     dword ptr [ebp-$14]
005F9916   8B03                   mov     eax, [ebx]
005F9918   8B80B0000000           mov     eax, [eax+$00B0]
005F991E   80B8A100000000         cmp     byte ptr [eax+$00A1], $00
005F9925   752E                   jnz     005F9955
005F9927   DB45F4                 fild    dword ptr [ebp-$0C]
005F992A   D835E09B5F00           fdiv    dword ptr [$005F9BE0]

* Reference to: System.@ROUND;
|
005F9930   E8FB93E0FF             call    00402D30
005F9935   52                     push    edx
005F9936   50                     push    eax
005F9937   8BC7                   mov     eax, edi
005F9939   99                     cdq
005F993A   3B542404               cmp     edx, [esp+$04]
005F993E   750D                   jnz     005F994D
005F9940   3B0424                 cmp     eax, [esp]
005F9943   5A                     pop     edx
005F9944   58                     pop     eax
005F9945   0F86B7FDFFFF           jbe     005F9702
005F994B   EB08                   jmp     005F9955
005F994D   5A                     pop     edx
005F994E   58                     pop     eax
005F994F   0F8EADFDFFFF           jle     005F9702

* Possible String Reference to: '<HR></HR>'
|
005F9955   BA749C5F00             mov     edx, $005F9C74
005F995A   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F995C   E8D3B8E0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F9961   E8EE9DE0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F9966   E81D90E0FF             call    00402988

* Reference to: Unit_00408494.Proc_0040BC38
|
005F996B   E8C822E1FF             call    0040BC38
005F9970   83C4F8                 add     esp, -$08
005F9973   DD1C24                 fstp    qword ptr [esp]
005F9976   9B                     wait
005F9977   8D459C                 lea     eax, [ebp-$64]

* Reference to: Unit_00408494.Proc_0040C84C
|
005F997A   E8CD2EE1FF             call    0040C84C
005F997F   8B4D9C                 mov     ecx, [ebp-$64]
005F9982   8D45A0                 lea     eax, [ebp-$60]

* Possible String Reference to: 'AHNENWIN 5.1 / '
|
005F9985   BA889C5F00             mov     edx, $005F9C88

* Reference to: System.@LStrCat3;
|
005F998A   E8DDB4E0FF             call    00404E6C
005F998F   8B55A0                 mov     edx, [ebp-$60]
005F9992   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F9994   E89BB8E0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F9999   E8B69DE0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F999E   E8E58FE0FF             call    00402988

* Possible String Reference to: '</tbcnt>'
|
005F99A3   BAA09C5F00             mov     edx, $005F9CA0
005F99A8   8BC6                   mov     eax, esi

* Reference to: System.@Write0Bool(TTextRec;TTextRec;Boolean):Pointer;
|
005F99AA   E885B8E0FF             call    00405234

* Reference to: System.@WriteLn(TTextRec;TTextRec):Pointer;
|
005F99AF   E8A09DE0FF             call    00403754

* Reference to: System.Proc_00402988
|
005F99B4   E8CF8FE0FF             call    00402988
005F99B9   8BC6                   mov     eax, esi

* Reference to: System.@Close(TTextRec;TTextRec):Integer;
|
005F99BB   E84C97E0FF             call    0040310C

* Reference to: System.Proc_00402988
|
005F99C0   E8C38FE0FF             call    00402988

* Reference to pointer to GlobalVar_0061E0AC
|
005F99C5   A1D0CC6100             mov     eax, dword ptr [$0061CCD0]
005F99CA   8B00                   mov     eax, [eax]

* Possible String Reference to: 'Christliche Namenstage'
|
005F99CC   BAB49C5F00             mov     edx, $005F9CB4

* Reference to: Controls.TControl.SetText(TControl;TCaption);
|
005F99D1   E85E30E5FF             call    0044CA34

* Reference to pointer to GlobalVar_0061E0AC
|
005F99D6   A1D0CC6100             mov     eax, dword ptr [$0061CCD0]
005F99DB   8B00                   mov     eax, [eax]

* Reference to control Label8 : TLabel
|
005F99DD   8B801C030000           mov     eax, [eax+$031C]
005F99E3   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005F99E5   E83A2FE5FF             call    0044C924

* Reference to pointer to GlobalVar_0061E0AC
|
005F99EA   A1D0CC6100             mov     eax, dword ptr [$0061CCD0]
005F99EF   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061E0AC.OFFS_0324
|
005F99F1   8B8024030000           mov     eax, [eax+$0324]
005F99F7   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005F99F9   E8262FE5FF             call    0044C924

* Reference to pointer to GlobalVar_0061E0AC
|
005F99FE   A1D0CC6100             mov     eax, dword ptr [$0061CCD0]
005F9A03   8B00                   mov     eax, [eax]

* Reference to control Timer1 : N.A.
|
005F9A05   8B8020030000           mov     eax, [eax+$0320]
005F9A0B   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005F9A0D   E8122FE5FF             call    0044C924

* Reference to pointer to GlobalVar_0061E0AC
|
005F9A12   A1D0CC6100             mov     eax, dword ptr [$0061CCD0]
005F9A17   8B00                   mov     eax, [eax]

* Reference to control Label7 : TLabel
|
005F9A19   8B8008030000           mov     eax, [eax+$0308]
005F9A1F   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005F9A21   E8FE2EE5FF             call    0044C924

* Reference to pointer to GlobalVar_0061E0AC
|
005F9A26   A1D0CC6100             mov     eax, dword ptr [$0061CCD0]
005F9A2B   8B00                   mov     eax, [eax]

* Reference to control Image2 : TImage
|
005F9A2D   8B800C030000           mov     eax, [eax+$030C]
005F9A33   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005F9A35   E8EA2EE5FF             call    0044C924

* Reference to pointer to GlobalVar_0061E0AC
|
005F9A3A   A1D0CC6100             mov     eax, dword ptr [$0061CCD0]
005F9A3F   8B00                   mov     eax, [eax]

* Reference to control Shape1 : TShape
|
005F9A41   8B8018030000           mov     eax, [eax+$0318]
005F9A47   33D2                   xor     edx, edx

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005F9A49   E8D62EE5FF             call    0044C924
005F9A4E   8D4598                 lea     eax, [ebp-$68]

* Possible String Reference to: 'chnt.xml'
|
005F9A51   B9B89A5F00             mov     ecx, $005F9AB8
005F9A56   8B159C5B5302           mov     edx, [$02535B9C]

* Reference to: System.@LStrCat3;
|
005F9A5C   E80BB4E0FF             call    00404E6C
005F9A61   8B5598                 mov     edx, [ebp-$68]
005F9A64   8B4DF8                 mov     ecx, [ebp-$08]

* Reference to Form1
|
005F9A67   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.Browser()
|
005F9A6A   E86188FFFF             call    005F22D0
005F9A6F   33C0                   xor     eax, eax
005F9A71   5A                     pop     edx
005F9A72   59                     pop     ecx
005F9A73   59                     pop     ecx
005F9A74   648910                 mov     fs:[eax], edx

****** FINALLY
|
005F9A77   68999A5F00             push    $005F9A99
005F9A7C   8D4598                 lea     eax, [ebp-$68]
005F9A7F   BA12000000             mov     edx, $00000012

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005F9A84   E803B1E0FF             call    00404B8C
005F9A89   8D45E8                 lea     eax, [ebp-$18]

* Reference to: System.@LStrClr(void;void);
|
005F9A8C   E8D7B0E0FF             call    00404B68
005F9A91   C3                     ret


* Reference to: System.@HandleFinally;
|
005F9A92   E935AAE0FF             jmp     004044CC
005F9A97   EBE3                   jmp     005F9A7C

****** END
|
005F9A99   5F                     pop     edi
005F9A9A   5E                     pop     esi
005F9A9B   5B                     pop     ebx
005F9A9C   8BE5                   mov     esp, ebp
005F9A9E   5D                     pop     ebp
005F9A9F   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.Image1 (TImage); TForm1.OpenPictureDialog1
    (TOpenPictureDialog); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet);
    TForm1.UpDown1 (TUpDown)
Global state: GlobalVar_0061DF08
Unresolved field offsets: OFFS_0534
Project calls: Unit_00408494.Proc_004091D8; Unit_00408494.Proc_00409950;
    Unit_00408494.Proc_00409CD0; Unit_00408494.Proc_00409F2C; Unit_00408494.Proc_0040A07C;
    Unit_00408494.Proc_0040A1B8; Unit_00408494.Proc_0040A1F0
Framework/API calls: class TBitmap; class TJPEGImage;
    ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Controls.TControl.SetVisible(TControl;Boolean);; Controls.TControl.SetWidth(TControl;Integer);;
    Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;;
    Graphics.TPicture.LoadFromFile(TPicture;AnsiString);;
    Graphics.TPicture.SaveToFile(TPicture;AnsiString);; method TGraphic.Height(); method
    TGraphic.Width(); method TMenuItem.Click(); method TOpenPictureDialog.Execute();
    MMSystem.mci_TMSF_Frame(Longint):Byte;; System.ParamStr(Integer):String;; System.Proc_00404EE0
Strings/files/dialog text: '.bmp'; '.BMP'; '.jpg'; '.JPG'; 'bilder\'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.einfgen1Click(Sender : TObject);
begin
(*
005F9CFC   55                     push    ebp
005F9CFD   8BEC                   mov     ebp, esp
005F9CFF   B90E000000             mov     ecx, $0000000E
005F9D04   6A00                   push    $00
005F9D06   6A00                   push    $00
005F9D08   49                     dec     ecx
005F9D09   75F9                   jnz     005F9D04
005F9D0B   51                     push    ecx
005F9D0C   53                     push    ebx
005F9D0D   56                     push    esi
005F9D0E   57                     push    edi
005F9D0F   8BD8                   mov     ebx, eax
005F9D11   33C0                   xor     eax, eax
005F9D13   55                     push    ebp
005F9D14   6896A05F00             push    $005FA096

***** TRY
|
005F9D19   64FF30                 push    dword ptr fs:[eax]
005F9D1C   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005F9D1F   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005F9D25   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005F9D2B   E88860E8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005F9D30   8B831C060000           mov     eax, [ebx+$061C]
005F9D36   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005F9D38   FF5244                 call    dword ptr [edx+$44]

* Reference to pointer to GlobalVar_0061DF08
|
005F9D3B   A13CCC6100             mov     eax, dword ptr [$0061CC3C]
005F9D40   8B00                   mov     eax, [eax]

* Reference to field GlobalVar_0061DF08.OFFS_0534
|
005F9D42   8B8034050000           mov     eax, [eax+$0534]
005F9D48   8B10                   mov     edx, [eax]
005F9D4A   FF5258                 call    dword ptr [edx+$58]
005F9D4D   8BF8                   mov     edi, eax

* Reference to control TForm1.OpenPictureDialog1 : TOpenPictureDialog
|
005F9D4F   8B83BC060000           mov     eax, [ebx+$06BC]

* Reference to field TOpenPictureDialog.FilterIndex : Integer
|
005F9D55   C7406402000000         mov     dword ptr [eax+$64], $00000002
005F9D5C   8D55EC                 lea     edx, [ebp-$14]
005F9D5F   33C0                   xor     eax, eax

* Reference to: System.ParamStr(Integer):String;
|
005F9D61   E8BE8EE0FF             call    00402C24
005F9D66   8B45EC                 mov     eax, [ebp-$14]
005F9D69   8D55FC                 lea     edx, [ebp-$04]

* Reference to: Unit_00408494.Proc_0040A07C
|
005F9D6C   E80B03E1FF             call    0040A07C
005F9D71   8D45F8                 lea     eax, [ebp-$08]

* Possible String Reference to: 'bilder\'
|
005F9D74   B9ACA05F00             mov     ecx, $005FA0AC
005F9D79   8B55FC                 mov     edx, [ebp-$04]

* Reference to: System.@LStrCat3;
|
005F9D7C   E8EBB0E0FF             call    00404E6C
005F9D81   8B45F8                 mov     eax, [ebp-$08]

* Reference to: MMSystem.mci_TMSF_Frame(Longint):Byte;
|
005F9D84   E83B8CE0FF             call    004029C4

* Reference to control TForm1.OpenPictureDialog1 : TOpenPictureDialog
|
005F9D89   8B83BC060000           mov     eax, [ebx+$06BC]
005F9D8F   8B10                   mov     edx, [eax]

* Reference to method TOpenPictureDialog.Execute()
|
005F9D91   FF523C                 call    dword ptr [edx+$3C]
005F9D94   84C0                   test    al, al
005F9D96   0F84FC010000           jz      005F9F98
005F9D9C   8D55E8                 lea     edx, [ebp-$18]

* Reference to control TForm1.OpenPictureDialog1 : TOpenPictureDialog
|
005F9D9F   8B83BC060000           mov     eax, [ebx+$06BC]

* Reference to: Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;
|
005F9DA5   E886A0E4FF             call    00443E30
005F9DAA   8B45E8                 mov     eax, [ebp-$18]
005F9DAD   8D55F4                 lea     edx, [ebp-$0C]

* Reference to: Unit_00408494.Proc_004091D8
|
005F9DB0   E823F4E0FF             call    004091D8
005F9DB5   8D55E4                 lea     edx, [ebp-$1C]
005F9DB8   8B45F4                 mov     eax, [ebp-$0C]

* Reference to: Unit_00408494.Proc_0040A1B8
|
005F9DBB   E8F803E1FF             call    0040A1B8
005F9DC0   8B45E4                 mov     eax, [ebp-$1C]
005F9DC3   8D55F0                 lea     edx, [ebp-$10]

* Reference to: Unit_00408494.Proc_004091D8
|
005F9DC6   E80DF4E0FF             call    004091D8
005F9DCB   8D55DC                 lea     edx, [ebp-$24]
005F9DCE   8B45F4                 mov     eax, [ebp-$0C]

* Reference to: Unit_00408494.Proc_0040A1F0
|
005F9DD1   E81A04E1FF             call    0040A1F0
005F9DD6   8B45DC                 mov     eax, [ebp-$24]
005F9DD9   8D55E0                 lea     edx, [ebp-$20]

* Reference to: Unit_00408494.Proc_004091D8
|
005F9DDC   E8F7F3E0FF             call    004091D8
005F9DE1   8B45E0                 mov     eax, [ebp-$20]

* Possible String Reference to: '.JPG'
|
005F9DE4   BABCA05F00             mov     edx, $005FA0BC

* Reference to: System.@LStrCmp;
|
005F9DE9   E876B1E0FF             call    00404F64
005F9DEE   0F85AC000000           jnz     005F9EA0

* Reference to control TForm1.Image1 : TImage
|
005F9DF4   8B83B8060000           mov     eax, [ebx+$06B8]

* Reference to field TImage.Picture : TPicture
|
005F9DFA   8B8068010000           mov     eax, [eax+$0168]
005F9E00   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: Graphics.TPicture.LoadFromFile(TPicture;AnsiString);
|
005F9E03   E86CF6E2FF             call    00429474
005F9E08   33F6                   xor     esi, esi
005F9E0A   FF75F8                 push    dword ptr [ebp-$08]
005F9E0D   68CCA05F00             push    $005FA0CC
005F9E12   8D55D4                 lea     edx, [ebp-$2C]
005F9E15   8BC7                   mov     eax, edi

* Reference to: Unit_00408494.Proc_00409950
|
005F9E17   E834FBE0FF             call    00409950
005F9E1C   FF75D4                 push    dword ptr [ebp-$2C]
005F9E1F   8D45D0                 lea     eax, [ebp-$30]
005F9E22   8D5661                 lea     edx, [esi+$61]

* Reference to: System.@LStrFromChar(String;String;Char);
|
005F9E25   E81EAFE0FF             call    00404D48
005F9E2A   FF75D0                 push    dword ptr [ebp-$30]

* Possible String Reference to: '.jpg'
|
005F9E2D   68D8A05F00             push    $005FA0D8
005F9E32   8D45D8                 lea     eax, [ebp-$28]
005F9E35   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005F9E3A   E8A1B0E0FF             call    00404EE0
005F9E3F   8B45D8                 mov     eax, [ebp-$28]

* Reference to: Unit_00408494.Proc_00409CD0
|
005F9E42   E889FEE0FF             call    00409CD0
005F9E47   84C0                   test    al, al
005F9E49   754B                   jnz     005F9E96
005F9E4B   FF75F8                 push    dword ptr [ebp-$08]
005F9E4E   68CCA05F00             push    $005FA0CC
005F9E53   8D55C8                 lea     edx, [ebp-$38]
005F9E56   8BC7                   mov     eax, edi

* Reference to: Unit_00408494.Proc_00409950
|
005F9E58   E8F3FAE0FF             call    00409950
005F9E5D   FF75C8                 push    dword ptr [ebp-$38]
005F9E60   8D45C4                 lea     eax, [ebp-$3C]
005F9E63   8D5661                 lea     edx, [esi+$61]

* Reference to: System.@LStrFromChar(String;String;Char);
|
005F9E66   E8DDAEE0FF             call    00404D48
005F9E6B   FF75C4                 push    dword ptr [ebp-$3C]

* Possible String Reference to: '.jpg'
|
005F9E6E   68D8A05F00             push    $005FA0D8
005F9E73   8D45CC                 lea     eax, [ebp-$34]
005F9E76   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005F9E7B   E860B0E0FF             call    00404EE0
005F9E80   8B55CC                 mov     edx, [ebp-$34]

* Reference to control TForm1.Image1 : TImage
|
005F9E83   8B83B8060000           mov     eax, [ebx+$06B8]

* Reference to field TImage.Picture : TPicture
|
005F9E89   8B8068010000           mov     eax, [eax+$0168]

* Reference to: Graphics.TPicture.SaveToFile(TPicture;AnsiString);
|
005F9E8F   E814F7E2FF             call    004295A8
005F9E94   EB0A                   jmp     005F9EA0
005F9E96   46                     inc     esi
005F9E97   83FE1A                 cmp     esi, +$1A
005F9E9A   0F856AFFFFFF           jnz     005F9E0A
005F9EA0   8D55BC                 lea     edx, [ebp-$44]
005F9EA3   8B45F4                 mov     eax, [ebp-$0C]

* Reference to: Unit_00408494.Proc_0040A1F0
|
005F9EA6   E84503E1FF             call    0040A1F0
005F9EAB   8B45BC                 mov     eax, [ebp-$44]
005F9EAE   8D55C0                 lea     edx, [ebp-$40]

* Reference to: Unit_00408494.Proc_004091D8
|
005F9EB1   E822F3E0FF             call    004091D8
005F9EB6   8B45C0                 mov     eax, [ebp-$40]

* Possible String Reference to: '.BMP'
|
005F9EB9   BAE8A05F00             mov     edx, $005FA0E8

* Reference to: System.@LStrCmp;
|
005F9EBE   E8A1B0E0FF             call    00404F64
005F9EC3   0F85AC000000           jnz     005F9F75

* Reference to control TForm1.Image1 : TImage
|
005F9EC9   8B83B8060000           mov     eax, [ebx+$06B8]

* Reference to field TImage.Picture : TPicture
|
005F9ECF   8B8068010000           mov     eax, [eax+$0168]
005F9ED5   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: Graphics.TPicture.LoadFromFile(TPicture;AnsiString);
|
005F9ED8   E897F5E2FF             call    00429474
005F9EDD   33F6                   xor     esi, esi
005F9EDF   FF75F8                 push    dword ptr [ebp-$08]
005F9EE2   68CCA05F00             push    $005FA0CC
005F9EE7   8D55B4                 lea     edx, [ebp-$4C]
005F9EEA   8BC7                   mov     eax, edi

* Reference to: Unit_00408494.Proc_00409950
|
005F9EEC   E85FFAE0FF             call    00409950
005F9EF1   FF75B4                 push    dword ptr [ebp-$4C]
005F9EF4   8D45B0                 lea     eax, [ebp-$50]
005F9EF7   8D5661                 lea     edx, [esi+$61]

* Reference to: System.@LStrFromChar(String;String;Char);
|
005F9EFA   E849AEE0FF             call    00404D48
005F9EFF   FF75B0                 push    dword ptr [ebp-$50]

* Possible String Reference to: '.bmp'
|
005F9F02   68F8A05F00             push    $005FA0F8
005F9F07   8D45B8                 lea     eax, [ebp-$48]
005F9F0A   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005F9F0F   E8CCAFE0FF             call    00404EE0
005F9F14   8B45B8                 mov     eax, [ebp-$48]

* Reference to: Unit_00408494.Proc_00409CD0
|
005F9F17   E8B4FDE0FF             call    00409CD0
005F9F1C   84C0                   test    al, al
005F9F1E   754B                   jnz     005F9F6B
005F9F20   FF75F8                 push    dword ptr [ebp-$08]
005F9F23   68CCA05F00             push    $005FA0CC
005F9F28   8D55A8                 lea     edx, [ebp-$58]
005F9F2B   8BC7                   mov     eax, edi

* Reference to: Unit_00408494.Proc_00409950
|
005F9F2D   E81EFAE0FF             call    00409950
005F9F32   FF75A8                 push    dword ptr [ebp-$58]
005F9F35   8D45A4                 lea     eax, [ebp-$5C]
005F9F38   8D5661                 lea     edx, [esi+$61]

* Reference to: System.@LStrFromChar(String;String;Char);
|
005F9F3B   E808AEE0FF             call    00404D48
005F9F40   FF75A4                 push    dword ptr [ebp-$5C]

* Possible String Reference to: '.bmp'
|
005F9F43   68F8A05F00             push    $005FA0F8
005F9F48   8D45AC                 lea     eax, [ebp-$54]
005F9F4B   BA05000000             mov     edx, $00000005

* Reference to: System.Proc_00404EE0
|
005F9F50   E88BAFE0FF             call    00404EE0
005F9F55   8B55AC                 mov     edx, [ebp-$54]

* Reference to control TForm1.Image1 : TImage
|
005F9F58   8B83B8060000           mov     eax, [ebx+$06B8]

* Reference to field TImage.Picture : TPicture
|
005F9F5E   8B8068010000           mov     eax, [eax+$0168]

* Reference to: Graphics.TPicture.SaveToFile(TPicture;AnsiString);
|
005F9F64   E83FF6E2FF             call    004295A8
005F9F69   EB0A                   jmp     005F9F75
005F9F6B   46                     inc     esi
005F9F6C   83FE1A                 cmp     esi, +$1A
005F9F6F   0F856AFFFFFF           jnz     005F9EDF
005F9F75   8D45A0                 lea     eax, [ebp-$60]
005F9F78   8B4DF0                 mov     ecx, [ebp-$10]
005F9F7B   8B55F8                 mov     edx, [ebp-$08]

* Reference to: System.@LStrCat3;
|
005F9F7E   E8E9AEE0FF             call    00404E6C
005F9F83   8B45A0                 mov     eax, [ebp-$60]

* Reference to: Unit_00408494.Proc_00409F2C
|
005F9F86   E8A1FFE0FF             call    00409F2C
005F9F8B   B201                   mov     dl, $01

* Reference to control TForm1.UpDown1 : TUpDown
|
005F9F8D   8B83C0060000           mov     eax, [ebx+$06C0]

* Reference to: Controls.TControl.SetVisible(TControl;Boolean);
|
005F9F93   E88C29E5FF             call    0044C924
005F9F98   8B45FC                 mov     eax, [ebp-$04]

* Reference to: MMSystem.mci_TMSF_Frame(Longint):Byte;
|
005F9F9B   E8248AE0FF             call    004029C4

* Reference to control TForm1.Image1 : TImage
|
005F9FA0   8BB3B8060000           mov     esi, [ebx+$06B8]

* Reference to field TImage.Picture : TPicture
|
005F9FA6   8B8668010000           mov     eax, [esi+$0168]

* Reference to field TPicture.Graphic : TGraphic
|
005F9FAC   8B780C                 mov     edi, [eax+$0C]
005F9FAF   8BC7                   mov     eax, edi

* Reference to class TJPEGImage
|
005F9FB1   8B150C014F00           mov     edx, [$004F010C]

* Reference to: System.@IsClass(TObject;TClass):Boolean;
|
005F9FB7   E8089FE0FF             call    00403EC4
005F9FBC   84C0                   test    al, al
005F9FBE   7443                   jz      005FA003
005F9FC0   8BC7                   mov     eax, edi
005F9FC2   8B10                   mov     edx, [eax]

* Reference to method TGraphic.Height()
|
005F9FC4   FF5220                 call    dword ptr [edx+$20]
005F9FC7   89459C                 mov     [ebp-$64], eax
005F9FCA   DB459C                 fild    dword ptr [ebp-$64]
005F9FCD   DB464C                 fild    dword ptr [esi+$4C]
005F9FD0   DEF1                   fdivrp  st(1), st(0)
005F9FD2   DB7D90                 fstp    tbyte ptr [ebp-$70]
005F9FD5   9B                     wait

* Reference to control TForm1.Image1 : TImage
|
005F9FD6   8B83B8060000           mov     eax, [ebx+$06B8]

* Reference to field TImage.Picture : TPicture
|
005F9FDC   8B8068010000           mov     eax, [eax+$0168]

* Reference to field TPicture.Graphic : TGraphic
|
005F9FE2   8B400C                 mov     eax, [eax+$0C]
005F9FE5   8B10                   mov     edx, [eax]

* Reference to method TGraphic.Width()
|
005F9FE7   FF522C                 call    dword ptr [edx+$2C]
005F9FEA   89458C                 mov     [ebp-$74], eax
005F9FED   DB458C                 fild    dword ptr [ebp-$74]
005F9FF0   DB6D90                 fld     tbyte ptr [ebp-$70]
005F9FF3   DEC9                   fmulp   st(1), st(0)

* Reference to: System.@ROUND;
|
005F9FF5   E8368DE0FF             call    00402D30
005F9FFA   8BD0                   mov     edx, eax
005F9FFC   8BC6                   mov     eax, esi

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
005F9FFE   E89521E5FF             call    0044C198

* Reference to control TForm1.Image1 : TImage
|
005FA003   8BB3B8060000           mov     esi, [ebx+$06B8]

* Reference to field TImage.Picture : TPicture
|
005FA009   8B8668010000           mov     eax, [esi+$0168]

* Reference to field TPicture.Graphic : TGraphic
|
005FA00F   8B780C                 mov     edi, [eax+$0C]
005FA012   8BC7                   mov     eax, edi

* Reference to class TBitmap
|
005FA014   8B15BC4D4200           mov     edx, [$00424DBC]

* Reference to: System.@IsClass(TObject;TClass):Boolean;
|
005FA01A   E8A59EE0FF             call    00403EC4
005FA01F   84C0                   test    al, al
005FA021   7443                   jz      005FA066
005FA023   8BC7                   mov     eax, edi
005FA025   8B10                   mov     edx, [eax]

* Reference to method TGraphic.Height()
|
005FA027   FF5220                 call    dword ptr [edx+$20]
005FA02A   89459C                 mov     [ebp-$64], eax
005FA02D   DB459C                 fild    dword ptr [ebp-$64]
005FA030   DB464C                 fild    dword ptr [esi+$4C]
005FA033   DEF1                   fdivrp  st(1), st(0)
005FA035   DB7D90                 fstp    tbyte ptr [ebp-$70]
005FA038   9B                     wait

* Reference to control TForm1.Image1 : TImage
|
005FA039   8B83B8060000           mov     eax, [ebx+$06B8]

* Reference to field TImage.Picture : TPicture
|
005FA03F   8B8068010000           mov     eax, [eax+$0168]

* Reference to field TPicture.Graphic : TGraphic
|
005FA045   8B400C                 mov     eax, [eax+$0C]
005FA048   8B10                   mov     edx, [eax]

* Reference to method TGraphic.Width()
|
005FA04A   FF522C                 call    dword ptr [edx+$2C]
005FA04D   89458C                 mov     [ebp-$74], eax
005FA050   DB458C                 fild    dword ptr [ebp-$74]
005FA053   DB6D90                 fld     tbyte ptr [ebp-$70]
005FA056   DEC9                   fmulp   st(1), st(0)

* Reference to: System.@ROUND;
|
005FA058   E8D38CE0FF             call    00402D30
005FA05D   8BD0                   mov     edx, eax
005FA05F   8BC6                   mov     eax, esi

* Reference to: Controls.TControl.SetWidth(TControl;Integer);
|
005FA061   E83221E5FF             call    0044C198
005FA066   33C0                   xor     eax, eax
005FA068   5A                     pop     edx
005FA069   59                     pop     ecx
005FA06A   59                     pop     ecx
005FA06B   648910                 mov     fs:[eax], edx

****** FINALLY
|
005FA06E   689DA05F00             push    $005FA09D
005FA073   8D45A0                 lea     eax, [ebp-$60]
005FA076   BA12000000             mov     edx, $00000012

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FA07B   E80CABE0FF             call    00404B8C
005FA080   8D45E8                 lea     eax, [ebp-$18]

* Reference to: System.@LStrClr(void;void);
|
005FA083   E8E0AAE0FF             call    00404B68
005FA088   8D45EC                 lea     eax, [ebp-$14]
005FA08B   BA05000000             mov     edx, $00000005

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FA090   E8F7AAE0FF             call    00404B8C
005FA095   C3                     ret


* Reference to: System.@HandleFinally;
|
005FA096   E931A4E0FF             jmp     004044CC
005FA09B   EBD6                   jmp     005FA073

****** END
|
005FA09D   5F                     pop     edi
005FA09E   5E                     pop     esi
005FA09F   5B                     pop     ebx
005FA0A0   8BE5                   mov     esp, ebp
005FA0A2   5D                     pop     ebp
005FA0A3   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.Image1 (TImage); TForm1.PageControl1 (TPageControl);
    TForm1.TabSheet2 (TTabSheet)
Project calls: TForm1.anzeigen(); Unit_00408494.Proc_004091D8; Unit_00408494.Proc_00409CD0;
    Unit_00408494.Proc_00409F2C; Unit_00408494.Proc_0040A07C; Unit_00408494.Proc_0040A1B8
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Graphics.TPicture.SaveToFile(TPicture;AnsiString);; method TMenuItem.Click();
    System.ParamStr(Integer):String;; System.Proc_00404EE0
Strings/files/dialog text: 'bilder\'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.entfernen1Click(Sender : TObject);
begin
(*
005FA438   55                     push    ebp
005FA439   8BEC                   mov     ebp, esp
005FA43B   B907000000             mov     ecx, $00000007
005FA440   6A00                   push    $00
005FA442   6A00                   push    $00
005FA444   49                     dec     ecx
005FA445   75F9                   jnz     005FA440
005FA447   51                     push    ecx
005FA448   53                     push    ebx
005FA449   8BD8                   mov     ebx, eax
005FA44B   33C0                   xor     eax, eax
005FA44D   55                     push    ebp
005FA44E   68DCA55F00             push    $005FA5DC

***** TRY
|
005FA453   64FF30                 push    dword ptr fs:[eax]
005FA456   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FA459   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FA45F   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FA465   E84E59E8FF             call    0047FDB8
005FA46A   8D55EC                 lea     edx, [ebp-$14]
005FA46D   A1305B5302             mov     eax, dword ptr [$02535B30]

* Reference to: Unit_00408494.Proc_0040A1B8
|
005FA472   E841FDE0FF             call    0040A1B8
005FA477   8B45EC                 mov     eax, [ebp-$14]
005FA47A   8D55F4                 lea     edx, [ebp-$0C]

* Reference to: Unit_00408494.Proc_004091D8
|
005FA47D   E856EDE0FF             call    004091D8
005FA482   8D55E8                 lea     edx, [ebp-$18]
005FA485   A1345B5302             mov     eax, dword ptr [$02535B34]

* Reference to: Unit_00408494.Proc_0040A1B8
|
005FA48A   E829FDE0FF             call    0040A1B8
005FA48F   8B45E8                 mov     eax, [ebp-$18]
005FA492   8D55F0                 lea     edx, [ebp-$10]

* Reference to: Unit_00408494.Proc_004091D8
|
005FA495   E83EEDE0FF             call    004091D8

* Reference to control TForm1.aus1 : TMenuItem
|
005FA49A   8B831C060000           mov     eax, [ebx+$061C]
005FA4A0   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FA4A2   FF5244                 call    dword ptr [edx+$44]
005FA4A5   8D55E4                 lea     edx, [ebp-$1C]
005FA4A8   33C0                   xor     eax, eax

* Reference to: System.ParamStr(Integer):String;
|
005FA4AA   E87587E0FF             call    00402C24
005FA4AF   8B45E4                 mov     eax, [ebp-$1C]
005FA4B2   8D55FC                 lea     edx, [ebp-$04]

* Reference to: Unit_00408494.Proc_0040A07C
|
005FA4B5   E8C2FBE0FF             call    0040A07C
005FA4BA   8D45F8                 lea     eax, [ebp-$08]

* Possible String Reference to: 'bilder\'
|
005FA4BD   B9F0A55F00             mov     ecx, $005FA5F0
005FA4C2   8B55FC                 mov     edx, [ebp-$04]

* Reference to: System.@LStrCat3;
|
005FA4C5   E8A2A9E0FF             call    00404E6C
005FA4CA   8D45E0                 lea     eax, [ebp-$20]
005FA4CD   8B4DF4                 mov     ecx, [ebp-$0C]
005FA4D0   8B55F8                 mov     edx, [ebp-$08]

* Reference to: System.@LStrCat3;
|
005FA4D3   E894A9E0FF             call    00404E6C
005FA4D8   8B45E0                 mov     eax, [ebp-$20]

* Reference to: Unit_00408494.Proc_00409CD0
|
005FA4DB   E8F0F7E0FF             call    00409CD0
005FA4E0   84C0                   test    al, al
005FA4E2   745E                   jz      005FA542
005FA4E4   FF75F8                 push    dword ptr [ebp-$08]
005FA4E7   6800A65F00             push    $005FA600
005FA4EC   8D45D8                 lea     eax, [ebp-$28]
005FA4EF   50                     push    eax
005FA4F0   8B45F4                 mov     eax, [ebp-$0C]

* Reference to: System.@LStrLen(String):Integer;
|
005FA4F3   E828A9E0FF             call    00404E20
005FA4F8   8BC8                   mov     ecx, eax
005FA4FA   49                     dec     ecx
005FA4FB   BA02000000             mov     edx, $00000002
005FA500   8B45F4                 mov     eax, [ebp-$0C]

* Reference to: System.@LStrCopy;
|
005FA503   E870ABE0FF             call    00405078
005FA508   FF75D8                 push    dword ptr [ebp-$28]
005FA50B   8D45DC                 lea     eax, [ebp-$24]
005FA50E   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005FA513   E8C8A9E0FF             call    00404EE0
005FA518   8B55DC                 mov     edx, [ebp-$24]

* Reference to control TForm1.Image1 : TImage
|
005FA51B   8B83B8060000           mov     eax, [ebx+$06B8]

* Reference to field TImage.Picture : TPicture
|
005FA521   8B8068010000           mov     eax, [eax+$0168]

* Reference to: Graphics.TPicture.SaveToFile(TPicture;AnsiString);
|
005FA527   E87CF0E2FF             call    004295A8
005FA52C   8D45D4                 lea     eax, [ebp-$2C]
005FA52F   8B4DF4                 mov     ecx, [ebp-$0C]
005FA532   8B55F8                 mov     edx, [ebp-$08]

* Reference to: System.@LStrCat3;
|
005FA535   E832A9E0FF             call    00404E6C
005FA53A   8B45D4                 mov     eax, [ebp-$2C]

* Reference to: Unit_00408494.Proc_00409F2C
|
005FA53D   E8EAF9E0FF             call    00409F2C
005FA542   8D45D0                 lea     eax, [ebp-$30]
005FA545   8B4DF0                 mov     ecx, [ebp-$10]
005FA548   8B55F8                 mov     edx, [ebp-$08]

* Reference to: System.@LStrCat3;
|
005FA54B   E81CA9E0FF             call    00404E6C
005FA550   8B45D0                 mov     eax, [ebp-$30]

* Reference to: Unit_00408494.Proc_00409CD0
|
005FA553   E878F7E0FF             call    00409CD0
005FA558   84C0                   test    al, al
005FA55A   745E                   jz      005FA5BA
005FA55C   FF75F8                 push    dword ptr [ebp-$08]
005FA55F   6800A65F00             push    $005FA600
005FA564   8D45C8                 lea     eax, [ebp-$38]
005FA567   50                     push    eax
005FA568   8B45F0                 mov     eax, [ebp-$10]

* Reference to: System.@LStrLen(String):Integer;
|
005FA56B   E8B0A8E0FF             call    00404E20
005FA570   8BC8                   mov     ecx, eax
005FA572   49                     dec     ecx
005FA573   BA02000000             mov     edx, $00000002
005FA578   8B45F0                 mov     eax, [ebp-$10]

* Reference to: System.@LStrCopy;
|
005FA57B   E8F8AAE0FF             call    00405078
005FA580   FF75C8                 push    dword ptr [ebp-$38]
005FA583   8D45CC                 lea     eax, [ebp-$34]
005FA586   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
005FA58B   E850A9E0FF             call    00404EE0
005FA590   8B55CC                 mov     edx, [ebp-$34]

* Reference to control TForm1.Image1 : TImage
|
005FA593   8B83B8060000           mov     eax, [ebx+$06B8]

* Reference to field TImage.Picture : TPicture
|
005FA599   8B8068010000           mov     eax, [eax+$0168]

* Reference to: Graphics.TPicture.SaveToFile(TPicture;AnsiString);
|
005FA59F   E804F0E2FF             call    004295A8
005FA5A4   8D45C4                 lea     eax, [ebp-$3C]
005FA5A7   8B4DF0                 mov     ecx, [ebp-$10]
005FA5AA   8B55F8                 mov     edx, [ebp-$08]

* Reference to: System.@LStrCat3;
|
005FA5AD   E8BAA8E0FF             call    00404E6C
005FA5B2   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: Unit_00408494.Proc_00409F2C
|
005FA5B5   E872F9E0FF             call    00409F2C
005FA5BA   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
005FA5BC   E8DB9DFDFF             call    005D439C
005FA5C1   33C0                   xor     eax, eax
005FA5C3   5A                     pop     edx
005FA5C4   59                     pop     ecx
005FA5C5   59                     pop     ecx
005FA5C6   648910                 mov     fs:[eax], edx

****** FINALLY
|
005FA5C9   68E3A55F00             push    $005FA5E3
005FA5CE   8D45C4                 lea     eax, [ebp-$3C]
005FA5D1   BA0F000000             mov     edx, $0000000F

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FA5D6   E8B1A5E0FF             call    00404B8C
005FA5DB   C3                     ret


* Reference to: System.@HandleFinally;
|
005FA5DC   E9EB9EE0FF             jmp     004044CC
005FA5E1   EBEB                   jmp     005FA5CE

****** END
|
005FA5E3   5B                     pop     ebx
005FA5E4   8BE5                   mov     esp, ebp
005FA5E6   5D                     pop     ebp
005FA5E7   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.aus1 (TMenuItem); TForm1.PageControl1 (TPageControl); TForm1.TabSheet2 (TTabSheet)
Project calls: TForm1.bild_entf()
Framework/API calls: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);; method
    TMenuItem.Click()
Strings/files/dialog text: 'BiLoe'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.alleBilderentfernen1Click(Sender : TObject);
begin
(*
005FBF84   53                     push    ebx
005FBF85   8BD8                   mov     ebx, eax

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FBF87   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FBF8D   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FBF93   E8203EE8FF             call    0047FDB8

* Reference to control TForm1.aus1 : TMenuItem
|
005FBF98   8B831C060000           mov     eax, [ebx+$061C]
005FBF9E   8B10                   mov     edx, [eax]

* Reference to method TMenuItem.Click()
|
005FBFA0   FF5244                 call    dword ptr [edx+$44]
005FBFA3   B82C595302             mov     eax, $0253592C

* Possible String Reference to: 'BiLoe'
|
005FBFA8   BAD0BF5F00             mov     edx, $005FBFD0

* Reference to: System.@LStrAsg(void;void;void;void);
|
005FBFAD   E80A8CE0FF             call    00404BBC
005FBFB2   8BC3                   mov     eax, ebx

* Reference to : TForm1.bild_entf()
|
005FBFB4   E83FFCFFFF             call    005FBBF8
005FBFB9   B82C595302             mov     eax, $0253592C

* Reference to: System.@LStrClr(void;void);
|
005FBFBE   E8A58BE0FF             call    00404B68
005FBFC3   5B                     pop     ebx
005FBFC4   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.OpenPictureDialog1 (TOpenPictureDialog); TForm1.PageControl1 (TPageControl);
    TForm1.TabSheet2 (TTabSheet)
Unresolved field offsets: OFFS_003F; OFFS_08; OFFS_50
Project calls: TForm1.Proc_005FBFD8(); Unit_00408494.Proc_004091D8; Unit_00408494.Proc_0040A1F0
Framework/API calls: class TImage; class TJPEGImage;
    ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);;
    Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;;
    Graphics.TPicture.LoadFromFile(TPicture;AnsiString);;
    jpeg.TJPEGImage.Create(TJPEGImage;boolean);;
    jpeg.TJPEGImage.SetPerformance(TJPEGImage;TJPEGPerformance);; method
    TOpenPictureDialog.Execute(); MMSystem.mci_TMSF_Frame(Longint):Byte;;
    System.TObject.Free(TObject);; TPanel._PROC_00440EF8()
Strings/files/dialog text: '.BMP'; '\Bilder'; '^[��]�'; '������^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.bmpjpg1Click(Sender : TObject);
begin
(*
005FC070   55                     push    ebp
005FC071   8BEC                   mov     ebp, esp
005FC073   33C9                   xor     ecx, ecx
005FC075   51                     push    ecx
005FC076   51                     push    ecx
005FC077   51                     push    ecx
005FC078   51                     push    ecx
005FC079   51                     push    ecx
005FC07A   51                     push    ecx
005FC07B   51                     push    ecx
005FC07C   53                     push    ebx
005FC07D   56                     push    esi
005FC07E   8BD8                   mov     ebx, eax
005FC080   33C0                   xor     eax, eax
005FC082   55                     push    ebp

* Possible String Reference to: '������^[��]�'
|
005FC083   68D6C15F00             push    $005FC1D6

***** TRY
|
005FC088   64FF30                 push    dword ptr fs:[eax]
005FC08B   648920                 mov     fs:[eax], esp

* Reference to control TForm1.TabSheet2 : TTabSheet
|
005FC08E   8B9340030000           mov     edx, [ebx+$0340]

* Reference to control TForm1.PageControl1 : TPageControl
|
005FC094   8B8338030000           mov     eax, [ebx+$0338]

* Reference to: ComCtrls.TPageControl.SetActivePage(TPageControl;TTabSheet);
|
005FC09A   E8193DE8FF             call    0047FDB8
005FC09F   8D55F4                 lea     edx, [ebp-$0C]
005FC0A2   33C0                   xor     eax, eax

* Reference to: System.@LGetDir(Byte;String;String);
|
005FC0A4   E88B69E0FF             call    00402A34
005FC0A9   8D45F0                 lea     eax, [ebp-$10]

* Possible String Reference to: '\Bilder'
|
005FC0AC   B9ECC15F00             mov     ecx, $005FC1EC
005FC0B1   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrCat3;
|
005FC0B4   E8B38DE0FF             call    00404E6C
005FC0B9   8B45F0                 mov     eax, [ebp-$10]

* Reference to: MMSystem.mci_TMSF_Frame(Longint):Byte;
|
005FC0BC   E80369E0FF             call    004029C4

* Reference to control TForm1.OpenPictureDialog1 : TOpenPictureDialog
|
005FC0C1   8BB3BC060000           mov     esi, [ebx+$06BC]

* Reference to field TOpenPictureDialog.FilterIndex : Integer
|
005FC0C7   C7466401000000         mov     dword ptr [esi+$64], $00000001
005FC0CE   8BC6                   mov     eax, esi
005FC0D0   8B10                   mov     edx, [eax]

* Reference to method TOpenPictureDialog.Execute()
|
005FC0D2   FF523C                 call    dword ptr [edx+$3C]
005FC0D5   84C0                   test    al, al
005FC0D7   7419                   jz      005FC0F2
005FC0D9   8D55EC                 lea     edx, [ebp-$14]

* Reference to control TForm1.OpenPictureDialog1 : TOpenPictureDialog
|
005FC0DC   8B83BC060000           mov     eax, [ebx+$06BC]

* Reference to: Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;
|
005FC0E2   E8497DE4FF             call    00443E30
005FC0E7   8B45EC                 mov     eax, [ebp-$14]
005FC0EA   8D55FC                 lea     edx, [ebp-$04]

* Reference to: Unit_00408494.Proc_004091D8
|
005FC0ED   E8E6D0E0FF             call    004091D8
005FC0F2   8D55E8                 lea     edx, [ebp-$18]
005FC0F5   8B45FC                 mov     eax, [ebp-$04]

* Reference to: Unit_00408494.Proc_0040A1F0
|
005FC0F8   E8F3E0E0FF             call    0040A1F0
005FC0FD   8B45E8                 mov     eax, [ebp-$18]

* Possible String Reference to: '.BMP'
|
005FC100   BAFCC15F00             mov     edx, $005FC1FC

* Reference to: System.@LStrCmp;
|
005FC105   E85A8EE0FF             call    00404F64
005FC10A   0F858E000000           jnz     005FC19E
005FC110   33C9                   xor     ecx, ecx
005FC112   B201                   mov     dl, $01

* Reference to class TImage
|
005FC114   A104F74300             mov     eax, dword ptr [$0043F704]

* Reference to : TPanel._PROC_00440EF8()
|
005FC119   E8DA4DE4FF             call    00440EF8
005FC11E   8BF0                   mov     esi, eax

* Reference to field TImage.Picture : TPicture
|
005FC120   8B8668010000           mov     eax, [esi+$0168]
005FC126   8B55FC                 mov     edx, [ebp-$04]

* Reference to: Graphics.TPicture.LoadFromFile(TPicture;AnsiString);
|
005FC129   E846D3E2FF             call    00429474
005FC12E   B201                   mov     dl, $01

* Reference to class TJPEGImage
|
005FC130   A10C014F00             mov     eax, dword ptr [$004F010C]

* Reference to: jpeg.TJPEGImage.Create(TJPEGImage;boolean);
|
005FC135   E88642EFFF             call    004F03C0
005FC13A   8BD8                   mov     ebx, eax
005FC13C   33D2                   xor     edx, edx
005FC13E   8BC3                   mov     eax, ebx

* Reference to: jpeg.TJPEGImage.SetPerformance(TJPEGImage;TJPEGPerformance);
|
005FC140   E8D354EFFF             call    004F1618

* Reference to field TJPEGImage.OFFS_003F
|
005FC145   C6433F50               mov     byte ptr [ebx+$3F], $50

* Reference to field TImage.Picture : TPicture
|
005FC149   8B8668010000           mov     eax, [esi+$0168]

* Reference to field TPicture.Graphic : TGraphic
|
005FC14F   8B500C                 mov     edx, [eax+$0C]
005FC152   8BC3                   mov     eax, ebx
005FC154   8B08                   mov     ecx, [eax]

* Possible reference to virtual method TJPEGImage.OFFS_08
|
005FC156   FF5108                 call    dword ptr [ecx+$08]
005FC159   8D55F8                 lea     edx, [ebp-$08]
005FC15C   8B45FC                 mov     eax, [ebp-$04]

* Reference to : TForm1.Proc_005FBFD8()
|
005FC15F   E874FEFFFF             call    005FBFD8
005FC164   8D45E4                 lea     eax, [ebp-$1C]

* Possible String Reference to: '\Bilder'
|
005FC167   B9ECC15F00             mov     ecx, $005FC1EC
005FC16C   8B55F4                 mov     edx, [ebp-$0C]

* Reference to: System.@LStrCat3;
|
005FC16F   E8F88CE0FF             call    00404E6C
005FC174   8B45E4                 mov     eax, [ebp-$1C]

* Reference to: MMSystem.mci_TMSF_Frame(Longint):Byte;
|
005FC177   E84868E0FF             call    004029C4
005FC17C   8D55F4                 lea     edx, [ebp-$0C]
005FC17F   33C0                   xor     eax, eax

* Reference to: System.@LGetDir(Byte;String;String);
|
005FC181   E8AE68E0FF             call    00402A34
005FC186   8B55F8                 mov     edx, [ebp-$08]
005FC189   8BC3                   mov     eax, ebx
005FC18B   8B08                   mov     ecx, [eax]

* Possible reference to virtual method TJPEGImage.OFFS_50
|
005FC18D   FF5150                 call    dword ptr [ecx+$50]
005FC190   8BC3                   mov     eax, ebx

* Reference to: System.TObject.Free(TObject);
|
005FC192   E8A17BE0FF             call    00403D38
005FC197   8BC6                   mov     eax, esi

* Reference to: System.TObject.Free(TObject);
|
005FC199   E89A7BE0FF             call    00403D38
005FC19E   8B45F4                 mov     eax, [ebp-$0C]

* Reference to: MMSystem.mci_TMSF_Frame(Longint):Byte;
|
005FC1A1   E81E68E0FF             call    004029C4
005FC1A6   33C0                   xor     eax, eax
005FC1A8   5A                     pop     edx
005FC1A9   59                     pop     ecx
005FC1AA   59                     pop     ecx
005FC1AB   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '^[��]�'
|
005FC1AE   68DDC15F00             push    $005FC1DD
005FC1B3   8D45E4                 lea     eax, [ebp-$1C]
005FC1B6   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FC1BB   E8CC89E0FF             call    00404B8C
005FC1C0   8D45EC                 lea     eax, [ebp-$14]

* Reference to: System.@LStrClr(void;void);
|
005FC1C3   E8A089E0FF             call    00404B68
005FC1C8   8D45F0                 lea     eax, [ebp-$10]
005FC1CB   BA04000000             mov     edx, $00000004

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
005FC1D0   E8B789E0FF             call    00404B8C
005FC1D5   C3                     ret


* Reference to: System.@HandleFinally;
|
005FC1D6   E9F182E0FF             jmp     004044CC
005FC1DB   EBD6                   jmp     005FC1B3

****** END
|
005FC1DD   5E                     pop     esi
005FC1DE   5B                     pop     ebx
005FC1DF   8BE5                   mov     esp, ebp
005FC1E1   5D                     pop     ebp
005FC1E2   C3                     ret

*)
end;

{ ASM listing resource map; extracted from commented binary evidence only.
UI/forms: TForm1.FileListBox1 (TFileListBox); TForm1.OpenDialog1 (TOpenDialog)
Unresolved field offsets: OFFS_08; OFFS_50
Project calls: TForm1.anzeigen(); Unit_00408494.Proc_004091D8; Unit_00408494.Proc_00409F2C;
    Unit_00408494.Proc_0040A0B0; Unit_00408494.Proc_0040A1F0
Framework/API calls: class TImage; class TJPEGImage;
    Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;;
    Graphics.TPicture.LoadFromFile(TPicture;AnsiString);;
    jpeg.TJPEGImage.Create(TJPEGImage;boolean);;
    jpeg.TJPEGImage.SetPerformance(TJPEGImage;TJPEGPerformance);; kernel32.CopyFileA(); method
    TFileListBox.ApplyFilePath(string); method TOpenDialog.Execute(); method TStrings.Count();
    method TStrings.Strings [ Index(); MMSystem.mci_TMSF_Frame(Longint):Byte;; System.Proc_00404EE0;
    System.TObject.Free(TObject);; TPanel._PROC_00440EF8()
Strings/files/dialog text: '.jpg'; '_^[��]�'; 'a.bmp'; 'a.jpg'; 'Bilder\'; 'BMP'; 'JPG';
    '�l�����_^[��]�'
  Unknown: raw binary addresses, unlabelled object offsets, and indirect targets are unresolved.
  This is not a runtime dependency map; original offsets refer to the decompiled binary layout.
}
procedure TForm1.bernehmen1Click(Sender : TObject);
begin
(*
00606CC0   55                     push    ebp
00606CC1   8BEC                   mov     ebp, esp
00606CC3   B90C000000             mov     ecx, $0000000C
00606CC8   6A00                   push    $00
00606CCA   6A00                   push    $00
00606CCC   49                     dec     ecx
00606CCD   75F9                   jnz     00606CC8
00606CCF   51                     push    ecx
00606CD0   53                     push    ebx
00606CD1   56                     push    esi
00606CD2   57                     push    edi
00606CD3   8BD8                   mov     ebx, eax
00606CD5   33C0                   xor     eax, eax
00606CD7   55                     push    ebp

* Possible String Reference to: '�l�����_^[��]�'
|
00606CD8   685B706000             push    $0060705B

***** TRY
|
00606CDD   64FF30                 push    dword ptr fs:[eax]
00606CE0   648920                 mov     fs:[eax], esp
00606CE3   8D45F8                 lea     eax, [ebp-$08]

* Reference to: System.@LStrClr(void;void);
|
00606CE6   E87DDEDFFF             call    00404B68
00606CEB   8D45FC                 lea     eax, [ebp-$04]

* Possible String Reference to: 'Bilder\'
|
00606CEE   B974706000             mov     ecx, $00607074
00606CF3   8B159C5B5302           mov     edx, [$02535B9C]

* Reference to: System.@LStrCat3;
|
00606CF9   E86EE1DFFF             call    00404E6C

* Reference to control TForm1.OpenDialog1 : TOpenDialog
|
00606CFE   8BB314040000           mov     esi, [ebx+$0414]

* Reference to field TOpenDialog.FilterIndex : Integer
|
00606D04   C7466406000000         mov     dword ptr [esi+$64], $00000006
00606D0B   8BC6                   mov     eax, esi
00606D0D   8B10                   mov     edx, [eax]

* Reference to method TOpenDialog.Execute()
|
00606D0F   FF523C                 call    dword ptr [edx+$3C]
00606D12   84C0                   test    al, al
00606D14   0F84F8020000           jz      00607012
00606D1A   8D55E4                 lea     edx, [ebp-$1C]

* Reference to control TForm1.OpenDialog1 : TOpenDialog
|
00606D1D   8B8314040000           mov     eax, [ebx+$0414]

* Reference to: Dialogs.TOpenDialog.GetFileName(TOpenDialog):TFileName;
|
00606D23   E808D1E3FF             call    00443E30
00606D28   8B45E4                 mov     eax, [ebp-$1C]
00606D2B   8D55E8                 lea     edx, [ebp-$18]

* Reference to: Unit_00408494.Proc_0040A0B0
|
00606D2E   E87D33E0FF             call    0040A0B0
00606D33   8B55E8                 mov     edx, [ebp-$18]

* Reference to control TForm1.FileListBox1 : TFileListBox
|
00606D36   8B83FC060000           mov     eax, [ebx+$06FC]
00606D3C   8B08                   mov     ecx, [eax]

* Reference to method TFileListBox.ApplyFilePath(string)
|
00606D3E   FF910C010000           call    dword ptr [ecx+$010C]

* Reference to control TForm1.FileListBox1 : TFileListBox
|
00606D44   8B83FC060000           mov     eax, [ebx+$06FC]

* Reference to field TFileListBox.Items : TStrings
|
00606D4A   8B8018020000           mov     eax, [eax+$0218]
00606D50   8B10                   mov     edx, [eax]

* Reference to method TStrings.Count()
|
00606D52   FF5214                 call    dword ptr [edx+$14]
00606D55   48                     dec     eax
00606D56   85C0                   test    eax, eax
00606D58   0F8CB4020000           jl      00607012
00606D5E   40                     inc     eax
00606D5F   8945EC                 mov     [ebp-$14], eax
00606D62   33F6                   xor     esi, esi
00606D64   8D45DC                 lea     eax, [ebp-$24]
00606D67   50                     push    eax
00606D68   8D4DD4                 lea     ecx, [ebp-$2C]

* Reference to control TForm1.FileListBox1 : TFileListBox
|
00606D6B   8B83FC060000           mov     eax, [ebx+$06FC]

* Reference to field TFileListBox.Items : TStrings
|
00606D71   8B8018020000           mov     eax, [eax+$0218]
00606D77   8BD6                   mov     edx, esi
00606D79   8B38                   mov     edi, [eax]

* Reference to method TStrings.Strings  [ Index()
|
00606D7B   FF570C                 call    dword ptr [edi+$0C]
00606D7E   8B45D4                 mov     eax, [ebp-$2C]
00606D81   8D55D8                 lea     edx, [ebp-$28]

* Reference to: Unit_00408494.Proc_0040A1F0
|
00606D84   E86734E0FF             call    0040A1F0
00606D89   8B45D8                 mov     eax, [ebp-$28]
00606D8C   B903000000             mov     ecx, $00000003
00606D91   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrCopy;
|
00606D96   E8DDE2DFFF             call    00405078
00606D9B   8B45DC                 mov     eax, [ebp-$24]
00606D9E   8D55E0                 lea     edx, [ebp-$20]

* Reference to: Unit_00408494.Proc_004091D8
|
00606DA1   E83224E0FF             call    004091D8
00606DA6   8B45E0                 mov     eax, [ebp-$20]

* Possible String Reference to: 'BMP'
|
00606DA9   BA84706000             mov     edx, $00607084

* Reference to: System.@LStrCmp;
|
00606DAE   E8B1E1DFFF             call    00404F64
00606DB3   0F8566010000           jnz     00606F1F
00606DB9   8D45F8                 lea     eax, [ebp-$08]
00606DBC   50                     push    eax
00606DBD   8D4DD0                 lea     ecx, [ebp-$30]

* Reference to control TForm1.FileListBox1 : TFileListBox
|
00606DC0   8B83FC060000           mov     eax, [ebx+$06FC]

* Reference to field TFileListBox.Items : TStrings
|
00606DC6   8B8018020000           mov     eax, [eax+$0218]
00606DCC   8BD6                   mov     edx, esi
00606DCE   8B38                   mov     edi, [eax]

* Reference to method TStrings.Strings  [ Index()
|
00606DD0   FF570C                 call    dword ptr [edi+$0C]
00606DD3   8B55D0                 mov     edx, [ebp-$30]
00606DD6   B890706000             mov     eax, $00607090

* Reference to: System.@LStrPos;
|
00606DDB   E87CE3DFFF             call    0040515C
00606DE0   48                     dec     eax
00606DE1   50                     push    eax
00606DE2   8D4DCC                 lea     ecx, [ebp-$34]

* Reference to control TForm1.FileListBox1 : TFileListBox
|
00606DE5   8B83FC060000           mov     eax, [ebx+$06FC]

* Reference to field TFileListBox.Items : TStrings
|
00606DEB   8B8018020000           mov     eax, [eax+$0218]
00606DF1   8BD6                   mov     edx, esi
00606DF3   8B38                   mov     edi, [eax]

* Reference to method TStrings.Strings  [ Index()
|
00606DF5   FF570C                 call    dword ptr [edi+$0C]
00606DF8   8B45CC                 mov     eax, [ebp-$34]
00606DFB   BA01000000             mov     edx, $00000001
00606E00   59                     pop     ecx

* Reference to: System.@LStrCopy;
|
00606E01   E872E2DFFF             call    00405078
00606E06   6A00                   push    $00
00606E08   FF75FC                 push    dword ptr [ebp-$04]
00606E0B   689C706000             push    $0060709C
00606E10   FF75F8                 push    dword ptr [ebp-$08]

* Possible String Reference to: 'a.bmp'
|
00606E13   68A8706000             push    $006070A8
00606E18   8D45C8                 lea     eax, [ebp-$38]
00606E1B   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
00606E20   E8BBE0DFFF             call    00404EE0
00606E25   8B45C8                 mov     eax, [ebp-$38]

* Reference to: System.@LStrToPChar(String):PAnsiChar;
|
00606E28   E8EBE1DFFF             call    00405018
00606E2D   50                     push    eax
00606E2E   8D4DC4                 lea     ecx, [ebp-$3C]

* Reference to control TForm1.FileListBox1 : TFileListBox
|
00606E31   8B83FC060000           mov     eax, [ebx+$06FC]

* Reference to field TFileListBox.Items : TStrings
|
00606E37   8B8018020000           mov     eax, [eax+$0218]
00606E3D   8BD6                   mov     edx, esi
00606E3F   8B38                   mov     edi, [eax]

* Reference to method TStrings.Strings  [ Index()
|
00606E41   FF570C                 call    dword ptr [edi+$0C]
00606E44   8B45C4                 mov     eax, [ebp-$3C]

* Reference to: System.@LStrToPChar(String):PAnsiChar;
|
00606E47   E8CCE1DFFF             call    00405018
00606E4C   50                     push    eax

* Reference to: kernel32.CopyFileA()
|
00606E4D   E80205E0FF             call    00407354
00606E52   33C9                   xor     ecx, ecx
00606E54   B201                   mov     dl, $01

* Reference to class TImage
|
00606E56   A104F74300             mov     eax, dword ptr [$0043F704]

* Reference to : TPanel._PROC_00440EF8()
|
00606E5B   E898A0E3FF             call    00440EF8
00606E60   8945F0                 mov     [ebp-$10], eax
00606E63   FF75FC                 push    dword ptr [ebp-$04]
00606E66   689C706000             push    $0060709C
00606E6B   FF75F8                 push    dword ptr [ebp-$08]

* Possible String Reference to: 'a.bmp'
|
00606E6E   68A8706000             push    $006070A8
00606E73   8D45C0                 lea     eax, [ebp-$40]
00606E76   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
00606E7B   E860E0DFFF             call    00404EE0
00606E80   8B55C0                 mov     edx, [ebp-$40]
00606E83   8B45F0                 mov     eax, [ebp-$10]

* Reference to field TImage.Picture : TPicture
|
00606E86   8B8068010000           mov     eax, [eax+$0168]

* Reference to: Graphics.TPicture.LoadFromFile(TPicture;AnsiString);
|
00606E8C   E8E325E2FF             call    00429474
00606E91   B201                   mov     dl, $01

* Reference to class TJPEGImage
|
00606E93   A10C014F00             mov     eax, dword ptr [$004F010C]

* Reference to: jpeg.TJPEGImage.Create(TJPEGImage;boolean);
|
00606E98   E82395EEFF             call    004F03C0
00606E9D   8BF8                   mov     edi, eax
00606E9F   33D2                   xor     edx, edx
00606EA1   8BC7                   mov     eax, edi

* Reference to: jpeg.TJPEGImage.SetPerformance(TJPEGImage;TJPEGPerformance);
|
00606EA3   E870A7EEFF             call    004F1618
00606EA8   C6473F50               mov     byte ptr [edi+$3F], $50
00606EAC   8B45F0                 mov     eax, [ebp-$10]

* Reference to field TImage.Picture : TPicture
|
00606EAF   8B8068010000           mov     eax, [eax+$0168]

* Reference to field TPicture.Graphic : TGraphic
|
00606EB5   8B500C                 mov     edx, [eax+$0C]
00606EB8   8BC7                   mov     eax, edi
00606EBA   8B08                   mov     ecx, [eax]

* Possible reference to virtual method TJPEGImage.OFFS_08
|
00606EBC   FF5108                 call    dword ptr [ecx+$08]
00606EBF   FF75FC                 push    dword ptr [ebp-$04]
00606EC2   689C706000             push    $0060709C
00606EC7   FF75F8                 push    dword ptr [ebp-$08]

* Possible String Reference to: 'a.jpg'
|
00606ECA   68B8706000             push    $006070B8
00606ECF   8D45F4                 lea     eax, [ebp-$0C]
00606ED2   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
00606ED7   E804E0DFFF             call    00404EE0
00606EDC   8B55F4                 mov     edx, [ebp-$0C]
00606EDF   8BC7                   mov     eax, edi
00606EE1   8B08                   mov     ecx, [eax]

* Possible reference to virtual method TJPEGImage.OFFS_50
|
00606EE3   FF5150                 call    dword ptr [ecx+$50]
00606EE6   FF75FC                 push    dword ptr [ebp-$04]
00606EE9   689C706000             push    $0060709C
00606EEE   FF75F8                 push    dword ptr [ebp-$08]

* Possible String Reference to: 'a.bmp'
|
00606EF1   68A8706000             push    $006070A8
00606EF6   8D45BC                 lea     eax, [ebp-$44]
00606EF9   BA04000000             mov     edx, $00000004

* Reference to: System.Proc_00404EE0
|
00606EFE   E8DDDFDFFF             call    00404EE0
00606F03   8B45BC                 mov     eax, [ebp-$44]

* Reference to: Unit_00408494.Proc_00409F2C
|
00606F06   E82130E0FF             call    00409F2C
00606F0B   8BC7                   mov     eax, edi

* Reference to: System.TObject.Free(TObject);
|
00606F0D   E826CEDFFF             call    00403D38
00606F12   8B45F0                 mov     eax, [ebp-$10]

* Reference to: System.TObject.Free(TObject);
|
00606F15   E81ECEDFFF             call    00403D38
00606F1A   E9E9000000             jmp     00607008
00606F1F   8D45B4                 lea     eax, [ebp-$4C]
00606F22   50                     push    eax
00606F23   8D4DAC                 lea     ecx, [ebp-$54]
00606F26   8B83FC060000           mov     eax, [ebx+$06FC]
00606F2C   8B8018020000           mov     eax, [eax+$0218]
00606F32   8BD6                   mov     edx, esi
00606F34   8B38                   mov     edi, [eax]
00606F36   FF570C                 call    dword ptr [edi+$0C]
00606F39   8B45AC                 mov     eax, [ebp-$54]
00606F3C   8D55B0                 lea     edx, [ebp-$50]

* Reference to: Unit_00408494.Proc_0040A1F0
|
00606F3F   E8AC32E0FF             call    0040A1F0
00606F44   8B45B0                 mov     eax, [ebp-$50]
00606F47   B903000000             mov     ecx, $00000003
00606F4C   BA02000000             mov     edx, $00000002

* Reference to: System.@LStrCopy;
|
00606F51   E822E1DFFF             call    00405078
00606F56   8B45B4                 mov     eax, [ebp-$4C]
00606F59   8D55B8                 lea     edx, [ebp-$48]

* Reference to: Unit_00408494.Proc_004091D8
|
00606F5C   E87722E0FF             call    004091D8
00606F61   8B45B8                 mov     eax, [ebp-$48]

* Possible String Reference to: 'JPG'
|
00606F64   BAC8706000             mov     edx, $006070C8

* Reference to: System.@LStrCmp;
|
00606F69   E8F6DFDFFF             call    00404F64
00606F6E   0F8594000000           jnz     00607008
00606F74   8D45F8                 lea     eax, [ebp-$08]
00606F77   50                     push    eax
00606F78   8D4DA8                 lea     ecx, [ebp-$58]
00606F7B   8B83FC060000           mov     eax, [ebx+$06FC]
00606F81   8B8018020000           mov     eax, [eax+$0218]
00606F87   8BD6                   mov     edx, esi
00606F89   8B38                   mov     edi, [eax]
00606F8B   FF570C                 call    dword ptr [edi+$0C]
00606F8E   8B55A8                 mov     edx, [ebp-$58]
00606F91   B890706000             mov     eax, $00607090

* Reference to: System.@LStrPos;
|
00606F96   E8C1E1DFFF             call    0040515C
00606F9B   48                     dec     eax
00606F9C   50                     push    eax
00606F9D   8D4DA4                 lea     ecx, [ebp-$5C]
00606FA0   8B83FC060000           mov     eax, [ebx+$06FC]
00606FA6   8B8018020000           mov     eax, [eax+$0218]
00606FAC   8BD6                   mov     edx, esi
00606FAE   8B38                   mov     edi, [eax]
00606FB0   FF570C                 call    dword ptr [edi+$0C]
00606FB3   8B45A4                 mov     eax, [ebp-$5C]
00606FB6   BA01000000             mov     edx, $00000001
00606FBB   59                     pop     ecx

* Reference to: System.@LStrCopy;
|
00606FBC   E8B7E0DFFF             call    00405078
00606FC1   6A00                   push    $00
00606FC3   FF75FC                 push    dword ptr [ebp-$04]
00606FC6   FF75F8                 push    dword ptr [ebp-$08]

* Possible String Reference to: '.jpg'
|
00606FC9   68D4706000             push    $006070D4
00606FCE   8D45A0                 lea     eax, [ebp-$60]
00606FD1   BA03000000             mov     edx, $00000003

* Reference to: System.Proc_00404EE0
|
00606FD6   E805DFDFFF             call    00404EE0
00606FDB   8B45A0                 mov     eax, [ebp-$60]

* Reference to: System.@LStrToPChar(String):PAnsiChar;
|
00606FDE   E835E0DFFF             call    00405018
00606FE3   50                     push    eax
00606FE4   8D4D9C                 lea     ecx, [ebp-$64]
00606FE7   8B83FC060000           mov     eax, [ebx+$06FC]
00606FED   8B8018020000           mov     eax, [eax+$0218]
00606FF3   8BD6                   mov     edx, esi
00606FF5   8B38                   mov     edi, [eax]
00606FF7   FF570C                 call    dword ptr [edi+$0C]
00606FFA   8B459C                 mov     eax, [ebp-$64]

* Reference to: System.@LStrToPChar(String):PAnsiChar;
|
00606FFD   E816E0DFFF             call    00405018
00607002   50                     push    eax

* Reference to: kernel32.CopyFileA()
|
00607003   E84C03E0FF             call    00407354
00607008   46                     inc     esi
00607009   FF4DEC                 dec     dword ptr [ebp-$14]
0060700C   0F8552FDFFFF           jnz     00606D64
00607012   A19C5B5302             mov     eax, dword ptr [$02535B9C]

* Reference to: MMSystem.mci_TMSF_Frame(Longint):Byte;
|
00607017   E8A8B9DFFF             call    004029C4
0060701C   8BC3                   mov     eax, ebx

* Reference to : TForm1.anzeigen()
|
0060701E   E879D3FCFF             call    005D439C
00607023   33C0                   xor     eax, eax
00607025   5A                     pop     edx
00607026   59                     pop     ecx
00607027   59                     pop     ecx
00607028   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
0060702B   6862706000             push    $00607062
00607030   8D459C                 lea     eax, [ebp-$64]
00607033   BA12000000             mov     edx, $00000012

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
00607038   E84FDBDFFF             call    00404B8C
0060703D   8D45E4                 lea     eax, [ebp-$1C]

* Reference to: System.@LStrClr(void;void);
|
00607040   E823DBDFFF             call    00404B68
00607045   8D45E8                 lea     eax, [ebp-$18]

* Reference to: System.@LStrClr(void;void);
|
00607048   E81BDBDFFF             call    00404B68
0060704D   8D45F4                 lea     eax, [ebp-$0C]
00607050   BA03000000             mov     edx, $00000003

* Reference to: System.@LStrArrayClr(void;void;Integer);
|
00607055   E832DBDFFF             call    00404B8C
0060705A   C3                     ret


* Reference to: System.@HandleFinally;
|
0060705B   E96CD4DFFF             jmp     004044CC
00607060   EBCE                   jmp     00607030

****** END
|
00607062   5F                     pop     edi
00607063   5E                     pop     esi
00607064   5B                     pop     ebx
00607065   8BE5                   mov     esp, ebp
00607067   5D                     pop     ebp
00607068   C3                     ret

*)
end;
