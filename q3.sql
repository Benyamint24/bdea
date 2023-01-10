-- enable federated in DB. add federated in the config and restart service

federated

-- create table in remote db
CREATE TABLE federat_db.t (
  a int PRIMARY KEY AUTO_INCREMENT,
  b timestamp NOT NULL DEFAULT NOW(),
  c int NOT NULL 
  );

-- create a federated table:

CREATE TABLE federated_t (
  a int PRIMARY KEY AUTO_INCREMENT,
  b timestamp NOT NULL DEFAULT NOW(),
  c int NOT NULL 
)
ENGINE=FEDERATED
CONNECTION='mysql://username:password@hostname:port/federat_db/t';

-- the application also should change SELECT something like this:

select *  from t
UNION ALL
select *  from federated_t;

-- now we can move old data from the t table to the federated table:

CREATE DEFINER=`user`@`%` PROCEDURE `move_data_to_fed_sp`()
BEGIN
set @a = 1;      
set @b = 10000;  
WHILE @a < half_of_main_table DO

	SET @b = @a + 1; 
    SET @sql_text1 = concat('INSERT into federated_t select * from t where a >= ',@a,' and a < ',@b,'' );
    PREPARE stmt1 FROM @sql_text1;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;    
	
    SET @sql_text2 = concat('delete from t where a >= ',@a,' and a < ',@b,'' );
    PREPARE stmt1 FROM @sql_text1;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;   
	
    commit;
    SET @a = @a + 1; 
  END WHILE;
commit;
END
