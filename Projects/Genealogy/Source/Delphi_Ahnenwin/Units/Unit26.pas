unit Unit26;

{-------------------------------------------------------------------------------
  Unit26 - TForm26, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit26.pas and the original resource
  Source\Projects_AhnenWin\Form26.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, StdCtrls, Buttons, Forms, Controls, Grids, DB, Graphics;

type
  TForm26 = class(TForm)
  published
    GroupBox1: TGroupBox; //2F0
    RadioButton1: TRadioButton; //2F4
    RadioButton2: TRadioButton; //2F8
    RadioButton3: TRadioButton; //2FC
    SpeedButton1: TSpeedButton; //300
    procedure RadioButton2Click(Sender: TObject); //00550450
    procedure nach_erm; //0054FC40
    procedure FormActivate(Sender: TObject); //00550540
    procedure RadioButton1Click(Sender: TObject); //0054FA08
    procedure RadioButton3Click(Sender: TObject); //0054F9C8
    procedure los; //0054F8B4
    procedure SpeedButton1Click(Sender: TObject); //0054F9FC
  public
    Mode: Integer; //24C
  end;

var
  Form26: TForm26;

implementation

uses
  AHNGlobals, Unit1, Unit2, Unit27, Dialogs;

{$R ..\Forms\Form26.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm26.RadioButton2Click(Sender: TObject);
var
  s: AnsiString;
begin
  //00550450: "Nachfahren-Datenbank (Gedcom)" anstossen.
  gvar_0061F008 := 'nachged';
  s := Trim(Form1.StringGrid2.Cells[0, 1]);
  if s = '' then
  begin
    ShowMessage('Keine Nachfahren gefunden.');
    Form26.Close;
  end
  else
  begin
    nach_erm;
    if gvar_0061F004 = 0 then
      los
    else
      Form26.Close;
  end;
end;

procedure TForm26.nach_erm;
var
  nummer, key, gen, cnt, stufennr, i, n, lfn: Integer;
  frontier, nextf, doneE, s, t, eing: AnsiString;

  function Code(AValue: Integer): AnsiString;
  var
    s: AnsiString;
  begin
    //0054F810: Zahl auf 6 Stellen mit fuehrenden Nullen (Code).
    s := '000000' + IntToStr(AValue);
    Result := Copy(s, Length(s) - 5, 6);
  end;

begin
  //0054FC40: Nachfahren-Ausgabe in Gedcom via Table24 sammeln.
  nummer := DataModule2.Table1Nummer.AsInteger;
  DataModule2.Table1.IndexName := '';
  eing := '1';
  gvar_0061F004 := 0;
  if not InputQuery('Nachfahren - Gedcom', 'Wieviele Generationen ? ', eing) then
  begin
    gvar_0061F004 := 1;
    Exit;
  end;
  if Trim(eing) = '' then
  begin
    gvar_0061F004 := 1;
    Exit;
  end;
  if gvar_02536BA0 > 1 then
  begin
    s := 'gebjahr<=' + IntToStr(gvar_02536BA0) +
      ' and taufjahr<=' + IntToStr(gvar_02536BA0);
    DataModule2.Table1.Filter := s;
    DataModule2.Table1.Filtered := True;
    DataModule2.Table9.Filter := s;
    DataModule2.Table9.Filtered := True;
    Form1.DBText1.Color := clYellow;
  end;
  DataModule2.Table1.FindKey([nummer]);
  gen := 1;
  cnt := 1;
  DataModule2.Table24.Open;
  DataModule2.Table24.Close;
  DataModule2.Table24.EmptyTable;
  DataModule2.Table24.IndexName := 'lfn';
  DataModule2.Table24.Open;
  frontier := Code(DataModule2.Table1Nummer.AsInteger) + '*';
  nextf := '';
  doneE := '';
  stufennr := StrToInt(eing);
  if stufennr > 0 then
  begin
    while stufennr > 0 do
    begin
      n := Round(Length(frontier) / 7);
      if n > 0 then
      begin
        for i := 1 to n do
        begin
          key := StrToInt(Copy(frontier, (i - 1) * 7 + 1, 6));
          DataModule2.Table1.FindKey([key]);
          s := Code(DataModule2.Table1Nummer.AsInteger) + '*';
          if Pos(s, doneE) = 0 then
          begin
            cnt := cnt + 1;
            doneE := doneE + Code(DataModule2.Table1Nummer.AsInteger) + '*';
            if DataModule2.Table5.RecordCount > 0 then
            begin
              DataModule2.Table5.First;
              while not DataModule2.Table5.EOF do
              begin
                s := Code(DataModule2.Table5Epnum.AsInteger) + '*';
                if Pos(s, doneE) = 0 then
                begin
                  cnt := cnt + 1;
                  doneE := doneE +
                    Code(DataModule2.Table5Epnum.AsInteger) + '*';
                  t := UpperCase(DataModule2.Table1Geschlecht.AsString);
                  if t = 'M' then
                  begin
                    DataModule2.Table9.IndexName := 'vat';
                    key := DataModule2.Table1Nummer.AsInteger;
                    if DataModule2.Table9.FindKey([key]) then
                    begin
                      repeat
                        nextf := nextf +
                          Code(DataModule2.Table9Nummer.AsInteger) + '*';
                        DataModule2.Table9.Next;
                      until DataModule2.Table9.EOF or
                        (DataModule2.Table9Vater.AsInteger <> key);
                    end;
                  end;
                  t := UpperCase(DataModule2.Table1Geschlecht.AsString);
                  if t = 'W' then
                  begin
                    DataModule2.Table9.IndexName := 'mut';
                    key := DataModule2.Table1Nummer.AsInteger;
                    if DataModule2.Table9.FindKey([key]) then
                    begin
                      repeat
                        nextf := nextf +
                          Code(DataModule2.Table9Nummer.AsInteger) + '*';
                        DataModule2.Table9.Next;
                      until DataModule2.Table9.EOF or
                        (DataModule2.Table9Mutter.AsInteger <> key);
                    end;
                  end;
                end;
                DataModule2.Table5.Next;
              end;
            end;
          end;
        end;
      end;
      frontier := nextf;
      nextf := '';
      if Trim(frontier) = '' then
        Break;
      gen := gen + 1;
      stufennr := stufennr - 1;
    end;
  end;
  lfn := 0;
  n := Round(Length(doneE) / 7);
  if n > 0 then
  begin
    for i := 1 to n do
    begin
      lfn := lfn + 1;
      DataModule2.Table24.Append;
      DataModule2.Table24Lfdn.AsInteger := lfn;
      DataModule2.Table24Pp.AsInteger := lfn;
      DataModule2.Table24Nummer.AsInteger :=
        StrToInt(Copy(doneE, (i - 1) * 7 + 1, 6));
      DataModule2.Table24.Post;
    end;
  end;
  DataModule2.Table1.FindKey([nummer]);
  ShowMessage(IntToStr(gen - 1) + ' Generation(en) / ' +
    IntToStr(cnt - 1) + ' Person(en) gefunden.');
end;

procedure TForm26.FormActivate(Sender: TObject);
begin
  { (00550540) When the dialog is opened, the radio buttons are not set yet. }
  RadioButton1.Checked := False;
  RadioButton2.Checked := False;
  RadioButton3.Checked := False;
end;

procedure TForm26.RadioButton1Click(Sender: TObject);
var
  s: AnsiString;
  flag: Integer;
begin
  //0054FA08: "Vorfahren-Datenbank (Gedcom)" anstossen.
  s := Trim(Form1.Edit1.Text);
  if s = '' then
    s := Trim(Form1.Edit2.Text);
  if s = '' then
  begin
    ShowMessage('Keine Vorfahren gefunden.');
    Form26.Close;
  end
  else
  begin
    gvar_0253694C := 1;
    gvar_0061F008 := 'vorged';
    flag := 0;
    Form1.vorf_erm2(StrToInt(Form1.DBText1.Field.AsString),
      Form1.DBEdit7.Field.AsString, flag);
    if gvar_0253694C = 0 then
    begin
      Form26.Close;
    end
    else
    begin
      gvar_0061F000 := 0;
      Form1.SaveDialog1.FileName := '';
      Form1.SaveDialog1.FilterIndex := 1;
      Form1.SaveDialog1.DefaultExt := 'ged';
      if Form1.SaveDialog1.Execute then
      begin
        Form1.Refresh;
        Screen.Cursor := crHourGlass;
        try
          Form27.ShowModal;
        finally
          Screen.Cursor := crDefault;
        end;
      end
      else
      begin
        gvar_0061F000 := 1;
        Mode := 2;
      end;
    end;
  end;
end;

procedure TForm26.RadioButton3Click(Sender: TObject);
begin
  //0054F9C8: "Alles" - alle Daten in einer Gedcom-Datei ausgeben.
  gvar_0061F008 := 'Alle';
  los;
end;

procedure TForm26.los;
begin
  //0054F8B4: Speicher-Namen erfragen und dann die Gedcom-Ausgabe starten.
  gvar_0061F000 := 0;
  Form1.SaveDialog1.DefaultExt := 'ged';
  Form1.SaveDialog1.Filter := 'Gedcom-Dateien (*.ged)|*.ged';
  Form1.SaveDialog1.Options := [ofOverwritePrompt];
  Form1.SaveDialog1.FilterIndex := 1;
  if Form1.SaveDialog1.Execute then
  begin
    Form1.Refresh;
    Screen.Cursor := crHourGlass;
    try
      Form27.ShowModal;
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
  begin
    gvar_0061F000 := 1;
    Mode := 2;
  end;
end;

procedure TForm26.SpeedButton1Click(Sender: TObject);
begin
  { (0054F9FC) The button "nichts dergleichen" closes the dialog. }
  Close;
end;


end.
