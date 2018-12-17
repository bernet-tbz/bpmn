DROP PROCEDURE IF EXISTS select_src_by_id;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE select_src_by_id (
    IN d_episode_id INT(11)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Select src by id of episoe
  Call: call select_src_by_id(696)
**/

SELECT src FROM tbl_episode
  WHERE id = d_episode_id;
END$$

DELIMITER ;
