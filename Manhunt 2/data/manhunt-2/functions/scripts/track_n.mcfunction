#Spawns a new marker on the runner's location (if in dimension NETHER)
execute if entity @a[tag=manhuntRunner,nbt={Dimension:"minecraft:the_nether"}] as @e[tag=manhuntMarkerN] at @s run forceload remove ~ ~ ~ ~
execute if entity @a[tag=manhuntRunner,nbt={Dimension:"minecraft:the_nether"}] run kill @e[tag=manhuntMarkerN]
execute at @a[tag=manhuntRunner,nbt={Dimension:"minecraft:the_nether"},limit=1,sort=nearest] run summon armor_stand ~ -5 ~ {Tags:["manhuntMarkerN"],Marker:1b,Invisible:1b,Silent:1b}
execute as @e[tag=manhuntMarkerN] at @s run forceload add ~ ~ ~ ~