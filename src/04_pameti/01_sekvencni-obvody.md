# Paměti - Sekvenční obvody

### Kombinační obvody

Kombinační obvody lze ekvivalentně zadefinovat několika způsoby:

- Hodnoty výstupů jsou plně definované pouze hodnotami vstupů
- Obvod implementuje matematickou funkci, tj. lze popsat pravdivostní tabulkou
- V obvodu se nevyskytují žádné cykly (nepřímá závislost závislost vstupu hradla na jeho výstupu)

Příklad kombinačního obvodu

![Kombinační obvod](../img/kombinacni-1.png)

### Sekvenční obvody

Sekvenční obvody jsou ty obvody, které nejsou kombinační, tj. vyskutyjí se v nich nějaké cykly. Tyto cykly způsobují zajímavé chování (paměť), ale jsou obtížnější analyzovat.

Příkladný sekvenční obvod s `OR`

![Sekvenční obvod](../img/sekvencni-1.png)


#### Znázornění v pravdivostní tabulce

Protože X je zároveň výstup a vstup do obvodu, musíme tyto dvě jeho funkce rozdělit:

- $X$ - aktuální hodnota vodiče X, tj. vstup
- $X'$ - příští hodnota vodiče X, tj. výstup.

"Příští" tady znamená, jakmile dané hradlo zpracuje své vstupy a aktualizuje svůj výstup - jeho tzv. *propagační delay*, který je vždy nenulový, závislý na výrobním procesu (typická hodnota např. 10ns). Tedy je to hodnota X v budoucnosti.

Nyní v pravdivostní tabulce můžeme popsat, jaké bude *příští X* $X'$ v závislosti na *aktuálním X* $X$ a vstupu $A$:

| A | X | X' |
|:-:|:-:|:--:|
| 0 | 0 | 0  |
| 0 | 1 | 1  |
| 1 | 0 | 1  |
| 1 | 1 | 1  |

Z chování obvodu vidíme, že pokud je $A=0$, $X$ se nezmění ($X'=X$), a pokud $A=1$, pak na $X$ nezáleží a $X'=1$. Můžeme tedy pravdivostní tabulku zjednodušit zavedením *neznámé* $S$:

| A | X | X' |
|:-:|:-:|:--:|
| 0 | S | S  |
| 1 | S | 1  |

V této tabulce může S nabýt libovolných hodnot ($0$ nebo $1$) a každá varianta repreznetuje jeden řádek. Nicméně z takto zjednodušené tabulky je lépe vidět časové chování obvodu:

Pokud se obvod nachází v nějakém "stavu" $S$, tak při $A=0$ v něm **zůstane**, ale při $A=1$ **přejde** do stavu $S=1$.

Zároveň platí, že abychom mohli znát hodnotu výstupu, musíme znát hodnotu aktuálního stavu $S$, který může být skrytý uvnitř obvodu, nestačí nám pouze vstup $A$ - typická vlastnost sekvenčních obvodů.

#### Popis výrazem a nekonečné vyhodnocování

Obvod můžeme popsat i výrazem:

$$ X' = X + A $$

TODO

### SR Latch

Sekvenční obvody můžete využít pro paměť pomocí hradla `OR`. Hradlo `OR` nám vstup zapne a nechá výstup neustále zapnutý, ale nemáme ho **zatím** jak vyresetovat.

![Sekvenční obvod](../img/sekvencni-1.png)

Abychom ho mohli vyresetovat, přidáme další vstup a to `R` jako reset.

![SR Latch](../img/rookie-sr-latch.png)

Zapíšeme do výrazu

$$ Q = S + B = S + (Q \cdot \overline{R}) $$

Zapíšeme chování do pravdivostní tabulky

| R | S | Q | Q' |
|:-:|:-:|:-:|:--:|
| 0 | 0 | Q | Q |
| 0 | 1 | X | 1 |
| 1 | 0 | X | 0 |
| 1 | 1 | X | 1 |

Vytvořili jsme SR Latch, který se ale dá optimalizovat, tak abychom potřebovali 2 stejné gaty a to `NOR` viz. gif.

![SR Latch](../img/sr-latch-gif.gif)

### Latch vs Flip Flop

#### Signály

![Stavy signálů](../img/signal-states.png)

Na následujícím obrázku vidíme 4 definice.

- `High Level` (Active-High) - zde probíhá ukládání
- `Low Level` (Active-Low) - značí se jako `CLK` nebo `ENA`
- `Rising/Falling edge` hodnota se zpracuje v okamžíku přechodu `CLK` signálu z high na low a opačně

#### Latch

Latch je *level-triggered*. To znamená, že latch bere vstup, když je zapnutý viz. obrázek

![Latch](../img/signal-latch.png)

#### Flip Flop

Flip flop je *edge-triggered*. To znamená, že buď bere vstup na `rising edge` nebo `falling edge`. Na následujícím obrázku bere vstup na `rising edge`.

![Flip Flop](../img/signal-flip-flop.png)


### Oscillation apparent

V rámci sekvenčních obvodů můžete narazit na chybu `Oscillation apparent`. Znamená to, že jste v nějakém paradoxním cyklu. Vyřešíte to následovně:
- Odstraníme problémový prvek
- `Reset Simulation` (`CTRL+R`)
- Pokud není zapnuté tak --> `Auto-Propagate` (`CTRL+E`) 

### Bonusové materiály

-  Latch vs Flip Flop - [https://www.youtube.com/watch?v=LTtuYeSmJ2g](https://www.youtube.com/watch?v=LTtuYeSmJ2g)
- Latch a Flip Flop na wikipedii
    - Anglicky (víc informací) - [https://en.wikipedia.org/wiki/Flip-flop_(electronics)](https://en.wikipedia.org/wiki/Flip-flop_(electronics))
    - Česky - [https://cs.wikipedia.org/wiki/Bistabiln%C3%AD_klopn%C3%BD_obvod](https://cs.wikipedia.org/wiki/Bistabiln%C3%AD_klopn%C3%BD_obvod)