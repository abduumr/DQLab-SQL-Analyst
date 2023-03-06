
3. Untuk pelaksanaan year-end sale pada minggu keempat, dibutuhkan data penjualan berupa rata-rata jumlah transaksi 
(dalam rupiah) dan jumlah produk terjual untuk mempersiapkan stok barang yang akan dijual.
-------------------------------------------------------------------------------------------------------------------------------
-- 1.| Data pelanggan (customer_id) dengan rata-rata pembelian lebih dari Rp 1.000.000,- per produk akan berhak untuk mendapatkan
------ diskon belanja di year-end sale.

SELECT DISTINCT Customer_ID, 
				Product,
				Average_transaction
FROM summary_transaction
WHERE Average_transaction >= 1000000 

-------------------------------------------------------------------------------------------------------------------------------
-- 2.| kriteria yang disediakan :
------
-------------------------------------------------------------------------------------------------------------------------------
1. Customer yang memiliki rata-rata transaksi lebih dari 2 juta dan jumlah transaksi lebih dari 30 kali
   akan menjadi “Platinum member.”
2. Customer yang memiliki rata-rata transaksi 1-2 juta dan jumlah transaksi 20-30 kali akan menjadi “Gold Member.”
3. Customer dengan rata-rata transaksi kurang dari 1 juta dan jumlah transaksi kurang dari 20x kali akan 
   menjadi “Silver Member.”
-------------------------------------------------------------------------------------------------------------------------------


SELECT DISTINCT Customer_ID,
				Product,
				Average_Transaction,
				Count_Transaction,
	CASE
		WHEN Average_transaction > 2000000 and Count_Transaction > 30 then 'Platinum Member'
		WHEN Average_transaction between 1000000 and 2000000 and Count_Transaction between 20 and 30 then 'Gold Member'
		WHEN Average_transaction < 1000000 and Count_Transaction <20 then 'Silver Member'
		ELSE 'Other Membership' 
	END as Membership
FROM summary_transaction

-------------------------------------------------------------------------------------------------------------------------------
-- 3.| Customer akan dikirimkan email marketing berdasarkan total transaksi mereka.  
------ 
-------------------------------------------------------------------------------------------------------------------------------
4-5 email dalam seminggu untuk customer dengan rata-rata transaksi kurang dari 1.000.000.
1-2 email dalam seminggu untuk Customer loyal dengan rata-rata transaksi lebih dari 1.000.000 akan dikirimkan 
beserta dengan kode voucher diskon.
-------------------------------------------------------------------------------------------------------------------------------

SELECT DISTINCT
Customer_ID,
Product,
Average_transaction,
Count_Transaction,
CASE
	when Average_transaction < 1000000 then '4-5x Email dalam seminggu'
    when Average_transaction > 1000000 then '1-2x Email dalam seminggu'
END AS frekuensi_email
FROM summary_transaction

-------------------------------------------------------------------------------------------------------------------------------
-- 4.| daftar customer yang akan dikirimi 4-5 email untuk produk sepatu dalam seminggu
------ 
SELECT DISTINCT Customer_ID
FROM summary_transaction
WHERE Average_transaction < 1000000 and product =  'Sepatu';

-------------------------------------------------------------------------------------------------------------------------------
-- 5.| Menyiapkan Report Penjualan
------
SELECT  DISTINCT Product Produk,
		avg(Average_transaction) 'Jumlah transaksi (Rupiah)',
		sum(Count_Transaction) 'Barang terjual'
FROM summary_transaction
GROUP BY Product


-------------------------------------------------------------------------------------------------------------------------------
-- 6.| menampilkan customer yang pernah berbelanja di 3 (tiga) produk berbeda dan rata-rata pembelanjaan dari ketiga produk
------ / lebih produk tersebut lebih dari Rp 1.500.000,-.

SELECT DISTINCT Customer_ID
FROM [DQLab].[dbo].[data_retail_undian]
WHERE Unik_produk >= 1 and Rata_rata_transaksi >= 1500000

-------------------------------------------------------------------------------------------------------------------------------
-- 7.| Customer lain di luar kriteria diatas berhak untuk mengikuti undian 3 (tiga) voucher belanja sebesar 500 ribu rupiah 
------ untuk customer yang beruntung. 

SELECT DISTINCT Customer_ID
FROM data_retail_undian
WHERE NOT (Unik_produk >= 3 and Rata_rata_transaksi >= 1500000)