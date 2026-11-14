unit QRExpr;

{-------------------------------------------------------------------------------
  QRExpr - QuickReport expression evaluator (compatibility stub).

  The original AHNENWIN 5.1 binary links against QuickReport 3.x, whose
  QRExpr unit provides the expression engine used by TQRExpr / TQRExprEditor.
  Neither the DCUs nor the sources of the QuickReport companion units
  (QRCtrls / QRExpr / QRPrntr) are present in this environment:

    * C:\copy\delphi\RAD Studio\3.0\lib contains QuickRpt.dcu only.
    * The IDR decompilation in Source\Projects_AhnenWin\QRExpr.pas is not
      usable as a source: 191 method signatures are left unresolved ("?:")
      and the anonymous-enum artefacts cannot be reconstructed.

  This stub therefore reproduces only the *public surface* that the AHNENWIN
  resources and the reconstructed application units actually reference:
  the expression element / evaluator / result types.

  It deliberately provides NO evaluation logic. Every expression used by the
  reconstructed reports is either a built-in QuickReport function
  (PAGENUMBER, COLUMNNUMBER, REPORTTITLE - see Forms\Form15.dfm) or is
  evaluated by QuickRpt itself.

  Dependency direction: QRExpr must NOT reference QuickRpt, because QuickRpt
  references QRExpr. Keeping this unit leaf-level avoids a circular unit
  reference (E2047), which was verified empirically with dcc32 17.0.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, DB;

type
  { Element kinds understood by the original evaluator. The decompilation
    could not recover the original enumeration, so the values are placeholders
    and carry no behaviour. }
  TQREvElementType = (etUnknown, etConstant, etField, etFunction, etAggregate,
                      etSubtotal, etDataset, etVariable, etOperation,
                      etFormat, etBuiltIn);

  TQREvElement = class(TObject)
  private
    FElementType: TQREvElementType;
    FExpression: String;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property ElementType: TQREvElementType read FElementType write FElementType;
    property Expression: String read FExpression write FExpression;
  end;

  { Result of an expression evaluation. }
  TQREvResult = class(TObject)
  private
    FValue: String;
    FIsNull: Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Value: String read FValue write FValue;
    property IsNull: Boolean read FIsNull write FIsNull;
  end;

  { Evaluator. The original binds to a dataset and walks the expression tree.
    The stub keeps only the state that the reconstructed units assign. }
  TQREvaluator = class(TObject)
  private
    FExpression: String;
    FDataSet: TDataSet;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Expression: String read FExpression write FExpression;
    property DataSet: TDataSet read FDataSet write FDataSet;
  end;

  { Operator used by the original expression parser. }
  TQROperator = (opNone, opAdd, opSub, opMul, opDiv, opMod, opConcat,
                 opEQ, opNE, opLT, opLE, opGT, opGE, opAnd, opOr, opNot);

  { Notification kinds broadcast by QuickReport to its bands and labels. }
  TQRNotifyOperation = (qrnoPrepare, qrnoPrint, qrnoUnprepare, qrnoPage,
                        qrnoReset, qrnoClear, qrnoRestore);

  TQRNotifyEvent = procedure(Sender: TObject; Operation: TQRNotifyOperation) of object;

implementation

constructor TQREvElement.Create;
begin
  inherited Create;
  FElementType := etUnknown;
end;

destructor TQREvElement.Destroy;
begin
  inherited Destroy;
end;

constructor TQREvResult.Create;
begin
  inherited Create;
  FIsNull := True;
end;

destructor TQREvResult.Destroy;
begin
  inherited Destroy;
end;

constructor TQREvaluator.Create;
begin
  inherited Create;
end;

destructor TQREvaluator.Destroy;
begin
  inherited Destroy;
end;

end.
