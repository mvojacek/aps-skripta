# ALU - Sčítačka/odčítačka

Sčítačka je podstatná část ALU. Po určitých úpravách z ní můžeme udělat dokonce i odčítačku. Začneme jednoduše, a to s jedno bitovou verzí.

## Half-adder (1 bit adder)

Pravdivostní tabulka pro half-adder vypadá následovně.

```admonish check title="Solution", collapsible=true
| A | B | OUT | COUT |
|:-:|:-:|:---:|:----:|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 |
```

Pomocí karnaughovy mapy nebo i logiky (odkoukání) můžeme zjistit, že sčítání (`OUT`) je vlastně `XOR` a `COUT` je jenom `AND`. Takže half-adder vypadá následovně.

```admonish check title="Solution", collapsible=true
![Half-adder](../img/alu-half-adder.png)
```

## Full-adder

Full-adder využívá half adder a pomocí něj přijímá další argument a to `CIN`, neboli carry in.

Pravdivostní tabulka pro full-adder vypadá následovně.

```admonish check title="Solution", collapsible=true
| CIN | A | B | OUT | COUT |
|:---:|:-:|:-:|:---:|:----:|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 |
| 0 | 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 0 | 1 |
| 1 | 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 1 | 1 |
```

Jediné, co tedy uděláme je, že přidáme half-adder 2 krát, jeden na `A+B` a druhý na výsledek z prvního `X` a `CIN`, neboli `X+CIN`.

`COUT` half-adderů by se měly sčítat, ale jelikož nemůže nastat případ, kdy jsou oba dva `COUT` `1`, tak nám stačí `OR`. Taky se nemusíme bát přetečení, jelikož při sčítání 3 bitů se hodnota vždy vejde do 2 bitů (maximální hodnota je 3).

```admonish check title="Solution", collapsible=true
![Full-adder](../img/alu-full-adder.png)
```
