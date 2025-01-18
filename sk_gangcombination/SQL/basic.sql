ALTER TABLE `users`
ADD COLUMN `gang` VARCHAR(50) NOT NULL DEFAULT 'none',
ADD COLUMN `gang_grade` INT NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS `gangs` (
  `name`  VARCHAR(50) NOT NULL,
  `label` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`name`)
);

CREATE TABLE IF NOT EXISTS `gang_grades` (
  `id`          INT AUTO_INCREMENT,
  `gang_name`   VARCHAR(50) NOT NULL,
  `grade`       INT NOT NULL DEFAULT 0,
  `name`        VARCHAR(50) NOT NULL,
  `label`       VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY (`gang_name`)
);

