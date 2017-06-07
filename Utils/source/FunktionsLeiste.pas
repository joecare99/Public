unit FunktionsLeiste;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,ActnList;

type
  TFunktionsLeiste = class(TPanel)
  private
    { Private-Deklarationen }
    // Untergeordnete Komponenten
    btn_FktTast:array of TButton;
    lbl_FktTast:array of TLabel;
    Acn_Fkttast:array of TAction;

    // Ereignisse
    OnTastPressed:TFunkt

  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner:TComponent);override;
  published
    { Published-Deklarationen }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Projekt', [TFunktionsLeiste]);
end;

end.
