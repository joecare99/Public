UNIT BarChart;

{$ifdef FPC}
{$MODE Delphi}
{$endif}

INTERFACE

USES
{$ifdef FPC}
  LCLIntf, LCLType, LMessages,
{$else}
{$endif}
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs;

TYPE
  TBarChart = CLASS(TGraphicControl)
  PRIVATE
    FPen:                   TPen;
    FBrush:                 TBrush;
    FData:                  TStrings;
    FLabels:                Boolean;
    XBase, YBase:           Integer;
    XIncrement, YIncrement: Integer;
    PROCEDURE SetPen(Value: TPen);
    PROCEDURE SetBrush(Value: TBrush);
    PROCEDURE SetData(Value: TStrings);
    PROCEDURE SetLabels(Value: Boolean);
    FUNCTION YData(N: Integer): Integer;
  PROTECTED
    PROCEDURE Paint; OVERRIDE;
  PUBLIC
    CONSTRUCTOR Create(AOwner: TComponent); OVERRIDE;
    DESTRUCTOR Destroy; OVERRIDE;
  PUBLISHED
    PROCEDURE StyleChanged(Sender: TObject);
    PROPERTY Pen: TPen READ FPen WRITE SetPen;
    PROPERTY Brush: TBrush READ FBrush WRITE SetBrush;
    PROPERTY Data: TStrings READ FData WRITE SetData;
    PROPERTY Labels: Boolean READ FLabels WRITE SetLabels;
    PROPERTY DragCursor;
    PROPERTY DragMode;
    PROPERTY Enabled;
    PROPERTY ParentShowHint;
    PROPERTY ShowHint;
    PROPERTY Visible;
    PROPERTY OnDragDrop;
    PROPERTY OnDragOver;
    PROPERTY OnEndDrag;
    PROPERTY OnMouseDown;
    PROPERTY OnMouseMove;
    PROPERTY OnMouseUp;
  END;

PROCEDURE Register;

IMPLEMENTATION

CONST
  { Fixed constants }
  numClrs         = 16; { Number of colors in colorArray }
  spaceAtBottom   = 10; { Reserved pixels below chart }
  spaceAtLeft     = 20; { Reserved pixels at left of chart }
  spaceAtTop      = 40; { Reserved pixels above chart }
  spaceAtRight    = 20; { Reserved pixels at right of chart }
  yScaleMax       = 100.0; { Maximum Y scale value }
  yScaleIncrement = 10.0; { Increment for Y scale markers }
  { Typed constants }
  spaceVertical: Integer   = spaceAtTop + spaceAtBottom;
  spaceHorizontal: Integer = spaceAtLeft + spaceAtRight;
  yScale: Integer          = Trunc(yScaleMax / yScaleIncrement);
  { Array of colors used to draw topmost bars }
  colorArray: ARRAY [0 .. numClrs - 1] OF TColor = ($0000000, $0FFFFFF, $0FF0000,
    $000FF00, $00000FF, $0FFFF00, $000FFFF, $0FF00FF, $0880000, $0008800, $0000088,
    $0888800, $0008888, $0880088, $0448844, $0884488);

  { Delphi calls this to install component onto the VCL palette }
PROCEDURE Register;
BEGIN
  RegisterComponents('Samples', [TBarChart]);
END;

{ Create component instance at runtime AND design time }
CONSTRUCTOR TBarChart.Create(AOwner: TComponent);
BEGIN
  INHERITED Create(AOwner); { Call inherited constructor ! }
  Width := 65;
  Height := 65;
  FPen := TPen.Create;
  FPen.OnChange := StyleChanged;
  FBrush := TBrush.Create;
  FBrush.OnChange := StyleChanged;
  FData := TStringList.Create;
  FLabels := True;
END;

{ Destroy component instance at runtime AND design time }
DESTRUCTOR TBarChart.Destroy;
BEGIN
  FPen.Free; { Free allocated resources }
  FBrush.Free;
  FData.Free;
  INHERITED Destroy; { Call inherited destructor ! }
END;

{ Return Y coordinate for data point N }
FUNCTION TBarChart.YData(N: Integer): Integer;
VAR
  F: Double;
BEGIN
  F := (StrToFloat(FData[N]) / yScaleIncrement) * YIncrement;
  Result := YBase - Round(F);
END;

{ Paint component shape at runtime AND design time }
PROCEDURE TBarChart.Paint;
VAR
  XMax, YMax:           Integer;
  Width1, WidthD2:      Integer;
  I, X1, Y1, X2, Y2, E: Integer;
BEGIN
  WITH Canvas DO
    BEGIN
      { Erase background }
      Pen.Color := FPen.Color;
      Brush.Color := FBrush.Color;
      X1 := Pen.Width DIV 2;
      Y1 := X1;
      XMax := Width - Pen.Width + 1;
      YMax := Height - Pen.Width + 1;
      Rectangle(X1, Y1, X1 + XMax, Y1 + YMax);
      IF FData.Count = 0 THEN
        Exit;
      { Initialize variables }
      e := -1;
      TRY
        XIncrement := (XMax - spaceHorizontal) DIV FData.Count;
        YIncrement := (YMax - spaceVertical) DIV yScale;
        Width1 := XIncrement DIV 2;
        WidthD2 := Width1 DIV 2;
        XBase := spaceAtLeft + WidthD2;
        YBase := YMax - spaceAtBottom;
        Canvas.Font := Self.Font;
        { Draw barchart }
        FOR I := 0 TO FData.Count - 1 DO
          BEGIN
            E := I; // Because I may be undefined after for-loop
            X1 := spaceAtLeft + (XIncrement * I);
            Y1 := YData(I);
            X2 := X1 + Width1;
            Y2 := YBase;
            IF FLabels THEN
              BEGIN
                Brush.Color := FBrush.Color;
                TextOut(X1, Y1 - 30, FData.Strings[I]);
              END;
            Brush.Color := clBlack;
            Rectangle(X1 + 4, Y1 - 4, X2 + 4, Y2 - 4);
            Brush.Color := colorArray[(I + 2) MOD numClrs];
            Rectangle(X1, Y1, X2, Y2);
          END;
      EXCEPT
        ShowMessage('Error in data point ' + IntToStr(E));
        FData.Clear;
        Invalidate;
      END;
    END;
END;

{ Local event handler redraws shape when necessary }
PROCEDURE TBarChart.StyleChanged(Sender: TObject);
BEGIN
  Invalidate;
END;

{ Assign new brush data to FBrush field }
PROCEDURE TBarChart.SetBrush(Value: TBrush);
BEGIN
  FBrush.Assign(Value);
END;

{ Assign new pen data to FPen field }
PROCEDURE TBarChart.SetPen(Value: TPen);
BEGIN
  FPen.Assign(Value);
END;

{ Assign new string list to FData field }
PROCEDURE TBarChart.SetData(Value: TStrings);
BEGIN
  FData.Assign(Value);
  Invalidate;
END;

{ Assign new Boolean value to FLabels field }
PROCEDURE TBarChart.SetLabels(Value: Boolean);
BEGIN
  IF FLabels <> Value THEN { Exit if no change needed }
    BEGIN
      FLabels := Value; { Assign to FLabels, NOT Labels ! }
      Invalidate; { Redraw component to add/remove labels }
    END;
END;

END.
