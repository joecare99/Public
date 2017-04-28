{  $IFDEF DPMI}
    {  $A+,B-,E+,F-,G+,I+,N+,P-,T-,V-,X+}
    {  $M 65520,0}
{  $ELSE}
    {  $A+,B-,E+,F-,G+,I+,N+,O+,P-,T-,V-,X+}
    {  $M 8192,8192,614400}
{  $ENDIF}

program DialEdit;  {&Use32+}

{$apptype Console}
{$mode objfpc}{$H+}
{*******************************************************}
{                                                       }
{   Released under GNU General Public License 3 as      } 
{   given at https://www.gnu.org/copyleft/gpl.html      }
{                    April 29, 2014                     }
{                                                       }
{*******************************************************}
//      {$IFDEF FPC}
uses  sysutils,

  Objects, Drivers, Memory, Views, Menus, Dialogs,
  StdDlg, MsgBox, App, Validate, Gadgets, HistList,

  TVinput, Params, obj_TrialLabel, DialEditBase, DialEditBFctn,
  obj_TrialStaticText, Obj_EditControlDlg, dialeditDefaults, str_statictextdata,
  str_InputLineData, Str_DialogData, str_ParamTextData, str_ButtonData,
  str_ListBoxData, str_OutOptData, obj_TrialParamText, obj_trialbutton,
  obj_TrialInputLine, obj_DialEditApp, obj_TrialCluster ;

const
    CopyNote = 'DialEdit 8-14-95 (C) J.M.Clark';

{*******************************************************}
{                                                       }
{               DialEdit - a dialog editor              }
{                                                       }
{   This provides for visual editing of TurboVision     }
{   dialog boxes (TDialog objects) with the follow-     }
{   ing component objects:                              }
{                                                       }
{       TStaticText                                     }
{       TParamText                                      }
{       TButton                                         }
{       TInputLine        \                             }
{       TRadioButtons     |                             }
{       TCheckBoxes       |- These may have a TLabel.   }
{       TMultiCheckBoxes  |                             }
{       TListBox          /                             }
{                                                       }
{   TInputLine may have one of these validators:        }
{            FilterValidator                            }
{            RangeValidator (value is longint)          }
{            StringLookupValidator                      }
{            PXPictureValidator                         }
{   and may have a History icon.                        }
{                                                       }
{   TListBox also has a vertical TScrollBar.            }
{                                                       }
{   'Trial' versions of these can be moved/sized by     }
{   dragging with left/right mouse buttons.  A double   }
{   click re-activates the initialing dialog to edit    }
{   features.  Dialogs can be saved to a file and       }
{   fetched later, and Pascal code and/or picture of    }
{   the dialog can be generated and written to a disk   }
{   file or to standard output.                         }
{                                                       }
{   For full documentation, see file DialEdit.doc.      }
{                                                       }
{*******************************************************}

(****************************************************=--

----------------------- TO DO --------------------------

provide FocusFirst option in create/edit dialogs for all controls.
    this would put a control^.Select call at the end of the dialog
    init code to make that control focused first.

COMPLETE conversion to dual string collections for Cluster objects.


read/write history should use Done to close BufStream ?

add generic validator to TrialInputLine
    in form of
        <xxx>InputLine  - need name of defining unit
        <xxx>Validator  - need name of defining unit, and -
    generate code as in TvInput unit -
        with IL^ do begin
            SetValidator(New(P<name>Validator, Init(<arg list>)));
            Validator^.Options:= <voXXX bit>;   {optional}
            Options:= Options or ofValidate;
        end;

provide a FileDialog for Select Files dialog

generate optional 'blank' HandleEvent method code

generate const definitions for -    - done, need to doc.
    History ID names
    CheckBox bit positions
    MultiCheckBox mask values
    RadioButton values

provide variants -
    MRadioButtons (from TvInput)
    BigCheckBoxes (add to TvInput; for Count >16, <=32)

Use of ValidView -
    is it included in ExecDialog?
    is it used consistently?
    is OutOfMemory involved? needed?

Discard Patterned option?  (Pattern indicates editable)

Put pictures in Picture file?  Allow PictFile = CodeFile?

Provide for translating trial objects to real dialogs; -- done
    ( but
        collections for ListBoxes,
        validators for InputLines, &
        commands for Buttons
      are not supported in 'real' dialogs.
    )
use real dialogs to -
    store dialogs in (real) ResourceFile
    execute -
        for test                        -- done
        to define default data          -- done

Provide backup for output file (except '').
Provide backup for collection file.

InputLine length parameter (dialog input) -
    default: if input is number,
        length is input and type is string[input].
    option: if input is type,
        length is SizeOf(input)-1 and type is input.

Provide 25-line mode (or version), compact-format dialogs.

Re-structuring -
    Use revised OOP form of Params unit (ParamsO).
    Look for repeated code that can be merged.

----------------------- NOTES --------------------------

Cluster value size
    Documentation and debugger say SizeOf(Value) is 4.
    Documentation says DataSize returns SizeOf(Value) --
    BUT source code and experimentation say SizeOf(word) !
    (However, Value is actually a longint.)
    CheckBoxes and RadioButtons do not override DataSize.
    MultiCheckBoxes.DataSize = 4 (longint).

ParamText.SetData
    The documenation says that ParamText.SetData "reads DataSize
    bytes into ParamList from Rec".  Actually, it does "ParamList:=
    @Rec", so no memory is allocated for ParamList.  There is no
    GetData method.  ParamList points to a FormatStr parameter list,
    making the list data available to ParamText.Draw indirectly.
    DataSize is the size of the list (4 bytes per item).

ListBox
    An item can be selected by double-clicking it with the mouse,
    or moving the highlight with the cursor keys and pressing space.
    When an item is selected, the ListBox executes:
        Message(Owner, evBroadcast, cmListItemSelected, @Self);
    But to use this, the Dialog needs code added to its EventHandler
    such as in FetchDialogDialog.

Collections - names for item methods -

    obvious name    Turbo Vision name
    ------------    -----------------
    FreeItem        Free
    DeleteItem      Delete
    DisposeItem     FreeItem
    LoadItem        GetItem
    StoreItem       PutItem

EMSStream cannot support ResourceFile
(as hoped for in CloseCollFile).

TDialog.HandleEvent -
    Borland documentation says that TDialog.HandleEvent
        "handles most events by calling the HandleEvent method
        inherited from TWindow .."
        and that TWindow.HandleEvent
        "handles events specific to windows"
        including command
        "cmResize (move or resize the window using DragView)".
    However, the debugger *seems* to reveal that TWindow does
        the move and resize functions without calling DragView.
        Not really -- DragView is not virtual!!  (and can't be)
        But SetState *is* virtual; use SetState(sfDragging, )
        to clear DialSaved.

--=****************************************************)

{*******************************************************}

{ Outline of global functions and procedures }
{ These are implemented below in the same sequence }

{
        RegisterTrialObjects
    shared by trial objects -
        DragIt
        DragBoth
        NewLabel
        CodeBounds
        InitBounds
        CopyStrings
        InitStrings
        EscQuot
        GenImplementation
    stream & file routines -
        OpenCollFile
        CloseCollFile
        OpenCodeFile
        CloseCodeFile
        RemDialog
        SaveDialog
        DeleteDialog
        GetDialog
        FetchDialog
        TestDialog
        ReadHistory
        WriteHistory
        ScreenCapture       * (optional)
}

{*******************************************************}

{$R *.res}

begin
    DialEditApp.Init;
    DialEditApp.Run;
    DialEditApp.Done;
end.
