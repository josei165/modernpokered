ViridianForestSouthGate_Script:
	call EnableAutoTextBoxDrawing
	call ViridianForestSouthGateGuardCheck
	ret

ViridianForestSouthGateGuardCheck:
	CheckEvent EVENT_BEAT_ROUTE22_RIVAL_1ST_BATTLE
	ret z
	ld a, TOGGLE_VIRIDIAN_FOREST_SOUTH_GATE_OAKS_AIDE
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret

ViridianForestSouthGateBlockCoords:
	dbmapcoord 5, 1
	db -1 ; end

ViridianForestSouthGate_TextPointers:
	def_text_pointers
	dw_const ViridianForestSouthGateGirlText,      TEXT_VIRIDIANFORESTSOUTHGATE_GIRL
	dw_const ViridianForestSouthGateLittleGirlText, TEXT_VIRIDIANFORESTSOUTHGATE_LITTLE_GIRL
	dw_const ViridianForestSouthGateOaksAideText,  TEXT_VIRIDIANFORESTSOUTHGATE_OAKS_AIDE

ViridianForestSouthGateGirlText:
	text_far _ViridianForestSouthGateGirlText
	text_end

ViridianForestSouthGateLittleGirlText:
	text_far _ViridianForestSouthGateLittleGirlText
	text_end

ViridianForestSouthGateOaksAideText:
	text_far _ViridianForestSouthGateOaksAideText
	text_end