unit Unt_DCL;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Cmp_OpenGLScene,
     Cmp_DBConfig,
      cmp_DBHLLookUpPanel,
      cmp_DBHlPanel,
 {$IFNDEF FPC}
      Cmp_DBLookUpGrid,
      Fra_SelectVars,
      Unt_UserRechte,
 {$endif}
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
{$IFNDEF FPC}
    TUser,
    TFraSelectVars,
 {$endif}
    TAboutBox ]);
  {$IFDEF FPC}
  RegisterComponents('Data Controls', [//TDBLookUpGrid,
  TDBHLLookUpPanel, TDBHlPanel]);
  {$ELSE}
  RegisterComponents('Datensteuerung', [TDBLookUpGrid,TDBHLLookUpPanel,
    TDBHlPanel]);
  {$ENDIF}
end;

end.
