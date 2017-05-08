unit unt_PowerTest;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

(*
 * This program is not a Delphi project. It is a stand-alone
 * CRT application, which must be run from a DOS prompt. Follow
 * these steps to load the program into Delphi, compile,
 * and run:
 *
 * 1. Close any files now open.
 * 2. Use File|Open..., select *.pas files, open PowerTest.pas.
 * 3. Press Ctrl+F9 (Project|Compile) to create PowerTest.exe.
 * 4. Open a DOS-prompt window.
 * 5. Change to the Source\Power directory.
 * 6. Type PowerTest to run the test program.
 *
 * Note 1: If you run the CRT application using Explorer, the
 * DOS window closes as soon as the program ends. To prevent
 * this, run the program *after* opening a DOS prompt window.
 *
 * Note 2: The program intentionally displays four error
 * messages to demonstrate the Power function's exceptions.
 *)

interface

Procedure Execute;

implementation

uses SysUtils;

const
  sFmt = 'Exception raised in Power function. Base=%f Exp=%f';
type
{ Declare exception class }
  EPower = class(EMathError);
{ Return Base raised to Exponent }
function Power(Base, Exponent: Double): Double;

  function F(B, E: Double): Double;
  begin
    Result := Exp(E * Ln(B));
  end;

begin
  if Base = 0.0 then
    if Exponent = 0.0 then
      Result := 1.0
    else if Exponent < 1.0 then
      raise EPower.CreateFmt(sFmt, [Base, Exponent])
    else
      Result := 0.0
  else if Base > 0.0 then
    Result := F(Base, Exponent)
  else if Frac(Exponent) = 0.0 then
    if Odd(Trunc(Exponent)) then
      Result := -F(-Base, Exponent)
    else
      Result :=  F(-Base, Exponent )
  else raise EPower.CreateFmt(sFmt, [Base, Exponent]);
end; { Power }

{ Test procedure }
procedure Test(Base, Exponent: Double);
begin
  try
    Writeln(Base:8:3, ' ^ ', Exponent:8:3, ' = ',
      Power(Base, Exponent));
  except
    on E: EPower do
      Writeln(E.Message);
  end;
end;

Procedure Execute ;
{ The following is the CRT application's main body. It
  merely calls the test procedure with various values. The
  final four values intentionally test the Power function's
  exceptions. }
begin
  test( 7,    3  );
  test( 7,   -3  );
  test(-7,    3  );
  test(-7,   -3  );
  test( 7,    3.5);
  test( 7,   -3.5);
  test( 7.2,  3  );
  test( 7.2, -3  );
  test(-7.2,  3  );
  test(-7.2, -3  );
  test( 7.2,  3.5);
  test( 7.2, -3.5);
{ These four tests produce *expected* exceptions }
  test(-7,    3.5);
  test(-7,   -3.5);
  test(-7.2,  3.5);
  test(-7.2, -3.5);
  test( 0,    0.5);
  readln;
end;

end.

