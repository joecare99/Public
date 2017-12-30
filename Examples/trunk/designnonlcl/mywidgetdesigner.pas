{ Example designer for the Lazarus IDE

  Copyright (C) 2009 Mattias Gaertner mattias@freepascal.org

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:
  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.
  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.
  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.
}

unit MyWidgetDesigner;

{$mode objfpc}{$H+}

interface

uses
  LCLProc, LCLType, Classes, SysUtils, FormEditingIntf, LCLIntf, Graphics,
  ProjectIntf, MyWidgetSet;

type

  { TMyWidgetMediator }

  TMyWidgetMediator = class(TDesignerMediator,IMyWidgetDesigner)
  private
    FMyForm: TMyForm;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    // needed by the Lazarus form editor
    class function CreateMediator(TheOwner, aForm: TComponent): TDesignerMediator;
      override;
    class function FormClass: TComponentClass; override;
    procedure GetBounds(AComponent: TComponent; out CurBounds: TRect); override;
    procedure SetBounds(AComponent: TComponent; NewBounds: TRect); override;
    procedure GetClientArea(AComponent: TComponent; out
            CurClientArea: TRect; out ScrollOffset: TPoint); override;
    procedure Paint; override;
    function ComponentIsIcon(AComponent: TComponent): boolean; override;
    function ParentAcceptsChild(Parent: TComponent;
                Child: TComponentClass): boolean; override;
  public
    // needed by TMyWidget
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
    property MyForm: TMyForm read FMyForm;
  public
    procedure GetObjInspNodeImageIndex(APersistent: TPersistent; var AIndex: integer); override;
  end;

  { TFileDescPascalUnitWithMyForm }

  TFileDescPascalUnitWithMyForm = class(TFileDescPascalUnitWithResource)
  public
    constructor Create; override;
    function GetInterfaceUsesSection: string; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;


procedure Register;

implementation

procedure Register;
begin
  FormEditingHook.RegisterDesignerMediator(TMyWidgetMediator);
  RegisterComponents('MyWidgets',[TMyButton,TMyGroupBox]);
  RegisterProjectFileDescriptor(TFileDescPascalUnitWithMyForm.Create,
                                FileDescGroupName);
end;

{ TMyWidgetMediator }

constructor TMyWidgetMediator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TMyWidgetMediator.Destroy;
begin
  if FMyForm<>nil then FMyForm.Designer:=nil;
  FMyForm:=nil;
  inherited Destroy;
end;

procedure TMyWidgetMediator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation=opRemove then
  begin
    if FMyForm=AComponent then
    begin
      FMyForm.Designer:=nil;
      FMyForm:=nil;
    end;
  end;
end;

class function TMyWidgetMediator.CreateMediator(TheOwner, aForm: TComponent
  ): TDesignerMediator;
var
  Mediator: TMyWidgetMediator;
begin
  Result:=inherited CreateMediator(TheOwner,aForm);
  Mediator:=TMyWidgetMediator(Result);
  Mediator.FMyForm:=aForm as TMyForm;
  Mediator.FMyForm.FreeNotification(Mediator);
  Mediator.FMyForm.Designer:=Mediator;
end;

class function TMyWidgetMediator.FormClass: TComponentClass;
begin
  Result:=TMyForm;
end;

procedure TMyWidgetMediator.GetBounds(AComponent: TComponent; out
  CurBounds: TRect);
var
  w: TMyWidget;
begin
  if AComponent is TMyWidget then begin
    w:=TMyWidget(AComponent);
    CurBounds:=Bounds(w.Left,w.Top,w.Width,w.Height);
  end else
    inherited GetBounds(AComponent,CurBounds);
end;

procedure TMyWidgetMediator.InvalidateRect(Sender: TObject; ARect: TRect;
  Erase: boolean);
begin
  if (LCLForm=nil) or (not LCLForm.HandleAllocated) then exit;
  LCLIntf.InvalidateRect(LCLForm.Handle,@ARect,Erase);
end;

procedure TMyWidgetMediator.GetObjInspNodeImageIndex(APersistent: TPersistent;
  var AIndex: integer);
begin
  if Assigned(APersistent) then
  begin
    if (APersistent is TMyWidget) and (TMyWidget(APersistent).AcceptChildrenAtDesignTime) then
      AIndex := FormEditingHook.GetCurrentObjectInspector.ComponentTree.ImgIndexBox
    else
    if (APersistent is TMyWidget) then
      AIndex := FormEditingHook.GetCurrentObjectInspector.ComponentTree.ImgIndexControl
    else
      inherited;
  end
end;

procedure TMyWidgetMediator.SetBounds(AComponent: TComponent; NewBounds: TRect);
begin
  if AComponent is TMyWidget then begin
    TMyWidget(AComponent).SetBounds(NewBounds.Left,NewBounds.Top,
      NewBounds.Right-NewBounds.Left,NewBounds.Bottom-NewBounds.Top);
  end else
    inherited SetBounds(AComponent,NewBounds);
end;

procedure TMyWidgetMediator.GetClientArea(AComponent: TComponent; out
  CurClientArea: TRect; out ScrollOffset: TPoint);
var
  Widget: TMyWidget;
begin
  if AComponent is TMyWidget then begin
    Widget:=TMyWidget(AComponent);
    CurClientArea:=Rect(Widget.BorderLeft,Widget.BorderTop,
                        Widget.Width-Widget.BorderRight,
                        Widget.Height-Widget.BorderBottom);
    ScrollOffset:=Point(0,0);
  end else
    inherited GetClientArea(AComponent, CurClientArea, ScrollOffset);
end;

procedure TMyWidgetMediator.Paint;

  procedure PaintWidget(AWidget: TMyWidget);
  var
    i: Integer;
    Child: TMyWidget;
  begin
    with LCLForm.Canvas do begin
      // fill background
      Brush.Style:=bsSolid;
      Brush.Color:=clLtGray;
      FillRect(0,0,AWidget.Width,AWidget.Height);
      // outer frame
      Pen.Color:=clRed;
      Rectangle(0,0,AWidget.Width,AWidget.Height);
      // inner frame
      if AWidget.AcceptChildrenAtDesignTime then begin
        Pen.Color:=clMaroon;
        Rectangle(AWidget.BorderLeft-1,AWidget.BorderTop-1,
                  AWidget.Width-AWidget.BorderRight+1,
                  AWidget.Height-AWidget.BorderBottom+1);
      end;
      // caption
      TextOut(5,2,AWidget.Caption);
      // children
      if AWidget.ChildCount>0 then begin
        SaveHandleState;
        // clip client area
        MoveWindowOrgEx(Handle,AWidget.BorderLeft,AWidget.BorderTop);
        if IntersectClipRect(Handle, 0, 0, AWidget.Width-AWidget.BorderLeft-AWidget.BorderRight,
                             AWidget.Height-AWidget.BorderTop-AWidget.BorderBottom)<>NullRegion
        then begin
          for i:=0 to AWidget.ChildCount-1 do begin
            SaveHandleState;
            Child:=AWidget.Children[i];
            // clip child area
            MoveWindowOrgEx(Handle,Child.Left,Child.Top);
            if IntersectClipRect(Handle,0,0,Child.Width,Child.Height)<>NullRegion then
              PaintWidget(Child);
            RestoreHandleState;
          end;
        end;
        RestoreHandleState;
      end;
    end;
  end;

begin
  PaintWidget(MyForm);
  inherited Paint;
end;

function TMyWidgetMediator.ComponentIsIcon(AComponent: TComponent): boolean;
begin
  Result:=not (AComponent is TMyWidget);
end;

function TMyWidgetMediator.ParentAcceptsChild(Parent: TComponent;
  Child: TComponentClass): boolean;
begin
  Result:=(Parent is TMyWidget) and (Child.InheritsFrom(TMyWidget))
    and (TMyWidget(Parent).AcceptChildrenAtDesignTime);
end;

{ TFileDescPascalUnitWithMyForm }

constructor TFileDescPascalUnitWithMyForm.Create;
begin
  inherited Create;
  Name:='MyForm';
  ResourceClass:=TMyForm;
  UseCreateFormStatements:=true;
end;

function TFileDescPascalUnitWithMyForm.GetInterfaceUsesSection: string;
begin
  Result:='Classes, SysUtils, MyWidgetSet';
end;

function TFileDescPascalUnitWithMyForm.GetLocalizedName: string;
begin
  Result:='MyForm';
end;

function TFileDescPascalUnitWithMyForm.GetLocalizedDescription: string;
begin
  Result:='Create a new MyForm from example package NotLCLDesigner';
end;

end.

