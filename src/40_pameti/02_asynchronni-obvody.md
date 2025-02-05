# Paměti - Asynchronní obvody

[Původní verze lekce](https://docs.google.com/document/d/1NGTikBfkWAnwpol82G0NdqacZL8hJSLKO40L2ferYpw/edit)

{{#check TODO | Přepsat stránku }}

Asynchronní obvody fungují bez clocku, takže jakmile je na vstupu hodnota, zpracuje se.

## SR (Set-Reset) latch

SR latch jde vytvořit mnoho způsoby, nejčastější jsou `SR NOR latch` a `SR NAND latch`

Obrázek `SR  NOR latch`

![SR NOR latch](../img/sr-latch.png)

Obrázek `SR NAND latch`

![SR NAND latch](../img/1024px-SR_Flip-flop_Diagram.svg.png =500x)

Pravdivostní tabulka

| S | R | Q' | Poznámka |
|:-:|:-:|:--:|:-------:|
| 0 | 0 | Q | Beze změny |
| 0 | 1 | 0 | Reset |
| 1 | 0 | 1 | Set |
| 1 | 1 | ? | Set+Reset |

```admonish check title="Jaké jsou rozdíly mezi SR NAND a SR NOR? (3)",collapsible=true
- Výstup při set+reset je u NAND 1, u NOR 0
- Vstupy set a reset mají u NAND invertovanou logiku
- U NAND SR je kladný výstup u hradla se set vstupem, u NOR SR je to opačně
```

## JK latch

JK latch se primárně používá na toggle.

Pravdivostní tabulka JK latch

| J | K | Q' | Poznámka |
|:-:|:-:|:--:|:-------:|
| 0 | 0 | Q | Beze změny |
| 0 | 1 | 0 | Reset |
| 1 | 0 | 1 | Set |
| 1 | 1 | Q | Toggle |

## Gated D (data) latch

- Gatování - možnost vypnout či zapnout prvek, pomocí vstupu (typicky `ENABLE`).

D latch využívá vstup enable jako 2 vstup. Tvořící sérii pravidel.

| E | D | $Q'$ | $ \overline{Q'} $ | Poznámka |
|:-:|:-:|:-:|:--------------:|:--------:|
| 0 | - | Q | $ \overline{Q} $ | Beze změny |
| 1 | 0 | 0 | 1 | Zápis 0 (reset) |
| 1 | 1 | 1 | 0 | Zápis 1 (set) |

```admonish check title="Diagram",collapsible=true
![Gated D latch](../img/D-type_Transparent_Latch_(NOR).svg.png)
```
