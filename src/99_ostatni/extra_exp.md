# Práce na hodině: Umocňování pomocí metody Square and Multiply

Je možné odevzdat práci začatou na hodinách v uterý/středu 14./15.1. za až 2 bonusové body. Odevzdání probíhá na Submitty (je na to založena nová gradeable) a je možné do konce čtvrtka 16.1. (tedy 23:59). Je možné jedno odevzdání a bude hodnoceno ručně.

## Specifikace modulu

Je nutné postavit sekvenční modul, který realizuje umocnění 4-bitového základu (vstup A) na 3-bitový exponent (vstup B), tedy spočítat operaci $OUTP = A^B$, během jednoho načítacího a 3 výpočetních cyklů (tedy dohromady během 4 cyklů). Výstup musí být alespoň 28-bitový, aby se do něj vešel maxímální možný výsledek ($15^7$). Pro jednoduchost řekněme, že výsledek bude 32-bitový. Modul se bude jmenovat `EXP` a můžete (máte) v něm používat logisimové matematické operace, e.g. násobení. Pro implementaci stačí dvě násobičky, víc pro sekvenční implementací umocňování není potřeba.

```kroki-symbolator
module EXP #(
) (
    input [3:0] A,
    input [2:0] B,
    input start,
    input clk,
    output [31:0] OUTP,
    output done
);
endmodule
```

## Časování

Modul je plně synchronní, reaguje na vstup a mění svůj výstup tedy pouze s náběžnou hrannou vstupu `clk`.

Pokud je na vstupu `start=1`, načte modul vstupy a připraví se na výpočet (toto může nastat i během výpočtu, v takovém případě se výpočet ruší a připraví se nový podle vstupů.

Jakmile `start=0`, provede modul s každým clockem jeden krok výpočtu. Během tohoto musí být výstup `done=0`. Modul může počítat s tím, že po celou dobu jednoho výpočtu zůstanou vstupy A a B konstatní. Jakmile modul dokončil výpočet a na výstupu `OUTP` prezentuje správný výsledek, musí přestat počítat (výsledek musí zůstat konstantní, dokud nepřijde další `start=1` signál). Zároveň toto musí indikovat pomocí `done=1`.

Příklad průběhu výpočtu modulu:

```kroki-wavedrom
{signal: [
  {name: 'clk',   wave: 'P...........'},
  {name: 'start', wave: '010.1.0....1'},
  {name: 'done',  wave: '1.0......1..'},
  {name: 'A',     wave: 'x=..=......=', data: ["9", "2", "4"]},
  {name: 'B',     wave: 'x=..=......=', data: ["5", "3", "4"]},
  {name: 'OUTP',  wave: 'x.====.===..', data: ["1", "81", "6561", "1", "1", "4", "16"]}
],
 head: {
   tick: 0
 }}
```

Popis událostí (ticků) v diagramu:

- 1: Uživatel zadefinoval A a B a zadal `start=1`. Modul o tom ale zatím neví, na tuto změnu bude moct zareagovat **až v přístím cyklu**.
- 2: Modul zpracoval `start=1`: inicializoval interní registr (a tímpádem i OUTP) na 1, změnil `done=1`.
- 3-4: Dva cykly výpočtu $9^5$.
- 5-6: Modul reaguje (dvakrát za sebou) na inicializační požadavek `start=1` od uživatele. První požadavek inicializuje OUTP=1. Druhý požadavek nemá na hodnoty žádný další vliv, protože už mají správnou hodnotu.
- 7-9: Tři výpočetní cykly $2^3$. OUTP průběžně reflektuje částečný výsledek (ale toto chování není zdokumentované a uživatel by tuto hodnotu měl ignorovat!).
- 9: Posledním výpočetním cyklem se nastaví `done=1` a na výstupu je správný výsledek. Ten tam vydrží, až do té doby, než se **zpracuje** přístí `start=1` (což je tady až ve 12. ticku).
