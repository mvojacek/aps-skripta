# Paměti - Synchronní obvody

Původní verze lekce viz asynchronní obvody

{{ todo("Přepsat stránku") }}

## Synchronní obvody

Jsou ovládané extra clockem (`CLK`), který určuje kdy obvod pracuje. Příkladné obvody jsou:

- SR-flip-flop
- T-flip-flop
- D-flip-flop

V následující kapitole se podíváme na D-flip-flop, jelikož je nejzajímavější.

### Jak synchronizovat obvod? (Rising/Falling edge detektor)

Vytvoření Rising/Falling edge detektoru viz. obrázek

Rising edge detektor (pomocí `NOT` delaye)

<img src="../img/sekvencni-rising-edge-detector.png">

U falling edge detektoru jen prohodíme `NAND` gatu za `AND` gatu.

## D (Data) Flip Flop

Pravdivostní tabulka

| Clock | D | $Q_{next}$ |
|:-----:|:-:|:----------:|
| `Rising edge` | 0 | 0 |
| `Rising edge` | 1 | 1 |
| `Non-rising` | X | Q |

D flip-flop jde vytvořit mnoha způsoby. Ukážeme si dva, a to klasickou variantu a master-slave variantu.


### Master-slave D-flipflop

Vytvoříme ho pomocí 2 *Gated D-latch*. Pozor, aktivuje se na **Falling edge**.

![Negative edge triggered master slave D flip-flop](../img/Negative-edge_triggered_master_slave_D_flip-flop.svg.png)

Varianta pro **Rising edge**.

![D-Type Flip-flop Diagram](../img/1024px-D-Type_Flip-flop_Diagram.svg.png)

### Optimalizovaná varianta

Můžeme vystavět pomocí 6 `NAND` gate.

![Edge triggered D flip flop](../img/Edge_triggered_D_flip_flop.svg.png)

Můžeme přidat 2 vstupy pro **asynchronní** set a reset. Stačí jenom `NAND` gaty vyměnit za 3-vstupové.

![Edge triggered D flip flop with set and reset](../img/Edge_triggered_D_flip_flop_with_set_and_reset.svg.png)

#### Registr

Pokud chceme ukládat vícebitové hodnoty, stačí položit několik D-flip-flopů vedle sebe:

![alt text](../img/register_dflipflops.png)

#### Shift Register

Shift register je užitečná varianta registru. Je tvořen z několika D flip-flopů zapojených v zřetězení do sebe. Při každém clocku se hodnoty v shift registru posunou o jednu pozici po směru toku dat. To umožňuje shift registr naplnit v čase za sebou přicházejícími 1bit hodnotami a následně pracovat s celou hodnotou.

![4 Bit Shift Register](../img/1024px-4_Bit_Shift_Register_001.svg.png)

### Bonusové materiály

- Shift register anglická wikipedie - [https://en.wikipedia.org/wiki/Shift_register](https://en.wikipedia.org/wiki/Shift_register)
- Flip-flopy a latche - [https://en.wikipedia.org/wiki/Flip-flop_(electronics)](https://en.wikipedia.org/wiki/Flip-flop_(electronics))
