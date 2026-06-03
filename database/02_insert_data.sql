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