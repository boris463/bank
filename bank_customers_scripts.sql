-- premenovanie stlpcov---------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE bank_customers
RENAME COLUMN `Income` TO `income`;

-- hladanie duplicitnych zaznamov---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT age, experience, income, zip_code, family, credit_score, education, mortgage, personal_loan,
securities_account, cd_account, `online`, credit_card,
	ROW_NUMBER() OVER(PARTITION BY age, experience, income, zip_code, family, credit_score, education, mortgage, personal_loan,
	securities_account, cd_account, `online`, credit_card ) as row_num
FROM bank_customers;

WITH duplicate_cte AS
(
	SELECT age, experience, income, zip_code, family, credit_score, education, mortgage, personal_loan,
	securities_account, cd_account, `online`, credit_card,
		ROW_NUMBER() OVER(PARTITION BY age, experience, income, zip_code, family, credit_score, education, mortgage, personal_loan,
		securities_account, cd_account, `online`, credit_card ) as row_num
	FROM bank_customers
)

SELECT * FROM duplicate_cte
WHERE row_num > 1;

-- normalizovanie stlpca experience nakolko zakaznici nemozu mat negativnu hodnotu v pocte rokov skusenosti-------------------------------------------------
SELECT * 
FROM bank_customers
WHERE experience < 0
ORDER BY experience;

UPDATE bank_customers
SET experience = 1
WHERE experience = -1;

UPDATE bank_customers
SET experience = 2
WHERE experience = -2;

UPDATE bank_customers
SET experience = 3
WHERE experience = -3;



-- kpis---------------------------------------------------------------------------------------------------------------------------------------------------
SELECT count(id) as customers_count
FROM bank_customers;

SELECT SUM(`online`) as online_banking_users, SUM(`online`)/COUNT(id)*100 as `%`
FROM bank_customers;

SELECT SUM(securities_account) as investing_accounts, SUM(securities_account)/COUNT(id)*100 as `%`
FROM bank_customers;

SELECT SUM(cd_account) as savings_accounts , SUM(cd_account)/COUNT(id)*100 as `%`
FROM bank_customers;

SELECT SUM(mortgage) as total_debt_lent
FROM bank_customers;

SELECT COUNT(mortgage) as mortgage_accounts
FROM bank_customers
WHERE mortgage > 0;

SELECT ( SELECT COUNT(mortgage) as mortgage_accounts
		FROM bank_customers
		WHERE mortgage > 0) as mrtg_acc, 
        (SELECT COUNT(mortgage) as mortgage_accounts
		FROM bank_customers
		WHERE mortgage > 0) /COUNT(id)*100 as `%`
FROM bank_customers;

SELECT SUM(personal_loan) as ploan_accounts, SUM(personal_loan)/COUNT(id)*100 as `%`
FROM bank_customers;

SELECT SUM(credit_card) as credit_users, SUM(credit_card)/COUNT(id)*100 as `%`
FROM bank_customers;





SELECT * 
FROM bank_customers
WHERE personal_loan > 0 AND securities_account > 0 AND cd_account > 0;

