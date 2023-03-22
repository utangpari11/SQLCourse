
CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_year`( calendar_date date 
) RETURNS int
    DETERMINISTIC
BEGIN
	DECLARE fiscal_year INT;
    SET fiscal_year = YEAR(date_add(calendar_date,interval 4 month));
RETURN fiscal_year;
END
----------------------------
 CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_quarter`(calender_date date) RETURNS char(2) CHARSET latin1
    DETERMINISTIC
BEGIN
	DECLARE mn tinyint;
    DECLARE qtr char(2);
    SET mn = MONTH(calender_date);
    case 
		when mn IN (1,2,3) then SET qtr="Q1";
		when mn IN (4,5,6) then SET qtr="Q2";
		when mn IN (7,8,9) then SET qtr="Q3";
	else 
		 SET qtr="Q4";
	end case;
RETURN qtr;
END 