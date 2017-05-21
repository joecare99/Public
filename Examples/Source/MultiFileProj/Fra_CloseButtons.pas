unit Fra_CloseButtons;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Buttons, ComCtrls;

type

  { TfraCloseButtons }

  TfraCloseButtons = class(TFrame)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    StatusBar1: TStatusBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TfraCloseButtons }

procedure TfraCloseButtons.BitBtn1Click(Sender: TObject);
begin
  TForm(parent).Close;
end;

procedure TfraCloseButtons.BitBtn2Click(Sender: TObject);
begin
  TForm(parent).Close;
end;

end.

