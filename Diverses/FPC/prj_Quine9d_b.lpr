program prj_Quine9d_b;

uses
    SysUtils;

const
    c = 'const b='#39;
    b = ''';var d:char;begin write(''const b=''#39+b);for d in b do write(char(byte(d)%0:s))end.';
var
    d:     Char;
    I:     Integer;
    bTest: Boolean;
begin
    writeln(32 - Byte('§'[1]));
    for I := 1 to 9 do
      begin
        Write('const b=' + #39);
        bTest := False;
        for d In Format(b, ['-' + IntToStr(I)]) do
          begin
            Write(Char(Byte(d) + I));
            bTest := bTest Or (Byte(d) + I = 39);
          end;
        //  write(#39);
        //  write(c);
        writeln(Format(b, ['-' + IntToStr(I)]));
        if btest then
            writeln('-> NIO');

      end;//  write(#39);
    for I := 1 to 9 do
      begin
        bTest := False;
        Write('const b=' + #39);
        for d In Format(b, ['+' + IntToStr(I)]) do
          begin
            Write(Char(Byte(d) - I));
            bTest := bTest Or (Byte(d) - I = 39);
          end;
        //  write(#39);
        //  write(c);
        writeln(Format(b, ['+' + IntToStr(I)]));
        if btest then
            writeln('-> NIO');
      end;//  write(#39);
    //  write(c);
    readln;
end.
