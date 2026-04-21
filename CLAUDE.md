# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

"I made this Game in 3 Days" is a Godot 4.4 roguelike-style arena survival game with Steam integration. Players fight endless waves of enemies with upgradeable abilities in a fast-paced top-down action style similar to Vampire Survivors.

## Development Setup

### Prerequisites
- Godot 4.4+ (project migrated from earlier versions to 4.4.1)
- Steam SDK (for development with achievements)
- MacOS/Windows/Linux with appropriate build tools

### Running the Game
```bash
# Open project in Godot editor
godot project.godot

# Run the game in editor (press F5 or click "Play" button)
# Or run exported binary from Downloads folder
```

### Building & Exporting
Godot projects export through the editor UI: **Project > Export**

Three export presets are configured:
- **Windows Desktop**: x86_64, embedded PCK, outputs to ~/Downloads/win/
- **macOS**: Universal binary, notarized, outputs to ~/Downloads/I made this Game in 3 Days.dmg
- **Linux/X11**: x86_64, embedded PCK, outputs to ~/Downloads/linux/

**Mac Export Notes:** To fix Steam achievements on macOS, disable codesigning and follow https://godotsteam.com/tutorials/mac_export/

## Architecture Overview

### Scene Hierarchy
The game uses a three-tier structure:

1. **SceneHolder** (res://scenes/core/SceneHolder.tscn)
   - Root node that holds and restarts the main game scene
   - Manages game resets via `restart_game()` method
   - Entry point specified in project.godot

2. **Main** (res://scenes/core/Main.tscn)
   - Contains all active gameplay systems: player, enemies, UI, camera, music
   - Instantiated/destroyed on restart

3. **ProgressionTracker** (Autoload)
   - Global singleton managing all progression state
   - Accessible from any script via `/root/ProgressionTracker`
   - Tracks monster spawn rates, speeds, and all player upgrade values
   - Initializes Steam API on startup

### Key Systems & Responsibilities

**Player System** (scenes/entities/player.gd)
- Movement via WASD/arrows + gamepad (smooth acceleration via exponential lerp)
- HP/XP/level management (max level 8 per session)
- Triggers upgrade UI at level 8
- Spawns swords (projectiles) on level-up
- Added to "player" group for global access

**Attack System** (scenes/animation/AttackController.gd)
- Queries enemies within `player_attack_range_finder` range
- Sorts by distance, attacks closest
- Spawns axe animations on cooldown (cooldown scales with `player_axe_attack_speed`)
- Axe size and animation speed scale with progression stats

**Enemy System** (scenes/entities/enemy.gd)
- Spawned by EnemySpawner at fixed intervals around player
- Follows player with speed from ProgressionTracker
- Knockback on player collision (1000 units/sec propel)
- Self-removes after hitting player
- Added to "enemy" group for range queries

**Projectile Weapon System** (scenes/animation/SwordShooting.gd)
- Player spawns swords on level-up (count from ProgressionTracker)
- Each sword orbits at random distance, accelerating toward target position
- Attacks enemies on collision, awards XP (amount scales with sword count)
- Demonstrates exponential lerp for smooth movement

**UI/Progression** (scenes/ui/)
- Main HUD shows health, XP, level (updated via signal from player)
- Upgrade selection screen appears every 8 levels (pauses game tree)
- Pause screen for game over/restart
- Game timer triggers monster upgrades every 30 seconds
- Steam achievement unlocks on 30-second intervals (0:30, 1:00, etc. up to 10:00)

**Camera** (scenes/core/GameCamera.gd)
- Smooth follow-cam tracking player with exponential lerp
- CAMERA_SMOOTHNESS = 15 (higher = less smooth)

### Physics Layers
The project uses 6 physics layers (2D):
1. TERRAIN - Static terrain
2. PLAYER - Player character
3. ENEMY - Enemy characters  
4. ENEMY_COLLISION - Enemy detection for collision
5. ATTACK - Axe/projectile hitboxes
6. ITEM - Future item pickups

### Display & Input
- **Viewport:** 640x360 (internal resolution)
- **Display:** Scales to 1920x1080 window via viewport stretching
- **Input Actions:** move_up, move_down, move_left, move_right, pause (all support keyboard + joypad)

## Code Patterns & Conventions

### Accessing Global State
ProgressionTracker is accessible globally—use it to modify game balance:
```gdscript
var speed = get_node("/root/ProgressionTracker").player_movement_speed
get_node("/root/ProgressionTracker").upgrade_player(PlayerUpgradeType.PLAYER_UPGRADE.MOVEMENT_SPEED)
```

### Node Groups
- `"player"` - Single player node, queried by enemies and attacks
- `"enemy"` - All active enemies, queried by AttackController for range

### Smooth Movement & Animations
Uses exponential lerp instead of linear: `lerp(target, 1 - exp(-delta * smoothing))`
- Player movement: ACCELERATION_SMOOTHING = 30
- Camera: CAMERA_SMOOTHNESS = 15
- Swords: ACCELERATION_SPEED = 5

This creates organic, physics-like smoothing regardless of frame rate.

### Upgrade System
PlayerUpgradeType enum defines 6 upgrades: AXE_SIZE, AXE_ATTACK_SPEED, MOVEMENT_SPEED, NUM_OF_SWORDS_SPAWN, ATTACK_RANGE_FINDER, HP_REGEN

Each upgrade tier scales by fixed amounts (e.g., axe size += 0.1, movement += 15). The UpgradeSelectionUI randomly picks 3 from 6 on level 8.

### Deferred Calls
Swords spawn deferred (`Callable(spawn_sword).call_deferred()`) during level-up to avoid frame hitches when spawning multiple projectiles.

## File Structure

```
scenes/
├── core/
│   ├── SceneHolder.tscn/gd      # Root scene holder
│   ├── Main.tscn                # Main game scene
│   ├── ProgressionTracker.tscn/gd  # Autoload singleton
│   ├── GameCamera.tscn/gd       # Camera system
│   └── MusicPlayer.tscn/gd      # Music cycling
├── entities/
│   ├── player.tscn/gd           # Player character
│   ├── enemy.tscn/gd            # Enemy character
│   └── EnemySpawner.tscn/gd     # Enemy wave spawner
├── animation/
│   ├── AttackController.tscn/gd # Axe attack system
│   ├── AttackAnimation.tscn/gd  # Axe animation/hitbox
│   └── SwordShooting.tscn/gd    # Projectile sword
└── ui/
    ├── UI.tscn/gd              # Main HUD
    ├── UpgradeSelectionUI.tscn/gd  # Upgrade picker
    ├── UpgradePanel.tscn/gd    # Single upgrade button
    └── PausedScreen.tscn/gd    # Game over/pause screen

assets/
├── audio/                       # 3 background tracks (Kim Lightyear)
└── (sprites)                    # player.png, enemy.png, sword.png, axe.png, etc.

addons/
└── godotsteam/                  # GodotSteam plugin (Windows/Mac/Linux native libs)

resources/
(Custom resource types if added)
```

## Common Development Tasks

### Adding a New Upgrade
1. Add enum variant to `PlayerUpgradeType.PLAYER_UPGRADE`
2. Add case in `ProgressionTracker.upgrade_player()` with scaling value
3. Add `Upgrade.new()` entry in `UpgradeSelectionUI.possible_upgrades`

### Adjusting Game Balance
Edit ProgressionTracker.reset() for initial values, and upgrade functions for scaling per level:
- Monster spawn rate: `monster_spawn_timer_timeout /= 1.5` (exponential scaling)
- Monster speed: `monster_movement_speed += 9` (linear scaling)
- Player stats: Each upgrade has a fixed increment (e.g., movement_speed += 15)

Tweak exponential vs linear to change difficulty curve.

### Testing Gameplay Loops
- Press F5 in editor to run; use Godot's built-in pause/inspector to debug
- Check ProgressionTracker node in running game to see current stat values
- Modify player level directly in inspector to test upgrade UI

### Modifying Difficulty (Monster Spawn & Upgrades)
Edit `EnemySpawner.spawn_enemy()` for spawn pattern and `UI.check_monsters_upgrade()` for upgrade frequency. Currently monsters upgrade every 30 seconds; tweak MONSTER_UPGRADE_INTERVAL in UI.gd.

## Steam Integration

### Achievements
- Defined in Steam backend (not in code); achievements are numeric: "000", "030", "060", etc.
- Unlocked by `UI.handle_steam_achievments()` at 30-second intervals (30s, 60s, ..., 600s)
- Synced via `Steam.storeStats()`

### API Initialization
`ProgressionTracker._initialize_Steam()` calls `Steam.steamInit(false)` on startup. Prints whether Steam initialized.

### Testing Achievements
Requires running under Steam (steam_appid.txt = 2556730). Not testable in Godot editor without Steam client.

## Git Workflow

Project uses standard git flow. Recent notable commits:
- "migrated to godot 4.4.1" - Engine version bump
- "fixed restart crash bug" - Bug fixes related to scene cleanup
- "achievments are working! :)" - Steam integration milestone
- "core gameplay done" - Feature completeness marker

## Known Constraints & Workarounds

1. **Scene Cleanup on Restart:** SceneHolder explicitly removes children before re-instantiating Main (crashes without this step).
2. **Mac Export:** Codesigning must be disabled for Steam achievements to work; follow godotsteam.com tutorial.
3. **Deferred Sword Spawning:** Swords spawn deferred during level-up to avoid frame drops on rapid multi-sword spawns.
4. **No Custom Build System:** Builds only via Godot editor export (no Makefile/CI-CD).

## Debugging Tips

- **View ProgressionTracker state:** In running game, inspect the ProgressionTracker node to see current upgrade values
- **Check enemy spawn:** Modify EnemySpawner.SPAWN_RADIUS to adjust spawn distance
- **Monitor FPS/profiling:** Use Godot's built-in profiler (Debug > Monitor)
- **Physics layer issues:** Verify collision layer/mask settings in each entity's PhysicsBody2D properties
