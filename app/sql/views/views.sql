CREATE VIEW select_all_series AS
SELECT *
FROM tbl_series
ORDER BY name;

CREATE VIEW select_all_users AS
SELECT *
FROM tbl_user;
