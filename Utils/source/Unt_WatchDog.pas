unit Unt_WatchDog;

interface

uses classes,LogUnit,extctrls,LinLIst;

type TNotificationList = class (TLinList)
        DoExec:TNotifyEvent;
        constructor Create(NDoExec:TNotifyEvent;NNext:TLinList= nil);
     end;

     TWDComponent = class(TComponent)
       private
         WDTimer:TTimer;
         FNotifyList:TNotificationList;

         function getWDInterv:Cardinal;
         Procedure SetWDInterv(NewInterv:Cardinal);
         Procedure SetNotifyList(NewNLIst:TNotificationList);

       protected
         procedure WatchDog(sender:TObject);virtual;
       published
          property NotifyList:TNotificationList read FNotifylist write setNotifylist;
          property WDInterval:cardinal read GetWDinterv write SetWDinterv;

       public
         Constructor Create(AOwner:TComponent;WDIntervall:integer=500;WDEnabled:boolean=false);overload;
         destructor destroy; override;

     end;


implementation

constructor TNotificationlist.Create(NDoExec:TNotifyEvent;NNext:TLinList= nil);

begin
  inherited create(nnext);
  doexec:=NDoexec
end;


Constructor TWDComponent.Create(AOwner:TComponent;WDIntervall:integer=500;WDEnabled:boolean=false);

begin
  inherited create(AOwner);
  Wdtimer:=ttimer.Create (self);
  WDTimer.name := 'WDTimer';
  WDTimer.OnTimer := WatchDog ;
  wdtimer.Interval := WDIntervall;
  WDTimer.enabled:=WDEnabled;
end;

destructor Twdcomponent.destroy;

begin
  WDTimer.enabled:=false;
  wdtimer.Ontimer:=nil;
  wdtimer.free;
  inherited Destroy
end;

procedure TWDComponent.WatchDog(sender:TObject);

var p:TNotificationList ;

begin
  p:= FNotifyList  ;
  while assigned(p) do
    begin
      if assigned(p.doexec) then
        p.DoExec(self);
      p:= p.getnext as TNotificationList
    end
end;

function TWDComponent.getWDInterv:Cardinal;

begin
   getwdinterv:=WDTimer.Interval
end;

Procedure TWDComponent.SetWDInterv(NewInterv:Cardinal);

begin
   WDTimer.Interval:=Newinterv;
end;

Procedure TWDComponent.SetNotifyList ;

begin
   FNotifyList :=NewNLIst;
   if assigned(fnotifyList) and assigned(wdtimer.ontimer) then
     WDTimer.Enabled := true
   else
     WDTimer.Enabled := false;
end;


end.
