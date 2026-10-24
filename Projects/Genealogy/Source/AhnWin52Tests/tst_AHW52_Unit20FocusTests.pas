unit tst_AHW52_Unit20FocusTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit20Focus = class(TTestCase)
  published
    procedure TestLookupClickMovesActiveControlToMembershipEdit;
    procedure TestCancelClickSetsModalResultOnGlobalForm;
  end;

implementation

uses
  Controls, Forms, StdCtrls, DBCtrls, Unit20;

procedure TTestAHW52Unit20Focus.
  TestLookupClickMovesActiveControlToMembershipEdit;
var
  form: TForm20;
  lookup: TDBLookupComboBox;
  membershipEdit: TEdit;
begin
  form := TForm20.CreateNew(nil);
  try
    lookup := TDBLookupComboBox.Create(form);
    lookup.Parent := form;
    membershipEdit := TEdit.Create(form);
    membershipEdit.Parent := form;
    form.dblookupcombobox1 := lookup;
    form.Edit1 := membershipEdit;
    form.ActiveControl := lookup;

    form.dblookupcombobox1Click(lookup);

    AssertSame(membershipEdit, form.ActiveControl);
  finally
    form.Free;
  end;
end;

procedure TTestAHW52Unit20Focus.TestCancelClickSetsModalResultOnGlobalForm;
var
  globalForm: TForm20;
  eventReceiver: TForm20;
  previousGlobalForm: TForm20;
begin
  previousGlobalForm := Form20;
  globalForm := TForm20.CreateNew(nil);
  eventReceiver := TForm20.CreateNew(nil);
  try
    Form20 := globalForm;
    globalForm.ModalResult := mrNone;
    eventReceiver.ModalResult := mrNone;

    eventReceiver.BitBtn2Click(eventReceiver);

    AssertEquals(Ord(mrCancel), Ord(globalForm.ModalResult));
    AssertEquals(Ord(mrNone), Ord(eventReceiver.ModalResult));
  finally
    Form20 := previousGlobalForm;
    eventReceiver.Free;
    globalForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit20Focus);

end.
