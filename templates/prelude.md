{% from "spoiler.j2" import spoiler %}
{% from "tikz.j2" import tikzpicture, gate, resizesvg %}
{% from "todo.j2" import todo %}
{% from "util.j2" import svg %}

{%- if env.APS_TEST_THEME | length > 0 -%}
<style>
#menu-bar {
    background-color: hsl(0, 80%, 70%);
}
</style>
{%- endif -%}

{% set logisim_version = "4.0.0" %}
