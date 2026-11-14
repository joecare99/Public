unit AHW52PasswordSessionIntf;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

type
  /// Narrow testable boundary for the password operations used by the dialog.
  /// This is not the BDE IDBSession interface or a BDE implementation.
  IAHW52PasswordSession = interface
    ['{D453F738-2CE6-40B6-A2EF-36D245CFF22B}']
    /// Adds a password to the session.
    procedure AddPassword(const Password: string);
    /// Removes a password from the session.
    procedure RemovePassword(const Password: string);
    /// Removes all passwords from the session.
    procedure RemoveAllPasswords;
  end;

implementation

end.
