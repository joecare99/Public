unit frm_text2html;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, IpHtml, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    IpHtmlPanel1: TIpHtmlPanel;
    Memo1: TMemo;
    procedure Memo1Change(Sender: TObject);
  private
    function TextToHTML(Txt: string): string;
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

uses strutils;

{$R *.lfm}

{ TForm1 }

{** procedure Execute

  This procedure will :
        - Go Up 	| And	|
	- Go Down	| or	|
  	- And Running 	| again	|
}
function TForm1.TextToHTML(Txt: string): string;
var
  p,po,pc,TabSize: Integer;
begin
  Result:=Txt;
  p:=length(Result);
  while p>0 do
  begin
    case Result[p] of
    ' ': Result:=copy(Result,1,p-1)+'&nbsp;'+copy(Result,p+1,length(Result));
    #$A0:
       if (p>1) and (Result[p-1] = #$c2) then
         begin
           dec(p);
           Result:=copy(Result,1,p-1)+'&nbsp;'+copy(Result,p+2,length(Result));
         end;
    #9:
      begin
        po := p;
        TabSize := 8;
        while (po>1) and not (result[po] in [#10,#13]) do
          dec(po);
        inc(po);
        pc := 0;
        while (po<p) do
          begin
            if result [po] = #9 then
              pc := ((pc ) div TabSize) *TabSize +TabSize-1 ;
            if (result [po] = #$C2) then
              dec(pc);
             inc(pc);
            inc(po);
          end;
          pc := TabSize - (pc mod TabSize);
        Result:=copy(Result,1,p-1)+DupeString('&nbsp;',pc)+copy(Result,p+1,length(Result));
      end;
    '<': Result:=copy(Result,1,p-1)+'&lt;'+copy(Result,p+1,length(Result));
    '>': Result:=copy(Result,1,p-1)+'&gt;'+copy(Result,p+1,length(Result));
    '&': Result:=copy(Result,1,p-1)+'&amp;'+copy(Result,p+1,length(Result));
    #10,#13:
      begin
        po:=p;
        if (p>1) and (Result[p-1] in [#10,#13]) and (Result[p-1]<>Result[p]) then
          dec(p);
        Result:=copy(Result,1,p-1)+'<br>'+copy(Result,po+1,length(Result));
      end;
    end;
    dec(p);
  end;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  IpHtmlPanel1.SetHtmlFromStr('<span style="font-family:Courier">'+TextToHTML(memo1.Text)+'</span>');
end;

end.

