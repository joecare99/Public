unit DingButtonXControl_TLB;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

// ************************************************************************ //
// WARNUNG                                                                    
// -------                                                                    
// Die in dieser Datei deklarierten Typen wurden aus Daten einer Typbibliothek
// generiert. Wenn diese Typbibliothek explizit oder indirekt (ueber eine     
// andere Typbibliothek) reimportiert wird oder wenn der Befehl            
// 'Aktualisieren' im Typbibliotheks-Editor waehrend des Bearbeitens der     
// Typbibliothek aktiviert ist, wird der Inhalt dieser Datei neu generiert und 
// alle manuell vorgenommenen Aenderungen gehen verloren.                                        
// ************************************************************************ //

// $Rev: 5081 $
// Datei generiert am 07.07.2007 13:13:48 aus der unten beschriebenen Typbibliothek.

// ************************************************************************  //
// Typbib: W:\Daten\Sprachen\Delphi\Delphi Bible\Delphi Bible\source\DingX\DingButtonXControl.tlb (1)
// LIBID: {199D9A87-CC89-11D1-AC07-C54ACBC13325}
// LCID: 0
// Hilfedatei: 
// Hilfe-String: DingButtonXControl Library
// DepndLst: 
//   (1) v1.0 stdole, (C:\WINNT\system32\stdole32.tlb)
//   (2) v2.0 StdType, (C:\WINNT\system32\OLEPRO32.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit muss ohne Typueberpruefung fuer Zeiger compiliert werden. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses
{$IFnDEF FPC}
  OleCtrls, StdVCL, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  ActiveX, Classes, Graphics, Variants;
  

// *********************************************************************//
// In dieser Typbibliothek deklarierte GUIDS . Es werden folgende        
// Praefixe verwendet:                                                     
//   Typbibliotheken     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Nicht-DISP-Interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // Haupt- und Nebenversionen der Typbibliothek
  DingButtonXControlMajorVersion = 1;
  DingButtonXControlMinorVersion = 0;

  LIBID_DingButtonXControl: TGUID = '{199D9A87-CC89-11D1-AC07-C54ACBC13325}';

  IID_IDingButtonX: TGUID = '{199D9A88-CC89-11D1-AC07-C54ACBC13325}';
  DIID_IDingButtonXEvents: TGUID = '{199D9A89-CC89-11D1-AC07-C54ACBC13325}';
  CLASS_DingButtonX: TGUID = '{199D9A8A-CC89-11D1-AC07-C54ACBC13325}';

// *********************************************************************//
// Deklaration von in der Typbibliothek definierten  Aufzählungen                    
// *********************************************************************//
// Konstanten für enum TxDragMode
type
  TxDragMode = TOleEnum;
const
  dmManual = $00000000;
  dmAutomatic = $00000001;

// Konstanten für enum TxMouseButton
type
  TxMouseButton = TOleEnum;
const
  mbLeft = $00000000;
  mbRight = $00000001;
  mbMiddle = $00000002;

type

// *********************************************************************//
// Forward-Deklaration von in der Typbibliothek definierten Typen                    
// *********************************************************************//
  IDingButtonX = interface;
  IDingButtonXDisp = dispinterface;
  IDingButtonXEvents = dispinterface;

// *********************************************************************//
// Deklaration von in der Typbibliothek definierten CoClasses             
// (HINWEIS: Hier wird jede CoClass ihrem Standard-Interface zugewiesen)              
// *********************************************************************//
  DingButtonX = IDingButtonX;


// *********************************************************************//
// Interface: IDingButtonX
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {199D9A88-CC89-11D1-AC07-C54ACBC13325}
// *********************************************************************//
  IDingButtonX = interface(IDispatch)
    ['{199D9A88-CC89-11D1-AC07-C54ACBC13325}']
    procedure Click; safecall;
    function Get_Cancel: WordBool; safecall;
    procedure Set_Cancel(Value: WordBool); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Default: WordBool; safecall;
    procedure Set_Default(Value: WordBool); safecall;
    function Get_DragCursor: Smallint; safecall;
    procedure Set_DragCursor(Value: Smallint); safecall;
    function Get_DragMode: TxDragMode; safecall;
    procedure Set_DragMode(Value: TxDragMode); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    function Get_Font: IFontDisp; safecall;
    procedure Set_Font(const Value: IFontDisp); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_Cursor: Smallint; safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure AboutBox; safecall;
    property Cancel: WordBool read Get_Cancel write Set_Cancel;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Default: WordBool read Get_Default write Set_Default;
    property DragCursor: Smallint read Get_DragCursor write Set_DragCursor;
    property DragMode: TxDragMode read Get_DragMode write Set_DragMode;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property Font: IFontDisp read Get_Font write Set_Font;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Cursor: Smallint read Get_Cursor write Set_Cursor;
  end;

// *********************************************************************//
// DispIntf:  IDingButtonXDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {199D9A88-CC89-11D1-AC07-C54ACBC13325}
// *********************************************************************//
  IDingButtonXDisp = dispinterface
    ['{199D9A88-CC89-11D1-AC07-C54ACBC13325}']
    procedure Click; dispid 1;
    property Cancel: WordBool dispid 2;
    property Caption: WideString dispid 3;
    property Default: WordBool dispid 4;
    property DragCursor: Smallint dispid 5;
    property DragMode: TxDragMode dispid 6;
    property Enabled: WordBool dispid 7;
    property Font: IFontDisp dispid 8;
    property Visible: WordBool dispid 9;
    property Cursor: Smallint dispid 10;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  IDingButtonXEvents
// Flags:     (4096) Dispatchable
// GUID:      {199D9A89-CC89-11D1-AC07-C54ACBC13325}
// *********************************************************************//
  IDingButtonXEvents = dispinterface
    ['{199D9A89-CC89-11D1-AC07-C54ACBC13325}']
    procedure OnClick; dispid 1;
    procedure OnKeyPress(var Key: Smallint); dispid 2;
  end;


// *********************************************************************//
// Klassendeklaration von OLE-Control-Proxy
// Elementname     : TDingButtonX
// Hilfe-String      : DingButtonXControl
// Standard-Interface: IDingButtonX
// Def. Intf. DISP? : No
// Ereignis-Interface: IDingButtonXEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TDingButtonXOnKeyPress = procedure(ASender: TObject; var Key: Smallint) of object;

  TDingButtonX = class(TOleControl)
  private
    FOnClick: TNotifyEvent;
    FOnKeyPress: TDingButtonXOnKeyPress;
    FIntf: IDingButtonX;
    function  GetControlInterface: IDingButtonX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Click; override;
    procedure AboutBox;
    property  ControlInterface: IDingButtonX read GetControlInterface;
    property  DefaultInterface: IDingButtonX read GetControlInterface;
  published
    property Anchors;
    property  TabStop;
    property  Align;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property Cancel: WordBool index 2 read GetWordBoolProp write SetWordBoolProp stored False;
    property Caption: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property Default: WordBool index 4 read GetWordBoolProp write SetWordBoolProp stored False;
    property DragCursor: Smallint index 5 read GetSmallintProp write SetSmallintProp stored False;
    property DragMode: TOleEnum index 6 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Enabled: WordBool index 7 read GetWordBoolProp write SetWordBoolProp stored False;
    property Font: TFont index 8 read GetTFontProp write SetTFontProp stored False;
    property Visible: WordBool index 9 read GetWordBoolProp write SetWordBoolProp stored False;
    property Cursor: Smallint index 10 read GetSmallintProp write SetSmallintProp stored False;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnKeyPress: TDingButtonXOnKeyPress read FOnKeyPress write FOnKeyPress;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TDingButtonX.InitControlData;
const
  CEventDispIDs: array [0..1] of DWORD = (
    $00000001, $00000002);
  CTFontIDs: array [0..0] of DWORD = (
    $00000008);
  CControlData: TControlData2 = (
    ClassID: '{199D9A8A-CC89-11D1-AC07-C54ACBC13325}';
    EventIID: '{199D9A89-CC89-11D1-AC07-C54ACBC13325}';
    EventCount: 2;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$00000000*);
    Flags: $00000000;
    Version: 401;
    FontCount: 1;
    FontIDs: @CTFontIDs);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnClick) - Cardinal(Self);
end;

procedure TDingButtonX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IDingButtonX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TDingButtonX.GetControlInterface: IDingButtonX;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TDingButtonX.Click;
begin
  DefaultInterface.Click;
end;

procedure TDingButtonX.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TDingButtonX]);
end;

end.
