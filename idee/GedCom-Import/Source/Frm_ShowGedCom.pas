Unit Frm_ShowGedCom;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
{$IFnDEF FPC}
  GestureMgr, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Unt_Config, StdCtrls, Buttons, ComCtrls, FileUtil,
  unt_VariantProcs;

Type
  TForm1 = Class(TForm)
    TreeView1: TTreeView;
    StatusBar1: TStatusBar;
    OpenDialog1: TOpenDialog;
    BitBtn1: TBitBtn;
    ComboBox1: TComboBox;
    Config1: TConfig;
   {$IFNDEF FPC}  GestureManager1: TGestureManager;    {$ENDIF}
    BitBtn2: TBitBtn;
    Memo1: TMemo;
    Procedure BitBtn1Click(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure BitBtn2Click(Sender: TObject);
  Private
    { Private-Deklarationen }
    GedVar: variant;

  Public
    Function ParseGed(fs: tStream): variant;
    { Public-Deklarationen }
  End;

Var
  Form1: TForm1;

Implementation

uses Unt_Stringprocs;
{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}


procedure Var2treenodes(const Data:variant;Owner:TTreeNodes;base:tTreenode) ;

var hst : string;
    actnode:TTreeNode;
    i:integer;

begin
  case Vartype(Data) of
      varEmpty:hst:='';
      varNull:hst:='';
      varSmallint ,
      varInteger  ,
      varSingle   ,
      varDouble   ,
      varCurrency ,
      varDate     ,
      varDispatch ,
      varError    ,
      varVariant  ,
      varUnknown  ,
      varByte     :HST:=varastype(Data,varstring);
      varBoolean  :if data then hst:='TRUE' else hst:='FALSE';
      varOleStr   ,
      varString   : hst:=Data;
      varArray..varArray+vartypeMask:
          begin
            for i := VarArrayLowBound(data,1)to VarArrayHighBound(data,1) div 2 do
              begin
                actnode:=Owner.AddChild(base,var2string(data[i*2]));
                Var2treenodes(Data[i*2+1],Owner,Actnode);
              end;
            hst :='';
          end;
    end;
   if hst <> ''  then
     begin
       actnode:=Owner.AddChild(base,hst);
     end;

end;

Procedure TForm1.BitBtn1Click(Sender: TObject);
  Var
    ix, i: Integer;
  Begin
    OpenDialog1.Filter := 'Gedcom-Dateien (*.ged)|*.ged|Alle Dateien (*.*)|*.*';
    If OpenDialog1.Execute Then
      Begin
        ix := ComboBox1.Items.IndexOf(OpenDialog1.FileName);
        If ix = -1 Then
          Begin
            ComboBox1.Items.Add(OpenDialog1.FileName);
            ix := ComboBox1.Items.count - 1;
            Config1.Value[ComboBox1, 'ICount'] := ComboBox1.Items.count;
            For i := 0 To ComboBox1.Items.count - 1 Do
              Config1.Value[ComboBox1, inttostr(i)] := ComboBox1.Items[i];
          End;
        ComboBox1.ItemIndex := ix;
      End;

  End;

Procedure TForm1.BitBtn2Click(Sender: TObject);

  Var
    lMemStream: TMemoryStream;
  Begin
    If FileExistsUTF8(ComboBox1.Text) { *Converted from FileExists* } Then
      Begin
        lMemStream := TMemoryStream.Create;
        lMemStream.LoadFromFile(ComboBox1.Text);
        GedVar := ParseGed(lMemStream);
        lMemStream.free;

        memo1.text := var2string(GedVar,false);
        Var2treenodes(GedVar,TreeView1.Items,nil);
      End;
  End;

Procedure TForm1.FormShow(Sender: TObject);
  Var
    CBCount, i: Integer;
  Begin
    CBCount := Config1.getValue(ComboBox1, 'ICount', 0);
    For i := 0 To CBCount - 1 Do
      ComboBox1.Items.Add(Config1.getValue(ComboBox1, inttostr(i), ''))

  End;

Function TForm1.ParseGed(fs: tStream): variant;

  Var
    ActLevel: Integer;
    actVar: Array Of variant;

    Procedure AppendLine(Const Line: String);

      Var
        LineLevel: Integer;
        newvar: variant;
      Begin
        Memo1.Lines.Add(StringOfChar(' ',actlevel+1  )+line);
        If trystrtoint(trim(copy(Line, 1, 2)), LineLevel) Then
          Begin
            If LineLevel = ActLevel + 1 Then
              Begin
                setlength(actVar, LineLevel + 1);
                newvar := VarArrayCreate([0, 1], varVariant);
                newvar[0] := copy(Line, 3, length(Line));
                actVar[ LineLevel] := newvar;
                ActLevel := LineLevel;
              End
            Else If LineLevel <= ActLevel Then
              Begin
                while ActLevel > LineLevel do
                begin
                  actVar[ActLevel-1][vararrayhighbound(actVar[ActLevel-1], 1)
                  ]:=actVar[ActLevel];
                  dec(Actlevel);
                end;
                VarArrayRedim(actVar[LineLevel],
                  vararrayhighbound(actVar[LineLevel], 1) + 2);
                actVar[LineLevel][vararrayhighbound(actVar[LineLevel], 1) - 1]
                  := copy(Line, 3, length(Line));

              End;
          End;
      End;

  Var
    wide: byte;
    aCh: ansiChar;
    wCh: WideChar;
    Line: String;

  Begin
    ActLevel := -1;
    fs.Seek(0, soFromBeginning);
    wide := 0;
    If wide = 0 Then
      Begin
        fs.Seek(0, soFromBeginning);
        While fs.Position < fs.Size Do
          Begin
            fs.Read(aCh, 1);
            If charinset(aCh, [#13, #10]) Then
              Begin
                If Line <> '' Then
                  AppendLine(Line);
                Line := '';
              End
            Else
              Line := Line + aCh;
          End;
      End
    Else
      Begin
        While fs.Position < fs.Size Do
          Begin
            fs.Read(wCh, 2);
            Line := Line + wCh;
          End;
      End;
    result := actVar[0];
  End;

End.