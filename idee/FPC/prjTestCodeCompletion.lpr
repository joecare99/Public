program prjTestCodeCompletion;

{$mode objfpc}{$H+}
{$ifdef darwin}
{$modeswitch objectivec2}
{$endif}

uses
{$ifdef darwin}
,CocoaAll
{$endif}
 classes,
 nullstream;

type
  { TMyDelegate }
  TMyDelegate = objcclass(NSObject)
  public
    procedure HandleButtonClick(sender: id); message 'HandleButtonClick:';
  end;

var
  appName: NSString;
  window: NSWindow;
  pool: NSAutoreleasePool;
  lText: NSTextField;
  lButton: NSButton;
  lDelegate: TMyDelegate;

procedure TMyDelegate.HandleButtonClick(sender: id);
begin
  lText.setStringValue(NSSTR('New text!'));
end;

begin
  // Autorelease pool, app and window creation
  pool := NSAutoreleasePool.new;
  NSApp := NSApplication.sharedApplication;
  NSApp.setActivationPolicy(NSApplicationActivationPolicyRegular);
  appName := NSProcessInfo.processInfo.processName;
  window := NSWindow.alloc.initWithContentRect_styleMask_backing_defer(NSMakeRect(0, 0, 200, 200),
    NSTitledWindowMask or NSClosableWindowMask or NSMiniaturizableWindowMask or NSResizableWindowMask,
    NSBackingStoreBuffered, False).autorelease;

  // text label
  lText := NSTextField.alloc.initWithFrame(NSMakeRect(50, 50, 120, 50)).autorelease;
  lText.setBezeled(False);
  lText.setDrawsBackground(False);
  lText.setEditable(False);
  lText.setSelectable(False);
  lText.setStringValue(NSSTR('NSTextField'));
  window.contentView.addSubview(lText);

  // button
  lButton := NSButton.alloc.initWithFrame(NSMakeRect(50, 100, 120, 50)).autorelease;
  window.contentView.addSubview(lButton);
  lButton.setTitle(NSSTR('Button title!'));
  lButton.setButtonType(NSMomentaryLightButton);
  lButton.setBezelStyle(NSRoundedBezelStyle);

  // button event handler setting
  lDelegate := TMyDelegate.alloc.init;
  lButton.setTarget(lDelegate);
  lButton.setAction(ObjCSelector(lDelegate.HandleButtonClick));

  // Window showing and app running
  window.center;
  window.setTitle(appName);
  window.makeKeyAndOrderFront(nil);
  NSApp.activateIgnoringOtherApps(true);
  NSApp.run;
end.

