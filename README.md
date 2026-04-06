# Procedural-3D-Terrain-Generator
Procedural 3D terrain generator for Roblox using noise-based heightmaps, biome coloring, and chunk-based loading around the player.

This project is a Roblox terrain generation system that creates a large, explorable 3D map using noise-based height values and chunk-based loading. Terrain blocks are generated dynamically around the player, allowing the world to expand as the player moves, while older chunks are removed to reduce unnecessary memory usage.
The generator uses math.noise() to produce height variation and biome values, which control terrain elevation and color distribution across the map. This creates a more natural-looking world with large-scale variation instead of a flat repeated grid.
The system is designed as a simple procedural world framework that demonstrates chunk generation, chunk deletion, biome-based terrain styling, and dynamic map streaming around the player.
