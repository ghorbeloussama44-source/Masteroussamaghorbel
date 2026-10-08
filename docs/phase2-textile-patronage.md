# Phase 2 — Textile et patronage

Le mémoire a été présenté au *Second International Forum on Textiles for Graduate Students*.
Cette phase rend le lien avec le textile concret. Deux outils du mémoire se transposent
directement : **la grammaire générative** (pour le dessin textile) et **la croissance
logistique ajustée par logit** (pour le patronage).

## Idée centrale : le vêtement enfant évolutif

Un enfant grandit selon une courbe en S, exactement comme un entrenœud d'oranger. La méthode du
mémoire (balayer K, linéariser `logit(y/K) = r·t − ln a`, garder la meilleure corrélation)
s'applique telle quelle aux mensurations. On en tire trois choses utiles à l'atelier :

1. **La gradation par âge.** Chaque mensuration (stature, tour de poitrine, longueur dos,
   épaule, cou) est une sigmoïde de l'âge. Le patron d'une taille se calcule à l'âge où la
   stature atteint la taille EN 13402 (taille enfant = stature en cm), par inversion de la
   logistique : `t = ln(a / (K/y − 1)) / r`.
2. **La durée de port de chaque taille.** Temps pour que la stature gagne un pas de taille.
   On en déduit la probabilité de changer de taille en six mois (temps de séjour exponentiel),
   c'est-à-dire une **chaîne de Markov des tailles**, cousine de celle des bourgeons.
3. **La réserve d'ourlet évolutive.** Allongement du vêtement pendant la durée de port. Le patron
   l'intègre comme ourlet à rallonger (ligne pointillée sur la pièce). Le vêtement dure toute sa
   taille au lieu de devenir court au bout de quelques mois.

Valeur : moins de vêtements achetés puis délaissés, argument d'économie circulaire, base pour une
offre de location ou d'abonnement de vêtements enfant dimensionnée par la donnée.

## Imprimé morphogénétique

La branche simulée en phase 1 est projetée (de face ou de dessus) et devient un motif vectoriel :

- raccords droit, demi-saut, miroir ;
- **semis phyllotaxique** : les motifs sont placés sur la spirale de Vogel
  (`r = c√k`, `θ = k · 137.508°`), la même règle d'angle d'or que les feuilles. La couverture du
  tissu est uniforme sans répétition visible ;
- export SVG à l'échelle (cm) pour impression numérique, broderie ou jacquard ;
- chaque graine aléatoire donne une variante unique : collection « une branche, un vêtement ».

L'imprimé remplit la pièce de patron de la taille choisie, ce qui montre le placement réel du
motif sur la pièce.

## Patron de base

Demi-devant de tee-shirt / corsage enfant, construction pédagogique simplifiée :

| Élément | Formule (cm) |
|---|---|
| Largeur demi-devant | poitrine/4 + aisance/4 |
| Encolure largeur / profondeur | cou/6 + 0.5 / cou/6 + 1.5 |
| Profondeur d'emmanchure | poitrine/8 + 6 |
| Pente d'épaule | 0.24 × longueur d'épaule (≥ 1.5) |
| Taille | longueur dos + 1 |
| Longueur totale | taille + 0.09 × stature (+ réserve d'ourlet) |

Le SVG exporté est à l'échelle 1:1, milieu devant au pli, droit-fil, lignes de poitrine et de
taille, valeur de couture réglable.

## Limites et suite

- Les paramètres des mensurations sont **illustratifs**. Ils doivent être recalés sur une
  campagne anthropométrique (tables ISO 8559 / EN 13402, ou mesures propres) avec l'outil
  « Recaler une mensuration » de l'onglet 2.
- Une seule logistique ne reproduit pas le pic pubertaire. Pour les 10–16 ans, utiliser une
  double logistique (modèle de Preece–Baines) ; le noyau est prêt à l'accueillir.
- Construction de patron simplifiée : à valider par un modéliste, puis étendre (dos, manche,
  pantalon), et vérifier les gradations par toile.
