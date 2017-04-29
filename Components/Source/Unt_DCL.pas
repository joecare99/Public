unit Unt_DCL;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Cmp_OpenGLScene,
     Cmp_DBConfig,
    // Unt_UserRechte,
      cmp_DBHLLookUpPanel,
      Cmp_DBLookUpGrid,
      cmp_DBHlPanel,
     //Fra_SelectVars,
     Frm_Aboutbox;

procedure Register;

implementation

uses classes,controls, Unt_Config;

procedure register;

begin
  GroupDescendentsWith(TConfig, Controls.TControl);
  GroupDescendentsWith(TAboutBox, Controls.TControl);
  RegisterComponents('OpenGL', [TO3DCanvas,TO3DGroup]);
  RegisterComponents('Projekt', [
    TConfig,
    TDBConfig,
//    TUser,
//    TFraSelectVars,
    TAboutBox ]);
  {$IFDEF FPC}
  RegisterComponents('Data Controls', [//TDBLookUpGrid,TDBHLLookUpPanel,
    TDBHlPanel]);
  {$ELSE}
  RegisterComponents('Datensteuerung', [TDBLookUpGrid,TDBHLLookUpPanel,
    TDBHlPanel]);
  {$ENDIF}
end;

end.
