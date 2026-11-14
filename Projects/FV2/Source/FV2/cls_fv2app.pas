unit cls_fv2app;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cls_fv2application, cls_fv2controls, cls_fv2forms;

type
  TProgram = class(TFvApplication)
  private
    FDesktop: TForm;
    FMenuBar: TControl;
    FCloseRequested: Boolean;
    FStatusLine: TControl;
    procedure SetDesktop(AValue: TForm);
  protected
    procedure InitDesktop; virtual;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure CloseRequested(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Initialize; override;
    property Desktop: TForm read FDesktop write SetDesktop;
    property MenuBar: TControl read FMenuBar write FMenuBar;
    property StatusLine: TControl read FStatusLine write FStatusLine;
  end;

  TApplication = class(TProgram);

var
  Application: TApplication;

implementation

constructor TProgram.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TProgram.Initialize;
begin
  inherited Initialize;
  InitDesktop;
  InitMenuBar;
  InitStatusLine;
end;

procedure TProgram.InitDesktop;
begin
  if not Assigned(FDesktop) then
  begin
    FDesktop := TForm.Create(Self);
    FDesktop.Bounds := Rect(0, 0, 80, 25);
    MainForm := FDesktop;
    FDesktop.OnCloseRequest := @CloseRequested;
  end;
end;

procedure TProgram.InitMenuBar;
begin
end;

procedure TProgram.InitStatusLine;
begin
end;

procedure TProgram.SetDesktop(AValue: TForm);
begin
  FDesktop := AValue;
  if Assigned(FDesktop) then
  begin
    MainForm := FDesktop;
    FDesktop.OnCloseRequest := @CloseRequested;
  end;
end;

procedure TProgram.CloseRequested(Sender: TObject);
begin
  FCloseRequested := True;
  Terminate;
end;

initialization
  Application := TApplication.Create(nil);

finalization
  FreeAndNil(Application);

end.
