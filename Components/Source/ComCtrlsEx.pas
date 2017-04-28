unit ComCtrlsEx;

interface

uses
{$IF DEFINED(CLR)}
  System.Runtime.InteropServices, System.Collections, System.Text, ActiveX,
{$IFEND}
{$IFDEF LINUX}
  WinUtils,
{$ENDIF}
{$IFNDEF FPC}
  ListActns,
{$ELSE}
 LCLStrConsts, LCLType, LCLProc, LCLIntf, LMessages,
{$ENDIF}
  SysUtils, Messages, Windows, Forms, CommCtrl, Classes,  Menus,
  ImgList, StdCtrls, ExtCtrls, Controls,  Graphics, ToolWin,GraphUtil,
  ShlObj;

Type
 TListControlItems = class;
 TCustomData = pointer;
 TStringsClass = Class of TStrings;
  TListControlItem = class(TCollectionItem)
  private
    FListControlItems: TListControlItems;
  protected
    FCaption: String;
    FData: TCustomData;
    FImageIndex: TImageIndex;
    procedure Changed;
    function GetDisplayName: String; override;
    procedure SetCaption(const Value: String); virtual;
    procedure SetData(const Value: TCustomData); virtual;
    procedure SetImageIndex(const Value: TImageIndex); virtual;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    property Data: TCustomData read FData write SetData;
  published
    property Caption: String read FCaption write SetCaption;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
  end;

  TListItemsSortType = (stNone, stData, stText, stBoth);
  TListCompareEvent = function(List: TListControlItems;
    Item1, Item2: TListControlItem): Integer of object;
  TListItemsCompare = function(List: TListControlItems;
    Index1, Index2: Integer): Integer;

  TListControlItems = class(TOwnedCollection)
  private
    FCaseSensitive: Boolean;
    FSortType: TListItemsSortType;
    FOnCompare: TListCompareEvent;
    procedure ExchangeItems(Index1, Index2: Integer);
    function GetListItem(const Index: Integer): TListControlItem;
    procedure QuickSort(L, R: Integer; SCompare: TListItemsCompare);
    procedure SetSortType(const Value: TListItemsSortType);
  protected
    function CompareItems(I1, I2: TListControlItem): Integer; virtual;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass); virtual;
    function Add: TListControlItem;
    procedure Sort;
    procedure CustomSort(Compare: TListItemsCompare);
    property Items[const Index: Integer]: TListControlItem read GetListItem; default;
  published
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive default False;
    property SortType: TListItemsSortType read FSortType write SetSortType default stNone;
    property OnCompare: TListCompareEvent read FOnCompare write FOnCompare;
  end;

{ TCustomComboBoxEx }

  TComboExItem = class(TListControlItem)
  private
    FSelectedImageIndex: TImageIndex;
    FOverlayImageIndex: TImageIndex;
    FIndent: Integer;
  protected
    procedure SetOverlayImageIndex(const Value: TImageIndex); virtual;
    procedure SetSelectedImageIndex(const Value: TImageIndex); virtual;
    procedure SetCaption(const Value: String); override;
    procedure SetData(const Value: TCustomData); override;
    procedure SetDisplayName(const Value: String); override;
    procedure SetImageIndex(const Value: TImageIndex); override;
    procedure SetIndex(Value: Integer); override;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Indent: Integer read FIndent write FIndent default -1;
    property OverlayImageIndex: TImageIndex read FOverlayImageIndex
      write SetOverlayImageIndex default -1;
    property SelectedImageIndex: TImageIndex read FSelectedImageIndex
      write SetSelectedImageIndex default -1;
  end;

  TComboExItems = class(TListControlItems)
  private
    function GetComboItem(const Index: Integer): TComboExItem;
  protected
    procedure Notify(Item: TCollectionItem;
      Action: TCollectionNotification); override;
    procedure SetItem(const Index: Integer); virtual;
  public
    function Add: TComboExItem;
    function AddItem(const Caption: string; const ImageIndex, SelectedImageIndex,
      OverlayImageIndex, Indent: Integer; Data: TCustomData): TComboExItem;
    function Insert(Index: Integer): TComboExItem;
    property ComboItems[const Index: Integer]: TComboExItem read GetComboItem;
  end;

  TComboExItemsClass = class of TComboExItems;
  TComboExItemClass = class of TComboExItem;

  TCustomComboBoxEx = class;

  TComboBoxExStrings = class(TStrings)
  private
    FItems: TComboExItems;
    function GetSortType: TListItemsSortType;
    procedure SetItems(const Value: TComboExItems);
    procedure SetSortType(const Value: TListItemsSortType);
  protected
    function GetItemsClass: TComboExItemsClass; virtual;
    function GetItemClass: TComboExItemClass; virtual;
    procedure PutObject(Index: Integer; AObject: TObject); override;
    procedure SetUpdateState(Updating: Boolean); override;
  public
    constructor Create(Owner: TCustomComboBoxEx); reintroduce;
    destructor Destroy; override;
    function Add(const S: String): Integer; override;
    function AddItem(const Caption: string; const ImageIndex, SelectedImageIndex,
      OverlayImageIndex, Indent: Integer; Data: TCustomData): TComboExItem;
    function AddObject(const S: String; AObject: TObject): Integer; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Exchange(Index1: Integer; Index2: Integer); override;
    function Get(Index: Integer): String; override;
    function GetCapacity: Integer; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): TObject; override;
    function IndexOf(const S: String): Integer; override;
    function IndexOfName(const Name: String): Integer; override;
    procedure Insert(Index: Integer; const S: String); override;
    procedure Move(CurIndex: Integer; NewIndex: Integer); override;
    property SortType: TListItemsSortType read GetSortType write SetSortType;
    property ItemsEx: TComboExItems read FItems write SetItems;
  end;

{ TCustomComboBoxEx }

  TComboBoxExStyle = (csExDropDown, csExSimple, csExDropDownList);
  TComboBoxExStyleEx = (csExCaseSensitive, csExNoEditImage, csExNoEditImageIndent,
                        csExNoSizeLimit, csExPathWordBreak);
  TComboBoxExStyles = set of TComboBoxExStyleEx;

  TAutoCompleteOption = (acoAutoSuggest, acoAutoAppend, acoSearch,
    acoFilterPrefixes, acoUseTab, acoUpDownKeyDropsList, acoRtlReading);
  TAutoCompleteOptions = set of TAutoCompleteOption;

{$IF DEFINED(CLR)}
  TComboExInstance = class
  private
    FHandle: TFNWndProc;
  strict protected
    procedure Finalize; override;
  public
    property Handle: TFNWndProc read FHandle write FHandle;
  end;
{$ELSE}
  TComboExInstance = Pointer;
{$IFEND}

(*$HPPEMIT ''*)
(*$HPPEMIT '#ifdef WIN32_LEAN_AND_MEAN'*)
(*$HPPEMIT '#include <shldisp.h>'*)
(*$HPPEMIT '#endif'*)
(*$HPPEMIT ''*)

  TCustomComboBoxEx = class(TCustomComboBox)
  private
    FAutoCompleteIntf: IAutoComplete;
    FAutoCompleteOptions: TAutoCompleteOptions;
    FComboBoxExHandle: HWND;
//    FComboBoxExDefProc: TWindowProcPtr;
    FComboBoxExInstance: TComboExInstance;
    FImageChangeLink: TChangeLink;
    FImages: TCustomImageList;
    FMemStream: TCollection;
    FReading: Boolean;
    FSaveIndex: Integer;
    FStyle: TComboBoxExStyle;
    FStyleEx: TComboBoxExStyles;
    FItemsEx: TComboExItems;
    FOnBeginEdit: TNotifyEvent;
    FOnEndEdit: TNotifyEvent;
    function GetSelText: String; override;
    procedure ImageListChange(Sender: TObject);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetSelText(const Value: String); override;
    procedure SetStyle(Value: TComboBoxExStyle); virtual;
    procedure SetItemsEx(const Value: TComboExItems);
    procedure SetStyleEx(const Value: TComboBoxExStyles);
    function IsItemsExStored: Boolean;
    function GetDropDownCount: Integer;
    procedure UpdateAutoComplete;
    procedure SetAutoCompleteOptions(const Value: TAutoCompleteOptions);
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure ComboExWndProc(var Message: TMessage);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    function GetActionLinkClass: TControlActionLinkClass; override;
    function GetItemsClass: TStringsClass; virtual;
    function GetItemCount: Integer; virtual;
    function GetItemHt: Integer; virtual;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetDropDownCount(const Value: Integer); override;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WndProc(var Message: TMessage); override;
    procedure WMHelp(var Message: TWMHelp); message WM_HELP;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Focused: Boolean; override;
    property AutoCompleteOptions: TAutoCompleteOptions read FAutoCompleteOptions
      write SetAutoCompleteOptions default [acoAutoAppend];
    property DropDownCount: Integer read GetDropDownCount write SetDropDownCount default 8;
    property Images: TCustomImageList read FImages write SetImages;
    property ItemsEx: TComboExItems read FItemsEx write SetItemsEx stored IsItemsExStored;
    property SelText: string read GetSelText write SetSelText;
    property Style: TComboBoxExStyle read FStyle write SetStyle default csExDropDown;
    property StyleEx: TComboBoxExStyles read FStyleEx write SetStyleEx default [];
    property OnBeginEdit: TNotifyEvent read FOnBeginEdit write FOnBeginEdit;
    property OnEndEdit: TNotifyEvent read FOnEndEdit write FOnEndEdit;
  end;

{ TComboBoxEx }

  TComboBoxEx = class(TCustomComboBoxEx)
  published
    property Align;
    property AutoCompleteOptions default [acoAutoAppend];
    property ItemsEx;
    property Style; {Must be published before Items}
    property StyleEx;
    property Action;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
 //   property Ctl3D;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
 //   property ImeMode;
 //   property ImeName;
    property ItemHeight;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
 //   property ParentCtl3D;
 //   property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
//    property Touch;
    property Visible;
    property OnBeginEdit;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndEdit;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
//    property OnGesture;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseMove;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
//    property Items;
    property Images;
    property DropDownCount;
  end;

implementation

uses
{$IF DEFINED(CLR)}
  System.Threading, System.Security, System.Security.Permissions, System.IO,
  WinUtils,
{$ELSE}
  ActiveX,
{$IFEND}
   {$IFNDEF FPC}
   Consts, ComStrs,
   {$ENDIF}
  Printers,RTLConsts, ActnList, StdActns, Types,
  Themes, UxTheme, DwmApi, StrUtils, CommDlg;

{$IF DEFINED(CLR)}
var
  { ComboBoxEx messages }
  _CBEM_GETITEM: Integer      = CBEM_GETITEMW;
  _CBEM_INSERTITEM: Integer   = CBEM_INSERTITEMW;
  _CBEM_SETITEM: Integer      = CBEM_SETITEMW;

{$ELSE}
const

  { ComboBoxEx messages }
  _CBEM_GETITEM      = CBEM_GETITEM;
  _CBEM_INSERTITEM   = CBEM_INSERTITEM;
  _CBEM_SETITEM      = CBEM_SETITEM;
{$IFEND}

function InitCommonControl(CC: Integer): Boolean;
var
  ICC: TInitCommonControlsEx;
begin
{$IF DEFINED(CLR)}
  ICC.dwSize := Marshal.SizeOf(TypeOf(TInitCommonControlsEx));
{$ELSE}
  ICC.dwSize := SizeOf(TInitCommonControlsEx);
{$IFEND}
  ICC.dwICC := CC;
  Result := InitCommonControlsEx(ICC);
  if not Result then InitCommonControls;
end;

procedure CheckCommonControl(CC: Integer);
begin
  //
end;

{ TListControlItem }

procedure TListControlItem.Assign(Source: TPersistent);
begin
  if Source is TListControlItem then
  begin
    if Assigned(Collection) then Collection.BeginUpdate;
    try
      Caption := TListControlItem(Source).Caption;
      ImageIndex := TListControlItem(Source).ImageIndex;
      Data := TListControlItem(Source).Data;
    finally
      if Assigned(Collection) then Collection.EndUpdate;
    end;
  end;
end;

procedure TListControlItem.Changed;
begin
  if Assigned(FListControlItems) then
    FListControlItems.Update(Self);
end;

constructor TListControlItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FImageIndex := -1;
end;

function TListControlItem.GetDisplayName: String;
begin
  if Length(Caption) > 0 then
    Result := Caption
  else
    Result := inherited GetDisplayName;
end;

procedure TListControlItem.SetCaption(const Value: String);
begin
  FCaption := Value;
  Changed;
end;

procedure TListControlItem.SetData(const Value: TCustomData);
begin
  FData := Value;
  Changed;
end;

procedure TListControlItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  Changed;
end;

{ TListControlItems }

function ListItemsCompare(List: TListControlItems; Index1, Index2: Integer): Integer;
begin
  Result := List.CompareItems(List.Items[Index1], List.Items[Index2]);
end;

function TListControlItems.Add: TListControlItem;
begin
  Result := TListControlItem(inherited Add);
  Result.FListControlItems := Self;
end;

procedure TListControlItems.CustomSort(Compare: TListItemsCompare);
begin
  if (SortType <> stNone) and (Count > 1) then
    QuickSort(0, Count - 1, Compare);
end;

function TListControlItems.CompareItems(I1, I2: TListControlItem): Integer;
begin
  if Assigned(OnCompare) then
    Result := OnCompare(Self, I1, I2)
  else
    if CaseSensitive then
      Result := AnsiCompareStr(I1.Caption, I2.Caption)
    else
      Result := AnsiCompareText(I1.Caption, I2.Caption);
end;

procedure TListControlItems.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;

procedure TListControlItems.ExchangeItems(Index1, Index2: Integer);
var
  Item1, Item2: TListControlItem;
  I1, I2: Integer;
begin
  Item1 := Items[Index1];
  Item2 := Items[Index2];
  I1 := Items[Index1].Index;
  I2 := Items[Index2].Index;
  Item1.Index := I2;
  Item2.Index := I1;
end;

procedure TListControlItems.QuickSort(L, R: Integer; SCompare: TListItemsCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(Self, I, P) < 0 do Inc(I);
      while SCompare(Self, J, P) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J, SCompare);
    L := I;
  until I >= R;
end;

function TListControlItems.GetListItem(
  const Index: Integer): TListControlItem;
begin
  Result := TListControlItem(GetItem(Index));
end;

procedure TListControlItems.SetSortType(const Value: TListItemsSortType);
begin
  if FSortType <> Value then
  begin
    FSortType := Value;
    if Value <> stNone then
      CustomSort(ListItemsCompare);
  end;
end;

procedure TListControlItems.Sort;
begin
  CustomSort(ListItemsCompare);
end;

constructor TListControlItems.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(AOwner, ItemClass);
  FCaseSensitive := False;
  FSortType := stNone;
end;

{ TComboExItem }

procedure TComboExItem.Assign(Source: TPersistent);
begin
  if Source is TComboExItem then
  begin
    FSelectedImageIndex := TComboExItem(Source).SelectedImageIndex;
    FIndent := TComboExItem(Source).Indent;
    FOverlayImageIndex := TComboExItem(Source).OverlayImageIndex;
    FImageIndex := TComboExItem(Source).ImageIndex;
    FCaption := TComboExItem(Source).Caption;
    FData := TComboExItem(Source).Data;
  end
  else
    inherited Assign(Source);
end;

procedure TComboExItem.SetCaption(const Value: String);
begin
  inherited SetCaption(Value);
  TComboExItems(Collection).SetItem(Index);
  if (TComboExItems(Collection).SortType = ListActns.stText) or
  (TComboExItems(Collection).SortType = ListActns.stBoth) then
    TComboExItems(Collection).Sort;
end;

procedure TComboExItem.SetData(const Value: TCustomData);
begin
  inherited SetData(Value);
  TComboExItems(Collection).SetItem(Index);
  if (TComboExItems(Collection).SortType = ListActns.stData) or
  (TComboExItems(Collection).SortType = ListActns.stBoth) then
    TComboExItems(Collection).Sort;
end;

procedure TComboExItem.SetDisplayName(const Value: String);
begin
  inherited SetDisplayName(Value);
  TComboExItems(Collection).SetItem(Index);
end;

procedure TComboExItem.SetImageIndex(const Value: TImageIndex);
begin
  if (FSelectedImageIndex = -1) or (FSelectedImageIndex = ImageIndex) then
    FSelectedImageIndex := Value;
  inherited SetImageIndex(Value);
  TComboExItems(Collection).SetItem(Index);
end;

procedure TComboExItem.SetIndex(Value: Integer);
begin
  inherited SetIndex(Value);
  TComboExItems(Collection).SetItem(Value);
end;

procedure TComboExItem.SetOverlayImageIndex(const Value: TImageIndex);
begin
  FOverlayImageIndex := Value;
  TComboExItems(Collection).SetItem(Index);
end;

procedure TComboExItem.SetSelectedImageIndex(const Value: TImageIndex);
begin
  FSelectedImageIndex := Value;
  TComboExItems(Collection).SetItem(Index);
end;

{ TComboExItems }

function TComboExItems.Add: TComboExItem;
begin
  Result := TComboExItem(inherited Add);
end;

function TComboExItems.AddItem(const Caption: string; const ImageIndex,
  SelectedImageIndex, OverlayImageIndex, Indent: Integer;
  Data: TCustomData): TComboExItem;
begin
  Result := Add;
  Result.Caption := Caption;
  Result.ImageIndex := ImageIndex;
  Result.SelectedImageIndex := SelectedImageIndex;
  Result.OverlayImageIndex := OverlayImageIndex;
  Result.Indent := Indent;
  Result.Data := Data;
  SetItem(Result.Index);
end;

function TComboExItems.GetComboItem(const Index: Integer): TComboExItem;
begin
  Result := TComboExItem(Items[Index]);
end;

function TComboExItems.Insert(Index: Integer): TComboExItem;
var
  I : integer;
begin
  Result := TComboExItem(inherited Insert(Index));
  for I := Index to Count - 1 do
    SetItem(I);
end;

procedure TComboExItems.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  case Action of
    cnAdded:
      with TComboExItem(Item) do
      begin
        FImageIndex := -1;
        FSelectedImageIndex := -1;
        FIndent := -1;
        FOverlayImageIndex := -1;
        FData := nil;
        FCaption := '';
      end;
    cnExtracting:
      if not (csDestroying in TWinControl(Owner).ComponentState) then
        SendMessage(TWinControl(Owner).Handle, CBEM_DELETEITEM, Item.Index, 0);
  end;
end;

procedure TComboExItems.SetItem(const Index: Integer);
var
  AnItem: TComboBoxExItem;
  Insert: BOOL;
begin
  inherited;
{$IF NOT DEFINED(CLR)}
  FillChar(AnItem{%H-}, SizeOf(TComboBoxExItem), 0);
{$IFEND}
  AnItem.iItem := Index;
  AnItem.cchTextMax := 0;
  Insert := SendGetStructMessage(TWinControl(Owner).Handle,
    _CBEM_GETITEM, 0, AnItem, True) = 0;
  with AnItem, ComboItems[Index] do
  begin
    mask := CBEIF_TEXT or CBEIF_IMAGE or CBEIF_SELECTEDIMAGE or
      CBEIF_INDENT or CBEIF_LPARAM;
{$IF DEFINED(CLR)}
    pszText := Caption;
{$ELSE}
    pszText := PChar(Caption);
{$IFEND}
    iItem := Index;
    cchTextMax := Length(Caption);
    iImage := ImageIndex;
    iSelectedImage := SelectedImageIndex;
    iOverlay := OverlayImageIndex;
    iIndent := Indent;
{$IF NOT DEFINED(CLR)}
    lParam := Windows.LPARAM(Data);
{$IFEND}
  end;
  if Insert then
    SendStructMessage(TWinControl(Owner).Handle, _CBEM_INSERTITEM, Index, AnItem)
  else
    SendStructMessage(TWinControl(Owner).Handle, _CBEM_SETITEM, Index, AnItem);
end;

{ TCustomComboBoxEx }

type
{$IF DEFINED(CLR)}
  TStringArray = array of String;
  TComboBoxExEnumerator = class(TInterfacedObject, IEnumString)
  private
    FItems: TComboExItems;
    FCurrentIndex: Integer;
  protected
    { IEnumString }
    function Clone(out enm: IEnumString): HResult;
    function Next(celt: Longint;
      [out, MarshalAs(UnmanagedType.LPArray, ArraySubType=UnmanagedType.LPWStr, SizeParamIndex = 0)]
      rgelt: TStringArray; out pceltFetched: Longint): HResult;
    function Reset: HResult;
    function Skip(celt: Longint): HResult;

    function GetString(Index: Integer): string;
    function GetCount: Integer;
  public
    constructor Create(Items: TComboExItems);
  end;
{$ELSE}
  TComboBoxExEnumerator = class(TInterfacedObject, IEnumString)
  private
    FItems: TComboExItems;
    FCurrentIndex: Integer;
  protected
    { IEnumString }
    function Clone(out enm: IEnumString): HRESULT; stdcall;
    function Next(celt: Integer; out elt; pceltFetched: PLongint): HRESULT;
      stdcall;
    function Reset: HRESULT; stdcall;
    function Skip(celt: Integer): HRESULT; stdcall;

    function GetString(Index: Integer): string;
    function GetCount: Integer;
  public
    constructor Create(Items: TComboExItems);
  end;
{$IFEND}

{$IF DEFINED(CLR)}
procedure TComboExInstance.Finalize;
begin
  if Assigned(FHandle) then
  begin
    FreeObjectInstance(FHandle);
    FHandle := nil;
  end;
  inherited;
end;
{$IFEND}

constructor TCustomComboBoxEx.Create(AOwner: TComponent);
begin
{$IF DEFINED(CLR)}
  CheckThreadingModel(System.Threading.ApartmentState.STA);
{$IFEND}
  CheckCommonControl(ICC_USEREX_CLASSES);
  inherited Create(AOwner);
{$IF DEFINED(CLR)}
  FComboBoxExInstance := TComboExInstance.Create;
  FComboBoxExInstance.Handle := MakeObjectInstance(ComboExWndProc);
{$ELSE}
  FComboBoxExInstance := MakeObjectInstance(ComboExWndProc);
{$IFEND}
  Items := TComboBoxExStrings.Create(Self);
  TComboBoxExStrings(Items).ComboBox := Self;
  FItemsEx := TComboBoxExStrings(Items).FItems;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FStyle := csExDropDown;
  FAutoCompleteOptions := [acoAutoAppend];
end;

destructor TCustomComboBoxEx.Destroy;
begin
  Items.Free;
  FreeAndNil(FImageChangeLink);
  if HandleAllocated then
    DestroyWindowHandle;
{$IF DEFINED(CLR)}
  if Assigned(FComboBoxExInstance) then
  begin
    FreeObjectInstance(FComboBoxExInstance.Handle);
    FComboBoxExInstance.Handle := nil;
    System.GC.SuppressFinalize(FComboBoxExInstance);
    FreeAndNil(FComboBoxExInstance);
  end;
{$ELSE}
  FreeObjectInstance(FComboBoxExInstance);
{$IFEND}
  FreeAndNil(FMemStream);
  FAutoCompleteIntf := nil;
  inherited Destroy;
end;

procedure TCustomComboBoxEx.CNNotify(var Message: TWMNotify);
begin
  with Message do
    case NMHdr.code of
      CBEN_BEGINEDIT: if Assigned(FOnBeginEdit) then FOnBeginEdit(Self);
      CBEN_ENDEDIT  : if Assigned(FOnEndEdit) then FOnEndEdit(Self);
    else
      inherited;
    end;
end;

procedure TCustomComboBoxEx.CreateParams(var Params: TCreateParams);
const
  ComboBoxExStyles: array[TComboBoxExStyle] of DWORD = (
    CBS_DROPDOWN, CBS_SIMPLE, CBS_DROPDOWNLIST);
begin
  InitCommonControl(ICC_USEREX_CLASSES);
  inherited CreateParams(Params);
  CreateSubClass(Params, WC_COMBOBOXEX);
  with Params do
  begin
    Style := Style or WS_TABSTOP or WS_VSCROLL or WS_CLIPCHILDREN or
      CCS_NORESIZE or CBS_AUTOHSCROLL or ComboBoxExStyles[Self.Style];
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
    WindowClass.style := (WindowClass.style or CS_DBLCLKS) and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TCustomComboBoxEx.SetImages(const Value: TCustomImageList);
begin
  if Images <> nil then
    Images.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  if Images <> nil then
  begin
    Images.RegisterChanges(FImageChangeLink);
    Images.FreeNotification(Self);
    if HandleAllocated then
      PostMessage(Handle, CBEM_SETIMAGELIST, 0, Images.Handle);
  end
  else
  begin
    if HandleAllocated then
    begin
      Perform(CBEM_SETIMAGELIST, 0, 0);
      RecreateWnd;
    end;
  end;
end;

procedure TCustomComboBoxEx.ImageListChange(Sender: TObject);
begin
  if HandleAllocated then
    Perform(CBEM_SETIMAGELIST, 0, TCustomImageList(Sender).Handle);
end;

procedure TCustomComboBoxEx.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    CN_CTLCOLORMSGBOX..CN_CTLCOLORSTATIC:
      if not NewStyleControls and (Style < csExDropDownList) and (Parent <> nil) then
        Message.Result := Parent.Brush.Handle;
    else
      inherited WndProc(Message);
  end;
end;

procedure TCustomComboBoxEx.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FImages) then
    Images := nil; // must go through the setter
end;

procedure TCustomComboBoxEx.SetStyle(Value: TComboBoxExStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    if Value = csExSimple then
      ControlStyle := ControlStyle - [csFixedHeight]
    else
      ControlStyle := ControlStyle + [csFixedHeight];
    if HandleAllocated then
      RecreateWnd;
  end;
end;

procedure TCustomComboBoxEx.CMParentColorChanged(var Message: TMessage);
begin
  inherited;
  if not NewStyleControls and (Style < csExDropDownList) then
    Invalidate;
end;

procedure TCustomComboBoxEx.CMColorChanged(var Message: TMessage);
var
  R: TRect;
begin
  inherited;
  if HandleAllocated and NewStyleControls then
  begin
    R := ClientRect;
    if FComboBoxExHandle <> 0 then
      InvalidateRect(FComboBoxExHandle, R, False);
    if FEditHandle <> 0 then
      InvalidateRect(FEditHandle, R, False);
  end;
end;

procedure TCustomComboBoxEx.WMLButtonDown(var Message: TWMLButtonDown);
var
  Form: TCustomForm;
begin
  if (DragMode = dmAutomatic) and (Style = csExDropDownList) and
      (Message.XPos < (Width - GetSystemMetrics(SM_CXHSCROLL))) then
  begin
    SetFocus;
    BeginDrag(False);
    Exit;
  end;
  inherited;
  if MouseCapture then
  begin
    Form := GetParentForm(Self);
    if (Form <> nil) and (Form.ActiveControl <> Self) then
      MouseCapture := False;
  end;
end;

procedure TCustomComboBoxEx.ComboExWndProc(var Message: TMessage);
begin
  ComboWndProc(Message, FComboBoxExHandle, FComboBoxExDefProc);
end;

procedure TCustomComboBoxEx.CreateWnd;
var
  ChildHandle: THandle;
  I: Integer;
  StrEnum: IEnumString;
  EditHandle: THandle;
{$IF DEFINED(CLR)}
  AutoCompleteType: System.Type;
{$IFEND}
begin
  inherited CreateWnd;
  FDropHandle := GetWindow(Handle, GW_CHILD);
  FComboBoxExHandle := FDropHandle;
  FComboBoxExDefProc := TWindowProcPtr(GetWindowLong(FComboBoxExHandle, GWL_WNDPROC));
{$IF DEFINED(CLR)}
  SetWindowLong(FComboBoxExHandle, GWL_WNDPROC, FComboBoxExInstance.Handle);
{$ELSE}
  SetWindowLong(FComboBoxExHandle, GWL_WNDPROC, Integer(FComboBoxExInstance));
{$IFEND}
  if FStyle in [csExDropDown, csExSimple] then
  begin
    ChildHandle := GetWindow(GetWindow(Handle, GW_CHILD), GW_CHILD);
    if ChildHandle <> 0 then
    begin
      if FStyle = csExSimple then
      begin
        FListHandle := ChildHandle;
        FDefListProc := TWindowProcPtr(GetWindowLong(FListHandle, GWL_WNDPROC));
{$IF DEFINED(CLR)}
        SetWindowLong(FListHandle, GWL_WNDPROC, FListInstance);
{$ELSE}
        SetWindowLong(FListHandle, GWL_WNDPROC, Longint(FListInstance));
{$IFEND}
        ChildHandle := GetWindow(ChildHandle, GW_HWNDNEXT);
      end;
      FEditHandle := ChildHandle;
      FDefEditProc := TWindowProcPtr(GetWindowLong(FEditHandle, GWL_WNDPROC));
{$IF DEFINED(CLR)}
      SetWindowLong(FEditHandle, GWL_WNDPROC, FEditInstance);
{$ELSE}
      SetWindowLong(FEditHandle, GWL_WNDPROC, Longint(FEditInstance));
{$IFEND}
    end;
  end;
  if NewStyleControls and (FEditHandle <> 0) then
    SendMessage(FEditHandle, EM_SETMARGINS, EC_LEFTMARGIN or EC_RIGHTMARGIN, 0);
  if FMemStream <> nil then
  begin
    ItemsEx.BeginUpdate;
    FReading := True;
    try
      ItemsEx.Assign(FMemStream);
      for I := 0 to ItemsEx.Count - 1 do
        ItemsEx.SetItem(I);
      FreeAndNil(FMemStream);
      Font := Font;
      ItemIndex := FSaveIndex;
    finally
      ItemsEx.EndUpdate;
      FReading := False;
    end;
  end;
  if Assigned(Images) then
    PostMessage(Handle, CBEM_SETIMAGELIST, 0, Images.Handle);
  SetStyleEx(StyleEx);

  FAutoCompleteIntf := nil;
{$IF DEFINED(CLR)}
  AutoCompleteType := System.Type.GetTypeFromCLSID(Guid.Create(CLSID_AutoComplete));
  FAutoCompleteIntf := Activator.CreateInstance(AutoCompleteType) as IAutoComplete;
{$ELSE}
  CoCreateInstance(CLSID_AutoComplete, nil, CLSCTX_INPROC_SERVER,
    IAutoComplete, FAutoCompleteIntf);
{$IFEND}

  if FAutoCompleteIntf <> nil then
  begin
    EditHandle := SendMessage(Handle, CBEM_GETEDITCONTROL, 0, 0);
    if EditHandle <> 0 then
    begin
      StrEnum := TComboBoxExEnumerator.Create(FItemsEx);
      FAutoCompleteIntf.Init(EditHandle, StrEnum, nil, nil);
      UpdateAutoComplete;
    end;
  end;
end;

function TCustomComboBoxEx.GetItemCount: Integer;
begin
  Result := Items.Count;
end;

function TCustomComboBoxEx.GetItemsClass: TComboExItemClass;
begin
  Result := TComboExItem;
end;

function TCustomComboBoxEx.GetSelText: String;
begin
  Result := '';
  if FStyle < csExDropDownList then
    Result := Copy(Text, GetSelStart + 1, GetSelLength);
end;

procedure TCustomComboBoxEx.SetItemsEx(const Value: TComboExItems);
begin
  FItemsEx.Assign(Value);
end;

function TCustomComboBoxEx.GetActionLinkClass: TActionLinkClass;
begin
  Result := TActionLink;
end;

procedure TCustomComboBoxEx.SetStyleEx(const Value: TComboBoxExStyles);
const
  ComboExStyles: array[TComboBoxExStyleEx] of DWORD = (CBES_EX_CASESENSITIVE,
    CBES_EX_NOEDITIMAGE, CBES_EX_NOEDITIMAGEINDENT, CBES_EX_NOSIZELIMIT,
    CBES_EX_PATHWORDBREAKPROC);
var
  AStyle: DWORD;
  I: TComboBoxExStyleEx;
begin
  AStyle := 0;
  FStyleEx := Value;
  if HandleAllocated then
  begin
    for I := Low(TComboBoxExStyleEx) to High(TComboBoxExStyleEx) do
      if I in FStyleEx then
        AStyle := AStyle or ComboExStyles[I];
    SendMessage(Handle, CBEM_SETEXTENDEDSTYLE, 0, AStyle);
  end;
end;

function TCustomComboBoxEx.IsItemsExStored: Boolean;
begin
  Result := (Action = nil) or Assigned(Action) and not (Action is TCustomListAction);
end;

procedure TCustomComboBoxEx.ActionChange(Sender: TObject;
  CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TStaticListAction then
    with TStaticListAction(Sender) do
    begin
      if not CheckDefaults or (Self.Images = nil) then
        Self.Images := Images;
      if not CheckDefaults or (Self.ItemIndex <> -1) then
        Self.ItemIndex := ItemIndex;
    end;
end;

procedure TCustomComboBoxEx.SetDropDownCount(const Value: Integer);
begin
  inherited SetDropDownCount(Value);
  if ((ComponentState * [csLoading, csDesigning]) = []) and HandleAllocated then
    RecreateWnd;
end;

procedure TCustomComboBoxEx.SetSelText(const Value: String);
begin
  if FStyle in [csExSimple, csExDropDown] then
  begin
    HandleNeeded;
{$IF DEFINED(CLR)}
    if Assigned(Value) then
      SendTextMessage(FEditHandle, EM_REPLACESEL, 0, Value)
    else
      SendTextMessage(FEditHandle, EM_REPLACESEL, 0, '');
{$ELSE}
    SendMessage(FEditHandle, EM_REPLACESEL, 0, Longint(PChar(Value)));
{$IFEND}
  end;
end;

function TCustomComboBoxEx.GetDropDownCount: Integer;
begin
  Result := inherited DropDownCount;
end;

function TCustomComboBoxEx.GetItemHt: Integer;
begin
  Result := 16;
end;

procedure TCustomComboBoxEx.DestroyWnd;
begin
  if (ItemsEx.Count > 0) and (FMemStream = nil) and (csRecreating in ControlState) then
  begin
    FMemStream := TCollection.Create(TComboExItem);
    FMemStream.Assign(ItemsEx);
    FSaveIndex := ItemIndex;
  end;
  inherited DestroyWnd;
end;

function TCustomComboBoxEx.Focused: Boolean;
var
  FocusedWnd: HWND;
begin
  Result := False;
  if HandleAllocated then
  begin
    FocusedWnd := GetFocus;
    Result := (FocusedWnd = FEditHandle) or (FocusedWnd = FListHandle) or
              (FocusedWnd = FComboBoxExHandle);
  end;
end;

procedure TCustomComboBoxEx.UpdateAutoComplete;
var
  Auto2: IAutoComplete2;
  ActualOptions: DWORD;
begin
  if HandleAllocated and (FAutoCompleteIntf <> nil) then
  begin
    if Supports(FAutoCompleteIntf, IAutoComplete2, Auto2) then
    begin
      if FAutoCompleteOptions = [] then
        Auto2.SetOptions(ACO_NONE)
      else
      begin
        ActualOptions := 0;
        if acoAutoSuggest in FAutoCompleteOptions then
          ActualOptions := ActualOptions or ACO_AUTOSUGGEST;
        if acoAutoAppend in FAutoCompleteOptions then
          ActualOptions := ActualOptions or ACO_AUTOAPPEND;
        if acoSearch in FAutoCompleteOptions then
          ActualOptions := ActualOptions or ACO_SEARCH;
        if acoFilterPrefixes in FAutoCompleteOptions then
          ActualOptions := ActualOptions or ACO_FILTERPREFIXES;
        if acoUseTab in FAutoCompleteOptions then
          ActualOptions := ActualOptions or ACO_USETAB;
        if acoUpDownKeyDropsList in FAutoCompleteOptions then
          ActualOptions := ActualOptions or ACO_UPDOWNKEYDROPSLIST;
        if acoRtlReading in FAutoCompleteOptions then
          ActualOptions := ActualOptions or ACO_RTLREADING;

        Auto2.SetOptions(ActualOptions);
      end;
    end
    else
      FAutoCompleteIntf.Enable(acoAutoSuggest in FAutoCompleteOptions);
  end;
end;

procedure TCustomComboBoxEx.SetAutoCompleteOptions(
  const Value: TAutoCompleteOptions);
begin
  if FAutoCompleteOptions <> Value then
  begin
    FAutoCompleteOptions := Value;
    UpdateAutoComplete;
  end;
end;

procedure TCustomComboBoxEx.WMHelp(var Message: TWMHelp);
{$IF DEFINED(CLR)}
var
  LHelpInfo: THelpInfo;
begin
  LHelpInfo := Message.HelpInfo;
  LHelpInfo.hItemHandle := Handle;
  Message.HelpInfo := LHelpInfo;
  inherited;
{$ELSE}
begin
  Message.HelpInfo^.hItemHandle := Handle;
  inherited;
{$IFEND}
end;

{ TComboBoxExStrings }

function TComboBoxExStrings.Add(const S: String): Integer;
begin
  with FItems.Add do
  begin
    Caption := S;
    Result := Index;
  end;
end;

function TComboBoxExStrings.AddObject(const S: String;
  AObject: TObject): Integer;
begin
  with FItems.Add do
  begin
    Caption := S;
    Data := AObject;
    Result := Index;
  end;
end;

procedure TComboBoxExStrings.Clear;
begin
  FItems.BeginUpdate;
  try
    FItems.Clear;

    if ComboBox.HandleAllocated then
      ComboBox.Perform(CM_RECREATEWND, 0, 0);
  finally
    FItems.EndUpdate;
  end;
end;

constructor TComboBoxExStrings.Create(Owner: TCustomComboboxEx);
begin
  inherited Create;
  FItems := GetItemsClass.Create(Owner, GetItemClass);
end;

destructor TComboBoxExStrings.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

procedure TComboBoxExStrings.Delete(Index: Integer);
begin
  FItems.Delete(Index);
end;

procedure TComboBoxExStrings.Exchange(Index1, Index2: Integer);
var
  Text: string;
  Image: Integer;
begin
  Text := ItemsEx[Index2].Caption;
  ItemsEx[Index2].Caption := ItemsEx[Index1].Caption;
  ItemsEx[Index1].Caption := Text;

  Image := ItemsEx[Index2].ImageIndex;
  ItemsEx[Index2].ImageIndex := ItemsEx[Index1].ImageIndex;
  ItemsEx[Index1].ImageIndex := Image;

  Image := TComboExItem(ItemsEx[Index2]).SelectedImageIndex;
  TComboExItem(ItemsEx[Index2]).SelectedImageIndex :=
    TComboExItem(ItemsEx[Index1]).SelectedImageIndex;
  TComboExItem(ItemsEx[Index1]).SelectedImageIndex := Image;

  Image := TComboExItem(ItemsEx[Index2]).OverlayImageIndex;
  TComboExItem(ItemsEx[Index2]).OverlayImageIndex :=
    TComboExItem(ItemsEx[Index1]).OverlayImageIndex;
  TComboExItem(ItemsEx[Index1]).OverlayImageIndex := Image;
end;

function TComboBoxExStrings.Get(Index: Integer): String;
begin
  Result := FItems[Index].Caption;
end;

function TComboBoxExStrings.GetCapacity: Integer;
begin
  Result := FItems.Count;
end;

function TComboBoxExStrings.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TComboBoxExStrings.GetObject(Index: Integer): TObject;
begin
  Result := TObject(FItems[Index].Data);
end;

function TComboBoxExStrings.IndexOf(const S: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FItems.Count - 1 do
    if AnsiCompareText(FItems[I].Caption, S) = 0 then
    begin
      Result := I;
      break;
    end;
end;

function TComboBoxExStrings.IndexOfName(const Name: String): Integer;
begin
  Result := IndexOf(Name);  // Simply forward this on to IndexOf
end;

procedure TComboBoxExStrings.Insert(Index: Integer; const S: String);
var
  AnItem: TComboExItem;
begin
  AnItem := FItems.Insert(Index);
  AnItem.Caption := S;
end;

procedure TComboBoxExStrings.Move(CurIndex, NewIndex: Integer);
begin
  FItems[CurIndex].Index := NewIndex;
end;

procedure TComboBoxExStrings.PutObject(Index: Integer; AObject: TObject);
begin
  FItems[Index].Data := AObject;
end;

procedure TComboBoxExStrings.SetItems(const Value: TComboExItems);
begin
  FItems.Assign(Value);
end;

procedure TComboBoxExStrings.SetUpdateState(Updating: Boolean);
begin
  if ComboBox.HandleAllocated then
  begin
    SendMessage(ComboBox.Handle, WM_SETREDRAW, Ord(not Updating), 0);
    if not Updating then
      ComboBox.Refresh;
  end;
end;

function TComboBoxExStrings.AddItem(const Caption: string;
  const ImageIndex, SelectedImageIndex, OverlayImageIndex, Indent: Integer;
  Data: TCustomData): TComboExItem;
begin
  Result := FItems.AddItem(Caption, ImageIndex, SelectedImageIndex,
    OverlayImageIndex, Indent, Data);
end;

function TComboBoxExStrings.GetSortType: TListItemsSortType;
begin
  Result := FItems.SortType;
end;

procedure TComboBoxExStrings.SetSortType(const Value: TListItemsSortType);
begin
  FItems.SortType := Value;
end;

function TComboBoxExStrings.GetItemsClass: TComboExItemsClass;
begin
  Result := TComboExItems;
end;

function TComboBoxExStrings.GetItemClass: TComboExItemClass;
begin
  Result := TComboExItem;
end;

{ TComboBoxExActionLink }

procedure TComboBoxExActionLink.AddItem(ACaption: string;
  AImageIndex: Integer; DataPtr: TCustomData);
begin
  with FClient as TCustomComboBoxEx do
    ItemsEx.AddItem(ACaption, AImageIndex, AImageIndex, -1, -1, DataPtr);
end;

procedure TComboBoxExActionLink.AddItem(AnItem: TListControlItem);
begin
  with FClient as TCustomComboBoxEx do
    ItemsEx.AddItem(AnItem.Caption, AnItem.ImageIndex, AnItem.ImageIndex, -1,
      -1, AnItem.Data);
end;

{ TComboBoxExEnumerator }

function TComboBoxExEnumerator.Clone(out enm: IEnumString): HRESULT;
var
  NewEnum: TComboBoxExEnumerator;
begin
  NewEnum := TComboBoxExEnumerator.Create(FItems);
  enm := NewEnum;
  NewEnum.FCurrentIndex := FCurrentIndex;
  Result := S_OK;
end;

constructor TComboBoxExEnumerator.Create(Items: TComboExItems);
begin
  inherited Create;
  FItems := Items;
end;

function TComboBoxExEnumerator.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TComboBoxExEnumerator.GetString(Index: Integer): String;
begin
  Result := FItems[Index].Caption;
end;

{$IF DEFINED(CLR)}
function TComboBoxExEnumerator.Next(celt: Longint; rgelt: TStringArray;
  out pceltFetched: Longint): HRESULT;
var
  I: Integer;
  TotalCount: Integer;
begin
  I := 0;
  TotalCount := GetCount;
  while (I < celt) and (FCurrentIndex < TotalCount) do
  begin
    rgelt[I] := GetString(FCurrentIndex);
    Inc(I);
    Inc(FCurrentIndex);
  end;
  pceltFetched := I;
  if I = celt then
    Result := S_OK
  else
    Result := S_FALSE;
end;
{$ELSE}
function TComboBoxExEnumerator.Next(celt: Integer; out elt;
  pceltFetched: PLongint): HRESULT;
type
  TWideCharArray = array[0..MaxListSize-1] of PWideChar;
var
  I: Integer;
  W: WideString;
  Size: Integer;
  TotalCount: Integer;
begin
  I := 0;
  TotalCount := GetCount;
  while (I < celt) and (FCurrentIndex < TotalCount) do
  begin
    W := GetString(FCurrentIndex);
    Size := Length(W) * SizeOf(WideChar);
    TPointerList(elt)[I] := CoTaskMemAlloc(Size + SizeOf(WideChar));
    FillChar(TPointerList(elt)[I]^, Size + SizeOf(WideChar), 0);
    CopyMemory(TPointerList(elt)[I], PWideString(W), Size);
    Inc(I);
    Inc(FCurrentIndex);
  end;
  if pceltFetched <> nil then
    pceltFetched^ := I;
  if I = celt then
    Result := S_OK
  else
    Result := S_FALSE;
end;
{$IFEND}

function TComboBoxExEnumerator.Reset: HRESULT;
begin
  FCurrentIndex := 0;
  Result := S_OK;
end;

function TComboBoxExEnumerator.Skip(celt: Longint): HRESULT;
var
  TotalCount: Integer;
begin
  TotalCount := GetCount;
  FCurrentIndex := FCurrentIndex + celt;
  if FCurrentIndex < TotalCount then
    Result := S_OK
  else
  begin
    FCurrentIndex := 0;
    Result := S_FALSE;
  end;
end;

{$IF DEFINED(CLR)}
procedure InitializeMessages;
begin
  if Marshal.SystemDefaultCharSize = 1 then
  begin
    _HDM_INSERTITEM := HDM_INSERTITEMA;
    _HDM_SETITEM := HDM_SETITEMA;

    _SB_SETTEXT := SB_SETTEXTA;

    _TCM_GETITEM := TCM_GETITEMA;
    _TCM_SETITEM := TCM_SETITEMA;
    _TCM_INSERTITEM := TCM_INSERTITEMA;

    _TB_SAVERESTORE := TB_SAVERESTOREA;
    _TB_ADDSTRING := TB_ADDSTRINGA;
    _TB_SETBUTTONINFO := TB_SETBUTTONINFOA;
    _TB_INSERTBUTTON := TB_INSERTBUTTONA;

    _CBEM_GETITEM := CBEM_GETITEMA;
    _CBEM_INSERTITEM := CBEM_INSERTITEMA;
    _CBEM_SETITEM := CBEM_SETITEMA;

    _ACM_OPEN := ACM_OPENA;

    _RB_INSERTBAND := RB_INSERTBANDA;
    _RB_SETBANDINFO := RB_SETBANDINFOA;
    _RB_GETBANDINFO := RB_GETBANDINFOA;
  end;
end;
{$IFEND}


end.
