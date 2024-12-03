# Zadání projektu ALU

Vytvořte v Logisim Evolution modul tzv. Aritmeticko-Logické jednotky (ALU). ALU je (v našem provedení) kombinační obvod, který umí provést vždy jednou vybranou z několika podporovaných aritmetických nebo logických operací.

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
| `ZERO`   | OUT | 1  | Indikuje, že `OUTP` je roven `0` |
| `SIGN`   | OUT | 1  | Indikuje, že `OUTP`, pokud ho interpretujeme ve dvojkovém doplňku, je záporné číslo |
| `OVER`   | OUT | 1  | V případě, že došlo k součtu, indikuje, že pokud by se operace brala jako ve dvojkovém doplňku, je výsledek nevalidní (nevešel se do reprezentovatelného rozsahu) |
| `GT`, `LT`, `EQ`  | OUT | 1  | Indikují vztah porovnání mezi `A` a `B` nezávisle na aktuálně vybrané operaci. `GT` se rozumí `A > B`. |

```admonish info
Ne všechny I/O musí být nutně přítomné, pouze ty, které jsou potřeba pro nějakou z implementovaných operací. Taky je přípustné mít I/O navíc, které slouží nějaké funkcionalitě nad rámec, nebo bonusovým operacím - v takových situacích bude funkcionalita ověřena ručně.
```

```admonish important
Vstupy a výstupy musí být pojmenované *přesně* podle tabulky, jinak jejich hodnota nebude při opravování brána v potaz!
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

### Posuny a rotace (shifts and rotations)

| Typ | ID | Mnemo | Pseudokód | Popis |
|:---:|:--:|-----------|-----------|-------|
| :bangbang: | `shr` | SHR A | $\forall i: \var{OUTP}_i \leftarrow \var{A}_{i+1}$ <br> $\var{OUTP}_{15} \leftarrow \var{CIN}$ <br> $\var{COUT} \leftarrow \var{A}_{0}$ | Logický posun doprava |
| :bangbang: | `shl` | SHL A | $\forall i: \var{OUTP}_i \leftarrow \var{A}_{i-1}$ <br> $\var{OUTP}_{0} \leftarrow \var{CIN}$ <br> $\var{COUT} \leftarrow \var{A}_{15}$ | Logický posun doleva |
| :bangbang: | `rotr` | ROTR A | $\forall i: \var{OUTP}_i \leftarrow \var{A}_{i+1}$ <br> $\var{OUTP}_{15} \leftarrow \var{OUTP}_{0}$ | Rotace doprava |
| :bangbang: | `rotl` | ROTL A | $\forall i: \var{OUTP}_i \leftarrow \var{A}_{i-1}$ <br> $\var{OUTP}_{0} \leftarrow \var{OUTP}_{15}$ | Rotace doleva |

```admonish info
Takto naspecifikovaný logický posun se někdy nazývá *rotace skrz carry*.
```

```admonish tip
Pomocí logických posunů (a správného použití carry) lze rychle provést dělení a násobení dvěma, a to jak u čísel bez znaménka, tak u čísel v doplňkovém kódu.
```

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
```

### Bonusové

| Typ | ID | Mnemo | Pseudokód | Popis |
|:---:|:--:|-----------|-----------|-------|
| :student: | `mul8` | AL MUL BL | $\var{OUTP}$<br>&emsp;$\leftarrow \slice{\var{A}}{7:0} * \slice{\var{B}}{7:0} $ | 8bit násobení spodních<br>polovin A a B |
| :student: | `mul16` | AL MUL BL | $\{\var{HOUT}, \var{OUTP}\}$<br>&emsp;$\leftarrow \var{A} * \var{B} $ | 16bit násobení A a B |


TODO: {{#check ALU-Zadani | Zadání ALU}}

