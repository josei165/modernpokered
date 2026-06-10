CeladonMart5F_Script:
	call EnableAutoTextBoxDrawing
	call CeladonMart5FGuardCheck
	ret

CeladonMart5FGuardCheck:
	ld a, [wObtainedBadges]
	bit BIT_SOULBADGE, a
	ret z
	ld a, TOGGLE_CELADONMART5F_GUARD
	ld [wToggleableObjectIndex], a
	predef HideObject
	ret

CeladonMart5FGuardBlockCoords:
	dbmapcoord 14, 2
	db -1 ; end

CeladonMart5F_TextPointers:
	def_text_pointers
	dw_const CeladonMart5FGentlemanText,        TEXT_CELADONMART5F_GENTLEMAN
	dw_const CeladonMart5FSailorText,           TEXT_CELADONMART5F_SAILOR
	dw_const CeladonMart5FClerk1Text,           TEXT_CELADONMART5F_CLERK1
	dw_const CeladonMart5FClerk2Text,           TEXT_CELADONMART5F_CLERK2
	dw_const CeladonMart5FGuardText, 			TEXT_CELADONMART5F_GUARD
	dw_const CeladonMart5FCurrentFloorSignText, TEXT_CELADONMART5F_CURRENT_FLOOR_SIGN


CeladonMart5FGentlemanText:
	text_far _CeladonMart5FGentlemanText
	text_end

CeladonMart5FSailorText:
	text_far _CeladonMart5FSailorText
	text_end

CeladonMart5FGuardText:
	text_far _CeladonMart5FGuardText
	text_end

CeladonMart5FCurrentFloorSignText:
	text_far _CeladonMart5FCurrentFloorSignText
	text_end

CeladonMart5FClerk1Text:
	script_mart X_ACCURACY, GUARD_SPEC, DIRE_HIT, X_ATTACK, X_DEFEND, X_SPEED, X_SP_ATK, X_SP_DEF

CeladonMart5FClerk2Text:
	script_mart HP_UP, PROTEIN, IRON, CARBOS, CALCIUM

