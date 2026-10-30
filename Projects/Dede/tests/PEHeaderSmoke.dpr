program PEHeaderSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, DeDeClasses;

procedure Require(Value: Boolean; const MessageText: string);
begin
  if not Value then
    raise Exception.Create(MessageText);
end;

var
  Input: ThePEFile;
  Header: TPEHeader;
begin
  if ParamCount <> 1 then
    raise EArgumentException.Create('Pass a PE file path');

  Input := ThePEFile.Create(ParamStr(1));
  Header := TPEHeader.Create;
  try
    PEFile := Input;
    DeDeClasses.PEHeader := Header;
    Header.Dump(Input);
    Require(Copy(Header.Signature, 1, 2) = 'PE',
      'PE signature was not decoded from ANSI bytes');
    Require(Header.ObjectNum > 0, 'PE section table was not parsed');
    Require((Header.Objects[1].OBJECT_NAME = '.text') or
      (Header.Objects[1].OBJECT_NAME = 'CODE'),
      'Unexpected first PE section name: ' + Header.Objects[1].OBJECT_NAME);
    WriteLn('PE header smoke test passed: ' +
      Header.Objects[1].OBJECT_NAME);
  finally
    DeDeClasses.PEFile := nil;
    DeDeClasses.PEHeader := nil;
    Header.Free;
    Input.Free;
  end;
end.
