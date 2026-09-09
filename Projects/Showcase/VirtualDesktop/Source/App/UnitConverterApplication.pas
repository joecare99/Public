unit UnitConverterApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, DesktopApplication, DesktopWindow,
  DesktopWorkspace,
  DesktopServices, UnitConverterViewModel;

type
  TUnitConverterApplication = class(TDesktopApplication)
  private
    FViewModel: TUnitConverterViewModel;
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    destructor Destroy; override;
    procedure Open; override;
  end;

implementation

constructor TUnitConverterApplication.Create(AWorkspace: TDesktopWorkspace;
  const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
begin
  inherited Create('Unit converter', AWorkspace, AServices, AOnOpened);
  FViewModel := TUnitConverterViewModel.Create;
end;

destructor TUnitConverterApplication.Destroy;
begin
  FViewModel.Free;
  inherited Destroy;
end;

procedure TUnitConverterApplication.Open;
var
  Window: TDesktopWindow;
  LabelControl: TLabel;
begin
  Window := FWorkspace.CreateWindow(Name, 690, 360, 360, 180);
  LabelControl := TLabel.Create(Window.ClientArea);
  LabelControl.Parent := Window.ClientArea;
  LabelControl.SetBounds(18, 22, 320, 80);
  LabelControl.Caption := '100 cm = ' +
    FloatToStr(TUnitConverterViewModel.ConvertLength(100, 'cm', 'm')) + ' m';
  NotifyOpened(Self);
end;

end.
