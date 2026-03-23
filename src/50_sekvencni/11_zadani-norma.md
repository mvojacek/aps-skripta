# DÚ: Akcelerace Euklidovské normy ve 2D pomocí CORDIC

```admonish important title="Verze Logisimu"
Pro tuto úlohu je potřeba Logisim alespoň verze **4.1.0**. Připravené soubory nebudou v Logisimu 4.0.0 a starším fungovat! Aktualizujte svůj Logisim viz [instalace](../20_logisim/01_logisim-instalace.md) a případně si stáhněte i novou [template](../20_logisim/01a_template.md).
```

```admonish info title="Používání AI"
Zvažte prosím před nakopírováním celého zadání do AI, zda nezkusit udělat úkol úplně bez, anebo alespoň s minimálním použitím AI. Tato úloha je navržená tak, abyste dokázali postupným porozuměním problému dospět k řešení, které je ve srovnání se samotným problémem velmi jednoduché a elegantní. Nemám pochyby o tom, že AI bude schopná z kontextu zadání rovnou dospět k optimálnímu řešení - to je tím, že CORDIC je už desítky let podrobně studovaný a je o něm velká spousta literatury.

Cílem tohoto úkolu ovšem není jenom získat optimální řešení, ale vyzkoušet si proces práce s dokumentací a odbornou literaturou, a na základě ní řešení navrhovat. U více obskurních nebo nedávných problémů, kde AI nebude schopné úlohu řešit "na základě dlouholetého výzkumu", vám nezbyde nic jiného. Pokud si chcete udržet použitelnost i ve světě, ve kterém je AI všudypřítomné a používá se na vše, budete řešit právě tyto druhy problémů - všechny ostatní bude řešit AI. Bohužel takové obskurní úlohy vám nemohu úplně zadat za úkol na střední škole, takže úkoly budou z principu pomocí AI lépe či hůře řešitelné. Ale ke komplexním problémům, kde AI selhává, se musíte propracovat.

Ten, kdo bude umět řešit problémy pouze pomocí AI, bude tou AI nevyhnutelně nahrazen.
```

## Vysvětlení problému a algoritmu

Navrhovaný modul bude umět spočítat euklidovskou normu 2D vektoru postupným zpřesňováním výsledku (tzv. *iterativně*), a to pouze za použití dvou sčítaček-odčítaček a dvou barrel shifterů (a jedné násobičky konstantou), pomocí algoritmu CORDIC.

```admonish info title="Návod ke čtení"
Tento popis postupuje od jednoduchých konceptů ke komplikovanějším, co nejvíce to jde, ale i tak se může stát, že vám nebude nějaká pasáž dávat smysl (nebo vám nepřijde důležitá a neporozumíte jí), než budete mít lepší přehled o celém problému. Doporučuji se u prvního čtení nesoustředit tolik na konkrétní detaily nebo matematiku, ale spíše na obecný princip. Poté se můžete ve druhém čtení vrátit ke komplikovanějším sekcím a začít řešit, proč to vlastně funguje.
```

### Euklidovská norma

Spočítat *euklidovskou normu* vektoru $\vec{v}$ znamená geometricky vzato spočítat jeho skutečnou "délku" v (euklidovském) prostoru. Normu značíme $\lVert \vec{v} \rVert$ a pro 2D vektor $\vec{v} = [x, y]$ ji spočítáme pomocí Pythagorovy věty: $\lVert \vec{v} \rVert = \sqrt{x^2 + y^2}$. Určovat normu vektoru je potřeba na nejrůznějších místech: v samotné matematice, ale i ve fyzice, při zpracování signálu a třeba i v počítačové grafice. Protože umocňování i odmocňování jsou náročné operace, existují algoritmy, které se k výsledku postupně dopočítají pomocí jednodušších operací. My si ukážeme algoritmus CORDIC.

### <ins>CO</ins>rdinate <ins>R</ins>otation <ins>DI</ins>gital <ins>C</ins>omputer (<ins>CORDIC</ins>)

Algoritmus CORDIC vzniknul v roce 1959 (ale podobné matematické techniky se používaly už v 17. století) pro výpočty při zaměřování v radarových systémech. Samotná implementace CORDICu je jednoduchá a kompaktní, proto se používá např. v kalkulačkách, a je hotová k dispozici pro všechna možná FPGA - jedná se o standardní aritmetický blok v hardwarových knihovnách.

Samotný CORDIC provádí velmi jednoduchou operaci: Na vstupech bere 2D vektor $\vec{v}$ a úhel $\Theta$, a po několika cyklech vrátí otočený vektor $\vec{v}$ o úhel $\Theta$ proti směru hodinových ručiček, viz obrázek ([zdroj](https://web.cs.ucla.edu/digital_arithmetic/files/ch11.pdf)):

![](./img/vector-rotation.png =500x center)

Nezní to příliš zajímavě, ale pomocí této jednoduché operace a vhodně zvolených vstupů lze s vysokou přesností spočítat hodnoty nejrůznějších "strašidelných" funkcí:  
$\sin(\theta), \cos(\theta), \sinh(\theta), \cosh(\theta), a \cdot e^\theta, \ln(a),
\sqrt{a^2+b^2}, \sqrt{a^2-b^2}, \sqrt{a}, \ldots$

### Princip Rotačního CORDICu

#### Rotace vektoru pomocí rotační matice

Otočit vektor $\vec{v} = [x_0, y_0]$ o úhel $\theta$ je velmi jednoduché, pokud umíme spočítat sin a cos a násobit vektor maticí. Vektor stačí zleva vynásobit tzv. [Rotační maticí](https://en.wikipedia.org/wiki/Rotation_matrix) o úhel $\theta$ proti směru hodinových ručiček:

$ \mathbf{R}_\theta = \begin{bmatrix}
\cos(\theta) & -\sin(\theta) \\
\sin(\theta) & \cos(\theta) \end{bmatrix}$

$ \begin{bmatrix}x \\ y\end{bmatrix} = \vec{u} =
\mathbf{R}_\theta \cdot \vec{v} = \begin{bmatrix}
\cos(\theta) & -\sin(\theta) \\
\sin(\theta) & \cos(\theta) \end{bmatrix}
\cdot \begin{bmatrix}x_0 \\ y_0\end{bmatrix}
$

Tedy po roznásobení matice:

$ x = x_0 \cos(\theta) - y_0 \sin(\theta) \\
y = x_0 \sin(\theta) + y_0 \cos(\theta)
$

Spočítat $\sin(\theta)$ a $\cos(\theta)$ pro libovolné $\theta$ je obtížné. Ale pro některé $\theta$ je to jednoduché: např. pro $\theta = \pi / 2$ víme, že $\sin(\theta)=1$ a $\cos(\theta)=0$. Pokusíme se problém nějak převést na výpočet s pomocí pouze "známých úhlů", ke kterým známe odpověď.

#### Rozložení na více menších rotací


Pokud zvolíme nějaké $\alpha$ a $\beta$ tak, že $\theta = \alpha + \beta$, můžeme místo jedné rotace o $\theta$ provést dvě rotace za sebou: prvně o $\alpha$ a pak o $\beta$. To lze vyjádřit i pomocí rotačních matic, postupným násobením:

$ \vec{u} = \mathbf{R}_\theta \cdot \vec{u} = \mathbf{R}_\beta \cdot (\mathbf{R}_\alpha \cdot \vec{u}) $

Tento princip lze libovolně rozšířit pro $N$ malých rotací:

Pokud $\theta = \sum\limits_{i=0}^{N-1} \varphi_i$,
pak $\vec{u} = (\prod\limits_{i=0}^{N-1} \mathbf{R}_{\varphi_i}) \cdot \vec{v}$


Na následujícím obrázku ([zdroj](https://commons.wikimedia.org/wiki/File:CORDIC-illustration.svg)) je vidět skutečný princip CORDICu. Začínáme vektorem $V_0 = [1,0]$, a chceme vektor $V_3$ otočený o $\beta = 56.25^{\circ}$. Tak prvně otočíme o nějaký menší úhel ($45^{\circ}$) a dostaneme $V_1$. Pak dalším otočením ($22.5^{\circ}$) dostaneme $V_2$. Sice jsme cílový úhel přestřelili, ale to nevadí, můžeme se *vrátit* otočením o *záporný* úhel ($-11.25^{\circ}$), získáváme $V_3$. Mělo by být evidentní, že ze složek $V_3$ lze vyčíst $\sin(\beta)$ a $\cos(\beta)$, a tohle je skutečně způsob, kterým se tyto funkce pomocí CORDICu počítají. Jde pouze ilustraci, ve skutečnosti se úhly volí jiným způsobem, nicméně princip je stejný: stačí vhodně zvolit rozložení $\theta$ na $\varphi_0, \ldots, \varphi_{N-1}$ tak, aby šly matice $\mathbf{R}_{\varphi_i}$ jednoduše spočítat.

![](./img/CORDIC-illustration.svg =500x center)

Z celé této sekce je opravdu nejdůležitější princip algoritmu, ne nutně konkrétní matematika.

#### Zjednodušení rotace pouze na tangens

Chceme tedy náš vektor vynásobit několika rotačními maticemi:

$\begin{bmatrix}x \\ y\end{bmatrix} = 
(\prod\limits_{i=0}^{N-1} \mathbf{R}_{\varphi_i}) \cdot \vec{v} =
\underbrace{
  (\prod\limits_{i=0}^{N-1}
    \begin{bmatrix}
      \cos(\varphi_i) & -\sin(\varphi_i) \\
      \sin(\varphi_i) & \cos(\varphi_i)
    \end{bmatrix})
    \cdot \begin{bmatrix}x_0 \\ y_0\end{bmatrix}
}_{\textnormal{postupné násobení maticemi}}
$

Protože budeme chtít úhly $\varphi_i$ volit vůči trigonometrickým funkcím speciálně tak, aby nám vyšlo hezké číslo, kterým se bude dobře násobit, vadí nám, že máme ve výrazu *dvě různé* goniometrické funkce. Tyto dvě funkce totiž pro skoro všechny vstupy mají odlišné, navíc iracionální výstupy, kterými se težko násobí.

Tento problém se dá vyřešit následujícím "trikem": z i-té matice $\mathbf{R}_{\varphi_i}$ vytkneme $\cos(\varphi_i)$:

$
\begin{bmatrix}
  \cos(\varphi_i) & -\sin(\varphi_i) \\
  \sin(\varphi_i) & \cos(\varphi_i)
\end{bmatrix} =
\cos(\varphi_i) \cdot
\begin{bmatrix}
  \frac{\cos(\varphi_i)}{\cos(\varphi_i)} & -\frac{\sin(\varphi_i)}{\cos(\varphi_i)} \\
  \frac{\sin(\varphi_i)}{\cos(\varphi_i)} & \frac{\cos(\varphi_i)}{\cos(\varphi_i)}
\end{bmatrix} =
\cos(\varphi_i) \cdot
\begin{bmatrix}
  1 & -\tan(\varphi_i) \\
  \tan(\varphi_i) & 1
  \end{bmatrix}
$

Teď už máme v maticích, kterými se bude náš vektor násobit, pouze $\tan(\varphi_i)$. Zůstal nám sice $\cos(\varphi_i)$ mimo matici, ale protože násobení matic skalárem ("číslem") je komutativní (samotné násobení matice maticí komutativní není!), můžeme všechny $\cos(\varphi_i)$ vytknout před samotné násobení maticemi, do samostatného součinu skalárů, který si označíme $K_N$. ([zdroj](https://files.gamepub.sk/CSS/od%20Risa/Ine%20materialy/CORDIC/Algoritmus%20CORDIC.pdf),
[zdroj](https://web.cs.ucla.edu/digital_arithmetic/files/ch11.pdf),
[zdroj](https://en.wikipedia.org/wiki/CORDIC))


Dostaneme tedy:

$\begin{bmatrix} x \\ y\end{bmatrix} =
\underbrace{(
  \prod\limits_{i=0}^{N-1} \cos(\varphi_i)
)}_{K_N} \cdot
\underbrace{
  (\prod\limits_{i=0}^{N-1} \begin{bmatrix}
  1 & -\tan(\varphi_i) \\
  \tan(\varphi_i) & 1
  \end{bmatrix}) \cdot
  \begin{bmatrix}x_0 \\ y_0\end{bmatrix}
}_{\textnormal{postupné násobení maticemi}}
$

Levý člen $K_N$ zatím vynecháme - ukáže se, že je konstantní a vůbec nezávisí na $\theta$ ani na samotných $\varphi_i$ - budeme ho aplikovat až úplně na konci algoritmu jako korekci.

Postupné násobení matic si rozložíme na jednotlivé mezikroky $x_0,\ldots,x_N$ a $y_0,\ldots,y_N$ a zapíšeme jako rekurenci (tj. vzorec pro (i+1)-tý člen posloupnosti na základě i-tého):

$\begin{bmatrix} x_{i+1} \\ y_{i+1}\end{bmatrix} =
\begin{bmatrix}
1 & -\tan(\varphi_i) \\
\tan(\varphi_i) & 1
\end{bmatrix} \cdot
\begin{bmatrix}x_i \\ y_i\end{bmatrix}
$

Pozn.: S pomocí této rekurence můžeme konstatovat vztah $N$-tého členu posloupnosti ke správnému výsledku:

$
\begin{bmatrix} x \\ y \end{bmatrix} =
K_N \cdot
\begin{bmatrix} x_N \\ y_N \end{bmatrix}
$

Poté rozepíšeme maticové násobení a dostaneme následující vzorce pro $x_{i+1}$ a $y_{i+1}$:

$x_{i+1} = x_i - \tan(\varphi_i) \cdot y_i \\
 y_{i+1} = y_i + \tan(\varphi_i) \cdot x_i
$

Až na ten $\tan(\varphi_i)$ tohle vypadá už docela implementovatelně. Zbývá nám tedy nějak zařídit, abychom nemuseli v hardwaru implementovat výpočet $\tan(x)$. To uděláme tak, že $\varphi_i$ zvolíme "magicky" tak, abychom úplně bez počítání, na první pohled, věděli, kolik bude $\tan(\varphi_i)$.

#### Volba vhodných úhlu pro tangens

A jak tedy zvolit $\varphi_i$ tak, abychom hned věděli kolik je $\tan(\varphi_i)$? Jednoduše, pomocí k $\tan$ opačné funkce $\arctan$:

Zvolme $\varphi_i = \arctan(2^{-i})$, pak platí

$\tan(\varphi_i) = \tan(\arctan(2^{-i})) = 2^{-i}$.

Tedy pokud takto "kouzelně" zvolíme $\varphi_i$, pak $\tan(\varphi_i) = 2^{-i}$. Např. $\tan(\varphi_4) = 2^{-4} = 1/16$. Není potřeba žádný tangens počítat. Sice jsme problém tangensu jenom přesunuli jinam, protože pokud by nás zajímala skutečná hodnota $\varphi_i$, museli bychom umět spočítat $\arctan(x)$ - ale najednou ne pro libovolný vstup, ale pouze pro konkrétní $x=2^{-i}$, kde $i$ jde od $0$ do $N-1$. To se dá udělat například předpočítáním $N$-řádkové tabulky, kterou budeme mít v nějaké paměti. My dokonce pro výpočet $\sqrt{x^2+y^2}$ skutečnou hodnotu $\varphi_i$ znát vůbec nepotřebujeme, takže tu tabulku nepotřebovat nebudeme. Budeme totiž používat CORDIC ve *vektorovém* režimu popsaném níže, kde nás úhel $\theta$ a tímpádem ani konkrétní hodnoty $\varphi_i$ nezajímají.

V tomto místě je vhodné do výpočtu vnést i zmiňovaný "směr" rotace. Pokud je $\varphi_i$ kladné, otáčíme proti směru hodinových ručiček. Pokud je záporné, použijeme identitu $\tan(-\alpha) = -\tan(\alpha)$. Budeme tedy uvažovat, že samotný úhel $\varphi_i$ je vždy kladný (je to pouze "velikost"), a směr budeme ovládat koeficientem $d_i \in \{-1,1\}$, kde $1$ je proti směru hodinových ručiček (dopředu) a $-1$ opačně (zpátky). Tedy pokud je směr $-1$, tak jenom prohodíme znaménka před $\tan(\varphi_i)$ v tom vzorci, nic dalšího není potřeba měnit.

#### Skutečný krok CORDICu a jeho implementace

Po dosazení $\varphi_i = \arctan(2^{-i})$ do zmíněné rekurence

$x_{i+1} = x_i - \tan(\varphi_i) \cdot y_i \\
 y_{i+1} = y_i + \tan(\varphi_i) \cdot x_i
$


a zjednodušení $\tan(\arctan(2^{-i})) = 2^{-i}$ a přidání směru $d_i$ tedy získáme **skutečný jeden krok algoritmu CORDIC**:

$ x_{i+1} = x_i - d_i \cdot 2^{-i} \cdot y_i \\
  y_{i+1} = y_i + d_i \cdot 2^{-i} \cdot x_i
$

Povšimněte si, jak dobře se tyto matematické operace budou implementovat v hardwaru. Kvůli tomu jsme všechny ty úpravy a triky dělali.

Zaprvé, násobení číslem $2^{-i}$ je to samé jako dělení číslem $2^i$. Podobně jako dělení číslem $10^i$ v desítkové soustavě je tato operace triviální - jednoduše posun o $i$ číslic, ve dvojkové soustavě o $i$ bitů (tzn. barrel shifter). Tohle je mimochodem důvod, proč jsme zvolili $\varphi_i = \arctan(2^{-i})$, a ne něco jiného - fungovaly by i jiné hodnoty, ale hůř by se jimi násobilo.

Za druhé, protože $d_i$ je pouze $1$ nebo $-1$ a hodnotu pak ihned přičítáme/odčítáme od něčeho jiného, není potřeba nic násobit, ani nic invertovat - stačí oba dva součty/rozdíly implementovat pomocí sčítaček-odčítaček - a pouze správně (podle $d_i$) rozhodnout o tom, zda se má sčítat nebo odčítat. Jenom to pro $x_i$ bude fungovat opačně než pro $y_i$.

#### Určení směru rotace v každém kroku rotačního CORDICu

Jediné, co zbývá, je nějak určit ty $d_i$ tak, aby byl výsledek správně, tj., pokud se snažíme otočit o konkrétní úhel $\theta$ (to je co dělá *rotační* CORDIC), musíme ho nějak poskládat jako součet:

$ \theta = \sum\limits_{i=0}^{N-1} d_i \cdot \arctan(2^{-i}) \qquad$ (fuj)

V praxi se to dělá tak, že během výpočtu, v $i$-té iteraci, koukáme, jestli je zbývající $\theta$ větší nebo menší než $\varphi_i = \arctan(2^{-i})$ (ty taháme z tabulky v paměti), podle toho určíme $d_i$, a pak $\varphi_i$ od $\theta$ odečteme, a se zbytkem pokračujeme dál do příští iterace. Tedy pro výpočet $\sin$ a $\cos$ pomocí CORDICu je potřeba tabulka $\varphi_i$, a právě kvůli tomu jsem vám záměrně zadal místo $\sin$ nebo $\cos$ právě výpočet normy, kde taková tabulka potřeba není.

#### Škálování výsledku

Pokud se rozhodneme pro $N$ iterací algoritmu, začneme s hodnotami $[x_0, y_0]$ (ze vstupu), a budeme iterovat, dokud nezískáme $[x_N, y_N]$. Hodnota $[x_N, y_N]$ v určitém smyslu reprezentuje náš výsledek, ale zatím není úplný. Musíme do výsledku ještě zahrnout konstantní člen kosinů:

$x = \underbrace{(\prod\limits_{i=0}^{N-1} \cos(\varphi_i))}_{K_N} \cdot x_N$

Tento člen $K_N$ koriguje skutečnost, že během "zjednodušeného" CORDIC algoritmu, kde jsme cosiny vynechali, se nám výsledek postupně více a více "natahuje" o faktor $1/K_N$. Ovšem my umíme $K_N$ spočítat, a vynásobíme jím náš výsledek abychom ho zase "zkrátili" na správnou velikost:

$ K_N = \prod\limits_{i=0}^{N-1} \cos(\varphi_i) = 1/(\prod\limits_{i=0}^{N-1} \sqrt{1+2^{-2i}}) $

Pro konkrétní $N$ iterací je vhodné použít přesně $K_N$, protože to přesně odpovídá natažení, které způsobilo těch $N$ iterací. Ovšem pro $N > 10$ je mezi jednotlivými $K_N$ už velmi malý rozdíl, proto často stačí jednoduše použít limitu $K_\infty$:

$ K_\infty = \lim\limits_{N \to \infty} K_N
\approx 0.6072529350088812561694
$

Jakmile máme vhodné $K_N$, které je konstantní pro CORDIC s konstantním počtem iterací, stačí naše vypočítané $x_N$ přeškálovat pomocí $K_N$, čímž konečně získáme výsledek.

$ x = K_N \cdot x_N $

Zde je potřeba násobit - ovšem násobení konstantou lze implementovat efektivněji než obecné násobení, a násobit je potřeba pouze jednou, na konci algoritmu - násobení v tomto případě není bottleneck.


### Vektorový CORDIC

U *rotačního* CORDICu se algoritmus snažil vektor otočit o konkrétní úhel. CORDIC lze ale použít i jinak, ve *vektorovém* režimu. Ten se snaží vstupní vektor natočit *určitým směrem*, a výstup je kromě otočeného vektoru i úhel, o který bylo potřeba vektor otočit (pokud nás zajímá). Standardně se provádí otáčení do směru vektoru $\vec{e_x} = [1,0]$ (tj. na osu X), protože se jednoduše implementuje.

Vektorový CORDIC dostane na vstupu vektor s nenulovým $y$, a snaží se ho postupně "sklopit" do vodorovné polohy na ose X tím, že se snaží dostat $y$ vektoru na nulu. To je jednodušší než rotační CORDIC - vektor otáčíme v $i$-tém kroku o úhel $\varphi_i$, ale vždy jednoduše směrem k ose X: Pokud je $y > 0$, tak po směru hodinových ručiček ("dolů", $d_i = -1$), a pokud $y < 0$, tak proti směru ("nahoru", $d_i = 1$), viz následující obrázek ([zdroj](https://www.instructables.com/Cordic-Algorithm-Using-VHDL/)):

![](./img/cordic-vectored.png =500x center)

#### Výpočet normy pomocí vektorového CORDICu

Pokud vektor $\vec{v} = [x_0, y_0]$ otočíme tak, aby byl vodorovně s osou X ($y = 0$), dostaneme právě vektor $\vec{u} = [\sqrt{x_0^2+y_0^2}, 0]$, což vychází z podobnosti trojúhelníků, viz obrázek:

![](./img/cordic-norm.svg =500x center)

Stačí tedy na zadaný vstupní vektor pustit vektorový CORDIC, a v souřadnici $x$ výsledného vektoru nalezneme "skoro" normu. Tu jenom přenásobíme $K_N$, což nám dá skutečnou normu vstupního vektoru:

$\vec{v} = [x_0, y_0]$

$[x_N, y_N] = \textnormal{VectorCORDIC}_N(\vec{v})$

Nyní platí $y_N \approx 0$

$\lVert \vec{v} \rVert = \sqrt{x_0^2+y_0^2} = K_N \cdot x_N$

#### Příklad výpočtu normy

Mějme $\vec{v} = [4,3]$, stejně jako na obrázku výše. Norma je $\lVert \vec{v} \rVert = \sqrt{x_0^2+y_0^2} = \sqrt{4^2+3^2} = \sqrt{25} = 5$. Pojďme se podívat, jestli CORDIC dospěje ke stejnému závěru:

| i  | $x_i$   | $y_i$     | $d_i$ | $2^{-i}$ | $K_i$     | $K_i \cdot x_i$ |
| -- | ------- | --------- | ----- | -------- | ------- | -------------- |
| 0  | 4.00000 | +3.00000  | \-1   | 1.00000  | 1.00000 | 4.00000        |
| 1  | 7.00000 | \-1.00000 | 1     | 0.50000  | 0.70711 | 4.94975        |
| 2  | 7.50000 | +2.50000  | \-1   | 0.25000  | 0.63246 | 4.74342        |
| 3  | 8.12500 | +0.62500  | \-1   | 0.12500  | 0.61357 | 4.98527        |
| 4  | 8.20313 | \-0.39062 | 1     | 0.06250  | 0.60883 | 4.99434        |
| 5  | 8.22754 | +0.12207  | \-1   | 0.03125  | 0.60865 | 4.99945        |
| 6  | 8.23135 | \-0.13504 | 1     | 0.01563  | 0.60735 | 4.99933        |
| 7  | 8.23346 | \-0.06425 | 1     | 0.00781  | 0.60728 | 5.00001        |
| 8  | 8.23351 | +0.05790  | \-1   | 0.00391  | 0.60726 | 4.99988        |
| 9  | 8.23374 | +0.02574  | \-1   | 0.00195  | 0.60725 | 4.99998        |
| 10 | 8.23379 | +0.00965  | \-1   | 0.00098  | 0.60725 | 5.00000        |
| 11 | 8.23380 | \-0.00241 | 1     | 0.00049  | 0.60725 | 5.00000        |

Všimněte si, jak rychle se CORDIC přiblížil ke správnému výsledku (tedy po přenásobení $K_i$). Obecně platí, že každá iterace CORDICU zvětší přesnost výsledku o 1 bit (pokud máme dost přesnou sčítačku atd.). Standardně tedy pokud CORDIC interně pracuje s 32-bitovými čísly, bude se používat cca. $N=32$ iterací, po nich už bude celý 32bit výsledek velmi přesný.

## Desetinné čísla ve dvojkové soustavě

Protože CORDIC potřebuje pracovat s desetinnými čísly, musíme je nějak reprezentovat pomocí bitů. V praxi, např. při programování, jste se nejspíš setkali s *čísly s plovoucí řádovou čárkou* (*floating-point numbers*), nejspíš ve formě datových typů `float` a `double`. Ty jsou super, protože umí reprezentovat zároveň obrovská čísla a také velmi přesně čísla velmi blízko k nule, ovšem pro naše využití jsou zbytečně komplikované. Nám budou stačit čísla s tzv. *pevnou řádovou čárkou* (*fixed-point numbers*). Sice mají nějaké nedostatky, obzvlášť omezenou přesnost, ale zase je práce s nimi drasticky jednodušší.

### Fixed-point numbers

Jak napovídá název, ve fixed-point desetinném čísle je na nějakém místě zafixovaná desetinná čárka, viz obrázek ([zdroj](https://www.geeksforgeeks.org/computer-organization-architecture/fixed-point-representation/)).

![](./img/geeksforgeeksbinarypointrepresentation.png =500x center)

Tato desetinná čárka se *neukládá*, je vlastností zvoleného číselného formátu. V obrázku tedy například pracujeme s čísly `Q5.3`: máme 5 bitů před čárkou a 3 bity za čárkou, dohromady 8 bitů. "Na drátě" existuje pouze těch 8 bitů, bez jakékoliv informace o tom, co znamenají, tj. jak se mají správně interpretovat. To je popsané někde v dokumentaci a ovlivňuje to, jak budeme s číslem pracovat.

Hodnotu čísla $00010.110_2$ můžeme chápat jako $00010_2 + 110_2 \cdot 2^{-3}$. V této reprezentaci se už vyskytují pouze celé binární čísla, a po převedení do desítkové soustavy dostaneme $2 + 6/8 = 2.75$.

Existuje i jiný způsob přemýšlení o fixed-point číslech. Jak jistě víte, násobením $2^n$ můžeme posouvat desetinnou čárku doleva nebo doprava (násobíme nebo dělíme řádem, funguje to úplně stejně v desítkové soustavě pro $10^n$). Tedy místo $00010.110_2$ můžeme psát $00010110_2 \cdot 2^{-3}$. Pracujeme tedy s číslem $00010110_2$ (to jsou surové bity tohoto fixed-point čísla na drátě), ale bokem si "pamatujeme", že toto číslo je $2^3$-krát větší než opravdová hodnota. Tohle je, jak budeme k fixed-point číslům přistupovat my, protože nás to nechá se k nim chovat prostě jako k celým číslům, až do momentu, kdy je potřebujeme ukázat uživateli (v ten moment musíme umístit na správné místo desetinnou čárku).

### Operace s fixed-point čísly

Pokud chci sečíst dvě fixed-point čísla *stejného typu*, stačí je reprezentovat výše zmíněným způsobem a vytknout těch $2^{-n}$:

$a \cdot 2^{-n} + b \cdot 2^{-n} = (a + b) \cdot 2^{-n}$

Z toho plyne, že můžeme prostě sčítat bitové reprezentace *stejných* fixed-point čísel a dostaneme správné fixed-point číslo *stejného typu*.

U násobení budeme muset provést drobnou úpravu, protože budeme mít ve výrazu přebytečné $2^{-n}$:

$(a \cdot 2^{-n}) \cdot (b \cdot 2^{-n}) = (a \cdot b \cdot 2^{-n}) \cdot 2^{-n}$

Tedy po klasickém celočíselném vynásobení $a \cdot b$ musíme jedno násobení $2^{-n}$ *aplikovat*: posuneme výslednou hodnotu o $n$ bitů doprava (protože exponent je záporný). Tím dostaneme $a \cdot b \cdot 2^{-n}$, což je správná reprezentace výsledku ve fixed-point číslech.

Zmiňované operace lze navrhnout i pro čísla různých typů, ale my budeme v celém obvodu pracovat pouze s čísly jednoho jediného fixed-point typu, `Q12.16` (12 bitů před a 16 bitů za desetinnou čárkou = 28 bitů). Pro případ `Q12.16` je $n=16$ a tedy pracujeme s čísly v podobě $a \cdot 2^{-16}$.

### Záporná fixed-point čísla

Určitě jste zaznamenali, že CORDIC potřebuje pracovat i se zápornými čísly, musíme tedy naše fixed-point obohatit o znaménko, abychom měli čísla se znaménkem. To se dělá velmi jednoduše, stačí říct, že v našem desetinném čísle $a \cdot 2^{-n}$ je $a$ reprezentováno ve *dvojkovém doplňku*. Dostáváme tedy něco, čemu můžeme říkat *two's-complement signed fixed-point*.

Pokud už si nepamatujete, jak funguje dvojkový doplňek, doporučuji si znovu projít [příslušnou kapitolu skript](https://skripta.vojacek.org/30_alu/03_odcitani.html#dvojkov%C3%BD-dopln%C4%9Bk-twos-complement). Nejdůležitější potřebné skutečnosti pro práci s ním shrnu tady:

- $-A = \overline{A} + 1$. To stačí udělat na celou reprezentaci fixed-point čísla bez ohledu na jeho typ, protože platí, že $-(a \cdot 2^{-n}) = (-a) \cdot 2^{-n}$. Z toho vyplývá i, že odčítání fixed-point čísel funguje identicky jako odčítání celých čísel ([skripta](https://skripta.vojacek.org/30_alu/03_odcitani.html)).
- Nejvyšší bit čísla je znaménko. Platí pro libovolné fixed-point číslo, nehledě na typ.
- Násobení $2^n$ odpovídá shiftu *doleva*. Pokud vypadnou shiftem zleva nějaké nenulové bity, dochází k přetečení a výsledek nelze reprezentovat. Zprava hodnotu doplňujeme nulami.
- !!! Násobení $2^{-n}$ (tedy dělení $2^n$) odpovídá **aritmetickému** shiftu *doprava*. Ten se chová odlišně od *logického* (kde se doplňuje nulami). Při aritmetickém shiftu musí zůstat znaménko čísla zachované, tzn. bity zleva se doplňují **hodnotou znaménka** (a NE nulami!). Tedy pro kladná čísla se doplňuje nulami (sign bit je nula) a pro záporná čísla se doplňuje jedničkami (sign bit je 1). Více detailů a diagram je na [wikipedii](https://en.wikipedia.org/wiki/Arithmetic_shift). Bity, které vypadávají zprava, pokud jsou jedničkové, znamenají *ztrátu přesnosti* (zaokrouhlení výsledku), ale to neznamená, že výsledek je nesprávný, jenom je nepřesný. V Logisimu můžete použít *Shifter*, pokud ho **správně nastavíte**.
- Čísla ve dvojkovém doplňku **nelze přímo násobit!!!** [Jak se to implementuje](https://faculty-web.msoe.edu/johnsontimoj/Common/FILES/binary_multiplication.pdf), aby to fungovalo, neprobíráme. V Logisimu můžete použít *Multiplier* v režimu *2's Complement*.

### V Logisimu

V Logisimu žádná konkrétní podpora pro fixed-point čísla není, budete muset správně manipulovat jejich bitovou reprezentaci (není to těžké). Ale, Logisim umí zobrazovat floating-point čísla. V projektovém souboru máte připravené moduly `Q12_16_tofloat` a `Q12_16_fromfloat`, které konvertují mezi reprezentací `Q12.16` a 32-bit floating-point čísly. Pomocí nich, a inputů/outputů/probes s nastaveným radixem "Float" můžete při testování zadávat hodnotu jako (nepřesné) desetinné číslo, a také si ho jako desetinné číslo nechat zobrazit. To hodně pomahá, pokud se snažíte odladit, při kterém kroku váš modul udělal výpočetní chybu. Konverze z/do floatů jsou pouze přibližné, měli byste obvod otestovat i přímo poskytnutými testovacími vektory v `Q12.16` formátu a ujistit se, že dostáváte úplně přesný výsledek.

## Specifikace modulu

```kroki-symbolator
module NORM #(
) (
    input [27:0] X_IN,
    input [27:0] Y_IN,
    input START,
    input CLK,
    output [27:0] OUTP,
    output DONE,
    output [27:0] DEBUG_X,
    output [27:0] DEBUG_Y
);
endmodule
```

## Struktura a chování

- Plně sekvenční modul, synchronizovaný na nábežné hraně
- Vstupy `X_IN` a `Y_IN` výstup `OUTP`
  - V signed two's-complement fixed-point formátu `Q12.16` (28 bitů)
  - Výstup bude vzhledem k povaze výpočtu vždy kladný, ale stejně bude v signed formátu
- Vstupy `START`, `CLK` a výstup `DONE` tvoří start-done interface modulu
- Na výstupy `DEBUG_X` a `DEBUG_Y` přiveďte aktuální stav vašich registrů pro $X$ a $Y$, ve kterých provádíte mezivýpočty, aby bylo zvenku vidět, co modul dělá. Hodnota těchto výstupů se nekontroluje, slouží pouze pro ladění.
- Modul spočítá $\texttt{OUTP} = \sqrt{\texttt{X}_\texttt{IN}^2 + \texttt{Y}_\texttt{IN}^2}$ pomocí CORDIC algoritmu
- Po jednom úvodním načítacím cyklu (start=1) modul provede přesně 28 iterací CORDIC algoritmu
  - Výsledek 28. iterace CORDICu $x_{28}$ je potřeba přenásobit konstantou $K_{28}$ (stačí kombinačně na výstupu z modulu)
  - Použijte hodnotu $K_{28} = 0.6072529350...$ zaokrouhlenou do formátu `Q12.16`:  
    $K_{28} \approx \texttt{0.1001101101110101}_2 = \texttt{00.9B75}_{16}$
  - Tato hodnota je ve skutečnosti přesně $0.6072540283_{10}$, ale to je ke $K_{28}$ dostatečně blízko
- Modul se bude jmenovat `NORM`
- Používejte logisimové matematické operátory
  - Pro implementaci stačí dvě sčítačky/odčítačky (můžete pro jednoduchost použít i separátní sčítačku+odčítačku+multiplexor), dva shiftery a jedna násobička. Pokud toho potřebujete víc, zkuste se vrátit k zadání.

### Časování

Modul je plně synchronní, reaguje na vstup a mění svůj výstup tedy pouze s náběžnou hranou vstupu `clk`. Modul používá standardní start-done interface, jak jsme ho probírali. Po skončení výpočtu (`done=1`) výsledek **musí** zůstat konstantní až do příštího `start=1`. Detailní popis níže.

#### Standardní start-done interface

Pokud je na vstupu `start=1`, načte modul vstupy a připraví se na výpočet (toto může nastat i během již probíhajícího předchozího výpočtu, v takovém případě se tento výpočet ruší a připraví se nový podle vstupů). "Příprava na výpočet" může znamenat různé věci: pouhé uložení vstupních hodnot do registrů, nebo přímo provedení prvního kroku výpočtu podle vstupů a uložení částečného výsledku do registrů. V každém případě by se ale měla inicializovat řídící část obvodu - pokud obvod provádí výpočet v nějakých "krocích", nebo má v registrech jiné poznámky o výpočtu, je potřeba tyto inicializovat na hodnoty, které umožní začít výpočet od začátku.

Jakmile `start=0`, provede modul s každým clockem jeden krok výpočtu. Během tohoto musí být výstup `done=0`. Modul může počítat s tím, že po celou dobu jednoho výpočtu zůstanou vstupy A a B konstatní. Jakmile modul dokončil výpočet a na výstupu `OUTP` prezentuje správný výsledek, musí přestat počítat (výsledek musí zůstat konstantní, dokud nepřijde další `start=1` signál). Zároveň toto musí indikovat pomocí `done=1`.

```admonish warning
Pamatujte, že synchronní obvod reaguje na hodnoty na vstupu **až při _příští_ náběžné hraně**, ne té, která změnu hodnoty způsobila!
```

## Postup řešení

U celého vašeho řešení se bude hodnotit čitelnost a srozumitelnost - vše co odevzdáváte kromě řešení slouží jako dokumentace k projektu. Pokud vám dokumentace přijde nepřehledná, je nutné ji přepsat, přepracovat, nebo překleslit, aby byla. Toto platí obzvlášť pro diagram - např. škrtání a matoucí věci v diagramu budou penalizovány.

Pokud budete pracovat na papír, použijte kontrastní propisku, ne slabou tužku, a výsledek buď naskenujte, nebo s dobrým osvětlením, kolmo a ve vysokém rozlišení vyfoťte (vyhněte se tvrdým stínům ve fotce), a upravte, aby vypadal jako naskenovaný, zejména proveďte korekci zkosení (pro tento účel lze použít např. aplikaci Microsoft Lens, dříve Office Lens, na telefony). Odevzdání v nízké kvalitě (jak rozlišení tak vizuálně) bude vráceno k přepracování.

### 1. Zadání

Přečtěte si zadání, ujistěte se, že rozumíte CORDICu, postupu výpočtu, desetinným číslům a záporným číslům. Pochopení těchto konceptů může být zkoušeno v rámci hodnocení domácího úkolu.

### 2. Teoretická příprava

Buď na papír nebo digitálně (bude součástí odevzdání) si připravte (jako v předchozích úlohách)

1. Stručný popis algoritmu, ať máte ujasněné, co implementujete. Tento popis je oproti uvedené teorii velmi jednoduchý, to je záměrně (úloha je navžená tak, aby byla implementace jednoduchá).
2. Seznam registrů (stavu), jejich velikosti, stručný popis jejich funkce, pokud to není evidentní.
3. Popis zápisů do registrů za určitých podmínek (při `start=1`, při `done=0`, etc.). Použijte syntaxi z předchozích úloh a obecně zažité výrazy/konstrukce z číslicového návrhu nebo programování. Cokoliv nejasného popište.
4. Detailní simulaci příkladu nemusíte provádět, ani to moc bez programování nejde, stačí aby vám bylo jasno, jak zjistit že proběhlo přesně 16 iterací CORDICu. Pokud necháte proběhnout 15 nebo 17 iterací, nedostanete správný výsledek.
5. Pro každý stavový registr rozepište, jaké různé hodnoty je potřeba do něj umět uložit.
6. Uveďte, jak z aktuálního stavu vypočítáváte všechny kontrolní i datové signály, např. `DONE`, `OUTP`, všechny write-enably, a cokoliv jiného pojmenovaného, co používáte v popisu chování.

### 3. Blokový diagram

Buď na papír nebo digitálně (buď tabletem s tužkou nebo např. pomocí draw.io) nakreslete blokový diagram zapojení obvodu. Diagram musí odpovídat běžným elektronickým diagramům.

Zejména upozorňuji na:

1. Datovou cestu se snažte zapojit přímým napojováním drátů, bez tunelů
2. Pro kontrolní signály používejte tunely (pojmenované odkazy na jiné vodiče)
3. U vícebitových drátů/registrů označte zavedeným způsobem šířku (počet bitů)
4. V blokovém diagramu mohou být operace a bloky víc "high level" - jde o chování, ne o konkrétní způsob implementace (např. násobění dvěma v diagramu by se pak implementovalo shifterem)
5. Diagram musí být přehledný (bez škrtání atd.) a smysluplně rozvržený - má sloužit jako dokumentace. Pokud je nepřehledný, musíte ho překreslit. Dokonce se dá počítat s tím, že vaše první iterace nebude dostatečně přehledná, a budete odevzdávat až druhou/třetí verzi.
6. Označte všechny clock vstupy zavedeným symbolem. Dále není v diagramu potřeba clocky spojovat, clocky se předpokládají vždy spojené.

### 4. Zapojení v Logisimu

Stáhněte si [:link: template pro tento úkol](./res/norm_template.circ) a do předpřipraveného modulu `NORM` podle vašeho blokového diagramu postavte řešení. Dbejte na následující:

- Upravujte pouze modul `NORM`, modifikace ostatních modulů budou při odevzdání zahozeny!
- V datové cestě modulu použijte:
  - 2x připravený modul ADDSUB
  - 1x Logisimovou celočíselnou 28-bitovou násobičku
  - Libovolný počet Logisimových shifterů (libovolné nastavení)
  - Libovolný počet Logisimových sčítaček jako **inkrementorů**
  - Libovolný počet Logisimových komparátorů pro rozhodování
  - Žádná další aritmetika není pro datovou cestu potřeba!
- Snažte se, aby struktura vaší Logisimové implementace (hlavně datové cesty) odpovídala vašemu blokovému diagramu (stavte to podle něj!)
- Není potřeba vytvářet žádné další moduly, všechno stačí zapojit do `NORM`
- Pro debuggování můžete používat připravenou sadu `Q12_16_*` modulů spolu s Logisimovou `Probe` nastavenou na Radix `Float` - nechá vás to sledovat skutečnou (ale nepřesnou, kvůli konverzi na float) hodnotu fixed-point drátů živě, aniž byste museli ručně konvertovat. Příklad použití je v modulu `main`.
- Testujte svůj modul proti testovacím vektorům v modulu `main`.
- Před odevzdáním na svůj modul pusťte testovací baterii připravenou v modulu `NORM_TEST_BATTERY`, případně můžete zkusit jeden test ručně pomocí modulu `NORM_GOLDEN_TEST`. Červeně jsou vyznačeny parametry testu, které můžete měnit.

Ujistěte se, že jste nezměnili externí interface modulu `NORM`. Měl by vypadat následovně:

![](./img/NORM-module.png =500x center)

```admonish info
Na výstupu `DEBUG_X` a `DEBUG_Y` přiveďte přímo hodnoty vašich registrů X a Y, ve kterých provádíte iterativní výpočet. Je to pro účely debuggování pro vás i pro mě. Hodnoty těchto výstupů se _netestují_. Testuje se pouze hodnota výstupu `OUTP`, jakmile `done=1`. Také se testuje, jestli váš modul dokončil výpočet (indikoval `done=1`) během nejvýše 40 cyklů, jinak je příklad hodnocen jako TIMEOUT.
```

### 5. Testování

Váš modul otestujte v `main` pomocí (některých z) následujících testovacích vektorů. Nemusíte mít výsledek úplně přesně jako je zde uvedeno, ale neměl by se lišit o více než 0.01%. V `OUTPUT_ACTUAL` jsem uvedl výsledek z mojí implementace. Pozn.: tyto testovací hodnoty odpovídají těm v modulu `NORM_TEST_BATTERY`.

```admonish example title="Testovací vektory",collapsible=true
| Nr | X | Y | OUTP_EXPECTED | OUTP_ACTUAL |
|--|--|--|--|--|
| `00` | `0030000` | `0030000` | `0050000` | `0050008` |
| `01` | `0010000` | `0010000` | `0016A0A` | `0016A0A` |
| `02` | `00A0000` | `00A0000` | `00A0000` | `00A0009` |
| `03` | `0000000` | `0000000` | `00A0000` | `00A0008` |
| `04` | `001BB67` | `001BB67` | `002FFFF` | `0030008` |
| `05` | `0050000` | `0050000` | `00D0000` | `00D0008` |
| `06` | `0080000` | `0080000` | `0110000` | `0110009` |
| `07` | `0070000` | `0070000` | `0190000` | `019000A` |
| `08` | `0140000` | `0140000` | `01D0000` | `01D000B` |
| `09` | `00C0000` | `00C0000` | `0250000` | `0250006` |
| `10` | `0090000` | `0090000` | `0290000` | `0290008` |
| `11` | `01C0000` | `01C0000` | `0350000` | `035000D` |
| `12` | `00B0000` | `00B0000` | `03D0000` | `03D000B` |
| `13` | `0100000` | `0100000` | `0410000` | `041000C` |
| `14` | `0210000` | `0210000` | `0410000` | `041000A` |
| `15` | `0300000` | `0300000` | `0490000` | `049000F` |
| `16` | `00D0000` | `00D0000` | `0550000` | `055000D` |
| `17` | `0240000` | `0240000` | `0550000` | `0550010` |
| `18` | `0270000` | `0270000` | `0590000` | `059000F` |
| `19` | `0410000` | `0410000` | `0610000` | `061000C` |
| `20` | `0140000` | `0140000` | `0650000` | `065000F` |
| `21` | `03C0000` | `03C0000` | `06D0000` | `06D0011` |
| `22` | `00F0000` | `00F0000` | `0710000` | `0710011` |
| `23` | `02C0000` | `02C0000` | `07D0000` | `07D0014` |
| `24` | `0580000` | `0580000` | `0890000` | `0890015` |
| `25` | `0110000` | `0110000` | `0910000` | `0910013` |
| `26` | `0180000` | `0180000` | `0910000` | `0910018` |
| `27` | `0330000` | `0330000` | `0950000` | `0950011` |
| `28` | `0550000` | `0550000` | `09D0000` | `09D0015` |
| `29` | `0770000` | `0770000` | `0A90000` | `0A90017` |
| `30` | `0340000` | `0340000` | `0AD0000` | `0AD0017` |
| `31` | `0130000` | `0130000` | `0B50000` | `0B50018` |
| `32` | `0390000` | `0390000` | `0B90000` | `0B9001B` |
| `33` | `0680000` | `0680000` | `0B90000` | `0B9001A` |
| `34` | `05F0000` | `05F0000` | `0C10000` | `0C10018` |
| `35` | `01C0000` | `01C0000` | `0C50000` | `0C50019` |
| `36` | `0540000` | `0540000` | `0CD0000` | `0CD001C` |
| `37` | `0850000` | `0850000` | `0CD0000` | `0CD001B` |
| `38` | `0150000` | `0150000` | `0DD0000` | `0DD001F` |
| `39` | `08C0000` | `08C0000` | `0DD0000` | `0DD001C` |
| `40` | `03C0000` | `03C0000` | `0E50000` | `0E50020` |
| `41` | `0690000` | `0690000` | `0E90000` | `0E90021` |
| `42` | `0780000` | `0780000` | `0F10000` | `0F1001D` |
| `43` | `0200000` | `0200000` | `1010000` | `1010021` |
| `44` | `0170000` | `0170000` | `1090000` | `1090023` |
| `45` | `0600000` | `0600000` | `1090000` | `1090023` |
| `46` | `0450000` | `0450000` | `10D0000` | `10D0021` |
| `47` | `0730000` | `0730000` | `1150000` | `1150024` |
| `48` | `0A00000` | `0A00000` | `1190000` | `1190024` |
| `49` | `0A10000` | `0A10000` | `1210000` | `1210026` |
| `50` | `0440000` | `0440000` | `1250000` | `1250026` |
```


Zde uvádím tabulku kompletního průběhu příkladu X=3 Y=4 na mé implementaci. Opět připomínám, že stačí, aby vaše hodnoty byly blízko k těm mým, s dostatečnou přesností.

```admonish example title="Průběh X=3 Y=4 na mé implementaci",collapsible=true
| cycle | start | X | Y | done | OUTP |
|--|--|--|--|--|--|
| `00` | `1` | `0000000` | `0000000` | `0` | `0000000` |
| `01` | `0` | `0030000` | `0040000` | `0` | `001D25F` |
| `02` | `0` | `0070000` | `0010000` | `0` | `0044033` |
| `03` | `0` | `0078000` | `FFD8000` | `0` | `0048DED` |
| `04` | `0` | `0082000` | `FFF6000` | `0` | `004EF16` |
| `05` | `0` | `0083400` | `0006400` | `0` | `004FB3B` |
| `06` | `0` | `0083A40` | `FFFE0C0` | `0` | `004FF07` |
| `07` | `0` | `0083B3A` | `0002292` | `0` | `004FF9F` |
| `08` | `0` | `0083BC4` | `00001A6` | `0` | `004FFF2` |
| `09` | `0` | `0083BC7` | `FFFF12F` | `0` | `004FFF4` |
| `10` | `0` | `0083BD6` | `FFFF96A` | `0` | `004FFFD` |
| `11` | `0` | `0083BDA` | `FFFFD87` | `0` | `0050000` |
| `12` | `0` | `0083BDB` | `FFFFF95` | `0` | `0050000` |
| `13` | `0` | `0083BDC` | `000009C` | `0` | `0050001` |
| `14` | `0` | `0083BDC` | `0000019` | `0` | `0050001` |
| `15` | `0` | `0083BDC` | `FFFFFD8` | `0` | `0050001` |
| `16` | `0` | `0083BDD` | `FFFFFF8` | `0` | `0050002` |
| `17` | `0` | `0083BDE` | `0000008` | `0` | `0050002` |
| `18` | `0` | `0083BDE` | `0000000` | `0` | `0050002` |
| `19` | `0` | `0083BDE` | `FFFFFFC` | `0` | `0050002` |
| `20` | `0` | `0083BDF` | `FFFFFFE` | `0` | `0050003` |
| `21` | `0` | `0083BE0` | `FFFFFFF` | `0` | `0050003` |
| `22` | `0` | `0083BE1` | `FFFFFFF` | `0` | `0050004` |
| `23` | `0` | `0083BE2` | `FFFFFFF` | `0` | `0050005` |
| `24` | `0` | `0083BE3` | `FFFFFFF` | `0` | `0050005` |
| `25` | `0` | `0083BE4` | `FFFFFFF` | `0` | `0050006` |
| `26` | `0` | `0083BE5` | `FFFFFFF` | `0` | `0050007` |
| `27` | `0` | `0083BE6` | `FFFFFFF` | `0` | `0050007` |
| `28` | `0` | `0083BE7` | `FFFFFFF` | `0` | `0050008` |
| `29` | `0` | `0083BE8` | `FFFFFFF` | `1` | `0050008` |
```

Test včetně kontroly přesnosti lze provést v modulu `NORM_GOLDEN_TEST`. Přesnost tam je zadaná jako 0x64 miliontin, což je 0.01%.

Finálně na svůj modul pusťte baterii testů v `NORM_TEST_BATTERY` a ověřte počet PASS/FAIL/TIMEOUT. Pokud budete mít nějaké selhání, můžete si nastavit konstantu tak, aby se tester zastavil. Proklikáním do modulů se pak můžete podívat na vaše hodnoty vs. očekávané, spočítanou chybu v přesnosti, a získat vstupy X a Y pro další debuggování selhávajícího příkladu. Pozn.: Odevzdávač testuje právě tuto baterii testů.

### 6. Odevzdávání

Nejspíše na Submitty, Logisim se bude kontrolovat automaticky, zbytek (přípravu na papír) budu hodnotit ručně. TBA.

## FAQ

V případě, že máte nějakou otázku, se určitě neváhejte co nejdříve ptát. Pokud bude odpověď užitečná pro všechny, přidám ji zde do FAQ.

- TBA
