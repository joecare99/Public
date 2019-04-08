unit Unt_RenderTask;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Classes {$IFDEF MSWINDOWS} ,graphics{$ENDIF} ;

type
  TExPoint = record
    x, y: extended;
  End;
  TExRect = record
    case boolean of
      true: (P1,P2:TExPoint);
      false: (X1,Y1,X2,Y2:extended)
  end;
  TResultRec=record
    p:TExPoint;
    col:TColor;
  end;
  TResultArray = array of TResultRec;
  TDFunktion =function(p,p0:TExPoint;var break:boolean):TExPoint;
  TCFunktion =function(p:TExPoint):Tcolor;

  { TRenderThread }

  TRenderThread = class(TThread)
  private
    FOnCompletion:TNotifyEvent;
    procedure RenderComplete;
  protected
    procedure Execute; override;
  public
    Fkt:array of TDFunktion;
    CFkt:TCFunktion;
    Source:TExRect;
    Result:TBitmap;
    PntPerEdge:integer;
    constructor CreateRTask(const aFktArr: array of TDFunktion;
      const aCFkt: TCFunktion; aSource: TExRect; aPntPerEdge: integer);
  end;

implementation

uses sysutils;

var B:array[byte] of char;
{ TRenderThread }


procedure TRenderThread.RenderComplete;
begin
  if assigned(FOnCompletion)  then
    FOnCompletion(self);
end;

constructor TRenderThread.CreateRTask(const aFktArr: array of TDFunktion;
  const aCFkt: TCFunktion; aSource: TExRect; aPntPerEdge: integer);
var
  i: Integer;
begin
  setlength(Fkt,length(aFktArr));
  for i := 0 to high(aFktArr) do
    fkt[i] := aFktArr[i];
  CFkt := aCFkt;
  Source:=aSource;
  PntPerEdge:=aPntPerEdge;
  Result:= TBitmap.Create;
  result.Height:=PntPerEdge;
  result.Width:=PntPerEdge;
  Result.PixelFormat:=pf32bit;
  Create(false);
  FreeOnTerminate:=false;
end;

procedure TRenderThread.Execute;
var
  I: Integer;
  J, x, y: Integer;
  p0: TExPoint;
  p: TExPoint;
  Lbreak: Boolean;
  vx: Extended;
begin
  { Thread-Code hier einfügen }
  for x := 0 to PntPerEdge-1 do
  begin
    vx := Source.X1+(Source.X2-Source.x1) *(x/PntPerEdge)  ;

    for y := 0 to PntPerEdge -1 do
    begin
      p0.x:=vx;
      p0.y := Source.Y1+(Source.Y2-Source.Y1) *(Y/PntPerEdge)  ;


      p:=p0;
      Lbreak:=false;
      for I := 0 to high(fkt) do
          p:=fkt[I](p,p0,Lbreak);
      Result.Canvas.Pixels[x,y]:=CFkt(p);
    end;

  end;
  Synchronize(RenderComplete);
end;

end.
