Unit frm_html2csvMAIN;

Interface

Uses {$IFDEF FPC}   {$ELSE} Windows, ToolWin,  {$ENDIF}Classes, Graphics,
  Forms, Controls, Menus, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  ImgList, StdActns, ActnList, ComboEx, FramBrwz, Frm_Aboutbox,
  VisualHTTPClient, Unt_Config, htmlview, Htmlsubs, fphttpclient;

Type

  { TSDIAppForm }

  TSDIAppForm = Class(TForm)
    AboutBox1: TAboutBox;
    Config1: TConfig;
    ListBox1: TListBox;
    {$IFDEF FPC}
    //    FrameBrowser1: TFrameBrowser;
    VisualHTTPClient1: TVisualHTTPClient;
    {$ELSE}
    WebBrowser1: TWebBrowser;
    {$ENDIF}
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ToolBar1: TToolBar;
    ToolButton9: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileOpen1: TAction;
    FileSave1: TAction;
    FileSaveAs1: TAction;
    FileExit1: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    HelpAbout1: TAction;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    Help1: TMenuItem;
    HelpAboutItem: TMenuItem;
    ProgressBar1: TProgressBar;
    cbxFilename: TComboBoxEx;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Memo2: TMemo;
    TreeView1: TTreeView;
    Memo3: TMemo;
    Procedure FileNew1Execute(Sender: TObject);
    Procedure FileOpen1Execute(Sender: TObject);
    Procedure FileSave1Execute(Sender: TObject);
    Procedure FileExit1Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    Procedure HelpAbout1Execute(Sender: TObject);
    Procedure ButtonedEdit1LeftButtonClick(Sender: TObject);
    Procedure ButtonedEdit1RightButtonClick(Sender: TObject);
    Procedure BitBtn1Click(Sender: TObject);
    Procedure BitBtn2Click(Sender: TObject);
    procedure VisualHTTPClient1DataReceived(Sender: TObject;
      const ContentLength, CurrentPos: Int64);
  Private
    { Private-Deklarationen }
    Procedure ParseHTML(Source: String; tokens: Array Of String;
      dest: Tstrings);
  Public
    { Public-Deklarationen }
  End;

Var
  SDIAppForm: TSDIAppForm;

Implementation

Uses variants, VarUtils, sysutils, unt_StringProcs;
{$IFDEF FPC} {$R *.lfm}  {$ELSE} {$R *.dfm}  {$ENDIF}

Procedure TSDIAppForm.FileNew1Execute(Sender: TObject);
  Begin
    { Nichts ausführen }
  End;

Procedure TSDIAppForm.FileOpen1Execute(Sender: TObject);
  Begin
    OpenDialog.Execute;
  End;

Procedure TSDIAppForm.FileSave1Execute(Sender: TObject);
  Begin
    SaveDialog.Execute;
  End;

Procedure TSDIAppForm.BitBtn1Click(Sender: TObject);
  Begin
    {$IFDEF FPC}
    Memo1.text := VisualHTTPClient1.Get(cbxFilename.Text);
    {$ELSE}
    WebBrowser1.Navigate(cbxFilename.Text);
    {$ENDIF}
  End;

Procedure TSDIAppForm.BitBtn2Click(Sender: TObject);
  Begin
    Memo2.clear;
    {$IFDEF FPC}
    ParseHTML(Memo1.text, [], Memo2.lines);
    {$ELSE}
    ParseHTML(WebBrowser1.OleObject.Document.body.innerhtml, [], Memo2.lines);
    {$ENDIF}
  End;

procedure TSDIAppForm.VisualHTTPClient1DataReceived(Sender: TObject;
  const ContentLength, CurrentPos: Int64);
begin

end;

Procedure TSDIAppForm.ButtonedEdit1LeftButtonClick(Sender: TObject);
  Begin
    //
  End;

Procedure TSDIAppForm.ButtonedEdit1RightButtonClick(Sender: TObject);
  Begin
    //
  End;

Procedure TSDIAppForm.FileExit1Execute(Sender: TObject);
  Begin
    Close;
  End;

procedure TSDIAppForm.FormShow(Sender: TObject);
Var
    CBCount, i: Integer;
  Begin
    CBCount := Config1.getValue(cbxFilename, 'ICount', 0);
    For i := 0 To CBCount - 1 Do
      cbxFilename.Items.Add(Config1.getValue(cbxFilename, inttostr(i), ''));
end;

Procedure TSDIAppForm.HelpAbout1Execute(Sender: TObject);
  Begin
    AboutBox1.ShowModal;
  End;

Type
  TTagInfo = Record
    Key: String;
    Level: integer;
    Tag: String;
    Pre: String End;

  Const
    TagInfo: Array [0 .. 11] Of TTagInfo =
      ((Key: 'Name'; Level: 6; Tag: 'H2'), (Key: 'Birth'; Level: 8; Tag: 'LI';
        Pre: 'Geboren:'), (Key: 'Baptised'; Level: 8; Tag: 'LI';
        Pre: 'Getauft:'), (Key: 'Marr'; Level: 8; Tag: 'LI'; Pre: 'Ehe:'),
      (Key: 'Death'; Level: 8; Tag: 'LI'; Pre: 'Gestorben:'), (Key: 'Buried';
        Level: 8; Tag: 'LI'; Pre: 'Bestattet:'), (Key: 'Parent'; Level: 16;
        Tag: 'A'; Pre: ''), (Key: 'Partner'; Level: 20; Tag: 'A'; Pre: ''),
      (Key: 'Child'; Level: 22; Tag: 'A'; Pre: ''), (Key: 'Occupation';
        Level: 7; Tag: 'FONT'; Pre: '• Beruf:'), (Key: 'Adress'; Level: 7;
        Tag: 'FONT'; Pre: '• Wohnort,'), (Key: 'Religion'; Level: 7;
        Tag: 'FONT'; Pre: '• Religion:'));

    Procedure TSDIAppForm.ParseHTML(Source: String; tokens: Array Of String;
      dest: Tstrings);

  Var
    PP, divPos, EDivPos, tl, TagLevel: integer;
    Dtyp: String;
    I: integer;
    flag: Boolean;

  Var
    UnaryTags: TarrayOfString;
    TagStack: TarrayOfString;
    tNodes: Array Of TTreeNode;

    Procedure HandleTags(DarstTag: Boolean; Var PlainText: String;
      Var TagLevel: integer; tagTyp: String);

  Var
    EDivPos: integer;
    send: integer;
    SL, I: integer;

  Begin
    Memo1.lines.add(inttostr(TagLevel) + ' <' + TagStack[TagLevel] + '> ' + trim
        (PlainText) + ' <' + tagTyp + '>');
    {
    dest.Add(inttostr(TagLevel) + ' <'+TagStack[taglevel] +'> '+ trim(PlainText) + ' <' +
          tagTyp + '>');

      If TagLevel = 0 Then
      Begin
      setlength(tNodes, TagLevel + 1);
      tNodes[TagLevel] := TreeView1.Items.AddChild(Nil,
      trim(PlainText) + ' <' + tagTyp + '>')
      End
      Else
      Begin
      setlength(tNodes, TagLevel + 1);
      tNodes[TagLevel] := TreeView1.Items.AddChild(tNodes[TagLevel - 1],
      trim(PlainText) + ' < ' + tagTyp + ' > ');
      End;
    }
    For I := 0 To High(TagInfo) Do
      If (TagLevel = TagInfo[I].Level) And
        (copy(TagStack[TagLevel], 1, length(TagInfo[I].Tag)) = TagInfo[I].Tag)
        And (copy(PlainText, 1, length(TagInfo[I].Pre)) = TagInfo[I].Pre) Then
        dest.add(TagInfo[I].Key + '=' + trim
            (copy(PlainText, length(TagInfo[I].Pre) + 1, length(PlainText))));

    If copy(tagTyp, 1, 1) = '/' Then
      Begin
        SL := TagLevel;
      While (uppercase(copy(tagTyp, 2, length(tagTyp))) <> copy
          (TagStack[SL], 1, length(tagTyp) - 1)) And (SL > 0) Do
          dec(SL);
      If uppercase(copy(tagTyp, 2, length(tagTyp))) = copy
        (TagStack[SL], 1, length(tagTyp) - 1) Then
          Begin
            // POP Stack
            TagLevel := SL - 1;
            setlength(TagStack, TagLevel + 1);
          End;
      End
    Else If (parsestr(tagTyp, UnaryTags, psm_start) = -1) Or
      (uppercase(copy(tagTyp, 1, length(tagTyp))) <> copy
        (TagStack[TagLevel], 1, length(tagTyp))) Then
      Begin
        // Push Stack
        inc(TagLevel);
        setlength(TagStack, TagLevel + 1);
        TagStack[TagLevel] := tagTyp;
      End;

    PlainText := '';

  End;

  Procedure parseDiv(Source, tt: String; dest: Tstrings);

  Var
    PP, TagPos, tl, TagLevel: integer;
    tagTyp: String;
    PlainText: String;
    DarstTag: Boolean;

  Begin
    PP := 1;
    PlainText := '';
    TagLevel := 0;
    TagPos := PP + pos('<', copy(Source, PP, length(Source)));
    DarstTag := false;
    While PP < length(Source) Do
      Begin
        PlainText := PlainText + copy(Source, PP, TagPos - PP - 1);
        tl := pos('>', copy(Source, TagPos, length(Source)));
        tagTyp := copy(Source, TagPos, tl - 1);
        HandleTags(DarstTag, PlainText, TagLevel, tagTyp);

        PP := TagPos + tl;

        TagPos := PP + pos('<', copy(Source, PP, length(Source)));
        If TagPos = PP Then
          PP := length(Source);
      End;
    PlainText := StringReplace(PlainText, #13#10, '', [rfReplaceAll]);
    If TagLevel = 0 Then
      If (pos(':', PlainText) = 0) Or (tt = 'tn15title') Then
        dest.Add(tt + '=' + PlainText)
      Else
        dest.Add(StringReplace(PlainText, ':', '=', []));
  End;

  Begin
    PP := 1;
    TagLevel := 0;
    setlength(UnaryTags, 2);
    UnaryTags[0] := 'BR';
    UnaryTags[1] := 'LI';
    setlength(TagStack, 1);
    divPos := PP + pos('<DIV', copy(Source, PP, length(Source)));
    EDivPos := PP + pos('</DIV', copy(Source, PP, length(Source)));
    While PP < length(Source) Do
      Begin
        If EDivPos > divPos Then
          Begin
            // DIV
            inc(TagLevel);
            tl := pos('>', copy(Source, divPos + 4, length(Source)));
            Dtyp := copy(Source, divPos + 4, tl - 1);

            PP := divPos + 4 + tl;
          End
        Else
          Begin // \DIV
            flag := false;
            For I := 0 To High(tokens) Do
              If copy(Dtyp, pos('=', Dtyp) + 1, length(Dtyp)) = tokens[I] Then
                flag := true;
            If flag Or ( High(tokens) = -1) Then
              Begin
          parseDiv(copy(Source, PP, EDivPos - PP), copy
              (Dtyp, pos('=', Dtyp) + 1, length(Dtyp)), dest);
              End;
            dec(TagLevel);
            PP := EDivPos + 4;
          End;
        divPos := PP + pos('<DIV', copy(Source, PP, length(Source)));
        EDivPos := PP + pos('</DIV', copy(Source, PP, length(Source)));
        If (divPos = EDivPos) Or (divPos = PP) Then
          PP := length(Source);
      End;
  End;

End.
