# Od kořenů k plodům: postav si první dbt projekt

Workshop Data Festival VŠE 2026. Minimální dbt projekt nad DuckDB.

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/<GITHUB_USER>/dbt-workshop/HEAD)

## Spuštění
1. Klikni na badge Binder (bez registrace). Tab nech otevřený v popředí.
2. V JupyterLab otevři **Terminal** a spusť:

```bash
dbt debug    # ověří připojení
dbt seed     # nahraje CSV ze seeds/ do DuckDB
dbt run      # postaví modely
dbt test     # spustí testy kvality dat
dbt build    # seed + run + test najednou
```

3. Dokumentace: `dbt docs generate --static` a pak otevři `target/static_index.html`.

## Struktura (kořeny → kmen → plody)
- `seeds/` - kořeny: surová data (CSV)
- `models/staging/` - kmen: čištění a přejmenování
- `models/marts/` - plody: hotové tabulky pro analýzy

Lokálně: `pip install -r requirements.txt` a stejné příkazy.
