unit QRCtrls;

{-------------------------------------------------------------------------------
  QRCtrls - QuickReport report elements (compatibility stub).

  QuickReport 3.x provides the visual report elements (label, memo, dbtext,
  image, shape, sysdata) in QRCtrls. Neither the DCU nor the source is
  available in this environment:

    * C:\copy\delphi\RAD Studio\3.0\lib contains QuickRpt.dcu only.
    * The IDR decompilation in Source\Projects_AhnenWin\QRCtrls.pas is not
      usable as a source: 40 method signatures remain unresolved ("?:") and
      the class bodies are damaged.

  This stub reproduces the public surface that the AHNENWIN resources stream.
  The property set was derived from the DFM files:

    Forms/Form5.dfm, Forms/Form15.dfm, Forms/Form23.dfm, Forms/Form25.dfm
      TQRLabel    : Caption, Alignment, AutoStretch, Font.*, Frame.*, Size.*
      TQRMemo     : Caption, Lines.Strings, Alignment, AutoStretch, Font.*, ...
      TQRDBText   : DataField, DataSet, Caption, Alignment, AutoStretch, ...
      TQRExpr     : Expression, Master, Caption, ...
      TQRSysData  : Data, Text, Caption, Alignment, ...
      TQRShape    : Shape, Brush.*, Pen.*, Frame.*, ...
      TQRImage    : Picture, AutoSize, Stretch, Center, Frame.*, ...

  No rendering is performed. The stub exists so that the AHNENWIN report
  forms stream, load and display their layout.

  Dependency direction: QRCtrls references QuickRpt, never the other way
  round, to avoid a circular unit reference (E2047).
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, DB, Controls, Graphics, QuickRpt;

type
  { Data source kinds for TQRSysData. }
  TQRSysDataType = (qrsTime, qrsDate, qrsDateTime, qrsPageNumber,
                    qrsReportTitle, qrsDetailCount, qrsDetailNo);

  { Shape kinds for TQRShape. }
  TQRShapeType = (qrsRectangle, qrsCircle, qrsVertLine, qrsHorLine,
                  qrsTopAndBottom, qrsRightAndLeft);

  { A report label.

    The AHNENWIN resources stream these properties on a label:
      Alignment, AlignToBand, AutoSize, AutoStretch, Caption, Color,
      Font.*, Frame.*, Height, Left, ParentFont, Size.Values, Top,
      Transparent, Width, WordWrap

    Most of them come from TQRPrintable (which descends from TControl). }
  TQRCustomLabel = class(TQRPrintable)
  private
    FCaption: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetCaption(Value: String);
  published
    property Caption: String read FCaption write SetCaption;
  end;

  TQRLabel = class(TQRCustomLabel);

  { A multi-line report label. }
  TQRMemo = class(TQRCustomLabel)
  private
    FLines: TStringList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetLines(Value: TStringList);
  published
    { The resources stream the memo text under "Lines.Strings". }
    property Lines: TStringList read FLines write SetLines;
  end;

  { A report text bound to a dataset field. }
  TQRDBText = class(TQRCustomLabel)
  private
    FDataSet: TDataSet;
    FDataField: String;
    FMask: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetDataSet(Value: TDataSet);
    procedure SetDataField(Value: String);
    procedure SetMask(Value: String);
  published
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property DataField: String read FDataField write SetDataField;
    property Mask: String read FMask write SetMask;
  end;

  { A report text bound to an expression. }
  TQRExpr = class(TQRCustomLabel)
  private
    FExpression: String;
    FMask: String;
    FMaster: TComponent;
    FResetAfterPrint: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetExpression(Value: String);
    procedure SetMask(Value: String);
    procedure SetMaster(Value: TComponent);
  published
    property Expression: String read FExpression write SetExpression;
    property Mask: String read FMask write SetMask;
    property Master: TComponent read FMaster write SetMaster;
    property ResetAfterPrint: Boolean read FResetAfterPrint
      write FResetAfterPrint;
  end;

  { A report text bound to a system value.

    The enumeration is recovered verbatim from the decompilation of
    Source\Projects_AhnenWin\QRCtrls.pas:
      TQRSysDataType = (qrsTime, qrsDate, qrsDateTime, qrsPageNumber,
                        qrsReportTitle, qrsDetailCount, qrsDetailNo)
    and the resources stream "Data = qrsDate" / "Data = qrsPageNumber". }
  TQRSysData = class(TQRCustomLabel)
  private
    FData: TQRSysDataType;
    FText: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetData(Value: TQRSysDataType);
    procedure SetText(Value: String);
  published
    property Data: TQRSysDataType read FData write SetData;
    property Text: String read FText write SetText;
  end;

  { A drawn shape.

    The enumeration is recovered verbatim from the decompilation of
    Source\Projects_AhnenWin\QRCtrls.pas:
      TQRShapeType = (qrsRectangle, qrsCircle, qrsVertLine, qrsHorLine,
                      qrsTopAndBottom, qrsRightAndLeft)
    and the resources stream "Shape = qrsHorLine". }
  TQRShape = class(TQRPrintable)
  private
    FShape: TQRShapeType;
    FBrush: TBrush;
    FPen: TPen;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetShape(Value: TQRShapeType);
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
  published
    property Shape: TQRShapeType read FShape write SetShape;
    property Brush: TBrush read FBrush write SetBrush;
    property Pen: TPen read FPen write SetPen;
  end;

  { A picture. }
  TQRImage = class(TQRPrintable)
  private
    FPicture: TPicture;
    FQRAutoSize: Boolean;
    FStretch: Boolean;
    FCenter: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetPicture(Value: TPicture);
    procedure SetQRAutoSize(Value: Boolean);
    procedure SetStretch(Value: Boolean);
    procedure SetCenter(Value: Boolean);
  published
    property Picture: TPicture read FPicture write SetPicture;
    { The property is named AutoSize in the QuickReport resources, but
      TControl already declares an AutoSize property, so the setter is
      spelled differently while the property keeps the streamed name. }
    property AutoSize: Boolean read FQRAutoSize write SetQRAutoSize;
    property Stretch: Boolean read FStretch write SetStretch;
    property Center: Boolean read FCenter write SetCenter;
  end;

implementation

{ TQRCustomLabel }

constructor TQRCustomLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TQRCustomLabel.SetCaption(Value: String);
begin
  FCaption := Value;
end;

{ TQRMemo }

constructor TQRMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLines := TStringList.Create;
end;

destructor TQRMemo.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

procedure TQRMemo.SetLines(Value: TStringList);
begin
  FLines.Assign(Value);
end;

{ TQRDBText }

constructor TQRDBText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TQRDBText.SetDataSet(Value: TDataSet);
begin
  FDataSet := Value;
end;

procedure TQRDBText.SetDataField(Value: String);
begin
  FDataField := Value;
end;

procedure TQRDBText.SetMask(Value: String);
begin
  FMask := Value;
end;

{ TQRExpr }

constructor TQRExpr.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TQRExpr.SetExpression(Value: String);
begin
  FExpression := Value;
end;

procedure TQRExpr.SetMask(Value: String);
begin
  FMask := Value;
end;

procedure TQRExpr.SetMaster(Value: TComponent);
begin
  FMaster := Value;
end;

{ TQRSysData }

constructor TQRSysData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FData := qrsTime;
end;

procedure TQRSysData.SetData(Value: TQRSysDataType);
begin
  FData := Value;
end;

procedure TQRSysData.SetText(Value: String);
begin
  FText := Value;
end;

{ TQRShape }

constructor TQRShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShape := qrsRectangle;
  FBrush := TBrush.Create;
  FPen := TPen.Create;
end;

destructor TQRShape.Destroy;
begin
  FBrush.Free;
  FPen.Free;
  inherited Destroy;
end;

procedure TQRShape.SetShape(Value: TQRShapeType);
begin
  FShape := Value;
end;

procedure TQRShape.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TQRShape.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

{ TQRImage }

constructor TQRImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPicture := TPicture.Create;
end;

destructor TQRImage.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

procedure TQRImage.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TQRImage.SetQRAutoSize(Value: Boolean);
begin
  FQRAutoSize := Value;
end;

procedure TQRImage.SetStretch(Value: Boolean);
begin
  FStretch := Value;
end;

procedure TQRImage.SetCenter(Value: Boolean);
begin
  FCenter := Value;
end;

end.
