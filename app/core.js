/*
 * Noyau mathématique — Atelier Morphogenèse (d'après le mémoire de Mastère
 * d'Oussama Ghorbel, EPT 2014 : « Reconstruction 3D et modélisation-simulation
 * du développement et de la croissance d'une branche d'oranger »).
 *
 * Contenu :
 *  - 0L-system stochastique binaire (Proposition 2 du mémoire) :
 *      A : g -> g          (organe mort)
 *      B : f -> g          (le bourgeon meurt)
 *      C : f -> f          (retard de croissance)
 *      D : f -> Y f        (développement linéaire)
 *      E : f -> X [f] f    (ramification)
 *    les règles B..E sont les états d'une chaîne de Markov de matrice H.
 *  - Croissance sigmoïde des entrenœuds (éq. 2.178–2.183) et phyllotaxie (2.171).
 *  - Espérances : champ moyen du mémoire (2.67–2.70) et processus de
 *    Galton–Watson multitype (correction proposée ici).
 *  - Ajustement logit/sigmoïde par balayage de K (méthode du mémoire, §2.3.3.4).
 *  - Inférence inverse par ABC (phase 3).
 *  - Patronage enfant gradé par croissance logistique (phase 2).
 *
 * Fichier UMD : utilisable dans le navigateur (window.Morpho) et sous Node.
 */
(function (root, factory) {
  if (typeof module === 'object' && module.exports) module.exports = factory();
  else root.Morpho = factory();
})(typeof self !== 'undefined' ? self : this, function () {
  'use strict';

  const PHI = (1 + Math.sqrt(5)) / 2;
  const RULES = ['B', 'C', 'D', 'E'];
  const RULE_TEXT = {
    B: 'f → g (mort)',
    C: 'f → f (retard)',
    D: 'f → Y f (linéaire)',
    E: 'f → X[f] f (ramification)',
  };

  /* ---------- Aléatoire reproductible ---------- */

  function rng(seed) {
    let a = seed >>> 0;
    return function () {
      a = (a + 0x6d2b79f5) | 0;
      let t = Math.imul(a ^ (a >>> 15), 1 | a);
      t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
  }

  function gauss(r) {
    let u = 0;
    while (u === 0) u = r();
    return Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * r());
  }

  function pick(r, p) {
    const u = r();
    let c = 0;
    for (let i = 0; i < p.length; i++) {
      c += p[i];
      if (u < c) return i;
    }
    return p.length - 1;
  }

  function normalizeRow(row) {
    const clean = row.map((v) => (Number.isFinite(v) && v > 0 ? v : 0));
    const s = clean.reduce((a, b) => a + b, 0);
    return s > 0 ? clean.map((v) => v / s) : [0, 1, 0, 0];
  }

  function normalizeMatrix(H) {
    return H.map(normalizeRow);
  }

  /* ---------- Algèbre linéaire minimale ---------- */

  function vecMat(v, M) {
    const out = new Array(M[0].length).fill(0);
    for (let i = 0; i < v.length; i++)
      for (let j = 0; j < out.length; j++) out[j] += v[i] * M[i][j];
    return out;
  }

  /* Loi stationnaire d'une matrice stochastique (itération de puissance). */
  function stationary(H, iters = 2000) {
    let v = new Array(H.length).fill(1 / H.length);
    for (let k = 0; k < iters; k++) {
      const w = vecMat(v, H);
      const s = w.reduce((a, b) => a + b, 0) || 1;
      v = w.map((x) => x / s);
    }
    return v;
  }

  /* Rayon spectral (racine de Perron) d'une matrice positive. */
  function perronRoot(M, iters = 3000) {
    let v = new Array(M.length).fill(1);
    let lambda = 0;
    for (let k = 0; k < iters; k++) {
      const w = vecMat(v, M);
      const s = w.reduce((a, b) => a + b, 0);
      if (s === 0) return 0;
      lambda = s / v.reduce((a, b) => a + b, 0);
      v = w.map((x) => x / s);
    }
    return lambda;
  }

  /* ---------- Simulation topologique (0L-system stochastique + Markov) ---------- */

  /*
   * params : {
   *   H: 4x4 (lignes = règle précédente B,C,D,E ; colonnes = règle suivante),
   *   h1: loi de la première règle tirée,
   *   iterations, seed,
   *   lateral: 'inherit' | 0..3  (état initial d'un bourgeon latéral créé par E),
   *   phyllo: {mean, sd}, branch: {mean, sd, min, max}, noise: {len, rad}
   * }
   * Chaque organe porte ses tirages aléatoires figés, de sorte que la géométrie
   * peut être recalculée à n'importe quel âge sans changer la topologie.
   */
  function simulate(params) {
    const H = normalizeMatrix(params.H);
    const h1 = normalizeRow(params.h1);
    const N = params.iterations | 0;
    const maxNodes = params.maxNodes || 40000;
    const r = rng(params.seed || 1);
    const ph = params.phyllo || { mean: 138.1, sd: 4 };
    const br = params.branch || { mean: 38, sd: 22, min: 15, max: 85 };
    const nz = params.noise || { len: 0.34 / 8, rad: 0.07 / 1.9 };
    const bendSd = params.bend == null ? 7 : params.bend; // courbure aléatoire de chaque entrenœud (°)

    const nodes = []; // {type: 'X'|'Y', birth, parent, lateral, roll, pitch, ln, rn}
    let buds = [{ node: -1, lateral: false, state: -1 }];
    const dead = []; // {node, at}
    const hist = { f: [1], g: [0], X: [0], Y: [0], rules: [[0, 0, 0, 0]] };
    let nX = 0, nY = 0, nG = 0, truncated = false, done = 0;

    function addNode(type, bud, n) {
      let pitch = 0;
      if (bud.lateral) {
        pitch = br.mean + br.sd * gauss(r);
        pitch = Math.max(br.min, Math.min(br.max, pitch));
      }
      nodes.push({
        type,
        birth: n,
        parent: bud.node,
        lateral: bud.lateral,
        roll: ph.mean + ph.sd * gauss(r),
        spin: r() * 360,
        bend: bendSd * gauss(r),
        pitch,
        ln: gauss(r) * nz.len,
        rn: gauss(r) * nz.rad,
      });
      return nodes.length - 1;
    }

    for (let n = 1; n <= N; n++) {
      if (nodes.length > maxNodes) { truncated = true; break; }
      const next = [];
      const rc = [0, 0, 0, 0];
      for (const bud of buds) {
        const p = bud.state < 0 ? h1 : H[bud.state];
        const j = pick(r, p);
        rc[j]++;
        if (j === 0) { dead.push({ node: bud.node, at: n }); nG++; continue; }
        if (j === 1) { next.push({ node: bud.node, lateral: bud.lateral, state: 1 }); continue; }
        if (j === 2) {
          const id = addNode('Y', bud, n); nY++;
          next.push({ node: id, lateral: false, state: 2 });
          continue;
        }
        const id = addNode('X', bud, n); nX++;
        const latState = params.lateral === 'inherit' || params.lateral == null ? 3 : params.lateral;
        next.push({ node: id, lateral: true, state: latState });
        next.push({ node: id, lateral: false, state: 3 });
      }
      buds = next;
      done = n;
      hist.f.push(buds.length); hist.g.push(nG); hist.X.push(nX); hist.Y.push(nY); hist.rules.push(rc);
    }

    // enfants : utile pour savoir quels nœuds portent un apex
    return { nodes, buds, dead, hist, iterations: done, requested: N, truncated, H, h1 };
  }

  /* ---------- Géométrie : tortue 3D + croissance sigmoïde ---------- */

  function sigmoid(K, a, r, t) {
    return K / (1 + a * Math.exp(-r * t));
  }

  /* Paramètres ajustés dans le mémoire (cm, âge en itérations). */
  const THESIS_GROWTH = {
    length: { K: 8, a: 7.85, r: 0.0075, sd: 0.34 },
    rb: { K: 1.9, a: 25.02, r: 0.0338, sd: 0.07 },
    rs: { K: 1.3, a: 18.89, r: 0.0385, sd: 0.06 },
  };

  function rotate(v, axis, deg) {
    // Rodrigues
    const t = (deg * Math.PI) / 180, c = Math.cos(t), s = Math.sin(t);
    const [x, y, z] = v, [u, w, k] = axis;
    const dot = u * x + w * y + k * z;
    return [
      x * c + (w * z - k * y) * s + u * dot * (1 - c),
      y * c + (k * x - u * z) * s + w * dot * (1 - c),
      z * c + (u * y - w * x) * s + k * dot * (1 - c),
    ];
  }
  function norm(v) {
    const l = Math.hypot(v[0], v[1], v[2]) || 1;
    return [v[0] / l, v[1] / l, v[2] / l];
  }
  function cross(a, b) {
    return [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
  }

  /*
   * Calcule les segments visibles à l'âge k (k <= iterations).
   * g = {growth: THESIS_GROWTH-like, ageScale, tropism, lengthScale}
   * Repère tortue : H (avant), L (gauche), U (haut). Axe vertical monde = +Y (Three.js).
   */
  function geometry(sim, k, g) {
    const G = g.growth || THESIS_GROWTH;
    const ageScale = g.ageScale == null ? 1 : g.ageScale;
    const trop = g.tropism || 0;
    const lscale = g.lengthScale || 1;
    const n = sim.nodes.length;
    const out = { segs: [], tips: [], bounds: [Infinity, -Infinity, Infinity, -Infinity, Infinity, -Infinity] };
    const frame = new Array(n);
    const end = new Array(n);
    const rootFrame = { H: [0, 1, 0], L: [-1, 0, 0], U: [0, 0, 1] };
    const hasChild = new Uint8Array(n);

    for (let i = 0; i < n; i++) {
      const nd = sim.nodes[i];
      if (nd.birth > k) continue;
      const pf = nd.parent < 0 ? rootFrame : frame[nd.parent];
      if (!pf) continue;
      if (nd.parent >= 0) hasChild[nd.parent] = 1;
      const start = nd.parent < 0 ? [0, 0, 0] : end[nd.parent];
      let { H, L, U } = pf;
      // phyllotaxie : rotation autour de l'axe de la tige (« @ » du mémoire)
      L = rotate(L, H, nd.roll); U = rotate(U, H, nd.roll);
      if (nd.lateral) {
        // angle de branchement « # »
        H = rotate(H, L, nd.pitch); U = rotate(U, L, nd.pitch);
      }
      if (nd.bend) {
        // courbure : l'entrenœud dévie d'un petit angle dans une direction quelconque
        // autour de son axe (angles « & » et « > » mesurés dans le mémoire)
        const ax = rotate(L, H, nd.spin || 0);
        H = norm(rotate(H, ax, nd.bend)); L = norm(rotate(L, ax, nd.bend)); U = norm(cross(H, L));
      }
      if (trop) {
        // tropisme : légère inclinaison de H vers la verticale (ou vers le sol si < 0)
        H = norm([H[0], H[1] + trop, H[2]]);
        L = norm(cross(U, H));
        U = norm(cross(H, L));
      }
      const t = (k - nd.birth) * ageScale;
      const len = Math.max(0.05, (sigmoid(G.length.K, G.length.a, G.length.r, t) + nd.ln * G.length.K) * lscale);
      const rb = Math.max(0.01, sigmoid(G.rb.K, G.rb.a, G.rb.r, t) + nd.rn * G.rb.K);
      const rs = Math.max(0.008, sigmoid(G.rs.K, G.rs.a, G.rs.r, t) + nd.rn * G.rs.K);
      const e = [start[0] + H[0] * len, start[1] + H[1] * len, start[2] + H[2] * len];
      frame[i] = { H, L, U };
      end[i] = e;
      out.segs.push({ i, type: nd.type, start, end: e, dir: H, len, rb, rs: Math.min(rs, rb), age: t, lateral: nd.lateral });
      const b = out.bounds;
      for (const p of [start, e]) {
        b[0] = Math.min(b[0], p[0]); b[1] = Math.max(b[1], p[0]);
        b[2] = Math.min(b[2], p[1]); b[3] = Math.max(b[3], p[1]);
        b[4] = Math.min(b[4], p[2]); b[5] = Math.max(b[5], p[2]);
      }
    }
    for (const s of out.segs) if (!hasChild[s.i]) out.tips.push(s);
    if (!out.segs.length) out.bounds = [0, 0, 0, 0, 0, 0];
    return out;
  }

  /* ---------- Espérances ---------- */

  /* Champ moyen du mémoire : h_n = h_1 H^(n-1), f_{n+1} = f_n (1 - h_B + h_E). */
  function thesisMeanField(H, h1, N) {
    H = normalizeMatrix(H); h1 = normalizeRow(h1);
    let h = h1.slice(), f = 1, g = 0, X = 0, Y = 0;
    const res = { f: [1], g: [0], X: [0], Y: [0] };
    for (let n = 1; n <= N; n++) {
      if (n > 1) h = vecMat(h, H);
      g += h[0] * f; Y += h[2] * f; X += h[3] * f;
      f = f * (1 - h[0] + h[3]);
      res.f.push(f); res.g.push(g); res.X.push(X); res.Y.push(Y);
    }
    return res;
  }

  /*
   * Matrice moyenne du processus de Galton–Watson multitype :
   * un bourgeon dans l'état i tire la règle j avec H_ij ;
   * j = B : 0 descendant ; C, D : 1 bourgeon d'état j ; E : 1 apical (E) + 1 latéral.
   */
  function meanMatrix(H, lateral) {
    H = normalizeMatrix(H);
    const lat = lateral === 'inherit' || lateral == null ? 3 : lateral;
    return H.map((row) => {
      const m = [0, row[1], row[2], row[3]];
      m[lat] += row[3];
      return m;
    });
  }

  function branchingExpectation(H, h1, N, lateral) {
    H = normalizeMatrix(H); h1 = normalizeRow(h1);
    const lat = lateral === 'inherit' || lateral == null ? 3 : lateral;
    const res = { f: [1], g: [0], X: [0], Y: [0] };
    // première itération depuis h1
    let v = [0, h1[1], h1[2], h1[3]];
    v[lat] += h1[3];
    let g = h1[0], X = h1[3], Y = h1[2];
    res.f.push(v.reduce((a, b) => a + b, 0)); res.g.push(g); res.X.push(X); res.Y.push(Y);
    const M = meanMatrix(H, lateral);
    for (let n = 2; n <= N; n++) {
      for (let i = 0; i < 4; i++) { g += v[i] * H[i][0]; Y += v[i] * H[i][2]; X += v[i] * H[i][3]; }
      v = vecMat(v, M);
      res.f.push(v.reduce((a, b) => a + b, 0)); res.g.push(g); res.X.push(X); res.Y.push(Y);
    }
    return res;
  }

  /* Taux de croissance asymptotique des bourgeons, selon les deux lectures. */
  function growthRates(H, lateral) {
    H = normalizeMatrix(H);
    const pi = stationary(H);
    return {
      stationary: pi,
      meanField: 1 - pi[0] + pi[3], // lecture du mémoire
      galtonWatson: perronRoot(meanMatrix(H, lateral)), // lecture « processus de branchement »
    };
  }

  /*
   * « Conditionnement Fibonacci » (perspective du mémoire) : on cherche un
   * facteur s qui multiplie la colonne E (le reste est pris sur C puis D, B fixe)
   * pour que le taux de Galton–Watson vaille la cible (φ par défaut).
   */
  function scaleE(H, s) {
    return normalizeMatrix(H).map((row) => {
      const free = 1 - row[0];
      const e = Math.min(free, row[3] * s);
      const rest = free - e;
      const cd = row[1] + row[2];
      const c = cd > 0 ? (rest * row[1]) / cd : rest;
      const d = cd > 0 ? (rest * row[2]) / cd : 0;
      return [row[0], c, d, e];
    });
  }
  function fitGrowthRate(H, target, lateral) {
    target = target || PHI;
    const rate = (s) => perronRoot(meanMatrix(scaleE(H, s), lateral), 600);
    let lo = 0, hi = 1;
    while (rate(hi) < target && hi < 1e4) hi *= 2;
    if (rate(hi) < target || rate(lo) > target) return null;
    for (let k = 0; k < 60; k++) {
      const mid = (lo + hi) / 2;
      if (rate(mid) < target) lo = mid; else hi = mid;
    }
    const s = (lo + hi) / 2;
    return { s, H: scaleE(H, s), rate: rate(s) };
  }

  /* ---------- Ajustement sigmoïde (méthode logit du mémoire) ---------- */

  function linreg(xs, ys) {
    const n = xs.length;
    const mx = xs.reduce((a, b) => a + b, 0) / n;
    const my = ys.reduce((a, b) => a + b, 0) / n;
    let sxy = 0, sxx = 0, syy = 0;
    for (let i = 0; i < n; i++) {
      sxy += (xs[i] - mx) * (ys[i] - my);
      sxx += (xs[i] - mx) ** 2;
      syy += (ys[i] - my) ** 2;
    }
    const slope = sxy / sxx;
    return { slope, intercept: my - slope * mx, r: sxy / Math.sqrt(sxx * syy) };
  }

  /*
   * Balaye K > max(y), linéarise logit(y/K) = r t − ln a, garde le K qui
   * maximise le coefficient de corrélation (éq. 2.165–2.167).
   */
  function fitSigmoid(ts, ys, opts) {
    opts = opts || {};
    const ymax = Math.max(...ys);
    const kMin = opts.kMin || ymax * 1.001;
    const kMax = opts.kMax || ymax * 6;
    const steps = opts.steps || 600;
    let best = null;
    for (let s = 0; s <= steps; s++) {
      const K = kMin * Math.pow(kMax / kMin, s / steps);
      const z = ys.map((y) => Math.log(y / K / (1 - y / K)));
      const fit = linreg(ts, z);
      if (!Number.isFinite(fit.r)) continue;
      if (!best || fit.r > best.rp) best = { K, r: fit.slope, a: Math.exp(-fit.intercept), rp: fit.r };
    }
    if (best) {
      const res = ys.map((y, i) => y - sigmoid(best.K, best.a, best.r, ts[i]));
      best.sd = Math.sqrt(res.reduce((a, b) => a + b * b, 0) / Math.max(1, res.length - 3));
    }
    return best;
  }

  /* ---------- Phase 3 : inférence inverse (ABC) ---------- */

  function binomial(r, n, p) {
    if (n <= 0 || p <= 0) return 0;
    if (p >= 1) return n;
    if (n < 40) { let k = 0; for (let i = 0; i < n; i++) if (r() < p) k++; return k; }
    const m = n * p, sd = Math.sqrt(n * p * (1 - p));
    return Math.max(0, Math.min(n, Math.round(m + sd * gauss(r))));
  }

  /* Galton–Watson rapide (comptages seulement), lignes de H identiques = h. */
  function gwCounts(h, N, r, cap) {
    let f = 1, X = 0, Y = 0, g = 0;
    for (let n = 0; n < N && f > 0; n++) {
      let left = f;
      const nB = binomial(r, left, h[0]); left -= nB;
      const nC = binomial(r, left, h[1] / Math.max(1e-12, 1 - h[0])); left -= nC;
      const nD = binomial(r, left, h[2] / Math.max(1e-12, 1 - h[0] - h[1])); left -= nD;
      const nE = left;
      g += nB; Y += nD; X += nE;
      f = nC + nD + 2 * nE;
      if (f > cap) return null;
    }
    return { f, X, Y, g };
  }

  function dirichlet1(r, k) {
    const x = [];
    for (let i = 0; i < k; i++) { let u = 0; while (u === 0) u = r(); x.push(-Math.log(u)); }
    const s = x.reduce((a, b) => a + b, 0);
    return x.map((v) => v / s);
  }

  /*
   * ABC par rejet : tire h ~ Dirichlet(1,1,1,1), simule, garde les plus proches
   * des comptages observés (distance euclidienne sur log(1+·) des comptages
   * fournis parmi X, Y, f vivants, g morts).
   * Retourne un générateur pour l'exécution par tranches dans l'interface.
   */
  function* abc(obs, N, sims, seed, cap) {
    const r = rng(seed || 7);
    const all = [];
    for (let s = 0; s < sims; s++) {
      const h = dirichlet1(r, 4);
      const c = gwCounts(h, N, r, cap || 20000);
      if (c) {
        let d2 = 0;
        for (const k of ['X', 'Y', 'f', 'g']) if (obs[k] != null) d2 += (Math.log1p(c[k]) - Math.log1p(obs[k])) ** 2;
        const d = Math.sqrt(d2);
        all.push({ h, d, c });
      }
      if (s % 250 === 249) yield { progress: (s + 1) / sims, all };
    }
    yield { progress: 1, all, done: true };
  }

  function abcSummary(all, keepFrac) {
    const sorted = all.slice().sort((a, b) => a.d - b.d);
    const keep = sorted.slice(0, Math.max(5, Math.floor(sorted.length * (keepFrac || 0.02))));
    const mean = [0, 0, 0, 0], sd = [0, 0, 0, 0];
    for (const k of keep) for (let i = 0; i < 4; i++) mean[i] += k.h[i] / keep.length;
    for (const k of keep) for (let i = 0; i < 4; i++) sd[i] += (k.h[i] - mean[i]) ** 2 / keep.length;
    return { keep, mean, sd: sd.map(Math.sqrt), eps: keep[keep.length - 1].d };
  }

  /* ---------- Exports ---------- */

  function toMaxScript(geo) {
    // Repère 3ds Max : Z vertical. Three.js : Y vertical -> (x, -z, y)
    const P = (p) => `[${p[0].toFixed(3)},${(-p[2]).toFixed(3)},${p[1].toFixed(3)}]`;
    const lines = [
      '-- Généré par l\'Atelier Morphogenèse (L-system stochastique + Markov)',
      '-- Unités : cm. Coller dans le MAXScript Listener de 3ds Max.',
      'branche = #()',
    ];
    for (const s of geo.segs) {
      const col = s.type === 'X' ? '(color 214 120 40)' : '(color 110 84 52)';
      lines.push(
        `c = Cone radius1:${s.rb.toFixed(3)} radius2:${s.rs.toFixed(3)} height:${s.len.toFixed(3)} sides:8 heightsegs:1 pos:${P(s.start)} wirecolor:${col}; c.dir = ${P(s.dir)}; append branche c`
      );
    }
    lines.push('group branche name:"BrancheOranger"');
    return lines.join('\n');
  }

  function toOBJ(geo) {
    const v = [], l = [];
    geo.segs.forEach((s, i) => {
      v.push(`v ${s.start.map((x) => x.toFixed(4)).join(' ')}`);
      v.push(`v ${s.end.map((x) => x.toFixed(4)).join(' ')}`);
      l.push(`l ${2 * i + 1} ${2 * i + 2}`);
    });
    return ['# Squelette de branche — Atelier Morphogenèse', 'o branche', ...v, ...l].join('\n');
  }

  function toLString(sim) {
    // Chaîne formelle (sans paramètres) reconstruite depuis l'arbre
    const kids = sim.nodes.map(() => []);
    const budsAt = new Map();
    sim.nodes.forEach((nd, i) => { if (nd.parent >= 0) kids[nd.parent].push(i); });
    const roots = sim.nodes.map((nd, i) => (nd.parent < 0 ? i : -1)).filter((i) => i >= 0);
    for (const b of sim.buds) budsAt.set(b.node, (budsAt.get(b.node) || 0) + 1);
    let out = '';
    function walk(i, depth) {
      if (out.length > 20000) return;
      out += sim.nodes[i].type;
      const ch = kids[i];
      const lat = ch.filter((c) => sim.nodes[c].lateral);
      const api = ch.filter((c) => !sim.nodes[c].lateral);
      for (const c of lat) { out += '['; walk(c, depth + 1); out += ']'; }
      const nb = budsAt.get(i) || 0;
      if (!api.length && nb) out += 'f';
      for (const c of api) walk(c, depth);
    }
    for (const r0 of roots) walk(r0, 0);
    if (!roots.length) out = sim.buds.length ? 'f' : 'g';
    return out.length > 20000 ? out.slice(0, 20000) + '…' : out;
  }

  /* ---------- Phase 2 : patronage enfant gradé par croissance ---------- */

  /*
   * Mensurations enfant modélisées en logistique de l'âge (années).
   * VALEURS ILLUSTRATIVES calées sur 4 points d'ordre de grandeur ; à recaler
   * sur une campagne anthropométrique réelle avec fitSigmoid().
   */
  const CHILD_GROWTH = {
    stature: { K: 180, a: 1.635, r: 0.2013, label: 'Stature' },
    chest: { K: 100, a: 1.147, r: 0.1088, label: 'Tour de poitrine' },
    backLen: { K: 50, a: 1.606, r: 0.1162, label: 'Longueur dos' },
    shoulder: { K: 16, a: 1.568, r: 0.0992, label: 'Longueur d\'épaule' },
    neck: { K: 40, a: 0.7136, r: 0.0867, label: 'Tour de cou' },
  };

  function measuresAt(age, model) {
    model = model || CHILD_GROWTH;
    const m = {};
    for (const k in model) m[k] = sigmoid(model[k].K, model[k].a, model[k].r, age);
    return m;
  }

  function sigmoidRate(p, t) {
    const y = sigmoid(p.K, p.a, p.r, t);
    return p.r * y * (1 - y / p.K);
  }

  /*
   * Demi-devant de tee-shirt / corsage de base (cm, y vers le bas, milieu devant en x = 0).
   * Construction simplifiée pédagogique (type bloc enfant).
   */
  function frontBlock(m, opts) {
    opts = opts || {};
    const ease = opts.ease == null ? 8 : opts.ease;
    const hem = opts.hem == null ? 0 : opts.hem;
    const neckW = m.neck / 6 + 0.5;
    const neckD = m.neck / 6 + 1.5;
    const drop = Math.max(1.5, m.shoulder * 0.24);
    const W = m.chest / 4 + ease / 4;
    const armD = m.chest / 8 + 6;
    const waist = m.backLen + 1;
    const length = waist + m.stature * 0.09;
    const spx = neckW + Math.sqrt(Math.max(0, m.shoulder ** 2 - drop ** 2));
    const P = {
      snp: [neckW, 0], sp: [spx, drop], arm: [W, armD], sideHem: [W + 0.8, length + hem],
      cfHem: [0, length + hem], cfNeck: [0, neckD],
    };
    const f = (p) => `${p[0].toFixed(2)} ${p[1].toFixed(2)}`;
    const c1 = [spx - 0.6, drop + (armD - drop) * 0.5];
    const c2 = [spx + (W - spx) * 0.25, armD];
    const n1 = [neckW * 0.55, neckD];
    const n2 = [neckW, neckD * 0.45];
    const d = `M ${f(P.snp)} L ${f(P.sp)} C ${f(c1)} ${f(c2)} ${f(P.arm)} L ${f(P.sideHem)} L ${f(P.cfHem)} L ${f(P.cfNeck)} C ${f(n1)} ${f(n2)} ${f(P.snp)} Z`;
    return { d, P, W, armD, waist, length: length + hem, neckW, neckD, width: W + 0.8 };
  }

  /* Âge auquel une mensuration logistique atteint y (inverse de la sigmoïde). */
  function ageFor(p, y) {
    return Math.log(p.a / (p.K / y - 1)) / p.r;
  }

  /*
   * Tailles enfant européennes (EN 13402) : la taille EST la stature en cm.
   * Durée de port d'une taille = temps pour que la stature gagne un pas de taille,
   * déduit de l'inverse de la logistique. On en tire la probabilité de changer de
   * taille en 6 mois (temps de séjour exponentiel → chaîne de Markov des tailles)
   * et la réserve d'ourlet à prévoir pour couvrir toute la durée de port.
   */
  function sizeTable(sizes, model) {
    model = model || CHILD_GROWTH;
    return sizes.map((size, i) => {
      const age = ageFor(model.stature, size);
      const next = sizes[i + 1] == null ? size + (size - sizes[i - 1]) : sizes[i + 1];
      const nextAge = next < model.stature.K ? ageFor(model.stature, next) : age + 3;
      const years = nextAge - age;
      const m = measuresAt(age, model);
      const pMove6m = 1 - Math.exp(-0.5 / years);
      const hemReserve = frontBlock(measuresAt(nextAge, model)).length - frontBlock(m).length;
      return { size, age, m, rate: sigmoidRate(model.stature, age), months: years * 12, pMove6m, hemReserve };
    });
  }

  return {
    PHI, RULES, RULE_TEXT, THESIS_GROWTH, CHILD_GROWTH,
    rng, gauss, normalizeRow, normalizeMatrix, stationary, perronRoot,
    simulate, geometry, sigmoid, thesisMeanField, branchingExpectation, meanMatrix,
    growthRates, fitGrowthRate, scaleE, fitSigmoid, linreg,
    gwCounts, abc, abcSummary, toMaxScript, toOBJ, toLString,
    measuresAt, sigmoidRate, ageFor, frontBlock, sizeTable,
  };
});
