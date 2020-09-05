program prj_Quine2;
uses SysUtils;
const s='program prj_Quine2;%1:suses SysUtils;%1:sconst s=%0:s;%1:sbegin%1:s  writeln(Format(s,QuotedStr(s),LineEnding))%1:send.';
begin
  writeln(Format(s,[QuotedStr(s),LineEnding]))
end.

