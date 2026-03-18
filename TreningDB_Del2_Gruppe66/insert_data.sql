-- TDT4145 Prosjekt: TreningDB
-- Brukstilfelle 1: Innsetting av data
-- Periode: 16. mars – 18. mars 2026 (uke 12)
-- Kun spinning-aktiviteter på Øya og Dragvoll

PRAGMA foreign_keys = ON;

-- ============================================================
-- Treningssentre
-- ============================================================
INSERT INTO Treningssenter (senterID, navn, gateadresse) VALUES
    (1, 'Øya',        'Vangslundgate 2'),
    (2, 'Gløshaugen', 'Strindvegen 2'),
    (3, 'Dragvoll',   'Loholt allé 81'),
    (4, 'Moholt',     'Høgskoleringen 4'),
    (5, 'DMMH',       'Thrond Nergaards vei 7');

-- ============================================================
-- Åpningstider (Øya og Dragvoll)
-- ============================================================
INSERT INTO Aapningstid (senterID, ukedag, startTid, sluttTid) VALUES
    (1, 'Mandag',  '06:00', '23:00'),
    (1, 'Tirsdag', '06:00', '23:00'),
    (1, 'Onsdag',  '06:00', '23:00'),
    (1, 'Torsdag', '06:00', '23:00'),
    (1, 'Fredag',  '06:00', '23:00'),
    (1, 'Lørdag',  '09:00', '20:00'),
    (1, 'Søndag',  '09:00', '20:00'),
    (3, 'Mandag',  '06:30', '22:00'),
    (3, 'Tirsdag', '06:30', '22:00'),
    (3, 'Onsdag',  '06:30', '22:00'),
    (3, 'Torsdag', '06:30', '22:00'),
    (3, 'Fredag',  '06:30', '22:00'),
    (3, 'Lørdag',  '10:00', '18:00'),
    (3, 'Søndag',  '10:00', '18:00');

-- ============================================================
-- Bemanningstider (Øya og Dragvoll)
-- ============================================================
INSERT INTO Bemanningstid (senterID, ukedag, startTid, sluttTid) VALUES
    (1, 'Mandag',  '08:00', '21:00'),
    (1, 'Tirsdag', '08:00', '21:00'),
    (1, 'Onsdag',  '08:00', '21:00'),
    (1, 'Torsdag', '08:00', '21:00'),
    (1, 'Fredag',  '08:00', '21:00'),
    (1, 'Lørdag',  '10:00', '16:00'),
    (1, 'Søndag',  '10:00', '16:00'),
    (3, 'Mandag',  '09:00', '20:00'),
    (3, 'Tirsdag', '09:00', '20:00'),
    (3, 'Onsdag',  '09:00', '20:00'),
    (3, 'Torsdag', '09:00', '20:00'),
    (3, 'Fredag',  '09:00', '20:00');

-- ============================================================
-- Fasiliteter for Øya
-- ============================================================
INSERT INTO Fasilitet (fasilitetID, navn) VALUES
    (1, 'Styrkerom'),
    (2, 'Spinningsal'),
    (3, 'Garderobe'),
    (4, 'Dusj'),
    (5, 'Badstue'),
    (6, 'Klatrevegg'),
    (7, 'Flerbrukshall'),
    (8, 'Functional Fitness'),
    (9, 'Tredemøllerom');

INSERT INTO SenterHarFasilitet (senterID, fasilitetID) VALUES
    (1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
    (1, 6), (1, 7), (1, 8), (1, 9),
    (3, 1), (3, 2), (3, 3), (3, 4);

-- ============================================================
-- Saler (spinningsaler for Øya og Dragvoll)
-- ============================================================
INSERT INTO Sal (salID, senterID, navn, kapasitet) VALUES
    (1, 1, 'Spinningsal 1 Øya',    25),
    (2, 1, 'Spinningsal 2 Øya',    20),
    (3, 3, 'Spinningsal Dragvoll',  18);

-- ============================================================
-- Sykler for Øya (Spinningsal 1 og 2)
-- ============================================================
-- Spinningsal 1: 25 sykler, nr. 1-10 har BodyBike
INSERT INTO Sykkel (salID, sykkelNr, harBodyBike) VALUES
    (1, 1, 1), (1, 2, 1), (1, 3, 1), (1, 4, 1), (1, 5, 1),
    (1, 6, 1), (1, 7, 1), (1, 8, 1), (1, 9, 1), (1, 10, 1),
    (1, 11, 0), (1, 12, 0), (1, 13, 0), (1, 14, 0), (1, 15, 0),
    (1, 16, 0), (1, 17, 0), (1, 18, 0), (1, 19, 0), (1, 20, 0),
    (1, 21, 0), (1, 22, 0), (1, 23, 0), (1, 24, 0), (1, 25, 0);

-- Spinningsal 2: 20 sykler, nr. 1-5 har BodyBike
INSERT INTO Sykkel (salID, sykkelNr, harBodyBike) VALUES
    (2, 1, 1), (2, 2, 1), (2, 3, 1), (2, 4, 1), (2, 5, 1),
    (2, 6, 0), (2, 7, 0), (2, 8, 0), (2, 9, 0), (2, 10, 0),
    (2, 11, 0), (2, 12, 0), (2, 13, 0), (2, 14, 0), (2, 15, 0),
    (2, 16, 0), (2, 17, 0), (2, 18, 0), (2, 19, 0), (2, 20, 0);

-- Spinningsal Dragvoll: 18 sykler, ingen BodyBike
INSERT INTO Sykkel (salID, sykkelNr, harBodyBike) VALUES
    (3, 1, 0), (3, 2, 0), (3, 3, 0), (3, 4, 0), (3, 5, 0),
    (3, 6, 0), (3, 7, 0), (3, 8, 0), (3, 9, 0), (3, 10, 0),
    (3, 11, 0), (3, 12, 0), (3, 13, 0), (3, 14, 0), (3, 15, 0),
    (3, 16, 0), (3, 17, 0), (3, 18, 0);

-- ============================================================
-- Tredemøller for Øya (i en tenkt tredemøllesal, salID=4)
-- ============================================================
INSERT INTO Sal (salID, senterID, navn, kapasitet) VALUES
    (4, 1, 'Kondisrom Øya', 40);

INSERT INTO Tredemolle (salID, molleNr, produsent, maksHastighet, maksStigning) VALUES
    (4, 1, 'Technogym',  22.0, 15.0),
    (4, 2, 'Technogym',  22.0, 15.0),
    (4, 3, 'Life Fitness', 20.0, 15.0),
    (4, 4, 'Life Fitness', 20.0, 15.0),
    (4, 5, 'Precor',      20.0, 12.0);

-- ============================================================
-- Aktivitetstyper (spinning-varianter fra SiT)
-- ============================================================
INSERT INTO Aktivitetstype (aktivitetstypeID, navn, beskrivelse, varighet, kategori) VALUES
    (1, 'Spin30',
     'En kort og intensiv spinningøkt på 30 minutter. Perfekt for deg som ønsker rask og effektiv trening med høy intensitet.',
     30, 'Spinning'),
    (2, 'Spin45',
     'Klassisk spinningtime på 45 minutter med variert intensitet. Kombinerer intervaller og utholdenhetsarbeid til musikk.',
     45, 'Spinning'),
    (3, 'Spin60',
     'Hel spinningtime på 60 minutter med lengre intervaller og utholdenhetspartier. God trening for de som ønsker en grundig økt.',
     60, 'Spinning'),
    (4, 'SpinIntervall',
     'Intervallbasert spinningtime med korte, intense arbeidsperioder etterfulgt av aktiv restitusjon. Effektivt for å øke maksimalt oksygenopptak.',
     45, 'Spinning'),
    (5, 'SpinBike',
     'Spinningtime med fokus på BodyBike-funksjonalitet. Koble til appen for å følge watt og kadens i sanntid.',
     45, 'Spinning');

-- Knytt spinning-aktiviteter til Øya og Dragvoll
INSERT INTO SenterHarAktivitetstype (senterID, aktivitetstypeID) VALUES
    (1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
    (3, 1), (3, 2), (3, 3), (3, 4);

-- ============================================================
-- Instruktører
-- ============================================================
INSERT INTO Instruktor (instruktorID, fornavn) VALUES
    (1, 'Tore'),
    (2, 'Anders'),
    (3, 'Hedda'),
    (4, 'Marte'),
    (5, 'Kristian');

-- ============================================================
-- Brukere
-- ============================================================
INSERT INTO Bruker (epost, navn, mobilnr, erSvartelistet) VALUES
    ('johnny@stud.ntnu.no',  'Johnny Bransen',   '91234567', 0),
    ('anna@stud.ntnu.no',    'Anna Nilsen',      '92345678', 0),
    ('ola@stud.ntnu.no',     'Ola Nordmann',     '93456789', 0),
    ('kari@stud.ntnu.no',    'Kari Hansen',      '94567890', 0),
    ('per@stud.ntnu.no',     'Per Olsen',        '95678901', 0),
    ('lisa@stud.ntnu.no',    'Lisa Berg',        '96789012', 0),
    ('erik@stud.ntnu.no',    'Erik Dahl',        '97890123', 0),
    ('maria@stud.ntnu.no',   'Maria Vik',        '98901234', 0);

-- ============================================================
-- Treninger (spinning, 16.–18. mars 2026, Øya og Dragvoll)
-- 16. mars = mandag, 17. mars = tirsdag, 18. mars = onsdag
-- ============================================================

-- === Mandag 16. mars – Øya ===
INSERT INTO Trening (treningsID, startTidspunkt, aktivitetstypeID, instruktorID, salID) VALUES
    (1,  '2026-03-16 07:00', 1, 1, 1),   -- Spin30, Tore, Spinningsal 1
    (2,  '2026-03-16 09:00', 3, 2, 1),   -- Spin60, Anders, Spinningsal 1
    (3,  '2026-03-16 16:30', 2, 3, 1),   -- Spin45, Hedda, Spinningsal 1
    (4,  '2026-03-16 18:00', 4, 4, 2),   -- SpinIntervall, Marte, Spinningsal 2
    (5,  '2026-03-16 20:00', 5, 1, 1);   -- SpinBike, Tore, Spinningsal 1

-- === Mandag 16. mars – Dragvoll ===
INSERT INTO Trening (treningsID, startTidspunkt, aktivitetstypeID, instruktorID, salID) VALUES
    (6,  '2026-03-16 10:00', 2, 5, 3),   -- Spin45, Kristian, Dragvoll
    (7,  '2026-03-16 17:00', 3, 5, 3);   -- Spin60, Kristian, Dragvoll

-- === Tirsdag 17. mars – Øya ===
INSERT INTO Trening (treningsID, startTidspunkt, aktivitetstypeID, instruktorID, salID) VALUES
    (8,  '2026-03-17 07:00', 1, 2, 1),   -- Spin30, Anders, Spinningsal 1
    (9,  '2026-03-17 10:00', 3, 3, 2),   -- Spin60, Hedda, Spinningsal 2
    (10, '2026-03-17 16:00', 4, 1, 1),   -- SpinIntervall, Tore, Spinningsal 1
    (11, '2026-03-17 18:30', 3, 4, 1),   -- Spin60, Marte, Spinningsal 1
    (12, '2026-03-17 20:00', 2, 2, 2);   -- Spin45, Anders, Spinningsal 2

-- === Tirsdag 17. mars – Dragvoll ===
INSERT INTO Trening (treningsID, startTidspunkt, aktivitetstypeID, instruktorID, salID) VALUES
    (13, '2026-03-17 09:00', 1, 5, 3),   -- Spin30, Kristian, Dragvoll
    (14, '2026-03-17 17:30', 2, 5, 3);   -- Spin45, Kristian, Dragvoll

-- === Onsdag 18. mars – Øya ===
INSERT INTO Trening (treningsID, startTidspunkt, aktivitetstypeID, instruktorID, salID) VALUES
    (15, '2026-03-18 07:00', 1, 3, 1),   -- Spin30, Hedda, Spinningsal 1
    (16, '2026-03-18 09:30', 3, 1, 1),   -- Spin60, Tore, Spinningsal 1
    (17, '2026-03-18 16:00', 5, 4, 2),   -- SpinBike, Marte, Spinningsal 2
    (18, '2026-03-18 18:00', 4, 2, 1),   -- SpinIntervall, Anders, Spinningsal 1
    (19, '2026-03-18 20:00', 2, 3, 2);   -- Spin45, Hedda, Spinningsal 2

-- === Onsdag 18. mars – Dragvoll ===
INSERT INTO Trening (treningsID, startTidspunkt, aktivitetstypeID, instruktorID, salID) VALUES
    (20, '2026-03-18 10:00', 3, 5, 3),   -- Spin60, Kristian, Dragvoll
    (21, '2026-03-18 17:00', 4, 5, 3);   -- SpinIntervall, Kristian, Dragvoll

-- ============================================================
-- Bookinger og oppmøte
-- Gir Johnny og andre brukere treningshistorikk
-- ============================================================

-- Johnny booker og møter opp på flere treninger
INSERT INTO Booking (epost, treningsID, tidspunktBooket, harMott, erPaaVenteliste) VALUES
    ('johnny@stud.ntnu.no', 2,  '2026-03-14 09:00', 1, 0),  -- Spin60 ma 09
    ('johnny@stud.ntnu.no', 4,  '2026-03-14 18:00', 1, 0),  -- SpinIntervall ma 18
    ('johnny@stud.ntnu.no', 15, '2026-03-16 07:00', 1, 0),  -- Spin30 on 07
    ('johnny@stud.ntnu.no', 18, '2026-03-16 18:00', 1, 0);  -- SpinIntervall on 18

-- Anna trener mye (for brukstilfelle 7)
INSERT INTO Booking (epost, treningsID, tidspunktBooket, harMott, erPaaVenteliste) VALUES
    ('anna@stud.ntnu.no', 1,  '2026-03-14 07:00', 1, 0),
    ('anna@stud.ntnu.no', 3,  '2026-03-14 16:30', 1, 0),
    ('anna@stud.ntnu.no', 8,  '2026-03-15 07:00', 1, 0),
    ('anna@stud.ntnu.no', 11, '2026-03-15 18:30', 1, 0),
    ('anna@stud.ntnu.no', 15, '2026-03-16 07:00', 1, 0),
    ('anna@stud.ntnu.no', 18, '2026-03-16 18:00', 1, 0),
    ('anna@stud.ntnu.no', 19, '2026-03-16 20:00', 1, 0);

-- Ola trener med Johnny (for brukstilfelle 8 - treningspartnere)
INSERT INTO Booking (epost, treningsID, tidspunktBooket, harMott, erPaaVenteliste) VALUES
    ('ola@stud.ntnu.no', 2,  '2026-03-14 09:00', 1, 0),
    ('ola@stud.ntnu.no', 4,  '2026-03-14 18:00', 1, 0),
    ('ola@stud.ntnu.no', 11, '2026-03-15 18:30', 1, 0),
    ('ola@stud.ntnu.no', 18, '2026-03-16 18:00', 1, 0);

-- Kari trener noe
INSERT INTO Booking (epost, treningsID, tidspunktBooket, harMott, erPaaVenteliste) VALUES
    ('kari@stud.ntnu.no', 1,  '2026-03-14 07:00', 1, 0),
    ('kari@stud.ntnu.no', 6,  '2026-03-14 10:00', 1, 0),
    ('kari@stud.ntnu.no', 9,  '2026-03-15 10:00', 1, 0),
    ('kari@stud.ntnu.no', 15, '2026-03-16 07:00', 1, 0);

-- Per, Lisa, Erik, Maria trener noe
INSERT INTO Booking (epost, treningsID, tidspunktBooket, harMott, erPaaVenteliste) VALUES
    ('per@stud.ntnu.no',   3,  '2026-03-14 16:30', 1, 0),
    ('per@stud.ntnu.no',   10, '2026-03-15 16:00', 1, 0),
    ('lisa@stud.ntnu.no',  2,  '2026-03-14 09:00', 1, 0),
    ('lisa@stud.ntnu.no',  11, '2026-03-15 18:30', 1, 0),
    ('erik@stud.ntnu.no',  5,  '2026-03-14 20:00', 1, 0),
    ('erik@stud.ntnu.no',  12, '2026-03-15 20:00', 1, 0),
    ('maria@stud.ntnu.no', 7,  '2026-03-14 17:00', 1, 0),
    ('maria@stud.ntnu.no', 14, '2026-03-15 17:30', 1, 0);

-- Johnny har IKKE møtt opp på 3 treninger (for svartelisting, brukstilfelle 6)
-- Prikker som brukes i svartelistingslogikken
INSERT INTO Prikk (prikkID, epost, dato) VALUES
    (1, 'johnny@stud.ntnu.no', '2026-03-05'),
    (2, 'johnny@stud.ntnu.no', '2026-03-10'),
    (3, 'johnny@stud.ntnu.no', '2026-03-15');

-- ============================================================
-- Idrettslag og grupper
-- ============================================================
INSERT INTO Idrettslag (lagID, navn) VALUES
    (1, 'NTNUI');

INSERT INTO IdrettslagsGruppe (gruppeID, lagID, gruppenavn) VALUES
    (1, 1, 'NTNUI Basket'),
    (2, 1, 'NTNUI Volleyball');

INSERT INTO BrukerMedlemskap (epost, lagID) VALUES
    ('johnny@stud.ntnu.no', 1),
    ('anna@stud.ntnu.no',   1),
    ('ola@stud.ntnu.no',    1);

-- En salreservasjon for NTNUI Basket
INSERT INTO SalReservasjon (reservasjonID, salID, gruppeID, ukedag, startTid, sluttTid) VALUES
    (1, 1, 1, 'Onsdag', '12:00', '14:00');
