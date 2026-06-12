	db DEX_PORYGON2       ; pokedex id

	db   55,  50,  45, 120, 135,  85 ; ALAKAZAM (+10 sdf for modern stats)
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 30 ; catch rate
	db 255 ; base exp

	INCBIN "gfx/pokemon/front/porygon2.pic", 0, 1 ; sprite dimensions
	dw Porygon2PicFront, Porygon2PicBack

	db POUND, DOUBLESLAP, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         \
	     SOLARBEAM,    THUNDERBOLT,  THUNDER,      PSYCHIC_M,    TELEPORT,     \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,      BIDE,         METRONOME,    \
	     EGG_BOMB,     FIRE_BLAST,   SKULL_BASH,   REST,         \
	     THUNDER_WAVE, PSYWAVE,      TRI_ATTACK,   SUBSTITUTE,   STRENGTH,     \
	     FLASH
	; end

	db 0 ; padding
