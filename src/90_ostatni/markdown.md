# Markdown

Tyto skripta se kompilují pomocí [mdbook](https://rust-lang.github.io/mdBook/), je tedy možné používat všechny tímto programem podporované konstrukce.

Časem je cílem podorovat i build do pdf, což nejspíš omezí některé syntaxe, aby mohl proběhnout build do html i do pdf ze stejného zdrojového kódu.

Navíc jsou do mdbook nainstalované preprocessory, které umožňují používat další druhy syntaxe. Preprocesory jsou uvedeny cca v pořadí, ve kterém se spoštějí:

## checklist [:blue_book:](https://github.com/ANSSI-FR/mdbook-checklist)

Umožňuje vložit do markdownu inline TODO, ze kterých se udělá globální seznam ve speciální kapitole, s odkazy.

### Příklad

Kvůli konfliktu syntaxu s jinja templatováním je nutné použít pro vytvoření TODO jinja makro:

```markdown
{% raw -%}
{{ todo("This and that needs to be done") }}
{%- endraw %}
```

## minijinja [:blue_book:](https://github.com/ssanderson/mdbook-minijinja)

Umožňuje napříč celými skripty používat jinja templates ([specifikace](https://jinja.palletsprojects.com/en/stable/templates/)) pomocí implementace [minijinja](https://github.com/mitsuhiko/minijinja) ([rozdíly oproti specifikaci](https://github.com/mitsuhiko/minijinja/blob/main/COMPATIBILITY.md)).

Templates, včetně souborů obsahující makra, jsou ve složce templates. Globální proměnné lze přidat v book.toml.

Naimportování všech důležitých maker lze provést pomocí `{% raw %}{% include prelude %}{% endraw %}`, kde `prelude` je v book.toml zadefinované jako "prelude.md", které se nachází v templates/ a importuje makra. **NEW:** prelude se includuje ve všech kapitolách automaticky, není potřeba includovat nic z ní.

### Příklad

```markdown
{% raw -%}

{% set authors = ["Michal Vojáček", "Michal Javor"] %}

Autoři těchto skript jsou {{ authors | join(", ") }}.

| Číslo | Autor |
|------:|:------|
{% for author in authors -%}
| {{ loop.index }} | {{ author }} |
{% endfor -%}
| end | end |

{% call spoiler(el="div") %}
{{ gate("xor", "OUT", "IN1", "IN2") }}
{% endcall %}

{%- endraw %}
```

{% set authors = ["Michal Vojáček", "Michal Javor"] %}

Autoři těchto skript jsou {{ authors | join(", ") }}.

| Číslo | Autor |
|------:|:------|
{% for author in authors -%}
| {{ loop.index }} | {{ author }} |
{% endfor -%}
| end | end |

{% call spoiler(el="div") %}
{{ gate("xor", "OUT", "IN1", "IN2") }}
{% endcall %}

## cmdrun [:blue_book:](https://github.com/FauconFan/mdbook-cmdrun)

Umožňuje do skript přidat výstup libovolného unix příkazu, což je užitečné např. pro generování výstupů z logisimu, nebo buildování latexu.

Přichází s tím samozřejmě určitý risk, proto doporučuji provozovat mdbook
builder v dockeru. Všechny použití tohoto preprocesoru lze najít pomocí:

```bash
grep -roP '\<\!\-\- cmdrun\K.+(?=\-\-\>)' --exclude-dir book .
```

### Příklad

Jako příklad seznam všech použití toho preprocesoru ve skriptech (příkaz výše):

```console
<!-- cmdrun cd ../.. && grep --color=no -roP '\<\!\-\- cmdrun\K.+(?=\-\-\>)' --exclude-dir book . -->
```

## katex [:blue_book:](https://github.com/lzanini/mdbook-katex)

Umožňuje použití `$` a `$$` pro psaní matematických výrazů.

### Příklad

$$ \nabla f(x) \in \mathbb{R}^n $$

## image-size [:blue_book:](https://github.com/lhybdv/mdbook-image-size)

Markdown neumožňuje specifikaci velikosti a centrování obrázků, tento preprocesor tuto funkcionalitu přidává.

Do budoucna chci projekt upravit a rozvolnit syntaxi, aby šlo specifikovat pouze zarovnání, bez šířky.  
{{ todo("Forknout mdbook-image-size a rozvolnit syntaxi") }}

### Příklad

![](../img/ABasicComputer.svg.png =500x100 center)

## admonish [:blue_book:](https://github.com/tommilligan/mdbook-admonish)

Umožňuje vytvářet HTML "bannery", které volitelně můžou být rozbalovací.

Vyvolává se pomocí ` ```admonish info title="Title",collapsible=true`, kde místo info můžou být následující vestavěné styly:

### Příklad

```admonish note title="note",collapsible=true
Takhle vypadá rozbalovací sekce.
```

```admonish summary title="abstract, summary, tldr"
```

```admonish info title="info, todo"
```

```admonish tip title="tip, hint, important"
```

```admonish success title="success, check, done"
```

```admonish question title="question, help, faq"
```

```admonish warning title="warning, caution, attention"
```

```admonish fail title="failure, fail, missing"
```

```admonish danger title="danger, error"
```

```admonish bug title="bug"
```

```admonish example title="example"
```

```admonish quote title="quote, cite"
```

## quiz

{{ todo("quiz") }}

## toc

{{ todo("toc") }}

## kroki

{{ todo("kroki") }}

## emojicodes [:blue_book:](https://github.com/blyxyas/mdbook-emojicodes)

Umožňuje vkládat do textu emoji pomocí Github shortcode ohraničeného ::

[Kompletní seznam shortcodes](https://github.com/ikatyang/emoji-cheat-sheet/blob/master/README.md)

### Příklad

:couple_with_heart_man_man: :couple_with_heart_woman_woman: :white_check_mark: :rainbow_flag: :transgender_flag:

## embedify

{{ todo("embedify") }}

## footnote

{{ todo("footnote") }}

## pagetoc [:blue_book:](https://github.com/slowsage/mdbook-pagetoc)

Přidává na generovanou stránku vpravo sidebar s navigací v aktuální kapitole, pokud na nej je horizontální místo ve viewportu.
