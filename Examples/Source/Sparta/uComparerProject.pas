// Generic types for FreeSparta.com and FreePascal!
// by Maciej Izak (hnb), 2014
unit uComparerProject;

{$MODE DELPHI}{$H+}

interface

procedure Main;

implementation

uses
  SysUtils, Generics.Collections, Generics.Defaults;

type

  { TCustomer }

  TCustomer = record
  private
    FName: string;
    FMoney: currency;
  public
    constructor Create(const Name: string; Money: currency);
    property Name: string read FName write FName;
    property Money: currency read FMoney write FMoney;
    function ToString: string;
  end;

  TCustomerComparer = class(TComparer<TCustomer>)
    function Compare(constref Left, Right: TCustomer): integer; override;
  end;

{ TCustomer }

constructor TCustomer.Create(const Name: string; Money: currency);
begin
  FName := Name;
  FMoney := Money;
end;

function TCustomer.ToString: string;
begin
  Result := Format('Name: %s >>> Money: %m', [Name, Money]);
end;

// Ascending
function TCustomerComparer.Compare(constref Left, Right: TCustomer): integer;
begin
  Result := TCompare.&string(Left.Name, Right.Name);
  if Result = 0 then
    Result := TCompare.currency(Left.Money, Right.Money);
end;

// Descending
function CustomerCompare(constref Left, Right: TCustomer): integer;
begin
  Result := TCompare.&string(Right.Name, Left.Name);
  if Result = 0 then
    Result := TCompare.currency(Right.Money, Left.Money);
end;

procedure Main;

var
  CustomersArray: TArray<TCustomer>;
  CustomersList: TList<TCustomer>;
  Comparer: TCustomerComparer;
  Customer: TCustomer;
begin
  CustomersArray := TArray<TCustomer>.Create(
    TCustomer.Create('Derp', 2000), TCustomer.Create('Sheikh', 2000000000),
    TCustomer.Create('Derp', 1000), TCustomer.Create('Bill Gates', 1000000000));

  Comparer := TCustomerComparer.Create;
  Comparer._AddRef;

  // create TList with custom comparer
  CustomersList := TList<TCustomer>.Create(Comparer);
  CustomersList.AddRange(CustomersArray);

  WriteLn('CustomersList before sort:');
  for Customer in CustomersList do
    WriteLn(Customer.ToString);
  WriteLn;

  // default sort
  CustomersList.Sort; // will use TCustomerComparer (passed in the constructor)
  WriteLn('CustomersList after ascending sort (default with interface from constructor):');
  for Customer in CustomersList do
    WriteLn(Customer.ToString);
  WriteLn;

  // construct with simple function
  CustomersList.Sort(TComparer<TCustomer>.Construct(CustomerCompare));
  WriteLn('CustomersList after descending sort (by using construct with function)');
  WriteLn('CustomersList.Sort(TComparer<TCustomer>.Construct(CustomerCompare)):');
  for Customer in CustomersList do
    WriteLn(Customer.ToString);
  WriteLn;

  // construct with method
  CustomersList.Sort(TComparer<TCustomer>.Construct(Comparer.Compare));
  WriteLn('CustomersList after ascending sort (by using construct with method)');
  WriteLn('CustomersList.Sort(TComparer<TCustomer>.Construct(Comparer.Compare)):');
  for Customer in CustomersList do
    WriteLn(Customer.ToString);
  WriteLn;

  WriteLn('CustomersArray before sort:');
  for Customer in CustomersArray do
    WriteLn(Customer.ToString);
  WriteLn;

  // sort with interface
  TArrayHelper<TCustomer>.Sort(CustomersArray, TCustomerComparer.Create);
  WriteLn('CustomersArray after ascending sort (by using interfese - no construct)');
  WriteLn('TArrayHelper<TCustomer>.Sort(CustomersArray, TCustomerComparer.Create):');
  for Customer in CustomersArray do
    WriteLn(Customer.ToString);
  WriteLn;

  CustomersList.Free;
  Comparer._Release;
  ReadLn;
end;

end.

