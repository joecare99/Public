program PrjHelloWorld2;
{$apptype gui}{$H+}
uses windows;
const c:string='deHlorW';
  var v1,v2:string;
begin
  v1:=c[7]+c[5]+c[6]+c[4]+c[1];
  v2:=c[3]+c[2]+c[4]+c[4]+c[5];
  MessageBox(0,pchar(v1),pchar(v2),0);
end.

