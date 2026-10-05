# Od kořenů k plodům: postav si první dbt projekt

Workshop Data Festival VŠE 2026. Minimální dbt projekt nad DuckDB (dbt v2, DuckDB driver je součástí, žádný adapter navíc).

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/novakmatej/dbt-workshop/HEAD?urlpath=vscode%2F%3Ffolder%3D%2Fhome%2Fjovyan)

## Spuštění
1. Klikni na badge Binder (bez registrace). Tab nech otevřený v popředí.
2. Otevře se VS Code v prohlížeči. Terminál: menu → Terminal → New Terminal a spusť:

```bash
dbt debug    # ověří připojení
dbt seed     # nahraje CSV ze seeds/ do DuckDB
dbt run      # postaví modely
dbt test     # spustí testy kvality dat
dbt build    # seed + run + test najednou
```

3. Dokumentace: `dbt docs generate` a pak `python -m http.server 8000 -d target`. Otevři `<binder-url>/proxy/8000/`.

## Struktura (kořeny → kmen → plody)
- `seeds/` - kořeny: surová data (CSV)
- `models/staging/` - kmen: čištění a přejmenování
- `models/marts/` - plody: hotové tabulky pro analýzy

Lokálně: `pip install -r requirements.txt` a stejné příkazy.
