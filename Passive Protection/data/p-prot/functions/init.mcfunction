tellraw @a [{"text":"reload - "},{"text":"Passive Protection","color":"green","bold":true},{"text":" - ","color":"white","bold":false},{"text":"by Bzlbzlbzl","color":"light_purple"}]

team add p-prot
team modify p-prot seeFriendlyInvisibles false
team modify p-prot collisionRule pushOwnTeam
scoreboard objectives add p_prot_id dummy
scoreboard players set %next p_prot_id 1
scoreboard players set %2 p_prot_id 2
scoreboard objectives add p_sneak minecraft.custom:minecraft.sneak_time
scoreboard objectives add p_sneak_last dummy
scoreboard objectives add p_sneak_mod dummy