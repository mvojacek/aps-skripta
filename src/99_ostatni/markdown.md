# Markdown

Tyto skripta se kompilují pomocí [mdbook](https://rust-lang.github.io/mdBook/), je tedy možné používat všechny tímto programem podporované konstrukce.

Časem je cílem podorovat i build do pdf, což nejspíš omezí některé syntaxe, aby mohl proběhnout build do html i do pdf ze stejného zdrojového kódu.

Navíc jsou do mdbook nainstalované preprocessory, které umožňují používat další druhy syntaxe. Preprocesory jsou uvedeny cca v pořadí, ve kterém se spoštějí:

## [checklist](https://github.com/ANSSI-FR/mdbook-checklist)

Umožňuje vložit do markdownu inline TODO, ze kterých se udělá globální seznam ve speciální kapitole, s odkazy.

### Příklad

```markdown
{{ ch_markdown.checklist_usage }}
```

## [tera](https://github.com/mvojacek/mdbook-tera)

Nahrazuje template výrazy [tera](https://github.com/Keats/tera) v markdownu podle contextu v [src/context.toml](../context.toml). Tohle je nejjednodušší způsob, jak zadefinovat a recyklovat řetězce napříč celými skripty.

### Příklad

{{ ch_markdown.tera_test }}

Autoři těchto skript jsou {{ ctx.config.book.authors | join(sep=", ") }}.

| Číslo | Autor |
|------:|:------|
{% for author in ctx.config.book.authors -%}
| {{ loop.index }} | {{ author }} |
{% endfor -%}
| end | end |

## [cmdrun](https://github.com/FauconFan/mdbook-cmdrun)

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

## [katex](https://github.com/lzanini/mdbook-katex)

Umožňuje použití `$` a `$$` pro psaní matematických výrazů.

### Příklad

$$ \nabla f(x) \in \mathbb{R}^n $$

## [image-size](https://github.com/lhybdv/mdbook-image-size)

Markdown neumožňuje specifikaci velikosti a centrování obrázků, tento preprocesor tuto funkcionalitu přidává.

Do budoucna chci projekt upravit a rozvolnit syntaxi, aby šlo specifikovat pouze zarovnání, bez šířky.  
TODO: {{#check image-size-fork | Forknout mdbook-image-size a rozvolnit syntaxi}}

### Příklad

![](../img/ABasicComputer.svg.png =500x100 center)

## [admonish](https://github.com/tommilligan/mdbook-admonish)

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

TODO

## toc

TODO

## kroki

TODO

## emojicodes

TODO

## embedify

TODO

## footnote

TODO

