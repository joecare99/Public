unit unt_Lists;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

const TL_FE_Plain=0;
      TL_FE_recur=1;

type TList=class;
     CBCList=Procedure(List:TList;var continue:boolean);

      { TList }

      TList=class
       ZNext:TList;

       constructor create;

       Destructor Destroy;override;

       Procedure Clear;Virtual;
       Function GetNext:TList;virtual;
       Function Add(Item:TList):TList;virtual;
       Function Append(Item:TList):TList;virtual;

       Function Delete(Item:Tlist):Tlist;Virtual;

       Procedure ForEach(ZCallBack:CBCList;mode:byte);virtual;

       Function Name:String;virtual;
       private
       procedure setnext(Item:Tlist);virtual;

     end;


implementation

constructor TList.create;

begin
  ZNext:=nil;
end;

procedure TList.Clear;
begin
  if assigned(ZNext) then
    begin
      Znext.clear;
      zNext:=nil;
    end;
  free;
end;

Destructor Tlist.Destroy;

begin
   inherited
end;

function TList.GetNext: TList;

begin
  GetNext:=ZNext;
end;

function TList.Add(Item: TList): TList;

var ZP1:TList;
begin
  if Item <> nil then
    begin
      ZP1:=Item;
      while Zp1.getnext <> nil do
        zp1:=zp1.GetNext;
      result:=Item;
      zp1.setnext(self)
    end
  else
    result:=self;
end;

function TList.Append(Item: TList): TList;

var ZP1:TList;
begin
  if Item <> nil then
    begin
      ZP1:=self;
      while Zp1.getnext <> nil do
        zp1:=zp1.GetNext;
      zp1.setnext(Item)
    end;
  result:=self;
end;

function TList.Delete(Item: Tlist): Tlist;

begin
  Delete:=self;
  RunError(123);
end;

procedure TList.ForEach(ZCallBack: CBCList; mode: byte);

var zp1:TList;
    c:boolean;

begin
  case mode of
  TL_FE_Plain:
    begin
      zp1:=self ;
      c:=true;
      while (zp1 <> nil) and c do
        begin
          ZCallBack(zp1,c);
          zp1:=zp1.getnext
        end;
    end;
  TL_FE_Recur:
    begin
      Zcallback(self,c);
      if c then begin
        zp1:= getnext;
        if zp1<> nil then zp1.foreach(Zcallback,mode);
      end
    end;
  end;
end;

procedure TList.setnext(Item: Tlist);

begin;
   Znext:=Item;
end ;

function TList.Name: String;

begin
  name:='TList: BasisObjekt für Listen';
end;
end.
