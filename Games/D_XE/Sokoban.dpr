{Sokoban 3.0, by Ben Ruyl}
program Sokoban;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}



uses
  Forms,
  MainUnit in '..\Sokoban\MainUnit.pas' {frmSokoban},
  AboutUnit in '..\Sokoban\AboutUnit.pas' {AboutBox},
  ThumbUnit in '..\Sokoban\ThumbUnit.pas' {frmThumbnails},
  SkinUnit in '..\Sokoban\SkinUnit.pas',
  PathFUnit in '..\Sokoban\PathFUnit.pas',
  SkinInfoUnit in '..\Sokoban\SkinInfoUnit.pas' {frmSkinInfo},
  LevInfoUnit in '..\Sokoban\LevInfoUnit.pas' {frmLevInfo},
  DetailsUnit in '..\Sokoban\DetailsUnit.pas' {frmGameDetails},
  SettingsUnit in '..\Sokoban\SettingsUnit.pas',
  LoadLevelsetUnit in '..\Sokoban\LoadLevelsetUnit.pas',
  sokoengine in '..\Sokoban\sokoengine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Sokoban 3.0';
  Application.CreateForm(TfrmSokoban, frmSokoban);
  Application.CreateForm(TfrmThumbnails, frmThumbnails);
  Application.CreateForm(TfrmSkinInfo, frmSkinInfo);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TfrmLevInfo, frmLevInfo);
  Application.CreateForm(TfrmGameDetails, frmGameDetails);
  Application.Run;
end.
