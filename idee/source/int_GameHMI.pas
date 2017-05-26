unit int_GameHMI;

interface

uses cls_Gamebase;

type
  /// <author>C. Rosewich</author>
  /// <version>0.9</version>
  /// <since>04.10.2012</since>
  TPlayerAction = Procedure of Object;
  /// <author>C. Rosewich</author>
  /// <version>0.9</version>
  /// <stereotype>Event</stereotype>
  /// <since>04.10.2012</since>
  TPlayerActionEvent = PROCEDURE(Action: TPlayerAction; Sender: TObject) OF OBJECT;

  /// <author>C. Rosewich</author>
  /// <version>0.9</version>
  /// <since>04.10.2012</since>
  iHMI=interface
    PROCEDURE SetOnPlayerAction(val: TPlayerActionEvent);
    FUNCTION GetOnPlayerAction(): TPlayerActionEvent;
    /// <associates>TPlayerAction</associates>
    /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>04.10.2012</since>
    PROPERTY OnPlayerAction: TPlayerActionEvent READ GetOnPlayerAction WRITE SetOnPlayerAction;
    /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>16.12.2014</since>
    /// <info>Initialisiert HMI </info>
    PROCEDURE InitHMI;
    /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>04.10.2012</since>
    /// <info>Zeichnet das Spielfeld (neu) </info>
    PROCEDURE UpdatePlayfield(Board: TBoardBase; Player: TPlayerBase);
    /// <author>C. Rosewich</author>
    /// <version>0.9</version>
    /// <since>04.10.2012</since>
    /// <info>Schreibt Spieler-Status </info>
    PROCEDURE UpdateStatus(Player:TPlayerBase);
  END;


IMPLEMENTATION

end.
