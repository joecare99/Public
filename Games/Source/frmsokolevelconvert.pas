unit frmSokoLevelConvert;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,{$IFDEF FPC} FileUtil,{$ELSE}windows, {$ENDIF} Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, Grids, ValEdit, SokoEngine;

type

  { TfrmConvertLevelData }

  TfrmConvertLevelData = class(TForm)
    btnGenTestData: TButton;
    btnGenLevelData: TButton;
    btnSaveData: TButton;
    btnLoadData: TButton;
    Button1: TButton;
    Button2: TButton;
    dgrActLevel: TDrawGrid;
    edtShowData1: TMemo;
    iglLevelTiles: TImageList;
    edtLevelFile: TLabeledEdit;
    lblCompileInfo: TLabel;
    lbxLevels: TListBox;
    edtShowData: TMemo;
    dlgOpenLevelFile: TOpenDialog;
    btnOpenLFile: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ValueListEditor1: TValueListEditor;
    procedure btnGenTestDataClick(Sender: TObject);
    procedure btnGenLevelDataClick(Sender: TObject);
    procedure btnLoadDataClick(Sender: TObject);
    procedure btnSaveDataClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure dgrActLevelDrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; aState: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbxLevelsSelectionChange(Sender: TObject; User: boolean);
    procedure btnOpenLFileClick(Sender: TObject);
  private
    { private declarations }
    FLevelSet: TPuzzleCollectionData;
    FActLevel: TPuzzleField;
    FBinData: TBytes;
    FBOffset: integer;
    FReadPos:integer;
    FLastVal: integer;
    FLastMax: integer;
    procedure ClearData;
    procedure AppendData(AValue: integer; MaxValue: integer = 255);
    procedure AppendString(AString: AnsiString);
    procedure ResetRead;
    function ReadData(MaxValue: integer = 255): integer;
    function readString:AnsiString ;
    Procedure BuildLevelSet(out aLevelset:TPuzzleCollectionData);
    PRocedure CompareLevelsets(const LS1,LS2:TPuzzleCollectionData);
    procedure ShowData;
    procedure UpdateHMI;
  public
    { public declarations }
  end;

var
  frmConvertLevelData: TfrmConvertLevelData;

implementation

uses unt_cdate, LoadLevelsetUnit;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
const LineEnding=#13#10;

{$ENDIF}

resourcestring
  SCompileInfo = 'Compiled: %s' + LineEnding + #9'on: %s';

{ TfrmConvertLevelData }

procedure TfrmConvertLevelData.FormCreate(Sender: TObject);
begin
  lblCompileInfo.Caption := format(SCompileInfo, [ADate, CName]);
  FLevelSet := TPuzzleCollectionData.Create;
end;

procedure TfrmConvertLevelData.dgrActLevelDrawCell(Sender: TObject;
  aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
var
  lTile: integer;
  lIsTarg: boolean;
begin
  if assigned(FActLevel) then
  begin
    lIsTarg := FActLevel[acol, arow].FIsCrateTarget;
    case FActLevel[acol, arow].FPartType of
      ptWall: lTile := 0;
      ptNone: if lIsTarg then
          lTile := 2
        else
          lTile := 1;
      ptCrate: if lIsTarg then
          lTile := 4
        else
          lTile := 3;
      ptPlayer: if lIsTarg then
          lTile := 6
        else
          lTile := 5
      else
        lTile := 7;
    end;

  end
  else
    lTile := 7;
  {$IFDEF FPC}
  iglLevelTiles.StretchDraw(dgrActLevel.canvas, lTile, aRect);
  {$else}
  iglLevelTiles.Draw(dgrActLevel.canvas, aRect.left, arect.top, lTile);
  {$ENDIF}
end;

procedure TfrmConvertLevelData.btnGenTestDataClick(Sender: TObject);
begin
  ClearData;
  AppendString('Das ist ein Test ÄÖÜ!');
  AppendData(25);
  AppendData(255, 255);
  AppendData(257, 1000);
  AppendData(1000000, 1000000);
  AppendData(1000, 1000);
  AppendData(999, 1000);
  AppendData(1, 1);
  AppendData(1, 1);
  AppendData(1, 1);
  AppendData(0, 1);
  AppendData(0, 1);
  AppendData(1, 4);
  AppendData(1, 4);
  AppendData(1, 4);
  AppendData(2, 4);
  AppendData(2, 4);
  AppendData(17, 30);
  AppendData(12, 20);
  AppendData(0, 1);
  AppendData(0, 1);
  AppendData(0, 1);
  AppendData(1, 1);
  AppendData(1, 1);
  AppendData(4, 4);
  AppendData(4, 4);
  AppendData(4, 4);
  AppendData(1, 4);
  AppendData(1, 4);
  ShowData;
end;

procedure TfrmConvertLevelData.Button1Click(Sender: TObject);
begin
  edtShowData.Clear;
  ResetRead;
  edtShowData.Lines.Add(readString);
  edtShowData.Lines.Add(inttostr(ReadData()));
  edtShowData.Lines.Add(inttostr(ReadData(255)));
  edtShowData.Lines.Add(inttostr(ReadData(1000)));
  edtShowData.Lines.Add(inttostr(ReadData(1000000)));
  edtShowData.Lines.Add(inttostr(ReadData(1000))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1000))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(4))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(4))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(4))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(4))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(4))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(30))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(20))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(1))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(4))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(4))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(4))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(4))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
  edtShowData.Lines.Add(inttostr(ReadData(4))+#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));
end;

procedure TfrmConvertLevelData.Button2Click(Sender: TObject);
var
  aLevelset: TPuzzleCollectionData;
begin
  if FLevelSet.NumberOfLevels=0 then
    begin
      freeandnil(FLevelSet);
      BuildLevelSet(FLevelSet);
      UpdateHMI;
    end
  else
    begin
      BuildLevelSet(aLevelset);
      try
      CompareLevelsets(FLevelSet,aLevelset);
      finally
        freeandnil(aLevelset);
      end;
    end;
end;


procedure TfrmConvertLevelData.btnGenLevelDataClick(Sender: TObject);
var
  I: integer;
  X: integer;
  Y: integer;

  procedure AppendFrameData(i, x, y: integer);
  begin
    if FLevelSet.FPuzzleFields[i][X, y].FPartType in [ptNone, ptEmpty] then
      AppendData(0, 1)
    else
      AppendData(1, 1);
  end;

begin
  ClearData;
  // HEader
  AppendData(1002003006, 2000000000); // Magic
  AppendString(FLevelSet.Title);
  AppendString(FLevelSet.Description);
  AppendString(FLevelSet.EMail);
  AppendString(FLevelSet.Copyright);
  AppendData(FLevelSet.NumberOfLevels, 1000);
  AppendData(FLevelSet.MaxWidth, 30);
  AppendData(FLevelSet.MaxHeight, 20);
  //  AddPadding(8);
  for I := 0 to FLevelSet.NumberOfLevels - 1 do
  begin
    // Level-Header
    //   AppendData(i+1,1000);
    //if FBOffset = 0 then
    //edtShowData1.lines.add(inttostr(I)+':'#9+inttostr(high(FBinData)+1)+'.'+inttostr(FBOffset))
    //else
    //edtShowData1.lines.add(inttostr(I)+':'#9+inttostr(high(FBinData))+'.'+inttostr(FBOffset));
    AppendData(high(FLevelSet.FPuzzleFields[i]) + 1, 30);
    AppendData(high(FLevelSet.FPuzzleFields[i][0]) + 1, 20);
    // Suche Player
    for X := 0 to high(FLevelSet.FPuzzleFields[i]) do
      for Y := 0 to high(FLevelSet.FPuzzleFields[i][0]) do
        if FLevelSet.FPuzzleFields[i][X, y].FPartType = ptPlayer then
        begin
          AppendData(X + 1, 30);
          AppendData(Y + 1, 20);
        end;

    //if FBOffset = 0 then
    //edtShowData1.lines.add(inttostr(I)+'.a:'#9+inttostr(high(FBinData)+1)+'.'+inttostr(FBOffset))
    //else
    //edtShowData1.lines.add(inttostr(I)+'.a:'#9+inttostr(high(FBinData))+'.'+inttostr(FBOffset));

    // FrameData
    Y := 0;
    for X := 0 to high(FLevelSet.FPuzzleFields[i]) do
      AppendFrameData(i, x, y);

    x := high(FLevelSet.FPuzzleFields[i]);
    for Y := 1 to high(FLevelSet.FPuzzleFields[i][0]) - 1 do
      AppendFrameData(i, x, y);

    Y := high(FLevelSet.FPuzzleFields[i][0]);
    for X := high(FLevelSet.FPuzzleFields[i]) downto 0 do
      AppendFrameData(i, x, y);

    x := 0;
    for Y := high(FLevelSet.FPuzzleFields[i][0]) - 1 downto 1 do
      AppendFrameData(i, x, y);

    //if FBOffset = 0 then
    //edtShowData1.lines.add(inttostr(I)+'.b:'#9+inttostr(high(FBinData)+1)+'.'+inttostr(FBOffset))
    //else
    //edtShowData1.lines.add(inttostr(I)+'.b:'#9+inttostr(high(FBinData))+'.'+inttostr(FBOffset));

    // Inner Data
    for X := 1 to high(FLevelSet.FPuzzleFields[i]) - 1 do
      for Y := 1 to high(FLevelSet.FPuzzleFields[i][0]) - 1 do
      begin
        if FLevelSet.FPuzzleFields[i][X, y].FPartType in
          [ptPlayer, ptNone, ptEmpty] then
          if not FLevelSet.FPuzzleFields[i][X, y].FIsCrateTarget then
            AppendData(0, 4)
          else
            AppendData(2, 4)
        else
        if FLevelSet.FPuzzleFields[i][X, y].FPartType = ptWall then
          AppendData(1, 4)
        else
        if FLevelSet.FPuzzleFields[i][X, y].FPartType = ptCrate then
          if not FLevelSet.FPuzzleFields[i][X, y].FIsCrateTarget then
            AppendData(3, 4)
          else
            AppendData(4, 4);
      end;
  end;
  ShowData;
end;


procedure TfrmConvertLevelData.BuildLevelSet(out
  aLevelset: TPuzzleCollectionData);
var
  Magic: Integer;
  lFrame: Boolean;
  lActWidth: Integer;
  lActHeight: Integer;
  lActPlayerX: Integer;
  lActPlayerY: Integer;
  I: Integer;
  Y: Integer;
  X: Integer;

  procedure ReadFrameData(i, x, y: integer);
  begin
    if ReadData(1) = 1 then
      aLevelset.FPuzzleFields[i][X, y].FPartType :=ptWall
    else
      aLevelset.FPuzzleFields[i][X, y].FPartType :=ptEmpty;
    aLevelset.FPuzzleFields[i][X, y].FIsCrateTarget := false;
  end;

begin
  ResetRead;
  edtShowData1.Clear;
    // HEader
  Magic := ReadData(2000000000); // Magic
  lFrame := (Magic > 1002003005);
  aLevelset:= TPuzzleCollectionData.Create;
  aLevelset.Title:= readString;
  aLevelset.Description:=readString();
  aLevelset.EMail:=readString();
  aLevelset.Copyright:=readString();
  aLevelset.NumberOfLevels:= ReadData( 1000);
  aLevelset.MaxWidth:=ReadData( 30);
  aLevelset.MaxHeight:=ReadData( 20);
 // setlength(aLevelset.FPuzzleFields, aLevelset.NumberOfLevels );
   for I := 0 to aLevelset.NumberOfLevels - 1 do
  begin
    // Level-Header
    //   AppendData(i+1,1000);
  //Debug:  edtShowData1.lines.add(inttostr(I)+':'#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));

    lActWidth:=ReadData( 30);
    lActHeight:=ReadData( 20);
    setlength(aLevelset.FPuzzleFields[i],lActWidth,lActHeight);
    // Suche Player
    lActPlayerX:=ReadData( 30);
    lActPlayerY:=ReadData( 20);

  //Debug:  edtShowData1.lines.add(inttostr(I)+'.a:'#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));

    // FrameData
    Y := 0;
    for X := 0 to high(aLevelset.FPuzzleFields[i]) do
      ReadFrameData(i, x, y);

    x := high(aLevelset.FPuzzleFields[i]);
    for Y := 1 to high(aLevelset.FPuzzleFields[i][0]) - 1 do
      ReadFrameData(i, x, y);

    Y := high(aLevelset.FPuzzleFields[i][0]);
    for X := high(aLevelset.FPuzzleFields[i]) downto 0 do
      ReadFrameData(i, x, y);

    x := 0;
    for Y := high(aLevelset.FPuzzleFields[i][0]) - 1 downto 1 do
      ReadFrameData(i, x, y);

   //Debug: edtShowData1.lines.add(inttostr(I)+'.b:'#9+inttostr(FReadPos)+'.'+inttostr(FBOffset));

    // Inner Data
    for X := 1 to high(aLevelset.FPuzzleFields[i]) - 1 do
      for Y := 1 to high(aLevelset.FPuzzleFields[i][0]) - 1 do
      begin
        case readData(4) of
          1:begin
             aLevelset.FPuzzleFields[i][X, y].FPartType := ptWall;
             aLevelset.FPuzzleFields[i][X, y].FIsCrateTarget := false;
          end;
          2:begin
             aLevelset.FPuzzleFields[i][X, y].FPartType := ptNone;
             aLevelset.FPuzzleFields[i][X, y].FIsCrateTarget := true;
          end;
          3:begin
             aLevelset.FPuzzleFields[i][X, y].FPartType := ptCrate;
             aLevelset.FPuzzleFields[i][X, y].FIsCrateTarget := false;
          end;
          4:begin
             aLevelset.FPuzzleFields[i][X, y].FPartType := ptCrate;
             aLevelset.FPuzzleFields[i][X, y].FIsCrateTarget := true;
          end
          else
            begin
               if (aLevelset.FPuzzleFields[i][X-1, y].FPartType = ptEmpty) or
                  (aLevelset.FPuzzleFields[i][X+1, y].FPartType = ptEmpty) or
                  (aLevelset.FPuzzleFields[i][X, y-1].FPartType = ptEmpty) or
                  (aLevelset.FPuzzleFields[i][X, y+1].FPartType = ptEmpty) then
                  aLevelset.FPuzzleFields[i][X, y].FPartType := ptEmpty
                 else
               aLevelset.FPuzzleFields[i][X, y].FPartType := ptNone;
               aLevelset.FPuzzleFields[i][X, y].FIsCrateTarget := false;
            end
        end;
      end;
      aLevelset.FPuzzleFields[i][lActPlayerX-1, lActPlayerY-1].FPartType := ptPlayer;
   end;
end;

procedure TfrmConvertLevelData.CompareLevelsets(const LS1,
  LS2: TPuzzleCollectionData);
var
  FlOK: Boolean;
  i: Integer;
  x: Integer;
  y: Integer;
begin
  edtShowData.Clear;
  // header
  If LS1.Title = ls2.Title then
    edtShowData.Lines.add('Title OK');
  If LS1.Description = ls2.Description then
    edtShowData.Lines.add('Description OK');
  If LS1.Copyright = ls2.Copyright then
    edtShowData.Lines.add('Copyright OK');
  If LS1.EMail = ls2.EMail then
    edtShowData.Lines.add('EMail OK');
  If LS1.NumberOfLevels = ls2.NumberOfLevels then
    edtShowData.Lines.add('NumberOfLevels OK');
  If LS1.MaxWidth = ls2.MaxWidth then
    edtShowData.Lines.add('MaxWidth OK');
  If LS1.MaxHeight = ls2.MaxHeight then
    edtShowData.Lines.add('MaxHeight OK');
  If LS1.NumberOfLevels <= ls2.NumberOfLevels then
  for i := 0 to LS1.NumberOfLevels-1 do
    begin
      FlOK := High(Ls1.FPuzzleFields[i]) = high(Ls2.FPuzzleFields[i]);
      FlOK := FlOK and (High(Ls1.FPuzzleFields[i][0]) = high(Ls2.FPuzzleFields[i][0]));
      if FlOK then
      for x := 0 to High(Ls1.FPuzzleFields[i]) do
        for y := 0 to High(Ls1.FPuzzleFields[i][0]) do
          begin
            FlOK := FlOK and (Ls1.FPuzzleFields[i][x,y].FPartType =
            Ls2.FPuzzleFields[i][x,y].FPartType);
            FlOK := FlOK and (Ls1.FPuzzleFields[i][x,y].FIsCrateTarget =
            Ls2.FPuzzleFields[i][x,y].FIsCrateTarget);
          end;
  If not FlOK then
    edtShowData.Lines.add('Level'+inttostr(i+1)+': NIO');
    end;
end;

procedure TfrmConvertLevelData.btnLoadDataClick(Sender: TObject);
var
  fs: TFileStream;
begin
  if OpenDialog1.execute then
    begin
      fs := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);
    try
      setlength(FBinData,fs.Size);
      fs.ReadBuffer(FBinData[0], length(FBinData));
    finally
      FreeAndNil(fs);
    end;
      ShowData;
    end;
end;

procedure TfrmConvertLevelData.btnSaveDataClick(Sender: TObject);

var
  fs: TFileStream;
begin
  if SaveDialog1.Execute then
  begin
    if FileExists(SaveDialog1.FileName) then
      fs := TFileStream.Create(SaveDialog1.FileName, fmOpenWrite)
    else
      fs := TFileStream.Create(SaveDialog1.FileName, fmCreate + fmOpenWrite);
    try
      fs.WriteBuffer(FBinData[0], length(FBinData));
    finally
      FreeAndNil(fs);
    end;
  end;
end;

procedure TfrmConvertLevelData.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FLevelSet);
end;

procedure TfrmConvertLevelData.lbxLevelsSelectionChange(Sender: TObject; User: boolean);
type
  PPuzzleField = ^TPuzzleField;
begin
  FActLevel := PPuzzleField(lbxLevels.Items.Objects[lbxLevels.ItemIndex])^;
  dgrActLevel.ColCount := high(FActLevel) + 1;
  dgrActLevel.RowCount := high(FActLevel[0]) + 1;
  dgrActLevel.Invalidate;
end;

procedure TfrmConvertLevelData.btnOpenLFileClick(Sender: TObject);

begin
  if FileExists(edtLevelFile.Text) then
    dlgOpenLevelFile.FileName := edtLevelFile.Text;
  if dlgOpenLevelFile.Execute then
  begin
    edtLevelFile.Text := dlgOpenLevelFile.FileName;
    LoadLevelsetUnit.LoadPuzzleSet(dlgOpenLevelFile.FileName, Flevelset);
    UpdateHMI;
  end;
end;

procedure TfrmConvertLevelData.ClearData;

begin
  setlength(FBinData, 0);
  FBOffset := 0;
  FLastMax := 0;
end;

procedure TfrmConvertLevelData.AppendData(AValue: integer; MaxValue: integer);
var
  lDsZ: integer;
  Offs: integer;
  i, ValDiff: integer;

const
  Ln2 = ln(2);
  mask: array[0..7] of byte = ($0, $1, $3, $7, $f, $1f, $3f, $7f);

begin
  Offs := succ(high(FBinData));
  // Standard-Coding
  if False then
  begin
    if MaxValue < 256 then
      lDsZ := 1
    else if MaxValue < 65536 then
      lDsZ := 2
    else
      lDsZ := 4;
    setlength(FBinData, Offs + lDsZ);
    if MaxValue <> FLastMax then
      FLastVal := 0;
    ValDiff := (AValue + MaxValue + 1 - Flastval) mod (MaxValue + 1);
    for i := 0 to pred(lDsZ) do
      FBinData[Offs + i] := (ValDiff shr (i * 8)) and 255;
    FLastVal := AValue;
    FLastMax := MaxValue;
  end
  else
  begin
    // Anzahl der benötigten bits
    if FBOffset > 0 then
      Dec(Offs);
    lDsZ := trunc(ln(MaxValue) / ln2) + 1;
    if MaxValue < FLastMax then
      FLastVal := 0;
    ValDiff := (int64(AValue) + MaxValue + 1 - Flastval) mod (MaxValue + 1);
    // VBC
    if MaxValue = 4 then
    begin
      if ValDiff = 0 then
        lDsZ := 1
      else
        ValDiff := ValDiff *2-1;
    end;
    setlength(FBinData, Offs + (lDsZ + Fboffset + 7) div 8);
    for i := 0 to pred((lDsZ + Fboffset + 7) div 8) do
      if i = 0 then
        FBinData[Offs + i] := (FBinData[Offs + i] and mask[FBoffset]) or
          ((int64(ValDiff) shl Fboffset) shr (i * 8)) and 255
      else
        FBinData[Offs + i] := (FBinData[Offs + i]) or
          ((int64(ValDiff) shl Fboffset) shr (i * 8)) and 255;
    FBOffset := (lDsZ + Fboffset) mod 8;
    FLastVal := AValue;
    FLastMax := MaxValue;
  end;
end;

procedure TfrmConvertLevelData.AppendString(AString: AnsiString);
var
  ll, i: integer;
  lc: AnsiChar;
begin
  ll := length(AString);
  if ll > 255 then
    ll := 255;
  AppendData(ll);
  for i := 1 to ll do
  begin
    lc := AString[i];
    AppendData(Ord(lc));
  end;
end;

procedure TfrmConvertLevelData.ResetRead;
begin
  FReadPos := 0;
  FBOffset := 0;
  FLastMax := 255;
  FLastVal := 0;
end;

function TfrmConvertLevelData.ReadData(MaxValue: integer): integer;
const
  Ln2 = ln(2);
  mask: array[0..8] of byte = ($0, $1, $3, $7, $f, $1f, $3f, $7f, $ff);
var
  lDsZ: Integer;
  i,ValDiff: Integer;
begin
  if true then
    begin
      lDsZ := trunc(ln(MaxValue) / ln2) + 1;
      if MaxValue < FLastMax then
        FLastVal := 0;
      ValDiff := 0;
         for i := 0 to pred((lDsZ + FBOffset + 7) div 8) do
           if (i = 0) and (i = pred((lDsZ + FBOffset + 7) div 8)) then
             ValDiff :=  (FBinData[FReadPos + i]  shr Fboffset) and mask[lDsZ]
           else if (i = 0) then
             ValDiff :=  (FBinData[FReadPos + i]  shr Fboffset)
           else if i = pred((lDsZ + FBOffset + 7) div 8) then
             ValDiff := ValDiff {%H-}or (((FBinData[FReadPos + i] and mask[lDsZ+FBoffset-(i*8)]) shl (i*8)) shr Fboffset)
           else
             ValDiff := ValDiff {%H-}or ((FBinData[FReadPos + i] shl (i*8)) shr Fboffset);
       // VBC
      if MaxValue = 4 then
      begin
        if (ValDiff and 1)=0 then
          begin
            lDsZ := 1;
            ValDiff:=0;
          end
        else
          ValDiff:=(ValDiff+1) div 2;
      end;
      result :=  (ValDiff + Flastval) mod (MaxValue + 1);
      FReadPos := FReadPos + ((lDsZ+ Fboffset) div 8);
      FBOffset := (lDsZ + Fboffset) mod 8;
      FLastVal:=result;
      FLastMax:=MaxValue;
    end;
end;

function TfrmConvertLevelData.readString: AnsiString;
var
  i: Integer;
  ll: Integer;
begin
  ll := ReadData();
  setlength(result,ll);
  for i := 1 to ll do
    result[i] := AnsiChar(ReadData());
end;


procedure TfrmConvertLevelData.ShowData;
var
  lLine: string;
  i: integer;
begin
  edtShowData.Clear;
  lLine := '';
  for i := 0 to High(FBinData) do
  begin
    if (i mod 16) = 0 then // New Line
    begin
      if lLine <> '' then
        edtShowData.Lines.add(lLine);
      lLine := IntToHex(i, 4) + ':' + #9 + inttohex(FBinData[i], 2);
    end
    else if (i mod 16) = 8 then // New Line
      lLine := lLine + ' : ' + inttohex(FBinData[i], 2)
    else
      lLine := lLine + ' ' + inttohex(FBinData[i], 2);
  end;
  if lLine <> '' then
    edtShowData.Lines.add(lLine);
end;

procedure TfrmConvertLevelData.UpdateHMI;
var
  i: integer;
begin
  lbxLevels.Clear;
  for i := 0 to FLevelSet.NumberOfLevels - 1 do
    lbxLevels.AddItem('Level ' + IntToStr(i + 1), @FLevelSet.FPuzzleFields[i]);
  lbxLevels.ItemIndex:=0;
  ValueListEditor1.strings.Clear;
  ValueListEditor1.Strings.Values['Title']:=FLevelSet.Title;
  ValueListEditor1.Strings.Values['Description']:=FLevelSet.Description;
  ValueListEditor1.Strings.Values['Copyright']:=FLevelSet.Copyright;
  ValueListEditor1.Strings.Values['eMail']:=FLevelSet.EMail;
  ValueListEditor1.Strings.Values['Copyright']:=FLevelSet.Copyright;
  ValueListEditor1.Strings.Values['Levels']:=inttostr(FLevelSet.NumberOfLevels);
  ValueListEditor1.Strings.Values['MaxWidth']:=inttostr(FLevelSet.MaxWidth);
  ValueListEditor1.Strings.Values['MaxHeight']:=inttostr(FLevelSet.MaxHeight);
end;

end.
