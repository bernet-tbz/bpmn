DROP PROCEDURE IF EXISTS select_watchtime_by_user_and_episode;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE select_watchtime_by_user_and_episode (
    IN d_id_episode INT(11)
  , IN d_username VARCHAR(30)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call select_watchtime_by_user_and_episode(100000, 'Yvo')
**/

SELECT watch_time
FROM tbl_watchlist
WHERE fk_episode = d_id_episode
AND fk_user = (SELECT id FROM tbl_user WHERE username = d_username);

END$$

DELIMITER ;
