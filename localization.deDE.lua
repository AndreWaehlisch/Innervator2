if (GetLocale() ~= "deDE") then
	return
end

Innervator2Locals = setmetatable({
	--Printstuff
	["PrintFirstLogin"] = "Dies ist dein erster Login mit diesem Addon. Als Anregen Ziel wurdest Du selbst gesetzt: ",
	["PrintNoTarget"] = "Kein Anregen Ziel angegeben.",
	["PrintMacroPlayerInCombat"] = "Du befindest dich im Kampf. Makro wird erstellt, wenn du aus dem Kampf bist.",
	["PrintSoundsDisabled"] = "Sounds sind deaktiviert. Benutze [|cff00FF00/i2 sound|r], um Sounds zu aktivieren.",
	["PrintSoundsEnabled"] = "Sounds sind aktiviert. Benutze [|cff00FF00/i2 sound|r] erneut, um Sounds zu deaktivieren.",
	["PrintAddonDidNotLoadup"] = "Das Addon wurde deaktiviert, weil du den Anregen Zauber nicht beherschst.",
	["PrintAddonIsAlreadyDisabled"] = "Das Addon is bereits deaktiviert.",
	["PrintAddonIsAlreadyEnabled"] = "Das Addon ist bereits aktiviert.",
	["PrintAddonDisabled"] = "Deaktiviert. Benutze den Befehl [|cff00FF00/i2 on|r], um das Addon zu aktivieren.",
	["PrintAddonEnabled"] = "Aktiviert. Benutze den Befehl [|cff00FF00/i2 off|r], um das Addon zu deaktivieren.",
	["PrintEditmacroNoTargetFound"] = "Kein Anregen Ziel im Makro gefunden. Benutze im Makro wenigstens ein Mal /i2 als Dummy daf\195\188r.",
	["PrintEditmacroCleared"] = "Der Standard Code f\195\188r das Makro wurde wiederhergestellt.",
	["PrintEditMacroError"] = "Fehler! Konnte Makro nicht editieren.",
	["PrintEditmacroSaved"] = "Das neue Makro wurde vom Addon gespeichert. Du kannst das passende Makro jetzt immer mit [|cff00FF00/i2 macro|r] erstellen.",
	["PrintEditmacroNotCorrect"] = "Das Makro konnte nicht ausgelesen werden oder ist zu kurz (mindestens 10 Zeichen).",
	["PrintEditmacroNotFound"] = "Makro nicht gefunden!",
	["PrintMacroForEditCreated"] = "Macro zum Editieren erstellt (I2InputMacroText). Bearbeite das Makro nach deinen W\195\188nschen und dann gebe [|cff00FF00/i2 macro save|r] ein, um es vom Addon speichern zu lassen. F\195\188r das Anregen Ziel setze /i2 als Dummy im Makro ein, dieses wird dann immer durch das aktuelle Ziel ersetzt.",
	["PrintMacroNoSpace"] = "Konnte Makro nicht erstellen. Es sind bereits zu viele Makros vorhanden.",
	["PrintMacroCreated"] = "Makro wurde erstellt bzw. editiert: [|cffFF7D0A|HInnervator2|hInnervator2Macro|h|r]. Klicke auf den Namen, um das Makro an den Cursor zu heften.",
	["PrintSetTarget1"] = "Anregen Ziel gesetzt zu ",
	["PrintSetTarget2"] = " Verwende den Befehl [|cff00FF00/i2 test|r], um eine /who Anfrage an den Server zu senden. Dies kann n\195\188tzlich sein, um die korrekte Schreibung des Anregen Ziels zu \195\188berpr\195\188fen.",
	["PrintUnknownCommand1"] = "Unbekannter Befehl: |cff5555FF",
	["PrintUnknownCommand2"] = "Um die Hilfe anzuzeigen, verwende den Befehl [|cff00FF00/i2 help|r], ohne die eckigen Klammern.",
	["PrintTarget"] = "Dein Anregen Ziel ist ",

	--ChatSpamer
	["PrintChatSpam"] = "|cffFF0000Anregen jetzt auf|r ",
	["PrintChatSpamOutOfRange"] = "|cffFF0000Au\195\159er Reichweite f\195\188r Anregen, lauf zu|r ",
	["PrintChatSpamManaPot"] = "|cff5555FFNutze deinen Manatrank jetzt!|r",

	--GUI
	["OptionsButtonHelp"] = "Hilfe",
	["SelectDrop_CLOSE_INFO_TEXT"] = "Schließen",
		--mainpanel
	["OptionsStringInfo"] = " Optionen.\n Benutze [|cff00FF00/i2 help|r], um die Hilfe anzuzeigen (ohne eckige Klammern).",
	["OptionsCheckEnableAddon_LABEL"] = "Addon aktivieren",
	["OptionsCheckEnableAddon_HINT"] = "Aktiviert/deaktiviert das Addon tempor\195\164r.",
	["OptionsStringSetTarget"] = "Neues Anregen Ziel setzen:",
	["OptionsButtonSetTarget"] = "Ok",
	["OptionsWarningByThreshold_LABEL"] = "Warnung nach festem Wert",
	["OptionsWarningByThreshold_HINT"] = "Wenn diese Option aktiviert ist, wird die Anregen Warnung dann ausgegeben, wenn das Mana einen festlegbaren Prozentteil des maximalen Manas deines Anregen-Ziels unterschreitet.",
	["OptionsWarningByBest_LABEL"] = "Fr\195\188hwarnung",
	["OptionsWarningByBest_HINT"] = "Wenn diese Option aktiviert ist, wird die Anregen Warnung so fr\195\188h wie m\195\182glich ausgegeben, d.h. sobald dein aktuelles Mana eine Stufe erreicht, auf der kein Mana durch Anregen verschwendet wird.",
	["OptionsSliderThresholdLabel"] = "Grenzwert: ",

		--warningpanels
	["Innervator2Warning1Panel_NAME"] = "Warnung1",
	["Innervator2Warning2Panel_NAME"] = "Warnung2",
	["OptionsWarning1StringInfo"] = " |cffFFFFFFWarnung1|r Optionen.\n Benutze [|cff00FF00/i2 help|r], um die Hilfe anzuzeigen (ohne eckige Klammern).",
	["OptionsWarning2StringInfo"] = " |cffFFFFFFWarnung2|r Optionen.\n Benutze [|cff00FF00/i2 help|r], um die Hilfe anzuzeigen (ohne eckige Klammern).",
	["OptionsCheckSound_LABEL"] = "Sound",
	["OptionsCheckSound_HINT"] = "Aktiviert/deaktiviert das Abspielen von Sounds durch dieses Addon.",
	["OptionsWarningStringSound1"] = "Warnsound:",
	["OptionsWarningStringSound2"] = "Au\195\159er-Reichweite Sound:",
	["OptionsWarningSelectSounds"] = "Sounds:",
	["OptionsWarningButtonSave"] = "Speichern",
	["OptionsWarningButtonTest"] = "Test",
	["OptionsWarningTestMessage"] = "Dies ist eine Test Nachricht.",
	["OptionsWarningSoundtestPlayed"] = "' abgespielt.",
	["OptionsWarningStringChatframe"] = "Ausgabe Chatframe:",
	["OptionsWarningChatframesDefault"] = "Standard Chatframe",
	["OptionsWarningChatframesError"] = "Fehler-Chatframe",
	["OptionsWarningIcon"] = "Icon:",
	["OptionsWarningChatframeSaved"] = "Chatframe wurde ge\195\164ndert zu: ",
	["OptionsWarningIconSaved"] = "Icon wurde ge\195\164ndert zu: ",
	["OptionsWarningLineCount"] = "Zeilenanzahl:",
	["OptionsWarningSingleLine"] = "Einzeilig",
	["OptionsWarningDoubleLine"] = "Zweizeilig",
	["OptionsWarningTripleLine"] = "Dreizeilig",
	["OptionsWarningLineCountSaved"] = "Neue Zeilenanzahl wurde gespeichert: ",
	["OptionsWarningFrameflash_NAME"] = "Frameflash",
	["OptionsWarningFrameflash_LABEL"] = "Aktiviert das Aufblinken des Randes des Bildschirms, sobald die Anregen Warnung ausgegeben wird (Frameflash).",
	["OptionsWarningIconsInnervate"] = "Anregen",
	["OptionsWarningIconsStar"] = "Stern",
	["OptionsWarningIconsCircle"] = "Kreis",
	["OptionsWarningIconsDiamond"] = "Diamant",
	["OptionsWarningIconsTriangle"] = "Dreieck",
	["OptionsWarningIconsMoon"] = "Mond",
	["OptionsWarningIconsSquare"] = "Quadrat",
	["OptionsWarningIconsCross"] = "Kreuz",
	["OptionsWarningIconsSkull"] = "Totenkopf",
	["OptionsWarningIconsSkull2"] = "Totenkopf2",
	["OptionsWarningIconsTreeOfLife"] = "Baum des Lebens",
	["OptionsWarningIconsReplenishment"] = "Erfrischung",
	["OptionsWarningIconsNone"] = "Keins",
	["OptionsWarningSound1Saved"] = "Neuer Warnsound gespeichert: ",
	["OptionsWarningSound2Saved"] = "Neuer Au\195\159er-Reichweite Sound gespeichert: ",
	["OptionsWarningFlashColor"] = "Flash Farbe:",
	["OptionsWarningWrongInputColor"] = "Falscher Farb Eingabewert.",
	["OptionsWarningColorPreview"] = "Vorschau:",
	["OptionsWarningErrorColorpickerShown"] = "Die Farbauswahl wird bereits angezeigt.",
	["OptionsWarningFrameflashColorSaved"] = "Neue Frameflash Farbe gespeichert.",
	["OptionsWarningFrameflashSave_TOOLTIP"] = "Die Eingabe muss aus drei Werten zwischen 0 und 1 bestehen, getrennt mit einem Leerzeichen. Diese stehen f\195\188r eine RGB Farbe (rot, gr\195\188n, blau). Ein Beispiel w\195\164re: '0 0.5 1', ohne die Anf\195\188hrungszeichen.",
	["OptionsWarningLineCount_TOOLTIP"] = "Legt fest, über wieviele Zeilen die Warnungen gehen sollen.",

		--macropanel
	["Innervator2MacroPanel_NAME"] = "Macro (fortgeschritten)",
	["OptionsMacroStringInfo"] = " |cffFFFFFFMacro|r Optionen.\n Benutze [|cff00FF00/i2 help|r], um die Hilfe anzuzeigen (ohne eckige Klammern).",
	["OptionsMacroPrintHyperlinkMacro"] = "Hyperlink",
	["OptionsMacroEditTheMacro"] = "Macro editieren",
	["OptionsMacroSaveTheMacro"] = "Macro speichern",
	["OptionsMacroInputMacroTextInfo"] = "Dies ist der momentane Macro Code:",
	["OptionsMacroPrintHyperlink"] = "Makro: [|cffFF7D0A|HInnervator2|hInnervator2Macro|h|r]. Klicke auf den Namen, um das Makro an den Cursor zu heften (funktioniert nicht im Kampf).",

		--ManaPotPanel
	["Innervator2ManaPotPanel_NAME"] = "Manatrank",
	["OptionsManaPotStringInfo"] = " |cffFFFFFFManatrank|r Optionen.\n Benutze [|cff00FF00/i2 help|r], um die Hilfe anzuzeigen (ohne eckige Klammern).",
	["OptionsCheckManaPot_HINT"] = "Wenn diese Option aktiviert wird, erinnert dich das Addon auch daran, einen Manatrank im Kampf zu benutzen (ab einen bestimmten Grenzwert an Mana).",
	["OptionsCheckManaPot_LABEL"] = "Manatrank aktivieren",
	["OptionsManaPotSoundSaved"] = "Manatrank Sound wurde gespeichert:",

		--ButtonHelp
	["OptionsBH1_1"] = "Das Addon kann tempor\195\164r deaktiviert werden. Wenn deaktiviert, werden keine Warnungen vom Addon ausgegeben. De- und Aktivierung kann im Kampf vorgenommen werden.",
	["OptionsBH1_2"] = "Als Anregen Ziel kann ein beliebiger Spieler festgelegt werden. Das Addon wird dann das Mana von dieser Person \195\188berpr\195\188fen. Innervator2 kann dich dann auch warnen, wenn du zu weit weg von diesem Spieler bist.",
	["OptionsBH2"] = "Aktiviert/Deaktiviert das Addon, basierend auf deiner Talentspezialisierung oder deinem Aufenthaltsort. Du kannst den Status immer mit [|cff00FF00/i2 disable|r] oder [|cff00FF00/i2 enable|r] \195\164ndern.",
	["OptionsBH3"] = "Du kannst entweder 'Fr\195\188hwarnung' (die Anregen Warnung wird so fr\195\188h wie m\195\182glich ausgegeben, d.h. sodass kein Mana verschwendet wird) oder 'Warnung nach festem Wert' (die Anregen Warnung wird nach einem festen Mana-Prozent-Wert ausgegeben).",
	["OptionsWarning1BH"] = "Zu allen Warnungen kann auch ein kleiner Sound ausgegeben werden. Diese k\195\182nnen hier de-/aktiviert werden. Eine Liste bereits vorgegebener Sounds ist \195\188ber den '!' Button verf\195\188gbar. Warnsound: Der Sound der ausgegeben wird, wenn Anregen genutzt werden sollte. Au\195\159er-Reichweite Sound: Der Sound der ausgegeben wird, wenn du Anregen benutzen solltest und zu weit weg vom Anregen Ziel bist.",
	["OptionsWarning2BH1"] = "Frameflash: L\195\164sst die R\195\164nder des Bildschirmes aufblinken wenn aktiviert. Um die Farbe zu \195\164ndern, klicke auf den '!' und such dir eine neue aus.",
	["OptionsWarning2BH2"] = "Ausgabe Chatframe: Der Chatframe in dem die (Text-) Warnungen ausgegeben werden. Der Standard Chatframe ist derjenige, in dem der Allgemein- und Handelchat zu sehen sein sollten. Der Fehler-Chatframe ist ein Frame in der oberen Mitte des Bildschirms. Du kannst au\195\159erdem den DBM Frame ausw\195\164hlen. Dieser ist auch in der oberen Mitte, sieht aber etwas schicker aus. Weiterhin kann ein Icon ausgew\195\164hlt werden, sodass die (Text-T Warnungen besser sichtbar sind.",
	["OptionsMacroBH"] = "(Fortgeschritten) Das Addon kann ein Makro zur Verf\195\188gung stellen, in dem immer das aktuelle Anregen Ziel steht. In der Dokumentation sind mehr Information zu diesem Thema zu finden (Englisch).",
	["OptionsManaPotBH"] = "Das Addon kann dich auch daran erinnern, dass du ein Manatrank benutzt. Die Warnung erfolgt nach einem festen Mana-Prozent-Wert. Weiterhin kann ein extra Sound f\195\188r diese Warnung festgelegt werden. Dies funktioniert nur wenn du einen von den folgenden Manatr\195\164nken benutzbar im Inventar hast: Trank der Konzentration, Mysteri\195\182ser Trank oder Mythischer Manatrank.",

	--THEHELP
	["HELP1"] = "Zeige die Hilfe an...",
	["HELP2"] = "Alle Befehle werden ohne eckige Klammern eingegeben. Diese sollen nur die Lesbarkeit der Befehle verbessern.",
	["HELP3"] = "[|cff00FF00/i2|r] und [|cff00FF00/innervator2|r] k\195\182nnen f\195\188r alle Befehle analog verwendet werden.",
	["HELP4"] = "Um dieses Addon (tempor\195\164r) zu deaktivieren, verwende den Befehl [|cff00FF00/i2 disable|r].",
	["HELP5"] = "Um dieses Addon danach wieder zu aktivieren, verwende den Befehl[|cff00FF00/i2 enable|r].",
	["HELP6"] = "Um das aktuelle Anregen Ziel auszugeben, verwende den Befehl [|cff00FF00/i2 print|r].",
	["HELP7"] = "Verwende den Befehl [|cff00FF00/i2 set|r |cffFF0000xxx|r], um ein neues Anregen Ziel festzulegen, dabei wird [|cffFF0000xxx|r] durch den Namen des Spielers ersetzt, dem du zuk\195\188nftig dein Anregen geben m\195\182chtest.",
	["HELP8"] = "Um eine /who Anfrage an den Server zu senden, verwende den Befehl [|cff00FF00/i2 test|r]. Dies kann n\195\188tzlich sein, um die korrekte Schreibung des Anregen Ziels zu \195\188berpr\195\188fen.",
	["HELP9"] = "Das Addon wird dich mit einem Sound daran erinnern, dein Anregen zu benutzen. Um das Abspielen der Warnt\195\182ne zu (de)aktiveren, nutze den Befehl [|cff00FF00/i2 sound|r].",
	["HELP10"] = "F\195\188r weitere Optionen kann das GUI mit [|cff00FF00/i2 opt|r] aufgerufen werden.",
	["HELP11"] = "...Ende der Hilfe."
}, {__index = Innervator2Locals})

--UTF8 encoding:
-- ä	\195\164
-- Ä	\195\132
-- ö	\195\182
-- Ö	\195\150
-- ü	\195\188
-- Ü	\195\156
-- ß	\195\159