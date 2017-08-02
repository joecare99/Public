program prj_TestClasses;

{$apptype console}
uses
  cls_BaseClass,
  cls_ChildClass;

begin
  writeln(TChildClass.GetTest);
  writeln(TChildClass.TestProp);
  readln;
end.
