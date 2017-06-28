unit unt_WritePascal4;

{$mode objfpc}{$H+}

interface

procedure Main;

implementation

uses Math;

type
    l0 = 0..11;

const
    ll = $EA48A42E8EA435F; (* This defines "Pascal" *)
    l1 = $714;
    lO = $40840708F7D8E14D;
    lI = ll and -ll; // 1
    lQ = lI - lI;  // 0
    l = lI shl lI; // 2
    I = l shl l;  //8
    Q = I - l - lI; //5
    D = #8' \_/';

//    cc: array[0..6] of TEnumerator = (3, 2, 0, 1, 0, 1, 0); //= $44b
// replaced by Index cc1
//cc0: array [0..(Acht-Eins)*(Fuenf-Eins)-Eins] of integer = (* Here are all string-constants *)
//  //    #8'__/\    '#8'    '#8'__    \ '#8' \  ';

// (0,3,3,4,2,1,1,
// 1,1,0,1,1,1,1,
// 0,3,3,1,1,1,1,
// 2,1,0,1,2,1,1);

procedure Main;

var
    OO, O0, Q0: integer;
    //v: TValue;

    //function cc0(Idx: integer): TValue;
    //begin
    //    Result := (ll xor l1) shr (((((ll shr ((x and (I + I -
    //                  lI)) * (Q - lI) + y div (I - Q))) and ((I -
    //                  Q) - (y div (I + lI)) shl lI)) - (Q - lI) +
    //                  (l - y mod (I - Q)) shl l) mod (Q - lI) +
    //                  (I - Q)) * l) and (l + lI);
    //end;

    //function cc1(Idx: integer): TValue;
    //begin
    //    Result := (ll xor lO) div round(power(Q, 27 - (Idx))) mod Q;
    //end;
    //  37252902984619140625
begin                 //   7450580596923828125
    //v := 0;


    //for OO := 0 to 27 do
    //    Writeln(IntToStr(OO) + ': ' + boolToStr(cc1(OO) = cc1(OO), ' ', '-') + #9 + inttohex(lO shr OO and $3fff, 4) + #9 + inttohex(ll shr OO and $3fff, 4));
    //writeln('$'+IntToHex(v,16));

    for O0 in l0 do
      begin
        Write(StringOfChar(D[l], (I + Q) - O0));
        for OO := lQ to (I + I) do
            for Q0 in l0 do
                if Q0 < Q + (OO mod (I - Q)) and l then
                    Write(D[((ll xor lO) div round(power(Q, ((I +
                      lI) * (I - Q)) - (((ll xor l1) shr (((((ll shr ((OO and (I + I -
                      lI)) * (Q - lI) + O0 div (I - Q))) and ((I -
                      Q) - (O0 div (I + lI)) shl lI)) - (Q - lI) +
                      (l - O0 mod (I - Q)) shl l) mod (Q - lI) +
                      (I - Q)) * l) and (l + lI)) * (I - lI) + Q0))) mod Q) + lI]);


        writeln;
      end;
    readln;
end;

end.
