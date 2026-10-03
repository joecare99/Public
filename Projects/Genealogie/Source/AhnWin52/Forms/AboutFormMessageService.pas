unit AboutFormMessageService;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  AboutFormMessageServiceIntf;

type
  /// Presents About-form errors using the application's standard message dialog.
  TAboutFormMessageService = class(TInterfacedObject, IAboutFormMessageService)
  public
    /// Displays the supplied error text in a standard modal message dialog.
    /// <param name="Message">Localized text describing the error.</param>
    procedure ShowError(const Message: string);
  end;

implementation

uses
  Dialogs;

procedure TAboutFormMessageService.ShowError(const Message: string);
begin
  ShowMessage(Message);
end;

end.
