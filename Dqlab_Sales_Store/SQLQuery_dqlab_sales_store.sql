SELECT * FROM dqlab_sales_store

----------------------------------------------------------------------------------------------------
--Convert order_date dari 2012-10-25 00:00:00.000 menjadi 2012-10-25 

ALTER TABLE dqlab_sales_store
ADD order_date_ Date 

UPDATE dqlab_sales_store
SET order_date_ = CONVERT(Date,order_date)

------------------------------------------------------------------------------------------------------
-- kita pecah order_date_ 2012-10-25 menjadi tahun bulan dan tanggal
SELECT order_date_ ,
    YEAR(order_date_) AS tahun,
    MONTH(order_date_) AS bulan,
    DAY(order_date_) AS tanggal
FROM dqlab_sales_store;

--tahun
ALTER TABLE dqlab_sales_store
ADD tahun int 

UPDATE dqlab_sales_store
SET tahun = YEAR(order_date_)

--Month

ALTER TABLE dqlab_sales_store
ADD bulan int 

UPDATE dqlab_sales_store
SET bulan = MONTH(order_date_)

-- tanggal

ALTER TABLE dqlab_sales_store
ADD tanggal int 

UPDATE dqlab_sales_store
SET tanggal =  DAY(order_date_)

------------------------------------------------------------------------------------------------------
-- Menghapus column yang gk perlu
ALTER TABLE dqlab_sales_store DROP COLUMN [order];
ALTER TABLE dqlab_sales_store DROP COLUMN [order_date];

SELECT * FROM dqlab_sales_store

------------------------------------------------------------------------------------------------------

-- perofrmance DQLab Store dari tahun 2009 - 2012 untuk jumlah order dan total sales order finished

SELECT  tahun , 
		SUM(sales) sales , 
		COUNT(order_id ) as  number_of_order
FROM dqlab_sales_store
where status = 'Finished'
group by tahun
order by 1 asc

-- performance DQLab by subcategory product yang akan dibandingkan antara tahun 2011 dan tahun 2012

SELECT	tahun,
		product_sub_category , 
		SUM(sales) sales
FROM dqlab_sales_store
where status = 'Finished'
group by tahun , product_sub_category
having tahun > 2010
order by 1 asc , 3 desc

------------------------------------------------------------------------------------------------------
-- analisa terhadap efektifitas dan efisiensi dari promosi yang sudah dilakukan selama ini
-- Efektifitas dan efisiensi dari promosi yang dilakukan akan dianalisa berdasarkan Burn Rate yaitu dengan membandigkan total 
-- value promosi yang dikeluarkan terhadap total sales yang diperoleh

-- Formula untuk burn rate : (total discount / total sales) * 100

SELECT  tahun,
		sales,
		promotion_value,
		ROUND((promotion_value/sales)*100,2) AS burn_rate_percentage
FROM (
SELECT	tahun ,
		SUM(discount_value) AS promotion_value,
		SUM(sales) AS sales
FROM dqlab_sales_store
WHERE status = 'Finished'
GROUP BY tahun
)a
ORDER BY 1

------------------------------------------------------------------------------------------------------
--Promotion Effectiveness and Efficiency by Product Sub Category

--Pada bagian ini kita akan melakukan analisa terhadap efektifitas dan efisiensi dari promosi yang sudah dilakukan 
--selama ini seperti pada bagian sebelumnya.Akan tetapi, ada kolom yang harus ditambahkan, yaitu : product_sub_category
--dan product_category


SELECT	tahun,
		product_sub_category,
		product_category,
		sales,
		promotion_value,
		ROUND((promotion_value/sales)*100,2) AS burn_rate_percentage
FROM (
SELECT	ROUND(AVG(tahun),0) AS tahun,
		product_category,
		product_sub_category,
		SUM(discount_value) AS promotion_value,
		SUM(sales) AS sales
FROM dqlab_sales_store
WHERE status = 'Finished' AND tahun = '2012'	
GROUP BY product_category,
		 product_sub_category) a
ORDER BY 4 DESC

------------------------------------------------------------------------------------------------------

--Customers Transactions per Year
--DQLab Store ingin mengetahui jumlah customer (number_of_customer) yang bertransaksi setiap tahun dari 2009 sampai 2012 (years).

SELECT	tahun,	
		COUNT(DISTINCT customer) AS number_of_customer	
FROM dqlab_sales_store	
WHERE status = 'Finished'	
GROUP BY tahun	
ORDER BY 1	