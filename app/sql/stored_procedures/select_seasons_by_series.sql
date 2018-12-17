DROP PROCEDURE IF EXISTS select_seasons_by_series;
-- Stored Procedure
DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=root@localhost PROCEDURE select_seasons_by_series (
  IN d_series_name VARCHAR(255)
)
BEGIN

/**
  Author:		Yvo Keller
  Date:			Dezember 2017
  Version:	1.0

  Description: Insert New Season Into Database if it doesnt exist yet
  Call: call select_seasons_by_series('The Walking Dead')
**/

SELECT se.name series_name, sea.id, sea.fk_series, sea.name
FROM tbl_season sea
INNER JOIN tbl_series se ON se.id = sea.fk_series
WHERE sea.fk_series = (SELECT se.id FROM tbl_series se where se.name = d_series_name)
ORDER BY sea.order_number;

END$$

DELIMITER ;
