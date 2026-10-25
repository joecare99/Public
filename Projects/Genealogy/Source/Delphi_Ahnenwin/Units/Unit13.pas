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
    procedure nr2; //0056CB30
    procedure nz1; //0056D6B4
    procedure nz2; //0056EB10
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
    procedure vz1; //005711D4
    procedure vz2; //00569504
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
  Unit12, Unit2, AHNGlobals, Math, Printers;
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

procedure TForm13.nr2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.nz1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.nz2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
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
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.Nach_erm;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
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
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.SpeedButton13Click(Sender: TObject);
begin
  { 00572478: Druckdialog anzeigen. }
  PrinterSetupDialog1.Execute;
end;

procedure TForm13.vz1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.vz2;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
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
