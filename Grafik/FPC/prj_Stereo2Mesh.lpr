program prj_Stereo2Mesh;

{$mode objfpc}{$H+}

//ToDo 9 -oJC -cFileSys : Laden & ggf. Speichern von Bildern
{ TODO 9 -oJC -cBase : Erstellen einer 3D-Mesh - Klasse ggf. Kompatibel mit RenderImage }
{ TODO 8 -oJC -cFileSys : Laden & Speichern von 3D-Mesh - Objekten }
{ TODO 8 -oJC -cHMI : Darstellung von 3D-Mesh-Objekten im Open-GL Context }
{ TODO 8 -oJC -cFileSys : Speichern & Laden eines Projekts }

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, frm_Stereo2MeshMain
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFrmStereo2MeshMain, FrmStereo2MeshMain);
  Application.Run;
end.

