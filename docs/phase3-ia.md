# Phase 3 — Ce que l'IA peut faire avancer

Le mémoire concluait sur trois pistes : de meilleures estimations (« conditionnement Fibonacci »),
une simulation plus rapide, et une collecte de données facilitée par le traitement d'images et la
géométrie épipolaire. Chacune correspond aujourd'hui à une technique d'IA mature. Classement par
statut : **fait** (dans l'atelier), **prototype** (quelques semaines), **recherche** (thèse,
article).

## 1. Fait : inférence bayésienne par simulation (ABC)

Dans le mémoire, `H` a été choisie en faisant varier un taux de retard jusqu'à retrouver le
rapport Y/X observé (≈ 7.32). L'onglet 3 automatise cela :

- loi a priori uniforme (Dirichlet(1,1,1,1)) sur les probabilités des règles ;
- simulation rapide du processus de branchement (comptages par lois binomiales) ;
- on garde les 2 % de simulations les plus proches des comptages observés (X, Y, et si connus
  f vivants, g morts) ;
- résultat : moyenne **et incertitude** de chaque probabilité, nuage a posteriori, réinjection
  dans le simulateur en un clic.

Constat utile : X et Y seuls ne fixent pas trois probabilités libres (le nuage reste large). Il
faut des statistiques de forme supplémentaires, ce qui motive les points 3 et 4.

## 2. Fait : cadre de Galton–Watson multitype

Correction du champ moyen (voir phase 1). Il fournit l'espérance exacte, donc une vérité de terrain
pour entraîner et valider les modèles d'apprentissage.

## 3. Prototype : modèle de Markov caché appris par EM

La Proposition 1 du mémoire décrit exactement un **HMM** : les règles (états) sont cachées, la
chaîne d'entrenœuds X/Y est observée. L'algorithme de Baum–Welch estime `H` complète (avec
mémoire, ligne par ligne) et la loi initiale à partir des chaînes converties des branches
mesurées, sans réglage manuel. Extension naturelle : HMM arborescent (hidden Markov tree), adapté
à la structure ramifiée, déjà utilisé en architecture végétale.

## 4. Prototype : inférence par réseau de neurones (NPE)

Entraîner un réseau (normalizing flow) sur des millions de branches simulées par le noyau de
l'atelier. En entrée : statistiques de forme (comptages par ordre de ramification, distribution
des longueurs, angles). En sortie : loi a posteriori de `H`, des sigmoïdes et de la phyllotaxie,
en une passe. Bibliothèque type `sbi` (PyTorch). Gain : inférence instantanée sur le terrain,
incertitude calibrée.

## 5. Prototype : numérisation automatique

Remplacer la mesure manuelle (longueurs, épaisseurs, angles relevés à la main dans Excel) par :

1. photogrammétrie ou Gaussian splatting depuis une vidéo smartphone ;
2. nuage de points → squelettisation (Laplacian contraction, ou réseau dédié) ;
3. segmentation des organes (PointNet++ / transformer de points) : entrenœud, feuille, fruit ;
4. conversion automatique en chaîne L-system, puis inférence (points 1, 3, 4).

C'est le prolongement direct de la perspective « traitement d'images et géométrie épipolaire ».

## 6. Prototype : interface en langage naturel (LLM)

Un LLM (par exemple Claude via l'API, en mode outil) traduit une description
(« branche d'oranger de 3 ans, port retombant, peu ramifiée ») en JSON de paramètres
(`H`, sigmoïdes, angles). Le JSON est validé par `core.js` (lignes stochastiques, bornes) avant
simulation. Le LLM sert d'interface ; la simulation reste mathématique et vérifiable. Même
principe côté textile : « imprimé indigo, raccord demi-saut, 12 cm » → paramètres de motif.

## 7. Recherche : L-system différentiable

Relaxer les tirages discrets (Gumbel-softmax) et la géométrie de la tortue pour obtenir un
simulateur différentiable. On optimise alors `H`, angles et sigmoïdes par descente de gradient
contre une silhouette, un scan 3D ou des photos (rendu différentiable). Sujet de thèse naturel
dans la continuité du mémoire.

## 8. Recherche : imprimés génératifs guidés par la morphogenèse

Un modèle de diffusion conditionné par le squelette produit par le L-system (type ControlNet)
génère des imprimés photoréalistes dont la structure reste botaniquement juste et
reparamétrable : rapport, coloris, densité, raccord sans couture garanti par le squelette.

## 9. Recherche : patron sur mesure et placement

- Prédire les mensurations d'un enfant et leur trajectoire (double logistique, Preece–Baines)
  depuis une photo ou un scan, générer le patron gradé et la réserve d'ourlet personnalisés.
- Placement des pièces sur la laize par apprentissage par renforcement ou recherche guidée,
  avec contrainte de raccord de l'imprimé : moins de chutes.

## Plan de travail proposé

| Étape | Livrable | Durée indicative |
|---|---|---|
| A | Baum–Welch sur les chaînes des branches 1 et 2 du mémoire, comparaison avec `H` publiée | 2–3 semaines |
| B | Jeu de données simulées (10⁶ branches) + NPE, validation sur les branches réelles | 1–2 mois |
| C | Pipeline smartphone → nuage de points → chaîne L-system sur 10 branches | 2–3 mois |
| D | Campagne de mensurations enfant, recalage logistique / Preece–Baines, toile de validation | 2 mois |
| E | Article : « Galton–Watson multitype et inférence bayésienne pour les L-systems stochastiques markoviens » | en parallèle |
