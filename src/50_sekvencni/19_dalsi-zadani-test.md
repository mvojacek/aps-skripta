{% import "macros.tera" as m %}

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
- Návrh kombinačních obvodů, buď intuitivně nebo podle pravdivostní tabulky
  - Je potřeba pro výpočet kontrolních signálů v kontrolní jednotce, případně pro návrh nějakého výpočtu v datové cestě
  - Je zde možné využít pomocné nástroje a kalkulačky vestavěné v Logisimu.

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

Nápověda: {{ m::spoiler() }} Evidentně bude potřeba nějak mít uložených vždy posledních N hodnot. Na to se hodí shift registr, buď manuálně postavený, nebo ten logisimový. {{ m::spoilerend() }}

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

Takových detektorů bude typicky založen na shift registru/registrech, který používáme na uložení posledních N hodnot, nebo nějaké vlastnosti vypočítané z hodnoty nebo z posledních několika hodnot.

Příklady možných detektorů pro jednobitovou variantu:

- Detekuj pattern '10011' (bit úplně vlevo přišel jako poslední)
- Detekuj situaci, kde v posledních N bitech (sudé N) je *stejný počet 0 a 1*.
  - Nápověda: {{ m::spoiler() }} Pro nízke N je možné sestavit pravdivostní tabulku detektoru této vlastnosti, a implementovat ho pomocí Karnaughovy mapy, nebo pomocí nástrojů vestavěných v Logisimu. {{ m::spoilerend() }}
- Detekuj situaci, kde sekvence N bitů tvoří [palindrom](https://cs.wikipedia.org/wiki/Palindrom)
- ...

Příklady možných detektorů pro vícebitovou variantu

- Detekuj situaci, že všech N posledních čísel bylo sudých
  - Nápověda: {{ m::spoiler() }} Jak na čísle reprezentovaném v binárce poznáme, že je sudé? Je potřeba ukládat N samotných čísel, nebo nám stačí ukládat jejich sudost? {{ m::spoilerend() }}
- Detekuj v posledních N číslech [aritmetickou posloupnost](https://cs.wikipedia.org/wiki/Aritmetick%C3%A1_posloupnost), tj. že každé číslo je o libovolné K větší/menší než to předchozí. Koeficient K posloupnosti posíláme na výstup VALUE. Použij jednu odčítačku.
  - Poznámka: Koeficient K může klidně být záporný (ve dvojkovém doplňku), tj. posloupnost je klesající. Na obvodu to nic nemění, záporné číslo je taky číslo.
  - Nápověda: {{ m::spoiler() }} O aritmetickou posloupnost se jedná, pokud rozdíl sousedních čísel je nějaká jedna hodnota. Máme jedno odčítačku, takže nemůžeme rozdíly počítat paralelně, musíme je počítat hned, jak čísla přicházejí. Neukládáme tedy samotné přicházející čísla, ale pouze rozdíly mezi nimi. K tomu samozřejmě musíme uložit i jedno předchozí číslo, abychom měli proti čemu rozdíl počítat. {{ m::spoilerend() }}
- Detekuj v posledních N číslech [geometrickou posloupnost](https://cs.wikipedia.org/wiki/Geometrick%C3%A1_posloupnost) s daným předem určeným koeficientem K (pro koeficienty, které jsou mocnina dvou je možná optimalizovaná implementace, v ostatních případech je nutné použít násobičku).
  - Poznámka: Oproti předchozímu příkladu je zde koeficient zafixovaný zadáním - umíme tedy detekovat pouze jeden konkrétní "typ" geometrické posloupnosti. Tím se vyhneme nutnosti dělit. Navíc, pokud je koeficient mocnina dvou, stává se násobení jím triviální, a není potřeba ani násobička. Pokud je koeficent mocnina dvou plus jedna nebo mínus jedna, stačí místo násobičky sčítačka.
  - Nápověda: {{ m::spoiler() }} Potřebujeme ověřit, že v posloupnosti platí $X_n = X_{n-1} \cdot K$, tedy že každé přicházející číslo je $K$-násobek předchozího. Ukládáme tedy předchozí přijaté číslo, a vynásobíme ho s $K$. Pokud se příští přijate číslo rovná této hodnotě, tvoří poslední dvě přijaté čísla žádanou posloupnost. Tuto pravdivostní hodnotu uložíme do shift registru. Posloupnost délky $N$ jsme nalezli, pokud v tomto shift registru o délce $N-1$ jsou samé $1$. {{ m::spoilerend() }}
- ...

### Proudový analyzátor vyváženosti

```kroki-symbolator
module STREAM_DETECT_BITS #(
) (
    input INP,
    input we,
    input init,
    input clk,
    output [15:0] BALANCE,
    output BALANCED
);
endmodule
```

Analyzátor beží do nekonečna a na výstupu vždy indikuje vyváženost počtu 0 a 1 ve vstupním proudu *od jeho inicializace*, tedy nevíme předem z kolika bitů musíme tuto vlastnost vypočítat, není tedy možné ukládat samotné bity, musíme je zpracovávat průběžně.

Je potřeba držet si "vyváženost", tj. číslo se znaménkem ve dvojkovém doplňku, které značí, o kolik víc jedniček, než nul, jsme viděli. Tuto hodnotu dávame na výstup BALANCE. Alternativně lze separátně držet počet jedniček a počet nul a tu pak odečíst, výsledek bude stejný. Výstup BALANCED indikuje, že BALANCE je 0, tj. počet jedniček a nul byl stejný. Pro zobrazení hodnot ve dvojkovém doplňku během vývoje doporučuji *Probe*, nastavenou na *Radix: Signed Decimal*.

Protože modul musí začít ve "vyváženém" stavu, ale iniciální hodnota všech pameťových buňek je doopravdy náhodná, potřebuje tento modul navíc (také synchronní) vstup INIT, pomocí kterého lze modul přivést do dobře definovaného, iniciálního, "vyváženého" stavu. Co to konkrétně znamená, záleží na zvolené vnitřní reprezentaci dat v modulu.

### Výpočet matematického výrazu / provedení algoritmu (!!!)

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

U paralelní varianty je buď garantované, že vstupy zůstanou po celou dobu jednoho výpočtu konstantní, anebo tomu tak není, a vstupy se mohou během výpočtu měnit, a jsou validní pouze v tom cyklu, ve kterém byl START=1. Hodnoty vstupů mimo tento moment nesmíme použít, nejsou to hodnoty pro nás! O kterou variantu se jedná bude upřesněno v zadání.

U sériové varianty typicky platí, že počínaje cyklem, kde START=1, bude v každém clocku na vstupu INP jedna z potřebných hodnot, v nějakém pořadí, e.g. A-B-C-D. Nemusí to ale být vždy přesně takto: první hodnota může být k dispozici např. *až v následujícím cyklu po START=1*. Na hodnotu je pak potřeba jeden cyklus počkat. Zároveň můžou mezi jednotlivými hodnotami být mezery - např. předchozí modul hodnoty vypočítává průbežně a nemá je k dispozici hned za sebou. Pokud v následující notaci *číslo* značí prodlevu tolika cyklů, ve kterých nejsou na vstupu žádné užitečné data, proud hodnot na vstupu může mít např. následující podobu: 1-A-2-B-2-C-D (první startovní cyklus, nedostáváme nic, potom A, potom dva cykly nic, potom B, ...). Hodnoty je pak potřeba ze vstupu přečíst ve správnou dobu. Během toho čekání je možné provádět nějaké výpočty, ale není to nutné, počet cyklů odevzdaného obvodu nemusí být optimální.

Ukázkové zapojení paralelní varianty pro výraz $(A-B)+(C-D)$ s postupem je k dispozici [zde](./20_soubory-z-hodin.md).

Další příklady výrazů k výpočtu:

- $A + 2 \cdot B + 3 \cdot C + 4 \cdot D$ pomocí jediné sčítačky.
  - Na výpočet stačí 4 cykly, plus případné registrování vstupů/výstupů.
  - Nápověda: {{ m::spoiler() }} Násobení mocninou dvou lze provést posunem, který je instantní, a $3 \cdot X = 2 \cdot X + X$. Násobička tedy není potřeba. {{ m::spoilerend() }}
- $A^3 + B^2 + C \cdot D$ pomocí jediné násobičky a sčítačky
  - Nabízí se dvě varianty implementace. Druhá varianta bude pomalejší a komplexnější.
    - V každém cyklu vynásobit + možná sečíst
    - V každém cyklu vynásobit *anebo* sečíst
  - Nápověda: {{ m::spoiler() }} $A^3 = A^2 \cdot A$, tento výpočet je potřeba provést ve dvou cyklech. {{ m::spoilerend() }}
- $ A! $, tedy [faktoriál](https://cs.wikipedia.org/wiki/Faktori%C3%A1l) $A$
  - Výsledky budou velké, použijeme tedy 32-bitové čísla. I tak budeme schopni spočítat nejvýše $12!$, vstupní hodnota může tedy být 4 bitová.
  - Nápověda: {{ m::spoiler() }} Bude potřeba udržovat si čítač, který projede rozsah od $2$ do $A$ včetně (nebo od $A$ do $2$, což možná vyjde lépe) a výpočet provádět v akumulátoru, který začně neutrálním prvkem pro násobení. {{ m::spoilerend() }}
- $A + B - C + D \pmod{N}$, kde $N \gt \max{(A, B, C, D)}$, pomocí jedné sčítačky/odčítačky
  - $N$ je v tomto případě další vstup, jako $A, B, C, D$.
  - Obecné modulo vyžaduje děličku, kterou nemáme k dispozici. Ovšem, protože všechna čísla na vstupu jsou menší než $N$, jediné případy, kdy bychom se mohli dostat během výpočtu mimo rozsah hodnot modulární grupy, jsou následující:
    - Pokud výsledek součtu má hodnotu $\ge N$, nebude ale určitě mít hodnotu $\ge 2 \cdot N$, modulo tedy lze provést pomocí pouhého odečtení $N$.  
    Matematicky: $\Bigl(N \le A \lt 2 \cdot N\Bigr) \Rightarrow \Bigl((A \bmod N) = (A - N)\Bigr) $
    - Pokud výsledek odečtení má hodnotu $\lt 0$, nebude ale určitě mít hodnotu $\lt -N$, modulo lze tedy provést přičtením $N$.  
    Matematicky: $\Bigl(-N \le A \lt 0 \Bigr) \Rightarrow \Bigl((A \bmod N) = (A + N)\Bigr) $
  - Po každém příčtení/odečtení v průběhu výpočtu je tedy potřeba zkontrolovat, zda jsme se nedostali mimo rozsah hodnot příjatelných jako výsledek $(\bmod\ N)$, a pokud ano, provést korekci přičtením/odečtením $N$. Protože máme pouze jedinou sčítačku, musí se tato korekce stát až v následujícím cyklu.
  - Algoritmus výpočtu může tedy vypadat nějak takto: {{ m::spoiler(el="div", enable="true") }}<ol>
    $\\
    1.\> \var{R1} \leftarrow \var{A} + \var{B} \\
    2.\> \t{if}\ \var{R1} \ge \var{N}\ \t{then}\ \var{R1} \leftarrow \var{R1} - \var{N} \\
    3.\> \var{R1} \leftarrow \var{R1} - \var{C} \\
    4.\> \t{if}\ \var{R1} \lt 0\ \t{then}\ \var{R1} \leftarrow \var{R1} + \var{N} \\
    5.\> \var{R1} \leftarrow \var{R1} + \var{D} \\
    6.\> \t{if}\ \var{R1} \ge \var{N}\ \t{then}\ \var{R1} \leftarrow \var{R1} - \var{N} \\
    7.\> \t{return}\ \var{R1} \\
    $  
    </ol>  
    Případně lze provést optimalizaci, a kroky $2$, $4$, a $6$ <em>přeskočit</em>, pokud není podmínka splněna, a v daném kroku by se tak nic nestalo.
    {{ m::spoilerend(el="div") }}
  - Tento postup je příklad často používané techniky, kdy jsou požadavky na výsledek jendodušší zajišťovat průběžně jednoduchým výpočtem, místo komplexním výpočtem na konci. Příklad z praxe je např. výpočet kroku [MixColumns](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard#The_MixColumns_step) v šifře AES - zde se násobí polynom polynomem modulo polynom z $\t{GF}(2^8)$. Spočítat polynomiální modulo je náročné, ale pokud postupujeme při násobení bit po bitu, můžeme místo závěrečného modula průbežně aplikovat podmíněný xor: "*If processed bit by bit, then, after shifting, a conditional XOR with $\t{1B}_{16}$ should be performed if the shifted value is larger than $\t{FF}_{16}$ (overflow must be corrected by subtraction of generating polynomial).*"

Je možná varianta tohoto zadání, kde místo matematického výrazu (který je potřeba prvně převést na algoritmus), bude poskutnut přímo algoritmus k implementaci.

Dalšími příklady jsou [algoritmy probírané na hodinách](./01_navrh-sekvencnich.md#sekvenční-algoritmy-probírané-na-hodinách), ke kterým je k dispozici i [implementace v Logisimu](./20_soubory-z-hodin.md).
