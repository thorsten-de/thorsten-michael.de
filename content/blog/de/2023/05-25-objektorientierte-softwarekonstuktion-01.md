%{
  title: "Takeaways aus \"Objektorientierte Softwarekonstruktion\", Teil 1: Modularität",
  tags: ~w(OOP Softwareentwicklung Modularität Open-Closed-Prinzip),
  abstract: "In ersten Teil seines Buches \"Object-orientated Software Construction\" prägt Bertrand Meyer im Jahr 1988 das aus \"SOLID\" berühmte Open-Closed-Prinzip (OCP). Er begründet aber vor allem, warum objektorientierte Programmiersprachen überhaupt nötig waren. In Teil 1 geht es darum, wie externe Qualitätsmerkmale und Modularität zum OCP führen.",
  language: "de",
  estimated_reading_time: 10,
  image: "modular-systems"
}
---

Zurzeit sichte ich einige Klassiker zum Thema Softwareentwicklung, und so habe ich mich unlängst durch den ersten Teil von Bertrand Meyers _"Object-orientated Software Construction"_ studiert. In den weiteren Teilen entwirft er mit _Eiffel_ seine eigene objektorientierte Programmiersprache, aber da seit 1988 schon einige Sprachen entstanden sind, konzentriere ich mich darauf, die vorhandenen sinnvoll zu verwenden - dafür bezahlt man mich schließlich.

## Externe Qualitätsmerkmale von Software

Dennoch kann man viel daraus lernen, warum 1988, vor dem Siegeszug von Java, C++ und co, Objektorientierung als nötig angesehen wurde. Das liefert den Rahmen, um objektorientierte Programmierung und Design erfolgreich einzusetzen. Zunächst definiert Meyer fünf _externe Qualitätsmerkmale_ von Software:

- **Korrektheit**: Die Software verhält sich so, wie es in den Anforderungen spezifiziert ist.
- **Robustheit**: Die Software verursacht in Situationen, die außerhalb der spezifizierten Bedingungen liegen, keine Katastrophe. [^1]
- **Erweiterbarkeit**: Die Software  ist _"soft"_, lässt sich leicht an geänderte Anforderungen anpassen.
- **Wiederverwendbarkeit**: Die Software kann - ganz oder in Teilen - in neuen Produkten genutzt werden.
- **Kompatibilität**: Die Software lässt sich leicht mit anderen Produkten kombinieren.

Diese Merkmale werden von Nutzern wahrgenommen, die mit der Software _interagieren_, sei es beim Kauf, Einrichten, Anpassen, Warten oder Nutzen des Systems. Die Korrektheit hat dabei zentrale Bedeutung, denn sonst wäre das System nicht nutzbar. Um korrekte, robuste und kompatible Software zu bauen benötigt man keine Objektorientierung. Anders sieht es bei der Erweiterbarkeit und Wiederverwendbarkeit der Software aus.

## Modularität als internes Qualitätsmerkmal

> Externe Qualitätsmerkmale entstehen aus internen Qualitätsmerkmalen

Damit Erweiterbarkeit und Wiederverwendbarkeit von außen sichtbar sind, muss die Software im Inneren _modular_ aufgebaut sein. Modularität ermöglicht, Systeme aus eigenständigen Elementen in einer einfachen, kohärenten Struktur zu konstruieren. Programmierung, Spezifikation und Design wirken zusammen, um die _Menge_ und die _Form_ der _Kommunikation zwischen den Modulen_ zu kontrollieren.

### Fünf Kriterien für Modularität

Meyer definiert fünf Kriterien oder unabhängige Merkmale, die ein modulares System erfüllen soll:

- **Zerlegbarkeit** (decomposability): Ein komplexes Problem oder System wird in Teile zerlegt, die für sich betrachtet einfacher zu lösen sind. Das ist die Grundlage, um Aufgaben in der Softwareentwicklung aufzuteilen. Auf algorithmischer Ebene entspricht das dem Prinzip _"teile und herrsche" (divide and conquer)_, auf Ebene dem _Top-Down_-Ansatz.
- **Zusammensetzbarkeit** (composability): Das Gegenteil zur Zerlegbarkeit bedeutet, dass sich ein System aus kleinen, wiederverwendbaren Bausteinen konstruiert ist. Wohldefinierte Aufgaben werden wie Legos in ganz verschiedenen Kontexten kombiniert. Das entspricht dem _Bottom-Up_-Ansatz.
- **Verständlichkeit** (understandability): Das Modul erschließt sich dem Betrachter für sich allein, oder mit dem Blick auf nur wenige, benachbarte Module. Temporale Abhängigkeiten, bei dem das Modul in der richtigen Reihenfolge genutzt werden muss, werden vermieden.
- **Kontinuität** (continuity): Kleine Änderungen im System betreffen nur eines oder wenige Module. Insbesondere ist keine strukturelle Änderung der Verbindungen der Module - d.h. der Architektur - erforderlich.
- **Fehlerabgrenzung** (protection): Fehler betreffen ein Modul oder  nur wenige Nachbarn. Fehler lassen sich nicht ausschließen. Ziel ist es, die _Ausbreitung (Propagation)_ von Fehlern zu minimieren.[^1]

### Fünf Prinzipien für Modularität

Aus diesen fünf Kriterien folgen fünf Prinzipien, um Modularität zu erreichen:

- Module bilden in der verwendeten Programmiersprache **eine kompilierbare, syntaktische Einheit**. Nur so können sie zerlegt und zusammengesetzt und die Ausbreitung von Fehlern kontrolliert werden.
- Jedes Modul hat **so wenig Schnittstellen wie möglich**.
- Wenn zwei Module kommunizieren, sind die **Schnittstellen so eingeschränkt wie möglich**. Insbesondere wird kein Wissen über interne Daten und Strukturen vorausgesetzt. Das vermeidet zu enge Koppelung.
- Module kommunizieren über **explizite Schnittstellen**. Das macht die Abhängigkeit offensichtlich, sowohl im Design als auch im Laufzeitverhalten.
- Alles im Modul ist **privat**, bis es **bewusst veröffentlicht wird**. Das Modul kann nur über die öffentliche Schnittstelle nutzen. Diese wird bewusst unabhängig von der Implementierung gemacht.

### Das Open-Closed-Prinzip

Auf dieser Basis formuliert Mayer nun sein _Open-Closed-Prinzip_, das allgemein als das "O" in S**O**LID bekannt ist:

> Ein Modul soll offen sein für Erweiterungen, aber geschlossen gegenüber Veränderungen

Ein Modul ist **offen**, wenn es möglich ist, das Verhalten zu erweitern:

- Felder zu Datenstrukturen hinzufügen
- Funktionen hinzufügen
- bestehende Funktionen erweitern oder anpassen

Ein Modul ist **geschlossen**, sobald es durch seine Schnittstelle von anderen Modulen genutzt werden kann:

- Die Schnittstelle ist stabil und wohldefiniert
- Es ist als Paket / Bibliothek kompiliert und verteilbar

Ziel ist es, dass ein Modul **gleichzeitig offen und geschlossen** ist. Dazu ist _Abstraktion_ nötig. Wenn ein Modul dem Open-Closed-Prinzip entspricht, kann es erweitert werden,

- ohne den _Quelltext_ des Moduls anzupassen
- ohne es neu zu _kompilieren_
- und somit ohne abhängige Module neu zu kompilieren
- oder abhängige Komponenten anzupassen, um sie kompatibel zu halten.

 Meyer kommt zu dem Schluss, dass die klassischen Ansätze seinerzeit (1988) genau dafür keine Lösung geboten haben. Hieraus ergibt sich eine der drei Säulen objektorientierter Programmierung: _Vererbung_ ermöglicht es, die abstrakten Klassen/Interfaces aus einem geschlossenen Modul woanders zu implementieren und zu erweitern. Das Verhalten wird geändert, indem _neuer Code hinzugefügt wird_, anstatt bestehenden Code zu ändern.

## Meine Takeaways

- Objektorientierte Softwarekonstruktion hat das Ziel, nicht nur korrekte und robuste Software zu bauen. Es geht darum, sie so zu bauen, dass sie leicht _erweitert_, _wiederverwendet_ und _gewartet_ werden kann.
- Modulare Software wird nicht durch einen rigorosen divide-and-conquer oder Top-Down-Ansatz auf Systemebene erreicht. Hier muss die Zerlegbarkeit mit anderen Kriterien für Modularität in Einklang gebracht werden.
- Das Ziel objektorientierter Softwareentwicklung ist das Bereitstellen von eigenständigen Modulen, die im System auf unterschiedliche Weise genutzt und erweitert werden. Somit fördert objektorientierte Entwicklung eher einen Bottom-Up-Ansatz.
- Programmiere gegen die öffentliche Schnittstelle, nicht gegen die aktuelle interne Implementierung. Das (nicht-spezifizierte) Verhalten wird sich ändern!
- Gutes objektorientiertes Design ist die Strategie, bewusst zu entscheiden, gegen welche Art von Erweiterungen ein Modul geschlossen sein soll, und schafft die dafür nötigen Abstraktionen.

Im nächsten Teil werde ich weiter auf die Auswirkungen des Open-Closed-Prinzips auf objektorientierte Entwicklung eingehen. Es wird beantwortet, warum der Top-Down-Ansatz in einem _"teile und verzweifle"_ enden kann, und warum man nicht zuerst fragen sollte, was ein System tut, sondern was es dazu befähigt, es zu tun.

[^1]: Michael T. Nygard geht in seinem Buch _"Release It!: Design and Deploy Production-Ready Software"_ darauf ein, wie robuste Software konstruiert wird. Es geht um konkrete Strategien, die verhindern, dass lokale Fehler und Ausfälle sich ausbreiten und das Gesamtsystem lahmlegen. Dazu gibt es beizeiten Takeaways, sobald ich die Lektüre verdaut habe.
