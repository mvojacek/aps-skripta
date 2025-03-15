# Poznámky z hodin

Tyto stručné poznámky v pár bodech shrnují probranou látku na hodinách týkajících se procesoru. Pro dosažení parity s látkou probranou na hodinách je potřeba si o každém zmíněném tématu něco přečíst.

## 25.2.2025: Princip procesoru

Témata z bakalářů:

1. Úprava účelného sekvenčního obvodu na procesor, princip procesoru
2. Návrh datové cesty pro procesor, překlad zdrojový kod - assembler - strojový kód - kontrolní signály, customasm

Výpisky:

- Procesor je plně synchronní sekvenční obvod, v každém cyklu provede nějakou jednu operaci na základě aktuálního stavu, tím vypočítá nový stav po provedení operace.
- Aby se jednalo o procesor, musí být obvod *programovatelný*, tj. sled operací jím prováděný je určený nějakým *programem*, který je uložený v nějaké *programové/instrukční paměti*.
- Procesor je "obecný", pokud na něm lze vypočítat libovolný spočítatelný příklad. Odborně se bavíme o Turingovské kompletnosti.
- V této paměti se nechází *strojový kód* - posloupnost instrukcí pro procesor v nějaké binární podobě, které procesor rozumí.
- Procesor si musí pamatovat, kde v programu se nachází, tj. kterou instrukci spustit jako další. Ukládá si to v tzv. `PC` (Program Counter) nebo `IP` (Instruction Pointer) registru. Tento registr obsahuje adresu příští instrukce v instrukční paměti. Typicky není uživatelsky přístupný, a s výjimkou skokových instrukcí se při provedení každé instrukce jednoduše zvětší.
- Datová cesta procesoru umožňuje provést každou operaci, kterou má procesor umět, pomocí nějaké kombinace *kontrolních signálů*. Je možné, že některé komplexnější operace/instrukce budou vyžadovat více cycklů, protože datová cesta neumožňuje provést celou operaci najednou. Snažíme se počet cyklů držet nízký. Typické komponenty v datové cestě procesoru:
  - 4-32 uživatelských registrů na mezivýpočty. Můžeme je např. zapojit tak, abychom mohli podle nějakých "adres" do jednoho z nich psát, a z libovolných dvou číst. Registry pak tvoří něco připomínající paměť s jedním zapisovacím a dvěma čtecími porty. Takové struktuře se pak říká "Registrová banka", někdy `GPR` (General Purpose Registers).
  - ALU
  - Datová paměť - na ukládání většího množství uživatelských dat, které se nevejdou do registrů
  - Input/Output zařízení, resp. interface logika pro komunikaci s nimi.
- Tyto kontrolní signály se z aktuálně prováděné instrukce vypočítají v tzv. `CU` (Control unit, Kontrolní jednotka). Podle zvoleného kódování strojového kódu může být výpočet komplexní nebo triviální.
- Máme následující abstrakce programu:
  - Zdrojový kód v low-level programovacím jazyce (C, C++, Rust, Zig, Go...), ten se pomocí *kompilátoru* přeloží na:
  - Jazyk symbolických instrukcí (assembler), jedná se o textovou a lidsky čítelnou reprezentaci programu. Každý řádek obsahuje jednu instrukci. Pomocí *assembleru (programu co assembluje)* se assembler přeloží na:
  - Strojový kód, což je binární podoba programu, která už není lidsky čitelná. Instrukce můžou mít libovolný počet bitů, a to buď všechny stejný, nebo různý (*variable-length instructions*). Bez znalosti specifik kódování daného strojového kódu nelze určit, co daný program děla, kde která instrukce začíná, nebo zda se vůbec jedná o program nebo náhodné data. Program v této podobě se nahraje do instrukční paměti procesoru, který postupně instrukce čte a dekóduje je na:
  - Kontrolní signály. Těmito procesor ovládá svoji datovou cestu, aby zajistil provedení té operace, kterou programátor určil.
- Assembler i strojový kód musí být dobře zdokumentovaný, aby bylo jednoznačně zřejmé, jaký program bude mí jaké chování v procesoru.
- Překlad z assembleru na strojový kód můžeme provádět ručně podle dokumentace - ta by měla obsahovat přesné rozložení bitů pro sestavení strojového kódu dané instrukce. Je to pracné a náchylné na chybu.
  - Místo toho můžeme použít nástroje, např. napsat si vlastní assembler (program), nebo použít nástoj [customasm](https://hlorenzi.github.io/customasm/web/), což budeme dělat my.

## 4.3.2025: Architektura souboru instrukcí

Témata z bakalářů:

1. Architektura souboru instrukcí (ISA), návrhové parametry procesoru
2. Typy architektur podle operandů, typy operandů instrukcí

Výpisky:

- ISA (Instruction Set Architecture) je kontrakt mezi návrhářem HW a vývojářem SW o tom, jak procesor funguje. Obsahuje vše, co je nutné zadefinovat:
  - Množina instrukcí (jaké instrukce, s jakými operandy, jaké je jejich chování)
  - Velikost dat, adres, operandů, instrukcí, etc.
  - Typy operandů v instrukcích
  - Kódování instrukcí (formát strojového kódu)
- Instrukce podle druhu:
  - Aritmetické instrukce - provádí výpočet pomocí ALU
  - Instrukce pro manipulaci s daty - přesun mezi registry, mezi registrem a datovou pamětí, načtení konstanty do registru...
  - Instrukce pro řízení toku programu (skoky) - nepodmíněné a podmíněné skoky
  - Speciální instrukce - nop, halt, IO, etc.
- Druhy operandů instrukce:
  - Přímý (**Immediate**) - konstanta v instrukci, např. `addi r1, 3`
  - Registrový - číslo registru v instrukci, např. `add r1, r2`
  - Přímá adresa - v instrukci je adresa do paměti, instrukce pracuje s hodnotou v paměti, např. `add r1, [0x1234]`
  - Registrový nepřímý (**Indirect**) - číslo registru v instrukci, v tom registru adresa do paměti, pracuje se hodnotou v paměti, např. `add r1, [r2]`.
  - ... a další.
- "Indirekce" = nemám hodnotu, ale mám adresu, kde ta hodnota je, pracuj s ní. Typicky se v assembleru značí nějakou formou závorek, e.g. `mov [r1], r2`.
- Strojový kód každé instrukce musí obsahovat:
  - Operační kód = nějaký počet bitů, podle kterého procesor *jednoznačně* pozná, že je to tahle instrukce.
  - Operandy instrukce.
  - Pozn: Operační kód může a nemusí být pro všechny instrukce stejně dlouhý.
  - Pozn: Operandy instrukce můžou a nemusí být v instrukci popřadě, dokonce můžou být jejich bity různě proložené, dokud je to pořadně zdokumentované.
- ISA podle komplexity a počtu instrukcí
  - CISC - Complex Instruction Set Computer. Komplexní instrukce, které umí typicky provést výpočet a pracovat s pamětí zároveň. Velký počet instrukcí. Např. x86
  - RISC - Reduced Instruction Set Computer. Malý počet jednoduchých jednoúčelových instrukcí. Aktuální trend ISA. Např. ARM, RISC-V, MIPS
- ISA lze podle schopností datové cesty procesoru a podle operandů ALU instrukcí rozdělit na různé kategorie:
  - GPR load-store ISA, 3 explicitní operandy (source A, source B, destination). e.g. `add r1, r2, r3` provede `r1 = r2 + r3`
    - Hodně univerzální, ale velké instrukce (3 explicitní operandy)
  - GPR load-store ISA, 2 explicitní operandy (source A / destination, source B). e.g. `add r1, r2` provede `r1 = r1 + r2`
    - Méně univerzální, ale menší instrukce - dobrý trade-off
  - Akumulátorová ISA, 1 explicitní operand (source A / destination je vždy akumulátor, udáváme pouze source B), e.g. `add r2` provede `ACC = ACC + r2`
    - lze zafixovat i source B a mít 0 explicitních operandů
    - malé instrukce, ale malá flexibilita - pro každý výpočet musíme manipulovat s daty z/do ACC -> pomalé, nepřehledný assembler
  - Zásobníková ISA - místo GPR máme zásobník. 0 explicitních operandů, operandy jsou vždy 2 horní prvky zásobníku a výsledek se ukládá na zásobník.
    - V hardwaru obsolete, ale v SW se používá např. uvnitř JVM.
  - GPR register-memory ISA - jeden/více source/destination operandů může jít z datové paměti
    - Typické pro CISC procesory - komplexní, pomalé.
- Mezi těmito varianty se rozhodujeme podle toho, co je pro nás jako návrháře CPU důležité:
  - Rychlost procesoru - počet cyklů per instrukce, maximální hodinová frekvence, čekání na paměť, etc.
  - Počet hradel (jednoduchost procesoru)
  - Velikost instrukcí - menší kód se rychleji načítá a tak v praxi beží rychleji. Alternativně, do stejnbé paměti se nám vejde komplexnější program.
  - Komplexita programování v assembleru (pokud máme compiler, tak nás tento bod moc nezajímá, viz x86)
- Naší prioritou by měla být jednoduchost programování v assembleru (smysluplné jednoduché instrukce) a jednoduchost instrukcí (jednoduchá implementace v jediném cyklu).

## 11.3.2025: Zrušeno

## 18.3.2025: Návrh ISA, mapování strojového kódu
