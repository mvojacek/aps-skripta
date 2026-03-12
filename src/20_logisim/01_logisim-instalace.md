# Instalace a nastavení Logisim Evolution

```admonish important title="Máte správný Logisim?"
Pozor na to, že používate Logisim **Evolution**. Klasický Logisim je už léta zastaralý, je nestabilní, nepodporuje moderní komponenty, a **projektové soubory s Logisimem Evolution nejsou kompatibilní a nebudou akceptovány!**
```

```admonish info title="Verze Logisimu Evolution"
Požadovaná verze Logisimu Evolution v tomto předmětu je **{{ logisim_version }}**. Soubory vytvořené ve starších verzích nemusí být kompatibilní a nebudou akceptovány!
```

## Logisim template

Stáhněte a nastavte si v Logisimu [template](./02a_template.md)!

## Instalace logisimu

Pozor na outdated balíčky v různých repozitářích. Potřebujete verzi **{{ logisim_version }}**

Aktuální balíčky lze stáhnout jako [release z githubu](https://github.com/logisim-evolution/logisim-evolution/releases/tag/v{{ logisim_version }}). Vyberte si příslušnou verzi pro vaše OS.

## Logisim s manuální Javou

Pokud vám nevyhovuje žádný z balíčků v releases, stáhněte si soubor `.jar` (Java archive) a budete ho ručně spouštět v Javě. Logisim vyžaduje Javu minimálně verze 21.

Pokud už máte na počítači Javu alespoň 21, nebo jí umíte nainstalovat, můžete spustit logisim z příkazové řádky:

```sh
java -jar logisim-evolution-{{ logisim_version }}.jar
```

### Instalace Javy 21

### Linux

Nejpřímočařejší nainstalovat openjdk z repozitářů:

Ubuntu: `apt-get install openjdk-21-jre`  
Arch: `pacman -S jre21-openjdk`  
...etc. pro vaši distribuci

Pokud instalace z repozitářů není možná, nebo preferujete portable instalaci, můžete si stáhnout a rozbalit [Eclipse Temurin OpenJDK 21](https://adoptium.net/temurin/releases?version=21&os=any&arch=any) (Chcete JRE pro Linux, ve formátu .tar.gz). Binárku `java` najdete ve složce `bin` a můžete jí po rozbalení používat místo nainstalované javy.

### Windows

Doporučuji [Microsoft build openjdk](https://learn.microsoft.com/en-us/java/openjdk/download#openjdk-21), protože se hezky zaintegruje do windows a aplikace to můžou bez problému najít. Pro windows tedy instalátor `.msi`. Během instalace je vhodné vybrat všechny features, tedy i nastavení `JAVA_HOME` a Oracle registry keys.

```admonish info title="Instalace bez administrátorských práv (e.g. ve škole)",collapsible=true

V případě, že nemáte k dispozici administrátorské práva, postačí `.zip` openjdk, který si rozbalíte, a do jeho bin složky (vedle java.exe) nakopírujete logisim. Přes shift-rightlick můžete pak ve složce otevřít terminál, ve kterém lze logisim spustit přes

`.\java.exe -jar logisim-evolution-xxxx.jar`

Je důležité mít `.\` před `java.exe`, jinak se použije systémová, potenciálně zastaralá, java.
```
