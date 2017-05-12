unit Yesno;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls;

type
  TYesNoDlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    PromptLabel: TLabel;
//  private
    { Private declarations }
//  public
    { Public declarations }
  end;

var
  YesNoDlg: TYesNoDlg;

implementation

{$R *.DFM}

end.
