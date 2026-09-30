unit fra_GenIndivEvent;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Buttons, EditBtn, ComboEx,
  ExtCtrls, unt_IGenBase2;

type
  TEventField=(
     evf_Date,  // The Date of the Event
     evf_Place, // The Place of the Event
     evf_Desc, // The Description of the Event
     evf_Note, // An Additional Note for the Event
     evf_Assoc // an Associated 2nd Person
     );
  TEventFields = set of TEventField;
  { TFraGenEvent }

  TFraGenEvent = class(TFrame)
    cbxAssociation: TComboBoxEx;
    cbxPlace: TComboBoxEx;
    cbxDescription: TComboBoxEx;
    edtDate: TEditButton;
    Memo1: TMemo;
    pnlClient: TPanel;
    pnlLeft: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    lblEvent: TStaticText;
    procedure edtDateChange(Sender: TObject);
    // Event-Label
    // Date-Edit-Field
    // Date-Calculator
    // Place-Edit-Field
    // Place-Lookup
    // Description-Edit-Field
    // Note-Edit Field
    // Association - Edit
    // Assosiation-Lookup
    // Quotation-Lookup
  private
    FEventType: TenumEventType;
    FFamily: iGenFamily;
    FIndividual: iGenIndividual;
    procedure SetEventType(const AValue: TenumEventType);
    procedure SetFamily(const AValue: iGenFamily);
    procedure SetIndividual(const AValue: iGenIndividual);
    procedure SetOnFamBrowse(const AValue: TNotifyEvent);
    procedure SetOnIndBrowse(const AValue: TNotifyEvent);

  public
    constructor Create(TheOwner: TComponent); override;
    Property EventType:TenumEventType read FEventType write SetEventType;
    Property Individual:iGenIndividual read FIndividual write SetIndividual;
    Property Family:iGenFamily read FFamily write SetFamily;
  end;

implementation

{$R *.lfm}

{ TFraGenEvent }

procedure TFraGenEvent.edtDateChange(Sender: TObject);
begin

end;

procedure TFraGenEvent.SetEventType(const AValue: TenumEventType);
begin
  if FEventType=AValue then Exit;
  FEventType:=AValue;
end;

procedure TFraGenEvent.SetFamily(const AValue: iGenFamily);
begin
  if FFamily=AValue then Exit;
  FFamily:=AValue;
end;

procedure TFraGenEvent.SetIndividual(const AValue: iGenIndividual);
begin
  if FIndividual=AValue then Exit;
  FIndividual:=AValue;
end;

procedure TFraGenEvent.SetOnFamBrowse(const AValue: TNotifyEvent);
begin

end;

procedure TFraGenEvent.SetOnIndBrowse(const AValue: TNotifyEvent);
begin

end;

constructor TFraGenEvent.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

end.

