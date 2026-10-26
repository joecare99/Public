unit Unit13;

{-------------------------------------------------------------------------------
  Unit13 - TForm13, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit13.pas and the original resource
  Source\Projects_AhnenWin\Form13.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, StrUtils, Classes, ExtCtrls, Buttons, Dialogs, StdCtrls, WPPDFR2, WPPDFPRP, Forms, Controls, Grids, DB, Graphics;

type
  TForm13 = class(TForm)
  published
    Panel1: TPanel; //2F0
    SpeedButton11: TSpeedButton; //2F4
    SpeedButton12: TSpeedButton; //2F8
    SpeedButton1: TSpeedButton; //2FC
    PrintDialog1: TPrintDialog; //300
    Label1: TLabel; //304
    Button1: TButton; //308
    FontDialog1: TFontDialog; //30C
    SpeedButton2: TSpeedButton; //310
    Button2: TButton; //314
    Button3: TButton; //318
    Button4: TButton; //31C
    SaveDialog1: TSaveDialog; //320
    PrinterSetupDialog1: TPrinterSetupDialog; //324
    SpeedButton13: TSpeedButton; //328
    Button5: TButton; //32C
    Button6: TButton; //330
    Label2: TLabel; //334
    PaintBox1: TPaintBox; //338
    ScrollBar1: TScrollBar; //33C
    ScrollBar2: TScrollBar; //340
    Memo1: TMemo; //344
    Button7: TButton; //348
    Button8: TButton; //34C
    Label3: TLabel; //350
    WPPDFPrinter1: TWPPDFPrinter; //354
    SpeedButton3: TSpeedButton; //358
    WPPDFProperties1: TWPPDFProperties; //35C
    procedure sub_0056CAD4; //0056CAD4
    procedure nr2; //0056CB30
    procedure nz1(ACanvas: TCanvas); //0056D6B4, ACanvas in EDX
    procedure nz2(ACanvas: TCanvas); //0056EB10, ACanvas in EDX
    procedure schieb_vm; //0056862C
    procedure schieb_vm1; //00568528
    procedure ScrollBar1Change(Sender: TObject); //00572484
    procedure ScrollBar2Change(Sender: TObject); //00572490
    procedure nr1; //0056C0D4
    procedure Nach_erm; //0056A970
    procedure kek_ord; //005686F0
    procedure Proband1Click; //005729E4
    procedure Button7Click(Sender: TObject); //00573120
    procedure vorf_erm2; //00572A78
    procedure SpeedButton3Click(Sender: TObject); //00573450
    procedure sam2; //00572D98
    procedure Symm; //00568834
    procedure kek_ord_2; //00568774
    procedure Verwandtschaft1Click(Sender: TObject); //0057249C
    procedure Button8Click(Sender: TObject); //005730D4
    procedure Vorf_erm1; //00563CF8
    procedure memein(AValue: Integer); //00566220, AValue in EDX
    procedure zerleg(AVal1: Integer; AVal2: Integer; ACanvas: TCanvas); //005675D8, IDR lists a function; result unused at 0056932E
    procedure FormCreate(Sender: TObject); //00570740
    procedure Vorf_erm; //00567A30
    procedure Button1Click(Sender: TObject); //005707C0
    procedure Button2Click(Sender: TObject); //00570838
    procedure SpeedButton2Click(Sender: TObject); //0057082C
    procedure FormShow(Sender: TObject); //00570294
    procedure UpDown1Click; //005661E8
    procedure SpeedButton1Click(Sender: TObject); //005704A8
    procedure FormClose(sender:tobject;var action:tcloseaction); //00570728
    procedure SpeedButton12Click(Sender: TObject); //00570694
    procedure Button3Click(Sender: TObject); //00570854
    procedure vr1; //00570D1C
    procedure SpeedButton13Click(Sender: TObject); //00572478
    procedure vz1(AValue: TCanvas); //005711D4, AValue in EDX
    procedure vz2(AValue: TCanvas); //00569504, AValue in EDX
    procedure Vr2; //0056904C
    procedure nachf_neu; //00564668
    procedure Button4Click(Sender: TObject); //00570890
    procedure PaintBox1Paint(Sender:TObject); //00570C14
    procedure Button6Click(Sender: TObject); //00572448
    procedure Button5Click(Sender: TObject); //00572404
  end;

var
  Form13: TForm13;

implementation

uses
  Unit12, Unit2, AHNGlobals, Math, Printers, jpeg, Types, Unit1;
{$R ..\Forms\Form13.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure sub_005637C4(AValue: Integer; var AResult: AnsiString);
var
  s: AnsiString;
begin
  { Formats the number to 6 digits, zero padded from the right. }
  s := '000000' + IntToStr(AValue);
  AResult := Copy(s, Length(s) - 5, 6);
end;

procedure sub_00563868(AIn: AnsiString; var AOut: AnsiString);
var
  i: Integer;
  c: AnsiChar;
begin
  { Uppercases AIn character by character; the German umlauts
    (which UpperCase does not handle) are mapped manually to
    their respective uppercase form first. }
  AOut := '';
  for i := 1 to Length(AIn) do
  begin
    c := AnsiChar(AIn[i]);
    if c = #$E4 then
      AOut := AOut + #$C4
    else
    begin
      if c = #$F6 then
        AOut := AOut + #$D6
      else
      begin
        if c = #$FC then
          AOut := AOut + #$DC
        else
          AOut := AOut + UpperCase(AnsiString(c));
      end;
    end;
  end;
end;

procedure sub_00563A0C(AIn: AnsiString; var AErgebnis: AnsiString);
var
  s: AnsiString;
  i: Integer;
begin
  { Normalizes a date/comment entry: the prefixes ("..", "HK ", "vor...",
    "nach...") are evaluated, then leading dots and blanks are removed
    and the remaining dots are stripped. }
  AErgebnis := AIn;
  s := AIn;
  if Trim(s) = '..' then
  begin
    AErgebnis := '';
    exit;
  end;
  if Copy(s, 1, 2) = 'HK' then
  begin
    AErgebnis := 'HK ' + Copy(s, 4, 7);
    exit;
  end;
  if Pos('vo.r', s) > 0 then
  begin
    AErgebnis := Copy(s, 1, 2) + Copy(s, 4, 1) + ' ' + RightStr(s, 4);
    exit;
  end;
  if Pos('na.ch', s) > 0 then
  begin
    AErgebnis := Copy(s, 1, 2) + Copy(s, 4, 2) + ' ' + RightStr(s, 4);
    exit;
  end;
  if Trim(s) = '' then
    exit;
  AErgebnis := '';
  while (Length(s) > 0) and ((s[1] = '.') or (s[1] = ' ')) do
    s := Copy(s, 2, 9);
  AErgebnis := s;
  if (Length(s) > 0) and (s[1] > '9') then
  begin
    AErgebnis := '';
    for i := 1 to Length(s) do
      if s[i] <> '.' then
        AErgebnis := AErgebnis + s[i];
    if Length(AErgebnis) > 0 then
      for i := 1 to Length(AErgebnis) do
        if AErgebnis[i] < ':' then
        begin
          Insert(' ', AErgebnis, i);
          break;
        end;
  end;
end;

procedure sub_0056897C(AValue: Integer);
var
  V, passes, lvl, row, edx, ebx, delta: Integer;
begin
  { 0056897C: V-passed normalizer on the grid-A "hi dword" pair
    (offsets -194/-184/+4 like sub_00568C9C), but comparing with
    jge/jle and running V full passes over the level loop. The
    propagation condition compares the level dword with lvl+1. }
  V := AValue;
  if V <= 0 then
    exit;
  passes := V;                                   //0056898B-96
  while passes > 0 do
  begin
    lvl := V - 1;                                //0056899A-A0
    while lvl > 1 do
    begin
      row := Round(Power(2.0, lvl - 1));         //005689A7-CA
      while ChartAFlat(102 * row + 1) = 0 do     //005689CF-DD skipper
        Inc(row);
      repeat                                     //00568AD7-E2
        if ChartAFlat(102 * row + 5) = lvl then  //00568AD8-E2
        begin
          if ChartAFlat(132 * row + 1) > 0 then  //005689E4-F3
          begin
            ebx := ChartAFlat(132 * row + 1);    //005689F5-FC
            if ebx < ChartAFlat(102 * row + 1) then        //00568A03-A6 jge
            begin
              delta := ChartAFlat(102 * row + 1) - ebx;    //00568A10-A28
              SetChartAFlat(132 * row + 1,
                ChartAFlat(102 * row + 1));              //00568A2C-A3B
              edx := 2 * row + 1;                        //00568A2C-A30
              while ChartAFlat(66 * edx + 5) = lvl + 1 do  //00568A5A-69
              begin
                if ChartAFlat(66 * edx + 1) > 0 then     //00568A44-4C
                  SetChartAFlat(66 * edx + 1,
                    ChartAFlat(66 * edx + 1) + delta);   //00568A4E-52
                Inc(edx);                                //00568A59
              end;
            end;
          end
          else if ChartAFlat(132 * row + 103) > 0 then   //00568A6D-72
          begin
            ebx := ChartAFlat(102 * row + 1);            //00568A74
            if ebx > ChartAFlat(132 * row + 102) then    //00568A7B-7E jle
            begin
              delta := ebx - ChartAFlat(132 * row + 103); //00568A80-95
              SetChartAFlat(132 * row + 103, ebx);       //00568A99-AAA
              edx := 2 * row + 2;                        //00568A99-A9D
              while ChartAFlat(66 * edx + 5) = lvl + 1 do  //00568AC6-D5
              begin
                if ChartAFlat(66 * edx + 1) > 0 then     //00568AB0-B8
                  SetChartAFlat(66 * edx + 1,
                    ChartAFlat(66 * edx + 1) + delta);   //00568ABA-BE
                Inc(edx);                                //00568AC5
              end;
            end;
          end;
          Inc(row);                                      //00568AD7
        end
        else
        begin
          Dec(lvl);                                      //00568AE8
          Break;                                         //00568AE9-EC / AF2
        end;
      until False;
    end;
    Dec(passes);                                         //00568AF2-F6
  end;
end;

procedure sub_00568B04(AValue: Integer);
var
  V, passes, lvl, row, edx, ebx, delta: Integer;
begin
  { 00568B04: same normalizer as sub_0056897C, one dword lower in the
    cell (offsets -198/-184/bare) like sub_00568E3C vs 968C9C. }
  V := AValue;
  if V <= 0 then
    exit;
  passes := V;                                   //00568B13-18
  while passes > 0 do
  begin
    lvl := V - 1;                                //00568B22-25
    while lvl > 1 do
    begin
      row := Round(Power(2.0, lvl - 1));         //00568B2F-52
      while ChartAFlat(102 * row) = 0 do         //00568B57-65 skipper
        Inc(row);
      repeat                                     //00568C6D-78
        if ChartAFlat(102 * row + 5) = lvl then  //00568C6E-78
        begin
          if ChartAFlat(132 * row) > 0 then      //00568B6C-7C
          begin
            if ChartAFlat(132 * row) <
               ChartAFlat(102 * row) then        //00568B7E-8C jge
            begin
              delta := ChartAFlat(102 * row) -
                       ChartAFlat(132 * row);    //00568B92-A5
              SetChartAFlat(132 * row,
                ChartAFlat(102 * row));          //00568BAE-BBF
              edx := 2 * row + 1;                //00568BA9-BAD
              while ChartAFlat(66 * edx + 5) = lvl + 1 do  //00568BDE-ED
              begin
                if ChartAFlat(66 * edx) > 0 then         //00568BC8-D0
                  SetChartAFlat(66 * edx,
                    ChartAFlat(66 * edx) + delta);       //00568BD2-D6
                Inc(edx);                                //00568BDD
              end;
            end;
          end
          else if ChartAFlat(132 * row + 102) > 0 then   //00568BF1-FC
          begin
            if ChartAFlat(102 * row) >
               ChartAFlat(132 * row + 102) then          //00568BFE-0F jle
            begin
              delta := ChartAFlat(102 * row) -
                       ChartAFlat(132 * row + 102);      //00568C11-25
              SetChartAFlat(132 * row + 102,
                ChartAFlat(102 * row));                 //00568C29-41
              edx := 2 * row + 2;                       //00568C29-C2D
              while ChartAFlat(66 * edx + 5) = lvl + 1 do  //00568C5C-6B
              begin
                if ChartAFlat(66 * edx) > 0 then        //00568C46-4E
                  SetChartAFlat(66 * edx,
                    ChartAFlat(66 * edx) + delta);      //00568C50-54
                Inc(edx);                               //00568C5B
              end;
            end;
          end;
          Inc(row);                                     //00568C6D
        end
        else
        begin
          Dec(lvl);                                     //00568C7E
          Break;                                        //00568C7F-82 / C88
        end;
      until False;
    end;
    Dec(passes);                                        //00568C88-8C
  end;
end;

{ Phase-B note (both walkers below). The addressing is transliterated
  1:1 into flat dword indexes of grid A via ChartAFlat/SetChartAFlat:
  every term [esi + T*8 + K] with esi = 011AE35C = base + $198 becomes
  index 2*T + 102 + (K div 4). With T = $21*ebx = 51*ebx (set by
  "imul eax,ebx,33") the indexes 102*ebx+c address row ebx dword c,
  and with T = $42*ebx = 102*ebx ("add eax,eax; imul ...,33") the
  indexes 132*ebx+c address the corresponding fields of the paired
  "doubling" row; the propagation loops walk T = 33*eax = 51*eax,
  i.e. index 66*eax+c. The "Power" call idiom is the Pascal-convention
  build of Power(2.0, N) with N = level-1 (first push = 2.0 exponent
  high/low, last = base N), so Round(Power(2.0, lvl-1)) = 2^(lvl-1). }

procedure sub_00568C9C(AValue: Integer);
var
  V, lvl, ebx, eax, t1, delta: Integer;
begin
  { 00568C9C. }
  V := AValue;
  lvl := V - 1;
  while lvl >= 1 do
  begin
    ebx := Round(Power(2.0, lvl - 1));          //00568CB8-DDB
    while ChartAFlat(102 * ebx + 1) = 0 do      //00568CE2-F0 skipper
      Inc(ebx);
    repeat                                      //00568E17-E2B
      if ChartAFlat(102 * ebx + 5) = lvl then   //00568E18-E22
      begin
        if ChartAFlat(102 * ebx + 1) > 0 then   //00568CF7-FF
        begin
          if (ChartAFlat(102 * ebx + 103) > 0) and        //00568D05-0D
             (ChartAFlat(132 * ebx + 1) <> 0) and         //00568D0F-1E
             (ChartAFlat(132 * ebx + 103) <> 0) then      //00568D20-2C
            sub_0056897C(V);                              //00568D2E-31
        end;
        t1 := ChartAFlat(132 * ebx + 1);                  //00568D36-3D
        if t1 > 0 then                                    //00568D44-46
        begin
          if t1 <> ChartAFlat(102 * ebx + 1) then         //00568D48-56
          begin
            delta := t1 - ChartAFlat(102 * ebx + 1);      //00568D5C-6F
            SetChartAFlat(102 * ebx + 1, t1);             //00568D73-7A
            eax := ebx + 1;                               //00568D81
            while ChartAFlat(66 * eax + 5) = lvl do       //00568D84-A6
            begin
              if ChartAFlat(66 * eax + 1) > 0 then        //00568D86-8E
                SetChartAFlat(66 * eax + 1,
                  ChartAFlat(66 * eax + 1) + delta);      //00568D90-94
              Inc(eax);                                   //00568D9B
            end;
          end;
        end
        else if ChartAFlat(132 * ebx + 103) > 0 then      //00568DAA-AF
        begin
          if ChartAFlat(102 * ebx + 1) <>
             ChartAFlat(132 * ebx + 103) then             //00568DB1-C3
          begin
            delta := ChartAFlat(132 * ebx + 103) -
                     ChartAFlat(102 * ebx + 1);           //00568DC5-DA
            SetChartAFlat(102 * ebx + 1,
              ChartAFlat(132 * ebx + 103));               //00568DDE-E9
            eax := ebx + 1;                               //00568DF0
            while ChartAFlat(66 * eax + 5) = lvl do       //00568DF3-15
            begin
              if ChartAFlat(66 * eax + 1) > 0 then        //00568DF5-FD
                SetChartAFlat(66 * eax + 1,
                  ChartAFlat(66 * eax + 1) + delta);      //00568DFF-03
              Inc(eax);                                   //00568E0A
            end;
          end;
        end;
        Inc(ebx);                                         //00568E17
      end
      else
      begin
        Dec(lvl);                                         //00568E28
        Break;                                            //00568E29-2B / CB8
      end;
    until False;
  end;
end;

procedure sub_00568E3C(AValue: Integer);
var
  V, lvl, ebx, eax, t1, delta: Integer;
begin
  { 00568E3C: same walker as sub_00568C9C, one dword lower in every
    8-byte cell (offsets -198/-184/bare instead of -194/-184/+4) and
    calling sub_00568B04 instead of sub_0056897C. }
  V := AValue;
  lvl := V - 1;
  while lvl >= 1 do
  begin
    ebx := Round(Power(2.0, lvl - 1));          //00568E58-7B
    while ChartAFlat(102 * ebx) = 0 do          //00568E82-90 skipper
      Inc(ebx);
    repeat                                      //00568FB1-FC5
      if ChartAFlat(102 * ebx + 5) = lvl then   //00568FB2-BC
      begin
        if ChartAFlat(102 * ebx) > 0 then       //00568E97-9F
        begin
          if (ChartAFlat(102 * ebx + 102) > 0) and        //00568EA5-AC
             (ChartAFlat(132 * ebx) <> 0) and             //00568EAE-BD
             (ChartAFlat(132 * ebx + 102) <> 0) then      //00568EBF-CA
            sub_00568B04(V);                              //00568ECC-F0
        end;
        t1 := ChartAFlat(132 * ebx);                      //00568ED4-E2
        if t1 > 0 then                                    //00568EE2-E4
        begin
          if t1 <> ChartAFlat(102 * ebx) then             //00568EED-F4
          begin
            delta := t1 - ChartAFlat(102 * ebx);          //00568EFA-0D
            SetChartAFlat(102 * ebx, t1);                 //00568F11-18
            eax := ebx + 1;                               //00568F1F
            while ChartAFlat(66 * eax + 5) = lvl do       //00568F22-44
            begin
              if ChartAFlat(66 * eax) > 0 then            //00568F24-2C
                SetChartAFlat(66 * eax,
                  ChartAFlat(66 * eax) + delta);          //00568F2E-32
              Inc(eax);                                   //00568F39
            end;
          end;
        end
        else if ChartAFlat(132 * ebx + 102) > 0 then      //00568F48-4C
        begin
          if ChartAFlat(102 * ebx) <>
             ChartAFlat(132 * ebx + 102) then             //00568F4E-5F
          begin
            delta := ChartAFlat(132 * ebx + 102) -
                     ChartAFlat(102 * ebx);               //00568F61-75
            SetChartAFlat(102 * ebx,
              ChartAFlat(132 * ebx + 102));               //00568F79-83
            eax := ebx + 1;                               //00568F8A
            while ChartAFlat(66 * eax + 5) = lvl do       //00568F8D-AF
            begin
              if ChartAFlat(66 * eax) > 0 then            //00568F8F-97
                SetChartAFlat(66 * eax,
                  ChartAFlat(66 * eax) + delta);          //00568F99-9D
              Inc(eax);                                   //00568FA4
            end;
          end;
        end;
        Inc(ebx);                                         //00568FB1
      end
      else
      begin
        Dec(lvl);                                         //00568FC2
        Break;                                            //00568FC3-5 / E58
      end;
    until False;
  end;
end;

procedure sub_00568FD4;
var
  best, r: Integer;
begin
  { 00568FD4: scan chart grid A (gvar_011AE1C4) while row r's
    active/Count field is > 0, tracking the maximum of the row's
    dword[5]; the disassembly anchors the array at label 011AE35C =
    grid A row (r+1) dword[0], so the terms are
    [ebx + r*408 - $190] = gridA[r].dword[2] and
    [ebx + r*408 - $184] = gridA[r].dword[5].
    Passing the maximum to sub_00568C9C. }
  best := 0;
  r := 1;
  while gvar_011AE1C4[r][2] > 0 do
  begin
    if best < gvar_011AE1C4[r][5] then
      best := gvar_011AE1C4[r][5];
    Inc(r);
  end;
  sub_00568C9C(best);
end;

procedure sub_00569010;
var
  best, r: Integer;
begin
  { 00569010: identical scan (see sub_00568FD4); the maximum is
    passed to sub_00568E3C instead. }
  best := 0;
  r := 1;
  while gvar_011AE1C4[r][2] > 0 do
  begin
    if best < gvar_011AE1C4[r][5] then
      best := gvar_011AE1C4[r][5];
    Inc(r);
  end;
  sub_00568E3C(best);
end;

procedure TForm13.sub_0056CAD4;
var
  gen, count, r, edi: Integer;
begin
  { 0056CAD4: horizontal push variant for the 'Nachgr2' layout -
    same conditional slot-right-shift as nr1's push passes, but on
    the x/d0 columns: anchor eax = 11AE370 = row R + 20 (d5); thus
    [eax] = d5(row), [eax-14] = d0(row), [eax+198] = d5(next row),
    [eax+184] = d0(next row). One push pass over the row pairs for
    every level count = 328-1 (levels 2..328-1); nothing is written
    in-place beyond next-row d0. Flat index convention:
    ChartAFlat(102*r + 5) = d5, ChartAFlat(102*r) = d0. }
  if gvar_011AE328 < 2 then                                        //0056CAD6-D
    Exit;                                                          //0056CADD
  count := gvar_011AE328 - 2;                                      //0056CADF-E5
  if count < 0 then                                                //0056CAE8
    Exit;
  count := count + 1;                                              //0056CAEA
  gen := 2;                                                        //0056CAEB
  repeat
    if gvar_011AE344 > 1 then begin                                //0056CAF0-F7
      r := 1;                                                      //0056CAFB
      repeat
        edi := ChartAFlat(102 * r + 5);                            //0056CB00-C
        if (gen = edi) and                                         //0056CB02-C
           (edi = ChartAFlat(102 * (r + 1) + 5)) then
        begin
          edi := ChartAFlat(102 * r);                              //0056CB0E
          if edi >= ChartAFlat(102 * (r + 1)) then begin           //0056CB11-F
            edi := edi + 1;                                        //0056CB19
            SetChartAFlat(102 * (r + 1), edi);                     //0056CB1A
          end;
        end;
        r := r + 1;                                                //0056CB20-26
      until r > gvar_011AE344 - 1;
    end;
    gen := gen + 1;                                                //0056CB28
    count := count - 1;                                            //0056CB29-2A
  until count <= 0;
end;

procedure TForm13.nr2;
var
  row, child, i0, count, lvl, esi: Integer;
  gen, lastEsi, curGen, posIdx: Integer;
  tmpS, tmpS2, tmpS3: AnsiString;
  marked, processed, tmpGenC, msg: AnsiString;
  pair1, pair2: AnsiString;
begin
  { 0056CB30: Nachfahren-Graph 'Nachgr2' vorbereiten (nr2). Same grid-A
    row layout as nr1 (anchor edi = 011AE35C = row 1 start, so
    [edi + 408*row + K] = row 'row' at in-row offset K). Differences to
    nr1: 011AE33C/011AE340 swapped, 61F114 gets *30 as well, x1/y1 are
    preloaded from gvar_02522AD8/0252C718, duplicate Nummer warnings
    go to Memo1, and the alignment works on father/mother pairs
    (d7/d8) before calling sub_0056CAD4. Stack locals: [ebp-38] =
    current generation, [ebp-3C] = position within the generation,
    [ebp-40] = marker list, [ebp-44] = processed list,
    [ebp-34] = last matched row, esi = the processed row register
    (kept across both alignment phases, 0 on entry). }
  esi := 0;
  gvar_011AE33C := Round(gvar_0061F120 * 45);                       //0056CB88-67
  gvar_011AE340 := 30;                                              //0056CB6C
  gvar_0061F118 := Round(gvar_0061F120 * 30);                       //0056CB76
  gvar_0061F114 := Round(gvar_0061F120 * 30);                       //0056CB8C
  gvar_011AE334 := Round(gvar_0061F120 * 120) + gvar_011AE338;      //0056CB9E-9
  Screen.Cursor := crHourGlass;                                     //0056CBB-E9
  gvar_02536364 := 0;                                               //0056CBCE
  gvar_02536368 := 0;                                               //0056CBD5
  if PaintBox1.Canvas = gvar_011AE32C then begin                    //0056CBDC-F1
    gvar_02536364 := ScrollBar1.Position;                           //0056CBF3
    gvar_02536368 := ScrollBar2.Position;                           //0056CC07
  end;
  gvar_011AE348 := 0;                                               //0056CC1B
  gvar_0253637C := 0;                                               //0056CC22
  gvar_011AE318 := 0;                                               //0056CC29
  gvar_011AE32C.Font.Name := 'Arial';                               //0056CC30
  gvar_011AE32C.Font.Size := Round(gvar_0061F120 * 9);              //0056CC42
  gvar_011AE318 := -gvar_011AE32C.Font.Height + 2;                  //0056CC62
  PaintBox1.Canvas.Font.Size := Round(gvar_0061F120 * 9);           //0056CC79
  gvar_011AE318 := -PaintBox1.Canvas.Font.Height + 2;               //0056CCA3
  gvar_0253636C := 0;                                               //0056CCC4

  if Printer.Canvas = gvar_011AE32C then begin                      //0056CCDF-EF
    gvar_0253636C := 0.6;                                           //0056CCF5
    Printer.Canvas.Font.Name := 'Arial';                            //0056CD12
    Printer.Canvas.Font.Size := Round(gvar_0061F120 * 9);           //0056CD29
    count := PaintBox1.Canvas.Pen.Width;                            //0056CD50
    Printer.Canvas.Pen.Width := Round(count * gvar_0253636C);       //0056CDA3-CD8E
  end;
  if PaintBox1.Canvas <> gvar_011AE32C then                         //0056CD8E
    gvar_0253636C := 0.1;                                           //0056CDA5

  DataModule2.Table17.IndexName := '';                              //0056CDC2-D6
  marked := '';                                                     //0056CDD6
  processed := '';                                                  //0056CDE3
  curGen := 1;                                                      //0056CDEB
  posIdx := 1;                                                      //0056CDF2

  { 0056CE0C-E1: reload columns x1/y1 from the 'Nachgr2' sources. }
  row := 1;
  while ChartAFlat(102 * row + 2) > 0 do begin                      //0056D0E5-0F0
    SetChartAFlat(102 * row, gvar_02522AD8[row]);                   //0056CE0C-5
    SetChartAFlat(102 * row + 1, gvar_0252C718[row]);               //0056CE1A
    if ChartAFlat(102 * row + 5) <> curGen then begin               //0056CE1A-3A
      curGen := ChartAFlat(102 * row + 5);
      posIdx := 1;
    end;
    for i0 := 0 to 19 do begin                                      //0056CE3A-70
      ChartSlotAnsi(i0)^ := '';
      ChartAAnsi(102 * row + 18 + i0)^ := '';
    end;
    DataModule2.Table17.FindKey([ChartAFlat(102 * row + 3)]);       //0056CE72-95
    memein(ChartAFlat(102 * row + 11));                             //0056CE9A
    sub_005637C4(ChartAFlat(102 * row + 3), tmpS2);                 //0056CEAC-B9
    tmpS2 := tmpS2 + '*';                                           //0056CEBE-C6
    if Pos(tmpS2, marked) = 0 then begin                            //0056CECB-CED8
      { Nummer not seen yet: append the generation/position markers. }
      sub_005637C4(ChartAFlat(102 * row + 3), tmpS);                //0056CEE1-EE
      marked := marked + tmpS + '*' +                               //0056CEDE-76
        RightStr('0' + IntToStr(curGen), 2) + '*' +
        RightStr('00' + IntToStr(posIdx), 3) + '*';
    end else begin
      { Nummer already marked: emit a duplicate warning. }
      sub_005637C4(ChartAFlat(102 * row + 3), tmpS);                //0056CF8C
      tmpGenC := Copy(marked, Pos(tmpS, marked) + 7, 2);            //0056CFA1-BC
      tmpS3 := Copy(marked, Pos(tmpS, marked) + 10, 3);             //0056CFE9-19
      msg := '***' + #13#10 + 's.a. Gen. ' +                        //0056CFD2-45
        IntToStr(StrToInt(tmpGenC)) + ' Pos. ' +
        IntToStr(StrToInt(tmpS3));
      Memo1.Lines.Add(msg);                                         //0056D04A-61
      sub_005637C4(ChartAFlat(102 * row + 3), tmpS);                //0056D067
      processed := processed + tmpS + '*';                          //0056D064-8F
    end;
    zerleg(gvar_011AE334, gvar_011AE318, gvar_011AE32C);            //0056D094-A
    for i0 := 0 to 19 do                                            //0056D0AE-DF
      ChartAAnsi(102 * row + 18 + i0)^ := ChartSlotAnsi(i0)^;
    Inc(row);                                                       //0056D0E1
    Inc(posIdx);                                                    //0056D0E2
  end;

  if gvar_0061F2BC = 1 then                                          //0056D0F6-D
    gvar_011AE348 := Round(((gvar_0253637C * gvar_011AE318) +        //0056D0FF-10
      gvar_011AE318) * 4 / 5);

  { 0056D129-222: mark pass for Vater d7 (row index) / Mutter d8,
    stopping at rows 1 .. 011AE344-1; bytes 316/318 flag processed
    rows. Anchor edi = 011AE364 = row 1 d2: [edi] = d2(row),
    [edi+4] = d3(row). }
  if gvar_011AE344 > 1 then                                         //0056D129-31
    for row := 1 to gvar_011AE344 - 1 do
      if ChartAFlat(102 * row + 2) > 0 then begin                    //0056D13F-47
        child := 1;                                                  //0056D14D
        while ChartAFlat(102 * child + 2) > 0 do begin               //0056D202-E
          if (ChartAFlat(102 * child + 7) > 0) and                   //0056D159-91
             (ChartAFlat(102 * child + 7) = ChartAFlat(102 * row + 3)) and
             (ChartAShort(child, 316)^ <> '*') then begin
            SetChartAFlat(102 * child + 7, row);                     //0056D193-8
            ChartAShort(child, 316)^ := '*';
          end;
          { same for the mother d8/b318 }
          if (ChartAFlat(102 * child + 8) > 0) and                   //0056D1AC-E4
             (ChartAFlat(102 * child + 8) = ChartAFlat(102 * row + 3)) and
             (ChartAShort(child, 318)^ <> '*') then begin
            SetChartAFlat(102 * child + 8, row);                     //0056D1E6-F
            ChartAShort(child, 318)^ := '*';
          end;
          Inc(child);                                                //0056D1FF
        end;
      end;

  { 0056D224-2D4: d10 partner pass - the partner row index is the
    child's own index minus one, and x1/y1 are then synced back to
    the 'Nachgr2' sources gvar_02522AD8/0252C718 (converted anchors:
    [edi-8] = d0(row), [edi-4] = d1(row)). }
  if gvar_011AE344 > 1 then                                         //0056D224-C
    for row := 1 to gvar_011AE344 - 1 do
      if ChartAFlat(102 * row + 2) > 0 then begin                    //0056D248-B
        child := 1;
        while ChartAFlat(102 * child + 2) > 0 do begin               //0056D29D-A0
          if (ChartAFlat(102 * child + 10) > 0) and                  //0056D256-93
             (ChartAFlat(102 * child + 10) = ChartAFlat(102 * row + 3)) and
             (ChartAShort(child, 320)^ <> '*') then begin
            SetChartAFlat(102 * child + 10, child - 1);              //0056D288
            ChartAShort(child, 320)^ := '*';
          end;
          Inc(child);
        end;
        gvar_02522AD8[row] := ChartAFlat(102 * row);                 //0056D2AE
        gvar_0252C718[row] := ChartAFlat(102 * row + 1);             //0056D2B6
      end;

  { 0056D2D5-46A: alignment over father/mother pairs. Per row:
    pair1 = Num2Str(d7) + '*' + Num2Str(d8) is rebuilt first (it is
    built for every row - also for rows failing the d5/processed
    checks, mirroring the listing). Anchor conversions: [ebx] = d7,
    [ebx+4] = d8, [ebx-8] = d5, [ebx-10] = d3, [ebx-1C] = d0 of the
    row; sub_0056CAD4 pushes overlapping siblings. }
  count := Round(gvar_011AE328 / 2) + 1;                            //0056D2D5-6
  if count > 0 then                                                 //0056D2E7-9
    repeat
      if gvar_011AE328 >= 1 then begin                              //0056D2F2-F7
        lvl := gvar_011AE328;                                       //0056D300
        repeat
          lastEsi := 0;                                             //0056D303
          if gvar_011AE344 > 0 then begin                           //0056D316-A
            for row := 1 to gvar_011AE344 do begin                  //0056D31B-450
              sub_005637C4(ChartAFlat(102 * row + 7), tmpS);        //0056D31B-23
              sub_005637C4(ChartAFlat(102 * row + 8), tmpS2);       //0056D333-C
              pair1 := tmpS + '*' + tmpS2;                          //0056D347-40
              if ChartAFlat(102 * row + 5) = lvl then begin         //0056D354-60
                sub_005637C4(ChartAFlat(102 * row + 3), tmpS3);     //0056D366
                if Pos(tmpS3, processed) = 0 then begin             //0056D36E-E
                  esi := ChartAFlat(102 * row + 7);                 //0056D384
                  if ChartAFlat(102 * row + 8) < esi then           //0056D386-C
                    esi := ChartAFlat(102 * row + 8);
                  sub_005637C4(ChartAFlat(102 * row + 7), tmpS);    //0056D395-D3B7
                  sub_005637C4(ChartAFlat(102 * row + 8), tmpS2);   //0056D3AD
                  pair2 := tmpS + '*' + tmpS2;                      //0056D3BB-6
                  if CompareStr(pair2, pair1) <> 0 then begin       //0056D3CB-9
                    if (esi > 0) and (esi <> lastEsi) then begin        //0056D3DB-2
                      sub_005637C4(ChartAFlat(102 * row + 7), tmpS); //0056D3EA
                      sub_005637C4(ChartAFlat(102 * row + 8), tmpS2); //0056D402
                      pair1 := tmpS + '*' + tmpS2;                  //0056D410
                      if ChartAFlat(102 * esi) > ChartAFlat(102 * row) then //0056D41D-2
                        SetChartAFlat(102 * row, ChartAFlat(102 * esi)) //0056D43B-6
                      else
                        SetChartAFlat(102 * esi, ChartAFlat(102 * row)); //0056D43B-D441
                      sub_0056CAD4;                                 //0056D448
                      lastEsi := esi;                               //0056D44D
                    end;
                  end;
                end;
              end;
            end;
          end;
          Dec(lvl);                                                 //0056D45D
        until lvl <= 0;
      end;
      Dec(count);                                                   //0056D531
    until count <= 0;

  { 0056D46A-52B: alignment from generation 2 upward row by row - the
    esi + 1 guard skips rows already covered by the last processed
    pair, then the d0 columns of both rows in a pair are equalized
    (max of both) before sub_0056CAD4. }
  if gvar_011AE328 >= 2 then begin                                  //0056D46A-79
    count := gvar_011AE328 - 2;                                     //0056D470
    count := count + 1;                                             //0056D479
    gen := 2;                                                       //0056D47A
    repeat
      lastEsi := 0;                                                 //0056D481
      if gvar_011AE344 > 0 then begin                               //0056D486-91
        for row := 1 to gvar_011AE344 do begin                      //0056D496-D51E
          if not ((esi + 1 >= ChartAFlat(102 * row + 7)) and        //0056D49B-24
                  (esi + 1 >= ChartAFlat(102 * row + 8))) then begin
            if ChartAFlat(102 * row + 5) = gen then begin           //0056D4A7-AD
              sub_005637C4(ChartAFlat(102 * row + 3), tmpS);        //0056D4AF
              if Pos(tmpS, processed) = 0 then begin                //0056D4BD-CD
                esi := ChartAFlat(102 * row + 7);                   //0056D4CF-D6
                if ChartAFlat(102 * row + 8) < esi then
                  esi := ChartAFlat(102 * row + 8);
                if (esi > 0) and (esi <> lastEsi) then begin            //0056D4DC-E3
                  if ChartAFlat(102 * esi) > ChartAFlat(102 * row) then //0056D4E5-1
                    SetChartAFlat(102 * row, ChartAFlat(102 * esi)) //0056D503
                  else
                    SetChartAFlat(102 * esi, ChartAFlat(102 * row)); //0056D503-9
                  sub_0056CAD4;                                     //0056D510
                  lastEsi := esi;                                   //0056D515
                end;
              end;
            end;
          end;
        end;
      end;
      Inc(gen);                                                     //0056D527
      Dec(count);                                                   //0056D52A-D34
    until count <= 0;
  end;

  { 0056D53A-8A: track the maximal d0 column in gvar_011AE320 and the
    maximal d1 row in gvar_011AE324. }
  row := 1;
  while ChartAFlat(102 * row + 2) > 0 do begin                      //0056D57E-8A
    if ChartAFlat(102 * row) > gvar_011AE320 then                   //0056D541-4
      gvar_011AE320 := ChartAFlat(102 * row);                       //0056D550
    if ChartAFlat(102 * row + 1) > gvar_011AE324 then               //0056D560-D
      gvar_011AE324 := ChartAFlat(102 * row + 1);                   //0056D578
    Inc(row);                                                       //0056D57E
  end;

  ScrollBar1.LargeChange := PaintBox1.Width - 5;                    //0056D58C-91
  ScrollBar2.LargeChange := PaintBox1.Height - 5;                   //0056D5AD-C7
  ScrollBar1.SmallChange := 10;                                     //0056D5D1
  ScrollBar2.SmallChange := 10;                                     //0056D5E3
  Screen.Cursor := crDefault;                                       //0056D5F2
end;

procedure TForm13.nz1(ACanvas: TCanvas); //0056D6B4
{ Draws the "Nachfahren" chart variant 1 from the grid-B working copy.
  Listing: esi = $197665C = gvar_019764C4[1]; every  [esi + 408*row + X]
  translates to  gvar_019764C4[row][(408 + X) div 4]  (same map as vz1:
  -198->d0, -194->d1, -190->d2, -18C->d3, -184->d5, -17C/-178->d7/d8,
  -174->d9, -170/-16C->d10/d11, -168->d12, -150->ptrs@72, -100->@152,
  -0D7->@193, -56->@322); every  [edi*8 + 11AE1CC + n]  with
  edi = 51*row -> gvar_011AE1C4[row][k]. EBP aliases: [ebp-8] = ACanvas. }
var
  row, shift, ebp14, slotRow, slotI: Integer;      // [ebp-14]=[ebp-10]=[ebp-0C]
  tName, tVor, tmpS, wasSchon: AnsiString;         // [ebp-154..]/[ebp-1C]
  img: TImage;                                     // edi in the photo block
  q1, q2: Integer;
  ratio: Extended;                                 // [ebp-1D4]
  jpegFlag: Boolean;                               // [ebp-1D]
  aRect: TRect;                                    // [ebp-34]
begin
  { 0056D6B4: copies grid A rows into grid B, rescales the coordinates
    and paints title, child connectors, boxes, names and photos. }
  Screen.Cursor := crHourGlass;                                     //0056D6E0-EB
  PaintBox1.Canvas.Brush.Color := $FFFFFF;                          //0056D6F0-07
  PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height)); //0056D70C-32
  gvar_02536364 := 0;                                               //0056D737-3E
  gvar_02536368 := 0;                                               //0056D73E-40
  if PaintBox1.Canvas = ACanvas then begin                          //0056D745-57
    gvar_02536364 := ScrollBar1.Position;                           //0056D759-68
    gvar_02536368 := ScrollBar2.Position;                           //0056D76D-7C
  end;
  { Copy grid A -> grid B (rescaled). }
  row := 1;                                                         //0056D781
  while gvar_011AE1C4[row][2] > 0 do begin                          //0056D786-953 loop
    DataModule2.Table17.FindKey([gvar_011AE1C4[row][3]]);           //0056D78B-B0
    gvar_019764C4[row][2] := gvar_011AE1C4[row][2];                 //0056D7B0-B7
    gvar_019764C4[row][3] := gvar_011AE1C4[row][3];                 //0056D7BE-C5
    gvar_019764C4[row][5] := gvar_011AE1C4[row][5];                 //0056D7CC-D3
    tmpS := UpperCase(ChartAShort(row, 193)^);                      //0056D7DA-D08
    ChartBShort(row, 193)^ := tmpS;                                 //0056D813-26 (@PStrNCpy cl=28)
    gvar_019764C4[row][7] := gvar_011AE1C4[row][7];                 //0056D827-2E
    gvar_019764C4[row][8] := gvar_011AE1C4[row][8];                 //0056D835-3C
    for shift := 0 to 19 do                                         //0056D843-61 (@CopyArray 20 dwords)
      ChartBAnsi(102 * row + 18 + shift)^ := ChartAAnsi(102 * row + 18 + shift)^;
    ChartBShort(row, 152)^ := ChartAShort(row, 152)^;               //0056D862-76 (@PStrNCpy cl=28)
    gvar_019764C4[row][9] := gvar_011AE1C4[row][9];                 //0056D877-7E
    gvar_019764C4[row][10] := gvar_011AE1C4[row][10];               //0056D885-8C
    gvar_019764C4[row][11] := gvar_011AE1C4[row][11];               //0056D893-9A
    ChartBShort(row, 322)^ := ChartAShort(row, 322)^;               //0056D8A1-B2 (@PStrNCpy cl=50)
    gvar_019764C4[row][12] := gvar_011AE1C4[row][12];               //0056D8B3-BA
    gvar_019764C4[row][0] := (gvar_011AE1C4[row][0] - 1) * (gvar_011AE334 + gvar_0061F118) + gvar_011AE340 - gvar_02536364; //0056D8C1-E7
    gvar_019764C4[row][1] := (gvar_011AE1C4[row][1] - 1) * (gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_0061F114 + gvar_011AE348) + gvar_011AE33C - gvar_02536368; //0056D8EE-27
    if gvar_011AE1C4[row][0] > gvar_011AE320 then                   //0056D92E-3E
      gvar_011AE320 := gvar_011AE1C4[row][0];                       //0056D940-4F
    Inc(row);                                                       //0056D94F
  end;
  { Title "Nachfahren von <Name> <Vorname>" from the row-1 person. }
  DataModule2.Table17.FindKey([gvar_019764C4[1][3]]);               //0056D961-82
  tmpS := DataModule2.Table17Name.AsString;                         //0056D987-9F
  sub_00563868(tmpS, tName);                                        //0056D9A5-AB
  tVor := DataModule2.Table17Vornamen.AsString;                     //0056D9BB-D3
  wasSchon := 'Nachfahren von ' + tName + ' ' + tVor;               //0056D9D9-E9 (@LStrCatN)
  ACanvas.TextOut(Round(gvar_0253636C * 30) - gvar_02536364,        //0056D9F0-2C
    Round(gvar_0253636C * 5) - gvar_02536368, wasSchon);
  gvar_011AE324 := 0;                                               //0056DA31-33
  gvar_011AE31C := 0;                                               //0056DA38-3A
  { Child connectors: elbow to the left from the box edge. }
  row := 1;                                                         //0056DA3F
  while gvar_019764C4[row][2] > 0 do begin                          //0056DA44-DF01
    if gvar_019764C4[row][1] > 0 then begin                         //0056DA49-51
      if gvar_019764C4[row][5] < gvar_011AE330 then begin           //0056DA57-64 (father block skipped otherwise)
        if gvar_019764C4[row][5] > 1 then                           //0056DA6A-75
          if gvar_019764C4[row][7] > 0 then                         //0056DA7B-83
            if gvar_019764C4[gvar_019764C4[row][7]][1] > gvar_019764C4[gvar_019764C4[row][8]][1] then begin //0056DA89-AAA
              shift := gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348; //0056DAB7-C8
              ACanvas.MoveTo(Round(gvar_019764C4[row][0] * gvar_0253636C),      //0056DAB0-0A
                Round(gvar_0253636C * (gvar_019764C4[row][1] + shift / 2)));
              ACanvas.LineTo(Round((gvar_019764C4[row][0] - gvar_0061F118 / 2) * gvar_0253636C), //0056DB0F-A
                Round(gvar_0253636C * (gvar_019764C4[row][1] + shift / 2)));
              ACanvas.LineTo(Round((gvar_019764C4[row][0] - gvar_0061F118 / 2) * gvar_0253636C), //0056DB7C-EC
                Round(gvar_0253636C * (gvar_019764C4[gvar_019764C4[row][7]][1] + shift / 2)));
              ACanvas.LineTo(Round((gvar_019764C4[row][0] - gvar_0061F118 - 1) * gvar_0253636C), //0056DBF1-66
                Round(gvar_0253636C * (gvar_019764C4[gvar_019764C4[row][7]][1] + shift / 2)));
            end;
      end;
      { 0056DC6B: the mother connector runs for every row (both d5 skips
        jump straight here). }
      if (gvar_019764C4[row][8] > 0) and                                           //0056DC6B-73
         (gvar_019764C4[gvar_019764C4[row][8]][1] > gvar_019764C4[gvar_019764C4[row][7]][1]) then begin //0056DC79-9A
        shift := gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348; //0056DCAC-BD
        ACanvas.MoveTo(Round(gvar_019764C4[row][0] * gvar_0253636C),        //0056DCA0-FA
          Round(gvar_0253636C * (gvar_019764C4[row][1] + shift / 2)));
        ACanvas.LineTo(Round((gvar_019764C4[row][0] - gvar_0061F118 / 2) * gvar_0253636C), //0056DCFF-67
          Round(gvar_0253636C * (gvar_019764C4[row][1] + shift / 2)));
        ACanvas.LineTo(Round((gvar_019764C4[row][0] - gvar_0061F118 / 2) * gvar_0253636C), //0056DD6C-=DC
          Round(gvar_0253636C * (gvar_019764C4[gvar_019764C4[row][8]][1] + shift / 2)));
        ACanvas.LineTo(Round((gvar_019764C4[row][0] - gvar_0061F118 - 1) * gvar_0253636C), //0056DDE1-56
          Round(gvar_0253636C * (gvar_019764C4[gvar_019764C4[row][8]][1] + shift / 2)));
      end;
      if gvar_019764C4[row][11] > 0 then begin                      //0056DE5B-63 (spouse drop line)
        ACanvas.MoveTo(Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C), //0056DE69-A6
          Round(gvar_019764C4[row][1] * gvar_0253636C));
        ACanvas.LineTo(Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C), //0056DEAB-FB
          Round((gvar_019764C4[row][1] - gvar_0061F114 - 1) * gvar_0253636C));
      end;
    end;
    Inc(row);                                                       //0056DF00
  end;
  { Extrema, boxes, person text, 20 names, photo. }
  row := 1;                                                         //0056DF12
  while gvar_019764C4[row][2] > 0 do begin                          //0056DF17-E9AB loop
    if (gvar_019764C4[row][1] - gvar_011AE33C + gvar_02536368) div (gvar_0253637C * gvar_011AE318 + gvar_0061F114 + gvar_011AE318 + gvar_011AE348) > gvar_011AE324 then //0056DF1C-8E (idiv)
      gvar_011AE324 := (gvar_019764C4[row][1] - gvar_011AE33C + gvar_02536368) div (gvar_0253637C * gvar_011AE318 + gvar_0061F114 + gvar_011AE318 + gvar_011AE348); //0056DF55-8D (identical recompute)
    if (gvar_019764C4[row][0] - gvar_011AE340 + gvar_02536364) div (gvar_0061F118 + gvar_011AE334) > gvar_011AE31C then //0056DF8E-B2 (idiv)
      gvar_011AE31C := (gvar_019764C4[row][0] - gvar_011AE340 + gvar_02536364) div (gvar_0061F118 + gvar_011AE334); //0056DFBA-E1 (identical recompute)
    if gvar_019764C4[row][3] > 0 then begin                         //0056DFE6-EE
      wasSchon := '';                                               //0056DFF4-FC (@LStrClr)
      if gvar_0061F2C4 = 1 then                                     //0056DFFC-E
        wasSchon := 'DS: ' + IntToStr(gvar_019764C4[row][3]);       //0056E005-28 ('DS: ')
      if gvar_0061F2C8 = 1 then                                     //0056E02D-34
        if Length(ChartBShort(row, 152)^) > 0 then begin            //0056E036-3E (len byte cmp)
          if wasSchon = '' then begin                               //0056E040-7B
            tmpS := 'ID: ' + ChartBShort(row, 152)^;                //0056E046-67 (PStrCpy/PStrNCat cl=2C)
            wasSchon := tmpS;                                       //0056E06D-76 (@LStrFromString)
          end
          else
            wasSchon := wasSchon + ' ID: ' + ChartBShort(row, 152)^; //0056E07D-AD (@LStrCatN)
        end;
      { 0056E0AD-52: father-row suffix block; 0056E155-F2: mother-row
        suffix block always follows (both else-chains fall through to
        the mother block). }
      if gvar_019764C4[row][7] > 0 then begin                       //0056E0AD-B8
        if gvar_019764C4[row][8] = 0 then                           //0056E0BA-C2
          wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][7]][12]) + ')' //0056E0C4-F4
        else if gvar_019764C4[gvar_019764C4[row][7]][12] > 1 then   //0056E103-16
          wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][7]][12]) + ')'; //0056E118-52
      end
      else if gvar_019764C4[gvar_019764C4[row][7]][12] > 1 then     //0056E103-16 (d7 = 0: row 0)
        wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][7]][12]) + ')';
      if gvar_019764C4[row][7] = 0 then begin                       //0056E155-6A
        if gvar_019764C4[row][8] > 0 then                           //0056E162-6A
          wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][8]][12]) + ')' //0056E16C-A6
        else if gvar_019764C4[gvar_019764C4[row][8]][12] > 1 then   //0056E1A8-F2
          wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][8]][12]) + ')';
      end
      else if gvar_019764C4[gvar_019764C4[row][8]][12] > 1 then     //0056E1A8-F2
        wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][8]][12]) + ')';
      ACanvas.Font.Size := Round(gvar_0061F120 * 9) - 1;            //0056E1F7-11
      ACanvas.TextOut(Round(gvar_019764C4[row][0] * gvar_0253636C) + 2, //0056E216-F
        Round((gvar_019764C4[row][1] - gvar_011AE318) * gvar_0253636C) + 1,
        wasSchon);
      ACanvas.Font.Size := Round(gvar_0061F120 * 9);                //0056E264-F0
      DataModule2.Table17.FindKey([gvar_019764C4[row][3]]);         //0056E290-A2
      slotRow := 0;                                                 //0056E2A7-AE ([ebp-10])
      slotI := 0;                                                   //0056E2AC-B1 ([ebp-0C])
      repeat                                                        //0056E2B4-79F
        ACanvas.Font.Style := [];                                   //0056E2B4-C0 (TFont.SetStyle byte 0)
        if slotI = 0 then                                           //0056E2C5-C9
          ACanvas.Font.Style := [fsBold];                           //0056E2CB-D7 (byte 1)
        if slotI = 0 then                                           //0056E2DC-E2
          if RightStr(ChartBAnsi(102 * row + 18)^, 1) = '#' then begin //0056E2E2-0C
            ChartBAnsi(102 * row + 18)^ := Copy(ChartBAnsi(102 * row + 18)^, 1, Length(ChartBAnsi(102 * row + 18)^) - 1); //0056E30E-31 (LStrCopy len-1)
            ACanvas.Font.Style := [fsBold];                         //0056E336-42
          end;
        if slotI = 1 then                                           //0056E347-4B
          if RightStr(ChartBAnsi(102 * row + 19)^, 1) = '#' then begin //0056E34D-77
            ChartBAnsi(102 * row + 19)^ := Copy(ChartBAnsi(102 * row + 19)^, 1, Length(ChartBAnsi(102 * row + 19)^) - 1); //0056E379-9C
            ACanvas.Font.Style := [fsBold];                         //0056E3A1-AD
          end;
        if slotI = 2 then                                           //0056E3B2-B6
          if RightStr(ChartBAnsi(102 * row + 20)^, 1) = '#' then begin //0056E3B8-E2
            ChartBAnsi(102 * row + 20)^ := Copy(ChartBAnsi(102 * row + 20)^, 1, Length(ChartBAnsi(102 * row + 20)^) - 1); //0056E3E4-:07
            ACanvas.Font.Style := [fsBold];                         //0056E40C-18
          end;
        if slotI = 3 then                                           //0056E41D-21
          if RightStr(ChartBAnsi(102 * row + 21)^, 1) = '#' then begin //0056E423-4D
            ChartBAnsi(102 * row + 21)^ := Copy(ChartBAnsi(102 * row + 21)^, 1, Length(ChartBAnsi(102 * row + 21)^) - 1); //0056E44F-72
            ACanvas.Font.Style := [fsBold];                         //0056E477-83
          end;
        ebp14 := ACanvas.TextWidth(ChartBAnsi(102 * row + 18 + slotI)^); //0056E488-A3
        ebp14 := Round((gvar_011AE334 * gvar_0253636C - ebp14) / 2); //0056E4A3-C4 (fsubrp)
        ACanvas.TextOut(Round(gvar_019764C4[row][0] * gvar_0253636C) + ebp14, //0056E4C7-25
          Round((gvar_019764C4[row][1] + slotRow * gvar_011AE318 + gvar_011AE348) * gvar_0253636C) + 3,
          ChartBAnsi(102 * row + 18 + slotI)^);
        Inc(slotRow);                                               //0056E791 ([ebp-10])
        Inc(slotI);                                                 //0056E794 ([ebp-0C])
      until slotI = 20;                                             //0056E79B-F (cmp $14)
      ACanvas.Brush.Style := bsClear;                               //0056E52A-32
      ACanvas.Pen.Color := 0;                                       //0056E537-3F
      if ChartBShort(row, 193)^ = 'M' then                          //0056E544-5A (@AStrCmp)
        ACanvas.Rectangle(Round(gvar_019764C4[row][0] * gvar_0253636C),       //0056E560-F8
          Round(gvar_019764C4[row][1] * gvar_0253636C),
          Round((gvar_019764C4[row][0] + gvar_011AE334) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348) * gvar_0253636C));
      if ChartBShort(row, 193)^ = 'W' then                          //0056E5FD-13 (@AStrCmp)
        ACanvas.RoundRect(Round(gvar_019764C4[row][0] * gvar_0253636C),       //0056E619-B5
          Round(gvar_019764C4[row][1] * gvar_0253636C),
          Round((gvar_019764C4[row][0] + gvar_011AE334) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348) * gvar_0253636C), 15, 15);
      if ChartBShort(row, 193)^ = 'X' then begin                    //0056E6BA-D0 (@AStrCmp)
        ACanvas.Pen.Color := 0;                                     //0056E6D6-DE
        ACanvas.RoundRect(Round(gvar_019764C4[row][0] * gvar_0253636C),       //0056E6E3-7F
          Round(gvar_019764C4[row][1] * gvar_0253636C),
          Round((gvar_019764C4[row][0] + gvar_011AE334) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348) * gvar_0253636C), 15, 15);
      end;
      ACanvas.Pen.Color := 0;                                       //0056E784-8C
      if gvar_0061F2BC = 1 then begin                               //0056E7A5-AC
        if ChartBShort(row, 322)^ > ' ' then begin                  //0056E7B2-C3 (@PStrCmp vs ' ', jbe skip)
          img := TImage.Create(Self);                               //0056E7C9-D3 (AOwner)
          tmpS := ChartBShort(row, 322)^;                           //0056E7DA-EC (@LStrFromString)
          img.Picture.LoadFromFile(tmpS);                           //0056E7EC-F8
          jpegFlag := img.Picture.Graphic is TJPEGImage;            //0056E7FD-11
          if jpegFlag then begin                                    //0056E814-18
            ratio := img.Height / img.Picture.Graphic.Height;       //0056E81A-3B (fdivrp)
            img.Width := Round(img.Picture.Graphic.Width * ratio);  //0056E83F-6B
          end;
          q1 := Round((gvar_0253637C * gvar_011AE318 + gvar_011AE318) * 4 / 5); //0056E870-9B (shl 2, fdiv 5)
          q2 := Round(img.Picture.Graphic.Width / img.Height * ((gvar_0253637C * gvar_011AE318 + gvar_011AE318) * 4 / 5)); //0056E8CD-90
          aRect := Rect(Round((gvar_019764C4[row][0] + 4) * gvar_0253636C),   //ALeft  0056E957-:6F
            Round((gvar_019764C4[row][1] + 2) * gvar_0253636C),              //ATop   0056E93C-56
            Round((gvar_019764C4[row][0] + q2) * gvar_0253636C),             //ARight 0056E925-38
            Round((gvar_019764C4[row][1] + q1) * gvar_0253636C));            //ABottom 0056E8C8-:0D
          img.Proportional := True;                                 //0056E97B-7F
          ACanvas.StretchDraw(aRect, img.Picture.Graphic);          //0056E984-93
          img.Free;                                                 //0056E998-9A
        end;
      end;
    end;
    Inc(row);                                                       //0056E99F
  end;
  ScrollBar1.Max := (gvar_011AE31C + 1) * (gvar_011AE334 + gvar_0061F118) + gvar_011AE340; //0056E9B1-C5
  ScrollBar2.Max := (gvar_0253637C * gvar_011AE318 + gvar_0061F114 + gvar_011AE318 + gvar_011AE348) * gvar_011AE324 + gvar_011AE33C; //0056E9DA-06
  Screen.Cursor := crDefault;                                       //0056EA14-1D
end;

procedure TForm13.nz2(ACanvas: TCanvas); //0056EB10
{ Draws the "Nachfahren" chart variant 2. Copy/title/names/boxes/photo
  blocks are byte-identical to nz1; differences: the connector loop
  draws a horizontal marriage line (d7>0 or d8>0) plus an 'W'-only
  vertical line (gated by row > 1, d5 < 330-1 and d9 > 0), and the
  extrema loop uses gvar_011AE324 := max(d5) (plain). EBP aliases:
  [ebp-8] = ACanvas. }
var
  row, shift, ebp14, slotRow, slotI: Integer;      // [ebp-14]=[ebp-10]=[ebp-0C]
  tName, tVor, tmpS, wasSchon: AnsiString;         // [ebp-154..]/[ebp-1C]
  img: TImage;                                     // edi in the photo block
  q1, q2: Integer;
  ratio: Extended;                                 // [ebp-1D4]
  jpegFlag: Boolean;                               // [ebp-1D]
  aRect: TRect;                                    // [ebp-34]
begin
  Screen.Cursor := crHourGlass;                                     //0056EB3C-47
  PaintBox1.Canvas.Brush.Color := $FFFFFF;                          //0056EB4C-63
  PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height)); //0056EB68-8E
  gvar_02536364 := 0;                                               //0056EB93-95
  gvar_02536368 := 0;                                               //0056EB9A-9C
  if PaintBox1.Canvas = ACanvas then begin                          //0056EBA1-B3
    gvar_02536364 := ScrollBar1.Position;                           //0056EBB5-C4
    gvar_02536368 := ScrollBar2.Position;                           //0056EBC9-D8
  end;
  { Copy grid A -> grid B (rescaled, identical to nz1). }
  row := 1;                                                         //0056EBDD
  while gvar_011AE1C4[row][2] > 0 do begin                          //0056EBE2-DB7 loop
    DataModule2.Table17.FindKey([gvar_011AE1C4[row][3]]);           //0056EBE7-C07
    gvar_019764C4[row][2] := gvar_011AE1C4[row][2];                 //0056EC0C-13
    gvar_019764C4[row][3] := gvar_011AE1C4[row][3];                 //0056EC1A-21
    gvar_019764C4[row][5] := gvar_011AE1C4[row][5];                 //0056EC28-2F
    tmpS := UpperCase(ChartAShort(row, 193)^);                      //0056EC36-54
    ChartBShort(row, 193)^ := tmpS;                                 //0056EC6F-7E
    gvar_019764C4[row][7] := gvar_011AE1C4[row][7];                 //0056EC83-8A
    gvar_019764C4[row][8] := gvar_011AE1C4[row][8];                 //0056EC91-98
    for shift := 0 to 19 do                                         //0056EC9F-B9 (@CopyArray 20 dwords)
      ChartBAnsi(102 * row + 18 + shift)^ := ChartAAnsi(102 * row + 18 + shift)^;
    ChartBShort(row, 152)^ := ChartAShort(row, 152)^;               //0056ECBE-CE (@PStrNCpy cl=28)
    gvar_019764C4[row][9] := gvar_011AE1C4[row][9];                 //0056ECD3-DA
    gvar_019764C4[row][10] := gvar_011AE1C4[row][10];               //0056ECE1-E8
    gvar_019764C4[row][11] := gvar_011AE1C4[row][11];               //0056ECEF-F6
    ChartBShort(row, 322)^ := ChartAShort(row, 322)^;               //0056ECFD-0A (@PStrNCpy cl=50)
    gvar_019764C4[row][12] := gvar_011AE1C4[row][12];               //0056ED0F-16
    gvar_019764C4[row][0] := (gvar_011AE1C4[row][0] - 1) * (gvar_011AE334 + gvar_0061F118) + gvar_011AE340 - gvar_02536364; //0056ED1D-43
    gvar_019764C4[row][1] := (gvar_011AE1C4[row][1] - 1) * (gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_0061F114 + gvar_011AE348) + gvar_011AE33C - gvar_02536368; //0056ED4A-83
    if gvar_011AE1C4[row][0] > gvar_011AE320 then                   //0056ED8A-94
      gvar_011AE320 := gvar_011AE1C4[row][0];                       //0056ED9C-A6
    Inc(row);                                                       //0056EDAB
  end;
  { Title "Nachfahren von <Name> <Vorname>" from the row-1 person. }
  DataModule2.Table17.FindKey([gvar_019764C4[1][3]]);               //0056EDBD-D9
  tmpS := DataModule2.Table17Name.AsString;                         //0056EDE3-FB
  sub_00563868(tmpS, tName);                                        //0056EE01-07
  tVor := DataModule2.Table17Vornamen.AsString;                     //0056EE17-2F
  wasSchon := 'Nachfahren von ' + tName + ' ' + tVor;               //0056EE35-40 (@LStrCatN)
  ACanvas.TextOut(Round(gvar_0253636C * 30) - gvar_02536364,        //0056EE45-83
    Round(gvar_0253636C * 5) - gvar_02536368, wasSchon);
  gvar_011AE324 := 0;                                               //0056EE8D-8F
  gvar_011AE31C := 0;                                               //0056EE94-96
  { Marriage line + 'W' drop line. }
  row := 1;                                                         //0056EE9B
  while gvar_019764C4[row][2] > 0 do begin                          //0056EEA0-0DD loop
    if gvar_019764C4[row][1] > 0 then begin                         //0056EEA5-AD
      if gvar_019764C4[row][5] < gvar_011AE330 then begin           //0056EEB3-C0
        if gvar_019764C4[row][5] > 1 then                           //0056EEC6-D1
          if (gvar_019764C4[row][7] > 0) or (gvar_019764C4[row][8] > 0) then begin //0056EED7-EF fallthrough either way
            ACanvas.MoveTo(Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C), //0056EEF5-EF38
              Round(gvar_019764C4[row][1] * gvar_0253636C));
            ACanvas.LineTo(Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C), //0056EF3D-8E
              Round((gvar_019764C4[row][1] - gvar_0061F114 / 2) * gvar_0253636C));
          end;
      end;
      { 0056EF93: 'W' drop line, only for rows > 1. }
      if row > 1 then                                               //0056EF93-:96
        if ChartBShort(row, 193)^ = 'W' then                        //0056EF9C-B5 (@AStrCmp)
          if gvar_019764C4[row][5] < gvar_011AE330 - 1 then         //0056EFBB-:CE (dec edx, cmp)
            if gvar_019764C4[row][9] > 0 then begin                 //0056EFD4-DF
              shift := gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348; //0056EFE8-F0A
              ACanvas.MoveTo(Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C), //0056EFE5-:04F
                Round(gvar_0253636C * (gvar_019764C4[row][1] + shift)));
              ACanvas.LineTo(Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C), //0056F054-CC
                Round(gvar_0253636C * (gvar_019764C4[row][1] + shift + gvar_0061F114 / 2)));
            end;
    end;
    Inc(row);                                                       //0056F0D1
  end;
  { Extrema, boxes, person text, 20 names, photo. }
  row := 1;                                                         //0056F0E3
  ACanvas.Pen.Color := 0;                                           //0056F0E8-F0
  while gvar_019764C4[row][2] > 0 do begin                          //0056F0F5-128 loop
    if gvar_019764C4[row][5] > gvar_011AE324 then                   //0056F6F8-05
      gvar_011AE324 := gvar_019764C4[row][5];                       //0056F707-16 (plain d5 max!)
    if (gvar_019764C4[row][0] - gvar_011AE340 + gvar_02536364) div (gvar_0061F118 + gvar_011AE334) > gvar_011AE31C then //0056F716-3A (idiv)
      gvar_011AE31C := (gvar_019764C4[row][0] - gvar_011AE340 + gvar_02536364) div (gvar_0061F118 + gvar_011AE334); //0056F742-78 (identical recompute)
    if gvar_019764C4[row][3] > 0 then begin                         //0056F76E-76
      wasSchon := '';                                               //0056F77C-7F (@LStrClr)
      if gvar_0061F2C4 = 1 then                                     //0056F784-8B
        wasSchon := 'DS: ' + IntToStr(gvar_019764C4[row][3]);       //0056F78D-B0 ('DS: ')
      if gvar_0061F2C8 = 1 then                                     //0056F7B5-BC
        if Length(ChartBShort(row, 152)^) > 0 then begin            //0056F7BE-C6 (len byte cmp)
          if wasSchon = '' then begin                               //0056F7C8-C
            tmpS := 'ID: ' + ChartBShort(row, 152)^;                //0056F7CE-F5 (PStrCpy/PStrNCat cl=2C)
            wasSchon := tmpS;                                       //0056F7F5-:0 (LStrFromString)
          end
          else
            wasSchon := wasSchon + ' ID: ' + ChartBShort(row, 152)^; //0056F805-30 (@LStrCatN)
        end;
      { 0056F835-52: father-row suffix block; 0056F8DD-7A: mother-row
        suffix block always follows. }
      if gvar_019764C4[row][7] > 0 then begin                       //0056F835-40
        if gvar_019764C4[row][8] = 0 then                           //0056F842-4A
          wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][7]][12]) + ')' //0056F84C-89
        else if gvar_019764C4[gvar_019764C4[row][7]][12] > 1 then   //0056F88B-9E
          wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][7]][12]) + ')'; //0056F8A0-D8
      end
      else if gvar_019764C4[gvar_019764C4[row][7]][12] > 1 then     //0056F88B-9E (d7 = 0: row 0)
        wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][7]][12]) + ')';
      if gvar_019764C4[row][7] = 0 then begin                       //0056F8DD-E8
        if gvar_019764C4[row][8] > 0 then                           //0056F8EA-F2
          wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][8]][12]) + ')' //0056F8F4-2E
        else if gvar_019764C4[gvar_019764C4[row][8]][12] > 1 then   //0056F930-40
          wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][8]][12]) + ')';
      end
      else if gvar_019764C4[gvar_019764C4[row][8]][12] > 1 then     //0056F930-40
        wasSchon := wasSchon + ' (' + IntToStr(gvar_019764C4[gvar_019764C4[row][8]][12]) + ')';
      ACanvas.Font.Size := Round(gvar_0061F120 * 9) - 1;            //0056F97F-9F
      ACanvas.TextOut(Round(gvar_019764C4[row][0] * gvar_0253636C) + 2, //0056F99E-E7
        Round((gvar_019764C4[row][1] - gvar_011AE318) * gvar_0253636C) + 1,
        wasSchon);
      ACanvas.Font.Size := Round(gvar_0061F120 * 9);                //0056F9EC-05
      DataModule2.Table17.FindKey([gvar_019764C4[row][3]]);         //0056FA0A-2A
      slotRow := 0;                                                 //0056FA2F-31 ([ebp-10])
      slotI := 0;                                                   //0056FA34-36 ([ebp-0C])
      repeat                                                        //0056FA39-FF23
        ACanvas.Font.Style := [];                                   //0056FA3C-48 (TFont.SetStyle byte 0)
        if slotI = 0 then                                           //0056FA4D-51
          ACanvas.Font.Style := [fsBold];                           //0056FA53-5F
        if slotI = 0 then                                           //0056FA64-68
          if RightStr(ChartBAnsi(102 * row + 18)^, 1) = '#' then begin //0056FA6A-94
            ChartBAnsi(102 * row + 18)^ := Copy(ChartBAnsi(102 * row + 18)^, 1, Length(ChartBAnsi(102 * row + 18)^) - 1); //0056FA96-B9 (LStrCopy len-1)
            ACanvas.Font.Style := [fsBold];                         //0056FABE-CA
          end;
        if slotI = 1 then                                           //0056FACF-D3
          if RightStr(ChartBAnsi(102 * row + 19)^, 1) = '#' then begin //0056FAD5-FF
            ChartBAnsi(102 * row + 19)^ := Copy(ChartBAnsi(102 * row + 19)^, 1, Length(ChartBAnsi(102 * row + 19)^) - 1); //0056FB01-24
            ACanvas.Font.Style := [fsBold];                         //0056FB29-35
          end;
        if slotI = 2 then                                           //0056FB3A-3E
          if RightStr(ChartBAnsi(102 * row + 20)^, 1) = '#' then begin //0056FB40-6A
            ChartBAnsi(102 * row + 20)^ := Copy(ChartBAnsi(102 * row + 20)^, 1, Length(ChartBAnsi(102 * row + 20)^) - 1); //0056FB6C-:8F
            ACanvas.Font.Style := [fsBold];                         //0056FB94-A0
          end;
        if slotI = 3 then                                           //0056FBA5-A9
          if RightStr(ChartBAnsi(102 * row + 21)^, 1) = '#' then begin //0056FBAB-D5
            ChartBAnsi(102 * row + 21)^ := Copy(ChartBAnsi(102 * row + 21)^, 1, Length(ChartBAnsi(102 * row + 21)^) - 1); //0056FBD7-FA
            ACanvas.Font.Style := [fsBold];                         //0056FBFF-:0B
          end;
        ebp14 := ACanvas.TextWidth(ChartBAnsi(102 * row + 18 + slotI)^); //0056FC10-25
        ebp14 := Round((gvar_011AE334 * gvar_0253636C - ebp14) / 2); //0056FC2B-4C (fsubrp)
        ACanvas.TextOut(Round(gvar_019764C4[row][0] * gvar_0253636C) + ebp14, //0056FC4F-AB
          Round((gvar_019764C4[row][1] + slotRow * gvar_011AE318 + gvar_011AE348) * gvar_0253636C) + 3,
          ChartBAnsi(102 * row + 18 + slotI)^);
        Inc(slotRow);                                               //0056FF19 ([ebp-10])
        Inc(slotI);                                                 //0056FF1C ([ebp-0C])
      until slotI = 20;                                             //0056FF23-7 (cmp $14)
      ACanvas.Brush.Style := bsClear;                               //0056FCB2-BA
      ACanvas.Pen.Color := 0;                                       //0056FCBF-C7
      if ChartBShort(row, 193)^ = 'M' then                          //0056FCCC-E2 (@AStrCmp)
        ACanvas.Rectangle(Round(gvar_019764C4[row][0] * gvar_0253636C),       //0056FCE8-80
          Round(gvar_019764C4[row][1] * gvar_0253636C),
          Round((gvar_019764C4[row][0] + gvar_011AE334) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348) * gvar_0253636C));
      if ChartBShort(row, 193)^ = 'W' then                          //0056FD85-96 (@AStrCmp)
        ACanvas.RoundRect(Round(gvar_019764C4[row][0] * gvar_0253636C),       //0056FDA1-:3D
          Round(gvar_019764C4[row][1] * gvar_0253636C),
          Round((gvar_019764C4[row][0] + gvar_011AE334) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348) * gvar_0253636C), 15, 15);
      if ChartBShort(row, 193)^ = 'X' then begin                    //0056FE42-58 (@AStrCmp)
        ACanvas.Pen.Color := 0;                                     //0056FE5E-66
        ACanvas.RoundRect(Round(gvar_019764C4[row][0] * gvar_0253636C),       //0056FE6B-:07
          Round(gvar_019764C4[row][1] * gvar_0253636C),
          Round((gvar_019764C4[row][0] + gvar_011AE334) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348) * gvar_0253636C), 15, 15);
      end;
      ACanvas.Pen.Color := 0;                                       //0056FF0C-14
      if gvar_0061F2BC = 1 then begin                               //0056FF2D-34
        if ChartBShort(row, 322)^ > ' ' then begin                  //0056FF3A-4B (@PStrCmp vs ' ', jbe skip)
          img := TImage.Create(Self);                               //0056FF51-60 (AOwner)
          tmpS := ChartBShort(row, 322)^;                           //0056FF62-74 (@LStrFromString)
          img.Picture.LoadFromFile(tmpS);                           //0056FF74-80
          jpegFlag := img.Picture.Graphic is TJPEGImage;            //0056FF85-9C
          if jpegFlag then begin                                    //0056FF9C-A0
            ratio := img.Height / img.Picture.Graphic.Height;       //0056FFA2-C1 (fdivrp)
            img.Width := Round(img.Picture.Graphic.Width * ratio);  //0056FFC7-F3
          end;
          q1 := Round((gvar_0253637C * gvar_011AE318 + gvar_011AE318) * 4 / 5); //0056FFF8-23 (shl 2, fdiv 5)
          q2 := Round(img.Picture.Graphic.Width / img.Height * ((gvar_0253637C * gvar_011AE318 + gvar_011AE318) * 4 / 5)); //00570055-85
          aRect := Rect(Round((gvar_019764C4[row][0] + 4) * gvar_0253636C),   //ALeft  005700DF-:F7
            Round((gvar_019764C4[row][1] + 2) * gvar_0253636C),              //ATop   005700C1-E
            Round((gvar_019764C4[row][0] + q2) * gvar_0253636C),             //ARight 005700AD-C0
            Round((gvar_019764C4[row][1] + q1) * gvar_0253636C));            //ABottom 00570050-:0D
          img.Proportional := True;                                 //00570103-07
          ACanvas.StretchDraw(aRect, img.Picture.Graphic);          //0057010C-20
          img.Free;                                                 //00570120-22
        end;
      end;
    end;
    Inc(row);                                                       //00570127
  end;
  ScrollBar1.Max := (gvar_011AE31C + 1) * (gvar_011AE334 + gvar_0061F118) + gvar_011AE340; //00570139-4E
  ScrollBar2.Max := (gvar_0253637C * gvar_011AE318 + gvar_0061F114 + gvar_011AE318 + gvar_011AE348) * gvar_011AE324 + gvar_011AE33C; //00570162-8E
  Screen.Cursor := crDefault;                                       //0057019C-A5
end;

procedure TForm13.schieb_vm1;
var
  esi, eax, edx, ebx, ecx, edi, ebp: Integer;
begin
  { 00568528: first scan grid B rows (while row[r].dword[2] > 0,
    anchor [eax*8+19764CC] = flat idx 102*eax+2) to find esi = the
    maximum of row dword[5]; then for ecx = 1 .. esi-1 walk all rows
    and shift row dword[1] ([eax-8] on the 1976668 anchor = row[r][3]): }
  gvar_011AE324 := 0;                                 //0056852C-2E
  esi := 0;
  eax := 1;                                           //00568535
  while gvar_019764C4[eax][2] > 0 do                  //00568550-5B
  begin
    if esi < gvar_019764C4[eax][5] then               //0056853C-48
      esi := gvar_019764C4[eax][5];
    Inc(eax);
  end;
  edi := esi - 1;                                     //0056855D-F
  while edi > 0 do                                    //00568560-20
  begin
    ecx := 1;                                         //00568568
    for edx := 1 to gvar_011AE344 do                  //0056856D-18
    begin
      if gvar_019764C4[edx][3] > 0 then               //00568580-83
      begin
        if ecx = gvar_019764C4[edx][5] then           //00568589-8C
        begin
          ebx := gvar_019764C4[edx][6];               //0056858E
          if ebx > 0 then                             //00568591-93
            gvar_019764C4[edx][1] :=                  //00568595-9F
              ChartBFlat(102 * ebx + 1)
          else
          begin
            ebx := gvar_019764C4[edx][7];             //005685A4
            if ebx > 0 then
              gvar_019764C4[edx][1] :=                //005685A4-B5
                ChartBFlat(102 * ebx + 1);
          end;
        end
        else if (gvar_019764C4[edx][6] = 0) and       //005685BA-C4
                (gvar_019764C4[edx][7] = 0) and
                (esi > gvar_019764C4[edx][5]) and     //005685C6-C9 jle
                (gvar_019764C4[edx][5] = gvar_019764C4[edx - 1][5]) and //005685CD-D3
                (gvar_019764C4[edx][3] > 0) and       //005685D5-D8
                (gvar_019764C4[edx - 1][3] > 0) and   //005685DA-E1
                (gvar_019764C4[edx - 1][4] >= gvar_019764C4[edx][1]) then //005685E3-EC jl
        begin
          ebp := gvar_019764C4[edx - 1][4];           //005685E3
          ebx := gvar_0253637C * gvar_011AE318 +       //005685EE-607
                 gvar_011AE318 + gvar_0061F118 +
                 gvar_011AE348 + ebp;
          gvar_019764C4[edx][1] := ebx;               //0056860D-0F
        end;
      end;
    end;
    Inc(ecx);                                         //0056861E
    Dec(edi);                                         //0056861F
  end;
end;

procedure TForm13.schieb_vm;
var
  esi, ecx, edx, eax, ebx, edi: Integer;
begin
  { 0056862C: like schieb_vm1, but the outer count is 011AE328-1 and
    the row dword[0] ([eax-0C]) is shifted instead of dword[1]. }
  esi := gvar_011AE328 - 1;                           //0056862F-35
  while esi > 0 do
  begin
    ecx := 1;                                         //0056863E
    for edx := 1 to gvar_011AE344 do                  //00568643-DB
    begin
      if gvar_019764C4[edx][3] > 0 then               //00568656-59
      begin
        if ecx = gvar_019764C4[edx][5] then           //0056865B-5E
        begin
          ebx := gvar_019764C4[edx][6];               //00568660
          if ebx > 0 then
            gvar_019764C4[edx][0] :=                  //00568667-71
              ChartBFlat(102 * ebx)
          else
          begin
            ebx := gvar_019764C4[edx][7];             //00568676
            if ebx > 0 then
              gvar_019764C4[edx][0] :=                //00568676-87
                ChartBFlat(102 * ebx);
          end;
        end
        else if (gvar_019764C4[edx][6] = 0) and       //0056868C-96
                (gvar_019764C4[edx][7] = 0) and
                (gvar_019764C4[edx][5] < gvar_011AE328) and    //00568698-A1 jge
                (gvar_019764C4[edx][5] = gvar_019764C4[edx - 1][5]) and //005686A3-A9
                (gvar_019764C4[edx][3] > 0) and       //005686AB-AE
                (gvar_019764C4[edx - 1][3] > 0) and   //005686B0-B7
                (gvar_019764C4[edx - 1][0] >= gvar_019764C4[edx][0]) then //005686B9-C2 jl
        begin
          edi := gvar_019764C4[edx - 1][0];           //005686B9
          gvar_019764C4[edx][0] := edi +              //005686C4-D2
            gvar_011AE334 + gvar_0061F118;
        end;
      end;
    end;
    Inc(ecx);                                         //005686E1
    Dec(esi);                                         //005686E2
  end;
end;

procedure TForm13.ScrollBar1Change(Sender: TObject);
begin
  { 00572484: Scrollbalken 1 -> Graphik neu zeichnen. }
  PaintBox1.Refresh;
end;

procedure TForm13.ScrollBar2Change(Sender: TObject);
begin
  { 00572490: Scrollbalken 2 -> Graphik neu zeichnen. }
  PaintBox1.Refresh;
end;

procedure TForm13.nr1;
var
  row, child, i0, count, gen, esi: Integer;
begin
  { 0056C0D4: Nachfahren-Graph 'Nachgr1' vorbereiten (nr1). Devil of
    the listing: rows of grid A are 408-byte records; esi in the
    listing is the row number and [edi + 408*esi + off] = row esi at
    in-row offset off (edi anchors row 1, so K>0 relative terms move
    one row up). Recon uses the flat dword helpers with flat index
    102*row + off/4 plus ChartAShort for bytes 316/318/320. |
    Stack locals: [esp+14] = loop counter (count), [esp+18] = pen
    width, [esp] = Self. }
  gvar_011AE340 := Round(gvar_0061F120 * 45);                       //0056C0E7-F8
  gvar_011AE33C := 30;                                              //0056C0FD
  gvar_0061F118 := Round(gvar_0061F120 * 30);                       //0056C107
  gvar_0061F114 := Round(gvar_0061F120 * 20);                       //0056C11D
  gvar_011AE334 := Round(gvar_0061F120 * 120) + gvar_011AE338;      //0056C133-4A
  Screen.Cursor := crHourGlass;                                     //0056C14F-5A
  gvar_02536364 := 0;                                               //0056C15F-8
  gvar_02536368 := 0;                                               //0056C166
  if PaintBox1.Canvas = gvar_011AE32C then begin                    //0056C16D-82
    gvar_02536364 := ScrollBar1.Position;                           //0056C184-A1
    gvar_02536368 := ScrollBar2.Position;                           //0056C1A7
  end;
  gvar_011AE348 := 0;                                               //0056C1AC-B2
  gvar_0253637C := 0;                                               //0056C1B3-B5
  gvar_011AE318 := 0;                                               //0056C1BA-C0
  gvar_011AE32C.Font.Name := 'Arial';                               //0056C1C1-E
  gvar_011AE32C.Font.Size := Round(gvar_0061F120 * 9);              //0056C1D3-E6
  gvar_011AE318 := -gvar_011AE32C.Font.Height + 2;                  //0056C1F3-7
  PaintBox1.Canvas.Font.Size := Round(gvar_0061F120 * 9);           //0056C20A-30
  gvar_011AE318 := -PaintBox1.Canvas.Font.Height + 2;               //0056C234-8
  gvar_0253636C := 0;                                               //0056C255

  if Printer.Canvas = gvar_011AE32C then begin                      //0056C270-9
    gvar_0253636C := 0.6;                                           //0056C286-9A
    Printer.Canvas.Font.Name := 'Arial';                            //0056C2A3-D
    Printer.Canvas.Font.Size := Round(gvar_0061F120 * 9);           //0056C2BA-D9
    count := PaintBox1.Canvas.Pen.Width;                            //0056C2E1-F3
    Printer.Canvas.Pen.Width := Round(count * gvar_0253636C);       //0056C2FC-3F
  end;
  if PaintBox1.Canvas <> gvar_011AE32C then                         //0056C321-8
    gvar_0253636C := 0.1;                                           //0056C338-F

  DataModule2.Table17.IndexName := '';                              //0056C355-64

  { 0056C369-C426: reset the 20 AnsiString slots per row, replay the
   ameron row data via Table17->memein, and run zerleg for each row. }
  row := 1;
  while ChartAFlat(102 * row + 2) > 0 do begin                      //0056C427-32
    for i0 := 0 to 19 do begin                                      //0056C373-A2
      ChartSlotAnsi(i0)^ := '';
      ChartAAnsi(102 * row + 18 + i0)^ := '';
    end;
    DataModule2.Table17.FindKey([ChartAFlat(102 * row + 3)]);       //0056C3A4-CA
    memein(ChartAFlat(102 * row + 11));                             //0056C3CF-D9
    zerleg(gvar_011AE334, gvar_011AE318, gvar_011AE32C);            //0056C3DE-F4
    for i0 := 0 to 19 do begin                                      //0056C3F9-24
      ChartAAnsi(102 * row + 18 + i0)^ := ChartSlotAnsi(i0)^;
    end;
    Inc(row);                                                       //0056C426
  end;

  if gvar_0061F2BC = 1 then                                          //0056C438-F
    gvar_011AE348 := Round(((gvar_0253637C * gvar_011AE318) +        //0056C441-E
      gvar_011AE318) * 4 / 5);

  { 0056C46D-C52B: pass 1 - replace d7 Vater person numbers by the
    row index carrying the same Nummer (d3); the '*' ShortStrings at
    bytes 316/318/320 remember already processed rows. }
  row := 1;
  while ChartAFlat(102 * row + 2) > 0 do begin                      //0056C508-25
    child := 1;
    while ChartAFlat(102 * child + 2) > 0 do begin                  //0056C47C-C52B
      if (ChartAFlat(102 * child + 7) > 0) and                      //0056C481-9F
         (ChartAFlat(102 * child + 7) = ChartAFlat(102 * row + 3)) and
         (ChartAShort(child, 316)^ <> '*') then begin               //0056C4A1-B4
        SetChartAFlat(102 * child + 7, row);                        //0056C4BA-94 mov 2A01
        ChartAShort(child, 316)^ := '*';
      end;
      { 0056C4C4-C51A: same for the mother d8/b318. }
      if (ChartAFlat(102 * child + 8) > 0) and
         (ChartAFlat(102 * child + 8) = ChartAFlat(102 * row + 3)) and
         (ChartAShort(child, 318)^ <> '*') then begin
        SetChartAFlat(102 * child + 8, row);
        ChartAShort(child, 318)^ := '*';
      end;
      Inc(child);
    end;
    Inc(row);
  end;

  { 0056C52B-C599: pass 2 - same scan over the partner link d10; the
    partner row index is ebx-1 here. }
  row := 1;
  while ChartAFlat(102 * row + 2) > 0 do begin                      //0056C580-B
    child := 1;
    while ChartAFlat(102 * child + 2) > 0 do begin                  //0056C537-C
      if (ChartAFlat(102 * child + 10) > 0) and                     //0056C539-67
         (ChartAFlat(102 * child + 10) = ChartAFlat(102 * row + 3)) and
         (ChartAShort(child, 320)^ <> '*') then begin               //0056C559-C
        SetChartAFlat(102 * child + 10, child - 1);                 //0056C56E-8
        ChartAShort(child, 320)^ := '*';
      end;
      Inc(child);
    end;
    Inc(row);
  end;

  { 0056C59B-C732: column alignment. Anchor conversions: [eax] = d5,
    [eax-10] = d1, [eax+8] = d7, [eax+0C] = d8 of the current row;
    [eax+198] = d1 of the next row, [eax+1A8] = its d5. The inner
    child terms [edi+W-17C/-178] = d7/d8 and [edi+W-194] = d1 of row
    W. Level ecx runs over generations. }
  if gvar_011AE328 >= 3 then begin                                  //0056C59B-A8
    count := gvar_011AE328 - 3 + 1;                                 //0056C5A8-C
    gen := 3;                                                       //0056C5BB
    repeat
      esi := 0;                                                     //0056C5C0
      if gvar_011AE328 >= 3 then begin                              //0056C5C2-A
        for row := 1 to gvar_011AE344 do begin                      //0056C5D9-56
          if (ChartAFlat(102 * row + 5) = gen) and                  //0056C5DC-E8
             (esi <> ChartAFlat(102 * row + 7)) and
             (esi <> ChartAFlat(102 * row + 8)) then begin
            { childs carrying d7 }
            if (ChartAFlat(102 * row + 7) > 0) and                  //0056C5EA-1A
               ((ChartAFlat(102 * ChartAFlat(102 * row + 7) + 7) > 0) or
                (ChartAFlat(102 * ChartAFlat(102 * row + 7) + 8) > 0)) then begin
              esi := ChartAFlat(102 * row + 1);                     //0056C610
              SetChartAFlat(102 * ChartAFlat(102 * row + 7) + 1, esi);
              esi := ChartAFlat(102 * row + 7);                     //0056C61A
            end;
            { the same for d8/mother childs }
            if (ChartAFlat(102 * row + 8) > 0) and                  //0056C61D-D
               ((ChartAFlat(102 * ChartAFlat(102 * row + 8) + 7) > 0) or
                (ChartAFlat(102 * ChartAFlat(102 * row + 8) + 8) > 0)) then begin
              esi := ChartAFlat(102 * row + 1);                     //0056C63F-6
              SetChartAFlat(102 * ChartAFlat(102 * row + 8) + 1, esi);
              esi := ChartAFlat(102 * row + 8);                     //0056C64D
            end;
          end;
        end;
      end;
      { 0056C658-8C: push overlapping siblings of the same generation
        one column right. }
      for row := 1 to gvar_011AE344 do begin                        //0056C658-8C
        esi := ChartAFlat(102 * row + 1);                           //0056C665
        if (ChartAFlat(102 * row + 5) > 1) and                      //0056C66A-F
           (ChartAFlat(102 * row + 5) = ChartAFlat(102 * (row + 1) + 5)) and
           (esi >= ChartAFlat(102 * (row + 1) + 1)) then begin      //0056C677-C
          Inc(esi);                                                 //0056C67F
          SetChartAFlat(102 * (row + 1) + 1, esi);                  //0056C680
        end;
      end;
      { 0056C68E-F5: second pass - parent d1 onto the child column. }
      for row := 1 to gvar_011AE344 do begin                        //0056C68E-F5
        if ChartAFlat(102 * row + 5) = gen then begin               //0056C69B-D
          if (ChartAFlat(102 * row + 7) > 0) and                    //0056C69F-F
             ((ChartAFlat(102 * ChartAFlat(102 * row + 7) + 7) > 0) or
              (ChartAFlat(102 * ChartAFlat(102 * row + 7) + 8) > 0)) then
            SetChartAFlat(102 * row + 1,                            //0056C6BD-6
              ChartAFlat(102 * ChartAFlat(102 * row + 7) + 1));
          if (ChartAFlat(102 * row + 8) > 0) and                    //0056C6C7-E5
             ((ChartAFlat(102 * ChartAFlat(102 * row + 8) + 7) > 0) or
              (ChartAFlat(102 * ChartAFlat(102 * row + 8) + 8) > 0)) then
            SetChartAFlat(102 * row + 1,                            //0056C6E5-C
              ChartAFlat(102 * ChartAFlat(102 * row + 8) + 1));
        end;
      end;
      { 0056C6F7-2B: horizontal push again. }
      for row := 1 to gvar_011AE344 do begin
        esi := ChartAFlat(102 * row + 1);
        if (ChartAFlat(102 * row + 5) > 1) and
           (ChartAFlat(102 * row + 5) = ChartAFlat(102 * (row + 1) + 5)) and
           (esi >= ChartAFlat(102 * (row + 1) + 1)) then begin
          Inc(esi);
          SetChartAFlat(102 * (row + 1) + 1, esi);
        end;
      end;
      Inc(gen);                                                     //0056C72D-2
      Dec(count);                                                   //0056C72E-32
    until count <= 0;
  end;

  { 0056C738-C7C7: single scan - parent d1 onto child column for the
    generations 3..count-2. }
  if gvar_011AE328 >= 3 then begin
    count := gvar_011AE328 - 3;                                     //0056C745-A
    count := count + 1;                                             //0056C74F
    gen := 3;                                                       //0056C754
    repeat
      for row := 1 to gvar_011AE344 do begin                        //0056C759-C0
        if ChartAFlat(102 * row + 5) = gen then begin               //0056C766-C
          if (ChartAFlat(102 * row + 7) > 0) and                    //0056C76A-F
             ((ChartAFlat(102 * ChartAFlat(102 * row + 7) + 7) > 0) or
              (ChartAFlat(102 * ChartAFlat(102 * row + 7) + 8) > 0)) then
            SetChartAFlat(102 * row + 1,                            //0056C788-F
              ChartAFlat(102 * ChartAFlat(102 * row + 7) + 1));
          if (ChartAFlat(102 * row + 8) > 0) and                    //0056C792-B
             ((ChartAFlat(102 * ChartAFlat(102 * row + 8) + 7) > 0) or
              (ChartAFlat(102 * ChartAFlat(102 * row + 8) + 8) > 0)) then
            SetChartAFlat(102 * row + 1,                            //0056C7B0-7
              ChartAFlat(102 * ChartAFlat(102 * row + 8) + 1));
        end;
      end;
      Inc(gen);                                                     //0056C7C2-3
      Dec(count);
    until count <= 0;
  end;

  { 0056C7C9-C805: horizontal push once more. }
  for row := 1 to gvar_011AE344 do begin
    esi := ChartAFlat(102 * row + 1);
    if (ChartAFlat(102 * row + 5) > 1) and
       (ChartAFlat(102 * row + 5) = ChartAFlat(102 * (row + 1) + 5)) and
       (esi >= ChartAFlat(102 * (row + 1) + 1)) then begin
      Inc(esi);
      SetChartAFlat(102 * (row + 1) + 1, esi);
    end;
  end;

  { 0056C807-C8D1: alignment from generation 2 upward. }
  if gvar_011AE328 >= 2 then begin                                  //0056C807-E
    count := gvar_011AE328 - 2 + 1;                                 //0056C814-3
    gen := 2;                                                       //0056C827
    repeat
      for row := 1 to gvar_011AE344 do begin                        //0056C82C-93
        if ChartAFlat(102 * row + 5) = gen then begin               //0056C839-A
          if (ChartAFlat(102 * row + 7) > 0) and                    //0056C83D-5
             ((ChartAFlat(102 * ChartAFlat(102 * row + 7) + 7) > 0) or
              (ChartAFlat(102 * ChartAFlat(102 * row + 7) + 8) > 0)) then
            SetChartAFlat(102 * row + 1,                            //0056C85B-4
              ChartAFlat(102 * ChartAFlat(102 * row + 7) + 1));
          if (ChartAFlat(102 * row + 8) > 0) and                    //0056C865-D
             ((ChartAFlat(102 * ChartAFlat(102 * row + 8) + 7) > 0) or
              (ChartAFlat(102 * ChartAFlat(102 * row + 8) + 8) > 0)) then
            SetChartAFlat(102 * row + 1,                            //0056C883-A
              ChartAFlat(102 * ChartAFlat(102 * row + 8) + 1));
        end;
      end;
      { 0056C895-CC: push. }
      for row := 1 to gvar_011AE344 do begin
        esi := ChartAFlat(102 * row + 1);
        if (ChartAFlat(102 * row + 5) > 1) and
           (ChartAFlat(102 * row + 5) = ChartAFlat(102 * (row + 1) + 5)) and
           (esi >= ChartAFlat(102 * (row + 1) + 1)) then begin
          Inc(esi);
          SetChartAFlat(102 * (row + 1) + 1, esi);
        end;
      end;
      Inc(gen);                                                     //0056C8CC-D1
      Dec(count);
    until count <= 0;
  end;

  { 0056C8D7-C98C: children adopt the parent's column, generations
    from gvar_011AE328 downto 2. esi = the last processed child row. }
  esi := 0;                                                         //0056C8D7-9
  if gvar_011AE328 >= 2 then begin                                  //0056C8D9-F
    gen := gvar_011AE328;                                           //0056C8E6-E
    repeat
      for row := 1 to gvar_011AE344 do begin                        //0056C906-7D
        if (ChartAFlat(102 * row + 5) = gen) and                    //0056C909-B
           (esi <> ChartAFlat(102 * row + 7)) and
           (esi <> ChartAFlat(102 * row + 8)) then begin
          if (ChartAFlat(102 * row + 7) > 0) and                    //0056C90D-39
             ((ChartAFlat(102 * ChartAFlat(102 * row + 7) + 7) > 0) or
              (ChartAFlat(102 * ChartAFlat(102 * row + 7) + 8) > 0)) then begin
            SetChartAFlat(102 * ChartAFlat(102 * row + 7) + 1,      //0056C939-8
              ChartAFlat(102 * row + 1));
            esi := ChartAFlat(102 * row + 7);                       //0056C947
          end;
          if (ChartAFlat(102 * row + 8) > 0) and                    //0056C94A-7A
             ((ChartAFlat(102 * ChartAFlat(102 * row + 8) + 7) > 0) or
              (ChartAFlat(102 * ChartAFlat(102 * row + 8) + 8) > 0)) then begin
            SetChartAFlat(102 * ChartAFlat(102 * row + 8) + 1,      //0056C96C-A
              ChartAFlat(102 * row + 1));
            esi := ChartAFlat(102 * row + 8);                       //0056C97A
          end;
        end;
      end;
      Dec(gen);                                                     //0056C988-C
    until gen <= 1;
  end;

  { 0056C992-C9CE: final horizontal push. }
  for row := 1 to gvar_011AE344 do begin
    esi := ChartAFlat(102 * row + 1);
    if (ChartAFlat(102 * row + 5) > 1) and
       (ChartAFlat(102 * row + 5) = ChartAFlat(102 * (row + 1) + 5)) and
       (esi >= ChartAFlat(102 * (row + 1) + 1)) then begin
      Inc(esi);
      SetChartAFlat(102 * (row + 1) + 1, esi);
    end;
  end;

  { 0056C9D0-CA22: track the maximal x/d1 column in gvar_011AE320 and
    gvar_011AE324. }
  row := 1;
  while ChartAFlat(102 * row + 2) > 0 do begin                      //0056CA17-22
    if ChartAFlat(102 * row + 1) > gvar_011AE320 then               //0056C9D7-E4
      gvar_011AE320 := ChartAFlat(102 * row + 1);
    if ChartAFlat(102 * row + 1) > gvar_011AE324 then               //0056C9F5-16
      gvar_011AE324 := ChartAFlat(102 * row + 1);
    Inc(row);
  end;

  gvar_011AE320 := gvar_011AE320 - 1;                               //0056CA24
  ScrollBar1.LargeChange := PaintBox1.Width - 5;                    //0056CA2A-48
  ScrollBar2.LargeChange := PaintBox1.Height - 5;                   //0056CA4B-6C
  ScrollBar1.SmallChange := 10;                                     //0056CA6C-B
  ScrollBar2.SmallChange := 10;                                     //0056CA7E
  Screen.Cursor := crDefault;                                       //0056CA90-9C
end;

procedure TForm13.Nach_erm;
var
  startNr, edi, cnt, chunkIdx, pnun, pIdx, i0: Integer;
  ebx, colx, ardy, rowMark: Integer;
  bmk: Integer;
  chain, nextChain, markers: AnsiString;
  tmpS, tmpS2: AnsiString;
begin
  { 0056A970: Nachfahren-Ermittlung. Fills chart grid A and the x/y
    column arrays gvar_02522AD8/gvar_0252C718 per person; the flat
    dword layout of grid A is reached via ChartAFlat/SetChartAFlat,
    the in-row ShortStrings via ChartAShort(edi, 152/193/322/...)
    and the AnsiString aux slots via ChartAAnsi/ChartSlotAnsi.
    The assembly dumps 48 zero dwords onto the stack; all locals
    therefore start with '' / nil (markers, chain, nextChain). }
  markers := '';
  chain := '';
  nextChain := '';

  { 0056A99D-AA12: scale/margin setup }
  Screen.Cursor := crHourGlass;                                     //0056A9A4
  gvar_0253636C := 0;                                               //0056A9AD-BF
  gvar_0061F118 := Round(gvar_0061F120 * 20);                       //0056A9C8-9F
  gvar_0061F114 := Round(gvar_0061F120 * 30);                       //0056A9DE-EF
  gvar_011AE344 := 0;                                               //0056A9F4
  gvar_011AE31C := 0;                                               //0056A9FB
  if gvar_0061F2BC = 1 then                                         //0056AA02-12
    Inc(gvar_011AE334, 10);                                         //0056AA0B

  { 0056AA12-AB1B: clear grid A and grid B rows 1..10000. Grid A gets
    d0..d3, d5, d7, d8, d10..d12 plus the in-row bytes 316/318/31A/31C;
    grid B gets d0..d3, d5..d12 plus the same bytes. }
  for edi := 10000 downto 1 do
  begin
    SetChartAFlat(102 * edi + 0, 0);                                 //0056AA31
    SetChartAFlat(102 * edi + 2, 0);                                 //0056AA36
    SetChartAFlat(102 * edi + 1, 0);                                 //0056AA3B
    SetChartAFlat(102 * edi + 3, 0);                                 //0056AA40
    SetChartAFlat(102 * edi + 11, 0);                                //0056AA50
    SetChartAFlat(102 * edi + 12, 0);                                //0056AA55
    SetChartAFlat(102 * edi + 5, 0);                                 //0056AA60
    SetChartAFlat(102 * edi + 7, 0);                                 //0056AA68
    SetChartAFlat(102 * edi + 8, 0);                                 //0056AA70
    ChartAShort(edi, 316)^ := #0;                                    //0056AA7B-82
    ChartAShort(edi, 318)^ := #0;                                    //0056AA82-85
    ChartAShort(edi, 320)^ := #0;                                    //0056AA8C-8F
    ChartAShort(edi, 322)^ := #0;                                    //0056AA96-99
    SetChartAFlat(102 * edi + 10, 0);                                //0056AAA0-A5
    SetChartBFlat(102 * edi + 3, 0);                                 //0056AAA8-AAAC
    SetChartBFlat(102 * edi + 2, 0);                                 //0056AAAC-AAE
    ChartBShort(edi, 316)^ := #0;                                    //0056AAB1-B5
    ChartBShort(edi, 318)^ := #0;                                    //0056AAB8-B8
    ChartBShort(edi, 320)^ := #0;                                    //0056AABF-BF
    SetChartBFlat(102 * edi + 9, 0);                                 //0056AAC6-C8
    SetChartBFlat(102 * edi + 1, 0);                                 //0056AACB-CD
    SetChartBFlat(102 * edi + 0, 0);                                 //0056AAD0-D2
    SetChartBFlat(102 * edi + 10, 0);                                //0056AAD5-D7
    SetChartBFlat(102 * edi + 11, 0);                                //0056AADA-DC
    SetChartBFlat(102 * edi + 5, 0);                                 //0056AADF-AE4
    SetChartBFlat(102 * edi + 7, 0);                                 //0056AAE6
    SetChartBFlat(102 * edi + 8, 0);                                 //0056AAEB
    ChartBShort(edi, 322)^ := #0;                                    //0056AAEE-F5
    SetChartBFlat(102 * edi + 12, 0);                                //0056AAF5-A7
  end;                                                              //0056AB08-1E

  { 0056AB24-AD64: locate the starting person; the filter on
    Geburt/taufjahr is only applied when more than the merely present }
  startNr := DataModule2.Table1Nummer.AsInteger;                     //0056AB24-31
  gvar_0061F2F0 := StrToInt(Form12.SpinEdit1.Text);                  //0056AB34-51
  if gvar_02536BA0 > 1 then                                         //0056AB56-5E
  begin
    DataModule2.Table17.Filter := 'gebjahr<=' + IntToStr(gvar_02536BA0) +
      ' and taufjahr<=' + IntToStr(gvar_02536BA0);                  //0056AB60-99
    DataModule2.Table17.Filtered := True;                            //0056ABAE-B8
    Form1.DBText1.Color := $FFFF;                                    //0056ABC0-D2
  end;
  DataModule2.Table17.FindKey([startNr]);                            //0056ABD7-F3
  if UpperCase(DataModule2.Table17Geschlecht.AsString) = 'M' then    //0056ABF3-2F
    DataModule2.Table17.IndexName := 'vat';                          //0056AC1D-2A
  if UpperCase(DataModule2.Table17Geschlecht.AsString) = 'W' then    //0056AC2F-6B
    DataModule2.Table17.IndexName := 'mut';                          //0056AC59-66
  DataModule2.Table17.FindKey([startNr]);                            //0056AC6B-87
  if not DataModule2.Table17.FindKey([startNr]) then                 //0056AC75-89
  begin
    ShowMessage('Keine Nachfahren gefunden.');                       //0056AC8B-90
    Exit;  //0056AC95: finally does NOT restore the cursor here
  end;
  PaintBox1.Canvas.Font.Name := 'Arial';                             //0056AC9A-B1
  PaintBox1.Canvas.Font.Size := Round(gvar_0061F120 * 9);            //0056ACB6-DB (5C02C: 9)
  gvar_011AE318 := -PaintBox1.Canvas.Font.Height + 2;                //0056ACE0-D07 (fild/ROUND identity)
  gvar_011AE33C := Round(gvar_0061F120 * 45);                        //0056AD0C-1D
  gvar_011AE340 := Round(gvar_0061F120 * 20);                        //0056AD22-33
  gvar_0061F118 := Round(gvar_0061F120 * 20);                        //0056AD38-49
  gvar_0061F114 := Round(gvar_0061F120 * 30);                        //0056AD4E-5F
  gvar_011AE330 := 1;                                                //0056AD6C
  DataModule2.Table17.IndexName := '';                               //0056AD76-80
  DataModule2.Table17.FindKey([startNr]);                            //0056AD85-9C
  sub_005637C4(DataModule2.Table17Nummer.AsInteger, chain);          //0056ADA1-B1

  { Phase 1 (0056ADB6-B47B): BFS over marriage chunks, collects the
    marked numbers that will be filled in phase 2 into nextChain. }
  while gvar_011AE330 <= gvar_0061F2F0 do                            //0056ADB6-C1
  begin
    cnt := Length(chain) div 6;                                      //0056ADC7-DD
    if cnt > 0 then                                                  //0056ADD9
    begin
      chunkIdx := 1;                                                 //0056ADE2
      while cnt > 0 do                                               //0056B44E-51
      begin
        pnun := StrToInt(Copy(chain, 6 * (chunkIdx - 1) + 1, 6));    //0056ADE9-E0E
        sub_005637C4(pnun, tmpS);                                    //0056AE11-17
        tmpS := tmpS + '*';                                          //0056AE1C-24
        if Pos(tmpS, markers) = 0 then                               //0056AE29-36
        begin
          sub_005637C4(pnun, tmpS2);                                 //0056AE3B-41
          markers := markers + tmpS2 + '*';                          //0056AE3E-56
        end;
        DataModule2.Table18.IndexName := 'num';                      //0056AE5B-68
        if DataModule2.Table18.FindKey([pnun]) then                  //0056AE6D-8B
        begin
          while (not DataModule2.Table18.Eof) and                    //0056BE03-12
                (DataModule2.Table18Nummer.AsInteger = pnun) do      //0056BE05-15
          begin
            sub_005637C4(DataModule2.Table18Epnum.AsInteger, tmpS);  //0056AE96-A9
            chain := chain + tmpS;                                   //0056AEAE-B7
            sub_005637C4(DataModule2.Table18Epnum.AsInteger, tmpS);  //0056AEBC-F
            tmpS := tmpS + '*';                                      //0056AED4-DF
            if Pos(tmpS, markers) = 0 then                           //0056AEE4-F4
            begin
              sub_005637C4(DataModule2.Table18Epnum.AsInteger, tmpS2); //0056AEF6-F0C
              markers := markers + tmpS2 + '*';                      //0056AEF9-24
            end;
            bmk := -1;  //0056AF29-39: v150 GetBookmark = or eax,-1;ret
            DataModule2.Table17.IndexName := '';                       //0056AF3C-46
            DataModule2.Table17.FindKey([DataModule2.Table18Epnum.AsInteger]); //0056AF4B-6C
            // 0056AF7E: v1A0 GotoBookmark = bare ret (no-op)
            bmk := -1;  //0056AF84-94: v150 again
            if UpperCase(DataModule2.Table17Geschlecht.AsString) = 'M' then //0056AF97-C6
            begin
              DataModule2.Table17.IndexName := 'vat';                  //0056AFD9
              if DataModule2.Table17.FindKey([pnun]) then              //0056AFE3
                while (not DataModule2.Table17.Eof) and                //0056B19F-AE
                      (DataModule2.Table17Vater.AsInteger = pnun) do   //0056B1B0-C0
                begin
                  rowMark := DataModule2.Table17Mutter.AsInteger;      //0056B00C-19
                  if rowMark = DataModule2.Table18Epnum.AsInteger then //0056B01B-2A
                  begin
                    sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056B030-43
                    nextChain := nextChain + tmpS;                     //0056B048-51
                    if gvar_011AE330 < gvar_0061F2F0 then              //0056B056-61
                    begin
                      sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056B067-7A
                      tmpS := tmpS + '*';                              //0056B07F-8A
                      if Pos(tmpS, markers) = 0 then                   //0056B08F-9F
                      begin
                        sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS2); //0056B0A5-B5
                        markers := markers + tmpS2 + '*';              //0056B0A8-D3
                      end;
                    end;
                  end
                  else if rowMark = 0 then                             //0056B0DD-EC
                  begin
                    sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056B0F2-FC
                    nextChain := nextChain + tmpS;                     //0056B10A-13
                    if gvar_011AE330 < gvar_0061F2F0 then              //0056B118-23
                    begin
                      sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056B125-2F
                      tmpS := tmpS + '*';                              //0056B13D-43
                      if Pos(tmpS, markers) = 0 then                   //0056B14D-5D
                      begin
                        sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS2); //0056B15F-6F
                        markers := markers + tmpS2 + '*';              //0056B162-8D
                      end;
                    end;
                  end;
                  DataModule2.Table17.Next;                            //0056B192
                end;
            end
            else if UpperCase(DataModule2.Table17Geschlecht.AsString) = 'W' then //0056B1C6-F5
            begin
              DataModule2.Table17.IndexName := 'mut';                  //0056B200
              if DataModule2.Table17.FindKey([pnun]) then              //0056B212
                while (not DataModule2.Table17.Eof) and                //0056B3C1-DD
                      (DataModule2.Table17Mutter.AsInteger = pnun) do  //0056B3DF-94
                begin
                  rowMark := DataModule2.Table17Vater.AsInteger;       //0056B23B-45
                  if rowMark = DataModule2.Table18Epnum.AsInteger then //0056B248-59
                  begin
                    sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056B25F-6C
                    nextChain := nextChain + tmpS;                     //0056B277-80
                    if gvar_011AE330 < gvar_0061F2F0 then              //0056B285-90
                    begin
                      sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056B296-A3
                      tmpS := tmpS + '*';                              //0056B2AE-B9
                      if Pos(tmpS, markers) = 0 then                   //0056B2BE-CE
                      begin
                        sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS2); //0056B2D4-E4
                        markers := markers + tmpS2 + '*';              //0056B2D7-FA
                      end;
                    end;
                  end
                  else if rowMark = 0 then                             //0056B30C-1B
                  begin
                    sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056B321-2E
                    nextChain := nextChain + tmpS;                     //0056B339-42
                    if gvar_011AE330 < gvar_0061F2F0 then              //0056B347-52
                    begin
                      sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056B354-5E
                      tmpS := tmpS + '*';                              //0056B361-72
                      if Pos(tmpS, markers) = 0 then                   //0056B37C-8C
                      begin
                        sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS2); //0056B38E-9E
                        markers := markers + tmpS2 + '*';              //0056B391-B8
                      end;
                    end;
                  end;
                  DataModule2.Table17.Next;                            //0056B3C1
                end;
            end;
            DataModule2.Table17.IndexName := '';                       //0056B3F5-FF
            // 0056B40F: v1A0 GotoBookmark(bmk) = no-op
            DataModule2.Table18.Next;                                  //0056B417-1F
          end;  // while Table18
        end;    // FindKey([pnun])
        Inc(chunkIdx);                                               //0056B44B
        Dec(cnt);                                                    //0056B44E
      end;
    end;
    chain := nextChain;                                              //0056B457-5D
    nextChain := '';                                                 //0056B462-65
    Inc(gvar_011AE330);                                              //0056B46A
  end;                                                               //0056B470-7B

  { Phase 2 (0056B481-BE58): breadth fill of grid A row edi: person
    rows then one marriage row per spouse of pnun. }
  edi := 1;                                                          //0056B481
  colx := 1;                                                         //0056B486
  ardy := 1;                                                         //0056B48D
  gvar_011AE330 := 1;                                                //0056B494
  DataModule2.Table17.IndexName := '';                               //0056B49E-A8
  DataModule2.Table17.FindKey([startNr]);                            //0056B4AD-C4
  sub_005637C4(DataModule2.Table17Nummer.AsInteger, chain);          //0056B4C9-D9
  nextChain := '';                                                   //0056B4DE-E1
  while gvar_011AE330 <= gvar_0061F2F0 do                            //0056B4E6-F1
  begin
    cnt := Length(chain) div 6;                                      //0056B4F7-09
    if cnt > 0 then
    begin
      chunkIdx := 1;                                                 //0056B512
      while cnt > 0 do                                               //0056BE1E-21
      begin
        pnun := StrToInt(Copy(chain, 6 * (chunkIdx - 1) + 1, 6));    //0056B519-44
        DataModule2.Table17.FindKey([pnun]);                         //0056B547-63
        SetChartAFlat(102 * edi + 2, edi);                           //0056B563-66
        SetChartAFlat(102 * edi + 3, DataModule2.Table17Nummer.AsInteger); //0056B56D-7A
        SetChartAFlat(102 * edi + 7, DataModule2.Table17Vater.AsInteger); //0056B581-8E
        SetChartAFlat(102 * edi + 8, DataModule2.Table17Mutter.AsInteger); //0056B595-A2
        ChartAShort(edi, 152)^ := Copy(DataModule2.Table17IDNR.AsString, 1, 40); //0056B5A9-E1
        if gvar_0061F2BC = 1 then                                    //0056B5E6
        begin
          tmpS := gvar_02536B9C + '\bilder\b' + IntToStr(ChartAFlat(102 * edi + 3)) + 'a.jpg'; //0056B5F3-27
          if FileExists(tmpS) then                                   //0056B62C-37
          begin
            tmpS := gvar_02536B9C + '\bilder\b' + IntToStr(ChartAFlat(102 * edi + 3)) + 'a.jpg'; //0056B63B-B6F (recomputed)
            ChartAShort(edi, 322)^ := Copy(tmpS, 1, 50);             //0056B674-99
          end;
        end;
        if edi = 1 then                                              //0056B69E-A1
        begin
          SetChartAFlat(102 * edi + 7, 0);                           //0056B6A3-A5
          SetChartAFlat(102 * edi + 8, 0);                           //0056B6AC-AE
        end;
        ChartAShort(edi, 193)^ := Copy(UpperCase(DataModule2.Table17Geschlecht.AsString), 1, 40); //0056B6B5-6D9
        if gvar_0253692C = 'Nachgr1' then                            //0056B703-14
        begin
          SetChartAFlat(102 * edi + 0, (gvar_011AE330 - 1) + ardy);  //0056B716-1F
          SetChartAFlat(102 * edi + 1, colx);                        //0056B726-29
        end;
        if gvar_0253692C = 'Nachgr2' then                            //0056B730-41
        begin
          SetChartAFlat(102 * edi + 0, colx);                        //0056B743-46
          SetChartAFlat(102 * edi + 1, (gvar_011AE330 - 1) + ardy);  //0056B74D-56
        end;
        for i0 := 0 to 19 do                                         //0056B75D-76
          ChartSlotAnsi(i0)^ := '';
        SetChartAFlat(102 * edi + 5, gvar_011AE330);                 //0056B778-81
        Inc(edi);                                                    //0056B788
        Inc(colx);                                                   //0056B789
        if colx > gvar_011AE31C then                                 //0056B78C-95
          gvar_011AE31C := colx;                                     //0056B797
        DataModule2.Table18.IndexName := 'num';                      //0056B79F-AC
        if DataModule2.Table18.FindKey([pnun]) then                  //0056B7B1-CF
        begin
          pIdx := 0;                                                 //0056B7D5-D7
          while (not DataModule2.Table18.Eof) and                    //0056BDF4-E03
                (DataModule2.Table18Nummer.AsInteger = pnun) do      //0056BE05-15
          begin
            Inc(pIdx);                                               //0056B7DF
            sub_005637C4(DataModule2.Table18Epnum.AsInteger, tmpS);  //0056B7E2-F5
            chain := chain + tmpS;                                   //0056B7FA-03
            bmk := -1;  //0056B808-18: v150 GetBookmark
            DataModule2.Table17.IndexName := '';                     //0056B81B-25
            DataModule2.Table17.FindKey([DataModule2.Table18Epnum.AsInteger]); //0056B82A-B49
            SetChartAFlat(102 * edi + 2, edi);                       //0056B850-53
            SetChartAFlat(102 * edi + 3, DataModule2.Table17Nummer.AsInteger); //0056B85A-67
            ChartAShort(edi, 193)^ := Copy(UpperCase(DataModule2.Table17Geschlecht.AsString), 1, 40); //0056B86E-87D
            SetChartAFlat(102 * edi + 7, 0);                         //0056B8BC-BE
            SetChartAFlat(102 * edi + 8, 0);                         //0056B8C5-C7
            ChartAShort(edi, 152)^ := Copy(DataModule2.Table17IDNR.AsString, 1, 40); //0056B8CE-F06
            SetChartAFlat(102 * edi + 10, ChartAFlat(102 * (edi - 1) + 3)); //0056B90B-12 (d3 of the partner row edi-1)
            SetChartAFlat(102 * edi + 11, DataModule2.Table18Nummer.AsInteger); //0056B919-26
            SetChartAFlat(102 * edi + 12, pIdx);                     //0056B92D-30
            if gvar_0253692C = 'Nachgr1' then                        //0056B937-48
            begin
              SetChartAFlat(102 * edi + 0, (gvar_011AE330 - 1) + ardy); //0056B94A-53
              SetChartAFlat(102 * edi + 1, colx);                    //0056B95A-5D
            end;
            if gvar_0253692C = 'Nachgr2' then                        //0056B964-75
            begin
              SetChartAFlat(102 * edi + 0, colx);                    //0056B977-7A
              SetChartAFlat(102 * edi + 1, (gvar_011AE330 - 1) + ardy); //0056B981-8A
            end;
            if gvar_0061F2BC = 1 then                                //0056B991-98
            begin
              tmpS := gvar_02536B9C + '\bilder\b' + IntToStr(ChartAFlat(102 * edi + 3)) + 'a.jpg'; //0056B99E-2D
              if FileExists(tmpS) then                               //0056B9D7-E2
              begin
                tmpS := gvar_02536B9C + '\bilder\b' + IntToStr(ChartAFlat(102 * edi + 3)) + 'a.jpg'; //0056B9E6-A0F (recomputed)
                ChartAShort(edi, 322)^ := Copy(tmpS, 1, 50);         //0056BA1F-44
              end;
            end;
            for i0 := 0 to 19 do                                     //0056BA49-64
              ChartSlotAnsi(i0)^ := '';
            { 0056BA66-B82: DEAD block - guarded by cmp [ebp-0C],0 which
              is never 0 here (20 from the slot-clear loop); skipped. }
            for i0 := 1 to 19 do                                     //0056BA85-ACC
            begin
              tmpS := Trim(ChartSlotAnsi(i0)^);                      //0056BA91-9E
              if tmpS <> '' then
                ChartAAnsi(102 * edi + 17)^ := ChartAAnsi(102 * edi + 17)^ + #13#10 + ChartSlotAnsi(i0)^; //0056BAA7-C7
            end;
            SetChartAFlat(102 * edi + 5, gvar_011AE330);             //0056BAD4-DD
            Inc(edi);                                                //0056BAE4
            Inc(colx);                                               //0056BAE5
            if colx > gvar_011AE31C then                             //0056BAE8-96
              gvar_011AE31C := colx;                                 //0056BAF3
            // 0056BB03: v1A0 GotoBookmark(bmk) = no-op
            bmk := -1;  //0056BB0E-1E: v150 GetBookmark
            if UpperCase(DataModule2.Table17Geschlecht.AsString) = 'M' then //0056BB21-50
            begin
              DataModule2.Table17.IndexName := 'vat';                 //0056BB5B
              if DataModule2.Table17.FindKey([pnun]) then             //0056BB6D
                while (not DataModule2.Table17.Eof) and               //0056BC3F-5B
                      (DataModule2.Table17Vater.AsInteger = pnun) do  //0056BC5D-6D
                begin
                  rowMark := DataModule2.Table17Mutter.AsInteger;      //0056BB96-A3
                  if rowMark = 0 then                                  //0056BBA5
                  begin
                    sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056BBA7-E4
                    if Pos(tmpS, nextChain) = 0 then                   //0056BBC5
                    begin
                      sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS2); //0056BBD1-E4
                      nextChain := nextChain + tmpS2;                  //0056BBE9-F2
                    end;
                  end
                  else if rowMark = DataModule2.Table18Epnum.AsInteger then //0056BBF9-17
                  begin
                    sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056BC19
                    nextChain := nextChain + tmpS;                     //0056BC26-3A
                  end;
                  DataModule2.Table17.Next;                            //0056BC3F
                end;
            end
            else if UpperCase(DataModule2.Table17Geschlecht.AsString) = 'W' then //0056BC73-A2
            begin
              DataModule2.Table17.IndexName := 'mut';                 //0056BCAD
              if DataModule2.Table17.FindKey([pnun]) then             //0056BCC9
                while (not DataModule2.Table17.Eof) and               //0056BD82-8D
                      (DataModule2.Table17Mutter.AsInteger = pnun) do //0056BDAF-BF
                begin
                  rowMark := DataModule2.Table17Vater.AsInteger;       //0056BCE8-F2
                  if rowMark = 0 then                                  //0056BCF5
                  begin
                    sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056BCF9-D03
                    if Pos(tmpS, nextChain) = 0 then                   //0056BD11-1F
                    begin
                      sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS2); //0056BD23-36
                      nextChain := nextChain + tmpS2;                  //0056BD3B-44
                    end;
                  end
                  else if rowMark = DataModule2.Table18Epnum.AsInteger then //0056BD4B-67
                  begin
                    sub_005637C4(DataModule2.Table17Nummer.AsInteger, tmpS); //0056BD6B
                    nextChain := nextChain + tmpS;                     //0056BD78-8C
                  end;
                  DataModule2.Table17.Next;                            //0056BD91
                end;
            end;
            DataModule2.Table17.IndexName := '';                      //0056BDC5
            // 0056BDE1: v1A0 GotoBookmark(bmk) = no-op
            DataModule2.Table18.Next;                                 //0056BDE7
          end;  // while Table18
        end;    // FindKey([pnun])
        Inc(chunkIdx);                                               //0056BE1B
        Dec(cnt);                                                    //0056BE1E
      end;
    end;
    chain := nextChain;                                              //0056BE27-2D
    nextChain := '';                                                 //0056BE32-35
    Inc(gvar_011AE330);                                              //0056BE3A
    colx := 1;                                                       //0056BE40
    gvar_011AE344 := edi;                                            //0056BE47
  end;                                                               //0056BE4D-58

  { Phase 3 (0056BE5E-BF24): tail bookkeeping }
  Screen.Cursor := crDefault;                                        //0056BE5E-67
  gvar_011AE328 := 0;                                                //0056BE6C-6E
  edi := 1;                                                          //0056BE73
  while ChartAFlat(102 * edi + 2) > 0 do                             //0056BEB6-C1
  begin
    if ChartAFlat(102 * edi + 5) > gvar_011AE328 then                //0056BE7A-87
      gvar_011AE328 := ChartAFlat(102 * edi + 5);                    //0056BE89-93
    gvar_02522AD8[edi] := ChartAFlat(102 * edi + 0);                 //0056BE99-A0
    gvar_0252C718[edi] := ChartAFlat(102 * edi + 1);                 //0056BEA7-AE
    Inc(edi);                                                        //0056BEB5
  end;
  ShowMessage(IntToStr(gvar_011AE328) + ' Generationen / ' +        //0056BEC3-F0
    IntToStr(gvar_011AE344 - 1) + ' Personen gefunden');
  gvar_011AE32C := PaintBox1.Canvas;                                 //0056BF15-24
end;

procedure TForm13.kek_ord;
var
  esi, edx, eax, ecx: Integer;
begin
  { 005686F0: for esi = gvar_011AE328-1 downto 1, walk rows on the
    1976670 anchor = grid B row[r] dword[5] ([eax-14] = [r][0],
    [eax-1AC] = [r-1][0], [eax-8] = [r][3], [eax-1A0] = [r-1][3],
    [eax+190] = [r+1][3], [eax+8] = [r][7], [eax+0C] = [r][8]): }
  esi := gvar_011AE328 - 1;                            //005686F7-FA
  while esi >= 1 do
  begin
    for edx := 1 to gvar_011AE344 do                   //005686FF-68
    begin
      eax := edx;  // anchor 1976670 = row(r) dword[5]
      ecx := gvar_019764C4[eax][5];                    //0056870E
      if (ecx < gvar_011AE328) and                     //00568710-12 jge
         (gvar_019764C4[eax - 1][5] = ecx) and         //00568714-1A jne
         (gvar_019764C4[eax][3] > 0) and               //0056871C-20
         (gvar_019764C4[eax - 1][3] > 0) and           //00568722-29
         (gvar_019764C4[eax + 1][3] > 0) and           //0056872B-32
         (gvar_019764C4[eax][0] <= gvar_019764C4[eax - 1][0]) and //00568734-3D jg
         (gvar_019764C4[eax][7] = 0) and               //0056873F-43
         (gvar_019764C4[eax][8] = 0) then              //00568745-49
      begin
        ecx := gvar_011AE334 + gvar_0061F118;          //0056874B-51
        ecx := ecx + ecx;                              //00568757
        gvar_019764C4[eax][0] := ecx +                 //00568759-5F
          gvar_019764C4[eax - 1][0];
      end;
    end;
    Dec(esi);                                          //0056876A-6D
  end;
end;

procedure TForm13.Proband1Click;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button7Click(Sender: TObject);
begin
  { 00573120: Linie dunnern - Strichbreite verkleinern, aber nicht unter 1. }
  if (PaintBox1.Canvas.Pen.Width - 1) > 0 then
  begin
    PaintBox1.Canvas.Pen.Width := PaintBox1.Canvas.Pen.Width - 1;
    PaintBox1.Refresh;
  end;
end;

procedure TForm13.vorf_erm2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.SpeedButton3Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.sam2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Symm;
var
  r, esi, eax, edx, ecx, edi: Integer;
begin
  { 00568834: two backward row walks over grid B (gvar_019764C4),
    from row gvar_011AE344 downto 1 (Step $198).
    Grid B local offsets at the [esi][5] anchor ebx:
      [ebx] = [esi][5], [ebx+8] = [esi][7], [ebx+0C] = [esi][8],
      [ebx-14] = [esi][0]; the second walk anchors at [esi][7]:
      [eax-8] = [esi][5], [eax-10] = [esi][3], [eax-1A0] = [esi-1][5],
      [eax-1A8] = [esi-1][3], [eax-1B4] = [esi-1][0],
      [eax-1C] = [esi][0]. Row-index terms [T*8 + 19764C4] translate
    to flat dword index 2*T (ChartBFlat). gvar_011AE334 and
    gvar_0061F118 are read as plain dword integers throughout. }

  { Part 1 (00568847-905). }
  for r := gvar_011AE344 downto 1 do
  begin
    esi := r;
    if gvar_011AE330 > 2 then                            //00568851-58
    begin
      if gvar_019764C4[esi][5] < gvar_011AE328 then      //0056885E-66 jge
      begin
        edi := gvar_019764C4[esi][7];                    //00568897
        if (edi > 0) and (gvar_019764C4[esi][8] > 0) then //0056889A-A2
        begin
          //005688A4-D5: midpoint move
          eax := Round((ChartBFlat(102 * gvar_019764C4[esi][8]) -
                        ChartBFlat(102 * gvar_019764C4[esi][7])) / 2.0) +
                 ChartBFlat(102 * edi);
          gvar_019764C4[esi][0] := eax;                  //005688D5
        end;
        eax := gvar_019764C4[esi][0];                    //005688E4
        ecx := eax div (gvar_011AE334 + gvar_0061F118);  //005688E8-E8 idiv
        if ecx > gvar_011AE31C then                      //005688EF-F5 jle
          gvar_011AE31C := ecx - 1;                      //005688F7-F8
      end;
    end;
  end;

  { Part 2 (0056889D-971). }
  for r := gvar_011AE344 downto 1 do
  begin
    esi := r;
    if (gvar_019764C4[esi][7] = 0) and                   //00568923-25
       (gvar_019764C4[esi][8] = 0) then                  //00568927-2B
    begin
      edx := gvar_019764C4[esi][5];                      //0056892D
      if (edx < gvar_011AE328) and                       //00568930-36 jge
         (edx = gvar_019764C4[esi - 1][5]) and           //00568938-3E jne
         (gvar_019764C4[esi][3] > 0) and                 //00568940-44
         (gvar_019764C4[esi - 1][3] > 0) and             //00568946-4D
         (gvar_019764C4[esi - 1][0] >= gvar_019764C4[esi][0]) then //0056894F-58 jl
      begin
        edx := gvar_019764C4[esi - 1][0];                //0056894F
        gvar_019764C4[esi][0] := edx + gvar_011AE334 +    //0056895A-66
          gvar_0061F118;
      end;
    end;
  end;
end;

procedure TForm13.kek_ord_2;
var
  ecx, esi, edx, eax, ebx: Integer;
begin
  { 00568774: counter trap makes EXACTLY two row walks (esi = V-1-V =
    -1; the bottom dec ecx/inc esi pair drives ecx = V-1 then V-2).
    Conditions like kek_ord but keyed on ecx: [r][5] and [r-1][5]
    must both equal ecx. Then [r][0] := [r-1][0] + sum, and [r-1][0]
    is nudged +/- sum depending on the parity of [r][2]
    ([eax-0C] = row[r] dword[2]; and 80000001 idiom = sign-corrected
    odd test). }
  ecx := gvar_011AE328;                                //0056877C
  esi := -1;                                           //0056877E-83
  while esi <> 0 do
  begin
    for edx := 1 to gvar_011AE344 do                   //0056878A-1F
    begin
      eax := edx;
      ebx := gvar_019764C4[eax][5];                    //0056879D
      if (ebx < gvar_011AE328) and                     //0056879F-A1 jge
         (ecx = gvar_019764C4[eax][5]) and             //005687A3-A5
         (ecx = gvar_019764C4[eax - 1][5]) and         //005687A7-AD
         (gvar_019764C4[eax][3] > 0) and               //005687AF-B3
         (gvar_019764C4[eax - 1][3] > 0) then          //005687B5-BC
      begin
        gvar_019764C4[eax][0] :=                       //005687BE-D0
          gvar_019764C4[eax - 1][0] +
          gvar_011AE334 + gvar_0061F118;
        ebx := gvar_019764C4[eax][2] and 80000001;     //005687D3-E2
        if ebx = 0 then                                //005687E3-E5 jne
          gvar_019764C4[eax - 1][0] :=                 //005687E7-F9
            gvar_019764C4[eax - 1][0] +
            gvar_011AE334 + gvar_0061F118
        else
          gvar_019764C4[eax - 1][0] :=                 //00568801-13
            gvar_019764C4[eax - 1][0] -
            gvar_011AE334 - gvar_0061F118;
      end;
    end;
    Dec(ecx);                                          //00568825
    Inc(esi);                                          //00568826
  end;
end;

procedure TForm13.Verwandtschaft1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button8Click(Sender: TObject);
begin
  { 005730D4: Linie dicker machen - Strichbreite erhohen, max. 3. }
  if PaintBox1.Canvas.Pen.Width < 3 then
  begin
    PaintBox1.Canvas.Pen.Width := PaintBox1.Canvas.Pen.Width + 1;
    PaintBox1.Refresh;
  end;
end;

procedure TForm13.Vorf_erm1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.memein(AValue: Integer);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.zerleg(AVal1: Integer; AVal2: Integer; ACanvas: TCanvas);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.FormCreate(Sender: TObject);
begin
  //00570740: Anfangsmasse und Zeichenstift vorbereiten.
  gvar_02536380 := $35C;
  gvar_02536384 := $258;
  gvar_011AE31C := 0;
  gvar_011AE324 := 0;
  gvar_011AE318 := 0;
  gvar_0253637C := 0;
  PaintBox1.Height := $64;
  PaintBox1.Width := $64;
  PaintBox1.Color := $FFFFFF;
  PaintBox1.Canvas.Pen.Width := 1;
end;

procedure TForm13.Vorf_erm;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button1Click(Sender: TObject);
begin
  //005707C0: zwischen symmetrisch / asymmetrisch umschalten.
  if gvar_0061F2DC <> 0 then
    gvar_0061F2DC := 0
  else
    gvar_0061F2DC := 1;
  if gvar_0061F2DC <> 0 then
    Button1.Caption := 'asym.'
  else
    Button1.Caption := 'symm.';
  PaintBox1.Refresh;
end;

procedure TForm13.Button2Click(Sender: TObject);
begin
  { 00570838: Verschiebungen in beiden Achsen -> Graphik neu zeichnen. }
  Inc(gvar_011AE338, 10);
  Inc(gvar_0061F110, 10);
  PaintBox1.Refresh;
end;

procedure TForm13.SpeedButton2Click(Sender: TObject);
begin
  //0057082C: nur Form13 schliessen.
  Close;
end;

procedure TForm13.FormShow(Sender: TObject);
begin
  //00570294: Tabellen oeffnen, Skaliermasse setzen und je nach
  //Aufrufmodus (gvar_0253692C) das Bild vorbereiten.
  gvar_02536388 := 0;
  Button1.Visible := False;
  DataModule2.Table17.Open;
  DataModule2.Table17.IndexName := '';
  DataModule2.Table18.Open;
  DataModule2.Table1Nummer.Value; //05702F3: Feldzugriff ohne Verwertung des Ergebnisses
  gvar_0061F2F4 := 0;
  gvar_0061F2F8 := 0;
  gvar_0061F120 := 0.375;
  gvar_0061F11C := Round(gvar_0061F120 * 6);
  gvar_011AE338 := $14;
  gvar_011AE334 := Round(gvar_0061F120 * 120);
  if gvar_0253692C = 'Vorgr1' then
  begin
    PaintBox1.Refresh;
    ScrollBar1.Position := 0;
    ScrollBar2.Position := 0;
    Vorf_erm;
  end;
  if gvar_0253692C = 'Vorgr2' then
  begin
    PaintBox1.Refresh;
    ScrollBar1.Position := 0;
    ScrollBar2.Position := 0;
    Vorf_erm;
  end;
  if gvar_0253692C = 'Nachgr1' then
  begin
    PaintBox1.Refresh;
    ScrollBar1.Position := 0;
    ScrollBar2.Position := 0;
    Nach_erm;
  end;
  if gvar_0253692C = 'Nachgr2' then
  begin
    PaintBox1.Refresh;
    ScrollBar1.Position := 0;
    ScrollBar2.Position := 0;
    Nach_erm;
  end;
end;

procedure TForm13.SpeedButton12Click(Sender: TObject);
begin
  //00570694: Zeichensatz waehlen (fuer Bild und Druck gleicher Stift).
  if gvar_011AE32C <> nil then
    gvar_011AE32C.Font.Name := 'Arial';
  if FontDialog1.Execute then
    gvar_0061F2EC := FontDialog1.Font.Name;
  PaintBox1.Refresh;
end;

procedure TForm13.UpDown1Click;
begin
  { 005661E8: Zoom herabsetzen, aber nicht unter 1. }
  if gvar_0061F120 > 1 then
    gvar_0061F120 := gvar_0061F120 - 0.1;
end;

procedure TForm13.SpeedButton1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.FormClose(sender:tobject;var action:tcloseaction);
begin
  //00570728: Form12 schliessen und Form13 unsichtbar stellen.
  { gvar_0061F0F8^ ist Form12; gvar_0061F10C ist Form13. }
  Form12.Close;
  Form13.Hide;
end;

procedure TForm13.Button3Click(Sender: TObject);
begin
  { 00570854: Vertikale Verschiebung zuruecksetzen -> Graphik neu zeichnen. }
  if gvar_0061F110 > 30 then
  begin
    Dec(gvar_0061F110, 10);
    PaintBox1.Refresh;
  end;
  if gvar_011AE334 > 60 then
  begin
    Dec(gvar_011AE338, 10);
    PaintBox1.Refresh;
  end;
end;

procedure TForm13.vr1;
var
  i, row, eaxv, ebp14, ebpC: Integer;
  byteFlag: Byte;
  fScale: Extended;
  tmp: AnsiString;
begin
  { 00570D1C: the "Vorgeneration 1" variant of Vr2 (0056904C). Same
    skeleton - canvas/font metrics, per-row memein/zerleg fill of grid
    A, 10000-row grid C copy, sub_00568FD4 scan, scrollbar setup - but
    the metric constants are swapped/shuffled: gvar_0061F118 = 30 and
    gvar_0061F114 = 20 (Vr2: 20/30). The bitmap scale gvar_011AE32C
    gate and the printer branch (fScale = 0x4001.. mantissa C0 -> 7.0)
    are identical in shape. Registers/EBP slots as in the listing. }
  tmp := '';                                        //00570D25-2A [ebp-18]
  Screen.Cursor := crHourGlass;                     //00570D40-4B
  fScale := 1.0;                                    //00570D50-5B [ebx]
  if PaintBox1.Canvas <> gvar_011AE32C then         //00570D61-76
    fScale := 1.13;                                 //00570D78-B5
  gvar_011AE33C := Round(gvar_0061F120 * 45 * fScale);  //00570D8B-A0
  gvar_011AE340 := 20;                              //00570DA5
  gvar_0061F118 := Round(gvar_0061F120 * 30 * fScale);  //00570DAF-C4
  gvar_0061F114 := Round(gvar_0061F120 * 20 * fScale);  //00570DC9-DE
  gvar_011AE334 := Round(gvar_0061F120 * 120 * fScale)  //00570DE3-FE
    + gvar_011AE338;
  if gvar_0061F2BC = 1 then                         //00570E03-0A
    Inc(gvar_011AE334, 10);                         //00570E0C
  gvar_011AE348 := 0;                               //00570E13-1A
  gvar_0253637C := 0;                               //00570E1A-21
  gvar_011AE318 := 0;                               //00570E21-27
  gvar_02536364 := ScrollBar1.Position;             //00570E28-37
  gvar_02536368 := ScrollBar2.Position;             //00570E3C-4B
  if PaintBox1.Canvas <> gvar_011AE32C then         //00570E50-65
  begin
    gvar_02536364 := 0;                             //00570E67-6E
    gvar_02536368 := 0;                             //00570E6E-75
  end;                                              //00570E75
  gvar_011AE32C.Font.Name := 'Arial';               //00570E75-B2
  gvar_011AE32C.Font.Size :=                     //00570E87-A6
    Round(gvar_0061F120 * 9 * fScale);
  gvar_011AE318 := 2 - gvar_011AE32C.Font.Height;   //00570EAB-ED
  if Printer.Canvas = gvar_011AE32C then            //00570EC2-D2
  begin
    fScale := 7.0;                                  //00570ED4-DF (mant. C0, exp 4001)
    gvar_011AE32C.Font.Name := 'Arial';             //00570EE5-F2
    gvar_011AE32C.Font.Size :=                  //00570EF7-25
      Round(gvar_0061F120 * 9);
    ebpC := PaintBox1.Canvas.Pen.Width;             //00570F26-31 [ebp-0C]
    gvar_011AE32C.Pen.Width := Round(ebpC * 7.0);   //00570F31-47
  end;
  if PaintBox1.Canvas <> gvar_011AE32C then         //00570F4C-61
    fScale := 1.13;                                 //00570F63-70
  row := 1;                                         //00570F76 [ebp-8]
  while gvar_011AE1C4[row][2] > 0 do                //00571052-5E
  begin
    for i := 0 to 19 do                             //00570F82-B1
    begin
      ChartSlotAnsi(i)^ := '';                      //00570F91-93
      // target [ebx(11AE35C+4i) + eax*8 - $150] = row string slot
      ChartAAnsi(102 * row + 19 + i)^ := '';        //00570F98-F8
    end;
    ebp14 := gvar_011AE1C4[row][3];                 //00570FB1-F5 [ebp-14]
    byteFlag := 0;                                  //00570FBF [ebp-10]
    DataModule2.Table17.FindKey([ebp14]);           //00570FC3-D5
    memein(gvar_011AE1C4[row - 1][3]);              //00570FDA-E4
    zerleg(gvar_011AE334, gvar_011AE318,            //00570FE9-FFE
      gvar_011AE32C);
    ChartAAnsi(102 * row + 18)^ :=                  //00571003-10
      ChartSlotAnsi(0)^;
    for i := 0 to 12 do                             //00571015-4D edi=13
    begin
      tmp := Trim(ChartSlotAnsi(i + 1)^);           //00571024-29 [ebp-18]
      if Length(tmp) > 0 then                       //0057102E-32 (jbe)
        ChartAAnsi(102 * row + 19 + i)^ := tmp;     //00571034-41
    end;
    Inc(row);                                       //0057104F
  end;
  if gvar_0061F2BC = 1 then                         //00571064-6B
    gvar_011AE348 := Round(                         //0057106D-C2
      (gvar_0253637C * gvar_011AE318 +
       gvar_011AE318) * 4 / 5);
  for row := 1 to 10000 do                          //00571097-C7
  begin
    eaxv := gvar_015924E4[row][2];                  //005710A8-AA
    SetChartAFlat(102 * row + 2, eaxv);             //005710AA-edx? [ebx]
    eaxv := gvar_015924E4[row][0];                  //005710AC-AF [esi-8]
    SetChartAFlat(102 * row, eaxv);                 //005710AF-B5
    eaxv := gvar_015924E4[row][1];                  //005710B2-B5 [esi-4]
    SetChartAFlat(102 * row + 1, eaxv);             //005710B5-9C
  end;
  sub_00568FD4;                                     //005710C9
  row := 1;                                         //005710CE [ebp-8]
  gvar_011AE320 := 0;                               //005710D5-D7
  while gvar_011AE1C4[row][2] > 0 do                //005710DC-40C
  begin
    eaxv := gvar_011AE1C4[row][0];                  //005710DE
    if eaxv > gvar_011AE320 then                    //005710E5-EB jle
      gvar_011AE320 := eaxv;                        //005710ED-28
    Inc(row);                                       //005710FD
  end;
  Dec(gvar_011AE320);                               //0057110E
  ScrollBar1.LargeChange := PaintBox1.Width - 5;    //00571114-2E
  ScrollBar2.LargeChange := PaintBox1.Height - 5;   //00571135-4F
  ScrollBar1.SmallChange := 20;                     //00571156-5F
  ScrollBar2.SmallChange := 20;                     //00571162-7A
  Screen.Cursor := crDefault;                       //0057117A-83
end;

procedure TForm13.SpeedButton13Click(Sender: TObject);
begin
  { 00572478: Druckdialog anzeigen. }
  PrinterSetupDialog1.Execute;
end;

procedure TForm13.vz1(AValue: TCanvas); //005711D4
{ The listing keeps grid B in edi = gvar_0197665C (= gvar_019764C4 + 408,
  i.e. the frame pointer used by vz2) with esi = 51*row as the stride:
  [edi + esi*8 + X] = gvar_019764C4[row][offset div 4], identical to the
  vz2 offset map (-190→d2, -198→d0, -194→d1, -18C→d3, -184→d5,
  -17C/-178→d7/d8, -170/-16C→d10/d11, -160/-15C→d14/d15, -158→word16,
  -0D7→ShortString@193, -100→@152, -56→@322, -150→ptrs@72).
  Differences vs vz2: scroll offsets are zeroed first and only loaded
  when the canvases match; no 'W' drop line and no above-box connector;
  child lines are orthogonal 3-segment connectors from the box's right
  edge (B0+334, [ebp-68]) via B0+334+118/2; the extrema are swapped:
  gvar_011AE324 = max (B1-33C+368) div (37C*318+114+318+348) and
  gvar_011AE31C = plain max of B5. EBP aliases: [ebp-8] = AValue. }
var
  row, i, child, tw, ebp14, rightX, cnt2: Integer;
  slotRow, slotI, q1, q2: Integer;     // [ebp-10] / [ebp-0C]
  tmpIn, tmpName, tName, tVor: AnsiString;
  sTitle: AnsiString;                  // [ebp-54]
  wasSchon: AnsiString;                // [ebp-20]
  tmpStr: AnsiString;                  // [ebp-0CC]/[ebp-0DC]
  ssID: ShortString;                   // [ebp-0A4]
  img: TImage;                         // [ebp-24]
  aRect: TRect;                        // [ebp-35]
  ratio: Extended;                     // [ebp-0B8]
  extOver: packed record Lo, Hi: Cardinal; W: Word; end; // FloatToStr build-up
  extVal: Extended absolute extOver;   // [esp push block]
begin
  { 005711D4: draws the ancestor chart columns ("Vorfahren", variant 1)
    into AValue using the grid-B copy of grid A. }
  Screen.Cursor := crHourGlass;                                     //0057120E-19
  PaintBox1.Canvas.Brush.Color := $FFFFFF;                          //0057121E-35
  PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height)); //0057123A-60
  gvar_02536364 := 0;                                               //00571265-67
  gvar_02536368 := 0;                                               //0057126C-6E
  if PaintBox1.Canvas = AValue then begin                           //00571273-85
    gvar_02536364 := ScrollBar1.Position;                           //00571287-96
    gvar_02536368 := ScrollBar2.Position;                           //0057129B-AA
  end;
  { Copy grid A -> grid B (identical to vz2's build loop). }
  row := 1;                                                         //005712AF
  while gvar_011AE1C4[row][2] > 0 do begin                          //005712B4-:418 (jmp 005712B4 -> 0057140C)
    gvar_019764C4[row][2] := gvar_011AE1C4[row][2];                 //005712B9-C3
    gvar_019764C4[row][3] := gvar_011AE1C4[row][3];                 //005712C3-CA
    gvar_019764C4[row][5] := gvar_011AE1C4[row][5];                 //005712D1-D8
    ChartBShort(row, 193)^ := ChartAShort(row, 193)^;               //005712DF-EF (@PStrNCpy cl=$28)
    gvar_019764C4[row][14] := gvar_011AE1C4[row][14];               //005712F4-FB
    gvar_019764C4[row][15] := gvar_011AE1C4[row][15];               //00571302-:09
    gvar_019764C4[row][16] := (gvar_019764C4[row][16] and $FFFF0000) or (gvar_011AE1C4[row][16] and $0000FFFF); //00571310-18 (word copy)
    ChartBShort(row, 152)^ := ChartAShort(row, 152)^;               //00571320-:30 (@PStrNCpy cl=$28)
    gvar_019764C4[row][10] := gvar_011AE1C4[row][10];               //00571335-3C
    gvar_019764C4[row][11] := gvar_011AE1C4[row][11];               //00571343-4A
    for i := 0 to 19 do                                             //00571351-6B (@CopyArray, 20 dwords, String)
      ChartBAnsi(102 * row + 18 + i)^ := ChartAAnsi(102 * row + 18 + i)^;
    gvar_019764C4[row][7] := gvar_011AE1C4[row][7];                 //00571370-77
    gvar_019764C4[row][8] := gvar_011AE1C4[row][8];                 //0057137E-85
    ChartBShort(row, 322)^ := ChartAShort(row, 322)^;               //0057138C-99 (@PStrNCpy cl=$32=50)
    gvar_019764C4[row][0] := (gvar_011AE1C4[row][0] - 1) * (gvar_011AE334 + gvar_0061F118) + gvar_011AE340 - gvar_02536364; //0057139E-C4
    gvar_019764C4[row][1] := (gvar_011AE1C4[row][1] - 1) * (gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348 + gvar_0061F114) + gvar_011AE33C - gvar_02536368; //005713CB-:04
    Inc(row);                                                       //0057140B
  end;
  AValue.Pen.Color := 0;                                            //0057141E-26
  DataModule2.Table17.FindKey([gvar_011AE368]);                     //0057142B-47
  tmpIn := DataModule2.Table17Name.AsString;                        //0057144C-66
  sub_00563868(tmpIn, tName);                                       //00571466-:6C
  tVor := DataModule2.Table17Vornamen.AsString;                     //00571474-8E
  sTitle := 'Vorfahren von ' + tName + ' ' + tVor;                  //0057144C-99 (@LStrCatN)
  AValue.TextOut(Round(gvar_0253636C * 30) - gvar_02536364 - 8,     //0057149E-E1
    Round(gvar_0253636C * 5) - gvar_02536368, sTitle);
  gvar_011AE324 := 0;                                               //005714E6-8E
  gvar_011AE31C := 0;                                               //005714ED-EF
  { Minimum of B[row][0] over active rows. }
  ebp14 := 100000; // $186A0                                        //005714F4
  row := 1;                                                         //005714F9
  while gvar_019764C4[row][2] > 0 do begin                          //005714FE-29 (jmp 005714FE -> 0057151E)
    if (gvar_019764C4[row][3] > 0) and (ebp14 > gvar_019764C4[row][0]) then //00571500-11
      ebp14 := gvar_019764C4[row][0];                               //00571513-16
    Inc(row);                                                       //0057151D
  end;
  { Shift all x coordinates so the leftmost box sits at gvar_011AE340. }
  row := 1;                                                         //0057152B
  if ebp14 > gvar_011AE340 then                                     //00571530-36
    while gvar_019764C4[row][2] > 0 do begin                        //00571538-63 (jmp 0057153 -> 00571563)
      if gvar_019764C4[row][3] > 0 then                             //0057153A-42
        gvar_019764C4[row][0] := gvar_019764C4[row][0] - gvar_02536364 - ebp14 + gvar_011AE340; //00571544-5B
      Inc(row);                                                     //00571562
    end;
  { Child connector loops: orthogonal 3-line connectors from the right
    box edge to the B[row][7]/B[row][8] children. }
  row := 1;                                                         //00571570
  while gvar_019764C4[row][2] > 0 do begin                          //00571575-96 (jmp 00571575 -> 0057198B)
    child := gvar_019764C4[row][7];                                 //005716B4-B4 (imul eax,[edi+esi*8-17C],33)
    if (gvar_019764C4[row][5] < gvar_011AE328) and (child > 0) then begin //0057157A-95
      rightX := gvar_019764C4[row][0] + gvar_011AE334;              //005715DF-EC ([ebp-68])
      cnt2 := gvar_0253637C * gvar_011AE318 + gvar_011AE318;        //005715A9-BA
      AValue.MoveTo(Round((rightX) * gvar_0253636C),
        Round(gvar_0253636C * (gvar_019764C4[row][1] + (gvar_011AE348 * gvar_0253636C + cnt2) / 2))); //0057159B-:05
      AValue.LineTo(Round((rightX + gvar_0061F118 / 2) * gvar_0253636C),
        Round(gvar_0253636C * (gvar_019764C4[row][1] + (gvar_011AE348 * gvar_0253636C + cnt2) / 2))); //0057160A-82
      AValue.LineTo(Round((rightX + gvar_0061F118 / 2) * gvar_0253636C),
        Round(gvar_0253636C * (gvar_019764C4[child][1] + (gvar_011AE348 * gvar_0253636C + cnt2) / 2))); //00571687-:07 (child = B[row][7])
      AValue.LineTo(Round(gvar_019764C4[child][0] * gvar_0253636C),
        Round(gvar_0253636C * (gvar_019764C4[child][1] + (gvar_011AE348 * gvar_0253636C + cnt2) / 2))); //0057170C-7D
    end;
    child := gvar_019764C4[row][8];                                 //005718BC (imul eax,[edi+esi*8-178],33)
    if (gvar_019764C4[row][5] < gvar_011AE328) and (child > 0) then begin //00571782-9D
      rightX := gvar_019764C4[row][0] + gvar_011AE334;              //005717E7-F4 ([ebp-68])
      cnt2 := gvar_0253637C * gvar_011AE318 + gvar_011AE318;        //005717B1-C2
      AValue.MoveTo(Round(rightX * gvar_0253636C),
        Round(gvar_0253636C * (gvar_019764C4[row][1] + (gvar_011AE348 * gvar_0253636C + cnt2) / 2))); //005717A3-0D
      AValue.LineTo(Round((rightX + gvar_0061F118 / 2) * gvar_0253636C),
        Round(gvar_0253636C * (gvar_019764C4[row][1] + (gvar_011AE348 * gvar_0253636C + cnt2) / 2))); //00571812-8A
      AValue.LineTo(Round((rightX + gvar_0061F118 / 2) * gvar_0253636C),
        Round(gvar_0253636C * (gvar_019764C4[child][1] + (gvar_011AE348 * gvar_0253636C + cnt2) / 2))); //0057188F-0F
      AValue.LineTo(Round(gvar_019764C4[child][0] * gvar_0253636C),
        Round(gvar_0253636C * (gvar_019764C4[child][1] + (gvar_011AE348 * gvar_0253636C + cnt2) / 2))); //00571914-85
    end;
    Inc(row);                                                       //0057198A
  end;
  { Extrema, person text, photo, 20 names, M/W boxes (like vz2 loop 3). }
  row := 1;                                                         //0057199C
  while gvar_019764C4[row][2] > 0 do begin                          //005719A1-74 (jmp 005719A1 -> 00572274)
    if (gvar_019764C4[row][1] - gvar_011AE33C + gvar_02536368) div (gvar_0253637C * gvar_011AE318 + gvar_0061F114 + gvar_011AE318 + gvar_011AE348) > gvar_011AE324 then //005719A6-DD (idiv)
      gvar_011AE324 := (gvar_019764C4[row][1] - gvar_011AE33C + gvar_02536368) div (gvar_0253637C * gvar_011AE318 + gvar_0061F114 + gvar_011AE318 + gvar_011AE348); //005719E5-1D (identical recompute)
    if gvar_019764C4[row][5] > gvar_011AE31C then                   //00571A24-31
      gvar_011AE31C := gvar_019764C4[row][5];                       //00571A33-3D
    DataModule2.Table17.FindKey([gvar_019764C4[row][3]]);           //00571A42-62
    if gvar_019764C4[row][3] > 0 then begin                         //00571A67-6F
      wasSchon := '';                                               //00571A75-78 (@LStrClr)
      if gvar_0061F2C0 = 1 then begin                               //00571A7D-84
        extOver.Lo := gvar_019764C4[row][14];                       //00571A96
        extOver.Hi := gvar_019764C4[row][15];                       //00571A8F
        extOver.W := Word(gvar_019764C4[row][16] and $FFFF);        //00571A86-: (10-byte push)
        wasSchon := 'K: ' + FloatToStr(extVal);                     //00571A9D-B0
      end;
      if gvar_0061F2C4 = 1 then begin                               //00571AB5-BC
        if wasSchon = '' then
          wasSchon := 'DS: ' + IntToStr(gvar_019764C4[row][3])      //00571AC4-E3
        else
          wasSchon := wasSchon + ' DS: ' + IntToStr(gvar_019764C4[row][3]); //00571AE5-:07
      end;
      if gvar_0061F2C8 = 1 then                                     //00571B0C-13
        if ChartBShort(row, 152)^ > ' ' then begin                  //00571B19-2A (@PStrCmp vs ' ', jbe skip)
          if wasSchon = '' then begin                               //00571B2C-30
            ssID := 'ID: ';                                         //00571B32-3D (@PStrCpy)
            ssID := Copy(ssID + ChartBShort(row, 152)^, 1, $2C);    //00571B42-54 (@PStrNCat cl=$2C=44)
            wasSchon := ssID;                                       //00571B59-67 (@LStrFromString)
          end
          else begin                                                //00571B69-94
            tmpStr := ChartBShort(row, 152)^;                       //00571B71-81 (@LStrFromString)
            wasSchon := wasSchon + ' ID: ' + tmpStr;                //00571B69-94 (@LStrCatN)
          end;
        end;
      AValue.Font.Size := Round(gvar_0061F120 * 9) - 1;             //00571B99-3
      AValue.TextOut(Round(gvar_019764C4[row][0] * gvar_0253636C) + 2,
        Round(gvar_019764C4[row][1] * gvar_0253636C) + AValue.Font.Height - 2,
        wasSchon);                                                  //00571BB8-:00
      AValue.Font.Size := Round(gvar_0061F120 * 9);                 //00571C05-:1E
      if (gvar_0061F2BC = 1) and (ChartBShort(row, 322)^ > ' ') then begin //00571C23-3E (@PStrCmp ' ', jbe skip)
        img := TImage.Create(Self);                                 //00571C44-4E (AOwner in ECX)
        tmpStr := ChartBShort(row, 322)^;                           //00571C56-60 (@LStrFromString)
        img.Picture.LoadFromFile(tmpStr);                           //00571C65-74
        if img.Picture.Graphic is TJPEGImage then begin             //00571C79-93
          q1 := img.Picture.Graphic.Height;                         //00571C99-CAA ([ebp-64])
          ratio := img.Height / q1;                                 //00571CB3-B8 (fdivrp) -> [ebp-0B8]
          q2 := Round(img.Picture.Graphic.Width * ratio);           //00571CCD-D6
          img.Width := q2;                                          //00571CE3-:E8 (TControl.SetWidth)
        end;
        q1 := Round((gvar_0253637C * gvar_011AE318 + gvar_011AE318) * 4 / 5); //00571CED-:0D (shl 2, fdiv 5, 64-bit)
        q2 := Round(img.Picture.Graphic.Width / img.Height
          * (gvar_0253637C * gvar_011AE318 + gvar_011AE318) * 4 / 5); //00571D44-77
        aRect := Rect(Round((gvar_019764C4[row][0] + 4) * gvar_0253636C),   //ALeft  00571DD7-FA
          Round((gvar_019764C4[row][1] + 2) * gvar_0253636C),               //ATop   00571DB3-D6
          Round((gvar_019764C4[row][0] + q2) * gvar_0253636C),              //ARight 00571D7C-B2
          Round((gvar_019764C4[row][1] + q1) * gvar_0253636C));             //ABottom 00571D2F-:3A
        img.Proportional := True;                                   //00571E01-06 (TImage.SetProportional)
        AValue.StretchDraw(aRect, img.Picture.Graphic);             //00571E0B-1D
        img.Free;                                                   //00571E22-25
      end;
      slotRow := 0;                                                 //00571E2A-2C
      slotI := 0;                                                   //00571E2F-31
      repeat                                                        //00571E34-.			(esi := edi here)
        AValue.Font.Style := [];                                    //00571E36-42 (byte 005723EC = 0)
        if slotI = 0 then                                           //00571E47-5E
          AValue.Font.Style := [fsBold];                            //00571E4D-59 (byte 005723C8 = 1)
        if slotI = 0 then                                           //00571E5E-62
          if RightStr(ChartBAnsi(102 * row + 18)^, 1) = '#' then begin //00571E64-8E
            ChartBAnsi(102 * row + 18)^ := Copy(ChartBAnsi(102 * row + 18)^, 1, Length(ChartBAnsi(102 * row + 18)^) - 1); //00571E90-BC (LStrCopy, len-1)
            AValue.Font.Style := [fsBold];                          //00571EC1-CD
          end;
        if slotI = 1 then                                           //00571ED2-D6
          if RightStr(ChartBAnsi(102 * row + 19)^, 1) = '#' then begin //00571ED8-FD
            ChartBAnsi(102 * row + 19)^ := Copy(ChartBAnsi(102 * row + 19)^, 1, Length(ChartBAnsi(102 * row + 19)^) - 1); //00571F04-30
            AValue.Font.Style := [fsBold];                          //00571F35-41
          end;
        if slotI = 2 then                                           //00571F46-4A
          if RightStr(ChartBAnsi(102 * row + 20)^, 1) = '#' then begin //00571F4C-71
            ChartBAnsi(102 * row + 20)^ := Copy(ChartBAnsi(102 * row + 20)^, 1, Length(ChartBAnsi(102 * row + 20)^) - 1); //00571F78-:04
            AValue.Font.Style := [fsBold];                          //00571FA9-B5
          end;
        if slotI = 3 then                                           //00571FBA-BE
          if RightStr(ChartBAnsi(102 * row + 21)^, 1) = '#' then begin //00571FC0-EA
            ChartBAnsi(102 * row + 21)^ := Copy(ChartBAnsi(102 * row + 21)^, 1, Length(ChartBAnsi(102 * row + 21)^) - 1); //00571FEC-18
            AValue.Font.Style := [fsBold];                          //0057201D-29
          end;
        tw := AValue.TextWidth(ChartBAnsi(102 * row + 18 + slotI)^); //0057202E-40
        ebp14 := Round((gvar_011AE334 * gvar_0253636C - tw) / 2);    //00572043-61 (fsubrp) -> [ebp-14]
        AValue.TextOut(Round(gvar_019764C4[row][0] * gvar_0253636C) + ebp14,
          Round((gvar_019764C4[row][1] + 3 + slotRow * gvar_011AE318 + gvar_011AE348) * gvar_0253636C),
          Trim(ChartBAnsi(102 * row + 18 + slotI)^));               //00572064-D3
        Inc(slotRow);                                               //005720D8
        Inc(slotI);                                                 //005720DB
      until slotI = 20;                                             //005720E1-E5 (cmp $14)
      AValue.Pen.Color := 0;                                        //005720EB-F3
      AValue.Brush.Style := bsClear;                                //005720F8-:00 (SetStyle dl=1)
      if ChartBShort(row, 193)^ = 'M' then                          //00572105-1E (@AStrCmp 'M')
        AValue.Rectangle(Round(gvar_019764C4[row][0] * gvar_0253636C),
          Round(gvar_019764C4[row][1] * gvar_0253636C),
          Round((gvar_019764C4[row][0] + gvar_011AE334) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348) * gvar_0253636C)); //00572124-B0
      if ChartBShort(row, 193)^ = 'W' then                          //005721B5-CB (@AStrCmp 'W')
        AValue.RoundRect(Round(gvar_019764C4[row][0] * gvar_0253636C),
          Round(gvar_019764C4[row][1] * gvar_0253636C),
          Round((gvar_019764C4[row][0] + gvar_011AE334) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348) * gvar_0253636C), 15, 15); //005721D1-61
      AValue.Pen.Color := 0;                                        //00572266-6E
    end;
    Inc(row);                                                       //00572273
  end;
  ScrollBar1.Max := (gvar_011AE31C + 1) * (gvar_011AE334 + gvar_0061F118) + gvar_011AE340; //00572285-:A9
  ScrollBar2.Max := (gvar_0253637C * gvar_011AE318 + gvar_0061F114 + gvar_011AE318 + gvar_011AE348) * gvar_011AE324 + gvar_011AE33C; //005722AE-:E3
  Screen.Cursor := crDefault;                                       //005722E8-FE
end;

procedure TForm13.vz2(AValue: TCanvas); //00569504
{ Each grid-B row addressed in the listing as [esi + edi*8 - X] with
  edi = 51*row (esi = base + 408) maps to the row-local offsets:
      -190 -18C -184 -198 -194 -17C -178 -170 -16C -160 -15C -158
      -> dword  2   3   5   0   1   7   8  10  11  14  15  word16
      -0D7 -> ShortString @193, -100 -> ShortString @152,
      -56 -> ShortString @322, -150 -> AnsiString ptrs @72 (dwords 18..37).
  EBP alias: [ebp-8] = AValue (EDX), [ebp-4] = Self. }
var
  row, i, child, tw, ebp14: Integer;
  slotRow, slotI, q1, q2: Integer;     // [ebp-10] / [ebp-0C]
  ratio: Extended;                     // [ebp-0B4]
  tmpIn, tmpName, tName, tVor: AnsiString;
  sTitle: AnsiString;                  // [ebp-54]
  wasSchon: AnsiString;                // [ebp-20]
  tmpStr: AnsiString;                  // [ebp-0A4]/[ebp-0DC]
  ssID: ShortString;                   // [ebp-0A0]
  img: TImage;                         // [ebp-24]
  aRect: TRect;                        // [ebp-35]
  extOver: packed record Lo, Hi: Cardinal; W: Word; end; // FloatToStr build-up
  extVal: Extended absolute extOver;   // [esp push block]
begin
  { 00569504: draws the ancestor chart into AValue, working entirely on
    a copy of grid A in grid B (every B[row][k] below is gvar_019764C4). }
  Screen.Cursor := crHourGlass;                                     //00569530-49
  gvar_02536364 := ScrollBar1.Position;                             //0056954E-5D
  gvar_02536368 := ScrollBar2.Position;                             //00569562-71
  if PaintBox1.Canvas <> AValue then begin                          //00569576-88
    gvar_02536364 := 0;                                             //0056958A-91
    gvar_02536368 := 0;                                             //00569591-93
  end;
  PaintBox1.Canvas.Brush.Color := $FFFFFF;                          //00569598-AF
  PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height)); //005695B4-F1
  AValue.Pen.Color := 0;                                            //005695F1-F9
  DataModule2.Table17.FindKey([gvar_011AE368]);                     //005695FE-621C
  tmpIn := DataModule2.Table17Name.AsString;                        //00569621-3B
  sub_00563868(tmpIn, tName);                                       //0056963B-46
  tVor := DataModule2.Table17Vornamen.AsString;                     //00569649-67
  sTitle := 'Vorfahren von ' + tName + ' ' + tVor;                  //00569621-71 (@LStrCatN)
  AValue.TextOut(Round(gvar_0253636C * 30) - gvar_02536364 - 8,     //00569673-B6
    Round(gvar_0253636C * 5) - gvar_02536368, sTitle);
  gvar_011AE324 := 0;                                               //005696BB-C4
  gvar_011AE31C := 0;                                               //005696C2-C4
  { Copy grid A -> grid B. }
  row := 1;                                                         //005696C9
  while gvar_011AE1C4[row][2] > 0 do begin                          //005696CE-9832
    gvar_019764C4[row][2] := gvar_011AE1C4[row][2];                 //005696D3-D6
    gvar_019764C4[row][3] := gvar_011AE1C4[row][3];                 //005696DD-E4
    gvar_019764C4[row][5] := gvar_011AE1C4[row][5];                 //005696EB-F2
    ChartBShort(row, 193)^ := ChartAShort(row, 193)^;               //005696F9-709 (@PStrNCpy cl=$28)
    gvar_019764C4[row][14] := gvar_011AE1C4[row][14];               //0056970E-15
    gvar_019764C4[row][15] := gvar_011AE1C4[row][15];               //0056971C-23
    gvar_019764C4[row][16] := (gvar_019764C4[row][16] and $FFFF0000) or (gvar_011AE1C4[row][16] and $0000FFFF); //0056972A-32 (word copy)
    ChartBShort(row, 152)^ := ChartAShort(row, 152)^;               //0056973A-74A (@PStrNCpy cl=$28)
    gvar_019764C4[row][10] := gvar_011AE1C4[row][10];               //0056974F-56
    gvar_019764C4[row][11] := gvar_011AE1C4[row][11];               //0056975D-64
    for i := 0 to 19 do                                             //0056976B-85 (@CopyArray, 20 dwords, String)
      ChartBAnsi(102 * row + 18 + i)^ := ChartAAnsi(102 * row + 18 + i)^;
    gvar_019764C4[row][7] := gvar_011AE1C4[row][7];                 //0056978A-91
    gvar_019764C4[row][8] := gvar_011AE1C4[row][8];                 //00569798-9F
    ChartBShort(row, 322)^ := ChartAShort(row, 322)^;               //005697A6-B3 (@PStrNCpy cl=$32=50)
    gvar_019764C4[row][0] := (gvar_011AE1C4[row][0] - 1) * (gvar_011AE334 + gvar_0061F118) + gvar_011AE340 - gvar_02536364; //005697B8-DEC
    gvar_019764C4[row][1] := (gvar_011AE1C4[row][1] - 1) * (gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348 + gvar_0061F114) + gvar_011AE33C - gvar_02536368; //005697E5-981E
    Inc(row);                                                       //00569825
  end;
  { Minimum of B[row][0] over active rows. }
  ebp14 := 100000; // $186A0                                        //00569838
  row := 1;                                                         //0056983D
  while gvar_019764C4[row][2] > 0 do begin                          //00569842-6D jmp 00569862
    if (gvar_019764C4[row][3] > 0) and (ebp14 > gvar_019764C4[row][0]) then //00569844-5A
      ebp14 := gvar_019764C4[row][0];                               //00569857-5A
    Inc(row);                                                       //00569861
  end;
  { Shift all x coordinates so the leftmost box sits at gvar_011AE340. }
  row := 1;                                                         //0056986F
  if ebp14 > gvar_011AE340 then                                     //00569874-7A
    while gvar_019764C4[row][2] > 0 do begin                        //0056987C-A7 jmp 005698A7
      if gvar_019764C4[row][3] > 0 then                             //0056987E-86
        gvar_019764C4[row][0] := gvar_019764C4[row][0] - gvar_02536364 - ebp14 + gvar_011AE340; //00569888-9F
      Inc(row);                                                     //005698A6
    end;
  { Loop 1: connector line above every active box (center-top up), plus
    the 'W' female drop line below the box. }
  row := 1;                                                         //005698B4
  while gvar_019764C4[row][2] > 0 do begin                          //005698B9-9AA1 (jmp 005698B9 -> 00569A96)
    if gvar_019764C4[row][3] > 0 then begin                         //005698BE-C6
      if gvar_019764C4[row][5] < gvar_011AE328 then                 //005698CC-D9 (jge 0056998C skips the pair)
        if (gvar_019764C4[row][7] > 0) or (gvar_019764C4[row][8] > 0) then begin //005698DF-F4
          AValue.MoveTo(Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C),
            Round(gvar_019764C4[row][1] * gvar_0253636C));          //005698FA-:37
          AValue.LineTo(Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C),
            Round((gvar_019764C4[row][1] - gvar_0061F114 / 2) * gvar_0253636C)); //0056993C-87 (fsubp: B1 - half)
        end;
      if (row > 1) and (ChartBShort(row, 193)^ = 'W') then begin    //0056998C-AE (@AStrCmp 'W')
        AValue.MoveTo(Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318) * gvar_0253636C) + gvar_011AE348 - 1); //005699B4-:19
        AValue.LineTo(Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_0061F114 / 2) * gvar_0253636C) + gvar_011AE348); //00569A1E-:90
      end;
    end;
    Inc(row);                                                       //00569A95
  end;
  { Loop 2a: connector down to the B[row][7] child. }
  row := 1;                                                         //00569AA7
  while gvar_019764C4[row][2] > 0 do begin                          //00569AAC-9F0E (jmp 00569AC -> 00569F03)
    child := gvar_019764C4[row][7];                                 //00569B22-25
    if (gvar_019764C4[row][5] < gvar_011AE328) and (child > 0) then begin //00569AB1-CC
      AValue.MoveTo(Round((gvar_019764C4[row][1] - gvar_0061F114 / 2) * gvar_0253636C),
        Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C)); //00569AD2-BD
      AValue.LineTo(Round((gvar_019764C4[child][0] + gvar_011AE334 / 2) * gvar_0253636C),
        Round((gvar_019764C4[child][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_0061F114 / 2) * gvar_0253636C)
        + Round(gvar_011AE348 * gvar_0253636C));                    //00569B22-BB
      if PaintBox1.Canvas = AValue then                             //00569BB0-C2
        AValue.LineTo(Round((gvar_019764C4[child][0] + gvar_011AE334 / 2) * gvar_0253636C),
          Round((gvar_019764C4[child][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318) * gvar_0253636C - 1
          + gvar_011AE348 * gvar_0253636C))                         //00569BC8-C49
      else
        AValue.LineTo(Round((gvar_019764C4[child][0] + gvar_011AE334 / 2) * gvar_0253636C),
          Round((gvar_019764C4[child][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318) * gvar_0253636C - 1
          + gvar_011AE348 * gvar_0253636C));                        //00569C53-C70 (identical, no inc)
    end;
    child := gvar_019764C4[row][8];                                 //00569D4A-4D
    if (gvar_019764C4[row][5] < gvar_011AE328) and (child > 0) then begin //00569CD9-CF4
      AValue.MoveTo(Round((gvar_019764C4[row][1] - gvar_0061F114 / 2) * gvar_0253636C),
        Round((gvar_019764C4[row][0] + gvar_011AE334 / 2) * gvar_0253636C)); //00569CFA-D45
      AValue.LineTo(Round((gvar_019764C4[child][0] + gvar_011AE334 / 2) * gvar_0253636C),
        Round((gvar_019764C4[child][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_0061F114 / 2) * gvar_0253636C)
        + Round(gvar_011AE348 * gvar_0253636C));                    //00569D4A-DD3
      if PaintBox1.Canvas = AValue then                             //00569DD8-EA
        AValue.LineTo(Round((gvar_019764C4[child][0] + gvar_011AE334 / 2) * gvar_0253636C),
          Round((gvar_019764C4[child][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318) * gvar_0253636C - 1
          + gvar_011AE348 * gvar_0253636C))                         //00569DF0-E71 (no inc)
      else
        AValue.LineTo(Round((gvar_019764C4[child][0] + gvar_011AE334 / 2) * gvar_0253636C),
          Round((gvar_019764C4[child][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318) * gvar_0253636C - 1
          + gvar_011AE348 * gvar_0253636C) + 1);                    //00569E7B-EFD (inc eax => y+1)
    end;
    Inc(row);                                                       //00569F02
  end;
  { Loop 3: tracked extrema, TextOut of the person text, photo, names,
    M/W boxes. }
  row := 1;                                                         //00569F14
  while gvar_019764C4[row][2] > 0 do begin                          //00569F19-7DE (jmp 00569F19 -> 0056A7DE)
    if (gvar_019764C4[row][0] - gvar_011AE340 + gvar_02536364) div (gvar_011AE334 + gvar_0061F114) > gvar_011AE31C then //00569F1E-48 (idiv)
      gvar_011AE31C := (gvar_019764C4[row][0] - gvar_011AE340 + gvar_02536364) div (gvar_0061F114 + gvar_011AE334); //00569F4A-71 (identical recompute)
    if gvar_019764C4[row][5] > gvar_011AE324 then                   //00569F76-83
      gvar_011AE324 := gvar_019764C4[row][5];                       //00569F85-8F
    DataModule2.Table17.FindKey([gvar_019764C4[row][3]]);           //00569F94-B4
    if gvar_019764C4[row][3] > 0 then begin                         //00569FB9-C1
      wasSchon := '';                                               //00569FC7-CA (@LStrClr)
      if gvar_0061F2C0 = 1 then begin                               //00569FCF-D6
        extOver.Lo := gvar_019764C4[row][14];                       //00569FE8
        extOver.Hi := gvar_019764C4[row][15];                       //00569FE1
        extOver.W := Word(gvar_019764C4[row][16] and $FFFF);        //00569FD8-: (10-byte push)
        wasSchon := 'K: ' + FloatToStr(extVal);                     //00569FEF-A007
      end;
      if gvar_0061F2C4 = 1 then begin                               //0056A007-0E
        if wasSchon = '' then
          wasSchon := 'DS: ' + IntToStr(gvar_019764C4[row][3])      //0056A016-35
        else
          wasSchon := wasSchon + ' DS: ' + IntToStr(gvar_019764C4[row][3]); //0056A037-59
      end;
      if gvar_0061F2C8 = 1 then                                     //0056A05E-65
        if ChartBShort(row, 152)^ > ' ' then begin                  //0056A06B-7C (@PStrCmp vs ' ', jbe skip)
          if wasSchon = '' then begin                               //0056A07E-82
            ssID := 'ID: ';                                         //0056A084-8F (@PStrCpy)
            ssID := Copy(ssID + ChartBShort(row, 152)^, 1, $2C);    //0056A094-A6 (@PStrNCat cl=$2C=44)
            wasSchon := ssID;                                       //0056A0AB-B9 (@LStrFromString)
          end
          else begin                                                //0056A0BB-E6
            tmpStr := ChartBShort(row, 152)^;                       //0056A0C3-D8 (@LStrFromString)
            wasSchon := wasSchon + ' ID: ' + tmpStr;                //0056A0BB-E6 (@LStrCatN)
          end;
        end;
      AValue.Font.Size := Round(gvar_0061F120 * 9) - 1;             //0056A0EB-:09
      AValue.TextOut(Round(gvar_019764C4[row][0] * gvar_0253636C) + 2,
        Round(gvar_019764C4[row][1] * gvar_0253636C) + AValue.Font.Height - 2,
        wasSchon);                                                  //0056A10A-52
      AValue.Font.Size := Round(gvar_0061F120 * 9);                 //0056A157-70
      if (gvar_0061F2BC = 1) and (ChartBShort(row, 322)^ > ' ') then begin //0056A175-:90 (@PStrCmp ' ', jbe skip)
        img := TImage.Create(Self);                                 //0056A196-:A0 (AOwner in ECX)
        tmpStr := ChartBShort(row, 322)^;                           //0056A1A8-B7 (@LStrFromString)
        img.Picture.LoadFromFile(tmpStr);                           //0056A1BD-C6
        if img.Picture.Graphic is TJPEGImage then begin             //0056A1CB-:E9
          q1 := img.Picture.Graphic.Height;                         //0056A1EB-1FC ([ebp-64])
          ratio := img.Height / q1;                                 //0056A208-:0A (fdivrp) -> [ebp-0B4]
          q2 := Round(img.Picture.Graphic.Width * ratio);           //0056A21D-236
          img.Width := q2;                                          //0056A23B-:40 (TControl.SetWidth)
        end;
        q1 := Round((gvar_0253637C * gvar_011AE318 + gvar_011AE318) * 4 / 5); //0056A245-:6A (shl 2, fdiv 5, 64-bit)
        q2 := Round(img.Picture.Graphic.Width / img.Height
          * (gvar_0253637C * gvar_011AE318 + gvar_011AE318) * 4 / 5); //0056A29C-A2D5
        aRect := Rect(Round((gvar_019764C4[row][0] + 4) * gvar_0253636C),   //ALeft  0056A335-59
          Round((gvar_019764C4[row][1] + 2) * gvar_0253636C),               //ATop   0056A311-34
          Round((gvar_019764C4[row][0] + q2) * gvar_0253636C),              //ARight 0056A2DC-:10
          Round((gvar_019764C4[row][1] + q1) * gvar_0253636C));             //ABottom 0056A297-:A0
        img.Proportional := True;                                   //0056A35F-64 (TImage.SetProportional)
        AValue.StretchDraw(aRect, img.Picture.Graphic);             //0056A366-7B
        img.Free;                                                   //0056A380-83
      end;
      slotRow := 0;                                                 //0056A388-8F
      slotI := 0;                                                   //0056A38D-8F
      repeat                                                        //0056A392-63F
        AValue.Font.Style := [];                                    //0056A394-:A0 (byte 0056A95C = 0)
        if slotI = 0 then                                           //0056A3A5-BC
          AValue.Font.Style := [fsBold];                            //0056A3AB-B7 (byte 0056A904 = 1)
        if slotI = 0 then                                           //0056A3BC-C0
          if RightStr(ChartBAnsi(102 * row + 18)^, 1) = '#' then begin //0056A3C2-EC
            ChartBAnsi(102 * row + 18)^ := Copy(ChartBAnsi(102 * row + 18)^, 1, Length(ChartBAnsi(102 * row + 18)^) - 1); //0056A3EE-1A (LStrCopy, len-1)
            AValue.Font.Style := [fsBold];                          //0056A41F-2B
          end;
        if slotI = 1 then                                           //0056A430-34
          if RightStr(ChartBAnsi(102 * row + 19)^, 1) = '#' then begin //0056A436-60
            ChartBAnsi(102 * row + 19)^ := Copy(ChartBAnsi(102 * row + 19)^, 1, Length(ChartBAnsi(102 * row + 19)^) - 1); //0056A462-8E
            AValue.Font.Style := [fsBold];                          //0056A493-9F
          end;
        if slotI = 2 then                                           //0056A4A4-A8
          if RightStr(ChartBAnsi(102 * row + 20)^, 1) = '#' then begin //0056A4AA-D4
            ChartBAnsi(102 * row + 20)^ := Copy(ChartBAnsi(102 * row + 20)^, 1, Length(ChartBAnsi(102 * row + 20)^) - 1); //0056A4D6-:02
            AValue.Font.Style := [fsBold];                          //0056A507-13
          end;
        if slotI = 3 then                                           //0056A518-1C
          if RightStr(ChartBAnsi(102 * row + 21)^, 1) = '#' then begin //0056A51E-48
            ChartBAnsi(102 * row + 21)^ := Copy(ChartBAnsi(102 * row + 21)^, 1, Length(ChartBAnsi(102 * row + 21)^) - 1); //0056A54A-76
            AValue.Font.Style := [fsBold];                          //0056A57B-87
          end;
        tw := AValue.TextWidth(ChartBAnsi(102 * row + 18 + slotI)^); //0056A58C-A1
        ebp14 := Round((gvar_011AE334 * gvar_0253636C - tw) / 2);    //0056A5A1-BF (fsubrp) -> [ebp-14]
        AValue.TextOut(Round(gvar_019764C4[row][0] * gvar_0253636C) + ebp14,
          Round((gvar_019764C4[row][1] + 3 + slotRow * gvar_011AE318 + gvar_011AE348) * gvar_0253636C),
          Trim(ChartBAnsi(102 * row + 18 + slotI)^));               //0056A5C2-31
        Inc(slotRow);                                               //0056A636
        Inc(slotI);                                                 //0056A639
      until slotI = 20;                                             //0056A63F-43 (cmp $14)
      AValue.Pen.Color := 0;                                        //0056A649-51
      AValue.Brush.Style := bsClear;                                //0056A656-5E (SetStyle dl=1)
      if ChartBShort(row, 193)^ = 'M' then                          //0056A663-7C (@AStrCmp 'M')
        AValue.Rectangle(Round(gvar_019764C4[row][0] * gvar_0253636C),
          Round(gvar_019764C4[row][1] * gvar_0253636C),
          Round((gvar_019764C4[row][0] + gvar_011AE334) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348) * gvar_0253636C)); //0056A682-:14
      if ChartBShort(row, 193)^ = 'W' then                          //0056A719-2F (@AStrCmp 'W')
        AValue.RoundRect(Round(gvar_019764C4[row][0] * gvar_0253636C),
          Round(gvar_019764C4[row][1] * gvar_0253636C),
          Round((gvar_019764C4[row][0] + gvar_011AE334) * gvar_0253636C),
          Round((gvar_019764C4[row][1] + gvar_0253637C * gvar_011AE318 + gvar_011AE318 + gvar_011AE348) * gvar_0253636C), 15, 15); //0056A735-CB
      AValue.Pen.Color := 0;                                        //0056A7D0-D8
    end;
    Inc(row);                                                       //0056A7DD
  end;
  ScrollBar1.Max := (gvar_011AE31C + 1) * (gvar_011AE334 + gvar_0061F118) + gvar_011AE340; //0056A7EF-:13
  ScrollBar2.Max := (gvar_0253637C * gvar_011AE318 + gvar_0061F114 + gvar_011AE318 + gvar_011AE348) * gvar_011AE324 + gvar_011AE33C; //0056A818-44
  Screen.Cursor := crDefault;                                       //0056A852-68
end;

procedure TForm13.Vr2;
var
  i, row, eaxv, ebp14, ebpC: Integer;
  byteFlag: Byte;
  fScale: Extended;
  tmp: AnsiString;
begin
  { 0056904C: prepares the chart canvas/font metrics ("Verkleinerung"
    fScale = 0x3FFF/0x80000000... = 1.0, or 1.13 when the drawing
    canvas differs from PaintBox1.Canvas), then walks the active rows
    of grid A filling the row-local string slots via memein/zerleg,
    copies the first 3 dwords of each grid-C row over grid A's first
    3 dwords, calls sub_00569010, finds the maximum dword[0], and
    sets the scrollbars.
    Registers used: EDX/EAX/EBX/ESI/ECX/EDI as in the listing. }
  tmp := '';                                        //00569055-57 [ebp-18]:LStrClr?$0
  Screen.Cursor := crHourGlass;                     //00569070-7B
  fScale := 1.0;                                    //00569080-8B
  if PaintBox1.Canvas <> gvar_011AE32C then         //00569094-A6
    fScale := 1.13;                                 //005690A8-B5
  gvar_011AE33C := Round(gvar_0061F120 * 45 * fScale);  //005690BB-D0
  gvar_011AE340 := 20;                              //005690D5
  gvar_0061F118 := Round(gvar_0061F120 * 20 * fScale);  //005690DF-F4
  gvar_0061F114 := Round(gvar_0061F120 * 30 * fScale);  //005690F9-10E
  gvar_011AE334 := Round(gvar_0061F120 * 120 * fScale)  //00569113-2E
    + gvar_011AE338;
  if gvar_0061F2BC = 1 then                         //00569133-3A
    Inc(gvar_011AE334, 10);                         //0056913C
  gvar_011AE348 := 0;                               //00569143-45
  gvar_0253637C := 0;                               //0056914A-4C
  gvar_011AE318 := 0;                               //00569151-53
  gvar_02536364 := 0;                               //00569158-5A
  gvar_02536368 := 0;                               //0056915F-61
  if PaintBox1.Canvas = gvar_011AE32C then          //00569166-7B
  begin
    gvar_02536364 := ScrollBar1.Position;           //0056917D-8C
    gvar_02536368 := ScrollBar2.Position;           //00569191-A0
  end;
  gvar_011AE32C.Font.Name := 'Arial';                //005691A5-B2
  gvar_011AE32C.Font.Size :=                     //005691B7-D6
    Round(gvar_0061F120 * 9 * fScale);
  gvar_011AE318 := 2 - gvar_011AE32C.Font.Height;   //005691DB-ED
  if Printer.Canvas = gvar_011AE32C then            //005691F2-700
  begin
    fScale := 6.0;                                  //00569215-0F
    gvar_011AE32C.Font.Name := 'Arial';             //0056921D-22
    gvar_011AE32C.Font.Size :=                  //00569227-42
      Round(gvar_0061F120 * 9);
    ebpC := PaintBox1.Canvas.Pen.Width;             //00569247-5E
    gvar_011AE32C.Pen.Width := Round(ebpC * 6.0);   //00569261-77
  end;
  if PaintBox1.Canvas <> gvar_011AE32C then         //0056927C-91
    fScale := 1.13;                                 //00569293-A0
  row := 1;                                         //005692A6-AD
  while gvar_011AE1C4[row][2] > 0 do                //00569382-8E
  begin
    for i := 0 to 19 do                             //005692B2-DF
    begin
      ChartSlotAnsi(i)^ := '';                      //005692C1-C3
      // target [ebx(11AE35C+4i) + eax*8 - $150] = row string slot
      ChartAAnsi(102 * row + 19 + i)^ := '';        //005692C8-D3
    end;
    ebp14 := gvar_011AE1C4[row][3];                 //005692E1-EC
    byteFlag := 0;                                  //005692EF
    DataModule2.Table17.FindKey([ebp14]);           //005692F3-305
    memein(gvar_011AE1C4[row - 1][3]);              //0056930A-14
    zerleg(gvar_011AE334, gvar_011AE318,            //00569319-2E
      gvar_011AE32C);
    ChartAAnsi(102 * row + 18)^ :=                  //00569333-40
      ChartSlotAnsi(0)^;
    for i := 0 to 18 do                             //00569345-7D
    begin
      tmp := Trim(ChartSlotAnsi(i + 1)^);           //00569354-59
      if Length(tmp) > 0 then                       //0056935E-62
        ChartAAnsi(102 * row + 19 + i)^ := tmp;     //00569364-71
    end;
    Inc(row);                                       //0056937F
  end;
  if gvar_0061F2BC = 1 then                         //00569394-9B
    gvar_011AE348 := Round(                         //0056939D-C2
      (gvar_0253637C * gvar_011AE318 +
       gvar_011AE318) * 4 / 5);
  for row := 1 to 10000 do                          //005693C7-F7
  begin
    eaxv := gvar_015924E4[row][2];                  //005693D8-DA
    SetChartAFlat(102 * row + 2, eaxv);             //005693DA-DC
    eaxv := gvar_015924E4[row][0];                  //005693DC-DF
    SetChartAFlat(102 * row, eaxv);                 //005693DF-E2
    eaxv := gvar_015924E4[row][1];                  //005693E2-E5
    SetChartAFlat(102 * row + 1, eaxv);             //005693E5-E8
  end;
  sub_00569010;                                     //005693F9
  row := 1;                                         //005693FE
  gvar_011AE320 := 0;                               //00569405-07
  while gvar_011AE1C4[row][2] > 0 do                //00569430-3C
  begin
    eaxv := gvar_011AE1C4[row][0];                  //0056940E-15
    if eaxv > gvar_011AE320 then                    //00569415-1B jle
      gvar_011AE320 := eaxv;                        //0056941D-28
    Inc(row);                                       //0056942D
  end;
  Dec(gvar_011AE320);                               //0056943E
  ScrollBar1.LargeChange := PaintBox1.Width - 5;    //00569444-65
  ScrollBar2.LargeChange := PaintBox1.Height - 5;   //00569465-86
  ScrollBar1.SmallChange := 20;                     //00569486-98
  ScrollBar2.SmallChange := 20;                     //00569498-AA
  Screen.Cursor := crDefault;                       //005694AA-B3
end;

procedure TForm13.nachf_neu;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button4Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.PaintBox1Paint(Sender:TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Button6Click(Sender: TObject);
begin
  { 00572448: Zoom ein. }
  gvar_0061F120 := gvar_0061F120 + 0.13;
  PaintBox1.Refresh;
end;

procedure TForm13.Button5Click(Sender: TObject);
begin
  { 00572404: Zoom aus. }
  if gvar_0061F120 > 0.5 then
  begin
    gvar_0061F120 := gvar_0061F120 - 0.13;
    PaintBox1.Refresh;
  end;
end;


end.
