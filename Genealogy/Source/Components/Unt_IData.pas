unit Unt_IData;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses classes, variants;

type

 { IDataRO }

 IDataRO=interface
    ['{735E17C0-B53F-4999-B668-B11B77EE34BB}']
    /// <INFO>GetData liefert einen (den aktellen) kompletten Datensatz.</INFO>
    function getdata:variant;
    procedure First(Sender:Tobject=nil);
    Procedure Last(Sender:Tobject=nil);
    Procedure Next(Sender:Tobject=nil);
    Procedure Previous(Sender:Tobject=nil);
    Procedure Seek(aID:Integer);
    Function EOF:boolean;
    function BOF:boolean;
    Function GetActID:integer;
    function GetOnUpdate: TNotifyEvent;
    procedure SetOnUpdate(AValue: TNotifyEvent);
    property Data:variant read getdata;
    property OnUpdate:TNotifyEvent read GetOnUpdate write SetOnUpdate;
 end;

 IData=interface(IDataRO)
    ['{7E8B9348-4B2E-4A6F-B540-F0E9F3717EFC}']
    /// <INFO>SetData verändert Daten / einzeln, mehrere oder alle</INFO>
    procedure SetData(NewVal:Variant);
    /// <INFO>Fügt einen neuen, leeren Datensatz an.</INFO>
    Procedure Append(Sender:Tobject=nil);
    Procedure Edit(Sender:Tobject=nil);
    Procedure Post(Sender:Tobject=nil);
    Procedure Cancel(Sender:Tobject=nil);
    Procedure Delete(Sender:Tobject=nil);
    property Data:variant read getdata write SetData;
end;

implementation

end.
