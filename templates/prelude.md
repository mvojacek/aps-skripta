{% from "spoiler.j2" import spoiler %}
{% from "tikz.j2" import tikzpicture, gate %}
{% from "todo.j2" import todo %}

{%- if env.APS_TEST_THEME | length > 0 -%}
<style>
#menu-bar {
    background-color: hsl(0, 80%, 70%);
}
</style>
{%- endif -%}
