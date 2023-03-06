-- 1 | 10 Transaksi terbesar user 12476
------

SELECT	TOP 10 seller_id, 
		buyer_id, 
		total AS nilai_transaksi, 
		created_at AS tanggal_transaksi
FROM orders
WHERE buyer_id = 12476
ORDER BY 3 DESC

---------------------------------------------------------------------------------------------------
-- 2 | Transaksi per bulan di tahun 2020.
------
SELECT	CONVERT(varchar(4), YEAR(created_at)) + '-' + CONVERT(varchar(2), MONTH(created_at)) AS tahun_bulan,
		COUNT(1) AS jumlah_transaksi, 
		SUM(total) AS total_nilai_transaksi
FROM orders
WHERE created_at >= '2020-01-01'
GROUP BY CONVERT(varchar(4), YEAR(created_at)) + '-' + CONVERT(varchar(2), MONTH(created_at)) 
ORDER BY 1

---------------------------------------------------------------------------------------------------
-- 3 | Pengguna dengan rata-rata transaksi terbesar di Januari 2020
------ 10 pembeli dengan rata-rata nilai transaksi terbesar yang bertransaksi minimal 2 kali di Januari 2020.

SELECT	TOP 10 buyer_id, 
		COUNT(1) AS jumlah_transaksi, 
		AVG(total) AS avg_nilai_transaksi
FROM orders
WHERE created_at> = '2020-01-01' AND created_at < '2020-02-01'
group by buyer_id
having COUNT(1) >= 2 
order by 3 desc

---------------------------------------------------------------------------------------------------
-- 4 | Transaksi besar di Desember 2019
------  nilai transaksi minimal 20,000,000 di bulan Desember 2019,

SELECT	b.nama_user AS nama_pembeli, 
		a.total AS nilai_transaksi, 
		a.created_at AS tanggal_transaksi
FROM orders a
INNER JOIN users b 
ON a.buyer_id = b.user_id
WHERE created_at>='2019-12-01' AND created_at<'2020-01-01' AND total >=20000000
order by 1

---------------------------------------------------------------------------------------------------
-- 5 | Kategori Produk Terlaris di 2020
------ menampilkan 5 Kategori dengan total quantity terbanyak di tahun 2020, transaksi yang sudah terkirim ke pembeli

SELECT	TOP 5 category, 
		SUM(quantity) AS total_quantity, 
		SUM(price) AS total_price
FROM orders a
INNER JOIN order_details b
ON  a.order_id = b.order_id
INNER JOIN products c
ON  b.product_id = c.product_id
WHERE created_at >='2020-01-01' AND delivery_at IS NOT NULL
GROUP BY category
ORDER BY 2 DESC

---------------------------------------------------------------------------------------------------
-- 6 | Mencari pembeli high value
------ mencari pembeli yang sudah bertransaksi lebih dari 5 kali, dan setiap transaksi lebih dari 2,000,000.

SELECT	nama_user AS nama_pembeli, 
		COUNT(1) AS jumlah_transaksi, 
		SUM(total) AS total_nilai_transaksi,
		MIN(total) AS min_nilai_transaksi
FROM orders a
INNER JOIN  users b
ON a.buyer_id = b.user_id
GROUP BY user_id, nama_user
HAVING COUNT(1) > 5 AND MIN (total)>2000000
ORDER BY 3 DESC

---------------------------------------------------------------------------------------------------
-- 7 | Mencari Dropshipper
------ mencari tahu pengguna yang menjadi dropshipper, yakni pembeli yang membeli barang akan tetapi dikirim 
------ ke orang lain. Ciri-cirinya yakni transaksinya banyak, dengan alamat yang berbeda-beda.

SELECT	nama_user AS nama_pembeli, 
		COUNT(1) AS jumlah_transaksi,
		COUNT(DISTINCT a.kodepos) AS distinct_kodepos, 
		SUM(total) AS total_nilai_transaksi,
		AVG(total) AS avg_nilai_transaksi
FROM orders a
INNER JOIN users b
ON a.buyer_id = b.user_id
GROUP BY user_id, nama_user
HAVING COUNT(1) >= 10 and COUNT(1) = COUNT(DISTINCT a.kodepos)
ORDER BY 2 DESC

---------------------------------------------------------------------------------------------------
-- 8 | Mencari Reseller Offline
------ Selanjutnya, akan dicari tahu jenis pengguna yang menjadi reseller offline atau punya toko offline, yakni pembeli yang 
------ sering sekali membeli barang dan seringnya dikirimkan ke alamat yang sama. Pembelian juga dengan quantity produk yang 
------ banyak. Sehingga kemungkinan barang ini akan dijual lagi

SELECT	nama_user AS nama_pembeli, 
		COUNT(1) AS jumlah_transaksi, 
		SUM (total) AS total_nilai_transaksi, 
		AVG(total) AS avg_nilai_transaksi, 
		AVG(total_quantity) AS avg_quantity_per_transaksi
FROM orders a
INNER JOIN users b 
on a.buyer_id = b.user_id
INNER JOIN (SELECT order_id, SUM(quantity) AS total_quantity FROM order_details  GROUP BY order_id) c
ON a.order_id = c.order_id
WHERE a.kodepos = b.kodepos 
GROUP BY user_id, nama_user
HAVING COUNT(1)> = 8  AND AVG(total_quantity) > 10
order by 3 desc



---------------------------------------------------------------------------------------------------
-- 9 | Pembeli sekaligus penjual
------ mencari penjual yang juga pernah bertransaksi sebagai pembeli minimal 7 kali.

SELECT	nama_user AS nama_pengguna, 
		jumlah_transaksi_beli, 
		jumlah_transaksi_jual
FROM users a
INNER JOIN (SELECT buyer_id, COUNT(1) as jumlah_transaksi_beli FROM orders GROUP BY buyer_id) b
ON b.buyer_id = a.user_id
INNER JOIN (SELECT seller_id, COUNT(1) as jumlah_transaksi_jual FROM orders GROUP BY seller_id) c
ON c.seller_id = a.user_id
WHERE jumlah_transaksi_beli >= 7
ORDER BY 1

---------------------------------------------------------------------------------------------------
-- 10 | Lama transaksi dibayar
------ lama waktu transaksi dibayar sejak dibuat.
------ Menghitung rata-rata lama waktu dari transaksi dibuat sampai dibayar, dikelompokkan per bulan.

select	CONVERT(varchar(4), YEAR(created_at)) + '-' + CONVERT(varchar(2), MONTH(created_at)) AS tahun_bulan,
		count(1) as jumlah_transaksi, 
		AVG(DATEDIFF(day, created_at, paid_at)) as avg_lama_dibayar,
		min(DATEDIFF(day, created_at, paid_at)) min_lama_dibayar,
		max(DATEDIFF(day, created_at, paid_at)) max_lama_dibayar
from orders
--where paid_at is not null
group by CONVERT(varchar(4), YEAR(created_at)) + '-' + CONVERT(varchar(2), MONTH(created_at)) 
order by 1

