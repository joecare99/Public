unit Frm_TestFrame2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  GenealogyDataModule, AHW52PersonEditFrame;

type

  { TForm1 }

  TForm1 = class(TForm)
    PersonEditFrame: TAHW52PersonEditFrame;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.
