-- Active: 1679547298233@@127.0.0.1@3306@db_name
CREATE DEFINER=`root`@`localhost` PROCEDURE `SALES_TRANFORMATION`()
BEGIN

  CREATE TABLE if not exists SALES_TRANSFORM(
	 NAME varchar(100),
	 PRODUCT_NAME varchar(100),
	 QUANTITY integer,
	 AMOUNT float
	);
	
	truncate table SALES_TRANSFORM;

	INSERT INTO SALES_TRANSFORM select C.NAME, P.PRODUCT_NAME,S.QUANTITY,S.AMOUNT from PRODUCT P
	inner join SALES S on P.P_ID=S.P_ID
	inner join CUSTOMER C on C.C_ID=S.C_ID;
END