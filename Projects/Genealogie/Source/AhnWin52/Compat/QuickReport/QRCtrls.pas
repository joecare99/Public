unit QRCtrls;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, Controls, Graphics, DB, QRCompatErrors;

type
  TQRBandType = (rbTitle, rbPageHeader, rbColumnHeader, rbDetail,
    rbColumnFooter, rbPageFooter, rbSummary, rbGroupHeader, rbGroupFooter,
    rbSubDetail, rbOverlay);
  TQRShapeType = (qrsRectangle, qrsEllipse, qrsVertLine, qrsHorLine);
  TQRSysDataType = (qrsDate, qrsPageNumber, qrsReportTitle, qrsDetailCount);

  /// Published frame values identified in the recovered QuickReport resources.
  TQRFrame = class(TPersistent)
  private
    FColor: TColor;
    FDrawBottom: Boolean;
    FDrawLeft: Boolean;
    FDrawRight: Boolean;
    FDrawTop: Boolean;
  published
    property Color: TColor read FColor write FColor;
    property DrawBottom: Boolean read FDrawBottom write FDrawBottom;
    property DrawLeft: Boolean read FDrawLeft write FDrawLeft;
    property DrawRight: Boolean read FDrawRight write FDrawRight;
    property DrawTop: Boolean read FDrawTop write FDrawTop;
  end;

  /// Shared geometry and frame fields used by the recovered report layouts.
  TQRVisualComponent = class(TQuickReportCompatComponent)
  private
    FFrame: TQRFrame;
    FHeight: Integer;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
  published
    property Frame: TQRFrame read FFrame write FFrame;
    property Height: Integer read FHeight write FHeight;
    property Left: Integer read FLeft write FLeft;
    property Top: Integer read FTop write FTop;
    property Width: Integer read FWidth write FWidth;
  end;

  TQRBand = class(TQRVisualComponent)
  private
    FAlignToBottom: Boolean;
    FBandType: TQRBandType;
    FColor: TColor;
    FForceNewColumn: Boolean;
    FForceNewPage: Boolean;
  published
    property AlignToBottom: Boolean read FAlignToBottom write FAlignToBottom;
    property BandType: TQRBandType read FBandType write FBandType;
    property Color: TColor read FColor write FColor;
    property ForceNewColumn: Boolean read FForceNewColumn write FForceNewColumn;
    property ForceNewPage: Boolean read FForceNewPage write FForceNewPage;
  end;

  TQRCustomLabel = class(TQRVisualComponent)
  private
    FAlignToBand: Boolean;
    FAlignment: TAlignment;
    FAutoSize: Boolean;
    FAutoStretch: Boolean;
    FCaption: string;
    FColor: TColor;
    FFont: TFont;
    FFontSize: Integer;
    FParentFont: Boolean;
    FTransparent: Boolean;
    FWordWrap: Boolean;
  published
    property AlignToBand: Boolean read FAlignToBand write FAlignToBand;
    property Alignment: TAlignment read FAlignment write FAlignment;
    property AutoSize: Boolean read FAutoSize write FAutoSize;
    property AutoStretch: Boolean read FAutoStretch write FAutoStretch;
    property Caption: string read FCaption write FCaption;
    property Color: TColor read FColor write FColor;
    property Font: TFont read FFont write FFont;
    property FontSize: Integer read FFontSize write FFontSize;
    property ParentFont: Boolean read FParentFont write FParentFont;
    property Transparent: Boolean read FTransparent write FTransparent;
    property WordWrap: Boolean read FWordWrap write FWordWrap;
  end;

  TQRLabel = class(TQRCustomLabel);

  TQRDBText = class(TQRCustomLabel)
  private
    FDataField: string;
    FDataSet: TDataSet;
  published
    property DataField: string read FDataField write FDataField;
    property DataSet: TDataSet read FDataSet write FDataSet;
  end;

  TQRMemo = class(TQRCustomLabel);

  TQRImage = class(TQRVisualComponent)
  private
    FCenter: Boolean;
    FStretch: Boolean;
  published
    property Center: Boolean read FCenter write FCenter;
    property Stretch: Boolean read FStretch write FStretch;
  end;

  TQRShape = class(TQRVisualComponent)
  private
    FShape: TQRShapeType;
  published
    property Shape: TQRShapeType read FShape write FShape;
  end;

  TQRSysData = class(TQRCustomLabel)
  private
    FData: TQRSysDataType;
  published
    property Data: TQRSysDataType read FData write FData;
  end;

implementation

initialization
  RegisterClasses([TQRBand, TQRDBText, TQRImage, TQRLabel, TQRMemo,
    TQRShape, TQRSysData]);

end.
