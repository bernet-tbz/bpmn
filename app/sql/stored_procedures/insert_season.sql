DROP PROCEDURE IF EXISTS insert_season;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE insert_season (
    IN d_series_name VARCHAR(255)
  , IN d_name VARCHAR(255)
  , IN d_order_number INT(10)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call insert_season('Game Of Thrones', 'Season 2', 2)
**/

INSERT INTO tbl_season (fk_series, name, order_number)
  SELECT (SELECT id FROM tbl_series ser WHERE ser.name = d_series_name), d_name, d_order_number FROM DUAL
    WHERE NOT EXISTS
      (SELECT name FROM tbl_season sea
        WHERE sea.order_number = d_order_number
        AND sea.fk_series = (SELECT id FROM tbl_series ser WHERE ser.name = d_series_name));
  SET @last_id = LAST_INSERT_ID();
  SELECT @last_id AS last_id;
END$$

DELIMITER ;
