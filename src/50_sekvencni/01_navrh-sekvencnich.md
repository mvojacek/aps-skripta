# Návrh sekvenčních obvodů

## Rozhraní typického sekvenčního obvodu

### Vstupy a výstupy

```kroki-symbolator
module EXP #(
) (
    input [3:0] A,
    input [2:0] B,
    input start,
    input clk,
    output [31:0] OUTP,
    output done
);
endmodule
```

Typický plně synchronní sekvenční obvod bude mít kromě datových vstupů a výstupů navíc následující vstupy a výstupy, které řídí sekvenční povahu obvodu:

- `CLK` - vstup hodinového signálu. Hodinové vstupy všech obvodů v jednom sekvenčním obvodu musí být vždy propojené, aby obvod představoval jedinou hodinovou doménu. V opačném případě se vystavujeme nebezpečí.
- `START` - pokud je vstup `START=1`, inicializuj výpočet podle aktuální hodnoty vstupů, nehledě na to, zda aktuálně nějaký výpočet probíhá. Rovněž je možné (jako optimalizace) během toho cyklu provést první operaci výpočtu, ale není to nutné. Až při `START=0` je možné ve výpočtu pokračovat, a časem ho dokončit.
- `DONE` - pokud je na výstupu `DONE=1`, je výpočet hotový, a výsledek na datových výstupech je validní. Jakmile tohle nastane, musí obvod držet výstupy v neměnném stavu a dále držet `DONE=1`, až do příštího `START=1`. V momentě, kdy se zpracuje `START=1`, musí být na výstupu `DONE=0` (obvod se inicializoval pro další výpočet => výpočet není hotový), aby mohl vnější uživatel očekávat `DONE=1`. Vyjímečně, pokud je výpočet hotový hned v inicializačním cyklu (např. násobička identifikovala násobení nulou => výsledek je triviálně nula), může ihned indikovat `DONE=1`.

### Synchronizace s hodinovým vstupem

Synchronní obvod může být synchronizovaný buď na sestupnou na náběžnou hranu hodin, nebo využívat obě hrany (tato technika se nazývá [Double Data Rate](https://en.wikipedia.org/wiki/Double_data_rate), neboli DDR, což znáte z počítačových pamětí). Návrh používající DDR je vhodný pouze pro realizaci v silikonu (ASIC), nikoliv pro FPGA, kde paměťové prvky reagují buď na jeden nebo druhý typ hrany.

```admonish info
Ve všech naších návrzích budeme používat výhradně **náběžnou** hranu hodin.
```

## Sekvenční algoritmy probírané na hodinách

Všechny Logisim soubory z hodin jsou ke stažení [zde](./20_soubory-z-hodin.md).

### Naivní násobení pomocí iterovaného sčítání

Princip: Pro výpočet $A \times B$ provedeme $B$-krát $ACC \leftarrow ACC + A$. Pokud $ACC$ začínalo na $0$, tak po těchto iteracích bude $ACC = A \times B$.

Tento algoritmus je neskutečně neefektivní, protože počet provedených operací stoupá lineárně s *hodnotou B* (složitost $\mathcal{O}(B)$). Typicky se snažíme, aby počet operací byl úměrný *počtu bitů* B, tedy aby složitost algoritmu byla $\mathcal{O}(\log_2{B})$. Takovou složitost má právě metoda double-and-add popsaná dále.

### Násobení pomocí metody Double-And-Add

Pro urychlení násobení lze využít tzv. [Hornerovo schéma pro násobení polynomů](https://cs.wikipedia.org/wiki/Hornerovo_sch%C3%A9ma):

$$ A \times B \stackrel{např.}{=} A \times 13_{10} = A \times \red{1}\green{1}\blue{0}\purple{1}_2 = \Biggl( \Bigl( (0 \times 2 + \red{1}A) \times 2 + \green{1}A \Bigr) \times 2 + \blue{0}A \Biggr) \times 2 + \purple{1}A $$

Neboli začínáme s hodnotou 0 (neutrální prvek vůči sčítání), a v každém cyklu zpracujeme jeden bit hodnoty B od MSB: pokaždé hodnotu výnásobíme 2, a pak přičteme buď $A$ nebo $0$, právě podle hodnoty bitu z $B$. Proto se algoritmus jmenuje Double-And-Add.

Při zapojení lze provést optimalizaci, kde přeskočíme první iteraci Double-And-Add, protože její výsledek je triviální: Pokud $B_{MSB}=1$, pak výsledek iterace je $A$, jinak je $0$.

### Umocňování pomocí metody Square-And-Multiply

Stejný princip lze použít i pro *umocňování*, pouze s vyššími operátory: Začínáme s hodnotou *1* (neutrální prvek vůči *násobení*), a v každém cyklu *umocníme na druhou*, a pak podmíněně *vynásobíme* hodnotu $A$ podle bitu z $B$:

$$ A ^ B \stackrel{např.}{=} A ^ {13_{10}} = A ^ {\red{1}\green{1}\blue{0}\purple{1}_2} = \Biggl( \Bigl( (1^2 \times A^\red{1})^2 \times A^\green{1} \Bigr)^2 \times A^\blue{0} \Biggr)^2 \times A^\purple{1} $$

Více informací o tomto algoritmu je k dispozici v [KBB přednášce](https://radojcic.cz/kbb3/prezentace/3_teorie_cisel.pdf), kde se používá pro modulární umocňování, a taky v KBB skriptech.

### Double-Dabble algoritmus

Popis algoritmu viz [zadání ALU](../30_alu/90_zadani.md#konverze-z-bin%C3%A1rky-na-bcd-2b). Principem sekvenčního provedení je skutečnost, že pokud explicitně provedeme posun, provádí se jádrová operace algoritmu vždy na ty samé bity. Zároveň lze provést vždy až 4 operace paralelně, jednu na každém řádu (jednotky, desítky, etc.). Modelujeme tedy softwarovou variantu algoritmu, ale opravování číslic provádíme vždy 4-paralelně.
