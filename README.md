# Strat Tester BO2

## [**Donwload**](https://github.com/Fraagaa/Strat-Tester-BO2/releases/latest/download/Strat.Tester.BO2.rar)

## Chat Commands
- `!tpc` teleports player to desired coordinates
- `!tp` teleports player to desired location
- `!drops` enables drops
- `!power` toggles between power and no power
- `!boards` toggles opening window's boards
- `!doors` toggles oppening all necesary doors
- `!weapons` toggles spawning with weapons
- `!perks` toggles spawning with perks / reviving with perks
- `!round` changes initial round
- `!depart` changes bus depart time on farm
- `!delay` changes delat at the start of the round
- `!buried` toggles buildable setup on buried
- `!zone` toggles zone name
- `!remaining` toggles zombie counter
- `!traptimer` toggles traptimer on mob
- `!wm` toggles getting war machine on origins
- `!healthbar` toggles healthbar
- `!timer` changes timer position or hides it
- `!cherry` toggles getting cherry in origins
- `!perkrng` toggles autorestart for pap on green house
- `!lives` toggles infinite afterlives
- `tank` toggles tank kill counter on origins
- `tumble` toggles tumble counter on origins
- `stomp` toggles stomp counter on origins
- `templars` starts a templar round if more than 3 generator are on

## TP locations for !tp
| **Map**     | **Tranzit**            | **Die Rise**   | **MOB**     | **Buried**   | **Origins**      |
|--------------|------------------------|----------------|-------------|--------------|------------------|
| **Location**| `farm` `town` `dinner` `tunel` `depot` `power` `bus` `natch` | `shaft` `tramp` | `cafe` `cage` `fans` `dt` | `saloon` `jug` `tunel` | `church` `tcp` `gen2` `tank` |

## General changed
- Perks are given on spawn
- Weapons are given on spawn
- All doors are oppened (except the ones needed for a certain strat)
- Game starts at round 100
- Game, round and trap timers
- Healthbar
- Zombie counter
- Zone display
- Seconds per horde meter

### Weapons given for each player on each map

| Mapa       | White                                                                             | Blue                                                                    | Green                                                 | Yellow                                                 |
|------------|--------------------------------------------------------------------------------|-----------------------------------------------------------------|-----------------------------------------------|-----------------------------------------------|
| Tranzit    | `Sallys` `M16 upgraded` `JetGun` `EMPs` `Claymores` `Galvaknuckels` | `Sallys` `M16 upgraded` `EMPs` `Claymores` `Galvaknuckels` | `Sallys` `M16 upgraded` `EMPs` `Claymores` `Galvaknuckels` | `Sallys` `M16 upgraded` `EMPs` `Claymores` `Galvaknuckels` |
| Depot      | `Chicom` `Raygun Mark 2` `Monkeys`                            | `Chicom` `Raygun` `Monkeys`                 | `Chicom` `Raygun` `Monkeys`                 | `Chicom` `Raygun` `Monkeys`                 |
| Farm       | `Chicom` `Raygun Mark 2` `Monkeys` `Galvaknuckels`         | `Chicom` `Raygun` `Monkeys`                 | `Chicom` `Raygun` `Monkeys`                 | `Chicom` `Raygun` `Monkeys`                 |
| Town       | `Sallys` `Raygun Mark 2 upgraded` `Semtex` `Monkeys` `Galvaknuckels` | `Sallys` `Raygun upgraded` `Semtex` `Monkeys` `Galvaknuckels` | `Sallys` `Raygun upgraded` `Semtex` `Monkeys` `Galvaknuckels` | `Sallys` `Raygun upgraded` `Semtex` `Monkeys` `Galvaknuckels` |
| NukeTown   | `Sallys` `Raygun Mark 2 upgraded` `Monkeys`                   | `Sallys` `Raygun upgraded` `Monkeys`                 | `Sallys` `Raygun upgraded` `Monkeys`                 | `Sallys` `Raygun upgraded` `Monkeys`                 |
| Die Rise   | `Sallys` `Sliquifire` `AN94 upgraded` `Monkeys` `Semtex` `Galvaknuckels` `Claymores` `Springpad` | `Sallys` `AN94 upgraded` `Monkeys` `Semtex` `Galvaknuckels` `Claymores` `Springpad` | `Sallys` `AN94 upgraded` `Monkeys` `Semtex` `Galvaknuckels` `Claymores` `Springpad` | `Sallys` `AN94 upgraded` `Monkeys` `Semtex` `Galvaknuckels` `Claymores` `Springpad` |
| Mob        | `Acidgat` `Raygun Mark 2 upgraded` `Shield` `Claymores` `Tomahawk` | `Sallys` `Acidgat` `Shield` `Claymores` `Tomahawk` | `Sallys` `Uzi` `Shield` `Claymores` `Tomahawk` | `Sallys` `Uzi` `Shield` `Claymores` `Tomahawk` |
| Buried     | `Sallys` `Paralyzer` `Raygun Mark 2 upgraded` `Monkeys` `Claymores` `Galvaknuckels` | `Raygun Mark 2 upgraded` `Sallys` `Monkeys` `Claymores` `Galvaknuckels` | `Raygun Mark 2 upgraded` `Sallys` `Monkeys` `Claymores` `Galvaknuckels` | `Raygun Mark 2 upgraded` `Sallys` `Monkeys` `Claymores` `Galvaknuckels` |
| Origins    | `Raygun Mark 2 upgraded` `Air Staff or Ice Staff` `Shield` `Semtex` `Monkeys` | `Boomhilda` `MP40` `Ice Staff` `Shield` `Semtex` `Monkeys` | `Boomhilda` `MP40` `Fire Staff` `Shield` `Semtex` `Monkeys` | `Boomhilda` `MP40` `Lightning Staff` `Shield` `Semtex` `Monkeys` |

## Changes by map
### Tranzit
- Display at the top left of the screen indicating the ammount of time it takes for the bus to depart from farm.

### Nuketown
- All perks fall from the sky at the start of the game
- Can automatically restart for pap on green house with !perkrng

### Die Rise
- Spawned trample steam buildable

### MOTD
- White player will be teleported to the necesary afterlife switches to be able to shock them and pick up the key
- Spawned shield buildable at cafeteria
- Infinite afterlives, can be switched off with !lives

### Buried
- 2 buildable setups:
- Resonator at jug, Turbine at church and Springpad at saloon (default)
- Resonator at saloon, Turbine at church and Springpad at jug

### Origins
- White player starts with shovel and golden helmet
- Players are able to call tank from gen 2 for the first time
- Spawned shield buildable at church
- Awarded max ammo reward for each player
- Staffs are placed in the crazy place
- All portals are oppened
- Trackers for zombies stopmpt and tumbled
- Tracker for tank kills (does not count the flamethrower kills) (can be turned on with !tank)
