unit NotepadView;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, ExtCtrls, Graphics, Dialogs, StdCtrls,
  DesktopWindow, DesktopWorkspace, NotepadViewModel;

type
  TNotepadView = class
  private
    FWorkspace: TDesktopWorkspace;
    FViewModel: TNotepadViewModel;
    FOnOpened: TNotifyEvent;
    FMemo: TMemo;
    procedure SaveNotes(Sender: TObject);
  public
    constructor Create(AWorkspace: TDesktopWorkspace;
      AViewModel: TNotepadViewModel; AOnOpened: TNotifyEvent);
    procedure Open;
  end;

implementation

constructor TNotepadView.Create(AWorkspace: TDesktopWorkspace;
  AViewModel: TNotepadViewModel; AOnOpened: TNotifyEvent);
begin
  FWorkspace := AWorkspace;
  FViewModel := AViewModel;
  FOnOpened := AOnOpened;
end;

procedure TNotepadView.Open;
var
  Window: TDesktopWindow;
  Footer: TPanel;
  SaveButton: TButton;
begin
  Window := FWorkspace.CreateWindow('Notepad', 10, 360, 440, 240);
  FMemo := TMemo.Create(Window);
  FMemo.Parent := Window;
  FMemo.SetBounds(18, 48, 400, 135);
  FMemo.Lines.Text := FViewModel.Text;
  FMemo.ScrollBars := ssAutoBoth;
  Footer := TPanel.Create(Window);
  Footer.Parent := Window;
  Footer.SetBounds(18, 190, 400, 35);
  Footer.BevelOuter := bvNone;
  Footer.Color := Window.Color;
  SaveButton := TButton.Create(Footer);
  SaveButton.Parent := Footer;
  SaveButton.SetBounds(0, 0, 90, 30);
  SaveButton.Caption := 'Save';
  SaveButton.OnClick := @SaveNotes;
  if Assigned(FOnOpened) then
    FOnOpened(Self);
end;

procedure TNotepadView.SaveNotes(Sender: TObject);
begin
  if Assigned(FMemo) then begin
    FViewModel.UpdateText(FMemo.Lines.Text);
    FViewModel.SaveCommand.Execute('');
  end;
end;

end.
