Unit Frm_LogicMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
{$IFnDEF FPC}
  XPMan, XPStyleActnCtrls, Windows, ActnMan, StdCtrls, ImgList,
{$ELSE}
  LCLIntf, LCLType, Printer4Lazarus, PrintersDlgs,
{$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Grids, ComCtrls, Menus, StdActns,
  ActnList,  frm_Aboutbox, math;

Type
  TCellData = Shortint;
  THistoryData = Record
    X, Y: byte;
    OldData, NewData: Shortint;
  End;

  { TForm2 }

  TForm2 = Class(TForm)
    AboutBox1: TAboutBox;
    DrawGrid1: TDrawGrid;
    PageSetupDialog1: TPageSetupDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    {$IFDEF FPC}
    ActionManager1: TActionList;
    {$ELSE}
    ActionManager1: TActionManager;
    {$ENDIF}
    ActSetUp: TAction;
    FileOpen1: TFileOpen;
    FileSaveAs1: TFileSaveAs;
    FileExit1: TFileExit;
    PrintDialog1: TPrintDialog;
    {$IFDEF FPC}
    PrintDlg1: TAction;
    FilePageSetup1: TAction;
    FilePrintSetup1: TAction;
    {$ELSE}
    PrintDlg1: TPrintDlg;
    FilePageSetup1: TFilePageSetup;
    FilePrintSetup1: TFilePrintSetup;
    XPManifest1: TXPManifest;
    {$ENDIF}
    MainMenu1: TMainMenu;
    PrinterSetupDialog1: TPrinterSetupDialog;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    Datei1: TMenuItem;
    ffnen1: TMenuItem;
    Speichernunter1: TMenuItem;
    N1: TMenuItem;
    Seiteeinrichten1: TMenuItem;
    Druckereinstellungen1: TMenuItem;
    Drucken1: TMenuItem;
    N2: TMenuItem;
    Beenden1: TMenuItem;
    Extras1: TMenuItem;
    Hilfe1: TMenuItem;
    HelpOnHelp1: THelpOnHelp;
    HelpAbout: TAction;
    VerwendungderHilfe1: TMenuItem;
    ber1: TMenuItem;
    ExtraConfig: TMenuItem;
    ImageList1: TImageList;
    OpenDialog: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ToolButton4: TToolButton;
    BitBtn2: TBitBtn;
    FileNew1: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    FileSave1: TAction;
    Speichern1: TMenuItem;
    ActEditClear: TAction;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ActClearCalkulated: TAction;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ActExecute: TAction;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    procedure FilePageSetup1Execute(Sender: TObject);
    procedure FilePrintSetup1Execute(Sender: TObject);
    procedure HelpAboutExecute(Sender: TObject);
    Procedure PrintDlg1Accept(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure DrawGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      Const Value: String);
    Procedure DrawGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
      Var Value: String);
    Procedure FileSave1Execute(Sender: TObject);
    Procedure FileSave1Update(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure FilePageSetup1PageSetupDialogDrawGreekText(Sender: TObject;
      Canvas: TCanvas; PageRect: TRect; Var DoneDrawing: Boolean);
    Procedure FilePageSetup1PageSetupDialogDrawMargin(Sender: TObject;
      Canvas: TCanvas; PageRect: TRect; Var DoneDrawing: Boolean);
    Procedure FileNew1Execute(Sender: TObject);
    Procedure FileSaveAs1BeforeExecute(Sender: TObject);
    Procedure FileOpen1Accept(Sender: TObject);
    Procedure FileSaveAs1Accept(Sender: TObject);
    Procedure DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      Var CanSelect: Boolean);
    Procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    Procedure BitBtn1Click(Sender: TObject);
    Procedure ClearAll(Sender: TObject);
    Procedure ClearCalculated(Sender: TObject);
    procedure PrintDlg1Execute(Sender: TObject);
  private
    Maxkat: Integer;
    elem: Integer;
    cells: Array Of TCellData;
    History: Array[0..100] Of THistoryData;
    HistoryBase, HistoryPtr: Byte;
    FFilename: String;
    FChanged: Boolean;
    Procedure SetCell(col, row: integer; Newval: Tcelldata);
    Function GetCell(col, row: integer): Tcelldata;
    Procedure SetFilename(NewName: String);
    { Private-Deklarationen }
    Procedure UpdateCfg(Sender: TObject);
    Procedure UQSaveChanges;
  public
    { Public-Deklarationen }
    Property Cell[col, row: integer]: TcellData read getCell write setcell;
  protected
    Property Filename: String read FFilename write SetFilename;
  End;

Var
  Form2: TForm2;

Implementation

Uses frm_logicConf, printers;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

Resourcestring
  ShowChars = '|-- XX?';

Procedure TForm2.BitBtn1Click(Sender: TObject);
Begin
  FrmLogicConf.OnSuccess := UpdateCfg;
  FrmLogicconf.show;
End;

Procedure TForm2.Button1Click(Sender: TObject);
Var rrow, rcol: integer;
  actdata: TCellData;
  I: Integer;
  flag: Boolean;
  nflag: Boolean;
  sflag: Boolean;
Begin
  flag := false;
  For rcol := 1 To elem * maxkat - 1 Do
    For rrow := 0 To rcol - 1 Do
      Begin
        actdata := cell[rcol, rrow];
        If actdata > 0 Then
          Begin
            For I := 0 To elem * maxkat - 1 Do
              If sign(cell[i, rrow]) <> sign(cell[i, rcol]) Then
                Begin
                  If cell[i, rrow] = 0 Then
                    cell[i, rrow] := sign(cell[i, rcol]);
                  If cell[i, rcol] = 0 Then
                    cell[i, rcol] := sign(cell[i, rrow]);
                  flag := true;
                End
          End
        Else If actdata < 0 Then
          Begin

          End
        Else If actdata = 0 Then
          Begin
            nflag := true;
            sflag := false;
            For I := 0 To elem * maxkat - 1 Do
              Begin
                nflag := nflag And (sign(cell[i, rrow]) + sign(cell[i, rcol]) <
                  0);
                sflag := sflag Or (sign(cell[i, rrow]) * sign(cell[i, rcol]) <
                  0);
                If (i Mod elem) = (elem - 1) Then
                  Begin
                    sflag := sflag Or Nflag;
                    nflag := true;

                  End;
              End;
            If sflag Then
              Begin
                cell[rcol, rrow] := -1;
                flag := true;
              End;
            nflag := true;
            sflag := true;
            For I := 0 To elem - 1 Do
              Begin
                nflag := nflag And ((((rrow Div elem) * elem + i) = rrow) Xor
                  (cell[((rrow Div elem) * elem + i), rcol] < 0));
                sflag := sflag And ((((rcol Div elem) * elem + i) = rcol) Xor
                  (cell[rrow, ((rcol Div elem) * elem + i)] < 0));
              End;
            If nflag Or sflag Then
              Begin
                cell[rcol, rrow] := 1;
                flag := true;
              End;
          End;

      End;
  If flag Then
    Begin
      fchanged := true;
      DrawGrid1.Invalidate;
    End;
End;

Procedure TForm2.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
Var
  Maxkat: integer;
  elem: Integer;
  ttext: String;

Begin
// Titel 1
  Maxkat := frmlogicConf.StringGrid1.ColCount;
  elem := frmlogicConf.StringGrid1.RowCount - 1;
  If (ACol = 0) And (arow = 0) Then
    Begin
      DrawGrid1.Canvas.brush.color := clWhite;
      DrawGrid1.Canvas.FillRect(rect);
    End;
  If (ARow = 0) And (Acol > 0) Then
    Begin
      ttext := frmlogicConf.StringGrid1.cells[Maxkat - ((acol - 1) Div elem) -
        1, ((acol - 1) Mod elem) + 1];
 //     RotatedText(10,rect.Left,rect.bottom,ttext,DrawGrid1.Canvas)
      DrawGrid1.Canvas.Font.Orientation := 900;
      DrawGrid1.Canvas.TextRect(rect, rect.Left, rect.Bottom - 2, ttext);
      DrawGrid1.Canvas.Font.Orientation := 00;
    End;
  If (ACol = 0) And (arow > 0) Then
    Begin
      ttext := frmlogicConf.StringGrid1.cells[((arow - 1) Div elem), ((aRow - 1)
        Mod elem) + 1];
      DrawGrid1.Canvas.TextRect(rect, rect.Left + 2, rect.top, ttext);
    End;

  If (ACol > 0) And (arow > 0) And (((arow - 1) Div elem) + ((acol - 1) Div elem)
    < maxkat - 1) Then
    Begin
      DrawGrid1.Canvas.Brush.Color := clwhite;
      If (arow = DrawGrid1.Row) And (acol <> DrawGrid1.col) Then
        DrawGrid1.Canvas.Brush.Color := clYellow;
      If ((acol - 1) Mod elem) + (maxkat - 1 - ((acol - 1) Div elem)) * elem =
        DrawGrid1.Row - 1 Then
        DrawGrid1.Canvas.Brush.Color := clYellow;
      If (arow <> DrawGrid1.Row) And (acol = DrawGrid1.col) Then
        DrawGrid1.Canvas.Brush.Color := cllime;
      If ((aRow - 1) Mod elem) + (maxkat - 1 - ((arow - 1) Div elem)) * elem =
        DrawGrid1.col - 1 Then
        DrawGrid1.Canvas.Brush.Color := clLime;
      DrawGrid1.Canvas.FillRect(rect);
      If abs(cells[acol - 1 + (arow - 1) * (drawgrid1.ColCount - 1)]) = 2 Then
        DrawGrid1.Canvas.font.Style := [fsbold]
      Else
        DrawGrid1.Canvas.font.Style := [];
      ttext := copy(showchars, cells[acol - 1 + (arow - 1) * (drawgrid1.ColCount
        - 1)] + 1 + (length(showchars) Div 2), 1);
      DrawGrid1.Canvas.TextRect(rect, rect.Left + 2, rect.top, ttext);
      DrawGrid1.Canvas.Pen.color := clblack;
//      DrawGrid1.Canvas.DrawFocusRect(rect);
      DrawGrid1.Canvas.MoveTo(rect.Right, rect.top);
      If acol Mod elem = 0 Then
        DrawGrid1.Canvas.Pen.Width := 2
      Else
        DrawGrid1.Canvas.Pen.Width := 1;
      DrawGrid1.Canvas.LineTo(rect.right, rect.Bottom);
      If aRow Mod elem = 0 Then
        DrawGrid1.Canvas.Pen.Width := 2
      Else
        DrawGrid1.Canvas.Pen.Width := 1;
      DrawGrid1.Canvas.LineTo(rect.left, rect.bottom);
    End;
End;

Procedure TForm2.DrawGrid1GetEditText(Sender: TObject; ACol, ARow: Integer;
  Var Value: String);

Begin
  value := copy(showchars, cells[acol - 1 + (arow - 1) * (drawgrid1.ColCount -
    1)] + 1 + (length(showchars) Div 2), 1);
End;

Procedure TForm2.DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  Var CanSelect: Boolean);
Var
  Maxkat: Integer;
  elem: Integer;
Begin
  if assigned(frmlogicConf) then
    begin
    Maxkat := frmlogicConf.StringGrid1.ColCount;
    elem := frmlogicConf.StringGrid1.RowCount - 1;
    CanSelect := (((arow - 1) Div elem) + ((acol - 1) Div elem) < maxkat - 1);
    end
  else
  begin
  Maxkat := 0;
  elem := 0;
  CanSelect := false;
  end;
  If canselect Then
    Begin
      drawgrid1.invalidate;
    End;
End;

Procedure TForm2.DrawGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
  Const Value: String);
Var
  oldval: TCellData;
  K, i, kk: Integer;
  Maxkat: Integer;
  elem: Integer;
Begin
  Maxkat := frmlogicConf.StringGrid1.ColCount - 1;
  elem := frmlogicConf.StringGrid1.RowCount - 1;
  i := acol - 1 + (arow - 1) * (drawgrid1.ColCount - 1);
  oldval := cells[i];
  If pos(copy(Value, 1, 1), '?') > 0 Then
    cells[i] := 3;
  If pos(copy(Value, 1, 1), '+xX') > 0 Then
    cells[i] := 2;
  If pos(copy(Value, 1, 1), '-') > 0 Then
    cells[i] := -2;
  If pos(copy(Value, 1, 1), '!|') > 0 Then
    cells[i] := -3;
  If pos(copy(Value, 1, 1), ' ') > 0 Then
    cells[i] := 0;
  If oldval <> cells[i] Then
    Begin
      fchanged := true;
      If cells[acol - 1 + (arow - 1) * (drawgrid1.ColCount - 1)] = 2 Then
        Begin
          For K := 0 To elem - 1 Do
            Begin
              If (i Div elem) * elem + k <> i Then
                If cells[(i Div elem) * elem + k] = 0 Then
                  cells[(i Div elem) * elem + k] := -1;
              kk := (i Div (elem * elem * maxkat)) * maxkat * elem * elem + (i
                Mod (elem * maxkat)) + k * elem * maxkat;
              If kk <> i Then
                If cells[kk] = 0 Then
                  cells[kk] := -1;
            End;
        End;
      drawgrid1.invalidate;
    End;
End;

Procedure TForm2.FileNew1Execute(Sender: TObject);
Begin
  UQSaveChanges;
  Filename := 'Logic1';
  FrmLogicConf.Clear;
  HistoryBase := 0;
  HistoryPtr := 0;
  UpdateCfg(sender);
  Fchanged := False;
End;

Procedure TForm2.FileOpen1Accept(Sender: TObject);
Var Strings: TStrings;
  I: Integer;
  J: Integer;
  K, kk, elem: Integer;
  maxkat: Integer;
Begin
  strings := TStringList.Create;
  Filename := FileOpen1.Dialog.FileName;
  strings.LoadFromFile(FileOpen1.Dialog.FileName);
  // Anzahl der Kategorien
  FrmLogicConf.SpinEdit1.Text := strings.Values['KatCount'];
  maxkat := FrmLogicConf.SpinEdit1.value - 1;
  // Anzahl der Elemente
  FrmLogicConf.SpinEdit2.Text := strings.Values['ElemCount'];
  elem := FrmLogicConf.SpinEdit2.value;
  // Namen der Kategorien
  For I := 0 To FrmLogicConf.SpinEdit1.value - 1 Do
    Begin
      FrmLogicConf.StringGrid1.Cells[i,
        0] := strings.Values['Kat' + inttostr(i)];
  // Namen der Elemente
      For J := 0 To FrmLogicConf.SpinEdit2.value - 1 Do
        FrmLogicConf.StringGrid1.Cells[i, j + 1] :=
          strings.Values['Elem' + inttostr(i) + '.' + inttostr(j)];
    End;
  UpdateCfg(sender);
  // Eingefügte positive Informationen
  For I := 0 To high(cells) Do
    If trystrtoint(Strings.Values[inttostr(i)], j) Then
      Begin
        cells[i] := j;
        If J = 2 Then
          Begin
            For K := 0 To elem - 1 Do
              Begin
                If (i Div elem) * elem + k <> i Then
                  If cells[(i Div elem) * elem + k] = 0 Then
                    cells[(i Div elem) * elem + k] := -1;
                kk := (i Div (elem * elem * maxkat)) * maxkat * elem * elem + (i
                  Mod (elem * maxkat)) + k * elem * maxkat;
                If kk <> i Then
                  If cells[kk] = 0 Then

                    cells[kk] := -1;
              End;

          End;
      End;
  // Eingefügte Negaive Informationen
  FChanged := False;
End;

Procedure TForm2.FilePageSetup1PageSetupDialogDrawGreekText(Sender: TObject;
  Canvas: TCanvas; PageRect: TRect; Var DoneDrawing: Boolean);
Var
  i, th, tw: Integer;
  HorizDPP, VertDPP: extended;
  activerect, rect: Trect;
  ROffset: Integer;
  COffset: integer;
  ttext: String;
Begin
  // Rahmen
  {$IFDEF FPC}
 with PageSetupDialog1 do
 {$ELSE}
 with filePageSetup1.Dialog do
 {$ENDIF}
    begin
  activerect.Top := PageRect.Top + {$IFNDEF FPC}Margin{$ELSE}Margins.{$ENDIF}Top *
    (PageRect.bottom
    - PageRect.top) Div {$IFNDEF FPC}Page{$ENDIF}Height;
  activerect.bottom := PageRect.bottom - {$IFNDEF FPC}Margin{$ELSE}Margins.{$ENDIF}bottom *
    (PageRect.bottom - PageRect.top) Div {$IFNDEF FPC}Page{$ENDIF}Height;
  activerect.left := PageRect.left + {$IFNDEF FPC}Margin{$ELSE}Margins.{$ENDIF}left *
    (PageRect.right - PageRect.left) Div {$IFNDEF FPC}Page{$ENDIF}Width;
  activerect.right := PageRect.right - {$IFNDEF FPC}Margin{$ELSE}Margins.{$ENDIF}right *
    (PageRect.right - PageRect.left) Div {$IFNDEF FPC}Page{$ENDIF}Width;
    end;
  th := (activerect.bottom - activerect.top) Div 2;
  tw := (activerect.right - activerect.left) Div 2;
  If th > tw Then
    Begin
      activerect.Bottom := activerect.top + th + tw;
      activerect.top := activerect.top + th - tw;
    End
  Else
    Begin
      activerect.right := activerect.left + tw + th;
      activerect.left := activerect.left + tw - th;
    End;
  canvas.Pen.Style := psSolid;

  HorizDPP := ((activerect.right - activerect.left - 1) /
    (drawgrid1.ColWidths[0] + (DrawGrid1.ColCount - 1) *
    drawgrid1.ColWidths[1]));
  VertDPP := ((activerect.bottom - activerect.Top - 1) /
    (drawgrid1.RowHeights[0] + (DrawGrid1.rowCount - 1) *
    drawgrid1.RowHeights[1]));
  canvas.Font.Size := 20;
  Canvas.Font.Name := 'Tahoma';
  Canvas.Font.Color := clblack;
  th := canvas.TextHeight('0');

  canvas.Font.Size := trunc(canvas.font.Size / th * (VertDPP *
    (drawgrid1.RowHeights[1] - 3)));
  If canvas.Font.size < 6 Then
    Begin
      Canvas.Font.Name := 'Small Fonts';
      If Canvas.Font.size < 2 Then
        Canvas.Font.size := 2;
    End
  Else
    Canvas.Font.Name := 'Tahoma';
  tW := Canvas.TextWidth('0');

  ROffset := trunc(VertDPP * drawgrid1.RowHeights[0]);
  COffset := trunc(HorizDPP * drawgrid1.ColWidths[0]);

  //col-Title
  Canvas.Font.Orientation := 900;
  For I := 0 To elem * (maxkat - 1) - 1 Do
    Begin
      rect.Top := activerect.Top;
      rect.left := COffset + activerect.left + trunc(i * VertDPP *
        drawgrid1.ColWidths[1]);
      rect.Right := rect.Left + trunc(HorizDPP * drawgrid1.ColWidths[1]);
      rect.bottom := rect.top + trunc(VertDPP * drawgrid1.RowHeights[0]);

      brush.Color := clblack;
      brush.Style := bsFDiagonal;
      ttext := frmlogicConf.StringGrid1.cells[Maxkat - (i Div elem) -
        1, (i Mod elem) + 1];
 //     RotatedText(10,rect.Left,rect.bottom,ttext,DrawGrid1.Canvas)
      Canvas.pen.color := clblack;
      canvas.Pen.Width := trunc(horizDPP * 0.5 + 1);
      canvas.Rectangle(rect);
      Canvas.Textout(rect.Left + canvas.Pen.Width * 2, rect.Bottom -
        canvas.Pen.Width * 2, ttext);
    End;

  //Row-Title
  Canvas.Font.Orientation := 0;
  For I := 0 To elem * (maxkat - 1) - 1 Do
    Begin
      rect.Top := ROffset + activerect.Top + trunc(i * VertDPP *
        drawgrid1.RowHeights[1]);
      rect.left := activerect.left;
      rect.Right := rect.Left + trunc(HorizDPP * drawgrid1.ColWidths[0]);
      rect.bottom := rect.top + trunc(VertDPP * drawgrid1.RowHeights[1]);

      brush.Color := clblack;
      brush.Style := bsBDiagonal;
      ttext := frmlogicConf.StringGrid1.cells[(i Div elem), (i Mod elem) + 1];
 //     RotatedText(10,rect.Left,rect.bottom,ttext,DrawGrid1.Canvas)
      Canvas.pen.color := clblack;
      canvas.Pen.Width := trunc(horizDPP * 0.5 + 1);
      canvas.Rectangle(rect);
      Canvas.Textout(rect.Left + canvas.Pen.Width * 2, rect.top +
        canvas.Pen.Width * 2, ttext);
    End;

  canvas.brush.Color := clWhite;
  canvas.font.Style := [fsBold];
  For i := 0 To high(cells) Do
    If ((i Mod (elem * (maxkat - 1))) Div elem) + ((i Div (elem * (maxkat - 1)))
      Div elem)
      < maxkat - 1 Then
      Begin
        rect.Top := roffset + trunc(((i Div (elem * (maxkat - 1))) * VertDPP *
          drawgrid1.RowHeights[1])) + activerect.Top;
        rect.left := coffset + trunc(((i Mod (elem * (maxkat - 1))) * HorizDPP *
          drawgrid1.ColWidths[1])) + activerect.left;
        rect.Right := rect.Left + trunc(HorizDPP * drawgrid1.ColWidths[1]);
        rect.bottom := rect.top + trunc(VertDPP * drawgrid1.RowHeights[1]);
//      Canvas.FillRect(rect);
        Canvas.pen.color := clblack;
        Canvas.moveto(rect.right, rect.top);
        If i Mod elem = (elem - 1) Then
          Canvas.pen.Width := trunc(horizDPP * 1 + 1)
        Else
          Canvas.pen.Width := trunc(horizDPP * 0.5 + 1);
        Canvas.LineTo(rect.right, rect.bottom);
        If (i Div (Elem * (maxkat - 1))) Mod elem = (elem - 1) Then
          Canvas.pen.Width := trunc(horizDPP + 1)
        Else
          Canvas.pen.Width := trunc(horizDPP * 0.5 + 1);
        Canvas.LineTo(rect.left, rect.bottom);
        If cells[i] > 0 Then
          Canvas.TextOut(rect.Left Div 2 + rect.right Div 2 - tw Div 2,
            rect.Top + 3, 'X');
        If cells[i] < 0 Then
          Canvas.TextOut(rect.Left Div 2 + rect.right Div 2 - tw Div 2,
            rect.Top + 3, '-')

      End;
  DoneDrawing := true;
End;

Procedure TForm2.FilePageSetup1PageSetupDialogDrawMargin(Sender: TObject;
  Canvas: TCanvas; PageRect: TRect; Var DoneDrawing: Boolean);
Var
  activerect: Trect;
Begin
  // Rahmen
  {$IFDEF FPC}
 with PageSetupDialog1 do
 {$ELSE}
 with filePageSetup1.Dialog do
 {$ENDIF}
    begin
  activerect.Top := PageRect.Top + {$IFNDEF FPC}Margin{$ELSE}Margins.{$ENDIF}Top *
    (PageRect.bottom
    - PageRect.top) Div {$IFNDEF FPC}Page{$ENDIF}Height;
  activerect.bottom := PageRect.bottom - {$IFNDEF FPC}Margin{$ELSE}Margins.{$ENDIF}bottom *
    (PageRect.bottom - PageRect.top) Div {$IFNDEF FPC}Page{$ENDIF}Height;
  activerect.left := PageRect.left + {$IFNDEF FPC}Margin{$ELSE}Margins.{$ENDIF}left *
    (PageRect.right - PageRect.left) Div {$IFNDEF FPC}Page{$ENDIF}Width;
  activerect.right := PageRect.right - {$IFNDEF FPC}Margin{$ELSE}Margins.{$ENDIF}right *
    (PageRect.right - PageRect.left) Div {$IFNDEF FPC}Page{$ENDIF}Width;
    end;
  canvas.Pen.Style := psInsideFrame;
  canvas.DrawFocusRect(activerect);
  DoneDrawing := true;
End;

Procedure TForm2.FileSave1Execute(Sender: TObject);
Begin
  If (Ffilename <> '') And (Ffilename <> 'Logic1') Then
    Begin
      FileSaveAs1.Dialog.FileName := FFilename;
      FileSaveAs1Accept(sender);
    End
  Else
    FileSaveAs1.execute;
End;

Procedure TForm2.FileSave1Update(Sender: TObject);
Begin
  FileSave1.Enabled := FChanged;
End;

Procedure TForm2.FileSaveAs1Accept(Sender: TObject);
Var Strings: TStrings;
  I: Integer;
  J: Integer;
Begin
  strings := TStringList.Create;
  // Anzahl der Kategorien
  strings.Values['KatCount'] := FrmLogicConf.SpinEdit1.Text;
  // Anzahl der Elemente
  strings.Values['ElemCount'] := FrmLogicConf.SpinEdit2.Text;
  // Namen der Kategorien
  For I := 0 To FrmLogicConf.SpinEdit1.value - 1 Do
    Begin
      strings.Values['Kat' + inttostr(i)] := FrmLogicConf.StringGrid1.Cells[i,
        0];
  // Namen der Elemente
      For J := 0 To FrmLogicConf.SpinEdit2.value - 1 Do
        strings.Values['Elem' + inttostr(i) + '.' + inttostr(j)] :=
          FrmLogicConf.StringGrid1.Cells[i, j + 1];
    End;
  // Eingefügte positive Informationen
  For I := 0 To high(cells) Do
    If abs(cells[i]) = 2 Then
      Strings.Values[inttostr(i)] := inttostr(cells[i]);
  // Eingefügte Negaive Informationen
  strings.SaveToFile(FileSaveAs1.Dialog.FileName);
  Filename := FileSaveAs1.Dialog.FileName;
  Fchanged := false;
End;

Procedure TForm2.FileSaveAs1BeforeExecute(Sender: TObject);
Begin
  FileSaveAs1.Dialog.FileName := FFilename;
End;

Procedure TForm2.FormShow(Sender: TObject);
Begin
  FileNew1.execute;
End;

Function TForm2.GetCell(col, row: integer): Tcelldata;
Var vCol: integer;
Begin
//
  If col < row Then
    Begin
      vcol := col;
      col := row;
      row := Vcol;
    End;
  vcol := col Mod elem + (maxkat - 1 - (col Div elem)) * elem;
  If (col Div elem) = (row Div elem) Then
    If col = row Then
      result := 1
    Else
      result := -1
  Else
    result := cells[row * elem * (maxkat - 1) + vcol];
End;

Procedure TForm2.PrintDlg1Accept(Sender: TObject);
Var bb: boolean;
Begin
  With Printer Do
    Begin
      BeginDoc;
      FilePageSetup1PageSetupDialogDrawGreekText(self, Canvas, Canvas.ClipRect,
        bb);
      EndDoc;
    End;

End;

procedure TForm2.HelpAboutExecute(Sender: TObject);
begin
  AboutBox1.Show;
end;

procedure TForm2.FilePrintSetup1Execute(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

procedure TForm2.FilePageSetup1Execute(Sender: TObject);
begin
 // PageSetupDialog1.OnShow:=FilePageSetup1PageSetupDialogDrawGreekText;
  PageSetupDialog1.Execute;
end;

Procedure TForm2.SetCell(col, row: integer; Newval: Tcelldata);
Var vCol: integer;
Begin
  If col < row Then
    Begin
      vcol := col;
      col := row;
      row := Vcol;
    End;
  vcol := col Mod elem + (maxkat - 1 - (col Div elem)) * elem;
  If (col Div elem) <> (row Div elem) Then
    cells[row * elem * (maxkat - 1) + vcol] := NewVal;
End;

Procedure TForm2.SetFilename(NewName: String);
Begin
  FFilename := NewName;
  Caption := 'Logic: ' + FFilename;
End;

Procedure TForm2.updateCfg(Sender: TObject);
Var
  I: Integer;
  j: Integer;
  maxtextl: integer;
Begin
  Maxkat := frmlogicConf.StringGrid1.ColCount;
  elem := frmlogicConf.StringGrid1.RowCount - 1;
  maxtextl := 15;
  For I := 0 To FrmLogicConf.SpinEdit2.Value *
    (FrmLogicConf.SpinEdit1.Value - 1) Do
    maxtextl := max(DrawGrid1.Canvas.TextWidth(FrmLogicConf.StringGrid1.Cells[i
      Div elem, (i Mod elem) + 1]), maxtextl);

  DrawGrid1.ColCount := FrmLogicConf.SpinEdit2.Value *
    (FrmLogicConf.SpinEdit1.Value - 1) + 1;
  DrawGrid1.RowCount := FrmLogicConf.SpinEdit2.Value *
    (FrmLogicConf.SpinEdit1.Value - 1) + 1;
  DrawGrid1.FixedCols := 1;
  DrawGrid1.FixedRows := 1;
  DrawGrid1.RowHeights[0] := maxtextl + 4;
  DrawGrid1.ColWidths[0] := maxtextl + 4;
  setlength(cells, (DrawGrid1.ColCount - 1) * (DrawGrid1.RowCount - 1));
  Fchanged := false;
  ClearAll(sender);
End;

Procedure TForm2.UQSaveChanges;
Begin
  If FChanged Then
    If MessageDlg('Wollen Sie die Änderungen speichern ?', mtConfirmation,
      mbYesNo, 0) = mrYes Then
      Begin
        FileSave1.execute;
        FChanged := false;
      End;
End;

Procedure TForm2.ClearAll(Sender: TObject);
Var
  I: Integer;
Begin
  UQSaveChanges;
  For i := 0 To high(cells) Do
    cells[i] := 0;
  FChanged := true;
  DrawGrid1.Invalidate;
End;

Procedure TForm2.ClearCalculated(Sender: TObject);
Var
  I: Integer;
Begin
  For i := 0 To high(cells) Do
    If abs(cells[i]) <> 2 Then
      cells[i] := 0;
  FChanged := true;
  DrawGrid1.Invalidate;
End;

procedure TForm2.PrintDlg1Execute(Sender: TObject);
begin
  if PrintDialog1.Execute then
    PrintDlg1Accept(Sender);
end;

End.

