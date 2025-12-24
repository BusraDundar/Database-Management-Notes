
IF OBJECT_ID('SiparisTest', 'U') IS NOT NULL
    DROP TABLE SiparisTest;
GO

CREATE TABLE SiparisTest (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MusteriAdi NVARCHAR(50),
    SiparisTarihi DATETIME,
    Tutar DECIMAL(10, 2),
    Durum NVARCHAR(20)
);
GO


DECLARE @Sayac INT = 1;
DECLARE @Limit INT = 100; 
DECLARE @RasgeleTutar DECIMAL(10,2);
DECLARE @RasgeleGun INT;
DECLARE @SiparisDurumu NVARCHAR(20);


WHILE @Sayac <= @Limit
BEGIN
   
    SET @RasgeleTutar = CAST(RAND() * 900 + 100 AS DECIMAL(10,2));
    
    
    SET @RasgeleGun = CAST(RAND() * 30 AS INT) * -1; 
    
   
    IF @RasgeleTutar > 800
        SET @SiparisDurumu = 'Inceleniyor';
    ELSE
        SET @SiparisDurumu = 'Onaylandi';

    
    INSERT INTO SiparisTest (MusteriAdi, SiparisTarihi, Tutar, Durum)
    VALUES (
        'Musteri_' + CAST(@Sayac AS NVARCHAR(10)), 
        DATEADD(DAY, @RasgeleGun, GETDATE()),     
        @RasgeleTutar,
        @SiparisDurumu
    );

    
    SET @Sayac = @Sayac + 1;
END


SELECT * FROM SiparisTest;
