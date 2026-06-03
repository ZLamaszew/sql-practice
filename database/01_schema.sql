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