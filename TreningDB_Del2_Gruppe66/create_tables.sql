-- TDT4145 Prosjekt: TreningDB
-- SQL-script for å opprette databasen

-- Slå på fremmednøkler i SQLite
PRAGMA foreign_keys = ON;

-- ============================================================
-- Treningssenter
-- ============================================================
CREATE TABLE Treningssenter (
    senterID    INTEGER PRIMARY KEY AUTOINCREMENT,
    navn        TEXT NOT NULL UNIQUE,
    gateadresse TEXT NOT NULL
);

-- ============================================================
-- Åpningstid (svak entitet under Treningssenter)
-- Identifisert av (senterID, ukedag, startTid)
-- ============================================================
CREATE TABLE Aapningstid (
    senterID    INTEGER NOT NULL,
    ukedag      TEXT NOT NULL CHECK (ukedag IN ('Mandag','Tirsdag','Onsdag','Torsdag','Fredag','Lørdag','Søndag')),
    startTid    TEXT NOT NULL,
    sluttTid    TEXT NOT NULL,
    PRIMARY KEY (senterID, ukedag, startTid),
    FOREIGN KEY (senterID) REFERENCES Treningssenter(senterID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Bemanningstid (svak entitet under Treningssenter)
-- Identifisert av (senterID, ukedag, startTid)
-- ============================================================
CREATE TABLE Bemanningstid (
    senterID    INTEGER NOT NULL,
    ukedag      TEXT NOT NULL CHECK (ukedag IN ('Mandag','Tirsdag','Onsdag','Torsdag','Fredag','Lørdag','Søndag')),
    startTid    TEXT NOT NULL,
    sluttTid    TEXT NOT NULL,
    PRIMARY KEY (senterID, ukedag, startTid),
    FOREIGN KEY (senterID) REFERENCES Treningssenter(senterID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Fasilitet
-- ============================================================
CREATE TABLE Fasilitet (
    fasilitetID INTEGER PRIMARY KEY AUTOINCREMENT,
    navn        TEXT NOT NULL
);

-- ============================================================
-- SenterHarFasilitet (M:N mellom Treningssenter og Fasilitet)
-- ============================================================
CREATE TABLE SenterHarFasilitet (
    senterID    INTEGER NOT NULL,
    fasilitetID INTEGER NOT NULL,
    PRIMARY KEY (senterID, fasilitetID),
    FOREIGN KEY (senterID) REFERENCES Treningssenter(senterID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (fasilitetID) REFERENCES Fasilitet(fasilitetID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Sal (tilhører et treningssenter)
-- ============================================================
CREATE TABLE Sal (
    salID       INTEGER PRIMARY KEY AUTOINCREMENT,
    senterID    INTEGER NOT NULL,
    navn        TEXT NOT NULL,
    kapasitet   INTEGER NOT NULL,
    FOREIGN KEY (senterID) REFERENCES Treningssenter(senterID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Tredemølle (tilhører en sal)
-- Identifisert av (salID, mølleNr)
-- ============================================================
CREATE TABLE Tredemolle (
    salID           INTEGER NOT NULL,
    molleNr         INTEGER NOT NULL,
    produsent       TEXT NOT NULL,
    maksHastighet   REAL NOT NULL,
    maksStigning    REAL NOT NULL,
    PRIMARY KEY (salID, molleNr),
    FOREIGN KEY (salID) REFERENCES Sal(salID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Sykkel (tilhører en sal)
-- Identifisert av (salID, sykkelNr)
-- ============================================================
CREATE TABLE Sykkel (
    salID       INTEGER NOT NULL,
    sykkelNr    INTEGER NOT NULL,
    harBodyBike INTEGER NOT NULL DEFAULT 0 CHECK (harBodyBike IN (0, 1)),
    PRIMARY KEY (salID, sykkelNr),
    FOREIGN KEY (salID) REFERENCES Sal(salID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Aktivitetstype
-- ============================================================
CREATE TABLE Aktivitetstype (
    aktivitetstypeID INTEGER PRIMARY KEY AUTOINCREMENT,
    navn             TEXT NOT NULL UNIQUE,
    beskrivelse      TEXT,
    varighet         INTEGER NOT NULL,  -- i minutter
    kategori         TEXT
);

-- ============================================================
-- SenterHarAktivitetstype (M:N: et senter kan tilby flere
-- aktivitetstyper, og en aktivitetstype kan tilbys på flere senter)
-- ============================================================
CREATE TABLE SenterHarAktivitetstype (
    senterID         INTEGER NOT NULL,
    aktivitetstypeID INTEGER NOT NULL,
    PRIMARY KEY (senterID, aktivitetstypeID),
    FOREIGN KEY (senterID) REFERENCES Treningssenter(senterID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (aktivitetstypeID) REFERENCES Aktivitetstype(aktivitetstypeID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Instruktør
-- ============================================================
CREATE TABLE Instruktor (
    instruktorID INTEGER PRIMARY KEY AUTOINCREMENT,
    fornavn      TEXT NOT NULL
);

-- ============================================================
-- Trening (en konkret treningsøkt)
-- ============================================================
CREATE TABLE Trening (
    treningsID       INTEGER PRIMARY KEY AUTOINCREMENT,
    startTidspunkt   TEXT NOT NULL,  -- ISO-format: 'YYYY-MM-DD HH:MM'
    aktivitetstypeID INTEGER NOT NULL,
    instruktorID     INTEGER,
    salID            INTEGER NOT NULL,
    FOREIGN KEY (aktivitetstypeID) REFERENCES Aktivitetstype(aktivitetstypeID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (instruktorID) REFERENCES Instruktor(instruktorID)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (salID) REFERENCES Sal(salID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Bruker
-- ============================================================
CREATE TABLE Bruker (
    epost           TEXT PRIMARY KEY,
    navn            TEXT NOT NULL,
    mobilnr         TEXT NOT NULL,
    erSvartelistet  INTEGER NOT NULL DEFAULT 0 CHECK (erSvartelistet IN (0, 1))
);

-- ============================================================
-- Prikk (svak entitet under Bruker)
-- Identifisert av (epost, prikkID). Vi bruker prikkID som
-- auto-generert, men epost er med som FK.
-- ============================================================
CREATE TABLE Prikk (
    prikkID     INTEGER PRIMARY KEY AUTOINCREMENT,
    epost       TEXT NOT NULL,
    dato        TEXT NOT NULL,  -- ISO-format: 'YYYY-MM-DD'
    FOREIGN KEY (epost) REFERENCES Bruker(epost)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Booking (M:N mellom Bruker og Trening)
-- Attributter: harMøtt, tidspunktBooket, erPåVenteliste
-- ============================================================
CREATE TABLE Booking (
    epost           TEXT NOT NULL,
    treningsID      INTEGER NOT NULL,
    tidspunktBooket TEXT NOT NULL,  -- ISO-format tidspunkt
    harMott         INTEGER NOT NULL DEFAULT 0 CHECK (harMott IN (0, 1)),
    erPaaVenteliste INTEGER NOT NULL DEFAULT 0 CHECK (erPaaVenteliste IN (0, 1)),
    PRIMARY KEY (epost, treningsID),
    FOREIGN KEY (epost) REFERENCES Bruker(epost)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (treningsID) REFERENCES Trening(treningsID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Idrettslag
-- ============================================================
CREATE TABLE Idrettslag (
    lagID   INTEGER PRIMARY KEY AUTOINCREMENT,
    navn    TEXT NOT NULL UNIQUE
);

-- ============================================================
-- IdrettslagsGruppe (tilhører et idrettslag)
-- ============================================================
CREATE TABLE IdrettslagsGruppe (
    gruppeID    INTEGER PRIMARY KEY AUTOINCREMENT,
    lagID       INTEGER NOT NULL,
    gruppenavn  TEXT NOT NULL,
    FOREIGN KEY (lagID) REFERENCES Idrettslag(lagID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- BrukerMedlemskap (M:N mellom Bruker og Idrettslag)
-- ============================================================
CREATE TABLE BrukerMedlemskap (
    epost   TEXT NOT NULL,
    lagID   INTEGER NOT NULL,
    PRIMARY KEY (epost, lagID),
    FOREIGN KEY (epost) REFERENCES Bruker(epost)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (lagID) REFERENCES Idrettslag(lagID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- SalReservasjon (en reservasjon av en sal for en idrettslagsgruppe)
-- ============================================================
CREATE TABLE SalReservasjon (
    reservasjonID   INTEGER PRIMARY KEY AUTOINCREMENT,
    salID           INTEGER NOT NULL,
    gruppeID        INTEGER NOT NULL,
    ukedag          TEXT NOT NULL CHECK (ukedag IN ('Mandag','Tirsdag','Onsdag','Torsdag','Fredag','Lørdag','Søndag')),
    startTid        TEXT NOT NULL,
    sluttTid        TEXT NOT NULL,
    FOREIGN KEY (salID) REFERENCES Sal(salID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (gruppeID) REFERENCES IdrettslagsGruppe(gruppeID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
