-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 24. Jan 2018 um 19:15
-- Server-Version: 10.1.19-MariaDB
-- PHP-Version: 5.6.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `stream_dream5`
--
DROP DATABASE stream_dream5;
CREATE DATABASE IF NOT EXISTS `stream_dream5` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `stream_dream5`;

DELIMITER $$
--
-- Prozeduren
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_episode` (IN `d_name` VARCHAR(255), IN `d_thumbnail` VARCHAR(255), IN `d_src` VARCHAR(255), IN `d_description` TEXT, IN `d_released` VARCHAR(255), IN `d_year` INT(4), IN `d_country` VARCHAR(255), IN `d_language` VARCHAR(255))  BEGIN



INSERT INTO tbl_episode (name, thumbnail, src, description, released, year, country, language)
  SELECT d_name, d_thumbnail, d_src, d_description, d_released, d_year, d_country, d_language FROM DUAL
    WHERE NOT EXISTS
      (SELECT name FROM tbl_episode
        WHERE name = d_name
        AND description = d_description);
  SET @last_id = LAST_INSERT_ID();
  SELECT @last_id AS last_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_season` (IN `d_series_name` VARCHAR(255), IN `d_name` VARCHAR(255), IN `d_order_number` INT(10))  BEGIN



INSERT INTO tbl_season (fk_series, name, order_number)
  SELECT (SELECT id FROM tbl_series ser WHERE ser.name = d_series_name), d_name, d_order_number FROM DUAL
    WHERE NOT EXISTS
      (SELECT name FROM tbl_season sea
        WHERE sea.order_number = d_order_number
        AND sea.fk_series = (SELECT id FROM tbl_series ser WHERE ser.name = d_series_name));
  SET @last_id = LAST_INSERT_ID();
  SELECT @last_id AS last_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_season_episode` (IN `d_fk_episode` INT(10), IN `d_name_series` VARCHAR(255), IN `d_number_season` INT(10), IN `d_number_episode` INT(10))  BEGIN



INSERT INTO tbl_season_episode (fk_episode, fk_season, number)
  SELECT d_fk_episode, (SELECT sea.id FROM tbl_season sea INNER JOIN tbl_series ser ON sea.fk_series = ser.id WHERE sea.order_number = d_number_season AND ser.name = d_name_series), d_number_episode
    WHERE NOT EXISTS
      (SELECT fk_episode FROM tbl_season_episode
        WHERE fk_episode = d_fk_episode
        AND fk_season = (SELECT sea.id FROM tbl_season sea INNER JOIN tbl_series ser ON sea.fk_series = ser.id WHERE sea.order_number = d_number_season AND ser.name = d_name_series)
        AND number = d_number_episode);
  SET @last_id = LAST_INSERT_ID();
  SELECT @last_id AS last_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_series` (IN `d_name` VARCHAR(255), IN `d_description` TEXT, IN `d_genre` VARCHAR(255), IN `d_thumbnail` VARCHAR(255))  BEGIN



INSERT INTO tbl_series (name, description, genre, thumbnail)
  SELECT d_name, d_description, d_genre, d_thumbnail FROM DUAL
    WHERE NOT EXISTS
      (SELECT name FROM tbl_series
        WHERE name = d_name);
  SET @inserted_id = (SELECT id FROM tbl_series WHERE name = d_name);
  SET @last_id = LAST_INSERT_ID();
  SELECT @last_id AS last_id, @inserted_id AS inserted_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_update_watchtime` (IN `d_fk_episode` INT(11), IN `d_username` VARCHAR(30), IN `d_plays_count` VARCHAR(30), IN `d_watch_time` VARCHAR(255))  BEGIN



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

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_user` (IN `d_username` VARCHAR(30), IN `d_password` VARCHAR(255), IN `d_email` VARCHAR(255))  BEGIN



INSERT INTO tbl_user (username, password, email)
  SELECT d_username, d_password, d_email FROM DUAL
    WHERE NOT EXISTS
      (SELECT username FROM tbl_user
        WHERE username = d_username
        OR email = d_email);
  SET @last_id = LAST_INSERT_ID();
  SELECT @last_id AS last_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_episodes_by_season_and_series` (IN `d_name_series` VARCHAR(255), IN `d_id_season` INT(11))  BEGIN



SELECT e.id, e.name, e.description, e.thumbnail, e.src, e.released, e.year, e.country, e.language, seaepi.number
FROM tbl_episode e
INNER JOIN tbl_season_episode seaepi ON e.id = seaepi.fk_episode
INNER JOIN tbl_season sea ON seaepi.fk_season = sea.id
INNER JOIN tbl_series ser ON sea.fk_series = ser.id
WHERE ser.id = (SELECT id FROM tbl_series WHERE tbl_series.name = d_name_series) AND sea.id = d_id_season
ORDER BY seaepi.number;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_episode_by_id` (IN `d_id_episode` INT(11))  BEGIN



SELECT e.id, e.name, e.description, e.thumbnail, e.src, e.released, e.year, e.country, e.language, seaepi.number, sea.name name_season, ser.name name_series, ser.description desc_series, sea.order_number
FROM tbl_episode e
INNER JOIN tbl_season_episode seaepi ON e.id = seaepi.fk_episode
INNER JOIN tbl_season sea ON seaepi.fk_season = sea.id
INNER JOIN tbl_series ser ON sea.fk_series = ser.id
WHERE e.id = d_id_episode;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_episode_src_by_id` (IN `d_id_episode` INT(11))  BEGIN



SELECT e.src FROM tbl_episode e WHERE id = d_id_episode;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_recently_watched_by_username` (IN `d_username` VARCHAR(30))  BEGIN



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

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_seasons_by_series` (IN `d_series_name` VARCHAR(255))  BEGIN



SELECT se.name series_name, sea.id, sea.fk_series, sea.name
FROM tbl_season sea
INNER JOIN tbl_series se ON se.id = sea.fk_series
WHERE sea.fk_series = (SELECT se.id from tbl_series se where se.name = d_series_name)
ORDER BY sea.order_number;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_src_by_id` (IN `d_episode_id` INT(11))  BEGIN



SELECT src FROM tbl_episode
  WHERE id = d_episode_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_user_by_name` (IN `d_username` VARCHAR(30))  BEGIN



SELECT * FROM tbl_user
  WHERE username = d_username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_watchtime_by_user_and_episode` (IN `d_id_episode` INT(11), IN `d_username` VARCHAR(30))  BEGIN



SELECT watch_time
FROM tbl_watchlist
WHERE fk_episode = d_id_episode
AND fk_user = (SELECT id FROM tbl_user WHERE username = d_username);

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `select_all_series`
--
CREATE TABLE `select_all_series` (
`id` int(10) unsigned
,`name` varchar(255)
,`description` text
,`genre` varchar(255)
,`thumbnail` varchar(255)
);

-- --------------------------------------------------------

--
-- Stellvertreter-Struktur des Views `select_all_users`
--
CREATE TABLE `select_all_users` (
`id` int(10) unsigned
,`username` varchar(30)
,`password` varchar(255)
,`email` varchar(255)
,`registration_date` timestamp
);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tbl_episode`
--

CREATE TABLE `tbl_episode` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `thumbnail` varchar(255) NOT NULL,
  `src` varchar(255) NOT NULL,
  `description` text,
  `released` varchar(255) DEFAULT NULL,
  `year` int(4) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tbl_season`
--

CREATE TABLE `tbl_season` (
  `id` int(10) UNSIGNED NOT NULL,
  `fk_series` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `order_number` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tbl_season_episode`
--

CREATE TABLE `tbl_season_episode` (
  `id` int(10) UNSIGNED NOT NULL,
  `fk_episode` int(10) UNSIGNED NOT NULL,
  `fk_season` int(10) UNSIGNED NOT NULL,
  `number` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tbl_series`
--

CREATE TABLE `tbl_series` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `genre` varchar(255) NOT NULL,
  `thumbnail` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tbl_user`
--

CREATE TABLE `tbl_user` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `registration_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tbl_watchlist`
--

CREATE TABLE `tbl_watchlist` (
  `id` int(10) UNSIGNED NOT NULL,
  `fk_episode` int(10) UNSIGNED DEFAULT NULL,
  `fk_user` int(10) UNSIGNED DEFAULT NULL,
  `plays_count` varchar(30) NOT NULL,
  `watch_time` varchar(255) NOT NULL,
  `last_watched` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struktur des Views `select_all_series`
--
DROP TABLE IF EXISTS `select_all_series`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `select_all_series`  AS  select `tbl_series`.`id` AS `id`,`tbl_series`.`name` AS `name`,`tbl_series`.`description` AS `description`,`tbl_series`.`genre` AS `genre`,`tbl_series`.`thumbnail` AS `thumbnail` from `tbl_series` order by `tbl_series`.`name` ;

-- --------------------------------------------------------

--
-- Struktur des Views `select_all_users`
--
DROP TABLE IF EXISTS `select_all_users`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `select_all_users`  AS  select `tbl_user`.`id` AS `id`,`tbl_user`.`username` AS `username`,`tbl_user`.`password` AS `password`,`tbl_user`.`email` AS `email`,`tbl_user`.`registration_date` AS `registration_date` from `tbl_user` ;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `tbl_episode`
--
ALTER TABLE `tbl_episode`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `tbl_season`
--
ALTER TABLE `tbl_season`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_series` (`fk_series`);

--
-- Indizes für die Tabelle `tbl_season_episode`
--
ALTER TABLE `tbl_season_episode`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_episode` (`fk_episode`),
  ADD KEY `fk_season` (`fk_season`);

--
-- Indizes für die Tabelle `tbl_series`
--
ALTER TABLE `tbl_series`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indizes für die Tabelle `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indizes für die Tabelle `tbl_watchlist`
--
ALTER TABLE `tbl_watchlist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_episode` (`fk_episode`),
  ADD KEY `fk_user` (`fk_user`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `tbl_episode`
--
ALTER TABLE `tbl_episode`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1123;
--
-- AUTO_INCREMENT für Tabelle `tbl_season`
--
ALTER TABLE `tbl_season`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;
--
-- AUTO_INCREMENT für Tabelle `tbl_season_episode`
--
ALTER TABLE `tbl_season_episode`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1223;
--
-- AUTO_INCREMENT für Tabelle `tbl_series`
--
ALTER TABLE `tbl_series`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT für Tabelle `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT für Tabelle `tbl_watchlist`
--
ALTER TABLE `tbl_watchlist`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;
--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `tbl_season`
--
ALTER TABLE `tbl_season`
  ADD CONSTRAINT `tbl_season_ibfk_1` FOREIGN KEY (`fk_series`) REFERENCES `tbl_series` (`id`);

--
-- Constraints der Tabelle `tbl_season_episode`
--
ALTER TABLE `tbl_season_episode`
  ADD CONSTRAINT `tbl_season_episode_ibfk_1` FOREIGN KEY (`fk_episode`) REFERENCES `tbl_episode` (`id`),
  ADD CONSTRAINT `tbl_season_episode_ibfk_2` FOREIGN KEY (`fk_season`) REFERENCES `tbl_season` (`id`);

--
-- Constraints der Tabelle `tbl_watchlist`
--
ALTER TABLE `tbl_watchlist`
  ADD CONSTRAINT `tbl_watchlist_ibfk_1` FOREIGN KEY (`fk_episode`) REFERENCES `tbl_episode` (`id`),
  ADD CONSTRAINT `tbl_watchlist_ibfk_2` FOREIGN KEY (`fk_user`) REFERENCES `tbl_user` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
