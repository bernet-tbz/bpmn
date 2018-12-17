DROP PROCEDURE IF EXISTS select_user_by_name;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE select_user_by_name (
    IN d_username VARCHAR(30)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call select_user_by_name('Yvo')
**/

SELECT * FROM tbl_user
  WHERE username = d_username;
END$$

DELIMITER ;
