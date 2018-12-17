DROP PROCEDURE IF EXISTS insert_series;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE insert_series (
    IN d_name VARCHAR(255)
  , IN d_description TEXT
  , IN d_genre VARCHAR(255)
  , IN d_thumbnail VARCHAR(255)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call insert_series('Titel', 'Beschreibung', 'Genre', 'http://link.com/bild')
**/

INSERT INTO tbl_series (name, description, genre, thumbnail)
  SELECT d_name, d_description, d_genre, d_thumbnail FROM DUAL
    WHERE NOT EXISTS
      (SELECT name FROM tbl_series
        WHERE name = d_name);
  SET @inserted_id = (SELECT id FROM tbl_series WHERE name = d_name);
  SET @last_id = LAST_INSERT_ID();
  SELECT @last_id AS last_id, @inserted_id AS inserted_id;
END$$

DELIMITER ;
