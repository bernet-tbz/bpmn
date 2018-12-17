DROP PROCEDURE IF EXISTS search_series_by_name;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE search_series_by_name (
    IN d_search_name VARCHAR(255)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Select src by id of episoe
  Call: call search_series_by_name('The Walking Dead')
**/
SET @search = d_search_name;
SELECT name, description, genre, thumbnail FROM tbl_series
  WHERE name LIKE '%' + @search + '%';
END$$

DELIMITER ;
