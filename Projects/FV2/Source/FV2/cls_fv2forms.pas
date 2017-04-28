unit cls_Fv2Forms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Views, cls_fv2Controls;

type

{ TForm }

TForm=class(TComponent)
  private
    FAlign: TAlignment;
    FFVGroup:TGroup;
    FAction: TBasicAction;
    FActiveControl: TControl;

    FAllowDropFiles: boolean;
  procedure SetAction(AValue: TBasicAction);
  procedure SetActiveControl(AValue: TControl);
  procedure SetAlign(AValue: TAlignment);

  procedure SetAllowDropFiles(AValue: boolean);
        published
        Property Action:TBasicAction read FAction write SetAction;
        Property ActiveControl:TControl read FActiveControl write SetActiveControl;
        Property Align:TAlignment read FAlign write SetAlign;
        Property AllowDropFiles:boolean read FAllowDropFiles write SetAllowDropFiles;

      end;

implementation

{ TForm }

procedure TForm.SetAction(AValue: TBasicAction);
begin
  if FAction=AValue then Exit;
  FAction:=AValue;
end;

procedure TForm.SetActiveControl(AValue: TControl);
begin
  if FActiveControl=AValue then Exit;
  FActiveControl:=AValue;
end;

procedure TForm.SetAlign(AValue: TAlignment);
begin
  if FAlign=AValue then Exit;
  FAlign:=AValue;
end;

procedure TForm.SetAllowDropFiles(AValue: boolean);
begin
  if FAllowDropFiles=AValue then Exit;
  FAllowDropFiles:=AValue;
end;

end.

