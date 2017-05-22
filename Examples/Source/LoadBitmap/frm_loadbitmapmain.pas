unit Frm_LoadBitmapMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls;

type
  TLoadBitmapForm = class(TForm)
    Image1: TImage;
  public
    constructor Create(TheOwner: TComponent); override;
  end;

var
  LoadBitmapForm: TLoadBitmapForm;

implementation


{ TLoadBitmapForm }

constructor TLoadBitmapForm.Create(TheOwner: TComponent);
var
  Filename: string;
begin
  inherited CreateNew(TheOwner, 1);

  Filename := SetDirSeparators('../../examples/images/splash_logo.xpm');

  Caption := 'Example: Loading picture from file';
  Width := 429;
  Height := 341;
  Position := poScreenCenter;

  Image1 := TImage.Create(Self);
  with Image1 do
  begin
    Name := 'Image1';
    Parent := Self;
    Align := alClient;
    Picture.LoadFromFile(Filename);
  end;
end;


end.
