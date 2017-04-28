unit fv2appext;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fv2App, fv2Drivers, fv2Forms;

type

{ TAppExt }
 TDelegateEntry=record
   CmdNo:integer;
   Delegate:TDelegateCmdProcedure;
 end;
 PAppExt=^TAppExt deprecated 'use TAppExt';
 TAppExt=class(TApplication)
        private
          Fdelegates:array of array of TDelegateEntry;
          FFormList:array of TfvForm;
          FdynCommand:integer;
          FmainForm: TfvForm;
        public
        constructor create;
        destructor Done; Virtual;
        procedure Initialize;virtual;
        Procedure InitStatusLine; override;
        Procedure InitMenuBar; override;
        Procedure InitDeskTop; override;
        Procedure CreateForm(AForm:TfvForm;AFormClass:TfvFormClass);virtual;
        function RegisterCmdDelegate(const ADelegate:TDelegateCmdProcedure;Eventno:Integer=0):integer;
        procedure HandleEvent(var Event: TEvent); override;
     end;

implementation

uses fv2views;
{ TAppExt }

constructor TAppExt.create;
begin
  inherited Create;
  setlength(FFormList,0);
  setlength(Fdelegates,256);
  FdynCommand:=$8000;
end;

destructor TAppExt.Done;
var
  i: Integer;
begin
  for i := 0 to high(Fdelegates) do
    SetLength(Fdelegates[i],0);
  setlength(Fdelegates,0);
end;

procedure TAppExt.Initialize;
begin

end;

procedure TAppExt.InitStatusLine;
begin
  //
  if Assigned(FmainForm) then ;
end;

procedure TAppExt.InitMenuBar;
begin
  //
  if Assigned(FmainForm) then ;
end;

procedure TAppExt.InitDeskTop;
begin
  //
  if Assigned(FmainForm) then ;
end;

procedure TAppExt.CreateForm(AForm: TfvForm; AFormClass: TfvFormClass);

begin
  aForm:=AFormClass.Create(self);
  if not assigned(FmainForm) then
    FmainForm:= AForm;
  // load from ressource
  if assigned(AForm.OnFormCreate) then
    AForm.OnFormCreate(nil)
  else
    aForm.FormCreate(nil)
end;

function TAppExt.RegisterCmdDelegate(const ADelegate: TDelegateCmdProcedure;
  Eventno: Integer): integer;

var Arrel : array of TDelegateEntry;
  NewDelNo, i: Integer;
begin
  if Eventno=0 then
    begin
      inc(FdynCommand);
      result:=FdynCommand;
    end
  else
    result := Eventno;
  ArrEl := Fdelegates[result mod 255];
  NewDelNo:= high(ArrEl) +1;
  for i := 0 to high(Arrel) do
    if Arrel[i].CmdNo=result then
      NewDelNo := i;
  if NewDelNo> high(ArrEl) then
    SetLength(Fdelegates[result mod 255],NewDelNo+1);
  Fdelegates[result mod 255][NewDelNo].CmdNo:=result;
  Fdelegates[result mod 255][NewDelNo].Delegate:=ADelegate;
end;

procedure TAppExt.HandleEvent(var Event: TEvent);
var
  i: Integer;
begin
Inherited HandleEvent(Event);                      { Call ancestor }
If (Event.What = evCommand) Then Begin
  if high(Fdelegates[Event.Command mod 255]) = -1 then exit
  else
    for i := 0 to high(Fdelegates[Event.Command mod 255]) do
      if Fdelegates[Event.Command mod 255][i].CmdNo=Event.Command then
        begin
          if assigned(Fdelegates[Event.Command mod 255][i].delegate) then
            Fdelegates[Event.Command mod 255][i].Delegate(self,event);
          break;
        end;
  End;
ClearEvent(Event);
end;

initialization
  Application:= TAppExt.Create;
finalization
  FreeAndNil(Application);
end.

