# Odčítačka

Pro pochopení odčítačky si musíme říct, co jsou to záporná čísla. Záporná čísla můžeme v binárce vyjadřovat mnoho způsoby, ale nejčastější je dvojkový doplněk.

## Dvojkový doplněk (two's complement)

Když pracujeme s n-bitovými čísly, tak pracujeme s tělesem $ Z_{2^n}^+ $. Chceme vytvořit taková pravidla, že budeme moct pomocí sčítání odčítat.

- Pro každé kladné $ b^+ $ musí existovat takové $ b^- $, aby platitlo $ a-b^+ = a + (-b^+) = a + b^- $.
- Taky musí platit $ b^+ + b^- = 0 $

Potřebujeme tedy najít aditivní inverzi

$$ b^- = 2^n - b^+ = (2^n - 1) - b^+ + 1 $$

$ (2^n - 1) $ je řetězec samých jedniček a odečtením od takové hodnoty nikdy nenastane žádný přenos a odečtená hodnota se touto operací jednoduše zneguje. Dostáváme tedy pravidlo pro výpočet opačného čísla a to: $ b^- = \overline{b^+} + 1 $

Rozdělíme tak těleso na dvě poloviny na zápornou a nezápornou. Viz. obrázek

![Two's complement](../img/alu-scitacka-doplnek.png =500x center)

Zkráceně dvojkový doplněk spočívá ve vyhrazení prvního bitu pro znaménko. `1` znamená `-` a `0` znamená `+` s tím, že jsou u negativních čísel znegované bity a poté přičtena `1`. Pochopíte z následného příkladu.

| Dvojková soustava | Decimální soustava |
|:---:|:---:|
| `000` | `0` |
| `001` | `1` |
| `010` | `2` |
| `011` | `3` |
| `100` | `-4` |
| `101` | `-3` |
| `110` | `-2` |
| `111` | `-1` |

Jeho hlavní výhoda spočívá v odčítání, jelikož pomocí tohoto znázornění platí následující:

$$ A-B = A + \overline{B} + 1 $$

Tuto funkcionalitu tedy neimplementujeme nějak zvlášť, ale pomocí sčítačky, kde nastavíme `CIN` na `1` a znegujeme vstup `B`.
