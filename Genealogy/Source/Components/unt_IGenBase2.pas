unit unt_IGenBase2;

{
  ============================================================================
  Unit: unt_IGenBase2
  ============================================================================
  Beschreibung:
    Diese Unit definiert die grundlegenden Schnittstellen (Interfaces) für
    ein genealogisches Datenverwaltungssystem. Sie stellt CORBA-Interfaces
    zur Verfügung, die eine abstrakte, implementierungsunabhängige Sicht auf
    genealogische Daten ermöglichen.

  Hauptkomponenten:
    - Ereignis-Typen (Events) für genealogische Fakten
    - Schnittstellen für Daten, Fakten und Ereignisse
    - Schnittstellen für Personen (Individuals) und Familien
    - Enumeratoren für die Iteration über Collections
    - Genealogie-Container-Interface

  Bemerkungen:
    - Verwendet CORBA-Interfaces (keine Referenzzählung)
    - Unterstützt Variant-Indizes für flexible Zugriffsmuster
    - Kompatibel mit Free Pascal (Delphi-Modus)

  Autor: [Ihr Name]
  Datum: [Datum]
  Version: 2.0
  ============================================================================
}

{$mode delphi}
{$Interfaces CORBA}

interface

uses
    Classes, SysUtils;

type
    {
      ============================================================================
      Enumeration: TenumEventType
      ============================================================================
      Beschreibung:
        Definiert alle unterstützten Ereignis- und Faktentypen für genealogische
        Daten. Diese Enumeration wird verwendet, um die Art von Events und Fakten
        zu klassifizieren, die mit Personen und Familien verbunden sind.

      Werte:
        evt_ID              (0)  - Identifikationsnummer
        evt_Birth           (1)  - Geburt
        evt_Baptism         (2)  - Taufe
        evt_Marriage        (3)  - Heirat
        evt_Death           (4)  - Tod
        evt_Burial          (5)  - Beerdigung
        evt_Sex             (6)  - Geschlecht
        evt_Occupation      (7)  - Beruf
        evt_Religion        (8)  - Religion
        evt_Residence       (9)  - Wohnsitz
        evt_GivenName      (10)  - Vorname
        evt_AKA            (11)  - Auch bekannt als (Alias)
        evt_AddOccupation  (12)  - Zusätzlicher Beruf
        evt_AddResidence   (13)  - Zusätzlicher Wohnsitz
        evt_AddEmigration  (14)  - Auswanderung
        evt_Confirmation   (15)  - Konfirmation/Firmung
        evt_Military       (16)  - Militärdienst
        evt_Divorce        (17)  - Scheidung
        evt_Education      (18)  - Ausbildung
        evt_Degree         (19)  - Akademischer Grad
        evt_Anull          (20)  - Annullierung
        evt_BarMitzwah     (21)  - Bar Mizwa
        evt_BasMitzwah     (22)  - Bat Mizwa
        evt_Blessing       (23)  - Segnung
        evt_Cast           (24)  - Kaste
        evt_Cencus         (25)  - Volkszählung
        evt_Member         (26)  - Mitgliedschaft
        evt_Ordination           - Ordination
        evt_Graduation           - Studienabschluss
        evt_FreeEvent            - Freies Ereignis (benutzerdefiniert)
        evt_Adoption             - Adoption
        evt_Cremation            - Kremierung
        evt_Immigration          - Einwanderung
        evt_Naturalization       - Einbürgerung
        evt_Probation            - Bewährung
        evt_Retirement           - Ruhestand
        evt_LastWill             - Testament
        evt_FreeFact             - Freies Faktum (benutzerdefiniert)
        evt_Description          - Beschreibung
        evt_Uid                  - Eindeutige ID
        evt_FamilySearchID       - FamilySearch-Identifikator
        evt_Property             - Eigentum/Besitz
        evt_Assosiation          - Vereinigung/Mitgliedschaft
        evt_Stillborn            - Totgeburt
        evt_Partner              - Lebenspartner
        evt_fallen               - Gefallen (im Krieg)
        evt_missing              - Vermisst
        evt_Age                  - Alter
        evt_Info                 - Allgemeine Information
        evt_LastChange           - Letzte Änderung
        evt_Last                 - Marker für das Ende der Enumeration

      Verwendung:
        Wird hauptsächlich in IGenEvent.EventType verwendet
      ============================================================================
    }
    TenumEventType = (
        evt_ID = 0,
        evt_Birth = 1,
        evt_Baptism = 2,
        evt_Marriage = 3,
        evt_Death = 4,
        evt_Burial = 5,
        evt_Sex = 6,
        evt_Occupation = 7,
        evt_Religion = 8,
        evt_Residence = 9,
        evt_GivenName = 10,
        evt_AKA = 11,
        evt_AddOccupation = 12,
        evt_AddResidence = 13,
        evt_AddEmigration = 14,
        evt_Confirmation = 15,
        evt_Military = 16,
        evt_Divorce = 17,
        evt_Education = 18,
        evt_Degree = 19,
        evt_Anull =20,
        evt_BarMitzwah =21,
        evt_BasMitzwah =22,
        evt_Blessing =23,
        evt_Cast=24,
        evt_Cencus=25,
        evt_Member=26,
        evt_Ordination,
        evt_Graduation,
        evt_FreeEvent,
        evt_Adoption,
        evt_Cremation,
        evt_Immigration,
        evt_Naturalization,
        evt_Probation,
        evt_Retirement,
        evt_LastWill,
        evt_FreeFact,
        evt_Description,
        evt_Uid,
        evt_FamilySearchID,
        evt_Property,
        evt_Assosiation,
        evt_Stillborn,
        evt_Partner,
        evt_fallen,
        evt_missing,
        evt_Age,
        evt_Info,

        evt_LastChange,
        evt_Last
        );

const
    {
      ============================================================================
      Konstante: CMonthNames
      ============================================================================
      Beschreibung:
        Array mit Monatsnamen-Abkürzungen und deren numerischen Darstellungen
        für die Konvertierung zwischen verschiedenen Datumsformaten.

      Struktur:
        - Array[0..23] - 12 Monate × 2 Darstellungen
        - Gerade Indizes (0,2,4...): Englische Abkürzungen (JAN, FEB, MAR...)
        - Ungerade Indizes (1,3,5...): Numerische Darstellung (01., 02., 03...)

      Verwendung:
        Ermöglicht die Umwandlung zwischen verschiedenen Datumsformaten
        in genealogischen Daten (z.B. GEDCOM-Format)

      Beispiel:
        CMonthNames[0] = 'JAN'
        CMonthNames[1] = '01.'
        CMonthNames[2] = 'FEB'
        CMonthNames[3] = '02.'
      ============================================================================
    }
    CMonthNames: array[0..23] of string =
        ('JAN', '01.',
        'FEB', '02.',
        'MAR', '03.',
        'APR', '04.',
        'MAY', '05.',
        'JUN', '06.',
        'JUL', '07.',
        'AUG', '08.',
        'SEP', '09.',
        'OCT', '10.',
        'NOV', '11.',
        'DEC', '12.');

type
    {
      ============================================================================
      Interface: IGenData
      ============================================================================
      GUID: {1197F8EE-0339-47CC-AFAB-F78B9FF280A8}

      Beschreibung:
        Basis-Interface für alle genealogischen Datenelemente. Stellt die
        grundlegenden Eigenschaften für die Speicherung von Daten und deren
        Typ bereit.

      Eigenschaften:
        Data   - Der eigentliche Datenwert als String
        FType  - Der Typ des Faktums als Integer
        Self   - Zugriff auf das zugrunde liegende TObject

      Verwendung:
        - Basis für alle anderen genealogischen Daten-Interfaces
        - Ermöglicht polymorphe Verarbeitung von Daten
        - Self-Property erlaubt Zugriff auf Objekt-Implementierung

      Siehe auch:
        IGenFact, IGenEvent, IGenEntity
      ============================================================================
    }
    IGenData = interface
       ['{1197F8EE-0339-47CC-AFAB-F78B9FF280A8}']
        /// <summary>
        /// Gibt die Daten als String zurück
        /// </summary>
        function GetData: string;
        
        /// <summary>
        /// Gibt den Typ des Faktums zurück
        /// </summary>
        function GetFType: integer;
        
        /// <summary>
        /// Gibt das zugrunde liegende TObject zurück
        /// </summary>
        function GetObject: TObject;
        
        /// <summary>
        /// Setzt die Daten als String
        /// </summary>
        procedure SetData(AValue: string);
        
        /// <summary>
        /// Setzt den Typ des Faktums
        /// </summary>
        procedure SetFType(AValue: integer);
        
        /// <summary>
        /// Der eigentliche Datenwert als String
        /// </summary>
        property Data: string read GetData write SetData;
        
        /// <summary>
        /// Der Typ des Faktums als Integer
        /// </summary>
        property FType: integer read GetFType write SetFType;
        
        /// <summary>
        /// Zugriff auf das zugrunde liegende TObject
        /// </summary>
        property Self: TObject read GetObject;
    end;


    {
      ============================================================================
      Interface: IGenFact
      ============================================================================
      Beschreibung:
        Erweitert IGenData um Quellenangaben. Repräsentiert ein genealogisches
        Faktum mit zugehöriger Quelle.

      Vererbung:
        IGenData

      Zusätzliche Eigenschaften:
        Source - Verweis auf die Quellenangabe als IGenData

      Verwendung:
        - Für Fakten, die eine Quellenangabe benötigen
        - Ermöglicht Nachvollziehbarkeit genealogischer Informationen
        - Basis für IGenEvent und IGenName

      Siehe auch:
        IGenData, IGenEvent, IGenName
      ============================================================================
    }
    IGenFact = interface(IGenData)
        /// <summary>
        /// Gibt die zugeordnete Quellenangabe zurück
        /// </summary>
        function GetSource: IGenData;
        
        /// <summary>
        /// Setzt die Quellenangabe für dieses Faktum
        /// </summary>
        procedure SetSource(AValue: IGenData);
        
        /// <summary>
        /// Quellenangabe für dieses Faktum
        /// </summary>
        property Source: IGenData read GetSource write SetSource;
    end;

    {
      ============================================================================
      Interface: IGenEvent
      ============================================================================
      Beschreibung:
        Repräsentiert ein genealogisches Ereignis (Event) mit Datum, Ort und
        Ereignistyp. Erweitert IGenFact um ereignisspezifische Informationen.

      Vererbung:
        IGenFact -> IGenData

      Eigenschaften:
        Date      - Datum des Ereignisses als String
        Place     - Ort des Ereignisses als String
        EventType - Art des Ereignisses (TenumEventType)

      Bemerkungen:
        - Unterstützt überladene SetPlace-Methoden (IGenFact und String)
        - Datum kann in verschiedenen Formaten vorliegen
        - Ort kann hierarchisch strukturiert sein

      Verwendung:
        Wird für alle Ereignisse verwendet (Geburt, Tod, Heirat etc.)

      Siehe auch:
        TenumEventType, IGenFact
      ============================================================================
    }
    IGenEvent = interface(IGenFact)
        /// <summary>
        /// Gibt den Ereignistyp zurück
        /// </summary>
        function GetEventType: TenumEventType;
        
        /// <summary>
        /// Gibt das Datum des Ereignisses als String zurück
        /// </summary>
        function GetDate: string;
        
        /// <summary>
        /// Gibt den Ort des Ereignisses als String zurück
        /// </summary>
        function GetPlace: String; overload;
        
        /// <summary>
        /// Setzt das Datum des Ereignisses
        /// </summary>
        procedure SetDate(AValue: string);
        
        /// <summary>
        /// Setzt den Ereignistyp
        /// </summary>
        procedure SetEventType(AValue: TenumEventType);
        
        /// <summary>
        /// Setzt den Ort als IGenFact-Objekt
        /// </summary>
        procedure SetPlace(AValue: IGenFact); overload;
        
        /// <summary>
        /// Setzt den Ort als String
        /// </summary>
        procedure SetPlace(AValue: string); overload;
        
        /// <summary>
        /// Datum des Ereignisses
        /// </summary>
        property Date: string read GetDate write SetDate;
        
        /// <summary>
        /// Ort des Ereignisses
        /// </summary>
        property Place: string read GetPlace write SetPlace;
        
        /// <summary>
        /// Art des Ereignisses (Geburt, Tod, Heirat etc.)
        /// </summary>
        property EventType: TenumEventType read GetEventType write SetEventType;
    end;

    {
      ============================================================================
      Interface: IGenName
      ============================================================================
      Beschreibung:
        Repräsentiert einen Namen als genealogisches Faktum.
        Marker-Interface ohne zusätzliche Funktionalität.

      Vererbung:
        IGenFact -> IGenData

      Verwendung:
        - Zur Typunterscheidung von Namen gegenüber anderen Fakten
        - Kann für Vor-, Nach-, Spitz- oder andere Namensformen verwendet werden

      Siehe auch:
        IGenFact
      ============================================================================
    }
    IGenName = interface(IGenFact)
    end;

    {
      ============================================================================
      Interface: IGenEntity
      ============================================================================
      Beschreibung:
        Basis-Interface für genealogische Entitäten (Personen und Familien).
        Stellt eine Sammlung von Ereignissen bereit.

      Vererbung:
        IGenData

      Eigenschaften:
        EventCount - Anzahl der zugeordneten Ereignisse
        Events     - Zugriff auf Ereignisse über Variant-Index (numerisch oder String)

      Bemerkungen:
        - Events können über Index (Integer) oder ID (String) adressiert werden
        - Basis für IGenIndividual und IGenFamily

      Verwendung:
        - Abstrakte Basis für Personen und Familien
        - Ermöglicht einheitlichen Zugriff auf Ereignis-Collections

      Siehe auch:
        IGenIndividual, IGenFamily, IGenEvent
      ============================================================================
    }
    IGenEntity = interface(IGenData)
        /// <summary>
        /// Gibt die Anzahl der zugeordneten Ereignisse zurück
        /// </summary>
        function GetEventCount: integer;
        
        /// <summary>
        /// Gibt ein Ereignis über Index oder ID zurück
        /// </summary>
        /// <param name="Idx">Variant - Integer-Index oder String-ID</param>
        function GetEvents(Idx: Variant): IGenEvent;
        
        /// <summary>
        /// Setzt ein Ereignis an der angegebenen Position
        /// </summary>
        procedure SetEvents(Idx: variant; AValue: IGenEvent);
        
        /// <summary>
        /// Anzahl der zugeordneten Ereignisse
        /// </summary>
        property EventCount: integer read GetEventCount;
        
        /// <summary>
        /// Zugriff auf Ereignisse über Index (Integer) oder ID (String)
        /// </summary>
        property Events[Idx: variant]: IGenEvent read GetEvents write SetEvents;
    end;


    // Forward-Deklarationen für gegenseitige Referenzen
    IGenFamily = interface;
    IGenIndividual = interface;

    {
      ============================================================================
      Interface: IGenIndEnumerator
      ============================================================================
      GUID: {6BA55FCB-E374-40F7-B7DD-3125C266BABB}

      Beschreibung:
        Enumerator für die Iteration über Personen-Collections.
        Implementiert das Enumerator-Pattern für IGenIndividual.

      Methoden:
        GetCurrent     - Gibt die aktuelle Person zurück
        MoveNext       - Bewegt den Cursor zur nächsten Person
        GetEnumerator  - Gibt sich selbst zurück (für for-in-Schleifen)

      Verwendung:
        Ermöglicht foreach/for-in-Iteration über Personen-Sammlungen

      Beispiel:
        for person in family.EnumChildren do
        begin
          // Verarbeite person
        end;

      Siehe auch:
        IGenIndividual, IGenFamEnumerator
      ============================================================================
    }
    IGenIndEnumerator = Interface
         ['{6BA55FCB-E374-40F7-B7DD-3125C266BABB}']
             /// <summary>
             /// Gibt die aktuelle Person zurück
             /// </summary>
             function getCurrent: IGenIndividual;
             
             /// <summary>
             /// Bewegt den Cursor zur nächsten Person
             /// </summary>
             /// <returns>True, wenn eine weitere Person verfügbar ist</returns>
             function MoveNext: boolean;
             
             /// <summary>
             /// Aktuelle Person im Enumerator
             /// </summary>
             property Current: IGenIndividual read getCurrent;
             
             /// <summary>
             /// Gibt sich selbst zurück (für for-in-Schleifen)
             /// </summary>
             function GetEnumerator: IGenIndEnumerator;
     end;

    {
      ============================================================================
      Interface: IGenFamEnumerator
      ============================================================================
      GUID: {005A67C7-5A98-4749-8F56-204FADDE72F7}

      Beschreibung:
        Enumerator für die Iteration über Familien-Collections.
        Implementiert das Enumerator-Pattern für IGenFamily.

      Methoden:
        GetCurrent     - Gibt die aktuelle Familie zurück
        MoveNext       - Bewegt den Cursor zur nächsten Familie
        GetEnumerator  - Gibt sich selbst zurück (für for-in-Schleifen)

      Verwendung:
        Ermöglicht foreach/for-in-Iteration über Familien-Sammlungen

      Siehe auch:
        IGenFamily, IGenIndEnumerator
      ============================================================================
    }
    IGenFamEnumerator = Interface
         ['{005A67C7-5A98-4749-8F56-204FADDE72F7}']
             /// <summary>
             /// Gibt die aktuelle Familie zurück
             /// </summary>
             function getCurrent: IGenFamily;
             
             /// <summary>
             /// Bewegt den Cursor zur nächsten Familie
             /// </summary>
             /// <returns>True, wenn eine weitere Familie verfügbar ist</returns>
             function MoveNext: boolean;
             
             /// <summary>
             /// Aktuelle Familie im Enumerator
             /// </summary>
             property Current: IGenFamily read getCurrent;
             
             /// <summary>
             /// Gibt sich selbst zurück (für for-in-Schleifen)
             /// </summary>
             function GetEnumerator: IGenFamEnumerator;
     end;

    {
      ============================================================================
      Interface: IGenIndividual
      ============================================================================
      Beschreibung:
        Repräsentiert eine Person in der genealogischen Datenbank.
        Umfasst alle biografischen Daten, Beziehungen und Ereignisse.

      Vererbung:
        IGenEntity -> IGenData

      Kategorie der Eigenschaften:

      1. Basis-Eigenschaften:
         - Name, GivenName, Surname, Title - Namensbestandteile
         - Sex - Geschlecht
         - IndRefID - Eindeutige Referenz-ID

      2. Beziehungs-Eigenschaften:
         - Father, Mother - Eltern
         - Children - Kinder (Array)
         - ParentFamily - Ursprungsfamilie
         - Families - Familien als Ehepartner (Array)
         - Spouses - Ehepartner (Array)

      3. Lebensdaten-Eigenschaften:
         - Birth, BirthDate, BirthPlace - Geburt
         - Baptism, BaptDate, BaptPlace - Taufe
         - Death, DeathDate, DeathPlace - Tod
         - Burial, BurialDate, BurialPlace - Beerdigung
         - Religion - Religionszugehörigkeit
         - Occupation, OccuPlace - Beruf und Ort
         - Residence - Wohnsitz

      4. Verwaltungs-Eigenschaften:
         - LastChange - Zeitstempel der letzten Änderung

      Bemerkungen:
        - Variant-Indizes erlauben numerischen oder String-basierten Zugriff
        - TODO: EnumSpouses, EnumChildren, EnumFamilies noch zu implementieren

      Siehe auch:
        IGenEntity, IGenFamily, IGenEvent
      ============================================================================
    }
    IGenIndividual = interface(IGenEntity)
        // === Getter-Methoden für Taufe ===
        function GetBaptDate: string;
        function GetBaptism: IGenEvent;
        function GetBaptPlace: string;
        
        // === Getter-Methoden für Geburt ===
        function GetBirth: IGenEvent;
        function GetBirthDate: string;
        function GetBirthPlace: string;
        
        // === Getter-Methoden für Beerdigung ===
        function GetBurial: IGenEvent;
        function GetBurialDate: string;
        function GetBurialPlace: string;
        
        // === Getter-Methoden für Kinder ===
        function GetChildrenCount: integer;
        function GetChildren(Idx: Variant): IGenIndividual;
        
        // === Getter-Methoden für Tod ===
        function GetDeath: IGenEvent;
        function GetDeathDate: string;
        function GetDeathPlace: string;
        
        // === Getter-Methoden für Familien ===
        function GetFamilies(Idx: Variant): IGenFamily;
        function GetFamilyCount: integer;
        
        // === Getter-Methoden für Eltern ===
        function GetFather: IGenIndividual;
        function GetMother: IGenIndividual;
        
        // === Getter-Methoden für Namen ===
        function GetGivenName: string;
        function GetName: string;
        function GetSurname: string;
        function GetTitle: string;
        
        // === Getter-Methoden für Identifikation ===
        function GetIndRefID: string;
        
        // === Getter-Methoden für Beruf/Wohnort ===
        function GetOccupation: string;
        function GetOccuPlace: string;
        function GetResidence: string;
        
        // === Getter-Methoden für Familie ===
        function GetParentFamily: IGenFamily;
        
        // === Getter-Methoden für Religion/Geschlecht ===
        function GetReligion: string;
        function GetSex: string;
        
        // === Getter-Methoden für Ehepartner ===
        function GetSpouseCount: integer;
        function GetSpouses(Idx: Variant): IGenIndividual;
        
        // === Getter-Methoden für Zeitstempel ===
        function GetTimeStamp: TDateTime;
        
        // === Getter-Methoden für Titel ===
        function GetTitle: string;
        
{    Todo:   Methoden Implementieren                            }
{       function EnumSpouses:IGenIndEnumerator;
        function EnumChildren:IGenIndEnumerator;
        function EnumFamilies:IGenFamEnumerator;       }
        
        // === Setter-Methoden für Taufe ===
        procedure SetBaptDate(AValue: string);
        procedure SetBaptism(AValue: IGenEvent);
        procedure SetBaptPlace(AValue: string);
        
        // === Setter-Methoden für Geburt ===
        procedure SetBirth(AValue: IGenEvent);
        procedure SetBirthDate(AValue: string);
        procedure SetBirthPlace(AValue: string);
        
        // === Setter-Methoden für Beerdigung ===
        procedure SetBurial(AValue: IGenEvent);
        procedure SetBurialDate(AValue: string);
        procedure SetBurialPlace(AValue: string);
        
        // === Setter-Methoden für Kinder ===
        procedure SetChildren(Idx: Variant; AValue: IGenIndividual);
        
        // === Setter-Methoden für Tod ===
        procedure SetDeath(AValue: IGenEvent);
        procedure SetDeathDate(AValue: string);
        procedure SetDeathPlace(AValue: string);
        
        // === Setter-Methoden für Familien ===
        procedure SetFamilies(Idx: Variant; AValue: IGenFamily);
        
        // === Setter-Methoden für Eltern ===
        procedure SetFather(AValue: IGenIndividual);
        procedure SetMother(AValue: IGenIndividual);
        
        // === Setter-Methoden für Namen ===
        procedure SetGivenName(AValue: string);
        procedure SetName(AValue: string);
        procedure SetSurname(AValue: string);
        procedure SetTitle(AValue: string);
        
        // === Setter-Methoden für Identifikation ===
        procedure SetIndRefID(AValue: string);
        
        // === Setter-Methoden für Beruf/Wohnort ===
        procedure SetOccupation(AValue: string);
        procedure SetOccuPlace(AValue: string);
        procedure SetResidence(AValue: string);
        
        // === Setter-Methoden für Familie ===
        procedure SetParentFamily(AValue: IGenFamily);
        
        // === Setter-Methoden für Religion/Geschlecht ===
        procedure SetReligion(AValue: string);
        procedure SetSex(AValue: string);
        
        // === Setter-Methoden für Ehepartner ===
        procedure SetSpouses(Idx: Variant; AValue: IGenIndividual);
        
        // === Setter-Methoden für Zeitstempel ===
        procedure SetTimeStamp(AValue: TDateTime);
        
        // ========================================================================
        // Basis-Properties
        // ========================================================================
        
        /// <summary>
        /// Vollständiger Name der Person
        /// </summary>
        property Name: string read GetName write SetName;
        
        /// <summary>
        /// Vorname(n) der Person
        /// </summary>
        property GivenName: string read GetGivenName write SetGivenName;
        
        /// <summary>
        /// Nachname/Familienname der Person
        /// </summary>
        property Surname: string read GetSurname write SetSurname;
        
        /// <summary>
        /// Titel der Person (z.B. Dr., Prof.)
        /// </summary>
        property Title: string read GetTitle write SetTitle;
        
        /// <summary>
        /// Geschlecht der Person (M/F/U)
        /// </summary>
        property Sex: string read GetSex write SetSex;
        
        /// <summary>
        /// Eindeutige Referenz-ID der Person
        /// </summary>
        property IndRefID: string read GetIndRefID write SetIndRefID;
        
        // ========================================================================
        // Beziehungs-Properties
        // ========================================================================
        
        /// <summary>
        /// Vater der Person
        /// </summary>
        property Father: IGenIndividual read GetFather write SetFather;
        
        /// <summary>
        /// Mutter der Person
        /// </summary>
        property Mother: IGenIndividual read GetMother write SetMother;
        
        /// <summary>
        /// Anzahl der Kinder
        /// </summary>
        property ChildCount: integer read GetChildrenCount;
        
        /// <summary>
        /// Zugriff auf Kinder über Index oder ID
        /// </summary>
        property Children[Idx: Variant]: IGenIndividual read GetChildren write SetChildren;
        
        /// <summary>
        /// Familie, in der die Person Kind ist
        /// </summary>
        property ParentFamily: IGenFamily read GetParentFamily write SetParentFamily;
        
        /// <summary>
        /// Anzahl der Familien, in denen die Person Ehepartner ist
        /// </summary>
        property FamilyCount: integer read GetFamilyCount;
        
        /// <summary>
        /// Familien, in denen die Person Ehepartner ist
        /// </summary>
        property Families[Idx: Variant]: IGenFamily read GetFamilies write SetFamilies;
        
        /// <summary>
        /// Anzahl der Ehepartner
        /// </summary>
        property SpouseCount: integer read GetSpouseCount;
        
        /// <summary>
        /// Ehepartner der Person
        /// </summary>
        property Spouses[Idx: Variant]: IGenIndividual read GetSpouses write SetSpouses;
        
        // ========================================================================
        // Lebensdaten-Properties
        // ========================================================================
        
        /// <summary>
        /// Geburtsdatum als String
        /// </summary>
        property BirthDate: string read GetBirthDate write SetBirthDate;
        
        /// <summary>
        /// Geburtsort als String
        /// </summary>
        property BirthPlace: string read GetBirthPlace write SetBirthPlace;
        
        /// <summary>
        /// Geburtsereignis (vollständige Event-Daten)
        /// </summary>
        property Birth: IGenEvent read GetBirth write SetBirth;
        
        /// <summary>
        /// Taufdatum als String
        /// </summary>
        property BaptDate: string read GetBaptDate write SetBaptDate;
        
        /// <summary>
        /// Taufort als String
        /// </summary>
        property BaptPlace: string read GetBaptPlace write SetBaptPlace;
        
        /// <summary>
        /// Taufereignis (vollständige Event-Daten)
        /// </summary>
        property Baptism: IGenEvent read GetBaptism write SetBaptism;
        
        /// <summary>
        /// Todesdatum als String
        /// </summary>
        property DeathDate: string read GetDeathDate write SetDeathDate;
        
        /// <summary>
        /// Todesort als String
        /// </summary>
        property DeathPlace: string read GetDeathPlace write SetDeathPlace;
        
        /// <summary>
        /// Todesereignis (vollständige Event-Daten)
        /// </summary>
        property Death: IGenEvent read GetDeath write SetDeath;
        
        /// <summary>
        /// Beerdigungsdatum als String
        /// </summary>
        property BurialDate: string read GetBurialDate write SetBurialDate;
        
        /// <summary>
        /// Beerdigungsort als String
        /// </summary>
        property BurialPlace: string read GetBurialPlace write SetBurialPlace;
        
        /// <summary>
        /// Beerdigungsereignis (vollständige Event-Daten)
        /// </summary>
        property Burial: IGenEvent read GetBurial write SetBurial;
        
        /// <summary>
        /// Religionszugehörigkeit
        /// </summary>
        property Religion: string read GetReligion write SetReligion;
        
        /// <summary>
        /// Beruf der Person
        /// </summary>
        property Occupation: string read GetOccupation write SetOccupation;
        
        /// <summary>
        /// Ort der Berufsausübung
        /// </summary>
        property OccuPlace: string read GetOccuPlace write SetOccuPlace;
        
        /// <summary>
        /// Wohnsitz der Person
        /// </summary>
        property Residence: string read GetResidence write SetResidence;
        
        // ========================================================================
        // Verwaltungs-Properties
        // ========================================================================
        
        /// <summary>
        /// Zeitstempel der letzten Änderung
        /// </summary>
        property LastChange: TDateTime read GetTimeStamp write SetTimeStamp;
    end;

    {
      ============================================================================
      Interface: IGenFamily
      ============================================================================
      Beschreibung:
        Repräsentiert eine Familie (Ehepaar mit Kindern) in der genealogischen
        Datenbank. Eine Familie verbindet Ehepartner und deren Kinder.

      Vererbung:
        IGenEntity -> IGenData

      Haupteigenschaften:
        - Husband, Wife - Die Ehepartner
        - Children - Array der Kinder
        - Marriage - Heiratsereignis mit Datum und Ort
        - FamilyRefID - Eindeutige Identifikation
        - FamilyName - Name der Familie

      Methoden:
        - EnumChildren - Enumerator für Kinder-Iteration

      Verwendung:
        Verbindet Personen in familiären Beziehungen und dokumentiert
        Heiratsinformationen

      Siehe auch:
        IGenEntity, IGenIndividual, IGenEvent
      ============================================================================
    }
    IGenFamily = interface(IGenEntity)
        /// <summary>
        /// Gibt die Anzahl der Kinder zurück
        /// </summary>
        function GetChildCount: integer;
        
        /// <summary>
        /// Gibt ein Kind über Index oder ID zurück
        /// </summary>
        function GetChildren(Idx: Variant): IGenIndividual;
        
        /// <summary>
        /// Gibt den Familiennamen zurück
        /// </summary>
        function GetFamilyName: string;
        
        /// <summary>
        /// Gibt die eindeutige Familien-ID zurück
        /// </summary>
        function GetFamilyRefID: string;
        
        /// <summary>
        /// Gibt den Ehemann zurück
        /// </summary>
        function GetHusband: IGenIndividual;
        
        /// <summary>
        /// Gibt das Heiratsereignis zurück
        /// </summary>
        function GetMarriage: IGenEvent;
        
        /// <summary>
        /// Gibt das Heiratsdatum als String zurück
        /// </summary>
        function GetMarriageDate: string;
        
        /// <summary>
        /// Gibt den Heiratsort als String zurück
        /// </summary>
        function GetMarriagePlace: string;
        
        /// <summary>
        /// Gibt die Ehefrau zurück
        /// </summary>
        function GetWife: IGenIndividual;
        
        /// <summary>
        /// Gibt einen Enumerator für die Iteration über Kinder zurück
        /// </summary>
        function EnumChildren:IGenIndEnumerator;
        
        /// <summary>
        /// Setzt ein Kind an der angegebenen Position
        /// </summary>
        procedure SetChildren(Idx: Variant; AValue: IGenIndividual);
        
        /// <summary>
        /// Setzt den Familiennamen
        /// </summary>
        procedure SetFamilyName(AValue: string);
        
        /// <summary>
        /// Setzt die Familien-ID
        /// </summary>
        procedure SetFamilyRefID(AValue: string);
        
        /// <summary>
        /// Setzt den Ehemann
        /// </summary>
        procedure SetHusband(AValue: IGenIndividual);
        
        /// <summary>
        /// Setzt das Heiratsereignis
        /// </summary>
        procedure SetMarriage(AValue: IGenEvent);
        
        /// <summary>
        /// Setzt das Heiratsdatum
        /// </summary>
        procedure SetMarriageDate(AValue: string);
        
        /// <summary>
        /// Setzt den Heiratsort
        /// </summary>
        procedure SetMarriagePlace(AValue: string);
        
        /// <summary>
        /// Setzt die Ehefrau
        /// </summary>
        procedure SetWife(AValue: IGenIndividual);
        
        /// <summary>
        /// Ehemann der Familie
        /// </summary>
        property Husband: IGenIndividual read GetHusband write SetHusband;
        
        /// <summary>
        /// Ehefrau der Familie
        /// </summary>
        property Wife: IGenIndividual read GetWife write SetWife;
        
        /// <summary>
        /// Anzahl der Kinder in dieser Familie
        /// </summary>
        property ChildCount: integer read GetChildCount;
        
        /// <summary>
        /// Zugriff auf Kinder über Index oder ID
        /// </summary>
        property Children[Idx: Variant]: IGenIndividual read GetChildren write SetChildren;
        
        /// <summary>
        /// Heiratsdatum als String
        /// </summary>
        property MarriageDate: string read GetMarriageDate write SetMarriageDate;
        
        /// <summary>
        /// Heiratsort als String
        /// </summary>
        property MarriagePlace: string read GetMarriagePlace write SetMarriagePlace;
        
        /// <summary>
        /// Heiratsereignis (vollständige Event-Daten)
        /// </summary>
        property Marriage: IGenEvent read GetMarriage write SetMarriage;
        
        /// <summary>
        /// Eindeutige Referenz-ID der Familie
        /// </summary>
        property FamilyRefID:string read GetFamilyRefID write SetFamilyRefID;
        
        /// <summary>
        /// Name der Familie
        /// </summary>
        property FamilyName:string read GetFamilyName write SetFamilyName;
    end;

    {
      ============================================================================
      Interface: IGenealogy
      ============================================================================
      GUID: {3A5EB720-AB5E-453B-97C2-C57A5E498D9D}

      Beschreibung:
        Haupt-Container-Interface für eine genealogische Datenbank.
        Verwaltet alle Personen und Familien in der Genealogie.

      Eigenschaften:
        Individuum    - Zugriff auf Personen über Index oder ID
        IndividCount  - Gesamtanzahl der Personen
        Family        - Zugriff auf Familien über Index oder ID
        FamilyCount   - Gesamtanzahl der Familien

      Methoden:
        EnumChildren  - Enumerator für Personen-Iteration
        EnumFamilies  - Enumerator für Familien-Iteration

      Verwendung:
        - Einstiegspunkt für Zugriff auf genealogische Daten
        - Ermöglicht Iteration über alle Personen und Familien
        - Unterstützt Variant-basierte Indizierung

      Siehe auch:
        IGenIndividual, IGenFamily, IGenIndEnumerator, IGenFamEnumerator
      ============================================================================
    }
    IGenealogy = interface
      ['{3A5EB720-AB5E-453B-97C2-C57A5E498D9D}']
       /// <summary>
       /// Zugriff auf Personen über Index (Integer) oder ID (String)
       /// </summary>
       Property Individuum[Idx:Variant]:IGenIndividual;
       
       /// <summary>
       /// Gesamtanzahl der Personen in der Genealogie
       /// </summary>
       Property IndividCount:Integer;
       
       /// <summary>
       /// Zugriff auf Familien über Index (Integer) oder ID (String)
       /// </summary>
       Property Family[Idx:Variant]:IGenFamily;
       
       /// <summary>
       /// Gesamtanzahl der Familien in der Genealogie
       /// </summary>
       Property FamilyCount:Integer;
       
       /// <summary>
       /// Gibt einen Enumerator für Personen-Iteration zurück
       /// </summary>
       function EnumChildren:IGenIndEnumerator;
       
       /// <summary>
       /// Gibt einen Enumerator für Familien-Iteration zurück
       /// </summary>
       function EnumFamilies:IGenFamEnumerator;
    end;

{
  ============================================================================
  Typ: TTMessageEvent
  ============================================================================
  Beschreibung:
    Event-Handler-Typ für Nachrichten und Meldungen im genealogischen System.

  Parameter:
    Sender - Das Objekt, das das Ereignis ausgelöst hat
    aType  - Typ des Ereignisses (TEventType)
    aText  - Nachrichtentext
    Ref    - Referenz (z.B. ID einer Person/Familie)
    aMode  - Modus/Schweregrad der Nachricht

  Verwendung:
    Für Logging, Statusmeldungen, Fehlerbehandlung und Fortschrittsanzeigen

  Bemerkungen:
    - TEventType muss in einer anderen Unit definiert sein
    - aMode kann für Filterung oder Priorisierung verwendet werden
  ============================================================================
}
 TTMessageEvent = procedure(Sender: TObject; aType: T_eventType;
        aText: string; Ref: string; aMode: integer) of object;
        
implementation

end.

