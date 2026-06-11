SaffronMart_Script:
	jp EnableAutoTextBoxDrawing

SaffronMart_TextPointers:
	def_text_pointers
	dw_const SaffronMartClerkText,        TEXT_SAFFRONMART_CLERK
	dw_const SaffronMartSuperNerdText,    TEXT_SAFFRONMART_SUPER_NERD
	dw_const SaffronMartCooltrainerFText, TEXT_SAFFRONMART_COOLTRAINER_F

SaffronMartSuperNerdText:
	text_far _SaffronMartSuperNerdText
	text_end

SaffronMartCooltrainerFText:
	text_far _SaffronMartCooltrainerFText
	text_end

SaffronMartClerkText:
	script_mart MASTER_BALL, FULL_RESTORE, FULL_HEAL, MAX_REVIVE, MAX_ELIXER, MAX_REPEL, RARE_CANDY