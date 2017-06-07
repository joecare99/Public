Program Filter;
{$APPTYPE CONSOLE}

var ch:char;

begin
  assign (output,'');
  assign (input,'');
  reset(input);
  rewrite(output);
  repeat
    read(ch);
    if ch<>#13 then write(ch)

  until eof(input)
  ;
end .
