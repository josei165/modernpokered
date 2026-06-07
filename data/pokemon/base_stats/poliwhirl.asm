	db DEX_POLIWHIRL ; pokedex id

	db  55,  50,  45, 120, 135,  85 ; ALAKAZAM (+10 sdf for modern stats)
	;   hp  atk  def  spd  sat  sdf

	db WATER, WATER ; type
	db 120 ; catch rate
	db 131 ; base exp

	INCBIN "gfx/pokemon/front/poliwhirl.pic", 0, 1 ; sprite dimensions
	dw PoliwhirlPicFront, PoliwhirlPicBack

	db BUBBLE, HYPNOSIS, WATER_GUN, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  BUBBLEBEAM,   WATER_GUN,    ICE_BEAM,     BLIZZARD,     \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, RAGE,         EARTHQUAKE,   \
	     FISSURE,      PSYCHIC_M,    MIMIC,        DOUBLE_TEAM,  BIDE,         \
	     METRONOME,    SKULL_BASH,   REST,         PSYWAVE,      SUBSTITUTE,   \
	     SURF,         STRENGTH
	; end

	db 0 ; padding
