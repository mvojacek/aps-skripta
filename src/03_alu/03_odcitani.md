# Binární odčítačka

## Odčítání jako sčítání

Sice lze postavit dedikovaný obvod, který umí odečíst dvě čísla, podobným postupem jako u sčítačky, akorát podle odčítání pod sebou.

Nicméně o odčítání se dá uvažovat jako o přičítání záporných čísel, v matematice je to běžná věc.

$$ a - b = a + (-b) $$

Pokud bychom tedy byli schopní vytvořit nějaký jednoduchý obvod, který z $b$ umí vytvořit nějakou hodnotu $-b$, kterou můžeme přičíst k $a$, abychom dostali $a-b$, můžeme pro odčítání použít naši existující obvod.

## Záporná čísla

Číslu $-b$ z předchozího příkladu budeme říkat zaporné číslo. Samozřejmě se pořád pohybujeme v digitální logice, toto číslo bude v počítači muset být reprezentované nějakou sekvencí $1$ a $0$.
Způsobů, jak to udělat, je hned několik (stejně jako u kladných čísel jsme měli binární kód, Grayův kód a BCD), a každá reprezentace bude mít své výhody a nevýhody.

V každém případě předpokládáme, že šířka našeho čísla v bitech je konstantní, protože naše sčítačka/ALU/CPU bude umět pracovat vždy s přesne $n$-bitovými čísly.

### Přímý kód (sign-magnitude)

Asi nejjendodušší, co vás napadne, je do jednoho z bitů (zpravidla největšího) "prostě" uložit znaménko zakódvané jako $0$ nebo $1$, a zbytek bitů interpretovat jako normální číslo.

![](https://media.geeksforgeeks.org/wp-content/uploads/20200427140428/signed-1.png =500x center)

Tato reprezentace má několik nevýhod, zejména:

- Pro sčítání těchto čísel je potřeba speciální sčítačka, zčásti protože:
- Máme dvě různé nuly, $+0 = 0000_2$ a $-0 = 1000_2$, tedy i porovnávání čísel je komplikovanější
- Odčítání nelze realizovat jednoduše jako přičtení záporného čísla

### Aditivní kód (offset binary)

Další přirozený způsob spočívá v posunutí nuly "doprostřed" reprezentovatelného rozsahu - směrem nahoru budou kladná, směrem dolů záporná. Tedy v případě 8-bit čísel, kde máme 256 různých čísel,
můžeme dát nulu na číslo $128$, takže $129$ bude $1$ a $127$ bude $-1$.

Jedná se v podstatě o přímý kód, ale s opačným významem bitu znaménka, má stejné nevýhody. Navíc se ale 

### Jedničkový doplňěk (one's complement)

Další dva možné způsoby reprezentace spočívají v hledání opačných prvků ke kladným číslům pomocí nějakého vzorce. Nejjednodušší takový vzorec je najít záporné číslo pomocí bitwise negace.

$$ -b = \overline{b} $$

Tedy $0$ bude $0000_2$ a $1111_2$. Protože $1$ je $0001_2$, $-1$ bude $1110_2$, a podobně.

Tento kód má zase podobné nevýhody.

### Dvojkový doplněk (two's complement)

Pojďme zkusit vymyslet takový kód, který bude mít vhodnou reprezentaci záporných čísel, abychom odstranili nevýhody ostatních kódů. Tedy chceme mít pouze jednu nulu, chceme aby kladné čísla měla stejnou reprezentaci jako bez znaménka, a chceme, aby šlo odčítat přičtením záporného čísla:

$$ a - b = a + (-b) $$

Když pracujeme s n-bitovými čísly, tak vlastně pracujeme s tělesem $ Z_{2^n}^+ $, protože hodnoty $2^n$ a větší neumíme reprezentovat a horní bity zahazujeme (carry).

Např. sčítáme 8-bit čísla, pohybujeme se v $Z_{256}^+$: $255 + 1 = 0 \pmod{256}$

Chceme označit některá čísla z této grupy jako záporná tak, aby platily následující pravidla:

- Pro každé kladné $ b^+ $ (které reprezentujeme jako číslo bez znaménka) musí existovat takové $ b^- $, aby platitlo $ a-b^+ = a + (-b^+) = a + b^- $.
- To je ekvivalentní tvrzení $ b^+ + b^- = 0 $

Hledané $b^-$ je tedy *aditivní inverzí* $b^+$ v $Z_{2^n}^+$. Tu umíme aritmeticky najít:

$$ b^- = 2^n - b^+ $$

Pokud toto pravidlo budeme aplikovat na nezáporná čísla počínaje nulou (která je korektně sama svojí vlastní inverzí), začneme záporným číslům přiřazovat reprezentace. Přestaneme, jakmile nám dojdou volná čísla (číslo, které jsme označili jako záporné už nemůžeme zároveň považovat za kladné). Pro n=3 skončíme s následujícím přiřazením:

| Binární řetězec | Bez znaménka | Dvojkový doplněk? |
|:---:|:---:|:---:|
| `000` | `0` | `0` |
| `001` | `1` | `1` |
| `010` | `2` | `2` |
| `011` | `3` | `3` |
| `100` | `4` |  `4` nebo `-4` ?  |
| `101` | `5` | `-3` |
| `110` | `6` | `-2` |
| `111` | `7` | `-1` |

Tento kód ja zajímavý tím, že není nemá symetrický rozsah, tedy stejný počet kladných a záporných čísel. To vyplývá automaticky z požadavku mít pouze jednu nulu, přičemž čísel je pořád sudý počet. "Lichý" binární řetězec můžeme přiřadit buď číslu $4$ nebo $-4$, výsledný kód bude fungovat stejně, protože nad {Z_8^+} platí, že $x+4 = x-4$. Vlastně tedy (stejně jako pro nulu), platí, že $4 = -4$.

```admonish question title="Tvoří prvky dvojkového doplňku a sčítání stále grupu?",collapsible=true
Ano, pouze jsme prvkům dali jiné názvy. Operátor $+$ nad nimi se chová pořád stejně jako v původním $Z_{2^n}^+$. Mezi sčítáním čísel *bez znaménka* a ve *dvojkovém doplňku* není na binární úrovní *žádný* rozdíl. **To znamená, že pro sčítání čísel ve dvojkovém doplňku můžeme používat stejnou sčítačku, jako pro nezáporná čísla!** 
```

Musíme se tedy při tvorbě kódu rozhodnout, jestli chceme více záporných a více kladných čísel, aby šly čísla jednoznačně interpretovat. Pokud se rozhodneme "lichému" řetezci přiřadit *zápornou* hodnotu, získáme pro nás kód navíc jednu velmi hezkou vlastnost:

| Binární řetězec | Bez znaménka | Dvojkový doplněk |
|:---:|:---:|:---:|
| `0 00` | `0` | `0` |
| `0 01` | `1` | `1` |
| `0 10` | `2` | `2` |
| `0 11` | `3` | `3` |
| `1 00` | `4` |  `-4` |
| `1 01` | `5` | `-3` |
| `1 10` | `6` | `-2` |
| `1 11` | `7` | `-1` |

```admonish info
Nejmohutnější (most significant) bit binárního řetězce ve dvojkovém doplňku přímo odpovídá znaménku čísla!
```

```admonish tip
Tomuto kódu, jak jsem jej teď sestavili, se říká **dvojkový doplněk** nebo **doplňkový kód**, a používá jej drtivá většina architektur a jazyků pro reprezentaci záporných čísel.
```

```admonish question title="Lze spočítat absolutní hodnotu z libovolného čísla ve dvojkovém doplňku?",collapsible=true
Ne bez zvětšení počtu bitů. Pro 3-bitové číslo $-4$:

$$ \lvert -4 \rvert = 4 $$

ale $4$ lze reprezentovat pouze ve 4- a více-bitových číslech.

Je to opravdová situace, která může nastat ve strojových číslech se znaménkem:

{{#playground ../code/negative_max_abs.rs}}

```

Rozdělili jsme tak grupu na dvě stejně velké poloviny: zápornou a nezápornou:

![Two's complement](../img/alu-scitacka-doplnek.png =500x center)

### Efektivní hledání opačného čísla ve dvojkovém doplňku

Našli jsme tedy pěkný kód, který nás nechá pro odčítání recyklovat naši existující sčítačku. Ale, abychom doopravdy mohli odčítat, musíme být schopni rychle nalézt k danému číslu jeho opačné číslo.

Vzorec pro opačné číslo v doplňkovém kódu je následující:

$$ b^- = 2^n - b^+ $$

...ovšem pro výpočet tohoto vzorce musíme umět odčítat. Je potřeba se tohoto odčítání nějak "zbavit" a nahradit ho jinou operací, kterou spočítat umíme.

S trochou algebry získáme:

$$ b^- = 2^n - b^+ = (2^n - 1 + 1) - b^+ = (2^n - 1) - b^+ + 1 $$

$(2^n - 1)$ v tomto výrazu je konstant, která má podobu binárního řetězce samých jedniček o délce $n$. Odečtením libovolného čísla od takové hodnoty nikdy nenastane žádný přenos a odečítaná hodnota se touto operací jednoduše zneguje (vyzkoušejte odečtením pod sebou na papíře), tedy $(2^n - 1) - b^+ = \overline{b^+}$. Dosazením do původního vzorce dostáváme

$$ b^- = \overline{b^+} + 1 $$

což je vzorec pro efektivní výpočet opačného čísla ve dvojkovém doplňku v hardwaru. Pozor, pokud je dvojkový doplňěk n-bitový, musí i negace být n-bitová!

Tedy, pokud chceme odečíst dvě čísla A, B, stačí provést:

$$ A - B = A + (-B) = A + \overline{B} + 1 $$

Pokud chceme odčítat, privedeme tedy na vstup B naší odčítačky invertovanou hodnotu. Na první pohled se zdá, že budeme muset provést dva součty, nicméně $+ 1$ lze na naší sčítačce zajistit pomocí vstupu `cin`, který při odčítání zafixujeme na kostantní `1`.

```admonish question title="Ale jak bez cin zřetězím dvě odčítání?",collapsible=true
U odčítání se řetězení provádí pomocí tzv. *výpůjčky (borrow)*. Pokud je `borrow-in` $1$, odečteme ještě o jedničku více (podobné ale opačné chování jako carry). Na výstupu odčítačky je naopak `borrow-out`, který signalizuje přetečení do záporných hodnot, tedy v dalším řádu se má odečíst jednička navíc (borrow-in).

Pokud do našich výpočtů zahrneme borrow-in ($b_{in}$):

$$ A - B - b_{in} = A + \overline{B} + 1 - b_{in} $$

$1 - b_{in}$ lze podobně jako předtím vyjádřit jako $\overline{b_{in}}$. Máme tedy:

$$ A - B - b_{in} = A + \overline{B} + \overline{b_{in}} $$

Tuto operaci opět provedeme na naší sčítačce, jako `cin` při odčítání přivedeme $\overline{b_{in}}$. `borrow-in` je tedy pouze invertované `carry-in`.

Kvůli neuvedeným skutečnostem (doplňkový pseudokód) platí to samé pro borrow_out:

$$ b_{out} = \overline{c_{out}} $$

Tedy abychom dostali borrow_out pro odčítání, stačí znegovat carry_out z výše uvedeného součtu.
```

# Sčítačka-Odčítačka

ALU musí samozřejmě umět nějěnom odčítat, ale i sčítat. Nestačí tedy zkonvertovat sčítačku na odčítačku. **Taky není dobré řešení mít dvě sčítačky, jednu na sčítání a odčítání, když ALU děla v jeden čas vždy pouze jednu z obou operací**.

Je tedy potřeba postavit modul sčítačka-odčítačka, který umí obojí, a má speciální vstup (může se jmenovat např. `sub` jako subtract), kterým lze zapnout režim odčítání.

- V režimu sčítání bude počítat $ A + B + CIN = OUT, COUT $.
- V režimu odčítání bude počítat $ A - B = OUT, COUT $.
  - Tedy $CIN$ se nebere v potaz, $COUT$ výstup je zapojen stejně jako u součtu.
- *Alternativně* v režimu odčítání bude počítat $ A - B - BIN = OUT, BOUT $
  - $BIN, BOUT$ mají korektní borrow chování ve dvojkovém doplňku, viz "Jak zřetězím dve odčítání"
  - $CIN / BIN$ je jeden vstup pojmenovaný `CIN` nebo `CIN_BIN`, který přepíná své chování podle toho, zda se zrovna odčítá.
  - $COUT / BOUT$ stejně.

## Implementace

Pro implementaci této komponenty je samozřejmě potřeba mít jako modul hotovou sčítačku. Poté stačí pomocí vhodných multiplexorů podle vstupu `sub` vybírat, jaké hodnoty vlastně na vstupy sčítačky chceme přivést, případně jaké hodnoty (třeba vypočtené z výstupů sčítačky) chceme vyvést na výstupy modulu.
