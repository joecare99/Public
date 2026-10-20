unit AHW52AddressFrameTests;

{$mode objfpc}{$H+}

interface

uses
  AHW52AddressFrame, StdCtrls, fpcunit, testregistry;

type
  TTestAHW52AddressFrame = class(TTestCase)
  published
    procedure TestMainFormStreamsAddressFrameAndPreservesBindings;
  end;

implementation

uses
  Forms, frmAhnenWinMain;

procedure TTestAHW52AddressFrame.
  TestMainFormStreamsAddressFrameAndPreservesBindings;
var
  mainForm: TForm1;
  addressFrame: TAHW52AddressFrame;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    addressFrame := mainForm.AddressFrame;
    AssertTrue('TabSheet8 should stream its production address frame.',
      Assigned(addressFrame));
    AssertTrue('The address frame should be parented by TabSheet8.',
      addressFrame.Parent = mainForm.TabSheet8);
    AssertEquals('The address tab caption should remain unchanged.',
      'Adresse', mainForm.TabSheet8.Caption);
    AssertEquals('The address tab image index should remain unchanged.',
      7, mainForm.TabSheet8.ImageIndex);
    AssertEquals('The address frame should own all 30 original controls.',
      30, addressFrame.ComponentCount);
    AssertEquals('The address panel should retain its original width.',
      839, addressFrame.Panel2.Width);
    AssertEquals('The address panel should retain its original height.',
      492, addressFrame.Panel2.Height);
    AssertEquals('The address panel should retain its original help context.',
      103, addressFrame.Panel2.HelpContext);

    AssertEquals('The first address field binding should be preserved.',
      'Adr1', addressFrame.DBEdit64.DataField);
    AssertEquals('The second address field binding should be preserved.',
      'Adr2', addressFrame.DBEdit65.DataField);
    AssertEquals('The postal-code field binding should be preserved.',
      'PLZ', addressFrame.DBEdit66.DataField);
    AssertEquals('The address supplement binding should be preserved.',
      'Adrzus', addressFrame.DBEdit68.DataField);
    AssertEquals('The telephone field binding should be preserved.',
      'Tel', addressFrame.DBEdit1.DataField);
    AssertEquals('The email field binding should be preserved.',
      'Ema', addressFrame.DBEdit11.DataField);
    AssertEquals('The web-address field binding should be preserved.',
      'Ur', addressFrame.DBEdit15.DataField);
    AssertEquals('The town field should remain an editable plain combo box.',
      Ord(csSimple), Ord(addressFrame.ComboBox26.Style));
    AssertTrue('The address edit controls should not open or attach a dataset.',
      (addressFrame.DBEdit64.DataSource = nil) and
      (addressFrame.DBEdit65.DataSource = nil) and
      (addressFrame.DBEdit66.DataSource = nil) and
      (addressFrame.DBEdit68.DataSource = nil) and
      (addressFrame.DBEdit1.DataSource = nil) and
      (addressFrame.DBEdit11.DataSource = nil) and
      (addressFrame.DBEdit15.DataSource = nil));
    AssertTrue('The city-combo exit event should belong to the frame.',
      addressFrame.ComboBox26.OnExit = @addressFrame.ComboBox26Exit);
    AssertTrue('Tab enter should route through the address frame.',
      mainForm.TabSheet8.OnEnter = @addressFrame.TabSheet8Enter);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52AddressFrame);

end.
