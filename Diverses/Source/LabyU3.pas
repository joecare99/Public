Unit LabyU3;

Interface

{$INCLUDE jedi.inc}

Uses
{$IFnDEF FPC}
  jpeg, pngimage, Windows,
{$ELSE}
  LCLIntf, LCLType, JPEGLib,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, ExtDlgs, variants, unt_Point2d;

Type
  TLbyRoom = class;
  TArrayOfRooms = Array Of TLbyRoom;

  TLbyRoomItm = Class

  End;

  TLbyActiveItm = Class(TLbyRoomItm)

  End;

  TLbyPassiveItm = Class(TLbyRoomItm)
  End;

  /// <author>Rosewich</author>

  { TLbyRoom }
  TLbyRoom = Class(TCollectionItem)
  private
    { Private-Deklarationen }
    FOrt: T2dpoint;
    FFGang: TArrayOfRooms;
    FFGIndex:array of integer;

    Function GetGang(gDir: integer): TLbyRoom;
    Procedure SetGang(gDir: integer; val: TLbyRoom);

  public
    { Public-Deklarationen }
    EDir: integer;
    Token: char;

    constructor Create(ACollection: TCollection;AOrt:T2DPoint);reintroduce;
    destructor Destroy; override;

    /// <author>Rosewich</author>
    Property Ort: T2dpoint read FOrt write FOrt;

    /// <author>Rosewich</author>
    Property Gang[dDir: integer]: TLbyRoom read GetGang write SetGang; default;

  End;

  TlbyEingang = Class(TLbyRoom)

  End;

  TLbyAusgang = Class(TLbyRoom)

  End;

  TLbyGang = Class(TLbyRoom)

  End;

  TLbyEnde = Class(TLbyRoom)

  End;

  TLbyCreature = Class(TLbyActiveItm)
  End;

  TLbyPlayer = Class(TLbyCreature)
  End;

  TPutObstaclePxl = Procedure(lb:T2DPoint; value: Boolean) Of Object;
  TMakeObstacle = Procedure(Putpixel: TPutObstaclePxl) Of Object;

  { TLaby }
  TLaby = Class(TForm)
    {Form-Elements}
    btnClose: TButton;
    Button3: TButton;
    LabImage: TImage;
    Timer1: TTimer;
    btnOK: TButton;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    SavePictureDialog1: TSavePictureDialog;
    Shape1: TShape;
    ProgressBar1: TProgressBar;
    procedure Button3Click(Sender: TObject);
    Procedure LabImageClick(Sender: TObject);
    Function NewPlayer: TLbyPlayer;
    Function GetRoom(ZLbyPlayer: TLbyPlayer): TLbyRoomItm;
    Procedure btnCloseClick(Sender: TObject);
    Procedure CreateLaby;
    Procedure Timer1Timer(Sender: TObject);
    Procedure btnOKClick(Sender: TObject);
    Procedure TermML(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
    Procedure OnProgress(Sender: TObject; Progress: double);
    procedure FormResize(Sender: TObject);
  private
    { Private-Deklarationen }
    ig: tbitmap;
    FPicture : TPicture;
    FPicBitmap :TBitmap;
    Labyfinished: Boolean;

    Function GetEingang: TLbyRoom;
    Function GetRoomIndex(idx: T2DPoint): TArrayOfRooms;
    procedure SaveLabyBitmap(Lfilename: String);
  public
    { Public-Deklarationen }
    fObstacles: Array Of TMakeObstacle;
    HFont: TFont;
    HText: String;
    Lab: tbitmap;
    Laby_Width: integer;
    Laby_Length: integer;

    /// <author>Rosewich</author>
    /// <since>12.07.2008</since>
    destructor Destroy;override;
    procedure Clear;
    Procedure SaveLaby(Const Filename: String);
    /// <author>Rosewich</author>
    Procedure LoadLaby(Const Filename: String);
    Property Eingang: TLbyRoom read GetEingang;
    Property RoomIndex[idx:T2DPoint]: TArrayOfRooms Read GetRoomINdex;
  End;

Var
  Laby: TLaby;

Implementation

Uses ProgressBarU;

Const
  CMult = 2;

Type
  TProgressEvent = Procedure(Sender: TObject; ActProgress: double) Of Object;

  TStack = Class
  private
    FStack: TArrayOfRooms;
    Stackin, Stackout: integer;
    Function getActRoom: TLbyRoom;
  public
    overflow: Boolean;
    Property Room: TLbyRoom read getActRoom;
    Constructor Init(count: integer);
    Destructor done; virtual;
    Procedure Add(newRoom: TLbyRoom);
    Function GetNext: Boolean;
  End;

  { TPntStack }
  TPntStack = Class
  private
    FStack: Array Of T2dpoint;
    Stackin, Stackout: integer;
    Function getActPoint: T2dpoint;
  public
    overflow: Boolean;
    Property Point: T2dpoint read getActPoint;
    Constructor Init(count: integer);
    Destructor done; virtual;
    Procedure Add(newPoint: T2dpoint);
    Function GetNext: Boolean;
  End;

  { TMakeLaby }

  TMakeLaby = Class(TThread)
  public
    test: integer;
    // LabyBM: TBitmap;
    LabyBM_Length: integer;
    LabyBM_Width: integer;
    LabyDBM: tbitmap;
    FunctnBM: tbitmap;
    dFact: integer;
    procedure Clear;
    Destructor Destroy;override;
    Procedure Refr;
    procedure InitBM(width, Length: integer);
    Procedure SetStartPoint(x, y: integer);
  private

    { Private-Deklarationen }
    FCount: integer;
    ZStack: TStack;
    // FLaby: TLbyRoom;
    FRooms: TCollection;
    FRunMode: Boolean;
    FNibblePack: Boolean;
    FHalfNibble: Boolean;
    FLastStChar: byte;
    FOnProgress: TProgressEvent;

    FIndex: Array Of Array Of Boolean;
    FRoomIndex: Array Of Array Of TArrayOfRooms;

    Function getLBPixel(lb:T2DPoint): Boolean;
    Procedure PutLBPixel(lb:T2DPoint; value: Boolean);

    Property LBpixel[lb:T2DPoint]: Boolean read getLBPixel write PutLBPixel;
    Function NewRoomWay(Room: TLbyRoom; dir: Shortint): TLbyRoom;
    Procedure InitResultBitmap;
    function FindNewWay(Point: T2dpoint; dDir: Shortint; var dir: Shortint; dp: T2dpoint): Boolean;
  protected
    Property CCount: integer read FCount;
    Procedure Execute; override;
    procedure AppendRoomIndex(ARoom:TLbyRoom);
  public
    FEingang: TLbyRoom;
    FDebugMode: Boolean;
    Property OnProgress: TProgressEvent Read FOnProgress Write FOnProgress;
    Procedure LabyCrawl;
    Procedure WriteToStream(Const WStream: TStream);

    /// <author>Rosewich</author>

    Procedure ReadFromStream(Const RStream: TStream);
    Procedure WriteNibble(Const WStream: TStream; Const Nibble: ansichar);
    Function ReadNibble(Const WStream: TStream): ansichar;
  End;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

Var
  makelaby: TMakeLaby;

Procedure TLaby.btnCloseClick(Sender: TObject);
Begin
  hide;
  If assigned(makelaby) Then
    makelaby.DoTerminate
End;

function TLaby.NewPlayer: TLbyPlayer;

Begin
  NewPlayer := Nil;
End;

function TLaby.GetRoom(ZLbyPlayer: TLbyPlayer): TLbyRoomItm;

Begin
  GetRoom := Nil;
End;

Function TLaby.GetRoomINdex(idx: T2DPoint): TArrayOfRooms;
Begin
  If Not assigned(makelaby) Or not assigned(idx) or
    (idx.x<0) or (idx.y<0) or
    (idx.x >= makelaby.LabyBM_Width) Or
    (idx.y >= makelaby.LabyBM_Length) Then
    result := Nil
  Else
    result := makelaby.FRoomIndex[idx.x Div 4, idx.y Div 4];
End;



procedure TLaby.SaveLabyBitmap(Lfilename: String);
var
  LImage: TGraphic;
begin
  {$IFNDEF FPC}
  if uppercase(ExtractFileExt(SavePictureDialog1.Filename)) = '.PNG' then
  begin
    LImage := TPngImage.CreateBlank(COLOR_GRAYSCALE, 4,
      makelaby.LabyDBM.width, makelaby.LabyDBM.Height);
    TPngImage(LImage).Canvas.CopyRect(TPngImage(LImage).Canvas.ClipRect,
      makelaby.LabyDBM.Canvas, makelaby.LabyDBM.Canvas.ClipRect);
    TPngImage(LImage).SaveToFile(Lfilename);
    LImage.free;
  end
  else
  {$ENDIF} if uppercase(ExtractFileExt(SavePictureDialog1.Filename)) = '.JPG'
    then
  begin
    LImage := TJPEGImage.Create;
    TJPEGImage(LImage).SetSize(makelaby.LabyDBM.width,makelaby.LabyDBM.Height);
    tbitmap(LImage).Canvas.CopyRect(makelaby.LabyDBM.Canvas.ClipRect, makelaby.LabyDBM.Canvas,
      makelaby.LabyDBM.Canvas.ClipRect);
    TJPEGImage(LImage).SaveToFile(Lfilename);
    LImage.free;
  end
  else
    makelaby.LabyDBM.SaveToFile(Lfilename);
  (* Makelaby.LabyBM.SaveToFile('c:\laby_0 0.bmp'); *)
end;

destructor TLaby.Destroy;
begin
  Clear;
  setlength(fObstacles, 0);
  Inherited;
end;

procedure TLaby.Button3Click(Sender: TObject);
begin
  makelaby.LabyCrawl;
End;

Procedure TLaby.LabImageClick(Sender: TObject);
Begin
  If Not makelaby.Terminated Then
    makelaby.Suspended:=false;
End;

// ---------------------------- Stack ------------------------------------

Constructor TStack.Init;

Begin
  setlength(FStack, count);
  Stackin := 0;
  Stackout := 0;
  overflow := false;
End;

Destructor TStack.done;

Begin
  setlength(FStack, 0);
End;

Procedure TStack.Add;
Begin
  Stackin := (Stackin + 1) Mod (High(FStack) + 1);
  FStack[Stackin] := newRoom;
  If Stackin = Stackout Then
  Begin
    Stackout := (Stackout + 1) Mod (High(FStack) + 1);
    overflow := true;
  End;
End;

Function TStack.getActRoom;
Begin
  result := FStack[Stackout];
End;

Function TStack.GetNext;
Begin
  result := Stackin <> Stackout;
  If result Then
    Stackout := (Stackout + 1) Mod (High(FStack) + 1);
End;

// ---------------------------- Stack ------------------------------------

Constructor TPntStack.Init;

Begin
  setlength(FStack, count);
  Stackin := 0;
  Stackout := 0;
  overflow := false;
End;

Destructor TPntStack.done;

Begin
  setlength(FStack, 0);
End;

procedure TPntStack.Add(newPoint: T2DPoint);
Begin
  Stackin := (Stackin + 1) Mod (High(FStack) + 1);
  FStack[Stackin] := newPoint;
  If Stackin = Stackout Then
  Begin
    Stackout := (Stackout + 1) Mod (High(FStack) + 1);
    overflow := true;
  End;
End;

function TPntStack.getActPoint: T2dpoint;
Begin
  result := FStack[Stackout];
End;

function TPntStack.GetNext: Boolean;
Begin
  result := Stackin <> Stackout;
  If result Then
    Stackout := (Stackout + 1) Mod (High(FStack) + 1);
End;

// ---------------------------------------------------------------------------

Procedure myFloodfill(im: Tcanvas; p: T2dpoint; c: Tcolor; o_r, u_l: T2dpoint;
  mode: byte);

Var
  ZpStack: TPntStack;
  ocol, tc: Tcolor;
  i, j, k: integer;
  flag: Boolean;
  pp: T2dpoint;

Begin
  k := 0;
  ocol := im.pixels[p.x, p.y];
  If ocol <> c Then
    With im Do
    Begin
      ZpStack := TPntStack.Init(im.ClipRect.Right * im.ClipRect.Bottom Div 4);
      ZpStack.Add(p);
      While ZpStack.GetNext Do
      Begin
        flag := true;
        If pixels[ZpStack.Point.x, ZpStack.Point.y] = ocol Then
        Begin
          If mode > 0 Then
          Begin
            j := 1;
            While (flag) And (j <= mode) Do
            Begin
              i := 1;
              While (flag) And (i <= 12) Do
              Begin
                tc := pixels[ZpStack.Point.x + (dir12[i].x * j) Div 2,
                  ZpStack.Point.y + (dir12[i].y * j) Div 2];
                flag := flag And ((tc = c) Or (tc = ocol));
                inc(i);
              End;
              inc(j)
            End;
          End;
          If flag Then
          Begin
            pixels[ZpStack.Point.x, ZpStack.Point.y] := c;
            k := k Mod 50 + 1;
            // if k = 1 then im.update;
            For i := 1 To 4 Do
            Begin
              If (ZpStack.Point.x + dir4[i].x >= o_r.x) And
                (ZpStack.Point.x + dir4[i].x <= u_l.x) And
                (ZpStack.Point.y + dir4[i].y >= o_r.y) And
                (ZpStack.Point.y + dir4[i].y <= u_l.y) And
                (pixels[ZpStack.Point.x + dir4[i].x,
                ZpStack.Point.y + dir4[i].y] = ocol) Then
              Begin
                pp := ZpStack.Point;
                pp.Add(dir4[i]);
                ZpStack.Add(pp);
              End;
            End;
          End;
        End;
      End;
      ZpStack.done;
    End;
End;

{ Wichtig: Objektmethoden und -eigenschaften in der VCL können in Methoden
  verwendet werden, die mit Synchronize aufgerufen werden, z.B.:

  Synchronize(UpdateCaption);

  wobei UpdateCaption so aussehen könnte:

  procedure MakeLaby.UpdateCaption;
  begin
  Form1.Caption := 'Aktualisiert im Thread';
  end; }

{ MakeLaby }

Const
  Farbtab: Array [0 .. 5] Of Tcolor = (clwhite, { Freier Bereich }
    clyellow, { Waarerecht }
    clgreen, { senkrecht }
    clred, { One Way }
    clblue, { eingang zu schwarz }
    clblack); { Innen im weg }
 (*
  Uebergtab: Array [0 .. 5, 0 .. 5] Of byte = ((1, 1, 1, 4, 4, 9),
    (1, 1, 1, 1, 4, 9), (1, 1, 1, 1, 4, 9), (9, 1, 1, 1, 4, 9),
    (9, 9, 9, 9, 1, 1), (9, 9, 9, 9, 9, 1));
 *)
Procedure TLaby.CreateLaby;

Const
  df = 2;

Var
  Lab_width,
  Lab_Length,
  i: integer;

Begin

  LabImage.visible := true;
  clear;

  Lab_width := (Laby_Width div CMult) Or 1;
  Lab_Length := (Laby_length div CMult) Or 1;

  FPicBitmap := TBitmap.Create;
  FPicBitmap.Width := Lab_width *CMult*df;
  FPicBitmap.Height := Lab_Length*cMult*df;
  FPicBitmap.Canvas.Brush.color:=clwhite;
  FPicBitmap.canvas.FillRect(rect(0,0,FPicBitmap.Width,FPicBitmap.Height));

  FPicture := TPicture.Create;
  FPicture.Graphic := FPicBitmap;

  LabImage.Picture:= FPicture;
  randomize;
  { *e Ausgang und Eingang }
  Update;
  if Assigned(makelaby) then
    makelaby.clear
  else
    makelaby := TMakeLaby.Create(true);
  // makelaby.LabyDBM :=LabImage.Picture.Bitmap;
  makelaby.InitBM(Lab_width * CMult, Lab_Length * CMult);
  makelaby.SetStartPoint(0, (makelaby.LabyBM_Length Div 2) Or 1);
  makelaby.dFact := df;
  makelaby.OnProgress := OnProgress;
{$IFDEF debug}
  makelaby.FDebugMode := true;
{$ENDIF debug}
  if Laby_Length+Laby_Width > 200 then
  For i := 0 To High(fObstacles) Do
    fObstacles[i](makelaby.PutLBPixel);
{$IFDEF debug}
  makelaby.FDebugMode := false;
  MessageDlg('Done, Cont ?', mtInformation, [mbOK], 0);
{$ENDIF debug}
  makelaby.Suspended := false;

  // point.x:=(LabImage.width-tp.x) div 2 ;
  // point.y:=(((LabImage.height-tp.y) div 2)or 1)-1;

End;

procedure TLaby.FormResize(Sender: TObject);
begin
  if assigned(makelaby) and assigned(makelaby.LabyDBM) Then
          With LabImage.Picture.Bitmap.Canvas Do
          Begin
            makelaby.LabyDBM.Canvas.lock;
            try
            CopyRect(ClipRect, makelaby.LabyDBM.Canvas,
              makelaby.LabyDBM.Canvas.ClipRect);
            finally
              makelaby.LabyDBM.Canvas.unlock;
            end;
          End;

end;

function TMakeLaby.getLBPixel(lb:T2DPoint): Boolean;

Begin
  with lb do
  If  not assigned(lb) or (x <= 0) Or (y <= 0)  Or
    (x >= LabyBM_Width) Or (y >= LabyBM_Length) Then
    result := true
  Else
    result := FIndex[x, y];
  // result := LabyBM.Canvas.pixels[x, y] <> clblack
End;

procedure TMakeLaby.PutLBPixel(lb:T2DPoint; value: Boolean);

Begin
  with lb do
  If  assigned(lb) and (x > 0) And (y > 0) And
    (x < LabyBM_Width) And (y < LabyBM_Length)  Then
    FIndex[x, y] := value;
{$IFDEF debug}
  If FDebugMode And value and assigned(lb)  Then
    Laby.LabImage.Canvas.pixels[lb.x *dFact , lb.y*dFact ] := clblack;
    // Else
    // LabyBM.canvas.pixels[x, y] := clblack; *)
{$ENDIF}
End;

procedure TMakeLaby.Execute;

Var
 // flag: Boolean;
  Point, dp: T2dpoint;
  Room: TLbyRoom;
  odir, dir, dDir: Shortint;
  i: Tcolor;
  path: Variant;
  wcount: integer;
  dir1: integer;
  dir2: integer;
  Sdir: integer;
  flag2: Boolean;
  newRoom: TLbyRoom;
  LPathLength: Integer;
  gl: LongInt;
  tr: T2DPoint;

  Function getcolorFkt(c: Tcolor): byte;

  Var
    i: byte;

  Begin

    i := 5;
    While (i > 0) And (Farbtab[i] <> c) Do
      dec(i);
    getcolorFkt := i;
  End;

//Var    dCount: integer;

Begin
  FRunMode := true;
  path := vararrayof([2, 1, 12, 4, 4, 4, 6, 5, 2, 11, 12, 10, 10, 12, 2, 6, 4,
    2, 12, 10, 10, 2, 12, 2, 5, 7, 4, 1, 1, 12, 10, 10, 11, 12, 2, 6, 5, 4, 3,
    1, 11, 10, 12, 2, 6, 4, 2, 12, 10, 10, 2, 4, 3, 1, 11, 10, 12, 4, 4, 2, 10,
    10, 12, 2,
    // 12,10,10,2,
    12, 2, 5, 7, 4, 1, 1]);
  (*
  // Code is Moved to LabyDemo3
  *)
  FCount := 0;
  InitResultBitmap;
  LPathLength := vararrayhighbound(path, 1);
  While ZStack.GetNext Do
  Begin
    wcount := 0;
    Room := ZStack.Room;
    Point := Room.Ort;
    dp := T2dpoint.Init(0, 0);
    tr := T2DPoint.Init(nil);
    odir := 0;
    Sdir := 0;
    dir := 0;
    While true Do
    Begin
      // bestimme eine Richtung und eine Drehung
      If Point.x = 0 Then // Startpunkt
      Begin
        dir := 1;
        dDir := random(2) * 2;
      End
      Else If odir = 0 Then // neuer Strang
      Begin
        dDir := random(2) * 2;
        dir := random(high(dir12)+1);
      End
      Else
      Begin // Logo
        If (wcount >= 10) And (FCount < 40000) And (FCount > 10000) Then
        Begin
          If ((wcount - 10) Div 3) Mod (LPathLength + 1) = 0 Then
            Sdir := (Sdir + random(3) + 10) Mod 12 + 1;
          dir1 := path[((wcount - 10) Div 3)
            Mod (LPathLength + 1)];
          dir2 := path[((wcount - 9) Div 3)
            Mod (LPathLength + 1)];
          If abs(dir1 - dir2) <= 6 Then
            dir := ((((dir1 + dir2) Div 2) + 11 + Sdir) Mod 12) + 1
          Else
            dir := (((dir1 + dir2) Div 2 + 4 + Sdir) Mod 12) + 1;
          dDir := random(2) * 2;
        End
        Else
        Begin
          Sdir := odir;
          dir := (odir + random(3) + high(dir12)-2) Mod (high(dir12))+ 1;
          dDir := random(2) * 2;
        End;
      End;
      inc(wcount);
      dp.copy(Point);

      If FindNewWay(Point, dDir, dir, dp) Then
      Begin
        // zeichne Linie als weg
        gl := dir12[dir].glen;
        if gl>0 then
        For i := 0 To gl Do
          LBpixel[tr.copy(round(dir12[dir].x * i / gl),
            round(dir12[dir].y * i / gl)
               ).add(point)] := true;
        inc(FCount);

        // füge Punkt zum Stack hinzu, für weitere Prüfungen
        newRoom := NewRoomWay(Room, dir);
        ZStack.Add(newRoom);
        ZStack.Add(Room);

        Room := newRoom;
        Point := newRoom.Ort;
        odir := dir;
      End
      Else
        break

    End;

    dp.free;
    tr.free;
    If Not FRunMode Then
      break;
  End;
  { LabyBM.Canvas.Unlock; }
  // Synchronize(refr);
  Terminate;
End;

procedure TMakeLaby.AppendRoomIndex(ARoom: TLbyRoom);


  procedure AppendCell(var IndexCell:TArrayOfRooms;ARoom: TLbyRoom);
  begin
    setlength(IndexCell, High(IndexCell) + 2);
    IndexCell[High(IndexCell)] := ARoom;
  end;

begin
  if assigned(ARoom) then
    begin
      AppendCell(FRoomIndex[ARoom.Ort.x Div 4, ARoom.Ort.y Div 4],ARoom);
    end;
end;

function TMakeLaby.FindNewWay(Point: T2dpoint; dDir: Shortint; var
  dir: Shortint; dp: T2dpoint): Boolean;
Var
  i: Tcolor;
  j: Tcolor;
  tp: T2DPoint;
Begin
  result := false;
  i := 0;
  tp:=T2DPoint.init(nil);
  // suche einen Freien Platz um den Punkt
  While Not result And (i < high(dir12)) Do
  Begin
    // Berechne zu testenden Punkt
    dp.copy(Point);
    dp.Add(dir12[dir]);
    j := 0;
    result := dir >0;
    // Teste ob Punkt und alle 8 umliegenden Punkte frei sind
    While (j <= high(Dir8)) And result  do
    Begin
      if (tp.copy(dir12[dir]).add(Dir8[j]).MLen>1) then
        begin
          tp.add(point);
          result := result And (Not LBpixel[tp]);
        end;
      inc(j);
    End;
    If Not result Then
      dir := (dir + dDir + 10) Mod 12 + 1;
    i := i + 1;
  End;
  tp.free
End;

procedure TMakeLaby.InitResultBitmap;
Begin
  LabyDBM := tbitmap.Create;
  LabyDBM.PixelFormat := pf4bit;
  LabyDBM.Height := LabyBM_Length * dFact;
  LabyDBM.width := LabyBM_Width * dFact;
  labyDBM.canvas.brush.color := clwhite;
  labyDBM.canvas.FillRect(rect(0,0,LabyBM_Width * dFact,LabyBM_Length * dFact));
  LabyDBM.Canvas.pen.Color := clblack;
  LabyDBM.Canvas.pen.width := (dFact Div 2) + 1;
End;

function TMakeLaby.NewRoomWay(Room: TLbyRoom; dir: Shortint): TLbyRoom;
Var
  Li, nx, ny: integer;

  Function sgn(i: integer): integer; Inline;
  Begin
    If i > 0 Then
      result := 1
    Else If i < 0 Then
      result := -1
    Else
      result := 0;
  End;

Begin
  result := TLbyRoom.Create(FRooms,T2DPoint.Init(Room.Ort.x + dir12[dir].x, Room.Ort.y + dir12[dir].y));
  With result Do
  Begin
    Gang[getInvDir(dir,22)] := Room;
  End;
  Room.Gang[dir] := result;

  LabyDBM.Canvas.lock;

  { zeichne Unterlage }
  If (dFact > 1) Then
    begin
      for Li := 1 to high(dir12) do
        if assigned(Room.Gang[li]) then
          begin
            LabyDBM.Canvas.pen.Color := clGray;
            if li mod 3 = 1 then
              LabyDBM.Canvas.pen.width := dFact+1
            else
              LabyDBM.Canvas.pen.width := dFact;
            LabyDBM.Canvas.MoveTo(
              (Room.Ort.x * dFact ),
              (Room.Ort.y * dFact ));
            if dir = li then
            LabyDBM.Canvas.LineTo(
              ((Room.Ort.x + dir12[li].x) * dFact)  ,
              ((Room.Ort.y + dir12[li].y) * dFact) )
            else
            LabyDBM.Canvas.LineTo(
              ((Room.Ort.x*2 + dir12[li].x) * dFact) div 2 ,
              ((Room.Ort.y*2 + dir12[li].y) * dFact) div 2);
         End;
      for Li := 1 to high(dir12) do
        if assigned(Room.Gang[li]) then
        Begin
          LabyDBM.Canvas.pen.Color := clblack;
          LabyDBM.Canvas.pen.width := dFact - 1;
          LabyDBM.Canvas.MoveTo(Room.Ort.x * dFact, Room.Ort.y * dFact);
          if dir = li then
          LabyDBM.Canvas.LineTo(
            (Room.Ort.x + dir12[li].x) * dFact ,
            (Room.Ort.y + dir12[li].y) * dFact )
          else
          LabyDBM.Canvas.LineTo(
            (((Room.Ort.x*2 + dir12[li].x) * dFact) div 2 + dir12[li].x),
            (((Room.Ort.y*2 + dir12[li].y) * dFact) div 2 + dir12[li].y));
        End
    end
  Else
    For Li := 0 To 3 Do
      Begin
        nx := (dir12[dir].x * Li + sgn(dir12[dir].x)) Div 3;
        ny := (dir12[dir].y * Li + sgn(dir12[dir].y)) Div 3;
        LabyDBM.Canvas.pixels[(Room.Ort.x + nx) * dFact,
          (Room.Ort.y + ny) * dFact] := clblack;
      End;
  LabyDBM.Canvas.unlock;

End;

Procedure TLaby.Timer1Timer(Sender: TObject);
Begin
  If assigned(makelaby) Then
  Begin
    If Not makelaby.Terminated Then
      Try
        Label1.Caption := inttostr(makelaby.FCount);
        Labyfinished := false;
        If makelaby.Suspended Then
          Shape1.Brush.Color := clyellow
        Else
          Shape1.Brush.Color := cllime;
        If assigned(makelaby.LabyDBM) Then
          With LabImage.Picture.Bitmap.Canvas Do
          Begin
            makelaby.LabyDBM.Canvas.lock;
            try
            try
            OnProgress(self, makelaby.FCount / (Laby_Length * Laby_Width) * 6);
            CopyRect(ClipRect, makelaby.LabyDBM.Canvas,
              makelaby.LabyDBM.Canvas.ClipRect);
            except

            end;
            finally
              makelaby.LabyDBM.Canvas.unlock;
            end;
          End;
      Finally
      End
    Else
      begin
      Shape1.Brush.Color := clred;
        Label1.Caption := inttostr(makelaby.FCount);
        If assigned(makelaby.LabyDBM) and not Labyfinished Then
          With LabImage.Picture.Bitmap.Canvas Do
          Begin
            Labyfinished := true;
            makelaby.LabyDBM.Canvas.lock;
            try
            try
            OnProgress(self, makelaby.FCount / (Laby_Length * Laby_Width) * 6);
            CopyRect(rect(0,0,width,height), makelaby.LabyDBM.Canvas,
              makelaby.LabyDBM.Canvas.ClipRect);
            except

            end;
            finally
              makelaby.LabyDBM.Canvas.unlock;
            end;
          End;
        end;
  End
End;

Procedure TLaby.TermML(Sender: TObject);
Begin
  btnOK.Enabled := true;
End;

Procedure TLaby.btnOKClick(Sender: TObject);
Begin
  hide;
  If assigned(makelaby) Then
    makelaby.Terminate;
End;

destructor TMakeLaby.Destroy;
begin
  Clear;
  inherited;
end;

procedure TMakeLaby.Clear;
begin
  if assigned(FRooms) then
     begin
       FRooms.Clear;
       FreeAndNil(FRooms);
     end;
  if assigned(LabyDBM) then
    freeandnil(LabyDBM);
  if assigned(ZStack) then
    freeandnil(ZStack);
end;

procedure TMakeLaby.Refr;
Begin
  // laby.LabImage.Invalidate;
  Laby.Label1.Caption := inttostr(FCount);
  If Suspended Then
    Suspended:=false;
End;

Procedure TLaby.Button1Click(Sender: TObject);
Begin
  {$IFNDEF FPC}
   print
  {$ENDIF}
End;

Procedure TLaby.Button2Click(Sender: TObject);
Var
  Lfilename: String;
Begin
  If SavePictureDialog1.Execute Then
  Begin
    If ExtractFileExt(SavePictureDialog1.Filename) = '' Then
    Begin
      Case SavePictureDialog1.FilterIndex Of
        1:
          Lfilename := SavePictureDialog1.Filename + '.gif';
        2:
          Lfilename := SavePictureDialog1.Filename + '.png';
        3:
          Lfilename := SavePictureDialog1.Filename + '.Jpg';
        4:
          Lfilename := SavePictureDialog1.Filename + '.jpeg'
      Else
        Lfilename := SavePictureDialog1.Filename + '.bmp';
      End;
    End
    Else
      Lfilename := SavePictureDialog1.Filename;
    SaveLabyBitmap(Lfilename);
    SaveLaby(ChangeFileExt(Lfilename, '.lby'));
  End;
End;

procedure TMakeLaby.InitBM(width, Length: integer);
Begin
  (* labyBM := TBitmap.Create;
    labyBM.PixelFormat := pf1bit;
    labyBM.Height := Height;
    labyBM.width := Width; *)
  LabyBM_Width := Width;
  LabyBM_Length:= Length;

  setlength(FIndex, 0, 0);
  setlength(FRoomIndex, 0, 0, 0);
  setlength(FIndex, width, Length);
  setlength(FRoomIndex, width Div 4 + 1, Length Div 4 + 1);
  FRooms := TCollection.Create(TLbyRoom);
  (*
    With labyBM.canvas Do
    Begin
    Brush.Color := clblack;
    FillRect(cliprect);
    End; *)
End;

procedure TMakeLaby.SetStartPoint(x, y: integer);
Var
  LRoom: TLbyRoom;
Begin
  ZStack := TStack.Init(LabyBM_Width * LabyBM_Length Div 4);
  LRoom := TLbyRoom.Create(FRooms,T2dpoint.Init(x, y));
  FEingang := LRoom;
  ZStack.Add(LRoom);
End;

Function TLbyRoom.GetGang(gDir: integer): TLbyRoom;
Begin
  if (gDir >=0)
     and (gDir<=high(FFGIndex))
     and (ffgindex[gdir]>=0)
     and (ffgindex[gdir]<=high(FFGang)) then
    result := FFGang[ffgindex[gdir]]
  else
    result := nil;
End;

Procedure TLbyRoom.SetGang(gDir: integer; val: TLbyRoom);
var
  OldIdx: LongInt;
  i: Integer;
Begin
  if (gDir >=0)
     and (gDir<=high(FFGIndex)) then
     if (ffgindex[gdir] = -1) and assigned(val) then
       begin
         setlength(FFGang,high(FFGang)+2);
         ffgindex[gdir] := high(FFGang);
         FFGang[ffgindex[gdir]] := val;
       end
     else if assigned(val) then
       FFGang[ffgindex[gdir]] := val
     else
       begin
         OldIdx := ffgindex[gdir];
         ffgindex[gdir] := -1;
         if OldIdx < high(FFGang) then
           for i := 0 to high(FFGIndex) do
             if FFGIndex[i]=high(FFGang) then
               begin
                 FFGang[OldIdx] := FFGang[high(FFGang)];
                 ffgindex[gdir] := OldIdx;
                 break;
               end;
         SetLength(FFGang,high(FFGang));
       end;
End;

constructor TLbyRoom.Create(ACollection: TCollection; AOrt: T2DPoint);
var
  i: Integer;
begin
  inherited Create(ACollection);
  setlength(FFGIndex,high(Dir12)+1);
  for i := 0 to high(FFGIndex) do
    FFGIndex[i]:=-1;
  FOrt := AOrt;
end;

destructor TLbyRoom.Destroy;
begin
  if Assigned(FOrt) then
    FreeAndNil(FOrt);
  setlength(FFGIndex,0);
  setlength(FFGang,0);
  inherited Destroy;
End;

Procedure TLaby.SaveLaby(Const Filename: String);

Var
  stream: TStream;
Begin
  stream := TFileStream.Create(Filename, fmCreate);
  Try
    makelaby.WriteToStream(stream);
  Finally
    stream.free;
  End;
End;

procedure TLaby.Clear;

begin
  if Assigned(makelaby) then
    FreeAndNil(makelaby);
  if Assigned(ig) then
    FreeAndNil(ig);
  if assigned(FPicBitmap) then
    begin
      FPicture.Graphic := nil;
      freeandnil(FPicBitmap);
    end;
  if assigned(FPicture) then
    begin
      LabImage.Picture:=nil;
      freeandnil(FPicture);
    end;
end;

procedure TMakeLaby.LabyCrawl;
Var
  LRoom: TLbyRoom;
  LForeward: Boolean;
  LcDir: Integer;
  Lgc: Integer;
  LSdir: Integer;
  i: Integer;
  cc:integer;
  LTdir: Integer;

begin
  // dies ist ein Laby-Crawler
  LRoom := FEingang;
  LForeward := true;
  cc:=0;
  LcDir := 1; // (X: +1 Y:+0)

  Repeat
  Begin
    // Bestimme, Anzahl der Abgänge -> Ende, Gang, Raum
    Lgc := 0;
    LSdir := 0;
    For i := 0 To high(dir12) - 2 Do
    Begin
      LTdir := (i + getInvDir(LcDir,22)) Mod high(dir12) + 1;
      If assigned(LRoom.Gang[LTdir]) Then
      Begin
        inc(Lgc);
        If LSdir = 0 Then
          LSdir := LTdir;
      End;
    End;

    If Lgc = 0 Then // Ende
    Begin
      { $ifdef debug }
      Laby.LabImage.Picture.Bitmap.Canvas.pixels[
        LRoom.Ort.x*dFact ,
        LRoom.Ort.y*dFact ] := clred;
      // Application.ProcessMessages;
      { $endif debug }

      LcDir := getInvDir(LcDir,22);
      LRoom := LRoom.Gang[LcDir];
      LForeward := false;
    End
    Else If Lgc = 1 Then // Gang
    Begin
      If LForeward Then
      Begin
        { $ifdef debug }
        Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := cllime;
        Laby.LabImage.Picture.Bitmap.Canvas.pen.width := 1;
        Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(
          LRoom.Ort.x*dFact ,
          LRoom.Ort.y *dFact);
        Laby.LabImage.Picture.Bitmap.Canvas.LineTo
          ((LRoom.Ort.x + dir12[LSdir].x)*dFact ,
           (LRoom.Ort.y + dir12[LSdir].y)*dFact );
        // Application.ProcessMessages;
        { $endif debug }
      End;
      LcDir := LSdir;
      LRoom := LRoom.Gang[LcDir];
    End
    Else
    Begin
      If LForeward Then
      Begin // Raum
        LRoom.EDir := getInvDir(LcDir,22);
      End
      Else
      Begin
        LForeward := (LSdir <> LRoom.EDir);
      End;
      { $ifdef debug }
      If (LRoom.Ort.x + dir12[LSdir].x <> LRoom.Gang[LSdir].Ort.x) Or
        (LRoom.Ort.y + dir12[LSdir].y <> LRoom.Gang[LSdir].Ort.y) Then
        Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clyellow
      Else
        Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clblue;
      Laby.LabImage.Picture.Bitmap.Canvas.pen.width := 1;
      Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(
        LRoom.Ort.x *dFact,
        LRoom.Ort.y *dFact);
      Laby.LabImage.Picture.Bitmap.Canvas.LineTo(
        (LRoom.Ort.x + dir12[LSdir].x)*dFact ,
        (LRoom.Ort.y + dir12[LSdir].y)*dFact );
      cc := cc Mod 100 + 1;
      If cc = 1 Then
        Application.ProcessMessages;
      { $endif debug }

      LcDir := LSdir;
      LRoom := LRoom.Gang[LcDir];
    End;
    // Nächster
  End
  Until (LRoom = FEingang);

end;

procedure TMakeLaby.WriteToStream(const WStream: TStream);
Var
  LRoom: TLbyRoom;
  i: integer;
  Lgc: integer;
  LcDir: integer;
  LTdir: integer;
  LSdir: byte;
  LForeward: Boolean;
  LKennung: ShortString;
  LToken: char;
  cc: integer;
Begin
  LForeward := true;
  // dies ist ein Laby-Crawler zum speichern des Labyrinth
  // 1. Kennung
  LKennung := 'LBYv00.11' + #26;
  WStream.Write(LKennung[1], 10);
  // 2. Grungsätzliche Daten ('D',Höhe,Breite)
  LToken := 'D';
  WStream.Write(LToken, 1);
  i := LabyBM_Width;
  WStream.Write(i, sizeof(integer));
  i := LabyBM_Length;
  WStream.Write(i, sizeof(integer));
  // 3. Startpunkt
  LRoom := FEingang;
  FNibblePack := true;
  If FNibblePack Then
    LToken := 'C'
  Else
    LToken := 'S';
  WStream.Write(LToken, 1);
  WStream.Write(LRoom.Ort.x, sizeof(integer));
  WStream.Write(LRoom.Ort.y, sizeof(integer));
  //
  LcDir := 1; // (X: +1 Y:+0)
  cc := 0;
  FHalfNibble := false;

  Repeat
  Begin
    Lgc := 0;
    LSdir := 0;
    For i := 0 To high(dir12) - 2 Do
    Begin
      LTdir := (i + getInvDir(LcDir,22)) Mod high(dir12) + 1;
      If assigned(LRoom.Gang[LTdir]) Then
      Begin
        inc(Lgc);
        If LSdir = 0 Then
          LSdir := LTdir;
      End;
    End;

    If Lgc = 0 Then // Ende
    Begin
      WriteNibble(WStream, 'E');
      WriteNibble(WStream, ansichar(LcDir + 48));
      WriteNibble(WStream, #13);
      { $ifdef debug }
      Laby.LabImage.Picture.Bitmap.Canvas.pixels[
        LRoom.Ort.x * dFact,
        LRoom.Ort.y * dFact] := clred;
      // Application.ProcessMessages;
      { $endif debug }

      LcDir := getInvDir(LcDir,22);
      LRoom := LRoom.Gang[LcDir];
      LForeward := false;
    End
    Else If Lgc = 1 Then // Gang
    Begin
      If LForeward Then
      Begin
        WriteNibble(WStream, ansichar(LcDir + 48));
        { $ifdef debug }
        Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := cllime;
        Laby.LabImage.Picture.Bitmap.Canvas.pen.width := 1;
        Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(
          LRoom.Ort.x * dFact,
          LRoom.Ort.y * dFact);
        Laby.LabImage.Picture.Bitmap.Canvas.LineTo
          ((LRoom.Ort.x + dir12[LSdir].x) * dFact,
          (LRoom.Ort.y + dir12[LSdir].y) * dFact);
        // Application.ProcessMessages;
        { $endif debug }
      End;
      LcDir := LSdir;
      LRoom := LRoom.Gang[LcDir];
    End
    Else
    Begin
      If LForeward Then
      Begin // Raum
        WriteNibble(WStream, 'R');
        WriteNibble(WStream, ansichar(LcDir + 48));
        LRoom.EDir := getInvDir(LcDir,22);
      End
      Else
      Begin
        If (LSdir = LRoom.EDir) Then
          WriteNibble(WStream, #13);
        LForeward := (LSdir <> LRoom.EDir);
      End;
      { $ifdef debug }
      If (LRoom.Ort.x + dir12[LSdir].x <> LRoom.Gang[LSdir].Ort.x) Or
        (LRoom.Ort.y + dir12[LSdir].y <> LRoom.Gang[LSdir].Ort.y) Then
        Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clyellow
      Else
        Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clblue;
      Laby.LabImage.Picture.Bitmap.Canvas.pen.width := 1;
      Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(
        LRoom.Ort.x * dFact,
        LRoom.Ort.y * dFact);
      Laby.LabImage.Picture.Bitmap.Canvas.LineTo(
       (LRoom.Ort.x + dir12[LSdir].x) * dFact,
       (LRoom.Ort.y + dir12[LSdir].y) * dFact);
      cc := cc Mod 100 + 1;
      If cc = 1 Then
        Application.ProcessMessages;
      { $endif debug }

      LcDir := LSdir;
      LRoom := LRoom.Gang[LcDir];
    End;
    // Nächster
  End
  Until (LRoom = FEingang);
  If FHalfNibble Then
    WriteNibble(WStream, #0);

End;
{$IFDEF debug}

Var
  cc: integer;
{$ENDIF debug}

procedure TMakeLaby.ReadFromStream(const RStream: TStream);
Type
  tc = Class Of TLbyRoom;

  Function AppendNewRoom(Lr: TLbyRoom; TRoom: tc; LcDir: integer;
    FRooms: TCollection): TLbyRoom;
  // Inline;

  Begin
    result := TRoom.Create(FRooms,
      T2dpoint.Init(
        Lr.Ort.x + dir12[LcDir].x,
        Lr.Ort.y + dir12[LcDir].y));
    Lr.Gang[LcDir] := result;
    With result Do
    Begin
      EDir := getinvdir(LcDir,22);
      Gang[EDir] := Lr;
      AppendRoomIndex(Result);
    End;
    If TRoom = TLbyRoom Then
    Begin
      Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clblue;
      result.Token := 'R';
    End;
    If TRoom = TLbyEnde Then
    Begin
      Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clred;
      result.Token := 'E';
    End;
    If TRoom = TLbyGang Then
    Begin
      Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := cllime;
      result.Token := 'G';
    End;
{$IFDEF debug}
    Laby.LabImage.Picture.Bitmap.Canvas.pen.width := 1;
    Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(Lr.Ort.x Div CMult,
      Lr.Ort.y Div CMult);
    Laby.LabImage.Picture.Bitmap.Canvas.LineTo(result.Ort.x Div CMult,
      result.Ort.y Div CMult);
    cc := cc Mod 1000 + 1;
    If cc = 1 Then
      Application.ProcessMessages;

    // Application.ProcessMessages;
{$ENDIF debug}
  End;

Var
  LRoom: TLbyRoom;
  i: integer;
  // Lgc: integer;
  LcDir: integer;
  // LTdir: integer;
  // LSdir: byte;
 // LForeward: Boolean;
  LToken: ansichar;
  LKennung: ShortString;
  lx: integer;
  ly: integer;
Begin
 // LForeward := true;
  // dies ist ein Laby-Crawler zum speichern des Labyrinth
  // 1. Kennung
  // Rstream.Seek(0,0);
  If assigned(FRooms) Then
    FRooms.clear
  else
    FRooms:=TCollection.Create(TLbyRoom);
  LKennung := '1234567890';
  LToken := #0;
  RStream.Read(LKennung[1], 10);
  If LKennung = 'LBYv00.11' + #26 Then
    Repeat
      RStream.Read(LToken, 1);
      Case LToken Of
        'D':
          Begin
            (* If Not assigned(LabyBM) Then
              LabyBM := TBitmap.Create(); *)
            {$IFDEF FPC}
            i := integer(RStream.ReadDWord);
            {$else}
            RStream.ReadBuffer(i,sizeof(LongWord));
            {$ENDIF}
            LabyBM_Width := i;
            {$IFDEF FPC}
            i := integer(RStream.ReadDWord);
            {$else}
            RStream.ReadBuffer(i,sizeof(LongWord));
            {$ENDIF}
            LabyBM_Length := i;
            setlength(FIndex, 0, 0);
            setlength(FRoomIndex, 0, 0, 0);
            setlength(FIndex, LabyBM_Width, LabyBM_Length);
            setlength(FRoomIndex, LabyBM_Width Div 4 + 1,
              LabyBM_Length Div 4 + 1);
            (*
              LabyBM.height:=LabyBM_Length;
              LabyBM.width:=LabyBM_Width;
              LabyBM.Canvas.Brush.Color := clblack;
              LabyBM.Canvas.FillRect(rect(0, 0, LabyBM_Width, LabyBM_Length)); *)
          End;
        'S', 'C':
          Begin
            FNibblePack := LToken = 'C';
            {$IFDEF FPC}
              lx := integer(RStream.ReadDWord);
              ly := integer(RStream.Readdword);
            {$else}
            RStream.ReadBuffer(lx,sizeof(LongWord));
            RStream.ReadBuffer(ly,sizeof(LongWord));
            {$ENDIF}
            FEingang := TlbyEingang.Create(FRooms,T2dpoint.Init(lx, ly));
            LRoom := FEingang;
            FHalfNibble := false;
            Repeat
              LToken := ReadNibble(RStream);
              Case LToken Of
                'E':
                  Begin
                    LToken := ReadNibble(RStream);
                    LcDir := ord(LToken) - 48;
                    LRoom := AppendNewRoom(LRoom, TLbyEnde, LcDir, FRooms);
                  End;
                'R':
                  Begin
                    LToken := ReadNibble(RStream);
                    LcDir := ord(LToken) - 48;
                    LRoom := AppendNewRoom(LRoom, TLbyRoom, LcDir, FRooms);

                  End;
                #13:
                  Begin (* return *)
                    Repeat
                      LRoom := LRoom.Gang[LRoom.EDir];
                    Until LRoom.ClassType <> TLbyGang;
                  End

              Else
                Begin
                  LcDir := ord(LToken) - 48;
                  LRoom := AppendNewRoom(LRoom, TLbyGang, LcDir, FRooms);
                End;
              End;
              If (RStream.Position Mod 1000 = 0) And assigned(FOnProgress) Then
                FOnProgress(self, RStream.Position / RStream.size);

            Until (LRoom.ClassType = TlbyEingang) Or (Not assigned(LRoom));
            If assigned(LRoom) Then
            Begin

            End;

          End;
      End;
      If assigned(FOnProgress) Then
        FOnProgress(self, RStream.Position / RStream.size);

    Until RStream.Position = RStream.size
  Else
    MessageDlg('Falsche Version', mtWarning, [mbOK], 0);
  // Falsche Version
End;

Const
  code: ShortString = '0123456789'#58#59#60#13'RE';

Procedure TLaby.LoadLaby(Const Filename: String);
Var
  LStream: TStream;
Begin
  LStream := TFileStream.Create(Filename, fmOpenRead);

  If assigned(makelaby) Then
    makelaby.clear
  else
    makelaby := TMakeLaby.Create(true);
  makelaby.OnProgress := OnProgress;
  makelaby.ReadFromStream(LStream);
  Laby_Length := makelaby.LabyBM_Length;
  Laby_Width := makelaby.LabyBM_Width;
  LStream.free;
End;

procedure TMakeLaby.WriteNibble(const WStream: TStream; const Nibble: ansichar);
Var
  i: integer;
  LC: byte;
Begin
  If Not FNibblePack Then
  Begin
    WStream.Write(byte(Nibble), 1);
    FHalfNibble := false;
  End
  Else
  Begin
    LC := 0;
    For i := 1 To 16 Do
      If Nibble = code[i] Then
        LC := i - 1;
    If FHalfNibble Then
    Begin
      FLastStChar := FLastStChar + LC * 16;
      WStream.Write(FLastStChar, 1);
      FLastStChar := 0;
      FHalfNibble := false;
    End
    Else
    Begin
      FLastStChar := LC;
      FHalfNibble := true;
    End;
  End;
End;

function TMakeLaby.ReadNibble(const WStream: TStream): ansichar;

Begin
  If Not FNibblePack Then
  Begin
    WStream.Read(FLastStChar, 1);
    result := ansichar(FLastStChar);
  End
  Else If FHalfNibble Then
  Begin
    result := code[FLastStChar Div 16 + 1];
    FHalfNibble := false;
  End
  Else
  Begin
    WStream.Read(FLastStChar, 1);
    result := code[byte(FLastStChar) And 15 + 1];
    FHalfNibble := true;
  End;

End;

Function TLaby.GetEingang: TLbyRoom;
Begin
  If assigned(makelaby) Then
    result := makelaby.FEingang
  Else
    result := Nil;
End;

Procedure TLaby.OnProgress(Sender: TObject; Progress: double);

Begin
  ProgressBar1.Position := trunc(Progress * ProgressBar1.Max);
  Application.ProcessMessages;
End;

End.

{
* \_/| _ _  _  //    _ _  _    _
*    |// \\// //    // || ||/\//
*    ||| |  | \\   ||  || |||  |
*   // \_|  \__\\_/ \_/ \/ ||  \_
*   \|

  12,1,2,11,11,11,10,12,3, }
