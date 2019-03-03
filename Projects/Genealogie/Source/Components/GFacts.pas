unit GFacts;

interface

uses GBaseClasses,
  GSource;

type
  TBaseFact = class abstract

  public
  var
    FactDate: TGDate;
    Description: String;
    FactText: String;
    Sources: array Of TBaseSource;
  end;

implementation

end.
