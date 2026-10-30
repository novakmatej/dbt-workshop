{#
  dbt Agent Schema: postaví schéma `agents` se 4 tabulkami, které agent čte za běhu.
  Exponuje jen modely s tagem 'agent' (marty). Spouští se v on-run-end po run/build,
  ručně: dbt run-operation build_agents_schema
#}
{% macro _agents_lit(v) -%}
  {%- if v is none -%}null{%- else -%}'{{ v | string | replace("'", "''") }}'{%- endif -%}
{%- endmacro %}

{% macro build_agents_schema(context_file='agents_business_context.md') %}
  {% if not execute %}{{ return('') }}{% endif %}

  {% set ddl %}
    create schema if not exists agents;
    create or replace table agents.root (provider varchar, key varchar, content text);
    create or replace table agents.dbt_model (unique_id varchar, name varchar, relation varchar, materialized varchar, description text);
    create or replace table agents.dbt_column (model_id varchar, column_name varchar, data_type varchar, description text);
    create or replace table agents.dbt_dependency (upstream_id varchar, downstream_id varchar);
  {% endset %}
  {% do run_query(ddl) %}

  {% set models = [] %}{% set columns = [] %}{% set deps = [] %}
  {% set exposed = [] %}{% set exposed_ids = [] %}
  {% for n in graph.nodes.values() if n.resource_type == 'model' and 'agent' in n.tags %}
    {% do exposed.append(n) %}{% do exposed_ids.append(n.unique_id) %}
  {% endfor %}
  {% for n in exposed %}
    {% do models.append('(' ~ _agents_lit(n.unique_id) ~ ',' ~ _agents_lit(n.name) ~ ','
        ~ _agents_lit(n.schema ~ '.' ~ (n.alias or n.name)) ~ ',' ~ _agents_lit(n.config.materialized) ~ ','
        ~ _agents_lit(n.description) ~ ')') %}
    {% for c in n.columns.values() %}
      {% do columns.append('(' ~ _agents_lit(n.unique_id) ~ ',' ~ _agents_lit(c.name) ~ ','
          ~ _agents_lit(c.data_type) ~ ',' ~ _agents_lit(c.description) ~ ')') %}
    {% endfor %}
    {% for up in n.depends_on.nodes if up in exposed_ids %}
      {% do deps.append('(' ~ _agents_lit(up) ~ ',' ~ _agents_lit(n.unique_id) ~ ')') %}
    {% endfor %}
  {% endfor %}

  {% if models %}{% do run_query('insert into agents.dbt_model values ' ~ models | join(',')) %}{% endif %}
  {% if columns %}{% do run_query('insert into agents.dbt_column values ' ~ columns | join(',')) %}{% endif %}
  {% if deps %}{% do run_query('insert into agents.dbt_dependency values ' ~ deps | join(',')) %}{% endif %}

  {% do run_query("insert into agents.root values
    ('dbt', 'overview', 'Smíš dotazovat jen modely z agents.dbt_model. Před psaním SQL si přečti agents.dbt_column pro každou tabulku. Staging je záměrně skrytý.'),
    ('jungle_shop', 'business_context', (select content from read_text(" ~ _agents_lit(context_file) ~ ")))") %}

  {{ log('agents schema: ' ~ models | length ~ ' modelů, ' ~ columns | length ~ ' sloupců, ' ~ deps | length ~ ' závislostí', info=true) }}
{% endmacro %}
