UNIT Frm_SudokuMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

INTERFACE

USES
{$IFnDEF FPC}
  XPStyleActnCtrls,  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages, PrintersDlgs,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ExtCtrls, ImgList,
  ActnList, Menus, StdActns, Spin, printers, ComCtrls;

TYPE
  TPossib = 1..16;
  TPossibility = SET OF TPossib;
  TCellData = RECORD
    Data: byte;
    CPossib: TPossibility;
    PLevel: Shortint;
  END;

  TForm1 = CLASS(TForm)
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    ActionManager1: TActionList;
    ImageList1: TImageList;
    Splitter1: TSplitter;
    DrawGrid1: TDrawGrid;
    BitBtn1: TBitBtn;
    StaticText1: TStaticText;
    FileOpen1: TFileOpen;
    FileSaveAs1: TFileSaveAs;
    CheckBox1: TCheckBox;
    SpinEdit1: TSpinEdit;
    BitBtn4: TBitBtn;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    CheckBox2: TCheckBox;
    PageSetupDialog1: TPageSetupDialog;
    PrintDialog1: TPrintDialog;
    CAct_FileNew: TAction;
    Datei1: TMenuItem;
    Neu1: TMenuItem;
    ffnen1: TMenuItem;
    Speichernunter1: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    StaticText2: TStaticText;
    ProgressBar1: TProgressBar;
    Action1: TAction;
    PROCEDURE SpeedButton5Click(Sender: TObject);
    PROCEDURE PageSetupDialog1DrawGreekText(Sender: TObject; Canvas: TCanvas;
      PageRect: TRect; VAR DoneDrawing: Boolean);
    PROCEDURE PageSetupDialog1DrawMargin(Sender: TObject; Canvas: TCanvas;
      PageRect: TRect; VAR DoneDrawing: Boolean);
    PROCEDURE SpeedButton4Click(Sender: TObject);
    PROCEDURE CheckBox2Click(Sender: TObject);
    PROCEDURE BitBtn4Click(Sender: TObject);
    PROCEDURE SpinEdit1Change(Sender: TObject);
    PROCEDURE CheckBox1Click(Sender: TObject);
    PROCEDURE FileSaveAs1Accept(Sender: TObject);
    PROCEDURE FileOpen1Accept(Sender: TObject);
    PROCEDURE BitBtn1Click(Sender: TObject);
    PROCEDURE DrawGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      CONST Value: STRING);
    PROCEDURE DrawGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      VAR Value: STRING);
    PROCEDURE DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      VAR CanSelect: Boolean);
    PROCEDURE DrawGrid1KeyPress(Sender: TObject; VAR Key: Char);
    PROCEDURE FormResize(Sender: TObject);
    PROCEDURE DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  Private
    { Private-Deklarationen }
    cells: ARRAY[0..8, 0..8] OF TCellData;
    tw: integer;
    index: array[0..80] of byte;
    FUNCTION GetPosibility(ACol: Integer; ARow: Integer; verify: Shortint =
      1; CL: byte = 0): TPossibility;
    FUNCTION setcount(s: Tpossibility): integer;
    FUNCTION firstinset(s: Tpossibility): integer;
    PROCEDURE FullReDrawGrid;
    procedure EliminateFullySpecCells;
  Public
    { Public-Deklarationen }
  END;

VAR
  Form1: TForm1;

IMPLEMENTATION

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

PROCEDURE TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);

VAR
  possib: TPossibility;
BEGIN
  IF CheckBox2.Checked THEN
    BEGIN
      possib := GetPosibility(ACol, ARow, SpinEdit1.value);
      IF gdSelected IN state THEN
        DrawGrid1.Canvas.Brush.Color := clBlue
      ELSE
        CASE setcount(possib) OF
          0: DrawGrid1.Canvas.Brush.Color := clred;
          1:
            BEGIN
              IF cells[acol, arow].data > 0 THEN
                DrawGrid1.Canvas.Brush.Color := clwhite
              ELSE
                DrawGrid1.Canvas.Brush.Color := cllime;
              IF CheckBox1.Checked THEN
                cells[acol, arow].data := firstinset(possib);
            END;
          2: DrawGrid1.Canvas.Brush.Color := clYellow;
          3: DrawGrid1.Canvas.Brush.Color := clLtGray;
          ELSE
            DrawGrid1.Canvas.Brush.Color := clDkGray;
        END;
    END
  ELSE
    DrawGrid1.Canvas.Brush.Color := clwhite;
  DrawGrid1.Canvas.FillRect(rect);
  DrawGrid1.Canvas.pen.color := clblack;
  IF acol MOD 3 = 0 THEN
    BEGIN
      DrawGrid1.Canvas.moveto(rect.left, rect.top);
      DrawGrid1.Canvas.LineTo(rect.left, rect.bottom);
    END;
  IF arow MOD 3 = 0 THEN
    BEGIN
      DrawGrid1.Canvas.moveto(rect.left, rect.top);
      DrawGrid1.Canvas.LineTo(rect.Right, rect.top);
    END;
  IF cells[acol, arow].data > 0 THEN
    DrawGrid1.Canvas.TextOut(rect.Left DIV 2 + rect.right DIV 2 - tw DIV 2,
      rect.Top + 3, inttostr(cells[acol, arow].data))
END;

FUNCTION TForm1.GetPosibility(ACol: Integer; ARow: Integer; Verify: Shortint =
  1; CL: byte = 0): TPossibility;
VAR
  i, j, oc, sc, sr: Integer;
  sp, sp1, sp2: TPossibility;
  pp: ARRAY[0..8, 0..8] OF TPossibility;
BEGIN
  IF (cells[Acol, Arow].plevel >= verify) AND (cl = 0) AND (verify >= 0) THEN
    BEGIN
      result := cells[Acol, Arow].cpossib;
      exit;
    END;
  result := [1..9];
  FOR i := 0 TO 8 DO
    BEGIN
      IF (i <> arow) AND (cells[Acol, i].data > 0) THEN
        result := result - [cells[Acol, i].data];
      IF (i <> acol) AND (cells[i, ARow].data > 0) THEN
        result := result - [cells[i, ARow].data];
      IF (((i MOD 3) <> (acol MOD 3)) OR ((arow MOD 3) <> (i DIV 3))) AND
        (cells[(acol DIV 3) * 3 + (i MOD 3), (arow DIV 3) * 3 + (i DIV 3)].data
        > 0) THEN
        result := result - [cells[(acol DIV 3) * 3 + (i MOD 3), (arow DIV 3) * 3
          + (i DIV 3)].data];
    END;
  IF (verify > 0) AND (result <> []) THEN
    BEGIN
      oc := cells[Acol, Arow].data;
      cells[Acol, Arow].data := 0;
      SP := [];
      SP1 := [];
      SP2 := [];
      fillchar(pp, sizeof(pp), 0);
      FOR i := 0 TO 8 DO
        BEGIN
          IF (cells[i, arow].data = 0) THEN
            BEGIN
              IF pp[i, arow] = [] THEN
                pp[i, arow] := getposibility(i, arow, verify - 2, oc + cl);
              IF (setcount(pp[i, arow]) = 1) AND (acol <> i) THEN
                result := result - pp[i, arow];
            END
          ELSE
            pp[i, arow] := [cells[i, arow].data];
          IF (acol <> i) THEN
            sp1 := sp1 + pp[i, arow];

          IF (cells[acol, i].data = 0) THEN
            BEGIN
              IF pp[acol, i] = [] THEN
                pp[acol, i] := getposibility(acol, i, verify - 2, oc + cl);
              IF (setcount(pp[acol, i]) = 1) AND (arow <> i) THEN
                result := result - pp[acol, i];
            END
          ELSE
            pp[acol, i] := [cells[acol, i].data];
          IF (arow <> i) THEN
            sp2 := sp2 + pp[acol, i];

          sc := (acol DIV 3) * 3 + (i MOD 3);
          sr := (arow DIV 3) * 3 + (i DIV 3);
          IF (cells[sc, sr].data = 0) THEN
            BEGIN
              IF pp[sc, sr] = [] THEN
                pp[sc, sr] := getposibility(sc, sr, verify - 2, oc + cl);
              IF (setcount(pp[sc, sr]) = 1) AND ((sc <> acol) OR (sr <> arow))
                THEN
                result := result - pp[sc, sr];
            END
          ELSE
            pp[sc, sr] := [cells[sc, sr].data];
          IF (sc <> acol) OR (sr <> arow) THEN
            sp := sp + pp[sc, sr];
        END;
      // Ausschliessungsverfahren
      FOR J IN result DO
        BEGIN
          IF NOT (j IN sp) THEN
            BEGIN
              result := [j];
              break;
            END;
          IF NOT (j IN sp1) THEN
            BEGIN
              result := [j];
              break;
            END;
          IF NOT (j IN sp2) THEN
            BEGIN
              result := [j];
              break;
            END
        END;
      cells[Acol, Arow].data := oc;
    END;
  IF (verify > 0) AND (setcount(result) < spinedit2.Value + verify) AND (result
    <> []) THEN
    BEGIN
      oc := cells[Acol, Arow].data;
      FOR j IN result - [oc] DO
        BEGIN
          cells[Acol, Arow].data := j;
          FOR i := 0 TO 8 DO
            BEGIN
              IF (i <> arow) AND (cells[Acol, i].data = 0) AND
                (getposibility(acol,
                i, verify - 1, cl + 1) = []) THEN
                BEGIN
                  result := result - [j];
                  break
                END;
              IF (i <> acol) AND (cells[i, ARow].data = 0) AND (getposibility(i,
                Arow, verify - 1, cl + 1) = []) THEN
                BEGIN
                  result := result - [j];
                  break
                END;
              IF (((i MOD 3) <> (acol MOD 3)) OR ((arow MOD 3) <> (i DIV 3)))
                AND
                (cells[(acol DIV 3) * 3 + (i MOD 3), (arow DIV 3) * 3 + (i DIV
                  3)].data = 0) AND
              (getposibility((acol DIV 3) * 3 + (i MOD 3), (arow DIV 3) * 3 + (i
                DIV 3), verify - 1, cl + 1) = []) THEN
                BEGIN
                  result := result - [j];
                  break
                END;
            END;
        END;
      cells[Acol, Arow].data := oc;
    END;
  IF (cells[Acol, Arow].plevel < verify) AND (cl = 0) THEN
    BEGIN
      cells[Acol, Arow].cpossib := result;
      cells[Acol, Arow].plevel := verify;
    END
END;

PROCEDURE TForm1.FormResize(Sender: TObject);

VAR
  th: integer;

BEGIN
  DrawGrid1.DefaultColWidth := ((DrawGrid1.Width - 1) DIV DrawGrid1.ColCount) -
    2;
  DrawGrid1.DefaultRowHeight := ((DrawGrid1.Height - 1) DIV DrawGrid1.RowCount)
    - 2;
  th := DrawGrid1.canvas.TextHeight('0');
  DrawGrid1.Font.Size := trunc(DrawGrid1.canvas.font.Size / th *
    (DrawGrid1.DefaultRowHeight - 3));
  tW := DrawGrid1.Canvas.TextWidth('0');
END;

PROCEDURE TForm1.DrawGrid1KeyPress(Sender: TObject; VAR Key: Char);
BEGIN
  //  DrawGrid1.Selection
END;

PROCEDURE TForm1.DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  VAR CanSelect: Boolean);

VAR
  possib: TPossibility;
  i: integer;
BEGIN
  possib := GetPosibility(ACol, ARow, SpinEdit3.value, 1);
  statictext1.caption := '';
  FOR i IN possib DO
    statictext1.caption := statictext1.caption + ', ' + inttostr(i);
  statictext1.caption := copy(statictext1.caption, 2, 30);
END;

PROCEDURE TForm1.DrawGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
  VAR Value: STRING);
BEGIN
  IF cells[acol, arow].data > 0 THEN
    value := inttostr(cells[acol, arow].data)
  ELSE
    value := '';
END;

PROCEDURE TForm1.DrawGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
  CONST Value: STRING);
BEGIN
  TRY
    IF length(value) > 0 THEN
      IF (value[1] >= '0') AND (value[1] <= '9') THEN
        cells[acol, arow].data := strtoint(value[1])
      ELSE
        cells[acol, arow].data := 0
    ELSE
      cells[acol, arow].data := 0;
    FullReDrawGrid;
  EXCEPT
    cells[acol, arow].data := 0
  END;

END;

FUNCTION TForm1.setcount(s: Tpossibility): integer;
VAR
  i: integer;
BEGIN
  result := 0;
  FOR i IN s DO
    inc(result);
END;

FUNCTION TForm1.firstinset(s: Tpossibility): integer;
VAR
  i: integer;
BEGIN
  result := 0;
  FOR i IN s DO
    BEGIN
      result := i;
      break
    END;
END;

PROCEDURE TForm1.FullReDrawGrid;
VAR
  i: Integer;
  fullcount: Byte;
BEGIN
  fullcount := 0;
  FOR i := 80 DOWNTO 0 DO
    WITH cells[i MOD 9, i DIV 9] DO
      BEGIN
        PLevel := -1;
        IF data > 0 THEN
          inc(fullcount);
      END;
  StaticText2.caption := inttostr(fullcount);
  DrawGrid1.Invalidate;
END;


PROCEDURE TForm1.BitBtn1Click(Sender: TObject);

BEGIN
  fillchar(cells, sizeof(cells), 0);
  FullReDrawGrid;
END;

PROCEDURE TForm1.FileOpen1Accept(Sender: TObject);
VAR
  f: FILE;
  cc: ARRAY[0..80] OF byte;
  i: Integer;
BEGIN
  assignfile(f, FileOpen1.Dialog.FileName);
  reset(f, 1);
  blockread(f, cc, sizeof(cc));
  CloseFile(f);
  FOR i := 0 TO 80 DO
    cells[i DIV 9, i MOD 9].data := cc[i];
  FullReDrawGrid;
END;

PROCEDURE TForm1.FileSaveAs1Accept(Sender: TObject);
VAR
  f: FILE;
  i: Integer;
  cc: ARRAY[0..80] OF Byte;
BEGIN
  IF (ExtractFileExt(FileSaveAs1.Dialog.FileName) = '') AND
    (FileSaveAs1.Dialog.Filterindex <> 2) THEN
    FileSaveAs1.Dialog.FileName := FileSaveAs1.Dialog.FileName +
      ExtractFileExt(FileSaveAs1.Dialog.Filter);
  assignfile(f, FileSaveAs1.Dialog.FileName);
  FOR i := 0 TO 80 DO
    cc[i] := cells[i DIV 9, i MOD 9].data;
  Rewrite(f, 1);
  blockwrite(f, cc, sizeof(cc));
  CloseFile(f);
END;

PROCEDURE TForm1.CheckBox1Click(Sender: TObject);
VAR
  i: Integer;
BEGIN
  FOR i := 0 TO 80 DO
    cells[i MOD 9, i DIV 9].PLevel := -1;
  DrawGrid1.Invalidate;
END;

PROCEDURE TForm1.SpinEdit1Change(Sender: TObject);
BEGIN
  IF SpinEdit1.Text <> '' THEN
    DrawGrid1.Invalidate;
END;

PROCEDURE TForm1.BitBtn4Click(Sender: TObject);
BEGIN
  EliminateFullySpecCells;
END;

PROCEDURE TForm1.CheckBox2Click(Sender: TObject);
BEGIN
  DrawGrid1.Invalidate;
END;

PROCEDURE TForm1.SpeedButton4Click(Sender: TObject);
BEGIN
  PageSetupDialog1.execute;
END;

PROCEDURE TForm1.PageSetupDialog1DrawGreekText(Sender: TObject; Canvas: TCanvas;
  PageRect: TRect; VAR DoneDrawing: Boolean);
VAR
  i, th, tw: Integer;
  DefaultColWidth: Integer;
  DefaultRowHeight: integer;
  activerect, rect: Trect;
BEGIN
  if (PageSetupDialog1.PageHeight = 0) then
     PageSetupDialog1.PageHeight := 29700;
  if (PageSetupDialog1.PageWidth = 0)  then
        PageSetupDialog1.PageWidth := 21000;
  // Rahmen
  activerect.Top := PageRect.Top + PageSetupDialog1.MarginTop  * (PageRect.bottom
    - PageRect.top) DIV PageSetupDialog1.PageHeight;
  activerect.bottom := PageRect.bottom - PageSetupDialog1.MarginBottom *
    (PageRect.bottom - PageRect.top) DIV PageSetupDialog1.PageHeight;
  activerect.left := PageRect.left + PageSetupDialog1.MarginLeft *
    (PageRect.right - PageRect.left) DIV PageSetupDialog1.PageWidth;
  activerect.right := PageRect.right - PageSetupDialog1.MarginRight *
    (PageRect.right - PageRect.left) DIV PageSetupDialog1.PageWidth;
  th := (activerect.bottom - activerect.top) DIV 2;
  tw := (activerect.right - activerect.left) DIV 2;
  IF th > tw THEN
    BEGIN
      activerect.Bottom := activerect.top + th + tw;
      activerect.top := activerect.top + th - tw;
    END
  ELSE
    BEGIN
      activerect.right := activerect.left + tw + th;
      activerect.left := activerect.left + tw - th;
    END;
  canvas.Pen.Style := psSolid;
  DefaultColWidth := ((activerect.right - activerect.left - 1) DIV 9) - 1;
  DefaultRowHeight := ((activerect.bottom - activerect.Top - 1) DIV 9) - 1;
  th := canvas.TextHeight('0');
  canvas.Font.Size := trunc(canvas.font.Size / th * (DefaultRowHeight - 1));
  IF canvas.Font.size < 6 THEN
    BEGIN
      Canvas.Font.Name := 'Small Fonts';
      IF Canvas.Font.size < 2 THEN
        Canvas.Font.size := 2;
    END
  ELSE
    Canvas.Font.Name := 'Tahoma';
  tW := Canvas.TextWidth('0');

  FOR i := 0 TO 80 DO
    BEGIN
      rect.Top := ((i DIV 9) * (DefaultRowHeight + 1)) + activerect.Top;
      rect.left := ((i MOD 9) * (DefaultColWidth + 1)) + activerect.left;
      rect.Right := rect.Left + DefaultColWidth;
      rect.bottom := rect.top + DefaultRowHeight;
      Canvas.FillRect(rect);
      Canvas.pen.color := clblack;
      Canvas.moveto(rect.right, rect.top);
      Canvas.LineTo(rect.right, rect.bottom);
      Canvas.LineTo(rect.left, rect.bottom);
      IF i MOD 3 = 0 THEN
        BEGIN
          Canvas.moveto(rect.left, rect.top);
          Canvas.LineTo(rect.left, rect.bottom);
        END;
      IF (i DIV 9) MOD 3 = 0 THEN
        BEGIN
          Canvas.moveto(rect.left, rect.top);
          Canvas.LineTo(rect.Right, rect.top);
        END;
      IF cells[i MOD 9, i DIV 9].data > 0 THEN
        Canvas.TextOut(rect.Left DIV 2 + rect.right DIV 2 - tw DIV 2,
          rect.Top + 3, inttostr(cells[i MOD 9, i DIV 9].data))

    END;
  DoneDrawing := true;
END;

PROCEDURE TForm1.PageSetupDialog1DrawMargin(Sender: TObject; Canvas: TCanvas;
  PageRect: TRect; VAR DoneDrawing: Boolean);
VAR
  activerect: Trect;
BEGIN
  // Rahmen
  activerect.Top := PageRect.Top + PageSetupDialog1.MarginTop * (PageRect.bottom
    - PageRect.top) DIV PageSetupDialog1.PageHeight;
  activerect.bottom := PageRect.bottom - PageSetupDialog1.MarginBottom*
    (PageRect.bottom - PageRect.top) DIV PageSetupDialog1.PageHeight;
  activerect.left := PageRect.left + PageSetupDialog1.MarginLeft *
    (PageRect.right - PageRect.left) DIV PageSetupDialog1.PageWidth;
  activerect.right := PageRect.right - PageSetupDialog1.MarginRight *
    (PageRect.right - PageRect.left) DIV PageSetupDialog1.PageWidth;
  canvas.Pen.Style := psInsideFrame;
  canvas.DrawFocusRect(activerect);
  DoneDrawing := true;
END;

PROCEDURE TForm1.SpeedButton5Click(Sender: TObject);
VAR
  bb: boolean;
BEGIN
  IF PrintDialog1.Execute THEN
    WITH Printer DO
      BEGIN
        BeginDoc;
        PageSetupDialog1DrawGreekText(self, Canvas, Canvas.ClipRect, bb);
        EndDoc;
      END;
END;



procedure TForm1.EliminateFullySpecCells;
var
  j: Integer;
  zi: Byte;
  i: Integer;
begin
  for j := 0 to 80 do
    index[j] := J;
  for j := 0 to 161 do
  begin
    i := random(81);
    zi := index[j mod 81];
    index[j mod 81] := index[i];
    index[i] := zi;
    if cells[i mod 9, i div 9].data > 0 then
      if GetPosibility(i mod 9, i div 9, SpinEdit1.Value) = [cells[i mod 9, i div 9].data] then
      begin
        cells[i mod 9, i div 9].data := 0;
        FullReDrawGrid;
      end;
    ProgressBar1.Position := trunc(j / 161 * ProgressBar1.Max);
    Application.ProcessMessages;
  end;
  for J := 80 downto 0 do
  begin
    i := index[j];
    if cells[i mod 9, i div 9].data > 0 then
      if GetPosibility(i mod 9, i div 9, SpinEdit3.Value) = [cells[i mod 9, i div 9].data] then
      begin
        cells[i mod 9, i div 9].data := 0;
        FullReDrawGrid;
      end;
    ProgressBar1.Position := trunc(j / 80 * ProgressBar1.Max);
    Application.ProcessMessages;
  end;
  DrawGrid1.Invalidate;
end;

END.

