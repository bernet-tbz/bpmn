DROP PROCEDURE IF EXISTS insert_update_watchtime;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE insert_update_watchtime (
    IN d_fk_episode INT(11)
  , IN d_username VARCHAR(30)
  , IN d_plays_count VARCHAR(30)
  , IN d_watch_time VARCHAR(255)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call insert_update_watchtime(100000, 'Yvo', 3, '422')
**/

INSERT INTO tbl_watchlist(fk_episode, fk_user, plays_count, watch_time)
SELECT d_fk_episode, (SELECT id FROM tbl_user WHERE username = d_username), d_plays_count, d_watch_time FROM DUAL
  WHERE NOT EXISTS
    (SELECT id FROM tbl_watchlist
      WHERE fk_episode = d_fk_episode
      AND fk_user = (SELECT id FROM tbl_user WHERE username = d_username));

UPDATE tbl_watchlist
SET watch_time = d_watch_time
WHERE fk_user = (SELECT id FROM tbl_user WHERE username = d_username)
AND fk_episode = d_fk_episode;

END$$

DELIMITER ;
