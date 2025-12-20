
CREATE TABLE Menu
(
    MenuID int IDENTITY(1,1) PRIMARY KEY,
    UrunAd varchar(50) NOT NULL,
    Fiyat decimal(10,2) NOT NULL
);

CREATE TABLE Siparisler 
(
    SiparisID int IDENTITY(1,1) PRIMARY KEY,
    MasaNo varchar(50) NOT NULL,
    MenuID int NOT NULL,
    SiparisTarihi datetime DEFAULT GETDATE(),
    
    CONSTRAINT FK_Siparis_Menu FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
);


INSERT INTO Menu (UrunAd, Fiyat) VALUES 
('Filtre Kahve', 90.00),
('Iced Latte', 115.50),
('White Choc. Mocha', 135.00),
('Demleme Çay', 30.00),
('San Sebastian', 180.00);

INSERT INTO Siparisler (MasaNo, MenuID) VALUES 
('Masa1', 1),
('Masa1', 5), 
('Masa2', 3), 
('Masa3', 2), 
('Masa3', 4), 
('Masa4', 1), 
('Masa1', 4); 

GO


CREATE VIEW DetayliSatis AS
SELECT 
    S.SiparisID,
    S.MasaNo,
    M.UrunAd,
    M.Fiyat  
FROM Siparisler S
INNER JOIN Menu M ON S.MenuID = M.MenuID;

GO


CREATE VIEW MasaHesap AS
SELECT 
    S.MasaNo,
    COUNT(S.MenuID) AS ToplamUrunAdedi, 
    SUM(M.Fiyat) AS ToplamTutar         
FROM Siparisler S
INNER JOIN Menu M ON S.MenuID = M.MenuID
GROUP BY S.MasaNo; 

GO


CREATE VIEW EnCokSatan AS
SELECT TOP 5
    M.UrunAd,
    COUNT(S.SiparisID) AS SatisAdedi,
    SUM(M.Fiyat) AS KazanilanCiro
FROM Siparisler S
INNER JOIN Menu M ON S.MenuID = M.MenuID
GROUP BY M.UrunAd
ORDER BY SatisAdedi DESC;

GO


SELECT * FROM DetayliSatis; 
SELECT * FROM MasaHesap;        
SELECT * FROM EnCokSatan;
