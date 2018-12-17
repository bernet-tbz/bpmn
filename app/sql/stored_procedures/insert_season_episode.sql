DROP PROCEDURE IF EXISTS insert_season_episode;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE insert_season_episode (
    IN d_fk_episode INT(10)
  , IN d_name_series VARCHAR(255)
  , IN d_number_season INT(10)
  , IN d_number_episode INT(10)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call insert_season_episode(100001, 'Game Of Thrones', 6, 1)
**/

INSERT INTO tbl_season_episode (fk_episode, fk_season, number)
  SELECT d_fk_episode, (SELECT sea.id FROM tbl_season sea INNER JOIN tbl_series ser ON sea.fk_series = ser.id WHERE sea.order_number = d_number_season AND ser.name = d_name_series), d_number_episode
  FROM DUAL
    WHERE NOT EXISTS
      (SELECT fk_episode FROM tbl_season_episode
        WHERE fk_episode = d_fk_episode
        AND fk_season = (SELECT sea.id FROM tbl_season sea INNER JOIN tbl_series ser ON sea.fk_series = ser.id WHERE sea.order_number = d_number_season AND ser.name = d_name_series)
        AND number = d_number_episode);
  SET @last_id = LAST_INSERT_ID();
  SELECT @last_id AS last_id;
END$$

DELIMITER ;
