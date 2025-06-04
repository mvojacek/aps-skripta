# customasm

Customasm je assembler s nastavitelnou syntaxí instrukcí a kódování strojového kódu.

[Github](https://github.com/hlorenzi/customasm)

[Online nástroj (oficiální)](https://hlorenzi.github.io/customasm/web/)

[Dokumentace (oficiální)](https://github.com/hlorenzi/customasm/wiki)

[Kuchařka ve skriptech](../60_cpu/04_cpu-programming.md)

Doporučuji si přečíst [kapitolu customasm wiki](https://github.com/hlorenzi/customasm/wiki/Defining-mnemonics-%E2%80%94-%23ruledef%2C-%23subruledef), kde se popisuje vytváření přepisovacích pravidel.

Oficiální customasm umí exportovat pouze pro 8-bit a 16-bit Logisim paměti.  
[Upravená verze](https://mvojacek.github.io/customasm/web/) ([github](https://github.com/mvojacek/customasm)) umí libovolné 4-32bitové paměti.

Pro nastavení počtu bitů slova instrukce je potřeba na začátek umístit a upravit následující blok, a použít upravenou verzi customasm a použít správný Logisim output formát.

```
#bankdef code
{
    #bits 22
    #addr 0x0000
    #size 0x8000
    #outp 0x0000
}
```

Pro označení registrů nebo alu operace můžete s výhodou použít `#subruledef` ([skripta](https://skripta.vojacek.org/60_cpu/04_cpu-programming.html#subruledef), [wiki](https://github.com/hlorenzi/customasm/wiki/Defining-mnemonics-%E2%80%94-%23ruledef%2C-%23subruledef#nested-rule-parameters)).

Pomocí `asm` bloku lze realizovat pseudoinstrukce složené z jedné nebo více jiných instrukcí:

```
ldi {dst: register}, {value: u16} => asm {
    xor {dst}, {dst}
    addi {dst}, {value[15:8]}
    shli {dst}, 8
    addi {dst}, {value[7:0]}
}
```

Užitečné příklady kromě zmíněného můžou být např. skok na immediate adresu (`ldi R1` + `jmp R1`), nop, různé manipulace s flagy.

Stejně jako labely lze použít jako hodnotu (adresu následující instrukce za labelem), lze použít symbol `$`, který se přeloží na adresu *aktuální instrukce* (tu customasm zná a dosadí jako číslo). Pomocí tohoto symbolu a výpočtů lze např. realizovat pseudoinstrukci absolutního skoku (na label) pomocí relativního skoku v CPU (více detailů viz [advanced rules na wiki](https://github.com/hlorenzi/customasm/wiki/Advanced-rules)):

```
jmpi {addr: u16} => {
    ; korekce o -1 nebo podobné bude záviset na tom,
    ; jak vaše CPU interpretuje relativní adresy
    reladdr = addr - $ - 1
    asm { jmpri {reladdr} }
}
```
