{% import "macros.tera" as m %}

# Hradla - Teorie

### Pravdivostní tabulka

Pro značení budeme používat pravdivostní tabulku, která označuje nějaký vztah mezi vstupy a výstupy. Jedná se o jednoduchou tabulku, kde se nachází libovolně vstupů, (typicky `A`,`B`,`CIN`,...) a výstupů (typicky `X`,`COUT`,`OUT`,...). S následujících příkladů u hradel, hned pochopíte o co jde.

## Hradla s jedním vstupem

Hradla, které mají jeden vstup jsou následující

- Buffer (repeater)
- NOT
### Buffer (repeater)

**Buffer** se převážně využívá na zopakování a posílení vstupu. Taky tím "ukazujete", jakým směrem teče proud.

#### Symbol

{{ m::gate1(gate="buffer") }}

#### Definice

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

{{ m::gate1(gate="not") }}

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

{{ m::gate2(gate="and") }}

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

{{ m::gate2(gate="or") }}

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

{{ m::gate2(gate="xor") }}

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

{{ m::gate2(gate="nand") }}

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

{{ m::gate2(gate="nor") }}

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

{{ m::gate2(gate="xnor") }}

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
|0|1|0|1|1|1|1|0|
|1|0|0|1|1|1|1|0|
|1|1|1|1|0|0|0|1|

### Zobrazení logických hradel v logisimu

![](../img/hradla.png =500x)
