program Prj_PlaceEdit;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  DefaultTranslator, SysUtils, Types,
  Interfaces, // this includes the LCL widgetset
  Forms, fpvhttp,
  frm_PlaceEditMain,
  dm_RNZAnzeigen  {dmRNZAnzeigen},
  fra_PlaceEdit
  { you can add units after this };

{$R *.res}

function GetApplicationName: string;
begin
  Result := 'RNZ-Anzeigen';
end;

function GetVendorName: string;
begin
  Result := 'JC-Soft';
end;

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  OnGetApplicationName:=@GetApplicationName;
  OnGetVendorName:=@GetVendorName;
  Application.CreateForm(TdmRNZAnzeigen, dmRNZAnzeigen);
  Application.CreateForm(TFrmPlaceEditMain, FrmPlaceEditMain);
  Application.Run;
end.

