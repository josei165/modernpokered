	db DEX_DITTO ; pokedex id

	db   55,   50,  45, 120, 135,  85 ; ALAKAZAM (+10 sdf for modern stats)
	;   hp  atk  def  spd  sat  sdf

	db NORMAL, NORMAL ; type
	db 35 ; catch rate
	db 61 ; base exp

	INCBIN "gfx/pokemon/front/ditto.pic", 0, 1 ; sprite dimensions
	dw DittoPicFront, DittoPicBack

	db TRANSFORM, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm
	; end

	db 0 ; padding
