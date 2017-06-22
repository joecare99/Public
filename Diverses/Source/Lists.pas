unit Lists;

interface

const TL_FE_Plain=0;
      TL_FE_recur=1;

type PList=^TList;
     CBList=Procedure(ZList:pList);

      TList=object
       ZNext:PList;

       constructor create;
       destructor done;virtual;
       Destructor Destroy;virtual;

       Function GetNext:PList;virtual;
       Function Add(ZItem:PList):PList;virtual;
       Function Append(ZItem:PList):PList;virtual;

       Function Delete(ZItem:Plist):Plist;Virtual;
       Procedure ForEach(ZCallBack:CBList;mode:byte);virtual;

       Function Name:String;virtual;
       private
       procedure setnext(Zitem:Plist);virtual;

     end;


implementation

Constructor Tlist.Create;

begin
  ZNext:=nil;
end;

Destructor Tlist.Done;

begin

end;

Destructor Tlist.Destroy;

begin
   if ZNext <> nil then
     dispose (Znext,Destroy);
   done;
end;

function Tlist.GetNext;

begin
  GetNext:=ZNext;
end;

Function Tlist.Add;

var ZP1,ZP2:PList;
begin
  if ZItem <> nil then
    begin
      ZP1:=ZItem;
      while Zp1^.getnext <> nil do
        zp1:=zp1^.GetNext;
      Add:=ZItem;
      zp1^.setnext(@self)
    end
  else
    add:=@self;
end;

Function Tlist.Append;

var ZP1,ZP2:PList;
begin
  if ZItem <> nil then
    begin
      ZP1:=@self;
      while Zp1^.getnext <> nil do
        zp1:=zp1^.GetNext;
      zp1^.setnext(ZItem)
    end;
  append:=@self;
end;

function Tlist.Delete;

begin
  Delete:=@self;
end;

procedure Tlist.ForEach ;

var zp1:PList;

begin
  case mode of
  TL_FE_Plain:
    begin
      zp1:=@self ;
      while zp1 <> nil do
        begin
          ZCallBack(zp1);
          zp1:=zp1^.getnext
        end;
    end;
  TL_FE_Recur:
    begin
      Zcallback(@self);
      zp1:= getnext;
      if zp1<> nil then zp1^.foreach(Zcallback,mode);
    end;
  end;
end;

procedure Tlist.setnext;

begin;
   Znext:=ZItem;
end ;

function Tlist.name;

begin
  name:='TList: BasisObjekt für Listen';
end;
end.
