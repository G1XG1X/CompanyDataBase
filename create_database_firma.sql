DROP DATABASE IF EXISTS firma;
CREATE DATABASE firma;
USE firma;

-- DROP TABLE pracownik;
-- DROP TABLE branza;
-- DROP TABLE klient;
-- DROP TABLE wspolpraca;
-- DROP TABLE dostawca;

-- TWORZENIE TABEL --

CREATE TABLE pracownik (
    pracownik_id INT PRIMARY KEY AUTO_INCREMENT,
    imie VARCHAR(40),
    nazwisko VARCHAR(40),
    data_urodzenia DATE,
    pensja INT,
    przelozony_id INT,
    branza_id INT,
    KEY fk_pracownik_branza (branza_id),
    KEY fk_pracownik_pracownik (przelozony_id)
) AUTO_INCREMENT=59, COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE branza (
    branza_id INT PRIMARY KEY AUTO_INCREMENT,
    nazwa_branzy VARCHAR(40),
    data_rozpoczecia DATE,
    manager INT,
    KEY fk_branza_pracownik (manager),
    CONSTRAINT fk_branza_pracownik FOREIGN KEY (manager) REFERENCES pracownik (pracownik_id) ON DELETE SET NULL
) AUTO_INCREMENT=4, COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE pracownik
ADD CONSTRAINT fk_pracownik_branza FOREIGN KEY (branza_id) REFERENCES branza (branza_id) ON DELETE SET NULL;

ALTER TABLE pracownik
ADD CONSTRAINT fk_pracownik_pracownik FOREIGN KEY (przelozony_id) REFERENCES pracownik (pracownik_id) ON DELETE SET NULL;

CREATE TABLE klient (
    klient_id INT PRIMARY KEY AUTO_INCREMENT,
    nazwa_klienta VARCHAR(40),
    branza_id INT,
    KEY fk_klient_branza_id (branza_id),
    CONSTRAINT fk_klient_branza_id FOREIGN KEY (branza_id) REFERENCES branza (branza_id) ON DELETE SET NULL
) AUTO_INCREMENT=47, COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE wspolpraca (
    pracownik_id INT,
    klient_id INT,
    sprzedaz INT,
    PRIMARY KEY(pracownik_id, klient_id),
    KEY fk_wspolpraca_pracownik (pracownik_id),
    KEY fk_wspolpraca_klient (klient_id),
    CONSTRAINT fk_wspolpraca_pracownik FOREIGN KEY (pracownik_id) REFERENCES pracownik (pracownik_id) ON DELETE CASCADE,
    CONSTRAINT fk_wspolpraca_klient FOREIGN KEY (klient_id) REFERENCES klient (klient_id) ON DELETE CASCADE
) COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE dostawca (
    branza_id INT,
    nazwa_dostawcy VARCHAR(40),
    typ_produktu VARCHAR(40),
    PRIMARY KEY(branza_id, nazwa_dostawcy),
    KEY fk_dostawca_branza (branza_id),
    CONSTRAINT fk_dostawca_branza FOREIGN KEY (branza_id) REFERENCES branza (branza_id) ON DELETE CASCADE
) COLLATE=utf8mb4_0900_ai_ci;

-- WSTAWIANIE DANYCH --
-- SOFTWARE --
-- branza_id nalezy zainicjować NULL, poniewa nie ma jeszcze wprowadzonych danych w tabeli branza --
INSERT INTO pracownik VALUES(50, 'Grzegorz', 'Majewski', '1998-05-18', 5000, NULL, NULL); 
INSERT INTO branza VALUES(1,'Software','2020-02-09', 50 );

UPDATE pracownik
SET branza_id = 1
WHERE pracownik_id = 50;

INSERT INTO pracownik VALUES(51, 'Kuba', 'Siwy', '1998-08-12', 11000, 50, 1); 

-- AUTOMOTIVE --
INSERT INTO pracownik VALUES(52, 'Michał', 'Szot', '2000-05-13', 7500, 50, NULL);
INSERT INTO branza VALUES(2, 'Automotive','2008-05-04', 52 );

UPDATE pracownik
SET branza_id = 2
WHERE pracownik_id = 52;

INSERT INTO pracownik VALUES(53, 'Angelika', 'Martyniuk', '1999-06-25', 6300, 52, 2);
INSERT INTO pracownik VALUES(54, 'Katarzyna', 'Kapustka', '1980-02-05', 5500, 52, 2);
INSERT INTO pracownik VALUES(55, 'Stanisław', 'Chudy', '1985-10-19', 6900, 52, 2);

-- MEDIA --
INSERT INTO pracownik VALUES(56, 'Janusz', 'Poterek', '1980-09-09', 7800, 50, NULL);
INSERT INTO branza VALUES(3, 'Media', '1981-02-13', 56 );

UPDATE pracownik
SET branza_id = 3
WHERE pracownik_id = 56;

INSERT INTO pracownik VALUES(57, 'Andrzej', 'Skok', '1979-07-22', 13500, 56, 3);
INSERT INTO pracownik VALUES(58, 'Jan', 'Hap', '2002-11-01', 7100, 56, 3);

-- klient
INSERT INTO klient VALUES(40, 'Politechnika Krakowska', 2);
INSERT INTO klient VALUES(41, 'AGH', 2);
INSERT INTO klient VALUES(42, 'Copylandia', 3);
INSERT INTO klient VALUES(43, 'Gazeta Krakowska', 3);
INSERT INTO klient VALUES(44, 'AMCTECH', 2);
INSERT INTO klient VALUES(45, 'DPD', 3);
INSERT INTO klient VALUES(46, 'Sabre', 2);

-- wspolpraca
INSERT INTO wspolpraca VALUES(55, 40, 60000);
INSERT INTO wspolpraca VALUES(52, 41, 200000);
INSERT INTO wspolpraca VALUES(58, 42, 30000);
INSERT INTO wspolpraca VALUES(57, 43, 5000);
INSERT INTO wspolpraca VALUES(58, 43, 12000);
INSERT INTO wspolpraca VALUES(55, 44, 33000);
INSERT INTO wspolpraca VALUES(57, 45, 26000);
INSERT INTO wspolpraca VALUES(52, 46, 15000);
INSERT INTO wspolpraca VALUES(55, 46, 130000);

-- dostawca
INSERT INTO dostawca VALUES(2, 'Aptiv', 'Elektronika');
INSERT INTO dostawca VALUES(2, 'COMARCH', 'Oprogramowanie biznesowe');
INSERT INTO dostawca VALUES(3, 'DrukarkaPL', 'Uslugi multimedialne');
INSERT INTO dostawca VALUES(2, 'IT4U', 'Serwis urzadzen');
INSERT INTO dostawca VALUES(3, 'COMARCH', 'Oprogramowanie biznesowe');
INSERT INTO dostawca VALUES(3, 'Aptiv', 'Elektronika');
INSERT INTO dostawca VALUES(3, 'Etykietka', 'Reklama');   

DELIMITER $$

CREATE TRIGGER before_branza_delete
BEFORE DELETE ON branza
FOR EACH ROW 
BEGIN
UPDATE pracownik
SET pensja = NULL
WHERE branza_id=OLD.branza_id;
END;

$$
DELIMITER ;


