program prj_Testfv2App;
 {$mode delphi}{$H+}
{$apptype console}
{$R *.res}

uses app_testfv2main,fv2app,fv2appext;

begin
  TAppExt(Application).initialize;
  TAppExt(Application).CreateForm(TVDemo,TTVDemo);
  Application.Run;
end.

