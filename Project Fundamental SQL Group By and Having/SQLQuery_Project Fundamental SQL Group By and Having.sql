-- 1 | Mendapatkan jumlah nilai pinalty
----- Pada pelayanan terdapat customer yang mendapatkan pinalty yang diakibatkan telat membayar.
----- Carilah customer-customer id dan jumlah pinalty dari yang dibayarkan oleh customer yang mendapatkan pinalty.

-- karrena disini tipe data pada pinalty itu varchar sehingga tidak bisa dijumlah maka disini saya 
-- membuat tipe data baru dengan nama pinalty_2 tipe data int dengan data yang sama seperti pinalty tapi 
-- kita ubah dari NULL menjadi 0
ALTER TABLE invoice ADD pinalty_2 INT;

UPDATE invoice SET pinalty_2 = pinalty;

--------------------------------------------------------------------

SELECT	customer_id,
		sum(pinalty_2) 
FROM invoice
GROUP BY customer_id
HAVING sum(pinalty_2) > 20000;


----------------------------------------------------------------------------------------------------------
-- 2 | Mencari customer yang mengganti layanan
------

SELECT	Name as name,
		t3.product_name 
FROM customer t1 
JOIN subscriptions t2 
ON t2.id = t1.customer_id 
JOIN products t3 
ON t3.product_id=t2.id 
WHERE t1.id IN (select customer_id 
                FROM subscriptions 
                GROUP BY customer_id 
                HAVING COUNT(customer_id)>1)
GROUP BY name;


select	t1.Name as name,
		t3.product_name  
from customers t1
join Subcriptions t2
ON t1.id = t2.id
join product t3
on t2.product_id = t3.id
WHERE t2.id IN (select customer_id 
                FROM Subcriptions 
                GROUP BY customer_id 
                HAVING COUNT(customer_id)>1)
GROUP BY t1.Name ,
		t3.product_name  