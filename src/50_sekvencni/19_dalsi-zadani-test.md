# Další zadání a informace k testu

## Test

Test se sekvenčních obvodů proběhne prezenčně na hodině v online prostředí Logisim za následujících podmínek:

- Zadání testu bude přístupné v lokální (neveřejné) kopii skript, kterou můžete během testu používat
- V online Logisimu bude zapnutá simulace, analýza, etc - nic nebude omezeno
- Bude povoleno používat všechny Logisimové komponenty - hradla, plexery, aritmetiku, paměti
  - s výjimkou těch, které přímo řeší zadání (e.g. násobička, pokud zadání je násobení)
  - a těch, které jsou pro zadání nepřiměřeně komplexní (e.g. procesor, velké paměti RAM, etc.)
  - počet některých komponent může být omezen, aby bylo nutné výpočet provádět sekvenčně (e.g. jedna sčítačka, pokud zadání je násobení nebo výpočet výrazu)

## Obecné kompetence

Pro úspěch v testu, tj. prokázání schopnosti postavit funkční sekvenční obvod podle zadání, je potřeba ovládat následující věci:

- Registry s Write-Enable, jejich synchronní chování
- Multiplexory pro rozhodování mezi variantami na nějakém vodiči/vstupu podle kontrolního signálu
- Shift registry, pro paralelně-sériovou konverzi, zejména:
  - zpracování sekvenčního vstupu (hodnoty příchází postupně ale jsou potřeba najednou)
  - ukládání průběžných výsledků (které jsou dostupné postupně) pro paralelní odevzdání na výstup
- Rozvržení paměťové části obvodu - jaké registry budou potřeba pro e.g. mezivýpočty, co v nich kdy bude, jak velké budou
- Návrh datové cesty, tj. úvaha nad tím, jakými všemi způsoby musí být data schopna z registrů a vstupů téct obvodem (provést nějaký výpočet) a zpátky do nějakých registrů nebo výstupů.
  - Realizace této datové cesty pomocí multiplexorů a kontrolních signálů, bez třetího stavu
- Zpracování problému v krocích, tedy:
  - Návrh algoritmu na úrovní RTL (Register Transfer Level), tj. co-kudy-kam poteče v každém kroku.
  - Převod popisu RTL na popis pomocí kontrolních signálů, tj. jaké kontrolní dráty musí mít jakou hodnotu, aby se stalo to, co popisuje RTL, v každém jednotlivém kroku.
  - Zapojení kontrolní jednotky, tj. (pravděpodobně) stepperu a následného výpočtu kontrolních signálů z aktuálního kroku a případně z aktuálního stavu dat v registrech

Tyto kompetence odpovídají látce probírané na hodinách před testem.

## Možné příklady zadání

Zadání, které dostanete, nebude přesně odpovídat žádnému z tady uvedených, ale potřebné kompetence a složitost jsou podobné. V opravdovém zadání se vyskytnou prvky z těchto zadání. Pokud všechny z těchto zadání zvládnete zapojit, nebudete mít s testem problém.

### Světelný had

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

V případě, že WE=1, musí se na výstupu (až s další hranou clk, jedná se o sekvenční obvod!) rozvítit N-tá LED podle hodnoty N na vstupu POS (tedy zápis "adresy" hada zvenčí - proto se vstup jmenuje WE - Write Enable). Až jakmile při hraně clk *není* WE=1, je had "vypuštěn", udělá jeden pohyb a poté se pohybuje normálně dál. Vypuštěný had se vždy začne pohybovat prvně směrem nahoru, kromě případu, kdy POS bylo 15, v takovém případě had rovnou narazil a začíná se pohybovat dolů.

Před prvním zápisem (WE=1) je chování hada nedefinované a nebude testováno.

Možná varianta by např. měla dva nezávislé hady na jednom LED pásku, a jednobitový vstup navíc určující, kterého hada zapisujeme.

### Posuv/Rotace o N

```kroki-symbolator
module SHIFT_ROT #(
) (
    input [15:0] INP,
    input [3:0] SHIFT
    input LEFT,
    input ROTATE,
    input start,
    input clk,
    output [15:0] OUTP,
    output done,
);
endmodule
```

Modul implementuje sekvenční shift/rotaci doleva/doprava o SHIFT bitů. V každém cyklu provede posun o 1 bit, dokud nemá hodnotu posunutou o SHIFT bitů. Platí standardní interface (start+done).

### Klouzavý součet/průměr N hodnot

```kroki-symbolator
module STREAM_AVG #(
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

Nápověda: Evidentně bude potřeba nějak mít uložených vždy posledních N hodnot. Na to se hodí shift registr, buď manuálně postavený, nebo ten logisimový.

### Proudový detektor vlastností posloupnosti

Jednobitová varianta:

```kroki-symbolator
module STREAM_DETECT_BITS #(
) (
    input INP,
    input we,
    input clk,
    output MATCH,
);
endmodule
```

Vícebitová varianta:

```kroki-symbolator
module STREAM_DETECT_VALUES #(
) (
    input [15:0] INP,
    input init,
    input we,
    input clk,
    output MATCH,
    output [15:0] VALUE
);
endmodule
```

Obvod zpracovává hodnoty ze vstupního proudu bitů nebo hodnot (pokud WE=1, jinak vstupy ignoruje). V posledních N (konstanta) hodnotách se snaží najít nějaký vzor, posloupnost s určitými vlastnostmi, etc. Pokud takový vzor našel, indikuje MATCH=1. Pokud to dává smysl podle zadání, zároveň indikuje číslem na výstupu nalezenou vlastnost nebo její parametr, viz konkrétní zadání níže.

Příklady možných detektorů pro jednobitovou variantu:

- Detekuj pattern '10011' (bit úplně vlevo přišel jako poslední)
- Detekuj situaci, kde v posledních N bitech (sudé N) je *stejný počet 0 a 1*.
- Detekuj situaci, kde sekvence N bitů tvoří [palindrom](https://cs.wikipedia.org/wiki/Palindrom)
- ...

Příklady možných detektorů pro vícebitovou variantu

- Detekuj situaci, že všech N posledních čísel bylo sudých
- Detekuj v posledních N bitech [aritmetickou posloupnost](https://cs.wikipedia.org/wiki/Aritmetick%C3%A1_posloupnost), tj. že každé číslo je o libovolné K větší/menší než to předchozí. Koeficient K posloupnosti posíláme na výstup VALUE. Použij jednu odčítačku.
- Detekuj v posledních N bitech [geometrickou posloupnost](https://cs.wikipedia.org/wiki/Geometrick%C3%A1_posloupnost) s daným koeficientem (pro koeficienty, které jsou mocnina dvou je možná optimalizovaná implementace, v ostatních případech je nutné použít násobičku). Použij max. jednu násobičku
- ...

### Proudový analyzátor vyváženosti

```kroki-symbolator
module STREAM_DETECT_BITS #(
) (
    input INP,
    input we,
    input clk,
    output [15:0] BALANCE,
    output BALANCED
);
endmodule
```

Analyzátor beží do nekonečna a na výstupu vždy indikuje vyváženost počtu 0 a 1 ve vstupním proudu *od začátku jeho existence*, tedy nevíme předem z kolika bitů musíme tuto vlastnost vypočítat, není tedy možné ukládat samotné bity, musíme je zpracovávat průběžně.

Je potřeba držet si "vyváženost", tj. číslo se znaménkem ve dvojkovém doplňku, které značí, o kolik víc jedniček, než nul, jsme viděli. Tuto hodnotu dávame na výstup BALANCE. Alternativně lze separátně držet počet jedniček a počet nul a tu pak odečíst, výsledek bude stejný. Výstup BALANCED indikuje, že BALANCE je 0, tj. počet jedniček a nul byl stejný.

### Výpočet matematického výrazu (!!!)

Varianta s paralelními vstupy:

```kroki-symbolator
module STREAM_DETECT_BITS #(
) (
    input [15:0] A,
    input [15:0] B,
    input [15:0] C,
    input [15:0] D,
    input start,
    input clk,
    output [15:0] OUTP,
    output done
);
endmodule
```

Varianta se sériovým vstupem:

```kroki-symbolator
module STREAM_DETECT_BITS #(
) (
    input [15:0] INP,
    input start,
    input clk,
    output [15:0] OUTP,
    output done
);
endmodule
```

Modul musí vypočítat zadaný výraz (e.g. $(A-B)+(C-D)$) pomocí předem určené výpočetní jednotky/jednotek (e.g. jediné sčítačky). Modul musí tento výraz pomocí vhodného, vámi navrženého, algoritmu ve více krocích vypočítat, výsledek vystavit na výstup OUTP a indikovat DONE=1. Platí standardní interface start-done.

U paralelní varianty je buď garantované, že vstupy zůstanou po celou dobu jednoho výpočtu konstantní, anebo není a vstupy se budou během výpočtu měnit, a jsou validní pouze v tom cyklu, ve kterém byl START=1. O kterou variantu se jedná bude upřesněno v zadání.

U sériové varianty typicky platí, že počínaje cyklem, kde START=1, bude v každém clocku na vstupu INP jedna z potřebných hodnot, v nějakém pořadí, e.g. A-B-C-D. Nemusí to ale být vždy přesně takto: první hodnota může být k dispozici např. *až v následujícím cyklu po START=1*. Na hodnotu je pak potřeba jeden cyklus počkat. Zároveň můžou mezi jednotlivými hodnotami být mezery - např. předchozí modul hodnoty vypočítává průbežně a nemá je k dispozici hned za sebou. Pokud v následující notaci *číslo* značí prodlevu tolika cyklů, ve kterých nejsou na vstupu žádné užitečné data, proud hodnot na vstupu může mít např. následující podobu: 1-A-2-B-2-C-D (první startovní cyklus, nedostáváme nic, potom A, potom dva cykly nic, potom B, ...). Hodnoty je pak potřeba ze vstupu přečíst ve správnou dobu. Během toho čekání je možné provádět nějaké výpočty, ale není to nutné, počet cyklů odevzdaného obvodu nemusí být optimální.

Ukázkové zapojení této varianty pro výraz $(A-B)+(C-D)$ s postupem je k dispozici [zde](./20_soubory-z-hodin.md).
