unit RichMemoFrame;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Classes, Graphics, Dialogs, StdCtrls, Buttons, ActnList,
  Menus, RichMemo, RichMemoUtils;

type

  { TRTFEditFrame }

  TRTFEditFrame = class(TFrame)
    actEditSetBold: TAction;
    actEditSetItalic: TAction;
    actEditSetUnderline: TAction;
    actEditJustLeft: TAction;
    actEditJustCenter: TAction;
    actEditJustRight: TAction;
    actEditJustJust: TAction;
    ActionList1: TActionList;
    btnCA: TSpeedButton;
    btnJA: TSpeedButton;
    btnLA: TSpeedButton;
    btnRA: TSpeedButton;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    PopupMenu1: TPopupMenu;
    RichMemo1: TRichMemo;
    btnBold: TSpeedButton;
    btnItalic: TSpeedButton;
    btnUnderline: TSpeedButton;
    btnFont: TSpeedButton;
    btnColor: TSpeedButton;
    procedure actEditJustCenterUpdate(Sender: TObject);
    procedure actEditJustJustUpdate(Sender: TObject);
    procedure actEditJustLeftUpdate(Sender: TObject);
    procedure actEditJustRightUpdate(Sender: TObject);
    procedure actEditSetBoldUpdate(Sender: TObject);
    procedure actEditSetItalicUpdate(Sender: TObject);
    procedure actEditSetUnderlineUpdate(Sender: TObject);
    procedure actEditJustCenterExecute(Sender: TObject);
    procedure actEditSetItalicExecute(Sender: TObject);
    procedure actEditJustJustExecute(Sender: TObject);
    procedure actEditJustLeftExecute(Sender: TObject);
    procedure actEditJustRightExecute(Sender: TObject);
    procedure actEditSetBoldExecute(Sender: TObject);
    procedure actEditSetUnderlineExecute(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure RichMemo1Change(Sender: TObject);
  private
    FFilename: String;
    FOnChange:TNotifyEvent;
    procedure FontStyleModify(fs: TFontStyle);
    function GetChanged: boolean;
    procedure SetChanged(AValue: boolean);
    procedure SetFilename(AValue: String);
    procedure SetOnChange(AValue: TnotifyEvent);
  public
    Procedure LoadFile(aFilename:String);
    procedure NewFile(aFilename: String='New File.rtf');
    procedure SaveFileAs(aFilename: String);
    Procedure SaveFile;
    property OnChange:TnotifyEvent read FOnChange write SetOnChange;
    property Changed:boolean read GetChanged write SetChanged;
    property Filename:String read FFilename write SetFilename;
  end;

var
  RTFEditFrame: TRTFEditFrame = nil;

implementation

{$R *.lfm}

{ TRTFEditFrame }

procedure TRTFEditFrame.actEditJustLeftExecute(Sender: TObject);
begin
  RichMemo1.SetParaAlignment( RichMemo1.SelStart,
    RichMemo1.SelLength, paLeft);
end;

procedure TRTFEditFrame.actEditJustCenterExecute(Sender: TObject);
begin
  RichMemo1.SetParaAlignment( RichMemo1.SelStart,
    RichMemo1.SelLength, paCenter);
end;

procedure TRTFEditFrame.actEditSetUnderlineUpdate(Sender: TObject);
var
  f: TFontParams;
begin
  RichMemo1.GetTextAttributes(RichMemo1.SelStart, f{%H-});
  actEditSetUnderline.Checked:=fsUnderline in f.Style;
end;

procedure TRTFEditFrame.actEditSetItalicUpdate(Sender: TObject);
var
  f: TFontParams;
begin
  RichMemo1.GetTextAttributes(RichMemo1.SelStart, f{%H-});
    actEditSetItalic.Checked:=fsItalic in f.Style ;
end;

procedure TRTFEditFrame.actEditJustCenterUpdate(Sender: TObject);
begin
   actEditJustCenter.checked:= RichMemo1.GetParaAlignment(RichMemo1.SelStart)=paCenter;
end;

procedure TRTFEditFrame.actEditJustJustUpdate(Sender: TObject);
begin
   actEditJustJust.checked:= RichMemo1.GetParaAlignment(RichMemo1.SelStart)=paJustify;
end;

procedure TRTFEditFrame.actEditJustLeftUpdate(Sender: TObject);
begin
  actEditJustLeft.checked:= RichMemo1.GetParaAlignment(RichMemo1.SelStart)=paLeft;
end;

procedure TRTFEditFrame.actEditJustRightUpdate(Sender: TObject);
begin
  actEditJustRight.checked:= RichMemo1.GetParaAlignment(RichMemo1.SelStart)=paRight;
end;

procedure TRTFEditFrame.actEditSetBoldUpdate(Sender: TObject);
var
  f: TFontParams;
begin
   RichMemo1.GetTextAttributes(RichMemo1.SelStart, f{%H-});
  actEditSetBold.Checked:=fsBold in f.Style;
end;

procedure TRTFEditFrame.actEditSetItalicExecute(Sender: TObject);
begin
  FontStyleModify(fsItalic);
  RichMemo1.Modified:=true;
end;

procedure TRTFEditFrame.actEditJustJustExecute(Sender: TObject);
begin
  RichMemo1.SetParaAlignment( RichMemo1.SelStart,
    RichMemo1.SelLength, paJustify);
  RichMemo1.Modified:=true;
end;

procedure TRTFEditFrame.actEditJustRightExecute(Sender: TObject);
begin
  RichMemo1.SetParaAlignment( RichMemo1.SelStart,
    RichMemo1.SelLength, paRight);
  RichMemo1.Modified:=true;
end;

procedure TRTFEditFrame.actEditSetBoldExecute(Sender: TObject);
begin
  FontStyleModify(fsBold);
  RichMemo1.Modified:=true;
end;

procedure TRTFEditFrame.actEditSetUnderlineExecute(Sender: TObject);
begin
  FontStyleModify(fsUnderline);
  RichMemo1.Modified:=true;
end;

procedure TRTFEditFrame.btnFontClick(Sender: TObject);
var
  f : TFontParams;
  lParamChangSet: TTextModifyMask;
begin
  RichMemo1.GetTextAttributes(RichMemo1.SelStart, f{%H-});
  FontDialog1.Font.Name:=f.Name;
  FontDialog1.Font.Size:=f.Size;
  FontDialog1.Font.Style:=f.Style;
  FontDialog1.Font.Color:=f.Color;
  FontDialog1.Font.Style:=f.Style;
  if FontDialog1.Execute then begin
    lParamChangSet:=[];
    if f.Name <> FontDialog1.Font.Name then
      lParamChangSet:=lParamChangSet + [tmm_Name];
    if f.Size <> FontDialog1.Font.size then
      lParamChangSet:=lParamChangSet + [tmm_Size];
    if f.Color <> FontDialog1.Font.Color then
      lParamChangSet:=lParamChangSet + [tmm_Color];
    if f.Style <> FontDialog1.Font.Style then
      lParamChangSet:=lParamChangSet + [tmm_Styles];

    RichMemo1.SetRangeParams(RichMemo1.SelStart, RichMemo1.SelLength
      , lParamChangSet
      , FontDialog1.Font.Name
      , FontDialog1.Font.Size
      , FontDialog1.Font.Color, FontDialog1.Font.Style - f.Style, f.Style-FontDialog1.Font.Style);
    RichMemo1.Modified:=true;
  end;
end;

procedure TRTFEditFrame.btnColorClick(Sender: TObject);
var
  f : TFontParams;
begin
  RichMemo1.GetTextAttributes(RichMemo1.SelStart, f{%H-});
  ColorDialog1.Color:=f.Color;
  if ColorDialog1.Execute then begin
    RichMemo1.SetRangeColor( RichMemo1.SelStart, RichMemo1.SelLength,
      ColorDialog1.Color);
    RichMemo1.Modified:=true;
  end;
end;

procedure TRTFEditFrame.RichMemo1Change(Sender: TObject);
begin
  RichMemo1.Modified:=true;
  if assigned(FOnChange) then
     FOnchange(Sender);
end;

procedure TRTFEditFrame.FontStyleModify(fs: TFontStyle);
var
  f : TFontParams;
  rm  : TFontStyles;
  add : TFontStyles;
begin
  if RichMemo1.SelLength = 0 then
     begin
       RichMemo1.Font.Style := TFontStyles( Longint(RichMemo1.Font.Style) xor longint([fs]));
       exit;
     end;
  RichMemo1.GetTextAttributes(RichMemo1.SelStart, f{%H-});
  if fs in f.Style then begin
    rm:=[fs]; add:=[];
  end else begin
    rm:=[]; add:=[fs];
  end;
  RichMemo1.SetRangeParams(RichMemo1.SelStart, RichMemo1.SelLength
    , [tmm_Styles] , '', 0, 0, add, rm);
  RichMemo1.Modified:=true;
end;

function TRTFEditFrame.GetChanged: boolean;
begin
  result:=RichMemo1.Modified;
end;

procedure TRTFEditFrame.SetChanged(AValue: boolean);
begin
  if RichMemo1.Modified= AValue then exit;
  RichMemo1.Modified:= AValue;
end;

procedure TRTFEditFrame.SetFilename(AValue: String);
begin
  if FFilename=AValue then Exit;
  FFilename:=AValue;
end;

procedure TRTFEditFrame.SetOnChange(AValue: TnotifyEvent);
begin
  if FOnChange=AValue then Exit;
  FOnChange:=AValue;
end;

procedure TRTFEditFrame.LoadFile(aFilename: String);
begin
  FFilename := aFilename;
  LoadRTFFile( RichMemo1, FFilename);
  RichMemo1.Modified := false;
end;

procedure TRTFEditFrame.NewFile(aFilename: String);
begin
  FFilename := aFilename;
  RichMemo1.Clear;
  RichMemo1.Modified := false;
end;

procedure TRTFEditFrame.SaveFileAs(aFilename: String);
var
  lNewFilename, lBakFilename: String;
begin
  if FFilename <> aFilename then
    FFilename := aFilename;
  lNewFilename := ChangeFileExt(FFilename,'.new');
  lBakFilename := ChangeFileExt(FFilename,'.bak');
  if (lNewFilename=FFilename) and fileexists(FFilename) then
    begin
      if fileexists(lBakFilename) then
        deletefile(lBakFilename);
      RenameFile(FFilename,lBakFilename);
    end;
  if fileexists(lNewFilename) then
    deletefile(lNewFilename);
  SaveRTFFile( RichMemo1, lNewFilename);
  if (lNewFilename<>FFilename) and fileexists(FFilename) then
    begin
      if fileexists(lBakFilename) then
        deletefile(lBakFilename);
      if FFilename <> lBakFilename then
        RenameFile(FFilename,lBakFilename);
    end;
  if (lNewFilename<>FFilename) then
    RenameFile(lNewFilename,FFilename);
  RichMemo1.Modified := false;
end;

procedure TRTFEditFrame.SaveFile;
begin
  SaveFileAs(FFilename);
end;

end.

