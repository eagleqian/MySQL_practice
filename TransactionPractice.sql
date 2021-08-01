CREATE TABLE transfer (
    `id` INT(5) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(20) NOT NULL,
    `money` DECIMAL(8 , 2 ) NOT NULL,
    PRIMARY KEY (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=utf8mb4;

-- insert the values 
INSERT INTO transfer ( `name`, `money`) VALUES ('eagle', '2000.00'),('tiger','10000.00');

-- transfer transaction

-- close autocommit
SET autocommit = 0;

-- START transaction
START TRANSACTION;-- open a transaction

UPDATE transfer 
SET 
    money = money - 500
WHERE
    id = 1;
    
UPDATE transfer 
SET 
    money = money + 500
WHERE
    id = 2;

-- COMMIT transaciton IF success  
COMMIT; -- once the THRANSACTION is committed, the data persistence is finished

-- ROLLBACK transaction IF fail
ROLLBACK;

-- CLOSE autocommit
SET autocommit = 1;

-- show the table
SELECT * FROM business.transfer;

-- show the state of autocommit
show session variables like 'autocommit';

-- drop the table
DROP TABLE transfer;