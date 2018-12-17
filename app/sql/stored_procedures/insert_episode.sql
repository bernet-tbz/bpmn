DROP PROCEDURE IF EXISTS insert_episode;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE insert_episode (
    IN d_name VARCHAR(255)
  , IN d_thumbnail VARCHAR(255)
  , IN d_src VARCHAR(255)
  , IN d_description TEXT
  , IN d_released VARCHAR(255)
  , IN d_year INT(4)
  , IN d_country VARCHAR(255)
  , IN d_language VARCHAR(255)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call insert_episode('Name', 'http://link.com/bild', 'http://link.com/video', 'Beschreibung', '30.12.2017', 2017, 'CH', 'Deutsch')
**/

INSERT INTO tbl_episode (name, thumbnail, src, description, released, year, country, language)
  SELECT d_name, d_thumbnail, d_src, d_description, d_released, d_year, d_country, d_language FROM DUAL
    WHERE NOT EXISTS
      (SELECT name FROM tbl_episode
        WHERE name = d_name
        AND description = d_description);
  SET @last_id = LAST_INSERT_ID();
  SELECT @last_id AS last_id;
END$$

DELIMITER ;
