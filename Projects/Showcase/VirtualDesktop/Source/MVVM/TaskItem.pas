unit TaskItem;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  TTaskItem = class
  private
    FId: string;
    FTitle: string;
    FCompleted: Boolean;
  public
    constructor Create(const AId, ATitle: string; ACompleted: Boolean = False);
    function MatchesFilter(const AFilter: string): Boolean;
    property Id: string read FId;
    property Title: string read FTitle write FTitle;
    property Completed: Boolean read FCompleted write FCompleted;
  end;

  TTaskItemArray = array of TTaskItem;

implementation

constructor TTaskItem.Create(const AId, ATitle: string; ACompleted: Boolean);
begin
  if Trim(AId) = '' then
    raise EArgumentException.Create('A task ID is required.');
  if Trim(ATitle) = '' then
    raise EArgumentException.Create('A task title is required.');
  FId := AId;
  FTitle := ATitle;
  FCompleted := ACompleted;
end;

function TTaskItem.MatchesFilter(const AFilter: string): Boolean;
var
  FilterText: string;
begin
  FilterText := LowerCase(Trim(AFilter));
  if FilterText = '' then
    Exit(True);
  Result := (Pos(FilterText, LowerCase(FId)) > 0) or
    (Pos(FilterText, LowerCase(FTitle)) > 0);
end;

end.
