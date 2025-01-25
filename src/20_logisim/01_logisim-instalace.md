# Instalace Logisimu Evolution

```admonish important title="Máte správný Logisim?"
Pozor na to, že používate Logisim **Evolution**. Klasický Logisim je už léta zastaralý, je nestabilní, nepodporuje moderní komponenty, a **projektové soubory s Logisimem Evolution nejsou kompatibilní!**
```

```admonish info title="Verze Logisimu Evolution"
Minimální požadovaná verze Logisimu Evolution v tomto předmětu je 3.9.0.
```

## Java 21

Logisim Evolution od verze 3.9.0 vyžaduje Javu 21.

### Linux

Nejpřímočařejší nainstalovat openjdk z repozitářů, e.g. na ubuntu:

`apt-get install openjdk-21-jre`

### Windows

Doporučuji [Microsoft build openjdk](https://learn.microsoft.com/en-us/java/openjdk/download#openjdk-21), protože se hezky zaintegruje do windows a aplikace to můžou bez problému najít. Pro windows tedy instalátor `.msi`. Během instalace je vhodné vybrat všechny features, tedy i nastavení `JAVA_HOME` a Oracle registry keys.

```admonish info title="Instalace bez administrátorských práv (e.g. ve škole)",collapsible=true

V případě, že nemáte k dispozici administrátorské práva, postačí `.zip` openjdk, který si rozbalíte, a do jeho bin složky (vedle java.exe) nakopírujete logisim. Přes shift-rightlick můžete pak ve složce otevřít terminál, ve kterém lze logisim spustit přes

`.\java.exe -jar logisim-evolution-xxxx.jar`

Je důležité mít `.\` před `java.exe`, jinak se použije systémová, potenciálně zastaralá, java.
```

## Logisim Evolution


Obecně stáhneme z oficiálního git repa v releases [https://github.com/logisim-evolution/logisim-evolution/releases](https://github.com/logisim-evolution/logisim-evolution/releases) nejnovější verzi.

Tedy

- Debian based (e.g. Ubuntu) - `.deb`
- RPM package - `.rpm`
- Windows - `.msi`
- macOS - `.dmg`
- Ostatní - `.jar` - půjde spustit buď poklikáním nebo z terminálu pomocí `java -jar logisim-evolution-xxx.jar`

```admonish warning
Na linuxu pozor na instalaci z repozitářů distribuce (apt, dnf, yum, flatpak, snap, ...). Často v nich bývají zastarelé verze, které nemají pro nás potřebné bugfixy a features (třeba autosave)!
```

### Arch linux

Můžeme nainstalovat z Arch AUR repozitáře pomocí `yay`

```bash
yay -S logisim-evolution-bin
```

Pokud preferujete instalaci ze zdrojáku, můžete vynechat `-bin`.

## Logisim template

Template si můžete nastavit v `File > Preferences... > Template > User template > Select > Vybrat template file`

Všechny gaty jsou nastaveny na `narrow`, všechny plexery mají disabled output zero.

[Download - template](../logisim/template.circ)
