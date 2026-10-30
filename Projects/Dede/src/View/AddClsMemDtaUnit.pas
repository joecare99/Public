unit AddClsMemDtaUnit;

interface

uses
  Classes, Controls, Forms, StdCtrls, Buttons;

type
  TAddClsMemDtaForm = class(TForm)
  published
    OffsEdit: TEdit;
    DispEdit: TEdit;
    TypeEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label4: TLabel;
    ClassEdit: TEdit;
  end;

var
  AddClsMemDtaForm: TAddClsMemDtaForm;

implementation

{$R *.dfm}

end.
