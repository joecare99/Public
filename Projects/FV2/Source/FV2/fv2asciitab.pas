{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}
{                                                          }
{   System independent GRAPHICAL clone of ASCIITAB.PAS     }
{                                                          }
{   Interface Copyright (c) 1992 Borland International     }
{                                                          }
{   Copyright (c) 2002 by Pierre Muller                    }
{   pierre@freepascal.org                                  }
{****************[ THIS CODE IS FREEWARE ]*****************}
{                                                          }
{     This sourcecode is released for the purpose to       }
{   promote the pascal language on all platforms. You may  }
{   redistribute it and/or modify with the following       }
{   DISCLAIMER.                                            }
{                                                          }
{     This SOURCE CODE is distributed "AS IS" WITHOUT      }
{   WARRANTIES AS TO PERFORMANCE OF MERCHANTABILITY OR     }
{   ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED.     }
{                                                          }
{*****************[ SUPPORTED PLATFORMS ]******************}
{     16 and 32 Bit compilers                              }
{        DPMI     - FPC 0.9912+ (GO32V2)    (32 Bit)       }
{        WIN95/NT - FPC 0.9912+             (32 Bit)       }
{                                                          }

UNIT fv2asciitab;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                  INTERFACE
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}

{$X+} { Extended syntax is ok }
{====================================================================}

USES classes, fv2Drivers, fv2Views;      { Standard GFV units }

{***************************************************************************}
{                        PUBLIC OBJECT DEFINITIONS                          }
{***************************************************************************}


{---------------------------------------------------------------------------}
{                  TTABLE OBJECT - 32x32 matrix of all chars                }
{---------------------------------------------------------------------------}

type
   PTable = ^TTable deprecated 'use TTable';
  TTable = class(TView)
    public
    procedure Draw; override;
    procedure HandleEvent(var Event:TEvent); override;
  private
    procedure DrawCurPos(enable : boolean);
  end;

{---------------------------------------------------------------------------}
{                  TREPORT OBJECT - View with details of current char       }
{---------------------------------------------------------------------------}
   PReport = ^TReport deprecated 'use TReport';
  TReport = class(TView)
    public
    ASCIIChar: LongInt;
    constructor Load(aOwner: Tgroup; var S: TStream);
    procedure Draw; override;
    procedure HandleEvent(var Event:TEvent); override;
    procedure Store(var S: TStream);override;
  end;

{---------------------------------------------------------------------------}
{                  TASCIIChart OBJECT - the complete AsciiChar window       }
{---------------------------------------------------------------------------}

   PASCIIChart = ^TASCIIChart deprecated 'use TASCIIChart';
  TASCIIChart = class(TWindow)
    public
    Report: TReport;
    Table: TTable;
    constructor create(aOwner:TGroup);
    constructor Load(aOwner:TGroup;var S: TStream);
    procedure   Store(var S: TStream);override;
    procedure HandleEvent(var Event:TEvent); override;
  end;

{---------------------------------------------------------------------------}
{ AsciiTableCommandBase                                                     }
{---------------------------------------------------------------------------}

const
  AsciiTableCommandBase: Word = 910;


{---------------------------------------------------------------------------}
{ Registration procedure                                                    }
{---------------------------------------------------------------------------}
procedure RegisterASCIITab;



{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                             IMPLEMENTATION
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
uses fv2common,fv2RectHelper;
{***************************************************************************}
{                              OBJECT METHODS                               }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TTable OBJECT METHODS                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

procedure TTable.Draw;
var
  NormColor : byte;
  B : TDrawBuffer;
  x,y : sw_integer;
begin
  NormColor:=GetColor(1);
  For y:=0 to size.Y-1 do begin
    For x:=0 to size.X-1 do
      B[x]:=(NormColor shl 8) or ((y*Size.X+x) and $ff);
    WriteLine(0,Y,Size.X,1,B);
  end;
  DrawCurPos(true);
end;

procedure TTable.DrawCurPos(enable : boolean);
var
  Color : byte;
  B : word;
begin
  Color:=GetColor(1);
  { add blinking if enable }
  If Enable then
    Color:=((Color and $F) shl 4) or (Color shr 4);
  B:=(Color shl 8) or ((Cursor.Y*Size.X+Cursor.X) and $ff);
  WriteLine(Cursor.X,Cursor.Y,1,1,B);
end;

procedure TTable.HandleEvent(var Event:TEvent);
var
  CurrentPos : TPoint;
  Handled : boolean;

  procedure SetTo(xpos, ypos : sw_integer;press:integer);
  var
    newchar : word;
  begin
    newchar:=(ypos*size.X+xpos) and $ff;
    DrawCurPos(false);
    SetCursor(xpos,ypos);
    MessageR(TView(Owner),evCommand,AsciiTableCommandBase,(newchar));
    if press>0 then
      begin
        MessageR(TView(Owner),evCommand,AsciiTableCommandBase+press,(newchar));
      end;
    DrawCurPos(true);
    ClearEvent(Event);
  end;

begin
  case Event.What of
    evMouseDown :
      begin
        If MouseInView(Event.Where) then
          begin
            MakeLocal(Event.Where, CurrentPos);
            SetTo(CurrentPos.X, CurrentPos.Y,1);
            exit;
          end;
      end;
    evKeyDown :
      begin
        Handled:=true;
        case Event.Keycode of
          kbUp   : if Cursor.Y>0 then
                   SetTo(Cursor.X,Cursor.Y-1,0);
          kbDown : if Cursor.Y<Size.Y-1 then
                   SetTo(Cursor.X,Cursor.Y+1,0);
          kbLeft : if Cursor.X>0 then
                   SetTo(Cursor.X-1,Cursor.Y,0);
          kbRight: if Cursor.X<Size.X-1 then
                   SetTo(Cursor.X+1,Cursor.Y,0);
          kbHome : SetTo(0,0,0);
          kbEnd  : SetTo(Size.X-1,Size.Y-1,0);
          kbEnter: SetTo(Cursor.X,Cursor.Y,1);
        else
          Handled:=false;
        end;
        if Handled then
          exit;
      end;
  end;
  inherited HandleEvent(Event);
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TReport OBJECT METHODS                             }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

constructor TReport.Load(aOwner:Tgroup;var S: TStream);
begin
  Inherited Load(aOwner,S);
  S.Read(AsciiChar,Sizeof(AsciiChar));
end;

procedure TReport.Draw;
  var
    stHex,stDec : string[3];
    s : string;
begin
  Str(AsciiChar,StDec);
  while length(stDec)<3 do
    stDec:=' '+stDec;
  stHex:=hexstr(AsciiChar,2);
  s:='Char "'+chr(AsciiChar)+'" Decimal: '+
     StDec+' Hex: $'+StHex+
     '  '; // //{!ss:fill gap. FormatStr function using be better}
  WriteStr(0,0,S,1);
end;

procedure TReport.HandleEvent(var Event:TEvent);
begin
  if (Event.what=evCommand) and
     (Event.Command =  AsciiTableCommandBase) then
    begin
      AsciiChar:=PtrInt(Event.InfoPtr);
      Draw;
      ClearEvent(Event);
    end
  else inherited HandleEvent(Event);
end;

procedure TReport.Store(var S: TStream);
begin
  Inherited Store(S);
  S.Write(AsciiChar,Sizeof(AsciiChar));
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TAsciiChart OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

constructor TASCIIChart.create(aOwner: TGroup);
var
  R : Trect;
begin
  R.Assign(0,0,34,12);
  Inherited create(aOwner,R,'Ascii table',wnNoNumber);
  Flags:=Flags and not (wfGrow or wfZoom);
  Palette:=wpGrayWindow;
  R.Assign(1,10,33,11);
  Report:=TReport.create(self,R);
  Report.Options:=Report.Options or ofFramed;
  Insert(Report);
  R.Assign(1,1,33,9);
  table:=TTable.create(self,R);
  Table.Options:=Table.Options or (ofSelectable+ofTopSelect);
  Insert(Table);
  Table.Select;
end;

constructor TASCIIChart.Load(aOwner: TGroup; var S: TStream);
begin
  Inherited Load(aOwner,S);
  GetSubViewPtr(S,Table);
  GetSubViewPtr(S,Report);
end;

procedure TASCIIChart.Store(var S: TStream);
begin
  Inherited Store(S);
  PutSubViewPtr(S,Table);
  PutSubViewPtr(S,Report);
end;

procedure TASCIIChart.HandleEvent(var Event:TEvent);
begin
  {writeln(stderr,'ascii cmd',event.what, ' ', event.command);}
  if (Event.what=evCommand) and
     (Event.Command =  AsciiTableCommandBase) then
    begin
      Report.HandleEvent(Event);
    end
  else inherited HandleEvent(Event);
end;
{---------------------------------------------------------------------------}
{ Registration procedure                                                    }
{---------------------------------------------------------------------------}
procedure RegisterASCIITab;
begin
  //RegisterType(RTable);
  //RegisterType(RReport);
  //RegisterType(RAsciiChart);
end;


END.
