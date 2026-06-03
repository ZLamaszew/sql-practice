/*
Project: Car Workshop Database
Database: Microsoft SQL Server / T-SQL
Authors: Patryk Dobrysiak-Pilch, Zbigniew Łamaszewski, Michał Młynarczyk
Description: Academic database project for managing clients, cars, employees, services, repairs, spare parts and warehouse stock.
*/


/* ===== 01_schema.sql ===== */

-- Patryk Dobrysiak-Pilch 166982
-- Zbigniew Łamaszewski 167684
-- Michał Młynarczyk 167024

CREATE DATABASE projekt_sql_warsztat;
GO
USE projekt_sql_warsztat;

CREATE TABLE klienci(
	id_klient int IDENTITY NOT NULL,
	imie varchar(50) NOT NULL,
	nazwisko varchar(50) NOT NULL,
	telefon varchar(12) NOT NULL,
	email varchar(50) NULL,
	CONSTRAINT PK_klienci PRIMARY KEY (id_klient)
);

CREATE TABLE samochody(
	id_samochod int IDENTITY NOT NULL,
	marka varchar(50) NOT NULL,
	model varchar(50) NOT NULL,
	rok_produkcji smallint NOT NULL,
	nr_rejestracyjny varchar(10) NOT NULL,
	nr_vin varchar(17) NOT NULL,
	CONSTRAINT PK_samochody PRIMARY KEY (id_samochod),
	CONSTRAINT UQ_samochody_rejestracja UNIQUE (nr_rejestracyjny),
	CONSTRAINT UQ_samochody_vin UNIQUE (nr_vin)
);

CREATE TABLE specjalizacje(
	id_specjalizacja int IDENTITY NOT NULL,
	nazwa varchar(50) NOT NULL,
	CONSTRAINT PK_specjalizacje PRIMARY KEY (id_specjalizacja)
);

CREATE TABLE stanowiska(
	id_stanowisko int IDENTITY NOT NULL,
	nazwa varchar(50) NOT NULL,
	pensja_min money NOT NULL,
	pensja_max money NOT NULL,
	CONSTRAINT PK_stanowiska PRIMARY KEY (id_stanowisko)
);

CREATE TABLE producenci(
	id_producent int IDENTITY NOT NULL,
	nazwa varchar(50) NOT NULL,
	kraj varchar(50) NOT NULL,
	CONSTRAINT PK_producenci PRIMARY KEY (id_producent)
);

CREATE TABLE pracownicy(
	id_pracownik int IDENTITY NOT NULL,
	imie varchar(50) NOT NULL,
	nazwisko varchar(50) NOT NULL,
	telefon varchar(12) NOT NULL,
	adres_zamieszkania varchar(50) NOT NULL,
	data_zatrudnienia date NOT NULL,
	id_stanowisko int NOT NULL,
	pensja money NOT NULL,
	premia money NULL,
	CONSTRAINT PK_pracownicy PRIMARY KEY (id_pracownik),
	CONSTRAINT FK_pracownicy_stanowiska FOREIGN KEY (id_stanowisko) REFERENCES stanowiska(id_stanowisko)
);

CREATE TABLE czesci(
	id_czesc int IDENTITY NOT NULL,
	nazwa varchar(50) NOT NULL,
	nr_katalogowy varchar(10) NOT NULL,
	cena money NOT NULL,
	id_producent int NOT NULL,
	CONSTRAINT PK_czesci PRIMARY KEY (id_czesc),
	CONSTRAINT FK_czesci_producenci FOREIGN KEY (id_producent) REFERENCES producenci(id_producent)
);

CREATE TABLE uslugi(
	id_usluga int IDENTITY NOT NULL,
	id_specjalizacja int NOT NULL,
	nazwa varchar(50) NOT NULL,
	cena money NOT NULL,
	czas time(7) NOT NULL,
	CONSTRAINT PK_uslugi PRIMARY KEY (id_usluga),
	CONSTRAINT FK_uslugi_specjalizacje FOREIGN KEY (id_specjalizacja) REFERENCES specjalizacje(id_specjalizacja)
);

CREATE TABLE zlecenia(
	id_zlecenia int IDENTITY NOT NULL,
	id_pracownik int NOT NULL,
	id_klient int NOT NULL,
	id_samochod int NOT NULL,
	opis varchar(max) NOT NULL,
	data_przyjecia date NOT NULL,
	data_oddania date NULL,
	status varchar(20) NOT NULL,
	CONSTRAINT PK_zlecenia PRIMARY KEY (id_zlecenia),
	CONSTRAINT CK_zlecenia_zgodnosc_dat CHECK ((data_oddania IS NULL OR data_oddania>=data_przyjecia)),
	CONSTRAINT CK_zlecenia_status CHECK ((status='anulowane' OR status='zakonczono' OR status='w trakcie' OR status='nowe')),
	CONSTRAINT FK_zlecenia_klienci FOREIGN KEY (id_klient) REFERENCES klienci(id_klient),
	CONSTRAINT FK_zlecenia_pracownicy FOREIGN KEY (id_pracownik) REFERENCES pracownicy(id_pracownik),
	CONSTRAINT FK_zlecenia_samochody FOREIGN KEY (id_samochod) REFERENCES samochody(id_samochod)
);

CREATE TABLE naprawy(
	id_naprawa int IDENTITY NOT NULL,
	id_zlecenia int NOT NULL,
	id_usluga int NOT NULL,
	id_pracownik int NOT NULL,
	data_wykonania date NOT NULL,
	CONSTRAINT PK_naprawy PRIMARY KEY (id_naprawa),
	CONSTRAINT FK_naprawy_zlecenia FOREIGN KEY (id_zlecenia) REFERENCES zlecenia(id_zlecenia),
	CONSTRAINT FK_naprawy_uslugi FOREIGN KEY (id_usluga) REFERENCES uslugi(id_usluga),
	CONSTRAINT FK_naprawy_pracownicy FOREIGN KEY (id_pracownik) REFERENCES pracownicy(id_pracownik)
);

CREATE TABLE magazyn(
	id_czesc int NOT NULL,
	ilosc int NOT NULL,
	CONSTRAINT PK_magazyn PRIMARY KEY (id_czesc),
	CONSTRAINT FK_magazyn_czesci FOREIGN KEY (id_czesc) REFERENCES czesci(id_czesc)
);

CREATE TABLE klienci_samochody(
	id_klient int NOT NULL,
	id_samochod int NOT NULL,
	CONSTRAINT PK_klienci_samochody PRIMARY KEY (id_klient, id_samochod),
	CONSTRAINT FK_klienci_samochody_klienci FOREIGN KEY (id_klient) REFERENCES klienci(id_klient),
	CONSTRAINT FK_klienci_samochody_samochody FOREIGN KEY (id_samochod) REFERENCES samochody(id_samochod)
);

CREATE TABLE naprawy_czesci(
	id_naprawa int NOT NULL,
	id_czesc int NOT NULL,
	ilosc int NOT NULL,
	CONSTRAINT PK_naprawy_czesci PRIMARY KEY (id_naprawa, id_czesc),
	CONSTRAINT FK_naprawy_czesci_naprawy FOREIGN KEY (id_naprawa) REFERENCES naprawy(id_naprawa),
	CONSTRAINT FK_naprawy_czesci_czesci FOREIGN KEY (id_czesc) REFERENCES czesci(id_czesc)
);

CREATE TABLE pracownicy_specjalizacje(
	id_pracownik int NOT NULL,
	id_specjalizacja int NOT NULL,
	CONSTRAINT PK_pracownicy_specjalizacje PRIMARY KEY (id_pracownik, id_specjalizacja),
	CONSTRAINT FK_pracownicy_specjalizacje_pracownicy FOREIGN KEY (id_pracownik) REFERENCES pracownicy(id_pracownik),
	CONSTRAINT FK_pracownicy_specjalizacje_specjalizacje FOREIGN KEY (id_specjalizacja) REFERENCES specjalizacje(id_specjalizacja)
);

/* ===== 02_insert_data.sql ===== */

-- Patryk Dobrysiak-Pilch 166982
-- Zbigniew Łamaszewski 167684
-- Michał Młynarczyk 167024

USE projekt_sql_warsztat;

INSERT INTO klienci (imie, nazwisko, telefon, email) VALUES
('Jan','Kowalski','501234567','kowalski.jan@email.com'),
('Anna','Nowak','502345678',NULL),
('Piotr','Wiśniewski','503456789',NULL),
('Katarzyna','Wójcik','504567890','kwojcik@email.com'),
('Michał','Kowalczyk','505678901',NULL),
('Magda','Kamiński','506789012','magkam@email.com'),
('Tomasz','Lewandowski','507890123',NULL),
('Ewa','Zieliński','508901234',NULL),
('Krzysztof','Szymański','509012345','krzysztof.szymanski@email.com'),
('Monika','Woźniak','510123456','m.wozniak@email.com');

INSERT INTO samochody (marka, model, rok_produkcji, nr_rejestracyjny, nr_vin) VALUES
('Volkswagen','Golf VII',2018,'DW123AB','WVW1ZZ1KZJW001234'),
('Skoda','Octavia III',2019,'DW234BC','TMB1BJ5EJKM002345'),
('Toyota','Corolla',2020,'DW345CD','JTD1ARFUEL003456'),
('Ford','Focus Mk4',2017,'DW456DE','WF01XXGBNJ004567'),
('Opel','Astra K',2016,'DW567EF','W0L1XAL756005678'),
('Volkswagen','Passat B8',2015,'DW678FG','WVW2ZZ1LZGW006789'),
('Audi','A4 B9',2018,'DW789GH','WAU1ZZF45JN007890'),
('BMW','Seria 3 G20',2019,'DW890HI','WBA2XXXXX008901'),
('Hyundai','i30 III',2020,'DW901IJ','KMHK851AHLT009012'),
('Renault','Megane IV',2017,'DW012JK','VF1RFB009010123'),
('Fiat','Tipo',2019,'DW123KL','ZFA312000011234'),
('Peugeot','308 II',2018,'DW234LM','VF31234U456012345'),
('Mercedes','Klasa A W177',2020,'DW345MN','W1K2XXXXX013456'),
('Seat','Leon IV',2021,'DW456NO','VSS1ZZ5LZMT014567'),
('Kia','Ceed III',2019,'DW567OP','KNA2XXXXX015678');

INSERT INTO specjalizacje (nazwa) VALUES
('Diagnostyka komputerowa'),
('Układ hamulcowy'),
('Układ napędowy'),
('Elektryka i elektronika'),
('Układ kierowniczy'),
('Zawieszenie i geometria'),
('Klimatyzacja');

INSERT INTO stanowiska (nazwa, pensja_min, pensja_max) VALUES
('Kierownik warsztatu',8000,12000),
('Mechanik samochodowy',4500,7000),
('Elektromechanik',4800,7500),
('Diagnosta',5000,8000),
('Magazynier',3500,5000),
('Recepcjonista',3200,4500),
('Myjnia samochodowa',3000,4200),
('Pomocnik mechanika',2800,3800);

INSERT INTO producenci (nazwa, kraj) VALUES
('Bosch','Niemcy'),
('Delphi','Wielka Brytania'),
('Valeo','Francja'),
('TRW','Niemcy'),
('Brembo','Włochy'),
('Lemförder','Niemcy'),
('Febi Bilstein','Niemcy'),
('Mahle','Niemcy'),
('NGK','Japonia'),
('Denso','Japonia');

INSERT INTO czesci (nazwa, nr_katalogowy, cena, id_producent) VALUES
('Tarcza hamulcowa przód','0986494',450.00,1),
('Klocki hamulcowe przód','0986495',280.00,1),('Tarcza hamulcowa tył','0986496',380.00,1),
('Klocki hamulcowe tył','0986497',250.00,1),('Pompa hamulcowa','1830001',650.00,2),
('Przewody hamulcowe','1830002',180.00,2),('Sonda lambda','02589865',420.00,1),
('Filtr powietrza','14574329',85.00,1),('Filtr oleju','04511033',45.00,1),
('Filtr paliwa','04509050',120.00,1),('Świeca zapłonowa','02422365',35.00,9),
('Komplet świec','02422365K',128.00,9),('Pasek rozrządu','53003891',320.00,8),
('Rolka rozrządu','VKM11002',95.00,6),('Zestaw rozrządu','53003891Z',680.00,8),
('Sprzęgło dwumasowe','26083311',1850.00,4),('Tarcza sprzęgłowa','30005265',280.00,4),
('Docisk sprzęgłowy','30005182',320.00,4),('Wahacz prawy','311267',450.00,6),
('Wahacz lewy','311268',450.00,6),('Amortyzator przód','354502',380.00,7),
('Amortyzator tył','354503',320.00,7),('Sprężyna zawieszenia','SE026830',180.00,7),
('Kondensator AC','517762',480.00,3),('Sprężarka AC','95427978',1250.00,3),
('Termostat','274114',95.00,1);

INSERT INTO uslugi (id_specjalizacja,nazwa,cena,czas) VALUES
(1,'Diagnostyka OBD',180,'00:45:00'),(1,'Diagnostyka ABS',220,'01:00:00'),
(2,'Tarcze+klocki przód',380,'02:30:00'),(2,'Tarcze+klocki tył',350,'02:15:00'),(2,'Płyn hamulcowy',250,'01:45:00'),
(3,'Olej+filtry',280,'01:30:00'),(3,'Rozrząd',950,'05:00:00'),(3,'Sprzęgło',1450,'06:30:00'),
(4,'Sonda lambda',380,'02:00:00'),(4,'Świece',220,'01:15:00'),
(5,'Geometria kół',280,'01:45:00'),
(6,'Wahacze',450,'03:00:00'),(6,'Amortyzatory',850,'04:30:00'),
(7,'Klimatyzacja',320,'02:00:00'),(7,'Sprężarka AC',980,'05:30:00');

INSERT INTO pracownicy (imie,nazwisko,telefon,adres_zamieszkania,data_zatrudnienia,id_stanowisko,pensja,premia) VALUES
('Robert','Mazur','601111111','ul. Mechaników 12','2018-03-15',1,9500,1500),
('Dariusz','Olszewski','602222222','ul. Warsztatowa 5','2019-01-10',2,5800,800),
('Łukasz','Pawłowski','603333333','ul. Elektryków 8','2020-05-20',3,6200,900),
('Marek','Jankowski','604444444','ul. Serwisowa 3','2017-09-01',4,6800,1200),
('Sebastian','Baran','605555555','ul. Magazynowa 10','2021-02-15',5,4200,500),
('Karolina','Duda','606666666','ul. Biurowa 2','2022-07-01',6,3800,400),
('Paweł','Wrona','607777777','ul. Myjnia 1','2020-11-10',7,3500,300),
('Kamil','Sowa','608888888','ul. Pomocnicza 4','2023-01-20',8,3200,200),
('Grzegorz','Lis','609999999','ul. Główna 25','2019-08-05',2,5500,700);

INSERT INTO magazyn (id_czesc,ilosc) VALUES
(1,8),(2,12),(3,6),(4,10),(5,3),(6,15),(7,4),(8,20),(9,25),(10,18),
(11,30),(12,22),(13,5),(14,8),(15,4),(16,2),(17,6),(18,7),(19,3),(20,3),
(21,5),(22,6),(23,8),(24,2),(25,1),(26,12);

INSERT INTO klienci_samochody (id_klient,id_samochod) VALUES
(1,1),(1,6),(2,2),(2,9),(3,3),(3,14),(4,4),(4,11),(5,5),(5,12),
(6,7),(7,8),(7,15),(8,10),(9,13),(10,1),(1,2);

INSERT INTO pracownicy_specjalizacje (id_pracownik,id_specjalizacja) VALUES
(2,2),(2,3),(3,1),(3,4),(4,1),(4,3),(9,2),(9,6),(1,1),(1,5),(7,7);

INSERT INTO zlecenia (id_pracownik,id_klient,id_samochod,opis,data_przyjecia,data_oddania,status) VALUES
(6,1,1,'Awaria hamulców','2025-01-15','2025-01-20','zakonczono'),
(6,1,1,'Przegląd oleju','2025-02-10',NULL,'w trakcie'),
(1,2,2,'Błąd sondy lambda','2025-01-05','2025-01-10','zakonczono'),
(1,2,2,'Klocki przód','2025-02-20',NULL,'nowe'),
(6,3,3,'Ubytek płynu','2024-12-28','2025-01-05','zakonczono'),
(1,3,3,'Stuki zawieszenia','2025-03-12',NULL,'w trakcie'),
(1,4,4,'Wymiana sprzęgła','2025-03-25',NULL,'nowe'),
(6,5,5,'Klimatyzacja','2025-02-05','2025-02-12','zakonczono'),
(6,1,6,'Rozrząd 180k km','2025-01-20','2025-02-01','zakonczono'),
(6,7,7,'Awaria ABS','2025-04-08',NULL,'w trakcie'),
(6,7,8,'Geometria kół','2025-04-18',NULL,'nowe'),
(6,2,9,'Serwis klimatyzacji','2025-02-28','2025-03-02','zakonczono'),
(6,8,10,'Akumulator','2025-05-10','2025-05-12','zakonczono'),
(1,4,11,'Diagnostyka silnika','2025-05-22',NULL,'nowe'),
(1,9,13,'Amortyzatory','2025-03-15','2025-03-25','zakonczono'),
(1,5,12,'Awaria świateł','2025-06-05','2025-06-12','zakonczono'),
(6,3,14,'Kontrola techniczna','2025-06-20',NULL,'nowe'),
(6,6,7,'Filtr kabinowy','2025-07-08','2025-07-10','zakonczono'),
(6,7,15,'Skrzynia biegów','2025-07-25',NULL,'w trakcie'),
(6,8,10,'Klocki tył','2025-08-12','2025-08-18','zakonczono'),
(6,9,13,'Sprężyny zawieszenia','2025-08-30',NULL,'nowe'),
(1,10,1,'Układ kierowniczy','2025-09-15',NULL,'w trakcie'),
(6,1,6,'Diagnostyka dodatkowa','2025-10-05',NULL,'nowe'),
(1,2,2,'Pompa wody','2025-10-22',NULL,'nowe'),
(6,3,3,'Przegląd hamulców','2025-11-10',NULL,'nowe'),
(6,4,4,'Anulowane','2025-11-25','2025-11-25','anulowane'),
(6,5,5,'Mycie detailing','2025-12-05','2025-12-05','zakonczono'),
(6,6,7,'Termostat','2025-12-18',NULL,'nowe'),
(1,7,8,'Przewody zapłonowe','2025-12-28',NULL,'nowe'),
(1,8,10,'Serwis AC','2025-12-30',NULL,'nowe');

INSERT INTO naprawy (id_zlecenia, id_usluga, id_pracownik, data_wykonania) VALUES
(1,3,2,'2025-01-18'),
(1,4,2,'2025-01-18'),
(2,6,3,'2025-02-12'),
(3,9,3,'2025-01-07'),
(5,6,1,'2025-01-02'),
(6,12,9,'2025-03-14'),
(8,14,7,'2025-02-08'),
(9,7,3,'2025-01-25'),
(12,14,7,'2025-03-01'),
(13,1,3,'2025-05-11'),
(15,13,9,'2025-03-20'),
(18,6,1,'2025-07-09'),
(20,4,3,'2025-08-15'),
(1,1,2,'2025-01-18'),
(3,7,3,'2025-01-07'),
(6,5,4,'2025-03-14'),
(9,1,3,'2025-01-25'),
(15,10,3,'2025-03-22'),
(20,1,3,'2025-08-15'),
(2,1,3,'2025-02-12'),
(8,1,4,'2025-02-08'),
(12,1,7,'2025-03-01'),
(18,1,4,'2025-07-09'),
(24,3,9,'2025-11-12'),
(25,1,3,'2025-11-28'),
(26,14,7,'2025-12-06'),
(27,6,2,'2025-12-20'),
(28,9,3,'2025-12-30'),
(29,4,2,'2025-12-30'),
(30,1,8,'2025-12-30');

INSERT INTO naprawy_czesci (id_naprawa,id_czesc,ilosc) VALUES
(1,1,1),(1,2,1),(1,5,1),(1,6,1),
(2,8,1),(2,9,1),(2,10,1),
(3,7,1),
(5,26,1),
(6,19,1),(6,20,1),(6,23,1),
(7,24,1),(7,25,1),
(8,13,1),(8,14,1),(8,15,1),
(9,1,1),
(10,24,1),
(11,21,2),(11,22,2),
(12,2,1),(12,4,1),
(13,23,2),
(14,1,1),(14,2,1),
(15,7,1),
(16,16,1),
(17,25,1),
(18,9,1),
(19,7,1),
(20,21,1),
(21,1,1),
(22,8,1),
(23,11,4),
(24,26,1),
(25,5,1),
(26,13,1),
(27,2,1),
(28,21,1),
(29,7,1),
(30,9,1);

/* ===== 03_queries.sql ===== */

-- Patryk Dobrysiak-Pilch 166982
-- Zbigniew Łamaszewski 167684
-- Michał Młynarczyk 167024

USE projekt_sql_warsztat;

-- 1. Wszyscy klienci z liczba ich samochodow
SELECT k.id_klient,
       k.imie,
       k.nazwisko,
       COUNT(ks.id_samochod) AS liczba_samochodow
FROM klienci k
LEFT JOIN klienci_samochody ks ON k.id_klient = ks.id_klient
GROUP BY k.id_klient, k.imie, k.nazwisko
ORDER BY liczba_samochodow DESC, k.nazwisko;

-- 2. Lista klientow z ich samochodami (marka, model, rejestracja)
SELECT k.id_klient,
       k.imie,
       k.nazwisko,
       s.marka,
       s.model,
       s.nr_rejestracyjny
FROM klienci k
INNER JOIN klienci_samochody ks ON k.id_klient = ks.id_klient
INNER JOIN samochody s ON ks.id_samochod = s.id_samochod
ORDER BY k.nazwisko, s.marka, s.model;

-- 3. Zlecenia w trakcie realizacji z klientem i samochodem
SELECT z.id_zlecenia,
       z.status,
       z.data_przyjecia,
       k.imie,
       k.nazwisko,
       s.marka,
       s.model,
       s.nr_rejestracyjny
FROM zlecenia z
INNER JOIN klienci k ON z.id_klient = k.id_klient
INNER JOIN samochody s ON z.id_samochod = s.id_samochod
WHERE z.status = 'w trakcie'
ORDER BY z.data_przyjecia DESC;

-- 4. Zlecenia zakonczone z czasem realizacji w dniach
SELECT z.id_zlecenia,
       z.data_przyjecia,
       z.data_oddania,
       DATEDIFF(DAY, z.data_przyjecia, z.data_oddania) AS czas_realizacji_dni,
       k.imie,
       k.nazwisko
FROM zlecenia z
INNER JOIN klienci k ON z.id_klient = k.id_klient
WHERE z.data_oddania IS NOT NULL
ORDER BY czas_realizacji_dni DESC;

-- 5. Raport napraw: zlecenie, usluga, mechanik, data
SELECT n.id_naprawa,
       z.id_zlecenia,
       u.nazwa AS usluga,
       u.cena  AS cena_uslugi,
       p.imie  AS imie_mechanika,
       p.nazwisko AS nazwisko_mechanika,
       n.data_wykonania
FROM naprawy n
INNER JOIN zlecenia z ON n.id_zlecenia = z.id_zlecenia
INNER JOIN uslugi u ON n.id_usluga = u.id_usluga
INNER JOIN pracownicy p ON n.id_pracownik = p.id_pracownik
ORDER BY n.data_wykonania DESC;

-- 6. Uzycie czesci w naprawach
SELECT c.id_czesc,
       c.nazwa,
       SUM(nc.ilosc) AS laczna_ilosc,
       SUM(nc.ilosc * c.cena) AS laczna_wartosc
FROM czesci c
INNER JOIN naprawy_czesci nc ON c.id_czesc = nc.id_czesc
GROUP BY c.id_czesc, c.nazwa
ORDER BY laczna_wartosc DESC;

-- 7. Stan magazynu z wartoscia czesci
SELECT c.id_czesc,
       c.nazwa,
       m.ilosc,
       c.cena,
       (m.ilosc * c.cena) AS wartosc_magazynowa
FROM magazyn m
INNER JOIN czesci c ON m.id_czesc = c.id_czesc
ORDER BY wartosc_magazynowa DESC;

-- 8. Producenci z najdrozszymi i srednimi cenami czesci
SELECT pr.id_producent,
       pr.nazwa AS producent,
       pr.kraj,
       MAX(c.cena) AS najdrozsza_czesc,
       AVG(c.cena) AS srednia_cena_czesci,
       COUNT(c.id_czesc) AS liczba_czesci
FROM producenci pr
LEFT JOIN czesci c ON pr.id_producent = c.id_producent
GROUP BY pr.id_producent, pr.nazwa, pr.kraj
ORDER BY najdrozsza_czesc DESC;

-- 9. Najczesciej uzywane czêœci
SELECT TOP 10
       c.id_czesc,
       c.nazwa,
       SUM(nc.ilosc) AS laczna_ilosc
FROM czesci c
INNER JOIN naprawy_czesci nc ON c.id_czesc = nc.id_czesc
GROUP BY c.id_czesc, c.nazwa
ORDER BY laczna_ilosc DESC;

-- 10. Liczba napraw wykonanych przez kazdego pracownika
SELECT p.id_pracownik,
       p.imie,
       p.nazwisko,
       COUNT(n.id_naprawa) AS liczba_napraw
FROM pracownicy p
LEFT JOIN naprawy n ON p.id_pracownik = n.id_pracownik
GROUP BY p.id_pracownik, p.imie, p.nazwisko
ORDER BY liczba_napraw DESC, p.nazwisko;

-- 11. Czesci uzyte przez mechanikow z data ich uzycia
SELECT p.nazwisko AS mechanik,
       cz.nazwa AS czesc,
       n.data_wykonania AS data_uzycia,
       nc.ilosc AS ilosc_w_naprawie,
       z.id_zlecenia
FROM naprawy_czesci nc 
JOIN naprawy n ON nc.id_naprawa = n.id_naprawa
JOIN czesci cz ON nc.id_czesc = cz.id_czesc  
JOIN pracownicy p ON n.id_pracownik = p.id_pracownik
JOIN zlecenia z ON n.id_zlecenia = z.id_zlecenia
ORDER BY p.nazwisko, n.data_wykonania DESC, cz.nazwa;

-- 12. Statystyki pensji na stanowiskach
SELECT s.id_stanowisko,
       s.nazwa AS stanowisko,
       COUNT(p.id_pracownik) AS liczba_pracownikow,
       AVG(p.pensja) AS srednia_pensja,
       s.pensja_min AS min_pensja,
       s.pensja_max AS max_pensja
FROM stanowiska s
LEFT JOIN pracownicy p ON s.id_stanowisko = p.id_stanowisko
GROUP BY s.id_stanowisko, s.nazwa, s.pensja_min, s.pensja_max
ORDER BY srednia_pensja DESC;

-- 13. Pracownicy i ich specjalizacje
SELECT p.id_pracownik,
       p.imie,
       p.nazwisko,
       s.id_specjalizacja,
       s.nazwa AS specjalizacja
FROM pracownicy p
INNER JOIN pracownicy_specjalizacje ps ON p.id_pracownik = ps.id_pracownik
INNER JOIN specjalizacje s ON ps.id_specjalizacja = s.id_specjalizacja
ORDER BY p.nazwisko, s.nazwa;

-- 14. Liczba pracownikow w kazdej specjalizacji
SELECT s.id_specjalizacja,
       s.nazwa AS specjalizacja,
       COUNT(ps.id_pracownik) AS liczba_pracownikow
FROM specjalizacje s
LEFT JOIN pracownicy_specjalizacje ps ON s.id_specjalizacja = ps.id_specjalizacja
GROUP BY s.id_specjalizacja, s.nazwa
ORDER BY liczba_pracownikow DESC;

-- 15. Liczba zlecen na klientow z iloscia zlecen powyzej sredniej
SELECT k.id_klient,
       k.imie,
       k.nazwisko,
       COUNT(z.id_zlecenia) AS liczba_zlecen
FROM klienci k
INNER JOIN zlecenia z ON k.id_klient = z.id_klient
GROUP BY k.id_klient, k.imie, k.nazwisko
HAVING COUNT(z.id_zlecenia) >=
(
    SELECT AVG(x.liczba_zlecen)
    FROM (
        SELECT COUNT(*) AS liczba_zlecen
        FROM zlecenia
        GROUP BY id_klient
    )
)
ORDER BY liczba_zlecen DESC;

-- 16. Miesieczna liczba zlecen
SELECT YEAR(z.data_przyjecia) AS rok,
       MONTH(z.data_przyjecia) AS miesiac,
       COUNT(z.id_zlecenia) AS liczba_zlecen
FROM zlecenia z
WHERE z.data_przyjecia IS NOT NULL
GROUP BY YEAR(z.data_przyjecia), MONTH(z.data_przyjecia)
ORDER BY rok, miesiac;

-- 17. Sredni czas realizacji wszystkich zlecen
SELECT AVG(DATEDIFF(DAY, z.data_przyjecia, z.data_oddania)) AS sredni_czas_realizacji_dni,
       MIN(DATEDIFF(DAY, z.data_przyjecia, z.data_oddania)) AS najkrotsze_zlecenie,
       MAX(DATEDIFF(DAY, z.data_przyjecia, z.data_oddania)) AS najdluzsze_zlecenie
FROM zlecenia z
WHERE z.data_oddania IS NOT NULL;

-- 18. Samochody najczesciej serwisowane wg marek
SELECT TOP 5 s.marka, 
       s.model,
       COUNT(z.id_zlecenia) AS liczba_serwisow,
       AVG(DATEDIFF(DAY, z.data_przyjecia, z.data_oddania)) AS sredni_czas_serwisow
FROM samochody s
INNER JOIN zlecenia z ON s.id_samochod = z.id_samochod
WHERE z.data_oddania IS NOT NULL
GROUP BY s.marka, s.model
ORDER BY liczba_serwisow DESC;

-- 19. Pelny raport napraw z czasem realizacji i mechanikiem
SELECT z.id_zlecenia,
       z.data_przyjecia,
       z.data_oddania,
       DATEDIFF(DAY, z.data_przyjecia, z.data_oddania) AS czas_realizacji_dni,
       u.nazwa AS usluga,
       SUM(ISNULL(nc.ilosc, 0) * ISNULL(c.cena, 0)) AS wartosc_czesci,
       CONCAT(pr.imie, ' ', pr.nazwisko) AS mechanik
FROM zlecenia z
INNER JOIN naprawy n ON z.id_zlecenia = n.id_zlecenia
INNER JOIN uslugi u ON n.id_usluga = u.id_usluga
INNER JOIN pracownicy pr ON n.id_pracownik = pr.id_pracownik
LEFT JOIN naprawy_czesci nc ON n.id_naprawa = nc.id_naprawa
LEFT JOIN czesci c ON nc.id_czesc = c.id_czesc
WHERE z.data_oddania IS NOT NULL
GROUP BY z.id_zlecenia, z.data_przyjecia, z.data_oddania, u.nazwa, pr.imie, pr.nazwisko
ORDER BY czas_realizacji_dni DESC;

-- 20. Zlecenia z trwajace 3 lub wiecej dni
SELECT z.id_zlecenia,
       k.nazwisko,
       DATEDIFF(DAY, z.data_przyjecia, z.data_oddania) AS dni_warsztat,
       z.status
FROM zlecenia z
INNER JOIN klienci k ON z.id_klient = k.id_klient
WHERE z.data_oddania IS NOT NULL 
  AND DATEDIFF(DAY, z.data_przyjecia, z.data_oddania) >= 3
ORDER BY dni_warsztat DESC;

-- 21. Specjalizacje z liczba wykonywanych przez nie uslug
SELECT s.id_specjalizacja,
       s.nazwa AS specjalizacja,
       COUNT(u.id_usluga) AS liczba_uslug,
       AVG(u.cena) AS srednia_cena_uslug
FROM specjalizacje s
LEFT JOIN uslugi u ON s.id_specjalizacja = u.id_specjalizacja
GROUP BY s.id_specjalizacja, s.nazwa
ORDER BY liczba_uslug DESC;

-- 22. Zlecenia z kosztami uslug i czesci
SELECT z.id_zlecenia,
       k.imie,
       k.nazwisko,
       s.marka,
       s.model,
       SUM(ISNULL(u.cena, 0)) AS suma_uslug,
       SUM(ISNULL(nc.ilosc, 0) * ISNULL(c.cena, 0)) AS suma_czesci,
       SUM(ISNULL(u.cena, 0)) +
       SUM(ISNULL(nc.ilosc, 0) * ISNULL(c.cena, 0)) AS laczny_koszt
FROM zlecenia z
INNER JOIN klienci k ON z.id_klient = k.id_klient
INNER JOIN samochody s ON z.id_samochod = s.id_samochod
LEFT JOIN naprawy n ON z.id_zlecenia = n.id_zlecenia
LEFT JOIN uslugi u ON n.id_usluga = u.id_usluga
LEFT JOIN naprawy_czesci nc ON n.id_naprawa = nc.id_naprawa
LEFT JOIN czesci c ON nc.id_czesc = c.id_czesc
GROUP BY z.id_zlecenia, k.imie, k.nazwisko, s.marka, s.model
ORDER BY laczny_koszt DESC;

-- 23. Mechanicy z najdrozszymi i srednimi kosztami wykonanych zlecen
SELECT TOP 5 p.nazwisko AS mechanik,
       COUNT(DISTINCT z.id_zlecenia) AS liczba_zlecen,
       SUM(u.cena + ISNULL(nc.ilosc * c.cena, 0)) AS laczna_wartosc_prac,
       AVG(u.cena + ISNULL(nc.ilosc * c.cena, 0)) AS srednia_wartosc_zlecenia
FROM pracownicy p
INNER JOIN naprawy n ON p.id_pracownik = n.id_pracownik
INNER JOIN zlecenia z ON n.id_zlecenia = z.id_zlecenia
LEFT JOIN uslugi u ON n.id_usluga = u.id_usluga
LEFT JOIN naprawy_czesci nc ON n.id_naprawa = nc.id_naprawa
LEFT JOIN czesci c ON nc.id_czesc = c.id_czesc
GROUP BY p.id_pracownik, p.nazwisko
ORDER BY laczna_wartosc_prac DESC;

-- 24. Lista ile razy wykonano dana usluge oraz kiedy pierwszy i ostatni raz byla wykonana
SELECT u.id_usluga,
       u.nazwa AS usluga,
       COUNT(n.id_naprawa) AS liczba_napraw,
       MIN(n.data_wykonania) AS pierwsza_naprawa,
       MAX(n.data_wykonania) AS ostatnia_naprawa
FROM uslugi u
LEFT JOIN naprawy n ON u.id_usluga = n.id_usluga
GROUP BY u.id_usluga, u.nazwa
ORDER BY liczba_napraw DESC;

-- 25. Klienci i ich laczna liczba samochodow oraz zlecen
SELECT k.id_klient,
       k.imie,
       k.nazwisko,
       COUNT(DISTINCT ks.id_samochod) AS liczba_samochodow,
       COUNT(DISTINCT z.id_zlecenia) AS liczba_zlecen
FROM klienci k
LEFT JOIN klienci_samochody ks ON k.id_klient = ks.id_klient
LEFT JOIN zlecenia z ON k.id_klient = z.id_klient
GROUP BY k.id_klient, k.imie, k.nazwisko
ORDER BY liczba_zlecen DESC, liczba_samochodow DESC;

-- 26. Samochody z historią napraw
SELECT TOP 10 s.marka, s.model, s.nr_rejestracyjny,
       COUNT(z.id_zlecenia) AS liczba_wizyt,
       AVG(DATEDIFF(DAY, z.data_przyjecia, z.data_oddania)) AS sredni_czas_warsztatu
FROM samochody s
INNER JOIN zlecenia z ON s.id_samochod = z.id_samochod
WHERE z.data_oddania IS NOT NULL
GROUP BY s.marka, s.model, s.nr_rejestracyjny
ORDER BY liczba_wizyt DESC;

-- 27. Najdrozsze zlecenia z rozbiciem na uslugi i czesci
SELECT TOP 5 z.id_zlecenia, k.nazwisko,
       SUM(u.cena) AS koszt_uslug,
       SUM(nc.ilosc * c.cena) AS koszt_czesci,
       SUM(u.cena + nc.ilosc * c.cena) AS laczny_koszt
FROM zlecenia z
INNER JOIN klienci k ON z.id_klient = k.id_klient
LEFT JOIN naprawy n ON z.id_zlecenia = n.id_zlecenia
LEFT JOIN uslugi u ON n.id_usluga = u.id_usluga
LEFT JOIN naprawy_czesci nc ON n.id_naprawa = nc.id_naprawa
LEFT JOIN czesci c ON nc.id_czesc = c.id_czesc
GROUP BY z.id_zlecenia, k.nazwisko
ORDER BY laczny_koszt DESC;

-- 28. Mechanicy z najwyższą premią za wydajność
SELECT TOP 5
    CONCAT(p.imie, ' ', p.nazwisko) AS mechanik,
    s.nazwa AS stanowisko,
    p.premia,
    COUNT(n.id_naprawa) AS liczba_napraw,
    AVG(DATEDIFF(DAY, z.data_przyjecia, z.data_oddania)) AS sredni_czas_zlecenia,
    SUM(u.cena) AS wygenerowany_przychod
FROM pracownicy p
INNER JOIN stanowiska s ON p.id_stanowisko = s.id_stanowisko
LEFT JOIN naprawy n ON p.id_pracownik = n.id_pracownik
LEFT JOIN zlecenia z ON n.id_zlecenia = z.id_zlecenia
LEFT JOIN uslugi u ON n.id_usluga = u.id_usluga
WHERE p.premia > 0
GROUP BY p.id_pracownik, p.imie, p.nazwisko, s.nazwa, p.premia
ORDER BY p.premia DESC, wygenerowany_przychod DESC;

-- 29. Trend miesieczny przychodow z napraw
SELECT YEAR(n.data_wykonania) AS rok,
       MONTH(n.data_wykonania) AS miesiac,
       SUM(u.cena) AS przychód_uslugi,
       SUM(nc.ilosc * c.cena) AS przychód_czesci,
       SUM(u.cena + nc.ilosc * c.cena) AS laczny_przychod
FROM naprawy n
INNER JOIN uslugi u ON n.id_usluga = u.id_usluga
LEFT JOIN naprawy_czesci nc ON n.id_naprawa = nc.id_naprawa
LEFT JOIN czesci c ON nc.id_czesc = c.id_czesc
GROUP BY YEAR(n.data_wykonania), MONTH(n.data_wykonania)
ORDER BY rok DESC, miesiac DESC;

-- 30. Statusy zlecen z wartoscia
SELECT 
    z.status,
    COUNT(*) AS liczba_zlecen,
    SUM(ISNULL(koszt_z.koszt, 0)) AS szacowana_wartosc,
    AVG(koszt_z.koszt) AS sredni_koszt_zlecenia
FROM zlecenia z
LEFT JOIN (
    SELECT z.id_zlecenia,
           SUM(ISNULL(u.cena, 0)) + SUM(ISNULL(nc.ilosc * c.cena, 0)) AS koszt
    FROM zlecenia z
    LEFT JOIN naprawy n ON z.id_zlecenia = n.id_zlecenia
    LEFT JOIN uslugi u ON n.id_usluga = u.id_usluga
    LEFT JOIN naprawy_czesci nc ON n.id_naprawa = nc.id_naprawa
    LEFT JOIN czesci c ON nc.id_czesc = c.id_czesc
    GROUP BY z.id_zlecenia
) koszt_z ON z.id_zlecenia = koszt_z.id_zlecenia
GROUP BY z.status
ORDER BY szacowana_wartosc DESC;