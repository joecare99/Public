unit unt_IGenBase2;

{$mode delphi}

interface

uses
  Classes, SysUtils;

type

{ IGenFact }

 IGenFact=interface  // Interface zu einem Genealogischen Faktum
        function GetData: string;
        function GetFType: integer;
        function GetSelf: Tobject;
        function GetSource: IGenFact;
        procedure SetData(AValue: string);
        procedure SetFType(AValue: integer);
        procedure SetSource(AValue: IGenFact);
        Property Data:string read GetData write SetData;
        Property FType:integer read GetFType write SetFType;
        Property Source: IGenFact read GetSource write SetSource;
        property Self:Tobject read GetSelf;
     end;

     { IGenEvent }

     IGenEvent=interface(IGenFact)  // Interface zu einem Genealogischen Event
     function GetPlace: IGenFact;overload;
     function GetDate: string;
     function GetPlace: string;overload;
     procedure SetDate(AValue: string);
     procedure SetPlace(AValue: IGenFact);overload;
     procedure SetPlace(AValue: string);overload;
            property Date: string read GetDate write SetDate;
            property Place: string read GetPlace write SetPlace;overload;
            property Place:IGenFact  read GetPlace write SetPlace;overload;
    end;

implementation

end.

