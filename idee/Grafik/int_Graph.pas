unit int_Graph;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses {$IFDEF FPC} types,{$ELSE} windows, {$ENDIF}graphics;

type
///<since>
///  </since>
TintGraph = interface
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetVisible(val : boolean);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function GetVisible : boolean;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    property Visible: boolean read GetVisible write SetVisible;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure Show;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure Hide;

    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetBitmap(val : TBitmap);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    Function GetBitmap : TBitmap;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    property bmp:TBitmap read GetBitmap write SetBitmap;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure FormResize(Sender:TObject);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function GetChanged : boolean;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetChanged(val : boolean);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    property Changed : boolean read GetChanged write SetChanged;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function GetbkColor : TColor;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetbkColor(val : TColor);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    property bkColor : TColor read GetbkColor write SetbkColor;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function GetActiveViewPort : TRect;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetActiveViewPort(val : TRect);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    property ActiveViewPort : TRect read GetActiveViewPort write SetActiveViewPort;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure UpdateGraph(Sender:Tobject);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function GetDrawColor : TColor;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure SetDrawColor(val : TColor);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    property DrawColor : TColor read GetDrawColor write SetDrawColor;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    function Getkkey : char;
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    procedure Setkkey(val : char);
    ///<author>Rosewich</author>
    ///  <since>16.05.2008</since>
    property kkey : char read Getkkey write Setkkey;
end;

implementation

end.