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