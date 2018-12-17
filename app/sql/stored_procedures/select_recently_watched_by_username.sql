DROP PROCEDURE IF EXISTS select_recently_watched_by_username;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE select_recently_watched_by_username (
  IN d_username VARCHAR(30)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call select_recently_watched_by_username('Yvo')
**/

SELECT w.last_watched, e.id, e.name, e.description, se.number, sea.order_number, e.thumbnail, s.name name_series
FROM tbl_watchlist w
INNER JOIN tbl_episode e ON e.id = w.fk_episode
INNER JOIN tbl_season_episode se ON se.fk_episode = e.id
INNER JOIN tbl_season sea ON se.fk_season = sea.id
INNER JOIN tbl_series s ON s.id = sea.fk_series
WHERE w.fk_user = (SELECT u.id from tbl_user u where u.username = d_username)
ORDER BY w.last_watched desc
LIMIT 4;

END$$

DELIMITER ;
