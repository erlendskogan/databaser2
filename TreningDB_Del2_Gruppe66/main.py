"""
TDT4145 Prosjekt: TreningDB — Del 2
Gruppe 66: Even Henriksen Bøifot, Erlend Holth Skogan, Henrik Skuterud Mohn

Implementasjon av brukstilfellene i Python med sqlite3.
Kjøring: python main.py
"""

import sqlite3
import os

DB_FILE = "treningdb.sqlite"


def get_connection():
    """Oppretter og returnerer en databaseforbindelse med fremmednøkler aktivert."""
    conn = sqlite3.connect(DB_FILE)
    conn.execute("PRAGMA foreign_keys = ON")
    conn.row_factory = sqlite3.Row
    return conn


def init_database():
    """Brukstilfelle 1: Opprett tabeller og sett inn data."""
    # Slett eksisterende database for ren start
    if os.path.exists(DB_FILE):
        os.remove(DB_FILE)

    conn = get_connection()
    cur = conn.cursor()

    # Kjør create_tables.sql
    with open("create_tables.sql", "r", encoding="utf-8") as f:
        cur.executescript(f.read())

    # Kjør insert_data.sql
    with open("insert_data.sql", "r", encoding="utf-8") as f:
        cur.executescript(f.read())

    conn.commit()
    conn.close()
    print("=== Brukstilfelle 1 ===")
    print("Database opprettet og data satt inn.\n")


def brukstilfelle_2(epost, aktivitetsnavn, tidspunkt):
    """
    Brukstilfelle 2: Booking av trening.
    Parametere: brukernavn (epost), aktivitet og tidspunkt.
    Sjekker at treningen finnes før booking.
    """
    print("=== Brukstilfelle 2: Booking av trening ===")
    print(f"  Bruker:     {epost}")
    print(f"  Aktivitet:  {aktivitetsnavn}")
    print(f"  Tidspunkt:  {tidspunkt}")

    conn = get_connection()
    cur = conn.cursor()

    # Sjekk om brukeren er svartelistet
    cur.execute("SELECT erSvartelistet FROM Bruker WHERE epost = ?", (epost,))
    bruker = cur.fetchone()
    if bruker is None:
        print("  FEIL: Bruker finnes ikke i systemet.")
        conn.close()
        return
    if bruker["erSvartelistet"] == 1:
        print("  FEIL: Bruker er svartelistet og kan ikke booke elektronisk.")
        conn.close()
        return

    # Finn treningen basert på aktivitetsnavn og tidspunkt
    cur.execute("""
        SELECT t.treningsID, t.salID, s.kapasitet, a.navn AS aktivitet,
               i.fornavn AS instruktor, ts.navn AS senter
        FROM Trening t
        JOIN Aktivitetstype a ON t.aktivitetstypeID = a.aktivitetstypeID
        JOIN Sal s ON t.salID = s.salID
        JOIN Treningssenter ts ON s.senterID = ts.senterID
        LEFT JOIN Instruktor i ON t.instruktorID = i.instruktorID
        WHERE a.navn = ? AND t.startTidspunkt = ?
    """, (aktivitetsnavn, tidspunkt))

    trening = cur.fetchone()
    if trening is None:
        print("  FEIL: Ingen trening funnet med gitt aktivitet og tidspunkt.")
        conn.close()
        return

    treningsID = trening["treningsID"]
    kapasitet = trening["kapasitet"]

    # Sjekk om brukeren allerede er booket
    cur.execute("""
        SELECT * FROM Booking WHERE epost = ? AND treningsID = ?
    """, (epost, treningsID))
    if cur.fetchone() is not None:
        print("  FEIL: Bruker er allerede booket på denne treningen.")
        conn.close()
        return

    # Sjekk antall bookinger (ikke venteliste) mot kapasitet
    cur.execute("""
        SELECT COUNT(*) AS antall
        FROM Booking
        WHERE treningsID = ? AND erPaaVenteliste = 0
    """, (treningsID,))
    antall = cur.fetchone()["antall"]

    er_paa_venteliste = 0
    if antall >= kapasitet:
        er_paa_venteliste = 1
        print(f"  Treningen er full ({antall}/{kapasitet}). Settes på venteliste.")

    # Utfør booking
    import datetime
    naa = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

    cur.execute("""
        INSERT INTO Booking (epost, treningsID, tidspunktBooket, harMott, erPaaVenteliste)
        VALUES (?, ?, ?, 0, ?)
    """, (epost, treningsID, naa, er_paa_venteliste))

    conn.commit()

    if er_paa_venteliste:
        print(f"  Bruker {epost} er satt på venteliste for {trening['aktivitet']} "
              f"({trening['senter']}) {tidspunkt}.")
    else:
        print(f"  Booking bekreftet for {epost}: {trening['aktivitet']} "
              f"({trening['senter']}) {tidspunkt}, instruktør {trening['instruktor']}.")

    conn.close()


def brukstilfelle_3(epost, treningsID):
    """
    Brukstilfelle 3: Registrering av oppmøte.
    Parametere: brukernavn (epost) og treningsID.
    Registrerer oppmøte og gir prikk ved manglende oppmøte.
    """
    print("=== Brukstilfelle 3: Registrering av oppmøte ===")
    print(f"  Bruker:      {epost}")
    print(f"  TreningsID:  {treningsID}")

    conn = get_connection()
    cur = conn.cursor()

    # Sjekk at booking finnes
    cur.execute("""
        SELECT b.*, a.navn AS aktivitet
        FROM Booking b
        JOIN Trening t ON b.treningsID = t.treningsID
        JOIN Aktivitetstype a ON t.aktivitetstypeID = a.aktivitetstypeID
        WHERE b.epost = ? AND b.treningsID = ?
    """, (epost, treningsID))

    booking = cur.fetchone()
    if booking is None:
        print("  FEIL: Ingen booking funnet for denne brukeren og treningen.")
        conn.close()
        return

    # Registrer oppmøte
    cur.execute("""
        UPDATE Booking SET harMott = 1
        WHERE epost = ? AND treningsID = ?
    """, (epost, treningsID))

    conn.commit()
    print(f"  Oppmøte registrert for {epost} på {booking['aktivitet']} (treningsID {treningsID}).")
    conn.close()


def brukstilfelle_4(start_dato, slutt_dato):
    """
    Brukstilfelle 4: Ukeplan for alle treninger i en gitt periode.
    Sorteres på tid (treninger fra forskjellige senter flettes inn).
    Parametere: startdag og sluttdag.
    """
    print("=== Brukstilfelle 4: Ukeplan ===")
    print(f"  Periode: {start_dato} til {slutt_dato}")
    print()

    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT t.startTidspunkt, a.navn AS aktivitet, a.varighet,
               i.fornavn AS instruktor, s.navn AS sal,
               ts.navn AS senter,
               (SELECT COUNT(*) FROM Booking b
                WHERE b.treningsID = t.treningsID AND b.erPaaVenteliste = 0) AS antallPaameldt,
               s.kapasitet
        FROM Trening t
        JOIN Aktivitetstype a ON t.aktivitetstypeID = a.aktivitetstypeID
        JOIN Sal s ON t.salID = s.salID
        JOIN Treningssenter ts ON s.senterID = ts.senterID
        LEFT JOIN Instruktor i ON t.instruktorID = i.instruktorID
        WHERE t.startTidspunkt >= ? AND t.startTidspunkt < ?
        ORDER BY t.startTidspunkt
    """, (start_dato, slutt_dato))

    rows = cur.fetchall()
    if not rows:
        print("  Ingen treninger funnet i perioden.")
    else:
        print(f"  {'Tidspunkt':<20} {'Aktivitet':<18} {'Var.':<6} {'Instruktør':<12} "
              f"{'Senter':<12} {'Sal':<24} {'Påmeldt'}")
        print("  " + "-" * 110)
        for r in rows:
            print(f"  {r['startTidspunkt']:<20} {r['aktivitet']:<18} {r['varighet']:<6} "
                  f"{r['instruktor'] or 'Ukjent':<12} {r['senter']:<12} {r['sal']:<24} "
                  f"{r['antallPaameldt']}/{r['kapasitet']}")

    print()
    conn.close()


def brukstilfelle_5(epost, fra_dato):
    """
    Brukstilfelle 5: Personlig besøkshistorie.
    Leveres som SQL (kjøres fra Python).
    """
    print("=== Brukstilfelle 5: Personlig besøkshistorie ===")
    print(f"  Bruker:   {epost}")
    print(f"  Fra dato: {fra_dato}")
    print()

    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT DISTINCT a.navn AS aktivitet, ts.navn AS senter, t.startTidspunkt
        FROM Booking b
        JOIN Trening t ON b.treningsID = t.treningsID
        JOIN Aktivitetstype a ON t.aktivitetstypeID = a.aktivitetstypeID
        JOIN Sal s ON t.salID = s.salID
        JOIN Treningssenter ts ON s.senterID = ts.senterID
        WHERE b.epost = ?
          AND b.harMott = 1
          AND t.startTidspunkt >= ?
        ORDER BY t.startTidspunkt
    """, (epost, fra_dato))

    rows = cur.fetchall()
    if not rows:
        print("  Ingen treningshistorikk funnet.")
    else:
        print(f"  {'Aktivitet':<18} {'Senter':<12} {'Dato/tid'}")
        print("  " + "-" * 50)
        for r in rows:
            print(f"  {r['aktivitet']:<18} {r['senter']:<12} {r['startTidspunkt']}")

    print()
    conn.close()


def brukstilfelle_6(epost):
    """
    Brukstilfelle 6: Svartelisting.
    Sjekker at brukeren har minst 3 prikker innen siste 30 dager.
    """
    print("=== Brukstilfelle 6: Svartelisting ===")
    print(f"  Bruker: {epost}")

    conn = get_connection()
    cur = conn.cursor()

    # Sjekk antall prikker siste 30 dager
    cur.execute("""
        SELECT COUNT(*) AS antall_prikker
        FROM Prikk
        WHERE epost = ?
          AND dato >= date('now', '-30 days')
    """, (epost,))

    antall = cur.fetchone()["antall_prikker"]
    print(f"  Antall prikker siste 30 dager: {antall}")

    if antall >= 3:
        cur.execute("""
            UPDATE Bruker SET erSvartelistet = 1
            WHERE epost = ?
        """, (epost,))
        conn.commit()
        print(f"  Bruker {epost} er nå svartelistet (utestengt fra elektronisk booking).")
    else:
        print(f"  Bruker {epost} har færre enn 3 prikker. Ingen svartelisting.")

    conn.close()
    print()


def brukstilfelle_7(aar, maaned):
    """
    Brukstilfelle 7: Person(er) som har deltatt på flest gruppetimer en gitt måned.
    """
    print("=== Brukstilfelle 7: Flest fellestreninger ===")
    print(f"  Måned: {aar}-{maaned:02d}")
    print()

    conn = get_connection()
    cur = conn.cursor()

    # Finn start og slutt på måneden
    start = f"{aar}-{maaned:02d}-01"
    if maaned == 12:
        slutt = f"{aar + 1}-01-01"
    else:
        slutt = f"{aar}-{maaned + 1:02d}-01"

    cur.execute("""
        SELECT b.epost, br.navn, COUNT(*) AS antall_treninger
        FROM Booking b
        JOIN Trening t ON b.treningsID = t.treningsID
        JOIN Bruker br ON b.epost = br.epost
        WHERE b.harMott = 1
          AND t.startTidspunkt >= ?
          AND t.startTidspunkt < ?
        GROUP BY b.epost
        HAVING antall_treninger = (
            SELECT MAX(cnt) FROM (
                SELECT COUNT(*) AS cnt
                FROM Booking b2
                JOIN Trening t2 ON b2.treningsID = t2.treningsID
                WHERE b2.harMott = 1
                  AND t2.startTidspunkt >= ?
                  AND t2.startTidspunkt < ?
                GROUP BY b2.epost
            )
        )
        ORDER BY br.navn
    """, (start, slutt, start, slutt))

    rows = cur.fetchall()
    if not rows:
        print("  Ingen deltakere funnet i denne måneden.")
    else:
        for r in rows:
            print(f"  {r['navn']} ({r['epost']}): {r['antall_treninger']} treninger")

    print()
    conn.close()


def brukstilfelle_8():
    """
    Brukstilfelle 8: Finn treningspartnere.
    Finner par av brukere som har trent sammen, sortert på antall felles treninger.
    """
    print("=== Brukstilfelle 8: Treningspartnere ===")
    print()

    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT b1.epost AS bruker1, b2.epost AS bruker2,
               COUNT(*) AS felles_treninger
        FROM Booking b1
        JOIN Booking b2 ON b1.treningsID = b2.treningsID
                       AND b1.epost < b2.epost
        WHERE b1.harMott = 1 AND b2.harMott = 1
        GROUP BY b1.epost, b2.epost
        HAVING felles_treninger >= 1
        ORDER BY felles_treninger DESC
    """)

    rows = cur.fetchall()
    if not rows:
        print("  Ingen treningspartnere funnet.")
    else:
        print(f"  {'Bruker 1':<28} {'Bruker 2':<28} {'Felles treninger'}")
        print("  " + "-" * 70)
        for r in rows:
            print(f"  {r['bruker1']:<28} {r['bruker2']:<28} {r['felles_treninger']}")

    print()
    conn.close()


def main():
    """Hovedprogram – kjører alle brukstilfeller i rekkefølge."""
    print("=" * 60)
    print("  TDT4145 Prosjekt: TreningDB – Del 2")
    print("  Gruppe 66")
    print("=" * 60)
    print()

    # 1. Initialiser databasen
    init_database()

    # 2. Booking: Spin60, tirsdag 17. mars kl 18:30, Øya, johnny
    brukstilfelle_2(
        epost="johnny@stud.ntnu.no",
        aktivitetsnavn="Spin60",
        tidspunkt="2026-03-17 18:30"
    )
    print()

    # 3. Registrering av oppmøte for treningen i brukstilfelle 2
    #    Trening 11 = Spin60 ti 18:30 Øya (se insert_data.sql)
    brukstilfelle_3(
        epost="johnny@stud.ntnu.no",
        treningsID=11
    )
    print()

    # 4. Ukeplan for uke 12 (16. mars – 23. mars)
    brukstilfelle_4(
        start_dato="2026-03-16",
        slutt_dato="2026-03-23"
    )

    # 5. Besøkshistorie for Johnny siden 1. januar 2026
    brukstilfelle_5(
        epost="johnny@stud.ntnu.no",
        fra_dato="2026-01-01"
    )

    # 6. Svartelisting av Johnny
    brukstilfelle_6(epost="johnny@stud.ntnu.no")

    # Vis at Johnny nå ikke kan booke
    print("  Forsøker ny booking etter svartelisting:")
    brukstilfelle_2(
        epost="johnny@stud.ntnu.no",
        aktivitetsnavn="Spin30",
        tidspunkt="2026-03-18 07:00"
    )
    print()

    # 7. Flest fellestreninger i mars 2026
    brukstilfelle_7(aar=2026, maaned=3)

    # 8. Treningspartnere
    brukstilfelle_8()


if __name__ == "__main__":
    main()
