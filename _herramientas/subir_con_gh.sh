#!/bin/bash
# subir_con_gh.sh · Crea un repositorio público por carpeta y lo sube a GitHub
# Requisitos: git y GitHub CLI (https://cli.github.com) con la sesión iniciada:  gh auth login
# Uso:  cd _herramientas && bash subir_con_gh.sh
set -euo pipefail
USUARIO="fabrizio2032-SVC"
cd "$(dirname "$0")/.."

bash _herramientas/comprobar_antes_de_subir.sh . || true
read -rp "¿Has revisado los avisos y quieres continuar? (s/N) " r; [[ "$r" =~ ^[sS]$ ]] || exit 1

for dir in */; do
  repo="${dir%/}"
  [[ "$repo" == _herramientas ]] && continue
  echo "== $repo"
  (
    cd "$repo"
    [[ -d .git ]] || git init -q -b main
    git add -A
    git commit -qm "Primera versión de ${repo}" || echo "   (sin cambios nuevos)"
    if gh repo view "$USUARIO/$repo" >/dev/null 2>&1; then
      git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$USUARIO/$repo.git"
      git push -u origin main
    else
      gh repo create "$USUARIO/$repo" --public --source . --remote origin --push \
        --description "$(head -1 README.md | sed 's/^# //')"
    fi
  )
done

echo "Activando GitHub Pages en el portfolio…"
gh api -X POST "repos/$USUARIO/portfolio/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  && echo "✓ Pages activado" || echo "   Actívalo a mano en Settings › Pages si no se ha podido"
