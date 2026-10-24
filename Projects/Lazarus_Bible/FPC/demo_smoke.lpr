program demo_smoke;

{$mode delphi}{$H+}

uses
  Interfaces,
  Forms,
  SysUtils,
  Classes,
  contnrs,
  BibleShowcase,
  BibleShowcaseRegistry;

var
  Reg: TShowcaseRegistry;
  I: Integer;
begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Reg := TShowcaseRegistry.Create;
  try
    Reg.RegisterAll;
    for I := 0 to Reg.Showcase.Entries.Count - 1 do
    begin
      Write('  ', TShowcaseEntry(Reg.Showcase.Entries[I]).Key, ' ... ');
      try
        TShowcaseEntry(Reg.Showcase.Entries[I]).Factory;
        Writeln('OK');
      except
        on E: Exception do
          Writeln('FEHLER: ', E.Message);
      end;
    end;
  finally
    Reg.Free;
  end;
end.
