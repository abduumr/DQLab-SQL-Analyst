1. Bagaimana pertumbuhan penjualan saat ini?
2. Apakah jumlah customers xyz.com semakin bertambah ?
3. Dan seberapa banyak customers tersebut yang sudah melakukan transaksi?
4. Category produk apa saja yang paling banyak dibeli oleh customers?
5. Seberapa banyak customers yang tetap aktif bertransaksi?

--------------------------------------------------------------------------------------------------------
SELECT * FROM customer  
SELECT * FROM orders_1  -- Quarter-1 (Jan, Feb, Mar) dan 
SELECT * FROM orders_2  -- Quarter-2 (Apr,Mei,Jun)

--------------------------------------------------------------------------------------------------------
-- 1 | Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)
------
SELECT  SUM(quantity) AS total_penjualan, 
		SUM(priceEach * quantity) as revenue 
FROM orders_1 
WHERE status = 'Shipped'

SELECT	SUM(quantity) AS total_penjualan, 
		SUM(priceEach * quantity) as revenue
FROM orders_2 
WHERE status = 'Shipped'

--------------------------------------------------------------------------------------------------------
-- 2 | Total Penjualan dan Revenue pada Quarter-1 dan Quarter-2 dan menggabungkanya
------

SELECT	quarter, 
		SUM(quantity) AS total_penjualan, 
		SUM(priceEach * quantity) as revenue
FROM (
SELECT	orderNumber, 
		status, 
		quantity, 
		priceEach, 
		'1' as quarter 
FROM orders_1
UNION 
SELECT	orderNumber, 
		status, 
		quantity,priceEach, 
		'2' as quarter 
FROM orders_2) AS tabel_a
WHERE status = 'Shipped'
GROUP BY quarter
---------------------------------------------------------------------------------
					Q2 - Q1 / Q1												|
%Growth Penjualan = (6717–8694)/8694 = -22%										|
																				|
					Q2 - Q1 / Q1												|
%Growth Revenue = (607548320–799579310)/ 799579310 = -24%						|
---------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------
-- 3 | mengubah format tanggal dari 2004-03-30 00:00:00.000 menjadi 2004-03-30 di tabel Customer
------

ALTER TABLE customer
ADD create_Date Date 

UPDATE customer
SET create_Date = CONVERT(Date,createDate)

--------------------------------------------------------------------------------------------------------
-- 4 | Apakah jumlah customers xyz.com semakin bertambah?
------
SELECT	quarter, 
		COUNT(DISTINCT customerID) AS total_customers
FROM (
SELECT	customerID, 
		createDate, 
		DATEPART(quarter,create_Date) AS quarter
FROM customer
WHERE create_Date BETWEEN '2004-01-01' AND '2004-07-01') as tabel_b
GROUP BY quarter

--------------------------------------------------------------------------------------------------------
-- 5 | Seberapa banyak customers tersebut yang sudah melakukan transaksi?
------

SELECT	quarter, 
		COUNT(DISTINCT customerID) AS total_customers
FROM (
SELECT	customerID, 
		createDate, 
		DATEPART(quarter,createDate) AS quarter
FROM customer
WHERE createDate BETWEEN '2004-01-01' AND '2004-07-01') AS tabel_b
WHERE customerID IN (
SELECT DISTINCT customerID FROM orders_1
UNION
SELECT DISTINCT customerID FROM orders_2)
GROUP BY quarter


--------------------------------------------------------------------------------------------------------
-- 6 | Category produk apa saja yang paling banyak di-order oleh customers di Quarter-2?
------

SELECT * 
FROM (
SELECT	categoryID, 
		COUNT(DISTINCT orderNumber) AS total_order, 
		SUM(quantity) AS total_penjualan
FROM ( SELECT	productCode, 
				orderNumber, quantity, 
				status, LEFT(productCode,3) AS categoryID
		FROM orders_2
		WHERE status = 'Shipped') tabel_c
GROUP BY categoryID ) a 
ORDER BY total_order DESC

--------------------------------------------------------------------------------------------------------
-- 7 | Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya?
------

--#Menghitung total unik customers yang transaksi di quarter_1 = output  25
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;

SELECT	'1' AS quarter,
		(COUNT(DISTINCT customerID) * 100) / 25 AS Q2
FROM orders_1
WHERE customerID IN( SELECT DISTINCT customerID
					FROM orders_2 )

