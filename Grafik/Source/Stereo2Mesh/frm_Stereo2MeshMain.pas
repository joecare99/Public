unit frm_Stereo2MeshMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, BGRAVirtualScreen,
  BGLVirtualScreen;

type

  { TFrmStereo2MeshMain }

  TFrmStereo2MeshMain = class(TForm)
    BGLVirtualScreen1: TBGLVirtualScreen;
    BGRAVirtualScreen1: TBGRAVirtualScreen;
    BGRAVirtualScreen2: TBGRAVirtualScreen;
  private

  public

  end;

var
  FrmStereo2MeshMain: TFrmStereo2MeshMain;

implementation

{$R *.lfm}

end.

