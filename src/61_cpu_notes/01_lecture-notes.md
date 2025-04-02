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

## 25.3.2025: Návrh ISA, Obecnost procesoru

- Adresní režimy (pokračování), implementace (všech) adresních režimů v datové cestě
  - `mov R1, [R1 + R2*d + c]` - přístup do pole struktur (C `struct`) ke konkrétní položce (`field`) struktury. Bežné na CISC
    - ořezané varianty toho adresního režimu, e.g. pouze `+c`
  - postinkrement, predekrement - ekvivalent `a = arr[i++]` a `a = arr[--i]` v C. Implementováno v HW paralelně s paměťovým přístupem. Nutné pro hardwarovoou podporu zásobníku, tedy instrukcí `push` a `pop`
  - x86 instrukce `lea`, a jak se komplexní adresní režim na x86 "zneužívá" k bežným výpočtům (které s adresou nebo pamětí nemusí mít nic společného)
- Adresní režimy jsou vlastností datové cesty procesoru, každý parametr každé instrukce podporuje některé adresní režimy, ne nutně všechny
- Operace, které musí jít nutně provést na obecném procesoru (ne nutně pomocí jediné instrukce):
  - [ALU] provést ALU operaci na libovolných datech v CPU (registry, paměť, immediate v instrukcích neboli konstanty v kódu)
  - [move] přesun (kopírování) dat mezi libovolnými registry
  - [load/store] přesun dat do/z paměti z/do libovolného registru na vypočtenou adresu (tj. adresu z e.g. registru)
    - můžou být též implementovány jako varianty move instrukce, pokud v ní je místo na pár bitů na rozlišení - mají totiž podobnou sadu operandů
  - [load imm] načtení konstanty (tj. dat z instrukcí) do libovolného registru
  - [jump] skok (změna PC) na vypočtenou adresu (tj. e.g. z registru)
    - může být např. vynechán pokud lze realizovat move instrukcí
  - [cond] podmíněné spuštění (příští) instrukce
    - může být realizováno jako podmíněný skok (bežné), ale nemusí - je to ekvivalentní přeskočení příští instrukce, pokud příští instrukce je jump
    - přeskočení příští instrukce může být komplikované, pokud jsou instrukce variabilní délky - potom pomáhá mít v instrukci její délku
    - podmínky: lt, gt, eq, zero, sign (negative), overflow
      - konkrétní realizace není specifikovaná
      - typicky každý flag výstup z ALU by měl jít použít jako podmínka
      - operandy pro porovnání nebo test můžou být specifikovány v instrukci, nebo může být použit výsledek z předchozí (např. ALU) operace
      - je potřeba umět vyhodnotit podmínku i její opak
        - e.g. opak od $A \gt B$ je $A \le B$
        - nemusí to být implementováno v HW, protože v assembleru půjde podmínky invertovat tím, že podmíněným skokem "přeskočíme jump instrukci" na kód pro opačnou podmínku
        - alu záporné varianty instrukcí (jz -> jnz, jeq -> jne) zjednodušují při programování v assembleru uvažování o podmínkách. Instrukce lze realizovat též jako pseudo-instrukce v assembleru
  - [io] musí jít komunikovat s input a output zařízeními - různé způsoby, je jedno jak
- Ne vsechny tyto operace musí být na procesoru přímo proveditelné v jedné instrukci - stačí když lze provést pomocí několika instrukcí (tuto skutečnost budete na vašem CPU muset demonstrovat)
  - Je tedy možné některé instrukce "omezit" (zafixovat některé z jejich operandů, nebo některé instrukce pro některé adresní režimy vůbec neimplementovat), pokud lze toto omezení "zrušit" použitím posloupnosti jiných instrukcí procesoru
  - Např:
    - ALU instrukce nemusí umět brát immediate, pokud umí brát registr, a do registru lze jinak načíst immediate
      - Opačně (např. v RISC-V): Nemusíme mít instrukci typu load imm, pokud umíme ALU operaci s nulovým registrem a immediate
    - Práci s paměti nemusí jít provést nad libovolnými registry, pokud umíme mezi registry hodnoty přesouvat
      - Opačně (ale nepraktické): Nemusíme umět přesouvat mezi registry, pokud umíme libovolný registr uložit+načíst z paměti
    - Jump může jít realizovat jako move do (v tomto případě nutně uživatelského) registru PC.
      - Pořád je potřeba nějak řešit podmínky. Příklad pro tuto variantu může být např. instrukce, která podle podmínky zabrání spuštění příští move instrukce (tedy i jumpu, a jump je schopen přeskočit libovolné instrukce => naplnili jsme požadavek "podmíněné spuštění instrukce").
    - Pokud v instrukci není dost bitů pro všechny nutné operandy, lze instrukci rozdělit na dvě instrukce "přípavu" a "dokončení" operace. Procesor si parametry z přípravy zapamatuje do speciálních registrů a použije je při dokončení
      - Např. načíst 16bit immediate, pokud instrukce jsou 16bitové, lze realizovat dvěmi instrukcemi: load high 8 bits, load low 8 bits
    - Pokud datová a instrukční paměť jsou ta samá paměť (u některých CPU je a u některých není), není load imm vůbec potřeba - načíst konstantu lze jednoduše pomocí move instrukcí se správnou (předem známou) adresou
  - Je vhdoné zvolit nějaký kompromis mezi:
    - Počtem instrukcí
    - Komplexitou implementace instrukcí v HW
    - Množstvím a velikostí operandů s ohledem na zvolenou velikost instrukce
    - Přidanou komplexitou při programování v assembleru (přesouvání dat, atypické skokové struktury, etc.)
    - Počet nutných instrukcí pro bežně používané operace (klasické C konstrukty jako for loopy, if-else, práce s array a strukturami, etc.)
      - Ovlivňuje rychlost procesoru i velikost kódu
- *konec středeční skupiny*
- Mapování instrukcí do strojového kódu
  - Nejjednodušší způsob - fixně velký (e.g. pro procesor se 14 instrukcemi minimálně 4 bity) tzv. "opcode" (operační kód) na začátku instrukce, který přesně identifikuje typ instrukce
  - (výhoda) Dekódování instrukci (zjištění ze strojového kódu, o kterou instrukci se jedná) lze pak v HW realizovat jednoduše dekodérem
  - (nevýhoda) Každá instrukce má k dispozici stejný počet bitů na operandy - některým instrukcím to nemusí stačit, pro některé to může být zbytečně moc
    - Instrukce, kterým to nestačí, se musí ořezat, rozdělit na dvě instrukce, nebo začít zabírat dvě adresy (variabilní délka instrukcí přidává komplexitu), nebo se musí zvětšit všechny instrukce (ještě víc wasted místa v ostatních instrukcích)
  - Do nevyužitého prostoru v instrukcích se ale můžou přidat bity upřesňující variantu/režim/chování instrukce, např:
    - load a store a move můžou být pouze varianty jedné univerzální move instrukce - berou totiž podobné operandy - jednodušší dekódování+datová cesta
    - jump instrukce může obsahovat 1 bit pro každou možnou podmínku - pokud je 1, skočí se pouze, pokud je podmínka splňená. Samé nuly => nepodmíněný skok
    - V případě chytrého použití variant instrukcí počet různých instrukcí (a případně nutná šířka opcode) rapidně klesá - jednodušší implementace
  - Jiný způsob - VLSM - operační kód je pro každou instrukcí různě dlouhý, ale mezi sebou se nepřekrývají
    - Instrukce s velkým počtem operandů mají krátký opcode - takových může být málo
    - Instrukce s malým počtem operandů mají delší opcode - může jich být víc
    - Stejný princip jako Variable Length Subnet Mask v sítích
    - Pro 8bit instrukce (bez variabilní délky instrukcí) v podstatě nutnost
    - Na příští hodině detaily
- DÚ (TBA): Sestavit si vlastní ISA splňující tyto kritéria s nějakou zajímavostí, inspirovat se dá na stránce s jednoduchými ISA.

## 1.4.2025: Návrh blokového diagramu CPU

Konkrétně návrh blokohového diagramu jednocyklového procesoru podle zvolené instrukční sady.

Postup návrhu:

- Projít si všechny instrukce, jejich chování, uvědomit si, s jakými daty pracují, jaké jednotky (ALU, etc.) používají, a kam ukládají výsledek.
  - *Pro každou kombinaci chování musí procesorem existovat fyzické cesty, kterými data mohou téct, aby provedli danou operaci, jinak procesor nebude jednocyklový*
- Umístit do blokového designu všechny moduly, které budou v procesoru potřeba, označit jejich vstupy a výstupy, včetně kontrolních signálů a clocku
  - GPR (general purpose register file), s nějakým počtem zapisovacích a čtecích portů, podle potřeb ISA
  - ALU
  - Datovou paměť
  - Instrukční paměť, PC registr, CU (control unit, kontrolní jednotku)
    - Separátní instrukční a datovou paměť máme, aby šly paměťové instrukce načíst a provést v jediném cyklu. V případě sjednocené paměti bychom museli v jednom cyklu načíst instrukci, a pak až v dalším cyklu provést paměťovou operaci
- Na každém vstupu každého modulu budeme možná potřebovat pro různé instrukce přivést jedny z více různých dat (z různých míst v procesoru)
  - Tento problém výběru N z 1 můžeme vyřešit přidáním kontrolního signálů, který řídí, která z hodnot se vybere, a komponenty, která podle tohoto signálu umí výběr provést
  - Není problém tohle udělat pro každý ze vstupů, i pokud nakonec zjistíme, že tam byla potřeba pouze jední hodnota, a výběr tedy nebylo potřeba řešit - stačí výběrový řídící signál zafixovat na konstantní hodnotu (všechny syntézní nástroje toto vyoptimalizují na přímé spojení drátů).
- Pro každou instrukci projdeme tok dat, který zkrz CPU vyžaduje, a přidáme do možného výběru daných vstupů dráty s daty, které tam instrukce potřebuje.
  - ie. chceme-li kopírovat z libovolného registru do libovolného registru - musí jít přivést čtecí výstup z GPR do zapisovacího vstupu GPR
- Je výhodné při kreslení diagramu používat "tunely" / "labely drátů" - pokud dva dráty na různých místech stejně pojmenujete, chápou se jako spojené.
  - Zredukujete tím šum z množství drátů, a zároveň tím diagram lépe zdokumentujete, protože každý drát smysluplně pojmenujete
- U každé komponenty dbejte na označení a pojmenování všech kontrolních signálů. Tyto signály nejsou potřeba nikam připojovat, předpokladá se, že je generuje CU.
- Každá sekvenční komponenta musí mít symbol clock inputu, není potřeba ho nikam zapojovat, všechny clocky se chápou spojené
- Pozor na to, že každá instrukce (vyjma úspěšných skoků) musí implicitně zvětšit PC, aby se v příštím cyklu spustila následující instrukce. Bez této funkcionality bude procesor opakovaně spouštět pouze první instrukci, nespustí tedy program, tedy není programovatelný, tedy to **není procesor**!
- Zapojení IO instrukcí silně závisí na jejich konkrétní variantě, nicméně vždy platí, že budou vysílat nějaké hodnoty mimo procesor, nebo je přijímat z vnějšku. To můžeme označit např. použitím kraje papíru jako hranice modulu procesoru, nebo pomocí symbolu $\vcenter{\rightarrow}\!\boxtimes$, kterým označíme fyzický pin procesoru jako reálného integrovaného obvodu (ie. drát co z něj vede ven)
  - Kde v CPU se tyto odchozí hodnoty berou, nebo kam se mají příchozí hodnoty v CPU uložit, je zřejmé z instrukce, a podle toho je potřeba upravit datovou cestu
  - Jednobitové statusové IO signály se vypočítají v CU (jde o kontrolní signály) pokud jde o výstupy, nebo slouží jako vstupy do CU (jde o stavové/statusové signály) pokud jde o vstupy. Zejména
  - e.g. `out_valid`, který navenek signalizuje, že CPU chce odeslat (validní) hodnotu
  - e.g. `in_valid`, který procesoru zvenku udává, že je k dispozici hodnota, kterou input instrukce může přečíst
  - e.g. `in_acknowledge`, kterým procesor indikuje, že hodnotu na vstupu zpracoval a odesílatel ji může přestat vysílat
- Žádný modul nelze v jednom cyklu použít na dva různé účely zároveň.
- Statusové výstupy z ALU (a klidně další) je potřeba uložit, aby s nimi mohly příští instrukce pracovat. Těmto hodnotám a registru kam je uložíme, se říká příznaky (flags)
  - Může být jeden N-bit flag registr, nebo N jedno-bitových registrů (pro N flagů), není v tom rozdíl. Zvolte, s čím se vám bude v kontextu vybraných instrukcí lépe pracovat
  - Ne všechny instrukce způsobí uložení flagů, obecně by se měly uložit pouze ty flagy, které nebývají v tomto cyklu smysluplné hodnoty. Např. při operaci xor se nastaví zero a sign ale ne carry, protože neexistuje smysluplná hodnota carry ve výsledku operace xor. Pro zjednodušení může např. ALU operace přepsat všechny flagy, ale ostatní instrukce ne.
    - Nezáleží na podobě konkrétní implementace, ale záleží na tom, aby bylo zvolené chování **zdokumentované**. V momentě, kdy je chování zdokumentované, nemůže být "špatně" - je to to co jste vy jako návrhář zvolili, a je zodpovědností programátora se tomu přizpůsobit. Procesor ale musí stále být obecný.
  - Flagy se používají na různých místech, např. CU je potřebuje pro rozhodnutí o podmínkách skoků, a ALU bude svůj CIN brát také z flagů. Nezapomeňte tyto skutečnosti v diagramu naznačit - pokud CU nemá vstup "flags", který má hodnotu z flag registru, nemá podle čeho o skoku rozhodnout!
- Kontrolní jednotka má jako vstup aktuální instrukci, a jako výstup případné dekódované immediate hodnoty. Ale má i spoustu dalších vstupů a výstupů z následujících dvou kategorií:
  - Kontrolní signály (výstupy) - řídí konfiguraci datové cesty. Nemusíte je u CU uvádět jako výstupy explicitně, stačí naznačit pár výstupů a nadepsat "control signals" nebo podobně. Předpokládá se, že všechny pojmenované *non-driven* dráty (bez nějakého zdroje signálu) jsou kontrolními signály a generuje je právě CU.
  - Stavové (status) signály (vstupy) - další informace o stavu datové cesty, které CU potřebuje k rozhodování. Sem patří např. flagy, `in_valid` z IO, případný signál `done` z např. sekvenční násobičky v ALU, na kterou se musí počkat, etc.
- Kontrolní jednotka umí dekódovat instrukci, můžeme jí pověřit kromě generování signálů i dalšími vypočetními úkoly, které s dekódování instrukce souvisí, např.:
  - Extrakce immediate argumentů z instrukce spravným způsobem (dle typu instrukce)
  - Vypočítání nové hodnoty flagů, pokud je potřeba flagy instrukcí přímo upravit (tj. ne nepřímo výpočtem z ALU)
- Každý vodič má vyznačenou **velikost** - pokud má CPU 16-bit data, bude velká část vodičů 16bit, avšak ne všechny. Např. vstup a výstup flag registru, immediate hodnoty z instrukce, a další budou mít jinou velikost
  - **Nelze spojit vodiče dvou různých šířek** - taková operace je nejasná, nespecifikuje, co se zbylými dráty. Je potřeba provést konverzi.
  - Konverze mají několik typů podle hodnot, nad kterými pracují. Rozlišujeme *zvětšení* / *zmenšení* podle velikosti, a *signed* / *unsigned* podle typu dat na drátě.
  - Zvětšení:
    - Unsigned: hodnotu interpretujeme jako číslo bez znaménka, stačí tedy na MSB straně hodnotu rozšířit nulami (Zero Extend), a hodnota zůstane zachovaná.
    - Signed: hodnotu interpretujeme jako číslo *se znaménkem v dvojkovém doplňku*, tj. při rozšíření musí zůstat znaménko i hodnota čísla zachovaná. Nestačí rozšířit nulami - to by vždy vytvořilo kladné číslo, ještě ke všemu jiné hodnoty. Na první pohled se to zdá komplikované, ale tato konverze se dá implementovat jednoduše: rozšíříme hodnotu na MSB straně čísla nikoliv nulami, ale hodnotou znaménka čísla (tedy hodnotě MSB). Tedy z čísla `SXXXXXXX` uděláme `SSSSSSSSSXXXXXXX`, kde `S` je sign bit čísla a `XXXXXXX` je zbytek čísla. Např. rozšíření 4-bit hodnoty $-2$ = `1110` na 8-bit vytvoří hodnotu `11111110`, což je v 8-bit dvojkovém doplňku pořád $-2$. Tento postup funguje i pro kladné čísla, kde `S=0`. Tomuto postupu se říká Sign Extend.
  - Zmenšení:
    - Unsigned: Jednoduše zahodíme MSB bity. Pokud některý z nich byl 1 (lze spočítat hradlem OR pokud je to potřeba), znamená to overflow - hodnota nebude stejná jako vstup, a nelze s tím nic dělat. Výsledná hodnota bude mít hodnotu $a \bmod 2^{N}$, kde $a$ je vstupní hodnota a $N$ je počet bitů výsledku.
    - Signed: Chceme zachovat znaménko čísla. Oddělíme tedy sign bit `S` od zbytku čísla. Zbytek čísla zmenšíme postupem pro unsigned číslo na $N-1$ bitů, a před výsledek vrátíme sign bit `S`, čímž cískáme `N`-bitové číslo. Výsledek bude mít hodnotu $\t{sgn}(a) \cdot (\lvert a \rvert \bmod 2^{N-1})$.

## 8.4.2025: Mapování instrukcí do strojového kódu

