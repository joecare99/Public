Unit Frm_VecFontEdit;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

Interface

Uses
  Classes, SysUtils,
{$IFDEF FPC}
  FileUtil,
{$ELSE}
  types,
{$ENDIF}
  Forms, Controls, Graphics, Dialogs, Menus,
  ActnList, ComCtrls, Grids, StdCtrls, StdActns, ExtCtrls, Buttons, Spin,
  frm_Aboutbox, Unt_Config, cls_VecFont, ImgList, ToolWin;

Type

  { TFrmVecFontEditMain }

  TFrmVecFontEditMain = Class(TForm)
   // AboutBox1: TAboutBox;
    actFileNew: TAction;
    actFileSave: TAction;
    actHelpAbout: TAction;
    ActionList1: TActionList;
    Config1: TConfig;
    DrawGrid1: TDrawGrid;
    Edit1: TEdit;
    FileExit1: TFileExit;
    FileOpen1: TFileOpen;
    FileSaveAs1: TFileSaveAs;
    Label1: TLabel;
    lbl_Middle: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LEd_TestText: TLabeledEdit;
    LEd_FontTitle: TLabeledEdit;
    lbl_Version: TLabel;
    MainMenu1: TMainMenu;
    mniFile: TMenuItem;
    mniHelpAbout: TMenuItem;
    mniHelp: TMenuItem;
    mniFileNew: TMenuItem;
    mniFileOpen: TMenuItem;
    mniFileSave: TMenuItem;
    mniFileSaveAs: TMenuItem;
    mniFileClose: TMenuItem;
    mniFileSep1: TMenuItem;
    mniFileExit: TMenuItem;
    OpenDialog1: TOpenDialog;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ImageList1: TImageList;
    AboutBox1: TAboutBox;
    Procedure actFileNewExecute(Sender: TObject);
    Procedure actFileSaveExecute(Sender: TObject);
    Procedure actFileSaveUpdate(Sender: TObject);
    Procedure actHelpAboutExecute(Sender: TObject);
    Procedure DrawGrid1Click(Sender: TObject);
    Procedure DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    Procedure Edit1Change(Sender: TObject);
    Procedure Edit1KeyPress(Sender: TObject; Var Key: char);
    Procedure FileOpen1Accept(Sender: TObject);
    Procedure FileSaveAs1Accept(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure lbl_VersionClick(Sender: TObject);
    procedure LEd_FontTitleChange(Sender: TObject);
    procedure LEd_FontTitleExit(Sender: TObject);
    Procedure PaintBox2MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    Procedure PaintBox2Paint(Sender: TObject);
    Procedure SpeedButton1Click(Sender: TObject);
  Private
    { private declarations }
    FVecFont: TVectorFont;
    FSelectedChar: Integer;
    FFilename: String;
    FtitleChanged: Boolean;
    FCharChanged: Boolean;
  Public
    { public declarations }
  End;

Var
  FrmVecFontEditMain: TFrmVecFontEditMain;

Implementation

Uses unt_CDate;
{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}
{$IFNDEF FPC}

Const
  LineEnding = #10#13;
{$ENDIF}

Resourcestring
  SCompiled = 'Compiled: %s' + LineEnding + #9'on: %s';

  { TFrmVecFontEditMain }

Procedure TFrmVecFontEditMain.DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
  Var
    tt: String;
  Begin
    If aCol = 0 Then
      Begin
        If aRow > 0 Then
          Begin
            // Left Title
            tt := IntToHex(aRow - 1, 2);
            DrawGrid1.Canvas.TextOut(aRect.left + 4, aRect.top, tt);
          End;
      End
    Else If aRow = 0 Then
      Begin
        // TopTitle
        tt := IntToHex(aCol - 1, 2);
        DrawGrid1.Canvas.TextOut(aRect.left + 4, aRect.top, tt);
      End
    Else If High(FVecFont.Character[aCol - 17 + aRow * 16]) < 0 Then
      Begin
        DrawGrid1.Canvas.brush.Color := clLtGray;
        DrawGrid1.Canvas.FillRect(aRect);
        DrawGrid1.Canvas.TextOut(aRect.left + 4, aRect.top,
          {$IFDEF FPC} AnsiToUtf8 {$ENDIF} (ansichar(aCol - 17 + aRow * 16)))
      End
    Else
      Begin
        DrawGrid1.Canvas.brush.Color := clWhite;
        DrawGrid1.Canvas.FillRect(aRect);
        DrawGrid1.Canvas.font.Color := clDkGray;
        DrawGrid1.Canvas.TextOut(aRect.left + 4, aRect.top,
          {$IFDEF FPC} AnsiToUtf8 {$ENDIF} (ansichar(aCol - 17 + aRow * 16)));
        DrawGrid1.Canvas.pen.Color := clblack;
        FVecFont.Write(DrawGrid1.Canvas, aRect.left + 16, aRect.top,
         ansichar(aCol - 17 + aRow * 16));
      End;
    If FSelectedChar = aCol - 17 + aRow * 16 Then
      DrawGrid1.Canvas.DrawFocusRect(aRect);

  End;

Procedure TFrmVecFontEditMain.Edit1Change(Sender: TObject);
  Begin
    PaintBox2.Invalidate;
    FCharChanged := true;
  End;

Procedure TFrmVecFontEditMain.Edit1KeyPress(Sender: TObject; Var Key: char);
  Var
    cc: TdAob;
    i: Integer;

  Begin
    If FCharChanged And (Key = #13) And (FSelectedChar > 0) Then
      Begin
        setlength(cc, 0);
        For i := 1 To length(Edit1.Text) Do
          If Ord(Edit1.Text[i]) In [48 .. 57] Then
            Begin
              setlength(cc, High(cc) + 2);
              cc[ High(cc)] := Ord(Edit1.Text[i]) Mod 48;
            End;
        FVecFont.Character[FSelectedChar] := cc;
        FCharChanged := false;
      End;
  End;

Procedure TFrmVecFontEditMain.FileOpen1Accept(Sender: TObject);
  Var
    fs: TFileStream;
  Begin
    FFilename := FileOpen1.Dialog.FileName;
    Caption := 'VectFontEdit: ' + ChangeFileExt(FFilename, '');
    fs := TFileStream.Create(FFilename, fmOpenRead);
    Try
      FVecFont.LoadFromStream(fs);
      LEd_FontTitle.Text:=FVecFont.FileDescription;
      DrawGrid1.Invalidate;
    Finally
      freeandnil(fs);
    End;
  End;

Procedure TFrmVecFontEditMain.FileSaveAs1Accept(Sender: TObject);
  Begin
    FFilename := FileSaveAs1.Dialog.FileName;
    actFileSave.Execute;
  End;

Procedure TFrmVecFontEditMain.FormCreate(Sender: TObject);
  Begin
    lbl_Version.Caption := format(SCompiled, [ADate, CName]);
    FVecFont := TVectorFont.Create;
  End;

Procedure TFrmVecFontEditMain.FormDestroy(Sender: TObject);
  Begin
    freeandnil(FVecFont);
  End;

Procedure TFrmVecFontEditMain.lbl_VersionClick(Sender: TObject);
  Begin
    actHelpAbout.Execute;
  End;

procedure TFrmVecFontEditMain.LEd_FontTitleChange(Sender: TObject);
begin
  FTitleChanged := true;
end;

procedure TFrmVecFontEditMain.LEd_FontTitleExit(Sender: TObject);

begin
  if Ftitlechanged Then
    FVecFont.FileDescription := LEd_FontTitle.Text;
  FtitleChanged := False;
end;

Procedure TFrmVecFontEditMain.PaintBox2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
  Begin
    StatusBar1.Panels[1].Text := '(' + inttostr(X Div 20) + ',' +
      inttostr(Y Div 20) + ')';
  End;

Procedure TFrmVecFontEditMain.PaintBox2Paint(Sender: TObject);
  Var
    xk: Integer;
    xe: Integer;
    drws: Integer;
    yk: Integer;
    i: Integer;
    cnt: Boolean;
    pnt: Boolean;
  Begin
    drws := 20; // Spined.value;
    With PaintBox2.Canvas Do
      Begin
        FillRect(ClipRect);
        xk := -1;
        yk := 6;
        MoveTo((xk * 2 + 1) * drws Div 2, (yk * 2 + 1) * drws Div 2);
        xe := 0;
        i := 1;
        pen.Width := 3;
        pen.Style := psSolid;
        While i <= length(Edit1.Text) Do
          Begin
            cnt := false;
            pnt := true;
            Case Edit1.Text[i] Of
              '9': // Goto
                If i + 2 <= length(Edit1.Text) Then
                  Begin
                    xk := Ord(Edit1.Text[i + 1]) - 48;
                    yk := Ord(Edit1.Text[i + 2]) - 48;
                    cnt := (i = 1) And (xk = 0);
                    i := i + 2;
                  End;
              '0':
                Begin
                  pnt := false;
                  If xe < xk Then
                    xe := xk + 1
                  Else
                    xe := xe + 1;
                  inc(i);
                  While (i < length(Edit1.Text)) And (Edit1.Text[i] = '0') Do
                    Begin
                      xe := xe + 1;
                      inc(i);
                    End;

                End;
              '1' .. '8':
                Begin
                  xk := xk + dir[Ord(Edit1.Text[i]) - 48].X;
                  yk := yk + dir[Ord(Edit1.Text[i]) - 48].Y;
                  cnt := true;
                End;
            Else
              pnt := false;
            End;
            brush.Color := clLtGray;
            If pnt Then
              FillRect(Rect(xk * drws, yk * drws, (xk + 1) * drws,
                (yk + 1) * drws));
            If (Edit1.SelStart <= i) And
              (Edit1.SelStart + Edit1.SelLength >= i) Then
              pen.Color := clBlue
            Else
              pen.Color := clblack;
            If Not cnt Or Not pnt Then
              MoveTo((xk * 2 + 1) * drws Div 2, (yk * 2 + 1) * drws Div 2)
            Else
              LineTo((xk * 2 + 1) * drws Div 2, (yk * 2 + 1) * drws Div 2);
            inc(i);
          End;
        // gid
        pen.Style := psDot;
        pen.Width := 1;
        For i := 1 To PaintBox2.Width Div drws Do
          Begin
            If i = xe Then
              pen.Color := clRed
            Else
              pen.Color := clDkGray;
{$IFDEF FPC}
            Line(i * drws, 0, i * drws, PaintBox2.Height);
{$ELSE}
            MoveTo(i * drws, 0);
            LineTo(i * drws, PaintBox2.Height);
{$ENDIF} End;
        For i := 1 To PaintBox2.Height Div drws Do
          Begin
            If i In [SpinEdit2.Value, SpinEdit3.Value, SpinEdit4.Value] Then
              pen.Color := clblack
            Else
              pen.Color := clDkGray;
              {$IFDEF FPC}
            Line(0, i * drws, PaintBox2.Width, i * drws);
{$ELSE}
            MoveTo(0, i * drws);
            LineTo( PaintBox2.Width, i * drws);
{$ENDIF}           End;

      End;

  End;

Procedure TFrmVecFontEditMain.SpeedButton1Click(Sender: TObject);
  Begin
   // PaintBox1.Canvas.Clear;
    PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
    PaintBox1.Canvas.pen.Width := 1;
    FVecFont.Write(PaintBox1.Canvas, 2, 2, LEd_TestText.Text, SpinEdit1.Value);
  End;

Procedure TFrmVecFontEditMain.actFileNewExecute(Sender: TObject);
  Var
    mr: TModalResult;
  Begin
    If FVecFont.changed Then
      Begin
        mr := MessageDlg('Sollen die Änderungen gespeichert werden ?',
          mtConfirmation, mbYesNoCancel, 0);
        If mr = mrYes Then
          actFileSave.Execute;
        If mr = mrNo Then
          FVecFont.changed := false;
        // File Save/Close -Query
      End;
    If Not FVecFont.changed Then
      FVecFont.Clear;
    DrawGrid1.Invalidate;
    FFilename := '';
  End;

Procedure TFrmVecFontEditMain.actFileSaveExecute(Sender: TObject);
  Var
    fs: TFileStream;
    lFileMode: TFontFileType;
  Begin
    If FFilename = '' Then
      FileSaveAs1.Execute
    Else
      Begin
        If FileExists(FFilename) Then
          fs := TFileStream.Create(FFilename, fmOpenWrite)
        Else
          fs := TFileStream.Create(FFilename, fmCreate);
        Try
          If UpperCase(ExtractFileExt(FFilename)) = '.TXT' Then
            lFileMode := fft_Textfile
          Else
            lFileMode := fft_Compressed;
          FVecFont.SaveToStream(fs, lFileMode);
        Finally
          freeandnil(fs);
        End;
      End;
  End;

Procedure TFrmVecFontEditMain.actFileSaveUpdate(Sender: TObject);
  Begin
    actFileSave.Enabled := FVecFont.changed;
  End;

Procedure TFrmVecFontEditMain.actHelpAboutExecute(Sender: TObject);
  Begin
    AboutBox1.ShowModal;
  End;

Procedure TFrmVecFontEditMain.DrawGrid1Click(Sender: TObject);

  Var
    Line: String;
    i: Integer;
  Begin
    FSelectedChar := DrawGrid1.Col - 17 + DrawGrid1.Row * 16;
    Line := '';
    For i := 0 To High(FVecFont.Character[FSelectedChar]) Do
      Line := Line + inttostr(FVecFont.Character[FSelectedChar][i]);
    Edit1.Text := Line;
    FCharChanged := false;
  End;

End.
