program Prj_TestInterface;

{$mode delphi}
{$interfaces corba}
uses sysutils;

type
  IMyDelegate = interface
    ['{B4DF70E1-EFC8-4C98-ABA2-F42A71A9EA02}']
    procedure DoThis (value: integer);
  end;

  IMyDelegate2 = interface
    ['{8D53C8E5-8533-4C94-A55F-3A4070FA28FC}']
    procedure DoThat (value: integer);
  end;

  { TMyClass }

  TMyClass = class (TInterfacedObject, IMyDelegate)
    procedure DoThis (value: integer);
  end;

  { TMyClass2 }
  TMyClass2 = class (TInterfacedObject, IMyDelegate2)
    procedure DoThat (value: integer);
  end;

  { TMyClass3 }
  TMyClass3 = class (TInterfacedObject, IMyDelegate2,IMyDelegate)
    procedure DoThat (value: integer);
    procedure DoThis (value: integer);
  end;

procedure TMyClass3.DoThat(value: integer);
begin
  WriteLn('MyClass3.DoThat('+inttostr(value)+'): Fail!!!');
end;

procedure TMyClass3.DoThis(value: integer);
begin
  WriteLn('MyClass2.DoThis('+inttostr(value)+'): Also a Success!!!');
end;

{ TMyClass }

procedure TMyClass.DoThis(value: integer);

begin
  WriteLn('MyClass.DoThis('+inttostr(value)+'): Success!!!');
end;

{ TMyClass 2 }

procedure TMyClass2.DoThat(value: integer);
begin
  WriteLn('MyClass2.DoThat('+inttostr(value)+'): Fail !!!');
end;


procedure TestDelegate(AClass:TInterfacedObject);

begin
  try
    if assigned(AClass) then
      if Aclass is IMyDelegate then
        (Aclass as IMyDelegate).DoThis(1)
      else
        WriteLn(AClass.ClassName+' does not implement IMyDelegate')
    else
      WriteLn('AClass is not assigned');
  except
    WriteLn(AClass.ClassName+' --> Exception');
  end;
end;


var test:array[0..4] of TInterfacedObject;
  i: Integer;
  Str: string;

begin
  test[0]:= TInterfacedObject.Create;
  test[1]:= TMyClass.Create;
  test[2]:= TMyClass2.Create;
  test[3]:= TMyClass3.Create;
  for i := 0 to high(test) do
    TestDelegate(test[i]);
  WriteLn('Type <enter> to continue');
  ReadLn(Str);
  for i := 0 to high(test) do
    test[i].Free;
end.
