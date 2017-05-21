unit DebugPanelUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, SymbolUnit;

type

  { TDebugPanelForm }

  TDebugPanelForm = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DebugPanelForm: TDebugPanelForm;
  TestSchObj    : TSchematicObject;
  PTestSchObj   : ^TSchematicObject;

implementation

{$R *.lfm}

{ TDebugPanelForm }

procedure TDebugPanelForm.FormCreate(Sender: TObject);
begin
  Edit1.Text:=IntToStr(Screen.PixelsPerInch);
  TestSchObj:=TSchematicObject.Create;
//  PTestSchObj := @TestSchObj;
end;

procedure TDebugPanelForm.Button1Click(Sender: TObject);
begin
 TestSchObj.setHeightAndWidth(5,5,TestSchObj);  {This works}
 TSchematicObject.setHeightAndWidth(5,5,TestSchObj); {This doesn't - but why, if setHeightAndWidth is a static function}
end;

procedure TDebugPanelForm.Edit2Click(Sender: TObject);
begin
  Edit2.Text:=IntToStr(TestSchObj.Width);
end;

end.

