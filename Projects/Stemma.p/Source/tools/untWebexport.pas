unit untWebexport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls;

procedure ExportToWebsite(const lOnProgress: TNotifyEvent;
  const password, user, db, server, site: string;Const SPanel:TStatusPanel ; const time_delay: integer);

implementation

uses FMUtils,cls_Translation,StrUtils, dm_GenData;

procedure ExportToWebsite(const lOnProgress: TNotifyEvent; const password, user,
  db, server, site: string; const SPanel: TStatusPanel; const time_delay: integer);
var
  temp: string;
  last: string;
  First: string;
  filename: string;
  drive: string;
  buttonsfile: textfile;
  indexfile: textfile;
  file2: textfile;
  file1: textfile;
  nb_file: integer;
  max_request: integer;
begin
  drive := drive + DirectorySeparator;
  dmGenData.Query1.SQL.Text := 'SELECT no FROM I WHERE NOT V=''O'' ';
  dmGenData.Query1.Open;
  dmGenData.Query1.tag := -dmGenData.Query1.RecordCount;
  if assigned(lOnProgress) then
    lOnProgress(dmGenData.Query1);
  max_request := 10000;
  filename := drive + 'sitemap.xml';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file1, '<?xml version="1.0" encoding="UTF-8"?>');
  writeln(file1, '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');
  while not dmGenData.Query1.EOF do
  begin
    // créer fichiers sitemap
    temp := '<url><loc>'+site+'/testphp/info.php?no=' +
      dmGenData.Query1.Fields[0].AsString +
      '</loc><changefreq>monthly</changefreq></url>';
    writeln(file1, temp);
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      writeln(file1, '</urlset>');
      closefile(file1);

      filename := drive + 'sitemap' + IntToStr(
        trunc(dmGenData.Query1.tag / max_request)) + '.xml';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file1, '<?xml version="1.0" encoding="UTF-8"?>');
      writeln(file1, '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');
    end;
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  writeln(file1, '</urlset>');
  closefile(file1);

  SPanel.Text := Translation.Items[324];
  // fr: Exporter projet, créer fichiers index
  // en: Export project, create index files
  dmGenData.Query1.SQL.Text :=
    'SELECT N.I, N.N FROM N JOIN I ON N.I=I.no WHERE NOT I.V=''O'' ORDER BY N.I1, N.I2, N.I3, N.I4';
  dmGenData.Query1.Open;

  dmGenData.Query1.tag := -dmGenData.Query1.RecordCount;
      if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);

  dmGenData.Query1.tag := 1;
      if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);

  filename := drive + 'boutons.html';
  assignfile(buttonsfile, FileName);
  rewrite(buttonsfile);
  writeln(buttonsfile, '<HTML>');
  writeln(buttonsfile, '<HEAD>');
  writeln(buttonsfile,
    '<META HTTP-EQUIV="Content-Type" CONTENT="Text/html; charset=windows-1252">');
  writeln(buttonsfile, '<TITLE>Choix d''Index</TITLE>');
  writeln(buttonsfile, '<BASE TARGET="texte">');
  writeln(buttonsfile,
    '<!--mstheme--><link rel="stylesheet" type="text/css" href="../_themes/genealogy/gene1011.css">'
    +
    '<meta name="Microsoft Theme" content="genealogy 1011">');
  writeln(buttonsfile, '</HEAD>');
  writeln(buttonsfile, '<BODY>');
  writeln(buttonsfile, '<HR>');
  writeln(buttonsfile, '<DL>');
  nb_file := 1;
  filename := format('%sindex_%d.php', [drive, nb_file]);
  assignfile(indexfile, FileName);
  rewrite(indexfile);
  writeln(indexfile, '<HTML>');
  writeln(indexfile, '<HEAD>');
  writeln(indexfile,
    '<META HTTP-EQUIV="Content-Type" CONTENT="Text/html; charset=windows-1252">');
  writeln(indexfile, Utf8ToAnsi('<TITLE>Index de la base de données</TITLE>'));
  writeln(indexfile, '<BASE TARGET="texte">');
  writeln(indexfile,
    '<!--mstheme--><link rel="stylesheet" type="text/css" href="../_themes/genealogy/gene1011.css"><meta name="Microsoft Theme" content="genealogy 1011">');
  writeln(indexfile, '</HEAD>');
  writeln(indexfile, '<BODY>');
  writeln(indexfile, Utf8ToAnsi(
    '<DD><A HREF=testphp/recherche.php>Recherche avancée</A></DD>'));
  writeln(indexfile, '<?php');
  writeln(indexfile, 'if (isset($_POST["recherche"]))  {');
  writeln(indexfile, '   $oldrecherche = $_POST["recherche"];');
  writeln(indexfile, '} else {');
  writeln(indexfile, '   $oldrecherche = '''';');
  writeln(indexfile, '}?>');
  writeln(indexfile,
    '  <form method="post" target=index action="<?php echo $_SERVER[''PHP_SELF'']?>">');
  writeln(indexfile,
    '  <input type="Text" name="recherche" value="<?php echo $oldrecherche?>"><br>');
  writeln(indexfile,
    '  <input type="Submit" target=index name="submit" value="Recherche nom">');
  writeln(indexfile, '  </form>');
  writeln(indexfile, '<?php');
  writeln(indexfile, 'if (isset($_POST["recherche"]))  {');
  writeln(indexfile, '  // process form');
  writeln(indexfile, '   require("testphp/fonctions.php");');
  writeln(indexfile, '   $serveur = GetMySqlServerAddress();');
  writeln(indexfile, '   $db = mysql_connect($serveur, "' + user +
    '", "' + password + '");');
  writeln(indexfile, '   mysql_select_db("genealo_data",$db);');
  writeln(indexfile,
    '   $result = mysql_query("SELECT I, N FROM N WHERE MATCH (N) AGAINST (''$oldrecherche'' IN BOOLEAN MODE) ORDER BY MATCH (N) AGAINST (''$oldrecherche'' IN BOOLEAN MODE) DESC, I1",$db);');
  writeln(indexfile, '   while ($myrow = mysql_fetch_row($result)) {');
  writeln(indexfile,
    '      $result2 = mysql_query("SELECT V FROM I WHERE no=$myrow[0]",$db);');
  writeln(indexfile, '      while ($myrow2 = mysql_fetch_row($result2)) {');
  writeln(indexfile, '          $html = $myrow2[0];');
  writeln(indexfile, '      }');
  writeln(indexfile, '      if ($html!=''O'') {');
  writeln(indexfile, '         if (substr($myrow[1],0,5)==''!dmGenData.TMG|'') {');
  writeln(indexfile,
    '            $myrow[1]= substr($myrow[1],strpos($myrow[1],''|'')+1,strlen($myrow[1]));');
  writeln(indexfile,
    '            $nom     = substr($myrow[1],0,strpos($myrow[1],''|''));');
  Write(indexfile,
    '            $suffixe  = substr($myrow[1],(strpos($myrow[1],''|'',strpos($myrow[1],''|'',');
  writeln(indexfile,
    'strpos($myrow[1],''|'')+1)+1)+1),(strpos($myrow[1],''|'',strpos($myrow[1],''|'',strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1)+1)+1)-(strpos($myrow[1],''|'',strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1)+1)+1)));');
  writeln(indexfile,
    '            $prenom = substr($myrow[1],(strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1)+1),(strpos($myrow[1],''|'',strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1)+1)-(strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1)+1)));');
  writeln(indexfile,
    '            $titre      = substr($myrow[1],strpos($myrow[1],''|'')+1,(strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1))-strpos($myrow[1],''|'')-1);');
  writeln(indexfile, '         } else {');
  writeln(indexfile, '            $titre='''';');
  writeln(indexfile, '            $prenom='''';');
  writeln(indexfile, '            $nom='''';');
  writeln(indexfile, '            $suffixe='''';');
  writeln(indexfile, '            if (strpos($myrow[1],''</' +
    CTagNameTitle + '>'')>0) {');
  writeln(indexfile, '               $titre=substr($myrow[1],strpos($myrow[1],''<' +
    CTagNameTitle + '>'')+' + IntToStr(length(CTagNameTitle) + 2) +
    ',strpos($myrow[1],''</' + CTagNameTitle + '>'')-strpos($myrow[1],''<' +
    CTagNameTitle + '>'')-' + IntToStr(length(CTagNameTitle) + 2) + '); }');
  writeln(indexfile, '            if (strpos($myrow[1],''</' +
    CTagNameGivenName + '>'')>0) {');
  writeln(indexfile, '               $prenom=substr($myrow[1],strpos($myrow[1],''<' +
    CTagNameGivenName + '>'')+' + IntToStr(length(CTagNameGivenName) + 2) +
    ',strpos($myrow[1],''</' + CTagNameGivenName + '>'')-strpos($myrow[1],''<' +
    CTagNameGivenName + '>'')-' + IntToStr(length(CTagNameTitle) + 2) + '); }');
  writeln(indexfile, '            if (strpos($myrow[1],''</' +
    CTagNameFamilyName + '>'')>0) {');
  writeln(indexfile, '               $nom=substr($myrow[1],strpos($myrow[1],''<' +
    CTagNameFamilyName + '>'')+' + IntToStr(length(CTagNameFamilyName) + 2) +
    ',strpos($myrow[1],''</' + CTagNameFamilyName + '>'')-strpos($myrow[1],''<' +
    CTagNameFamilyName + '>'')-' + IntToStr(length(CTagNameTitle) + 2) + '); }');
  writeln(indexfile, '            if (strpos($myrow[1],''</' +
    CTagNameSuffix + '>'')>0) {');
  writeln(indexfile, '               $suffixe=substr($myrow[1],strpos($myrow[1],''<' +
    CTagNameSuffix + '>'')+' + IntToStr(length(CTagNameSuffix) + 2) +
    ',strpos($myrow[1],''</' + CTagNameSuffix + '>'')-strpos($myrow[1],''<' +
    CTagNameSuffix + '>'')-' + IntToStr(length(CTagNameTitle) + 2) + '); }');
  writeln(indexfile, '         }');
  writeln(indexfile,
    '    if (((strlen($suffixe)>0) && (strlen($nom)>0)) && (strlen($prenom)>0)) {');
  writeln(indexfile,
    '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">%s %s, %s",$myrow[0],$nom,$suffixe,$prenom);');
  writeln(indexfile, '    }');
  writeln(indexfile,
    '    if (((strlen($suffixe)>0) && (strlen($nom)==0)) && (strlen($prenom)>0)) {');
  writeln(indexfile,
    '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">%s %s, %s",$myrow[0],$nom,$suffixe,$prenom);');
  writeln(indexfile, '    }');
  writeln(indexfile,
    '    if (((strlen($suffixe)==0) && (strlen($nom)>0)) && (strlen($prenom)>0)) {');
  writeln(indexfile,
    '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">%s, %s",$myrow[0],$nom,$prenom);');
  writeln(indexfile, '    }');
  writeln(indexfile,
    '    if (((strlen($suffixe)>0) || (strlen($nom)>0)) && (strlen($prenom)==0)) {');
  writeln(indexfile,
    '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">%s %s",$myrow[0],$nom,$suffixe);');
  writeln(indexfile, '    }');
  writeln(indexfile,
    '    if (((strlen($suffixe)==0) && (strlen($nom)==0)) && (strlen($prenom)>0)) {');
  writeln(indexfile,
    '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">, %s",$myrow[0],$prenom);');
  writeln(indexfile, '    }');
  writeln(indexfile,
    '    if (((strlen($suffixe)==0) && (strlen($nom)==0)) && (strlen($prenom)==0)) {');
  writeln(indexfile,
    '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">???",$myrow[0]);');
  writeln(indexfile, '    }');
  writeln(indexfile, '    if ((strlen($titre)>0)) {');
  writeln(indexfile, '        printf(" (%s)</A></DD>",$titre);');
  writeln(indexfile, '    } else {');
  writeln(indexfile, '        printf("</A></DD>");');
  writeln(indexfile, '    }');
  writeln(indexfile, '   }');
  writeln(indexfile, '   }');
  writeln(indexfile, '} ?>');
  writeln(indexfile, '<HR>');
  writeln(indexfile, '<DL>');
  First := DecodeName(dmGenData.Query1.Fields[1].AsString, 2);
  last := '';
  max_request := 3000;
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Ferme le file1 index, ouvre en un autre et ajoute une ligne à bouton
      writeln(indexfile, '</DL>');
      writeln(indexfile, '<HR>');
      writeln(indexfile, '</BODY>');
      writeln(indexfile, '</HTML>');
      closefile(indexfile);
      Write(buttonsfile, '<DD><A TITLE="' + First + ' - ' + last);
      Write(buttonsfile, format('" TARGET="index" HREF=index_%d.php>', [nb_file]));
      Write(buttonsfile, AnsiUpperCase(leftstr(First, 3)));
      Write(buttonsfile, ' - ' + AnsiUpperCase(leftstr(last, 3)));
      writeln(buttonsfile, '</A></DD>');
      nb_file := nb_file + 1;
      filename := format('%sindex_%d.php', [drive, nb_file]);
      assignfile(indexfile, FileName);
      rewrite(indexfile);
      writeln(indexfile, '<HTML>');
      writeln(indexfile, '<HEAD>');
      writeln(indexfile,
        '<META HTTP-EQUIV="Content-Type" CONTENT="Text/html; charset=windows-1252">');
      writeln(indexfile, Utf8ToAnsi('<TITLE>Index de la base de données</TITLE>'));
      writeln(indexfile, '<BASE TARGET="texte">');
      writeln(indexfile,
        '<!--mstheme--><link rel="stylesheet" type="text/css" href="../_themes/genealogy/gene1011.css"><meta name="Microsoft Theme" content="genealogy 1011">');
      writeln(indexfile, '</HEAD>');
      writeln(indexfile, '<BODY>');
      writeln(indexfile, Utf8ToAnsi(
        '<DD><A HREF=testphp/recherche.php>Recherche avancée</A></DD>'));
      writeln(indexfile, '<?php');
      writeln(indexfile, 'if (isset($_POST["recherche"]))  {');
      writeln(indexfile, '   $oldrecherche = $_POST["recherche"];');
      writeln(indexfile, '} else {');
      writeln(indexfile, '   $oldrecherche = '''';');
      writeln(indexfile, '}?>');
      writeln(indexfile,
        '  <form method="post" target=index action="<?php echo $_SERVER[''PHP_SELF'']?>">');
      writeln(indexfile,
        '  <input type="Text" name="recherche" value="<?php echo $oldrecherche?>"><br>');
      writeln(indexfile,
        '  <input type="Submit" target=index name="submit" value="Recherche nom">');
      writeln(indexfile, '  </form>');
      writeln(indexfile, '<?php');
      writeln(indexfile, 'if (isset($_POST["recherche"]))  {');
      writeln(indexfile, '  // process form');
      writeln(indexfile, '   require("testphp/fonctions.php");');
      writeln(indexfile, '   $serveur = GetMySqlServerAddress();');
      writeln(indexfile, '   $db = mysql_connect($serveur, "' +
        user + '", "' + password + '");');
      writeln(indexfile, '   mysql_select_db("genealo_data",$db);');
      writeln(indexfile,
        '   $result = mysql_query("SELECT I, N FROM N WHERE MATCH (N) AGAINST (''$oldrecherche'' IN BOOLEAN MODE) ORDER BY MATCH (N) AGAINST (''$oldrecherche'' IN BOOLEAN MODE) DESC",$db);');
      writeln(indexfile, '   while ($myrow = mysql_fetch_row($result)) {');
      writeln(indexfile,
        '      $result2 = mysql_query("SELECT V FROM I WHERE no=$myrow[0]",$db);');
      writeln(indexfile, '      while ($myrow2 = mysql_fetch_row($result2)) {');
      writeln(indexfile, '          $html = $myrow2[0];');
      writeln(indexfile, '      }');
      writeln(indexfile, '      if ($html!=''O'') {');
      writeln(indexfile,
        '         if (substr($myrow[1],0,5)==''!dmGenData.TMG|'') {');
      writeln(indexfile,
        '            $myrow[1]= substr($myrow[1],strpos($myrow[1],''|'')+1,strlen($myrow[1]));');
      writeln(indexfile,
        '            $nom     = substr($myrow[1],0,strpos($myrow[1],''|''));');
      writeln(indexfile,
        '            $suffixe  = substr($myrow[1],(strpos($myrow[1],''|'',strpos($myrow[1],''|'',');
      Write(indexfile,
        'strpos($myrow[1],''|'')+1)+1)+1),(strpos($myrow[1],''|'',strpos($myrow[1],''|'',strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1)+1)+1)-(strpos($myrow[1],''|'',strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1)+1)+1)));');
      writeln(indexfile,
        '            $prenom = substr($myrow[1],(strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1)+1),(strpos($myrow[1],''|'',strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1)+1)-(strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1)+1)));');
      writeln(indexfile,
        '            $titre      = substr($myrow[1],strpos($myrow[1],''|'')+1,(strpos($myrow[1],''|'',strpos($myrow[1],''|'')+1))-strpos($myrow[1],''|'')-1);');
      writeln(indexfile, '         } else {');
      writeln(indexfile, '            $titre='''';');
      writeln(indexfile, '            $prenom='''';');
      writeln(indexfile, '            $nom='''';');
      writeln(indexfile, '            $suffixe='''';');
      writeln(indexfile, '            if (strpos($myrow[1],''</' +
        CTagNameTitle + '>'')>0) {');
      writeln(indexfile,
        '               $titre=substr($myrow[1],strpos($myrow[1],''<' +
        CTagNameTitle + '>'')+' + IntToStr(length(CTagNameTitle) + 2) +
        ',strpos($myrow[1],''</' + CTagNameTitle + '>'')-strpos($myrow[1],''<' +
        CTagNameTitle + '>'')-' + IntToStr(length(CTagNameTitle) + 2) + '); }');
      writeln(indexfile, '            if (strpos($myrow[1],''</' +
        CTagNameGivenName + '>'')>0) {');
      writeln(indexfile,
        '               $prenom=substr($myrow[1],strpos($myrow[1],''<' +
        CTagNameGivenName + '>'')+' + IntToStr(length(CTagNameGivenName) + 2) +
        ',strpos($myrow[1],''</' + CTagNameGivenName +
        '>'')-strpos($myrow[1],''<' + CTagNameGivenName + '>'')-' +
        IntToStr(length(CTagNameGivenName) + 2) + '); }');
      writeln(indexfile, '            if (strpos($myrow[1],''</' +
        CTagNameFamilyName + '>'')>0) {');
      writeln(indexfile,
        '               $nom=substr($myrow[1],strpos($myrow[1],''<' +
        CTagNameFamilyName + '>'')+' + IntToStr(length(CTagNameFamilyName) + 2) +
        ',strpos($myrow[1],''</' + CTagNameFamilyName +
        '>'')-strpos($myrow[1],''<' + CTagNameFamilyName + '>'')-' +
        IntToStr(length(CTagNameFamilyName) + 2) + '); }');
      writeln(indexfile, '            if (strpos($myrow[1],''</' +
        CTagNameSuffix + '>'')>0) {');
      writeln(indexfile,
        '               $suffixe=substr($myrow[1],strpos($myrow[1],''<' +
        CTagNameSuffix + '>'')+' + IntToStr(length(CTagNameSuffix) + 2) +
        ',strpos($myrow[1],''</' + CTagNameSuffix + '>'')-strpos($myrow[1],''<' +
        CTagNameSuffix + '>'')-' + IntToStr(length(CTagNameSuffix) + 2) + '); }');
      writeln(indexfile, '         }');
      writeln(indexfile,
        '    if (((strlen($suffixe)>0) && (strlen($nom)>0)) && (strlen($prenom)>0)) {');
      writeln(indexfile,
        '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">%s %s, %s",$myrow[0],$nom,$suffixe,$prenom);');
      writeln(indexfile, '    }');
      writeln(indexfile,
        '    if (((strlen($suffixe)>0) && (strlen($nom)==0)) && (strlen($prenom)>0)) {');
      writeln(indexfile,
        '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">%s %s, %s",$myrow[0],$nom,$suffixe,$prenom);');
      writeln(indexfile, '    }');
      writeln(indexfile,
        '    if (((strlen($suffixe)==0) && (strlen($nom)>0)) && (strlen($prenom)>0)) {');
      writeln(indexfile,
        '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">%s, %s",$myrow[0],$nom,$prenom);');
      writeln(indexfile, '    }');
      writeln(indexfile,
        '    if (((strlen($suffixe)>0) || (strlen($nom)>0)) && (strlen($prenom)==0)) {');
      writeln(indexfile,
        '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">%s %s",$myrow[0],$nom,$suffixe);');
      writeln(indexfile, '    }');
      writeln(indexfile,
        '    if (((strlen($suffixe)==0) && (strlen($nom)==0)) && (strlen($prenom)>0)) {');
      writeln(indexfile,
        '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">, %s",$myrow[0],$prenom);');
      writeln(indexfile, '    }');
      writeln(indexfile,
        '    if (((strlen($suffixe)==0) && (strlen($nom)==0)) && (strlen($prenom)==0)) {');
      writeln(indexfile,
        '        printf("\n<DD><A HREF=\"testphp/info.php?no=%d\">???",$myrow[0]);');
      writeln(indexfile, '    }');
      writeln(indexfile, '    if ((strlen($titre)>0)) {');
      writeln(indexfile, '        printf(" (%s)</A></DD>",$titre);');
      writeln(indexfile, '    } else {');
      writeln(indexfile, '        printf("</A></DD>");');
      writeln(indexfile, '    }');
      writeln(indexfile, '   }');
      writeln(indexfile, '   }');
      writeln(indexfile, '} ?>');
      writeln(indexfile, '<HR>');
      writeln(indexfile, '<DL>');
      First := DecodeName(dmGenData.Query1.Fields[1].AsString, 2);
    end;
    // Inscrit le nom
    last := DecodeName(dmGenData.Query1.Fields[1].AsString, 2);
    Write(indexfile, '<DD><A HREF="testphp/info.php?no=');
    Write(indexfile, dmGenData.Query1.Fields[0].AsString);
    Write(indexfile, '">');
    Write(indexfile, last);
    writeln(indexfile, '</A></DD>');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);

  end;
  // Fermeture du file1 de buttonsfile
  writeln(indexfile, '</DL>');
  writeln(indexfile, '<HR>');
  writeln(indexfile, '</BODY>');
  writeln(indexfile, '</HTML>');
  closefile(indexfile);

  Write(buttonsfile, '<DD><A TITLE="' + First + ' - ' + last);
  Write(buttonsfile, format('" TARGET="index" HREF=index_%d.php>', [nb_file]));
  Write(buttonsfile, AnsiUpperCase(leftstr(First, 3)));
  Write(buttonsfile, ' - ' + AnsiUpperCase(leftstr(last, 3)));
  writeln(buttonsfile, '</A></DD>');
  writeln(buttonsfile, '</DL>');
  writeln(buttonsfile, '<HR>');
  // Ajout d'une recherche Google de mon site
  writeln(buttonsfile, '<!-- Search Google -->');
  writeln(buttonsfile, '<center>');
  writeln(buttonsfile, '<FORM method=GET action=http://www.google.com/custom>');
  writeln(buttonsfile, '<TABLE bgcolor=#FFCC00 cellspacing=0 border=0>');
  writeln(buttonsfile, '<tr valign=top><td>');
  writeln(buttonsfile, '<A HREF=http://www.google.com/search>');
  writeln(buttonsfile,
    '<IMG SRC=http://www.google.com/logos/Logo_40blk.gif border=0 ALT=Google align=middle></A>');
  writeln(buttonsfile, '</td>');
  writeln(buttonsfile, '<td>');
  writeln(buttonsfile, '<INPUT TYPE=text name=q size=31 maxlength=255 value="">');
  writeln(buttonsfile, '<INPUT type=submit name=sa VALUE="Google Search">');
  writeln(buttonsfile,
    '<INPUT type=hidden name=cof VALUE="GALT:#FFFFCC;S:'+site+';GL:2;VLC:#66CC99;AH:center;BGC:#000000;LC:#FFCC00;GFNT:#669999;ALC:#669999;BIMG:'+site+'/fond.jpg;T:#FFFFCC;GIMP:#FFFFCC;AWFID:4aaddc5da62118cf;">');
  writeln(buttonsfile,
    '<input type=hidden name=domains value="genealogiequebec.info"><br><input type=radio name=sitesearch value=""> web <input type=radio name=sitesearch value="genealogiequebec.info" checked> genealogiequebec.info');
  writeln(buttonsfile, '</td></tr></TABLE>');
  writeln(buttonsfile, '</FORM>');
  writeln(buttonsfile, '</center>');
  writeln(buttonsfile, '<!-- Search Google -->');
  writeln(buttonsfile, '</BODY>');
  writeln(buttonsfile, '</HTML>');
  closefile(buttonsfile);

  SPanel.text := Translation.Items[325];
  dmGenData.Query1.tag := -dmGenData.CountAllRecords;;
      if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  dmGenData.Query1.tag := 1;
      if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);

  max_request := 5000;
  // Exporter projet, créer fichiers php de base de données }
  // Insert file header }
  filename := Drive + 'update.html';
  assignfile(file2, FileName);
  rewrite(file2);
  writeln(file2, '<HTML>');
  writeln(file2, '<BODY>');
  writeln(file2, '<LI><A HREF="beginupdate.php" target="texte">beginupdate.php</A></LI>');
  nb_file := 1;
  // TABLE A
  dmGenData.Query1.SQL.Text := 'SELECT no, S, D, M FROM A';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_A' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_A' + IntToStr(nb_file) +
    '.php" target="texte">writedata_A' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS A");');
  writeln(file1,
    '$r = m("CREATE TABLE A (no SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY, S SMALLINT(8) UNSIGNED, D SMALLINT(8) UNSIGNED, M TINYTEXT)") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO A (no, S, D, M) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_A' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_A'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_A' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_A' + IntToStr(
        nb_file) + '.php" target="texte">writedata_A' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1, '$q = "INSERT IGNORE INTO A (no, S, D, M) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ' + dmGenData.Query1.Fields[1].AsString + ', ' +
      dmGenData.Query1.Fields[2].AsString + ', ''' +
      AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[3].AsString, '"', '\"'),
      '''', '\''') + ''')") OR DIE ("Err:' + IntToStr(dmGenData.Query1.tag) +
      '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1,
    '$r = m("CREATE INDEX S ON A (S)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1,
    '$r = m("CREATE INDEX D ON A (D)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1, 'printf("\ndernier writedata_A' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_C'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE C
  dmGenData.Query1.SQL.Text := 'SELECT no, Y, N, S, Q, M FROM C';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_C' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_C' + IntToStr(nb_file) +
    '.php" target="texte">writedata_C' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS C");');
  writeln(file1,
    '$r = m("CREATE TABLE C (no MEDIUMINT(9) UNSIGNED AUTO_INCREMENT PRIMARY KEY, Y CHAR(1), N MEDIUMINT(9) UNSIGNED, S SMALLINT(6) UNSIGNED, Q SMALLINT(2) UNSIGNED, M TEXT NULL)") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO C (no, Y, N, S, Q, M) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_C' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_C'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_C' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_C' + IntToStr(
        nb_file) + '.php" target="texte">writedata_C' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1, '$q = "INSERT IGNORE INTO C (no, Y, N, S, Q, M) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ''' + dmGenData.Query1.Fields[1].AsString + ''', ' +
      dmGenData.Query1.Fields[2].AsString + ', ' +
      dmGenData.Query1.Fields[3].AsString + ', ' + dmGenData.Query1.Fields[4].AsString +
      ', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[5].AsString,
      '"', '\"'), '''', '\''') + ''')") OR DIE ("Err:' +
      IntToStr(dmGenData.Query1.tag) + '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1,
    '$r = m("CREATE INDEX N ON C (N)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1,
    '$r = m("CREATE INDEX S ON C (S)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1, 'printf("\ndernier writedata_C' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_D'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE D
  dmGenData.Query1.SQL.Text := 'SELECT no, T, D, M, I FROM D';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_D' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_D' + IntToStr(nb_file) +
    '.php" target="texte">writedata_D' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS D");');
  writeln(file1,
    '$r = m("CREATE TABLE D (no SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY, T VARCHAR(35), D TINYTEXT, M TINYTEXT, I MEDIUMINT(9) UNSIGNED)") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO D (no, T, D, M, I) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_D' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_D'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_D' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_D' + IntToStr(
        nb_file) + '.php" target="texte">writedata_D' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1, '$q = "INSERT IGNORE INTO D (no, T, D, M, I) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[1].AsString,
      '"', '\"'), '''', '\''') + ''', ''' + AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[2].AsString, '"', '\"'), '''', '\''') +
      ''', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[3].AsString,
      '"', '\"'), '''', '\''') + ''', ' + dmGenData.Query1.Fields[4].AsString +
      ')") OR DIE ("Err:' + IntToStr(dmGenData.Query1.tag) + '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1, 'printf("\ndernier writedata_D' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_E'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE E
  dmGenData.Query1.SQL.Text := 'SELECT no, Y, PD, SD, L, M, X FROM E';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_E' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_E' + IntToStr(nb_file) +
    '.php" target="texte">writedata_E' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS E");');
  writeln(file1,
    '$r = m("CREATE TABLE E (no MEDIUMINT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY, Y SMALLINT(5) UNSIGNED, PD TINYTEXT, SD TINYTEXT, L MEDIUMINT(8) UNSIGNED, M TEXT, X TINYINT(1) UNSIGNED)") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO E (no, Y, PD, SD, L, M, X) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_E' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_E'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_E' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_E' + IntToStr(
        nb_file) + '.php" target="texte">writedata_E' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1, '$q = "INSERT IGNORE INTO E (no, Y, PD, SD, L, M, X) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ' + dmGenData.Query1.Fields[1].AsString + ', ''' +
      AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[2].AsString, '"', '\"'),
      '''', '\''') + ''', ''' +
      AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[3].AsString, '"', '\"'),
      '''', '\''') + ''', ' + dmGenData.Query1.Fields[4].AsString +
      ', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[5].AsString,
      '"', '\"'), '''', '\''') + ''', ' + dmGenData.Query1.Fields[6].AsString +
      ')") OR DIE ("Err:' + IntToStr(dmGenData.Query1.tag) + '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1,
    '$r = m("CREATE FULLTEXT INDEX M ON E (M)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1, 'printf("\ndernier writedata_E' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_I'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE I
  dmGenData.Query1.SQL.Text := 'SELECT no, S, V, I, date FROM I';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_I' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_I' + IntToStr(nb_file) +
    '.php" target="texte">writedata_I' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS I");');
  writeln(file1,
    '$r = m("CREATE TABLE I (no MEDIUMINT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY, S CHAR(1), V CHAR(1), I TINYINT(2), date CHAR(8))") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO I (no, S, V, I, date) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_I' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_I'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_I' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_I' + IntToStr(
        nb_file) + '.php" target="texte">writedata_I' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1, '$q = "INSERT IGNORE INTO I (no, S, V, I, date) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ''' + dmGenData.Query1.Fields[1].AsString + ''', ''' +
      dmGenData.Query1.Fields[2].AsString + ''', ' +
      dmGenData.Query1.Fields[3].AsString + ', ''' + dmGenData.Query1.Fields[4].AsString +
      ''')") OR DIE ("Err:' + IntToStr(dmGenData.Query1.tag) + '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1, 'printf("\ndernier writedata_I' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_L'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE L
  dmGenData.Query1.SQL.Text := 'SELECT no, L FROM L';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_L' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_L' + IntToStr(nb_file) +
    '.php" target="texte">writedata_L' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS L");');
  writeln(file1,
    '$r = m("CREATE TABLE L (no MEDIUMINT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY, L TINYTEXT)") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO L (no, L) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_L' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_L'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_L' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_L' + IntToStr(
        nb_file) + '.php" target="texte">writedata_L' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1, '$q = "INSERT IGNORE INTO L (no, L) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[1].AsString,
      '"', '\"'), '''', '\''') + ''')") OR DIE ("Err:' +
      IntToStr(dmGenData.Query1.tag) + '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1, 'printf("\ndernier writedata_L' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_N'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE N
  dmGenData.Query1.SQL.Text :=
    'SELECT no, I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4 FROM N';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_N' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_N' + IntToStr(nb_file) +
    '.php" target="texte">writedata_N' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS N");');
  Write(file1,
    '$r = m("CREATE TABLE N (no MEDIUMINT(9) UNSIGNED AUTO_INCREMENT PRIMARY KEY, I MEDIUMINT(8) UNSIGNED,');
  writeln(file1,
    ' Y SMALLINT(5) UNSIGNED, N TEXT, X TINYINT(1) UNSIGNED, M TEXT, P MEDIUMTEXT, PD TINYTEXT, SD TINYTEXT, I1 VARCHAR(35), I2 VARCHAR(35), I3 VARCHAR(35), I4 VARCHAR(35))") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1,
    '$q = "INSERT IGNORE INTO N (no, I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_N' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_N'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_N' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_N' + IntToStr(
        nb_file) + '.php" target="texte">writedata_N' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1,
        '$q = "INSERT IGNORE INTO N (no, I, Y, N, X, M, P, PD, SD, I1, I2, I3, I4) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ' + dmGenData.Query1.Fields[1].AsString + ', ' +
      dmGenData.Query1.Fields[2].AsString + ', ''' +
      AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[3].AsString, '"', '\"'),
      '''', '\''') + ''', ' + dmGenData.Query1.Fields[4].AsString +
      ', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[5].AsString,
      '"', '\"'), '''', '\''') + ''', ''' +
      AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[6].AsString, '"', '\"'),
      '''', '\''') + ''', ''' + AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[7].AsString, '"', '\"'), '''', '\''') +
      ''', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[8].AsString,
      '"', '\"'), '''', '\''') + ''', ''' + AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[9].AsString, '"', '\"'), '''', '\''') +
      ''', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[10].AsString,
      '"', '\"'), '''', '\''') + ''', ''' + AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[11].AsString, '"', '\"'), '''', '\''') +
      ''', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[12].AsString,
      '"', '\"'), '''', '\''') + ''')") OR DIE ("Err:' +
      IntToStr(dmGenData.Query1.tag) + '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1,
    '$r = m("CREATE FULLTEXT INDEX N ON N (N)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1,
    '$r = m("CREATE INDEX I ON N (I)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1,
    '$r = m("CREATE INDEX I1 ON N (I1)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1,
    '$r = m("CREATE INDEX I2 ON N (I2)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1,
    '$r = m("CREATE INDEX I3 ON N (I3)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1,
    '$r = m("CREATE INDEX I4 ON N (I4)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1, 'printf("\ndernier writedata_N' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_R'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE R
  dmGenData.Query1.SQL.Text := 'SELECT no, Y, A, B, M, X, P, SD FROM R';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_R' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_R' + IntToStr(nb_file) +
    '.php" target="texte">writedata_R' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS R");');
  Write(file1,
    '$r = m("CREATE TABLE R (no MEDIUMINT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY,');
  writeln(file1,
    ' Y SMALLINT(5) UNSIGNED, A MEDIUMINT(8) UNSIGNED, B MEDIUMINT(8) UNSIGNED, M TEXT, X TINYINT(1) UNSIGNED, P MEDIUMTEXT, SD TINYTEXT)") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO R (no, Y, A, B, M, X, P, SD) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_R' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_R'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_R' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_R' + IntToStr(
        nb_file) + '.php" target="texte">writedata_R' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1,
        '$q = "INSERT IGNORE INTO R (no, Y, A, B, M, X, P, SD) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ' + dmGenData.Query1.Fields[1].AsString + ', ' +
      dmGenData.Query1.Fields[2].AsString + ', ' +
      dmGenData.Query1.Fields[3].AsString + ', ''' + AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[4].AsString, '"', '\"'), '''', '\''') +
      ''', ' + dmGenData.Query1.Fields[5].AsString + ', ''' +
      AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[6].AsString, '"', '\"'),
      '''', '\''') + ''', ''' +
      AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[7].AsString, '"', '\"'),
      '''', '\''') + ''')") OR DIE ("Err:' + IntToStr(dmGenData.Query1.tag) +
      '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1,
    '$r = m("CREATE INDEX A ON R (A)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1,
    '$r = m("CREATE INDEX B ON R (B)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1, 'printf("\ndernier writedata_R' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_S'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE S
  dmGenData.Query1.SQL.Text := 'SELECT no, T, D, M, A, Q FROM S';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_S' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_S' + IntToStr(nb_file) +
    '.php" target="texte">writedata_S' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS S");');
  writeln(file1,
    '$r = m("CREATE TABLE S (no SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY, T VARCHAR(35), D TINYTEXT, M TINYTEXT, A TINYTEXT, Q SMALLINT(2) UNSIGNED)") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO S (no, T, D, M, A, Q) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_S' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_S'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_S' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_S' + IntToStr(
        nb_file) + '.php" target="texte">writedata_S' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1, '$q = "INSERT IGNORE INTO S (no, T, D, M, A, Q) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[1].AsString,
      '"', '\"'), '''', '\''') + ''', ''' + AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[2].AsString, '"', '\"'), '''', '\''') +
      ''', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[3].AsString,
      '"', '\"'), '''', '\''') + ''', ''' + AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[4].AsString, '"', '\"'), '''', '\''') +
      ''', ' + dmGenData.Query1.Fields[5].AsString + ')") OR DIE ("Err:' +
      IntToStr(dmGenData.Query1.tag) + '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1, 'printf("\ndernier writedata_S' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_W'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE W
  dmGenData.Query1.SQL.Text := 'SELECT no, I, E, X, P, R FROM W';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_W' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_W' + IntToStr(nb_file) +
    '.php" target="texte">writedata_W' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS W");');
  writeln(file1,
    '$r = m("CREATE TABLE W (no MEDIUMINT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY, I MEDIUMINT(8) UNSIGNED, E MEDIUMINT(8) UNSIGNED, X TINYINT(1) UNSIGNED, P TINYTEXT, R VARCHAR(20))") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO W (no, I, E, X, P, R) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_W' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_W'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_W' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_W' + IntToStr(
        nb_file) + '.php" target="texte">writedata_W' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1, '$q = "INSERT IGNORE INTO W (no, I, E, X, P, R) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ' + dmGenData.Query1.Fields[1].AsString + ', ' +
      dmGenData.Query1.Fields[2].AsString + ', ' +
      dmGenData.Query1.Fields[3].AsString + ', ''' + AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[4].AsString, '"', '\"'), '''', '\''') +
      ''', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[5].AsString,
      '"', '\"'), '''', '\''') + ''')") OR DIE ("Err:' +
      IntToStr(dmGenData.Query1.tag) + '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1,
    '$r = m("CREATE INDEX E ON W (E)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1,
    '$r = m("CREATE INDEX I ON W (I)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1, 'printf("\ndernier writedata_W' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_X'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE X
  dmGenData.Query1.SQL.Text := 'SELECT no, X, T, D, F, Z, A, N FROM X';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_X' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_X' + IntToStr(nb_file) +
    '.php" target="texte">writedata_X' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS X");');
  writeln(file1,
    '$r = m("CREATE TABLE X (no SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY, X TINYINT(1) UNSIGNED, T VARCHAR(35), D TINYTEXT, F TINYTEXT, Z LONGTEXT, A CHAR(1), N MEDIUMINT(9) UNSIGNED)") OR DIE ("Could not successfully run dmGenData.Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO X (no, X, T, D, F, Z, A, N) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_X' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_X'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_X' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_X' + IntToStr(
        nb_file) + '.php" target="texte">writedata_X' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1, '$q = "INSERT IGNORE INTO X (no, X, T, D, F, Z, A, N) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ' + dmGenData.Query1.Fields[1].AsString + ', ''' +
      AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[2].AsString, '"', '\"'),
      '''', '\''') + ''', ''' +
      AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[3].AsString, '"', '\"'),
      '''', '\''') + ''', ''' + AutoQuote(dmGenData.Query1.Fields[4].AsString) + ''', ''' + AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[5].AsString, '"', '\"'), '''', '\''') +
      ''', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[6].AsString,
      '"', '\"'), '''', '\''') + ''', ' + dmGenData.Query1.Fields[7].AsString +
      ')") OR DIE ("Err:' + IntToStr(dmGenData.Query1.tag) + '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1,
    '$r = m("CREATE INDEX N ON X (N)") OR DIE ("Could not successfully run dmGenData.Query from DB2: " . n());');
  writeln(file1, 'printf("\ndernier writedata_X' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1,
    'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_Y'
    + IntToStr(nb_file) + '.php\";'',' + IntToStr(time_delay) +
    ');</script>\n");');
  writeln(file1, 'echo ("<noscript>\n");');
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  // TABLE Y
  dmGenData.Query1.SQL.Text := 'SELECT no, T, Y, P, R FROM Y';
  dmGenData.Query1.Open;
  dmGenData.Query1.First;
  filename := Drive + 'writedata_Y' + IntToStr(nb_file) + '.php';
  assignfile(file1, FileName);
  rewrite(file1);
  writeln(file2, '<LI><A HREF="writedata_Y' + IntToStr(nb_file) +
    '.php" target="texte">writedata_Y' + IntToStr(nb_file) + '.php</A></LI>');
  writeln(file1, '<?PHP');
  writeln(file1, ' Header("Cache-Control: must-revalidate");');
  writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
  writeln(file1,
    ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
  writeln(file1, ' Header($ExpStr);');
  writeln(file1, 'function m($a) {');
  writeln(file1, '   Return mysql_query($a);');
  writeln(file1, '}');
  writeln(file1, 'function n() {');
  writeln(file1, '   Return mysql_error();');
  writeln(file1, '}');
  writeln(file1, '$db = mysql_connect("' + server + '", "' + user +
    '", "' + password + '");');
  writeln(file1, 'mysql_select_db("' + db + '",$db);');
  writeln(file1, '$r = m("DROP TABLE IF EXISTS Y");');
  writeln(file1,
    '$r = m("CREATE TABLE Y (no SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY, T VARCHAR(35), Y CHAR(1), P MEDIUMTEXT, R MEDIUMTEXT)") OR DIE ("Could not successfully run Query from CREATE: " . n());');
  writeln(file1, '$q = "INSERT IGNORE INTO Y (no, T, Y, P, R) VALUES";');
  while not dmGenData.Query1.EOF do
  begin
    if (dmGenData.Query1.tag mod max_request) = 0 then
    begin
      // Insert file footer
      writeln(file1, 'printf("\ndernier writedata_Y' + IntToStr(
        nb_file) + '.php");');
      writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
      writeln(file1, '');
      writeln(file1,
        'echo ("<script language=\"JavaScript\" type=\"text/javascript\">window.setTimeout(''location.href=\"writedata_Y'
        + IntToStr(nb_file + 1) + '.php\";'',' +
        IntToStr(time_delay) + ');</script>\n");');
      writeln(file1, 'echo ("<noscript>\n");');
      writeln(file1, '');
      writeln(file1, '?>');
      closefile(file1);
      // Insert file header
      nb_file := nb_file + 1;
      filename := Drive + 'writedata_Y' + IntToStr(nb_file) + '.php';
      assignfile(file1, FileName);
      rewrite(file1);
      writeln(file2, '<LI><A HREF="writedata_Y' + IntToStr(
        nb_file) + '.php" target="texte">writedata_Y' + IntToStr(nb_file) +
        '.php</A></LI>');
      writeln(file1, '<?PHP');
      writeln(file1, ' Header("Cache-Control: must-revalidate");');
      writeln(file1, ' $offset = 60 * 60 * 24 * 365 * -1;');
      writeln(file1,
        ' $ExpStr = "Expires: " . gmdate("D, d M Y H:i:s", time() + $offset) . " GMT";');
      writeln(file1, ' Header($ExpStr);');
      writeln(file1, 'function m($a) {');
      writeln(file1, '   Return mysql_query($a);');
      writeln(file1, '}');
      writeln(file1, 'function n() {');
      writeln(file1, '   Return mysql_error();');
      writeln(file1, '}');
      writeln(file1, '$db = mysql_connect("' + server + '", "' +
        user + '", "' + password + '");');
      writeln(file1, 'mysql_select_db("' + db + '",$db);');
      writeln(file1, '$q = "INSERT IGNORE INTO Y (no, T, Y, P, R) VALUES";');
    end;
    // Insert record
    writeln(file1, '$r = m("$q (' + dmGenData.Query1.Fields[0].AsString +
      ', ''' + AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[1].AsString,
      '"', '\"'), '''', '\''') + ''', ''' + AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[2].AsString, '"', '\"'), '''', '\''') +
      ''', ''' + AnsiReplaceStr(AnsiReplaceStr(
      AnsiReplaceStr(dmGenData.Query1.Fields[3].AsString, '$', '\$'), '"', '\"'),
      '''', '\''') + ''', ''' +
      AnsiReplaceStr(AnsiReplaceStr(dmGenData.Query1.Fields[4].AsString, '"', '\"'),
      '''', '\''') + ''')") OR DIE ("Err:' + IntToStr(dmGenData.Query1.tag) +
      '". n());');
    dmGenData.Query1.Next;
    dmGenData.Query1.tag := dmGenData.Query1.tag + 1;
    if Assigned(lOnProgress) then
     lOnProgress(dmGenData.Query1);
  end;
  // Insert file footer
  writeln(file1, 'printf("\ndernier writedata_Y' + IntToStr(nb_file) + '.php");');
  writeln(file1, 'printf(" terminé de traité à %s\n",date("F j, Y, g:i:s a"));');
  writeln(file1, '');
  nb_file := 1;
  writeln(file1, '');
  writeln(file1, '?>');
  closefile(file1);
  writeln(file2, '<LI><A HREF="endupdate.php" target="texte">endupdate.php</A></LI>');
  writeln(file2, '</BODY>');
  writeln(file2, '</HTML>');
  closefile(file2);
  SPanel.Text := '';
end;

end.

