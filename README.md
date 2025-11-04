Catalyst World — Full Concept (Final)
Visi singkat

Menjadi suite produksi environment terpadu untuk Roblox: sculpt, paint, populate, light, dan optimize dunia skala kecil sampai open-world — semua dalam satu plugin profesional yang cepat, cerdas, dan skalabel.

Slogan

“Create Immersive Worlds — Faster, Smarter, Limitless.”

Modul Utama (4) + Opsional (1)

TERRAFORM — Sculpting & Terrain Painting (non-destructive + procedural)

BIOME PAINTER — Smart asset & foliage scattering (preset, rules, ecosystem logic) — killer feature

ATMOSEQUENCER — Lighting / Sky / Weather timeline & bake-to-script

WORLD OPTIMIZER — Chunking, LOD, batching, streaming (performance engine)

WORLDBANK (opsional) — marketplace/preset sharing & team sync

Fitur Detail per Modul
1) TERRAFORM — The Sculptor

Layered Procedural Terrain: layer-based workflow (noise, mask, erosion) — non-destructive, reorderable.

Alpha & AI-Adaptive Brushes: gunakan grayscale alpha untuk bentuk kompleks + brush yang extend style dari contoh sculpt.

River/Lake Generator: spline → auto-carve riverbed + place water + shore props (stones, reeds).

Part-to-Terrain (3 modes): Precision / Game-Ready / Hybrid (gabungkan mesh & voxel).

Slope-Based Material Paint: rules: material by slope thresholds, auto-apply saat sculpt/paint.

Masking & Snap: mask area, snap to grid/curve, sample terrain to copy style.

2) BIOME PAINTER — The Artist (Core differentiator)

Biome Presets: list aset dengan bobot; drag & drop model + weight sliders.

Eco-Logic Placement: rules per-aset—slope filter, material filter, proximity rules, spawn-chains (e.g., root → pebble cluster).

Randomization: size range, rotation Y, per-axis random scale, deterministic seed.

Smart Alignment: Force Y-Up for trees; Align-to-Normal for rocks.

Biome Layers: multi-layer painting (forest, groundcover, detritus) dengan opacity/density.

Preview & Cost HUD: live preview + estimate instance count & perf risk before commit.

Optimization Pipeline: auto-chunk, group-merge, optional bake-to-prefab chunks.

Undo/Redo & Snapshot: safe iterative workflow + preview mode vs commit (Bake).

3) ATMOSEQUENCER — The Director

Multi-Track Timeline: Lighting, Atmosphere, Sky, Weather, SFX, PostProcessing tracks.

Preset Library: 50+ pro presets (sunrise, storm, cyberpunk night, desert noon).

Dynamic Weather: rain (wetness, puddles), snow (accumulation), storms (lightning + sound).

Interpolation & Blend Modes: linear / ease / curve / cinematic noise blends.

Bake to Runtime: export ModuleScript (or Flamework component) that interpolates at runtime + references assets (particles, sounds).

Preview in Editor: scrub timeline & preview in-scene.

4) WORLD OPTIMIZER — The Engine

Chunking & Streaming: group assets per grid; load/unload by distance.

LOD Generation: auto LOD pipeline (full → lowpoly → billboard).

Mesh Combining / Static Batching: combine static geometry into fewer meshes.

Runtime Spawn Strategy: server-authoritative + client streaming to avoid huge initial spawn.

Performance Tools: profiler HUD, quick rebake, bulk-merge suggestions.

5) WORLDBANK (Opsional)

Shareable Presets: export/import Biome / Atmo / Terraform presets (ModuleScript/JSON).

Marketplace: buy/sell pro presets, community hub.

Team Sync: cloud masks/presets for collaborative workflows.

Arsitektur Teknis Inti (implementable)

Data-driven: Preset disimpan sebagai ModuleScript/JSON — mudah version control & share.

Preview vs Commit: semua painting default ke preview buffer; Bake membuat persistent instances/chunks.

Seeded RNG: deterministic painting (reproducible across builds).

Non-destructive Layers: every major change can be toggled/disabled.

Client/Server Split: heavy generation tooling runs in plugin/editor; runtime streaming uses chunk metadata to spawn efficiently.

Plugin API: expose API (Lua) untuk integrasi pipeline/game frameworks.

Contoh Workflow (user-friendly)

Import heightmap / rough-sculpt terrain.

Use Alpha Brush untuk detail; draw spline untuk sungai → auto-carve + fill.

Select Biome Preset “Pine Forest”, tweak density & slope filters, paint area (preview shows placements).

Optimize: run Auto-Optimize (chunk + LOD suggestions).

Create Atmosequence timeline (06:00 sunrise → 12:00 clear → 18:00 storm clip).

Bake: export ModuleScript + chunk assets → integrate into game.
