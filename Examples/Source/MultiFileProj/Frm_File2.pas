unit Frm_File2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  Fra_CloseButtons;

type

  { TfrmDialog2 }

  TfrmDialog2 = class(TForm)
    Frame1_1: TfraCloseButtons;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmDialog2: TfrmDialog2;

implementation

{$R *.lfm}

end.

