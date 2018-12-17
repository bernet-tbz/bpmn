DROP PROCEDURE IF EXISTS insert_user;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE insert_user (
    IN d_username VARCHAR(30)
  , IN d_password VARCHAR(255)
  , IN d_email VARCHAR(255)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call insert_user('Yvo', 'huieadfe9asidfsadfheade31', 'keller.yvo@gmail.com')
**/

INSERT INTO tbl_user (username, password, email)
  SELECT d_username, d_password, d_email FROM DUAL
    WHERE NOT EXISTS
      (SELECT username FROM tbl_user
        WHERE username = d_username
        OR email = d_email);
  SET @last_id = LAST_INSERT_ID();
  SELECT @last_id AS last_id;
END$$

DELIMITER ;
