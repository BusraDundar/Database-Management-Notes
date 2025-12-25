
CREATE FUNCTION NetTutarHesapla
(
    @Tutar DECIMAL(18,2),
    @IndirimOrani DECIMAL(4,2), 
    @KdvOrani DECIMAL(4,2)      
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Sonuc DECIMAL(18,2);
    
    
    SET @Sonuc = (@Tutar - (@Tutar * @IndirimOrani)) * (1 + @KdvOrani);

    RETURN @Sonuc;
END;
GO


CREATE NONCLUSTERED INDEX Siparis_Tarih_Tutar_Index
ON Orders (OrderDate DESC, TotalAmount DESC);
GO


CREATE VIEW GenelSatisRaporu
AS
SELECT 
    o.OrderID,
    c.CompanyName AS SirketAdi,
    p.ProductName AS UrunAdi,
    o.OrderDate AS SiparisTarihi,
    o.TotalAmount AS HamFiyat,
 
    dbo.NetTutarHesapla(o.TotalAmount, 0.10, 0.20) AS SonFiyat,
   
    CASE 
        WHEN o.TotalAmount > 10000 THEN 'Yuksek Ciro'
        WHEN o.TotalAmount BETWEEN 5000 AND 10000 THEN 'Orta Ciro'
        ELSE 'Standart'
    END AS SatisDurumu
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Products p ON o.ProductID = p.ProductID;
GO


CREATE PROCEDURE TarihliSatisGetir
    @BaslangicTarihi DATE,
    @BitisTarihi DATE
AS
BEGIN
 
    SELECT 
        SatisDurumu,
        COUNT(OrderID) AS ToplamSiparis,
        SUM(SonFiyat) AS ToplamKazanc
    FROM GenelSatisRaporu
    WHERE SiparisTarihi BETWEEN @BaslangicTarihi AND @BitisTarihi
    GROUP BY SatisDurumu
    ORDER BY ToplamKazanc DESC;
END;
GO
