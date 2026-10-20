unit AHW52UICloseFlow;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  SysUtils;

type
  TClosePromptKind = (cpkUnknown, cpkExit, cpkBackup);
  TConfirmationChoice = (ccUnknown, ccYes, ccNo);

function ClassifyClosePrompt(const Text: UTF8String): TClosePromptKind;
function CanUseKnownPromptSequenceFallback(
  const WindowClass, WindowTitle, PromptText: UTF8String): Boolean;
function ClassifyConfirmationButton(
  const Caption: UTF8String): TConfirmationChoice;
function RequiredCloseChoice(Prompt: TClosePromptKind): TConfirmationChoice;

implementation

function ClassifyClosePrompt(const Text: UTF8String): TClosePromptKind;
var
  NormalizedText: string;
begin
  NormalizedText := UpperCase(Trim(string(Text)));
  if (Pos('AHNENWIN 5.1 BEENDEN', NormalizedText) > 0) and
     (Pos('DATENSICHERUNG', NormalizedText) = 0) then
    Exit(cpkExit);
  if (Pos('BEENDEN', NormalizedText) > 0) and
     ((Pos('AHNENWIN', NormalizedText) > 0) or
      (Pos('AHENEWIN', NormalizedText) > 0)) and
     (Pos('DATENSICHERUNG', NormalizedText) = 0) then
    Exit(cpkExit);
  if Pos('DATENSICHERUNG', NormalizedText) > 0 then
    Exit(cpkBackup);
  if Pos('BACKUP', NormalizedText) > 0 then
    Exit(cpkBackup);
  if Pos('CLOSE', NormalizedText) > 0 then
    Exit(cpkExit);
  Result := cpkUnknown;
end;

function CanUseKnownPromptSequenceFallback(
  const WindowClass, WindowTitle, PromptText: UTF8String): Boolean;
var
  NormalizedTitle: string;
begin
  NormalizedTitle := UpperCase(Trim(string(WindowTitle)));
  Result := SameText(string(WindowClass), 'TMessageForm') and
    (Trim(string(PromptText)) = '') and
    ((NormalizedTitle = '') or
     (NormalizedTitle = 'AHNENWIN 5.1') or
     SameText(Trim(string(WindowTitle)), 'Bestätigung'));
end;

function ClassifyConfirmationButton(
  const Caption: UTF8String): TConfirmationChoice;
var
  NormalizedCaption: string;
begin
  NormalizedCaption := UpperCase(Trim(StringReplace(
    string(Caption), '&', '', [rfReplaceAll])));
  if (NormalizedCaption = 'JA') or (NormalizedCaption = 'YES') then
    Exit(ccYes);
  if (NormalizedCaption = 'NEIN') or (NormalizedCaption = 'NO') then
    Exit(ccNo);
  Result := ccUnknown;
end;

function RequiredCloseChoice(Prompt: TClosePromptKind): TConfirmationChoice;
begin
  case Prompt of
    cpkExit: Result := ccYes;
    cpkBackup: Result := ccNo;
  else
    raise EArgumentException.Create(
      'An unknown confirmation dialog cannot be handled automatically.');
  end;
end;

end.
