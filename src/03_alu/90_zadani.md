# Zadání projektu ALU

Vytvořte v Logisim Evolution modul tzv. Aritmeticko-Logické jednotky (ALU). ALU je (v našem provedení) kombinační obvod, který umí provést vždy jednu vybranou z několika podporovaných aritmetických nebo logických operací.

## Formální náležitosti odevzdání

```admonish danger
V případě nedodržení některého z těchto požadavků bude ALU hodnoceno 0 body.
```

### Odevzdání

- Odevzdáváte vždy zip archiv `alu_{jmeno}_{prijmeni}_{cislo odevzdani}.zip` obsahující:

| Název souboru         | Popis                                                          |
|-----------------------|----------------------------------------------------------------|
| ALU.circ              | Projektový soubor Logisimu obsahující ALU                      |
| *.circ                | Libovolné další .circ soubory nutné pro funkčnost ALU          |
| OPCODES.txt           | Strojově čitelný popis operačních kódů implementovaných v ALU  |
| Dokumentace.xlsx/.odt | Uživatelsky přívětivá dokumentace ALU                          |
| README.md             | Jakékoliv další připomínky k odevzdání                         |

```admonish warning
Je potřeba dodržet přesné názvy souborů, včetně kapitalizace! ALU budu vyhodnocovat částečně strojově, v případě špatně pojmenovaných souborů nepůjde ohodnotit.
```

### Projekt v Logisimu

- Použijte Logisim **Evolution** 3.9.0
- Modul ALU v Logisimu se **musí** jmenovat `APS`. Pokud ho máte jiný, vytvořte správně pojmenovaný modul a překopírujte obsah.
- Všechna dvou-vstupová hradla musí mít **velikost Narrow**, pokud není vyloženě vhodné mít jinou. Doporučuji použít [template](../logisim/template.circ).
- *Všechny* moduly mají **pojmenované *všechny* vstupy a výstupy** vhodným jménem.
- Používání **třetího stavu** (a jej generující komponenty) je obecně **zakázáno**. U *každého* použití je nutné odůvodnit (text toolem v logisimu v místě použití), proč je to vhodné místo klasických hradel a že nenastává žádný z problémů obecně spojeným s třetím stavem.
- V ALU je dovoleno je používat následující komponenty z knihoven:
  - Wiring: **Splitter, Pin, Probe, Tunnel, Constant**
  - Gates: **NOT, Buffer, AND, OR, NAND, NOR, XOR, XNOR**
- Pro postavení modulu ALU by neměly být žádné jiné komponenty potřeba. V případě nejasností se ptejte. **Mimo modul ALU můžete použít libovolné komponenty** - např. pro testování, ukázku, etc.
- V ALU je pouze ***jedna* instance 16-bit sčítačky**. Všechny operace, které ji potřebují, se na ní musí vystřídat, ALU provádí pouze jednu operaci zároveň. Použití více sčítaček je penalizováno jako *hrubá neefektivita zapojení*.

```admonish hint title="Bonusové operace"
Pro implementování bonusových operací jsou tyto restrikce rozvolněné. Např. uvnitř násobičky můžete použít vestavěnou sčítačku, čímž se zásadně zrychlí simulace obvodu. Dokonce to doporučuji. Nemůžete ale např. pro implementaci násobičky použít logisimovou násobičku.
```

- V modulu `main`, `alu_main`, `alu_showcase` nebo podobně bude implementovaná showcase vašeho ALU:
  - Je zde položený váš ALU modul
  - Všechny vstupy jsou odvozené z komponent, kterým lze jednoduše upravovat hodnota v decimal nebo hexadecimal (např. input pin se správně nastaveným radixem)
  - Všechny výstupy jsou napojené na komponenty, na kterých je srozumitelně vidět jejich hodnota (opět decimal nebo hexadecimal) (např. LED, output pin se správně nastaveným radixem)
  - Radix (soustava, e.g. decimal nebo hexadecimal) všech vstupů a výstupů je stejný

```admonish check title="Příklad showcase"
![](../img/alu_showcase.png =600x center)
```

### Plagiáty

Všechny projekty v předmětu APS jsou samostatné práce, musí tedy produktem vaší vlastní práce. Je povoleno projekty probírat, konzultovat, nechat si pomoct s řešením problému. Je nepřípustné odevzdávat cizí práci, a to včetně případů, kdy jste obvod podle předlohy zapojili sami.

Ve skriptech a na internetu je dostatek informací pro řešení projektu, je nutné danou problematiku pochopit.

Do výsledného hodnocení se bude vždy započítávat pouze vaše vlastní práce. V případě porušení budou uděleny nevratné záporné body.

## Hodnocení

Za ALU, které **správně** implementuje všechny zadané operace, je možné získat až 20 bodů.

V případě, ALU je hodnocené 20 body, je možné získat až 4 bonusové body za bonusové operace.

## Vstupy a výstupy (I/O) ALU

Naše ALU je 16-bitové, to znamená že umí zpracovat data (čísla) o šířce 16 bitů. Z toho vyplývá, že všechny vstupy a výstupy, kterými tečou data (čísla), musí mít 16 bitů.

| Název v Logisimu | I/O | Šířka | Popis funkce |
|------------------|:---:|------:|--------------|
| `A`, `B` | IN  | 16 | 16-bitové vstupy do ALU |
| `CIN`    | IN  | 1  | Vstup carry-in (borrow-in) pro některé ALU operace (+, -, posuny, ...) |
| `SEL`    | IN  | 4  | Vybírá aktuálně prováděnou operaci v ALU |
| `OUTP`   | OUT | 16 | 16-bitový výstup z ALU |
| `HOUT`   | OUT | 16 | Horní polovina výsledku, pokud je výsledek operace širší než 16 bitů (např. násobení 16bit x 16bit) |
| `COUT`   | IN  | 1  | Výstup carry-out (borrow-out) pro některé ALU operace (+, -, posuny, ...) |
| `ZERO`   | OUT | 1  | Indikuje, že `OUTP` je roven `0` |
| `SIGN`   | OUT | 1  | Indikuje, že `OUTP`, pokud ho interpretujeme ve dvojkovém doplňku, je záporné číslo |
| `OVER`   | OUT | 1  | V případě, že došlo k součtu, indikuje, že pokud by se operace brala jako ve dvojkovém doplňku, je výsledek nevalidní (nevešel se do reprezentovatelného rozsahu) |
| `GT`, `LT`, `EQ`  | OUT | 1  | Indikují vztah porovnání mezi `A` a `B` nezávisle na aktuálně vybrané operaci. `GT` se rozumí `A > B`. |

```admonish info
Ne všechny I/O musí být nutně přítomné, pouze ty, které jsou potřeba pro nějakou z implementovaných operací. Taky je přípustné mít I/O navíc, které slouží nějaké funkcionalitě nad rámec, nebo bonusovým operacím - v takových situacích bude funkcionalita ověřena ručně.
```

```admonish important
Vstupy a výstupy musí být pojmenované *přesně* podle tabulky, jinak jejich hodnota nebude při opravování brána v potaz! Modul ALU se musí jmenovat `ALU`!
```

### Definovanost výstupů a relevance výstupů

Následující tabulka definuje, které výstupy musí být pro danou operaci smysluplně definované (mít hodnotu podle definice operace).

```admonish hint
Jako rule of thumb platí: každý výstup z ALU by měl být vypočten pomocí aktuálně vybrané operace v ALU, nebo být $0$ pokud to nedává smysl.
```

| ID | Inputy | Outputy |
|:--:|:-------|:--------|
| `xor`, `or`, `and` | $\var{A}, \var{B}$ | $\var{OUTP}$ |
| `not` | $\var{A}$ | $\var{OUTP}$ |
| `shr`, `shl` | $\var{A}, \var{CIN}$ | $\var{OUTP}, \var{COUT}$ |
| `rotr`, `rotl` | $\var{A}$ | $\var{OUTP}, \var{COUT}$ |
| `add` | $\var{A}, \var{B}, \var{CIN}$ | $\var{OUTP}, \var{COUT}, \var{OVER}$ |
| `sub_half` | $\var{A}, \var{B}$ | $\var{OUTP}, \var{OVER}$ |
| `sub_full` | $\var{A}, \var{B}, \var{CIN}$ | $\var{OUTP}, \var{COUT}, \var{OVER}$ |
| `inc` | $\var{A}$ | $\var{OUTP}, \var{COUT}, \var{OVER}$ |
| `dec` | $\var{A}$ | $\var{OUTP}, \var{OVER}$ |
| `mul8` | $\slice{\var{A}}{7:0}, \slice{\var{B}}{7:0}$ | $\var{OUTP}$ |
| `mul16` | $\var{A}, \var{B}$ | $\var{HOUT}, \var{OUTP}$ |
| `swap8` | $\var{A}$ | $\var{OUTP}$ |
| `bsh`  | $\var{A}, \slice{\var{B}}{3:0}, \var{CIN}$ | $\var{OUTP}$ |
| `bshl` | $\var{A}, \slice{\var{B}}{3:0}$ | $\var{OUTP}$ |
| `bshr` | $\var{A}, \slice{\var{B}}{3:0}$ | $\var{OUTP}$ |
| *všechny* |  | $\var{ZERO}, \var{SIGN}$ |
| *binární* | | $\var{GT}, \var{LT}, \var{EQ}$ |

```admonish note
V ostatních případech musí hodnota těchto výstupů být $0$! Není přípustné, aby na výstupech kdykoliv byl třetí stav, error, nebo náhodná/nerelvantní hodnota.
```

## Operace ALU

### Pseudokód

$\var{A} \leftarrow \var{B}$ značí assignment, tedy že bity z B se použijí pro konstrukci A (výsledku).

$\{\var{A}, \var{B}\}$ značí konkatenaci, tedy že bity A a B se spojí do širší hodnoty, více důležité bity vlevo. Do takové hodnoty lze i assignovat.

$\forall i$ v tomto kontextu značí "pro všechny $i$ (indexy bitů)", *kromě indexů, pro které operaci nelze provést*. Typicky `0..15`, což jsou indexy bitů 16-bitové hodnoty, kde index $0$ je LSB (Least Significant Bit).

$\slice{\var{A}}{7:0}$ značí *slice* neboli bitový výběr. V tomto případě vybereme bity 7 až 0, ve výsledné hodnotě budou uspořádané tak, že bit z je nejvíc vlevo (MSB), tedy neměníme pořadí bitů.

### Typy operací

| Typ | Význam |
|:---:|--------|
| :bangbang: | Povinné a důležité |
| :exclamation: | Povinné |
| :question: | ...za určitých podmínek |
| :man_shrugging: | Volitelné |
| :student: | Bonusové |

### Operace po bitech (bitwise)

| Typ | ID | Mnemo | Pseudokód | Popis |
|:---:|:--:|-----------|-----------|-------|
| :bangbang: | `xor` | A XOR B | $\forall i: \var{OUTP}_i \leftarrow \var{A}_i \xor \var{B}_i$ | XOR A a B po bitech |
| :bangbang: | `or`  | A OR B | $\forall i: \var{OUTP}_i \leftarrow \var{A}_i \or \var{B}_i$ | OR A a B po bitech |
| :bangbang: | `and` | A AND B | $\forall i: \var{OUTP}_i \leftarrow \var{A}_i \and \var{B}_i$ | AND A a B po bitech |
| :bangbang: | `not` | NOT A | $\forall i: \var{OUTP}_i \leftarrow \bnot{\var{A}_i} $ | NOT A po bitech |

Více informací na wikipedii: [Bitwise operators](https://en.wikipedia.org/wiki/Bitwise_operation#Bitwise_operators)

### Posuny a rotace (shifts and rotations)

| Typ | ID | Mnemo | Pseudokód | Popis |
|:---:|:--:|-----------|-----------|-------|
| :bangbang: | `shr` | SHR A | $\forall i: \var{OUTP}_i \leftarrow \var{A}_{i+1}$ <br> $\var{OUTP}_{15} \leftarrow \var{CIN}$ <br> $\var{COUT} \leftarrow \var{A}_{0}$ | Logický posun doprava |
| :bangbang: | `shl` | SHL A | $\forall i: \var{OUTP}_i \leftarrow \var{A}_{i-1}$ <br> $\var{OUTP}_{0} \leftarrow \var{CIN}$ <br> $\var{COUT} \leftarrow \var{A}_{15}$ | Logický posun doleva |
| :bangbang: | `rotr` | ROTR A | $\forall i: \var{OUTP}_i \leftarrow \var{A}_{i+1}$ <br> $\var{OUTP}_{15} \leftarrow \var{OUTP}_{0}$ | Rotace doprava |
| :bangbang: | `rotl` | ROTL A | $\forall i: \var{OUTP}_i \leftarrow \var{A}_{i-1}$ <br> $\var{OUTP}_{0} \leftarrow \var{OUTP}_{15}$ | Rotace doleva |

```admonish tip
Pomocí logických posunů (a správného použití carry) lze rychle provést dělení a násobení dvěma, a to jak u čísel bez znaménka, tak u čísel v doplňkovém kódu.
```

#### Shifty

```admonish info
Takto naspecifikovaný logický posun se někdy nazývá *rotace skrz carry*.
```

```admonish example title="Shift left (rotate left through carry)",collapsible=true
![](https://upload.wikimedia.org/wikipedia/commons/7/71/Rotate_left_through_carry.svg =500x center)
```

```admonish example title="Shift left (rotate right through carry)",collapsible=true
![](https://upload.wikimedia.org/wikipedia/commons/2/27/Rotate_right_through_carry.svg =500x center)
```

Více informací na wikipedii: [Rotate through carry](https://en.wikipedia.org/wiki/Bitwise_operation#Rotate_through_carry)

#### Rotace

```admonish example title="Rotate left",collapsible=true
![](https://upload.wikimedia.org/wikipedia/commons/0/09/Rotate_left.svg =500x center)
```

```admonish example title="Rotate right",collapsible=true
![](https://upload.wikimedia.org/wikipedia/commons/3/37/Rotate_right.svg =500x center)
```

Vice informací na wikipedii: [Rotate](https://en.wikipedia.org/wiki/Bitwise_operation#Rotate)

### Sčítání a odčítání

| Typ | ID | Mnemo | Pseudokód | Popis |
|:---:|:--:|-----------|-----------|-------|
| :bangbang: | `add` | A ADD B | $\{\var{COUT},\var{OUTP}\}$<br>&emsp;$\leftarrow \var{A} + \var{B} + \var{CIN}$ | Součet respektující carry |
| :bangbang: :question: | `sub_half` | A SUB B | $\var{OUTP} \leftarrow \var{A} - \var{B}$ | Rozdíl bez borrow |
| :bangbang: :question: | `sub_full` | A SUB B | $\{\var{COUT}, \var{OUTP}\}$<br>&emsp;$\leftarrow \var{A} - \var{B} - \var{CIN}$ | Rozdíl respektující borrow |
| :exclamation: | `inc` | INC A | $\{\var{COUT}, \var{OUTP}\}$<br>&emsp;$\leftarrow \var{A} + 1$ | Zvětšení A o 1 |
| :exclamation: | `dec` | DEC A | $\var{OUTP} \leftarrow \var{A} - 1$ | Změnšení A o 1 |

```admonish info
Z operací `sub_half` a `sub_full` stačí implementovat pouze jednu. V případě volby `sub_half` bude pomocí ALU obtížné odečítat větší než 16bit hodnoty.
```

```admonish warning
Operace `inc` a `dec` **neberou** v potaz hodnotu `CIN` a provádějí vždy úpravu o 1!

Operace `inc` **musí** správně vygenerovat `COUT`!

Operace `dec` nemusí správně vygenerovat `COUT` (netestuje se).

Operace `add`, `sub_half`, `sub_full`, `inc`, `dec` musí generovat `OVER`, pro případ, že jim programátor dal čísla se znaménkem.
```

Více informací v kapitolách o [sčítání](./02_alu-scitacka.md) a [odčítání](./03_odcitani.md).

### Bonusové

```admonish info
Pro všechny bonusové operace platí, že můžete používat libovolné komponenty, kromě těch, které přímo implementují danou operaci.

Např. v `mul` můžete použít jakoukoliv sčítačku, ale ne (vestavěnou) násobičku. V `cla` nesmíte použít vestavěnout sčítačku. V barrel shifteru nesmíte použít jakýkoliv vestavěný shifter. etc.
```

| Typ | ID | Mnemo | Pseudokód | Popis |
|:---:|:--:|-----------|-----------|-------|
| :student: | `mul16` | A MUL B | $\{\var{HOUT}, \var{OUTP}\}$<br>&emsp;$\leftarrow \var{A} * \var{B} $ | 16bit násobení A a B |
| :student: :question: | `mul8` | AL MUL BL | $\var{OUTP}$<br>&emsp;$\leftarrow \slice{\var{A}}{7:0} * \slice{\var{B}}{7:0} $ | 8bit násobení spodních<br>polovin A a B |
| :exclamation: :question: | `swap8` | SWAP8 A | $\{\slice{\var{A}}{15:8},\slice{\var{A}}{7:0}\}$<br>&emsp;$\leftarrow \{\slice{\var{A}}{7:0},\slice{\var{A}}{15:8}\}$ | Výměna horního<br>a spodního bytu A |
| :student: | `mul16k` | A MUL B | viz `mul16` | 16b násobení pomocí<br>Karatsubova alg. |
| :student: | `cla` | A ADD B | viz `add` | Použijte místo `add` pokud<br>jste implementovali CLA. |
| :student: | `bsh` | A SHC B | $if\ \var{CIN}$<br>&emsp;$\var{A} \leftarrow \var{A} << \slice{\var{B}}{3:0}$<br>$else$<br>&emsp;$\var{A} \leftarrow \var{A} >> \slice{\var{B}}{3:0}$ | Posun A o B<br>doleva/doprava |
| :student: :question: | `bshl` | A SHL B | $\var{A} \leftarrow \var{A} << \slice{\var{B}}{3:0}$ | Posun A o B doleva |
| :student: :question: | `bshr` | A SHR B | $\var{A} \leftarrow \var{A} >> \slice{\var{B}}{3:0}$ | Posun A o B doprava |
| :student: | `bcd` | BCD A | - | převod A na BCD |

#### Násobení (~2b)

Stačí implementovat násobičku kladných čísel podle naivního násobení pod sebou. Za pokročilejší řešení (násobení čísel ve dvojkovém doplňku, efektivnější násobička jako Dadda nebo Wallace multiplier) získáte větší počet bodů (indikujte v README).

```admonish faq title="Varianty"
Pro splnění násobení je potřeba implementovat buď `mul16` (velká operace), nebo `mul8`+`swap8` (menší operace + pomocná operace).
V obou případech bude možné násobit libovolně velké čísla v softwaru pomocí částečných násobků.

Doporučuji variantu `mul8`+`swap8`, protože bude v obvodu mnohem méně hradel, což urychlí simulaci.

V případě implementace barrel shifteru lze operaci `swap8` vynechat, protože jí lze nahradit pomocí série operací `bshl`, `bshr`, `or`.

Alternativně lze za více bodů rozšířit mul8 na mul16 pomocí Karatsubova algoritmu (viz níže).
```

```admonish tip title="Doporučení"
Používejte během stavění moduly, pokud potřebujete opakovat nějakou část obvodu.
```

#### Karatsubovo efektivní násobení (~1b navíc k násobení)

Alternativní způsob implementace 16bit násobení, pokud už máte postavenou 8bit násobičku.

Standardně je pro implementaci 16bit násobení potřeba provést **čtyři** 8bit násobky (AL\*BL, AL\*BH, AH\*BL, AH\*BH) a posčítat správně výsledky. To odpovídá klasickému "naivnímu" školnímu násobení pod sebou.

Ovšem [Anatolij Alexejevič Karacuba](https://en.wikipedia.org/wiki/Anatoly_Karatsuba) (anglicky Karatsuba) v roce 1962 publikoval algoritmus, pomocí kterého lze 16bit násobení provést pouze pomocí **tří** 8bit násobků, za cenu několika sčítání navíc.

Tento [Karatsubův algoritmus](https://en.wikipedia.org/wiki/Karatsuba_algorithm) se hodí primárně pro urychlení velkých násobků v softwarových rutinách, kde máme od hardwaru k dispozici pouze 8b/16/32b násobení. Počet hardwarových násobení, které je potřeba provést pro vypočtení nbit x nbit násobku je $O(n^{\log_2{3}}) \approx O(n^{1.58})$, což je podstatný rozdíl oproti naivnímu násobení pod sebou, kde je to $O(n^2)$.

Pro implementaci v HW se hodí spíše násobičky založené na efektivnější redukci součtů (Dadda, Wallace), nicméně pro porozumění algoritmu poslouží i jeho implementace v HW.

```admonish info title="Zadání"
Buď:
- implementujte 8bit násbičku klasicky, nebo
- implementujte 4bit násobičku klasicky, a pomocí tří jejich instancí dle Karatsubova algoritmu zapojte 8bit násobičku.

Poté, pomocí tří 8bit násobiček dle Karatsubova algoritmu zapojte 16bit násobičku. Touto násobičkou implementujte operaci `mul16`, ale označte ji v `OPCODES.txt` jako `mul16k`.
```

#### Sčítačka s predikcí přenosů (CLA) (~2b)

Neboli *Carry Lookahead Adder (CLA)*. Klasický postup sčítání zprava doleva (*Ripple-carry adder*) je pomalý. Analýzou vztahu carry-in jednotlivých full-adderů ke vstupům lze zjistit, že každý carry-in/out lze předpovědět přímo ze předchozích vstupů vypočtením několika násobků, které se sečtou. Tedy čas pro výpočet bude vždy pouze daný pouze rychlostí *vícevstupového AND* (kterých se provede několik paralelně) a následného *vícevstupového OR*. Při implementaci v tranzistorech je *vícevstupový AND/OR* rychlejší, než řetězec hradel *XOR+OR*, který najdeme v klasickém *ripple-carry adderu (RCA)*.

Získáváme tedy recept na to, jak postavit sčítačku, kde rychlost výpočtu výsledku je kvazi-konstantní vůči šířce sčítačky, ovšem za cenu velkého nárůstu hradel (pro **každý** full-adder musíme přidat několik širokých AND a jeden široký OR). Velikost prediktoru roste s tím, jak daleko dopředu predikci provádíme. Má tedy smysl udělat určitý trade-off, a predikci někde uříznout. Např. postavit 4b adder s predikcí (velmi rychlý), a ten 4x zřetězit na 16b adder.

Více informací na wikipedii: [Carry lookahead adder](https://en.wikipedia.org/wiki/Carry-lookahead_adder)

Ovšem i po zřetězení 4x 4bit-CLA za sebe není potřeba čekat na ripple-carry propagaci zkrz tyto CLA. Lze použít stejný princip jako předtím, a každý ze čtyř COUT předpovědět ze vstupů ($P$ a $G$ každého CLA lze vypočítat z $P$ a $G$ full-adderů uvnitř). Jednotce, která toto zaopatřuje se říká *Lookahead carry unit (LCU)*, a je to dobře studovaný obvod.

Více informací na wikipedii: [Lookahead carry unit](https://en.wikipedia.org/wiki/Lookahead_carry_unit)

```admonish faq title="Varianty"
- 4bit-CLA, 4x zřetězeno - 1b
- 8bit-CLA, 2x zřetězeno - 2b (relativně velký obvod)
- 4bit-CLA + LCU - 2b
- jiná varianta - dle domluvy
```

```admonish check title="Řešení"
Modifikujte svojí existující sčítačku, nevkládejte do ALU další. V `OPCODES.txt` indikujte místo `add` operaci `cla`.

Do full-adderu přidejte výstupy $P$, $G$. Pro přehlednost umístěte prediktor do samostatného modulu, který bude brát na vstupu všechny $P_i$, $G_i$, a CIN a na výstupu n-bitový COUT (nebo n-krát $COUT_i$).
```

```admonish warning title="Pozor"
V prediktoru se nesmí vyskytovat řetězec z CIN na nejvyšší COUT, to by mělo stejnou rychlost jako RCA. Je potřeba výraz pro predikci každého bitu plně vyexpandovat a vyjádřit jako součet násobků / sum of products (SOP) / disjunktivní normální formu (DNF), a zapojit pomocí vícevstupových hradel.
```

#### Logický posun A doprava/doleva o B míst (Barrel shifter) (~2b)

Pro implementaci posunu o libovolný počet míst se nabízí několik variant, nejefektivnější z hlediska využití tranzistorů je tzv. [*cross-bar shifter*](https://en.wikipedia.org/wiki/Barrel_shifter#/media/File:Crossbar_barrel_shifter.svg). Nicméně používá třetí stav (controlled buffery nebo na úrovni tranzistorů transmission gates), a proto není vhodný pro implementaci na FPGA, které třetí stav nepodporují.

Princip spočívá v rozložení velikosti posunu na součet mocnin dvou (to je jeho binární reprezentace, tu už máme!), a postupného provedení posunu o každou složku součtu zvlášť. Např. posun o 10 provedeme posunem o 8 a o 2 (posun o 4 a o 1 *neprovedeme*). Provedení/neprovedení posunu se dá přepínat multiplexorem.

Přehledný diagram implementace tohoto postupu se poměrně špatně hledá, proto ho uvádím zde:

```admonish quote title="Barrel Shifter pomocí $\\\\log_2{n}$ multiplexorů ([zdroj](https://community.element14.com/technologies/fpga-group/b/blog/posts/systemverilog-study-notes-barrel-shifter-rtl-combinational-circuit))",collapsible=true
![](../img/barrel_shifter_element14.png =600x center)
```

Pro plný počet bodů je potřeba implementovat shift doleva i doprava, v jedné ze dvou variant:

```admonish faq title="Varianty"
- `bsh` - posun doleva pokud $\var{CIN}=1$, jinak posun doprava
- `bshl`+`bshr` - posun každým směrem jako zvlášť operace ALU (vhodné pokud vám zbývá dost volných hodnot selectoru)
```

```admonish info
Není potřeba řešit `CIN` a `COUT` jako u `shl`/`shr`.

Posun u 16bit hodnot dává smysl provádět o 0-15 míst, posun o více má za výsledek vždy 0. Vaše operace nemusí správně řešit větší hodnoty posunu než 15, stačí tedy brát v potaz pouze spodní 4 bity `B`.
```

#### Konverze z binárky na BCD (~2b)

Implementujte v ALU modul, který převede hodnoty 0-9999 na vstupu A na čtyřmístnou reprezentaci čísla v [Binary Coded Decimal (BCD)](https://en.wikipedia.org/wiki/Binary-coded_decimal). Tato reprezentace je vhodná pro e.g. zobrazování hodnot v desítkové soustavě na 7-segmentovém displeji. Toto zobrazování budete mít následně jednodušší implementovat jako output v CPU, címž si zajistíte nějaké body za CPU IO.

Tedy $\slice{\var{OUTP}}{3:0}$ bude obsahovat jednotky, $\slice{\var{OUTP}}{7:4}$ desítky, $\slice{\var{OUTP}}{11:8}$ stovky a $\slice{\var{OUTP}}{15:12}$ tisíce hodnoty na vstupu $A$ interpretované v desítkové soustavě. Čísla na vstupu větší než 9999 nemusíte řešit. Takové čísla se vejdou do 14 bitů, takže stačí pracovat s těmito spodními bity vstupu.

Algoritmus, kterým se tento převod dá efektivně (bez dělení a modula!) provést, se jmenuje [Double-Dabble](https://en.wikipedia.org/wiki/Double_dabble). Dá se implementovat jak v SW (opakovanou aplikací porovnání a přičtení), tak v HW (zařazením za sebe tolik modulů provádějících porovnání+přičtení tak, aby se každému bitu stalo to samé, co v SW rutině). Příklad implementace v HW (pro větší hodnoty než máte zadáno) je [na konci článku o Double-Dabble](https://en.wikipedia.org/wiki/Double_dabble#/media/File:Bin2BCD-DoubleDabble2.svg).

```admonish tip title="Efektivní zapojení"
"Double" v algoritmu je pouze logický posun doleva, ten lze realizovat jednoduše úpravou zapojení vodičů do další fáze (je zdarma).

V jádrové operaci algoritmu "porovnání a podmíněné přičtení" se porovnává s konstantou (>4), a přičítá konstanta (+3). Obvody pro provedení těchto operací jdou oproti obecnému porovnání a sčítání dramaticky zjednodušit, jako jsme delali při úpravě výrazů v Booleově algebře (konstantní jedničky a nuly ve výrazu **vždy** lze nějak zjednodušit). Doporučuji si rozkreslit 4b komparátor a 4b sčítačku s těmito konstantami na jednom vstupu a zjednodušovat pomocí booleovy algebry (zapisovat hodnoty konstantních vodičů a škrtat nepotřebná hradla). Samotné rozhodnutí lze vyřešit malým multiplexorem.

Pouze řešení s efektivním komparátorem a zvětšovačkou bude hodnoceno plným počtem bodů.
```

TODO: {{#check ALU-Zadani | Zadání ALU}}

TODO strojová tabulka

TODO dokumentace

