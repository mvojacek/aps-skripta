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
| `xor`, `or`, `and` | `A`, `B` | `OUTP` |
| `not` | `A` | `OUTP` |
| `shr`, `shl` | `A`, `CIN` | `OUTP`, `COUT` |
| `rotr`, `rotl` | `A` | `OUTP`, `COUT` |
| `add` | `A`, `B`, `CIN` | `OUTP`, `COUT`, `OVER` |
| `sub_half` | `A`, `B` | `OUTP`, `OVER` |
| `sub_full` | `A`, `B`, `CIN` | `OUTP`, `COUT`, `OVER` |
| `inc` | `A` | `OUTP`, `COUT`, `OVER` |
| `dec` | `A` | `OUTP`, `OVER` |
| `mul8` | $\slice{A}{7:0}$, $\slice{B}{7:0}$ | `OUTP` |
| `mul16` | `A`, `B` | `HOUT`, `OUTP` |
| `swap8` | `A` | `OUTP` |
| *všechny* |  | `ZERO`, `SIGN` |
| *binární* | | `GT`, `LT`, `EQ` |

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
| :bangbang: | `not` | NOT A | $\forall i: \var{OUTP}_i \leftarrow \not{\var{A}_i} $ | NOT A po bitech |

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

| Typ | ID | Mnemo | Pseudokód | Popis |
|:---:|:--:|-----------|-----------|-------|
| :student: | `mul16` | A MUL B | $\{\var{HOUT}, \var{OUTP}\}$<br>&emsp;$\leftarrow \var{A} * \var{B} $ | 16bit násobení A a B |
| :student: | `mul8` | AL MUL BL | $\var{OUTP}$<br>&emsp;$\leftarrow \slice{\var{A}}{7:0} * \slice{\var{B}}{7:0} $ | 8bit násobení spodních<br>polovin A a B |
| :exclamation: :question: | `swap8` | SWAP8 A | $\{\slice{\var{A}}{15:8},\slice{\var{A}}{7:0}\}$<br>&emsp;$\leftarrow \{\slice{\var{A}}{7:0},\slice{\var{A}}{15:8}\}$ | Výměna horního<br>a spodního bytu A |
| :student: | `cla` | A ADD B | viz `add` | Použijte místo `add` pokud<br>jste implementovali CLA. |

#### Násobení (~2b)

Stačí implementovat násobičku kladných čísel podle naivního násobení pod sebou. Za pokročilejší řešení (násobení čísel ve dvojkovém doplňku, efektivnější násobička jako Dadda nebo Wallace multiplier) získáte větší počet bodů.

```admonish faq title="Varianty"
Pro splnění násobení je potřeba implementovat buď `mul16` (velká operace), nebo `mul8`+`swap8` (menší operace + pomocná operace).
V obou případech bude možné násobit libovolně velké čísla v softwaru pomocí částečných násobků.

Doporučuji variantu `mul8`+`swap8`, protože bude v obvodu mnohem méně hradel, což urychlí simulaci.
```

#### Sčítačka s predikcí přenosů (CLA) (~2b)

Neboli *Carry Lookahead Adder (CLA)*. Klasický postup sčítání zprava doleva (*Ripple-carry adder*) je pomalý. Analýzou vztahu carry-in jednotlivých full-adderů ke vstupům lze zjistit, že každý carry-in lze předpovědět přímo ze předchozích vstupů vypočtením několika násobků, které se sečtou. Tedy čas pro výpočet bude vždy pouze daný pouze rychlostí *vícevstupového AND* (kterých se provede několi paralelně) a následného *vícevstupového OR*. Při implementaci v tranzistorech je *vícevstupový AND/OR* rychlejší, než řetězec hradel, který najdeme v klasickém *ripple-carry adderu*.

Získáváme tedy recept na to, jak postavit sčítačku, kde rychlost výpočtu výsledku je kvazi-konstantní vůči šířce sčítačky, ovšem za cenou celkého nárůstu hradel (pro **každý** full-adder musíme přidat několik velkých AND a jedne velký OR). Velikost prediktoru roste s tím, jak daleko vlevo predikci provádíme. Má tedy smysl udělat určitý trade-off, a predikci někde uříznout. Např. postavit 4b adder s predikcí (velmi rychlý), a ten 4x zřetězit na 16b adder.

```admonish faq title="Řešení"
Modifikujte svojí existující sčítačku, nevkládejte do ALU další. V souboru popisující instrukce indikujte místo `add` operaci `cla`.

Pro splnění je potřeba predikovat alespoň 4b součet, dále je možné řetězit.
```

Více informací na wikipedii: [Carry lookahead adder](https://en.wikipedia.org/wiki/Carry-lookahead_adder)

#### Logický posun A doprava/doleva o B míst (~2b)

TODO

#### Karatsubovo efektivní násobení (~2b)

TODO

#### Konverze z binárky na BCD (~2b)

TODO

TODO: {{#check ALU-Zadani | Zadání ALU}}

TODO strojová tabulka

TODO dokumentace

