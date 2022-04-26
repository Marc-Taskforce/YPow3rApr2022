**free
//**************************************************************
//
// RPG-SQL to generate JSON-Data
//
// ISO DATE   - AUTHOR - COMMENT
// 2022-04-20 - MR     - Created
//**************************************************************

dcl-pi *n;
   version INT(3);
   json  char(20000);
end-pi;

//------------------------



json  = '';

IF (version = 1);
  EXEC SQL
  SELECT json_object ('ID' VALUE id,
                      'Name' VALUE name,
                      'Warengruppe' VALUE warengrp,
                      'Größe' VALUE groesse)
  INTO :json
  FROM tfwsdev.artikel;
ELSEIF  (version = 2);
  EXEC SQL
  SELECT json_object ('Artikel' VALUE json_arrayagg(
                                    json_object ('ID' VALUE id,
                                                 'Name' VALUE name,
                                                 'Warengruppe' VALUE warengrp,
                                                 'Größe' VALUE groesse)))
  INTO :json
  FROM tfwsdev.artikel;
ELSEIF  (version = 3);
  EXEC SQL
  SELECT json_object ('Artikel' VALUE json_arrayagg(
                                    json_object ('ID' VALUE a.id,
                                                 'Name' VALUE a.name,
                                                 'Warengruppe' VALUE w.name,
                                                 'Größe' VALUE a.groesse)))
  INTO :json
  FROM tfwsdev.artikel AS a
  INNER JOIN tfwsdev.warengrp AS w
  ON a.warengrp = w.id;
ELSEIF  (version = 4);
  EXEC SQL
  SELECT json_object ('Artikel' VALUE json_arrayagg(
                                    json_object ('ID' VALUE a.id,
                                                 'Name' VALUE a.name,
                                                 'Warengruppe' VALUE json_object ('ID' VALUE w.id,
                                                                               'Name' VALUE w.name),
                                                 'Größe' VALUE a.groesse)))
  INTO :json
  FROM tfwsdev.artikel AS a
  INNER JOIN tfwsdev.warengrp AS w
  ON a.warengrp = w.id;
ENDIF;

*inlr = *on ; 
