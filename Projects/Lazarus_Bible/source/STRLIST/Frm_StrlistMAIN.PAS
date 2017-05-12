unit Frm_StrlistMAIN;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    AddButton: TButton;
    CloseBitBtn: TBitBtn;
    GetButton: TButton;
    ListBox1: TListBox;
    UpdateButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure UpdateButtonClick(Sender: TObject);
    procedure GetButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

type

{- New class of items to insert in a list }
  TStrItem = class
    S: string;
    I: Integer;
    constructor Create(S1: string; I1: Integer);
  end;

{- Derived class to hold TStrItem objects }
  TStrList = class(TList)
    destructor Destroy; override;
    function FindItem(S1: string): TStrItem;
  end;

var
  StrList: TStrList;      { List of TStrItems }
  ItemCount: Integer;     { Number of items inserted }
  StList:TStringList;

{- Create a new instance of TStrItem }
constructor TStrItem.Create(S1: String; I1: Integer);
begin
  S := S1;                { Save string parameter }
  I := I1;                { Save integer parameter }
  inherited Create;       { Call inherited Create }
end;

{- Destroy instance of TStrList }
destructor TStrList.Destroy;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    TStrItem(Items[I]).Free;  { Free all TStrItems }
  inherited Destroy;          { Call inherited destroy }
end;

{- Return object identified by S1 or nil for no match }
function TStrList.FindItem(S1: string): TStrItem;
var
  I: Integer;
  P: TStrItem;
begin
  for I := 0 to Count - 1 do
  begin
    P := TStrItem(Items[I]);  { P refers to a TStrItem object }
    if Uppercase(P.S) = Uppercase(S1) then  { Match? }
    begin           { Found match }
      Result := P;  { Return P as function result }
      Exit;         { Exit function immediately }
    end;
  end;
  Result := nil;    { No match; return nil }
end;

{- TMainForm event handlers }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  StrList := TStrList.Create;  { Create new StrList object }
  ItemCount := 0;              { Initialize insertion count }
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  StrList.Free;  { Also destroys listed items }
end;

{- Button event handlers }

procedure TMainForm.AddButtonClick(Sender: TObject);
var
  StrItem: TStrItem;   { New item to insert }
  S: string;           { User input string }
begin
  S := '';
  if InputQuery(Caption, 'Enter item', S) then
  if Length(S) > 0 then
  begin
    Inc(ItemCount);
    StrItem := TStrItem.Create(S, ItemCount);
    StrList.Add(StrItem);
  end;
end;

procedure TMainForm.UpdateButtonClick(Sender: TObject);
var
  I: Integer;
  P: TStrItem;
begin
  ListBox1.Clear;
  with StrList do
  for I := 0 to Count - 1 do
  begin
    P := TStrItem(StrList.Items[I]);
    ListBox1.Items.Add(Format('#%d: %s', [P.I, P.S]));
  end;
end;

procedure TMainForm.GetButtonClick(Sender: TObject);
var
  S: string;
  P: TStrItem;
begin
  UpdateButton.Click;
  S := '';
  if InputQuery(Caption, 'Enter item name', S) then
  if Length(S) > 0 then
  begin
    P := StrList.FindItem(S);
    if P <> nil then
      ShowMessage(Format('%s, Number = %d', [P.S, P.I]))
    else
      ShowMessage('No such item');
  end;
end;

end.
