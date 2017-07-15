program McStrPlnTest;
{

  Delphi DUnit-Testprojekt
  -------------------------
  Dieses Projekt enthlt das DUnit-Test-Framework und die GUI/Konsolen-Test-Runner.
  Zum Verwenden des Konsolen-Test-Runners fgen Sie den konditinalen Definitionen
  in den Projektoptionen "CONSOLE_TESTRUNNER" hinzu. Ansonsten wird standardmig
  der GUI-Test-Runner verwendet.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IFDEF FPC}
  Interfaces,
  {$ENDIF}
  Forms,
  {$IFNDEF FPC}
  TestFramework,
  TextTestRunner,
  {$ENDIF}
  GUITestRunner,
  minecad.planner.util.Array3D in '..\MineCAD\Planner\util\minecad.planner.util.Array3D.pas',
  TestArray3D in '..\MineCAD\Planner\test\TestArray3D.pas',
  TestTagClass in '..\MineCAD\Planner\test\TestTagClass.pas',
  minecad.planner.util.tag in '..\MineCAD\Planner\util\minecad.planner.util.tag.pas',
  TestTDictionary in '..\MineCAD\Planner\test\TestTDictionary.pas',
  TestGParameter in '..\MineCAD\Planner\test\TestGParameter.pas',
  minecad.planner.model.generator in '..\MineCAD\Planner\model\minecad.planner.model.generator.pas',
  minecad.planner.model.grid in '..\MineCAD\Planner\model\minecad.planner.model.grid.pas',
  minecad.planner.model.cell in '..\MineCAD\Planner\model\minecad.planner.model.cell.pas',
  minecad.planner.data.nbtblock in '..\MineCAD\Planner\data\minecad.planner.data.nbtblock.pas',
  TestNBTBlock in '..\MineCAD\Planner\test\TestNBTBlock.pas',
  dmGlobalData in '..\MineCAD\Planner\data\dmGlobalData.pas' {DataModule1: TDataModule};

begin
  Application.Initialize;
  if IsConsole then
    with TextTestRunner.RunRegisteredTests do
      Free
  else
    GUITestRunner.RunRegisteredTests;
end.

