unit ParentUnlinkBehavior;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

type
  TParentRole = (prFather, prMother);

  IParentUnlinkActions = interface
    ['{2EE1375F-8FC7-49F4-85EB-C3021A772AB3}']
    function ConfirmParentUnlink(const Parent: TParentRole;
      const DisplayText: string): Boolean;
    procedure EditCurrentPerson;
    procedure ClearParentReference(const Parent: TParentRole);
    procedure PostCurrentPerson;
    procedure RefreshMainView;
  end;

/// Confirms and removes one parent reference from the current person.
/// Refreshes the main view after either confirmation or cancellation.
function ExecuteParentUnlink(const Actions: IParentUnlinkActions;
  const Parent: TParentRole; const DisplayText: string): Boolean;

implementation

procedure RequireActions(const Actions: IParentUnlinkActions);
begin
  if Actions = nil then
    raise EArgumentNilException.Create('Actions');
end;

function ExecuteParentUnlink(const Actions: IParentUnlinkActions;
  const Parent: TParentRole; const DisplayText: string): Boolean;
begin
  RequireActions(Actions);

  Result := False;
  if Actions.ConfirmParentUnlink(Parent, DisplayText) then
  begin
    Actions.EditCurrentPerson;
    Actions.ClearParentReference(Parent);
    Actions.PostCurrentPerson;
    Result := True;
  end;

  Actions.RefreshMainView;
end;

end.
