unit IndexedLookupContract;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  /// Found distinguishes a hit from a normal miss; misses return RecordId 0.
  TIndexedLookupResult = record
    Found: Boolean;
    RecordId: Integer;
  end;

  EUnknownLookupIndex = class(Exception);
  EInvalidLookupKey = class(Exception);

  IIndexedLookupProvider = interface
    ['{1439D3A6-3EBB-4514-9AFD-557B5DE6208C}']
    /// Looks up values in the registered index-field order without moving the
    /// current record cursor. Raises EUnknownLookupIndex for unsupported indexes
    /// and EInvalidLookupKey for a key-value count mismatch.
    function Lookup(const IndexName: string; const KeyValues: TStrings):
      TIndexedLookupResult;
    function GetCurrentRecordId: Integer;
    property CurrentRecordId: Integer read GetCurrentRecordId;
  end;

implementation

end.
