# # # Knockback Wars Datapack - Bzlbzlbzl # # #

#Always Effects and Kit Effects; weather clear; bye bye ground arrows
weather clear
effect give @a minecraft:resistance 100000 4 true
effect give @a minecraft:saturation 100000 0 true
kill @e[type=minecraft:arrow,nbt={inGround:1b}]
effect give @a[team=Reaper] minecraft:invisibility 1 0 true
effect give @a[team=Reaper] minecraft:speed 1 0 true
effect give @a[team=Ghost] minecraft:invisibility 1 0 true
effect give @a[team=Pyromaniac] minecraft:fire_resistance 1 0 true
effect give @a[team=Assassin] minecraft:speed 1 0 true
effect give @a[team=Knight] minecraft:slowness 1 1 true

#Getting count of players with %count
execute store result score %count wins if entity @a[scores={queue=1}]

#Starting the game based on the %countdown; first countdown, when finally 0 then runs start function
# NOTE: Command "execute if score %game wins matches 0 if score %count wins matches 2.. run scoreboard players set %countdown wins 60" run from elsewhere required to start this
execute if score %countdown wins matches 60 run tellraw @a ["",{"text":"Starting in "},{"text":"3","bold":true,"color":"dark_green"},{"text":"..."}]
execute if score %countdown wins matches 60 as @a at @s run playsound minecraft:block.note_block.hat master @s ~ ~ ~ 1 1
execute if score %countdown wins matches 40 run tellraw @a ["",{"text":"Starting in "},{"text":"2","bold":true,"color":"gold"},{"text":"..."}]
execute if score %countdown wins matches 40 as @a at @s run playsound minecraft:block.note_block.hat master @s ~ ~ ~ 1 1
execute if score %countdown wins matches 20 run tellraw @a ["",{"text":"Starting in "},{"text":"1","bold":true,"color":"dark_red"},{"text":"..."}]
execute if score %countdown wins matches 20 as @a at @s run playsound minecraft:block.note_block.hat master @s ~ ~ ~ 1 1
execute if score %countdown wins matches 0 run tellraw @a {"text":"START!","bold":true,"color":"blue"}
execute if score %countdown wins matches 0 run function kbw:scripts/start
execute if score %countdown wins matches 0 as @a at @s run playsound minecraft:block.note_block.pling master @s ~ ~ ~ 1 2

#Ghost head mechanics
item replace entity @a[team=Ghost,nbt=!{Inventory:[{Slot:103b,id:"minecraft:jack_o_lantern"}]}] armor.head with jack_o_lantern{display:{Name:'{"text":"Possessed Mask","color":"gray","italic":"false"}',Lore:['{"text":"Even with a physical head,"}','{"text":"attacks just seem to pass"}','{"text":"right through you."}']},HideFlags:61,AttributeModifiers:[{AttributeName:"generic.knockback_resistance",Name:"generic.knockback_resistance",Amount:0.25,Operation:0,UUID:[I;1095820967,317080703,-2066589546,346890519],Slot:"head"}],ghost:1b} 
clear @a[team=!Ghost] jack_o_lantern{ghost:1b}
kill @e[type=minecraft:item,nbt={Item:{tag:{ghost:1b}}}]

#Reaper armor mechanics
item replace entity @a[team=Reaper,nbt=!{Inventory:[{Slot:103b,id:"minecraft:leather_helmet",tag:{display:{color:0}}}]}] armor.head with leather_helmet{display:{Name:'{"text":"Reaper\'s Hood","color":"black","italic":false}',Lore:['{"text":"Nobody knows what\'s under"}','{"text":"this hood... not even you."}'],color:0},HideFlags:5,Unbreakable:1b,AttributeModifiers:[{AttributeName:"generic.movement_speed",Name:"generic.movement_speed",Amount:0.1,Operation:1,UUID:[I;-734874255,604457540,-1498911138,-520511022],Slot:"head"}],reaper:1b} 1
item replace entity @a[team=Reaper,nbt=!{Inventory:[{Slot:102b,id:"minecraft:leather_chestplate",tag:{display:{color:0}}}]}] armor.chest with leather_chestplate{display:{Name:'{"text":"Reaper\'s Robe","color":"black","italic":false}',Lore:['{"text":"Your body isn\'t as"}','{"text":"tangible as the living."}'],color:0},HideFlags:5,Unbreakable:1b,AttributeModifiers:[{AttributeName:"generic.knockback_resistance",Name:"generic.knockback_resistance",Amount:0.1,Operation:0,UUID:[I;2140370788,122831175,-1117071607,1877739167],Slot:"chest"}],reaper:1b} 1
clear @a[team=!Reaper] leather_helmet{reaper:1b}
clear @a[team=!Reaper] leather_chestplate{reaper:1b}
kill @e[type=minecraft:item,nbt={Item:{tag:{reaper:1b}}}]

#Archer trap mechanics; turtle spawn; particles; function kbw:scripts/ensnare
execute as @e[type=minecraft:turtle,tag=archerTrap] at @s run summon minecraft:armor_stand ~ ~ ~ {Marker:1b,Invisible:1b,Tags:["archerTrap"]}
execute as @e[type=minecraft:turtle,tag=archerTrap] at @s run playsound minecraft:block.gravel.hit master @a[team=Archer] ~ ~ ~ 0.4 0.7
execute as @e[type=minecraft:turtle,tag=archerTrap] at @s run playsound minecraft:block.bamboo.break master @a[team=Archer] ~ ~ ~ 2 0.2
execute as @e[type=minecraft:turtle,tag=archerTrap] at @s run tp @s ~ -1 ~
execute as @e[type=minecraft:turtle,tag=archerTrap] at @s run kill @s
execute at @e[tag=archerTrap,type=minecraft:armor_stand] run particle minecraft:totem_of_undying ~ ~0.1 ~ 0.4 0 0.4 0 3 force @a[team=Archer]
execute as @e[tag=archerTrap,type=minecraft:armor_stand] at @s if entity @a[team=!Archer,distance=..0.7] run function kbw:scripts/ensnare

#Witch particle, potion and milk mechanics (potion mechanics uses pyroFlail scoreboard cuz I didn't want to make another objective)
execute if score %game wins matches 1 if score %timer wins matches 10 as @a[team=Witch,nbt={SelectedItem:{id:"minecraft:stick",tag:{wand:1b}}}] at @s run particle minecraft:instant_effect ~ ~ ~ 0 0 0 0 3
execute as @a[team=Witch,tag=inGame,nbt={SelectedItem:{id:"minecraft:bucket"}}] run function kbw:scripts/milk
execute as @a[team=Witch,tag=inGame,nbt=!{Inventory:[{Slot:-106b}]},scores={calculation=..0}] at @s run function kbw:scripts/potion
execute as @a[team=Witch,tag=inGame,nbt=!{Inventory:[{Slot:-106b}]}] run scoreboard players remove @s calculation 1

#Pyromaniac flail mechanics
execute if score %game wins matches 1 at @e[type=minecraft:fireball,tag=pyroFireball] run particle minecraft:dust 1 0.2 0.1 1.5 ~ ~ ~ 0.07 0 0.07 0 3
scoreboard players set @a[team=Pyromaniac,scores={calculation=0}] pyroFlail 0
execute as @a[team=Pyromaniac,tag=inGame,scores={pyroFlail=1..,calculation=..0}] at @s run function kbw:scripts/fireball
execute as @a[team=Pyromaniac,tag=inGame,scores={calculation=0..}] run scoreboard players remove @s calculation 1

# Grim Reaper mechanics
#Swapping to diamond hoe and swapping back
execute as @a[team=Reaper,nbt={SelectedItem:{tag:{scythe:2b}}},nbt=!{FallDistance:0.0f},predicate=kbw:sneaking,scores={calculation=..0}] run function kbw:scripts/rend_prep
execute as @a[team=Reaper,nbt={Inventory:[{tag:{scythe:3b}}],FallDistance:0.0f},scores={calculation=..0}] run function kbw:scripts/rend_unprep

#Scoreboard updates to 0 right before they can use ability again
scoreboard players reset @a[team=Reaper,scores={calculation=0}] rend
scoreboard players reset @a[team=Reaper,scores={calculation=0}] reap
scoreboard players reset @a[team=Reaper,scores={calculation=0}] attack

#Reap and rend abilities (rend doesnt check for sneaking cuz it already does before)
execute as @a[team=Reaper,scores={rend=1..,calculation=..0}] at @s rotated ~180 0 run function kbw:scripts/rend
execute as @a[team=Reaper,predicate=kbw:sneaking,scores={reap=1..,calculation=..0}] at @s rotated ~ 0 run function kbw:scripts/reap
execute as @a[team=Reaper,predicate=kbw:sneaking,scores={attack=1..,calculation=..0}] at @s rotated ~ 0 run function kbw:scripts/reap

#Decreasing scoreboard values by 1 every tick
scoreboard players reset @a[team=Reaper,scores={rend=1..}] rend
scoreboard players reset @a[team=Reaper,scores={reap=1..}] reap
scoreboard players reset @a[team=Reaper,scores={attack=1..}] attack
execute as @a[team=Reaper,tag=inGame,scores={calculation=0..}] run scoreboard players remove @s calculation 1

#Effects for when Reaper has stolen a soul, and when they lose it
execute as @a[team=Reaper,tag=inGame,scores={calculation=20..}] at @s run particle minecraft:soul ~ ~1 ~ 0.3 0.5 0.3 0 1 normal
execute as @a[team=Reaper,tag=inGame,scores={calculation=20}] at @s run particle minecraft:smoke ~ ~0.8 ~ 0.25 0.6 0.25 0.05 90 normal
execute as @a[team=Reaper,tag=inGame,scores={calculation=20}] at @s run playsound minecraft:entity.generic.extinguish_fire master @a ~ ~ ~ 0.6 2
execute as @a[team=Reaper,tag=inGame,scores={calculation=20}] run attribute @s minecraft:generic.knockback_resistance base set 0

#Effects for when others lost their soul and get it back
execute as @e[nbt={ActiveEffects:[{Id:15b,Amplifier:1b}]}] at @s run particle minecraft:smoke ~ ~1 ~ 0.2 0.5 0.2 0 2 normal
execute as @e[nbt={ActiveEffects:[{Id:15b,Duration:20,Amplifier:1b}]}] at @s run particle minecraft:soul ~ ~1 ~ 0.35 0.5 0.35 0.01 20 normal
execute as @e[nbt={ActiveEffects:[{Id:15b,Duration:20,Amplifier:1b}]}] at @s run playsound minecraft:entity.iron_golem.repair master @s ~ ~ ~ 0.3 0.3

#Passive weapon effects
execute as @a[team=Reaper,nbt={SelectedItem:{tag:{scythe:2b}}},predicate=kbw:soul] at @s run particle minecraft:soul ~ ~1 ~ 0.15 0.5 0.15 0.02 1 normal

#Returning sythe mechanics and effects
scoreboard players remove @e[type=minecraft:armor_stand,tag=reapScythe,scores={calculation=1..}] calculation 1
execute as @e[type=minecraft:armor_stand,tag=reapScythe,scores={calculation=1..20}] at @s run tp @s ~ ~0.1 ~
execute as @e[type=minecraft:armor_stand,tag=reapScythe,scores={calculation=4}] at @s positioned ~-0.4 64 ~-0.7 run particle minecraft:item minecraft:soul_sand ~ ~0.05 ~ 0.2 0.1 0.2 0.1 20 normal
execute as @e[type=minecraft:armor_stand,tag=reapScythe,predicate=kbw:soul] at @s positioned ~-0.4 64 ~-0.7 run particle minecraft:soul ~ ~0 ~ 0.5 0 0.5 0.03 7
execute as @e[type=minecraft:armor_stand,tag=reapScythe,scores={calculation=0}] at @s positioned ~-0.4 64 ~-0.7 if entity @e[type=minecraft:player,team=Reaper,tag=noScythe,distance=..1,scores={calculation=..19}] run function kbw:scripts/scythe

#Duelist shield mechanics (I could have put the offhand + shield check in the same scan by separating w/ commas, but the point is they're different)
execute as @a[team=Duelist,nbt={SelectedItem:{tag:{duelist:1b}}},tag=inGame,scores={damage=0..,last_sprint=1},nbt=!{FallDistance:0.0f}] unless data entity @s Inventory[{id:"minecraft:shield"}] unless data entity @s Inventory[{Slot:-106b}] run item replace entity @s weapon.offhand with shield{display:{Name:'{"text":"Shield","color":"red","italic":false}',Lore:['{"translate":"Upon broken, stuns all nearby"}','{"translate":"enemies briefly. Restores"}','{"translate":"after every clean axe crit."}']},duelist:2b,Unbreakable:1b,HideFlags:4} 1
execute as @a[team=Duelist,scores={blocked=0..}] run clear @s shield{duelist:2b}
execute as @a[team=Duelist,scores={blocked=0..}] at @s as @e[distance=..5,type=!#impact_projectiles,type=!armor_stand,type=!ender_pearl,type=!potion] unless score @s blocked matches 0.. run effect give @s minecraft:weakness 2 10 true
execute as @a[team=Duelist,scores={blocked=0..}] at @s as @e[distance=..5,type=!#impact_projectiles,type=!armor_stand,type=!ender_pearl,type=!potion] run playsound minecraft:item.shield.break player @s ~ ~ ~ 1 0.9
execute as @a[team=Duelist,scores={blocked=0..}] at @s run particle minecraft:flash ~ ~ ~ 0 0 0 0 1 normal
execute as @a[team=Duelist,scores={blocked=0..}] at @s run particle minecraft:poof ~ ~1.2 ~ 1 0.3 0.8 1 10 normal
execute as @a[team=Duelist,scores={blocked=0..}] at @s as @e[distance=..5,type=!#impact_projectiles,type=!armor_stand,type=!ender_pearl,type=!potion] unless score @s blocked matches 0.. at @s run particle minecraft:angry_villager ~ ~0.5 ~ 0.4 0.5 0.4 0 5 normal

#Builder block mechanics
execute if score %game wins matches 1 run fill 18 68 -18 -18 64 18 minecraft:air replace minecraft:dead_tube_coral_block
execute if score %game wins matches 1 run fill 19 69 -19 -19 71 19 minecraft:air replace minecraft:tube_coral_block
execute if score %game wins matches 1 if score %timer wins matches 0 run scoreboard players add %blocks wins 1
execute if score %game wins matches 1 if score %blocks wins matches 2 as @a[team=Builder,tag=inGame] unless entity @s[nbt={Inventory:[{Count:64b,tag:{builder:1b}}]}] run give @s tube_coral_block{CanPlaceOn:["minecraft:red_terracotta","minecraft:glowstone","minecraft:white_wool","minecraft:lime_wool","minecraft:sand","minecraft:tube_coral_block"],display:{Name:'{"translate":"Building Block","color":"blue","italic":false}',Lore:['{"translate":"These blocks don\'t last forever..."}','{"translate":"Luckily you\'ve got tons more"}']},builder:1b,Enchantments:[{id:"minecraft:knockback",lvl:2s}],HideFlags:16} 1
execute if score %blocks wins matches 2.. run scoreboard players set %blocks wins 0

#Ending game if not enough players; message and set %game to 0
execute if score %game wins matches 1 unless entity @a[tag=inGame] run tellraw @a {"text":"The game ended with no winner.","bold":true,"color":"gray"}
execute if score %game wins matches 1 unless entity @a[tag=inGame] run function kbw:scripts/end

#Ending game if someone reaches a score of 100
execute as @a[tag=inGame,scores={score=100..}] run tellraw @a ["",{"selector":"@s","bold":true},{"text":" has won the game!","bold":true,"color":"gold"}]
scoreboard players add @a[tag=inGame,scores={score=100..}] wins 1
execute as @a[tag=inGame,scores={score=100..}] at @s run scoreboard players set @s jingle -30
execute if entity @a[tag=inGame,scores={score=100..}] as @a[tag=inGame,scores={score=..99}] at @s run scoreboard players set @s jingle 30
execute if entity @a[tag=inGame,scores={score=100..}] run function kbw:scripts/end

#Ending jingle(s)
execute as @a[scores={jingle=30}] at @s run playsound minecraft:block.note_block.iron_xylophone master @s ~ ~ ~ 1 1.189207
execute as @a[scores={jingle=25}] at @s run playsound minecraft:block.note_block.iron_xylophone master @s ~ ~ ~ 1 1.122462
execute as @a[scores={jingle=20}] at @s run playsound minecraft:block.note_block.iron_xylophone master @s ~ ~ ~ 1 1.059463
execute as @a[scores={jingle=15}] at @s run playsound minecraft:block.note_block.iron_xylophone master @s ~ ~ ~ 1 1
execute as @a[scores={jingle=1}] at @s run playsound minecraft:block.note_block.cow_bell master @s ~ ~ ~ 1 0.707107

execute as @a[scores={jingle=-30}] at @s run playsound minecraft:ui.toast.challenge_complete master @s ~ ~ ~ 1 1.6
execute as @a[scores={jingle=-30}] at @s run summon firework_rocket ~ ~ ~ {LifeTime:20,Tags:["celebrate"],FireworksItem:{id:firework_rocket,Count:1,tag:{Fireworks:{Explosions:[{Type:2,Colors:[I;16711680],FadeColors:[I;16712695]}]}}}}
execute as @a[scores={jingle=-20}] at @s run summon firework_rocket ~1 ~ ~2 {LifeTime:25,Tags:["celebrate"],FireworksItem:{id:firework_rocket,Count:1,tag:{Fireworks:{Explosions:[{Type:0,Trail:1b,Colors:[I;1048367],FadeColors:[I;16760333]}]}}}}
execute as @a[scores={jingle=-10}] at @s run summon firework_rocket ~-2 ~ ~-2 {LifeTime:20,Tags:["celebrate"],FireworksItem:{id:firework_rocket,Count:1,tag:{Fireworks:{Explosions:[{Type:4,Flicker:1b,Trail:1b,Colors:[I;2228479],FadeColors:[I;16745190]}]}}}}

#Incrementing %timer by 1 every tick, updates score of players (if game is running)
execute if score %game wins matches 1 run scoreboard players add %timer wins 1
execute if score %timer wins matches 20 run scoreboard players set %timer wins 0
execute if score %game wins matches 1 if score %timer wins matches 0 positioned 0.5 64 0.5 run scoreboard players add @a[distance=..9.2,tag=inGame] score 1
execute if score %game wins matches 1 if score %timer wins matches 0 positioned 0.5 64 0.5 run scoreboard players add @a[distance=..3.2,tag=inGame] score 1

#Removes 1 from %countdown every tick if its greater than 0 (it's counting down), resets damage detectors and updates lastSprtint
execute if score %countdown wins matches 0.. run scoreboard players remove %countdown wins 1
scoreboard players reset * damage
scoreboard players reset * blocked
execute as @a store success score @s last_sprint if predicate kbw:not_sprinting
execute as @a[scores={jingle=1..}] run scoreboard players remove @s jingle 1
execute as @a[scores={jingle=..-1}] run scoreboard players add @s jingle 1