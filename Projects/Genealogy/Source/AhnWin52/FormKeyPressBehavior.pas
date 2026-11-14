unit FormKeyPressBehavior;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  Controls, Forms;

/// Consumes Enter so the host form can move focus to the next control.
function ConsumeEnterKeyForNavigation(var Key: Char): Boolean;

/// Reports whether a virtual key code represents Escape.
function IsEscapeKey(const Key: Word): Boolean;

/// Sets a form's modal result to cancel only when Escape is pressed.
procedure SetCancelResultOnEscape(Form: TCustomForm; const Key: Word);

/// Advances from the sender control and consumes Enter.
procedure AdvanceToNextControlOnEnter(Form: TCustomForm; Sender: TObject;
  var Key: Char);

implementation

function ConsumeEnterKeyForNavigation(var Key: Char): Boolean;
begin
  Result := Key = #13;
  if Result then
    Key := #0;
end;

function IsEscapeKey(const Key: Word): Boolean;
begin
  Result := Key = $1B;
end;

procedure SetCancelResultOnEscape(Form: TCustomForm; const Key: Word);
begin
  if IsEscapeKey(Key) then
    Form.ModalResult := mrCancel;
end;

procedure AdvanceToNextControlOnEnter(Form: TCustomForm; Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Form.SelectNext(Sender as TWinControl, True, True);
    Key := #0;
  end;
end;

end.
