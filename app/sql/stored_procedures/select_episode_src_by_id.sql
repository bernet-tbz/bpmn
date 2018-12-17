DROP PROCEDURE IF EXISTS select_episode_src_by_id;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE select_episode_src_by_id (
  IN d_id_episode INT(11)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call select_episode_src_by_id(100001)
**/

SELECT e.src FROM tbl_episode e WHERE id = d_id_episode;

END$$

DELIMITER ;
