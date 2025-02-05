# Další zadání a informace k testu

## Test

Test se sekvenčních obvodů proběhne prezenčně na hodině v online prostředí Logisim za následujících podmínek:

- Zadání testu bude přístupné v lokální (neveřejné) kopii skript, kterou můžete během testu používat
- V online Logisimu bude zapnutá simulace, analýza, etc - nic nebude omezeno
- Bude povoleno používat všechny Logisimové komponenty - hradla, plexery, aritmetiku, paměti, ...
  - s výjimkou těch, které přímo řeší zadání (e.g. násobička, pokud zadání je násobení)
  - a těch, které jsou pro zadání nepřiměřeně komplexní (e.g. procesor, velké paměti RAM, etc.)
  - počet některých komponent může být omezen, aby bylo nutné výpočet provádět sekvenčně (e.g. jedna sčítačka, pokud zadání je násobení nebo výpočet výrazu)

## Možné příklady zadání

Zadání, které dostanete, nebude přesně odpovídat žádnému z tady uvedených, ale potřebné kompetence a složitost jsou podobné. V opravdovém zadání se vyskytnou prvky z těchto zadání. Pokud všechny z těechto zadání zvládnete zapojit, nebudete mít s testem problém.

## Světelný had

```kroki-symbolator
module HAD #(
) (
    input [3:0] POS,
    input we,
    input clk,
    output [15:0] LIGHTS
);
endmodule
```

N-bitový výstup LIGHTS světelného hada je připojen k řadě N LED světel. Rozsvícená je vždy pouze jediná LED. Dokud je vstup WE=0, tato rozsvícená LED "cestuje" v řetězci LED světel nahoru (směrem k 15. bitu výstupu), a jakmile dorazí na konec, kde stráví přesně jeden cyklus hodin, začne zase cestovat dolů. Na spodním konci se zase otočí a cestuje nahoru, do nekonečna.

V případě, že WE=1, musí se na výstupu rozvítit N-tá LED podle hodnoty N na vstupu POS. Až jakmile WE přejde z 1 na 0, je had "vypuštěn" a začne se pohybovat. Vypuštěný had se vždy začne pohybovat prvně směrem nahoru, kromě případu, kdy POS bylo 15, v takovém případě had rovnou narazil a začíná se pohybovat dolů.

Před prvním zápisem (WE=1) je chování hada nedefinované a nebude testováno.

## Posuv/Rotace o N

```kroki-symbolator
module SHIFTROT #(
) (
    input [15:0] INP,
    input LEFT,
    input ROTATE,
    input start,
    input clk,
    output [15:0] OUTP,
    output done,
);
endmodule
```

Modul implementuje sekvenční shift/rotaci doleva/doprava o N bitů. V každém cyklu provede posun o 1 bit, dokud nemá hodnotu posunutou o N bitů. Platí standardní interface (start+done).

Možná varianta by např. měla dva nezávislé hady na jednom LED pásku, a jednobitový vstup navíc určující, kterého hada zapisujeme.

## Dělička (hodně hard, nad rámec testu)

TODO

## Klouzavý součet/průměr N hodnot

```kroki-symbolator
module STREAMAVG #(
) (
    input [15:0] INP,
    input we,
    input clk,
    output [15:0] OUTP,
);
endmodule
```

Tento sekvenční modul je tzv. *proudový*, tzn. zpracovává *proud (stream)* dat. Modulu přichází na INP postupně za sebou hodnoty, a z posledních N hodnot je potřeba spočítat součet/průměr (pokud je N mocnina dvou, jsou tyto zadání v podstatě ekvivalentní a žádná dělička není potřeba!). Takovému součtu/průměru se říká "klouzavý".

Hodnotu na vstupu bereme v potaz (zahrneme jí do výpočtu) pouze, pokud WE=1. Tedy pokud WE=0, výsledek se nesmí změnit!. Hodnota výsledku je nedefinovaná (nebude testována), dokud modul nezpracoval alespoň N hodnot.

Nápověda: Evidentně bude potřeba nějak mít uložených vždy posledních N hodnot. Na to se hodí shift registr, buď manuálně postavený, nebo ten Logisimový.

## TODO
