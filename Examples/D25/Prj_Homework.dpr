program Prj_Homework;
{$ifdef fpc}{$mode objfpc}{$endif}{$apptype console}
uses sysutils;
procedure proc1;
begin
  Beep;
end;

procedure proc2;
begin
  Proc1;
end;

function func1:boolean;
begin
   result := Boolean(random(1));
end;

function func2:boolean;
begin
  result := true;
end;

var
   a,b:Boolean;
   c:integer = 100;
   d:single = 100.1;
   e:string = 'Finished homework';
begin
   if round(d)= c then
   begin
     b:=func1;
     if b = func1 then
     case b of
       true:proc1;
       false:proc2;
     else
       for b := false to true do
       while  b = func2 do
         repeat
           a :=func1;
         until a = b;
     end;
   writeln(e);
   end;
end.
