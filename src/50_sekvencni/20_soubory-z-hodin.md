# Logisim soubory z hodin

- [sekv_exp_sq_mul.circ :paperclip:](../logisim/sekv_exp_sq_mul.circ)
  - Umocňování Sq-Mul pomocí kombinačního square a kombinačního multiply (dvě násobičky, 4 cykly)
  - Umocňování Sq-Mul pomocí jediné kombinační násobičky (6 cyklů, ale poloviční kritická cesta = dvojnásobná maximální frekvence!)
  - 32bit Násobení Double-Add (jedna 32bit sčítačka, 33 cyklů)
  - Umocňování Sq-Mul pomocí sekvenční násobičky Double-Add (až 171 cyklů, ale pomocí jediné 32bit sčítačky - obrovská maximální frekvence)
- [sekv_double_dabble.circ :paperclip:](../logisim/sekv_double_dabble.circ)
  - Algoritmus Double-Dabble na převod do BCD (bonusová operace ALU)
  - 17 cyklů, ale pouze 4 instance jádrové operace algoritmu
- [sekv_compute_expr.circ :paperclip:](../logisim/sekv_compute_expr.circ)
  - Výpočet výrazu $(A-B)+(C-D)$ pomocí jediné sčítačky
  