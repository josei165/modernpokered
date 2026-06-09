Route5_Script:
	call EnableAutoTextBoxDrawing
	call Route5GuardCheck
	ret

Route5GuardCheck:
	CheckEvent EVENT_BEAT_MISTY
	ret z
	ld a, TOGGLE_ROUTE5_UNDERGROUND_GUARD
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret

Route5UndergroundGuardBlockCoords:
	dbmapcoord 17, 27
	db -1 ; end

Route5_TextPointers:
	def_text_pointers
	dw_const Route5UndergroundGuardText,     TEXT_ROUTE5_UNDERGROUND_GUARD
	dw_const Route5UndergroundPathSignText,  TEXT_ROUTE5_UNDERGROUND_PATH_SIGN

Route5UndergroundPathSignText:
	text_far _Route5UndergroundPathSignText
	text_end

Route5UndergroundGuardText:
	text_far _Route5UndergroundGuardText
	text_end