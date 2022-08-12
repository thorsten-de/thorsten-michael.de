<!-- INDEX_START -->
## Motivation

Vielleicht fragst du dich: Warum hast du überhaupt eine persönliche Webseite? Und was steckt dahinter, das Git-Repository öffentlich verfügbar zu machen?

> Das erste Haus baust du für deinen Feind, das zweite für deinen Freund, und das dritte für dich selbst.

Bisher habe ich keine Häuser gebaut, aber im Laufe der letzten Jahre so einige Webseiten und Anwendungen. Manche davon waren Teil meines Berufes, andere waren für Freunde. Einige Anwendungen dienten als Spielwiese für mich selbst, um ein Gefühl für eine  Programmiersprache, ein neues Framework oder eine Technologie zu bekommen. Dann gab es Projekte, die mir geholfen haben, anstehende Dinge zu erledigen. Vielleicht kennst du das: Man erhofft sich, dass sie einem bald eine Menge Arbeit abnehmen, aber bis es soweit ist, sind so viele Stunden ins Land gegangen.

Aber bis heute habe ich nie **meine persönliche Webseite** gebaut. Und das aus gutem Grund: Ich wusste nicht, welche Geschichte ich erzählen soll. Es gibt im Web _n_ langweilige Webseiten, die niemanden interessieren (dabei _n_ sei eine ausreichend große Zahl), warum also die Zeit damit verschwenden, das Web mit der Nummer _n+1_ zu bereichern? Das würde die Welt auch nicht besser machen.

Auf der anderen Seite gibt es da draußen so viele professionelle Portfolios von Personen, die Werbung für sich selbst machen. Damit kann und möchte ich nicht konkurrieren. Also habe ich das Erstellen meiner eigenen Webseite verschoben, bis ich etwas **Grundlegendes zu sagen habe** dass mir **wirklich wichtig ist**, **andere weiterbringt**, und **ehrlich über mich selber** ist.

Dieser Zeitpunkt ist nun gekommen, und zwar aus folgenden Gründen:

- Ich möchte weiterhin von meinem eigenen Mailserver (...@thorsten-michael.de) E-Mails an meine Freunde senden können, die ihre E-Mail bei T-Online haben.[^1]
- Ich bin auf der Suche nach einem neuen Job. Das ist natürlich der wichtigere Grund, etwas über mich, meine Kenntnisse und meine Arbeit zu präsentieren.

Deshalb habe ich mich dazu entschlossen, meine eigene Webseite zu bauen, die **das Haus für mich selbst** sein soll, und ganz nebenbei die Geschichte über ihre Konstruktion zu erzählen. Das Repository ist auf GitHub für die Öffentlichkeit zugänglich, damit nicht nur das Ergebnis sichtbar ist, sondern man einen Blick hinter die Kulissen werfen kann: Wie es gebaut ist und welche Überlegungen dahinterstecken. Das ist eine ganz schöne Herausforderung, bietet mir aber
auch Vorteile:

- ich muss **überlegt vorgehen** und mir **genug Zeit lassen**, da es nicht nur darum geht, etwas schnell zum Laufen zu bringen.
- ich muss **sorgfältig mit sensiblen Daten umgehen**. Die Anwendung muss offensichtlich so
entworfen werden, dass geheime Zugangsdaten außerhalb des Quellcodes konfiguriert werden. Eine
Möglichkeit ist hier, die Konfiguration der Anwendung in Umgebungsvariablen abzulegen, wie in
[The twelve-factor App](https://12factor.net/config) vorgeschlagen wird.

Macht diese Webseite die Welt wirklich besser? Wahrscheinlich nicht. Bringt sie andere weiter? Mag sein, ich hoffe es zumindest. Auf jeden Fall geht es um etwas Grundlegendes, das mir wirklich wichtig ist.

[^1]: Aus Sicht der Netzneutralität klingt das vielleicht wie ein Scherz: Die Mailserver von T-Online weisen legitime E-Mails von einem Mailserver ab, wenn auf der Domäne keine Webseite mit einem ordnungsgemäßen Impressum vorhanden ist. Ein Abuse-Kontakt im WhoIs reicht offensichtlich nicht. Dadurch bin ich gezwungen, meine private Adresse der Öffentlichkeit preiszugeben, was den Datenschutz auf den Kopf stellt. Und natürlich möchte ich keine leere Webseite hosten, nur um ein Impressum zu haben. Am Rande: Sogar DENIC, der Registrar für alle Top-Level ".de" Domains, gibt meine persönlichen Angaben aus Datenschutzgründen nicht preis.
<!-- INDEX_END -->