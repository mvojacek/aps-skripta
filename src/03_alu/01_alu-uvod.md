# ALU - Úvod

```admonish warning title="Poznámka"
Obsah této stránky slouží jako úvod k principu ALU, má pouze informační povahu a **není součástí zadání ALU!**
```

Každé CPU vyžaduje ALU neboli *Arithmetic Logic Unit*. Jedná se o "krabičku", která dokáže různé operace jako například sčítání, odčítání, bitwise operace, atd... V této kapitole se dozvíte, co je vše potřeba v ALU obsáhnout.

```admonish info
ALU musíte postavit do samostatného modulu, který se musí jmenovat **přesně** `ALU`. Jinak nebude možné ALU ohodnotit!
```

## Vstupy ALU

- vstup `A` a `B` - n-bitový vstup, záleží kolika bitové děláte ALU
- `CIN` - Carry IN, 1 bitová dodatečná hodnota
- `SEL` - Nebo taky `Opcode`, typicky 4 bitový, rozhoduje kolik vaše ALU umí operací

## Výstupy ALU

- `OUTP` - n-bitový výstup, záleží kolika bitové děláte ALU
- `HOUT` - použito pro násobení, využito pro vyšší polovinu výsledku
- `ZERO` - 1 bitová hodnota, rozhoduje jestli jsou na výstupu samé nuly
- `COUT` - Carry OUT z operací, 1 bitová hodnota
- `SIGN` - Znaménko hodnoty výstupu (totožné s nejvyšším bitem hodnoty)
- `GT`, `LT`, `EQ` - Nepovinně můžeme přidat operace z komparátoru, jde nahradit pomocí odčítání a `ZERO` a `SIGN` výstupy

```admonish danger title="Důležité"
Aby bylo možné vaše ALU ohodnotit, je potřeba pro tyto dráty dodržet **přesně** výše uvedené názvy!
```

## UI (uživatelské rozhraní)

Pro uživatelské rozhraní můžete použít například tyhle logisim komponenty.

### Komponenty vstupů

- `Wiring/Pin` -  pro 1 bitové hodnoty
- `Memory/Register` - pro n bitové hodnoty
- `Input/Output/Button` - tlačítko pro například operace

### Komponenty výstypů

- `Input/Output/LED` - pro 1 bitové hodnoty
- `Wiring/Pin` - pro n bitové hodnoty
- `Input/Output/Hex Digit Display` - pro 4 bitové hodnoty, doporučuji dost přehledné pro výstup

Příkladný `main` v projektu ALU může vypadat následovně.

![ALU Example Main](./img/alu-example-main.png)

## Operace ALU (`SEL`)

### Bitwise operace

Jednoduché logické gaty pro n-bitové vstupy

- `NOT`
- `OR`
- `AND`
- `XOR`

### Shifty

Posune nám hodnotu buď doleva `SHL`, nebo doprava `SHR`. Pokud by hodnota utekla, tedy například na hodnotu `1000 0000` budeme chtít použít operaci `SHL`, tak rozsvítíme `COUT` na `1` a `OUT` bude `0000 0000`.

- `SHL` - Shift left
- `SHR` - Shift right

Příklad `SHL`

| A | OUT | COUT |
|:-:|:---:|:----:|
| `0000 0001` | `0000 0010` | `0` |
| `1000 0000` | `0000 0000` | `1` |
| `1011 0111` | `0110 1110` | `1` |
| `0101 1101` | `1011 1010` | `0` |

Příklad `SHR`

| A | OUT | COUT |
|:-:|:---:|:----:|
| `0000 0001` | `0000 0000` | `1` |
| `1000 0000` | `0100 0000` | `0` |
| `1011 0111` | `0101 1011` | `1` |
| `0101 1101` | `0010 1110` | `1` |

### Rotace

Stejné jako shifty, ale při přetečení nastavíme nejmenší hodnotu na `1`. Například máme hodnotu `0000 0001` a použijeme operaci `ROTR`, tak nastavíme `OUT` na `1000 0000` a označíme `COUT` na `1`

- `ROTL` - Rotate left
- `ROTR` - Rotate right

Příklad `ROTL`

| A | OUT | COUT |
|:-:|:---:|:----:|
| `0000 0001` | `0000 0010` | `0` |
| `1000 0000` | `0000 0001` | `1` |
| `1011 0111` | `0110 1111` | `1` |
| `0101 1101` | `1011 1010` | `0` |

Příklad `ROTR`

| A | OUT | COUT |
|:-:|:---:|:----:|
| `0000 0001` | `1000 0000` | `1` |
| `1000 0000` | `0100 0000` | `0` |
| `1011 0111` | `1101 1011` | `1` |
| `0101 1101` | `1010 1110` | `1` |

### Sčítačka

Sčítačka by měla být schopna provést více operací, jedná se o následující.

- `ADD` - sčítání
- `SUB` - odčítání
- `INC` - inkrement (`A + 1`)
- `DEC` - dekrement (`A - 1`)

### Násobení

Bonusově můžete dodělat násobení neboli `MUL`. Zde se výsledek rozděluje na dva výstupy a to horní část `HOUT` a dolní část `OUT`.

- `MUL` - násobení
