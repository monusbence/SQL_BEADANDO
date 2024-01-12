/*Mónus Bence 12/b*/
1, /*Készíts 1 lekérdezést, amely allekérdezést is tartalmaz, és legalább 2 tábla
közötti kapcsolat van benne! */
SELECT versenyzo.nev AS VersenyzoNev
FROM versenyzo
INNER JOIN csapat ON versenyzo.csapatId = csapat.id
WHERE csapat.csapatNev = 'DECATHLON' AND versenyzo.nemzetiseg = 'HUN';

2,/*Készíts 1 lekérdezést, amelyben LEFT/RIGHT JOIN van használva, és van
is értelme, hogy azt használunk!*/
SELECT csapat.csapatNev, versenyzo.nev, eredmeny.szakasz, eredmeny.ido
FROM csapat
LEFT JOIN versenyzo ON csapat.id = versenyzo.csapatId
LEFT JOIN eredmeny ON versenyzo.id = eredmeny.versenyzoId;

3, /*Készíts 2 tárolt eljárást vagy függvényt, amelyben kurzort is használsz!
Amennyiben kurzor nélkül is megoldható, használj kurzort mindenképpen
akkor is!*/
DELIMITER //
a,
CREATE PROCEDURE CsapatokSzama()
BEGIN
  DECLARE kesz BOOLEAN DEFAULT FALSE;
  DECLARE szamol INT;
  DECLARE letrehoz_kurzor CURSOR FOR
    SELECT COUNT(*) FROM csapat;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET kesz = TRUE;

  OPEN letrehoz_kurzor;
  FETCH letrehoz_kurzor INTO szamol;

  IF NOT kesz THEN
    SELECT szamol AS CsapatokSzama;
  END IF;

  CLOSE letrehoz_kurzor;
END //

DELIMITER ;
b,
DELIMITER //

CREATE PROCEDURE VersenyzokSzama()
BEGIN
  DECLARE kesz BOOLEAN DEFAULT FALSE;
  DECLARE szamol INT;
  DECLARE versenyzo_kurzor CURSOR FOR
    SELECT COUNT(*) FROM versenyzo;
  
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET kesz = TRUE;

  OPEN versenyzo_kurzor;
  FETCH versenyzo_kurzor INTO szamol;

  IF NOT kesz THEN
    SELECT szamol AS szamol;
  END IF;

  CLOSE versenyzo_kurzor;
END //

DELIMITER ;

4, /*Készíts 1 trigger-t, amely törlés esetén fut le (pl. kaszkádolt törlést csinál,
tehát kitörli a hozzá tartozó adatot is!)*/
DELIMITER //
CREATE TRIGGER torles_trigger
BEFORE DELETE ON csapat
FOR EACH ROW
BEGIN
    DECLARE csapat_id INT;
    SET csapat_id = regi.id;
    DELETE FROM versenyzo WHERE csapatId = csapat_id;
    DELETE FROM eredmeny WHERE versenyzoId IN (SELECT id FROM versenyzo WHERE csapatId = csapat_id);
END;
//
DELIMITER ;

5,/*Készíts 1 trigger-t, amely az adatok beviteléhez, vagy módosításához vagy
törléséhez vezet naplót egy külön táblába! (Elég az egyikhez)*/
CREATE TABLE naplo(
    Felhasznalo VARCHAR(50),
    Idopont TIMESTAMP DEFAULT Current_Timestamp,
    Leiras VARCHAR(100)
);

CREATE TRIGGER insertNaplo AFTER INSERT ON versenyzo
FOR EACH ROW
BEGIN
    DECLARE leir VARCHAR(100);
    SET leir=CONCAT("Új adat: ",NEW.nev);
    INSERT INTO naplo(Felhasznalo,Leiras) VALUES (user(),leir);
END; //
DELIMITER ;

INSERT INTO versenyzo VALUES (99, 'Taki',3, 'HUN');