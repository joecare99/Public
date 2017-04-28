Unit Unt_ExecCommand;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{*v 1.00.01}

Interface

Uses classes, Unt_VariantProcs;

Type
  ///<author>Rosewich</author>
  ///  <version>1.00.00</version>
  ///  <stereotype>Event</stereotype>
  TOnReceive = Procedure(Sender: TObject; Msg: String) Of Object;
  ///<author>Rosewich</author>
  ///  <version>1.00.00</version>
  ///  <stereotype>Event</stereotype>
  TTokenProc0 = Procedure(Sender: TObject; Msg: String; OnReply: tobject) Of
    Object;
  ///<author>Rosewich</author>
  ///  <version>1.00.00</version>
  ///  <stereotype>Event</stereotype>
  TTokenProc = Procedure(Sender: TObject; Msg: String; OnReply: TTokenProc0 =
    Nil) Of Object;

  ///<author>Rosewich</author>
  ///  <version>1.00.00</version>
  IExecCommand = Interface
    ['{7BD3F271-DD48-11D3-BC33-005004624F5B}']
    ///<author>Rosewich</author>
    ///  <version>1.00.00</version>
    Function ExecCommand(sender: TComponent; Cmd: String; Prc_Repl: TTokenProc =
      Nil): boolean;
  End;

  ///<author>Rosewich</author>
  ///  <version>1.00.00</version>
  TToken = Record
    ProcName: String;
    PrcPtr: TTokenProc;
  End;

  ///<author>Rosewich</author>
  ///  <version>1.00.00</version>
Procedure DoReply(Sender: TObject; PrcRepl: TTokenProc; Const Answer: Variant;
  {%H-}markarray: boolean = false); Overload;

Implementation

Procedure DoReply(Sender: TObject; PrcRepl: TTokenProc; Const Answer: Variant;
  markarray: boolean); overload;

Begin
  If assigned(prcRepl) Then
    prcRepl(sender, Var2string(answer));
End;

End.

