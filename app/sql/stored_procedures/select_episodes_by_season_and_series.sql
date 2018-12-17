DROP PROCEDURE IF EXISTS select_episodes_by_season_and_series;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE select_episodes_by_season_and_series (
    IN d_name_series VARCHAR(255)
  , IN d_id_season INT(11)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call select_episodes_by_season_and_series(100001, 100001)
**/

SELECT e.id, e.name, e.description, e.thumbnail, e.src, e.released, e.year, e.country, e.language, seaepi.number
FROM tbl_episode e
INNER JOIN tbl_season_episode seaepi ON e.id = seaepi.fk_episode
INNER JOIN tbl_season sea ON seaepi.fk_season = sea.id
INNER JOIN tbl_series ser ON sea.fk_series = ser.id
WHERE ser.id = (SELECT id FROM tbl_series WHERE tbl_series.name = d_name_series) AND sea.id = d_id_season
ORDER BY seaepi.number;

END$$

DELIMITER ;
