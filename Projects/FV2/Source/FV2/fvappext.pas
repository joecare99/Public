unit fvAppExt;

{$mode objfpc}{$H+}

interface

uses
  classes, SysUtils, App, Drivers, fvForms, objects;

type

{ TAppExt }
 TDelegateEntry=record
   CmdNo:sw_Word;
   Delegate:TDelegateCmdProcedure;
 end;
 PAppExt=^TAppExt;
 TAppExt=object(TApplication)
        private
          Fdelegates:array of array of TDelegateEntry;
          FFormList:array of TfvForm;
          FdynCommand:Sw_Word;
          FmainForm: TfvForm;
        public
        constructor create;
        destructor Done; Virtual;
        procedure Initialize;virtual;
        Procedure InitStatusLine; Virtual;
        Procedure InitMenuBar; Virtual;
        Procedure InitDeskTop; Virtual;
        Procedure CreateForm(AForm:TfvForm;AFormClass:TfvFormClass);virtual;
        function RegisterCmdDelegate(const ADelegate:TDelegateCmdProcedure;Eventno:Sw_Word=0):Sw_Word;
        procedure HandleEvent(var Event: TEvent); Virtual;
     end;

implementation

uses views;
{ TAppExt }

constructor TAppExt.create;
begin
  inherited init;
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
  Eventno: Sw_Word): Sw_Word;

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
  Application:= new(PAppExt,Create);
finalization
  dispose(Application,Done);
end.

