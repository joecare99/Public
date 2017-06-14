program prj_TestfvApp1;
 {$mode delphi}{$H+}
{$apptype console}
{$R *.res}

uses app_TestFvMain, fvAppExt, fvForms,app;

begin
  PAppExt(Application).initialize;
  PAppExt(Application).CreateForm(TVDemo,TTVDemo);
  Application.Run;
end.

