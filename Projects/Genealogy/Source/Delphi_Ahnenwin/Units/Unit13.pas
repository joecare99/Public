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
  SysUtils, StrUtils, Classes, ExtCtrls, Buttons, Dialogs, StdCtrls, WPPDFR2, WPPDFPRP, Forms, Controls, Grids, DB;

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
    procedure memein; //00566220
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
  Unit12, Unit2, AHNGlobals, Math;
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

procedure TForm13.schieb_vm;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm13.schieb_vm1;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
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
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
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
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
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

procedure TForm13.memein;
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
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
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
