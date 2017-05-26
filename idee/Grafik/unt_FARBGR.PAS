unit unt_FARBGR;

interface

uses graph;

const maxhell=256;
        { Anzahl der Hellichkeitsstufen }
      maxfarb=256;
        { Anzahl der Farben }

procedure
  fputpixel(X,Y,Farbe,Hellichkeit:integer);
   { x,y : X- und Y-Koordinate des Punktes

 farbe,hellichkeit : Farben und Hellichkeit

     Die Farben von  F  entsprechen den
       unteren 8 Farben im Textmodus !

  Hellichkeit :=  0 -> Dunkel bzw. Schwarz
  Hellichkeit := 18 -> Hell   bzw. Weiá

    º     Bitte prfen Sie, daá:    º
    º   0 <=      x      <= getmaxx º
    º   0 <=      y      <= getmaxy º
    º   0 <=    farbe    <= maxfarb º
    º   0 <= hellichkeit <= maxhell º
    º            gilt !             º

}
implementation


procedure fputpixel(X, Y, Farbe, Hellichkeit: integer);

var r,g,b:integer;

begin
  if Hellichkeit <128 then
    begin
       r:=trunc((sin(2*pi*farbe/256)*0.5+0.5)*Hellichkeit*2);
       g:=trunc((sin(2*pi*farbe/256+2*pi/3)*0.5+0.5)*Hellichkeit*2);
       b:=trunc((sin(2*pi*farbe/256+4*pi/3)*0.5+0.5)*Hellichkeit*2);
     end
   else
     begin
       r:=255-trunc((sin(pi+2*pi*farbe/256)*0.5+0.5)*(255-Hellichkeit)*2);
       g:=255-trunc((sin(pi+2*pi*farbe/256+2*pi/3)*0.5+0.5)*(255-Hellichkeit)*2);
       b:=255-trunc((sin(pi+2*pi*farbe/256+4*pi/3)*0.5+0.5)*(255-Hellichkeit)*2);
     end ;
   putpixel(x,y,b*$10000+g*$100+r);
end;

end.
