# Summary

- [Teorie]()
  - [Booleova algebra](./10_teorie/01_booleova-algebra.md)
  - [Logická hradla](./10_teorie/02_hradla.md)
  - [Karnaughova mapa](./10_teorie/03_karnaughova-mapa.md)
  - [Příprava na test](./10_teorie/04_teorie-priprava-test.md)

- [Logisim]()
  - [Instalace](./20_logisim/01_logisim-instalace.md)
  - [Základy](./20_logisim/02_logisim-zaklady.md)
  - [Třetí stav a zkraty](./20_logisim/03_stavy.md)
  - [Multiplexory a dekodéry](./20_logisim/04_multiplexory-dekodery.md)
  - [Komparátor](./20_logisim/05_komparator.md)

- [ALU]()
  - [Úvod](./30_alu/01_alu-uvod.md)
  - [Sčítačka](./30_alu/02_alu-scitacka.md)
  - [Odčítání](./30_alu/03_odcitani.md)
  - [Zadání ALU](./30_alu/90_zadani.md)

- [Paměti]()
  - [Sekvenční obvody](./40_pameti/01_sekvencni-obvody.md)
  - [Asynchronní obvody](./40_pameti/02_asynchronni-obvody.md)
  - [Synchronní obvody](./40_pameti/03_synchronni-obvody.md)

- [Návrh sekvenčních obvodů]()
  - [Návrh sekvenčních obvodů](./50_sekvencni/01_navrh-sekvencnich.md)
  - [Ukázkové zadání: Umocňování](./50_sekvencni/10_zadani-exp.md)
  - [Další zadání a info k testu](./50_sekvencni/19_dalsi-zadani-test.md)
  - [Soubory z hodin](./50_sekvencni/20_soubory-z-hodin.md)
{% if env.APS_TEST_SEKVENCNI | default("") | length > 0 %}
  - [TEST](./50_sekvencni/zadani_test/{{env.APS_TEST_SEKVENCNI}}.md)
    - [Wikipedie k testu](./50_sekvencni/zadani_test/wiki.md)
{% endif %}

- [CPU]()
  - [Úvod](./60_cpu/01_cpu-uvod.md)
  - [Návrh](./60_cpu/02_cpu-design.md)
  - [Stavba](./60_cpu/03_cpu-build.md)
  - [Programování](./60_cpu/04_cpu-programming.md)

- [Ostatní]()
  - [Markdown](./90_ostatni/markdown.md)
  - [Poděkování](./90_ostatni/contributors.md)
  - [Zdroje](./90_ostatni/zdroje.md)
