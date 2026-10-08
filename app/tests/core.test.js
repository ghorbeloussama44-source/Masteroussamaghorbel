// Vérifications du noyau : node app/tests/core.test.js
const assert = require('assert');
const M = require('../core.js');

const H1 = [[0.02, 0.19, 0.71, 0.08], [0.05, 0.21, 0.67, 0.07], [0.02, 0.18, 0.71, 0.09], [0, 0.16, 0.8, 0.04]];
const PHI = M.PHI;

// 1. Fibonacci du mémoire (éq. 2.65) : matrice [[0,1],[1/φ,1/φ²]] sur les états C (retard) / E (ramification)
const Hfib = [[0, 1, 0, 0], [0, 0, 0, 1], [0, 1, 0, 0], [0, 1 / PHI, 0, 1 / PHI ** 2]];
const st = M.stationary(Hfib);
assert(Math.abs(st[3] - 1 / PHI) < 1e-6, 'loi stationnaire E = 1/φ');
const rates = M.growthRates(Hfib, 'inherit');
assert(Math.abs(rates.meanField - PHI) < 1e-6, 'champ moyen du mémoire : taux φ');
console.log('Fibonacci : champ moyen', rates.meanField.toFixed(4), '| Galton–Watson', rates.galtonWatson.toFixed(4));
// Le champ moyen surestime : la vraie racine de Perron vaut (0.764+√(0.764²+4·1.236))/2 ≈ 1.558
assert(Math.abs(rates.galtonWatson - 1.5576) < 2e-3);

// 2. Ajustement de H pour atteindre φ en Galton–Watson
const fit = M.fitGrowthRate(Hfib, PHI, 'inherit');
assert(fit && Math.abs(fit.rate - PHI) < 1e-4, 'conditionnement Fibonacci');

// 3. Branche 1 : ~55 bourgeons après 69 itérations en espérance (mémoire : g69+f69 = 55)
const bx = M.branchingExpectation(H1, H1[0], 69, 'inherit');
const mf = M.thesisMeanField(H1, H1[0], 69);
console.log('Branche 1 à n=69 — GW: f', bx.f[69].toFixed(1), 'X', bx.X[69].toFixed(1), 'Y', bx.Y[69].toFixed(1),
  '| champ moyen: f', mf.f[69].toFixed(1), 'X', mf.X[69].toFixed(1), 'Y', mf.Y[69].toFixed(1));

// 4. Monte Carlo ≈ espérance GW
let sumF = 0, R = 300;
for (let s = 1; s <= R; s++) sumF += M.simulate({ H: H1, h1: H1[0], iterations: 30, seed: s }).hist.f[30];
const mc = sumF / R;
console.log('Monte Carlo f30', mc.toFixed(2), 'vs GW', bx.f[30].toFixed(2));
assert(Math.abs(mc - bx.f[30]) / bx.f[30] < 0.15, 'Monte Carlo cohérent avec Galton–Watson');

// 5. Ajustement logit retrouve les paramètres de longueur du mémoire
const ts = [], ys = [];
for (let t = 0; t <= 90; t += 3) { ts.push(t); ys.push(M.sigmoid(8, 7.85, 0.0075, t)); }
const sf = M.fitSigmoid(ts, ys, { kMin: 2, kMax: 30, steps: 3000 });
console.log('Ajustement longueur : K', sf.K.toFixed(2), 'a', sf.a.toFixed(2), 'r', sf.r.toFixed(4), 'rp', sf.rp.toFixed(5));
assert(Math.abs(sf.r - 0.0075) < 0.001 && Math.abs(sf.K - 8) < 0.5);

// 6. Géométrie : nombre de segments = nœuds nés
const sim = M.simulate({ H: H1, h1: H1[0], iterations: 40, seed: 3 });
const geo = M.geometry(sim, sim.iterations, {});
assert.strictEqual(geo.segs.length, sim.nodes.length);
assert(M.toMaxScript(geo).includes('Cone radius1'));

// 7. Patronage : tailles croissantes, durées de port positives
const tab = M.sizeTable([92, 104, 116, 128, 140, 152, 164]);
tab.forEach((r, i) => { assert(r.months > 0); if (i) assert(r.m.chest > tab[i - 1].m.chest); });
console.log('Tailles :', tab.map((r) => `T${r.size} ${r.age.toFixed(1)}a poitrine ${r.m.chest.toFixed(0)} port ${r.months.toFixed(0)}mois ourlet ${r.hemReserve.toFixed(1)}`).join(' | '));

// 8. ABC : retrouve un h connu (ordre de grandeur)
const truth = [0.03, 0.2, 0.68, 0.09];
const obs = M.gwCounts(truth, 60, M.rng(11), 1e6);
let last; for (const st2 of M.abc(obs, 60, 6000, 5)) last = st2;
const sum = M.abcSummary(last.all, 0.02);
console.log('ABC obs', obs, '→ h moyen', sum.mean.map((x) => x.toFixed(3)).join(' '));
assert(Math.abs(sum.mean[3] - truth[3]) < 0.06);

console.log('OK — toutes les vérifications passent');
