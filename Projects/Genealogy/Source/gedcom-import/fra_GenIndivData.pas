unit fra_GenIndivData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, unt_IGenBase2;



type

  { TFraGenIndivData }

  TFraGenIndivData = class(TFrame)
    pnlTop: TPanel;
    pnlBottom2: TPanel;
    pnlBottom: TPanel;
    pnlClient: TPanel;
    Splitter1: TSplitter;
  private
    FIndividual: IGenIndividual;
    FOnIndBrowse: TNotifyEvent;
    procedure SetIndividual(const AValue: IGenIndividual);
    procedure SetOnIndBrowse(const AValue: TNotifyEvent);

  public
    constructor Create(TheOwner: TComponent); override;
    Property Individual:IGenIndividual read FIndividual write SetIndividual;
    property OnIndBrowse:TNotifyEvent read FOnIndBrowse write SetOnIndBrowse;
  end;

implementation

{$R *.lfm}

{ TFraGenIndivData }

procedure TFraGenIndivData.SetIndividual(const AValue: IGenIndividual);
begin
  if FIndividual=AValue then Exit;
  FIndividual:=AValue;
end;

procedure TFraGenIndivData.SetOnIndBrowse(const AValue: TNotifyEvent);
begin
  if FOnIndBrowse=AValue then Exit;
  FOnIndBrowse:=AValue;
end;

constructor TFraGenIndivData.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

end;

end.

