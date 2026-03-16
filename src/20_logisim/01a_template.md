## Template

Každá komponenta v Logisimu má nějaké výchozí nastavení. Aby se nám s obvody dobře pracovalo, připravil jsem _template_ (prázdný Logisimový projekt, který pouze přednastavené komponenty).

### Stažení template

```admonish important title="Verze Logisimu"
Tato template byla přípravena ve verzi Logisimu 4.1.0 a ve starších verzích nebude fungovat!
```

[template.circ](../logisim/template.circ)

### Používání template

Template stačí stáhnout, přejmenovat podle požadovaného názvu projektu, a můžete ho prostě otevřít a začít používat pro daný projekt. Pro každý nový projekt to musíte udělat znovu.

Alternativně lze template _nainstalovat_ do Logisimu, aby každý nově vytvořený projekt začal z této template. Doporučuji template umístit na nějaké misto, kde ho omylem nesmažete, např. do dokumentů. Pak nastavte v Logisimu:

File --> Preferences --> Template --> (vpravo) Select... --> (vyberte template) --> (bude zaškrtnuté "User template" se správnou cestou).

### Co je v template nastavené

Pro dokumentační účely, nebo pro případ, že už jste s projektem začali, a chcete si nastavení do projektu dodělat, uvádím všechny nastavení, které template obsahuje. Nastavení komponenty se mění tak, že jí vybereme v menu, ale _nepoložíme_ a upravíme její nastavení - tímto způsobem upravíme nastavení všech nově položených komponent tohoto typu (výchozí nastavení).

| Knihovna | Komponenta | Nastavení | Hodnota |
|---|---|---|---|
| Wiring | Pin | Appearance | Arrow Shapes |
| Wiring | Probe | Appearance | Arrow Shapes |
| Wiring | Bit Extender | Extension Type | Zero |
| Gates | * | Gate Size | Narrow |
| Gates | XOR Gate | Multiple-Input Behavior | When an odd number are on |
| Gates | XNOR Gate | Multiple-Input Behavior | When an odd number are on |
| Plexers | * (Decoder) | Include Enable | No |
| Arithmetic | * (Comparator) | Numeric Type | Unsigned |
| Memory | Counter | Appearance | Classic Logisim |
| Memory | Shift Register | Appearance | Classic Logisim |
| Memory | RAM | Enables | Use line enables |
| Memory | RAM | Appearance | Classic Logisim |
| Memory | ROM | Appearance | Classic Logisim |
| Memory | Dual Port RAM | Enables | Use line enables |
| Memory | Dual Port RAM | Appearance | Classic Logisim |

Tyto nastavení se musí provést zvlášť i pro komponenty v horní toolbaře, stejným způsobem jako v menu komponent.
