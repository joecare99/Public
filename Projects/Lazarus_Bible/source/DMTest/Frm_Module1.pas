unit Frm_Module1;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus;

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    Exit1: TMenuItem;
    File1: TMenuItem;
    MainMenu1: TMainMenu;
    procedure DataModuleFormExit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

uses Frm_DMTestMain;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TDataModule1.DataModuleFormExit1Click(Sender: TObject);
begin
  MainForm.Close;
end;

end.
