Unit Unt_LogUnit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{*V 1.01.03}
{*H 1.01.02 Umwandlung in eine Componente}
{*H 1.01.01 Autoseparation & SetAutoXXX-Proceduren}

Interface

Uses Classes;

Type
  ///<author>Joe Care</author>
  ///  <version>1.1.2</version>
  TLogKategorie =
    (
    LgNA = -1,
    LgBeginOfProc = 0,
    LgEndOfProc = 1,
    LgIO = 2,
    LgError = 3,
    LgClrError = 4,
    lgMessage = 5,
    lgStatus = 6,
    LgUser = 7,
    LgUser1 = 8,
    LgUser2 = 9);
  ///<author>Joe Care</author>
  ///  <version>1.1.2</version>
  ///  <stereotype>Event</stereotype>
  ///  <property>Dies ist eine Property</property>
  TLogEvent = Procedure(Sender: TOBject; LArt: TLogKategorie; Bemerkung: String)
    Of Object;

Resourcestring
  LGK_NA = 'Unbekannt';
  Lgk_BeginProc = 'Procedurestart';
  Lgk_EndProc = 'Procedureende';
  Lgk_IO = 'I/O';
  Lgk_Error = 'Fehler';
  Lgk_ClrError = 'Fehler-Behoben';
  Lgk_Message = 'Meldung';
  Lgk_Status = 'Status-Änderung';
  Lgk_User = 'Benutzer';
  LogHeader = 'Logfile vom %s, erstellt von %s';

Const
  ///<Author>Joe Care<\Author>
  ///  <property>Dies ist eine Property</property>
  LgKat: Array[TLogKategorie] Of String =
  (LGK_NA, LGK_BeginProc, Lgk_EndProc, Lgk_IO, Lgk_Error, Lgk_ClrError,
    Lgk_Message, Lgk_Status, Lgk_User, Lgk_User, Lgk_User);

Type
 ///<Author>Joe Care<\Author>
  TBaseLogObject = Class abstract(TComponent)
  protected
    PFileName: String;
    PAutoDate: Boolean;
    PAutoSeparationSender: Boolean;
    PAutoSeparationKategorie: Boolean;
    Property AutoDate: Boolean read PAutodate;
    Property AutoSeparationSender: Boolean read PAutoSeparationSender;
    Property AutoSeparationKategorie: Boolean read PAutoSeparationKategorie;
    Procedure FWriteLog(logLine: String); virtual; abstract;
  published
    Property DefaultLogFile: String read PFilename write PFilename;
    Property LogLine: String write FWriteLog;

  public
    Procedure AppendLog(Sender: TOBject; LArt: TLogKategorie; Bemerkung:
      String);
      virtual; abstract;

  End;

  ///<Author>Joe Care<\Author>
  ///  <version>1.1.2</version>
  TPrivateLogObject = Class(TObject)

  End;

  ///<Author>Joe Care<\Author>
  ///  <version>1.1.2</version>
  TLoggingObject = Class(TBaseLogObject)
  private
    FonLog: TLogEvent;
    Procedure AppendLogfile(sender: TObject; lart: TLogKategorie; Line: String);
    Procedure SetAutoDate(Newval:Boolean);
    Procedure SetAutoSeparationSender(Newval:Boolean);
    Procedure SetAutoSeparationKategorie(Newval:Boolean);
  published
    property AutoDate read Pautodate write SetAutoDate;
    property AutoSeparationSender read PAutoSeparationSender write SetAutoSeparationSender ;
    property AutoSeparationKategorie read PAutoSeparationKategorie  write SetAutoSeparationKategorie ;
  public
    Procedure AppendLog(Sender: TOBject; LArt: TLogKategorie; Entry: String);
      override;
  End;

///<Author>Joe Care<\Author>
///  <version>1.1.2</version>
///  <property>Bestimmt den Objektpfad von RObject</property>
Function getObjectPath(RObject: TObject): String;

Implementation

Uses sysutils;

Function getObjectPath(RObject: TObject): String;
Var
  Component: Tcomponent;

Begin
  If assigned(RObject) Then
    Begin
      If RObject.InheritsFrom(TComponent) Then
        Begin
          Component := RObject As TComponent;
          If Component.GetParentComponent <> Nil Then
            result := Component.GetNamePath
          Else
            result := getObjectPath(Component.Owner) + '\' + (RObject As
              TComponent).name
        End
      Else
        Begin
          If RObject.InheritsFrom(TPersistent) Then
            Begin
              Component := Tcomponent(RObject);
              result := getObjectPath(Component.Owner) + '\' +
                RObject.ClassName;
            End
          Else
            Begin
              result := RObject.ClassName;
            End;

        End;
    End
  Else
    result := 'root';
End;

//--------------------------------------------------------------
//                   Methoden für TLoggingObject
//--------------------------------------------------------------

Procedure TLoggingObject.AppendLog;

Begin
  If assigned(FonLog) Then
    Fonlog(sender, lart, Entry);
  appendlogfile(sender, lart, Entry);
End;

Var
  FFilename: String = '';
  AutoDate: boolean = true;
  Autoseparation: boolean = False;

Procedure TLoggingObject.AppendLogFile;

Var
  t: TextFile;
  Filename_Act: String;
Begin
  Filename_act := FFilename;
  If PAutoDate Then
    Filename_act := Filename_act + '_' + formatDateTime('yyyymmdd', now);
  If PAutoSeparationKategorie  Then
    Filename_act := Filename_act + '_' + lgkat[lart];
  If PAutoSeparationSender  Then
    Filename_act := Filename_act + '_' + StringReplace(getObjectPath(sender),'\','_',[rfReplaceAll]);
  If ExtractFileExt(Filename_act) = '' Then
    Filename_act := Filename_act + '.log';
  assignfile(t, Filename_act);
  If FileExists(Filename_act) { *Converted from FileExists*  } Then
    Append(t)
  Else
    Begin
      // Header
      rewrite(t);
      writeln(t, format(LogHeader, [formatDateTime('d. mmmm yyyy', now),
        paramstr(0)]));
    End;
  writeln(t, datetimetostr(now) + #9 + inttostr(ord(lart)) + #9 +
    getObjectPath(sender) + #9 + Line);
  CloseFile(t);
End;

Procedure TLoggingObject.SetAutoDate(Newval: Boolean);

Begin
  PAutoDate := newval;
End;

Procedure TLoggingObject.SetAutoSeparationSender(Newval: Boolean);

Begin
  PAutoSeparationSender := newval;
End;

Procedure TLoggingObject.SetAutoSeparationKategorie(Newval: Boolean);

Begin
  PAutoSeparationKategorie := newval;
End;

Initialization
Finalization

End.
