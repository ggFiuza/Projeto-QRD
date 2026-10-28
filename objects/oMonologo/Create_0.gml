//Luma's inner monologue before the boss fight (rMonologo -> rChefe): black screen, typed out
//letter by letter. ENTER completes the paragraph being typed, then shows the next; ESC skips.
//Draft text for the team to review.
lines = [
	{ text: "Os túneis ficaram para trás.", col: c_white },
	{ text: "Cada robô, cada serra, cada registro que encontrei pelo caminho me contou a mesma história: as raízes desta terra estão sendo arrancadas para alimentar máquinas que nunca dormem.", col: c_white },
	{ text: "Eu caí, levantei e continuei. Nem sei direito como cheguei tão longe... só sei que não podia parar.", col: c_white },
	{ text: "E agora, depois de tudo, ela está logo ali, do outro lado.", col: c_white },
	{ text: "Mariana.", col: make_colour_rgb(235, 50, 40) },
	{ text: "Desta vez eu não vou fugir. Eu vou te derrotar, Mariana. Pelas raízes. Por todos nós.", col: c_white },
];
current = 0;     //paragraph being typed
shown = 0;       //letters of it on screen
wait = 30;       //frames before the next letter (starts with a short pause)
t = 0;