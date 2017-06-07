Unit LogUnit;

Interface

Type TLogKategorie =
  (LgNA, LgBeginOfProc, LgEndOfProc, LgIO, LgError, LgUser);
  TLogEvent = Procedure(Sender: TOBject; LArt: TLogKategorie; Bemerkung: String) Of Object;

Const LgKat: Array[TLogKategorie] Of String =
  ('Unbekannt', 'Procedurestart', 'Procedureende', 'IO', 'Error', 'Benutzer');

Implementation

End.
