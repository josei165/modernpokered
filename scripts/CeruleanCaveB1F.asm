CeruleanCaveB1F_Script:
	call EnableAutoTextBoxDrawing
	call CeruleanCaveB1FLegendaryShowScript
	ld hl, CeruleanCaveB1FTrainerHeaders
	ld de, CeruleanCaveB1F_ScriptPointers
	ld a, [wCeruleanCaveB1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeruleanCaveB1FCurScript], a
	ret

CeruleanCaveB1FLegendaryShowScript:
	CheckEvent EVENT_BEAT_CHAMPION_FOR_POSTGAME
	ret z
	CheckEvent EVENT_BEAT_MEWTWO
	jr nz, .checkMew
	ld a, TOGGLE_MEWTWO
	ld [wToggleableObjectIndex], a
	predef ShowObject
.checkMew
	CheckEvent EVENT_BEAT_MEWTWO
	ret z
	CheckEvent EVENT_BEAT_OAK
	ret z
	CheckEvent EVENT_BEAT_MEW
	ret nz
	ld a, TOGGLE_MEW
	ld [wToggleableObjectIndex], a
	predef ShowObject
	ret

CeruleanCaveB1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_CERULEANCAVEB1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_CERULEANCAVEB1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_CERULEANCAVEB1F_END_BATTLE

CeruleanCaveB1F_TextPointers:
	def_text_pointers
	dw_const CeruleanCaveB1FMewtwoText, TEXT_CERULEANCAVEB1F_MEWTWO
	dw_const CeruleanCaveB1FMewText, TEXT_CERULEANCAVEB1F_MEW
	dw_const PickUpItemText,            TEXT_CERULEANCAVEB1F_ULTRA_BALL
	dw_const PickUpItemText,            TEXT_CERULEANCAVEB1F_MAX_REVIVE

CeruleanCaveB1FTrainerHeaders:
	def_trainers
MewtwoTrainerHeader:
	trainer EVENT_BEAT_MEWTWO, 0, MewtwoBattleText, MewtwoBattleText, MewtwoBattleText
MewTrainerHeader:
	trainer EVENT_BEAT_MEW, 0, MewBattleText, MewBattleText, MewBattleText
	db -1 ; end

CeruleanCaveB1FMewtwoText:
	text_asm
	ld hl, MewtwoTrainerHeader
	call TalkToTrainer
	jp TextScriptEnd

MewtwoBattleText:
	text_far _MewtwoBattleText
	text_asm
	ld a, MEWTWO
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

CeruleanCaveB1FMewText:
	text_asm
	ld hl, MewTrainerHeader
	call TalkToTrainer
	jp TextScriptEnd

MewBattleText:
	text_far _MewBattleText
	text_asm
	ld a, MEW
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd
