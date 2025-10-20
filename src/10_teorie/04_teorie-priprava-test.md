<style>
table { margin: 1em;}
</style>

{% set zadani -%}
admonish abstract title="Zadání"
{%- endset %}

{% macro resenifn(name="") -%}
admonish check title="Řešení{% if name != "" %} - {{name}}{% endif%}",collapsible=true
{%- endmacro %}
{% set reseni = resenifn() %}

# Příprava na první test

## Znalost hradel a operátorů Booleovy algebry

V tomto předmětu používáme hradla:

- BUFFER, NOT
- AND, NAND
- OR, NOR
- XOR, XNOR

Existují i další hradla (zejména *implikace ($\implies$)* ve výrokové logice), ale ty nebudeme potřebovat.

Ke každému hradlu je potřeba znát:

1. Název (AND)
2. "Distinctive shape" tvar hradla (podle IEEE Std 91/91a-1991)
3. Výraz/operátor v Booleově algebře ($X = A \cdot B$)
4. Pravdivostní tabulku, neboli jeho chování

V testu je potřeba na základě jednoho z těchto údajů vypsat všechny 3 ostatní, pro všechny hradla.

### Podle názvu

```{{zadani}}
**Nakresli logická hradla**, zapiš **operátor hradla jako výraz** (např. X=A+B), nakresli **pravdivostní tabulku**.
```

{% macro gate_by_name(letter, name, var, table) -%}
{{ letter }}) {{ name | upper }}

```{{reseni}}
{{ gate(name | lower, var) }}

$ {{var}} = {{ caller() }} $

{{ truth_table(var, table) }}
```
{%- endmacro -%}


{% call gate_by_name("a", "NOT",  "X", "10"  ) -%} \n{A}        {%- endcall %}
{% call gate_by_name("b", "OR",   "X", "0111") -%} A \or B      {%- endcall %}
{% call gate_by_name("c", "XNOR", "X", "1001") -%} \n{A \xor B} {%- endcall %}
{% call gate_by_name("d", "AND",  "X", "0001") -%} A \and B     {%- endcall %}

### Podle tvaru

```{{zadani}}
**Pojmenuj** následující hradla, zapiš jejich **výraz** a **pravdivostní tabulku**.
```

{% macro gate_by_shape(letter, name, var, table) -%}
{{ letter }}) {{ gate(name | lower, var) }}

```{{reseni}}
{{ name | upper }}

$ {{var}} = {{ caller() }} $

{{ truth_table(var, table) }}
```
{%- endmacro -%}


{% call gate_by_shape("a", "NOR",    "X", "1000") -%} \n{A \or B}  {%- endcall %}
{% call gate_by_shape("b", "XOR",    "Y", "0110") -%} A \xor B     {%- endcall %}
{% call gate_by_shape("c", "NAND",   "Z", "1110") -%} \n{A \and B} {%- endcall %}
{% call gate_by_shape("d", "BUFFER", "W", "01"  ) -%} A            {%- endcall %}


### Podle výrazu nebo podle tabulky

I to se může stát.

## Převod mezi obvodem, výrazem a pravdivostní tabulkou

V prvním testu stačí pouze:

- obvod $\rightarrow$ tabulka
- výraz $\rightarrow$ tabulka
- obvod $\leftrightarrow$ výraz

Pokud k tomu nejste explicitně vyzváni, výraz žádným způsobem neupravujte/neminimalizujte! Správný výraz je ten, který *přesně* odpovídá zadanému zapojení (vyjma: komutativity, asociativity).

### obvod $\rightarrow$ výraz

```{{zadani}}
Zapiš výraz pro **výstupy** zapojení a pro **označené vodiče**.
```

1\)

![](../img/teorie-cviko-1.png =750x)

```{{reseni}}
označené vodiče:

a) $A \cdot B$

b) $\overline{C}$

výstupy:

$ X = (A \cdot B) \oplus \overline{C} $
```

2\)

![](../img/teorie-cviko-2.png =750x)

```{{reseni}}
označené vodiče:

a) $\overline{A}$

b) $B+C$

c) $\overline{(B+C) \oplus D}$

výstupy:

$ X = \overline{A} \cdot (B+C) $

$ Y = (B+C) \cdot \overline{(B+C) \oplus D} $
```

### výraz $\rightarrow$ obvod a tabulka

```{{zadani}}
Nakresli **zapojení** pro následující výraz a nakresli pravdivostní **tabulku**.
```

$ X = (A \cdot B) + (\overline{A \oplus C}) + \overline{B} $

```{{resenifn("zapojení")}}
![](../img/teorie-cviko-3.png =750x)

Taktéž v zapojení lze použít jeden třívstupový OR, jelikož sčítání je asociativní a komutativní.
```

```{{resenifn("tabulka")}}

Vytváření tabulky si ulehčíme spočítáním sloupců pro námi zvolené podvýrazy ($A \cdot B$, $\overline{A \bigoplus C}$ a $\overline{B}$). Jejich hodnoty použijeme v dalších výpočtech, abychom se vyhnuli chybám při počítání komplikovaných výrazu z hlavy. Pokud víme na první pohled hodnoty některých řádků výsledku, můžeme je vyplnit hned do výsledku a v pomocných sloupcích je přeskočit. Nutné sloupce jsou pouze vstupy ($A$,$B$,$C$) a výstupy ($X$).

|$A$|$B$|$C$|$A \cdot B$|$\overline{A \oplus C} $| $\overline{B}$ | $X$ |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 0 | 0 | 0 | 0 | 1 | 1 | 1 |
| 0 | 0 | 1 | 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 0 | 0 | 0 | 0 |
| 1 | 0 | 0 | 0 | 0 | 1 | 1 |
| 1 | 0 | 1 | 0 | 1 | 1 | 1 |
| 1 | 1 | 0 | 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 1 | 1 | 0 | 1 |

Je důležité aby tabulka byla dobře zarovnaná a aby její řádky byly seřazené podle numerické hodnoty vstupů, pro lepší čitelnost.
```

### Cvičebnice

Pro další procvičování je zde k dispozici 8 dalších logických funkcí ve všech tří nám známých reprezentacích. Rozbalte si jednu z nich jako zadání a snažte se vytvořit ostatní dvě (pokud byl tento postup již probrán). Navíc je zde uvedený minimální výraz pro danou logickou funkci, který se bude hodit na procvičování zjednodušování výrazů.

{% macro cvicebnice(name, table) -%}
{% set lines = caller() | split("\n") -%}
#### {{name}}

```admonish abstract title="Výraz",collapsible=true
$\textnormal{ {{-name-}} } = {{ lines[0] }}$
```

```admonish note title="Zapojení",collapsible=true
{{ svg("./excercises/" ~ name ~".svg", width="750px") }}
```

```admonish example title="Pravdivostní tabulka",collapsible=true
{{ truth_table(name, table) }}
```
{%- if lines[1] is defined %}

```admonish tip title="Minimalizovaný výraz",collapsible=true
$\textnormal{ {{-name-}} } = {{ lines[1] }}$
```
{%- endif %}
{%- endmacro %}

{% call cvicebnice("X1", "0100") -%}
(A \and \n{B} \or \n{A}) \and B \and \n{A \or \n{B}}
\overline{A} \cdot B
{%- endcall %}

{% call cvicebnice("X2", "10101110") -%}
\n{(A \and B \or \n{A}) \and C} \or (B \and \n{C} \or A) \and \n{B}
\n{C} \or A \and \n{B}
{%- endcall %}

{% call cvicebnice("X3", "00110010") -%}
(A \or B) \and (B \or C) \and (\n{A} \or \n{C})
B \and \n{A \and C}
{%- endcall %}

{% call cvicebnice("X4", "00000010") -%}
(A \and B \or B) \and \n{C} \and (A \and \n{B} \or \n{\n{A} \or C})
A \and B \and \n{C}
{%- endcall %}

{% call cvicebnice("X5", "01110001") -%}
(\n{(A \or B) \and (\n{A} \and C \or \n{B})} \or B) \and \n{(A \or \n{B}) \and \n{C}}
\n{A} \and C \or \n{A} \and B \or B \and C
{%- endcall %}

{% call cvicebnice("X6", "1010") -%}
\n{A} \xor A \xor B
\n{B}
{%- endcall %}

{% call cvicebnice("X7", "10010000") -%}
(A \and (B \xor C) \or \n{A}) \and \n{B \xor C}
\n{A \or (B \xor C)}
{%- endcall %}

{% call cvicebnice("X8", "0110") -%}
(A \xor B) \and (A \xor \n{B}) \or \n{\n{A} \xor B}
A \xor B
{%- endcall %}

# Příprava na druhý test

{{ todo("druhý test") }}

#### 5. Zjednoduš následující výraz do co nejjednodušší podoby

Výsledek zde: $\Box$

$$ X=(AC + C + B) + \overline{B \cdot \overline{C}} + \overline{C}(\overline{A}C +C) $$

</details>
<details>
  <summary>Řešení</summary>

$$ X = (C(A+1)+B)+\overline{B}+C+\overline{C}(C(\overline{A}+1)) $$

$$ X = (C+B)+\overline{B} + C + \overline{C} \cdot (\overline{A}C) $$

$$ X = C + B + \overline{B} + C + 0 $$

$$ X = C + 1 + C $$

$$ X = 1 $$

</details>

---

Výsledek zde: $\Box + \Box$

$$ X=(A+C)(A \cdot B + \overline{\overline{A} + B}) + AC + C $$

<details>
  <summary>Řešení</summary>

$$ X = (A+C)(A \cdot B + A \cdot \overline{B}) + C $$

$$ X = (A+C)(A \cdot (B+\overline{B})) + C $$

$$ X = ((A+C) \cdot A) + C $$

$$ X = A \cdot A + A \cdot C + C $$

$$ X = A +C $$

</details>
