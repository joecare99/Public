unit Frm_AboutTabedit;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TfrmAboutForm = class(TForm)
    Panel1: TPanel;
    OKButton: TBitBtn;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Rights: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAboutForm: TfrmAboutForm;

implementation

{$R *.DFM}

end.

