CeruleanCave1F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, CeruleanCave1FTrainerHeaders
	ld de, CeruleanCave1F_ScriptPointers
	ld a, [wCeruleanCave1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeruleanCave1FCurScript], a
	ret

CeruleanCave1F_ScriptPointers:
	def_script_pointers
	dw_const CheckFightingMapTrainers,              SCRIPT_CERULEANCAVE1F_DEFAULT
	dw_const DisplayEnemyTrainerTextAndStartBattle, SCRIPT_CERULEANCAVE1F_START_BATTLE
	dw_const EndTrainerBattle,                      SCRIPT_CERULEANCAVE1F_END_BATTLE

CeruleanCave1F_TextPointers:
	def_text_pointers
	dw_const PickUpItemText, TEXT_CERULEANCAVE1F_FULL_RESTORE
	dw_const PickUpItemText, TEXT_CERULEANCAVE1F_MAX_ELIXER
	dw_const PickUpItemText, TEXT_CERULEANCAVE1F_NUGGET

CeruleanCave1FTrainerHeaders:
	def_trainers
	db -1 ; end