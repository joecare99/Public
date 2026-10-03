unit CalculatorApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, DesktopApplication, DesktopWorkspace, DesktopServices,
  CalculatorViewModel, CalculatorView;

type
  TCalculatorApplication = class(TDesktopApplication)
  private
    FViewModel: TCalculatorViewModel;
    FView: TCalculatorView;
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
    destructor Destroy; override;
    procedure Open; override;
  end;

implementation

constructor TCalculatorApplication.Create(AWorkspace: TDesktopWorkspace;
  const AServices: IDesktopServices; AOnOpened: TNotifyEvent);
begin
  inherited Create('Calculator', AWorkspace, AServices, AOnOpened);
  FViewModel := TCalculatorViewModel.Create;
  FView := TCalculatorView.Create(AWorkspace, FViewModel, @NotifyOpened);
end;

destructor TCalculatorApplication.Destroy;
begin
  FView.Free;
  FViewModel.Free;
  inherited Destroy;
end;

procedure TCalculatorApplication.Open;
begin
  FView.Open;
end;

end.
