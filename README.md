# 📚 Veritabanı Yönetimi (SQL) - Final Çalışma Notlarım

Bu depo, Veritabanı Yönetimi dersi final sınavı hazırlık sürecimde aldığım kişisel çalışma notlarımı içerir. Temel SQL komutları, veri sorgulama, birleştirme işlemleri (Joins), sanal tablolar (Views) ve temel T-SQL programlama (Trigger/Değişkenler) konularını kapsar.

---

## 1. Temel Veritabanı Nesne İşlemleri (DDL)

Veritabanı nesnelerini (Tablo, View vb.) oluşturmak, değiştirmek ve silmek için kullanılan komutlar.

### Tablo Oluşturma (CREATE)
```sql
CREATE TABLE Personel (
    ad VARCHAR(15) NOT NULL, -- Boş bırakılamaz
    soyad VARCHAR(15),
    dogum_tarihi DATETIME,
    cinsiyet BIT, -- 0 veya 1
    goz_rengi VARCHAR(15),
    maas TINYINT,
    PRIMARY KEY (ad) -- Birincil anahtar
);
```
Nesne Düzenleme ve Silme

*ALTER TABLE: Tablonun yapısını değiştirir (sütun ekleme/çıkarma).

-- Tabloya yeni sütun ekleme

ALTER TABLE TabloAdi ADD kolonadi VARCHAR(15);


*DROP TABLE: Tabloyu tamamen veritabanından siler.

DROP TABLE Personel;


*TRUNCATE TABLE: Tablonun yapısını korur ama içindeki TÜM verileri boşaltır (Delete'den hızlıdır).

TRUNCATE TABLE TabloAdi;

-- Tablo veya sütun adı değiştirme prosedürü
EXEC sp_rename 'EskiTabloAdi', 'YeniTabloAdi';
EXEC sp_rename 'Tablo.EskiKolon', 'YeniKolon', 'COLUMN';

2. Veri İşleme Komutları (DML)
Tablo içindeki verilerle çalışmak için kullanılan komutlar.

*UPDATE: Mevcut verileri günceller.

-- Belirli bir şarta uyan kayıtların sütununu güncelleme
UPDATE TabloAdi
SET kolonadi = 'Yeni Değer'
WHERE ID = 5; -- Şart belirtmezsek tüm tablo güncellenir!

*DELETE: Tablodan kayıt siler.

DELETE FROM TabloAdi
WHERE sartlar; -- Örn: WHERE ID = 10


3. Veri Sorgulama (SELECT Temelleri)
Temel Seçim ve Takma Adlar (Alias):

SELECT ad AS İsim, soyad AS Soyisim FROM Personel;


*TOP (İlk N Kayıt): Listeden sadece belirli sayıdaki ilk kayıtları getirir.

SELECT TOP(10) * FROM Personel; -- İlk 10 satırı getir


*DISTINCT (Tekrarsız): Aynı olan kayıtları tekile indirger.

SELECT DISTINCT(ad) FROM Personel; -- Tekrarsız isimleri getirir


*ORDER BY (Sıralama):

SELECT * FROM Personel ORDER BY ad ASC; -- A'dan Z'ye (Artan)
SELECT * FROM Personel ORDER BY maas DESC; -- Z'den A'ya (Azalan)


Filtreleme (WHERE Koşulları)

*LIKE (Metin Arama): % (joker karakter) kullanılır.

SELECT * FROM Personel WHERE ad LIKE '%a'; -- Adı 'a' ile bitenler
SELECT * FROM User WHERE username LIKE 'A%'; -- 'A' ile başlayanlar


*IN (Liste İçi Arama): Belirtilen değerler listesinde olanları getirir.

SELECT * FROM Personel WHERE maas IN (2, 7); -- Maaşı 2 veya 7 olanlar


*BETWEEN (Aralık Arama): İki değer arasındakileri getirir.

SELECT * FROM Personel WHERE maas BETWEEN 2 AND 7;


4. Fonksiyonlar
Kümeleme (Aggregate) Fonksiyonları
Genellikle GROUP BY ile kullanılırlar, tek bir sonuç değeri döndürürler.

COUNT(kolon): Kayıt sayısını verir.

SUM(kolon): Toplamını alır.

AVG(kolon): Ortalamasını alır.

MAX(kolon): En büyük değeri verir.

MIN(kolon): En küçük değeri verir.

Metin (String) Fonksiyonları
ASCII('A') / CHAR(65): Karakterin ASCII kodunu veya kodun karakter karşılığını verir.

LEN(metin): Metnin uzunluğunu (karakter sayısını) verir.

SUBSTRING(metin, baslangic, uzunluk): Metnin içinden parça alır.

CHARINDEX('aranan', metin): Bir metnin içinde başka bir metnin başladığı konumu verir.

CONCAT(metin1, metin2): Metinleri birleştirir.

CONCAT_WS('-', metin1, metin2): Araya ayraç koyarak birleştirir.

TRIM/LTRIM/RTRIM(metin): Başındaki/sonundaki boşlukları siler.

LOWER(metin) / UPPER(metin): Küçük/Büyük harfe çevirir.

REVERSE(metin): Metni tersten yazar.

REPLICATE('0', 10): Bir karakteri belirtilen sayıda tekrar eder.

REPLACE(metin, 'eski', 'yeni'): Metin içindeki bir ifadeyi yenisiyle değiştirir

Veri Tipi Dönüştürme

-- Bir veri tipini başka bir tipe dönüştürme
SELECT CONVERT(VARCHAR(10), DogumTarihi, 104) FROM Personel; -- Tarihi belirli formatta metne çevirir


5. İleri Seviye Sorgular
*İç İçe Sorgular (Subqueries)
Bir sorgunun sonucunu, başka bir sorgunun içinde kullanmak.

-- Bölüm adı 'Bilgisayar' veya 'Elektrik' olanların bölüm kodlarını bul,
-- Sonra bu kodlara sahip öğrencileri getir.
SELECT * FROM ogrenci
WHERE bolum_kod IN (
    SELECT bolum_kod
    FROM bolum
    WHERE bolum_ad IN ('Bilgisayar', 'Elektrik')
);


*Tablo Birleştirme (JOINS)
Birden fazla tablodan ilişkisel veri çekmek için kullanılır.

1. INNER JOIN (Kesişim): Sadece her iki tabloda da eşleşen kayıtları getirir.

   -- Modern Yöntem (Önerilen)
SELECT o.ad, o.soyad, b.bolum_adi
FROM ogrenci AS o
INNER JOIN bolum AS b ON o.bolum_kod = b.bolum_kod
WHERE o.cinsiyet = 1 OR b.bolum_adi = 'Bilgisayar';

-- Eski Yöntem (WHERE ile birleştirme)
SELECT o.ad, o.soyad, b.bolum_adi
FROM ogrenci AS o, bolum AS b
WHERE o.bolum_kod = b.bolum_kod AND b.bolum_adi = 'Bilgisayar';


2. OUTER JOIN (Sol/Sağ): Bir tablodaki tüm kayıtları, diğer tablodaki eşleşenleri getirir. Eşleşmeyenler NULL gelir.

   -- LEFT OUTER JOIN: Soldaki tablonun (ogrenci) tamamını getirir.
SELECT o.ogr_no, o.ad, b.bolum_ad
FROM ogrenci AS o
LEFT OUTER JOIN bolum AS b ON b.bolum_kod = o.bolum_kod;


*UNION (Sonuçları Alt Alta Ekleme)
İki farklı sorgunun sonucunu birleştirir. Sütun sayıları ve veri tipleri uyumlu olmalıdır.

SELECT ad, soyad FROM aktif_ogrenciler
UNION
SELECT ad, soyad FROM mezun_ogrenciler;
-- UNION ALL kullanılırsa tekrarlayan kayıtları da getirir.


6. Sanal Tablolar (VIEWS)
Sık kullanılan karmaşık sorguları bir sanal tablo olarak saklamaya yarar.

-- Basit View: Erkek öğrencileri getiren sanal tablo
CREATE VIEW Erkekler AS
SELECT ad, soyad FROM ogrenci WHERE cinsiyet = 1
WITH CHECK OPTION; -- Bu view üzerinden yapılan eklemelerin şarta (cinsiyet=1) uymasını zorunlu kılar.

-- View Kullanımı:
SELECT * FROM Erkekler;


7. T-SQL Programlama Temelleri
Değişkenler (Variables)

DECLARE @isim AS VARCHAR(MAX); -- Değişken oluşturma
SET @isim = 'Büşra'; -- Değer atama
-- Sorgu içinde kullanımı
SELECT * FROM Personel WHERE ad = @isim;


*Tetikleyiciler (TRIGGERS)
Bir tabloda INSERT, UPDATE veya DELETE işlemi yapıldığında otomatik devreye giren kod bloklarıdır. Veri güvenliği ve bütünlüğü için kullanılır.

inserted ve deleted sanal tabloları işlem sırasındaki verileri tutar.

ROLLBACK: İşlemi geri alır (iptal eder).

Örnek Trigger: 'ogrenci' tablosuna ekleme veya güncelleme yapıldıktan sonra çalışır.

CREATE TRIGGER deneme ON ogrenci
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @ad VARCHAR(43);
    -- Eklenen yeni kaydın adını 'inserted' tablosundan al
    SELECT @ad = ad FROM inserted; 
    
    -- Başka bir tabloya (bolum) bu adı ekle (Örnek amaçlı)
    INSERT INTO bolum (kod, bolum_adi) VALUES (35, @ad);
    
    -- Eğer bir kural ihlali varsa işlem iptal edilebilir:
    -- ROLLBACK TRANSACTION;
END;




