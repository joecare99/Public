unit Unt_VariantProcs;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{*v 1.52.00}
{*h 1.51.00 Modelsupport}
///<version>1.52.00</version>
///<history>1.51.00 Hinzufuegen von Modelling-Tags</history>

interface

uses sysutils, Unt_Allgfunklib;
///<author>Joe Care</author>
///  <property>Diese Funktion wandelt einen Variant in einen String um</property>
///  <version>1.51.00</version>
function Var2string(const Data:variant;markarray:boolean=false):String;overload;
function Var2string(const Data:variant;aFS:TFormatSettings;markarray:boolean=false):String;overload;

///<property>Diese Funktion berechnet die reale Größe des Variants</property>
///  <version>1.51.00</version>
///  <author>Joe Care</author>
function GetRealSize(const Data:Variant):integer;

///<author>Joe Care</author>
///  <version>1.51.00</version>
///  <property>Diese Funktion wandelt ein Variant in ein Array of Byte um</property>
function Var2AOB(const Data:variant;{%H-}align:TDataAlign = DAL_intel):Taob;

///<author>Joe Care</author>
///  <version>1.51.00</version>
///  <property>Diese Funktion wandelt ein Variant in Großbuchstaben um</property>
function UpCase(s:variant):variant;overload;

implementation

uses variants,Unt_StringProcs;

function Var2string(const Data:variant;aFS: TFormatSettings;markarray:boolean=false):String;

var hst : string;
    lDT : TDateTime;
    i:integer;

begin
  hst := '';
  case Vartype(Data) of
      varEmpty:hst:='Empty';
      varNull:hst:='NULL';

      varCurrency ,
      varDispatch ,
      varError    ,
      varVariant  ,
      varUnknown  ,

      varSmallint ,
      varInteger  ,
      varByte     :hst:=VarAsType(Data,varstring);

      varDate     :begin lDt := Data;hst:=DateTimeToStr(lDT,afs);end;

      varSingle   ,
      varDouble   : hst:=FloatToStr(extended(Data),aFS);

      varBoolean  :if data then hst:='TRUE' else hst:='FALSE';
      varOleStr   ,
      varString   :if markarray then hst:='"'+Data+'"'
                   else hst:=Data;
      varArray..varArray+vartypeMask:
          begin
            if markarray then HST:='(';
            for i := VarArrayLowBound(data,1)to VarArrayHighBound(data,1) do
              begin
                hst:=hst+Var2string (data[i],aFS,true);
                if markarray and (i < VarArrayHighBound(Data,1)) then
                  hst:=hst+','
                else
                  if (i < VarArrayHighBound(data,1)) then
                    hst:=hst + vbnewline;
              end;
            if markarray then hst:=hst +')';
          end;
    end;
  Result := hst;
end;

function Var2string(const Data: variant;
  markarray: boolean): String;inline;
begin
  Result := Var2string(Data,DefaultFormatSettings,markarray);
end;

function GetRealSize(const Data:Variant):integer;

var hint,i:integer;
    bitcount:byte;

begin
  hint:=0;
  bitcount :=0;
  case Vartype(Data) of
      varEmpty:hint:=0;
      varNull:Hint:=0;
      varSmallint :Hint:=sizeOf(smallint);
      varInteger  :Hint:=sizeOf(integer);
      varSingle   :Hint:=sizeOf(Single);
      varDouble   :Hint:=sizeOf(Double);
      varCurrency :Hint:=sizeOf(Currency);
      varDate     :Hint:=sizeOf(TDateTime);
      varOleStr   :Hint:=length(data);
      varDispatch :Hint:=sizeof(data);
      varError    ,
      varBoolean  :hint:=sizeof(boolean);
      varVariant  :Hint:=sizeof(data);
      varUnknown  :Hint:=sizeof(data);
      varByte     :Hint:=sizeof(byte);
      varString   :Hint:=length(data);
      varArray..varArray+vartypeMask:
          begin
            for i := VarArrayLowBound(data,1)to VarArrayHighBound(data,1) do
              begin
                if vartype(data[i]) = varboolean then
                  if bitcount >0 then
                   dec(bitcount)
                  else
                    begin
                      hint:=hint+getrealsize(data[i]);
                      bitcount:=7;
                   end
                else
                  begin
                    hint:=hint+getrealsize(data[i]);
                    bitcount:=0;
                  end;
              end;
          end;
    end;
  getrealsize:=hint;

end;

function var2AOB(const Data:variant;Align:TDataAlign):Taob;

type ctype = record
               case byte of
               0:(aob:packed array[0..19] of byte);
               1:(smint:smallint);
               2:(integ:integer);
               3:(sngle:Single);
               4:(dble:double);
               5:(curncy:Currency);
               6:(TiDa:TDateTime);
               7:(bool:TDateTime);
               end;




var retdata,
    tmpData :TAoB;
    rdSize,Addrs,i,bitcount:integer;
    tmpvar:ctype;
    tmpStr:String;

begin
  RDSize:= GetRealSize(data);
  setlength(retdata,rdsize);
  bitcount :=8;
  case Vartype(Data) of
      varEmpty:setlength(retdata,0);
      varNull:setlength(retdata,0);
      varSmallint :
          begin
            tmpvar.smint := data;
            move (tmpvar.aob[0],retdata[0],sizeof(smallint));
          end;
      varInteger  :
          begin
            tmpvar.integ  := data;
            move (tmpvar.aob[0],retdata[0],sizeof(integer));
          end;
      varSingle   :
          begin
            tmpvar.sngle  := data;
            move (tmpvar.aob[0],retdata[0],sizeOf(Single));
          end;
      varDouble   :
          begin
            tmpvar.Dble  := data;
            move (tmpvar.aob[0],retdata[0],sizeOf(Double));
          end;

      varCurrency :
          begin
            tmpvar.curncy   := data;
            move (tmpvar.aob[0],retdata[0],sizeOf(Currency));
          end;
      varDate     :
          begin
            tmpvar.TiDa  := data;
            move (tmpvar.aob[0],retdata[0],sizeOf(TDateTime));
          end;
      varDispatch :
          begin
            move (data,retdata[0],sizeOf(data));
          end;
      varError    :
          begin
            move (data,retdata[0],sizeOf(data));
          end;
      varBoolean  :
          begin
            tmpvar.bool  := data;
            move (tmpvar.aob[0],retdata[0],sizeOf(boolean));
          end;
      varVariant  :
          begin
            move (data,retdata[0],sizeOf(data));
          end;
      varUnknown  :
          begin
            move (data,retdata[0],sizeOf(data));
          end;
      varByte     :
          begin
            tmpvar.bool  := data;
            move (tmpvar.aob[0],retdata[0],sizeOf(byte));
          end;
      varOleStr   ,
      varString   :
          begin
             tmpstr:= data;
             move(tmpstr[1],retdata[0],length(data));
          end;
      varArray..varArray+vartypeMask:
          begin
            addrs:=0;
            for i := VarArrayLowBound(data,1)to VarArrayHighBound(data,1) do
              begin
                if vartype(data[i]) = varboolean then
                  if bitcount <8 then
                    begin
                      if data[i] then
                        retdata[addrs]:=1 shl bitcount;
                      inc(bitcount);
                    end
                  else
                    begin
                      inc(addrs,sizeof(boolean));
                      bitcount:=0;
                      if data[i] then
                        retdata[addrs]:=1
                      else
                        retdata[addrs]:=0;
                      inc(Bitcount);
                   end
                else
                  begin
                    tmpData:=var2aob(data[i]);
                    move(tmpData[0],retData[addrs],high(tmpdata)+1);
                    inc(addrs,high(tmpdata)+1);
                    bitcount:=8;
                  end;
              end;
          end;
    end;
  var2AOB := retdata;


end;

function UpCase(s:variant):variant;

var i:integer;
    st:string;

begin
  st:=varastype(s,varstring);
  for i := 1 to length (st) do
    st[i]:=system.UpCase (st[i]);
  UpCase:= st;

end;
//-------------------------------------------------------------


end.
