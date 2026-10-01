unit GregorianCalendarViewModelIntf;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

type
  /// View-facing calendar contract; keeps the form independent of its implementation.
  IGregorianCalendarViewModel = interface
    ['{E957357A-6BD6-4C45-B158-9DCA5D154F30}']
    /// Gets the currently displayed year.
    function GetYear: Longint;
    /// Rebuilds the displayed calendar for Value.
    /// <param name="Value">The supported Gregorian year to display.</param>
    /// <exception cref="EConvertError">Value is outside the supported year range.</exception>
    procedure SetYear(const Value: Longint);
    /// Returns the localized display label for the weekday row (0=Sunday).
    /// <param name="Row">Zero-based weekday row, with Sunday at index zero.</param>
    /// <exception cref="ERangeError">Row is not one of the seven weekday rows.</exception>
    function GetWeekdayLabel(const Row: Integer): string;
    /// Returns a day number or an empty string for one panel cell.
    /// <param name="GridIndex">Zero-based panel index (January-April through September-December).</param>
    /// <param name="Column">Zero-based calendar-grid column.</param>
    /// <param name="Row">Zero-based weekday row (Sunday through Saturday).</param>
    /// <exception cref="ERangeError">An index is outside the grid.</exception>
    function GetDayCellText(const GridIndex, Column, Row: Integer): string;
    /// Current year whose day cells and labels are exposed by this contract.
    property Year: Longint read GetYear write SetYear;
  end;

implementation

end.
