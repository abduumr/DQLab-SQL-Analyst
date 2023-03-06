-- 1 | tampilkan daftar produk yang memiliki harga antara 50.000 and 150.000.
------
SELECT * FROM ms_produk
WHERE harga BETWEEN 50000 AND 150000

------------------------------------------------------------------------------------------------------------------
-- 2 | Tampilkan semua produk yang mengandung kata Flashdisk.
------
SELECT * FROM ms_produk
WHERE nama_produk LIKE 'Flashdisk%' 

------------------------------------------------------------------------------------------------------------------
-- 3 | Tampilkan hanya nama-nama pelanggan yang hanya memiliki gelar-gelar berikut: S.H, Ir. dan Drs.
------

SELECT  no_urut, 
		kode_pelanggan, 
		nama_pelanggan, 
		alamat 
FROM ms_pelanggan 
WHERE nama_pelanggan LIKE '%S.H.' OR
	  nama_pelanggan LIKE 'Ir.%' OR
	  nama_pelanggan LIKE '%Drs.'

------------------------------------------------------------------------------------------------------------------
-- 4 | Tampilkan nama-nama pelanggan dan urutkan hasilnya berdasarkan kolom nama_pelanggan 
------ dari yang terkecil ke yang terbesar (A ke Z).

SELECT nama_pelanggan 
FROM ms_pelanggan 
ORDER BY nama_pelanggan ASC

------------------------------------------------------------------------------------------------------------------
-- 5 | Tampilkan nama-nama pelanggan dan urutkan hasilnya berdasarkan kolom nama_pelanggan 
------ dari yang terkecil ke yang terbesar (A ke Z). namun gelar tidak boleh menjadi bagian dari urutan.

SELECT nama_pelanggan
FROM ms_pelanggan
ORDER BY
 CASE WHEN LEFT(nama_pelanggan,3) = 'Ir.' THEN substring(nama_pelanggan,5,100) 
 ELSE nama_pelanggan END asc;

------------------------------------------------------------------------------------------------------------------
-- 6 | Tampilkan nama pelanggan yang memiliki nama paling panjang. Jika ada lebih dari 1 orang yang memiliki panjang nama 
------ yang sama,  tampilkan semuanya.


	SELECT top 1 len(nama_pelanggan) , nama_pelanggan
	FROM ms_pelanggan a
	order by 1 asc 

	SELECT top 1 len(nama_pelanggan) , nama_pelanggan
	FROM ms_pelanggan 
	order by 1 desc



------------------------------------------------------------------------------------------------------------------
-- 7 | Tampilkan produk yang paling banyak terjual dari segi kuantitas. Jika ada lebih dari 1 produk dengan nilai yang sama, 
------ tampilkan semua produk tersebut. 

SELECT a.kode_produk, 
	   a.nama_produk,
	   SUM(b.qty) AS total_qty
FROM ms_produk a
JOIN tr_penjualan_detail b
ON a.kode_produk = b.kode_produk
GROUP BY a.kode_produk, 
		 a.nama_produk
HAVING SUM (b.qty) = 7

------------------------------------------------------------------------------------------------------------------
-- 8 | Siapa saja pelanggan yang paling banyak menghabiskan uangnya untuk belanja? 
------ Jika ada lebih dari 1 pelanggan dengan nilai yang sama, tampilkan semua pelanggan tersebut.

SELECT a.kode_pelanggan,
	   a.nama_pelanggan,
	   sum(c.harga_satuan * c.qty) as total_harga
FROM ms_pelanggan a
JOIN tr_penjualan b 
ON a.kode_pelanggan = b.kode_pelanggan
JOIN tr_penjualan_detail c 
ON b.kode_transaksi = c.kode_transaksi
GROUP BY a.kode_pelanggan,
		 a.nama_pelanggan
ORDER BY total_harga desc



------------------------------------------------------------------------------------------------------------------
-- 8 | Tampilkan daftar pelanggan yang belum pernah melakukan transaksi.
------  

SELECT  a.kode_pelanggan,
		a.nama_pelanggan,
	    a.alamat
FROM ms_pelanggan a
WHERE  a.kode_pelanggan NOT IN (SELECT kode_pelanggan FROM tr_penjualan)


------------------------------------------------------------------------------------------------------------------
-- 9 | tampilkan transaksi-transaksi yang memiliki jumlah baris data pada table tr_penjualan_detail lebih dari satu.
------  
Tampilkan transaksi-transaksi yang memiliki jumlah item produk lebih dari 1 jenis produk. Dengan lain kalimat, 
tampilkan transaksi-transaksi yang memiliki jumlah baris data pada table tr_penjualan_detail lebih dari satu.

SELECT	a.kode_transaksi,
		a.kode_pelanggan,
		b.nama_pelanggan,
		a.tanggal_tran AS tanggal_transaksi,
		count(c.kode_produk) as jumlah_detail
FROM tr_penjualan a
JOIN ms_pelanggan b 
ON a.kode_pelanggan = b.kode_pelanggan 
JOIN tr_penjualan_detail c 
ON a.kode_transaksi = c.kode_transaksi
GROUP BY a.kode_transaksi,
		 a.kode_pelanggan,
		 b.nama_pelanggan,
		 a.tanggal_tran
HAVING count(c.kode_produk) > 1

