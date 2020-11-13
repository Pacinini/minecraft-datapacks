# # # Passive Protection - Bzlbzlbzl # # #

#Increments timer by 1, resets at 20; increment's sheep timer by 1, resets at 10
scoreboard players add %timer p_prot_id 1
execute if score %timer p_prot_id matches 20 run scoreboard players set %timer p_prot_id 0
scoreboard players add @e[type=sheep,tag=pProt] p_mod 1
execute as @e[type=sheep,tag=pProt] if score @s p_mod matches 40 run scoreboard players set @s p_mod 0

#Tags all pAI with toKill and then removes it if there is no pProt mob with their score (their pProt mob died); ((in this case, unless is not the inverse of if, so I have to do it this way))
tag @e[tag=pAI] add toKill
execute as @e[tag=pAI] at @e[tag=pProt] if score @e[tag=pProt,limit=1,sort=nearest] p_prot_id = @s p_prot_id run tag @s remove toKill

#Tags all non-cat pAI mobs toKill if cat pAI of same score exists (fixes duplication bug); REMOVE pChill lines if laggy (will be chaotic anyways); (I don't care about invisble baby cat case, doesn't matter)
execute as @e[tag=pAI,type=!cat] at @e[tag=pAI,type=cat] if score @e[tag=pAI,type=cat,limit=1,sort=nearest] p_prot_id = @s p_prot_id run tag @s add toKill
execute as @e[tag=pAI,type=zombie] at @e[tag=pAI,type=cat] if score @e[tag=pAI,type=cat,limit=1,sort=nearest] p_prot_id = @s p_prot_id run tag @s add pChill
execute as @e[tag=pAI,type=sheep] at @e[tag=pAI,type=cat] if score @e[tag=pAI,type=cat,limit=1,sort=nearest] p_prot_id = @s p_prot_id run tag @s add pChill

#Tags (all) nearby mobs with pCapture; removes pCapture if too far away
execute as @a[team=p-prot,gamemode=!spectator] at @s run tag @e[type=cow,distance=..8,tag=!pProt,nbt={Age:0},tag=!pCapture] add pCapture
execute as @a[team=p-prot,gamemode=!spectator] at @s run tag @e[type=pig,distance=..8,tag=!pProt,nbt={Age:0},tag=!pCapture] add pCapture
execute as @a[team=p-prot,gamemode=!spectator] at @s run tag @e[type=sheep,distance=..8,tag=!pProt,nbt={Age:0,Sheared:0b},tag=!pCapture] add pCapture
execute as @e[tag=pCapture] at @s unless entity @a[team=p-prot,distance=..8,limit=1,sort=nearest,gamemode=!spectator] run tag @s remove pCapture

#Resets p_sneak if no pCapture mobs within radius; kills armor stand; restores NoAI; removes pCapturing (NoAI is 1..40 because pProt mob will have NoAI if capture successful)
execute as @a[team=p-prot,scores={p_sneak=1},gamemode=!spectator] at @s unless entity @e[tag=pCapture,distance=..8,sort=nearest,limit=1] run scoreboard players set @s p_sneak 0
execute as @a[team=p-prot,scores={p_sneak=2..40},gamemode=!spectator] at @s unless entity @e[tag=pCapturing,distance=..8,sort=nearest,limit=1] run data modify entity @e[tag=pCapturing,limit=1,sort=nearest] NoAI set value 0b
execute as @a[team=p-prot,scores={p_sneak=2..},gamemode=!spectator] at @s unless entity @e[tag=pCapturing,distance=..8,sort=nearest,limit=1] run kill @e[tag=pParticle,limit=1,sort=nearest]
execute as @a[team=p-prot,scores={p_sneak=2..},gamemode=!spectator] at @s unless entity @e[tag=pCapturing,distance=..8,sort=nearest,limit=1] run tag @e[tag=pCapturing,limit=1,sort=nearest] remove pCapturing
execute as @a[team=p-prot,scores={p_sneak=2..},gamemode=!spectator] at @s unless entity @e[tag=pCapturing,distance=..8,sort=nearest,limit=1] run scoreboard players set @s p_sneak 0

#Resets p_sneak if not continuously sneaking by comparing to player's p_last score; kills armor stand; restores NoAI; removes pCapturing (NoAI is 1..40 because pProt mob will have NoAI if capture successful)
execute as @a[team=p-prot,scores={p_sneak=1..40},gamemode=!spectator] at @s if score @s p_last = @s p_sneak run data modify entity @e[tag=pCapturing,limit=1,sort=nearest] NoAI set value 0b
execute as @a[team=p-prot,scores={p_sneak=1..},gamemode=!spectator] at @s if score @s p_last = @s p_sneak run kill @e[tag=pParticle,limit=1,sort=nearest]
execute as @a[team=p-prot,scores={p_sneak=1..},gamemode=!spectator] at @s if score @s p_last = @s p_sneak run tag @e[tag=pCapturing,limit=1,sort=nearest] remove pCapturing
execute as @a[team=p-prot,scores={p_sneak=1..},gamemode=!spectator] if score @s p_last = @s p_sneak run scoreboard players set @s p_sneak 0
execute as @a[team=p-prot,gamemode=!spectator] run scoreboard players operation @s p_last = @s p_sneak

#Resets p_sneak if pCapturing sheep is sheared (not using sheep selector because shearing sheep would stop all captures in multiplayer)
execute as @a[team=p-prot,scores={p_sneak=1..40},gamemode=!spectator] at @s if data entity @e[tag=pCapturing,limit=1,sort=nearest] {Sheared:1b} run data modify entity @e[tag=pCapturing,limit=1,sort=nearest] NoAI set value 0b
execute as @a[team=p-prot,scores={p_sneak=1..},gamemode=!spectator] at @s if data entity @e[tag=pCapturing,limit=1,sort=nearest] {Sheared:1b} run kill @e[tag=pParticle,limit=1,sort=nearest]
execute as @a[team=p-prot,scores={p_sneak=1..},gamemode=!spectator] at @s if data entity @e[tag=pCapturing,limit=1,sort=nearest] {Sheared:1b} run tag @e[tag=pCapturing,limit=1,sort=nearest] remove pCapturing
execute as @a[team=p-prot,scores={p_sneak=1..},gamemode=!spectator] at @s if data entity @e[tag=pCapturing,limit=1,sort=nearest] {Sheared:1b} run scoreboard players set @s p_sneak 0

#Sounds for capturing (I must hardcode it because of the notes)
execute as @a[team=p-prot,scores={p_sneak=2},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.5
execute as @a[team=p-prot,scores={p_sneak=6},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.529732
execute as @a[team=p-prot,scores={p_sneak=9},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.561231
execute as @a[team=p-prot,scores={p_sneak=12},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.594604
execute as @a[team=p-prot,scores={p_sneak=15},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.629961
execute as @a[team=p-prot,scores={p_sneak=18},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.667420
execute as @a[team=p-prot,scores={p_sneak=21},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.707107
execute as @a[team=p-prot,scores={p_sneak=24},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.749154
execute as @a[team=p-prot,scores={p_sneak=27},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.793701
execute as @a[team=p-prot,scores={p_sneak=30},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.840896
execute as @a[team=p-prot,scores={p_sneak=33},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.890899
execute as @a[team=p-prot,scores={p_sneak=36},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 0.943874
execute as @a[team=p-prot,scores={p_sneak=40},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.cow_bell master @a ~ ~ ~ 1 1
execute as @a[team=p-prot,scores={p_sneak=40},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run playsound minecraft:block.note_block.bell master @a ~ ~ ~ 1 1

#Capturing process by rotating the armor stand at multiples of 2; works only for scores between 1 and 40; kills armor stand and removes pCapture at 40
execute as @a[team=p-prot,scores={p_sneak=1},gamemode=!spectator] at @s as @e[tag=pCapture,distance=..8,sort=nearest,limit=1] run tag @s add pCapturing
execute as @a[team=p-prot,scores={p_sneak=1},gamemode=!spectator] at @s run data modify entity @e[tag=pCapturing,limit=1,sort=nearest] NoAI set value 1b
execute as @a[team=p-prot,scores={p_sneak=1},gamemode=!spectator] at @s as @e[tag=pCapturing,limit=1,sort=nearest] at @s run summon minecraft:armor_stand ~ ~0.1 ~ {Marker:1b,Invisible:1b,Invulnerable:1b,Tags:["pParticle"],Rotation:[0.0f,0.0f]}
execute as @a[team=p-prot,scores={p_sneak=2},gamemode=!spectator] at @s as @e[tag=pParticle,limit=1,sort=nearest] at @s run function p-prot:scripts/circle
execute as @a[team=p-prot,scores={p_sneak=2..40},gamemode=!spectator] run scoreboard players operation @s p_mod %= %2 p_prot_id
execute as @a[team=p-prot,scores={p_sneak=2..40},gamemode=!spectator] at @s if score @s p_mod matches 0 as @e[tag=pParticle,limit=1,sort=nearest] at @s run particle minecraft:end_rod ^ ^ ^1.5 0 0 0 0 3
execute as @a[team=p-prot,scores={p_sneak=2..40},gamemode=!spectator] at @s if score @s p_mod matches 0 as @e[tag=pParticle,limit=1,sort=nearest] at @s run particle minecraft:end_rod ^ ^ ^1.5 0 0 0 0.05 1
execute as @a[team=p-prot,scores={p_sneak=2..40},gamemode=!spectator] at @s if score @s p_mod matches 0 as @e[tag=pParticle,limit=1,sort=nearest] at @s run tp @s ~ ~ ~ ~9 ~
execute as @a[team=p-prot,scores={p_sneak=40},gamemode=!spectator] at @s run function p-prot:scripts/circle
execute as @a[team=p-prot,scores={p_sneak=40},gamemode=!spectator] at @s run kill @e[tag=pParticle,limit=1,sort=nearest]
execute as @a[team=p-prot,gamemode=!spectator,scores={p_sneak=40}] at @s run tag @e[tag=pCapturing,limit=1,sort=nearest] remove pCapture
execute as @a[team=p-prot,gamemode=!spectator,scores={p_sneak=40}] at @s as @e[tag=pCapturing,limit=1,sort=nearest] at @s run function p-prot:scripts/circle

#Capturing (all) when p_sneak is 40, turns the pCapturing mob into pProt mob; gives them unique ID; (data merge will get rid of the pCapturing tag)
execute as @a[team=p-prot,gamemode=!spectator,scores={p_sneak=40}] at @s as @e[tag=pCapturing,limit=1,sort=nearest] run function p-prot:scripts/assign_next
execute as @a[team=p-prot,gamemode=!spectator,scores={p_sneak=40}] at @s as @e[type=cow,tag=pCapturing,limit=1,sort=nearest] at @s run particle minecraft:angry_villager ~ ~0.3 ~ 0.6 0.7 0.6 0 5
execute as @a[team=p-prot,gamemode=!spectator,scores={p_sneak=40}] at @s as @e[type=cow,tag=pCapturing,limit=1,sort=nearest] run data merge entity @s {CustomNameVisible:1b,CustomName:'{"text":"Moomoo Protector","color":"green","bold":true}',ActiveEffects:[{Id:10b,Amplifier:1b,Duration:2147483647}],Attributes:[{Name:generic.armor,Base:12}],Team:"p-prot",Tags:["pProt","pCapturing"]}
execute as @a[team=p-prot,gamemode=!spectator,scores={p_sneak=40}] at @s as @e[type=pig,tag=pCapturing,limit=1,sort=nearest] run data merge entity @s {Fire:1000000,CustomNameVisible:1b,Team:"p-prot",Tags:["pProt","pCapturing"],CustomName:'{"text":"Bacon Protector","color":"green","bold":true}',ActiveEffects:[{Id:10b,Amplifier:1b,Duration:2147483647,ShowParticles:1b},{Id:12b,Amplifier:0b,Duration:2147483647,ShowParticles:1b}],Attributes:[{Name:generic.armor,Base:18},{Name:generic.armor_toughness,Base:3}]}
execute as @a[team=p-prot,gamemode=!spectator,scores={p_sneak=40}] at @s as @e[type=sheep,tag=pCapturing,limit=1,sort=nearest] run data merge entity @s {CustomNameVisible:1b,CustomName:'{"text":"Wooly Protector","color":"green","bold":true}',ActiveEffects:[{Id:10b,Amplifier:1b,Duration:2147483647}],Team:"p-prot",Tags:["pProt","pCapturing"],Color:0}

#Enters pPassive mode; summons a pAI cat for all pProt without pPassive or pAgressive tags (will default to pPassive therefore)
execute as @e[tag=pProt,tag=!pAgressive,tag=!pPassive] at @s run summon cat ~ ~ ~ {Silent:1b,Invulnerable:1b,Team:"p-prot",Age:-2147483647,Tags:["pAI"],ActiveEffects:[{Id:14b,Amplifier:0b,Duration:2147483647,ShowParticles:0b}]}
execute as @e[tag=pProt,tag=!pAgressive,tag=!pPassive] at @s run scoreboard players operation @e[type=cat,limit=1,sort=nearest,tag=pAI] p_prot_id = @s p_prot_id
execute as @e[tag=pProt,tag=!pAgressive,tag=!pPassive] at @s run data modify entity @e[type=cat,limit=1,sort=nearest,tag=pAI] Owner set from entity @a[team=p-prot,limit=1,sort=nearest,gamemode=!spectator] UUID
tag @e[tag=pProt,tag=!pAgressive,tag=!pPassive] add pPassive

#Enters pAgressive mode (all); summons a pAI mob for all pProt pPassive mobs within 18 blocks of an enemy player; red mob name
execute as @e[type=!chicken,tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run tag @e[tag=pAI,type=cat,limit=1,sort=nearest] add toKill
execute as @e[type=cow,tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run summon vindicator ~ ~ ~ {Silent:1b,Invulnerable:1b,Team:"p-prot",CanPickUpLoot:0b,PersistenceRequired:1b,CanJoinRaid:0b,Tags:["pAI"],CustomName:'{"text":"Angry Moomoo Protector","color":"red","bold":true}',HandItems:[{id:"minecraft:iron_axe",Count:1b},{}],ActiveEffects:[{Id:14b,Amplifier:0b,Duration:2147483647,ShowParticles:0b},{Id:30b,Amplifier:9b,Duration:2147483647,ShowParticles:0b}],Attributes:[{Name:generic.follow_range,Base:20},{Name:generic.movement_speed,Base:0.41},{Name:generic.attack_damage,Base:2},{Name:generic.attack_knockback,Base:9}]}
execute as @e[type=cow,tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run scoreboard players operation @e[type=vindicator,limit=1,sort=nearest,tag=pAI] p_prot_id = @s p_prot_id
execute as @e[type=cow,tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run data merge entity @s {CustomName:'{"text":"Angry Moomoo Protector","color":"red","bold":true}'}
execute as @e[type=pig,tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run summon zombie ~ ~ ~ {Silent:1b,Invulnerable:1b,Team:"p-prot",PersistenceRequired:1b,CanPickUpLoot:0b,IsBaby:1b,CanBreakDoors:0b,Tags:["pAI"],CustomName:'{"text":"Bacon Protector","color":"red","bold":true}',HandItems:[{id:"minecraft:stone_button",Count:1b,tag:{HideFlags:1,Enchantments:[{id:"minecraft:fire_aspect",lvl:20s}]}},{}],ActiveEffects:[{Id:14b,Amplifier:0b,Duration:2147483647,ShowParticles:0b}],Attributes:[{Name:generic.follow_range,Base:20},{Name:generic.knockback_resistance,Base:1},{Name:generic.movement_speed,Base:0.15},{Name:generic.attack_damage,Base:4},{Name:generic.attack_knockback,Base:2}]}
execute as @e[type=pig,tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run scoreboard players operation @e[type=zombie,limit=1,sort=nearest,tag=pAI] p_prot_id = @s p_prot_id
execute as @e[type=pig,tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run data merge entity @s {CustomName:'{"text":"Bacon Protector","color":"red","bold":true}'}
execute as @e[type=sheep,tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run summon slime ~ ~ ~ {Silent:1b,Invulnerable:1b,Team:"p-prot",PersistenceRequired:1b,Size:0,Tags:["pAI"],CustomName:'{"text":"Explosive Wooly Protector","color":"red","bold":true}',ActiveEffects:[{Id:14b,Amplifier:0b,Duration:2147483647,ShowParticles:0b},{Id:30b,Amplifier:9b,Duration:2147483647,ShowParticles:0b}],Attributes:[{Name:generic.follow_range,Base:20},{Name:generic.movement_speed,Base:1.8}]}
execute as @e[type=sheep,tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run scoreboard players operation @e[type=slime,limit=1,sort=nearest,tag=pAI] p_prot_id = @s p_prot_id
execute as @e[type=sheep,tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run data merge entity @s {CustomName:'{"text":"Explosive Wooly Protector","color":"red","bold":true}'}
execute as @e[tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run tag @s add pAgressive
execute as @e[tag=pProt,tag=pPassive] at @s if entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run tag @s remove pPassive

#Leaves pAgressive mode (all); kills pAI mob and tp's to p-prot player if not within 18 blocks of an enemy player; green pProt name
execute as @e[type=cow,tag=pProt,tag=pAgressive] at @s unless entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run tag @e[type=vindicator,tag=pAI,sort=nearest,limit=1] add toKill
execute as @e[type=cow,tag=pProt,tag=pAgressive] at @s unless entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run data merge entity @s {CustomName:'{"text":"Moomoo Protector","color":"green","bold":true}'}
execute as @e[type=pig,tag=pProt,tag=pAgressive] at @s unless entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run tag @e[type=zombie,tag=pAI,sort=nearest,limit=1] add pChill
execute as @e[type=pig,tag=pProt,tag=pAgressive] at @s unless entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run tag @e[type=zombie,tag=pAI,sort=nearest,limit=1] add toKill
execute as @e[type=pig,tag=pProt,tag=pAgressive] at @s unless entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run data merge entity @s {CustomName:'{"text":"Bacon Protector","color":"green","bold":true}'}
execute as @e[type=sheep,tag=pProt,tag=pAgressive] at @s unless entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run tag @e[type=slime,tag=pAI,sort=nearest,limit=1] add pChill
execute as @e[type=sheep,tag=pProt,tag=pAgressive] at @s unless entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run tag @e[type=slime,tag=pAI,sort=nearest,limit=1] add toKill
execute as @e[type=sheep,tag=pProt,tag=pAgressive] at @s unless entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run data merge entity @s {CustomName:'{"text":"Wooly Protector","color":"green","bold":true}'}
execute as @e[tag=pProt,tag=pAgressive] at @s unless entity @a[team=!p-prot,distance=..18,gamemode=!spectator] run tag @s remove pAgressive
execute as @e[tag=pAI,tag=toKill] at @s unless entity @a[team=p-prot,distance=..16,gamemode=!spectator] run tp @s @a[team=p-prot,limit=1,sort=nearest,gamemode=!spectator]

#Bacon Protector water mechanics; checks for fire
execute as @e[type=pig,tag=pProt] at @s run function p-prot:scripts/fire_check

#pProt sheep mechanics; kills pAI and self and summons explosive wool (if pPassive) item when sheared; self destructs when near player
execute as @e[type=sheep,tag=pProt] at @s if data entity @s {Sheared:1b} run tag @e[tag=pAI,type=slime,limit=1,sort=nearest] add toKill
execute as @e[type=sheep,tag=pProt,tag=pPassive] at @s if data entity @s {Sheared:1b} run summon item ~ ~ ~ {Item:{id:"minecraft:tnt",Count:1b,tag:{display:{Name:'{"text":"Explosive Wool","italic":false}'},BlockStateTag:{unstable:"true"}}}}
execute as @e[type=sheep,tag=pProt] at @s if data entity @s {Sheared:1b} run kill @s
execute as @e[type=sheep,tag=pProt] at @s if entity @a[team=!p-prot,distance=..1.3,gamemode=!spectator] run tag @e[type=slime,tag=pAI,limit=1,sort=nearest] add toKill
execute as @e[type=sheep,tag=pProt] at @s if entity @a[team=!p-prot,distance=..1.3,gamemode=!spectator] run tag @e[type=slime,tag=pAI,limit=1,sort=nearest] add pChill
execute as @e[type=sheep,tag=pProt] at @s if entity @a[team=!p-prot,distance=..1.3,gamemode=!spectator] run summon creeper ~ -1 ~ {Silent:1b,Invulnerable:1b,Fuse:0,ignited:1b,CustomName:'{"text":"Explosive Wooly Protector","color":"red","bold":true}',Tags:["pBoom"]}
execute as @e[type=sheep,tag=pProt] at @s if entity @a[team=!p-prot,distance=..1.3,gamemode=!spectator] positioned ~ -1 ~ run tp @e[tag=pBoom,limit=1,sort=nearest] @s
execute as @e[type=sheep,tag=pProt] at @s if entity @a[team=!p-prot,distance=..1.3,gamemode=!spectator] run kill @s

#Explosive wool mechanics; kills self if wool is gone; summons creeper at Age:20 (the teleport thing is to prevent seeing the creeper)
execute as @e[tag=pWool] at @s unless block ~ ~ ~ #wool run kill @s
execute as @e[tag=pWool,nbt={Age:5}] at @s run setblock ~ ~ ~ minecraft:white_wool
execute as @e[tag=pWool,nbt={Age:10}] at @s run setblock ~ ~ ~ minecraft:red_wool
execute as @e[tag=pWool,nbt={Age:15}] at @s run setblock ~ ~ ~ minecraft:white_wool
execute as @e[tag=pWool,nbt={Age:20}] at @s run setblock ~ ~ ~ air
execute as @e[tag=pWool,nbt={Age:20}] at @s run summon creeper ~ -1 ~ {Silent:1b,Invulnerable:1b,Fuse:0,ignited:1b,Tags:["pBoom"],CustomName:'{"text":"Wool Mine","color":"red","bold":true}'}
execute as @e[tag=pWool,nbt={Age:20}] at @s positioned ~ -1 ~ run tp @e[tag=pBoom,limit=1,sort=nearest] @s

#Teleports all pProt to their respective pAI
execute as @e[tag=pProt] at @e[tag=pAI] if score @s p_prot_id = @e[tag=pAI,limit=1,sort=nearest] p_prot_id run tp @s @e[tag=pAI,limit=1,sort=nearest]

#Particles for (all) pProt (passively)
execute as @e[type=cow,tag=pProt,tag=pAgressive] at @s if score %timer p_prot_id matches 10 run particle minecraft:angry_villager ~ ~0.3 ~ 0.6 0.7 0.6 0 2
execute if entity @e[type=pig,tag=pProt,limit=1] run scoreboard players operation %timer p_mod = %timer p_prot_id
execute if entity @e[type=pig,tag=pProt,limit=1] run scoreboard players operation %timer p_mod %= %2 p_prot_id
execute as @e[type=pig,tag=pProt] at @s if score %timer p_mod matches 0 run particle minecraft:campfire_cosy_smoke ~ ~0.2 ~ 0 1 0 0.1 0
execute if entity @e[type=sheep,tag=pProt,tag=pAgressive] run scoreboard players operation @s p_last = @s p_mod
execute if entity @e[type=sheep,tag=pProt,tag=pAgressive] run scoreboard players operation @s p_last %= %10 p_prot_id
execute as @e[type=sheep,tag=pProt,tag=pAgressive] at @s if score @s p_last matches 0 run data modify entity @s Color set value 0
execute as @e[type=sheep,tag=pProt,tag=pAgressive] at @s if score @s p_last matches 5 run data modify entity @s Color set value 14
execute as @e[type=sheep,tag=pProt,tag=pPassive] at @s if score @s p_mod matches 0 run data modify entity @s Color set value 0
execute as @e[type=sheep,tag=pProt,tag=pPassive] at @s if score @s p_mod matches 36 run data modify entity @s Color set value 14

#Prevents any pAI cat from sitting
execute as @e[type=cat,tag=pAI,nbt={Sitting:1b}] run data modify entity @s Sitting set value 0b

#Kills any tagged with toKill
# also sets the Owner of cat to [I; 0, 0, 0, 0] so no death messages (data remove doesn't work; sorry to whoever has [I; 0, 0, 0, 0] UUID who will get that spam)
# also creates pig fire explosion on death (when zombie dies)
# also creates explosive wool (when slime dies)
execute as @e[type=cat,tag=pAI,tag=toKill] run data merge entity @s {Owner:[I; 0, 0, 0, 0]}
execute as @e[type=zombie,tag=pAI,tag=toKill,tag=!pChill] at @s if entity @a[team=p-prot,distance=..4,gamemode=!spectator] run effect give @a[team=p-prot,distance=..10,gamemode=!spectator] minecraft:fire_resistance 3 0
execute as @e[type=zombie,tag=pAI,tag=toKill,tag=!pChill] at @s run summon minecraft:fireball ~ ~ ~ {Motion:[0.0,-1.0,0.0],ExplosionPower:1}
execute as @e[type=zombie,tag=pAI,tag=toKill,tag=!pChill] at @s run fill ~3 ~3 ~3 ~-3 ~-3 ~-3 fire replace air
execute as @e[type=zombie,tag=pAI,tag=toKill,tag=!pChill] at @s run particle minecraft:lava ~ ~1.5 ~ 3 0.2 3 0 70
execute as @e[type=slime,tag=pAI,tag=toKill,tag=!pChill] at @s run summon area_effect_cloud ~ ~ ~ {Duration:21,Tags:["pWool"]}
execute as @e[type=slime,tag=pAI,tag=toKill,tag=!pChill] at @s run setblock ~ ~ ~ red_wool
execute as @e[tag=toKill] at @s run tp @s ~ -5 ~
kill @e[tag=toKill]
