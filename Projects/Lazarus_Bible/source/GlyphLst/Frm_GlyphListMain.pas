unit Frm_GlyphListMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, FileUtil,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, Menus;

type

  { TMainForm }

  TMainForm = class(TForm)
    PathLabel: TLabel;
    BitBtn1: TBitBtn;
    GlyphList: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GlyphListDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; {%H-}State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  glyphPath =
  {$IFDEF FPC} // FPC
      '%2:s\..\Glyphs\Buttons';
{$ELSE}
{$IFDEF ver110} // Delphi 3
    '$0:s\Borland\Delphi 3\Images\Buttons';
{$ENDIF}
{$IFDEF ver120} // Delphi 4
'$0:s\Borland\Delphi 4\Images\Buttons';
{$ENDIF}
{$IFDEF ver130} // Delphi 5
'$0:s\Borland\Delphi 5\Images\Buttons';
{$ENDIF}
{$IFDEF ver140} // Delphi 6
'$0:s\Borland\Delphi 6\Images\Buttons';
{$ENDIF}
{$IFDEF ver150} // Delphi 7
'%0:s\Borland\Delphi 7\Images\Buttons';
{$ENDIF}
{$IFDEF ver160} // Delphi 8
'$0:s\Borland\Delphi 8\Images\Buttons';
{$ENDIF}
{$IFDEF ver170} // BDS 2005
'$0:s\Borland\Rad Studio\Images\Buttons';
{$ENDIF}
{$IFDEF ver180} // BDS 2006
'$1:s\Borland Shared\Images\Buttons';
{$ENDIF}
{$IFDEF ver190} // BDS 2007
'$1:s\Borland Shared\Images\Buttons';
{$ENDIF}
{$IFDEF ver200} // BDS 2009
'$1:s\Borland Shared\Images\Buttons';
{$ENDIF}
{$IFDEF ver210} // BDS 2010
'%1:s\CodeGear Shared\Images\Buttons';
{$ENDIF}
{$IFDEF ver210} // BDS 2010
'%1:s\CodeGear Shared\Images\Buttons';
{$ENDIF}
{$IFDEF ver210} // BDS 2010
'%1:s\CodeGear Shared\Images\Buttons';
{$ENDIF}
{$IFDEF ver310} // DXE 10.1
'%1:s\CodeGear Shared\Images\Buttons';
{$ENDIF}
{$IFDEF ver320} // DXE 10.2
'%1:s\CodeGear Shared\Images\Buttons';
{$ENDIF}
{$ENDIF}

// Reads all glyph bitmaps and stores their filenames and
// images in the GlyphList TStringGrid object.
procedure TMainForm.FormCreate(Sender: TObject);
var
  SearchRec: TSearchRec; { Directory scan result record }
  K: Integer; { while-loop control variable }
  Bitmap: TBitmap; { Holds bitmaps. Do not Free! }
  Index: Integer; { TStringGrid cell index }
  ProgFilesDir, { Path of Programm Files }
//  CommonProgFiles: String; { Path of Common Files }
  Datapath :String;
begin
  Datapath := 'Data';
  for k := 0 to 2 do
    {$IFDEF FPC}
    if DirectoryExists(Datapath) then
    {$ELSE}
    if DirPathExists(Datapath) then
    {$ENDIF}
      break
    else Datapath:='..'+DirectorySeparator + Datapath;
  ProgFilesDir := GetEnvironmentVariable('ProgramFiles');
  Show; { Make form visible while loading bitmaps }
  Screen.Cursor := crHourGlass; { Show hourglass cursor }
  Index := 0;
  try
    PathLabel.Caption := format
      (glyphPath, [ProgFilesDir, GetEnvironmentVariable('CommonProgramFiles'),DataPath]
      ); { Show path above ListBox }
    { Start scan }
    K := FindFirst(PathLabel.Caption + '\*.*',faAnyFile,SearchRec); { *Converted from FindFirst* }
    try
      while K = 0 do { Scan directory for file names }
        begin
          if SearchRec.Name[1] <> '.' then { No '.' or '..' paths }
            begin
              Bitmap := TBitmap.Create; { Create bitmap object }
              try { Get bitmap and load from list }
                Bitmap.LoadFromFile(PathLabel.Caption + '\' + SearchRec.Name);
                if Index >= GlyphList.RowCount then // Expand list
                  GlyphList.RowCount := Index + 1;
                GlyphList.Cells[0, Index] := SearchRec.Name; // Name
                GlyphList.Objects[1, Index] := Bitmap; // Bitmap
                inc(Index);
              except
                Bitmap.Free; { Executed if ANYTHING goes wrong }
      //          raise ; { Pass any exceptions up call chain }
              end;
            end;
          K := FindNext(SearchRec); { *Converted from FindNext* } { Continue directory scan }
        end;
    finally
      FindClose(SearchRec); { *Converted from FindClose* }
    end;
  finally
    Screen.Cursor := crDefault; { Restore normal cursor }
  end;
end;

// Frees memory occupied by all glyph bitmaps. The TStringGrid
// object does NOT do this automatically.
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
  for I := 0 to GlyphList.RowCount - 1 do
    TBitmap(GlyphList.Objects[0, I]).Free;
  Action:=caFree;
end;

// Draw each glyph bitmap. The TStringGrid object is smart
// enough to draw its filename text objects with no further
// help. This code draws only the bitmaps in the second column.
procedure TMainForm.GlyphListDrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Bitmap: TBitmap;
begin
  if Col = 1 then // Be sure to refer to the bitmap column
    begin
      { Get bitmap object }
      Bitmap := TBitmap(GlyphList.Objects[1, Row]);
      if Bitmap <> nil then
        begin { Draw bitmap in column cell }
          GlyphList.Canvas.BrushCopy
            (Bounds(Rect.Left + 2, Rect.Top + 2, Bitmap.Width, Bitmap.Height),
            Bitmap, Bounds(0, 0, Bitmap.Width, Bitmap.Height), clRed);
          { The preceding clRed argument gives the transparent
            glyph substance. Change this to any solid color, or
            change it to 0 to see why this is necessary. }
        end;
    end;
end;

end.
