-- TDT4145 Prosjekt: TreningDB — Del 2
-- Brukstilfeller som leveres som SQL
-- Gruppe 66

-- ============================================================
-- Brukstilfelle 2: Booking av Spin60, tirsdag 17. mars kl. 18:30
-- på Øya for bruker johnny@stud.ntnu.no
-- ============================================================

-- Sjekk at treningen finnes
SELECT t.treningsID, a.navn, t.startTidspunkt, ts.navn AS senter, s.kapasitet
FROM Trening t
JOIN Aktivitetstype a ON t.aktivitetstypeID = a.aktivitetstypeID
JOIN Sal s ON t.salID = s.salID
JOIN Treningssenter ts ON s.senterID = ts.senterID
WHERE a.navn = 'Spin60'
  AND t.startTidspunkt = '2026-03-17 18:30';

-- Sjekk at bruker ikke er svartelistet
SELECT epost, erSvartelistet FROM Bruker WHERE epost = 'johnny@stud.ntnu.no';

-- Sjekk ledig plass (antall bookinger vs kapasitet)
SELECT COUNT(*) AS antall_booket
FROM Booking b
JOIN Trening t ON b.treningsID = t.treningsID
JOIN Aktivitetstype a ON t.aktivitetstypeID = a.aktivitetstypeID
WHERE a.navn = 'Spin60'
  AND t.startTidspunkt = '2026-03-17 18:30'
  AND b.erPaaVenteliste = 0;

-- Utfør booking (treningsID 11 = Spin60 ti 18:30)
INSERT INTO Booking (epost, treningsID, tidspunktBooket, harMott, erPaaVenteliste)
VALUES ('johnny@stud.ntnu.no', 11, datetime('now'), 0, 0);


-- ============================================================
-- Brukstilfelle 3: Registrering av oppmøte
-- ============================================================

UPDATE Booking SET harMott = 1
WHERE epost = 'johnny@stud.ntnu.no' AND treningsID = 11;


-- ============================================================
-- Brukstilfelle 4: Ukeplan for uke 12 (16.–23. mars 2026)
-- Sortert på tid, treninger fra ulike senter flettes inn
-- ============================================================

SELECT t.startTidspunkt, a.navn AS aktivitet, a.varighet,
       i.fornavn AS instruktor, ts.navn AS senter, s.navn AS sal,
       (SELECT COUNT(*) FROM Booking b
        WHERE b.treningsID = t.treningsID AND b.erPaaVenteliste = 0) AS antallPaameldt,
       s.kapasitet
FROM Trening t
JOIN Aktivitetstype a ON t.aktivitetstypeID = a.aktivitetstypeID
JOIN Sal s ON t.salID = s.salID
JOIN Treningssenter ts ON s.senterID = ts.senterID
LEFT JOIN Instruktor i ON t.instruktorID = i.instruktorID
WHERE t.startTidspunkt >= '2026-03-16'
  AND t.startTidspunkt < '2026-03-23'
ORDER BY t.startTidspunkt;


-- ============================================================
-- Brukstilfelle 5: Personlig besøkshistorie for Johnny
-- siden 1. januar 2026
-- ============================================================

SELECT DISTINCT a.navn AS aktivitet, ts.navn AS senter, t.startTidspunkt
FROM Booking b
JOIN Trening t ON b.treningsID = t.treningsID
JOIN Aktivitetstype a ON t.aktivitetstypeID = a.aktivitetstypeID
JOIN Sal s ON t.salID = s.salID
JOIN Treningssenter ts ON s.senterID = ts.senterID
WHERE b.epost = 'johnny@stud.ntnu.no'
  AND b.harMott = 1
  AND t.startTidspunkt >= '2026-01-01'
ORDER BY t.startTidspunkt;


-- ============================================================
-- Brukstilfelle 6: Svartelisting
-- Sjekk at minst 3 prikker innen siste 30 dager
-- ============================================================

-- Tell prikker siste 30 dager
SELECT COUNT(*) AS antall_prikker
FROM Prikk
WHERE epost = 'johnny@stud.ntnu.no'
  AND dato >= date('now', '-30 days');

-- Svartelisting (utføres kun dersom antall_prikker >= 3)
UPDATE Bruker SET erSvartelistet = 1
WHERE epost = 'johnny@stud.ntnu.no'
  AND (SELECT COUNT(*) FROM Prikk
       WHERE epost = 'johnny@stud.ntnu.no'
         AND dato >= date('now', '-30 days')) >= 3;


-- ============================================================
-- Brukstilfelle 7: Flest fellestreninger i mars 2026
-- ============================================================

SELECT b.epost, br.navn, COUNT(*) AS antall_treninger
FROM Booking b
JOIN Trening t ON b.treningsID = t.treningsID
JOIN Bruker br ON b.epost = br.epost
WHERE b.harMott = 1
  AND t.startTidspunkt >= '2026-03-01'
  AND t.startTidspunkt < '2026-04-01'
GROUP BY b.epost
HAVING antall_treninger = (
    SELECT MAX(cnt) FROM (
        SELECT COUNT(*) AS cnt
        FROM Booking b2
        JOIN Trening t2 ON b2.treningsID = t2.treningsID
        WHERE b2.harMott = 1
          AND t2.startTidspunkt >= '2026-03-01'
          AND t2.startTidspunkt < '2026-04-01'
        GROUP BY b2.epost
    )
)
ORDER BY br.navn;


-- ============================================================
-- Brukstilfelle 8: Treningspartnere
-- Finner par av brukere som har trent sammen
-- ============================================================

SELECT b1.epost AS bruker1, b2.epost AS bruker2,
       COUNT(*) AS felles_treninger
FROM Booking b1
JOIN Booking b2 ON b1.treningsID = b2.treningsID
               AND b1.epost < b2.epost
WHERE b1.harMott = 1 AND b2.harMott = 1
GROUP BY b1.epost, b2.epost
HAVING felles_treninger >= 1
ORDER BY felles_treninger DESC;
