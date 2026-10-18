{$IFDEF FPC}
unit minecad_planner_model_grid;
{$ELSE}
unit minecad.planner.model.grid;
{$ENDIF}

interface

uses minecad.planner.util.Array3D,
     minecad.planner.model.cell,
     types,
     classes;

type  TStructureModel = TObject;
      TGridStatistics = TObject;
 TWorldGrid=Class(TBaseGrid)
  private
    FWidth:integer;
    FLength:integer;
    FHeight:integer;

    MaxHeight:integer;
    MinHeight:integer;
    TotalBlocks:integer;
    VisibleBlocks:integer;
    grid:TArray3D<TCell>;
    Statistics:TGridStatistics;
    Procedure SetCell(x,y,z:integer;NewVal:TCell);

  public
    Constructor Create;
    Procedure initialize(newwidth,newLength,newheight:integer;includeBufferCells:boolean=
      false);
    Function GetWidth:Integer;
    Function GetHeight:integer;
    Function GetLength:integer;
    Function GetCell(x,y,z:integer):TCell;
    Function GetTotalBlocks:integer;
    Function GetVisibleBlocks:integer;
    Function GetMinHeight:integer;
    function GetMaxHeight:Integer;
    Procedure UpdateMetrics(Model:TStructureModel);
//    Function GridStatistics:TGridStatistics;
    Procedure SaveAsXML(os:TStream);
    Procedure SaveAsNBT(os:TStream);
    Procedure LoadAsXML(os:TStream);
    Procedure LoadAsNBT(os:TStream);
    procedure BeginAction(Name:String);
    procedure EndAction;
    Property Data[x,y,z:Integer]:TCell read GetCell write SetCell;Default;
End;

implementation

uses minecad.planner.util.tag;

Constructor TWorldGrid.Create;
begin
  FWidth :=0;
  FLength :=0;
  FHeight :=0;
  TotalBlocks :=0;
  VisibleBlocks :=0;
  MaxHeight :=0;
  MinHeight := 0;
  Grid := TArray3D<TCell>.Create(FWidth,FLength,FHeight);
  Statistics := TGridStatistics.Create;
end;

Procedure TWorldGrid.initialize(newwidth,NewLength, newheight: Integer; includeBufferCells: Boolean = False);
begin
  if includeBufferCells then
    begin
      FWidth:= Newwidth+2;
      FHeight:=Newheight+2;
      FLength:=newLength+2;
    end
  else
    begin
      FWidth:= Newwidth;
      FHeight:=Newheight;
      FLength := newLength;
    end;
  TotalBlocks :=0;
  VisibleBlocks :=0;
  grid.Resize(FWidth,FLength,FHeight);
//  Statistics.resetStatistics;
end;

Function TWorldGrid.GetCell(x,y,z:integer):TCell;

begin
  result := grid[x,y,z];
end;

Procedure TWorldGrid.SetCell(x: Integer; y: Integer; z: Integer; NewVal: TCell);
begin
  // Todo: Copy old Data to Undo-Buffer;
  grid.SetData(x,y,z,NewVal);
  Newval.x:=x;
  NewVal.y:=y;
  NewVal.z:=z;
end;

Procedure TWorldGrid.SaveAsNBT(os: TStream);
  var tagArray : Array of TTag;
      structureArray :TByteDynArray;
      dataArray :TByteDynArray;

begin
  setlength(tagArray,9);
  tagArray[0] := TTag.Create(TAG_Short,'Height',FHeight);
  tagArray[1] := TTag.Create(TAG_Short,'Length',FLength);
  tagArray[2] := TTag.Create(TAG_Short,'Width',FWidth);
  tagArray[3] := TTag.Create(TAG_List,'Entities',nil);
  tagArray[4] := TTag.Create(TAG_List,'TileEntitys',nil);
  tagArray[5] := TTag.Create(TAG_String,'Materials','Alpha');



  tagArray[6] := TTag.Create(TAG_ByteArray,'Blocks',structureArray);
  tagArray[7] := TTag.Create(TAG_ByteArray,'Data',dataArray);
  tagArray[8] := TTag.Create(TAG_End,'',0);
end;

Procedure TWorldGrid.UpdateMetrics(Model: TObject);
begin
  // Todo: Masse Updaten ?
end;

Procedure TWorldGrid.SaveAsXML(os: TStream);
begin
  // Todo: Daten als XML-Speichern
end;

Procedure TWorldGrid.LoadAsXML(os: TStream);
begin
  // Todo: Daten von XML-Laden
end;

Procedure TWorldGrid.LoadAsNBT(os: TStream);
begin
  // Todo: Daten von NBT-Laden
end;

Function TWorldGrid.GetWidth;
begin
  result := FWidth;
end;

Function TWorldGrid.GetLength;
begin
  result := FLength;
end;

Function TWorldGrid.GetHeight;
begin
  result := FHeight;
end;

Function TWorldGrid.GetMaxHeight;
begin
  result := 0;//Todo: Maximale Höhe bestimmen
end;

Function TWorldGrid.GetTotalBlocks;
begin
  result := 0; //Todo: Anzahl der Blöcke bestimmen
end;

Function TWorldGrid.GetVisibleBlocks;
begin
  result := 0; //Todo: Anzahl der sichtbaren Blöcke bestimmen
end;

Function TWorldGrid.GetMinHeight;
begin
  result :=0; // Todo: Minimale Höhe Bestimmen
end;

procedure TWorldGrid.BeginAction(Name:String);
begin
  // Todo: Undo - Aktion Starten
end;

procedure TWorldGrid.EndAction;
begin
  // Todo: Undo - Aktion Beenden
end;


end.
