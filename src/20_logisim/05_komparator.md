# Komparátor

{{ todo("Přepsat stránku") }}

### Cvičení

#### 1 bitový komparátor

Postavte 1 bitový komparátor, který má 2 vstupy $A,B$ a 3 výstupy `A>B` (GT), `A=B` (EQ), `A<B` (LT)

<details>
  <summary>Řešení</summary>
  <img src="../img/comp1b.png">
</details>

---

#### 2 bitový komparátor

Postavte 2 bitový komparátor, který má dva 2 bitové vstupy $A,B$ a 3 výstupy `A>B` (GT), `A=B` (EQ), `A<B` (LT)

<details>
  <summary>Řešení - Komparátor 2b</summary>
  <img src="../img/comp2b.png">
</details>
<details>
  <summary>Řešení - compGE</summary>
  <img src="../img/compge.png">
</details>
<details>
  <summary>Řešení - Popis</summary>
  Vytvořili jsme si compGE, abychom ušetřili dvě logic gaty, jelikož potřebujeme pro 2 bitový komparátor pouze GT a EQ.
</details>