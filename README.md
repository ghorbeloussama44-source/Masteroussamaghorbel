# Atelier Morphogenèse

Prolongement du mémoire de Mastère d'Oussama Ghorbel (EPT, 2014) :
*Reconstruction 3D et modélisation-simulation du développement et de la croissance d'une branche d'oranger*
(L-system stochastique, chaîne de Markov, suite de Fibonacci, croissance sigmoïde, plugin 3ds Max).

Le projet est découpé en trois phases :

| Phase | Contenu | Où |
|---|---|---|
| 1. Application de simulation | Simulateur 3D interactif dans le navigateur : matrice de Markov éditable, lecture du temps, courbes, export MAXScript/OBJ | [`app/index.html`](app/index.html), [`docs/phase1-application.md`](docs/phase1-application.md) |
| 2. Textile et patronage | Imprimé généré par la branche simulée, patron enfant gradé par croissance logistique, durée de port, réserve d'ourlet | onglet 2 de l'app, [`docs/phase2-textile-patronage.md`](docs/phase2-textile-patronage.md) |
| 3. Intelligence artificielle | Inférence bayésienne ABC de la matrice H (fonctionnelle) et feuille de route IA | onglet 3 de l'app, [`docs/phase3-ia.md`](docs/phase3-ia.md) |

## Mettre le site en ligne (Vercel)

[![Déployer sur Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fghorbeloussama44-source%2FMasteroussamaghorbel&project-name=atelier-morphogenese)

Ou : vercel.com → *Add New… → Project* → importer ce dépôt → *Deploy*. Aucune option à régler :
`vercel.json` sert directement le dossier `app/` (site statique, pas de build). Chaque push sur
`main` redéploie le site.

## Lancer l'application

Aucune installation. Depuis la racine du dépôt :

```bash
python3 -m http.server 8000 --directory app
# puis ouvrir http://localhost:8000
```

Three.js est chargé depuis un CDN ; sans réseau, la vue 3D est désactivée mais les courbes,
le textile et l'inférence restent utilisables.

## Vérifier le noyau mathématique

```bash
node app/tests/core.test.js
```

Les tests vérifient notamment : la loi stationnaire 1/φ de la matrice de Fibonacci du mémoire,
l'écart entre le champ moyen (taux φ) et le processus de Galton–Watson (taux ≈ 1.558),
l'accord Monte Carlo / espérance, la récupération des paramètres sigmoïdes du mémoire par la
méthode logit, et la cohérence du patron gradé.

## Contenu historique

- `Master Ghorbel_Oussama_VFinal.pdf`, `Master finale 10 -Ghorbel_Oussama.docx` : le mémoire.
- `Phd …3D-MODELING AND SIMULATION….pdf`, `…FORUM ON TEXTILES….pptx` : la communication au
  2ᵉ Forum international des textiles pour doctorants.
- `test3dsmax/` : scripts MAXScript d'origine (automate double échelle, L-system stochastique,
  chaîne de Markov).
