# Hradla a operátory Booleovy algebry

Jistě víte, že počítače pracují pouze s jedničkami a nulami. S pomocí pouze těchto dvou hodnot a operací nad nimi jsou schopné řešit libovolně komplikované problémy. Abychom mohli studovat, jak to je možné, musíme si určitým způsobem tyto základní výpočty nad jedničkami a nulami zformalizovat. Později si ukážeme, jak pomocí těchto jednoduchých operací stavět komplikovanější operace, moduly a finálně procesor.

## Booleova algebra

Matematickou abstrakci pro výpočty pouze nad hodnotami `0` a `1` popsal v 19. století George Boole, nazývá se Booleova algebra. Tuto _algebru_ můžeme zjednodušeně chápat jako alternativu ke klasické algebře z hodin matematiky - čísla a operace budou mít odlišný význam, než jsme zvýklí. Ovšem, pokud budou tyto operace chytře zvolené, jako v Booleově algebře, zjistíme, že spousta pravidel z klasické matematiky stále bude fungovat.

### Výrazy v Booleově algebře

Podobně jako v matematice, budeme se zde zabývat výrazy. V takovém výrazu najdeme _operátory_, _proměnné_ a _neznámé_. Např.

$X = (A \oplus B) \cdot (C + B)$

Zde $X$ je proměnná, která je definovaná tímto výrazem. $A, B, C$ jsou neznámé - musíme se k nim chovat jako by mohly mít libovolnou hodnotu. $\oplus, \cdot, +$ jsou operátory, které bychom uměli provést, pokud bychom znali hodnoty $A, B, C$.

### Nuly a jedničky

Každý výraz, proměnná nebo neznámá může v Booleově algebře nabýt pouze dvou hodnot:

- $0$ neboli `false` neboli _nepravda_ neboli např. 0 voltů
- $1$ neboli `true` neboli _pravda_ neboli např. 5 voltů

U výpočtů v Booleově algebře se budeme držet hodnot $0$ a $1$, nicméně je důležité si uvědomit, že tyto hodnoty mají jistý vztah k _výrokové logice_, která zkoumá, zda-li je nějaký _výrok pravdivý_ (rečeno v Booleově algebře: _výraz_ se rovná $1$). Zároveň se v praxi pak jedničky a nuly musí nějakým způsobem reprezentovat, například úrovní napětí na nějakém vodiči.

## Operátory Booleovy algebry a hradla

### Pozadí k operátorům

"Operátor" je pro naše účely symbol, který značí ve výrazu, že by se měla provést nějaké matematická operace, která bude mít nějaký výsledek. Operátory delíme podle počtu jejich argumentů (chcete-li "vstupů"):

- Unární (jeden vstup). V matematice máme např. _unární mínus_ nebo _faktoriál_:  
  $\t{-}5 = 0 - 5$ a $3! = 6$
- Binární (dva vstupy). Většina operátorů v matematice - sčítání, násobení, ...:
  $5 + 3 = 8$
- Ternární a další. V matematice takových moc není, ale např. v programovaní narazíte na [ternary conditional operator (a ? b : c)](https://en.wikipedia.org/wiki/Ternary_conditional_operator).

### Operátory v Booleově algebře

Protože v Booleově algebře mohou hodnoty nabývat pouze $0$ a $1$, je velmi jednoduché zadefinovat chování takového operátoru: Stačí vypsat všechny možnosti! Takže například násobení ($\cdot$) si můžeme zadefinovat takto:

$0 \cdot 0 = 0$  
$0 \cdot 1 = 0$  
$1 \cdot 0 = 0$  
$1 \cdot 1 = 1$

A to je vše! Žádná jiná varianta nemůže nikdy nastat. Když se nad tím zamyslíme, tak ostatní operátory se od násobení budou lišit pouze pravou stranou rovnic - levá strana pouze vyčítá všechny možné kombinace $0$ a $1$.

Další binární operátory si můžeme vymyslet vybráním $0$/$1$ pro každou ze 4 variant vstupů. Takže binárních operátorů v Booleově algebře je pouze $2^4 = 16$ a násobení je jedním z nich. Celkem si zadefinujeme 6 binárních operátorů a 1 unární, které budeme bežně používat.

### Pravdivostní tabulka

Uvidíme, že "vypsat všechny možnosti" je docela užitečná věc, nejenom pro základní operátory. Zavademe si tedy _pravdivostní tabulku_, ve které systematicky všechny možnosti popíšeme:

{{ truth_table("Q", "0001") }}

Levá část pravdivostní tabulky je nadepsaná vstupy a vyčítá všechny jejich kombinace v přehledném (vzestupném) pořadí. V pravé straně máme výstup, který můžeme označít buď výrazem nebo proměnnou, například $Q$.

Pravdivostní tabulka má různý počet řádků podle počtu kombinací a tedy podle počtu vstupů. Každá kombinace vstupů se musí vyskutnout přesně jednou! Takže pro $n$ vstupných proměnných bude mít pravdivostní tabulka $2^n$ řádků.

### Hradlo

Ke každému, operátoru, který si ukážeme, si zavedeme _hradlo_. To je "fyzická krabička", která má Booleovské vstupy a výstupy, a umí "provést" danou operaci. Např. pro operaci násobení si zavademe hradlo AND:

{{ gate("and") }}

Jde nám zde o tvar tohoto hradla, abychom ho uměli na první pohled rozlišit od ostatních. Stejně jako z operátorů lze stavět výrazy, z hradel budeme stavět obvody. Je důležité pamatovat na formální rozdíl mezi "operátorem" a "hradlem", ikdyž budeme používat "násobení" a "AND" zaměnitelně.

### Výroková logika

K operátorům a značení, které si ukážeme, existuje ještě alternativní značení v tzv. _výrokové logice_, které se používá v matematice pro důkazy. Např. místo $a \cdot b$ bychom napsali $a \wedge b$. Toto značení v tomto předmětu **nepoužíváme**, je uvedeno pro úplnost.

## Unární operátory

Hradla, které mají jeden vstup jsou následující

- Buffer (repeater)
- NOT

### Buffer (repeater)

**Buffer** je hradlo, u kterého výstup přesně kopíruje vstup. Nezavadíme pro něj symbol operátoru, protože je to zbytečné, trochu jako říkat $+5$ v matematice místo $5$. Nicméně v praxi se toto hradlo používá zejména pro zesílení signálu.

{{ todo("zbytek stranky") }}

#### Symbol

{{ gate("buffer") }}

#### Výraz

Matematická definice

$$ Q = A $$

Zápis v C

```c
bool A;
bool Q = A;
```

#### Pravdivostní tabulka

|A|Q|
|:-:|:-:|
|0|0|
|1|1|

### NOT

Hradlo **NOT** použijete, když potřebujete změnit hodnotu na její opak.

Neboli 0 &rarr; 1 nebo 1 &rarr; 0

#### Symbol

{{ gate("not") }}

#### Definice

Matematická definice

$$ Q = \overline{A} $$

Zápis v C

```c
bool A;
bool Q = !A;
```

#### Pravdivostní tabulka

|A|Q|
|:-:|:-:|
|0|1|
|1|0|


## Základní hradla se dvěma vstupy

Základní hradla, které mají dva vstupy jsou následující

- AND
- OR
- XOR
### AND

Hradlo **AND** neboli logické **"a"** , se využívá když chcete naplnit dvě podmíky.

*Pokud platí A* **a** *B, tak pošli na výstup hodnotu 1*

#### Symbol

{{ gate("and") }}

#### Definice

V Booleově algebře se hradlo **AND** rovná násobení

$$ Q = A \cdot B $$

Zápis v C:

```c
bool A = <bool_val>;
bool B = <bool_val>;
bool Q = A && B;
```

#### Pravdivostní tabulka

|A|B|Q|
|:-:|:-:|:-:|
|0|0|0|
|0|1|0|
|1|0|0|
|1|1|1|

### OR
Hradlo **OR** neboli logické **"nebo"** , se využívá když chcete naplnit aspoň jednu podmíku.

*Pokud platí A* **nebo** *B, tak pošli na výstup hodnotu 1*

#### Symbol

{{ gate("or") }}

#### Definice

V Booleově algebře se hradlo **OR** rovná součtu

$$ Q = A + B $$

Zápis v C:

```c
bool A = <bool_val>;
bool B = <bool_val>;
bool Q = A || B;
```

#### Pravdivostní tabulka

|A|B|Q|
|:-:|:-:|:-:|
|0|0|0|
|0|1|1|
|1|0|1|
|1|1|1|

### XOR
Hradlo **XOR** neboli exkluzivní OR , se využívá když chcete naplnit pouze jednu podmíku. Jednoduše řečeno, když se sobě nerovnají.

*Pokud platí ***právě*** *A* ***nebo*** ***právě*** *B, tak pošli na výstup hodnotu 1 ... Pokud se A **nerovná** B* 

#### Symbol

{{ gate("xor") }}

#### Definice

V Booleově algebře se pro hradlo **XOR** používá symbol $ \oplus $

$$ Q = A \oplus B $$

Zápis v C

```c
bool A = <bool_val>;
bool B = <bool_val>;
bool Q = A ^ B;
```

#### Pravdivostní tabulka

|A|B|Q|
|:-:|:-:|:-:|
|0|0|0|
|0|1|1|
|1|0|1|
|1|1|0|




## Opaky základních hradel se dvěma vstupy

Opaky základních hradel, existují právě 3

- NAND (opak AND)
- NOR (opak OR)
- XNOR (opak XOR)

### NAND
Hradlo **NAND** má opačný výstup hradla **AND**

*Pokud **ne**platí A* **a** *B, tak pošli na výstup hodnotu 1*

#### Symbol

{{ gate("nand") }}

#### Definice

V Booleově algebře se hradlo **NAND** rovná negaci násobení

$$ Q = \overline{(A \cdot B)} $$

Zápis v C:

```c
bool A = <bool_val>;
bool B = <bool_val>;
bool Q = !(A && B);
```

#### Pravdivostní tabulka

|A|B|Q|
|:-:|:-:|:-:|
|0|0|1|
|0|1|1|
|1|0|1|
|1|1|0|

### NOR
Hradlo **NOR** má opačný vstup hradla **OR**

*Pokud **ne**platí A* **nebo** *B, tak pošli na výstup hodnotu 1*

#### Symbol

{{ gate("nor") }}

#### Definice

V Booleově algebře se hradlo **NOR** rovná negaci součtu

$$ Q = \overline{(A + B)} $$

Zápis v C:

```c
bool A = <bool_val>;
bool B = <bool_val>;
bool Q = !(A || B);
```

#### Pravdivostní tabulka

|A|B|Q|
|:-:|:-:|:-:|
|0|0|1|
|0|1|0|
|1|0|0|
|1|1|0|


### XNOR
Hradlo **XNOR** je opak hradla **XOR**, jednoduše řečeno se jedná o ekvivalenci

*Pokud se A **rovná** B*

#### Symbol

{{ gate("xnor") }}

#### Definice

V Booleově algebře se hradlo **XNOR** rovná negaci operaci \((\oplus\))

$$ Q = \overline{(A \oplus B)} $$

Zápis v C:

```c
bool A = <bool_val>;
bool B = <bool_val>;
bool Q = !(A ^ B);
```

#### Pravdivostní tabulka

|A|B|Q|
|:-:|:-:|:-:|
|0|0|1|
|0|1|0|
|1|0|0|
|1|1|1|

## Cheat sheet

### Cheat sheet pro logické hradla

*Vstup A a Vstup B dává výstup \<operace\>*

|A|B|AND|OR|XOR|NAND|NOR|XNOR|
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|0|0|0|0|0|1|1|1|
|0|1|0|1|1|1|0|0|
|1|0|0|1|1|1|0|0|
|1|1|1|1|0|0|0|1|

### Zobrazení logických hradel v logisimu

![](../img/hradla.png =500x)
