# Jednoduché architektury (ISA)

## i8080 / Z80

Architektura mikroprocesoru [Intel 8080](https://en.wikipedia.org/wiki/Intel_8080) je velmi jednoduchá, s syntaxe jejích instrukcí se hodně podobá x86.

Architektura procesor Zilog Z80 je zpětně kompatibilní (naklonovaná) k 8080, ale má další instrukce navíc - tyto rozšíření nebudeme řešit.

- Datová šířka: 8bit, ale některé instrukce umí 16bit  
- Šířka instrukce: 8bit + případné immedate operandy (8 nebo 16bit). Operační kód variabilní délky
- Architektura: Akumulátorová
- Registry: A,B,C,D,E,H,L (8bit) a PC,SP (16-bit)
  - A je akumulátor
  - registry H a L slouží dohromady (High a Low byte) jako 16bit adresa `M` pro práci s datovou pamětí
  - SP je stack pointer

```admonish info title="Blokový diagram",collapsible=true
![](https://upload.wikimedia.org/wikipedia/commons/5/5d/Intel_8080_arch.svg)
```

Popis instrukcí: [8080instructions.pdf](../docs/8080instructions.pdf)

Kódování instrukcí: [Tabulka](https://pastraiser.com/cpu/i8080/i8080_opcodes.html) - je zde každá možná varianta každé instrukce v mřížce podle strojového kódu

Programátorská příručka: [8080 Programmers Manual.pdf](../docs/8080%20Programmers%20Manual.pdf) - 91 stran, obsahuje kompletní informace o ISA. Nečíst, ale otevřít a podívat se na dokumentaci alespoň jedné instrukce, např. instrukcí typu JUMP na straně 37 dokumentu (tj. straně 31 původní knihy).

## MIPS I

[Verze I architektury MIPS](https://en.wikipedia.org/wiki/MIPS_architecture#MIPS_I) je jednoduchá, ale výkonná ISA. Moderní varianty MIPS naleznete dnes např. v některých routerech, zejména MikroTik.

- Datová šířka: 32bit, novější verze 64bit
- Šířka instrukce: 32bit včetně operandů a 6bit operačního kódu
- Architektura: GPR load-store, 3 operandy
- Registry: \$0 až \$31, HI, LO (32bit)
  - \$0 je při čtení vždy 0, a zápisy do něj se ztratí - to zjednodušuje instrukční sadu
  - HI, LO jsou speciální registry na specifické operace, e.g. dělení
  - Některé registry mají speciální jména a účely, e.g. \$29 je \$sp (stackpointer)

Popis instrukcí: [MIPS_Instruction_Set.pdf](../docs/MIPS_Instruction_Set.pdf)

Prezentace o MIPS a o ISA obecně, o programování v assembleru, etc.: [mips-isa.pdf](http://www.cs.columbia.edu/~martha/courses/3827/sp16/mips-isa.pdf)

Programátorská příručka: [MIPS Programmers Guide](../docs/MIPS%20Programmers%20Guide.pdf) - 244 stran, koukněte např. na Computational instructions na straně 50 dokumentu (kapitola 5 strana 10 knihy).

## RISC V

Moderní RISC architektura [RISC-V](https://en.wikipedia.org/wiki/RISC-V#Design) vznikla nedávno jako free alternativa k ARM ISA. Konkrétní podoba architektury závisí na zvolených rozšířeních, od mikrokontrolerů (`RV32I`) až po procesory vhodné na desktop computing (Framework RISC-V mainboard má 4x `RV64GCB`)

- Datová šířka: 32 nebo 64bit
- Šířka instrukce: 32bit nebo volitelně 16bit
- Architektura: GPR load-store, 3 operandy
- Registry: x0-x31 (32bit)
  - Registr x0 je vždy 0
  - Některé registry mají speciální názvy a účely

```admonish info title="Blokový diagram",collapsible=true
![](./riscv-diagram-comparch.png)
```

Interaktivní simulátor: [comparch.edu.cvut.cz](https://comparch.edu.cvut.cz/qtrvsim/app/)

Cheatsheet instrukcí: [RISCV_CARD.pdf](../docs/RISCV_CARD.pdf)

Reference: [riscv-unprivileged.pdf](../docs/riscv-unprivileged.pdf) - 670 stran, ale pro nás je podstatná pouze kapitola 2 - RV32I Base Integer Instruction Set - to je ~15 stránek velmi hezky formátované a srozumitelné dokumentace k nejdůležitějším instrukcím této ISA.
