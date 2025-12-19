
# 📚 Veritabanı Yönetimi (SQL) - Final Çalışma Notlarım

Bu depo, Veritabanı Yönetimi dersi final sınavı hazırlık sürecimde aldığım kişisel çalışma notlarımı içerir. Temel SQL komutları, veri sorgulama, birleştirme işlemleri (Joins), sanal tablolar (Views) ve temel T-SQL programlama (Trigger/Değişkenler) konularını kapsar.

---## 🧱 1. Temel Veritabanı Nesne İşlemleri (DDL)

Veritabanı nesnelerini (Tablo, View vb.) oluşturmak, değiştirmek ve silmek için kullanılan komutlar.### Tablo Oluşturma (CREATE)```sql
CREATE TABLE Personel (
    ad VARCHAR(15) NOT NULL, -- Boş bırakılamaz
    soyad VARCHAR(15),
    dogum_tarihi DATETIME,
    cinsiyet BIT, -- 0 veya 1
    goz_rengi VARCHAR(15),
    maas TINYINT,
    PRIMARY KEY (ad) -- Birincil anahtar
);
Nesne Düzenleme ve Silme
ALTER TABLE: Tablonun yapısını değiştirir (sütun ekleme/çıkarma).
SQL

ALTER TABLE TabloAdi ADD kolonadi VARCHAR(15);
DROP TABLE: Tabloyu tamamen veritabanından siler.
SQL

DROP TABLE Personel;
TRUNCATE TABLE: Tablonun yapısını korur ama içindeki TÜM verileri boşaltır (Delete'den hızlıdır).
SQL

TRUNCATE TABLE TabloAdi;
Yeniden Adlandırma (SP_RENAME):
SQL

EXEC sp_rename 'EskiTabloAdi', 'YeniTabloAdi';EXEC sp_rename 'Tablo.EskiKolon', 'YeniKolon', 'COLUMN';
✏️ 2. Veri İşleme Komutları (DML)
Tablo içindeki verilerle çalışmak için kullanılan komutlar.
UPDATE: Mevcut verileri günceller.
SQL

UPDATE TabloAdiSET kolonadi = 'Yeni Değer'WHERE ID = 5;
DELETE: Tablodan kayıt siler.
SQL

DELETE FROM TabloAdiWHERE sartlar;
🔍 3. Veri Sorgulama (SELECT Temelleri)
Temel Seçim ve Takma Adlar (Alias)
SQL

SELECT ad AS İsim, soyad AS Soyisim FROM Personel;
TOP (İlk N Kayıt)
SQL

SELECT TOP(10) * FROM Personel;
DISTINCT (Tekrarsız)
SQL

SELECT DISTINCT(ad) FROM Personel;
ORDER BY (Sıralama)
SQL

SELECT * FROM Personel ORDER BY ad ASC; -- ArtanSELECT * FROM Personel ORDER BY maas DESC; -- Azalan
Filtreleme (WHERE Koşulları)
LIKE (Metin Arama)
SQL

SELECT * FROM Personel WHERE ad LIKE '%a';SELECT * FROM User WHERE username LIKE 'A%';
IN (Liste İçi Arama)
SQL

SELECT * FROM Personel WHERE maas IN (2, 7);
BETWEEN (Aralık Arama)
SQL

SELECT * FROM Personel WHERE maas BETWEEN 2 AND 7;
🧮 4. Fonksiyonlar
Kümeleme (Aggregate) Fonksiyonları
COUNT(kolon): Sayı
SUM(kolon): Toplam
AVG(kolon): Ortalama
MAX(kolon): En büyük
MIN(kolon): En küçük
Metin (String) Fonksiyonları
ASCII / CHAR
LEN: Uzunluk
SUBSTRING: Parça alma
CHARINDEX: Arama
CONCAT / CONCAT_WS: Birleştirme
TRIM / LTRIM / RTRIM: Boşluk silme
LOWER / UPPER: Harf büyütme/küçültme
REVERSE: Ters çevirme
REPLICATE: Tekrar etme
REPLACE: Değiştirme
Veri Tipi Dönüştürme
SQL

SELECT CONVERT(VARCHAR(10), DogumTarihi, 104) FROM Personel;
🔗 5. İleri Seviye Sorgular
İç İçe Sorgular (Subqueries)
SQL

SELECT * FROM ogrenciWHERE bolum_kod IN (
    SELECT bolum_kod
    FROM bolum
    WHERE bolum_ad IN ('Bilgisayar', 'Elektrik')
);
Tablo Birleştirme (JOINS)
INNER JOIN
SQL

SELECT o.ad, o.soyad, b.bolum_adiFROM ogrenci AS oINNER JOIN bolum AS b ON o.bolum_kod = b.bolum_kod;
LEFT OUTER JOIN
SQL

SELECT o.ogr_no, o.ad, b.bolum_adFROM ogrenci AS oLEFT OUTER JOIN bolum AS b ON b.bolum_kod = o.bolum_kod;
UNION
SQL

SELECT ad, soyad FROM aktif_ogrencilerUNIONSELECT ad, soyad FROM mezun_ogrenciler;
👁️ 6. Sanal Tablolar (VIEWS)
SQL

CREATE VIEW Erkekler ASSELECT ad, soyad FROM ogrenci WHERE cinsiyet = 1WITH CHECK OPTION;
⚙️ 7. T-SQL Programlama Temelleri
Değişkenler (Variables)
SQL

DECLARE @isim AS VARCHAR(MAX);SET @isim = 'Büşra';SELECT * FROM Personel WHERE ad = @isim;
Tetikleyiciler (TRIGGERS)
SQL

CREATE TRIGGER deneme ON ogrenci
AFTER INSERT, UPDATEASBEGIN
    DECLARE @ad VARCHAR(43);
    SELECT @ad = ad FROM inserted;
    INSERT INTO bolum (kod, bolum_adi) VALUES (35, @ad);END;
