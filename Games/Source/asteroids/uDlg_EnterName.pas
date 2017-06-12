Unit uDlg_EnterName;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

Interface
Uses {$IFDEF FPC} LCLIntf, LCLType, {$ENDIF} SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls,
StdCtrls;

Type tDlg_EnterName = Class(tForm)
    PanelName: tPanel;
    PanelOk: tPanel;
    PanelCancel: tPanel;
    EditName: tEdit;
    BtnOk: tButton;
    BtnCancel: tButton;
    Procedure Form_Show(Sender: tObject);
    Procedure Click_OK(Sender: tObject);
    Procedure Click_Cancel(Sender: tObject);
  private
  public
  End;

Var Dlg_EnterName: tDlg_EnterName;

Implementation
Uses uHighscores;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

Procedure tDlg_EnterName.Form_Show(Sender: tObject);
Begin
  With EditName Do
    Begin
      SetFocus;
      SelStart := 0;
      SelLength := Length(Text);
    End;
End;

Procedure tDlg_EnterName.Click_OK(Sender: tObject);
Begin
  Close;
  Highscores.AddName;
  Highscores.Show;
End;

Procedure tDlg_EnterName.Click_Cancel(Sender: tObject);
Begin
  Close;
End;

End.
