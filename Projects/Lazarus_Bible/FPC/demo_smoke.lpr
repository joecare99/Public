program demo_smoke;

{$mode delphi}{$H+}

uses
  Interfaces,
  Forms,
  SysUtils,
  Classes,
  contnrs,
  BibleShowcase,
  BibleShowcaseRegistry,
  Frm_StaticDemoMain;

var
  Reg: TShowcaseRegistry;
  I: Integer;
  DemoForm: TForm;
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
        DemoForm := TShowcaseEntry(Reg.Showcase.Entries[I]).Factory;
        DemoForm.Free;
        Writeln('OK');
      except
        on E: Exception do
          Writeln('FEHLER: ', E.Message);
      end;
    end;
    Write('  StaticDemo ... ');
    try
      DemoForm := TStaticDemoForm.Create(nil);
      DemoForm.Free;
      Writeln('OK');
    except
      on E: Exception do
        Writeln('FEHLER: ', E.Message);
    end;
  finally
    Reg.Free;
  end;
end.
