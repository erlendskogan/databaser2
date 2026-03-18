# TDT4145 Prosjekt: TreningDB – Del 2
## Gruppe 66: Even Henriksen Bøifot, Erlend Holth Skogan, Henrik Skuterud Mohn

## Filstruktur
- `main.py` — Hovedprogram med interaktiv meny og alle brukstilfeller
- `create_tables.sql` — SQL-script som oppretter databaseskjemaet (fra Del 1)
- `insert_data.sql` — SQL-script som setter inn testdata (Brukstilfelle 1)
- `brukstilfeller.sql` — Frittstående SQL for alle brukstilfeller
- `treningdb.sqlite` — Tom database (opprettes av programmet)
- `output.txt` — Eksempel-output fra automatisk kjøring

## Oppskrift for kjøring

### Krav
- Python 3 (med innebygd sqlite3-modul)
- Ingen ekstra pakker trengs

### Alternativ 1: Automatisk demo (anbefalt for sensor)
Kjører alle brukstilfeller i rekkefølge med eksempeldata:
```bash
python main.py demo
```
Dette oppretter databasen, setter inn data, og kjører brukstilfelle 2–8 automatisk.
Output tilsvarer det som finnes i `output.txt`.

### Alternativ 2: Interaktiv meny
Start programmet uten argumenter for en tekstbasert meny:
```bash
python main.py
```
Menyen lar deg:
1. Velge brukstilfelle med tall (0–8)
2. Skrive inn egne parametere (epost, aktivitet, dato osv.)
3. Trykke Enter for å bruke standardverdier

Eksempel på interaktiv bruk:
```
  Velg (0-8, d, q): 0          ← Initialiserer databasen
  Velg (0-8, d, q): 2          ← Åpner booking
    Epost: johnny@stud.ntnu.no
    Aktivitetsnavn: Spin60
    Tidspunkt: 2026-03-17 18:30
  Velg (0-8, d, q): 4          ← Viser ukeplan
    Startdato: 2026-03-16
    Sluttdato: 2026-03-23
  Velg (0-8, d, q): q          ← Avslutter
```

### Viktig rekkefølge
1. Kjør først **0** (eller **d**) for å opprette databasen med data
2. Deretter kan du kjøre brukstilfellene i valgfri rekkefølge
3. Brukstilfelle 6 (svartelisting) endrer tilstanden — etter dette vil booking feile for Johnny

## Endringer fra Del 1
Ingen endringer er gjort i databaseskjemaet fra Del 1.

## Brukstilfeller

| Nr | Beskrivelse | Levert som |
|----|-------------|------------|
| 1 | Innsetting av data (treningssentre, saler, sykler, brukere, treninger) | SQL |
| 2 | Booking av Spin60 for johnny@stud.ntnu.no | Python + SQL |
| 3 | Registrering av oppmøte | Python + SQL |
| 4 | Ukeplan uke 12 (16.–23. mars) | Python + SQL |
| 5 | Besøkshistorie for Johnny siden 1. jan 2026 | SQL (kjørt fra Python) |
| 6 | Svartelisting av johnny@stud.ntnu.no | Python + SQL |
| 7 | Flest fellestreninger i mars 2026 | Python + SQL |
| 8 | Treningspartnere | SQL (kjørt fra Python) |

## Eksempeldata
- Periode: 16.–18. mars 2026 (mandag–onsdag, uke 12)
- Spinning-aktiviteter på Øya og Dragvoll
- Aktivitetstyper: Spin30, Spin45, Spin60, SpinIntervall, SpinBike
- 8 brukere, 5 instruktører, 21 treninger
- Fasiliteter og sykler satt inn for Øya treningssenter

## Bruk av KI
I arbeidet med Del 2 har vi brukt Claude (KI) som et hjelpeverktøy. Vi har brukt det
til å strukturere Python-koden og diskutere valg rundt SQL-spørringer. Vi har
gjennomgått og tilpasset all generert kode for å sikre at den samsvarer med
databaseskjemaet fra Del 1 og oppgavekravene. Alle SQL-spørringer er verifisert
mot forventet output.
