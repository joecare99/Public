unit frm_TestDBEncoding;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

    { TFrmTstDBEncodingMain }

    TFrmTstDBEncodingMain = class(TForm)
        memo1 :TMemo;
        procedure FormShow(Sender :TObject);
    private

    public

    end;

var
    FrmTstDBEncodingMain :TFrmTstDBEncodingMain;

implementation

{$R *.lfm}

uses lazutf8;

{ TFrmTstDBEncodingMain }

procedure TFrmTstDBEncodingMain.FormShow(Sender :TObject);
var
    s :string;
begin
    s := 'Maaß';
    memo1.Append(s);// gives correct word

    SetCodePage(RawByteString(s), 1252, False);
    memo1.Append(s);// gives the wrong word

    s := 'WÃ¤lde'; // -> Wälde
    memo1.Append(s + ' --> ' + Utf8ToWinCP(s));
    s := 'GÃ¼nther'; // -> Günther
    memo1.Append(s + ' --> ' + Utf8ToWinCP(s));
    s := 'MaaÃŸ'; // -> Maaß
    memo1.Append(s + ' --> ' + Utf8ToWinCP(s));
end;



end.
