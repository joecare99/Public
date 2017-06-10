unit unt_PoFile;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, FileUtil;

type

  { TPoFile }

  TPoFile = class(TComponent)

  private
    Flines: TStringList;
    function GetLine(aIndex: integer): string;
    procedure SetLines(AValue: TStringList);
    procedure SetLine(aIndex: integer; AValue: string);
    procedure SetLines2(aIndex: integer; AValue: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AppendData(const aRef, aIndex, aTransl: string);
    function LookUpIdent(const aIdent: string): integer;
    function GetTranslText(const id: integer): string;
    procedure LoadFromFile(Filename: string);
    procedure SaveToFile(Filename: string);
    class function QuotedStr2(const S: string): string;
    class function UnQuotedStr2(const S: string): string;
    //  class function
    property Lines: TStringList read FLines write SetLines;
    property Line[aIndex: integer]: string read GetLine write SetLine;
  end;


implementation

{ TPoFile }

constructor TPoFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Flines := TStringList.Create;
end;

procedure TPoFile.AppendData(const aRef, aIndex, aTransl: string);

var
  lExIdx: integer;

begin
  lExIdx := LookUpIdent(aIndex);
  if lExIdx = -1 then
  begin
    FLines.Append('');
    FLines.Append('#: ' + aRef);
    FLines.Append('msgid ' + QuotedStr2(aIndex));
    FLines.Append('msgstr ' + QuotedStr2(aTransl));
  end
  else
    FLines[lExIdx - 1] := FLines[lExIdx - 1] + ' ' + aRef;
end;

function TPoFile.LookUpIdent(const aIdent: string): integer;
begin
  // Todo: Multiline
  Result := FLines.IndexOf('msgid ' + QuotedStr2(aIdent));
end;

function TPoFile.GetTranslText(const id: integer): string;
begin
  // Todo: Multiline
  Result := UnQuotedStr2(copy(FLines[id + 1], 8, length(FLines[id + 1])));
end;

procedure TPoFile.LoadFromFile(Filename: string);
begin
  Flines.LoadFromFile(Filename);
end;

procedure TPoFile.SaveToFile(Filename: string);
begin
  Flines.SaveToFile(Filename);
end;

procedure TPoFile.SetLines(AValue: TStringList);
begin
  if FLines = AValue then
    Exit;
  FLines := AValue;
end;

function TPoFile.GetLine(aIndex: integer): string;
begin
  Result := Flines.Strings[aIndex];
end;

procedure TPoFile.SetLine(aIndex: integer; AValue: string);
begin
  Flines[aIndex] := AValue;
end;

procedure TPoFile.SetLines2(aIndex: integer; AValue: string);
begin

end;


destructor TPoFile.Destroy;
begin
  FreeAndNil(Flines);
  inherited Destroy;
end;

class function TPoFile.QuotedStr2(const S: string): string;
var
  i, j, Count: integer;
const
  Quote = '"';

begin
  Result := '' + Quote;
  Count := length(s);
  i := 0;
  j := 0;
  while i < Count do
  begin
    i := i + 1;
    if S[i] in [Quote, '\'] then
    begin
      Result := Result + copy(S, 1 + j, i - j - 1) + '\' + S[i];
      j := i;
    end;
  end;
  if i <> j then
    Result := Result + copy(S, 1 + j, i - j);
  Result := Result + Quote;
end;

class function TPoFile.UnQuotedStr2(const S: string): string;
var
  i: integer;
const
  Quote = '"';

begin
  Result := s;
  if ('' + Quote = copy(s, length(s), 1)) and (copy(s, 1, 1) = '' + Quote) then
  begin
    Delete(Result, 1, 1);
    Delete(Result, length(Result), 1);
  end;
  i := 0;
  while i < length(Result) do
  begin
    i := i + 1;
    if Result[i] = '\' then
      Delete(Result, i, 1);
  end;
end;


end.
