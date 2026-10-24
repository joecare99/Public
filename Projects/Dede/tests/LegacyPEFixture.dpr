program LegacyPEFixture;

{$APPTYPE GUI}

uses
  Forms, LegacyPEFixtureUnit in 'LegacyPEFixtureUnit.pas' {LegacyFixtureForm};

begin
  Application.Initialize;
  Application.CreateForm(TLegacyFixtureForm, LegacyFixtureForm);
  Application.Run;
end.
