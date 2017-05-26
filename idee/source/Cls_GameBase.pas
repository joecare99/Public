UNIT Cls_GameBase;
{ Game - basisClassen }

INTERFACE

USES classes;

TYPE
  iHasPlace = INTERFACE
    /// <author>Rosewich</author>
    /// <Info>diese Methode setzt Koordinaten</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetKoor(NewX, NewY: integer);
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest die X-Koordinate</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetXKoor: integer;
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest die Y-Koordinate</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetYKoor: integer;
    /// <author>Rosewich</author>
    /// <Info>diese Eigenschaft liest die X-Koordinate</Info>
    /// <since>26.09.2012</since>
    PROPERTY XKoor: integer READ GetXKoor;
    /// <author>Rosewich</author>
    /// <Info>diese Eigenschaft liest die Y-Koordinate</Info>
    /// <since>26.09.2012</since>
    PROPERTY YKoor: integer READ GetYKoor;
  END;

  /// <author>Rosewich</author>
  /// <Info>Interface für FeldDateninhalte (Objekte, Lebeween ...) </Info>
  /// <since>26.09.2012</since>
  iFieldData = INTERFACE(iHasPlace)
    /// <author>Rosewich</author>
    /// <Info>Bestimmt ob dies ein Lebewesen ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetIsEntity: Boolean;
    /// <author>Rosewich</author>
    /// <Info>Bestimmt ob dies ein Objekt ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetIsObject: Boolean;
    /// <author>Rosewich</author>
    /// <Info>Eigenschaft: Ob dies ein Lebewesen ist</Info>
    /// <since>26.09.2012</since>
    PROPERTY isEntity: Boolean READ GetIsEntity;
    /// <author>Rosewich</author>
    /// <Info>Eigenschaft: Ob dies ein Objekt ist</Info>
    /// <since>26.09.2012</since>
    PROPERTY isObject: Boolean READ GetIsObject;
    /// <author>Rosewich</author>
    /// <Info>Liest Eigenschaft</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetProperty(Index: variant): variant;
    /// <author>Rosewich</author>
    /// <Info>Setzt eine Eigenschaft</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetProperty(Index, Newval: variant);
    /// <author>Rosewich</author>
    /// <Info>In dieser Methode werden Aktionen vorbereitet</Info>
    /// <since>26.09.2012</since>
    PROCEDURE PreMove;
    /// <author>Rosewich</author>
    /// <Info>In dieser Methode werden Aktionen ausgeführt</Info>
    /// <since>26.09.2012</since>
    PROCEDURE ExecMove;
  END;

  /// <author>Rosewich</author>
  /// <Info>Interface für SpielObjekte</Info>
  /// <since>26.09.2012</since>
  iGameObject = INTERFACE(iFieldData)
    Function GetObjectType:integer;
    PROPERTY ObjProperty[INDEX: variant]: variant READ GetProperty
      WRITE SetProperty;
  END;

  /// <author>Rosewich</author>
  /// <Info>Interface für Lebewesen</Info>
  /// <since>26.09.2012</since>
  iEntity = INTERFACE(iFieldData)
    Function GetEntityType:integer;
    PROPERTY EntProperty[INDEX: variant]: variant READ GetProperty
      WRITE SetProperty;
  END;

  /// <author>Rosewich</author>
  /// <Info>Interface: Kann Objekte (ent-)halten</Info>
  /// <since>26.09.2012</since>
  iCanHoldObject = INTERFACE
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest Inventory-Einträge</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetInventory(Index: integer): iGameObject;
    /// <author>Rosewich</author>
    /// <Info>diese Methode setzt Inventory-Einträge</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetInventory(Index: integer; Newval: iGameObject);
    /// <author>Rosewich</author>
    /// <Info>diese Methode fügt Objekte zum Inventory hinzu</Info>
    /// <since>02.10.2012</since>
    PROCEDURE AppendObject(NewObj: iGameObject);
    /// <author>Rosewich</author>
    /// <Info>diese Methode Löscht Objekte vom Inventory</Info>
    /// <since>02.10.2012</since>
    PROCEDURE RemoveObject(OldObj: iGameObject);
    PROPERTY Inventory[INDEX: integer]: iGameObject READ GetInventory
      WRITE SetInventory;
  END;

  TFieldTypes = set of byte;
  TField = CLASS(TComponent, iCanHoldObject, iHasPlace)
  PRIVATE
    FEntityEnum:    integer;
    maxObjIdx:      integer;
    FXKoor, FYKoor: integer;
    FUNCTION GetFDIndex(CONST NewData: iFieldData): integer;
  PUBLIC
    FieldType: integer;
    Data:      ARRAY OF iFieldData;
    PROCEDURE AppendFieldData(CONST NewData: iFieldData); VIRTUAL;
    PROCEDURE RemoveFieldData(CONST RemData: iFieldData); VIRTUAL;
    FUNCTION TestFieldData(CONST TestData: iFieldData): Boolean; VIRTUAL;
    FUNCTION GetFirstEntity: iFieldData;
    FUNCTION GetNextEntity: iFieldData;
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest Inventory-Einträge</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetInventory(Index: integer): iGameObject;
    /// <author>Rosewich</author>
    /// <Info>diese Methode setzt Inventory-Einträge</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetInventory(Index: integer; Newval: iGameObject);
    /// <author>Rosewich</author>
    /// <Info>diese Methode fügt Objekte zum Inventory hinzu</Info>
    /// <since>02.10.2012</since>
    PROCEDURE AppendObject(NewObj: iGameObject);
    /// <author>Rosewich</author>
    /// <Info>diese Methode Löscht Objekte vom Inventory</Info>
    /// <since>02.10.2012</since>
    PROCEDURE RemoveObject(OldObj: iGameObject);
    /// <author>Rosewich</author>
    /// <Info>diese Methode setzt Koordinaten</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetKoor(NewX, NewY: integer);
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest die X-Koordinate</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetXKoor: integer;
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest die Y-Koordinate</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetYKoor: integer;
    /// <author>Rosewich</author>
    /// <Info>Liefert gültige FieldTypen für diese Klasse</Info>
    /// <since>26.09.2012</since>
    Class function FieldTypes:TFieldTypes;virtual;abstract;
  END;

  TBoardBase = CLASS(TComponent)
  PRIVATE
    FSizeX, FSizeY: integer;
    Boarddata:      ARRAY OF TField;
    Entitys:        ARRAY OF iEntity;
    PROCEDURE SetField(x, y: integer; NewField: TField);
    FUNCTION GetField(x, y: integer): TField;
  PUBLIC
    FUNCTION GetEntityIndex(NewObj: iEntity): integer;
    PROPERTY SizeX: integer READ FSizeX;
    PROPERTY SizeY: integer READ FSizeY;
    PROPERTY Field[x, y: integer]: TField READ GetField WRITE SetField;
    PROCEDURE SetSize(NewX, NewY: integer);
    PROCEDURE Delete(DelObj: iEntity);
    PROCEDURE Append(NewObj: iEntity);
    PROCEDURE MoveObject(CONST Obj: iFieldData; OldX, OldY: integer);
    PROCEDURE PreMove;
    PROCEDURE ExecMove;
  END;

  TGameObjectBase = CLASS(TComponent, iGameObject)
  PUBLIC
    /// <author>Rosewich</author>
    /// <Info>Bestimmt ob dies ein Lebewesen ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetIsEntity: Boolean;
    /// <author>Rosewich</author>
    /// <Info>Bestimmt ob dies ein Objekt ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetIsObject: Boolean;
    /// <author>Rosewich</author>
    /// <Info>Bestimmt was für ein Objekt es ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetObjectType: integer;virtual;abstract;
    /// <author>Rosewich</author>
    /// <Info>Liest Eigenschaft</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetProperty(Index: variant): variant;
    /// <author>Rosewich</author>
    /// <Info>Setzt eine Eigenschaft</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetProperty(Index, Newval: variant);
    /// <author>Rosewich</author>
    /// <Info>In dieser Methode werden Aktionen vorbereitet</Info>
    /// <since>26.09.2012</since>
    PROCEDURE PreMove; VIRTUAL; ABSTRACT;
    /// <author>Rosewich</author>
    /// <Info>In dieser Methode werden Aktionen ausgeführt</Info>
    /// <since>26.09.2012</since>
    PROCEDURE ExecMove; VIRTUAL; ABSTRACT;
    /// <author>Rosewich</author>
    /// <Info>diese Methode setzt Koordinaten</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetKoor(NewX, NewY: integer); VIRTUAL; ABSTRACT;
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest die X-Koordinate</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetXKoor: integer;
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest die Y-Koordinate</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetYKoor: integer;
  END;

  TPlayerBase = CLASS(TComponent, iEntity, iCanHoldObject)
  PRIVATE
    FInventory: ARRAY OF iGameObject;
    FXKoor:     integer;
    FYKoor:     integer;
    FUNCTION GetObjectIndex(CONST NewData: iFieldData): integer;
  PUBLIC
    /// <author>Rosewich</author>
    /// <Info>Bestimmt ob dies ein Lebewesen ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetIsEntity: Boolean;
    /// <author>Rosewich</author>
    /// <Info>Bestimmt ob dies ein Objekt ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetIsObject: Boolean;
    /// <author>Rosewich</author>
    /// <Info>Bestimmt was für ein Lebewesen dies ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetEntitytype: integer;
    /// <author>Rosewich</author>
    /// <Info>Liest Eigenschaft</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetProperty(Index: variant): variant;
    /// <author>Rosewich</author>
    /// <Info>Setzt eine Eigenschaft</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetProperty(Index, Newval: variant);
    /// <author>Rosewich</author>
    /// <Info>In dieser Methode werden Aktionen vorbereitet</Info>
    /// <since>26.09.2012</since>
    PROCEDURE PreMove;virtual;
    /// <author>Rosewich</author>
    /// <Info>In dieser Methode werden Aktionen ausgeführt</Info>
    /// <since>26.09.2012</since>
    PROCEDURE ExecMove;virtual;
    /// <author>Rosewich</author>
    /// <Info>diese Methode setzt Koordinaten</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetKoor(NewX, NewY: integer);
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest die X-Koordinate</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetXKoor: integer;
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest die Y-Koordinate</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetYKoor: integer;
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest Inventory-Einträge</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetInventory(Index: integer): iGameObject;
    /// <author>Rosewich</author>
    /// <Info>diese Methode setzt Inventory-Einträge</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetInventory(Index: integer; Newval: iGameObject);
    /// <author>Rosewich</author>
    /// <Info>diese Methode fügt Objekte zum Inventory hinzu</Info>
    /// <since>02.10.2012</since>
    PROCEDURE AppendObject(NewObj: iGameObject);
    /// <author>Rosewich</author>
    /// <Info>diese Methode Löscht Objekte vom Inventory</Info>
    /// <since>02.10.2012</since>
    PROCEDURE RemoveObject(OldObj: iGameObject);
  END;

  TEnemyBase = CLASS(TComponent, iEntity, iCanHoldObject)
  PRIVATE
    FXKoor:     integer;
    FYKoor:     integer;
    FInventory: ARRAY OF iGameObject;
    FUNCTION GetObjectIndex(CONST NewData: iFieldData): integer;
  PUBLIC
    /// <author>Rosewich</author>
    /// <Info>Bestimmt ob dies ein Lebewesen ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetIsEntity: Boolean;
    /// <author>Rosewich</author>
    /// <Info>Bestimmt ob dies ein Objekt ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetIsObject: Boolean;
    /// <author>Rosewich</author>
    /// <Info>Bestimmt was für ein Lebewesen dies ist</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetEntitytype: integer;virtual;abstract;
    /// <author>Rosewich</author>
    /// <Info>Liest Eigenschaft</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetProperty(Index: variant): variant;
    /// <author>Rosewich</author>
    /// <Info>Setzt eine Eigenschaft</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetProperty(Index, Newval: variant);
    /// <author>Rosewich</author>
    /// <Info>In dieser Methode werden Aktionen vorbereitet</Info>
    /// <since>26.09.2012</since>
    PROCEDURE PreMove;
    /// <author>Rosewich</author>
    /// <Info>In dieser Methode werden Aktionen ausgeführt</Info>
    /// <since>26.09.2012</since>
    PROCEDURE ExecMove;
    /// <author>Rosewich</author>
    /// <Info>diese Methode setzt Koordinaten</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetKoor(NewX, NewY: integer);
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest die X-Koordinate</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetXKoor: integer;
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest die Y-Koordinate</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetYKoor: integer;
    /// <author>Rosewich</author>
    /// <Info>diese Methode liest Inventory-Einträge</Info>
    /// <since>26.09.2012</since>
    FUNCTION GetInventory(Index: integer): iGameObject;
    /// <author>Rosewich</author>
    /// <Info>diese Methode setzt Inventory-Einträge</Info>
    /// <since>26.09.2012</since>
    PROCEDURE SetInventory(Index: integer; Newval: iGameObject);
    /// <author>Rosewich</author>
    /// <Info>diese Methode fügt Objekte zum Inventory hinzu</Info>
    /// <since>02.10.2012</since>
    PROCEDURE AppendObject(NewObj: iGameObject);
    /// <author>Rosewich</author>
    /// <Info>diese Methode Löscht Objekte vom Inventory</Info>
    /// <since>02.10.2012</since>
    PROCEDURE RemoveObject(OldObj: iGameObject);
  END;

  TObjClass = class of TGameObjectBase;
  TEnemyClass = class of TEnemyBase;
  TFieldClass = class of TField;

IMPLEMENTATION

FUNCTION TField.GetFDIndex(CONST NewData: iFieldData): integer;
VAR
  I: integer;

BEGIN
  result := -1;
  FOR I := LOW(Data) TO HIGH(Data) DO
    IF Data[I] = NewData THEN
      BEGIN
        result := I;
        break;
      END;
END;

PROCEDURE TField.AppendFieldData(CONST NewData: iFieldData);
VAR
  Index: integer;

BEGIN
  INDEX := GetFDIndex(NewData);
  IF INDEX = -1 THEN
    BEGIN
      Setlength(Data, HIGH(Data) + 2);
      IF NewData.isObject THEN
        BEGIN
          WHILE assigned(Data[maxObjIdx]) AND Data[maxObjIdx].isObject DO
            inc(maxObjIdx);
          Data[HIGH(Data)] := Data[maxObjIdx];
          Data[maxObjIdx] := NewData;
        END
      ELSE
        Data[HIGH(Data)] := NewData;
    END;
END;

PROCEDURE TField.RemoveFieldData(CONST RemData: iFieldData);

VAR
  Index: integer;

BEGIN
  INDEX := GetFDIndex(RemData);
  IF INDEX > -1 THEN
    BEGIN
      IF RemData.isObject THEN
        BEGIN
          Data[INDEX] := Data[maxObjIdx];
          Data[maxObjIdx] := Data[HIGH(Data)];
          dec(maxObjIdx);
        END
      ELSE
        Data[INDEX] := Data[HIGH(Data)];
      Setlength(Data, HIGH(Data));
    END;
END;

FUNCTION TField.TestFieldData(CONST TestData: iFieldData): Boolean;
BEGIN
  result := GetFDIndex(TestData) > -1;
END;

FUNCTION TField.GetFirstEntity: iFieldData;
BEGIN
  FEntityEnum := maxObjIdx + 1;
  IF FEntityEnum <= HIGH(Data) THEN
    result := Data[FEntityEnum]
  ELSE
    result := NIL;
END;

FUNCTION TField.GetNextEntity: iFieldData;
BEGIN
  inc(FEntityEnum);
  IF FEntityEnum <= HIGH(Data) THEN
    result := Data[FEntityEnum]
  ELSE
    result := NIL;
END;

FUNCTION TField.GetInventory(Index: integer): iGameObject;
BEGIN
  IF (INDEX <= HIGH(Data)) AND (INDEX >= LOW(Data)) THEN
    IF Data[INDEX].isObject THEN
      result := iGameObject(Data[INDEX])
    ELSE
      result := NIL
  ELSE
    result := NIL;
END;

PROCEDURE TField.SetInventory(Index: integer; Newval: iGameObject);
BEGIN
  IF (INDEX <= HIGH(Data)) AND (INDEX >= LOW(Data)) AND
    NOT assigned(Newval) THEN
    BEGIN
      dec(maxObjIdx);
    END;
  IF (INDEX <= HIGH(Data)) AND (INDEX >= LOW(Data)) AND
    Data[INDEX].isObject THEN
    Data[INDEX] := Newval
  ELSE
    AppendObject(Newval);
END;

PROCEDURE TField.AppendObject(NewObj: iGameObject);
VAR
  idx: integer;
BEGIN
  idx := GetFDIndex(NewObj);
  IF idx > 0 THEN
    BEGIN
      Setlength(Data, HIGH(Data) + 2);
      WHILE assigned(Data[maxObjIdx]) AND Data[maxObjIdx].isObject DO
        inc(maxObjIdx);
      Data[HIGH(Data)] := Data[maxObjIdx];
      Data[maxObjIdx] := NewObj;
    END;
END;

PROCEDURE TField.RemoveObject(OldObj: iGameObject);

BEGIN
  RemoveFieldData(OldObj);
END;

{$REGION  'TGameObjectBase Methoden ...'}

FUNCTION TGameObjectBase.GetIsEntity: Boolean;
BEGIN
  result := false;
END;

FUNCTION TGameObjectBase.GetIsObject: Boolean;
BEGIN
  result := true;
END;

FUNCTION TGameObjectBase.GetProperty(Index: variant): variant;
BEGIN
END;

PROCEDURE TGameObjectBase.SetProperty(Index, Newval: variant);
BEGIN
END;

FUNCTION TGameObjectBase.GetYKoor: integer;
BEGIN
  IF Owner.InheritsFrom(TField) THEN
    result := TField(Owner).GetYKoor
  ELSE IF Owner.InheritsFrom(TEnemyBase) THEN
    result := TEnemyBase(Owner).GetYKoor
  ELSE IF Owner.InheritsFrom(TPlayerBase) THEN
    result := TPlayerBase(Owner).GetYKoor
  ELSE
    result := -1;
END;

FUNCTION TGameObjectBase.GetXKoor: integer;
BEGIN
  IF Owner.InheritsFrom(TField) THEN
    result := TField(Owner).GetYKoor
  ELSE IF Owner.InheritsFrom(TEnemyBase) THEN
    result := TEnemyBase(Owner).GetYKoor
  ELSE IF Owner.InheritsFrom(TPlayerBase) THEN
    result := TPlayerBase(Owner).GetYKoor
  ELSE
    result := -1;
END;

{$ENDREGION  TGameObjectBase}
{$REGION 'TEnemyBase Methoden ...'}

FUNCTION TEnemyBase.GetIsEntity: Boolean;
BEGIN
  result := true;
END;

FUNCTION TEnemyBase.GetIsObject: Boolean;
BEGIN
  result := false;
END;

FUNCTION TEnemyBase.GetProperty(Index: variant): variant;
BEGIN
END;

PROCEDURE TEnemyBase.SetProperty(Index, Newval: variant);
BEGIN
END;

PROCEDURE TEnemyBase.PreMove;
BEGIN
END;

PROCEDURE TEnemyBase.ExecMove;
BEGIN
END;

PROCEDURE TEnemyBase.SetKoor(NewX, NewY: integer);
VAR
  OldX, OldY: integer;
BEGIN
  // Wenn Koordinate Unterschiedlich ...
  IF (FXKoor <> NewX) OR (FYKoor <> NewY) THEN
    BEGIN
      // Entferne Entity von Field
      // TBoardBase(Owner).Delete(self);
      OldX := FXKoor;
      OldY := FYKoor;
      FXKoor := NewX;
      FYKoor := NewY;
      TBoardBase(Owner).MoveObject(iFieldData(iEntity(self)), OldX, OldY);
      // TBoardBase(Owner).Append(self);
      // Setze Entity auf neues Field
    END;
END;

FUNCTION TEnemyBase.GetXKoor: integer;
BEGIN
  result := FXKoor;
END;

FUNCTION TEnemyBase.GetYKoor: integer;
BEGIN
  result := FYKoor;
END;

FUNCTION TEnemyBase.GetInventory(Index: integer): iGameObject;
BEGIN
  IF (INDEX <= HIGH(FInventory)) AND (INDEX >= LOW(FInventory)) THEN
    result := FInventory[INDEX]
  ELSE
    result := NIL;
END;

PROCEDURE TEnemyBase.SetInventory(Index: integer; Newval: iGameObject);
BEGIN
  IF assigned(Newval) THEN
    BEGIN
      IF (INDEX <= HIGH(FInventory)) AND (INDEX >= LOW(FInventory)) THEN
        FInventory[INDEX] := Newval
      ELSE
        BEGIN
          Setlength(FInventory, HIGH(FInventory) + 2);
          FInventory[INDEX] := Newval;
        END
    END
  ELSE
    BEGIN
      IF (INDEX <= HIGH(FInventory)) AND (INDEX >= LOW(FInventory)) THEN
        BEGIN
          FInventory[INDEX] := FInventory[HIGH(FInventory)];
          Setlength(FInventory, HIGH(FInventory));
        END;
    END;
END;
{$ENDREGION}
{$REGION 'TPlayerBase Methoden ...'}

FUNCTION TPlayerBase.GetIsEntity: Boolean;
BEGIN
  result := true;
END;

FUNCTION TPlayerBase.GetIsObject: Boolean;
BEGIN
  result := false;
END;

FUNCTION TPlayerBase.GetEntityType: integer;
BEGIN
  result := -1; { 1. Spieler }
END;

FUNCTION TPlayerBase.GetProperty(Index: variant): variant;
BEGIN
END;

PROCEDURE TPlayerBase.SetProperty(Index, Newval: variant);
BEGIN
END;

PROCEDURE TPlayerBase.PreMove;
BEGIN
END;

PROCEDURE TPlayerBase.ExecMove;
BEGIN
END;

PROCEDURE TPlayerBase.SetKoor(NewX, NewY: integer);
VAR
  OldX, OldY: integer;
BEGIN
  // Wenn Koordinate Unterschiedlich ...
  IF (FXKoor <> NewX) OR (FYKoor <> NewY) THEN
    BEGIN
      // Entferne Entity von Field
      // TBoardBase(Owner).Delete(self);
      OldX := FXKoor;
      OldY := FYKoor;
      FXKoor := NewX;
      FYKoor := NewY;
      if assigned(Owner) then
        TBoardBase(Owner).MoveObject(iFieldData(iEntity(self)), OldX, OldY);
      // TBoardBase(Owner).Append(self);
      // Setze Entity auf neues Field
    END;
END;

FUNCTION TPlayerBase.GetXKoor: integer;
BEGIN
  result := FXKoor;
END;

FUNCTION TPlayerBase.GetYKoor: integer;
BEGIN
  result := FYKoor;
END;

FUNCTION TPlayerBase.GetInventory(Index: integer): iGameObject;
BEGIN
  IF (INDEX <= HIGH(FInventory)) AND (INDEX >= LOW(FInventory)) THEN
    result := FInventory[INDEX]
  ELSE
    result := NIL;
END;

PROCEDURE TPlayerBase.SetInventory(Index: integer; Newval: iGameObject);
BEGIN
  IF assigned(Newval) THEN
    BEGIN
      IF (INDEX <= HIGH(FInventory)) AND (INDEX >= LOW(FInventory)) THEN
        FInventory[INDEX] := Newval
      ELSE
        BEGIN
          Setlength(FInventory, HIGH(FInventory) + 2);
          FInventory[INDEX] := Newval;
        END
    END
  ELSE
    BEGIN
      IF (INDEX <= HIGH(FInventory)) AND (INDEX >= LOW(FInventory)) THEN
        BEGIN
          FInventory[INDEX] := FInventory[HIGH(FInventory)];
          Setlength(FInventory, HIGH(FInventory));
        END;
    END;
END;
{$ENDREGION}
{$REGION 'TBoardBase Methoden ...'}

PROCEDURE TBoardBase.SetField(x, y: integer; NewField: TField);
BEGIN
  Boarddata[x + y * (FSizeX + 1)] := NewField;
  NewField.SetKoor(x, y);
END;

FUNCTION TBoardBase.GetEntityIndex(NewObj: iEntity): integer;
VAR
  I: integer;
BEGIN
  result := -1;
  FOR I := LOW(Entitys) TO HIGH(Entitys) DO
    IF Entitys[I] = NewObj THEN
      BEGIN
        result := I;
        break;
      END;
END;

FUNCTION TBoardBase.GetField(x, y: integer): TField;
BEGIN
  IF (x + y * (FSizeX + 1)) <= HIGH(Boarddata) THEN
    result := Boarddata[x + y * (FSizeX + 1)]
  ELSE
    result := NIL;
END;

PROCEDURE TBoardBase.SetSize(NewX, NewY: integer);
BEGIN
  FSizeX := NewX;
  FSizeY := NewY;
  Setlength(Boarddata, (NewY + 1) * (NewX + 1) + 1);
END;

PROCEDURE TBoardBase.Append(NewObj: iEntity);
VAR
  x, y, idx: integer;
BEGIN
  x := NewObj.XKoor;
  y := NewObj.YKoor;
  if assigned(Field[x, y]) then
    Field[x, y].AppendFieldData(NewObj);
  idx := GetEntityIndex(NewObj);
  IF idx = -1 THEN
    BEGIN
      Setlength(Entitys, HIGH(Entitys) + 2);
      Entitys[HIGH(Entitys)] := NewObj;
    END;
END;

PROCEDURE TBoardBase.Delete(DelObj: iEntity);
VAR
  x, y, idx: integer;
BEGIN
  x := DelObj.XKoor;
  y := DelObj.YKoor;
  Field[x, y].RemoveFieldData(DelObj);
  idx := GetEntityIndex(DelObj);
  IF idx > -1 THEN
    BEGIN
      Entitys[idx] := Entitys[HIGH(Entitys)];
      Entitys[HIGH(Entitys)] := DelObj;
      Setlength(Entitys, HIGH(Entitys) + 1);
    END;
END;

PROCEDURE TBoardBase.MoveObject(CONST Obj: iFieldData; OldX, OldY: integer);

VAR
  x, y, idx: integer;

BEGIN
  IF Obj.isEntity THEN
    BEGIN
      x := iEntity(Obj).XKoor;
      y := iEntity(Obj).YKoor;
      Field[OldX, OldY].RemoveFieldData(Obj);
      Field[x, y].AppendFieldData(Obj);

      idx := GetEntityIndex(iEntity(Obj));
      IF idx = -1 THEN
        BEGIN
          Setlength(Entitys, HIGH(Entitys) + 2);
          Entitys[HIGH(Entitys)] := iEntity(Obj);
        END;
    END
  ELSE IF true THEN
END;

PROCEDURE TField.SetKoor(NewX, NewY: integer);
BEGIN
  // Wenn Koordinate Unterschiedlich ...
  IF (FXKoor <> NewX) OR (FYKoor <> NewY) THEN
    BEGIN
      // Entferne Entity von Field
      FXKoor := NewX;
      FYKoor := NewY
      // Setze Entity auf neues Field
    END;
END;

FUNCTION TField.GetXKoor: integer;
BEGIN
  result := FXKoor;
END;

FUNCTION TField.GetYKoor: integer;
BEGIN
  result := FYKoor;
END;

PROCEDURE TPlayerBase.AppendObject(NewObj: iGameObject);
VAR
  idx: integer;
BEGIN
  idx := GetObjectIndex(NewObj);
  IF idx = -1 THEN
    BEGIN
      Setlength(FInventory, HIGH(FInventory) + 2);
      FInventory[HIGH(FInventory)] := NewObj;
    END;
END;

PROCEDURE TPlayerBase.RemoveObject(OldObj: iGameObject);
VAR
  idx: integer;
BEGIN
  idx := GetObjectIndex(OldObj);
  IF idx > -1 THEN
    BEGIN
      FInventory[idx] := FInventory[HIGH(FInventory)];
      Setlength(FInventory, HIGH(FInventory));
    END;
END;

FUNCTION TPlayerBase.GetObjectIndex(CONST NewData: iFieldData): integer;
VAR
  I: integer;
BEGIN
  result := -1;
  FOR I := LOW(FInventory) TO HIGH(FInventory) DO
    IF FInventory[I] = NewData THEN
      BEGIN
        result := I;
        break;
      END;
END;

FUNCTION TEnemyBase.GetObjectIndex(CONST NewData: iFieldData): integer;
VAR
  I: integer;
BEGIN
  result := -1;
  FOR I := LOW(FInventory) TO HIGH(FInventory) DO
    IF FInventory[I] = NewData THEN
      BEGIN
        result := I;
        break;
      END;
END;

PROCEDURE TEnemyBase.AppendObject(NewObj: iGameObject);
VAR
  idx: integer;
BEGIN
  idx := GetObjectIndex(NewObj);
  IF idx = -1 THEN
    BEGIN
      Setlength(FInventory, HIGH(FInventory) + 2);
      FInventory[HIGH(FInventory)] := NewObj;
    END;
END;

PROCEDURE TEnemyBase.RemoveObject(OldObj: iGameObject);
VAR
  idx: integer;
BEGIN
  idx := GetObjectIndex(OldObj);
  IF idx > -1 THEN
    BEGIN
      FInventory[idx] := FInventory[HIGH(FInventory)];
      Setlength(FInventory, HIGH(FInventory));
    END;
END;

PROCEDURE TBoardBase.PreMove;
var Ent:iEntity;
BEGIN
  for Ent in Entitys do
    ent.PreMove;
END;

PROCEDURE TBoardBase.ExecMove;
var Ent:iEntity;
BEGIN
  for ent in Entitys do
    ent.ExecMove;
END;
{$ENDREGION}

END.
