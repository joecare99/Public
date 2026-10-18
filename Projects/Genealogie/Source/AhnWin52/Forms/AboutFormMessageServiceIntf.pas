unit AboutFormMessageServiceIntf;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

type
  /// Delivers user-facing errors raised while preparing About-form metadata.
  IAboutFormMessageService = interface
    ['{89A0CFE2-843A-4E78-A5D2-D81A686B9B4E}']
    /// Displays an error message to the user.
    /// <param name="Message">Localized text describing the error.</param>
    procedure ShowError(const Message: string);
  end;

implementation

end.
