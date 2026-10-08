# Phase 1 — Application de simulation

## Objectif

Remplacer la chaîne d'outils du mémoire (Excel → WinDev → plugin MAXScript dans 3ds Max) par une
seule application web, manipulable sans logiciel propriétaire, qui garde la compatibilité
3ds Max par export.

## Ce que fait l'application

- **Simulation topologique.** 0L-system stochastique binaire de la Proposition 2 du mémoire :
  `B : f → g`, `C : f → f`, `D : f → Y f`, `E : f → X[f] f`. Chaque bourgeon garde en mémoire la
  dernière règle appliquée ; la suivante est tirée dans la ligne correspondante de `H`.
- **Géométrie.** Tortue 3D : rotation de phyllotaxie autour de l'axe (α₁ ≈ 138.1°, σ = 4°),
  angle de branchement ~ N(38°, 22°), tropisme réglable. Chaque organe garde ses tirages
  aléatoires, donc la même branche peut être affichée à n'importe quel âge.
- **Croissance.** Longueur et rayons des entrenœuds selon les sigmoïdes ajustées dans le mémoire
  (éq. 2.178–2.182). Le curseur de temps montre le synchronisme développement / croissance.
- **Prévision.** « Prévoir +5 itérations » prolonge la même branche (même graine), comme la
  prévision de la fig. 2.32.
- **Lecture mathématique en direct.** Loi stationnaire de `H`, taux de croissance en champ moyen
  (lecture du mémoire) et en Galton–Watson (racine de Perron de la matrice moyenne), courbes
  simulation vs espérance.
- **Exports.** MAXScript (cônes, comme le plugin d'origine), squelette OBJ, chaîne L-system,
  paramètres JSON.

## Choix UI / UX

| Besoin | Réponse dans l'interface |
|---|---|
| Comprendre sans lire le mémoire | Préréglages commentés (branches 1 et 2, Fibonacci, exemple 4), onglet « Mode d'emploi » |
| Manipuler la matrice sans erreur | Saisie libre, renormalisation automatique des lignes, somme affichée par ligne |
| Voir l'effet d'un réglage | Taux de croissance et régime (croissance / extinction) recalculés à la frappe |
| Voir le temps | Curseur d'âge et lecture animée sous la scène 3D |
| Comparer théorie et tirage | Trait plein = simulation, tirets = espérance ; survol pour lire les valeurs |
| Retour vers 3ds Max | Export MAXScript copiable |
| Mobile | La scène passe au-dessus des réglages, sections repliables |

## Apport mathématique nouveau

Le mémoire calcule l'évolution des bourgeons en champ moyen :
`f(n+1) = f(n)(1 − h_n(B) + h_n(E))` avec `h_n = h_1 H^(n−1)`.
Or, quand un bourgeon se ramifie, ses deux descendants héritent de son état : les lignées ne sont
pas indépendantes de l'état. Le bon cadre est le **processus de Galton–Watson multitype** de
matrice moyenne

```
M_ij = H_ij · [j ≠ B] + H_iE · [j = état du latéral]
```

dont la racine de Perron ρ(M) donne le taux de croissance réel. Pour la matrice de Fibonacci du
mémoire (éq. 2.65), le champ moyen donne φ ≈ 1.618 mais ρ(M) ≈ 1.558. Le bouton « Caler la
croissance sur φ » résout ρ(M) = φ par dichotomie sur la colonne E : c'est une réalisation exacte
du « conditionnement Fibonacci » que le mémoire laissait en perspective. Les tests Monte Carlo
confirment l'espérance Galton–Watson.

## Fichiers

- `app/core.js` : noyau mathématique pur (navigateur et Node).
- `app/index.html` : interface (Three.js r128 pour la 3D, SVG pour les courbes).
- `app/tests/core.test.js` : vérifications.
