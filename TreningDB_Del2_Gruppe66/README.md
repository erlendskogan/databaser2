# TDT4145 Prosjekt: TreningDB – Del 2
## Gruppe 66: Even Henriksen Bøifot, Erlend Holth Skogan, Henrik Skuterud Mohn

## Filstruktur
- `main.py` — Hovedprogram med alle brukstilfeller (Python + SQL)
- `create_tables.sql` — SQL-script som oppretter databaseskjemaet (fra Del 1)
- `insert_data.sql` — SQL-script som setter inn testdata (Brukstilfelle 1)
- `brukstilfeller.sql` — Frittstående SQL for alle brukstilfeller
- `treningdb.sqlite` — Tom database (opprettes av programmet)
- `output.txt` — Eksempel-output fra kjøring av programmet

## Kjøring
Kjør følgende kommando i terminalen:

```bash
python main.py
```

Programmet vil:
1. Opprette databasen og sette inn all data (brukstilfelle 1)
2. Kjøre alle brukstilfeller (2–8) i rekkefølge med output til terminalen

Krav: Python 3 med sqlite3 (innebygget i Python).

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

## Data
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
