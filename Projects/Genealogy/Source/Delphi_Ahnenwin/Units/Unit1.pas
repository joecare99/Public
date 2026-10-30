unit Unit1;

{-------------------------------------------------------------------------------
  Unit1 - TForm1, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit1.pas and the original resource
  Source\Projects_AhnenWin\Form1.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, Menus, ExtCtrls, ComCtrls, DBCtrls, StdCtrls, Grids, Dialogs, DBGrids, ExtDlgs, FileCtrl, DBTables, DBCommon, DB, Buttons, DBClient, Forms, Controls, DateUtils, JPEG;

type
  TForm1 = class(TForm)
  published
    MainMenu1: TMainMenu; //2F0
    Datei1: TMenuItem; //2F4
    Datensatz1: TMenuItem; //2F8
    neu1: TMenuItem; //2FC
    N1: TMenuItem; //300
    schen1: TMenuItem; //304
    Shape1: TShape; //308
    Suchen1: TMenuItem; //30C
    DatensatzNr1: TMenuItem; //310
    Datenaustausch1: TMenuItem; //314
    Listen1: TMenuItem; //318
    Vorfahren1: TMenuItem; //31C
    Nachfahren1: TMenuItem; //320
    Kalender1: TMenuItem; //324
    Bilder1: TMenuItem; //328
    Datenprfung1: TMenuItem; //32C
    Info1: TMenuItem; //330
    Datensicherung1: TMenuItem; //334
    PageControl1: TPageControl; //338
    TabSheet1: TTabSheet; //33C
    TabSheet2: TTabSheet; //340
    TabSheet3: TTabSheet; //344
    TabSheet4: TTabSheet; //348
    TabSheet5: TTabSheet; //34C
    TabSheet6: TTabSheet; //350
    DBNavigator1: TDBNavigator; //354
    Label1: TLabel; //358
    Label2: TLabel; //35C
    Label3: TLabel; //360
    DBEdit2: TDBEdit; //364
    DBEdit3: TDBEdit; //368
    Label5: TLabel; //36C
    StringGrid1: TStringGrid; //370
    StringGrid2: TStringGrid; //374
    Label6: TLabel; //378
    Label7: TLabel; //37C
    Shape2: TShape; //380
    Label8: TLabel; //384
    DBEdit5: TDBEdit; //388
    Label9: TLabel; //38C
    Label10: TLabel; //390
    DBEdit6: TDBEdit; //394
    Prfen1: TMenuItem; //398
    Shape3: TShape; //39C
    Label11: TLabel; //3A0
    Label12: TLabel; //3A4
    Edit1: TEdit; //3A8
    Edit2: TEdit; //3AC
    DBEdit7: TDBEdit; //3B0
    Label4: TLabel; //3B4
    Label13: TLabel; //3B8
    DBEdit8: TDBEdit; //3BC
    DBEdit9: TDBEdit; //3C0
    DBEdit10: TDBEdit; //3C4
    Label14: TLabel; //3C8
    Label15: TLabel; //3CC
    DBEdit12: TDBEdit; //3D0
    DBEdit13: TDBEdit; //3D4
    DBEdit14: TDBEdit; //3D8
    Label16: TLabel; //3DC
    DBEdit16: TDBEdit; //3E0
    DBEdit17: TDBEdit; //3E4
    DBEdit18: TDBEdit; //3E8
    Label17: TLabel; //3EC
    DBEdit20: TDBEdit; //3F0
    DBEdit21: TDBEdit; //3F4
    DBEdit22: TDBEdit; //3F8
    SaveDialog1: TSaveDialog; //3FC
    Label18: TLabel; //400
    Label19: TLabel; //404
    DBMemo1: TDBMemo; //408
    Memo1: TMemo; //40C
    Datensichern1: TMenuItem; //410
    OpenDialog1: TOpenDialog; //414
    Datenlschen1: TMenuItem; //418
    Label20: TLabel; //41C
    Label21: TLabel; //420
    DBGrid1: TDBGrid; //424
    GregorianischerKalender1: TMenuItem; //428
    FrzRevolutionskalender1: TMenuItem; //42C
    Osterberechnung1: TMenuItem; //430
    ChristlicheNamenstage1: TMenuItem; //434
    N3: TMenuItem; //438
    IDSatznr1: TMenuItem; //43C
    IDslschen1: TMenuItem; //440
    N4: TMenuItem; //444
    DBEdit4: TDBEdit; //448
    Label22: TLabel; //44C
    Label23: TLabel; //450
    Label24: TLabel; //454
    Label25: TLabel; //458
    PopupMenu1: TPopupMenu; //45C
    PopupMenu2: TPopupMenu; //460
    Verbindungeinfgen1: TMenuItem; //464
    Verbindunglschen1: TMenuItem; //468
    Kindereinfgen1: TMenuItem; //46C
    Kinderentfernen1: TMenuItem; //470
    Label26: TLabel; //474
    StringGrid4: TStringGrid; //478
    beenden1: TMenuItem; //47C
    TabSheet7: TTabSheet; //480
    TabSheet8: TTabSheet; //484
    DBGrid2: TDBGrid; //488
    Label27: TLabel; //48C
    Label28: TLabel; //490
    Label35: TLabel; //494
    Label41: TLabel; //498
    DBEdit25: TDBEdit; //49C
    Label63: TLabel; //4A0
    Label29: TLabel; //4A4
    Label30: TLabel; //4A8
    Label31: TLabel; //4AC
    Label32: TLabel; //4B0
    Label52: TLabel; //4B4
    Label33: TLabel; //4B8
    Label34: TLabel; //4BC
    Label39: TLabel; //4C0
    Label40: TLabel; //4C4
    Label42: TLabel; //4C8
    Label43: TLabel; //4CC
    DBEdit57: TDBEdit; //4D0
    DBEdit56: TDBEdit; //4D4
    DBEdit55: TDBEdit; //4D8
    DBEdit60: TDBEdit; //4DC
    DBEdit52: TDBEdit; //4E0
    DBEdit51: TDBEdit; //4E4
    DBEdit50: TDBEdit; //4E8
    DBEdit59: TDBEdit; //4EC
    DBEdit49: TDBEdit; //4F0
    DBEdit48: TDBEdit; //4F4
    DBEdit47: TDBEdit; //4F8
    DBEdit44: TDBEdit; //4FC
    DBEdit43: TDBEdit; //500
    DBEdit42: TDBEdit; //504
    DBEdit26: TDBEdit; //508
    DBEdit40: TDBEdit; //50C
    DBComboBox7: TDBComboBox; //510
    DBCheckBox2: TDBCheckBox; //514
    Edit32: TEdit; //518
    Label53: TLabel; //51C
    Label60: TLabel; //520
    Label59: TLabel; //524
    Label58: TLabel; //528
    Label57: TLabel; //52C
    DBEdit31: TDBEdit; //530
    Label50: TLabel; //534
    Label44: TLabel; //538
    Label45: TLabel; //53C
    Label46: TLabel; //540
    Label47: TLabel; //544
    Label49: TLabel; //548
    Label48: TLabel; //54C
    Edit4: TEdit; //550
    Edit5: TEdit; //554
    Edit6: TEdit; //558
    Shape4: TShape; //55C
    Shape5: TShape; //560
    Edit30: TEdit; //564
    Edit10: TEdit; //568
    Edit9: TEdit; //56C
    Edit8: TEdit; //570
    Edit31: TEdit; //574
    Edit13: TEdit; //578
    Edit14: TEdit; //57C
    Edit15: TEdit; //580
    Panel1: TPanel; //584
    Label64: TLabel; //588
    DBEdit32: TDBEdit; //58C
    DBEdit33: TDBEdit; //590
    DBText2: TDBText; //594
    ComboBox5: TComboBox; //598
    Shape6: TShape; //59C
    Shape7: TShape; //5A0
    StringGrid3: TStringGrid; //5A4
    Label62: TLabel; //5A8
    Label36: TLabel; //5AC
    Label37: TLabel; //5B0
    Label38: TLabel; //5B4
    Label54: TLabel; //5B8
    Label51: TLabel; //5BC
    Label55: TLabel; //5C0
    Label56: TLabel; //5C4
    Label61: TLabel; //5C8
    Label65: TLabel; //5CC
    Shape8: TShape; //5D0
    Label66: TLabel; //5D4
    Label67: TLabel; //5D8
    DBEdit35: TDBEdit; //5DC
    DBEdit36: TDBEdit; //5E0
    DBEdit37: TDBEdit; //5E4
    DBEdit38: TDBEdit; //5E8
    DBEdit39: TDBEdit; //5EC
    DBEdit41: TDBEdit; //5F0
    DBEdit45: TDBEdit; //5F4
    DBEdit46: TDBEdit; //5F8
    DBComboBox1: TDBComboBox; //5FC
    DBEdit61: TDBEdit; //600
    DBEdit62: TDBEdit; //604
    DBEdit63: TDBEdit; //608
    Label68: TLabel; //60C
    Filter1: TMenuItem; //610
    ID1: TMenuItem; //614
    N2: TMenuItem; //618
    aus1: TMenuItem; //61C
    Datenschutzein1: TMenuItem; //620
    Datenschutzaus1: TMenuItem; //624
    N5: TMenuItem; //628
    DBCheckBox1: TDBCheckBox; //62C
    PopupMenu3: TPopupMenu; //630
    PopupMenu4: TPopupMenu; //634
    Vatereinfgen1: TMenuItem; //638
    Vaterentfernen1: TMenuItem; //63C
    Muttereinfgen1: TMenuItem; //640
    Mutterentfernen1: TMenuItem; //644
    Label69: TLabel; //648
    Label71: TLabel; //64C
    Label70: TLabel; //650
    Name1: TMenuItem; //654
    Druckereinstellung1: TMenuItem; //658
    Bildschirmdrucken1: TMenuItem; //65C
    N6: TMenuItem; //660
    PrintDialog1: TPrintDialog; //664
    ExcelExport1: TMenuItem; //668
    N8: TMenuItem; //66C
    Partnersuche1: TMenuItem; //670
    StringGrid5: TStringGrid; //674
    GlobaleSuche1: TMenuItem; //678
    LetzteSuche1: TMenuItem; //67C
    anzeigen1: TMenuItem; //680
    Hilfe1: TMenuItem; //684
    N10: TMenuItem; //688
    zuAHNENWIN1: TMenuItem; //68C
    Hausname1: TMenuItem; //690
    N11: TMenuItem; //694
    Namensliste1: TMenuItem; //698
    allePersonen1: TMenuItem; //69C
    frbestimmtenOrt1: TMenuItem; //6A0
    Ortsliste1: TMenuItem; //6A4
    allePersonen2: TMenuItem; //6A8
    Probandenname1: TMenuItem; //6AC
    FamGrafik1: TMenuItem; //6B0
    einfgen1: TMenuItem; //6B4
    Image1: TImage; //6B8
    OpenPictureDialog1: TOpenPictureDialog; //6BC
    UpDown1: TUpDown; //6C0
    entfernen1: TMenuItem; //6C4
    Grafik1: TMenuItem; //6C8
    Grafikneu1: TMenuItem; //6CC
    Familienblatt2: TMenuItem; //6D0
    Liste1: TMenuItem; //6D4
    N13: TMenuItem; //6D8
    FOKODateierstellen1: TMenuItem; //6DC
    N14: TMenuItem; //6E0
    inyTafelerstellen1: TMenuItem; //6E4
    FOKODateieditieren1: TMenuItem; //6E8
    N15: TMenuItem; //6EC
    OFBDruck1: TMenuItem; //6F0
    N16: TMenuItem; //6F4
    alleBilderentfernen1: TMenuItem; //6F8
    FileListBox1: TFileListBox; //6FC
    N17: TMenuItem; //700
    bmpjpg1: TMenuItem; //704
    N18: TMenuItem; //708
    GedcomDateischreiben1: TMenuItem; //70C
    GedcomDateieinlesen1: TMenuItem; //710
    GedcomXMLschreiben1: TMenuItem; //714
    N19: TMenuItem; //718
    GedcomXMLeinlesen1: TMenuItem; //71C
    Grafikalt1: TMenuItem; //720
    Listen2: TMenuItem; //724
    N21: TMenuItem; //728
    N7: TMenuItem; //72C
    N22: TMenuItem; //730
    AHNENDOSeinlesen1: TMenuItem; //734
    OSBeinlesen1: TMenuItem; //738
    Adressendateischreiben1: TMenuItem; //73C
    Panel2: TPanel; //740
    Label73: TLabel; //744
    Label74: TLabel; //748
    Label75: TLabel; //74C
    Label76: TLabel; //750
    Label77: TLabel; //754
    DBEdit64: TDBEdit; //758
    DBEdit65: TDBEdit; //75C
    DBEdit66: TDBEdit; //760
    DBEdit68: TDBEdit; //764
    Label78: TLabel; //768
    geschachtelt1: TMenuItem; //76C
    N24: TMenuItem; //770
    GrafikI1: TMenuItem; //774
    Label79: TLabel; //778
    Spitzenahnen1: TMenuItem; //77C
    Proband1: TMenuItem; //780
    allePersonen3: TMenuItem; //784
    Basisahnen1: TMenuItem; //788
    N25: TMenuItem; //78C
    DBEdit69: TDBEdit; //790
    N20: TMenuItem; //794
    Verwandtschaft1: TMenuItem; //798
    FamilienblattHTML1: TMenuItem; //79C
    N12: TMenuItem; //7A0
    OrtsDatei1: TMenuItem; //7A4
    NamensListeeditieren1: TMenuItem; //7A8
    N26: TMenuItem; //7AC
    Listenaktualisieren1: TMenuItem; //7B0
    DBText1: TDBText; //7B4
    ComboBox1: TComboBox; //7B8
    ComboBox2: TComboBox; //7BC
    ComboBox3: TComboBox; //7C0
    QuellenListeeditieren1: TMenuItem; //7C4
    N27: TMenuItem; //7C8
    drucken1: TMenuItem; //7CC
    DBComboBox2: TDBComboBox; //7D0
    DBComboBox3: TDBComboBox; //7D4
    Query1: TQuery; //7D8
    Label80: TLabel; //7DC
    DBGrid3: TDBGrid; //7E0
    DataSource1: TDataSource; //7E4
    Label81: TLabel; //7E8
    Shape9: TShape; //7EC
    Label82: TLabel; //7F0
    Label83: TLabel; //7F4
    Label84: TLabel; //7F8
    DBEdit1: TDBEdit; //7FC
    DBEdit11: TDBEdit; //800
    DBEdit15: TDBEdit; //804
    Shape10: TShape; //808
    Shape11: TShape; //80C
    Label86: TLabel; //810
    Label87: TLabel; //814
    Label85: TLabel; //818
    Label88: TLabel; //81C
    Label89: TLabel; //820
    Label90: TLabel; //824
    Label91: TLabel; //828
    Label92: TLabel; //82C
    Label93: TLabel; //830
    N29: TMenuItem; //834
    DoppelteEintrge1: TMenuItem; //838
    N30: TMenuItem; //83C
    nichtverknpfteBeziehungen1: TMenuItem; //840
    Einzelpersonen1: TMenuItem; //844
    FileListBox2: TFileListBox; //848
    bernehmen1: TMenuItem; //84C
    Neu2: TMenuItem; //850
    SpeedButton1: TSpeedButton; //854
    ComboBox4: TComboBox; //858
    ComboBox6: TComboBox; //85C
    ComboBox7: TComboBox; //860
    ComboBox8: TComboBox; //864
    ComboBox9: TComboBox; //868
    ComboBox10: TComboBox; //86C
    ComboBox11: TComboBox; //870
    ComboBox12: TComboBox; //874
    ComboBox13: TComboBox; //878
    ComboBox14: TComboBox; //87C
    ComboBox15: TComboBox; //880
    ComboBox16: TComboBox; //884
    ComboBox17: TComboBox; //888
    ComboBox18: TComboBox; //88C
    ComboBox19: TComboBox; //890
    ComboBox20: TComboBox; //894
    ComboBox21: TComboBox; //898
    ComboBox22: TComboBox; //89C
    ComboBox23: TComboBox; //8A0
    ComboBox24: TComboBox; //8A4
    ComboBox25: TComboBox; //8A8
    ComboBox26: TComboBox; //8AC
    BerufeVerwaltung1: TMenuItem; //8B0
    DataSource2: TDataSource; //8B4
    lfbh2: TClientDataSet; //8B8
    DataSource4: TDataSource; //8BC
    Repso2: TClientDataSet; //8C0
    Repso2z: TAutoIncField; //8C4
    Repso2nr: TIntegerField; //8C8
    Repso2inh: TStringField; //8CC
    Repso2inh2: TMemoField; //8D0
    Repso2alt: TStringField; //8D4
    N28: TMenuItem; //8D8
    EhenKiordnen1: TMenuItem; //8DC
    PrinterSetupDialog1: TPrinterSetupDialog; //8E0
    Edit3: TEdit; //8E4
    Edit7: TEdit; //8E8
    Edit11: TEdit; //8EC
    Edit12: TEdit; //8F0
    Edit16: TEdit; //8F4
    N31: TMenuItem; //8F8
    Fenstertitelndern1: TMenuItem; //8FC
    Quellenliste1: TMenuItem; //900
    HofnamenVerwaltung1: TMenuItem; //904
    lfbh2Nr: TAutoIncField; //908
    lfbh2Nm: TIntegerField; //90C
    lfbh2Prob: TStringField; //910
    lfbh2Eh: TStringField; //914
    lfbh2Ix: TStringField; //918
    lfbh2Nam: TStringField; //91C
    lfbh2Aus: TIntegerField; //920
    lfbh2Hei: TStringField; //924
    Vettern1: TMenuItem; //928
    Basen1: TMenuItem; //92C
    TabSheet9: TTabSheet; //930
    Image2: TImage; //934
    Image3: TImage; //938
    Image4: TImage; //93C
    Image5: TImage; //940
    Image6: TImage; //944
    Image7: TImage; //948
    Image13: TImage; //94C
    Image12: TImage; //950
    Image11: TImage; //954
    Image10: TImage; //958
    Image9: TImage; //95C
    Image8: TImage; //960
    Image14: TImage; //964
    Image15: TImage; //968
    Image16: TImage; //96C
    Image17: TImage; //970
    Image18: TImage; //974
    Image19: TImage; //978
    Image26: TImage; //97C
    Image25: TImage; //980
    Image24: TImage; //984
    Image23: TImage; //988
    Image22: TImage; //98C
    Image21: TImage; //990
    Image20: TImage; //994
    Label94: TLabel; //998
    Label95: TLabel; //99C
    Label96: TLabel; //9A0
    Label97: TLabel; //9A4
    Label98: TLabel; //9A8
    ColorDialog1: TColorDialog; //9AC
    Label99: TLabel; //9B0
    DBEdit19: TDBEdit; //9B4
    Label72: TLabel; //9B8
    GebDatumTaufdatum1: TMenuItem; //9BC
    N32: TMenuItem; //9C0
    SicherungsDateieinlesen2: TMenuItem; //9C4
    Button1: TButton; //9C8
    procedure listen_akt; //005F0AF0
    procedure ComboBox1Exit; //00603A50
    procedure DBLookupComboBox17Exit; //00603740
    procedure DBLookupComboBox16Exit; //006038A8
    procedure TabSheet2Exit(Sender: TObject); //00603D50
    procedure DBLookupComboBox12MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); //00603EE0
    procedure ComboBox2Exit; //00603B50
    procedure ComboBox3Exit; //00603C50
    procedure TabSheet7Enter(Sender: TObject); //006036AC
    procedure FamilienblattHTML1Click(Sender: TObject); //00602D2C
    procedure OrtsDatei1Click(Sender: TObject); //00602E00
    procedure DBEdit69Change(Sender: TObject); //00602C14
    procedure PopupMenu1Popup(Sender: TObject); //00602C34
    procedure gridanp; //005D3EF8
    procedure NamensListeeditieren1Click(Sender: TObject); //00603678
    procedure DBLookupComboBox4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); //00602F3C
    procedure DBLookupComboBox17MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); //006034D8
    procedure Einzelpersonenmarkieren1Click(Sender: TObject); //00605A2C
    procedure DBLookupComboBox4Enter; //00606D80
    procedure DBGrid3Exit(Sender: TObject); //006059B8
    procedure DBGrid3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //006059E4
    procedure DBLookupComboBox7Enter; //00606D8C
    procedure DBLookupComboBox8Enter; //00606D90
    procedure DBLookupComboBox5Enter; //00606D84
    procedure DBLookupComboBox6Enter; //00606D88
    procedure DBGrid3DblClick(Sender: TObject); //00605814
    procedure QuellenListeeditieren1Click(Sender: TObject); //00604810
    procedure Quellesuchen1Click; //00604820
    procedure DBLookupComboBox19MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); //006044C4
    procedure DBLookupComboBox19Click; //006047EC
    procedure DBComboBox3Change(Sender: TObject); //006053EC
    procedure DBComboBox3Exit(Sender: TObject); //00605754
    procedure drucken1Click(Sender: TObject); //0060482C
    procedure QRDefault; //005F0170
    procedure druck(ATitel, AUntertitel: string); //005EFF30
    procedure vorf_erm2(ANummer: Integer; AText: AnsiString; var AFlag: Integer); //00600F50
    procedure Hilfe1Click(Sender: TObject); //006023F4
    procedure GrafikI1Click(Sender: TObject); //00600D58
    procedure Grafikalt1Click(Sender: TObject); //006022BC
    procedure allePersonen3Click(Sender: TObject); //006024D0
    procedure Basisahnen1Click(Sender: TObject); //00602544
    procedure Listen; //005FBF0C
    procedure Proband1Click(Sender: TObject); //0060243C
    procedure ehtest(var s: string; epnum: Integer); //005FE42C
    procedure Adressendateischreiben1Click(Sender: TObject); //005FD964
    procedure TabSheet8Enter(Sender: TObject); //005FD9DC
    procedure Listen2Click(Sender: TObject); //005FD640
    procedure Button1Click(Sender: TObject); //005FD6A0
    procedure geschachtelt1Click(Sender: TObject); //005FE844
    procedure geb_sterb(var ergebnis: string); //005FDF68
    procedure AHNENDOSeinlesen1Click(Sender: TObject); //005FDAA4
    procedure OSBeinlesen1Click(Sender: TObject); //005FDD0C
    procedure Edit13Exit(Sender: TObject); //00602B58
    procedure PageControl1Exit(Sender: TObject); //00602BE0
    procedure Edit6Exit(Sender: TObject); //00602A48
    procedure Edit10Exit(Sender: TObject); //00602AD0
    procedure FormActivate(Sender: TObject); //00602BF0
    procedure DBCheckBox1Exit(Sender: TObject); //00602C04
    procedure ComboBox5Change(Sender: TObject); //00602BE4
    procedure DBEdit47Exit(Sender: TObject); //006028B0
    procedure DBEdit55Exit(Sender: TObject); //006029C0
    procedure aspitz(ASender: TObject); //005E4C30
    procedure pspitz(ASender: TObject); //005E4D60
    procedure spitzbas; //005E3454
    procedure basahnen(ASender: TObject); //005E4AB8
    procedure DBEdit44Exit(Sender: TObject); //00602828
    procedure DBEdit52Exit(Sender: TObject); //00602938
    procedure DBEdit40Exit(Sender: TObject); //006025B8
    procedure DBEdit7Exit(Sender: TObject); //006026F0
    procedure Quellenliste1Click(Sender: TObject); //0060E890
    procedure TabSheet1Show(Sender: TObject); //0060EAF0
    procedure fcapt; //0060E714
    procedure Fenstertitelndern1Click(Sender: TObject); //0060E888
    procedure HofnamenVerwaltung1Click(Sender: TObject); //0060EF00
    procedure Vettern1Click(Sender: TObject); //0060EF34
    procedure Verwandtschaft1Click(Sender: TObject); //0060EC94
    procedure DBEdit6Exit(Sender: TObject); //0060EDE8
    procedure EhenKiordnen1Click(Sender: TObject); //0060DDA4
    procedure ComboBox20Exit(Sender: TObject); //0060D28C
    procedure ComboBox11Exit(Sender: TObject); //0060D780
    procedure StringGrid5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); //0060C3A8
    procedure ComboBox4Exit(Sender: TObject); //0060C678
    procedure DBEdit32Exit(Sender: TObject); //0060DC84
    procedure TabSheet4Show(Sender: TObject); //0060DDA0
    procedure BerufeVerwaltung1Click(Sender: TObject); //0060DB58
    procedure DBEdit3Exit(Sender: TObject); //0060DB68
    procedure GebDatumTaufdatum1Click(Sender: TObject); //006180D8
    procedure DBComboBox1Exit(Sender: TObject); //00618254
    procedure DBEdit10Change(Sender: TObject); //006180CC
    procedure DBMemo1Exit(Sender: TObject); //006180D0
    procedure PopupMenu2Popup(Sender: TObject); //00618938
    procedure DBComboBox7Exit(Sender: TObject); //00618A30
    procedure ComboBox5Exit(Sender: TObject); //006183B8
    procedure Lb_speich(Sender: TObject); //006184B0
    procedure DBEdit9Change(Sender: TObject); //006180C8
    procedure Image2Click(Sender: TObject); //00614074
    procedure TabSheet9Show(Sender: TObject); //00615FD8
    procedure Basen1Click(Sender: TObject); //0061182C
    procedure TabSheet2Show(Sender: TObject); //00614068
    procedure DBEdit5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); //006180BC
    procedure DBEdit8Change(Sender: TObject); //006180C4
    procedure TabSheet9Exit(Sender: TObject); //00617F78
    procedure ComboBox4DblClick(Sender: TObject); //006180B8
    procedure Vorlist(Sender: TObject); //00607C78
    procedure DBLookupComboBox6KeyPress(Sender: TObject; var Key: Char); //0060746C
    procedure DBLookupComboBox7KeyPress(Sender: TObject; var Key: Char); //006074AC
    procedure DBLookupComboBox4KeyPress(Sender: TObject; var Key: Char); //006073EC
    procedure DBLookupComboBox5KeyPress(Sender: TObject; var Key: Char); //0060742C
    procedure DBLookupComboBox10KeyPress(Sender: TObject; var Key: Char); //006074FC
    procedure DBLookupComboBox11KeyPress(Sender: TObject; var Key: Char); //00607504
    procedure DBLookupComboBox8KeyPress(Sender: TObject; var Key: Char); //006074EC
    procedure DBLookupComboBox9KeyPress(Sender: TObject; var Key: Char); //006074F4
    procedure Einzelpersonen1Click(Sender: TObject); //006073B8
    procedure DBLookupComboBox11Enter; //00606D9C
    procedure DBLookupComboBox1Enter; //00606DA0
    procedure DBLookupComboBox9Enter; //00606D94
    procedure DBLookupComboBox10Enter; //00606D98
    procedure NichtverknpfteBeziehungen1Click(Sender: TObject); //00606DAC
    procedure DoppelteEintrge1Click(Sender: TObject); //00607310
    procedure DBLookupComboBox2Enter; //00606DA4
    procedure DBLookupComboBox3Enter; //00606DA8
    procedure DBLookupComboBox18KeyPress(Sender: TObject; var Key: Char); //00607704
    procedure DBLookupComboBox19KeyPress(Sender: TObject; var Key: Char); //00607744
    procedure DBLookupComboBox13KeyPress(Sender: TObject; var Key: Char); //00607684
    procedure DBLookupComboBox14KeyPress(Sender: TObject; var Key: Char); //006076C4
    procedure DBLookupComboBox22KeyPress(Sender: TObject; var Key: Char); //0060781C
    procedure bernehmen1Click(Sender: TObject); //0060785C
    procedure DBLookupComboBox20KeyPress(Sender: TObject; var Key: Char); //0060778C
    procedure DBLookupComboBox21KeyPress(Sender: TObject; var Key: Char); //006077D4
    procedure DBLookupComboBox12KeyPress(Sender: TObject; var Key: Char); //00607644
    procedure ComboBox3KeyPress(Sender: TObject; var Key: Char); //0060759C
    procedure DBLookupComboBox1KeyPress(Sender: TObject; var Key: Char); //006075E4
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char); //0060750C
    procedure ComboBox2KeyPress(Sender: TObject; var Key: Char); //00607554
    procedure DBLookupComboBox16KeyPress(Sender: TObject; var Key: Char); //006075FC
    procedure DBLookupComboBox17KeyPress(Sender: TObject; var Key: Char); //0060763C
    procedure DBLookupComboBox2KeyPress(Sender: TObject; var Key: Char); //006075EC
    procedure DBLookupComboBox3KeyPress(Sender: TObject; var Key: Char); //006075F4
    procedure DBEdit8Exit(Sender: TObject); //005E5CF0
    procedure DBEdit13Exit(Sender: TObject); //005E5E28
    procedure DBEdit22Exit(Sender: TObject); //005E5AC8
    procedure DBEdit9Exit(Sender: TObject); //005E5B50
    procedure DBEdit16Exit(Sender: TObject); //005E5F70
    procedure DBEdit21Exit(Sender: TObject); //005E60A8
    procedure DBEdit12Exit(Sender: TObject); //005E5E30
    procedure DBEdit17Exit(Sender: TObject); //005E5E38
    procedure DBEdit18Exit(Sender: TObject); //005E593C
    procedure wt35; //005D8024
    procedure wt36; //005D813C
    procedure wt33; //005D7DF4
    procedure wt34; //005D7F0C
    procedure wt39; //005D8484
    procedure DBEdit14Exit(Sender: TObject); //005E57B0
    procedure wt37; //005D8254
    procedure wt38; //005D836C
    procedure Verbindungeinfgen1Click(Sender: TObject); //005E844C
    procedure DBGrid2DblClick(Sender: TObject); //005E89E8
    procedure Kinderentfernen1Click(Sender: TObject); //005E7870
    procedure Kindereinfgen1Click(Sender: TObject); //005E7A14
    procedure StringGrid3Click(Sender: TObject); //005E9118
    procedure TabSheet4Exit(Sender: TObject); //005E9330
    procedure TabSheet7MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); //005E8F94
    procedure TabSheet4Enter(Sender: TObject); //005E8FC4
    procedure beenden1Click(Sender: TObject); //005E7844
    procedure TabSheet1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); //005E62D4
    procedure ucase(aansistring:ansistring;var aergebnis:ansistring); //005D7AA8
    procedure DBEdit20Exit(Sender: TObject); //005E60B0
    procedure Verbindunglschen1Click(Sender: TObject); //005E60B8
    procedure StringGrid4DblClick(Sender: TObject); //005E7654
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //005E7728
    procedure TabSheet5Enter(Sender: TObject); //005E683C
    procedure geschw(ANummer, AVater: Integer; AMutter, AVater2: Integer;
      AArt, AText: string; var A1, A2: string; var A3: Integer); //005E6304
    procedure datcheck(p1, p2, p3: string); //005D859C
    procedure kinderanz; //005D6E2C
    procedure eltanz; //005D76D0
    procedure StringGrid1DblClick(Sender: TObject); //005D93E8
    procedure StringGrid2DblClick(Sender: TObject); //005D94C0
    procedure Edit1DblClick(Sender: TObject); //005DCBD4
    procedure Edit2DblClick(Sender: TObject); //005DCC94
    procedure DatensatzNr1Click(Sender: TObject); //005D9598
    procedure Prfen1Click(Sender: TObject); //005D9778
    procedure DBNavigator1Click(Sender: TObject); //005D93B8
    procedure neu1Click(Sender: TObject); //005D8B60
    procedure speich1; //005D78BC
    procedure FormCreate(Sender: TObject); //005D4E28
    procedure FormClose(sender:tobject;var action:tcloseaction); //005D879C
    procedure ehenanz; //005D6604
    procedure FormShow(Sender: TObject); //005D92AC
    procedure schen1Click(Sender: TObject); //005D8E30
    procedure DBNavigator1BeforeAction(Sender: TObject; Button: TNavigateBtn); //005D92A4
    procedure DBGrid1DblClick(Sender: TObject); //005E2C2C
    procedure anzeigen; //005D42BC
    procedure FormKeyPress(Sender: TObject; var Key: Char); //005E28AC
    procedure TabSheet6Enter(Sender: TObject); //005E28CC
    procedure IDslschen1Click(Sender: TObject); //005E53B4
    procedure DBEdit10Exit(Sender: TObject); //005E5624
    procedure TabSheet1Exit(Sender: TObject); //005E4FB0
    procedure IDSatznr1Click(Sender: TObject); //005E4FC4
    procedure Datenlschen1Click(Sender: TObject); //005E2064
    procedure Sikoein; //005DF5EC
    procedure tabdisab; //005D8754
    procedure lab18ein; //005D8704
    procedure datsich; //005DCD54
    procedure Datensichern1Click(Sender: TObject); //005E1DC0
    procedure alineu(AAnsiString: AnsiString); //005E1DF8
    procedure tabenab; //005D8778
    procedure SicherungsDateieinlesen1Click(Sender: TObject); //005E1D2C
    procedure ChristlicheNamenstage1Click(Sender: TObject); //005FA138
    procedure FamGrafik1Click(Sender: TObject); //005FA868
    procedure famblattx_daten; //005F2F6C
    procedure Osterberechnung1Click(Sender: TObject); //005FA0EC
    procedure entfernen1Click(Sender: TObject); //005FAFD4
    procedure Listenaktualisieren1Click(Sender: TObject); //005FB1A0
    procedure einfgen1Click(Sender: TObject); //005FA898
    procedure UpDown1Click(Sender: TObject; AButton: TUDBtnType); //005FAC9C
    procedure FamblHTML; //005F53E4
    procedure allePersonen1Click(Sender: TObject); //005F0AA4
    procedure Probandenname1Click(Sender: TObject); //005F26E0
    procedure StringGrid2RowMoved(Sender: TObject; FromIndex, ToIndex: Longint); //005EFD84
    procedure frbestimmtenOrt1Click(Sender: TObject); //005F02D8
    procedure Browser1Click; //005F2F00
    procedure FormResize(Sender:TObject); //005F2F3C
    procedure allePersonen2Click(Sender: TObject); //005F2E20
    procedure Browser(AUrl: AnsiString); //005F2E6C
    procedure OFBDruck1Click(Sender: TObject); //005FC700
    procedure alleBilderentfernen1Click(Sender: TObject); //005FCB20
    procedure sdx(const AnInput: AnsiString; var AResult: AnsiString); //005D34D8
    procedure FOKODateieditieren1Click(Sender: TObject); //005FC67C
    procedure GedcomDateieinlesen1Click(Sender: TObject); //005FCDA0
    procedure GedcomDateischreiben1Click(Sender: TObject); //005FD330
    procedure bild_entf; //005FC794
    procedure bmpjpg1Click(Sender: TObject); //005FCC0C
    procedure inyTafelerstellen1Click(Sender: TObject); //005FC5B0
    procedure Familienblatt2Click(Sender: TObject); //005FB580
    procedure Famblatt; //005FB604
    procedure Grafik1Click(Sender: TObject); //005FB294
    procedure Grafikneu1Click(Sender: TObject); //005FB3CC
    procedure Liste1Click(Sender: TObject); //005FBEAC
    procedure FOKODateierstellen1Click(Sender: TObject); //005FC4F0
    procedure showpreview(Page: Integer); //005FBD5C
    procedure GlobaleSuche1Click(Sender: TObject); //005FBD98
    procedure StringGrid1RowMoved(Sender: TObject; FromIndex, ToIndex: Longint); //005EFBF4
    procedure PopupMenu3Popup(Sender: TObject); //005EB760
    procedure PopupMenu4Popup(Sender: TObject); //005EB870
    procedure elem(art: AnsiString); //005E8284
    procedure elem_leer; //005E81BC
    procedure Vatereinfgen1Click(Sender: TObject); //005EBB58
    procedure Muttereinfgen1Click(Sender: TObject); //005EBEB0
    procedure Vaterentfernen1Click(Sender: TObject); //005EB980
    procedure Mutterentfernen1Click(Sender: TObject); //005EBA6C
    procedure DBEdit2Exit(Sender: TObject); //005EB534
    procedure aus1Click(Sender: TObject); //005E9B54
    procedure Datenschutzein1Click(Sender: TObject); //005E9D04
    procedure roem(anummer:integer;var aergebnis:ansistring); //005E2CA4
    procedure ID1Click(Sender: TObject); //005E98B0
    procedure DBEdit33Exit(Sender: TObject); //005EB1C4
    procedure TabSheet3Enter(Sender: TObject); //005EB350
    procedure Datenschutzaus1Click(Sender: TObject); //005EA0B0
    procedure TabSheet3Exit(Sender: TObject); //005EA2B8
    procedure anzeigen1Click(Sender: TObject); //005EF6DC
    procedure GregorianischerKalender1Click(Sender: TObject); //005EF700
    procedure StringGrid5KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); //005EF604
    procedure StringGrid5DblClick(Sender: TObject); //005EF620
    procedure Hausname1Click(Sender: TObject); //005EF944
    procedure drucken2Click; //005D3ED0
    procedure FrzRevolutionskalender1Click(Sender: TObject); //005EF778
    procedure zuAHNENWIN1Click(Sender: TObject); //005EF7F0
    procedure Partnersuche1Click(Sender: TObject); //005EED2C
    procedure DBEdit45Exit(Sender: TObject); //005EC2E4
    procedure DBEdit63Exit(Sender: TObject); //005EC36C
    procedure TabSheet2Enter(Sender: TObject); //005EC208
    procedure DBEdit37Exit(Sender: TObject); //005EC25C
    procedure Bildschirmdrucken1Click(Sender: TObject); //005EC6C4
    procedure ExcelExport1Click(Sender: TObject); //005EC774
    procedure Name1Click(Sender: TObject); //005EC3F4
    procedure Druckereinstellung1Click(Sender: TObject); //005EC69C
  end;

var
  Form1: TForm1;

implementation

uses
  AHNGlobals, Windows, Messages, Printers, Graphics, StrUtils, QuickRpt, QRCtrls, Unit2, Unit3,
  Unit4, Unit5, Unit8, Unit9, Unit10, Unit11, Unit12, Unit13, Unit14, Unit15, Unit16, Unit20,
  Unit21, Unit22, Unit24, Unit28, Unit29, Unit36, Unit39, Unit18, Unit7, Unit6, Unit19, Unit17, Unit35, Unit33, Unit26;
{$R ..\Forms\Form1.DFM}

{ The local function of the original at the address 005D3148. It writes a
  number into six characters; the digits are filled up with zeros on the
  left. A number with more than six digits is cut off on the left. The
  original has no name for it, IDR lists it as sub_005D3148. }
function zahl6(n: Integer): string;
var
  s: string;
begin
  s := '000000' + IntToStr(n);
  Result := Copy(s, Length(s) - 5, 6);
end;

{ The local function of the original at the address 005D31EC. It brings a
  date into the form that the program uses. The original has no name for
  it, IDR lists it as sub_005D31EC. }
procedure datumNormalisieren(const datum: AnsiString; var ergebnis: AnsiString);
var
  s: string;
  i: Integer;
begin
  ergebnis := datum;
  if Trim(datum) = '..' then
  begin
    ergebnis := '';
    Exit;
  end;
  if Copy(datum, 1, 2) = 'HK' then
  begin
    ergebnis := 'HK ' + Copy(datum, 4, 7);
    Exit;
  end;
  if Pos('vo.r', datum) > 0 then
  begin
    ergebnis := Copy(datum, 1, 2) + Copy(datum, 4, 1) + ' ' + RightStr(datum, 4);
    Exit;
  end;
  if Pos('na.ch', datum) > 0 then
  begin
    ergebnis := Copy(datum, 1, 2) + Copy(datum, 4, 2) + ' ' + RightStr(datum, 4);
    Exit;
  end;
  if Trim(datum) = '' then
    Exit;

  { A prefix of the form "x. " is removed. }
  s := datum;
  ergebnis := '';
  while Pos(Copy(s, 1, 1) + '. ', s) > 0 do
    s := Copy(s, 2, 9);

  if s[1] > '9' then
  begin
    { The points are removed and a blank is set in front of the first
      letter. }
    ergebnis := '';
    for i := 1 to Length(s) do
      if s[i] <> '.' then
        ergebnis := ergebnis + s[i];
    for i := 1 to Length(ergebnis) do
      if ergebnis[i] < ':' then
      begin
        Insert(' ', ergebnis, i);
        Break;
      end;
  end
  else
    ergebnis := s;
end;

{ The local function of the original at the address 005D96D8. It writes a
  line into the grid with the relationships that are not linked: the name
  of the person goes into the first column, the number of the person into
  the second column.  The counter of the lines is increased.  The original
  has no name for it, IDR lists it as sub_005D96D8. }
procedure gitterZeile(name, nummer: string; var anzahl: Integer);
begin
  Inc(anzahl);
  Form1.StringGrid5.RowCount := Form1.StringGrid5.RowCount + 1;
  Form1.StringGrid5.Cells[0, anzahl] := name;
  Form1.StringGrid5.Cells[1, anzahl] := nummer;
end;


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

{ The local function of the original at the address 005D3A70. It computes
  the age of a person at the day of the wedding. The result is written
  into the variable "ergebnis", the fourth parameter of the function; the
  original has no result of its own. The forward declaration is needed
  because the methods that call it come first in this file. }
procedure altersberechnung(gebtag, gebmonat, gebjahr: string; var ergebnis: string;
  stjahr, stmonat, sttag, taufjahr, taufmonat, tauftag: string); forward;

{ The local function of the original at the address 005D7C50. It reads a
  date in the German notation "day.month.year" and returns the name of
  the weekday. An empty string is returned when the date cannot be read.
  The original has no name for it, IDR lists it as sub_005D7C50. }
procedure Wochentag(datum: AnsiString; var ergebnis: AnsiString);
var
  d: TDateTime;
  ok: Boolean;
begin
  ergebnis := '';
  ok := True;
  try
    d := StrToDate(datum);
  except
    ok := False;
  end;
  if ok then
    case DayOfWeek(d) of
      1: ergebnis := 'So';
      2: ergebnis := 'Mo';
      3: ergebnis := 'Di';
      4: ergebnis := 'Mi';
      5: ergebnis := 'Do';
      6: ergebnis := 'Fr';
      7: ergebnis := 'Sa';
    end;
end;

procedure TForm1.listen_akt;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.ComboBox1Exit;
begin
  //00603A50: Der Text des Feldes beginnt mit einem Grossbuchstaben.
  if Trim(ComboBox1.Text) <> '' then
    ComboBox1.Text := UpperCase(Copy(ComboBox1.Text, 1, 1)) +
                      Copy(ComboBox1.Text, 2, Length(ComboBox1.Text));
end;

procedure TForm1.DBLookupComboBox17Exit;
begin
  //00603740: Die Nummer eines geloeschten Datensatzes wieder benutzen.
  if Trim(ComboBox10.Text) <> '' then
  begin
    if DataModule2.Table1Nummer.AsInteger - 1 < 0 then
    begin
      DataModule2.Table1.Edit;
      DataModule2.Table4.First;
      if DataModule2.Table4.RecordCount > 0 then
      begin
        if DataModule2.Table4Num.AsInteger > 0 then
        begin
          DataModule2.Table1Nummer.AsInteger := DataModule2.Table4Num.AsInteger;
          DataModule2.Table4.Delete;
          if DataModule2.Table1Nummer.AsInteger > gvar_02536944 then
            gvar_02536944 := DataModule2.Table1Nummer.AsInteger;
        end;
      end
      else
      begin
        DataModule2.Table1Nummer.AsInteger := gvar_02536944 + 1;
        Inc(gvar_02536944);
      end;
    end;
  end;
end;

procedure TForm1.DBLookupComboBox16Exit;
begin
  //006038A8: Die Nummer eines geloeschten Datensatzes wieder benutzen
  //und neu1 aktivieren, wenn ComboBox10 einen Eintrag hat.
  if Trim(ComboBox4.Text) <> '' then
  begin
    if DataModule2.Table1Nummer.AsInteger - 1 < 0 then
    begin
      DataModule2.Table1.Edit;
      DataModule2.Table4.First;
      if DataModule2.Table4.RecordCount > 0 then
      begin
        if DataModule2.Table4Num.AsInteger > 0 then
        begin
          DataModule2.Table1Nummer.AsInteger := DataModule2.Table4Num.AsInteger;
          DataModule2.Table4.Delete;
          if DataModule2.Table1Nummer.AsInteger > gvar_02536944 then
            gvar_02536944 := DataModule2.Table1Nummer.AsInteger;
        end;
      end
      else
      begin
        DataModule2.Table1Nummer.AsInteger := gvar_02536944 + 1;
        Inc(gvar_02536944);
      end;
    end;
  end;
  if Trim(ComboBox10.Text) <> '' then
    neu1.Enabled := True;
end;

procedure TForm1.TabSheet2Exit(Sender: TObject);
begin
  { The number of the person that is worked on is remembered, so that it
    can be looked for again later. }
  if DataModule2.Table1Nummer.AsInteger > 0 then
    gvar_02536910 := DataModule2.Table1Nummer.AsInteger;

  DataModule2.Table1.Edit;

  { A source that is empty is written as an empty string, so that the
    index of the table is updated. }
  if Trim(DataModule2.Table1Quelle.AsString) = '' then
    DataModule2.Table1Quelle.AsString := '';
  if Trim(DataModule2.Table1Quelleg.AsString) = '' then
    DataModule2.Table1Quelleg.AsString := '';
  if Trim(DataModule2.Table1Quellet.AsString) = '' then
    DataModule2.Table1Quellet.AsString := '';
  if Trim(DataModule2.Table1Quelles.AsString) = '' then
    DataModule2.Table1Quelles.AsString := '';
  if Trim(DataModule2.Table1Quelleb.AsString) = '' then
    DataModule2.Table1Quelleb.AsString := '';

  DataModule2.Table1.Post;
  gvar_0253692C := '';
end;

procedure TForm1.DBLookupComboBox12MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  bezeichnung, quelle: string;
  anzahl: Integer;
begin
  { The right mouse button opens an input window in which a new source
    can be entered.  The source is added to the table of the sources if
    it is not yet known.  The number of the source is written into the
    field of the record that belongs to the combo box.

    The original counts the sources that are newly added only; the
    number is therefore 0 if the source was already known. }
  bezeichnung := '';
  quelle := '';
  anzahl := 0;
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;
  DataModule2.Table5.Open;

  if Sender = ComboBox11 then
    bezeichnung := 'Neue Quelle (allgemein)'
  else if Sender = ComboBox12 then
    bezeichnung := 'Neue Quelle (Geburt)'
  else if Sender = ComboBox13 then
    bezeichnung := 'Neue Quelle (Taufe)'
  else if Sender = ComboBox14 then
    bezeichnung := 'Neue Quelle (Tod)'
  else if Sender = ComboBox15 then
    bezeichnung := 'Neue Quelle (Bestattung)'
  else if Sender = ComboBox23 then
    bezeichnung := 'Neue Quelle (Heirat (Kirche))'
  else if Sender = ComboBox24 then
    bezeichnung := 'Neue Quelle (Heirat (Standesamt))'
  else if Sender = ComboBox25 then
    bezeichnung := 'Neue Quelle (Scheidung)';

  if Button = mbRight then
  begin
    if InputQuery(bezeichnung, 'Quelle: ', quelle) then
      if Trim(quelle) <> '' then
      begin
        if not DataModule2.Table38.FindKey([quelle]) then
        begin
          Inc(anzahl);
          DataModule2.Table38.Append;
          DataModule2.Table38Titel.AsString := quelle;
          DataModule2.Table38.Post;
        end;

        if Sender = ComboBox12 then
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Quelleg.AsString := IntToStr(anzahl);
          DataModule2.Table1.Post;
        end
        else if Sender = ComboBox13 then
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Quellet.AsString := IntToStr(anzahl);
          DataModule2.Table1.Post;
        end
        else if Sender = ComboBox14 then
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Quelles.AsString := IntToStr(anzahl);
          DataModule2.Table1.Post;
        end
        else if Sender = ComboBox15 then
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Quelleb.AsString := IntToStr(anzahl);
          DataModule2.Table1.Post;
        end
        else if Sender = ComboBox11 then
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Quelle.AsString := IntToStr(anzahl);
          DataModule2.Table1.Post;
        end
        else if Sender = ComboBox23 then
        begin
          DataModule2.Table5.Edit;
          DataModule2.Table5Hqu.AsString := IntToStr(anzahl);
          DataModule2.Table5.Post;
        end
        else if Sender = ComboBox24 then
        begin
          DataModule2.Table5.Edit;
          DataModule2.Table5Saqu.AsString := IntToStr(anzahl);
          DataModule2.Table5.Post;
        end
        else if Sender = ComboBox25 then
        begin
          DataModule2.Table5.Edit;
          DataModule2.Table5Schqu.AsString := IntToStr(anzahl);
          DataModule2.Table5.Post;
        end;
      end;
  end;
end;

procedure TForm1.ComboBox2Exit;
begin
  { The text of the field is written with a capital first letter. }
  if Trim(ComboBox2.Text) <> '' then
    ComboBox2.Text := UpperCase(Copy(ComboBox2.Text, 1, 1)) +
                      Copy(ComboBox2.Text, 2, Length(ComboBox2.Text));
end;

procedure TForm1.ComboBox3Exit;
begin
  { The text of the field is written with a capital first letter. }
  if Trim(ComboBox3.Text) <> '' then
    ComboBox3.Text := UpperCase(Copy(ComboBox3.Text, 1, 1)) +
                      Copy(ComboBox3.Text, 2, Length(ComboBox3.Text));
end;

procedure TForm1.TabSheet7Enter(Sender: TObject);
begin
  { The list of the names is read again. }
  DataModule2.Table9.Refresh;
  DataModule2.Table9.Open;
  DBGrid2.DataSource := DataModule2.DataSource9;
  DataModule2.Table9.IndexName := 'namgeb';
  DataModule2.Table9.Open;
  DBGrid2.Refresh;
  DBGrid2.SetFocus;
end;

procedure TForm1.FamilienblattHTML1Click(Sender: TObject);
begin
  { 00602D2C: Familienblatt erzeugen, aber als HTML-Datei (fambl.htm)
    statt als QuickRep-Formulare. Zuerst werden die Hilfs-Globalen
    geleert, die Auswahl in Form17 erscheint und dann wird die
    HTML-Ausgabe angestossen. }
  gvar_0253692C := 'Fbml';
  gvar_02536B58 := '';
  gvar_02536B38 := '';
  gvar_02536B3C := '';
  gvar_02536B40 := '';
  gvar_02536B44 := '';
  gvar_02536B48 := '';
  gvar_02536B4C := '';
  aus1.Click;
  if FileExists('fambl.htm') then
    DeleteFile('fambl.htm');
  Form17.CheckBox16.Show;
  Form17.CheckBox5.Show;
  Form17.ShowModal;
end;

procedure TForm1.OrtsDatei1Click(Sender: TObject);
begin
  { 00602E00: Orts-Abfrage in Form14 bzw. Anzeige des "Aktuellen
    Orts-Namens" in Form33 wenn der globale gvar_02536B60 gesetzt ist
    und in Table13 einen Treffer liefert. }
  DataModule2.Table13.Open;
  DataModule2.Table13.IndexName := 'ort_';
  DataModule2.Table13.First;
  if Trim(gvar_02536B60) <> '' then
  begin
    if DataModule2.Table13.FindKey([gvar_02536B60]) then
    begin
      Form33.Label12.Caption := 'Aktueller Orts-Name: ' + gvar_02536B60;
      Form33.Show;
    end;
  end
  else
    Form14.ShowModal;
  gvar_02536B60 := '';
end;

procedure TForm1.DBEdit69Change(Sender: TObject);
begin
  gvar_0061F0A0 := '';

  gvar_0061F0A4 := '';

  gvar_02536B58 := '';

end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  { The entries of the menu are only enabled when a person is worked on
    and a person is marked in the list. }
  PopupMenu1.Items[0].Enabled := False;
  PopupMenu1.Items[1].Enabled := False;
  if DataModule2.Table1Nummer.AsInteger > 0 then
  begin
    PopupMenu1.Items[0].Enabled := True;
    PopupMenu1.Items[1].Enabled := False;
    if Trim(StringGrid1.Cells[1, 0]) <> '' then
      PopupMenu1.Items[1].Enabled := True;
  end;
end;

procedure TForm1.gridanp;
begin
  { The widths of the columns of the five grids are a part of the width of
    the grid; they are recalculated when the form is shown. }
  StringGrid1.ColWidths[1] := Round(StringGrid1.Width * 1.3 / 10);
  StringGrid1.ColWidths[2] := Round(StringGrid1.Width * 4.5 / 10);
  StringGrid1.ColWidths[3] := Round(StringGrid1.Width * 1.1 / 10);
  StringGrid1.ColWidths[4] := Round(StringGrid1.Width * 1.1 / 10);
  StringGrid1.ColWidths[5] := Round(StringGrid1.Width * 1.4 / 10);

  StringGrid2.ColWidths[1] := Round(StringGrid2.Width * 1.3 / 10);
  StringGrid2.ColWidths[2] := Round(StringGrid2.Width * 4.5 / 10);
  StringGrid2.ColWidths[3] := Round(StringGrid2.Width * 1.1 / 10);
  StringGrid2.ColWidths[4] := Round(StringGrid2.Width * 1.1 / 10);
  StringGrid2.ColWidths[5] := Round(StringGrid2.Width * 1.4 / 10);

  StringGrid3.ColWidths[0] := Round(StringGrid3.Width * 1.3 / 10);
  StringGrid3.ColWidths[1] := Round(StringGrid3.Width * 4.5 / 10);
  StringGrid3.ColWidths[2] := Round(StringGrid3.Width * 1.2 / 10);
  StringGrid3.ColWidths[3] := Round(StringGrid3.Width * 1.2 / 10);
  StringGrid3.ColWidths[4] := Round(StringGrid3.Width * 1.5 / 10);

  StringGrid4.ColWidths[0] := Round(StringGrid4.Width * 1.3 / 10);
  StringGrid4.ColWidths[1] := Round(StringGrid4.Width * 4.5 / 10);
  StringGrid4.ColWidths[2] := Round(StringGrid4.Width * 1.2 / 10);
  StringGrid4.ColWidths[3] := Round(StringGrid4.Width * 1.2 / 10);
  StringGrid4.ColWidths[4] := Round(StringGrid4.Width * 1.5 / 10);

  StringGrid5.ColWidths[0] := Round(StringGrid5.Width * 1.3 / 10);
  StringGrid5.ColWidths[1] := Round(StringGrid5.Width * 5.3 / 10);
  StringGrid5.ColWidths[2] := Round(StringGrid5.Width * 1.2 / 10);
  StringGrid5.ColWidths[3] := Round(StringGrid5.Width * 1.6 / 10);
end;

procedure TForm1.NamensListeeditieren1Click(Sender: TObject);
begin
  DataModule2.Table12.Open;

  DataModule2.Table12.First;

  Form28.ShowModal;

end;

procedure TForm1.DBLookupComboBox4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  bezeichnung: string;
begin
  { The right mouse button opens an input window in which a new place
    can be entered.  The place is added to the table of the places if it
    is not yet known and is then written into the field of the record
    that belongs to the combo box the mouse click was made in. }
  gvar_02536B5C := '';
  bezeichnung := '';
  DataModule2.Table13.Open;
  DataModule2.Table5.Open;

  if (Sender = ComboBox6) or (Sender = ComboBox16) then
    bezeichnung := 'Neuer Ort (Geburt)'
  else if (Sender = ComboBox7) or (Sender = ComboBox17) then
    bezeichnung := 'Neuer Ort (Taufe)'
  else if (Sender = ComboBox8) or (Sender = ComboBox18) then
    bezeichnung := 'Neuer Ort (Tod)'
  else if (Sender = ComboBox9) or (Sender = ComboBox19) then
    bezeichnung := 'Neuer Ort (Bestattung)'
  else if Sender = ComboBox20 then
    bezeichnung := 'Neuer Ort (Heirat Kirche)'
  else if Sender = ComboBox21 then
    bezeichnung := 'Neuer Ort (Heirat Standesamt)'
  else if Sender = ComboBox22 then
    bezeichnung := 'Neuer Ort (Scheidung)'
  else if Sender = ComboBox26 then
    bezeichnung := 'Neuer Ort (Adresse)';

  if Button = mbRight then
  begin
    if InputQuery(bezeichnung, 'Ortsname: ', gvar_02536B5C) then
      if Trim(gvar_02536B5C) <> '' then
      begin
        if not DataModule2.Table13.FindKey([gvar_02536B5C]) then
        begin
          DataModule2.Table13.Append;
          DataModule2.Table13Ort.AsString := gvar_02536B5C;
          DataModule2.Table13.Post;
        end;

        if (Sender = ComboBox6) or (Sender = ComboBox16) then
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Gebort.AsString := gvar_02536B5C;
          DataModule2.Table1.Post;
        end
        else if (Sender = ComboBox7) or (Sender = ComboBox17) then
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Taufort.AsString := gvar_02536B5C;
          DataModule2.Table1.Post;
        end
        else if (Sender = ComboBox8) or (Sender = ComboBox18) then
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Stort.AsString := gvar_02536B5C;
          DataModule2.Table1.Post;
        end
        else if (Sender = ComboBox9) or (Sender = ComboBox19) then
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Begort.AsString := gvar_02536B5C;
          DataModule2.Table1.Post;
        end
        else if (Sender = ComboBox1) or (Sender = ComboBox20) then
        begin
          DataModule2.Table5.Edit;
          DataModule2.Table5Hort.AsString := gvar_02536B5C;
          DataModule2.Table5.Post;
        end
        else if (Sender = ComboBox2) or (Sender = ComboBox21) then
        begin
          DataModule2.Table5.Edit;
          DataModule2.Table5Saort.AsString := gvar_02536B5C;
          DataModule2.Table5.Post;
        end
        else if (Sender = ComboBox3) or (Sender = ComboBox22) then
        begin
          DataModule2.Table5.Edit;
          DataModule2.Table5Schort.AsString := gvar_02536B5C;
          DataModule2.Table5.Post;
        end
        else if Sender = ComboBox26 then
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Ort.AsString := gvar_02536B5C;
          DataModule2.Table1.Post;
        end;
      end;
  end;
end;

procedure TForm1.DBLookupComboBox17MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  bezeichnung, name: string;
  naechste: TWinControl;
begin
  { The right mouse button opens an input window in which a new name can
    be entered.  The name is added to the table of the names if it is not
    yet known, is written into the record and the focus is moved to the
    next control. }
  bezeichnung := '';
  name := '';
  DataModule2.Table12.Open;
  DataModule2.Table5.Open;
  bezeichnung := 'Neuer Name';

  if Button = mbRight then
  begin
    if InputQuery(bezeichnung, 'Name: ', name) then
      if Trim(name) <> '' then
      begin
        if not DataModule2.Table12.FindKey([name]) then
        begin
          DataModule2.Table12.Append;
          DataModule2.Table12Name.AsString := name;
          DataModule2.Table12.Post;
        end;

        DataModule2.Table1.Edit;
        DataModule2.Table1Name.AsString := name;
        DataModule2.Table1.Post;

        { The original uses SetActiveControl, which is private in
          Delphi 9; the focus is set to the same control. }
        naechste := FindNextControl(ActiveControl, True, True, False);
        if naechste <> nil then
          naechste.SetFocus;
      end;
  end;
end;

procedure TForm1.Einzelpersonenmarkieren1Click(Sender: TObject);
var
  s, s2, s3, s4, s5, s6: string;
  anzahl, laufnummer, personennummer, zeilen: Integer;
begin
  { The persons that have no parents, no children and no marriage are
    collected; they are shown in the grid.  In the mode "Dopp" the
    persons whose name is written more than once are collected and
    written into the table of the report.

    The list of the pairs of parents is not filled in the original, so
    that a pair can appear twice in the grid. }
  if gvar_0253692C <> 'Dopp' then
    gvar_0253692C := 'Einz';
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  speich1;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  s := 'J';
  DataModule2.Table14.Open;
  DataModule2.Table14.Close;
  DataModule2.Table14.EmptyTable;
  DataModule2.Table14.Open;
  personennummer := DataModule2.Table1Nummer.AsInteger;
  DataModule2.Table1.IndexName := 'namgeb';
  tabdisab;
  DataModule2.Table1.First;
  DataModule2.Table17.Open;
  DataModule2.Table17.Refresh;
  laufnummer := 1;
  s2 := '';
  s3 := '';
  anzahl := 0;
  zeilen := 0;
  Label19.Caption := 'Einzelpers.ermitt. ';
  if gvar_0253692C = 'Dopp' then
    Label19.Caption := 'Mehrfach-Eintr.ermitt. ';
  lab18ein;
  StringGrid5.RowCount := 1;
  StringGrid5.Cells[1, 0] := 'Einzelpersonen';

  if gvar_0253692C = 'Einz' then
  begin
    DataModule2.Table1.First;
    while not DataModule2.Table1.Eof do
    begin
      Label18.Caption := IntToStr(laufnummer);
      Label18.Refresh;
      Inc(laufnummer);
      DataModule2.Table17.IndexName := '';
      if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'M' then
        DataModule2.Table17.IndexName := 'vat'
      else if UpperCase(DataModule2.Table1Geschlecht.AsString) = 'W' then
        DataModule2.Table17.IndexName := 'mut';
      tabenab;

      { The person must have no father, no mother, no entry in the table
        of the children and no marriage. }
      if (DataModule2.Table1Vater.AsInteger - 1 < 0) and
         (DataModule2.Table1Mutter.AsInteger - 1 < 0) and
         (not DataModule2.Table17.FindKey([DataModule2.Table1Nummer.AsInteger])) and
         (DataModule2.Table5.RecordCount = 0) then
      begin
        DataModule2.Table17.IndexName := '';
        DataModule2.Table17.FindKey([DataModule2.Table1Nummer.AsInteger]);
        if Trim(DataModule2.Table17Kistat.AsString) = '' then
          try
            ucase(DataModule2.Table17Name.AsString, s5);
            geb_sterb(s6);
            gitterZeile(s5 + ' ' + DataModule2.Table17Vornamen.AsString + ', ' +
              DataModule2.Table17Beruf.AsString + ' ' + s6,
              IntToStr(DataModule2.Table17Nummer.AsInteger), zeilen);
          except
          end;
      end;
      tabdisab;
      DataModule2.Table1.Next;
    end;
  end
  else if gvar_0253692C = 'Dopp' then
  begin
    DataModule2.Table1.First;
    while not DataModule2.Table1.Eof do
    begin
      s4 := '';
      try
        Label18.Caption := IntToStr(laufnummer);
        Label18.Refresh;
        Inc(laufnummer);

        { The fields that are wanted are added to the text. }
        if gvar_02536B68 = 1 then
          s4 := s4 + ' * ' + DataModule2.Table1Gebjahr.AsString;
        if gvar_02536B6C = 1 then
          s4 := s4 + ' ' + Trim(DataModule2.Table1Gebort.AsString);
        if gvar_02536B70 = 1 then
          s4 := s4 + ' ~ ' + DataModule2.Table1Taufjahr.AsString;
        if gvar_02536B74 = 1 then
          s4 := s4 + ' ' + DataModule2.Table1Taufort.AsString;
        if gvar_02536B78 = 1 then
          s4 := s4 + ' + ' + DataModule2.Table1Stjahr.AsString;
        if gvar_02536B7C = 1 then
          s4 := s4 + ' ' + DataModule2.Table1Stort.AsString;
        if gvar_02536B80 = 1 then
          s4 := s4 + ' # ' + DataModule2.Table1Begjahr.AsString;
        if gvar_02536B84 = 1 then
          s4 := s4 + ' ' + DataModule2.Table1Begort.AsString;
        if gvar_02536B88 = 1 then
          s4 := s4 + ' ' + DataModule2.Table1Beruf.AsString;
        if gvar_02536B8C = 1 then
          s4 := s4 + ' ' + DataModule2.Table1IDNR.AsString;

        if (Trim(DataModule2.Table1Name.AsString) <> '') and
           (Trim(DataModule2.Table1Name.AsString) <> 'NN') and
           (Trim(DataModule2.Table1Name.AsString) <> '?') then
        begin
          ucase(DataModule2.Table1Name.AsString, s5);
          if s5 + ' ' + DataModule2.Table1Vornamen.AsString + s4 = s2 then
          begin
            { The person was written before: the first entry gets the
              number of the person that was found first. }
            if anzahl = 0 then
            begin
              DataModule2.Table14.Append;
              DataModule2.Table14Zeile.AsString := '(' + s3 + ') ' + s2;
              DataModule2.Table14.Post;
            end;
            DataModule2.Table14.Append;
            ucase(DataModule2.Table1Name.AsString, s6);
            DataModule2.Table14Zeile.AsString := '(' +
              IntToStr(DataModule2.Table1Nummer.AsInteger) + ') ' + s6 + ' ' +
              DataModule2.Table1Vornamen.AsString + s4;
            DataModule2.Table14.Post;
            anzahl := 1;
          end
          else
            anzahl := 0;
        end;

        { The text of the person is kept for the comparison with the next
          person. }
        ucase(DataModule2.Table1Name.AsString, s5);
        s2 := s5 + ' ' + DataModule2.Table1Vornamen.AsString;
        if gvar_02536B68 = 1 then
          s2 := s2 + ' * ' + DataModule2.Table1Gebjahr.AsString;
        if gvar_02536B6C = 1 then
          s2 := s2 + ' ' + Trim(DataModule2.Table1Gebort.AsString);
        if gvar_02536B70 = 1 then
          s2 := s2 + ' ~ ' + DataModule2.Table1Taufjahr.AsString;
        if gvar_02536B74 = 1 then
          s2 := s2 + ' ' + DataModule2.Table1Taufort.AsString;
        if gvar_02536B78 = 1 then
          s2 := s2 + ' + ' + DataModule2.Table1Stjahr.AsString;
        if gvar_02536B7C = 1 then
          s2 := s2 + ' ' + DataModule2.Table1Stort.AsString;
        if gvar_02536B80 = 1 then
          s2 := s2 + ' # ' + DataModule2.Table1Begjahr.AsString;
        if gvar_02536B84 = 1 then
          s2 := s2 + ' ' + DataModule2.Table1Begort.AsString;
        if gvar_02536B88 = 1 then
          s2 := s2 + ' ' + DataModule2.Table1Beruf.AsString;
        if gvar_02536B8C = 1 then
          s2 := s2 + ' ' + DataModule2.Table1IDNR.AsString;
        s3 := IntToStr(DataModule2.Table1Nummer.AsInteger);
      except
      end;
      DataModule2.Table1.Next;
    end;
  end;

  Label18.Visible := False;
  Label19.Visible := False;
  tabenab;
  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.FindKey([personennummer]);
  if gvar_0253692C = 'Einz' then
  begin
    StringGrid5.Visible := True;
    Exit;
  end;
  if DataModule2.Table14.RecordCount <= 0 then
  begin
    ShowMessage('Keine Treffer gefunden.');
    Exit;
  end;

  { The report is prepared. }
  Form16.SpeedButton3.Visible := True;
  Form16.SpeedButton6.Visible := False;
  QRDefault;
  Form15.QRMemo1.Lines.Clear;
  Form15.QRDBText1.DataField := '';
  Form15.QRDBText2.DataField := '';
  Form15.QuickRep1.DataSet := DataModule2.Table14;
  Form15.QRDBText1.DataSet := DataModule2.Table14;
  Form15.QRDBText1.DataField := 'zeile';
  Form15.QRDBText1.Enabled := True;
  Form15.QRDBText2.Enabled := True;
  Form15.QRDBText1.Font.Name := 'Arial';
  Form15.QRDBText2.Font.Name := 'Arial';
  Form15.QRDBText1.Font.Size := 10;
  Form15.QRDBText2.DataSet := nil;
  Form15.QRDBText1.Alignment := taLeftJustify;
  Form15.QRDBText2.Alignment := taRightJustify;
  Form15.QRDBText1.Left := 10;
  Form15.QRDBText1.Width := 258;
  Form15.QRDBText2.Left := 0;
  Form15.QRDBText2.Width := 0;
  Form15.QRLabel1.Caption := 'Einzelpersonen';
  Form15.QRLabel3.Caption := 'Einzelpersonen';
  if gvar_0253692C = 'Dopp' then
  begin
    Form15.QRLabel1.Caption := 'Doppel-/Mehrfach-Eintr' + #228 + 'ge';
    Form15.QRLabel3.Caption := 'Doppel-/Mehrfach-Eintr' + #228 + 'ge';
  end;
  DataModule2.Table14.Open;
  Form15.QuickRep1.Page.Columns := 1;
  Form15.QRLabel2.Caption := '(= ohne Eltern, Kinder, Ehe o' + #228 + '., nicht adoptiert)';
  if gvar_0253692C = 'Dopp' then
    Form15.QRLabel2.Caption := '(Name, Vorname' + gvar_02536B98 + ' gleich.)';
  { The original sets the event for the preview of the report and shows
    the preview; the compatibility layer of QuickReport has neither. }
end;

procedure TForm1.DBLookupComboBox4Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBGrid3Exit(Sender: TObject);
begin
  DBGrid3.Visible := False;

  Label81.Visible := False;

  DBComboBox3.SetFocus;

end;

procedure TForm1.DBGrid3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //006059E4: 'Esc' nimmt die Auswahl zurueck.
  if Key = VK_ESCAPE then
  begin
    DBComboBox3.Text := '';
    DBGrid3.Visible := False;
    Label81.Visible := False;
    DBComboBox3.SetFocus;
  end;
end;

procedure TForm1.DBLookupComboBox7Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBLookupComboBox8Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBLookupComboBox5Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBLookupComboBox6Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBGrid3DblClick(Sender: TObject);
begin
  //00585814: DBComboBox3-Wahl (V/M) in der Tabelle31 verlinken.
  DataModule2.Table31.Open;
  DataModule2.Table31.IndexName := '';
  if DataModule2.Table31.FindKey([DataModule2.Table1Nummer.AsInteger]) then
    DataModule2.Table31.Edit
  else
  begin
    DataModule2.Table31.Append;
    DataModule2.Table31Nummer.AsInteger := DataModule2.Table1Nummer.AsInteger;
  end;
  if DBComboBox3.Text = 'V' then
    DataModule2.Table31Av.AsInteger := DBGrid3.Fields[0].AsInteger;
  if DBComboBox3.Text = 'M' then
    DataModule2.Table31Am.AsInteger := DBGrid3.Fields[0].AsInteger;
  DataModule2.Table31.Post;
  DBGrid3.Visible := False;
  Label81.Visible := False;
  DBComboBox3.SetFocus;
end;

procedure TForm1.QuellenListeeditieren1Click(Sender: TObject);
begin
  Form29.ShowModal;

end;

procedure TForm1.Quellesuchen1Click;
begin
  //00604820: Anfrage stellt nur QuellenListeeditieren1Click dar.
  QuellenListeeditieren1.Click;
end;

procedure TForm1.DBLookupComboBox19MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  bezeichnung, quelle: string;
  anzahl: Integer;
begin
  { The right mouse button opens an input window in which a new source of
    a marriage or of a divorce can be entered.  The source is added to
    the table of the sources if it is not yet known; the number of the
    source is written into the field of the marriage. }
  bezeichnung := '';
  quelle := '';
  anzahl := 0;
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;

  if Sender = ComboBox23 then
    bezeichnung := 'Neue Quelle (Heirat (Kirche))'
  else if Sender = ComboBox24 then
    bezeichnung := 'Neue Quelle (Heirat (Standesamt))'
  else if Sender = ComboBox25 then
    bezeichnung := 'Neue Quelle (Scheidung)';

  if Button = mbRight then
  begin
    if InputQuery(bezeichnung, 'Quelle: ', quelle) then
      if Trim(quelle) <> '' then
      begin
        if not DataModule2.Table38.FindKey([quelle]) then
        begin
          Inc(anzahl);
          DataModule2.Table38.Append;
          DataModule2.Table38Titel.AsString := quelle;
          DataModule2.Table38.Post;
        end;

        if Sender = ComboBox23 then
        begin
          DataModule2.Table5.Edit;
          DataModule2.Table5Hqu.AsString := IntToStr(anzahl);
          DataModule2.Table5.Post;
        end
        else if Sender = ComboBox24 then
        begin
          DataModule2.Table5.Edit;
          DataModule2.Table5Saqu.AsString := IntToStr(anzahl);
          DataModule2.Table5.Post;
        end
        else if Sender = ComboBox25 then
        begin
          DataModule2.Table5.Edit;
          DataModule2.Table5Schqu.AsString := IntToStr(anzahl);
          DataModule2.Table5.Post;
        end;
      end;
  end;
end;

procedure TForm1.DBLookupComboBox19Click;
begin
  DataModule2.Table38.IndexName := 'tit';

end;

procedure TForm1.DBComboBox3Change(Sender: TObject);
begin
  //006053EC: V/M-Wahl fuehrt eine SQL-Abfrage aus und zeigt die Treffer
  //in DBGrid3 an. Der Text der ersten SQL-Zeile ist im Listing
  //abgeschnitten; die Rekonstruktion setztgroebere Vollansicht um.
  if Pos(DBComboBox3.Text, 'VM') > 0 then
  begin
    Query1.SQL.Clear;
    { Da der Original-SQL-Text im IDR-Listing abgeschnitten ist:
      die Spaltenbeschreibung entsprechend der Spaltenbreiten }
    Query1.SQL.Add('select nummer, name || " " || vornamen || " * " ||');
    Query1.SQL.Add('gebjahr || ", + " || stjahr, name, vornamen, gebjahr');
    Query1.SQL.Add('from awd');
    if DBComboBox3.Text = 'V' then
    begin
      Query1.SQL.Add('where geschlecht="m"');
      Label81.Caption := 'Adoptiv-Vater';
    end;
    if DBComboBox3.Text = 'M' then
    begin
      Query1.SQL.Add('where geschlecht="w"');
      Label81.Caption := 'Adoptiv-Mutter';
    end;
    Query1.SQL.Add('order by name,vornamen,gebjahr');
    DataSource1.DataSet := Query1;
    Query1.Open;
    DBGrid3.DataSource := DataSource1;
    Label81.Visible := True;
    DBGrid3.Columns[0].Width := 60;
    DBGrid3.Columns[1].Width := 272;
    DBGrid3.Columns[2].Width := 0;
    DBGrid3.Columns[3].Width := 0;
    DBGrid3.Columns[4].Width := 0;
    DBGrid3.Show;
    DBComboBox3.SetFocus;
    DataModule2.Table1.Edit;
  end;
end;

procedure TForm1.DBComboBox3Exit(Sender: TObject);
begin
  { The entry of the list is removed when the field is left empty. }
  if DBComboBox3.Text = '' then
  begin
    DataModule2.Table31.Open;
    DataModule2.Table31.IndexName := '';
    if DataModule2.Table31.FindKey([DataModule2.Table1Nummer.AsInteger]) then
      DataModule2.Table31.Delete;
  end;
end;


procedure TForm1.drucken1Click(Sender: TObject);
var
  s: AnsiString;
begin
  //0060482C: Druck der Ergebnisse der "Globale Suche" (Form15/QuickRep).
  gvar_0253692C := 'Over';
  s := '';
  if DataModule2.Table16.RecordCount <= 0 then
  begin
    ShowMessage('Keine Suchergebnisse vorhanden.');
    Exit;
  end;
  if not InputQuery('Globale Suche', 'Überschrift: ', s) then
    Exit;
  gvar_02536930 := s;
  gvar_02536934 := 'Nr.       Name' + ' ' + 'geb.am' + ' ' + 'in' + ' ' + '...';
  { list form layout to be per recon approximation of coping/caps (the
    positions row over deviations are in the 0060482C listing). }
  Form15.QuickRep1.DataSet := DataModule2.Table16;
  Form15.QuickRep1.Page.Orientation := poLandscape;
  Form15.QuickRep1.Page.Columns := 1;
  Form15.QRMemo1.Lines.Clear;
  Form15.QRLabel2.Font.Style := [];
  Form15.QRDBText3.Enabled := True;
  Form15.QRDBText4.Enabled := True;
  Form15.QRDBText5.Enabled := True;
  Form15.QRDBText6.Enabled := True;
  Form15.QRDBText7.Enabled := True;
  Form15.QRDBText8.Enabled := True;
  Form15.QRDBText9.Enabled := True;
  Form15.QRDBText10.Enabled := True;
  Form15.QRDBText11.Enabled := True;
  Form15.QRDBText12.Enabled := True;
  Form15.QRDBText13.Enabled := True;
  Form15.QRDBText14.Enabled := True;
  Form15.QRDBText15.Enabled := True;
  Form15.QRShape1.Width := 980;
  Form15.QRShape2.Width := 980;
  Form15.QRShape3.Enabled := True;
  Form15.QRShape3.Width := 980;
  Form15.QRLabel3.Caption := 'Globale Suche';
  Form15.QRDBText1.DataSet := DataModule2.Table16;
  Form15.QRDBText2.DataSet := DataModule2.Table16;
  Form15.QRDBText3.DataSet := DataModule2.Table16;
  Form15.QRDBText4.DataSet := DataModule2.Table16;
  Form15.QRDBText5.DataSet := DataModule2.Table16;
  Form15.QRDBText6.DataSet := DataModule2.Table16;
  Form15.QRDBText7.DataSet := DataModule2.Table16;
  Form15.QRDBText8.DataSet := DataModule2.Table16;
  Form15.QRDBText9.DataSet := DataModule2.Table16;
  Form15.QRDBText10.DataSet := DataModule2.Table16;
  Form15.QRDBText11.DataSet := DataModule2.Table16;
  Form15.QRDBText12.DataSet := DataModule2.Table16;
  Form15.QRDBText13.DataSet := DataModule2.Table16;
  Form15.QRDBText14.DataSet := DataModule2.Table16;
  Form15.QRDBText15.DataSet := DataModule2.Table16;
  Form15.QRDBText1.DataField := 'name';
  Form15.QRDBText2.DataField := 'nummer';
  Form15.QRDBText3.DataField := 'gebtag';
  Form15.QRDBText4.DataField := 'gebmonat';
  Form15.QRDBText5.DataField := 'gebjahr';
  Form15.QRDBText6.DataField := 'gebort';
  Form15.QRDBText7.DataField := 'sttag';
  Form15.QRDBText8.DataField := 'stmonat';
  Form15.QRDBText9.DataField := 'stjahr';
  Form15.QRDBText10.DataField := 'stort';
  Form15.QRDBText11.DataField := 'htag';
  Form15.QRDBText12.DataField := 'hmonat';
  Form15.QRDBText13.DataField := 'hjahr';
  Form15.QRDBText14.DataField := 'hort';
  Form15.QRDBText15.DataField := 'hname';
  Form15.QRDBText1.Font.Size := 8;
  Form15.QRDBText2.Font.Size := 8;
  Form15.QRDBText3.Font.Size := 8;
  Form15.QRDBText4.Font.Size := 8;
  Form15.QRDBText5.Font.Size := 8;
  Form15.QRDBText6.Font.Size := 8;
  Form15.QRDBText7.Font.Size := 8;
  Form15.QRDBText8.Font.Size := 8;
  Form15.QRDBText9.Font.Size := 8;
  Form15.QRDBText10.Font.Size := 8;
  Form15.QRDBText11.Font.Size := 8;
  Form15.QRDBText12.Font.Size := 8;
  Form15.QRDBText13.Font.Size := 8;
  Form15.QRDBText14.Font.Size := 8;
  Form15.QRDBText15.Font.Size := 8;
  { Kopf-/Spaltenanordnung (entnimmt der 0060482C-Listing) }
  Form15.QRDBText1.Top := 0;
  Form15.QRDBText2.Top := 0;
  Form15.QRDBText2.Left := 10;
  Form15.QRDBText2.Width := 35;
  Form15.QRDBText1.Left := 51;
  Form15.QRDBText1.Width := 150;
  Form15.QRDBText3.Left := 210;
  Form15.QRDBText3.Width := 21;
  Form15.QRDBText4.Left := 231;
  Form15.QRDBText4.Width := 16;
  Form15.QRDBText5.Left := 247;
  Form15.QRDBText5.Width := 32;
  Form15.QRDBText6.Left := 279;
  Form15.QRDBText6.Width := 120;
  Form15.QRDBText7.Left := 400;
  Form15.QRDBText7.Width := 21;
  Form15.QRDBText8.Left := 421;
  Form15.QRDBText8.Width := 16;
  Form15.QRDBText9.Left := 437;
  Form15.QRDBText9.Width := 32;
  Form15.QRDBText10.Left := 469;
  Form15.QRDBText10.Width := 120;
  Form15.QRDBText11.Left := 590;
  Form15.QRDBText11.Width := 39;
  Form15.QRDBText12.Left := 628;
  Form15.QRDBText12.Width := 19;
  Form15.QRDBText13.Left := 647;
  Form15.QRDBText13.Width := 23;
  Form15.QRDBText14.Left := 668;
  Form15.QRDBText14.Width := 123;
  Form15.QRDBText15.Left := 796;
  Form15.QRDBText15.Width := 175;
  DataModule2.Table16.Open;
  Form15.QRLabel1.Caption := gvar_02536930;
  if Length(gvar_02536934) > 0 then
  begin
    Form15.QRLabel2.Caption := gvar_02536934;
    Form15.QRBand1.Height := 55;
  end;
  Form15.QRBand3.Height := 19;
  Form15.QRShape1.Left := Form15.QRShape1.Width - 75;
  Form16.Label5.Visible := False;
  Form16.Button9.Visible := False;
  Form16.Button5.Visible := False;
  Form16.SpeedButton6.Enabled := False;
  Form16.SpeedButton1.Enabled := True;
  { Form15.QuickRep1.Preview - die Vorschau ist im
    Kompatibilitaetsschicht nicht implementiert. }
end;

procedure TForm1.QRDefault;
begin
  { The report is put into its default state: the page is upright, the two
    labels are bold, only the two fields of the report are shown and the
    caption of the second label is empty. }
  Form15.QuickRep1.Page.Orientation := poPortrait;
  Form15.QRLabel1.Font.Style := [fsBold];
  Form15.QRLabel2.Font.Style := [fsBold];
  Form15.QRDBText1.Visible := True;
  Form15.QRDBText2.Visible := True;
  Form15.QRDBText3.Visible := False;
  Form15.QRDBText4.Visible := False;
  Form15.QRDBText5.Visible := False;
  Form15.QRDBText6.Visible := False;
  Form15.QRDBText7.Visible := False;
  Form15.QRDBText8.Visible := False;
  Form15.QRDBText9.Visible := False;
  Form15.QRDBText10.Visible := False;
  Form15.QRDBText11.Visible := False;
  Form15.QRDBText12.Visible := False;
  Form15.QRDBText13.Visible := False;
  Form15.QRDBText14.Visible := False;
  Form15.QRDBText15.Visible := False;
  Form15.QRLabel2.Caption := '';
  Form16.Button5.Visible := True;
  Form16.Button9.Visible := True;
end;

procedure TForm1.druck(ATitel, AUntertitel: string);
  //005EFF30: die Listenvorschau in Form15 aufbauen. Table14 ist die
  //Datenquelle, eine Zeile ohne Kopfdrueck wird ueber QRDBText1
  //("zeile") angezeigt, QRBand3 stellt die Kopfzeile.
begin
  DataModule2.Table14.Close;
  Form16.SpeedButton3.Visible := True;   // 34C
  Form16.SpeedButton6.Visible := False;  // 350
  QRDefault;
  Form15.QRMemo1.Lines.Clear;
  Form15.QRDBText1.DataField := '';
  Form15.QRDBText2.DataField := '';
  Form15.QuickRep1.DataSet := DataModule2.Table14;
  Form15.QRDBText1.DataSet := DataModule2.Table14;
  Form15.QRDBText1.DataField := 'zeile';
  Form15.QRDBText1.Transparent := False; // 0E0
  Form15.QRDBText2.Transparent := True;  // 0E0 mit dl=1
  Form15.QRDBText1.Font.Size := 10;
  Form15.QRDBText1.AutoStretch := True; // 64
  Form15.QRDBText2.DataSet := nil;
  Form15.QRDBText1.Left := 10;
  Form15.QRDBText1.Width := 600;
  Form15.QRDBText2.Left := 0;
  Form15.QRDBText2.Width := 0;
  Form15.QRLabel1.Caption := ATitel;
  Form15.QRLabel3.Caption := ATitel;
  if AUntertitel <> '' then
    Form15.QRLabel2.Caption := AUntertitel;
  Form15.QRBand1.Height := 30;
  Form15.QRShape3.AutoSize := True;     // 64
  DataModule2.Table14.Open;
  { Form15.QuickRep1.OnPreview := showpreview - die Vorschau ist im
    Kompatibilitaetsschicht nicht implementiert. }
end;

procedure TForm1.vorf_erm2(ANummer: Integer; AText: AnsiString; var AFlag: Integer);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Hilfe1Click(Sender: TObject);
begin
  ShowMessage('Bitte die beiliegende Datei "Handbuch.pdf" ben' + #252 + 'tzen');

end;

procedure TForm1.GrafikI1Click(Sender: TObject);
var
  personNummer: Integer;
begin
  { The chart of the descendants is shown. }
  personNummer := DataModule2.Table1Nummer.AsInteger;
  speich1;
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  if StringGrid2.Cells[1, 0] = '' then
  begin
    ShowMessage('Keine Nachfahren gefunden.');
    Exit;
  end;
  gvar_02536948 := 0;
  gvar_0253692C := 'Nachgr1';
  gvar_0061F0FC := Form14;
  Form12.Caption := 'Nachfahren-Grafik I';
  Form12.ShowModal;
  gvar_02536958 := '1';
  if (Form12.SpinEdit1.Value - 1 < 0) or (gvar_02536948 = 1) then
  begin
    Form12.ModalResult := 2;
    gvar_02536948 := 1;
  end
  else
  begin
    DataModule2.Table1.FindKey([personNummer]);
    anzeigen;
  end;
end;

procedure TForm1.Grafikalt1Click(Sender: TObject);
begin
  { The chart of the ancestors is shown. }
  speich1;
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  if (DataModule2.Table1Vater.AsInteger = 0) and
     (DataModule2.Table1Mutter.AsInteger = 0) then
  begin
    ShowMessage('Keine Vorfahren gefunden.');
    Exit;
  end;
  gvar_0253692C := 'Vorgr1';
  gvar_0061F0FC := Form13;
  Form12.Caption := 'Vorfahren-Grafik I';
  Form12.ShowModal;
  anzeigen;
end;

procedure TForm1.allePersonen3Click(Sender: TObject);
begin
  { The family tree with all the persons is shown. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  aspitz(Sender);
end;

procedure TForm1.Basisahnen1Click(Sender: TObject);
begin
  { The family tree of the direct ancestors is shown. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  basahnen(Sender);
end;

procedure TForm1.Listen;
var
  nach: AnsiString;
  trim1: AnsiString;
  vn: AnsiString;
  trim2: AnsiString;
  f: TForm19;
begin
  //005FBF0C: Parameterdialog fuer Nachfahren- undVorfahrenlisten
  //anzeigen und danach die Liste waehlen bzw. den Dialog verlassen.
  PageControl1.ActivePage := TabSheet2;
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;
  if gvar_0253692C = 'Nach' then
  begin
    nach := Trim(StringGrid2.Cells[1, 0]);
    if nach = '' then
    begin
      ShowMessage('Keine Nachfahren gefunden.');
      Exit;
    end;
  end;
  if gvar_0253692C = 'Vorf' then
  begin
    trim1 := Trim(Edit1.Text);
    trim2 := Trim(Edit2.Text);
    if (trim1 = '') and (trim2 = '') then
    begin
      ShowMessage('Keine Vorfahren gefunden.');
      Exit;
    end;
  end;
  f := TForm19.Create(Self);
  Form19 := f;
  try
    Form19.Panel2.Hide;
    if gvar_0253692C = 'Nach' then
    begin
      Form19.Caption := 'Parameter f' + #252 + 'r Nachfahrenlisten';
      Form19.ComboBox1.Items.Clear;
      Form19.ComboBox1.Items.Add('Nachfahrenliste');
      Form19.ComboBox1.Items.Add('Stammliste');
      Form19.CheckBox11.Show;
      Form19.CheckBox9.Show;
      Form19.Panel2.Height := 127;
      Form19.Panel5.Top := 127;
      Form19.Panel3.Top := 176;
      Form19.Panel3.Height := 73;
      Form19.Edit2.Visible := False;
      Form19.Button3.Visible := False;
      Form19.Button4.Visible := False;
      Form19.Label3.Visible := False;
    end
    else if gvar_0253692C = 'Vorf' then
    begin
      Form19.Caption := 'Parameter f' + #252 + 'r Vorfahrenlisten';
      Form19.ComboBox1.Items.Clear;
      Form19.ComboBox1.Items.Add('chronologisch');
      Form19.ComboBox1.Items.Add('alphabetisch');
      Form19.CheckBox11.Visible := False;
      Form19.CheckBox9.Visible := False;
      Form19.Panel2.Hide;
      Form19.Panel2.Height := 85;
      Form19.Panel5.Top := 85;
      Form19.Panel3.Top := 134;
      Form19.Panel3.Height := 115;
      Form19.Edit2.Show;
      Form19.Edit2.Top := 88;
      Form19.Button3.Show;
      Form19.Button3.Top := 90;
      Form19.Button4.Show;
      Form19.Button4.Top := 90;
      Form19.Label3.Show;
      Form19.Label3.Top := 63;
    end
    else
      Form19.Panel2.Hide;
    Form19.ShowModal;
    if Form19.ModalResult <> 2 then
    begin
      { Form15.QuickRep1.OnPreview := showpreview und
        Form15.QuickRep1.Preview - die Vorschau ist im
        Kompatibilitaetsschicht nicht implementiert. }
    end;
  finally
    Form19.Release;
  end;
end;

procedure TForm1.Proband1Click(Sender: TObject);
begin
  { The family tree of the "Proband" is shown. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  gvar_0253692C := 'Sppr';
  pspitz(Sender);
end;

procedure TForm1.ehtest(var s: string; epnum: Integer);
  //005FE42C: das Partner-Datum in s anhaengen. Alle Eintraege der
  //Table18 mit der gesuchten Ehepartner-Nummer werden durchlaufen:
  //zuerst werden die Partner-Hochzeitsdaten, dann die eigenen
  //Herzstuecke (Ehe-Schluessel) gehaengt und am Ende das Ehe-'E'.
var
  tag: string;
  mon: string;
  jahr: string;
begin
  s := '';
  DataModule2.Table18.IndexName := 'num';
  DataModule2.Table18.FindKey([epnum]);
  while not DataModule2.Table18.EOF do
  begin
    if DataModule2.Table18Nummer.AsInteger <> epnum then
      Break;
    if DataModule2.Table18Epnum.AsInteger > 0 then
    begin
      if (DataModule2.Table18Sajahr.AsString <> '') or
         (DataModule2.Table18Saort.AsString <> '') then
      begin
        s := s + zahl6(DataModule2.Table18Epnum.AsInteger) +
          Format('%2s', [DataModule2.Table18Satag.AsString]) + '.' +
          Format('%2s', [DataModule2.Table18Samonat.AsString]) + '.' +
          Format('%4s', [DataModule2.Table18Sajahr.AsString]);
      end
      else
      begin
        s := s + zahl6(DataModule2.Table18Epnum.AsInteger) +
          Format('%2s', [DataModule2.Table18Htag.AsString]) + '.' +
          Format('%2s', [DataModule2.Table18Hmonat.AsString]) + '.' +
          Format('%4s', [DataModule2.Table18Hjahr.AsString]);
      end;
      if Pos('Ehes', DataModule2.Table18Verbind.AsString) > 0 then
        s := s + 'E'
      else
        s := s + ' ';
    end;
    DataModule2.Table18.Next;
  end;
end;

procedure TForm1.Adressendateischreiben1Click(Sender: TObject);
begin
  //005FD964: Adressen-Liste schreiben (ueber den Dialog in Form3).
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  speich1;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  Form3.adrschreib;
end;

procedure TForm1.TabSheet8Enter(Sender: TObject);
begin
  { The page of the address shows the name of the person. }
  Label78.Caption := 'Adresse von: ' +
                    UpperCase(DataModule2.Table1Name.AsString) + ' ' +
                    DataModule2.Table1Vornamen.AsString;
end;

procedure TForm1.Listen2Click(Sender: TObject);
begin
  { The list of the ancestors ("Vorfahren") is shown. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  gvar_0061F0BC := 0;
  gvar_0061F0C0 := 0;
  gvar_0253692C := 'Vorf';
  Vorlist(Sender);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  count: Integer;
  posk: Integer;
begin
  { 005FD6A0: In den Namen und Vornamen wird das erste Komma durch ein
    Leerzeichen ersetzt. Die Anzahl der Vornahmen wird am Ende
    gemeldet. }
  DataModule2.Table1.Open;
  DataModule2.Table1.First;
  count := 0;
  while not DataModule2.Table1.Eof do
  begin
    if Pos(',', DataModule2.Table1Name.AsString) > 0 then
    begin
      DataModule2.Table1.Edit;
      posk := Pos(',', DataModule2.Table1Name.AsString);
      DataModule2.Table1Name.AsString :=
        Copy(DataModule2.Table1Name.AsString, 1, posk - 1) + ' ' +
        Copy(DataModule2.Table1Name.AsString, posk + 1,
          Length(DataModule2.Table1Name.AsString) - posk);
      DataModule2.Table1.Post;
      Inc(count);
    end;
    if Pos(',', DataModule2.Table1Vornamen.AsString) > 0 then
    begin
      DataModule2.Table1.Edit;
      posk := Pos(',', DataModule2.Table1Vornamen.AsString);
      DataModule2.Table1Vornamen.AsString :=
        Copy(DataModule2.Table1Vornamen.AsString, 1, posk - 1) + ' ' +
        Copy(DataModule2.Table1Vornamen.AsString, posk + 1,
          Length(DataModule2.Table1Vornamen.AsString) - posk);
      DataModule2.Table1.Post;
      Inc(count);
    end;
    DataModule2.Table1.Next;
  end;
  ShowMessage(IntToStr(count) + ' Ersetzungen vorgenommen.');
end;

procedure TForm1.geschachtelt1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.geb_sterb(var ergebnis: string);
var
  s, datum: string;
begin
  { The text with the dates of the person is built: the birth (or the
    baptism) and the death (or the burial).  The places are only added
    when the list is made for a single person or for the duplicates. }
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;
  s := '';

  if (DataModule2.Table17Gebjahr.AsString <> '') or
     (DataModule2.Table17Gebort.AsString <> '') then
  begin
    datumNormalisieren(DataModule2.Table17Gebtag.AsString + '.' +
      DataModule2.Table17Gebmonat.AsString + '.' +
      DataModule2.Table17Gebjahr.AsString, datum);
    s := s + ' * ' + datum;
    if (gvar_0253692C = 'Einz') or (gvar_0253692C = 'Dopp') then
      s := s + ' ' + DataModule2.Table17Gebort.AsString;
  end
  else if (DataModule2.Table17Taufjahr.AsString <> '') or
          (DataModule2.Table17Taufort.AsString <> '') then
  begin
    datumNormalisieren(DataModule2.Table17Tauftag.AsString + '.' +
      DataModule2.Table17Taufmonat.AsString + '.' +
      DataModule2.Table17Taufjahr.AsString, datum);
    s := s + ' ~ ' + datum;
    if (gvar_0253692C = 'Einz') or (gvar_0253692C = 'Dopp') then
      s := s + ' ' + DataModule2.Table17Taufort.AsString;
  end;

  if (DataModule2.Table17Stjahr.AsString <> '') or
     (DataModule2.Table17Stort.AsString <> '') then
  begin
    datumNormalisieren(DataModule2.Table17Sttag.AsString + '.' +
      DataModule2.Table17Stmonat.AsString + '.' +
      DataModule2.Table17Stjahr.AsString, datum);
    s := s + datum;
    if (gvar_0253692C = 'Einz') or (gvar_0253692C = 'Dopp') then
      s := s + ' ' + DataModule2.Table17Stort.AsString;
  end
  else if (DataModule2.Table17Begjahr.AsString <> '') or
          (DataModule2.Table17Begort.AsString <> '') then
  begin
    datumNormalisieren(DataModule2.Table17Begtag.AsString + '.' +
      DataModule2.Table17Begmonat.AsString + '.' +
      DataModule2.Table17Begjahr.AsString, datum);
    s := s + datum;
    if (gvar_0253692C = 'Einz') or (gvar_0253692C = 'Dopp') then
      s := s + ' ' + DataModule2.Table17Begort.AsString;
  end;

  ergebnis := s;
end;

procedure TForm1.AHNENDOSeinlesen1Click(Sender: TObject);
var
  voldir: AnsiString;
  fname: AnsiString;
  fn: AnsiString;
begin
  //005FDAA4: AHNENWIN-DOS-Daten einlesen. Der Dateiname kommt ueber
  //den Opendialog; bei vorhandenen Daten wird nachgefragt, ob die
  //Bestandsdaten geloescht werden; das Einlesen macht Form3.ahndosein.
  voldir := GetCurrentDir;
  OpenDialog1.FileName := '';
  OpenDialog1.FilterIndex := 1;
  if not OpenDialog1.Execute then
    Exit;
  fname := OpenDialog1.FileName;
  fn := OpenDialog1.FileName;
  if (fname = '') or (fn = '') then
    Exit;
  Screen.Cursor := crHourGlass;
  try
    gvar_02536940 := 0;
    if DataModule2.Table1Nummer.AsInteger > 0 then
    begin
      if Application.MessageBox(
         'Die Bestandsdaten werden gel' + #246 + 'scht ?',
         'AHNENWIN-DOS einlesen', mb_YESNO) = IDYES then
      begin
        Datenlschen1Click(nil);
        Refresh;
      end
      else
        gvar_02536940 := gvar_02536944;
    end;
    Refresh;
    Form3.ahndosein;
  finally
    Screen.Cursor := crDefault;
  end;
  tabenab;
  ChDir(voldir);
  Label10.Visible := True;
  Label11.Visible := True;
  DataModule2.Table1.Open;
  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.Last;
  gvar_02536944 := DataModule2.Table1Nummer.AsInteger;
  DataModule2.Table1.First;
  DataModule2.Table4.Open;
  DataModule2.Table5.Open;
  anzeigen;
end;

procedure TForm1.OSBeinlesen1Click(Sender: TObject);
var
  voldir: AnsiString;
  fname: AnsiString;
  fn: AnsiString;
begin
  //005FDD0C: OS/2-Daten einlesen. Der Dateiname wird ueber den
  //Opendialog geholt; bei vorhandenen Daten wird nachgefragt, ob
  //die Bestandsdaten geloescht werden sollen, dann Ruft die Routine
  //in Form3.schreibtab_005F to. Danach wird die Ansicht aufgebaut.
  voldir := GetCurrentDir;
  OpenDialog1.FileName := '';
  OpenDialog1.FilterIndex := 2;
  if not OpenDialog1.Execute then
    Exit;
  fname := OpenDialog1.FileName;
  fn := OpenDialog1.FileName;
  if (fname = '') or (fn = '') then
    Exit;
  Screen.Cursor := crHourGlass;
  try
    gvar_02536940 := 0;
    if DataModule2.Table1Nummer.AsInteger > 0 then
    begin
      if Application.MessageBox(
         'Die Bestandsdaten werden gel' + #246 + 'scht ?',
         'OS-Daten einlesen', mb_YESNO) = IDYES then
      begin
        Datenlschen1Click(nil);
        Refresh;
      end
      else
        gvar_02536940 := gvar_02536944;
    end;
    Form3.osbein;
  finally
    Screen.Cursor := crDefault;
  end;
  ChDir(voldir);
  listen_akt;
  DataModule2.Table1.Open;
  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.Last;
  gvar_02536944 := DataModule2.Table1Nummer.AsInteger;
  DataModule2.Table1.First;
  Label10.Visible := True;
  Label11.Visible := True;
  DataModule2.Table5.Close;
  DataModule2.Table5.Open;
  anzeigen;
end;

procedure TForm1.Edit13Exit(Sender: TObject);
begin
  { The date of the separation was left: the weekday is shown again and the date is checked. }
  wt39;
  datcheck(Edit15.Text, Edit14.Text, Edit13.Text);
end;


procedure TForm1.PageControl1Exit(Sender: TObject);
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.Edit6Exit(Sender: TObject);
begin
  { The date of the marriage was left: the weekday is shown again and the date is checked. }
  wt37;
  datcheck(Edit4.Text, Edit5.Text, Edit6.Text);
end;


procedure TForm1.Edit10Exit(Sender: TObject);
begin
  { The date of the marriage at the registry office was left: the weekday is shown again and the date is checked. }
  wt38;
  datcheck(Edit8.Text, Edit9.Text, Edit10.Text);
end;


procedure TForm1.FormActivate(Sender: TObject);
begin
  { The field for the name of the father gets the input. }
  DBEdit2.SetFocus;
end;

procedure TForm1.DBCheckBox1Exit(Sender: TObject);
begin
  DataModule2.Table1.Refresh;

end;

procedure TForm1.ComboBox5Change(Sender: TObject);
begin
  { The field for the name gets the input. }

  Edit4.SetFocus;

end;

procedure TForm1.DBEdit47Exit(Sender: TObject);
begin
  { The year of the baptism was left: the weekday is shown again and the date is checked. }
  wt34;
  datcheck(DBEdit49.Text, DBEdit48.Text, DBEdit47.Text);
end;


procedure TForm1.DBEdit55Exit(Sender: TObject);
begin
  { The year of the burial was left: the weekday is shown again and the date is checked. }
  wt36;
  datcheck(DBEdit57.Text, DBEdit56.Text, DBEdit55.Text);
end;


procedure TForm1.aspitz(ASender: TObject);
begin
  { The ancestors without parents are searched. }
  speich1;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + 'fc' + 'gbar.');
    Exit;
  end;
  if PageControl1.PageCount <> 2 then
    PageControl1.ActivePage := TabSheet2;
  gvar_02536B54 := 1;
  gvar_02536930 := 'Spitzen-Ahnen (d.h.keine Eltern gefunden)';
  gvar_02536934 := '';
  Label19.Caption := 'Spitzenahnen erm.';
  lab18ein;
  Label18.Caption := '0 %';
  Label18.Refresh;
  gvar_0253692C := 'basa';
  spitzbas;
end;

procedure TForm1.pspitz(ASender: TObject);
var
  s: string;
begin
  { The ancestors without parents are searched. }
  DataModule2.Table12.Open;
  if DataModule2.Table1Vater.AsInteger = 0 then
    if DataModule2.Table1Mutter.AsInteger = 0 then
    begin
      ShowMessage('Keine Vorfahren gefunden.');
      Exit;
    end;
  gvar_0253692C := 'Sppr';
  vorf_erm2(StrToInt(DBText1.Field.AsString), DBText1.Field.AsString, gvar_02536948);
  if gvar_02536948 = 1 then
  begin
    gvar_02536948 := 0;
    Exit;
  end;
  if DataModule2.Table1.RecordCount < 2 then
    Exit;
  speich1;
  if PageControl1.PageCount <> 2 then
    PageControl1.ActivePage := TabSheet2;
  gvar_02536B54 := 1;
  ucase(DataModule2.Table1Name.AsString, s);
  gvar_02536930 := 'Spitzen-Ahnen von ' + s + ' ' +
                  DataModule2.Table1Vornamen.AsString;
  Label19.Caption := 'Spitzenahnen erm.';
  lab18ein;
  Label18.Caption := '0 %';
  Label18.Refresh;
  spitzbas;
end;

procedure TForm1.spitzbas;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.basahnen(ASender: TObject);
begin
  { The ancestors without a (marital) connection that are at least 50
    years old are searched. }
  speich1;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + 'fc' + 'gbar.');
    Exit;
  end;
  if PageControl1.PageCount <> 2 then
    PageControl1.ActivePage := TabSheet2;
  gvar_02536B54 := 1;
  gvar_02536930 := 'Basis-Ahnen (d.h. keine (eheliche) Verbindung gefunden und mindestens 50 Jahre alt)';
  gvar_02536934 := '';
  Label19.Caption := 'Basis-Ahnen erm.';
  lab18ein;
  Label18.Caption := '0 %';
  Label18.Refresh;
  gvar_0253692C := 'basa';
  spitzbas;
end;

procedure TForm1.DBEdit44Exit(Sender: TObject);
begin
  { The year of the birth was left: the weekday is shown again and the date is checked. }
  wt33;
  datcheck(DBEdit42.Text, DBEdit43.Text, DBEdit44.Text);
end;


procedure TForm1.DBEdit52Exit(Sender: TObject);
begin
  { The year of the death was left: the weekday is shown again and the date is checked. }
  wt35;
  datcheck(DBEdit50.Text, DBEdit51.Text, DBEdit52.Text);
end;


procedure TForm1.DBEdit40Exit(Sender: TObject);
begin
  { The gender of the person must be given. }
  if DBEdit40.Text = '' then
  begin
    if DataModule2.Table1Nummer.AsInteger > 0 then
      ShowMessage('Bitte Geschlecht eingeben.');
  end
  else if Pos('mMwWxX', DBEdit40.Text) = 0 then
    ShowMessage('Geschlecht: ' + DBEdit40.Text + '  Okay ?');
end;


procedure TForm1.DBEdit7Exit(Sender: TObject);
begin
  { The gender of the person must be given. }
  if DBEdit7.Text = '' then
  begin
    if DataModule2.Table1Nummer.AsInteger > 0 then
      ShowMessage('Bitte Geschlecht eingeben.');
  end
  else if Pos('mMwWxX', DBEdit7.Text) = 0 then
    ShowMessage('Geschlecht: ' + DBEdit7.Text + '  Okay ?');
end;


procedure TForm1.Quellenliste1Click(Sender: TObject);
begin
  { The list of the sources is written into the table of the report and
    printed. }
  gvar_0253692C := 'QL';
  gvar_02536930 := 'Quellenliste';
  gvar_02536934 := '';
  Screen.Cursor := crHourGlass;
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;
  if DataModule2.Table38.RecordCount = 0 then
  begin
    ShowMessage('Keine Quellenangaben verf' + #252 + 'gbar.');
    Exit;
  end;

  { The table of the report is filled with the titles of the sources. }
  DataModule2.Table14.Open;
  DataModule2.Table14.Close;
  DataModule2.Table14.EmptyTable;
  DataModule2.Table14.Open;
  DataModule2.Table14.Append;
  DataModule2.Table14Zeile.AsString := ' ';
  DataModule2.Table14.Post;
  repeat
    DataModule2.Table14.Append;
    DataModule2.Table14Zeile.AsString := DataModule2.Table38Titel.AsString;
    DataModule2.Table14.Post;
    DataModule2.Table38.Next;
  until DataModule2.Table38.Eof;

  { The report is printed. }
  Form15.QuickRep1.Page.Columns := 1;
  druck(gvar_02536930, gvar_02536934);
  DataModule2.Table14.Open;
  Screen.Cursor := crDefault;
  { The original shows the preview of the report; the compatibility layer
    of QuickReport has no preview. }
end;

procedure TForm1.TabSheet1Show(Sender: TObject);
begin
  { The list of the persons is shown; the dialog for the selection of a
    person is opened first. }
  if gvar_02536BA0 > 1 then
  begin
    DataModule2.Table9.Filter := 'gebjahr<=' + IntToStr(gvar_02536BA0) +
                               ' and taufjahr<=' + IntToStr(gvar_02536BA0);
    DataModule2.Table9.Filtered := True;
    DBText1.Color := $00FFFF;
  end;
  DBGrid1.DataSource := DataModule2.DataSource9;
  DataModule2.Table9.IndexName := 'geba';
  DataModule2.Table1.Refresh;
  DataModule2.Table3.Refresh;
  DataModule2.Table9.Refresh;
  DataModule2.Table8.Refresh;
  DataModule2.Table17.Open;
  DataModule2.Table17.Refresh;
  Form3.Edit1.Text := '';
  Form3.ShowModal;
  DBGrid1.Refresh;
  DBGrid1.SetFocus;
end;

procedure TForm1.fcapt;
var
  s: string;
begin
  { The title of the window is asked for and written into the configuration
    file as well. }
  gvar_02536BB4 := Copy(Caption, 1, 32);
  s := InputBox('Fenstertitel', 'Neuer Fenstertitel: ', gvar_02536BB4);
  gvar_02536BB4 := Copy(s, 1, 32);
  Caption := gvar_02536BB4;
  Application.Title := gvar_02536BB4;
end;

procedure TForm1.Fenstertitelndern1Click(Sender: TObject);
begin
  { the title of the window is changed. }
  fcapt;
end;


procedure TForm1.HofnamenVerwaltung1Click(Sender: TObject);
begin
  DataModule2.Table37.Open;

  DataModule2.Table37.First;

  Form39.ShowModal;

end;

procedure TForm1.Vettern1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Verwandtschaft1Click(Sender: TObject);
var
  s: string;
begin
  { The person is looked for in the list of the relations. }
  elem('aus');
  ucase(DataModule2.Table1Name.AsString, s);
  Label27.Caption := 'Ist ' + s + ' ' + DataModule2.Table1Vornamen.AsString +
                     ' blutsverwandt mit:';
  TabSheet7.Show;
  Form3.Edit1.Text := '';
  gvar_0253692C := 'Verw';
  Form3.ShowModal;
end;

procedure TForm1.DBEdit6Exit(Sender: TObject);
begin
  { The name of the estate is written into the list of the estates. }
  if Trim(DataModule2.Table1Hausname.AsString) <> '' then
    if not DataModule2.Table37.FindKey([DataModule2.Table1Hausname.AsString]) then
    begin
      DataModule2.Table37.Append;
      DataModule2.Table37Hofname.AsString := DataModule2.Table1Hausname.AsString;
      DataModule2.Table37.Post;
    end;
end;


procedure TForm1.EhenKiordnen1Click(Sender: TObject);
var
  anzahl, laufnummer, personennummer, vor: Integer;
begin
  { The marriages and the children are sorted by the date of the
    marriage resp. of the birth and are numbered within the family.

    The marriages of a person get the numbers 01, 02, ... (the field
    "Indm" of the table of the marriages), the children of a father
    resp. of a mother the numbers 01, 02, ... (the field "Indt" of the
    table of the persons).  The year of the birth resp. of the baptism
    is written into the field "Indj". }
  if MessageDlg('Wenn Sie fortfahren, werden alle Ehen und Kinder nach ' +
    'Heirats- bzw.Geburtsdatum sortiert!', mtWarning, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  Screen.Cursor := crHourGlass;
  personennummer := DataModule2.Table1Nummer.AsInteger;
  laufnummer := 1;
  Label18.Caption := '';
  Label18.Refresh;
  Label18.Visible := True;
  Label19.Caption := 'Ehen/Ki.ordnen';
  Label19.Visible := True;
  Label19.Refresh;

  { The table of the marriages is detached from its data source, so
    that the index can be changed and the records can be read freely.
    In Delphi 9 the property MasterSource is the data source of the
    table; the property DataSource itself cannot be written. }
  DataModule2.Table5.MasterSource := nil;
  DataModule2.Table5.IndexName := 'mh';
  DataModule2.Table5.First;
  vor := DataModule2.Table5Nummer.AsInteger;
  anzahl := 0;

  while not DataModule2.Table5.Eof do
  begin
    Label18.Caption := IntToStr(laufnummer);
    Label18.Refresh;
    Inc(laufnummer);
    if DataModule2.Table5Nummer.AsInteger = vor then
    begin
      Inc(anzahl);
      DataModule2.Table5.Edit;
      DataModule2.Table5Indm.AsString := RightStr('00' + IntToStr(anzahl), 2);
      DataModule2.Table5.Post;
    end
    else
    begin
      anzahl := 1;
      vor := DataModule2.Table5Nummer.AsInteger;
      DataModule2.Table5.Edit;
      DataModule2.Table5Indm.AsString := RightStr('00' + IntToStr(anzahl), 2);
      DataModule2.Table5.Post;
    end;
    DataModule2.Table5.Next;
  end;

  { The children are numbered per father. }
  DataModule2.Table5.MasterSource := DataModule2.DataSource1;
  DataModule2.Table1.DisableControls;
  DataModule2.Table1.IndexName := 'vato';
  DataModule2.Table1.First;
  vor := DataModule2.Table1Vater.AsInteger;
  anzahl := 0;

  while not DataModule2.Table1.Eof do
  begin
    Label18.Caption := IntToStr(laufnummer);
    Label18.Refresh;
    Inc(laufnummer);
    if DataModule2.Table1Vater.AsInteger = vor then
    begin
      Inc(anzahl);
      DataModule2.Table1.Edit;
      DataModule2.Table1Indj.AsString := DataModule2.Table1Gebjahr.AsString;
      if DataModule2.Table1Taufjahr.AsString > DataModule2.Table1Gebjahr.AsString then
        DataModule2.Table1Indj.AsString := DataModule2.Table1Taufjahr.AsString;
      DataModule2.Table1Indt.AsString := RightStr('00' + IntToStr(anzahl), 2);
      DataModule2.Table1.Post;
    end
    else
    begin
      anzahl := 1;
      vor := DataModule2.Table1Vater.AsInteger;
      DataModule2.Table1.Edit;
      DataModule2.Table1Indj.AsString := DataModule2.Table1Gebjahr.AsString;
      if DataModule2.Table1Taufjahr.AsString > DataModule2.Table1Gebjahr.AsString then
        DataModule2.Table1Indj.AsString := DataModule2.Table1Taufjahr.AsString;
      DataModule2.Table1Indt.AsString := RightStr('00' + IntToStr(anzahl), 2);
      DataModule2.Table1.Post;
    end;
    DataModule2.Table1.Next;
  end;

  { The children without a father are numbered per mother. }
  DataModule2.Table1.IndexName := 'muto';
  DataModule2.Table1.First;
  vor := DataModule2.Table1Mutter.AsInteger;
  anzahl := 0;

  while not DataModule2.Table1.Eof do
  begin
    Label18.Caption := IntToStr(laufnummer);
    Label18.Refresh;
    Inc(laufnummer);
    if DataModule2.Table1Vater.AsInteger <> 0 then
    begin
      { the child already has a father and was counted above }
    end
    else if DataModule2.Table1Mutter.AsInteger = vor then
    begin
      Inc(anzahl);
      DataModule2.Table1.Edit;
      DataModule2.Table1Indj.AsString := DataModule2.Table1Gebjahr.AsString;
      if DataModule2.Table1Taufjahr.AsString > DataModule2.Table1Gebjahr.AsString then
        DataModule2.Table1Indj.AsString := DataModule2.Table1Taufjahr.AsString;
      DataModule2.Table1Indt.AsString := RightStr('00' + IntToStr(anzahl), 2);
      DataModule2.Table1.Post;
    end
    else
    begin
      anzahl := 1;
      vor := DataModule2.Table1Mutter.AsInteger;
      DataModule2.Table1.Edit;
      DataModule2.Table1Indj.AsString := DataModule2.Table1Gebjahr.AsString;
      if DataModule2.Table1Taufjahr.AsString > DataModule2.Table1Gebjahr.AsString then
        DataModule2.Table1Indj.AsString := DataModule2.Table1Taufjahr.AsString;
      DataModule2.Table1Indt.AsString := RightStr('00' + IntToStr(anzahl), 2);
      DataModule2.Table1.Post;
    end;
    DataModule2.Table1.Next;
  end;

  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.FindKey([personennummer]);
  DataModule2.Table5.EnableControls;
  DataModule2.Table1.EnableControls;
  Label18.Visible := False;
  Label19.Visible := False;
  Screen.Cursor := crDefault;
  anzeigen;
end;

procedure TForm1.ComboBox20Exit(Sender: TObject);
var
  val: AnsiString;
begin
  //0060D28C: Gemeinsamer Exit-Handler der Tauf-/Hochzeits-/Sterbeort-
  //und Quellenfelder: Wert in die passende Table5-Spalte schreiben und
  //einen noch nicht registrierten Ort nachtragen.
  val := '';
  if (Sender = ComboBox1) or (Sender = ComboBox2) or (Sender = ComboBox3) then
  begin
    if Sender = ComboBox1 then
      val := ComboBox1.Text;
    if Sender = ComboBox2 then
      val := ComboBox2.Text;
    if Sender = ComboBox3 then
      val := ComboBox3.Text;
  end;
  if Sender = ComboBox20 then
  begin
    val := ComboBox20.Text;
    DataModule2.Table5.Edit;
    DataModule2.Table5Hort.AsString := val;
    DataModule2.Table5.Post;
  end;
  if Sender = ComboBox21 then
  begin
    val := ComboBox21.Text;
    DataModule2.Table5.Edit;
    DataModule2.Table5Saort.AsString := val;
    DataModule2.Table5.Post;
  end;
  if Sender = ComboBox22 then
  begin
    val := ComboBox22.Text;
    DataModule2.Table5.Edit;
    DataModule2.Table5Schort.AsString := val;
    DataModule2.Table5.Post;
  end;
  if Trim(val) <> '' then
  begin
    DataModule2.Table13.Open;
    DataModule2.Table13.IndexName := 'ort_';
    DataModule2.Table13.First;
    if (Trim(val) <> '') and not DataModule2.Table13.FindKey([val]) then
    begin
      ComboBox1.Items.Add(val);
      ComboBox2.Items.Add(val);
      ComboBox3.Items.Add(val);
      ComboBox6.Items.Add(val);
      ComboBox7.Items.Add(val);
      ComboBox8.Items.Add(val);
      ComboBox9.Items.Add(val);
      ComboBox16.Items.Add(val);
      ComboBox17.Items.Add(val);
      ComboBox18.Items.Add(val);
      ComboBox19.Items.Add(val);
      ComboBox20.Items.Add(val);
      ComboBox21.Items.Add(val);
      ComboBox22.Items.Add(val);
      ComboBox26.Items.Add(val);
      DataModule2.Table13.Append;
      DataModule2.Table13Ort.AsString := val;
      DataModule2.Table13.Post;
    end;
  end;
  if gvar_02536914 = 1 then
  begin
    DataModule2.Table5.Edit;
    if Sender = ComboBox20 then
      DataModule2.Table5Hort.AsString := ComboBox20.Text;
    if Sender = ComboBox21 then
      DataModule2.Table5Saort.AsString := ComboBox21.Text;
    if Sender = ComboBox22 then
      DataModule2.Table5Schort.AsString := ComboBox22.Text;
    if Sender = ComboBox23 then
      DataModule2.Table5Hqu.AsString := ComboBox23.Text;
    if Sender = ComboBox24 then
      DataModule2.Table5Saqu.AsString := ComboBox24.Text;
    if Sender = ComboBox25 then
      DataModule2.Table5Schqu.AsString := ComboBox25.Text;
    DataModule2.Table5.Post;
  end;
end;

procedure TForm1.ComboBox11Exit(Sender: TObject);
var
  val: AnsiString;
begin
  //0060D780: Gemeinsamer Exit-Handler der Quellenfelder: Text in die
  //passende Table1-/Table5-Spalte schreiben, unbekannten Titel in der
  //Titeltabelle (Table38) nachtragen.
  val := '';
  DataModule2.Table1.Edit;
  DataModule2.Table5.Edit;
  if Sender = ComboBox11 then
  begin
    val := ComboBox11.Text;
    DataModule2.Table1Quelle.AsString := ComboBox11.Text;
  end;
  if Sender = ComboBox12 then
  begin
    val := ComboBox12.Text;
    DataModule2.Table1Quelleg.AsString := ComboBox12.Text;
  end;
  if Sender = ComboBox13 then
  begin
    val := ComboBox13.Text;
    DataModule2.Table1Quellet.AsString := ComboBox13.Text;
  end;
  if Sender = ComboBox14 then
  begin
    val := ComboBox14.Text;
    DataModule2.Table1Quelles.AsString := ComboBox14.Text;
  end;
  if Sender = ComboBox15 then
  begin
    val := ComboBox15.Text;
    DataModule2.Table1Quelleb.AsString := ComboBox15.Text;
  end;
  if Sender = ComboBox23 then
  begin
    val := ComboBox23.Text;
    DataModule2.Table5Hqu.AsString := ComboBox23.Text;
  end;
  if Sender = ComboBox24 then
  begin
    val := ComboBox24.Text;
    DataModule2.Table5Saqu.AsString := ComboBox24.Text;
  end;
  if Sender = ComboBox25 then
  begin
    val := ComboBox25.Text;
    DataModule2.Table5Schqu.AsString := ComboBox25.Text;
  end;
  DataModule2.Table1.Post;
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  val := Trim(val);
  if (val <> '') and not DataModule2.Table38.FindKey([val]) then
  begin
    ComboBox11.Items.Add(val);
    ComboBox12.Items.Add(val);
    ComboBox13.Items.Add(val);
    ComboBox14.Items.Add(val);
    ComboBox15.Items.Add(val);
    ComboBox23.Items.Add(val);
    ComboBox24.Items.Add(val);
    ComboBox25.Items.Add(val);
    DataModule2.Table38.Append;
    DataModule2.Table38Titel.AsString := val;
    DataModule2.Table38.Post;
  end;
end;

procedure TForm1.StringGrid5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  f: TextFile;
  s: AnsiString;
  i: Integer;
begin
  //0060C3A8: Rechtsklick - Suchergebnisse der StringGrid5 in Textdatei
  //schreiben (Tabulator zwischen den Spalten).
  if Button = mbRight then
  begin
    if MessageDlg('Ergebnisse in Datei schreiben ?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    begin
      SaveDialog1.DefaultExt := 'txt';
      SaveDialog1.Filter := 'Text-Dateien (*.txt)|*.txt';
      if SaveDialog1.Execute then
      begin
        if Trim(SaveDialog1.FileName) <> '' then
        begin
          AssignFile(f, SaveDialog1.FileName);
          Rewrite(f);
          if IOResult = 0 then
          begin
            for i := 0 to StringGrid5.RowCount - 1 do
              WriteLn(f, StringGrid5.Cells[0, i] + #9 +
                StringGrid5.Cells[1, i] + #9 + StringGrid5.Cells[2, i] + #9 +
                StringGrid5.Cells[3, i] + #9 + StringGrid5.Cells[4, i]);
            CloseFile(f);
          end;
        end;
      end;
    end;
  end;
end;

procedure TForm1.ComboBox4Exit(Sender: TObject);
var
  name, vorname, ortval: AnsiString;
begin
  //0060C678: Gemeinsamer Exit-Handler der Personen- und Ortsrelationen.
  //Der Text des verlassenen Feldes wird in die passende Table1-Spalte
  //geschrieben, unbekannte Namen/Orte nachgetragen und alle Folgefelder
  //neu synchronisiert.
  name := '';
  vorname := '';
  if Sender = ComboBox4 then
  begin
    name := ComboBox4.Text;
    vorname := name;
  end;
  if Sender = ComboBox10 then
  begin
    name := ComboBox10.Text;
    vorname := name;
  end;
  if Trim(name) <> '' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Name.AsString := name;
    if not DataModule2.Table12.FindKey([name]) then
    begin
      ComboBox4.Items.Add(name);
      ComboBox10.Items.Add(name);
      DataModule2.Table12.Append;
      DataModule2.Table12Name.AsString := name;
      DataModule2.Table12.Post;
    end;
    schen1.Enabled := True;
  end;
  if DataModule2.Table1Name.AsString = '' then
    Exit;
  if DataModule2.Table1Vornamen.AsString = '' then
    Exit;
  if (ComboBox10.Text = DataModule2.Table1Name.AsString) and
     (ComboBox4.Text = DataModule2.Table1Name.AsString) and
     (ComboBox6.Text = DataModule2.Table1Gebort.AsString) and
     (ComboBox7.Text = DataModule2.Table1Taufort.AsString) and
     (ComboBox8.Text = DataModule2.Table1Stort.AsString) and
     (ComboBox9.Text = DataModule2.Table1Begort.AsString) and
     (ComboBox16.Text = DataModule2.Table1Gebort.AsString) and
     (ComboBox17.Text = DataModule2.Table1Taufort.AsString) and
     (ComboBox18.Text = DataModule2.Table1Stort.AsString) and
     (ComboBox19.Text = DataModule2.Table1Begort.AsString) and
     (ComboBox26.Text = DataModule2.Table1Ort.AsString) then
    Exit;
  if DataModule2.Table1Nummer.AsInteger = 0 then
  begin
    DataModule2.Table1.Edit;
    if DataModule2.Table4.RecordCount > 0 then
    begin
      DataModule2.Table4.First;
      DataModule2.Table1Nummer.AsInteger := DataModule2.Table4Num.AsInteger;
      DataModule2.Table4.Delete;
      if DataModule2.Table1Nummer.AsInteger > gvar_02536944 then
        gvar_02536944 := DataModule2.Table1Nummer.AsInteger;
    end
    else
    begin
      DataModule2.Table1Nummer.AsInteger := gvar_02536944 + 1;
      Inc(gvar_02536944);
    end;
  end
  else
    DataModule2.Table1.Edit;
  ortval := '';
  if Sender = ComboBox6 then
  begin
    DataModule2.Table1Gebort.AsString := ComboBox6.Text;
    ortval := DataModule2.Table1Gebort.AsString;
  end;
  if Sender = ComboBox7 then
  begin
    DataModule2.Table1Taufort.AsString := ComboBox7.Text;
    ortval := DataModule2.Table1Taufort.AsString;
  end;
  if Sender = ComboBox8 then
  begin
    DataModule2.Table1Stort.AsString := ComboBox8.Text;
    ortval := DataModule2.Table1Stort.AsString;
  end;
  if Sender = ComboBox9 then
  begin
    DataModule2.Table1Begort.AsString := ComboBox9.Text;
    ortval := DataModule2.Table1Begort.AsString;
  end;
  if Sender = ComboBox4 then
  begin
    DataModule2.Table1Name.AsString := ComboBox4.Text;
    ortval := DataModule2.Table1Name.AsString;
  end;
  if Sender = ComboBox10 then
  begin
    DataModule2.Table1Name.AsString := ComboBox10.Text;
    ortval := DataModule2.Table1Name.AsString;
  end;
  if Sender = ComboBox16 then
  begin
    DataModule2.Table1Gebort.AsString := ComboBox16.Text;
    ortval := DataModule2.Table1Gebort.AsString;
  end;
  if Sender = ComboBox17 then
  begin
    DataModule2.Table1Taufort.AsString := ComboBox17.Text;
    ortval := DataModule2.Table1Taufort.AsString;
  end;
  if Sender = ComboBox18 then
  begin
    DataModule2.Table1Stort.AsString := ComboBox18.Text;
    ortval := DataModule2.Table1Stort.AsString;
  end;
  if Sender = ComboBox19 then
  begin
    DataModule2.Table1Begort.AsString := ComboBox19.Text;
    ortval := DataModule2.Table1Begort.AsString;
  end;
  if Sender = ComboBox26 then
  begin
    DataModule2.Table1Ort.AsString := ComboBox26.Text;
    ortval := DataModule2.Table1Ort.AsString;
  end;
  DataModule2.Table1.Post;
  { Result fields all sync }
  ComboBox4.Text := DataModule2.Table1Name.AsString;
  ComboBox10.Text := DataModule2.Table1Name.AsString;
  ComboBox6.Text := DataModule2.Table1Gebort.AsString;
  ComboBox7.Text := DataModule2.Table1Taufort.AsString;
  ComboBox8.Text := DataModule2.Table1Stort.AsString;
  ComboBox9.Text := DataModule2.Table1Begort.AsString;
  ComboBox16.Text := DataModule2.Table1Gebort.AsString;
  ComboBox17.Text := DataModule2.Table1Taufort.AsString;
  ComboBox18.Text := DataModule2.Table1Stort.AsString;
  ComboBox19.Text := DataModule2.Table1Begort.AsString;
  ComboBox26.Text := DataModule2.Table1Ort.AsString;
  { Maintain the table with all place names. }
  DataModule2.Table13.Open;
  DataModule2.Table13.IndexName := 'ort_';
  if Trim(ortval) <> '' then
  begin
    if not DataModule2.Table13.FindKey([ortval]) then
    begin
      DataModule2.Table13.Append;
      DataModule2.Table13Ort.AsString := ortval;
      DataModule2.Table13.Post;
      ComboBox6.Items.Add(ortval);
      ComboBox7.Items.Add(ortval);
      ComboBox8.Items.Add(ortval);
      ComboBox9.Items.Add(ortval);
      ComboBox16.Items.Add(ortval);
      ComboBox17.Items.Add(ortval);
      ComboBox18.Items.Add(ortval);
      ComboBox19.Items.Add(ortval);
      ComboBox20.Items.Add(ortval);
      ComboBox21.Items.Add(ortval);
      ComboBox22.Items.Add(ortval);
      ComboBox1.Items.Add(ortval);
      ComboBox2.Items.Add(ortval);
      ComboBox3.Items.Add(ortval);
      ComboBox26.Items.Add(ortval);
    end;
  end;
  { Maintain the table with all name combinations. }
  DataModule2.Table12.Open;
  DataModule2.Table12.IndexName := '';
  DataModule2.Table12.First;
  if Trim(name) <> '' then
  begin
    if not DataModule2.Table12.FindKey([name]) then
    begin
      DataModule2.Table12.Append;
      DataModule2.Table12Name.AsString := name;
      DataModule2.Table12.Post;
    end;
  end;
  { If the record receives a new number, the number is removed from the
    idle numbers table. }
  if DataModule2.Table4.FindKey([DataModule2.Table1Nummer.AsInteger]) then
    DataModule2.Table4.Delete;
end;

procedure TForm1.DBEdit32Exit(Sender: TObject);
begin
  { The new entry is written into the list of the occupations. }
  DataModule2.Table35.IndexName := 'ber';
  if Trim(DBEdit32.Text) <> '' then
    if not DataModule2.Table35.FindKey([DBEdit32.Text]) then
    begin
      DataModule2.Table35.Append;
      DataModule2.Table35Occ.AsString := DBEdit32.Text;
      DataModule2.Table35.Post;
    end;
end;


procedure TForm1.TabSheet4Show(Sender: TObject);
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.BerufeVerwaltung1Click(Sender: TObject);
begin
  Form36.ShowModal;

end;

procedure TForm1.DBEdit3Exit(Sender: TObject);
begin
  { The new entry is written into the list of the occupations. }
  DataModule2.Table35.IndexName := 'ber';
  if Trim(DBEdit3.Text) <> '' then
    if not DataModule2.Table35.FindKey([DBEdit3.Text]) then
    begin
      DataModule2.Table35.Append;
      DataModule2.Table35Occ.AsString := DBEdit3.Text;
      DataModule2.Table35.Post;
    end;
end;


procedure TForm1.GebDatumTaufdatum1Click(Sender: TObject);
var
  s: AnsiString;
begin
  //006180D8: Tauforte "Arzbach" bzw. "Wackersberg" in "Bad Toelz"
  //umschreiben (Tisch der ganzen Datenbank).
  DataModule2.Table1.Open;
  DataModule2.Table1.First;
  Screen.Cursor := crHourGlass;
  DataModule2.Table1.DisableControls;
  while not DataModule2.Table1.EOF do
  begin
    if (Trim(DataModule2.Table1Taufort.AsString) = 'Arzbach') or
       (Trim(DataModule2.Table1Taufort.AsString) = 'Wackersberg') then
    begin
      DataModule2.Table1.Edit;
      DataModule2.Table1Taufort.AsString := 'T' + #$F6 + 'lz';
      DataModule2.Table1.Post;
    end;
    DataModule2.Table1.Next;
  end;
  DataModule2.Table1.EnableControls;
  Screen.Cursor := crDefault;
end;

procedure TForm1.DBComboBox1Exit(Sender: TObject);
begin
  { The kind of the relation is written into the field of the marriage. }
  if Pos('heschl', DataModule2.Table5Verbind.AsString) > 0 then
  begin
    DataModule2.Table5.Edit;
    DataModule2.Table5Verbind.AsString := 'Eheschliessung';
    DataModule2.Table5.Post;
  end;
  if Pos('dere Bez', DataModule2.Table5Verbind.AsString) > 0 then
  begin
    DataModule2.Table5.Edit;
    DataModule2.Table5Verbind.AsString := 'andere Beziehung';
    DataModule2.Table5.Post;
  end;
end;

procedure TForm1.DBEdit10Change(Sender: TObject);
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBMemo1Exit(Sender: TObject);
begin
  { the data is saved when the memo is left. }
  speich1;
end;


procedure TForm1.PopupMenu2Popup(Sender: TObject);
begin
  { The entries of the menu are only enabled when a person is worked on
    and a person is marked in the list of the children. }
  PopupMenu2.Items[0].Enabled := False;
  PopupMenu2.Items[1].Enabled := False;
  if DataModule2.Table1Nummer.AsInteger > 0 then
  begin
    PopupMenu2.Items[0].Enabled := True;
    PopupMenu2.Items[1].Enabled := False;
    if Trim(StringGrid2.Cells[1, 0]) <> '' then
      PopupMenu2.Items[1].Enabled := True;
  end;
end;

procedure TForm1.DBComboBox7Exit(Sender: TObject);
begin
  { The religion is taken over into the record of the person. }
  if DBComboBox7.Text <> '' then
    DataModule2.Table1Religion.AsString := DBComboBox7.Text;
end;


procedure TForm1.ComboBox5Exit(Sender: TObject);
var
  s: AnsiString;
begin
  //006183B8: Relationsart des Textes normalisieren.
  s := ComboBox5.Text;
  if Pos('heschl', s) > 0 then
    ComboBox5.Text := 'Eheschliessung';
  s := ComboBox5.Text;
  if Pos('dere Bez', s) > 0 then
    ComboBox5.Text := 'andere Beziehung';
end;

procedure TForm1.Lb_speich(Sender: TObject);
var
  art: string;
  f: TextFile;
  i: Integer;
begin
  { The list of the form that sent the message is written into a text
    file. }
  art := '';
  if Form28 = Sender then
    art := 'Namen';
  if Form14 = Sender then
    art := 'Orte';
  if Form36 = Sender then
    art := 'Berufe';
  if Form29 = Sender then
    art := 'Quellen';
  if Form39 = Sender then
    art := 'Hofnamen';

  SaveDialog1.DefaultExt := 'txt';
  SaveDialog1.Filter := 'Text-Dateien (*.txt)|*.txt';
  { The original writes the value 2 into the options; in the VCL of the
    original that was ofCreateNone, in Delphi 9 it is ofHideReadOnly. }
  SaveDialog1.Options := [ofHideReadOnly];
  SaveDialog1.FileName := art + '.txt';
  if SaveDialog1.Execute then
  begin
    AssignFile(f, SaveDialog1.FileName);
    Rewrite(f);
    if IOResult = 0 then
    begin
      WriteLn(f, art);
      WriteLn(f, ' ');
      if Form28 = Sender then
        for i := 0 to Form28.ListBox1.Count - 1 do
          WriteLn(f, Form28.ListBox1.Items[i]);
      if Form14 = Sender then
        for i := 0 to Form14.ListBox1.Count - 1 do
          WriteLn(f, Form14.ListBox1.Items[i]);
      if Form36 = Sender then
        for i := 0 to Form36.ListBox1.Count - 1 do
          WriteLn(f, Form36.ListBox1.Items[i]);
      if Form29 = Sender then
        for i := 0 to Form29.ListBox1.Count - 1 do
          WriteLn(f, Form29.ListBox1.Items[i]);
      if Form39 = Sender then
        for i := 0 to Form39.ListBox1.Count - 1 do
          WriteLn(f, Form39.ListBox1.Items[i]);
      CloseFile(f);
    end;
  end;
end;

procedure TForm1.DBEdit9Change(Sender: TObject);
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  { One of the pictures is selected.  The first click writes the number of
    the picture into the label 98 and the name of the file into the label
    96, the second click writes the number of the picture into the label
    94 and the name of the file into the label 97. }
  Label95.Caption := 'ausgew' + #228 + 'hlt:';

  if Sender = Image2 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 1';
      Label97.Caption := Image2.Hint + '*2';
    end
    else
    begin
      Label98.Caption := 'Bild 1';
      Label96.Caption := Image2.Hint + '*2';
    end;
  end;

  if Sender = Image3 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 2';
      Label97.Caption := Image3.Hint + '*3';
    end
    else
    begin
      Label98.Caption := 'Bild 2';
      Label96.Caption := Image3.Hint + '*3';
    end;
  end;

  if Sender = Image4 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 3';
      Label97.Caption := Image4.Hint + '*4';
    end
    else
    begin
      Label98.Caption := 'Bild 3';
      Label96.Caption := Image4.Hint + '*4';
    end;
  end;

  if Sender = Image5 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 4';
      Label97.Caption := Image5.Hint + '*5';
    end
    else
    begin
      Label98.Caption := 'Bild 4';
      Label96.Caption := Image5.Hint + '*5';
    end;
  end;

  if Sender = Image6 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 5';
      Label97.Caption := Image6.Hint + '*6';
    end
    else
    begin
      Label98.Caption := 'Bild 5';
      Label96.Caption := Image6.Hint + '*6';
    end;
  end;

  if Sender = Image7 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 6';
      Label97.Caption := Image7.Hint + '*7';
    end
    else
    begin
      Label98.Caption := 'Bild 6';
      Label96.Caption := Image7.Hint + '*7';
    end;
  end;

  if Sender = Image8 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 7';
      Label97.Caption := Image8.Hint + '*8';
    end
    else
    begin
      Label98.Caption := 'Bild 7';
      Label96.Caption := Image8.Hint + '*8';
    end;
  end;

  if Sender = Image9 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 8';
      Label97.Caption := Image9.Hint + '*9';
    end
    else
    begin
      Label98.Caption := 'Bild 8';
      Label96.Caption := Image9.Hint + '*9';
    end;
  end;

  if Sender = Image10 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 9';
      Label97.Caption := Image10.Hint + '*10';
    end
    else
    begin
      Label98.Caption := 'Bild 9';
      Label96.Caption := Image10.Hint + '*10';
    end;
  end;

  if Sender = Image11 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 10';
      Label97.Caption := Image11.Hint + '*11';
    end
    else
    begin
      Label98.Caption := 'Bild 10';
      Label96.Caption := Image11.Hint + '*11';
    end;
  end;

  if Sender = Image12 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 11';
      Label97.Caption := Image12.Hint + '*12';
    end
    else
    begin
      Label98.Caption := 'Bild 11';
      Label96.Caption := Image12.Hint + '*12';
    end;
  end;

  if Sender = Image13 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 12';
      Label97.Caption := Image13.Hint + '*13';
    end
    else
    begin
      Label98.Caption := 'Bild 12';
      Label96.Caption := Image13.Hint + '*13';
    end;
  end;

  if Sender = Image14 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 13';
      Label97.Caption := Image14.Hint + '*14';
    end
    else
    begin
      Label98.Caption := 'Bild 13';
      Label96.Caption := Image14.Hint + '*14';
    end;
  end;

  if Sender = Image15 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 14';
      Label97.Caption := Image15.Hint + '*15';
    end
    else
    begin
      Label98.Caption := 'Bild 14';
      Label96.Caption := Image15.Hint + '*15';
    end;
  end;

  if Sender = Image16 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 15';
      Label97.Caption := Image16.Hint + '*16';
    end
    else
    begin
      Label98.Caption := 'Bild 15';
      Label96.Caption := Image16.Hint + '*16';
    end;
  end;

  if Sender = Image17 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 16';
      Label97.Caption := Image17.Hint + '*17';
    end
    else
    begin
      Label98.Caption := 'Bild 16';
      Label96.Caption := Image17.Hint + '*17';
    end;
  end;

  if Sender = Image18 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 17';
      Label97.Caption := Image18.Hint + '*18';
    end
    else
    begin
      Label98.Caption := 'Bild 17';
      Label96.Caption := Image18.Hint + '*18';
    end;
  end;

  if Sender = Image19 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 18';
      Label97.Caption := Image19.Hint + '*19';
    end
    else
    begin
      Label98.Caption := 'Bild 18';
      Label96.Caption := Image19.Hint + '*19';
    end;
  end;

  if Sender = Image20 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 19';
      Label97.Caption := Image20.Hint + '*20';
    end
    else
    begin
      Label98.Caption := 'Bild 19';
      Label96.Caption := Image20.Hint + '*20';
    end;
  end;

  if Sender = Image21 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 20';
      Label97.Caption := Image21.Hint + '*21';
    end
    else
    begin
      Label98.Caption := 'Bild 20';
      Label96.Caption := Image21.Hint + '*21';
    end;
  end;

  if Sender = Image22 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 21';
      Label97.Caption := Image22.Hint + '*22';
    end
    else
    begin
      Label98.Caption := 'Bild 21';
      Label96.Caption := Image22.Hint + '*22';
    end;
  end;

  if Sender = Image23 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 22';
      Label97.Caption := Image23.Hint + '*23';
    end
    else
    begin
      Label98.Caption := 'Bild 22';
      Label96.Caption := Image23.Hint + '*23';
    end;
  end;

  if Sender = Image24 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 23';
      Label97.Caption := Image24.Hint + '*24';
    end
    else
    begin
      Label98.Caption := 'Bild 23';
      Label96.Caption := Image24.Hint + '*24';
    end;
  end;

  if Sender = Image25 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 24';
      Label97.Caption := Image25.Hint + '*25';
    end
    else
    begin
      Label98.Caption := 'Bild 24';
      Label96.Caption := Image25.Hint + '*25';
    end;
  end;

  if Sender = Image26 then
  begin
    if Trim(Label98.Caption) <> '' then
    begin
      Label94.Caption := 'Bild 25';
      Label97.Caption := Image26.Hint + '*26';
    end
    else
    begin
      Label98.Caption := 'Bild 25';
      Label96.Caption := Image26.Hint + '*26';
    end;
  end;
end;

procedure TForm1.TabSheet9Show(Sender: TObject);
var
  pfad, nummer, name: string;
  zeichen: Char;
begin
  { The pictures of the person are shown.  The files have the names
    b<number><letter>.jpg in the directory of the pictures.  The letter
    starts at the character 61; the cases of the letter run from 'a' to
    's', one picture for every image.

    The original hides the image 22 twice and does not hide the image 26;
    that is reproduced here. }
  Label98.Caption := '';
  Label94.Caption := '';
  pfad := gvar_02536B9C + 'bilder\';
  Image2.Visible := False;
  Image3.Visible := False;
  Image4.Visible := False;
  Image5.Visible := False;
  Image6.Visible := False;
  Image7.Visible := False;
  Image8.Visible := False;
  Image9.Visible := False;
  Image10.Visible := False;
  Image11.Visible := False;
  Image12.Visible := False;
  Image13.Visible := False;
  Image14.Visible := False;
  Image15.Visible := False;
  Image16.Visible := False;
  Image17.Visible := False;
  Image18.Visible := False;
  Image19.Visible := False;
  Image20.Visible := False;
  Image21.Visible := False;
  Image22.Visible := False;
  Image22.Visible := False;
  Image23.Visible := False;
  Image24.Visible := False;
  Image25.Visible := False;

  ucase(DataModule2.Table1Name.AsString, name);
  Label72.Caption := name + ' ' + DataModule2.Table1Vornamen.AsString;

  nummer := IntToStr(DataModule2.Table1Nummer.AsInteger);
  zeichen := #61;
  repeat
    case zeichen of
      'a': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image2.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image2.Visible := True;
              Image2.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'b': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image3.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image3.Visible := True;
              Image3.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'c': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image4.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image4.Visible := True;
              Image4.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'd': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image5.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image5.Visible := True;
              Image5.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'e': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image6.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image6.Visible := True;
              Image6.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'f': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image7.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image7.Visible := True;
              Image7.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'g': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image8.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image8.Visible := True;
              Image8.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'h': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image9.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image9.Visible := True;
              Image9.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'i': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image10.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image10.Visible := True;
              Image10.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'j': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image11.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image11.Visible := True;
              Image11.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'k': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image12.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image12.Visible := True;
              Image12.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'l': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image13.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image13.Visible := True;
              Image13.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'm': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image14.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image14.Visible := True;
              Image14.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'n': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image15.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image15.Visible := True;
              Image15.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'o': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image16.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image16.Visible := True;
              Image16.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'p': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image17.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image17.Visible := True;
              Image17.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'q': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image18.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image18.Visible := True;
              Image18.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      'r': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image19.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image19.Visible := True;
              Image19.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
      's': if FileExists(pfad + 'b' + nummer + zeichen + '.jpg') then
            begin
              Image20.Picture.LoadFromFile(pfad + 'b' + nummer + zeichen + '.jpg');
              Image20.Visible := True;
              Image20.Hint := pfad + 'b' + nummer + zeichen + '.jpg';
            end;
    end;
    Inc(zeichen);
  until zeichen = #122;
end;

procedure TForm1.Basen1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.TabSheet2Show(Sender: TObject);
begin
  { The field for the name of the father gets the input. }

  DBEdit2.SetFocus;

end;

procedure TForm1.DBEdit5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //006180BC: leerer Koerper (MouseDown-Funktion wird nicht genutzt).
end;

procedure TForm1.DBEdit8Change(Sender: TObject);
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.TabSheet9Exit(Sender: TObject);
begin
  //00617F78: Beim Verlassen der Uebersichtsseite alle Bilder loeschen.
  Image2.Picture := nil;
  Image3.Picture := nil;
  Image4.Picture := nil;
  Image5.Picture := nil;
  Image6.Picture := nil;
  Image7.Picture := nil;
  Image8.Picture := nil;
  Image9.Picture := nil;
  Image10.Picture := nil;
  Image11.Picture := nil;
  Image12.Picture := nil;
  Image13.Picture := nil;
  Image14.Picture := nil;
  Image15.Picture := nil;
  Image16.Picture := nil;
  Image17.Picture := nil;
  Image18.Picture := nil;
  Image19.Picture := nil;
  Image20.Picture := nil;
  Image21.Picture := nil;
  Image22.Picture := nil;
  Image23.Picture := nil;
  Image24.Picture := nil;
  Image25.Picture := nil;
end;

procedure TForm1.ComboBox4DblClick(Sender: TObject);
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.Vorlist(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBLookupComboBox6KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the place of the death. }
  if Key = ' ' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Stort.AsString := '';
    DataModule2.Table1.Post;
  end;
end;


procedure TForm1.DBLookupComboBox7KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the place of the burial. }
  if Key = ' ' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Begort.AsString := '';
    DataModule2.Table1.Post;
  end;
end;


procedure TForm1.DBLookupComboBox4KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the place of the birth. }
  if Key = ' ' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Gebort.AsString := '';
    DataModule2.Table1.Post;
  end;
end;


procedure TForm1.DBLookupComboBox5KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the place of the baptism. }
  if Key = ' ' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Taufort.AsString := '';
    DataModule2.Table1.Post;
  end;
end;


procedure TForm1.DBLookupComboBox10KeyPress(Sender: TObject; var Key: Char);
begin
  { The same handling as for the other field. }
  DBLookupComboBox6KeyPress(Sender, Key);
end;


procedure TForm1.DBLookupComboBox11KeyPress(Sender: TObject; var Key: Char);
begin
  { The same handling as for the other field. }
  DBLookupComboBox7KeyPress(Sender, Key);
end;


procedure TForm1.DBLookupComboBox8KeyPress(Sender: TObject; var Key: Char);
begin
  { The same handling as for the other field. }
  DBLookupComboBox4KeyPress(Sender, Key);
end;


procedure TForm1.DBLookupComboBox9KeyPress(Sender: TObject; var Key: Char);
begin
  { The same handling as for the other field. }
  DBLookupComboBox5KeyPress(Sender, Key);
end;


procedure TForm1.Einzelpersonen1Click(Sender: TObject);
begin
  gvar_0253692C := 'Einz';

  Einzelpersonenmarkieren1Click(Sender);

end;

procedure TForm1.DBLookupComboBox11Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBLookupComboBox1Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBLookupComboBox9Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBLookupComboBox10Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.NichtverknpfteBeziehungen1Click(Sender: TObject);
var
  personennummer, anzahl: Integer;
  paare, personen: string;
  verknuepft: Boolean;
begin
  { All persons that have a father and a mother but for whom no marriage
    is entered are searched.  The persons that are involved in such a
    relationship are written into the grid.

    The list of the pairs of parents is never filled in the original, so
    that a pair can appear twice in the grid (once for every child). }
  aus1.Click;
  personennummer := DataModule2.Table1Nummer.AsInteger;
  DataModule2.Table14.Close;
  DataModule2.Table14.EmptyTable;
  DataModule2.Table14.Open;
  DataModule2.Table18.Open;
  DataModule2.Table18.IndexName := 'num';
  DataModule2.Table18.First;
  tabdisab;
  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.First;
  paare := '';
  anzahl := 0;
  personen := '';
  StringGrid5.RowCount := 1;
  StringGrid5.Cells[1, 0] := 'nicht verkn' + #252 + 'pfte Beziehungen';

  while not DataModule2.Table1.Eof do
  begin
    if (DataModule2.Table1Vater.AsInteger > 0) and
       (DataModule2.Table1Mutter.AsInteger > 0) then
    begin
      { The marriages of the father are looked through; the relationship
        is linked when the mother is entered as the partner. }
      verknuepft := False;
      if DataModule2.Table18.FindKey([DataModule2.Table1Vater.AsInteger]) then
        while (not DataModule2.Table18.Eof) and
              (DataModule2.Table18Nummer.AsInteger = DataModule2.Table1Vater.AsInteger) do
        begin
          if DataModule2.Table18Epnum.AsInteger = DataModule2.Table1Mutter.AsInteger then
          begin
            verknuepft := True;
            break;
          end;
          DataModule2.Table18.Next;
        end;

      if not verknuepft then
      begin
        if Pos(IntToStr(DataModule2.Table1Vater.AsInteger) + ' und ' +
               IntToStr(DataModule2.Table1Mutter.AsInteger), paare) = 0 then
        begin
          { the child }
          personennummer := DataModule2.Table1Nummer.AsInteger;
          DataModule2.Table1.FindKey([DataModule2.Table1Vater.AsInteger]);
          if Pos(IntToStr(DataModule2.Table1Nummer.AsInteger), personen) = 0 then
          begin
            personen := personen + IntToStr(DataModule2.Table1Nummer.AsInteger) + '*';
            gitterZeile(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString,
              IntToStr(DataModule2.Table1Nummer.AsInteger), anzahl);
          end;

          { the mother }
          DataModule2.Table1.FindKey([personennummer]);
          DataModule2.Table1.FindKey([DataModule2.Table1Mutter.AsInteger]);
          if Pos(IntToStr(DataModule2.Table1Nummer.AsInteger), personen) = 0 then
          begin
            personen := personen + IntToStr(DataModule2.Table1Nummer.AsInteger) + '*';
            gitterZeile(DataModule2.Table1Name.AsString + ' ' + DataModule2.Table1Vornamen.AsString,
              IntToStr(DataModule2.Table1Nummer.AsInteger), anzahl);
          end;
        end;
      end;
    end;
    DataModule2.Table1.Next;
  end;

  DataModule2.Table1.FindKey([personennummer]);
  tabenab;
  if anzahl = 0 then
    ShowMessage('Alle Beziehungen sind verkn' + #252 + 'pft.')
  else
    StringGrid5.Visible := True;
  PageControl1.ActivePage := TabSheet2;
  if FileExists('nvbez.HTM') then
    SysUtils.DeleteFile('nvbez.HTM');
  anzeigen;
end;

procedure TForm1.DoppelteEintrge1Click(Sender: TObject);
begin
  { 00607310: Doppelte Eintraege aufsucht/zeigt. Zuerst werden die
    neun Vergleichs-Globale (gvar_02536B68..B90) zurueckgesetzt und die
    Vergleiche von Form35 angezeigt; falls sich ein Ergebnis aufsummiert,
    werden die Einzelpersonen markiert. }
  gvar_02536B68 := 0;
  gvar_02536B6C := 0;
  gvar_02536B70 := 0;
  gvar_02536B74 := 0;
  gvar_02536B78 := 0;
  gvar_02536B7C := 0;
  gvar_02536B80 := 0;
  gvar_02536B84 := 0;
  gvar_02536B88 := 0;
  gvar_02536B8C := 0;
  gvar_02536B90 := 0;
  gvar_0253692C := 'Dopp';
  Form35.ShowModal;
  Refresh;
  if gvar_02536B90 > 0 then
    Einzelpersonenmarkieren1Click(Sender);
end;

procedure TForm1.DBLookupComboBox2Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBLookupComboBox3Enter;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.DBLookupComboBox18KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the source of the burial. }
  if Key = ' ' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Quelleb.AsString := '';
    DataModule2.Table1.Post;
  end;
end;


procedure TForm1.DBLookupComboBox19KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the source of the marriage. }
  if Key = ' ' then
  begin
    DataModule2.Table5.Edit;
    DataModule2.Table5Hqu.AsString := '';
    DataModule2.Table5.Post;
  end;
end;


procedure TForm1.DBLookupComboBox13KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the source of the baptism. }
  if Key = ' ' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Quellet.AsString := '';
    DataModule2.Table1.Post;
  end;
end;


procedure TForm1.DBLookupComboBox14KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the source of the death. }
  if Key = ' ' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Quelles.AsString := '';
    DataModule2.Table1.Post;
  end;
end;


procedure TForm1.DBLookupComboBox22KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the source. }
  if Key = ' ' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Quelle.AsString := '';
    DataModule2.Table1.Post;
  end;
end;


procedure TForm1.bernehmen1Click(Sender: TObject);
var
  pbasis, sbasis: AnsiString;
  apfad, bjpg, astro, sbtmp: AnsiString;
  img: TImage;
  jpg: TJPEGImage;
  i, n, p: Integer;
begin
  //0060785C: Bilder eines Verzeichnisses (ueber OpenDialog) uebernehmen
  //und nach Bilder\ kopieren; BMP-Dateien zusaetzlich nach JPEG
  //konvertieren.
  pbasis := gvar_02536B9C + 'Bilder\';
  OpenDialog1.FilterIndex := 6;
  if not OpenDialog1.Execute then
    Exit;
  FileListBox1.ApplyFilePath(ExtractFileDir(OpenDialog1.FileName));
  n := FileListBox1.Items.Count;
  for i := 0 to n - 1 do
  begin
    sbtmp := UpperCase(Copy(ExtractFileExt(FileListBox1.Items[i]), 2, 3));
    if sbtmp = 'BMP' then
    begin
      sbasis := Copy(FileListBox1.Items[i], 1, Pos('.', FileListBox1.Items[i]) - 1);
      apfad := pbasis + sbasis + 'b' + 'a.bmp';
      CopyFile(PChar(apfad), PChar(FileListBox1.Items[i]), False);
      img := TImage.Create(Self);
      img.Picture.LoadFromFile(pbasis + sbasis + 'b' + 'a.bmp');
      jpg := TJPEGImage.Create;
      jpg.CompressionQuality := 50;
      jpg.Assign(img.Picture.Graphic);
      bjpg := pbasis + sbasis + 'b' + 'a.jpg';
      jpg.SaveToFile(bjpg);
      DeleteFile(PAnsiChar(AnsiString(pbasis + sbasis + 'b' + 'a.bmp')));
      jpg.Free;
      img.Free;
    end;
    if UpperCase(Copy(ExtractFileExt(FileListBox1.Items[i]), 2, 3)) = 'JPG' then
    begin
      sbasis := Copy(FileListBox1.Items[i], 1, Pos('.', FileListBox1.Items[i]) - 1);
      CopyFile(PChar(pbasis + sbasis + '.jpg'), PChar(FileListBox1.Items[i]), False);
    end;
  end;
  ChDir(gvar_02536B9C);
  anzeigen;
end;

procedure TForm1.DBLookupComboBox20KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the source of the marriage. }
  if Key = ' ' then
  begin
    DataModule2.Table5.Edit;
    DataModule2.Table5Saqu.AsString := '';
    DataModule2.Table5.Post;
  end;
end;


procedure TForm1.DBLookupComboBox21KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the source of the separation. }
  if Key = ' ' then
  begin
    DataModule2.Table5.Edit;
    DataModule2.Table5Schqu.AsString := '';
    DataModule2.Table5.Post;
  end;
end;


procedure TForm1.DBLookupComboBox12KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the source of the marriage. }
  if Key = ' ' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Quelleg.AsString := '';
    DataModule2.Table1.Post;
  end;
end;


procedure TForm1.ComboBox3KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the place of the separation. }
  if Key = ' ' then
  begin
    DataModule2.Table5.Edit;
    DataModule2.Table5Schort.AsString := '';
    DataModule2.Table5.Post;
  end;
end;

procedure TForm1.DBLookupComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  { The same handling as for the other field. }
  ComboBox1KeyPress(Sender, Key);
end;


procedure TForm1.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the place of the marriage. }

  if Key = ' ' then

  begin

    DataModule2.Table5.Edit;

    DataModule2.Table5Hort.AsString := '';

    DataModule2.Table5.Post;

  end;

end;

procedure TForm1.ComboBox2KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the place of the marriage. }
  if Key = ' ' then
  begin
    DataModule2.Table5.Edit;
    DataModule2.Table5Saort.AsString := '';
    DataModule2.Table5.Post;
  end;
end;

procedure TForm1.DBLookupComboBox16KeyPress(Sender: TObject; var Key: Char);
begin
  { A space in the field ends the entry of the name. }
  if Key = ' ' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Name.AsString := '';
    DataModule2.Table1.Post;
  end;
end;


procedure TForm1.DBLookupComboBox17KeyPress(Sender: TObject; var Key: Char);
begin
  { The same handling as for the other field. }
  DBLookupComboBox16KeyPress(Sender, Key);
end;


procedure TForm1.DBLookupComboBox2KeyPress(Sender: TObject; var Key: Char);
begin
  { The same handling as for the other field. }
  ComboBox2KeyPress(Sender, Key);
end;


procedure TForm1.DBLookupComboBox3KeyPress(Sender: TObject; var Key: Char);
begin
  { The same handling as for the other field. }
  ComboBox3KeyPress(Sender, Key);
end;


procedure TForm1.DBEdit8Exit(Sender: TObject);
var
  s: string;
begin
  { The day of the birth was left: the age is calculated again. }
  wt33;
  DataModule2.Table1.Edit;
  s := '';
  altersberechnung(
    DataModule2.Table1Gebtag.AsString,
    DataModule2.Table1Gebmonat.AsString,
    DataModule2.Table1Gebjahr.AsString,
    s,
    DataModule2.Table1Stjahr.AsString,
    DataModule2.Table1Stmonat.AsString,
    DataModule2.Table1Sttag.AsString,
    DataModule2.Table1Taufjahr.AsString,
    DataModule2.Table1Taufmonat.AsString,
    DataModule2.Table1Tauftag.AsString);
  DataModule2.Table1Alter.AsString := s;
  DataModule2.Table1.Post;
end;


procedure TForm1.DBEdit13Exit(Sender: TObject);
begin
  { the weekday of the baptism is shown again. }
  wt34;
end;


procedure TForm1.DBEdit22Exit(Sender: TObject);
begin
  { The year of the burial was left: the weekday is shown again and
    the date is checked. }
  wt36;
  datcheck(DBEdit20.Text, DBEdit21.Text, DBEdit22.Text);
end;


procedure TForm1.DBEdit9Exit(Sender: TObject);
var
  s: string;
begin
  { The month of the birth was left: the age is calculated again. }
  if Trim(DBEdit9.Text) <> '' then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Indm.AsString := DBEdit5.Text;
  end;
  wt33;
  DataModule2.Table1.Edit;
  s := '';
  altersberechnung(
    DataModule2.Table1Gebtag.AsString,
    DataModule2.Table1Gebmonat.AsString,
    DataModule2.Table1Gebjahr.AsString,
    s,
    DataModule2.Table1Stjahr.AsString,
    DataModule2.Table1Stmonat.AsString,
    DataModule2.Table1Sttag.AsString,
    DataModule2.Table1Taufjahr.AsString,
    DataModule2.Table1Taufmonat.AsString,
    DataModule2.Table1Tauftag.AsString);
  DataModule2.Table1Alter.AsString := s;
  DataModule2.Table1.Post;
end;


procedure TForm1.DBEdit16Exit(Sender: TObject);
var
  s: string;
begin
  { The day of the death was left: the age is calculated again. }
  wt35;
  DataModule2.Table1.Edit;
  s := '';
  altersberechnung(
    DataModule2.Table1Gebtag.AsString,
    DataModule2.Table1Gebmonat.AsString,
    DataModule2.Table1Gebjahr.AsString,
    s,
    DataModule2.Table1Stjahr.AsString,
    DataModule2.Table1Stmonat.AsString,
    DataModule2.Table1Sttag.AsString,
    DataModule2.Table1Taufjahr.AsString,
    DataModule2.Table1Taufmonat.AsString,
    DataModule2.Table1Tauftag.AsString);
  DataModule2.Table1Alter.AsString := s;
  DataModule2.Table1.Post;
end;


procedure TForm1.DBEdit21Exit(Sender: TObject);
begin
  { the weekday of the burial is shown again. }
  wt36;
end;


procedure TForm1.DBEdit12Exit(Sender: TObject);
begin
  { the weekday of the baptism is shown again. }
  wt34;
end;


procedure TForm1.DBEdit17Exit(Sender: TObject);
var
  s: string;
begin
  { The month of the death was left: the age is calculated again. }
  wt35;
  DataModule2.Table1.Edit;
  s := '';
  altersberechnung(
    DataModule2.Table1Gebtag.AsString,
    DataModule2.Table1Gebmonat.AsString,
    DataModule2.Table1Gebjahr.AsString,
    s,
    DataModule2.Table1Stjahr.AsString,
    DataModule2.Table1Stmonat.AsString,
    DataModule2.Table1Sttag.AsString,
    DataModule2.Table1Taufjahr.AsString,
    DataModule2.Table1Taufmonat.AsString,
    DataModule2.Table1Tauftag.AsString);
  DataModule2.Table1Alter.AsString := s;
  DataModule2.Table1.Post;
end;


procedure TForm1.DBEdit18Exit(Sender: TObject);
var
  s: string;
begin
  { The year of the death was left: the age is calculated again and the date is checked. }
  wt35;
  DataModule2.Table1.Edit;
  s := '';
  altersberechnung(
    DataModule2.Table1Gebtag.AsString,
    DataModule2.Table1Gebmonat.AsString,
    DataModule2.Table1Gebjahr.AsString,
    s,
    DataModule2.Table1Stjahr.AsString,
    DataModule2.Table1Stmonat.AsString,
    DataModule2.Table1Sttag.AsString,
    DataModule2.Table1Taufjahr.AsString,
    DataModule2.Table1Taufmonat.AsString,
    DataModule2.Table1Tauftag.AsString);
  DataModule2.Table1Alter.AsString := s;
  DataModule2.Table1.Post;
  datcheck(DBEdit16.Text, DBEdit17.Text, DBEdit18.Text);
end;


procedure TForm1.wt35;
var
  s: string;
begin
  { The name of the weekday of the death is shown in Label24. }
  s := '';
  Label24.Visible := False;
  if DataModule2.Table1Stjahr.AsString <> '' then
  begin
    Wochentag(DataModule2.Table1Sttag.AsString + '.' +
              DataModule2.Table1Stmonat.AsString + '.' +
              DataModule2.Table1Stjahr.AsString, s);
    if s <> '' then
    begin
      Label24.Caption := s;
      Label24.Visible := True;
    end;
  end;
end;

procedure TForm1.wt36;
var
  s: string;
begin
  { The name of the weekday of the burial is shown in Label25. }
  s := '';
  Label25.Visible := False;
  if DataModule2.Table1Begjahr.AsString <> '' then
  begin
    Wochentag(DataModule2.Table1Begtag.AsString + '.' +
              DataModule2.Table1Begmonat.AsString + '.' +
              DataModule2.Table1Begjahr.AsString, s);
    if s <> '' then
    begin
      Label25.Caption := s;
      Label25.Visible := True;
    end;
  end;
end;

procedure TForm1.wt33;
var
  s: string;
begin
  { The name of the weekday of the birth is shown in Label22. }
  s := '';
  Label22.Visible := False;
  if DataModule2.Table1Gebjahr.AsString <> '' then
  begin
    Wochentag(DataModule2.Table1Gebtag.AsString + '.' +
              DataModule2.Table1Gebmonat.AsString + '.' +
              DataModule2.Table1Gebjahr.AsString, s);
    if s <> '' then
    begin
      Label22.Caption := s;
      Label22.Visible := True;
    end;
  end;
end;

procedure TForm1.wt34;
var
  s: string;
begin
  { The name of the weekday of the baptism is shown in Label23. }
  s := '';
  Label23.Visible := False;
  if DataModule2.Table1Taufjahr.AsString <> '' then
  begin
    Wochentag(DataModule2.Table1Tauftag.AsString + '.' +
              DataModule2.Table1Taufmonat.AsString + '.' +
              DataModule2.Table1Taufjahr.AsString, s);
    if s <> '' then
    begin
      Label23.Caption := s;
      Label23.Visible := True;
    end;
  end;
end;

procedure TForm1.wt37;
var
  s: string;
begin
  { The name of the weekday of the church wedding is shown in Label69. }
  s := '';
  Label69.Visible := False;
  if DataModule2.Table5Hjahr.AsString <> '' then
  begin
    Wochentag(DataModule2.Table5Htag.AsString + '.' +
              DataModule2.Table5Hmonat.AsString + '.' +
              DataModule2.Table5Hjahr.AsString, s);
    if s <> '' then
    begin
      Label69.Caption := s;
      Label69.Visible := True;
    end;
  end;
end;

procedure TForm1.wt38;
var
  s: string;
begin
  { The name of the weekday of the wedding at the registry office is shown
    in Label70. }
  s := '';
  Label70.Visible := False;
  if DataModule2.Table5Sajahr.AsString <> '' then
  begin
    Wochentag(DataModule2.Table5Satag.AsString + '.' +
              DataModule2.Table5Samonat.AsString + '.' +
              DataModule2.Table5Sajahr.AsString, s);
    if s <> '' then
    begin
      Label70.Caption := s;
      Label70.Visible := True;
    end;
  end;
end;

procedure TForm1.wt39;
var
  s: string;
begin
  { The name of the weekday of the separation is shown in Label71. }
  s := '';
  Label71.Visible := False;
  if DataModule2.Table5Schjahr.AsString <> '' then
  begin
    Wochentag(DataModule2.Table5Schtag.AsString + '.' +
              DataModule2.Table5Schmonat.AsString + '.' +
              DataModule2.Table5Schjahr.AsString, s);
    if s <> '' then
    begin
      Label71.Caption := s;
      Label71.Visible := True;
    end;
  end;
end;

procedure TForm1.DBEdit14Exit(Sender: TObject);
var
  s: string;
begin
  { The year of the baptism was left: the age is calculated again and the
    date is checked. }
  wt34;
  DataModule2.Table1.Edit;
  s := '';
  altersberechnung(
    DataModule2.Table1Gebtag.AsString,
    DataModule2.Table1Gebmonat.AsString,
    DataModule2.Table1Gebjahr.AsString,
    s,
    DataModule2.Table1Stjahr.AsString,
    DataModule2.Table1Stmonat.AsString,
    DataModule2.Table1Sttag.AsString,
    DataModule2.Table1Taufjahr.AsString,
    DataModule2.Table1Taufmonat.AsString,
    DataModule2.Table1Tauftag.AsString);
  DataModule2.Table1Alter.AsString := s;
  DataModule2.Table1.Post;
  datcheck(DBEdit12.Text, DBEdit13.Text, DBEdit14.Text);
end;


procedure TForm1.Verbindungeinfgen1Click(Sender: TObject);
var
  geschlecht: string[1];
begin
  { A new connection (a marriage) is created for the person. }
  DataModule2.Table12.Open;
  gvar_02536918 := 0;
  gvar_02536914 := 1;
  gvar_02536910 := DataModule2.Table1Nummer.AsInteger;

  if Trim(DataModule2.Table1Geschlecht.AsString) = '' then
  begin
    ShowMessage('Bitte erst Geschlecht eingeben.');
    DBEdit7.SetFocus;
    gvar_02536914 := 0;
    Exit;
  end;

  geschlecht := UpperCase(DataModule2.Table1Geschlecht.AsString);

  Form4.Caption := 'Verbindung einf' + #252 + 'gen';
  Form4.ShowModal;

  { The partner is a new person. }
  if Form4.RadioButton1.Checked then
  begin
    elem_leer;
    elem('ein');
    ComboBox4.Text := '';
    ComboBox6.Text := '';
    ComboBox7.Text := '';
    ComboBox8.Text := '';
    ComboBox9.Text := '';
    ComboBox10.Text := '';
    ComboBox11.Text := '';
    ComboBox12.Text := '';
    ComboBox13.Text := '';
    ComboBox14.Text := '';
    ComboBox15.Text := '';
    ComboBox16.Text := '';
    ComboBox17.Text := '';
    ComboBox18.Text := '';
    ComboBox19.Text := '';
    ComboBox23.Text := '';
    ComboBox24.Text := '';
    ComboBox25.Text := '';
    DBCheckBox1.Checked := False;
    Edit1.Text := '';
    Edit2.Text := '';
    Label22.Caption := '';
    Label23.Caption := '';
    Label24.Caption := '';
    Label25.Caption := '';
    Label6.Caption := '';
    Label7.Caption := '';
    Image1.Picture := nil;
    Label35.Caption := 'Verbindung von ' + DataModule2.Table1Name.AsString +
                       ' ' + DataModule2.Table1Vornamen.AsString;
    Label35.Visible := True;
    Label35.Refresh;
    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.Append;
    DBCheckBox1.Checked := False;
    DataModule2.Table1Lebt.AsString := 'n';
    { The partner has the other gender. }
    if geschlecht = 'M' then
      DataModule2.Table1Geschlecht.AsString := 'w';
    if geschlecht = 'W' then
      DataModule2.Table1Geschlecht.AsString := 'm';
    PageControl1.ActivePage := TabSheet3;
    ComboBox10.SetFocus;
  end;

  { The partner is a person that is already known. }
  if Form4.RadioButton2.Checked then
  begin
    Label27.Caption := 'Verbindung von ' + DataModule2.Table1Name.AsString +
                       ' ' + DataModule2.Table1Vornamen.AsString;
    TabSheet7.Show;
    DBGrid2.SetFocus;
    Form3.ShowModal;
  end;

  anzeigen;
end;

procedure TForm1.DBGrid2DblClick(Sender: TObject);
var
  personNummer: Integer;
  partnerNummer: Integer;
  markiert: Integer;
  geschlecht: string[1];
begin
  { A person that is marked in the list is taken over into a connection
    or into the parents of the person. }
  if gvar_0253692C = 'Verw' then
  begin
    gvar_011AE2C4 := DataModule2.Table9Nummer.AsInteger;
    Form13.Verwandtschaft1Click(Sender);
  end;

  { The connection is written - in both directions. }
  if gvar_02536914 = 1 then
  begin
    personNummer := DataModule2.Table1Nummer.AsInteger;
    partnerNummer := DataModule2.Table9Nummer.AsInteger;

    DataModule2.Table10.Open;
    DataModule2.Table10.IndexName := '';
    DataModule2.Table5.First;
    while DataModule2.Table5Nummer.AsInteger = personNummer do
    begin
      if DataModule2.Table5Epnum.AsInteger = partnerNummer then
      begin
        ShowMessage('Verkn' + #252 + 'pfung schon vorhanden.');
        Form4.Close;
        PageControl1.ActivePage := TabSheet2;
        anzeigen;
        Exit;
      end;
      DataModule2.Table5.Next;
    end;

    DataModule2.Table10.Append;
    DataModule2.Table10Nummer.AsInteger := personNummer;
    DataModule2.Table10Epnum.AsInteger := partnerNummer;
    DataModule2.Table10Verbind.AsString := 'Eheschliessung';
    DataModule2.Table10Hqu.AsString := '';
    DataModule2.Table10Saqu.AsString := '';
    DataModule2.Table10Schqu.AsString := '';
    DataModule2.Table10.Post;

    DataModule2.Table10.Append;
    DataModule2.Table10Nummer.AsInteger := partnerNummer;
    DataModule2.Table10Epnum.AsInteger := personNummer;
    DataModule2.Table10Verbind.AsString := 'Eheschliessung';
    DataModule2.Table10Hqu.AsString := '';
    DataModule2.Table10Saqu.AsString := '';
    DataModule2.Table10Schqu.AsString := '';
    DataModule2.Table10.Post;
  end;

  { The marked person is a child of the person. }
  if gvar_02536914 = 2 then
  begin
    personNummer := DataModule2.Table1Nummer.AsInteger;
    partnerNummer := 0;
    if Trim(StringGrid1.Cells[1, StringGrid1.Row]) <> '' then
      partnerNummer := StrToInt(StringGrid1.Cells[1, StringGrid1.Row]);

    markiert := DataModule2.Table9Nummer.AsInteger;
    DataModule2.Table9.IndexName := '';
    DataModule2.Table9.FindKey([gvar_02536910]);
    geschlecht := Copy(DataModule2.Table9Geschlecht.AsString, 1, 1);
    DataModule2.Table9.FindKey([markiert]);
    DataModule2.Table9.Edit;
    if UpperCase(geschlecht) = 'M' then
    begin
      DataModule2.Table9Vater.AsInteger := personNummer;
      DataModule2.Table9Mutter.AsInteger := partnerNummer;
    end;
    if UpperCase(geschlecht) = 'W' then
    begin
      DataModule2.Table9Vater.AsInteger := partnerNummer;
      DataModule2.Table9Mutter.AsInteger := personNummer;
    end;
    DataModule2.Table9.Post;
  end;

  { The person becomes the father or the mother of the marked person. }
  if gvar_02536918 = 1 then
  begin
    DataModule2.Table1.Edit;
    if UpperCase(DataModule2.Table9Geschlecht.AsString) = 'M' then
      DataModule2.Table1Vater.AsInteger := DataModule2.Table9Nummer.AsInteger;
    if UpperCase(DataModule2.Table9Geschlecht.AsString) = 'W' then
      DataModule2.Table1Mutter.AsInteger := DataModule2.Table9Nummer.AsInteger;
  end;

  Form4.Close;
  PageControl1.ActivePage := TabSheet2;
  gvar_02536918 := 0;
  gvar_02536914 := 0;
  anzeigen;
end;

procedure TForm1.Kinderentfernen1Click(Sender: TObject);
begin
  { The child that is marked in the list is not a child of the person
    any more: its father and its mother are set to zero. }
  if MessageDlg('als Kind entfernen ?' + #10 + #13 +
                StringGrid2.Cells[2, StringGrid2.Row],
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DataModule2.Table7.First;
    while not DataModule2.Table7.Eof do
    begin
      if StrToInt(StringGrid2.Cells[1, StringGrid2.Row]) =
         DataModule2.Table7Nummer.AsInteger then
      begin
        DataModule2.Table7.Edit;
        DataModule2.Table7Vater.AsInteger := 0;
        DataModule2.Table7Mutter.AsInteger := 0;
        DataModule2.Table7.Post;
      end;
      DataModule2.Table7.Next;
    end;
  end;
  anzeigen;
end;

procedure TForm1.Kindereinfgen1Click(Sender: TObject);
var
  geschlecht: string;
  personNummer: Integer;
  partnerNummer: Integer;
begin
  { A new child is created. The dialog of the program asks whether the
    child is the child of the person alone or of the person and of the
    person that is marked in the list. }
  gvar_02536914 := 2;
  gvar_02536910 := DataModule2.Table1Nummer.AsInteger;
  geschlecht := Trim(DataModule2.Table1Geschlecht.AsString);
  if geschlecht = '' then
  begin
    gvar_02536914 := 0;
    ShowMessage('Bitte zuerst Geschlecht eingeben.');
    DBEdit7.SetFocus;
    Exit;
  end;

  personNummer := DataModule2.Table1Nummer.AsInteger;

  Form4.Caption := 'Kind einf' + #252 + 'gen';
  Form4.ShowModal;

  partnerNummer := 0;

  { The child is the child of the person and of the marked person. }
  if Form4.RadioButton1.Checked then
  begin
    elem('aus');
    ComboBox4.Text := '';
    ComboBox6.Text := '';
    ComboBox7.Text := '';
    ComboBox8.Text := '';
    ComboBox9.Text := '';
    ComboBox11.Text := '';
    ComboBox12.Text := '';
    ComboBox13.Text := '';
    ComboBox14.Text := '';
    ComboBox15.Text := '';
    ComboBox16.Text := '';
    ComboBox17.Text := '';
    ComboBox18.Text := '';
    ComboBox19.Text := '';
    DBCheckBox1.Checked := False;
    Edit1.Text := '';
    Edit2.Text := '';
    Label22.Caption := '';
    Label23.Caption := '';
    Label24.Caption := '';
    Label25.Caption := '';
    Label6.Caption := '';
    Label7.Caption := '';
    Image1.Picture := nil;

    if Trim(StringGrid1.Cells[1, StringGrid1.Row]) <> '' then
      partnerNummer := StrToInt(StringGrid1.Cells[1, StringGrid1.Row]);

    DataModule2.Table8.Open;
    DataModule2.Table8.IndexName := '';
    if partnerNummer > 0 then
    begin
      if DataModule2.Table8.FindKey([partnerNummer]) then
      begin
        Label35.Caption := 'Kind von: ' + DataModule2.Table1Name.AsString +
                           ' ' + DataModule2.Table1Vornamen.AsString;
        Label35.Caption := Label35.Caption + ' u. ' +
                           DataModule2.Table8Name.AsString + ' ' +
                           DataModule2.Table8Vornamen.AsString;
      end
      else
        Label35.Caption := 'Kind von ' + DataModule2.Table1Name.AsString +
                           ' ' + DataModule2.Table1Vornamen.AsString;
    end
    else
      Label35.Caption := 'Kind von ' + DataModule2.Table1Name.AsString +
                         ' ' + DataModule2.Table1Vornamen.AsString;
    Label35.Visible := True;

    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.Append;
    DBCheckBox1.Checked := False;
    DataModule2.Table1Lebt.AsString := 'n';
    if UpperCase(geschlecht) = 'M' then
    begin
      DataModule2.Table1Vater.AsInteger := personNummer;
      DataModule2.Table1Mutter.AsInteger := partnerNummer;
    end;
    if UpperCase(geschlecht) = 'W' then
    begin
      DataModule2.Table1Mutter.AsInteger := personNummer;
      DataModule2.Table1Vater.AsInteger := partnerNummer;
    end;
    PageControl1.ActivePage := TabSheet3;
    ComboBox10.SetFocus;
    anzeigen;
  end;

  { The marked person is the child of the person; the page of the
    connections is shown. }
  if Form4.RadioButton2.Checked then
  begin
    elem('aus');
    DataModule2.Table8.Open;
    DataModule2.Table8.IndexName := '';
    if Trim(StringGrid1.Cells[1, StringGrid1.Row]) <> '' then
    begin
      DataModule2.Table8.FindKey([StrToInt(StringGrid1.Cells[1, StringGrid1.Row])]);
      Label27.Caption := 'Kind von ' + DataModule2.Table1Name.AsString +
                         ' ' + DataModule2.Table1Vornamen.AsString;
      Label27.Caption := Label27.Caption + ' u. ' +
                         DataModule2.Table8Name.AsString + ' ' +
                         DataModule2.Table8Vornamen.AsString;
    end
    else
      Label27.Caption := 'Kind von ' + DataModule2.Table1Name.AsString +
                         ' ' + DataModule2.Table1Vornamen.AsString;
    TabSheet7.Show;
    Form3.Edit1.Text := '';
    Form3.ShowModal;
  end;

  anzeigen;
end;

procedure TForm1.StringGrid3Click(Sender: TObject);
var
  personNummer: Integer;
  eheNummer: Integer;
begin
  { The marriage that is marked in the list is shown in the fields of the
    page. }
  personNummer := DataModule2.Table1Nummer.AsInteger;

  if Trim(StringGrid3.Cells[0, StringGrid3.Row]) <> '' then
  begin
    eheNummer := StrToInt(StringGrid3.Cells[0, StringGrid3.Row]);
    DataModule2.Table5.IndexName := 'num';
    DataModule2.Table5.FindKey([personNummer]);
    while DataModule2.Table5Nummer.AsInteger = personNummer do
    begin
      if DataModule2.Table5Epnum.AsInteger = eheNummer then
      begin
        ComboBox20.Text := DataModule2.Table5Hort.AsString;
        ComboBox21.Text := DataModule2.Table5Saort.AsString;
        ComboBox22.Text := DataModule2.Table5Schort.AsString;
        ComboBox23.Text := DataModule2.Table5Hqu.AsString;
        ComboBox24.Text := DataModule2.Table5Saqu.AsString;
        ComboBox25.Text := DataModule2.Table5Schqu.AsString;
        wt37;
        wt38;
        wt39;
        Break;
      end;
      DataModule2.Table5.Next;
      if DataModule2.Table5.Eof then
        Break;
    end;
  end;
end;

procedure TForm1.TabSheet4Exit(Sender: TObject);
var
  n: Integer;
begin
  { The marriage is written into the table of the marriages. }
  if DataModule2.Table5.State in [dsEdit, dsInsert] then
  begin
    try
      DataModule2.Table5.Post;
    except
    end;
  end;

  { The marriage that is marked in the list is written into the table of
    the connections of the other person as well. }
  if DataModule2.Table1.RecordCount > 1 then
    if Trim(StringGrid3.Cells[0, 0]) <> '' then
    begin
      DataModule2.Table10.IndexName := 'nm';
      DataModule2.Table38.IndexName := 'tit';
      n := StrToInt(StringGrid3.Cells[0, StringGrid3.Row]);
      if DataModule2.Table10.FindKey([n]) then
        while StrToInt(StringGrid3.Cells[0, StringGrid3.Row]) =
              DataModule2.Table10Nummer.AsInteger do
        begin
          if DataModule2.Table10Epnum.AsInteger =
             DataModule2.Table1Nummer.AsInteger then
          begin
            DataModule2.Table10.Edit;
            DataModule2.Table10Verbind.AsString := DBComboBox1.Text;
            DataModule2.Table10Htag.AsString := DBEdit35.Text;
            DataModule2.Table10Hmonat.AsString := DBEdit36.Text;
            DataModule2.Table10Hjahr.AsString := DBEdit37.Text;
            DataModule2.Table10Trauz.AsString := DBEdit38.Text;
            DataModule2.Table10Hqu.AsString := ComboBox23.Text;
            DataModule2.Table10Hort.AsString := ComboBox20.Text;
            DataModule2.Table10Satag.AsString := DBEdit39.Text;
            DataModule2.Table10Samonat.AsString := DBEdit41.Text;
            DataModule2.Table10Sajahr.AsString := DBEdit45.Text;
            DataModule2.Table10Satrauz.AsString := DBEdit46.Text;
            DataModule2.Table10Saqu.AsString := ComboBox24.Text;
            DataModule2.Table10Saort.AsString := ComboBox21.Text;
            DataModule2.Table10Schtag.AsString := DBEdit61.Text;
            DataModule2.Table10Schmonat.AsString := DBEdit62.Text;
            DataModule2.Table10Schjahr.AsString := DBEdit63.Text;
            DataModule2.Table10Schort.AsString := ComboBox22.Text;
            DataModule2.Table10Schqu.AsString := ComboBox25.Text;
            DataModule2.Table10.Post;
            Break;
          end;
          DataModule2.Table10.Next;
          if DataModule2.Table10.Eof then
            Break;
        end;
    end;

  gvar_02536914 := 0;
end;

procedure TForm1.TabSheet7MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { The dialog for the selection of a person is opened. }

  Form3.Edit1.Text := '';

  Form3.ShowModal;

end;

procedure TForm1.TabSheet4Enter(Sender: TObject);
begin
  { The page shows the marriages of the person. }
  Label67.Caption := 'Verbindung(en) von : ' + DataModule2.Table1Name.AsString +
                    ' ' + DataModule2.Table1Vornamen.AsString;
  DataModule2.Table5.First;
  wt37;
  wt38;
  wt39;
  DBEdit35.SetFocus;
  ComboBox20.Text := '';
  ComboBox23.Text := '';
  ComboBox21.Text := '';
  ComboBox22.Text := '';
  ComboBox24.Text := '';
  ComboBox25.Text := '';
  StringGrid3Click(Sender);
end;

procedure TForm1.beenden1Click(Sender: TObject);
begin
  { The data protection is removed before the program is closed. }

  Datenschutzaus1.Click;

  PageControl1.ActivePage := TabSheet2;

  Form1.Close;

end;

procedure TForm1.TabSheet1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { The dialog for the selection of a person is opened. }

  Form3.Edit1.Text := '';

  Form3.ShowModal;

end;

procedure TForm1.ucase(aansistring:ansistring;var aergebnis:ansistring);
var
  i: Integer;
  c: string;
begin
  { The text is written in capitals. The umlauts of the German alphabet
    are converted as well - UpperCase of Delphi 9 does not do that. }
  AErgebnis := '';
  if Length(AAnsiString) > 0 then
    for i := 1 to Length(AAnsiString) do
    begin
      c := Copy(AAnsiString, i, 1);
      if c = Chr(228) then
        AErgebnis := AErgebnis + Chr(196)
      else if c = Chr(246) then
        AErgebnis := AErgebnis + Chr(214)
      else if c = Chr(252) then
        AErgebnis := AErgebnis + Chr(220)
      else
        AErgebnis := AErgebnis + UpperCase(c);
    end;
end;

procedure TForm1.DBEdit20Exit(Sender: TObject);
begin
  { the weekday of the burial is shown again. }
  wt36;
end;


procedure TForm1.Verbindunglschen1Click(Sender: TObject);
var
  partnerNummer: Integer;
  eheNummer: Integer;
begin
  { The person that is marked in the list is not a partner of the person
    any more: the marriages with him are removed. }
  if MessageDlg('als (Ehe-)Partner entfernen ?' + #10 + #13 +
                StringGrid1.Cells[2, StringGrid1.Row],
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    partnerNummer := StrToInt(StringGrid1.Cells[1, StringGrid1.Row]);
    eheNummer := 0;

    { The marriages with the partner are removed. }
    DataModule2.Table5.First;
    while not DataModule2.Table5.Eof do
    begin
      if DataModule2.Table5Epnum.AsInteger = partnerNummer then
      begin
        eheNummer := DataModule2.Table5Nummer.AsInteger;
        DataModule2.Table5.Delete;
      end;
      DataModule2.Table5.Next;
    end;

    DataModule2.Table1.FindKey([partnerNummer]);

    { The marriages of the person are removed as well. }
    DataModule2.Table5.First;
    while not DataModule2.Table5.Eof do
    begin
      if DataModule2.Table5Epnum.AsInteger = eheNummer then
        DataModule2.Table5.Delete;
      DataModule2.Table5.Next;
    end;

    DataModule2.Table1.FindKey([eheNummer]);
  end;
  anzeigen;
end;

procedure TForm1.StringGrid4DblClick(Sender: TObject);
var
  s: string;
  n: Integer;
begin
  { The person that is marked in the list of the siblings is shown. }
  s := StringGrid4.Cells[0, StringGrid4.Row];
  if s > ' ' then
  begin
    n := StrToInt(StringGrid4.Cells[0, StringGrid4.Row]);
    DataModule2.Table1.FindKey([n]);
    PageControl1.ActivePage := TabSheet2;
    anzeigen;
  end;
end;

procedure TForm1.DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  { A letter jumps to the person whose name begins with this letter. }
  if Pos(Chr(Key), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') > 0 then
    DataModule2.Table9.FindNearest([Chr(Key)]);

  { The return key takes over the person that is marked in the grid. }
  if Key = 13 then
  begin
    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.FindKey([DBGrid1.Fields[0].AsInteger]);
    PageControl1.ActivePage := TabSheet2;
    anzeigen;
  end;

  { The escape key shows the person again. }
  if Key = 27 then
  begin
    PageControl1.ActivePage := TabSheet2;
    anzeigen;
  end;
end;

procedure TForm1.TabSheet5Enter(Sender: TObject);
var
  anzahl, i: Integer;
  person, vater, mutter, mutter2: Integer;
  s1, s2, s3, s4, s5: string;
  datum: string;
  zeile: Integer;
begin
  { Die Geschwister der Person werden gesucht. }
  if DataModule2.Table1.RecordCount <= 1 then
    Exit;

  Label26.Caption := 'Geschwister von: ' + DataModule2.Table1Name.AsString +
                     ' ' + DataModule2.Table1Vornamen.AsString;
  if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then
  begin
    datum := DataModule2.Table1Gebtag.AsString + '.' +
             DataModule2.Table1Gebmonat.AsString + '.' +
             DataModule2.Table1Gebjahr.AsString;
    datumNormalisieren(datum, s5);
    Label26.Caption := Label26.Caption + ' * ' + s5;
  end
  else if Trim(DataModule2.Table1Taufjahr.AsString) <> '' then
  begin
    datum := DataModule2.Table1Tauftag.AsString + '.' +
             DataModule2.Table1Taufmonat.AsString + '.' +
             DataModule2.Table1Taufjahr.AsString;
    datumNormalisieren(datum, s5);
    Label26.Caption := Label26.Caption + ' ~ ' + s5;
  end;

  Label26.Left := Round((TabSheet5.Width - Label26.Width) / 2.0);

  s1 := '';
  s2 := '';
  s3 := '';
  s4 := '';
  s5 := '';
  person := DataModule2.Table1Nummer.AsInteger;
  vater := DataModule2.Table1Vater.AsInteger;
  mutter := DataModule2.Table1Mutter.AsInteger;

  DataModule2.Table12.Open;
  DataModule2.Table10.Open;
  DataModule2.Table10.IndexName := 'num';

  { The children of the father: the ones of the mother and the others. }
  if vater > 0 then
    if DataModule2.Table10.FindKey([vater]) then
      repeat
        if DataModule2.Table10Nummer.AsInteger <> vater then
          Break;
        if DataModule2.Table10Epnum.AsInteger = mutter then
          s1 := s1 + zahl6(DataModule2.Table10Epnum.AsInteger)
        else
          s2 := s2 + zahl6(DataModule2.Table10Epnum.AsInteger);
        DataModule2.Table10.Next;
      until DataModule2.Table10.Eof;

  { The children of the mother. }
  if mutter > 0 then
    if DataModule2.Table10.FindKey([mutter]) then
      repeat
        if DataModule2.Table10Nummer.AsInteger <> mutter then
          Break;
        if DataModule2.Table10Epnum.AsInteger = vater then
          s3 := s3 + zahl6(DataModule2.Table10Epnum.AsInteger)
        else
          s4 := s4 + zahl6(DataModule2.Table10Epnum.AsInteger);
        DataModule2.Table10.Next;
      until DataModule2.Table10.Eof;

  { The grid is cleared. }
  i := StringGrid4.RowCount - 1;
  if i >= 0 then
  begin
    Inc(i);
    zeile := 0;
    repeat
      StringGrid4.Cells[0, zeile] := '';
      StringGrid4.Cells[1, zeile] := '';
      StringGrid4.Cells[2, zeile] := '';
      StringGrid4.Cells[3, zeile] := '';
      StringGrid4.Cells[4, zeile] := '';
      Inc(zeile);
      Dec(i);
    until i = 0;
  end;
  StringGrid4.RowCount := 0;

  zeile := 1;

  { The siblings of the father. }
  if vater > 0 then
  begin
    DataModule2.Table8.Open;
    DataModule2.Table8.IndexName := 'vat';
    if DataModule2.Table8.FindKey([vater]) then
      geschw(person, vater, mutter, vater, 'vater', s5, s3, s4, zeile);
  end;

  { The siblings of the mother. }
  if mutter > 0 then
  begin
    DataModule2.Table8.Open;
    DataModule2.Table8.IndexName := 'mut';
    if DataModule2.Table8.FindKey([mutter]) then
      geschw(person, vater, mutter, mutter, 'mutter', s5, s3, s4, zeile);
  end;

  { The children of the father that do not have the same mother are
    half siblings. }
  if Length(s2) > 0 then
  begin
    anzahl := Length(s2) div 6;
    for i := 1 to anzahl do
    begin
      DataModule2.Table8.Open;
      DataModule2.Table8.IndexName := 'mut';
      mutter2 := StrToInt(Copy(s2, 6 * (i - 1) + 1, 6));
      if mutter2 > 0 then
        if DataModule2.Table8.FindKey([mutter2]) then
          repeat
            if DataModule2.Table8Mutter.AsInteger <> person then
            begin
              StringGrid4.RowCount := zeile;
              StringGrid4.Cells[0, zeile - 1] :=
                Format('%6s', [IntToStr(DataModule2.Table8Nummer.AsInteger)]);
              StringGrid4.Cells[1, zeile - 1] :=
                DataModule2.Table8Name.AsString + ' ' +
                DataModule2.Table8Vornamen.AsString;
              if DataModule2.Table8Gebjahr.AsString <> '' then
                StringGrid4.Cells[2, zeile - 1] :=
                  '* ' + DataModule2.Table8Gebjahr.AsString
              else if DataModule2.Table8Taufjahr.AsString <> '' then
                StringGrid4.Cells[2, zeile - 1] :=
                  '~ ' + DataModule2.Table8Taufjahr.AsString;
              if DataModule2.Table8Stjahr.AsString <> '' then
                StringGrid4.Cells[3, zeile - 1] :=
                  '+ ' + DataModule2.Table8Stjahr.AsString
              else if DataModule2.Table8Begjahr.AsString <> '' then
                StringGrid4.Cells[3, zeile - 1] :=
                  '# ' + DataModule2.Table8Begjahr.AsString;
              StringGrid4.Cells[4, zeile - 1] := 'S';
              Inc(zeile);
            end;
            DataModule2.Table8.Next;
          until DataModule2.Table8Mutter.AsInteger <> mutter2;
    end;
  end;

  { The children of the mother that do not have the same father. }
  if Length(s4) > 0 then
  begin
    anzahl := Length(s4) div 6;
    for i := 1 to anzahl do
    begin
      DataModule2.Table8.Open;
      DataModule2.Table8.IndexName := 'vat';
      mutter2 := StrToInt(Copy(s4, 6 * (i - 1) + 1, 6));
      if mutter2 > 0 then
        if DataModule2.Table8.FindKey([mutter2]) then
          repeat
            if DataModule2.Table8Vater.AsInteger <> person then
            begin
              StringGrid4.RowCount := zeile;
              StringGrid4.Cells[0, zeile - 1] :=
                Format('%6s', [IntToStr(DataModule2.Table8Nummer.AsInteger)]);
              StringGrid4.Cells[1, zeile - 1] :=
                DataModule2.Table8Name.AsString + ' ' +
                DataModule2.Table8Vornamen.AsString;
              if DataModule2.Table8Gebjahr.AsString <> '' then
                StringGrid4.Cells[2, zeile - 1] :=
                  '* ' + DataModule2.Table8Gebjahr.AsString
              else if DataModule2.Table8Taufjahr.AsString <> '' then
                StringGrid4.Cells[2, zeile - 1] :=
                  '~ ' + DataModule2.Table8Taufjahr.AsString;
              if DataModule2.Table8Stjahr.AsString <> '' then
                StringGrid4.Cells[3, zeile - 1] :=
                  '+ ' + DataModule2.Table8Stjahr.AsString
              else if DataModule2.Table8Begjahr.AsString <> '' then
                StringGrid4.Cells[3, zeile - 1] :=
                  '# ' + DataModule2.Table8Begjahr.AsString;
              StringGrid4.Cells[4, zeile - 1] := 'S';
              Inc(zeile);
            end;
            DataModule2.Table8.Next;
          until DataModule2.Table8Vater.AsInteger <> mutter2;
    end;
  end;

  tabenab;
  Label19.Visible := False;

  { The person that was worked on is looked for again. }
  DataModule2.Table1.Open;
  DataModule2.Table1.First;
  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.FindKey([person]);
  anzeigen;
end;


procedure TForm1.geschw(ANummer, AVater: Integer; AMutter, AVater2: Integer;
  AArt, AText: string; var A1, A2: string; var A3: Integer);
var
  s: string;
  kennung: string;
begin
  { Die Geschwister der Person werden gesucht.  Die Tabelle der Verbindungen
    (Table8) steht dabei auf dem ersten Kind; sie wird hier durchlaufen.

    A1 sammelt die Nummern der Geschwister, A2 die Nummern der Eltern der
    Geschwister und A3 zaehlt die Zeilen des Gitters. }
  kennung := AText;
  repeat
    if DataModule2.Table8.FieldByName(AArt).AsInteger <> AVater2 then
      Break;

    if DataModule2.Table8Nummer.AsInteger <> ANummer then
    begin
      s := zahl6(DataModule2.Table8Nummer.AsInteger);
      if Pos(s, A1) = 0 then
        A1 := A1 + s + '*';

      if AArt = 'vater' then
      begin
        if DataModule2.Table8Vater.AsInteger > 0 then
        begin
          s := zahl6(DataModule2.Table8Vater.AsInteger);
          if Pos(s, A2) = 0 then
            A2 := A2 + s + '*';
        end;
      end;

      if AArt = 'mutter' then
      begin
        if DataModule2.Table8Mutter.AsInteger > 0 then
        begin
          s := zahl6(DataModule2.Table8Mutter.AsInteger);
          if Pos(s, A2) = 0 then
            A2 := A2 + s + '*';
        end;
      end;

      { The sibling is written into the grid. }
      StringGrid4.RowCount := A3;
      StringGrid4.Cells[0, A3 - 1] :=
        Format('%6s', [IntToStr(DataModule2.Table8Nummer.AsInteger)]);
      StringGrid4.Cells[1, A3 - 1] := DataModule2.Table8Name.AsString + ' ' +
                                      DataModule2.Table8Vornamen.AsString;
      if DataModule2.Table8Gebjahr.AsString <> '' then
        StringGrid4.Cells[2, A3 - 1] := '* ' + DataModule2.Table8Gebjahr.AsString
      else if DataModule2.Table8Taufjahr.AsString <> '' then
        StringGrid4.Cells[2, A3 - 1] := '~ ' + DataModule2.Table8Taufjahr.AsString;
      if DataModule2.Table8Stjahr.AsString <> '' then
        StringGrid4.Cells[3, A3 - 1] := '+ ' + DataModule2.Table8Stjahr.AsString
      else if DataModule2.Table8Begjahr.AsString <> '' then
        StringGrid4.Cells[3, A3 - 1] := '# ' + DataModule2.Table8Begjahr.AsString;

      { "G" stands for a full sibling, "H" for a half sibling. }
      if AArt <> 'S' then
      begin
        if AArt = 'vater' then
        begin
          if DataModule2.Table8Vater.AsInteger = AMutter then
            kennung := 'G'
          else
            kennung := 'H';
        end;
        if AArt = 'mutter' then
        begin
          if DataModule2.Table8Mutter.AsInteger = 0 then
            kennung := 'G'
          else
            kennung := 'H';
        end;
      end;
      StringGrid4.Cells[4, A3 - 1] := kennung;

      Inc(A3);
    end;

    DataModule2.Table8.Next;
  until DataModule2.Table8.Eof;
end;

procedure TForm1.datcheck(p1, p2, p3: string);
begin
  { The three parts of the date are checked. If the date is not a valid
    one, the user is asked whether the date is correct. }
  if (Trim(p1) <> '') or (Trim(p2) <> '') or (Trim(p3) <> '') then
  begin
    try
      StrToDate(p1 + '.' + p2 + '.' + p3);
    except
      ShowMessage('Datum : ' + p1 + '.' + p2 + '.' + p3 + '   Okay ?');
    end;
  end;
end;

procedure TForm1.kinderanz;
var
  anzahl, anzahlEhen, i, j, spalte, zeile: Integer;
  ehen: array[1..10] of Integer;
  geschlecht: string;
  s: string;
begin
  { The children of the person are shown in StringGrid2, their number in
    Label7. The number of the marriage of the parents is shown as a Roman
    numeral in the last column. }
  anzahl := DataModule2.Table1.RecordCount;
  if anzahl < 2 then
  begin
    for spalte := 0 to StringGrid2.ColCount do
      for zeile := 0 to StringGrid2.RowCount do
        StringGrid2.Cells[spalte, zeile] := '';
    StringGrid2.RowCount := 0;
    Label7.Caption := 'Keine Kinder';
  end
  else
  begin
    { Children that were born after the given year are not shown. }
    if gvar_02536BA0 > 1 then
    begin
      DataModule2.Table7.Filter := 'gebjahr<=' + IntToStr(gvar_02536BA0) +
                                      ' and taufjahr<=' + IntToStr(gvar_02536BA0);
      DataModule2.Table7.Filtered := True;
      DBText1.Color := clYellow;
    end;

    { The numbers of the spouses of the marriages are collected; they are
      needed to find the marriage of the parents of a child. }
    DataModule2.Table5.First;
    i := 1;
    anzahlEhen := 0;
    while not DataModule2.Table5.Eof do
    begin
      ehen[i] := DataModule2.Table5Epnum.AsInteger;
      DataModule2.Table5.Next;
      anzahlEhen := i;
      Inc(i);
    end;

    { The children are looked for under the father or under the mother. }
    geschlecht := UpperCase(DataModule2.Table1Geschlecht.AsString);
    if geschlecht = 'M' then
      DataModule2.Table7.IndexFieldNames := 'Vater;indj'
    else if geschlecht = 'W' then
      DataModule2.Table7.IndexFieldNames := 'Mutter;indj';

    anzahl := DataModule2.Table7.RecordCount;
    if anzahl = 0 then
      Label7.Caption := 'Keine Kinder'
    else if anzahl = 1 then
      Label7.Caption := '1 Kind'
    else
      Label7.Caption := IntToStr(anzahl) + ' Kinder';

    for spalte := 0 to StringGrid2.ColCount do
      for zeile := 0 to StringGrid2.RowCount do
        StringGrid2.Cells[spalte, zeile] := '';

    DataModule2.Table7.First;
    i := 0;
    while (i < anzahl) and not DataModule2.Table7.Eof do
    begin
      StringGrid2.Cells[1, i] := Format('%6s', [IntToStr(DataModule2.Table7Nummer.AsInteger)]);
      StringGrid2.Cells[2, i] := DataModule2.Table7Name.AsString + ' ' +
                               DataModule2.Table7Vornamen.AsString;
      if Trim(DataModule2.Table7Gebjahr.AsString) <> '' then
        StringGrid2.Cells[3, i] := '* ' + DataModule2.Table7Gebjahr.AsString
      else if Trim(DataModule2.Table7Taufjahr.AsString) <> '' then
        StringGrid2.Cells[3, i] := '~ ' + DataModule2.Table7Taufjahr.AsString;
      if Trim(DataModule2.Table7Stjahr.AsString) <> '' then
        StringGrid2.Cells[4, i] := '+ ' + DataModule2.Table7Stjahr.AsString
      else if Trim(DataModule2.Table7Begjahr.AsString) <> '' then
        StringGrid2.Cells[4, i] := '# ' + DataModule2.Table7Begjahr.AsString;

      { The marriage of the parents is searched. }
      for j := 1 to anzahlEhen do
      begin
        if geschlecht = 'M' then
        begin
          if (DataModule2.Table7Mutter.AsInteger > 0) and
             (DataModule2.Table7Mutter.AsInteger = ehen[j]) then
          begin
            roem(j, s);
            StringGrid2.Cells[5, i] := '   ' + s;
            Break;
          end;
        end
        else if geschlecht = 'W' then
        begin
          if (DataModule2.Table7Vater.AsInteger > 0) and
             (DataModule2.Table7Vater.AsInteger = ehen[j]) then
          begin
            roem(j, s);
            StringGrid2.Cells[5, i] := '   ' + s;
            Break;
          end;
        end;
      end;

      Inc(i);
      DataModule2.Table7.Next;
    end;
  end;
end;

procedure TForm1.eltanz;
var
  s1, s2, s3: string;
begin
  { The parents of the person are shown: the father in Edit1, the mother
    in Edit2. The number of the person is written in front of the name,
    right aligned in six characters. }
  Edit1.Text := '';
  Edit2.Text := '';
  DataModule2.Table8.IndexName := '';

  if DataModule2.Table8.FindKey([DataModule2.Table1Vater.AsInteger]) then
  begin
    s1 := Format('%6s', [IntToStr(DataModule2.Table8Nummer.AsInteger)]);
    s2 := DataModule2.Table8Name.AsString;
    s3 := DataModule2.Table8Vornamen.AsString;
    Edit1.Text := s1 + ' ' + s2 + ' ' + s3;
  end;

  if DataModule2.Table8.FindKey([DataModule2.Table1Mutter.AsInteger]) then
  begin
    s1 := Format('%6s', [IntToStr(DataModule2.Table8Nummer.AsInteger)]);
    s2 := DataModule2.Table8Name.AsString;
    s3 := DataModule2.Table8Vornamen.AsString;
    Edit2.Text := s1 + ' ' + s2 + ' ' + s3;
  end;
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin
  { The person that is marked in the list is shown. }
  if Trim(StringGrid1.Cells[1, StringGrid1.Row]) <> '' then
    DataModule2.Table1.FindKey([StrToInt(StringGrid1.Cells[1, StringGrid1.Row])]);
  gvar_02536910 := DataModule2.Table1Nummer.AsInteger;
  anzeigen;
end;

procedure TForm1.StringGrid2DblClick(Sender: TObject);
begin
  { The person that is marked in the list is shown. }
  if Trim(StringGrid2.Cells[1, StringGrid2.Row]) <> '' then
    DataModule2.Table1.FindKey([StrToInt(StringGrid2.Cells[1, StringGrid2.Row])]);
  gvar_02536910 := DataModule2.Table1Nummer.AsInteger;
  anzeigen;
end;

procedure TForm1.Edit1DblClick(Sender: TObject);
begin
  //005DCBD4: Person der Nummer in Edit1 in der Haupttabelle suchen.
  if Trim(Edit1.Text) <> '' then
    DataModule2.Table1.FindKey([StrToInt(Copy(Edit1.Text, 1, 6))]);
  anzeigen;
end;

procedure TForm1.Edit2DblClick(Sender: TObject);
begin
  { The number of the mother is entered in Edit2; on a double click the
    person is looked for and shown. }
  if Trim(Edit2.Text) <> '' then
    DataModule2.Table1.FindKey([StrToInt(Copy(Edit2.Text, 1, 6))]);
  anzeigen;
end;

procedure TForm1.DatensatzNr1Click(Sender: TObject);
var
  s: string;
begin
  { The record with the given number is looked for. }
  PageControl1.ActivePage := TabSheet2;
  if InputQuery('Datensatz suchen', 'Datensatz-Nr.: ', s) then
  begin
    try
      DataModule2.Table1.IndexName := '';
      DataModule2.Table1.FindKey([StrToInt(s)]);
      anzeigen;
    except
      ShowMessage('Bitte Zahlenwert eingeben.');
      DatensatzNr1.Click;
    end;
  end;
end;

procedure TForm1.Prfen1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.DBNavigator1Click(Sender: TObject);
begin
  { A new person can only be entered when a person is selected. }
  if DataModule2.Table1Nummer.AsInteger > 0 then
    neu1.Enabled := True;
  anzeigen;
end;

procedure TForm1.neu1Click(Sender: TObject);
var
  spalte, zeile: Integer;
begin
  { A new person is created: the tables are put in the right order, the
    old data is saved, the fields are cleared and a new record is
    appended. }
  gvar_0253692C := 'dsneu';
  DataModule2.Table1.IndexName := '';
  DataModule2.Table5.IndexName := 'num';
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  speich1;

  ComboBox4.Text := '';
  ComboBox6.Text := '';
  ComboBox7.Text := '';
  ComboBox8.Text := '';
  ComboBox9.Text := '';
  ComboBox11.Text := '';
  ComboBox12.Text := '';
  ComboBox13.Text := '';
  ComboBox14.Text := '';
  ComboBox15.Text := '';

  DataModule2.Table1.Append;
  DataModule2.Table1Lebt.AsString := 'n';
  DataModule2.Table1Quelleg.AsString := '';
  DataModule2.Table1Quellet.AsString := '';
  DataModule2.Table1Quelles.AsString := '';
  DataModule2.Table1Quelleb.AsString := '';
  DataModule2.Table1Quelle.AsString := '';
  DBCheckBox1.Checked := False;
  Edit1.Text := '';
  Edit2.Text := '';
  Label22.Caption := '';
  Label23.Caption := '';
  Label24.Caption := '';
  Label25.Caption := '';
  Label6.Caption := '';
  Label7.Caption := '';
  Image1.Picture := nil;

  for spalte := 0 to StringGrid1.ColCount do
    for zeile := 0 to StringGrid1.RowCount do
      StringGrid1.Cells[spalte, zeile] := '';
  StringGrid1.RowCount := 1;

  for spalte := 0 to StringGrid2.ColCount do
    for zeile := 0 to StringGrid2.RowCount do
      StringGrid2.Cells[spalte, zeile] := '';
  StringGrid2.RowCount := 1;

  Label20.Caption := '';
  ComboBox4.SetFocus;
end;

procedure TForm1.speich1;
begin
  { A record that was newly created and that has no name at all is
    removed again. The original only looks at the records that are in the
    state dsEdit or dsInsert (the state of the table is at offset 0x9D). }
  if DataModule2.Table1.State in [dsEdit, dsInsert] then
    if Trim(DataModule2.Table1Name.AsString) = '' then
      if Trim(DataModule2.Table1Vornamen.AsString) = '' then
      begin
        DataModule2.Table1.Post;
        DataModule2.Table1.Delete;
        Exit;
      end;

  { The number of the person has to be unique; the number is looked for
    in the table of the persons. Only a record that has just been created
    (state dsInsert) is checked. }
  if DataModule2.Table1.State = dsInsert then
    if DataModule2.Table3.FindKey([DataModule2.Table1Nummer.AsInteger]) then
    begin
      ShowMessage('Datensatz kann nicht gespeichert werden (Indexfehler: ' +
                  IntToStr(DataModule2.Table1.Recno) + ').');
      { The original compares the number of the record with the text
        '41260' here; both branches of the comparison do nothing. }
    end
    else
      DataModule2.Table1.Post;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  OsVersion: TOsVersionInfo;
  Faktor: Double;
  i: Integer;
  h: Integer;
begin
  { The directory of the data is remembered in the global string
    gvar_02536B9C; it is the base for the help file, for the alias of the
    BDE and for the configuration file.

    The original takes the directory of the program file. The
    reconstruction uses the current directory, because the program file
    sets it to the directory of the data (the program file itself may be
    started from somewhere else). }
  gvar_02536B9C := IncludeTrailingPathDelimiter(GetCurrentDir);

  { The title and the help file depend on the Windows version: from Windows
    2000 on the program uses the compiled help file, before that the old
    help file. On a system that does not know GetVersionEx at all the
    except branch sets a blank help file. }
  try
    OsVersion.dwOSVersionInfoSize := SizeOf(OsVersion);
    GetVersionEx(OsVersion);
    if OsVersion.dwMajorVersion >= 6 then
    begin
      Application.Title := 'AHNENWIN 5.1';
      Application.HelpFile := gvar_02536B9C + 'AHNWIN50.chm';
    end
    else
    begin
      Application.Title := 'AHNENWIN 5.1';
      Application.HelpFile := gvar_02536B9C + 'AHNWIN51.HLP';
    end;
  except
    Application.Title := 'AHNENWIN 5.1';
    Application.HelpFile := gvar_02536B9C + ' ';
  end;

  { The screen dimensions at the moment of the start are remembered, they
    are the reference for the scaling of the other forms. }
  gvar_02536BA8 := Screen.Height;
  gvar_02536BAC := Screen.Width;
  gvar_02536BA4 := Height;

  { The directory for the pictures of the family chart.

    The listing calls a function of the VCL that reports whether the
    directory exists - FileExists would return false for a directory, so
    DirectoryExists is the equivalent that matches the behaviour of the
    original. }
  if not DirectoryExists('Bilder') then
    if not CreateDir('Bilder') then
      raise Exception.Create('Verzeichnis Bilder kann nicht erstellt werden');

  UpDown1.Visible := False;

  { The BDE is configured for the directory of the data: the tables are
    found through the standard alias "PARADOX". The configuration mode
    cfmSession (the value 4 of the listing) keeps the alias for the
    session only.

    The original takes the directory of the program file, the
    reconstruction the current directory, which the program file has set
    to the directory of the data. }
  gvar_0253692C := 'crea';
  gvar_02536B9C := IncludeTrailingPathDelimiter(GetCurrentDir);
  Session.ConfigMode := [cfmSession];
  Session.AddStandardAlias(' ', gvar_02536B9C, 'PARADOX');
  { The data module is normally created by the program file, before the
    forms, because the resources of the forms refer to it. The original
    program creates it here; the reconstruction only creates it when it
    does not exist yet. }
  if DataModule2 = nil then
    Application.CreateForm(TDataModule2, DataModule2);

  alineu(' ');

  { The program needs a printer; the list of the installed printers is
    shown in the memo while it is checked. }
  Memo1.Clear;
  Memo1.Lines := Printer.Printers;
  if Trim(Memo1.Lines[0]) = '' then
  begin
    ShowMessage('Bitte zuerst einen Drucker installieren.');
    Halt(0);
  end;
  Memo1.Clear;

  { The form is scaled to the screen, and the row height and the column
    widths of the five month grids are taken from the height of the edit
    field. The listing multiplies the column widths with the factor 1.0;
    the value is kept as it is. }
  Scaled := True;
  Faktor := 1.0;

  StringGrid1.DefaultRowHeight := DBEdit2.Height - 2;
  for i := 0 to 5 do
    StringGrid1.ColWidths[i] := Round(StringGrid1.ColWidths[i] * Faktor);

  StringGrid2.DefaultRowHeight := DBEdit2.Height - 2;
  for i := 0 to 5 do
    StringGrid2.ColWidths[i] := Round(StringGrid2.ColWidths[i] * Faktor);

  StringGrid3.DefaultRowHeight := DBEdit2.Height - 2;
  for i := 0 to 4 do
    StringGrid3.ColWidths[i] := Round(StringGrid3.ColWidths[i] * Faktor);

  StringGrid4.DefaultRowHeight := DBEdit2.Height - 2;
  for i := 0 to 4 do
    StringGrid4.ColWidths[i] := Round(StringGrid4.ColWidths[i] * Faktor);

  StringGrid5.DefaultRowHeight := DBEdit2.Height - 2;
  for i := 0 to 3 do
    StringGrid5.ColWidths[i] := Round(StringGrid5.ColWidths[i] * Faktor);

  { The password of the Paradox tables. }
  Session.AddPassword('hheerrii');

  { The five edit fields for the unused import are put behind. }
  Edit3.SendToBack;
  Edit7.SendToBack;
  Edit11.SendToBack;
  Edit12.SendToBack;
  Edit16.SendToBack;

  { The dates of the program file and of the database are shown in the
    about box.

    The original opens both files without checking the result. When a file
    is missing, FileOpen returns -1 and FileGetDate(-1) returns -1, so
    FileDateToDateTime raises EConvertError ("Ungueltiges Argument zum
    Codieren des Datums"). The reconstruction checks the handle, uses the
    date when the file is there and falls back to 0 (the epoch) when it is
    not, so that the program starts without a database as well. The file
    handles are closed in every case - the original closes them too. }
  h := FileOpen('AHNWIN51.exe', 64);
  if h >= 0 then
  begin
    gvar_02536924 := FileDateToDateTime(FileGetDate(h));
    FileClose(h);
  end
  else
    gvar_02536924 := 0;

  h := FileOpen('awd.db', 64);
  if h >= 0 then
  begin
    gvar_0253691C := FileDateToDateTime(FileGetDate(h));
    FileClose(h);
  end
  else
    gvar_0253691C := 0;

  Application.ShowHint := True;

  { The tables of the database are opened. Table1 and Table5 are opened
    exclusively for a moment, so that the maximum number of the persons
    can be read. }
  DataModule2.Table1.Exclusive := True;
  DataModule2.Table1.Exclusive := False;
  try
    DataModule2.Table1.Open;
  except
    on E: Exception do
    begin
      { The database was not found. The original program lets the error of
        the BDE come; the reconstruction names the directory that was
        searched, because the program can be started from anywhere.

        The program is stopped here on purpose. The OnCreate handler of a
        form runs in AfterConstruction, that is *after* the constructor,
        so an exception would not reach the caller of Create: the VCL
        would show its own error window and the program would continue
        with a half created form - which ends in an access violation
        later on. }
      MessageBox(0,
        PChar('Die Tabelle AWD.DB wurde nicht gefunden.' + #13#10 +
              'Gesucht im Verzeichnis: ' + gvar_02536B9C + #13#10 + #13#10 +
              'Die Programmdatei muss im Verzeichnis der Daten liegen.' +
              #13#10 + 'Alternativ kann das Verzeichnis angegeben werden:' +
              #13#10 + '  AHNWIN51.exe <Verzeichnis>' + #13#10 + #13#10 +
              E.Message),
        'AHNENWIN 5.1', MB_OK or MB_ICONERROR);
      Halt(1);
    end;
  end;
  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.Last;
  gvar_0253690C := DataModule2.Table1Nummer.AsInteger + 1;
  DataModule2.Table1.First;

  DataModule2.Table2.Open;
  DataModule2.Table3.Open;
  DataModule2.Table3.IndexName := '';
  DataModule2.Table4.Open;
  DataModule2.Table4.IndexName := '';

  DataModule2.Table5.Exclusive := True;
  DataModule2.Table5.Exclusive := False;
  DataModule2.Table5.Open;
  DataModule2.Table5.IndexName := 'num';
  DataModule2.Table6.Open;
  DataModule2.Table6.IndexName := '';
  DataModule2.Table7.Open;
  DataModule2.Table7.IndexName := 'vat';
  DataModule2.Table8.Open;
  DataModule2.Table8.IndexName := '';
  DataModule2.Table9.Open;
  DataModule2.Table9.IndexName := '';
  DataModule2.Table10.Open;
  DataModule2.Table10.IndexName := '';
  DataModule2.Table11.Open;
  DataModule2.Table11.IndexName := '';

  { The name list fills two of the combo boxes. }
  DataModule2.Table12.Exclusive := True;
  DataModule2.Table12.Exclusive := False;
  DataModule2.Table12.Open;
  ComboBox4.Clear;
  ComboBox10.Clear;
  DataModule2.Table12.First;
  while not DataModule2.Table12.Eof do
  begin
    ComboBox4.Items.Add(DataModule2.Table12Name.AsString);
    ComboBox10.Items.Add(DataModule2.Table12Name.AsString);
    DataModule2.Table12.Next;
  end;

  { The places fill the remaining combo boxes - but only when they are not
    filled already. }
  DataModule2.Table13.Open;
  DataModule2.Table13.First;
  if ComboBox6.Items.Count < 2 then
  begin
    ComboBox6.Clear;
    ComboBox1.Clear;
    ComboBox2.Clear;
    ComboBox3.Clear;
    ComboBox7.Clear;
    ComboBox8.Clear;
    ComboBox9.Clear;
    ComboBox16.Clear;
    ComboBox17.Clear;
    ComboBox18.Clear;
    ComboBox19.Clear;
    ComboBox20.Clear;
    ComboBox21.Clear;
    ComboBox22.Clear;
    ComboBox23.Clear;
    ComboBox24.Clear;
    ComboBox25.Clear;
    DataModule2.Table13.First;
    while not DataModule2.Table13.Eof do
    begin
      ComboBox6.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox1.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox2.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox3.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox7.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox8.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox9.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox16.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox17.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox18.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox19.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox20.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox21.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox22.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox11.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox12.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox13.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox14.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox15.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox23.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox24.Items.Add(DataModule2.Table13Ort.AsString);
      ComboBox25.Items.Add(DataModule2.Table13Ort.AsString);
      DataModule2.Table13.Next;
    end;
  end;

  { The sources of the current person are shown in the combo boxes. }
  DataModule2.Table37.Open;
  DataModule2.Table37.First;
  ComboBox12.Text := DataModule2.Table1Quellet.AsString;
  ComboBox13.Text := DataModule2.Table1Quelles.AsString;
  ComboBox14.Text := DataModule2.Table1Quelleb.AsString;
  ComboBox15.Text := DataModule2.Table1Quelle.AsString;

  { The fifth grid is only used while the calendar is shown. }
  StringGrid5.Visible := False;

  { One entry of the menu is removed. }
  MainMenu1.Items[3].Items[5].Visible := False;

  { The splash screen is closed. The original closes it without a check -
    the program file always creates the splash screen before the main form.
    The check keeps the program from running into an access violation when
    the main form is created on its own (TCustomForm.Close reads the field
    FFormState of the splash screen). }
  if Form8 <> nil then
    Form8.Close;

  { The window caption is taken from the configuration file "par.cfg"; it
    holds a short string of up to 50 characters. When the file does not
    exist, it is created and the caption of the form is kept. }

  if FileExists(gvar_02536B9C + 'par.cfg') then
  begin
    gvar_02536BB0 := TFileStream.Create(gvar_02536B9C + 'par.cfg', fmOpenRead);
    gvar_02536BB0.ReadBuffer(gvar_02536BB4, 33);
  end
  else
    gvar_02536BB0 := TFileStream.Create(gvar_02536B9C + 'par.cfg', fmCreate);

  Caption := gvar_02536BB4;
  Application.Title := gvar_02536BB4;
  gvar_02536BB0.Free;

  DataModule2.Table1.Edit;
  DataModule2.Table5.Edit;
end;


procedure TForm1.FormClose(sender:tobject;var action:tcloseaction);
var
  i: Integer;
begin
  { The page with the data of the person is shown again, so that the data
    are not lost when the program is closed. }
  if PageControl1.ActivePage <> TabSheet2 then
    PageControl1.ActivePage := TabSheet2;

  speich1;

  { The temporary files of the program are removed. }
  FileListBox2.Mask := '_q*.*';
  for i := 0 to FileListBox2.Count - 1 do
    SysUtils.DeleteFile(FileListBox2.Items[i]);

  if MessageDlg('AHNENWIN 5.1 beenden ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if Trim(DBText1.Field.AsString) <> '' then
    begin
      if DataModule2.Table1.State in [dsEdit, dsInsert] then
      begin
        try
          DataModule2.Table1.Post;
        except
        end;
      end;

      if DataModule2.Table5.State in [dsEdit, dsInsert] then
        if (DataModule2.Table5Nummer.AsInteger > 0) or
           (DataModule2.Table5Epnum.AsInteger > 0) then
        begin
          try
            DataModule2.Table5.Post;
          except
          end;
        end;

      if DataModule2.Table1Nummer.AsInteger > 0 then
        datsich;
    end;

    DataModule2.Table1.Close;
    DataModule2.Table4.Close;
    DataModule2.Table5.Close;
    DataModule2.Table20.Close;
    DataModule2.Table35.Close;

    if FileExists('vorfa.txt') then
      SysUtils.DeleteFile('vorfa.txt');
    if FileExists('kn.txt') then
      SysUtils.DeleteFile('kn.txt');

    { The title of the window is written into the configuration file. }
    gvar_02536BB4 := Copy(Caption, 1, 32);
    gvar_02536BB0 := TFileStream.Create(gvar_02536B9C + 'par.cfg', fmCreate);
    try
      gvar_02536BB0.WriteBuffer(gvar_02536BB4, 33);
    finally
      gvar_02536BB0.Free;
    end;

    Session.RemoveAllPasswords;
    Application.Terminate;
  end
  else
    action := caNone;
end;

procedure TForm1.ehenanz;
var
  anzahl: Integer;
  i, spalte, zeile: Integer;
  kennung: string;
begin
  { The connections of the person are shown in StringGrid1, their number
    in Label6. A marriage is marked with "o-o" in the last column, a
    marriage year with "K", a separation year with "S". }
  anzahl := DataModule2.Table5.RecordCount;
  if anzahl = 0 then
    Label6.Caption := 'Keine Verbindung'
  else if anzahl = 1 then
    Label6.Caption := '1 Verbindung'
  else
    Label6.Caption := IntToStr(anzahl) + ' Verbindungen';

  StringGrid1.RowCount := anzahl;

  { The grid is cleared. }
  for spalte := 0 to StringGrid1.ColCount do
    for zeile := 0 to StringGrid1.RowCount do
      StringGrid1.Cells[spalte, zeile] := '';

  DataModule2.Table5.First;
  for i := 0 to anzahl - 1 do
  begin
    if DataModule2.Table5Epnum.AsInteger > 0 then
    begin
      StringGrid1.Cells[1, i] := Format('%6s', [IntToStr(DataModule2.Table5Epnum.AsInteger)]);
      StringGrid1.Cells[2, i] := DataModule2.Table6Name.AsString + ' ' +
                               DataModule2.Table6Vornamen.AsString;
      if Trim(DataModule2.Table6Gebjahr.AsString) <> '' then
        StringGrid1.Cells[3, i] := '* ' + DataModule2.Table6Gebjahr.AsString
      else if Trim(DataModule2.Table6Taufjahr.AsString) <> '' then
        StringGrid1.Cells[3, i] := '~ ' + DataModule2.Table6Taufjahr.AsString;
      if Trim(DataModule2.Table6Sttag.AsString + ' ' +
             DataModule2.Table6Stmonat.AsString + ' ' +
             DataModule2.Table6Stjahr.AsString) <> '' then
        StringGrid1.Cells[4, i] := DataModule2.Table6Stjahr.AsString + '+ '
      else if Trim(DataModule2.Table6Begtag.AsString + ' ' +
                  DataModule2.Table6Begmonat.AsString + ' ' +
                  DataModule2.Table6Begjahr.AsString) <> '' then
        StringGrid1.Cells[4, i] := '# ' + DataModule2.Table6Begjahr.AsString;
    end;

    { The kind of the connection: a marriage is marked with "o-o". }
    kennung := 'oo';
    if Pos('Ehes', DataModule2.Table5Verbind.AsString) > 0 then
      kennung := 'o-o';
    StringGrid1.Cells[5, i] := kennung;

    if Trim(DataModule2.Table5Sajahr.AsString) <> '' then
      StringGrid1.Cells[5, i] := StringGrid1.Cells[5, i] + 'S' +
                                DataModule2.Table5Sajahr.AsString;

    if Trim(DataModule2.Table5Hjahr.AsString) <> '' then
      if kennung = 'oo' then
        StringGrid1.Cells[5, i] := StringGrid1.Cells[5, i] + 'K' +
                                  DataModule2.Table5Hjahr.AsString
      else
        StringGrid1.Cells[5, i] := StringGrid1.Cells[5, i] + ' ' +
                                  DataModule2.Table5Hjahr.AsString;

    DataModule2.Table5.Next;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  { The listing calls Table1Nummer.GetAsInteger and discards the result.
    The value was assigned to a local variable that the compiler removed
    because it was never used. }
  DataModule2.Table1Nummer.AsInteger;

  { The factor for the scaling of the display and the number of lines
    that are calculated from it. }
  gvar_0061F120 := 1.9;
  gvar_0061F11C := Round(gvar_0061F120 * 6);

  PageControl1.ActivePage := TabSheet2;

  { Without persons in the table the entry for a new person is not
    possible. }
  if DataModule2.Table1.RecordCount < 1 then
    neu1.Enabled := False;

  { The tables of the places, of the titles and of the notes are opened
    and positioned on their first record. }
  DataModule2.Table12.Open;
  DataModule2.Table12.First;
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;
  DataModule2.Table13.Open;
  DataModule2.Table13.First;

  DBGrid3.Visible := False;
  Label81.Visible := False;

  anzeigen;
end;

procedure TForm1.schen1Click(Sender: TObject);
var
  nummer: Integer;
  geschlecht: string[1];
begin
  { The person is given away: the record is deleted, the reference in the
    children is removed and the number of the person is written into the
    table of the deleted persons. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  speich1;

  nummer := DataModule2.Table1Nummer.AsInteger;
  geschlecht := UpperCase(DataModule2.Table1Geschlecht.AsString);

  if MessageDlg('Datensatz l' + #246 + 'schen ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    { All the marriages of the person are removed. The link to the master
      is removed for the time, so that the deletions do not change the
      table of the persons. In Delphi 9 the property DataSource of a table
      cannot be written; MasterSource is the link to the master. }
    DataModule2.Table5.First;
    while not DataModule2.Table5.Eof do
      DataModule2.Table5.Delete;

    DataModule2.Table5.MasterSource := nil;
    DataModule2.Table5.IndexName := 'ep';
    DataModule2.Table5.First;
    if DataModule2.Table5.FindKey([nummer]) then
      while DataModule2.Table5Epnum.AsInteger = DataModule2.Table1Nummer.AsInteger do
      begin
        DataModule2.Table5.Delete;
      end;

    DataModule2.Table5.IndexName := 'num';
    DataModule2.Table5.MasterSource := DataModule2.DataSource1;

    { The reference of the person in the children is removed: as the father
      or as the mother. }
    if geschlecht = 'M' then
    begin
      DataModule2.Table1.IndexName := 'vat';
      DataModule2.Table1.First;
      if DataModule2.Table1.FindKey([nummer]) then
        while DataModule2.Table1Vater.AsInteger = nummer do
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Vater.AsInteger := 0;
          if not DataModule2.Table1.FindKey([nummer]) then
            Break;
          if DataModule2.Table1.Eof then
            Break;
        end;
    end
    else if geschlecht = 'W' then
    begin
      DataModule2.Table1.IndexName := 'mut';
      DataModule2.Table1.First;
      if DataModule2.Table1.FindKey([nummer]) then
        while DataModule2.Table1Mutter.AsInteger = nummer do
        begin
          DataModule2.Table1.Edit;
          DataModule2.Table1Mutter.AsInteger := 0;
          if not DataModule2.Table1.FindKey([nummer]) then
            Break;
          if DataModule2.Table1.Eof then
            Break;
        end;
    end;

    DataModule2.Table1.IndexName := '';

    { The number of the person is kept in the table of the deleted persons. }
    if not DataModule2.Table4.FindKey([nummer]) then
    begin
      DataModule2.Table4.Append;
      DataModule2.Table4Num.AsInteger := nummer;
      DataModule2.Table4.Post;
    end;

    DataModule2.Table1.FindKey([nummer]);
    DataModule2.Table1.Delete;
    anzeigen;
  end;

  DataModule2.Table9.Open;
  DataModule2.Table9.Refresh;
  DataModule2.Table8.Open;
  DataModule2.Table8.Refresh;
  DataModule2.Table17.Open;
  DataModule2.Table17.Refresh;
end;

procedure TForm1.DBNavigator1BeforeAction(Sender: TObject; Button: TNavigateBtn);
begin
  { the data is saved before the navigator acts. }
  speich1;
end;


procedure TForm1.DBGrid1DblClick(Sender: TObject);
begin
  { The person that was clicked in the list is looked for and shown. }
  if DataModule2.Table1Nummer.AsInteger > 0 then
  begin
    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.FindKey([DBGrid1.Fields[0].AsInteger]);
    PageControl1.ActivePage := TabSheet2;
    anzeigen;
  end;
end;

{ Calculates the age of a person at the date of the wedding from the
  dates of birth, of baptism and of the wedding.

  The original program has a local function for this at the address
  005D3A70. It takes the nine parts of the three dates, writes its
  result into the first parameter and returns it as well.

  If the year of birth is not known, the date of baptism is used
  instead. If the dates cannot be read, the difference of the years is
  used and marked with "ca.". }
procedure altersberechnung(gebtag, gebmonat, gebjahr: string; var ergebnis: string;
  stjahr, stmonat, sttag, taufjahr, taufmonat, tauftag: string);
var
  ok: Boolean;
  ausTauf: Boolean;
  sT, sM, sJ: string;
  dT, dM, dJ: Integer;
begin
  ergebnis := '';
  ausTauf := False;

  { Without a year of birth the date of baptism is used instead. }
  if Trim(gebjahr) = '' then begin
    gebtag := tauftag;
    gebmonat := taufmonat;
    gebjahr := taufjahr;
    ausTauf := True;
  end;

  sT := '';
  sM := '';
  sJ := '';
  ok := True;
  try
    StrToDate(gebtag + '.' + gebmonat + '.' + gebjahr);
  except
    ok := False;
  end;
  if ok then
    try
      StrToDate(sttag + '.' + stmonat + '.' + stjahr);
    except
      ok := False;
    end;

  if ok then begin
    dT := StrToInt(sttag) - StrToInt(gebtag);
    dM := StrToInt(stmonat) - StrToInt(gebmonat);
    dJ := StrToInt(stjahr) - StrToInt(gebjahr);
    if dT < 0 then begin
      Dec(dM);
      { The day of the wedding is before the day of birth: the number of
        days of the month of birth decides how much is missing. }
      try
        dT := DaysInAMonth(StrToInt(gebjahr), StrToInt(gebmonat)) -
              StrToInt(gebtag) + StrToInt(sttag);
      except
      end;
    end;
    if dM < 0 then begin
      Dec(dJ);
      Inc(dM, 12);
    end;
    if dT > 0 then sT := IntToStr(dT) + ' T';
    if dM > 0 then sM := IntToStr(dM) + ' M ';
    if dJ > 0 then sJ := IntToStr(dJ) + ' J ';
    if ausTauf then
      ergebnis := sJ
    else
      ergebnis := sT + sM + sJ;
  end else begin
    { The dates cannot be read, only the years are used. }
    if Trim(gebjahr) <> '' then
      if Trim(stjahr) <> '' then
        try
          ergebnis := IntToStr(StrToInt(stjahr) - StrToInt(gebjahr)) + ' J';
        except
        end;
    if (Trim(gebtag) <> '') or (Trim(gebmonat) <> '') or
       (Trim(sttag) <> '') or (Trim(stmonat) <> '') then
      try
        ergebnis := ergebnis + 'ca. ' +
                    IntToStr(StrToInt(stjahr) - StrToInt(gebjahr)) + ' J';
      except
      end;
  end;
end;

procedure TForm1.anzeigen;
var
  nummer: Longint;
  ch: Byte;
  s: string;
  faktor: Extended;
begin
  { The entries for a new person and for drawing a family sheet are only
    possible when a person is selected. }
  neu1.Enabled := False;
  schen1.Enabled := False;
  if DataModule2.Table1Nummer.AsInteger > 0 then begin
    neu1.Enabled := True;
    schen1.Enabled := True;
  end;

  gridanp;

  { The number of the person is kept, the table is put on the last
    record to get the highest number and afterwards back to the person. }
  nummer := DataModule2.Table1Nummer.AsInteger;
  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.Last;
  gvar_02536944 := DataModule2.Table1Nummer.AsInteger;
  DataModule2.Table1.First;
  DataModule2.Table1.FindKey([nummer]);

  { The data of the person is shown in the fields of the form. }
  ComboBox6.Text := DataModule2.Table1Gebort.AsString;
  ComboBox7.Text := DataModule2.Table1Taufort.AsString;
  ComboBox8.Text := DataModule2.Table1Stort.AsString;
  ComboBox9.Text := DataModule2.Table1Begort.AsString;
  ComboBox4.Text := DataModule2.Table1Name.AsString;
  ComboBox11.Text := DataModule2.Table1Quelle.AsString;
  ComboBox12.Text := DataModule2.Table1Quelleg.AsString;
  ComboBox13.Text := DataModule2.Table1Quellet.AsString;
  ComboBox14.Text := DataModule2.Table1Quelles.AsString;
  ComboBox15.Text := DataModule2.Table1Quelleb.AsString;
  ComboBox26.Text := DataModule2.Table1Ort.AsString;

  ehenanz;
  kinderanz;
  eltanz;

  { The pictures of the person are taken from the tables of the places
    and of the titles. }
  DataModule2.Table7.Open;
  if DataModule2.Table5.RecordCount = 0 then
    PopupMenu1.Items[1].Enabled := False
  else
    PopupMenu1.Items[1].Enabled := True;
  if DataModule2.Table7.RecordCount = 0 then
    PopupMenu2.Items[1].Enabled := False
  else
    PopupMenu2.Items[1].Enabled := True;

  { A comment of the person is marked with a "T". }
  Label20.Caption := '';
  if Trim(DataModule2.Table1Kommentar.AsString) <> '' then
    Label20.Caption := 'T';

  Image1.Picture.Graphic := nil;
  UpDown1.Visible := False;

  { The picture of the person has the name of the number of the person
    and a letter, for example "bilder\b1a.jpg". }
  gvar_02536B9C := SysUtils.ExtractFilePath(ParamStr(0));
  gvar_02536B2C := Ord('a');
  while True do begin
    gvar_02536B30 := gvar_02536B9C + 'bilder\b' + Trim(IntToStr(nummer)) +
                    Chr(gvar_02536B2C) + '.jpg';
    if FileExists(gvar_02536B9C + 'bilder\b' + Trim(IntToStr(nummer)) +
                  Chr(gvar_02536B2C) + '.jpg') then
      Break;
    Inc(gvar_02536B2C);
    if UpperCase(Chr(gvar_02536B2C)) = 'Z' then begin
      gvar_02536B2C := Ord('a');
      Break;
    end;
  end;
  while True do begin
    gvar_02536B34 := gvar_02536B9C + 'bilder\b' + Trim(IntToStr(nummer)) +
                    Chr(gvar_02536B2C) + '.bmp';
    if FileExists(gvar_02536B9C + 'bilder\b' + Trim(IntToStr(nummer)) +
                  Chr(gvar_02536B2C) + '.bmp') then
      Break;
    Inc(gvar_02536B2C);
    if UpperCase(Chr(gvar_02536B2C)) = 'Z' then begin
      gvar_02536B2C := Ord('a');
      Break;
    end;
  end;

  if FileExists(gvar_02536B30) then begin
    UpDown1.Visible := True;
    Image1.Picture.LoadFromFile(gvar_02536B30);
    { The picture keeps its proportions, the height of the field is
      given. }
    if Image1.Picture.Graphic is TJPEGImage then begin
      faktor := Image1.Picture.Graphic.Height / Image1.Height;
      Image1.Width := Round(Image1.Picture.Graphic.Width * faktor);
    end;
  end else if FileExists(gvar_02536B34) then begin
    Image1.Picture.LoadFromFile(gvar_02536B34);
    UpDown1.Visible := True;
  end;

  wt33;
  wt34;
  wt35;
  wt36;

  { The age of the person at the wedding is calculated and written into
    the field of the table. }
  DataModule2.Table1.Edit;
  s := '';
  altersberechnung(
    DataModule2.Table1Gebtag.AsString,
    DataModule2.Table1Gebmonat.AsString,
    DataModule2.Table1Gebjahr.AsString,
    s,
    DataModule2.Table1Stjahr.AsString,
    DataModule2.Table1Stmonat.AsString,
    DataModule2.Table1Sttag.AsString,
    DataModule2.Table1Taufjahr.AsString,
    DataModule2.Table1Taufmonat.AsString,
    DataModule2.Table1Tauftag.AsString);
  DataModule2.Table1Alter.AsString := s;
  DataModule2.Table1.Post;

  try
    if PageControl1.ActivePage = TabSheet2 then
      DBEdit2.SetFocus;
  except
  end;
  try
    if PageControl1.ActivePage = TabSheet7 then
      DBGrid2.SetFocus;
  except
  end;

  if gvar_02536BA0 > 1 then
    DBText1.Color := $00FFFF;

  DataModule2.Table35.Open;

  Edit3.Text := ComboBox4.Text;
  Edit7.Text := ComboBox6.Text;
  Edit11.Text := ComboBox7.Text;
  Edit12.Text := ComboBox8.Text;
  Edit16.Text := ComboBox9.Text;

  DataModule2.Table1.Edit;
  DataModule2.Table5.Edit;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  { The return key is passed on to the form. }
  if Key = #13 then
  begin
    Key := #0;
    PostMessage(Handle, WM_KEYDOWN, VK_RETURN, 0);
  end;
end;

procedure TForm1.TabSheet6Enter(Sender: TObject);
begin
  { The label shows the name of the person and the date that is the most
    important for the text: the year of the birth, of the baptism, of the
    death or of the burial. }
  if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then
    Label21.Caption := 'Text zu:  ' + DataModule2.Table1Name.AsString + ' ' +
                       DataModule2.Table1Vornamen.AsString + ' * ' +
                       DataModule2.Table1Gebjahr.AsString
  else if Trim(DataModule2.Table1Taufjahr.AsString) <> '' then
    Label21.Caption := 'Text zu:  ' + DataModule2.Table1Name.AsString + ' ' +
                       DataModule2.Table1Vornamen.AsString + ' ~ ' +
                       DataModule2.Table1Taufjahr.AsString
  else if Trim(DataModule2.Table1Stjahr.AsString) <> '' then
    Label21.Caption := 'Text zu:  ' + DataModule2.Table1Name.AsString + ' ' +
                       DataModule2.Table1Vornamen.AsString + ' + ' +
                       DataModule2.Table1Stjahr.AsString
  else if Trim(DataModule2.Table1Begjahr.AsString) <> '' then
    Label21.Caption := 'Text zu:  ' + DataModule2.Table1Name.AsString + ' ' +
                       DataModule2.Table1Vornamen.AsString + ' # ' +
                       DataModule2.Table1Begjahr.AsString
  else
    Label21.Caption := 'Text zu:  ' + DataModule2.Table1Name.AsString + ' ' +
                       DataModule2.Table1Vornamen.AsString;
end;

procedure TForm1.IDslschen1Click(Sender: TObject);
var
  i: Integer;
  nummer: Integer;
begin
  { All the IDs of the persons are removed. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  speich1;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;

  if MessageDlg('Alle IDs l' + #246 + 'schen ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    i := 1;
    Label19.Caption := 'IDs l' + #246 + 'schen      ';
    lab18ein;

    nummer := DataModule2.Table1Nummer.AsInteger;
    DataModule2.Table1.IndexName := '';
    tabdisab;
    DataModule2.Table1.First;
    while not DataModule2.Table1.Eof do
    begin
      Label18.Caption := IntToStr(i);
      Label18.Refresh;
      Inc(i);
      DataModule2.Table1.Edit;
      DataModule2.Table1IDNR.AsString := '';
      try
        DataModule2.Table1.Post;
      except
      end;
      DataModule2.Table1.Next;
    end;

    Label18.Visible := False;
    Label19.Visible := False;
    DataModule2.Table1.FindKey([nummer]);
    tabenab;
    anzeigen;
  end;
end;

procedure TForm1.DBEdit10Exit(Sender: TObject);
var
  s: string;
begin
  { The year of the birth was left: the age is calculated again and the
    date is checked. }
  wt33;
  DataModule2.Table1.Edit;
  s := '';
  altersberechnung(
    DataModule2.Table1Gebtag.AsString,
    DataModule2.Table1Gebmonat.AsString,
    DataModule2.Table1Gebjahr.AsString,
    s,
    DataModule2.Table1Stjahr.AsString,
    DataModule2.Table1Stmonat.AsString,
    DataModule2.Table1Sttag.AsString,
    DataModule2.Table1Taufjahr.AsString,
    DataModule2.Table1Taufmonat.AsString,
    DataModule2.Table1Tauftag.AsString);
  DataModule2.Table1Alter.AsString := s;
  DataModule2.Table1.Post;
  datcheck(DBEdit8.Text, DBEdit9.Text, DBEdit10.Text);
end;


procedure TForm1.TabSheet1Exit(Sender: TObject);
begin
  { The index of the table of the persons is removed. }
  DataModule2.Table1.IndexName := '';
end;

procedure TForm1.IDSatznr1Click(Sender: TObject);
var
  ueberschreiben: Boolean;
  i: Integer;
  nummer: Integer;
begin
  { The number of the record is written into the field "ID" of every
    person - either instead of the old numbers or in addition to them. }
  speich1;
  if DataModule2.Table1.RecordCount = 0 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;

  PageControl1.ActivePage := TabSheet2;
  aus1.Click;

  ueberschreiben := False;
  if MessageDlg('Datensatz-Nr. nach ID schreiben ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if MessageDlg('Bisherige IDs ' + #252 + 'berschreiben ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      ueberschreiben := True;

    i := 1;
    if ueberschreiben then
      Label19.Caption := 'IDs ersetzen    '
    else
      Label19.Caption := 'IDs erg' + #228 + 'nzen    ';
    lab18ein;

    nummer := DataModule2.Table1Nummer.AsInteger;
    DataModule2.Table1.IndexName := '';
    tabdisab;
    DataModule2.Table1.First;
    while not DataModule2.Table1.Eof do
    begin
      Label18.Caption := IntToStr(i);
      Label18.Refresh;
      Inc(i);
      DataModule2.Table1.Edit;
      if ueberschreiben then
        DataModule2.Table1IDNR.AsString := IntToStr(DataModule2.Table1Nummer.AsInteger)
      else
        if Trim(DataModule2.Table1IDNR.AsString) <> '' then
          DataModule2.Table1IDNR.AsString := DataModule2.Table1IDNR.AsString +
            ' ' + IntToStr(DataModule2.Table1Nummer.AsInteger)
        else
          DataModule2.Table1IDNR.AsString := IntToStr(DataModule2.Table1Nummer.AsInteger);
      try
        DataModule2.Table1.Post;
      except
      end;
      DataModule2.Table1.Next;
    end;

    Label18.Visible := False;
    Label19.Visible := False;
    DataModule2.Table1.FindKey([nummer]);
    tabenab;
    anzeigen;
  end;
end;

procedure TForm1.Datenlschen1Click(Sender: TObject);
begin
  { All the data is removed: the tables are emptied, the lists are
    cleared and the pictures are removed. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  if gvar_0253692C <> 'sikoein' then
    if DataModule2.Table1.RecordCount - 1 < 0 then
    begin
      ShowMessage('Keine Daten verf' + #252 + 'gbar.');
      Exit;
    end;
  if gvar_0253692C <> 'sikoein' then
    if MessageDlg('Wirklich alle Datens' + #228 + 'tze l' + #246 + 'schen ?',
                  mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    begin
      gvar_02536B64 := 0;
      Screen.Cursor := crDefault;
      Label18.Visible := False;
      Label19.Visible := False;
      DataModule2.Table1.Edit;
      DataModule2.Table5.Edit;
      Exit;
    end;

  try
    Screen.Cursor := crHourGlass;
    bild_entf;
    Label19.Caption := 'Daten l' + #246 + 'schen ...';
    Label19.Show;
    Label19.Refresh;
    Form14.ListBox1.Clear;
    Form28.ListBox1.Clear;
    Form29.ListBox1.Clear;
    Form36.ListBox1.Clear;
    Form39.ListBox1.Clear;

    DataModule2.Table2.Open;
    DataModule2.Table2.Close;
    DataModule2.Table3.Open;
    DataModule2.Table3.Close;
    DataModule2.Table4.Open;
    DataModule2.Table4.Close;
    DataModule2.Table4.EmptyTable;
    DataModule2.Table4.Open;
    DataModule2.Table6.Open;
    DataModule2.Table6.Close;
    DataModule2.Table7.Open;
    DataModule2.Table7.Close;
    DataModule2.Table8.Open;
    DataModule2.Table8.Close;
    DataModule2.Table9.Open;
    DataModule2.Table9.Close;
    DataModule2.Table10.Open;
    DataModule2.Table10.Close;
    DataModule2.Table13.Open;
    DataModule2.Table13.Close;
    DataModule2.Table13.EmptyTable;
    DataModule2.Table13.Open;
    DataModule2.Table20.Open;
    DataModule2.Table20.Close;
    DataModule2.Table20.EmptyTable;
    DataModule2.Table20.Open;
    DataModule2.Table29.Open;
    DataModule2.Table29.Close;
    DataModule2.Table29.EmptyTable;
    DataModule2.Table29.Open;
    DataModule2.Table31.Open;
    DataModule2.Table31.Close;
    DataModule2.Table31.EmptyTable;
    DataModule2.Table31.Open;
    DataModule2.Table32.Open;
    DataModule2.Table38.Open;
    DataModule2.Table38.Close;
    DataModule2.Table38.EmptyTable;
    DataModule2.Table38.Open;
    DataModule2.Table5.Open;
    DataModule2.Table5.Close;
    DataModule2.Table5.EmptyTable;
    DataModule2.Table5.Open;
    DataModule2.Table1.Open;
    DataModule2.Table1.Close;
    DataModule2.Table1.EmptyTable;
    DataModule2.Table1.Open;

    DataModule2.Table2.Open;
    DataModule2.Table3.Open;
    DataModule2.Table4.Open;
    DataModule2.Table6.Open;
    DataModule2.Table7.Open;
    DataModule2.Table8.Open;
    DataModule2.Table9.Open;
    DataModule2.Table10.Open;
    DataModule2.Table12.Open;
    DataModule2.Table12.Close;
    DataModule2.Table12.EmptyTable;
    DataModule2.Table12.Open;
    DataModule2.Table13.Open;
    DataModule2.Table13.Close;
    DataModule2.Table13.EmptyTable;
    DataModule2.Table13.Open;
    DataModule2.Table14.Open;
    DataModule2.Table14.Close;
    DataModule2.Table14.EmptyTable;
    DataModule2.Table14.Open;
    DataModule2.Table15.Open;
    DataModule2.Table15.Close;
    DataModule2.Table15.EmptyTable;
    DataModule2.Table15.Open;
    DataModule2.Table25.Open;
    DataModule2.Table25.Close;
    DataModule2.Table25.EmptyTable;
    DataModule2.Table25.Open;
    DataModule2.Table26.Open;
    DataModule2.Table26.Close;
    DataModule2.Table26.EmptyTable;
    DataModule2.Table26.Open;
    DataModule2.Table35.Open;
    DataModule2.Table35.Close;
    DataModule2.Table35.EmptyTable;
    DataModule2.Table35.Open;

    listen_akt;
    neu1.Enabled := False;
    schen1.Enabled := False;
    gvar_0253690C := 1;
    gvar_02536944 := 0;
  finally
    Screen.Cursor := crDefault;
    Label19.Visible := False;
    DataModule2.Table1.Edit;
    DataModule2.Table5.Edit;
  end;
end;

procedure TForm1.Sikoein;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.tabdisab;
begin
  { While the tables are changed, the controls are not updated. }
  DataModule2.Table1.DisableControls;
  DataModule2.Table5.DisableControls;
end;

procedure TForm1.lab18ein;
begin
  { The two labels that show the progress are shown. }
  Label18.Show;
  Label18.Caption := '0';
  Label18.Refresh;
  Label19.Show;
  Label19.Refresh;
end;

procedure TForm1.datsich;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Datensichern1Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet2;

  aus1.Click;

  datsich;

  DBEdit2.SetFocus;

end;

procedure TForm1.alineu(AAnsiString: AnsiString);
begin
  { The directory of the data is put into the database name of every
    table of the data module. The tables are then found under that
    directory. }
  DataModule2.Table1.DatabaseName := AAnsiString;
  DataModule2.Table2.DatabaseName := AAnsiString;
  DataModule2.Table3.DatabaseName := AAnsiString;
  DataModule2.Table4.DatabaseName := AAnsiString;
  DataModule2.Table5.DatabaseName := AAnsiString;
  DataModule2.Table6.DatabaseName := AAnsiString;
  DataModule2.Table7.DatabaseName := AAnsiString;
  DataModule2.Table8.DatabaseName := AAnsiString;
  DataModule2.Table9.DatabaseName := AAnsiString;
  DataModule2.Table10.DatabaseName := AAnsiString;
  DataModule2.Table11.DatabaseName := AAnsiString;
  DataModule2.Table12.DatabaseName := AAnsiString;
  DataModule2.Table13.DatabaseName := AAnsiString;
  DataModule2.Table14.DatabaseName := AAnsiString;
  DataModule2.Table15.DatabaseName := AAnsiString;
  DataModule2.Table16.DatabaseName := AAnsiString;
  DataModule2.Table17.DatabaseName := AAnsiString;
  DataModule2.Table18.DatabaseName := AAnsiString;
  DataModule2.Table19.DatabaseName := AAnsiString;
  DataModule2.Table20.DatabaseName := AAnsiString;
  DataModule2.Table21.DatabaseName := AAnsiString;
  DataModule2.Table22.DatabaseName := AAnsiString;
  DataModule2.Table24.DatabaseName := AAnsiString;
  DataModule2.Table25.DatabaseName := AAnsiString;
  DataModule2.Table26.DatabaseName := AAnsiString;
  DataModule2.Table27.DatabaseName := AAnsiString;
  DataModule2.Table28.DatabaseName := AAnsiString;
  DataModule2.Table29.DatabaseName := AAnsiString;
  DataModule2.Table30.DatabaseName := AAnsiString;
  DataModule2.Table31.DatabaseName := AAnsiString;
  DataModule2.Table32.DatabaseName := AAnsiString;
  DataModule2.Table33.DatabaseName := AAnsiString;
  DataModule2.Table35.DatabaseName := AAnsiString;
  DataModule2.Table37.DatabaseName := AAnsiString;
  DataModule2.Table38.DatabaseName := AAnsiString;
end;

procedure TForm1.tabenab;
begin
  { The controls are updated again. }
  DataModule2.Table1.EnableControls;
  DataModule2.Table5.EnableControls;
end;

procedure TForm1.SicherungsDateieinlesen1Click(Sender: TObject);
begin
  { 005E1D2C: Sicherungs-Datei einlesen. Die eigentliche Einlesearbeit
    ueberlaesst die Methode an Sikoein; danach werden die Nummern-
    Globalen gesetzt, neu1 aktiviert und die Ansicht aktualisiert. }
  PageControl1.ActivePage := TabSheet2;
  Sikoein;
  DataModule2.Table1.Last;
  gvar_0253690C := DataModule2.Table1Nummer.AsInteger + 1;
  gvar_02536944 := DataModule2.Table1Nummer.AsInteger;
  DataModule2.Table1.First;
  if DataModule2.Table1Nummer.AsInteger > 0 then
    neu1.Enabled := True;
  anzeigen;
end;

procedure TForm1.ChristlicheNamenstage1Click(Sender: TObject);
var
  HTMLDatei: TextFile;
  txt: AnsiString;
  url: AnsiString;
  anz: Integer;
  drittela: Integer;
  drittelb: Integer;
  i: Integer;
begin
  //005FA138: die Namenstage aus Table11 nach "chnt.xml" schreiben;
  //die Namen werden in drei Spalten je ein Drittel erzeugt.
  gvar_0253692C := 'CHNT';
  PageControl1.ActivePage := TabSheet2;
  speich1;
  System.Assign(HTMLDatei, 'chnt.xml');
  Rewrite(HTMLDatei);
  try
    WriteLn(HTMLDatei, '<?xml version="1.0" encoding=' + #$22 + 'ISO-8859-1' + #$22 + '?>');
    WriteLn(HTMLDatei, '<?xml-StyleSheet type=' + #$22 + 'text/css' + #$22 +
      ' href=' + #$22 + gvar_02536B9C + 'style.css' + #$22 + ' ?>');
    WriteLn(HTMLDatei, '<!--Converted from AHNENWIN 5.1 (2013) by Heribert Reitmeier-->');
    WriteLn(HTMLDatei, '<tbcnt>');
    WriteLn(HTMLDatei, '<ues>Christliche Namenstage</ues>');
    WriteLn(HTMLDatei, '<strich></strich>');
    DataModule2.Table11.Open;
    DataModule2.Table11.First;
    anz := DataModule2.Table11.RecordCount;
    drittela := Round(anz / 3) + 1;
    drittelb := Round(anz / 3) * 2 + 1;
    i := 1;
    while not DataModule2.Table11.EOF do
    begin
      // erste Spalte
      DataModule2.Table11.IndexName := 'num';
      DataModule2.Table11.FindKey([i]);
      txt := '<tblcnt><tab>' + DataModule2.Table11FELD001.AsString + '</tab>';
      WriteLn(HTMLDatei, txt);
      WriteLn(HTMLDatei, '<tabcnt>' + DataModule2.Table11FELD002.AsString +
        '.' + DataModule2.Table11FELD003.AsString + '.</tabcnt>');
      // zweite Spalte
      DataModule2.Table11.FindKey([drittela]);
      WriteLn(HTMLDatei, '<tab>' + DataModule2.Table11FELD001.AsString + '</tab>');
      WriteLn(HTMLDatei, '<tabcnt>' + DataModule2.Table11FELD002.AsString +
        '.' + DataModule2.Table11FELD003.AsString + '.</tabcnt>');
      // dritte Spalte
      DataModule2.Table11.FindKey([drittelb]);
      WriteLn(HTMLDatei, '<tab>' + DataModule2.Table11FELD001.AsString + '</tab>');
      WriteLn(HTMLDatei, '<tabcnt>' + DataModule2.Table11FELD002.AsString +
        '.' + DataModule2.Table11FELD003.AsString + '.</tabcnt></tblcnt>');
      DataModule2.Table11.Next;
    end;
    WriteLn(HTMLDatei, '<HR></HR>');
    WriteLn(HTMLDatei, 'AHNENWIN 5.1 / ' + DateToStr(Now));
    WriteLn(HTMLDatei, '</tbcnt>');
  finally
    CloseFile(HTMLDatei);
  end;
  Form10.Caption := 'Christliche Namenstage';
  Form10.Edit1.Visible := False;
  Form10.Button2.Visible := False;
  Form10.Button1.Visible := False;
  Form10.SpeedButton3.Visible := False;
  Form10.SpeedButton4.Visible := False;
  Form10.SpeedButton5.Visible := False;
  Browser(gvar_02536B9C + 'chnt.xml');
end;

procedure TForm1.FamGrafik1Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet2;

  aus1.Click;

  Form11.Show;

end;

procedure TForm1.famblattx_daten;
begin
  { TODO: Listing fehlt noch - Originaladresse 005F2F6C. }
end;

procedure TForm1.Osterberechnung1Click(Sender: TObject);
begin
  { The calculation of the Easter date is shown in its own form. }
  gvar_0253692C := 'Oster';
  PageControl1.ActivePage := TabSheet2;
  speich1;
  Form10.ShowModal;
end;

procedure TForm1.entfernen1Click(Sender: TObject);
var
  jpgName, bmpName, pfad: string;
begin
  { The picture of the person is removed; the file is kept with a new
    name, so that it is not lost. }
  PageControl1.ActivePage := TabSheet2;
  jpgName := UpperCase(SysUtils.ExtractFileName(gvar_02536B30));
  bmpName := UpperCase(SysUtils.ExtractFileName(gvar_02536B34));
  aus1.Click;
  pfad := SysUtils.ExtractFilePath(ParamStr(0)) + 'bilder\';

  if FileExists(pfad + jpgName) then
  begin
    Image1.Picture.SaveToFile(pfad + '_' + Copy(jpgName, 2, Length(jpgName) - 1));
    SysUtils.DeleteFile(pfad + jpgName);
  end;

  if FileExists(pfad + bmpName) then
  begin
    Image1.Picture.SaveToFile(pfad + '_' + Copy(bmpName, 2, Length(bmpName) - 1));
    SysUtils.DeleteFile(pfad + bmpName);
  end;

  anzeigen;
end;

procedure TForm1.Listenaktualisieren1Click(Sender: TObject);
var
  nummer: Longint;
begin
  { The lists are rebuilt; the person that was shown is shown again
    afterwards. }
  PageControl1.ActivePage := TabSheet2;
  nummer := DataModule2.Table1Nummer.AsInteger;
  aus1.Click;
  try
    Screen.Cursor := crHourGlass;
    Label19.Show;
    listen_akt;
    Label19.Visible := False;
  finally
    Screen.Cursor := crDefault;
  end;
  DataModule2.Table1.Last;
  DataModule2.Table1.First;
  DataModule2.Table1.FindKey([nummer]);
  anzeigen;
end;

procedure TForm1.einfgen1Click(Sender: TObject);
var
  nummer: Integer;
  datei, name, pfad: string;
  i: Integer;
  verhaeltnis: Double;
begin
  { A picture is inserted for the person.  It is stored under the name of
    the number of the person and a letter.

    The original counts the letters from the character 61 on; the pictures
    that are already in the database use the letters 'a' to 'z' (see
    anzeigen). }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  nummer := DataModule2.Table1Nummer.AsInteger;
  OpenPictureDialog1.FilterIndex := 2;
  pfad := SysUtils.ExtractFilePath(ParamStr(0)) + 'bilder\';
  ChDir(pfad);
  if OpenPictureDialog1.Execute then
  begin
    datei := OpenPictureDialog1.FileName;
    name := UpperCase(SysUtils.ExtractFileName(datei));

    if UpperCase(SysUtils.ExtractFileExt(datei)) = '.JPG' then
    begin
      Image1.Picture.LoadFromFile(datei);
      i := 0;
      repeat
        if not FileExists(pfad + 'b' + IntToStr(nummer) + Chr(i + 61) + '.jpg') then
        begin
          Image1.Picture.SaveToFile(pfad + 'b' + IntToStr(nummer) +
                                   Chr(i + 61) + '.jpg');
          Break;
        end;
        Inc(i);
      until i = 26;
    end
    else if UpperCase(SysUtils.ExtractFileExt(datei)) = '.BMP' then
    begin
      Image1.Picture.LoadFromFile(datei);
      i := 0;
      repeat
        if not FileExists(pfad + 'b' + IntToStr(nummer) + Chr(i + 61) + '.bmp') then
        begin
          Image1.Picture.SaveToFile(pfad + 'b' + IntToStr(nummer) +
                                   Chr(i + 61) + '.bmp');
          Break;
        end;
        Inc(i);
      until i = 26;
    end;
    SysUtils.DeleteFile(pfad + name);
  end;
  UpDown1.Visible := True;
  ChDir(SysUtils.ExtractFilePath(ParamStr(0)));

  { The picture is scaled to the height of the image control. }
  if Image1.Picture.Graphic is TJPEGImage then
  begin
    verhaeltnis := Image1.Height * 1.0 / Image1.Picture.Graphic.Height;
    Image1.Width := Round(Image1.Picture.Graphic.Width * verhaeltnis);
  end;
  if Image1.Picture.Graphic is TBitmap then
  begin
    verhaeltnis := Image1.Height * 1.0 / Image1.Picture.Graphic.Height;
    Image1.Width := Round(Image1.Picture.Graphic.Width * verhaeltnis);
  end;
end;

procedure TForm1.UpDown1Click(Sender: TObject; AButton: TUDBtnType);
var
  z: AnsiChar;
  faktor: Extended;
  jpgneu, bmpneu, jpgalt, bmpalt: AnsiString;
begin
  //005FAC9C: Bild der Person mit UpDown durchblaettern. AButton
  //entscheidet die Richtung (0 = vor, 1 = zurueck).
  z := Chr(gvar_02536B2C);
  if Ord(AButton) = 0 then
    if FileExists(gvar_02536B9C + 'bilder\b' +
       Trim(IntToStr(DataModule2.Table1Nummer.AsInteger)) +
       Chr(Ord(z) + 1) + '.jpg') then
      gvar_02536B2C := gvar_02536B2C + 1;
  if Ord(AButton) = 1 then
    if gvar_02536B2C > Ord('a') then
      gvar_02536B2C := gvar_02536B2C - 1;

  jpgneu := gvar_02536B9C + 'bilder\b' +
    Trim(IntToStr(DataModule2.Table1Nummer.AsInteger)) +
    Chr(gvar_02536B2C) + '.jpg';
  bmpneu := gvar_02536B9C + 'bilder\b' +
    Trim(IntToStr(DataModule2.Table1Nummer.AsInteger)) +
    Chr(gvar_02536B2C) + '.bmp';
  jpgalt := gvar_02536B9C + 'bilder\b' +
    Trim(IntToStr(DataModule2.Table1Nummer.AsInteger)) + z + '.jpg';
  bmpalt := gvar_02536B9C + 'bilder\b' +
    Trim(IntToStr(DataModule2.Table1Nummer.AsInteger)) + z + '.bmp';

  if FileExists(jpgneu) then
  begin
    Image1.Picture.LoadFromFile(jpgneu);
    gvar_02536B30 := jpgneu;
    if Image1.Picture.Graphic is TJPEGImage then
    begin
      faktor := Image1.Picture.Graphic.Height / Image1.Height;
      Image1.Width := Round(Image1.Picture.Graphic.Width * faktor);
    end;
  end
  else
  begin
    if FileExists(jpgalt) then
    begin
      Image1.Picture.LoadFromFile(jpgalt);
      gvar_02536B30 := jpgalt;
    end
    else
    begin
      gvar_02536B34 := bmpalt;
    end;
  end;
  ActiveControl := ComboBox4;
end;

procedure TForm1.FamblHTML;
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.allePersonen1Click(Sender: TObject);
begin
  { All persons are shown; the place of the person is determined. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  gvar_0253692C := 'NLAP';
  frbestimmtenOrt1.Click;
end;

procedure TForm1.Probandenname1Click(Sender: TObject);
var
  olname: AnsiString;
  zeile: AnsiString;
  liste: TStringList;
  i: Integer;
begin
  //005F26E0: Ortsliste fuer den markierten Namen (oder fuer alle
  //Personen, wenn OLAP): die in Frage kommenden Orte werden in einer
  //sortierten Liste gesammelt, dann wie eine Liste in Table14
  //geschrieben und ueber Form15/QuickRep in der Vorschau angezeigt.
  olname := ComboBox4.Text;
  PageControl1.ActivePage := TabSheet2;
  i := DataModule2.Table1Nummer.AsInteger;
  aus1.Click;
  speich1;
  if gvar_0253692C <> 'OLAP' then
    gvar_0253692C := 'OLPN';
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  DataModule2.Table1.FindKey([i]);
  gvar_02536930 := 'Ortsliste f' + #252 + 'r Name: ' + olname;
  if gvar_0253692C = 'OLAP' then
    gvar_02536930 := 'Ortsliste (alle Personen)';
  Form5.Caption := gvar_02536930;
  zeile := '';
  liste := TStringList.Create;
  liste.Sorted := True;
  liste.Duplicates := dupIgnore;
  try
    DataModule2.Table8.Open;
    DataModule2.Table8.IndexName := 'namgeb';
    DataModule2.Table8.First;
    DataModule2.Table10.Open;
    DataModule2.Table10.IndexName := 'num';
    if gvar_0253692C = 'OLAP' then
    begin
      Screen.Cursor := crHourGlass;
      try
        DataModule2.Table13.IndexName := 'ort_';
        DataModule2.Table13.First;
        while not DataModule2.Table13.EOF do
        begin
          liste.Add(DataModule2.Table13Ort.AsString);
          DataModule2.Table13.Next;
        end;
      finally
        Screen.Cursor := crDefault;
      end;
    end
    else if gvar_0253692C = 'OLPN' then
    begin
      Screen.Cursor := crHourGlass;
      try
        DataModule2.Table8.IndexName := 'namgeb';
        DataModule2.Table8.FindKey([olname]);
        while True do
        begin
          if DataModule2.Table8.EOF then
            Break;
          liste.Add(DataModule2.Table8Gebort.AsString);
          liste.Add(DataModule2.Table8Taufort.AsString);
          liste.Add(DataModule2.Table8Stort.AsString);
          liste.Add(DataModule2.Table8Begort.AsString);
          DataModule2.Table10.First;
          while True do
          begin
            if DataModule2.Table10.EOF then
              Break;
            if DataModule2.Table10Nummer.AsInteger =
               DataModule2.Table8Nummer.AsInteger then
            begin
              liste.Add(DataModule2.Table10Hort.AsString);
              liste.Add(DataModule2.Table10Saort.AsString);
              liste.Add(DataModule2.Table10Schort.AsString);
            end;
            DataModule2.Table10.Next;
          end;
          DataModule2.Table8.Next;
          if DataModule2.Table8.EOF then
            Break;
          if DataModule2.Table8Name.AsString <> olname then
            Break;
        end;
      finally
        Screen.Cursor := crDefault;
      end;
    end;
    Screen.Cursor := crHourGlass;
    if liste.Count > 0 then
    begin
      if Trim(liste.Strings[0]) = '' then
        liste.Delete(0);
    end;
    DataModule2.Table14.Open;
    DataModule2.Table14.Close;
    DataModule2.Table14.EmptyTable;
    DataModule2.Table14.Open;
    for i := 0 to liste.Count - 1 do
    begin
      DataModule2.Table14.Append;
      DataModule2.Table14Zeile.AsString := liste.Strings[i];
      DataModule2.Table14.Post;
    end;
    Form15.QuickRep1.Page.Columns := 2;
    druck(gvar_02536930, zeile);
    DataModule2.Table14.Open;
  finally
    liste.Free;
    Screen.Cursor := crDefault;
    { Form15.QuickRep1.Preview - die Vorschau ist im
      Kompatibilitaetsschicht nicht implementiert. }
  end;
end;

procedure TForm1.StringGrid2RowMoved(Sender: TObject; FromIndex, ToIndex: Longint);
var
  anzahl, i: Integer;
  n: Integer;
begin
  { The order of the children was changed: the new order is written into
    the index fields of the table. }
  DataModule2.Table17.Open;
  DataModule2.Table17.First;
  DataModule2.Table17.IndexName := '';
  anzahl := StringGrid2.RowCount - 1;
  if anzahl >= 0 then
  begin
    Inc(anzahl);
    i := 0;
    repeat
      n := StrToInt(StringGrid2.Cells[1, i]);
      if DataModule2.Table17.FindKey([n]) then
      begin
        DataModule2.Table17.Edit;
        DataModule2.Table17Indj.AsString :=
          RightStr('0000' + IntToStr(i), 4);
        DataModule2.Table17Indm.AsString := '';
        DataModule2.Table17.Post;
      end;
      Inc(i);
      Dec(anzahl);
    until anzahl = 0;
  end;
  DataModule2.Table17.Refresh;
  DataModule2.Table1.Refresh;
  kinderanz;
end;

procedure TForm1.frbestimmtenOrt1Click(Sender: TObject);
var
  s, s2, titel: string;
  liste: TStringList;
  gefunden, ok: Boolean;
  i, anzahl: Integer;
begin
  { The names of the persons of a place are collected in a list; the list
    is written into the table of the report and printed.  In the mode
    "NLAP" the list contains all the persons. }
  if gvar_0253692C <> 'NLAP' then
    gvar_0253692C := 'NLBO';
  speich1;
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  if DataModule2.Table1.RecordCount - 1 <= 0 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  s := '';
  s2 := '';
  gefunden := (Pos(DataModule2.Table8Gebort.AsString, s) > 0) or
             (Pos(DataModule2.Table8Taufort.AsString, s) > 0) or
             (Pos(DataModule2.Table8Stort.AsString, s) > 0) or
             (Pos(DataModule2.Table8Begort.AsString, s) > 0) or
             (Pos(DataModule2.Table8Lebensort.AsString, s) > 0);
  titel := 'Namensliste f' + #252 + 'r den Ort';
  if gvar_0253692C = 'NLAP' then
  begin
    s := '';
    titel := 'Namensliste (alle Personen)';
    Form5.Caption := titel;
    ok := True;
  end
  else
    ok := InputQuery(titel, '', s);
  if not ok then
    Exit;
  s2 := s;
  Refresh;
  if PageControl1.PageCount <> 2 then
    PageControl1.ActivePage := TabSheet2;
  gvar_02536930 := titel + ' ' + s;

  liste := TStringList.Create;
  try
    liste.Sorted := True;
    liste.Duplicates := dupIgnore;
    DataModule2.Table8.Open;
    DataModule2.Table8.IndexName := 'namgeb';
    DataModule2.Table8.First;
    DataModule2.Table10.Open;
    DataModule2.Table10.IndexName := 'num';
    DataModule2.Table10.First;
    Screen.Cursor := crHourGlass;

    while not DataModule2.Table8.Eof do
    begin
      if gvar_0253692C <> 'NLAP' then
      begin
        { the person is wanted when one of the places is the place that
          was given; the place of the life is only searched in the text. }
        if (DataModule2.Table8Gebort.AsString = s2) or
           (DataModule2.Table8Taufort.AsString = s2) or
           (DataModule2.Table8Stort.AsString = s2) or
           (DataModule2.Table8Begort.AsString = s2) or
           (Pos(DataModule2.Table8Lebensort.AsString, s) > 0) then
          liste.Add(DataModule2.Table8Name.AsString);
      end
      else
      begin
        if Trim(DataModule2.Table8Name.AsString) <> '' then
          liste.Add(DataModule2.Table8Name.AsString);
      end;

      { The marriages of the person are looked through as well. }
      DataModule2.Table10.First;
      if gvar_0253692C <> 'NLAP' then
        if DataModule2.Table10.FindKey([DataModule2.Table8Nummer.AsInteger]) then
          while (not DataModule2.Table10.Eof) and
                (DataModule2.Table10Nummer.AsInteger = DataModule2.Table8Nummer.AsInteger) do
          begin
            if (DataModule2.Table10Hort.AsString = s2) or
               (DataModule2.Table10Saort.AsString = s2) or
               (DataModule2.Table10Schort.AsString = s2) then
              liste.Add(DataModule2.Table8Name.AsString);
            DataModule2.Table10.Next;
          end;
      DataModule2.Table8.Next;
    end;

    if liste.Count > 0 then
    begin
      { An empty first entry is removed. }
      if Trim(liste.Strings[0]) = '' then
        liste.Delete(0);

      DataModule2.Table14.Open;
      DataModule2.Table14.Close;
      DataModule2.Table14.EmptyTable;
      DataModule2.Table14.Open;
      anzahl := liste.Count;
      i := 0;
      while anzahl > 0 do
      begin
        DataModule2.Table14.Append;
        DataModule2.Table14Zeile.AsString := liste.Strings[i];
        DataModule2.Table14.Post;
        Inc(i);
        Dec(anzahl);
      end;

      Form15.QuickRep1.Page.Columns := 3;
      if Form16.Button5.Caption = 'A 4' then
        Form15.QuickRep1.Page.Columns := 4;
      druck(gvar_02536930, '');
      Screen.Cursor := crDefault;
      { The original shows the preview of the report; the compatibility
        layer of QuickReport has no preview. }
    end
    else
    begin
      ShowMessage('Keine Namen f' + #252 + 'r "' + s + '" gefunden.');
    end;
    Screen.Cursor := crDefault;
  finally
    liste.Free;
  end;
end;

procedure TForm1.Browser1Click;
begin
  Browser('c:\programme\xml\heri1\karteik.xml');

end;

procedure TForm1.FormResize(Sender:TObject);
begin
  { The form is scaled with the height it had before. }

  ScaleControls(Height, gvar_02536BA4);

  gvar_02536BA4 := Height;

  gridanp;

end;

procedure TForm1.allePersonen2Click(Sender: TObject);
begin
  { All persons are shown; the name of the person is determined. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  gvar_0253692C := 'OLAP';
  Probandenname1.Click;
end;

procedure TForm1.Browser(AUrl: AnsiString);
var
  s: WideString;
begin
  { The address is shown in the browser. }
  s := AUrl;
  Form10.WebBrowser1.Navigate(s);
  Form10.Show;
end;

procedure TForm1.OFBDruck1Click(Sender: TObject);
begin
  { The print of the "OFB" (the family chart) is prepared. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  speich1;
  gvar_0253692C := 'OFB';
  gvar_0061F0BC := 0;
  gvar_0061F0C0 := 0;
  Form24.ShowModal;
  if gvar_02536B50 = 'butt8' then
    Form3.ofb2;
end;

procedure TForm1.alleBilderentfernen1Click(Sender: TObject);
begin
  { All pictures of the person are removed. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  gvar_0253692C := 'BiLoe';
  bild_entf;
  gvar_0253692C := '';
end;

procedure TForm1.sdx(const AnInput: AnsiString; var AResult: AnsiString);
  //005D34D8: Soundex. Der erste Buchstabe bleibt stehen, dann kommen
  //die Ziffern der Buchstabenklassen zu einem vierstelligen Code.

  function sdx_klasse(c: AnsiString): AnsiString;
  begin
    // c ist 1 Zeichen (mit ae/oe/ue schon ersetzt)
    if Pos(c, 'BPFV') > 0 then Result := '1'
    else if Pos(c, 'CGJKQSXZ') > 0 then Result := '2'
    else if Pos(c, 'DT') > 0 then Result := '3'
    else if c = 'L' then Result := '4'
    else if Pos(c, 'MN') > 0 then Result := '5'
    else if c = 'R' then Result := '6'
    else Result := '7';
  end;

var
  c: AnsiString;
  kl: AnsiString;
  o1: AnsiString;
  o2: AnsiString;
  i: Integer;
begin
  if AnInput = '' then
  begin
    AResult := '';
    Exit;
  end;
  c := UpperCase(Copy(AnInput, 1, 1));
  kl := ' ';
  if c = #228 then c := 'A';
  if c = #246 then c := 'O';
  if c = #252 then c := 'U';
  kl := sdx_klasse(c);
  AResult := c;
  o1 := '7';
  o2 := c;
  for i := 2 to Length(AnInput) do
  begin
    c := UpperCase(Copy(AnInput, i, 1));
    if c = o2 then Continue;
    kl := sdx_klasse(c);
    if kl <> o1 then
      AResult := AResult + kl;
    o1 := kl;
    o2 := c;
  end;
  while Length(AResult) < 4 do
    AResult := AResult + '0';
  AResult := Copy(AResult, 1, 4);
end;

procedure TForm1.FOKODateieditieren1Click(Sender: TObject);
begin
  { The FOKO file is edited. }
  DataModule2.Table20.Open;
  PageControl1.ActivePage := TabSheet2;
  if DataModule2.Table20.RecordCount > 1 then
    Form21.ShowModal
  else
    ShowMessage('Nichts zum Editieren gefunden.');
end;

procedure TForm1.GedcomDateieinlesen1Click(Sender: TObject);
var
  nummer: Integer;
begin
  { 005FCDA0: Eine GEDCOM-Datei einlesen. Zuerst wird die aktuelle
    Person gemerkt und das "Aus"-Menu geklickt, dann laedt Form3
    (gedein_5) die Daten. Nach dem Einlesen wird ggf. die Liste
    aktualisiert, die erste Person angezeigt und die beiden
    Tabellen zur Bearbeitung geoffnet. }
  nummer := DataModule2.Table1Nummer.AsInteger;
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  gvar_0253686C := 2;
  Form3.gedein_5;
  DataModule2.Table1.FindKey([nummer]);
  if gvar_0253686C <> 2 then
    listen_akt;
  DataModule2.Table1.First;
  anzeigen;
  DataModule2.Table1.Edit;
  DataModule2.Table5.Edit;
end;

procedure TForm1.GedcomDateischreiben1Click(Sender: TObject);
var
  fehler: Integer;
  nummer: Integer;
begin
  { 005FD330: GEDCOM-Datei schreiben. Vorher wird geprueft, ob in einem
    Namen oder in einem Vornamen ein "/" oder ein "," enthalten ist;
    dann wird die Ausgabe abgebrochen. }
  PageControl1.ActivePage := TabSheet2;
  Label19.Visible := True;
  Label19.Caption := 'Testen';
  nummer := DataModule2.Table1Nummer.AsInteger;
  DataModule2.Table1.DisableControls;
  DataModule2.Table1.First;
  fehler := 0;
  while not DataModule2.Table1.Eof do
  begin
    if Pos('/', DataModule2.Table1Name.AsString) > 0 then
      Inc(fehler);
    if Pos('/', DataModule2.Table1Vornamen.AsString) > 0 then
      Inc(fehler);
    if Pos(',', DataModule2.Table1Name.AsString) > 0 then
      Inc(fehler);
    if Pos(',', DataModule2.Table1Vornamen.AsString) > 0 then
      Inc(fehler);
    if fehler > 0 then
      Break;
    DataModule2.Table1.Next;
  end;
  DataModule2.Table1.FindKey([nummer]);
  DataModule2.Table1.EnableControls;
  Label19.Visible := False;
  if fehler > 0 then
  begin
    ShowMessage('Datei enth' + #228 + 'lt in Name oder Vorname ' +
      'die Zeichen "," oder "/".');
    Exit;
  end;
  Form26.ModalResult := 0;
  aus1.Click;
  DataModule2.Table1.FindKey([nummer]);
  anzeigen;
  speich1;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  Form26.ShowModal;
  anzeigen;
  Form26.ModalResult := 2;
end;

type
  TSHFOStruct = record
    hwnd: HWND;
    wFunc: UINT;
    pFrom: PAnsiChar;
    pTo: PAnsiChar;
    fFlags: Word;
    fProgress: BOOL;
    hNameMappings: Pointer;
    lpszProgressTitle: PAnsiChar;
  end;

function SHFileOperation(var lp: TSHFOStruct): Integer; stdcall;
  external 'shell32.dll' name 'SHFileOperationA';

{ Original-Hilfsfunktion an der Adresse 005FCB74: Eine Dateiadresse und ein
  bestehender Praefix werden in den zugehoerigen JPEG-Namen umgewandelt. }
function sub_005FCB74(a, b: AnsiString): AnsiString;
var
  name_: AnsiString;
  i: Integer;
begin
  name_ := ExtractFileName(a);
  for i := 1 to 3 do
    Delete(name_, 1, 1);
  Result := b + name_ + 'jpg';
end;

procedure TForm1.bild_entf;
var
  apfad, t, name_, s: AnsiString;
  i, cnt: Integer;
  fname: TSHFOStruct;
begin
  //005FC794: Alle Bilddateien des Ordners Bilder in einen neu anzulegenden
  //Unterordner verschieben.
  FileListBox1.Clear;
  apfad := ExtractFilePath(ParamStr(0));
  t := apfad + 'bilder\';
  FileListBox1.ApplyFilePath(t);
  FileListBox1.Update;
  if FileListBox1.Items.Count < 3 then
  begin
    if gvar_0253692C = 'BiLoe' then
      ShowMessage('Keine Bilder vorhanden.');
    Exit;
  end;
  name_ := InputBox('', 'Ordner-Name', 'Neuer Ordner f' + #252 + 'r bisherige Bilder');
  while DirectoryExists(apfad + name_ + '\') do
  begin
    ShowMessage('Ordner ' + name_ + ' existiert bereits.' + #10 +
      'Bitte neuen Namen angeben.');
    name_ := InputBox('', 'Ordner-Name', 'Neuer Ordner f' + #252 + 'r bisherige Bilder');
  end;
  if Trim(name_) = '' then
    Exit;
  t := apfad + name_ + '\';
  cnt := FileListBox1.Items.Count;
  if cnt - 1 <= 0 then
  begin
    ChDir(apfad);
    anzeigen;
    Exit;
  end;
  MkDir(PChar(t));
  s := '';
  for i := 0 to cnt - 1 do
  begin
    if Pos('[.', FileListBox1.Items[i]) = 0 then
      s := s + FileListBox1.Items[i] + #0;
  end;
  s := s + #0;
  with fname do
  begin
    hwnd := Handle;
    wFunc := 1;
    pFrom := PChar(s);
    pTo := PChar(t);
  end;
  SHFileOperation(fname);
  ChDir(apfad);
  anzeigen;
end;

procedure TForm1.bmpjpg1Click(Sender: TObject);
var
  voldir, fdatei, fName: AnsiString;
  img: TImage;
  jpg: TJPEGImage;
begin
  //005FCC0C: Eine gewaehlte BMP-Datei nach JPEG konvertieren und im
  //Bilder-Ordner ablegen.
  PageControl1.ActivePage := TabSheet2;
  voldir := GetCurrentDir;
  ChDir(voldir + '\Bilder');
  OpenPictureDialog1.FilterIndex := 1;
  fdatei := '';
  if OpenPictureDialog1.Execute then
    fdatei := UpperCase(OpenPictureDialog1.FileName);
  if ExtractFileExt(fdatei) = '.BMP' then
  begin
    img := TImage.Create(Self);
    img.Picture.LoadFromFile(fdatei);
    jpg := TJPEGImage.Create;
    jpg.CompressionQuality := 50;
    jpg.Assign(img.Picture.Graphic);
    fName := sub_005FCB74(fdatei, voldir);
    ChDir(voldir + '\Bilder');
    jpg.SaveToFile(fName);
    jpg.Free;
    img.Free;
  end;
  ChDir(voldir);
end;

procedure TForm1.inyTafelerstellen1Click(Sender: TObject);
begin
  { The "Tiny-Tafel" (the small family chart) is created. }
  PageControl1.ActivePage := TabSheet2;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  speich1;
  gvar_02536930 := 'Tiny-Tafel';
  gvar_02536934 := '';
  gvar_0253692C := 'Tiny';
  Form22.Show;
  DataModule2.Table9.IndexName := '';
end;

procedure TForm1.Familienblatt2Click(Sender: TObject);
var
  ftitel: AnsiString;
begin
  //005FB580: zwei Zeichen-Konstanten einstellen und dann Famblatt
  //aufrufen; Titel und detaillierte Zeichen werden gelaoscht.
  gvar_0253692C := 'famb';
  gvar_02536B58 := '';
  gvar_02536B38 := '';
  gvar_02536B3C := '';
  gvar_02536B40 := '';
  gvar_02536B44 := '';
  gvar_02536B48 := '';
  gvar_02536B4C := '';
  aus1.Click;
  Famblatt;
end;

procedure TForm1.Famblatt;
var
  fname: AnsiString;
begin
  //005FB604: Familienblatt erzeugen. Die Auswahl in Form17 anzeigen,
  //dann das Layout auf Form15 aufbauen und die Bilder (Vater, Mutter,
  //Kind) aus pictures\b<nummer>.jpg laden.
  speich1;
  DataModule2.Table38.Open;
  DataModule2.Table38.IndexName := 'tit';
  DataModule2.Table38.First;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  PageControl1.ActivePage := TabSheet2;
  gvar_02536930 := 'Familienblatt';
  gvar_02536934 := '';
  Form17.ShowModal;
  if Form17.ModalResult = 2 then
    Exit;
  Form15.QRBand1.Height := 55;
  Form15.QRBand3.Height := 20;
  Form15.QRBand4.Height := 24;
  Form15.QRShape1.AutoSize := True;
  Form15.QRShape2.AutoSize := True;
  Form15.QRDBText1.AutoSize := False;
  Form15.QRDBText2.AutoSize := False;
  Form15.QRLabel1.Caption := gvar_02536930;
  Form15.QRLabel1.Visible := True;
  Form15.QRLabel2.AutoSize := True;
  Form15.QRLabel2.Visible := True;
  Form15.QRLabel3.Visible := True;
  if Trim(gvar_02536934) <> '' then
    Form15.QRLabel2.Caption := gvar_02536934;
  Form15.QRLabel3.Caption := 'Familienblatt';
  Form15.QuickRep1.Page.Columns := 1;
  Form16.Label5.Visible := True;      // 35C
  Form16.Button9.Visible := True;     // 358
  Form16.Button5.Visible := True;     // 360
  Form16.SpeedButton3.Visible := True; // 34C
  Form16.SpeedButton6.Visible := False; // 350
  { Form15.QuickRep1.OnPreview := showpreview } // 2AC/2A8
  Form15.QRShape1.Width := Form15.QRBand1.Width - 10;
  Form15.QRShape2.Width := Form15.QRBand1.Width - 10;
  Form15.QRShape3.Width := Form15.QRBand1.Width - 10;
  Form15.QRSysData2.Left := Form15.QRShape3.Width - Form15.QRSysData2.Width;
  Form15.QRDBText1.Width := Form15.QRBand3.Width - Form15.QRDBText1.Left;
  Form15.QRMemo1.Width := Memo1.Width;
  Form15.QRImage1.Picture := nil;
  Form15.QRImage2.Picture := nil;
  Form15.QRImage3.Picture := nil;
  if not Form17.CheckBox16.Visible then
    Exit;

  // Vater
  fname := gvar_02536B9C + 'bilder\b' + Trim(IntToStr(DataModule2.Table1Nummer.AsInteger)) +
    AnsiChar(gvar_02536B2C) + '.jpg';
  if FileExists(fname) then
  begin
    Form15.QRImage1.Picture.LoadFromFile(fname);
    Form15.QRImage1.Left := 673 - Form15.QRImage1.Width;
  end;

  // Mutter
  fname := gvar_02536B9C + 'bilder\b' + Trim(StringGrid1.Cells[1, 0]) +
    AnsiChar(gvar_02536B2C) + '.jpg';
  if FileExists(fname) then
  begin
    Form15.QRImage2.Picture.LoadFromFile(fname);
    Form15.QRImage2.Top := Form15.QRImage1.Height * 9;
    Form15.QRImage2.Left := 673 - Form15.QRImage2.Width;
  end;

  // Kind
  fname := gvar_02536B9C + 'bilder\b' + Trim(StringGrid1.Cells[1, 1]) +
    AnsiChar(gvar_02536B2C) + '.jpg';
  if FileExists(fname) then
  begin
    Form15.QRImage3.Picture.LoadFromFile(fname);
    Form15.QRImage3.Top := Form15.QRImage2.Height * 2 * 9;
    Form15.QRImage3.Left := 673 - Form15.QRImage3.Width;
  end;
  { Form15.QuickRep1.Preview - die Vorschau ist im
    Kompatibilitaetsschicht nicht implementiert. }
end;

procedure TForm1.Grafik1Click(Sender: TObject);
begin
  { The chart of the ancestors (the second one) is shown. }
  speich1;
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  if (DataModule2.Table1Vater.AsInteger = 0) and
     (DataModule2.Table1Mutter.AsInteger = 0) then
  begin
    ShowMessage('Keine Vorfahren gefunden.');
    Exit;
  end;
  gvar_0253692C := 'Vorgr2';
  gvar_0061F0FC := Form13;
  Form12.Caption := 'Vorfahren-Grafik II';
  Form12.ShowModal;
  anzeigen;
end;

procedure TForm1.Grafikneu1Click(Sender: TObject);
var
  personNummer: Integer;
begin
  { The chart of the descendants (the second one) is shown. }
  speich1;
  personNummer := DataModule2.Table1Nummer.AsInteger;
  PageControl1.ActivePage := TabSheet2;
  Form13.Button1.Visible := False;
  aus1.Click;
  if DataModule2.Table1.RecordCount < 2 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  if Trim(StringGrid2.Cells[1, 0]) = '' then
  begin
    ShowMessage('Keine Nachfahren gefunden.');
    Exit;
  end;
  gvar_0253692C := 'Nachgr2';
  Form12.Caption := 'Nachfahren-Grafik II';
  Form12.ShowModal;
  DataModule2.Table1.FindKey([personNummer]);
  anzeigen;
end;

procedure TForm1.Liste1Click(Sender: TObject);
begin
  { The list of the descendants ("Nachkommen") is shown. }
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  gvar_0253692C := 'Nach';
  gvar_0061F0BC := 0;
  gvar_0061F0C0 := 0;
  Listen;
end;

procedure TForm1.FOKODateierstellen1Click(Sender: TObject);
begin
  { The file of the FOKO is written again. }
  speich1;
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  DataModule2.Table20.Open;
  if MessageDlg('Bestehende FOKO-Datei wird ' + #252 + 'berschrieben. Dennoch weiter ?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DataModule2.Table19.Open;
    Form20.BitBtn1Click(Sender);
  end;
end;

procedure TForm1.showpreview(Page: Integer);
begin
  //005FBD5C: Vorschau: aktive Seite in Form16 melden und Form16 anzeigen.
  gvar_0061F0B8 := Page;
  Form16.QRPreview1PageAvailable(Form16, Page);
  Form16.QRPreview1.PageNumber := Page;
  Form16.Show;
end;

procedure TForm1.GlobaleSuche1Click(Sender: TObject);
var
  f: TForm18;
begin
  //005FBD98: Start der globalen Suche: Register "Suche" aktivieren,
  //Auswahl aufheben, Daten speichern und das Suchformular modal zeigen.
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  speich1;
  Form16.SpeedButton6.Visible := False;
  if DataModule2.Table1.RecordCount <= 1 then
  begin
    ShowMessage('Keine Daten verf' + #252 + 'gbar.');
    Exit;
  end;
  gvar_0253692C := 'Over';
    f := TForm18.Create(Self);
    Form18 := f;
    Form18.ShowModal;
  Form18.Release;
  Form16.SpeedButton6.Visible := False;
  gvar_0253692C := '';
end;

procedure TForm1.StringGrid1RowMoved(Sender: TObject; FromIndex, ToIndex: Longint);
var
  anzahl, i: Integer;
  n: Integer;
begin
  { The order of the marriages was changed: the new order is written into
    the index fields of the table. }
  anzahl := StringGrid1.RowCount - 1;
  if anzahl >= 0 then
  begin
    Inc(anzahl);
    i := 0;
    while True do
    begin
      DataModule2.Table5.First;
      while not DataModule2.Table5.Eof do
      begin
        n := StrToInt(StringGrid1.Cells[1, i]);
        if n = DataModule2.Table5Epnum.AsInteger then
        begin
          DataModule2.Table5.Edit;
          DataModule2.Table5Indj.AsString :=
            RightStr('0000' + IntToStr(i), 4);
          DataModule2.Table5Indm.AsString := '';
          DataModule2.Table5.Post;
        end;
        DataModule2.Table5.Next;
      end;
      Inc(i);
      Dec(anzahl);
      if anzahl = 0 then
        Break;
    end;
  end;
  DataModule2.Table5.Refresh;
  ehenanz;
  kinderanz;
end;

procedure TForm1.PopupMenu3Popup(Sender: TObject);
begin
  { The entries of the menu are only enabled when a person is selected and
    when its name is known. }
  PopupMenu3.Items[0].Enabled := False;
  PopupMenu3.Items[1].Enabled := False;
  if DataModule2.Table1Nummer.AsInteger > 0 then
  begin
    PopupMenu3.Items[0].Enabled := True;
    PopupMenu3.Items[1].Enabled := False;
    if Trim(Edit1.Text) <> '' then
    begin
      PopupMenu3.Items[0].Enabled := False;
      PopupMenu3.Items[1].Enabled := True;
    end;
  end;
end;

procedure TForm1.PopupMenu4Popup(Sender: TObject);
begin
  { The entries of the menu are only enabled when a person is selected and
    when the number of the mother is known. }
  PopupMenu4.Items[0].Enabled := False;
  PopupMenu4.Items[1].Enabled := False;
  if DataModule2.Table1Nummer.AsInteger > 0 then
  begin
    PopupMenu4.Items[0].Enabled := True;
    PopupMenu4.Items[1].Enabled := False;
    if Trim(Edit2.Text) <> '' then
    begin
      PopupMenu4.Items[0].Enabled := False;
      PopupMenu4.Items[1].Enabled := True;
    end;
  end;
end;

procedure TForm1.elem(art: AnsiString);
var
  sichtbar: Boolean;
begin
  { The fields of the marriage are shown ('ein') or hidden ('aus'). }
  sichtbar := False;
  if art = 'ein' then
    sichtbar := True;
  if art = 'aus' then
  begin
    sichtbar := False;
    if gvar_02536914 = 1 then
      gvar_02536914 := 0;
  end;

  Edit4.Visible := sichtbar;
  Edit5.Visible := sichtbar;
  Edit6.Visible := sichtbar;
  ComboBox1.Visible := sichtbar;
  Edit8.Visible := sichtbar;
  Edit9.Visible := sichtbar;
  Edit10.Visible := sichtbar;
  ComboBox2.Visible := sichtbar;
  Edit30.Visible := sichtbar;
  Edit31.Visible := sichtbar;
  Edit15.Visible := sichtbar;
  Edit14.Visible := sichtbar;
  Edit13.Visible := sichtbar;
  ComboBox3.Visible := sichtbar;
  Label35.Visible := sichtbar;
  Label44.Visible := sichtbar;
  Label45.Visible := sichtbar;
  Label46.Visible := sichtbar;
  Label47.Visible := sichtbar;
  Label48.Visible := sichtbar;
  Label49.Visible := sichtbar;
  Panel1.Visible := sichtbar;
  ComboBox5.Visible := sichtbar;
  Label64.Visible := sichtbar;
end;

procedure TForm1.elem_leer;
begin
  { All the fields of the marriage are cleared. }
  Edit4.Text := '';
  Edit5.Text := '';
  Edit6.Text := '';
  Edit30.Text := '';
  Edit8.Text := '';
  Edit9.Text := '';
  Edit10.Text := '';
  Edit31.Text := '';
  Edit15.Text := '';
  Edit14.Text := '';
  Edit13.Text := '';
  ComboBox5.Text := '';
  ComboBox1.Text := '';
  ComboBox2.Text := '';
  ComboBox3.Text := '';
end;

procedure TForm1.Vatereinfgen1Click(Sender: TObject);
begin
  { A new father is created for the person. }
  if DataModule2.Table1.State in [dsEdit, dsInsert] then
  begin
    if DataModule2.Table1Nummer.AsInteger > 0 then
      DataModule2.Table1.Post
    else
      DataModule2.Table1.Delete;
  end;

  DataModule2.Table12.Open;
  gvar_02536914 := 0;
  gvar_02536918 := 1;
  gvar_02536910 := DataModule2.Table1Nummer.AsInteger;

  Form4.Caption := 'Vater einf' + #252 + 'gen';
  Form4.ShowModal;

  { The father is a new person. }
  if Form4.RadioButton1.Checked then
  begin
    elem('aus');
    Label35.Caption := 'Vater von ' + DataModule2.Table1Name.AsString +
                       ' ' + DataModule2.Table1Vornamen.AsString;
    Label35.Visible := True;
    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.Append;
    DBCheckBox1.Checked := False;
    DataModule2.Table1Lebt.AsString := 'n';
    DataModule2.Table1Geschlecht.AsString := 'm';
    PageControl1.ActivePage := TabSheet3;
    ComboBox10.SetFocus;
    ComboBox10.Text := '';
    ComboBox16.Text := '';
    ComboBox17.Text := '';
    ComboBox18.Text := '';
    ComboBox19.Text := '';
  end;

  { The father is a person that is already known. }
  if Form4.RadioButton2.Checked then
  begin
    elem('aus');
    DataModule2.Table9.Open;
    DataModule2.Table9.IndexName := '';
    if DataModule2.Table9.FindKey([gvar_02536910]) then
      Label27.Caption := 'Vater von ' + DataModule2.Table1Name.AsString +
                         ' ' + DataModule2.Table1Vornamen.AsString;
    TabSheet7.Show;
    Form3.Edit1.Text := '';
    Form3.ShowModal;
  end;

  anzeigen;
end;

procedure TForm1.Muttereinfgen1Click(Sender: TObject);
begin
  { A new mother is created for the person. }
  if DataModule2.Table1.State in [dsEdit, dsInsert] then
  begin
    if DataModule2.Table1Nummer.AsInteger > 0 then
      DataModule2.Table1.Post
    else
      DataModule2.Table1.Delete;
  end;

  DataModule2.Table12.Open;
  gvar_02536914 := 0;
  gvar_02536918 := 1;
  gvar_02536910 := DataModule2.Table1Nummer.AsInteger;

  Form4.Caption := 'Mutter einf' + #252 + 'gen';
  Form4.ShowModal;

  { The mother is a new person. }
  if Form4.RadioButton1.Checked then
  begin
    elem('aus');
    Label35.Caption := 'Mutter von ' + DataModule2.Table1Name.AsString +
                       ' ' + DataModule2.Table1Vornamen.AsString;
    Label35.Visible := True;
    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.Append;
    DBCheckBox1.Checked := False;
    DataModule2.Table1Lebt.AsString := 'n';
    DataModule2.Table1Geschlecht.AsString := 'w';
    PageControl1.ActivePage := TabSheet3;
    ComboBox10.SetFocus;
    ComboBox10.Text := '';
    ComboBox16.Text := '';
    ComboBox17.Text := '';
    ComboBox18.Text := '';
    ComboBox19.Text := '';
  end;

  { The mother is a person that is already known. }
  if Form4.RadioButton2.Checked then
  begin
    elem('aus');
    DataModule2.Table9.Open;
    DataModule2.Table9.IndexName := '';
    if DataModule2.Table9.FindKey([gvar_02536910]) then
      Label27.Caption := 'Mutter von ' + DataModule2.Table1Name.AsString +
                         ' ' + DataModule2.Table1Vornamen.AsString;
    TabSheet7.Show;
    Form3.Edit1.Text := '';
    Form3.ShowModal;
  end;

  anzeigen;
end;

procedure TForm1.Vaterentfernen1Click(Sender: TObject);
begin
  { The father of the person is not known any more. }
  if MessageDlg(Copy(Edit1.Text, 7, 32) + ' als Vater entfernen ?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Vater.AsInteger := 0;
    DataModule2.Table1.Post;
  end;
  anzeigen;
end;

procedure TForm1.Mutterentfernen1Click(Sender: TObject);
begin
  { The mother of the person is not known any more. }
  if MessageDlg(Copy(Edit2.Text, 7, 32) + ' als Mutter entfernen ?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DataModule2.Table1.Edit;
    DataModule2.Table1Mutter.AsInteger := 0;
    DataModule2.Table1.Post;
  end;
  anzeigen;
end;

procedure TForm1.DBEdit2Exit(Sender: TObject);
begin
  { The number of a new person is taken from the table of the deleted
    persons, or the next free number is used. }
  if (Edit3.Text > ' ') or (DBEdit2.Text > ' ') then
    schen1.Enabled := True;

  if DataModule2.Table1Nummer.AsInteger - 1 < 0 then
    if Trim(DBEdit2.Text) <> '' then
    begin
      DataModule2.Table4.First;
      if DataModule2.Table4.RecordCount > 0 then
      begin
        if DataModule2.Table4Num.AsInteger > 0 then
        begin
          DataModule2.Table1Nummer.AsInteger := DataModule2.Table4Num.AsInteger;
          DataModule2.Table4.Delete;
          if DataModule2.Table1Nummer.AsInteger > gvar_02536944 then
            gvar_02536944 := DataModule2.Table1Nummer.AsInteger;
        end;
      end
      else
      begin
        DataModule2.Table1Nummer.AsInteger := gvar_02536944 + 1;
        Inc(gvar_02536944);
      end;
    end;

  if Trim(DBEdit2.Text) <> '' then
    neu1.Enabled := True;

  if DataModule2.Table4.FindKey([DataModule2.Table1Nummer.AsInteger]) then
    DataModule2.Table4.Delete;
end;


procedure TForm1.aus1Click(Sender: TObject);
var
  i: Integer;
begin
  { The list of the persons is cleared: the filter is removed, the menu

    entries of the printing are freed and the person is looked up again. }

  DataModule2.Table1Nummer.AsInteger;

  PageControl1.ActivePage := TabSheet2;

  ID1.Checked := False;

  Name1.Checked := False;

  Hausname1.Checked := False;

  StringGrid5.Visible := False;

  DataModule2.Table1.Filter := '';

  DataModule2.Table7.Filter := '';

  DataModule2.Table9.Filter := '';

  DataModule2.Table17.Filter := '';

  DataModule2.Table1.Filtered := False;

  DataModule2.Table7.Filtered := False;

  DataModule2.Table9.Filtered := False;

  DataModule2.Table17.Filtered := False;

  DBText1.Color := $C0C0C0;

  for i := 0 to MainMenu1.Items[10].Count - 3 do

    if Pos('drucken', MainMenu1.Items[10].Items[i].Caption) > 0 then

      MainMenu1.Items[10].Items[i].Free;

  DataModule2.Table1.FindKey([DataModule2.Table1Nummer.AsInteger]);

end;

procedure TForm1.Datenschutzein1Click(Sender: TObject);
var
  jahr: string;
begin
  { Only the persons that were born up to the given year are shown. }

  aus1.Click;

  PageControl1.ActivePage := TabSheet2;

  jahr := InputBox('Datenschutz', 'Geburtsjahr maximal', '');
  if jahr = '' then

    Exit;

  DBText1.Color := $00FFFF;

  DataModule2.Table1.Filter := 'gebjahr<=' + jahr +

                               ' and taufjahr<=' + jahr;

  DataModule2.Table1.Filtered := True;

  DataModule2.Table7.Filter := 'gebjahr<=' + jahr +

                               ' and taufjahr<=' + jahr;

  DataModule2.Table7.Filtered := True;

end;

procedure TForm1.roem(anummer:integer;var aergebnis:ansistring);
begin
  { The number of the marriage as a Roman numeral. The original has a
    table with the numerals from 0 to 60; the number 49 is written "IL"
    there - a mistake of the original that is kept here. }
  case ANummer of
    0: AErgebnis := ' ';
    1: AErgebnis := 'I';
    2: AErgebnis := 'II';
    3: AErgebnis := 'III';
    4: AErgebnis := 'IV';
    5: AErgebnis := 'V';
    6: AErgebnis := 'VI';
    7: AErgebnis := 'VII';
    8: AErgebnis := 'VIII';
    9: AErgebnis := 'IX';
    10: AErgebnis := 'X';
    11: AErgebnis := 'XI';
    12: AErgebnis := 'XII';
    13: AErgebnis := 'XIII';
    14: AErgebnis := 'XIV';
    15: AErgebnis := 'XV';
    16: AErgebnis := 'XVI';
    17: AErgebnis := 'XVII';
    18: AErgebnis := 'XVIII';
    19: AErgebnis := 'XIX';
    20: AErgebnis := 'XX';
    21: AErgebnis := 'XXI';
    22: AErgebnis := 'XXII';
    23: AErgebnis := 'XXIII';
    24: AErgebnis := 'XXIV';
    25: AErgebnis := 'XXV';
    26: AErgebnis := 'XXVI';
    27: AErgebnis := 'XXVII';
    28: AErgebnis := 'XXVIII';
    29: AErgebnis := 'XXIX';
    30: AErgebnis := 'XXX';
    31: AErgebnis := 'XXXI';
    32: AErgebnis := 'XXXII';
    33: AErgebnis := 'XXXIII';
    34: AErgebnis := 'XXXIV';
    35: AErgebnis := 'XXXV';
    36: AErgebnis := 'XXXVI';
    37: AErgebnis := 'XXXVII';
    38: AErgebnis := 'XXXVIII';
    39: AErgebnis := 'XXXIX';
    40: AErgebnis := 'XL';
    41: AErgebnis := 'XLI';
    42: AErgebnis := 'XLII';
    43: AErgebnis := 'XLIII';
    44: AErgebnis := 'XLIV';
    45: AErgebnis := 'XLV';
    46: AErgebnis := 'XLVI';
    47: AErgebnis := 'XLVII';
    48: AErgebnis := 'XLVIII';
    49: AErgebnis := 'IL';
    50: AErgebnis := 'L';
    51: AErgebnis := 'LI';
    52: AErgebnis := 'LII';
    53: AErgebnis := 'LIII';
    54: AErgebnis := 'LIV';
    55: AErgebnis := 'LV';
    56: AErgebnis := 'LVI';
    57: AErgebnis := 'LVII';
    58: AErgebnis := 'LVIII';
    59: AErgebnis := 'LIX';
    60: AErgebnis := 'LX';
  end;
end;

procedure TForm1.ID1Click(Sender: TObject);
var
  s: string;
  nummer: Integer;
  gefunden: Boolean;
begin
  { The persons with the given ID are filtered. }
  PageControl1.ActivePage := TabSheet2;
  s := InputBox('Filter', 'ID-Nr.', '');
  if Trim(s) <> '' then
  begin
    gefunden := False;
    nummer := DataModule2.Table1Nummer.AsInteger;
    tabdisab;
    DataModule2.Table1.First;
    repeat
      if Trim(DataModule2.Table1IDNR.AsString) = Trim(s) then
      begin
        gefunden := True;
        Break;
      end;
      DataModule2.Table1.Next;
    until DataModule2.Table1.Eof;
    tabenab;
    DataModule2.Table1.FindKey([nummer]);
    if gefunden then
    begin
      aus1.Click;
      ID1.Checked := True;
      DataModule2.Table1.Filter := 'idnr=' + QuotedStr(s);
      DataModule2.Table1.Filtered := True;
      DataModule2.Table9.Filter := 'idnr=' + QuotedStr(s);
      DataModule2.Table9.Filtered := True;
      DBText1.Color := clRed;
      anzeigen;
    end
    else
    begin
      ShowMessage('Filterkriterium ID="' + s + '" nicht gefunden.');
      DataModule2.Table1.FindKey([nummer]);
    end;
  end;
end;

procedure TForm1.DBEdit33Exit(Sender: TObject);
begin
  { A person that has no number yet gets the number that is written in
    the field. If that number is already taken, the next free number is
    used. }
  if DataModule2.Table1Nummer.AsInteger - 1 < 0 then
    if Trim(DBEdit33.Text) <> '' then
    begin
      DataModule2.Table4.First;
      if DataModule2.Table4.RecordCount > 0 then
        if DataModule2.Table4Num.AsInteger > 0 then
        begin
          DataModule2.Table1Nummer.AsInteger := DataModule2.Table4Num.AsInteger;
          DataModule2.Table4.Delete;
          if DataModule2.Table1Nummer.AsInteger > gvar_02536944 then
            gvar_02536944 := DataModule2.Table1Nummer.AsInteger;
        end
        else
        begin
          DataModule2.Table1Nummer.AsInteger := gvar_02536944 + 1;
          Inc(gvar_02536944);
        end;
    end;
  DataModule2.Table1.FindKey([DataModule2.Table1Nummer.AsInteger]);
end;

procedure TForm1.TabSheet3Enter(Sender: TObject);

begin
  { The fields of the marriage are filled with the data of the person. }
  if Sender = TabSheet3 then
    ComboBox10.Text := ComboBox4.Text;

  ComboBox11.Text := DataModule2.Table1Quelle.AsString;
  ComboBox12.Text := DataModule2.Table1Quelleg.AsString;
  ComboBox13.Text := DataModule2.Table1Quellet.AsString;
  ComboBox14.Text := DataModule2.Table1Quelles.AsString;
  ComboBox15.Text := DataModule2.Table1Quelleb.AsString;
  ComboBox10.Text := DataModule2.Table1Name.AsString;
  ComboBox16.Text := DataModule2.Table1Gebort.AsString;
  ComboBox17.Text := DataModule2.Table1Taufort.AsString;
  ComboBox18.Text := DataModule2.Table1Stort.AsString;
  ComboBox19.Text := DataModule2.Table1Begort.AsString;

  { The fields of the marriage are only shown when there is more than one
    person in the database. }
  if (DataModule2.Table1.RecordCount > 1) and
     (DataModule2.Table1Nummer.AsInteger > 0) then
    elem('aus');
end;

procedure TForm1.Datenschutzaus1Click(Sender: TObject);
begin
  { The data protection is removed: the filter is removed and the note in

    the title of the form is deleted. }

  PageControl1.ActivePage := TabSheet2;

  DBText1.Color := $C0C0C0;

  DataModule2.Table1.Filter := '';

  DataModule2.Table5.Filter := '';

  DataModule2.Table7.Filter := '';

  DataModule2.Table8.Filter := '';

  DataModule2.Table9.Filter := '';

  DataModule2.Table17.Filter := '';

  DataModule2.Table1.Filtered := False;

  DataModule2.Table5.Filtered := False;

  DataModule2.Table7.Filtered := False;

  DataModule2.Table8.Filtered := False;

  DataModule2.Table9.Filtered := False;

  DataModule2.Table17.Filtered := False;

  gvar_02536BA0 := 0;

  if Pos('Datenschutz', Form1.Caption) > 0 then

    Form1.Caption := Copy(Form1.Caption, 1,

                         Pos('(Datenschutz', Form1.Caption) - 1);

  DataModule2.Table1.FindKey([DataModule2.Table1Nummer.AsInteger]);

  anzeigen;

end;

procedure TForm1.TabSheet3Exit(Sender: TObject);
var
  personNr: Integer;
begin
  { A person without a name is not saved at all. }
  if Trim(DataModule2.Table1Name.AsString) = '' then
    if Trim(DataModule2.Table1Vornamen.AsString) = '' then
    begin
      DataModule2.Table1.Delete;
      gvar_02536914 := 0;
      gvar_02536918 := 0;
      speich1;
      Exit;
    end;

  if gvar_02536914 = 1 then
  begin
    { The places that are used are put into the list of the places, if they
      are not in it yet. }
    if Trim(ComboBox1.Text) <> '' then
      if not DataModule2.Table13.FindKey([Copy(ComboBox1.Text, 1, 10)]) then
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := ComboBox1.Text;
        DataModule2.Table13.Post;
      end;

    if Trim(ComboBox2.Text) <> '' then
      if not DataModule2.Table13.FindKey([Copy(ComboBox2.Text, 1, 10)]) then
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := ComboBox2.Text;
        DataModule2.Table13.Post;
      end;

    if Trim(ComboBox3.Text) <> '' then
      if not DataModule2.Table13.FindKey([Copy(ComboBox3.Text, 1, 10)]) then
      begin
        DataModule2.Table13.Append;
        DataModule2.Table13Ort.AsString := ComboBox3.Text;
        DataModule2.Table13.Post;
      end;

    { A marriage without a number is not valid and is removed. }
    if DataModule2.Table5.RecordCount > 0 then
      if (DataModule2.Table5Nummer.AsInteger = 0) or
         (DataModule2.Table5Epnum.AsInteger = 0) then
        DataModule2.Table5.Delete;

    { The marriage is written twice: once for the person and once for the
      partner of the person. }
    if (gvar_02536910 > 0) and (DataModule2.Table1Nummer.AsInteger > 0) then
    begin
      DataModule2.Table5.Append;
      DataModule2.Table5Nummer.AsInteger := gvar_02536910;
      DataModule2.Table5Epnum.AsInteger := DataModule2.Table1Nummer.AsInteger;
      DataModule2.Table5Verbind.AsString := ComboBox5.Text;
      DataModule2.Table5Htag.AsString := Edit4.Text;
      DataModule2.Table5Hmonat.AsString := Edit5.Text;
      DataModule2.Table5Hjahr.AsString := Edit6.Text;
      DataModule2.Table5Hort.AsString := ComboBox1.Text;
      DataModule2.Table5Trauz.AsString := Edit30.Text;
      DataModule2.Table5Satag.AsString := Edit8.Text;
      DataModule2.Table5Samonat.AsString := Edit9.Text;
      DataModule2.Table5Sajahr.AsString := Edit10.Text;
      DataModule2.Table5Saort.AsString := ComboBox2.Text;
      DataModule2.Table5Satrauz.AsString := Edit31.Text;
      DataModule2.Table5Schtag.AsString := Edit15.Text;
      DataModule2.Table5Schmonat.AsString := Edit14.Text;
      DataModule2.Table5Schjahr.AsString := Edit13.Text;
      DataModule2.Table5Schort.AsString := ComboBox3.Text;
      DataModule2.Table5Hqu.AsString := ComboBox23.Text;
      DataModule2.Table5Saqu.AsString := ComboBox24.Text;
      DataModule2.Table5Schqu.AsString := ComboBox25.Text;
      DataModule2.Table5.Post;

      DataModule2.Table5.Append;
      DataModule2.Table5Nummer.AsInteger := DataModule2.Table1Nummer.AsInteger;
      DataModule2.Table5Epnum.AsInteger := gvar_02536910;
      DataModule2.Table5Verbind.AsString := ComboBox5.Text;
      DataModule2.Table5Htag.AsString := Edit4.Text;
      DataModule2.Table5Hmonat.AsString := Edit5.Text;
      DataModule2.Table5Hjahr.AsString := Edit6.Text;
      DataModule2.Table5Hort.AsString := ComboBox1.Text;
      DataModule2.Table5Trauz.AsString := Edit30.Text;
      DataModule2.Table5Satag.AsString := Edit8.Text;
      DataModule2.Table5Samonat.AsString := Edit9.Text;
      DataModule2.Table5Sajahr.AsString := Edit10.Text;
      DataModule2.Table5Saort.AsString := ComboBox2.Text;
      DataModule2.Table5Satrauz.AsString := Edit31.Text;
      DataModule2.Table5Schtag.AsString := Edit15.Text;
      DataModule2.Table5Schmonat.AsString := Edit14.Text;
      DataModule2.Table5Schjahr.AsString := Edit13.Text;
      DataModule2.Table5Schort.AsString := ComboBox3.Text;
      DataModule2.Table5Hqu.AsString := ComboBox23.Text;
      DataModule2.Table5Saqu.AsString := ComboBox24.Text;
      DataModule2.Table5Schqu.AsString := ComboBox25.Text;
      DataModule2.Table5.Post;
    end;

    { The date for the index is taken from the year of the birth, if there
      is one, otherwise from the year of the baptism. }
    if Trim(DataModule2.Table1Gebjahr.AsString) <> '' then
    begin
      try
        DataModule2.Table1.Edit;
        DataModule2.Table1Indj.AsString := DataModule2.Table1Gebjahr.AsString;
        DataModule2.Table1Indm.AsString := DataModule2.Table1Gebmonat.AsString;
        DataModule2.Table1Indt.AsString := DataModule2.Table1Gebtag.AsString;
        DataModule2.Table1.Post;
      except
      end;
    end
    else
    begin
      try
        DataModule2.Table1.Edit;
        DataModule2.Table1Indj.AsString := DataModule2.Table1Taufjahr.AsString;
        DataModule2.Table1Indm.AsString := DataModule2.Table1Taufmonat.AsString;
        DataModule2.Table1Indt.AsString := DataModule2.Table1Tauftag.AsString;
        DataModule2.Table1.Post;
      except
      end;
    end;
  end;

  gvar_02536914 := 0;

  { The father or the mother of the person is taken over. }
  if gvar_02536918 = 1 then
  begin
    personNr := DBText2.Field.AsInteger;
    if DataModule2.Table1.State in [dsEdit, dsInsert] then
      DataModule2.Table1.Post;
    DataModule2.Table1.IndexName := '';
    DataModule2.Table1.FindKey([gvar_02536910]);
    DataModule2.Table1.Edit;
    if Copy(Label35.Caption, 1, 3) = 'Vat' then
      DataModule2.Table1Vater.AsInteger := personNr;
    if Copy(Label35.Caption, 1, 3) = 'Mut' then
      DataModule2.Table1Mutter.AsInteger := personNr;
    DataModule2.Table1.Post;
    if DataModule2.Table1.State in [dsEdit, dsInsert] then
      DataModule2.Table1.Post;
    DataModule2.Table1.Refresh;
    DataModule2.Table3.Refresh;
    DataModule2.Table9.Refresh;
    gvar_02536918 := 0;
  end;

  { The person that was worked on is looked for again. }
  if DataModule2.Table1.State in [dsEdit, dsInsert] then
    DataModule2.Table1.Post;
  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.FindKey([gvar_02536910]);
  gvar_02536910 := 0;
  anzeigen;
end;

procedure TForm1.anzeigen1Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet2;

  StringGrid5.Show;

end;

procedure TForm1.GregorianischerKalender1Click(Sender: TObject);
var
  f: TForm6;
begin
  //005EF700: Dialog "Gregorianischer Kalender" zeigen.
  PageControl1.ActivePage := TabSheet2;
  speich1;
  f := TForm6.Create(Self);
  Form6 := f;
  try
    Form6.ShowModal;
  finally
    Form6.Release;
  end;
end;

procedure TForm1.StringGrid5KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  StringGrid5.Visible := False;

end;

procedure TForm1.StringGrid5DblClick(Sender: TObject);
var
  s: string;
  n: Integer;
begin
  { The person that is marked in the list is shown. }
  s := StringGrid5.Cells[0, StringGrid5.Row];
  if Trim(s) <> '' then
  begin
    n := StrToInt(StringGrid5.Cells[0, StringGrid5.Row]);
    DataModule2.Table1.FindKey([n]);
    anzeigen;
  end;
end;


procedure TForm1.Hausname1Click(Sender: TObject);
var
  s: string;
  nummer: Integer;
  gefunden: Boolean;
begin
  { The persons with the name of the estate are filtered. }
  PageControl1.ActivePage := TabSheet2;
  s := InputBox('Filter', 'Hofname ', '');
  if Trim(s) <> '' then
  begin
    gefunden := False;
    nummer := DataModule2.Table1Nummer.AsInteger;
    tabdisab;
    DataModule2.Table1.First;
    repeat
      if Trim(DataModule2.Table1Hausname.AsString) = Trim(s) then
      begin
        gefunden := True;
        Break;
      end;
      DataModule2.Table1.Next;
    until DataModule2.Table1.Eof;
    tabenab;
    DataModule2.Table1.FindKey([nummer]);
    if gefunden then
    begin
      aus1.Click;
      Hausname1.Checked := True;
      DataModule2.Table1.Filter := 'hausname=' + QuotedStr(s);
      DataModule2.Table1.Filtered := True;
      DataModule2.Table9.Filter := 'hausname=' + QuotedStr(s);
      DataModule2.Table9.Filtered := True;
      DBText1.Color := clRed;
      anzeigen;
    end
    else
    begin
      ShowMessage('Filterkriterium Hofname = "' + s + '" nicht gefunden.');
      DataModule2.Table1.FindKey([nummer]);
    end;
  end;
end;

procedure TForm1.drucken2Click;
begin
  { The method of the original has an empty body. }

end;

procedure TForm1.FrzRevolutionskalender1Click(Sender: TObject);
var
  f: TForm7;
begin
  //005EF778: Dialog "Franzoesischer Revolutionskalender" zeigen.
  PageControl1.ActivePage := TabSheet2;
  speich1;
  f := TForm7.Create(Self);
  Form7 := f;
  try
    Form7.ShowModal;
  finally
    Form7.Release;
  end;
end;

procedure TForm1.zuAHNENWIN1Click(Sender: TObject);
begin
  { The output of the program (the form with the text) is shown. }
  PageControl1.ActivePage := TabSheet2;
  speich1;
  if PageControl1.PageCount <> 2 then
    PageControl1.ActivePage := TabSheet2;
  Form9.Label8.Caption := '(Ausgabe vom ' + DateToStr(gvar_02536924) + ')';
  Form9.Label10.Visible := True;
  Form9.Label10.Caption := IntToStr(DataModule2.Table1.RecordCount) + ' Datens' + #228 + 'tze';
  Form9.Show;
end;

procedure TForm1.Partnersuche1Click(Sender: TObject);
var
  szelle1: AnsiString;
  szelle2: AnsiString;
  cat1: AnsiString;
  cat2: AnsiString;
  cur: Integer;
  row: Integer;
  txt: AnsiString;
begin
  //005EED2C: Partner-Suche. Es wird die Heirats-Tabelle Table15
  // queried; jede getroffene Person landet in StringGrid5.
  PageControl1.ActivePage := TabSheet2;
  aus1.Click;
  cur := DataModule2.Table1Nummer.AsInteger;
  for row := 0 to StringGrid5.RowCount - 2 do
  begin
    StringGrid5.Cells[0, row] := '';
    StringGrid5.Cells[1, row] := '';
    StringGrid5.Cells[2, row] := '';
    StringGrid5.Cells[3, row] := '';
    StringGrid5.Cells[4, row] := '';
  end;
  if not InputQuery('Partner suchen', 'Heiratsname der Frau', szelle1) then
    Exit;
  if not InputQuery('Partner suchen', 'Vorname der Frau', szelle2) then
    Exit;
  DataModule2.Table9.Open;
  DataModule2.Table9.IndexName := '';
  DataModule2.Table9.First;
  DataModule2.Table15.Open;
  DataModule2.Table15.MasterSource := DataModule2.DataSource9;  // 0A0
  DataModule2.Table15.MasterFields := 'nummer';
  DataModule2.Table15.IndexName := 'num';
  DataModule2.Table15.First;
  DataModule2.Table17.Open;
  DataModule2.Table17.IndexName := '';
  DataModule2.Table17.First;
  Refresh;
  cat1 := '"' + szelle2 + ' ' + szelle1 + '"';
  StringGrid5.Cells[1, 0] := cat1;
  StringGrid5.RowCount := 2;
  DataModule2.Table9.First;
  row := 2;
  while not DataModule2.Table9.EOF do
  begin
    if Pos(UpperCase(szelle1), UpperCase(DataModule2.Table9Name.AsString)) <= 0 then
    begin
      DataModule2.Table9.Next;
      Continue;
    end;
    if DataModule2.Table9Geschlecht.AsString <> 'M' then
    begin
      DataModule2.Table9.Next;
      Continue;
    end;
    if DataModule2.Table15.RecordCount > 0 then
    begin
      DataModule2.Table15.First;
      while not DataModule2.Table15.EOF do
      begin
        DataModule2.Table17.FindKey([DataModule2.Table15Epnum.AsInteger]);
        if Pos(UpperCase(szelle2), UpperCase(DataModule2.Table17Vornamen.AsString)) > 0 then
        begin
          StringGrid5.RowCount := row + 1;
          StringGrid5.Cells[0, row] := IntToStr(DataModule2.Table17Nummer.AsInteger);
          StringGrid5.Cells[1, row] := DataModule2.Table17Name.AsString + ' ' +
              DataModule2.Table17Vornamen.AsString;
          if Trim(DataModule2.Table17Gebjahr.AsString) <> '' then
            StringGrid5.Cells[2, row] := '* ' + DataModule2.Table17Gebjahr.AsString
          else if Trim(DataModule2.Table17Taufjahr.AsString) <> '' then
            StringGrid5.Cells[2, row] := '~ ' + DataModule2.Table17Taufjahr.AsString;
          if Trim(DataModule2.Table15Sajahr.AsString) <> '' then
            StringGrid5.Cells[3, row] := 'ooS ' + DataModule2.Table15Sajahr.AsString
          else if Pos('Ehes', DataModule2.Table15Verbind.AsString) > 0 then
            StringGrid5.Cells[3, row] := 'ooK ' + DataModule2.Table15Hjahr.AsString
          else
            StringGrid5.Cells[3, row] := 'o-o ' + DataModule2.Table15Hjahr.AsString;
          txt := StringGrid5.Cells[2, row];
          Inc(row);
        end;
        DataModule2.Table15.Next;
      end;
    end;
    DataModule2.Table9.Next;
  end;
  if (Trim(szelle1) <> '') and (Trim(szelle2) <> '') then
  begin
    StringGrid5.Show;
    { 5. Menuitem 'Partner-Suche' zeigen - im Kompatibilitaetsschicht
      kein zugreifbarer Eintrag. }
  end;
  if Trim(StringGrid5.Cells[2, 1]) = '' then
    StringGrid5.Cells[2, 1] := 'nichts gefunden';
  DataModule2.Table15.MasterSource := nil;  DataModule2.Table1.IndexName := '';
  DataModule2.Table1.First;
  DataModule2.Table1.FindKey([cur]);
  anzeigen;
end;

procedure TForm1.DBEdit45Exit(Sender: TObject);
begin
  { The year of the marriage at the registry office was left: the weekday is shown again and the date is checked. }
  wt38;
  datcheck(DBEdit39.Text, DBEdit41.Text, DBEdit45.Text);
end;


procedure TForm1.DBEdit63Exit(Sender: TObject);
begin
  { The year of the separation was left: the weekday is shown again and the date is checked. }
  wt39;
  datcheck(DBEdit61.Text, DBEdit62.Text, DBEdit63.Text);
end;


procedure TForm1.TabSheet2Enter(Sender: TObject);
begin
  { The person is shown again when the page is entered - but not while a
    new person is being entered. }
  if gvar_0253692C <> 'dsneu' then
    anzeigen;
end;

procedure TForm1.DBEdit37Exit(Sender: TObject);
begin
  { The year of the marriage was left: the weekday is shown again and the date is checked. }
  wt37;
  datcheck(DBEdit35.Text, DBEdit36.Text, DBEdit37.Text);
end;


procedure TForm1.Bildschirmdrucken1Click(Sender: TObject);
begin
  //005EC6C4: Druckereinrichtung und dann den Bildschirminhalt
  //ausdrucken; dafuer werden die Druckerfelder nach vorn geholt.
  PageControl1.ActivePage := TabSheet2;
  speich1;
  if not PrinterSetupDialog1.Execute then
    Exit;
  Edit3.BringToFront;
  Edit7.BringToFront;
  Edit11.BringToFront;
  Edit12.BringToFront;
  Edit16.BringToFront;
  Print;
  Edit3.SendToBack;
  Edit7.SendToBack;
  Edit11.SendToBack;
  Edit12.SendToBack;
  Edit16.SendToBack;
  TabSheet2.Invalidate;
end;

procedure TForm1.ExcelExport1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm1.Name1Click(Sender: TObject);
var
  s: string;
  nummer: Integer;
  gefunden: Boolean;
begin
  { The persons with the given name are filtered. }
  PageControl1.ActivePage := TabSheet2;
  s := InputBox('Filter', 'Name ', '');
  if Trim(s) <> '' then
  begin
    gefunden := False;
    nummer := DataModule2.Table1Nummer.AsInteger;
    tabdisab;
    DataModule2.Table1.First;
    repeat
      if Trim(DataModule2.Table1Name.AsString) = Trim(s) then
      begin
        gefunden := True;
        Break;
      end;
      DataModule2.Table1.Next;
    until DataModule2.Table1.Eof;
    tabenab;
    DataModule2.Table1.FindKey([nummer]);
    if gefunden then
    begin
      aus1.Click;
      Name1.Checked := True;
      DataModule2.Table1.Filter := 'name=' + QuotedStr(s);
      DataModule2.Table1.Filtered := True;
      DataModule2.Table9.Filter := 'name=' + QuotedStr(s);
      DataModule2.Table9.Filtered := True;
      DBText1.Color := clRed;
      anzeigen;
    end
    else
    begin
      ShowMessage('Filterkriterium Name = "' + s + '" nicht gefunden.');
      DataModule2.Table1.FindKey([nummer]);
    end;
  end;
end;

procedure TForm1.Druckereinstellung1Click(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet2;

  speich1;

  PrintDialog1.Execute;

end;


end.




