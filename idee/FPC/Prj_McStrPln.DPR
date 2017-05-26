program Prj_McStrPln;
{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
uses
  Forms,
  Frm_McStrPln in '..\source\Frm_McStrPln.pas' {FrmMineCAD},
  Frm_ChildWin in '..\source\Frm_ChildWin.pas' {MDIChild},
  dmGlobalData in '..\MineCAD\Planner\data\dmGlobalData.pas' {DataModule1: TDataModule},
  fra_Welcome in '..\MineCAD\Planner\gui\fra_Welcome.pas' {Frame1: TFrame},
  minecad.planner.data.nbtblock in '..\MineCAD\Planner\data\minecad.planner.data.nbtblock.pas',
  minecad.planner.util in '..\MineCAD\Planner\util\minecad.planner.util.pas',
  minecad.planner.util.Array3D in '..\MineCAD\Planner\util\minecad.planner.util.Array3D.pas',
  minecad.planner.util.tag in '..\MineCAD\Planner\util\minecad.planner.util.tag.pas',
  minecad.planner.model.grid in '..\MineCAD\Planner\model\minecad.planner.model.grid.pas',
  minecad.planner.model.cell in '..\MineCAD\Planner\model\minecad.planner.model.cell.pas',
  minecad.planner.model.generator in '..\MineCAD\Planner\model\minecad.planner.model.generator.pas',
  minecad.planner.model.Sphere in '..\MineCAD\Planner\model\minecad.planner.model.Sphere.pas',
  minecad.planner.model.Torus in '..\MineCAD\Planner\model\minecad.planner.model.Torus.pas',
  minecad.planner.model.Archbridge in '..\MineCAD\Planner\model\minecad.planner.model.Archbridge.pas',
  minecad.planner.tool in '..\MineCAD\Planner\Tool\minecad.planner.tool.pas';

begin
  Application.Initialize;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TFrmMineCAD, FrmMineCAD);
  Application.Run;
end.
 
