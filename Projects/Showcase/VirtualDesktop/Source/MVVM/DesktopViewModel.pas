unit DesktopViewModel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Services, Mvvm;

type
  TDesktopViewModel = class(TNotifyPropertyChangedObject)
  private
    FClock: IClockService;
    FOpenCount: Integer;
  public
    constructor Create(const AClock: IClockService);
    procedure RegisterOpenedApp;
    function WelcomeCaption: string;
    function StatusCaption: string;
  end;

implementation

constructor TDesktopViewModel.Create(const AClock: IClockService);
begin
  inherited Create;
  FClock := AClock;
end;

procedure TDesktopViewModel.RegisterOpenedApp;
begin
  Inc(FOpenCount);
  NotifyPropertyChanged('StatusCaption');
end;

function TDesktopViewModel.WelcomeCaption: string;
begin
  Result := FormatDateTime('dddd, dd. mmmm yyyy', FClock.Now);
end;

function TDesktopViewModel.StatusCaption: string;
begin
  Result := Format('%d application window(s) opened', [FOpenCount]);
end;

end.
