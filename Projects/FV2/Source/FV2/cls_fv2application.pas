unit cls_fv2application;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

{ TFvApplication }

 TFvApplication=Class(TObject)
     constructor Create;
     Destructor Done;
     Procedure initialize;
     Procedure CreateForm(aFrmVar:TComponent;AFrmClass:TComponentClass);
     Procedure Run;
  end;

var Application:TfvApplication;
    RequireDerivedFormResource:boolean=true;

implementation

{ TFvApplication }

constructor TFvApplication.Create;
begin

end;

destructor TFvApplication.Done;
begin

end;

procedure TFvApplication.initialize;
begin

end;

procedure TFvApplication.CreateForm(aFrmVar: TComponent;
  AFrmClass: TComponentClass);
begin

end;

procedure TFvApplication.Run;
begin

end;

initialization
  Application:=TApplication.create;
finalization
  freeandnil(Application)
end.

