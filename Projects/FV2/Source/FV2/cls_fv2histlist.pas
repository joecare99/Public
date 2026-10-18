unit cls_fv2histlist;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  THistoryItem = class(TCollectionItem)
  private
    FText: string;
  published
    property Text: string read FText write FText;
  end;

  THistoryList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): THistoryItem;
  public
    constructor Create(AOwner: TPersistent);
    function Add(const AText: string): THistoryItem;
    property Items[Index: Integer]: THistoryItem read GetItem; default;
  end;

implementation

constructor THistoryList.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, THistoryItem);
end;

function THistoryList.Add(const AText: string): THistoryItem;
begin
  Result := THistoryItem(inherited Add);
  Result.Text := AText;
end;

function THistoryList.GetItem(Index: Integer): THistoryItem;
begin
  Result := THistoryItem(inherited Items[Index]);
end;

end.
