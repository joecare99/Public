unit Cmp_StringTable;
{$INCLUDE Switches}
{$I jedi.inc}

interface

uses Classes;

const
  MaxCount = 4000;

type
  TStringTable = class(TStringList)
  public
    constructor Create;
    //    destructor Destroy; override;
    function LoadFromCEvoFile(const FileName: string): boolean;
    function GetHandle(const Item: string): integer;
    function LookupByHandle(Handle: integer; Index: integer = -1): string;
    function Lookup(const Item: string; Index: integer = -1): string;
    function Search(const Content: string; var Handle, Index: integer): boolean;
  protected
  end;

implementation

uses
  SysUtils;


constructor TStringTable.Create;
begin
  NameValueSeparator:=' ';
  inherited;
end;
//
//destructor TStringTable.Destroy;
//begin
//  inherited;
//end;

function TStringTable.LoadFromCEvoFile(const FileName: string): boolean;
var
  nData, i: integer;

begin
  NameValueSeparator:=' ';
  LoadFromFile(Filename);
end;

function TStringTable.GetHandle(const Item: string): integer;
var
  i, l: integer;
begin
  Result := IndexOfName('#'+Item);
  if result =-1 then
    Result := IndexOf('#'+Item);
end;

function TStringTable.LookupByHandle(Handle: integer; Index: integer): string;
var
  s: string;
begin
  if Index < 0 then
    if Handle < 0 then
    begin
      Result := '';
      exit;
    end
    else
    begin
      if pos(' ', Strings[Handle]) = 0 then
        s := ''
      else
        s := copy(Strings[Handle], pos(' ', Strings[Handle]) + 1, MaxInt);
      while (Handle + 1 < Count) and (Strings[Handle + 1][1] <> '#') do
      begin
        Inc(Handle);
        if (Strings[Handle][1] <> #0) and (Strings[Handle][1] <> '''') then
        begin
          if (s <> '') and (s[Length(s)] <> '\') then
            s := s + ' ';
          s := s + Strings[Handle];
        end;
      end;
      Result := s;
    end
  else if Handle + Index + 1 >= Count then
  begin
    Result := '';
    exit;
  end
  else
    Result := Strings[Handle + Index + 1];
  while (Result <> '') and ((Result[1] = ' ') or (Result[1] = #9)) do
    system.Delete(Result, 1, 1);
  while (Result <> '') and ((Result[Length(Result)] = ' ') or
      (Result[Length(Result)] = #9)) do
    system.Delete(Result, Length(Result), 1);
  if Result = '' then
    Result := '*';
end;

function TStringTable.Lookup(const Item: string; Index: integer): string;
var
  Handle: integer;
begin
  Handle := GetHandle(Item);
  if Handle >= 0 then
    Result := LookupByHandle(Handle, Index)
  else
    Result := '';
  if Result = '' then
    if Index < 0 then
      Result := Format('[%s]', [Item])
    else
      Result := Format('[%s %d]', [Item, Index]);
end;

function TStringTable.Search(const Content: string;
  var Handle, Index: integer): boolean;
var
  h, i: integer;
  UContent: string;
begin
  UContent := UpperCase(Content);
  h := Handle;
  if h < 0 then
    i := 0
  else
    i := Index + 1;
  repeat
    if h + i + 1 >= Count then
    begin
      Result := False;
      exit;
    end;
    if Strings[h + i + 1][1] = '#' then
    begin
      h := h + i + 1;
      i := -1;
    end;
    if (h >= 0) and not (Strings[h + i + 1][1] in ['#', ':', ';']) and
      (pos(UContent, UpperCase(Strings[h + i + 1])) > 0) then
    begin
      Index := i;
      Handle := h;
      Result := True;
      exit;
    end;
    Inc(i);
  until False;
end;

end.

