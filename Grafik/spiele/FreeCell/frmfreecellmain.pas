unit FrmFreecellMain;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

// Todo -ojc : Test

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type
  TForm1 = class(TForm)
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

end.

