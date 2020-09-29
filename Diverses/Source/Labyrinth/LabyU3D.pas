unit LabyU3D;

interface

{$INCLUDE jedi.inc}

uses
{$IFnDEF FPC}
    jpeg, pngimage, Windows,
{$ELSE}
  LCLIntf, LCLType, JPEGLib,
{$ENDIF}
    SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ExtCtrls, ComCtrls, StdCtrls, ExtDlgs, PrintersDlgs, variants, unt_Point3d;

type
    TLbyRoom = class;
    TArrayOfRooms = array of TLbyRoom;

    TLbyRoomItm = class

    end;

    TLbyActiveItm = class(TLbyRoomItm)

    end;

    TLbyPassiveItm = class(TLbyRoomItm)
    end;

    /// <author>Rosewich</author>

    { TLbyRoom }
    TLbyRoom = class(TCollectionItem)
    private
        { Private-Deklarationen }
        FOrt: T3dpoint;
        FFGang: TArrayOfRooms;
        FFGIndex: array of integer;

        function GetGang(gDir: integer): TLbyRoom;
        procedure SetGang(gDir: integer; val: TLbyRoom);

    public
        { Public-Deklarationen }

        EDir: integer;
        Token: char;
        FDirCount: integer;

        constructor Create(ACollection: TCollection; AOrt: T3DPoint); reintroduce;
        destructor Destroy; override;

        /// <author>Rosewich</author>
        property Ort: T3DPoint read FOrt write FOrt;

        /// <author>Rosewich</author>
        property Gang[dDir: integer]: TLbyRoom read GetGang write SetGang; default;

    end;

    TlbyEingang = class(TLbyRoom)

    end;

    TLbyAusgang = class(TLbyRoom)

    end;

    TLbyGang = class(TLbyRoom)

    end;

    TLbyEnde = class(TLbyRoom)

    end;

    TLbyCreature = class(TLbyActiveItm)
    end;

    TLbyPlayer = class(TLbyCreature)
    end;

    TPut3DObstaclePxl = procedure(lb: T3DPoint; Value: boolean) of object;
    TMakeObstacle = procedure(Putpixel: TPut3DObstaclePxl) of object;

    { TLaby }

    TLaby = class(TForm)
        {Form-Elements}
        btnClose: TButton;
        btnDraw: TButton;
        btnPrint2: TButton;
        btnPrint3: TButton;
        LabImage: TImage;
        pnlBottom: TPanel;
        PrintDialog1: TPrintDialog;
        Timer1: TTimer;
        btnOK: TButton;
        btnPrint: TButton;
        btnSave: TButton;
        Label1: TLabel;
        SavePictureDialog1: TSavePictureDialog;
        shpState: TShape;
        ProgressBar1: TProgressBar;
        procedure btnDrawClick(Sender: TObject);
        procedure btnPrint2Click(Sender: TObject);
        procedure btnPrint3Click(Sender: TObject);
        procedure LabImageClick(Sender: TObject);
        function NewPlayer: TLbyPlayer;
        function GetRoom(ZLbyPlayer: TLbyPlayer): TLbyRoomItm;
        procedure btnCloseClick(Sender: TObject);
        procedure CreateLaby;
        procedure Timer1Timer(Sender: TObject);
        procedure btnOKClick(Sender: TObject);
        procedure TermML(Sender: TObject);
        procedure btnPrintClick(Sender: TObject);
        procedure btnSaveClick(Sender: TObject);
        procedure OnProgress(Sender: TObject; Progress: double);
        procedure FormResize(Sender: TObject);
    private
        { Private-Deklarationen }
        ig: tbitmap;
        FPicture: TPicture;
        FPicBitmap: TBitmap;
        Labyfinished: boolean;

        procedure DrawRoom(Sender: TObject; aRoom: TLbyRoom; inDir, outDir: integer);
        procedure DrawRoom2(Sender: TObject; room: TLbyRoom; inDir,
          outDir: integer);
        function GetEingang: TLbyRoom;
        function GetRoomIndex(idx: T3DPoint): TArrayOfRooms;
        procedure SaveLabyBitmap(Lfilename: string);
    public
        { Public-Deklarationen }
        fObstacles: array of TMakeObstacle;
        HFont: TFont;
        HText: string;
        Lab: tbitmap;
        Laby_Height_: integer;
        Laby_Length: integer;
        Laby_Width: integer;

        /// <author>Rosewich</author>
        /// <since>12.07.2008</since>
        destructor Destroy; override;
        procedure Clear;
        procedure SaveLaby(const Filename: string);
        /// <author>Rosewich</author>
        procedure LoadLaby(const Filename: string);
        property Eingang: TLbyRoom read GetEingang;
        property RoomIndex[idx: T3DPoint]: TArrayOfRooms read GetRoomINdex;
    end;

var
    Laby: TLaby;

implementation

uses ProgressBarU, Printers;

const
    CMult = 1;

type
    TProgressEvent = procedure(Sender: TObject; ActProgress: double) of object;
    TRoomCallback = procedure(Sender: TObject; room: TLbyRoom;
        inDir, outDir: integer) of object;

    TStack = class
    private
        FStack: TArrayOfRooms;
        Stackin, Stackout: integer;
        function getActRoom: TLbyRoom;
    public
        overflow: boolean;
        property Room: TLbyRoom read getActRoom;
        constructor Init(Count: integer);
        destructor done; virtual;
        procedure Add(newRoom: TLbyRoom);
        function GetNext: boolean;
    end;

    { TPntStack }

    TPntStack = class
    private
        FStack: array of T3dpoint;
        Stackin, Stackout: integer;
        function getActPoint: T3dpoint;
    public
        overflow: boolean;
        property Point: T3dpoint read getActPoint;
        constructor Init(Count: integer);
        destructor done; virtual;
        procedure Add(newPoint: T3DPoint);
        function GetNext: boolean;
    end;

    { TMakeLaby }

    TMakeLaby = class(TThread)
    public
        test: integer;
        // LabyBM: TBitmap;
        LabyBM_Height_: integer;
        LabyBM_Width: integer;
        LabyBM_Length: integer;

        LabyDBM: tbitmap;
        FunctnBM: tbitmap;
        dFact: integer;
        procedure Clear;
        destructor Destroy; override;
        procedure Refr;
        procedure InitBM(Width, Length, Height: integer);
        procedure SetStartPoint(x, y, z: integer);
    private

        { Private-Deklarationen }
        FCount: integer;
        ZStack: TStack;
        // FLaby: TLbyRoom;

        dir27: TArrayOF3DPoint;

        FRooms: TCollection;
        FRunMode: boolean;
        FNibblePack: boolean;
        FHalfNibble: boolean;
        FLastStChar: byte;
        FOnProgress: TProgressEvent;

        FIndex: array of array of array of boolean;
        FRoomIndex: array of array of array of TArrayOfRooms;

        function getIpPixel(x, y, z: integer): Tcolor;
        function getLBPixel(lb: T3DPoint): boolean;
        procedure PutLBPixel(lb: T3DPoint; Value: boolean);

        property LBpixel[lb: T3DPoint]: boolean read getLBPixel write PutLBPixel;
        function NewRoomWay(Room: TLbyRoom; dir: shortint; flag2: boolean): TLbyRoom;
        procedure InitResultBitmap;
        function FindNewWay(Point: T3DPoint; dDir: shortint;
            var dir: shortint; out flag2: boolean; dp: T3DPoint): boolean;
    protected
        property CCount: integer read FCount;
        procedure Execute; override;
        procedure AppendRoomIndex(ARoom: TLbyRoom);
    public
        FEingang: TLbyRoom;
        FDebugMode: boolean;
        property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
        procedure LabyCrawl(Callback: TRoomCallback; Foreward: bool = True;
            FilterLevel: integer = -1);
        procedure LabyCrawlV(Canvas: TCanvas = nil; HighRun: boolean = False);
        procedure WriteToStream(const WStream: TStream);

        /// <author>Rosewich</author>

        procedure ReadFromStream(const RStream: TStream);
        procedure WriteNibble(const WStream: TStream; const Nibble: ansichar);
        function ReadNibble(const WStream: TStream): ansichar;

    end;

{$IFnDEF FPC}
  {$R *.dfm}

{$ELSE}
  {$R *.lfm}
{$ENDIF}

var
    makelaby: TMakeLaby;

procedure TLaby.btnCloseClick(Sender: TObject);
begin
    hide;
    if assigned(makelaby) then
        makelaby.DoTerminate;
end;

function TLaby.NewPlayer: TLbyPlayer;

begin
    NewPlayer := nil;
end;

function TLaby.GetRoom(ZLbyPlayer: TLbyPlayer): TLbyRoomItm;

begin
    GetRoom := nil;
end;

function TLaby.GetRoomIndex(idx: T3DPoint): TArrayOfRooms;
begin
    if not assigned(makelaby) or not assigned(idx) or (idx.x < 0) or
        (idx.y < 0) or (idx.z < 0) or (idx.x >= makelaby.LabyBM_Width) or
        (idx.y >= makelaby.LabyBM_Length) or (idx.z >= makelaby.LabyBM_height_) then
        Result := nil
    else
        Result := makelaby.FRoomIndex[idx.x div 4, idx.y div 4, idx.z div 4];
end;

procedure TLaby.SaveLabyBitmap(Lfilename: string);
var
    LImage: TGraphic;
begin
  {$IFNDEF FPC}
    if uppercase(ExtractFileExt(SavePictureDialog1.Filename)) = '.PNG' then
      begin
        LImage := TPngImage.CreateBlank(COLOR_GRAYSCALE, 4,
            makelaby.LabyDBM.Width, makelaby.LabyDBM.Height);
        TPngImage(LImage).Canvas.CopyRect(TPngImage(LImage).Canvas.ClipRect,
            makelaby.LabyDBM.Canvas, makelaby.LabyDBM.Canvas.ClipRect);
        TPngImage(LImage).SaveToFile(Lfilename);
        LImage.Free;
      end
    else
  {$ENDIF}
    if uppercase(ExtractFileExt(SavePictureDialog1.Filename)) = '.JPG' then
      begin
        LImage := TJPEGImage.Create;
        TJPEGImage(LImage).SetSize(makelaby.LabyDBM.Width, makelaby.LabyDBM.Height);
        tbitmap(LImage).Canvas.CopyRect(makelaby.LabyDBM.Canvas.ClipRect,
            makelaby.LabyDBM.Canvas,
            makelaby.LabyDBM.Canvas.ClipRect);
        TJPEGImage(LImage).SaveToFile(Lfilename);
        LImage.Free;
      end
    else
        makelaby.LabyDBM.SaveToFile(Lfilename);
    (* Makelaby.LabyBM.SaveToFile('c:\laby_0 0.bmp'); *)
end;

destructor TLaby.Destroy;
begin
    Clear;
    setlength(fObstacles, 0);
    inherited;
end;

procedure TLaby.btnDrawClick(Sender: TObject);
begin
    makelaby.LabyCrawlV(nil, True);
    makelaby.LabyCrawlV;
end;

var
    pCanvas: TCanvas;
    cFactX, cFactY: double;
    DrawShaddow:boolean;

procedure TLaby.btnPrint2Click(Sender: TObject);
begin
   {$IFNDEF FPC}
    print;
    {$else}
    if PrintDialog1.Execute then
       begin
         printer.Orientation := poLandscape;
         printer.Title := 'Laby #3 ' + DateToStr(now());
         Printer.BeginDoc;
         printer.Canvas.Pen.Color:=clBlack;
         printer.Canvas.AntialiasingMode:=amOn;
         pCanvas:=printer.Canvas;
         cFactX := printer.canvas.cliprect.Width / (makelaby.LabyBM_Width + 1);
         cFactY := printer.Canvas.cliprect.Height / makelaby.LabyBM_Length;
         printer.Canvas.Pen.Width:=trunc(0.1 *cFactY)+1;
         makelaby.LabyCrawl(DrawRoom,False);
         Printer.EndDoc;
       end;
   {$ENDIF}
end;

procedure TLaby.btnPrint3Click(Sender: TObject);
begin
  {$IFNDEF FPC}
    print;
    {$else}
    if PrintDialog1.Execute then
       begin
         printer.Orientation := poLandscape;
         printer.Title := 'Laby #3 ' + DateToStr(now());
         Printer.BeginDoc;
         printer.Canvas.Pen.Color:=clBlack;
         printer.Canvas.AntialiasingMode:=amOn;
         pCanvas:=printer.Canvas;
         cFactX := printer.canvas.cliprect.Width / (makelaby.LabyBM_Width + 1);
         cFactY := printer.Canvas.cliprect.Height / makelaby.LabyBM_Length;
         printer.Canvas.Pen.Width:=trunc(0.1 *cFactY)+1;
         DrawShaddow := true;
         makelaby.LabyCrawl(DrawRoom2,true,-1);
         DrawShaddow := false;
         makelaby.LabyCrawl(DrawRoom2,true,2);
         makelaby.LabyCrawl(DrawRoom2,true,3);
         makelaby.LabyCrawl(DrawRoom2,true,4);
         Printer.EndDoc;
       end;
   {$ENDIF}
end;

procedure TLaby.LabImageClick(Sender: TObject);
begin
    if not makelaby.Terminated then
        makelaby.Suspended := False;
end;

// ---------------------------- Stack ------------------------------------

constructor TStack.Init;

begin
    setlength(FStack, Count);
    Stackin := 0;
    Stackout := 0;
    overflow := False;
end;

destructor TStack.done;

begin
    setlength(FStack, 0);
end;

procedure TStack.Add;
begin
    Stackin := (Stackin + 1) mod (High(FStack) + 1);
    FStack[Stackin] := newRoom;
    if Stackin = Stackout then
      begin
        Stackout := (Stackout + 1) mod (High(FStack) + 1);
        overflow := True;
      end;
end;

function TStack.getActRoom;
begin
    Result := FStack[Stackout];
end;

function TStack.GetNext;
begin
    Result := Stackin <> Stackout;
    if Result then
        Stackout := (Stackout + 1) mod (High(FStack) + 1);
end;

// ---------------------------- Stack ------------------------------------

constructor TPntStack.Init(Count: integer);

begin
    setlength(FStack, Count);
    Stackin := 0;
    Stackout := 0;
    overflow := False;
end;

destructor TPntStack.done;

begin
    setlength(FStack, 0);
end;

procedure TPntStack.Add(newPoint: T3DPoint);
begin
    Stackin := (Stackin + 1) mod (High(FStack) + 1);
    FStack[Stackin] := newPoint;
    if Stackin = Stackout then
      begin
        Stackout := (Stackout + 1) mod (High(FStack) + 1);
        overflow := True;
      end;
end;

function TPntStack.getActPoint: T3dpoint;
begin
    Result := FStack[Stackout];
end;

function TPntStack.GetNext: boolean;
begin
    Result := Stackin <> Stackout;
    if Result then
        Stackout := (Stackout + 1) mod (High(FStack) + 1);
end;

// ---------------------------------------------------------------------------

procedure myFloodfill(im: Tcanvas; p: T3dpoint; c: Tcolor; o_r, u_l: T3dpoint;
    mode: byte);

var
    ZpStack: TPntStack;
    ocol, tc: Tcolor;
    i, j, k: integer;
    flag: boolean;
    pp: T3DPoint;

begin
    k := 0;
    ocol := im.pixels[p.x, p.y];
    if ocol <> c then
        with im do
          begin
            ZpStack := TPntStack.Init(im.ClipRect.Right * im.ClipRect.Bottom div 4);
            ZpStack.Add(p);
            while ZpStack.GetNext do
              begin
                flag := True;
                if pixels[ZpStack.Point.x, ZpStack.Point.y] = ocol then
                  begin
                    if mode > 0 then
                      begin
                        j := 1;
                        while (flag) and (j <= mode) do
                          begin
                            i := 1;
                            while (flag) and (i <= 12) do
                              begin
                                tc :=
                                    pixels[ZpStack.Point.x + (dir3d22[i].x * j) div 2,
                                    ZpStack.Point.y + (dir3d22[i].y * j) div 2];
                                flag := flag and ((tc = c) or (tc = ocol));
                                Inc(i);
                              end;
                            Inc(j);
                          end;
                      end;
                    if flag then
                      begin
                        pixels[ZpStack.Point.x, ZpStack.Point.y] := c;
                        k := k mod 50 + 1;
                        // if k = 1 then im.update;
                        for i := 1 to 4 do
                          begin
                            if (ZpStack.Point.x + dir3d1[i].x >= o_r.x) and
                                (ZpStack.Point.x + dir3d1[i].x <= u_l.x) and
                                (ZpStack.Point.y + dir3d1[i].y >= o_r.y) and
                                (ZpStack.Point.y + dir3d1[i].y <= u_l.y) and
                                (pixels[ZpStack.Point.x + dir3d1[i].x,
                                ZpStack.Point.y + dir3d1[i].y] = ocol) then
                              begin
                                pp := ZpStack.Point;
                                pp.Add(dir3d1[i]);
                                ZpStack.Add(pp);
                              end;
                          end;
                      end;
                  end;
              end;
            ZpStack.done;
          end;
end;

{ Wichtig: Objektmethoden und -eigenschaften in der VCL können in Methoden
  verwendet werden, die mit Synchronize aufgerufen werden, z.B.:

  Synchronize(UpdateCaption);

  wobei UpdateCaption so aussehen könnte:

  procedure MakeLaby.UpdateCaption;
  begin
  Form1.Caption := 'Aktualisiert im Thread';
  end; }

{ MakeLaby }

const
    Farbtab: array [0 .. 5] of Tcolor = (clwhite, { Freier Bereich }
        clyellow, { Waarerecht }
        clgreen, { senkrecht }
        clred, { One Way }
        clblue, { eingang zu schwarz }
        clblack);

{ Innen im weg }
 (*
  Uebergtab: Array [0 .. 5, 0 .. 5] Of byte = ((1, 1, 1, 4, 4, 9),
    (1, 1, 1, 1, 4, 9), (1, 1, 1, 1, 4, 9), (9, 1, 1, 1, 4, 9),
    (9, 9, 9, 9, 1, 1), (9, 9, 9, 9, 9, 1));
 *)
procedure TLaby.CreateLaby;

const
    df = 2;

var
    Lab_width, Lab_Length, i: integer;
    tp, o: T3DPoint;

begin

    LabImage.Visible := True;
    Clear;

    Lab_width := (Laby_Width div CMult) or 1;
    Lab_Length := (Laby_length div CMult) or 1;

    FPicBitmap := TBitmap.Create;
    FPicBitmap.Width := Lab_width * CMult * df;
    FPicBitmap.Height := Lab_Length * cMult * df;
    FPicBitmap.Canvas.Brush.color := clwhite;
    FPicBitmap.canvas.FillRect(rect(0, 0, FPicBitmap.Width, FPicBitmap.Height));

    FPicture := TPicture.Create;
    FPicture.Graphic := FPicBitmap;

    LabImage.Picture := FPicture;
    randomize;
    { *e Ausgang und Eingang }
    Update;
    if Assigned(makelaby) then
        makelaby.Clear
    else
        makelaby := TMakeLaby.Create(True);
    // makelaby.LabyDBM :=LabImage.Picture.Bitmap;
    makelaby.InitBM(Lab_width * CMult, Lab_Length * CMult, 6);
    makelaby.SetStartPoint(0, (makelaby.LabyBM_Length div 2) or 1,
        (makelaby.LabyBM_height_ div 2) or 1);
    makelaby.dFact := df;
    makelaby.OnProgress := OnProgress;

    tp := T3DPoint.init(0, 0, 0);
    o := makelaby.FEingang.Ort;
    for i := 0 to makelaby.LabyBM_height_ - 1 do
      begin
        makelaby.PutLBPixel(tp.Copy(makelaby.LabyBM_Width - 2, o.y, i), True);
        makelaby.PutLBPixel(tp.Copy(makelaby.LabyBM_Width - 4, o.y, i), True);
      end;
    FreeAndNil(tp);
{$IFDEF debug}
  makelaby.FDebugMode := true;
{$ENDIF debug}
    if Laby_Length + Laby_Width > 200 then
        for i := 0 to High(fObstacles) do
            fObstacles[i](makelaby.PutLBPixel);
{$IFDEF debug}
  makelaby.FDebugMode := false;
  MessageDlg('Done, Cont ?', mtInformation, [mbOK], 0);
{$ENDIF debug}

    makelaby.Suspended := False;

    // point.x:=(LabImage.width-tp.x) div 2 ;
    // point.y:=(((LabImage.height-tp.y) div 2)or 1)-1;

end;

procedure TLaby.FormResize(Sender: TObject);
begin
    if assigned(makelaby) and assigned(makelaby.LabyDBM) then
        with LabImage.Picture.Bitmap.Canvas do
          begin
            makelaby.LabyDBM.Canvas.lock;
              try
                CopyRect(ClipRect, makelaby.LabyDBM.Canvas,
                    makelaby.LabyDBM.Canvas.ClipRect);
              finally
                makelaby.LabyDBM.Canvas.unlock;
              end;
          end;

end;

function TMakeLaby.getIpPixel(x, y, z: integer): Tcolor;

begin
    getIpPixel := Laby.ig.Canvas.pixels[x, y];
end;

function TMakeLaby.getLBPixel(lb: T3DPoint): boolean;

begin
    with lb do
        if not assigned(lb) or (x <= 0) or (y <= 0) or (z <= 0) or
            (x >= LabyBM_Width) or (y >= LabyBM_Length) or (z >= LabyBM_Height_) then
            Result := True
        else
            Result := FIndex[x, y, z];
    // result := LabyBM.Canvas.pixels[x, y] <> clblack
end;

procedure TMakeLaby.PutLBPixel(lb: T3DPoint; Value: boolean);

begin
    with lb do
        if assigned(lb) and (x > 0) and (y > 0) and (z > 0) and
            (x < LabyBM_Width) and (y < LabyBM_Length) and (z < LabyBM_Height_) then
            FIndex[x, y, z] := Value;
{$IFDEF debug}
  If FDebugMode And value and assigned(lb)  Then
    Laby.LabImage.Canvas.pixels[lb.x *dFact , lb.y*dFact ] := clblack;
    // Else
    // LabyBM.canvas.pixels[x, y] := clblack; *)
{$ENDIF}
end;

procedure TMakeLaby.Execute;

var
    // flag: Boolean;
    Point, dp: T3DPoint;
    Room: TLbyRoom;
    odir, dir, dDir: shortint;
    i: Tcolor;
    path: variant;
    wcount: integer;
    dir1: integer;
    dir2: integer;
    Sdir: integer;
    flag2: boolean;
    newRoom: TLbyRoom;
    LPathLength: integer;
    gl: longint;
    tr: T3DPoint;

    function getcolorFkt(c: Tcolor): byte;

    var
        i: byte;

    begin

        i := 5;
        while (i > 0) and (Farbtab[i] <> c) do
            Dec(i);
        getcolorFkt := i;
    end;

    //Var    dCount: integer;

begin
    FRunMode := True;
    path := vararrayof([2, 1, 12, 4, 4, 4, 6, 5, 2, 11, 12, 10, 10,
        12, 2, 6, 4, 2, 12, 10, 10, 2, 12, 2, 5, 7, 4, 1, 1, 12, 10,
        10, 11, 12, 2, 6, 5, 4, 3, 1, 11, 10, 12, 2, 6, 4, 2, 12, 10,
        10, 2, 4, 3, 1, 11, 10, 12, 4, 4, 2, 10, 10, 12, 2,
        // 12,10,10,2,
        12, 2, 5, 7, 4, 1, 1]);
  (*
  // Code is Moved to LabyDemo3
  *)
    FCount := 0;
    InitResultBitmap;
    LPathLength := vararrayhighbound(path, 1);
    while ZStack.GetNext do
      begin
        wcount := 0;
        Room := ZStack.Room;
        Point := Room.Ort;
        dp := T3DPoint.Init(nil);
        tr := T3DPoint.Init(nil);
        odir := 0;
        Sdir := 0;
        dir := 0;
        while True do
          begin
            // bestimme eine Richtung und eine Drehung
            if Point.x = 0 then // Startpunkt
              begin
                dir := 1;
                dDir := random(2) * 2;
              end
            else if odir = 0 then // neuer Strang
              begin
                dDir := random(2) * 2;
                dir := random(high(dir27) + 1);
              end
            else
              begin // Logo
                if (wcount >= 10) and (FCount < 40000) and (FCount > 10000) then
                  begin
                    if ((wcount - 10) div 3) mod (LPathLength + 1) = 0 then
                        Sdir := (Sdir + random(3) + 10) mod 12 + 1;
                    dir1 := path[((wcount - 10) div 3) mod (LPathLength + 1)];
                    dir2 := path[((wcount - 9) div 3) mod (LPathLength + 1)];
                    if abs(dir1 - dir2) <= 6 then
                        dir := ((((dir1 + dir2) div 2) + 11 + Sdir) mod 12) + 1
                    else
                        dir := (((dir1 + dir2) div 2 + 4 + Sdir) mod 12) + 1;
                    dDir := random(2) * 2;
                  end
                else
                  begin
                    Sdir := odir;
                    dir := (odir + random(3) + high(dir27) - 2) mod (high(dir27)) + 1;
                    dDir := random(2) * 2;
                  end;
              end;
            Inc(wcount);
            dp.copy(Point);

            if FindNewWay(Point, dDir, dir, flag2, dp) then
              begin
                // zeichne Linie als weg
                gl := dir27[dir].glen;
                if gl > 0 then
                    for i := 0 to gl do
                        LBpixel[tr.copy(round(dir27[dir].x * i / gl),
                            round(dir27[dir].y * i / gl),
                            round(dir27[dir].z * i / gl)).add(point)] := True;
                Inc(FCount);

                // füge Punkt zum Stack hinzu, für weitere Prüfungen
                newRoom := NewRoomWay(Room, dir, flag2);
                ZStack.Add(newRoom);
                ZStack.Add(Room);

                Room := newRoom;
                Point := newRoom.Ort;
                odir := dir;
              end
            else
                break;

          end;

        dp.Free;
        tr.Free;
        if not FRunMode then
            break;
      end;
    { LabyBM.Canvas.Unlock; }
    // Synchronize(refr);
    Terminate;
end;

procedure TMakeLaby.AppendRoomIndex(ARoom: TLbyRoom);


    procedure AppendCell(var IndexCell: TArrayOfRooms; ARoom: TLbyRoom);
    begin
        setlength(IndexCell, High(IndexCell) + 2);
        IndexCell[High(IndexCell)] := ARoom;
    end;

begin
    if assigned(ARoom) then
      begin
        AppendCell(FRoomIndex[ARoom.Ort.x div 4, ARoom.Ort.y div 4,
            ARoom.Ort.z div 4], ARoom);
      end;
end;

function TMakeLaby.FindNewWay(Point: T3DPoint; dDir: shortint;
    var dir: shortint; out flag2: boolean; dp: T3DPoint): boolean;
var
    i: Tcolor;
    j: Tcolor;
    tp: T3DPoint;
begin
    Result := False;
    i := 0;
    tp := T3DPoint.init(nil);
    // suche einen Freien Platz um den Punkt
    while not Result and (i < high(dir27)) do
      begin
        // Berechne zu testenden Punkt
        dp.copy(Point);
        dp.Add(dir27[dir]);
        j := 0;
        Result := dir > 0;
        // Teste ob Punkt und alle 26 umliegenden Punkte frei sind
        while (j <= high(Dir3D15)) and Result do
          begin
            if (tp.copy(dir27[dir]).add(Dir3D15[j]).MLen > 1) or (dir27[dir].z <> 0) then
              begin
                tp.add(Point);
                Result := Result and (not LBpixel[tp]);
              end;
            Inc(j);
          end;
        // spezial
        tp.copy(dp);
        tp.z := 6 - tp.z;
        Result := Result and (not LBpixel[tp]);

        if not Result then
            dir := (dir + dDir + 10) mod 12 + 1 +
                ((4 - ddir + (ddir - 1) * (i div 12)) mod 3) * 12;
        i := i + 1;
      end;
    tp.Free;
end;

procedure TMakeLaby.InitResultBitmap;
begin
    LabyDBM := tbitmap.Create;
    LabyDBM.PixelFormat := pf4bit;
    LabyDBM.Height := LabyBM_Length * dFact;
    LabyDBM.Width := LabyBM_Width * dFact;
    labyDBM.canvas.brush.color := clwhite;
    labyDBM.canvas.FillRect(rect(0, 0, LabyBM_Width * dFact, LabyBM_Length * dFact));
    LabyDBM.Canvas.pen.Color := clblack;
    LabyDBM.Canvas.pen.Width := (dFact div 2) + 1;
end;

function TMakeLaby.NewRoomWay(Room: TLbyRoom; dir: shortint; flag2: boolean): TLbyRoom;
var
    Li, nx, ny: integer;

    function sgn(i: integer): integer; inline;
    begin
        if i > 0 then
            Result := 1
        else if i < 0 then
            Result := -1
        else
            Result := 0;
    end;

begin
    Result := TLbyRoom.Create(FRooms, T3DPoint.Init(Room.Ort.x +
        dir27[dir].x, Room.Ort.y + dir27[dir].y, Room.Ort.z + dir27[dir].z));
    Result.EDir := getInvDir(dir, 22);
    Result.Gang[Result.EDir] := Room;
    with Room do
      begin
        Gang[dir] := Result;
        Inc(FDirCount);
        if Token = 'E' then
            Token := 'G'
        else
            Token := 'R';
      end;

    LabyDBM.Canvas.lock;

    { zeichne Unterlage }
    if (dFact > 1) then
      begin
        for Li := 1 to high(dir27) do
            if assigned(Room.Gang[li]) then
              begin
                LabyDBM.Canvas.pen.Color := clGray;
                if li mod 3 = 1 then
                    LabyDBM.Canvas.pen.Width := dFact + 2
                else
                    LabyDBM.Canvas.pen.Width := dFact + 1;
                LabyDBM.Canvas.MoveTo(
                    (Room.Ort.x * dFact),
                    (Room.Ort.y * dFact));
                LabyDBM.Canvas.LineTo(
                    ((Room.Ort.x * 2 + dir27[li].x) * dFact) div 2,
                    ((Room.Ort.y * 2 + dir27[li].y) * dFact) div 2);
              end;
        for Li := 1 to high(dir27) do
            if assigned(Room.Gang[li]) then
              begin
                LabyDBM.Canvas.pen.Color := clblack;
                LabyDBM.Canvas.pen.Width := dFact;

                LabyDBM.Canvas.MoveTo(Room.Ort.x * dFact, Room.Ort.y * dFact);
                LabyDBM.Canvas.LineTo(
                    (((Room.Ort.x * 2 + dir27[li].x) * dFact) div 2 + dir27[li].x),
                    (((Room.Ort.y * 2 + dir27[li].y) * dFact) div 2 + dir27[li].y));
              end;
      end
    else
        for Li := 0 to 3 do
          begin
            nx := (dir27[dir].x * Li + sgn(dir27[dir].x)) div 3;
            ny := (dir27[dir].y * Li + sgn(dir27[dir].y)) div 3;
            LabyDBM.Canvas.pixels[(Room.Ort.x + nx) * dFact,
                (Room.Ort.y + ny) * dFact] := clblack;
          end;
    LabyDBM.Canvas.unlock;

end;

procedure TLaby.Timer1Timer(Sender: TObject);

begin
    if assigned(makelaby) then
      begin
        if not makelaby.Terminated then
              try
                Label1.Caption := IntToStr(makelaby.FCount);
                Labyfinished := False;
                if makelaby.Suspended then
                    shpState.Brush.Color := clyellow
                else
                    shpState.Brush.Color := cllime;
                if assigned(makelaby.LabyDBM) then
                    with LabImage.Picture.Bitmap.Canvas do
                      begin
                        makelaby.LabyDBM.Canvas.lock;
                          try
                            if (Laby_Length * Laby_Width) > 0 then
                                  try
                                    OnProgress(self, makelaby.FCount /
                                        (Laby_Length * Laby_Width) * 6);
                                    CopyRect(ClipRect, makelaby.LabyDBM.Canvas,
                                        makelaby.LabyDBM.Canvas.ClipRect);
                                  except

                                  end;
                          finally
                            makelaby.LabyDBM.Canvas.unlock;
                          end;
                      end;
              finally
              end
        else
          begin
            shpState.Brush.Color := clred;
            Label1.Caption := IntToStr(makelaby.FCount);
            if assigned(makelaby.LabyDBM) and not Labyfinished then
                with LabImage.Picture.Bitmap.Canvas do
                  begin
                    Labyfinished := True;
                    makelaby.LabyDBM.Canvas.lock;
                      try
                          try
                            OnProgress(self, makelaby.FCount /
                                (Laby_Length * Laby_Width) * 6);
                            CopyRect(ClipRect, makelaby.LabyDBM.Canvas,
                                makelaby.LabyDBM.Canvas.ClipRect);
                          except

                          end;
                      finally
                        makelaby.LabyDBM.Canvas.unlock;
                      end;
                  end;
          end;
      end;
end;

procedure TLaby.TermML(Sender: TObject);
begin
    btnOK.Enabled := True;
end;

procedure TLaby.btnOKClick(Sender: TObject);
begin
    hide;
    if assigned(makelaby) then
        makelaby.Terminate;
end;

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
        FreeAndNil(LabyDBM);
    if assigned(ZStack) then
        FreeAndNil(ZStack);
end;

procedure TMakeLaby.Refr;
begin
    // laby.LabImage.Invalidate;
    Laby.Label1.Caption := IntToStr(FCount);
    if Suspended then
        Suspended := False;
end;

procedure TLaby.btnPrintClick(Sender: TObject);
begin
  {$IFDEF FPC}
  if PrintDialog1.Execute then
     begin
       printer.Orientation := poLandscape;
       printer.Title := 'Laby #3 ' + DateToStr(now());
   //    printer.FileName :=  'Laby_#3d_' + DateToStr(now())+'*.pdf';
       Printer.BeginDoc;
       printer.Canvas.Pen.Color:=clBlack;
       printer.Canvas.brush.Color:=clLtGray;
       printer.Canvas.Pen.Width:=2;

       printer.Canvas.AntialiasingMode:=amOn;
       makelaby.LabyCrawlV(printer.Canvas,false);
       printer.Canvas.Pen.Color:=clDkGray shr 1;
       printer.Canvas.brush.Color:=clWhite;
       makelaby.LabyCrawlV(printer.Canvas,true);
       Printer.EndDoc;
     end;
  {$ENDIF}
end;

procedure TLaby.btnSaveClick(Sender: TObject);

var
    Lfilename: string;

begin
    if SavePictureDialog1.Execute then
      begin
        if ExtractFileExt(SavePictureDialog1.Filename) = '' then
          begin
            case SavePictureDialog1.FilterIndex of
                1:
                    Lfilename := SavePictureDialog1.Filename + '.gif';
                2:
                    Lfilename := SavePictureDialog1.Filename + '.png';
                3:
                    Lfilename := SavePictureDialog1.Filename + '.Jpg';
                4:
                    Lfilename := SavePictureDialog1.Filename + '.jpeg'
                else
                    Lfilename := SavePictureDialog1.Filename + '.bmp';
              end;
          end
        else
            Lfilename := SavePictureDialog1.Filename;
        SaveLabyBitmap(Lfilename);
        SaveLaby(ChangeFileExt(Lfilename, '.lby'));
      end;
end;

procedure TMakeLaby.InitBM(Width, Length, Height: integer);
begin
  (* labyBM := TBitmap.Create;
    labyBM.PixelFormat := pf1bit;
    labyBM.Height := Height;
    labyBM.width := Width; *)
    LabyBM_Height_ := Height;
    LabyBM_Length := Length;
    LabyBM_Width := Width;
    setlength(FIndex, 0, 0, 0);
    setlength(FRoomIndex, 0, 0, 0);
    setlength(FIndex, Width, Length, Height);
    setlength(FRoomIndex, Width div 4 + 1, Length div 4 + 1, Height div 4 + 1);
    FRooms := TCollection.Create(TLbyRoom);
    dir27 := Dir3D22;
    setlength(dir27, 37);
  (*
    With labyBM.canvas Do
    Begin
    Brush.Color := clblack;
    FillRect(cliprect);
    End; *)
end;

procedure TMakeLaby.SetStartPoint(x, y, z: integer);
var
    LRoom: TLbyRoom;
begin
    ZStack := TStack.Init(LabyBM_Width * LabyBM_Length div 4);
    LRoom := TLbyRoom.Create(FRooms, T3DPoint.Init(x, y, z));
    FEingang := LRoom;
    ZStack.Add(LRoom);
end;

function TLbyRoom.GetGang(gDir: integer): TLbyRoom;
begin
    if (gDir >= 0) and (gDir <= high(FFGIndex)) and (ffgindex[gdir] >= 0) and
        (ffgindex[gdir] <= high(FFGang)) then
        Result := FFGang[ffgindex[gdir]]
    else
        Result := nil;
end;

procedure TLbyRoom.SetGang(gDir: integer; val: TLbyRoom);
var
    OldIdx: longint;
    i: integer;
begin
    if (gDir >= 0) and (gDir <= high(FFGIndex)) then
        if (ffgindex[gdir] = -1) and assigned(val) then
          begin
            setlength(FFGang, high(FFGang) + 2);
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
                    if FFGIndex[i] = high(FFGang) then
                      begin
                        FFGang[OldIdx] := FFGang[high(FFGang)];
                        ffgindex[gdir] := OldIdx;
                        break;
                      end;
            SetLength(FFGang, high(FFGang));
          end;
end;

constructor TLbyRoom.Create(ACollection: TCollection; AOrt: T3DPoint);
var
    i: integer;
begin
    inherited Create(ACollection);
    setlength(FFGIndex, high(Dir3D22) + 1);
    for i := 0 to high(FFGIndex) do
        FFGIndex[i] := -1;
    FOrt := AOrt;
    Token := 'E';
    FDirCount := 1;
end;

destructor TLbyRoom.Destroy;
begin
    if Assigned(FOrt) then
        FreeAndNil(FOrt);
    setlength(FFGIndex, 0);
    setlength(FFGang, 0);
    inherited Destroy;
end;

procedure TLaby.SaveLaby(const Filename: string);

var
    stream: TStream;
begin
    stream := TFileStream.Create(Filename, fmCreate);
      try
        makelaby.WriteToStream(stream);
      finally
        stream.Free;
      end;
end;

procedure TLaby.Clear;

begin
    if Assigned(makelaby) then
        FreeAndNil(makelaby);
    if Assigned(ig) then
        FreeAndNil(ig);
    if assigned(FPicBitmap) then
      begin
        FPicture.Graphic := nil;
        FreeAndNil(FPicBitmap);
      end;
    if assigned(FPicture) then
      begin
        LabImage.Picture := nil;
        FreeAndNil(FPicture);
      end;
end;

procedure TMakeLaby.LabyCrawl(Callback: TRoomCallback; Foreward: bool = True;
    FilterLevel: integer = -1);
var
    LRoom: TLbyRoom;
    LForeward: boolean;
    LcDir: integer;
    Lgc: integer;
    lOutDir: integer;
    i: integer;
    lInDir, lTestDir, J: integer;
    lTick, sTick: QWord;

begin
    // dies ist ein Laby-Crawler
    LRoom := FEingang;
    LForeward := True;
    LcDir := 1; // (X: +1 Y:+0)
    lTick := GetTickCount64;
    if assigned(Callback) then
        Callback(self, LRoom, 7, 1);
    repeat
          begin
            // Bestimme, Anzahl der Abgänge -> Ende, Gang, Raum
            Lgc := 0;
            lOutDir := 0;
            lInDir := getInvDir(LcDir, 22);
            for i := 1 to high(dir27) - 1 do
              begin
                //                J:=i;
                J := (i div 3) + (i mod 3) * 12;
                lTestDir := (J + (lInDir - 1) mod 12) mod high(dir27) + 1;
                if (lTestDir <> lInDir) and assigned(LRoom.Gang[lTestDir]) then
                  begin
                    Inc(Lgc);
                    if lOutDir = 0 then
                        lOutDir := lTestDir;
                  end;
              end;

            if Lgc = 0 then // Ende
              begin
                if (FilterLevel = -1) or (LRoom.Ort.z = FilterLevel) then
                  begin
                    { $ifdef debug }
                    Laby.LabImage.Picture.Bitmap.Canvas.pixels[
                        LRoom.Ort.x * dFact,
                        LRoom.Ort.y * dFact] := clred;
                    // Application.ProcessMessages;
                    { $endif debug }
                    if assigned(Callback) then
                        Callback(self, LRoom, lInDir, lInDir);
                  end;
                LcDir := LRoom.EDir;
                LRoom := LRoom.Gang[LcDir];
                LForeward := False;
              end
            else if Lgc = 1 then // Gang
              begin
                if (FilterLevel = -1) or (LRoom.Ort.z = FilterLevel) then
                  begin
                    if LForeward then
                      begin
                        { $ifdef debug }
                        case LRoom.Ort.z of
                            1: Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clRed;
                            2: Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clgreen;
                            3: Laby.LabImage.Picture.Bitmap.Canvas.pen.Color :=
                                    RGBToColor(255, 128, 0);
                            4: Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := cllime;
                            5: Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clLtGray;
                          end;
                        Laby.LabImage.Picture.Bitmap.Canvas.pen.Width := 1;
                        Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(
                            LRoom.Ort.x * dFact,
                            LRoom.Ort.y * dFact);
                        Laby.LabImage.Picture.Bitmap.Canvas.LineTo
                        ((LRoom.Ort.x + dir27[lOutDir].x) * dFact,
                            (LRoom.Ort.y + dir27[lOutDir].y) * dFact);

                        // Application.ProcessMessages;
                        { $endif debug }
                        if assigned(Callback) then
                            Callback(self, LRoom, lInDir, lOutDir);
                      end
                    else
                    if assigned(Callback) and not Foreward then
                        Callback(self, LRoom, lInDir, lOutDir);
                  end;
                if LForeward then
                    LcDir := lOutDir
                else
                    LcDir := Lroom.EDir;
                LRoom := LRoom.Gang[LcDir];
              end
            else
              begin
                if not LForeward then
                    LForeward := (lOutDir <> LRoom.EDir);

                if (FilterLevel = -1) or (LRoom.Ort.z = FilterLevel) then
                  begin
                    { $ifdef debug }
                    if (LRoom.Ort.x + dir27[lOutDir].x <> LRoom.Gang[lOutDir].Ort.x) or
                        (LRoom.Ort.y + dir27[lOutDir].y <>
                        LRoom.Gang[lOutDir].Ort.y) then
                        Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clyellow
                    else
                        Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clblue;
                    Laby.LabImage.Picture.Bitmap.Canvas.pen.Width := 1;
                    Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(
                        LRoom.Ort.x * dFact,
                        LRoom.Ort.y * dFact);
                    Laby.LabImage.Picture.Bitmap.Canvas.LineTo(
                        (LRoom.Ort.x + dir27[lOutDir].x) * dFact,
                        (LRoom.Ort.y + dir27[lOutDir].y) * dFact);

                    if assigned(Callback) and (not Foreward or (lInDir = Lroom.EDir)) then
                        Callback(self, LRoom, lInDir, lOutDir);
                  end;

                sTick := GetTickCount64;
                if sTick - lTick > 100 then
                  begin
                    Application.ProcessMessages;
                    lTick := sTick;
                  end;
                { $endif debug }

                LcDir := lOutDir;
                LRoom := LRoom.Gang[LcDir];
              end;
            // Nächster
          end
    until (LRoom = FEingang);
end;

procedure TMakeLaby.LabyCrawlV(Canvas: TCanvas; HighRun: boolean);
var
    LRoom: TLbyRoom;
    LForeward: boolean;
    LcDir: integer;
    Lgc: integer;
    LSdir: integer;
    i: integer;
    LTdir: integer;
    cFactX, cFactY: extended;
    lTick, sTick: QWord;
    PenColor, FillColor, BgrColor: TColor;

const
    WaySize = 0.5;
    ZFact = 0.025;
begin
    // dies ist ein Laby-Crawler
    LRoom := FEingang;
    LForeward := True;
    LcDir := 1; // (X: +1 Y:+0)
    lTick := GetTickCount64;
    if assigned(canvas) then
      begin
        cFactX := canvas.ClipRect.Width / (LabyBM_Width + 1);
        cFactY := canvas.ClipRect.Height / LabyBM_Length;
        PenColor := Canvas.Pen.Color;
        FillColor := Canvas.Brush.Color;
      end;
    repeat
          begin
            // Bestimme, Anzahl der Abgänge -> Ende, Gang, Raum
            Lgc := 0;
            LSdir := 0;
            for i := 0 to high(dir27) - 2 do
              begin
                LTdir := (i + getInvDir(LcDir, 22)) mod high(dir27) + 1;
                if assigned(LRoom.Gang[LTdir]) then
                  begin
                    Inc(Lgc);
                    if LSdir = 0 then
                        LSdir := LTdir;
                  end;
              end;

            LTdir := getInvDir(LcDir, 22);
            if Lgc = 0 then // Ende
              begin
                { $ifdef debug }
                if ((HighRun and (LRoom.Ort.z >= 3)) or
                    (not HighRun and (LRoom.Ort.z <= 3))) then
                  begin
                    Laby.LabImage.Picture.Bitmap.Canvas.pixels[
                        LRoom.Ort.x * dFact,
                        LRoom.Ort.y * dFact] := clred;
                  end;
                // Application.ProcessMessages;
                { $endif debug }
                if assigned(Canvas) and ((HighRun and (LRoom.Ort.z >= 3)) or
                    (not HighRun and (LRoom.Ort.z <= 3))) then
                  begin
                    Canvas.pen.Color := PenColor;
                    Canvas.pen.Width :=
                        trunc((WaySize + 0.2 + ZFact * LRoom.Ort.z) * cFactX);
                    Canvas.MoveTo
                    (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.5 +
                        ZFact * (LRoom.Ort.z + dir27[LTdir].z * 0.5)) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LTdir].y * 0.5 +
                        ZFact * (LRoom.Ort.z + dir27[LTdir].z * 0.5)) * cFactY));
                    Canvas.LineTo
                    (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.20 +
                        ZFact * LRoom.Ort.z) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LTdir].y * 0.20 +
                        ZFact * LRoom.Ort.z) * cFactY));

                    Canvas.pen.Width := trunc((0.1 + ZFact * LRoom.Ort.z) * cFactX);
                    Canvas.pen.Color := PenColor;
                    Canvas.Ellipse(trunc((LRoom.Ort.x - 0.5 * WaySize) * cFactX),
                        trunc((LRoom.Ort.y - 0.5 * WaySize) * cFactY),
                        trunc((LRoom.Ort.x + 0.5 * WaySize) * cFactX),
                        trunc((LRoom.Ort.y + 0.5 * WaySize) * cFactY));

                    Canvas.pen.Width := trunc(WaySize * cFactX);
                    Canvas.pen.Color := FillColor;
                    Canvas.MoveTo
                    (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.7) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LTdir].y * 0.7) * cFactY));
                    Canvas.LineTo
                    (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.10) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LTdir].y * 0.10) * cFactY));
                  end;
                LcDir := getInvDir(LcDir, 22);
                LRoom := LRoom.Gang[LcDir];
                LForeward := False;
              end
            else if Lgc = 1 then // Gang
              begin
                if LForeward then
                  begin
                    { $ifdef debug }
                    if ((HighRun and (LRoom.Ort.z >= 3)) or
                        (not HighRun and (LRoom.Ort.z <= 3))) then
                      begin
                        if HighRun then
                            Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := cllime
                        else
                            Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clGreen;
                        Laby.LabImage.Picture.Bitmap.Canvas.pen.Width := 1;
                        Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(
                            LRoom.Ort.x * dFact,
                            LRoom.Ort.y * dFact);
                        Laby.LabImage.Picture.Bitmap.Canvas.LineTo
                        ((LRoom.Ort.x + dir27[LSdir].x) * dFact,
                            (LRoom.Ort.y + dir27[LSdir].y) * dFact);
                      end;
                    // Application.ProcessMessages;
                    { $endif debug }
                    if assigned(Canvas) and ((HighRun and (LRoom.Ort.z >= 3)) or
                        (not HighRun and (LRoom.Ort.z <= 3))) then
                      begin
                        Canvas.pen.Color := PenColor;
                        Canvas.pen.Width :=
                            trunc((WaySize + 0.2 + ZFact * LRoom.Ort.z) * cFactX);
                        Canvas.MoveTo
                        (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.5 +
                            ZFact * (LRoom.Ort.z + dir27[LTdir].z * 0.5)) * cFactX),
                            trunc(
                            (LRoom.Ort.y + dir27[LTdir].y * 0.5 + ZFact *
                            (LRoom.Ort.z + dir27[LTdir].z * 0.5)) * cFactY));
                        Canvas.LineTo
                        (trunc(
                            (LRoom.Ort.x + dir27[LTdir].x * 0.25 + ZFact * LRoom.Ort.z) * cFactX),
                            trunc(
                            (LRoom.Ort.y + dir27[LTdir].y * 0.25 + ZFact * LRoom.Ort.z) * cFactY));
                        Canvas.LineTo
                        (trunc(
                            (LRoom.Ort.x + dir27[LSdir].x * 0.25 + ZFact * LRoom.Ort.z) * cFactX),
                            trunc(
                            (LRoom.Ort.y + dir27[LSdir].y * 0.25 + ZFact * LRoom.Ort.z) * cFactY));
                        Canvas.LineTo
                        (trunc((LRoom.Ort.x + dir27[LSdir].x * 0.5 +
                            ZFact * (LRoom.Ort.z + dir27[LSdir].z * 0.5)) * cFactX),
                            trunc(
                            (LRoom.Ort.y + dir27[LSdir].y * 0.5 + ZFact *
                            (LRoom.Ort.z + dir27[LSdir].z * 0.5)) * cFactY));
                        Canvas.pen.Width := trunc(WaySize * cFactX);
                        Canvas.pen.Color := FillColor;
                        Canvas.MoveTo
                        (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.7) * cFactX),
                            trunc((LRoom.Ort.y + dir27[LTdir].y * 0.7) * cFactY));
                        Canvas.LineTo
                        (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.25) * cFactX),
                            trunc((LRoom.Ort.y + dir27[LTdir].y * 0.25) * cFactY));
                        Canvas.LineTo
                        (trunc((LRoom.Ort.x + dir27[LSdir].x * 0.25) * cFactX),
                            trunc((LRoom.Ort.y + dir27[LSdir].y * 0.25) * cFactY));
                        Canvas.LineTo
                        (trunc((LRoom.Ort.x + dir27[LSdir].x * 0.7) * cFactX),
                            trunc((LRoom.Ort.y + dir27[LSdir].y * 0.7) * cFactY));
                      end;
                  end;
                LcDir := LSdir;
                LRoom := LRoom.Gang[LcDir];
              end
            else
              begin
                if LForeward then
                  begin // Raum
                    LRoom.EDir := getInvDir(LcDir, 22);
                  end
                else
                  begin
                    LForeward := (LSdir <> LRoom.EDir);
                  end;
                { $ifdef debug }
                if ((HighRun and (LRoom.Ort.z >= 3)) or
                    (not HighRun and (LRoom.Ort.z <= 3))) then
                  begin

                    if (LRoom.Ort.x + dir27[LSdir].x <> LRoom.Gang[LSdir].Ort.x) or
                        (LRoom.Ort.y + dir27[LSdir].y <> LRoom.Gang[LSdir].Ort.y) then
                        Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clyellow
                    else
                        Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clblue;
                    Laby.LabImage.Picture.Bitmap.Canvas.pen.Width := 1;
                    Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(
                        LRoom.Ort.x * dFact,
                        LRoom.Ort.y * dFact);
                    Laby.LabImage.Picture.Bitmap.Canvas.LineTo(
                        (LRoom.Ort.x + dir27[LSdir].x) * dFact,
                        (LRoom.Ort.y + dir27[LSdir].y) * dFact);
                  end;
                if assigned(Canvas) and ((HighRun and (LRoom.Ort.z >= 3)) or
                    (not HighRun and (LRoom.Ort.z <= 3))) then
                  begin
                    Canvas.pen.Color := PenColor;
                    Canvas.pen.Width :=
                        trunc((WaySize + 0.2 + ZFact * LRoom.Ort.z) * cFactX);
                    Canvas.MoveTo
                    (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.5 +
                        ZFact * (LRoom.Ort.z + dir27[LTdir].z * 0.5)) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LTdir].y * 0.5 +
                        ZFact * (LRoom.Ort.z + dir27[LTdir].z * 0.5)) * cFactY));
                    Canvas.LineTo
                    (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.25 +
                        ZFact * LRoom.Ort.z) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LTdir].y * 0.25 +
                        ZFact * LRoom.Ort.z) * cFactY));
                    Canvas.LineTo
                    (trunc((LRoom.Ort.x + dir27[LSdir].x * 0.25 +
                        ZFact * LRoom.Ort.z) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LSdir].y * 0.25 +
                        ZFact * LRoom.Ort.z) * cFactY));
                    Canvas.LineTo
                    (trunc((LRoom.Ort.x + dir27[LSdir].x * 0.5 +
                        ZFact * (LRoom.Ort.z + dir27[LSdir].z * 0.5)) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LSdir].y * 0.5 +
                        ZFact * (LRoom.Ort.z + dir27[LSdir].z * 0.5)) * cFactY));

                    Canvas.pen.Width := trunc(WaySize * cFactX);
                    Canvas.pen.Color := FillColor;
                    Canvas.MoveTo
                    (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.7) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LTdir].y * 0.7) * cFactY));
                    Canvas.LineTo
                    (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.25) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LTdir].y * 0.25) * cFactY));
                    Canvas.LineTo
                    (trunc((LRoom.Ort.x + dir27[LSdir].x * 0.25) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LSdir].y * 0.25) * cFactY));
                    Canvas.LineTo
                    (trunc((LRoom.Ort.x + dir27[LSdir].x * 0.7) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LSdir].y * 0.7) * cFactY));
                    Canvas.LineTo
                    (trunc((LRoom.Ort.x) * cFactX),
                        trunc((LRoom.Ort.y) * cFactY));
                    Canvas.LineTo
                    (trunc((LRoom.Ort.x + dir27[LTdir].x * 0.7) * cFactX),
                        trunc((LRoom.Ort.y + dir27[LTdir].y * 0.7) * cFactY));
                    Canvas.Ellipse(trunc((LRoom.Ort.x - 0.5 * WaySize) * cFactX),
                        trunc((LRoom.Ort.y - 0.5 * WaySize) * cFactY),
                        trunc((LRoom.Ort.x + 0.5 * WaySize) * cFactX),
                        trunc((LRoom.Ort.y + 0.5 * WaySize) * cFactY));
                  end;

                sTick := GetTickCount64;
                if sTick - lTick > 100 then
                  begin
                    Application.ProcessMessages;
                    lTick := sTick;
                  end;
                { $endif debug }

                LcDir := LSdir;
                LRoom := LRoom.Gang[LcDir];
              end;
            // Nächster
          end
    until (LRoom = FEingang);
    if Assigned(Canvas) then
        Canvas.pen.Color := PenColor;
end;

procedure TMakeLaby.WriteToStream(const WStream: TStream);
var
    LRoom: TLbyRoom;
    i: integer;
    Lgc: integer;
    LcDir: integer;
    LTdir: integer;
    LSdir: byte;
    LForeward: boolean;
    LKennung, st: ShortString;
    LToken: char;
    cc: integer;

begin
    LForeward := True;
    // dies ist ein Laby-Crawler zum speichern des Labyrinth
    // 1. Kennung
    LKennung := 'LBYv00.12' + #26;
    WStream.Write(LKennung[1], 10);
    // 2. Grungsätzliche Daten ('D',Breite,Länge,Höhe)
    if FNibblePack then
        LToken := 'C'
    else
        LToken := 'D';
    WStream.Write(LToken, 1);
    if FNibblePack then
      begin
        WStream.Write(LabyBM_Width, sizeof(integer));
        WStream.Write(LabyBM_Length, sizeof(integer));
        WStream.Write(LabyBM_Height_, sizeof(integer));
      end
    else
      begin
        st := IntToStr(LabyBM_Width) + ',' + IntToStr(LabyBM_Length) +
            ',' + IntToStr(LabyBM_Height_) + #13;
        WStream.Write(st[1], length(st));
      end;
    // 3. Startpunkt
    LRoom := FEingang;
    FNibblePack := False;
    LToken := 'S';
    WStream.Write(LToken, 1);
    if FNibblePack then
      begin
        WStream.Write(LRoom.Ort.x, sizeof(integer));
        WStream.Write(LRoom.Ort.y, sizeof(integer));
        WStream.Write(LRoom.Ort.z, sizeof(integer));
      end
    else
      begin
        st := IntToStr(LRoom.Ort.x) + ',' + IntToStr(LRoom.Ort.y) +
            ',' + IntToStr(LRoom.Ort.z) + #13;
        WStream.Write(st[1], length(st));
      end;

    LcDir := 1; // (X: +1 Y:+0)
    cc := 0;
    FHalfNibble := False;

    repeat
          begin
            Lgc := 0;
            LSdir := 0;
            for i := 0 to high(dir27) - 2 do
              begin
                LTdir := (i + getInvDir(LcDir, 22)) mod high(dir27) + 1;
                if assigned(LRoom.Gang[LTdir]) then
                  begin
                    Inc(Lgc);
                    if LSdir = 0 then
                        LSdir := LTdir;
                  end;
              end;

            if Lgc = 0 then // Ende
              begin
                WriteNibble(WStream, 'E');
                WriteNibble(WStream, ansichar(LcDir + 96));
                WriteNibble(WStream, #13);
                { $ifdef debug }
                Laby.LabImage.Picture.Bitmap.Canvas.pixels[LRoom.Ort.x div CMult,
                    LRoom.Ort.y div CMult] := clred;
                // Application.ProcessMessages;
                { $endif debug }

                LcDir := getInvDir(LcDir, 22);
                LRoom := LRoom.Gang[LcDir];
                LForeward := False;
              end
            else if Lgc = 1 then // Gang
              begin
                if LForeward then
                  begin
                    WriteNibble(WStream, ansichar(LcDir + 96));
                    { $ifdef debug }
                    Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := cllime;
                    Laby.LabImage.Picture.Bitmap.Canvas.pen.Width := 1;
                    Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(LRoom.Ort.x div CMult,
                        LRoom.Ort.y div CMult);
                    Laby.LabImage.Picture.Bitmap.Canvas.LineTo
                    ((LRoom.Ort.x + dir27[LSdir].x) div CMult,
                        (LRoom.Ort.y + dir27[LSdir].y) div CMult);
                    // Application.ProcessMessages;
                    { $endif debug }
                  end;
                LcDir := LSdir;
                LRoom := LRoom.Gang[LcDir];
              end
            else
              begin
                if LForeward then
                  begin // Raum
                    WriteNibble(WStream, 'R');
                    WriteNibble(WStream, ansichar(LcDir + 96));
                    LRoom.EDir := getInvDir(LcDir, 22);
                  end
                else
                  begin
                    if (LSdir = LRoom.EDir) then
                        WriteNibble(WStream, #13);
                    LForeward := (LSdir <> LRoom.EDir);
                  end;
                { $ifdef debug }
                if (LRoom.Ort.x + dir27[LSdir].x <> LRoom.Gang[LSdir].Ort.x) or
                    (LRoom.Ort.y + dir27[LSdir].y <> LRoom.Gang[LSdir].Ort.y) then
                    Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clyellow
                else
                    Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clblue;
                Laby.LabImage.Picture.Bitmap.Canvas.pen.Width := 1;
                Laby.LabImage.Picture.Bitmap.Canvas.MoveTo(LRoom.Ort.x div CMult,
                    LRoom.Ort.y div CMult);
                Laby.LabImage.Picture.Bitmap.Canvas.LineTo(
                    (LRoom.Ort.x + dir27[LSdir].x) div CMult,
                    (LRoom.Ort.y + dir27[LSdir].y) div CMult);
                cc := cc mod 100 + 1;
                if cc = 1 then
                    Application.ProcessMessages;
                { $endif debug }

                LcDir := LSdir;
                LRoom := LRoom.Gang[LcDir];
              end;
            // Nächster
          end
    until (LRoom = FEingang);
    if FHalfNibble then
        WriteNibble(WStream, #0);

end;

{$IFDEF debug}

Var
  cc: integer;
{$ENDIF debug}

procedure TMakeLaby.ReadFromStream(const RStream: TStream);
type
    tc = class of TLbyRoom;

    function AppendNewRoom(Lr: TLbyRoom; TRoom: tc; LcDir: integer;
        FRooms: TCollection): TLbyRoom;
        // Inline;

    begin
        Result := TRoom.Create(FRooms, T3DPoint.Init(
            Lr.Ort.x + dir27[LcDir].x, Lr.Ort.y + dir27[LcDir].y,
            Lr.Ort.z + dir27[LcDir].z));
        Lr.Gang[LcDir] := Result;
        Inc(Lr.FdirCount);
        with Result do
          begin
            EDir := getinvdir(LcDir, 22);
            Gang[EDir] := Lr;
            AppendRoomIndex(Result);
          end;
        if TRoom = TLbyRoom then
          begin
            Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clblue;
            Result.Token := 'R';
          end;
        if TRoom = TLbyEnde then
          begin
            Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := clred;
            Result.Token := 'E';
          end;
        if TRoom = TLbyGang then
          begin
            Laby.LabImage.Picture.Bitmap.Canvas.pen.Color := cllime;
            Result.Token := 'G';
          end;
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
    end;

var
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
    lz: integer;
    st: string;
begin
    // LForeward := true;
    // dies ist ein Laby-Crawler zum speichern des Labyrinth
    // 1. Kennung
    // Rstream.Seek(0,0);
    if high(dir27) = -1 then
      begin
        dir27 := Dir3D22;
        setlength(dir27, 37);
      end;
    if assigned(FRooms) then
        FRooms.Clear
    else
        FRooms := TCollection.Create(TLbyRoom);
    LKennung := '1234567890';
    LToken := #0;
    RStream.Read(LKennung[1], 10);
    if LKennung = 'LBYv00.12' + #26 then
        repeat
            RStream.Read(LToken, 1);
            case LToken of
                'C', 'D':
                  begin
                    FNibblePack := LToken = 'C';
                    if FNibblePack then
                      begin
                        RStream.ReadBuffer(LabyBM_Width, 4);
                        RStream.ReadBuffer(LabyBM_Length, 4);
                        RStream.ReadBuffer(LabyBM_Height_, 4);

                      end
                    else
                      begin
                        st := '';
                        i := 0;
                        RStream.Read(LToken, 1);
                        repeat
                            if (Ltoken = '-') or ((Ltoken >= '0') and
                                (LToken <= '9')) then
                                st := st + Ltoken
                            else
                            if TryStrToInt(st, LabyBM_Height_) then
                                case i of
                                    0:
                                      begin
                                        LabyBM_Width := LabyBM_Height_;
                                        i := 1;
                                        st := '';
                                      end;
                                    1:
                                      begin
                                        LabyBM_Length := LabyBM_Height_;
                                        i := 2;
                                        st := '';
                                      end
                                  end;
                            RStream.Read(LToken, 1);
                        until LToken = #13;
                        TryStrToInt(st, LabyBM_Height_);
                      end;

                    setlength(FIndex, 0, 0);
                    setlength(FRoomIndex, 0, 0, 0);
                    setlength(FIndex, LabyBM_Width, LabyBM_length, LabyBM_Height_);
                    setlength(FRoomIndex, LabyBM_Width div 4 + 1,
                        LabyBM_Length div 4 + 1,
                        LabyBM_Height_ div 4 + 1);
                    InitResultBitmap;
            (*
              LabyBM.height:=LabyBM_Height;
              LabyBM.width:=LabyBM_Width;
              LabyBM.Canvas.Brush.Color := clblack;
              LabyBM.Canvas.FillRect(rect(0, 0, LabyBM_Width, LabyBM_Height)); *)
                  end;
                'S':
                  begin
                    if FNibblePack then
                      begin
                        RStream.ReadBuffer(lx, 4);
                        RStream.ReadBuffer(ly, 4);
                        RStream.ReadBuffer(lz, 4);
                      end
                    else
                      begin
                        st := '';
                        i := 0;
                        RStream.Read(LToken, 1);
                        repeat
                            if (Ltoken = '-') or ((Ltoken >= '0') and
                                (LToken <= '9')) then
                                st := st + Ltoken
                            else
                            if TryStrToInt(st, lz) then
                                case i of
                                    0:
                                      begin
                                        lx := lz;
                                        i := 1;
                                        st := '';
                                      end;
                                    1:
                                      begin
                                        ly := lz;
                                        i := 2;
                                        st := '';
                                      end
                                  end;
                            RStream.Read(LToken, 1);
                        until LToken = #13;
                        TryStrToInt(st, lz);
                      end;
                    FEingang := TlbyEingang.Create(FRooms, T3DPoint.Init(lx, ly, lz));
                    LRoom := FEingang;
                    FHalfNibble := False;
                    repeat
                        LToken := ReadNibble(RStream);
                        case LToken of
                            'E':
                              begin
                                LToken := ReadNibble(RStream);
                                LcDir := Ord(LToken) - 96;
                                LRoom := AppendNewRoom(LRoom, TLbyEnde, LcDir, FRooms);
                              end;
                            'R':
                              begin
                                LToken := ReadNibble(RStream);
                                LcDir := Ord(LToken) - 96;
                                LRoom := AppendNewRoom(LRoom, TLbyRoom, LcDir, FRooms);
                              end;
                            #13:
                              begin (* return *)
                                repeat
                                    LRoom := LRoom.Gang[LRoom.EDir];
                                until LRoom.ClassType <> TLbyGang;
                              end

                            else
                              begin
                                LcDir := Ord(LToken) - 96;
                                LRoom := AppendNewRoom(LRoom, TLbyGang, LcDir, FRooms);
                              end;
                          end;
                        if (RStream.Position mod 1000 = 0) and assigned(FOnProgress) then
                            FOnProgress(self, RStream.Position / RStream.size);

                    until (LRoom.ClassType = TlbyEingang) or (not assigned(LRoom));
                    if assigned(LRoom) then
                      begin

                      end;

                  end;
              end;
            if assigned(FOnProgress) then
                FOnProgress(self, RStream.Position / RStream.size);

        until RStream.Position = RStream.size
    {Version 0.11 Kompat-Mode }
    else if LKennung = 'LBYv00.11' + #26 then
        repeat
            RStream.Read(LToken, 1);
            case LToken of
                'D':
                  begin
                    RStream.ReadBuffer(LabyBM_Width, 4);
                    RStream.ReadBuffer(LabyBM_Length, 4);
                    LabyBM_Height_ := 3;

                    setlength(FIndex, 0, 0);
                    setlength(FRoomIndex, 0, 0, 0);
                    setlength(FIndex, LabyBM_Width, LabyBM_length, LabyBM_Height_);
                    setlength(FRoomIndex, LabyBM_Width div 4 + 1,
                        LabyBM_Length div 4 + 1,
                        LabyBM_Height_ div 4 + 1);
                    InitResultBitmap;
            (*
              LabyBM.height:=LabyBM_Height;
              LabyBM.width:=LabyBM_Width;
              LabyBM.Canvas.Brush.Color := clblack;
              LabyBM.Canvas.FillRect(rect(0, 0, LabyBM_Width, LabyBM_Height)); *)
                  end;
                'S', 'C':
                  begin
                    FNibblePack := LToken = 'C';
                    RStream.ReadBuffer(lx, 4);
                    RStream.ReadBuffer(ly, 4);
                    lz := 2;
                    FEingang := TlbyEingang.Create(FRooms, T3DPoint.Init(lx, ly, lz));
                    LRoom := FEingang;
                    FHalfNibble := False;
                    repeat
                        LToken := ReadNibble(RStream);
                        case LToken of
                            'E':
                              begin
                                LToken := ReadNibble(RStream);
                                LcDir := Ord(LToken) - 48;
                                LRoom := AppendNewRoom(LRoom, TLbyEnde, LcDir, FRooms);
                              end;
                            'R':
                              begin
                                LToken := ReadNibble(RStream);
                                LcDir := Ord(LToken) - 48;
                                LRoom := AppendNewRoom(LRoom, TLbyRoom, LcDir, FRooms);
                              end;
                            #13:
                              begin (* return *)
                                repeat
                                    LRoom := LRoom.Gang[LRoom.EDir];
                                until LRoom.ClassType <> TLbyGang;
                              end

                            else
                              begin
                                LcDir := Ord(LToken) - 48;
                                LRoom := AppendNewRoom(LRoom, TLbyGang, LcDir, FRooms);
                              end;
                          end;
                        if (RStream.Position mod 1000 = 0) and assigned(FOnProgress) then
                            FOnProgress(self, RStream.Position / RStream.size);

                    until (LRoom.ClassType = TlbyEingang) or (not assigned(LRoom));
                    if assigned(LRoom) then
                      begin

                      end;

                  end;
              end;
            if assigned(FOnProgress) then
                FOnProgress(self, RStream.Position / RStream.size);

        until RStream.Position = RStream.size
    else
        MessageDlg('Falsche Version', mtWarning, [mbOK], 0);
    // Falsche Version
end;

const
    code: ShortString = '0123456789'#58#59#60#13'RE';

procedure TLaby.LoadLaby(const Filename: string);
var
    LStream: TStream;
begin
    LStream := TFileStream.Create(Filename, fmOpenRead);

    if assigned(makelaby) then
        makelaby.Clear
    else
        makelaby := TMakeLaby.Create(True);
    makelaby.OnProgress := OnProgress;
    makelaby.ReadFromStream(LStream);
    Laby_Height_ := makelaby.LabyBM_Height_;
    Laby_Width := makelaby.LabyBM_Width;
    Laby_Length := makelaby.LabyBM_Length;
    LStream.Free;
end;

procedure TMakeLaby.WriteNibble(const WStream: TStream; const Nibble: ansichar);
var
    i: integer;
    LC: byte;
begin
    if not FNibblePack then
      begin
        WStream.Write(byte(Nibble), 1);
        FHalfNibble := False;
      end
    else
      begin
        LC := 0;
        for i := 1 to 16 do
            if Nibble = code[i] then
                LC := i - 1;
        if FHalfNibble then
          begin
            FLastStChar := FLastStChar + LC * 16;
            WStream.Write(FLastStChar, 1);
            FLastStChar := 0;
            FHalfNibble := False;
          end
        else
          begin
            FLastStChar := LC;
            FHalfNibble := True;
          end;
      end;
end;

function TMakeLaby.ReadNibble(const WStream: TStream): ansichar;

begin
    if not FNibblePack then
      begin
        WStream.Read(FLastStChar, 1);
        Result := ansichar(FLastStChar);
      end
    else if FHalfNibble then
      begin
        Result := code[FLastStChar div 16 + 1];
        FHalfNibble := False;
      end
    else
      begin
        WStream.Read(FLastStChar, 1);
        Result := code[byte(FLastStChar) and 15 + 1];
        FHalfNibble := True;
      end;

end;

function TLaby.GetEingang: TLbyRoom;
begin
    if assigned(makelaby) then
        Result := makelaby.FEingang
    else
        Result := nil;
end;


procedure TLaby.DrawRoom(Sender: TObject; aRoom: TLbyRoom; inDir, outDir: integer);

var
    pInVect, pOutVect: T3DPoint;
    i: integer;
    bNear: boolean;
    GWidth: double;

const
    GWidtho = 0.20;
begin
    if assigned(pCanvas) then
      begin
        pInVect := Dir3D22[inDir];
        pOutVect := Dir3D22[outDir];

        bNear := (outdir - inDir + 12) mod 12 < 2;

        GWidth := GWidtho;
        pCanvas.MoveTo
        (trunc((aRoom.Ort.x + 0.5 * pInVect.x - GWidth * pInVect.y) * cFactX),
            trunc((aRoom.Ort.y + 0.5 * pInVect.y + GWidth * pInVect.x) * cFactY));
        if bNear then
            pCanvas.LineTo
            (trunc((aRoom.Ort.x + 0.4 * pInVect.x - GWidth * pInVect.y) * cFactX),
                trunc((aRoom.Ort.y + 0.4 * pInVect.y + GWidth * pInVect.x) * cFactY))
        else
            pCanvas.LineTo
            (trunc((aRoom.Ort.x + 0.25 * pInVect.x - GWidth * pInVect.y) * cFactX),
                trunc((aRoom.Ort.y + 0.25 * pInVect.y + GWidth * pInVect.x) * cFactY));
        if aRoom.Token = 'E' then
            for i := indir + 1 to indir + 7 do
              begin
                pInVect := Dir3D22[(i - 1) mod 12 + 1];
                pCanvas.LineTo
                (trunc((aRoom.Ort.x + GWidth * (0.8 * pInVect.x - pInVect.y)) * cFactX),
                    trunc((aRoom.Ort.y + GWidth * (0.8 * pInVect.y + pInVect.x)) * cFactY));
              end;
        if (outdir - inDir + 12) mod 12 > 8 then
            pCanvas.LineTo
            (trunc((aRoom.Ort.x + Gwidth * 0.5 * (-pInVect.y + poutVect.y)) * cFactX),
                trunc((aRoom.Ort.y + Gwidth * 0.5 * (pInVect.x - poutVect.x)) * cFactY));

        if bNear then
            pCanvas.LineTo
            (trunc((aRoom.Ort.x + 0.4 * pOutVect.x + GWidth * poutVect.y) * cFactX),
                trunc((aRoom.Ort.y + 0.4 * pOutVect.y - GWidth * poutVect.x) * cFactY))
        else
            pCanvas.LineTo
            (trunc((aRoom.Ort.x + 0.25 * pOutVect.x + GWidth * poutVect.y) * cFactX),
                trunc((aRoom.Ort.y + 0.25 * pOutVect.y - GWidth * poutVect.x) * cFactY));
        pCanvas.LineTo
        (trunc((aRoom.Ort.x + 0.5 * pOutVect.x + GWidth * poutVect.y) * cFactX),
            trunc((aRoom.Ort.y + 0.5 * pOutVect.y - GWidth * poutVect.x) * cFactY));
      end;
end;

procedure TLaby.DrawRoom2(Sender: TObject; room: TLbyRoom; inDir,
  outDir: integer);

var pInVect:T3DPoint;
  i, j: Integer;

function DrawPoint(Ort,v:T3dpoint;vf,zf:single):Tpoint;inline;

var xx,yy,zz :double;
begin
    xx := Ort.x + vf * v.x;
    yy := Ort.y + vf * v.y;
    zz := Ort.z + vf * v.z-2.0;
    result := point(trunc((xx + zz * zf) * cFactX),
                    trunc((yy + zz * zf) * cFactY));
end;

const PenWidth = 0.4;
begin
    if assigned(pCanvas) then
      begin
        if DrawShaddow then
          begin
        // Zeichne Schatten
        pCanvas.pen.Mode:=pmCopy;
        for j := 5 downto 0 do
          begin
        pCanvas.pen.width:=trunc((PenWidth-0.15 +j*0.05)*cFactY)+2;
        pCanvas.pen.color :=RGB(j*40,j*40,j*40);
        for i := 0 to high(room.FFGIndex) do
          if room.FFGIndex[i] >=0 then
          begin
            pInVect := Dir3D22[i];
            pCanvas.line(DrawPoint(room.Ort,Dir3D22[0],0.5,0.1),DrawPoint(room.Ort,pInvect,0.5+(5-j)*0.025,0.1));
        end;
          end;
        end else begin
        // Zeichne Umriss
        pCanvas.pen.color :=clBlack;
        pCanvas.pen.width:=trunc(PenWidth*cFactY)+3;
        pCanvas.pen.Mode:=pmCopy;
        for i := 0 to high(room.FFgindex) do
          if room.FFGIndex[i] >=0 then
          begin
            pInVect := Dir3D22[i];
            pCanvas.Line(DrawPoint(room.Ort,Dir3D22[0],0.5,-0.2),DrawPoint(room.Ort,pInvect,0.5,-0.2));
        end;

        // Zeichne Weg1
        pCanvas.pen.width:=trunc(PenWidth*cFactY);
        pCanvas.pen.Mode:=pmCopy;

        pCanvas.pen.color :=RGBToColor(room.Ort.z*55,room.Ort.z*55,room.Ort.z*55);
        for i := 0 to high(room.FFGIndex) do
          if room.FFGIndex[i] >=0 then
          begin
            pInVect := Dir3D22[i];
            pCanvas.Line(DrawPoint(room.Ort,Dir3D22[0],0.5,-0.2),DrawPoint(room.Ort,pInvect,0.25,-0.2));
        end;

        for i := 0 to high(room.FFGIndex) do
          if room.FFGIndex[i] >=0 then
          try
            pInVect := Dir3D22[i];
            pCanvas.pen.color :=RGBToColor(room.Ort.z*55+pInvect.z*20,room.Ort.z*55+pInvect.z*20,room.Ort.z*55+pInvect.z*20);
            pCanvas.Line(DrawPoint(room.Ort,pInvect,0.25,-0.2),DrawPoint(room.Ort,pInvect,0.55,-0.2));
          except
          end;
        end;
      end;
end;

procedure TLaby.OnProgress(Sender: TObject; Progress: double);

begin
    ProgressBar1.Position := trunc(Progress * ProgressBar1.Max);
    Application.ProcessMessages;
end;

end.
{
* \_/| _ _  _  //    _ _  _    _
*    |// \\// //    // || ||/\//
*    ||| |  | \\   ||  || |||  |
*   // \_|  \__\\_/ \_/ \/ ||  \_
*   \|

  12,1,2,11,11,11,10,12,3, }
