%{
  title: "Eine Homepage mit Elixir, Phoenix und LiveView?",
  tags: ~w(Blog Phoenix Elixir LiveView),
  abstract: "Ist das dein Ernst? Du hast vollig recht, wenn du dir diese Frage stellst. Der Tech-Stack hinter meiner Seite ist eigenwillig, das muss ich zugeben. Und völlig überzogen, wenn man nur einen kleinen Blog schreiben möchte.",
  language: "de",
}
---
Warum also dieser Aufwand, wenn man doch so einfach einen Wordpress-Blog hosten kann? Oder statische Seiten mit Jekyll, Hugo und Co. generiert? 

## Tech-Stack in der Übersicht

- Elixir
- [Phoenix Web-Framework](https://www.phoenixframework.org/){:target="_blank"}
- [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html){:target="_blank"}
- Postgres
- Bulma
- Docker
- Git

## Elixir

[Elixir](https://elixir-lang.org){:target="_blank"} ist eine dynamische, funktionale Programmiersprache. Wie [Erlang](https://erlang.org){:target="_blank"} wird sie auf der Erlang Virtual Machine *(Beam)* ausgeführt, und nutzt OTP (Open Telecom Platform) als Mittdleware für verteilte, hochverfügbare Syssteme. Erlang/OTP wurde bei Ericson entwickelt, um in Telefonnetzen robuste Switches zu betreiben. Daraus erbeben sich:

- Parallelität
- hohe Verfügbarkeit
- Fehlertoleranz
- Update von Modulen im Betrieb

Die Syntax von Erlang ist an Prolog angelehnt und wirkt etwas antiquiert. Elixir bietet eine moderne Syntax und direkt das nötige Tooling, um effizient und produktiv zu arbeiten:

- Unit-Test-Integration [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html){:target="_blank"}
- Metaprogrammierung
- Templating-Library [Eex](https://hexdocs.pm/eex/EEx.html){:target="_blank"}
- Build-Tool [Mix](https://hexdocs.pm/eex/EEx.html){:target="_blank"}
- Paketmanager [Hex](https://hex.pm)
- herausragende [Dokumentation von Elixir](https://hexdocs.pm/elixir){:target="_blank"} und vieler [Pakete](https://hexdocs.pm/){:target="_blank"}
