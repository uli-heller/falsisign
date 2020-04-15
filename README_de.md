FALSISIGN
=========

Für unsere Auftragsarbeiten müssen wir sehr häufig unsere
Arbeitszeitberichte ausdrucken, unterschreiben, einscannen
und als PDF versenden. Dies ist insbesondere dann sehr
lästig, wenn kein Drucker oder Scanner greifbar ist.

[FALSISIGN](https://gitlab.com/edouardklein/falsisign.git)
scheint eine Lösung zu bieten: Man bereitet eine Reihe von
Unterschriften vor und fügt diese dann bei Bedarf in die
PDF-Dateien ein.

Grundsätzliches Vorgehen
--------

1. Formular erstellen für die Unterschriften
    * DIN A4
    * möglichst randlos
    * hochkant
    * 4 Spalten
    * 16 Zeilen
2. Formular ausdrucken
3. Unterschriften eintragen (4x16 = 64 Unterschriften)
4. Formular einscannen
5. Unterschriften splitten: `./signdiv.sh formular.pdf`

   Erzeugt Unterschriftendateien im Unterverzeichnis "signatures"

6. PDF-Dokument signieren: `xxx` 

Quelle und Änderungen
------

Dies ist ein Fork von [https://gitlab.com/edouardklein/falsisign.git](https://gitlab.com/edouardklein/falsisign.git).

Änderungen:

* Deutsche Anleitung (diese Datei)
* Formular in A4
