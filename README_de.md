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
2. Formular ausdrucken - [signatures-empty.pdf](signatures-empty.pdf)
3. Unterschriften eintragen (4x16 = 64 Unterschriften)
4. Formular einscannen - [signatures-max.pdf](signatures-max.pdf)
5. Unterschriften splitten: `./signdiv.sh signatures-max.pdf`

   Erzeugt Unterschriftendateien im Unterverzeichnis "signatures"

6. PDF-Dokument signieren: `./falsisign.sh uli.pdf 200x100+550+700 uli-signed.pdf` 

   Es wird zufällig eine der vorhandenen Unterschriften im Unterverzeichnis "signatures" ausgewählt.
   Momentan funktioniert das nur bei einseitigen PDF-Dokumenten.
   Breite, Höhe, X-Position und Y-Position in "200x100+550+700" müssen angepasst werden an
   das PDF-Dokument.

Quelle und Änderungen
------

Dies ist ein Fork von [https://gitlab.com/edouardklein/falsisign.git](https://gitlab.com/edouardklein/falsisign.git).

Änderungen:

* Deutsche Anleitung (diese Datei)
* Formular in A4
* PDF-Wandlungen für ImageMagick freischalten für Ubuntu-18.04 und neuer

Probleme
--------

### PDF-Wandlung klappt nicht - convert: not authorized

Bei der Ausführung von `./signdiv.sh formular.pdf` erscheint eine Fehlermeldung dieser Art:

```
...
+ convert -density 576 -resize 3560x4752 -transparent white formular.pdf /tmp/falsisign-28220/signatures.png
convert: not authorized `formular.pdf' @ error/constitute.c/ReadImage/412.
convert: no images defined `/tmp/falsisign-28220/signatures.png' @ error/convert.c/ConvertImageCommand/3210.
...
```

Ursache: Aus Sicherheitsgründen ist ImageMagick auf vielen Systemen so konfiguriert, dass keine PDF-Dateien bearbeitet
werden können.

Abhilfe:
* Generelle Lösung:
    1. Wandlung nach PNG mittels `gs`
    2. Weiterverarbeitung mittels `convert` (=Teil von ImageMagick)
* Obsolet - Ubuntu-18.04 oder neuer: Problem sollte nicht mehr auftreten
* Obsolet - Ubuntu-16.04 oder älter: "policy.xml" entfernen - `sudo mv /etc/ImageMagick*/policy.xml /etc/ImageMagick*/policy.xml.deactivated`

Änderungen
----------

* 2020-04-16: Wandlung mit `gs`, Formular signatures-empty.pdf und Muster-Scan signatures-max.pdf
