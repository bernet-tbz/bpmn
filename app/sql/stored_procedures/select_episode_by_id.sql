DROP PROCEDURE IF EXISTS select_episode_by_id;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE select_episode_by_id (
    IN d_id_episode INT(11)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call select_episode_by_id(100001)
**/

SELECT e.id, e.name, e.description, e.thumbnail, e.src, e.released, e.year, e.country, e.language, seaepi.number, sea.name name_season, ser.name name_series, ser.description desc_series, sea.order_number
FROM tbl_episode e
INNER JOIN tbl_season_episode seaepi ON e.id = seaepi.fk_episode
INNER JOIN tbl_season sea ON seaepi.fk_season = sea.id
INNER JOIN tbl_series ser ON sea.fk_series = ser.id
WHERE e.id = d_id_episode;

END$$

DELIMITER ;

start here to top!
