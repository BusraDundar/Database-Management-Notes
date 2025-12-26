
CREATE TABLE Hesaplar (
    HesapID INT PRIMARY KEY IDENTITY(1,1),
    MusteriAdi NVARCHAR(50),
    Bakiye MONEY DEFAULT 0,
    SonIslemTarihi DATETIME DEFAULT GETDATE()
);

CREATE TABLE TransferLoglari (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    GonderenID INT,
    AliciID INT,
    Tutar MONEY,
    IslemDurumu NVARCHAR(20), 
    IslemTarihi DATETIME DEFAULT GETDATE()
);
GO


INSERT INTO Hesaplar (MusteriAdi, Bakiye) VALUES ('Büşra Dündar', 15000);
INSERT INTO Hesaplar (MusteriAdi, Bakiye) VALUES ('Şirket Hesabı', 50000);
GO


CREATE PROCEDURE sp_ParaTransferiYap
    @GonderenID INT,
    @AliciID INT,
    @TransferTutari MONEY
AS
BEGIN
    
    BEGIN TRY
       
        BEGIN TRANSACTION;

        
        DECLARE @MevcutBakiye MONEY;
        SELECT @MevcutBakiye = Bakiye FROM Hesaplar WHERE HesapID = @GonderenID;

        IF @MevcutBakiye < @TransferTutari
        BEGIN
            
            RAISERROR('Yetersiz Bakiye!', 16, 1);
        END

    
        UPDATE Hesaplar 
        SET Bakiye = Bakiye - @TransferTutari, SonIslemTarihi = GETDATE()
        WHERE HesapID = @GonderenID;

     
        UPDATE Hesaplar 
        SET Bakiye = Bakiye + @TransferTutari, SonIslemTarihi = GETDATE()
        WHERE HesapID = @AliciID;

       
        INSERT INTO TransferLoglari (GonderenID, AliciID, Tutar, IslemDurumu)
        VALUES (@GonderenID, @AliciID, @TransferTutari, 'Basarili');

        COMMIT TRANSACTION;
        PRINT 'Transfer başarıyla gerçekleşti.';
    END TRY
    BEGIN CATCH
        -
        ROLLBACK TRANSACTION;

       
        INSERT INTO TransferLoglari (GonderenID, AliciID, Tutar, IslemDurumu)
        VALUES (@GonderenID, @AliciID, @TransferTutari, 'HATALI');

        PRINT 'Hata oluştu! İşlem iptal edildi. Hata Mesajı: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
