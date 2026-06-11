PewterMart_Script:
	call EnableAutoTextBoxDrawing
	ld a, 1 << BIT_NO_AUTO_TEXT_BOX
	ld [wAutoTextBoxDrawingControl], a
	ret

PewterMart_TextPointers:
	def_text_pointers
	dw_const PewterMartClerkText,     TEXT_PEWTERMART_CLERK
	dw_const PewterMartYoungsterText, TEXT_PEWTERMART_YOUNGSTER
	dw_const PewterMartSuperNerdText, TEXT_PEWTERMART_SUPER_NERD

PewterMartYoungsterText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _PewterMartYoungsterText
	text_end

PewterMartSuperNerdText:
	text_asm
	ld hl, .Text
	call PrintText
	jp TextScriptEnd

.Text:
	text_far _PewterMartSuperNerdText
	text_end

PewterMartClerkText:
	script_mart MASTER_BALL, FULL_RESTORE, FULL_HEAL, MAX_REVIVE, MAX_ELIXER, MAX_REPEL, RARE_CANDY