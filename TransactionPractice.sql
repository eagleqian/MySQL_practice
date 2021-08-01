CREATE TABLE transfer(
`id` INT(5) NOT NULL AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL,
`money` DECIMAL(8,2) NOT NULL,
PRIMARY KEY (`id`)
);

-- insert the values 
INSERT INTO transfer ( `name`, `money`) VALUES ('eagle', '2000.00'),('tiger','10000.00');

-- transfer transaction

-- close autocommit
SET autocommit = 0;

-- START transaction
START TRANSACTION  -- open a transaction

UPDATE 


