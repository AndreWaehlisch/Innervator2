--define locals
local L = Innervator2Locals;

function Innervator2.SetupSavedVars()
	--returns true if var is NOT desired type
	local function CheckVar(var,desiredtype,minval,maxmval)
		local result = true;
		
		if type(var)==desiredtype then
			result = false;
		end;
		
		if minval and maxval and result then
			if var < minval then
				result = false;
			elseif var > maxval then
				result = false;
			end;
		end;
		
		return result;
	end;

	--for Config table
	local function CheckVarAndSetCheckBox(ConfigEntry,myType,CheckBox,StandardMapping)		
		if CheckVar(Innervator2Config[ConfigEntry],myType) then
			Innervator2Config[ConfigEntry] = StandardMapping;
		end;
		CheckBox:SetChecked(Innervator2Config[ConfigEntry]);
	end;
	
	--main config table
	if CheckVar(Innervator2Config,"table") then
		Innervator2Config = {};
	end;
	
	--mana pot
	if CheckVar(Innervator2Config["ManaPotThreshold"],"number",0,100) then
		Innervator2Config["ManaPotThreshold"] = 25;
	end;
	Innervator2.OptionsSliderManaPotThreshold:SetValue(Innervator2Config["ManaPotThreshold"]);
	
	CheckVarAndSetCheckBox("ManaPotEnabled","boolean",Innervator2.OptionsCheckManaPot,true);
	
	if not Innervator2Config["ManaPotEnabled"] then
		_G[Innervator2.OptionsSliderManaPotThreshold:GetName() .. 'Low']:SetText("");
		_G[Innervator2.OptionsSliderManaPotThreshold:GetName() .. 'High']:SetText("");
		Innervator2.OptionsSliderManaPotThreshold:Disable();
	end
	
	--sound mana pot
	if CheckVar(Innervator2Config["SoundfileManaPot"],"string") then
		Innervator2Config["SoundfileManaPot"] = "Sound\\character\\Tauren\\TaurenVocalFemale\\TaurenFemaleOutOfMana01.ogg";
	end
	Innervator2.OptionsManaPotEditSound:SetText(Innervator2Config["SoundfileManaPot"]);
	Innervator2.OptionsManaPotEditSound:SetCursorPosition(0);
	
	--warning type
	if CheckVar(Innervator2Config["WarningType"],"string") then
		Innervator2Config["WarningType"] = "Best";
	end;
	
	if Innervator2Config["WarningType"] == "Threshold" then
		Innervator2.OptionsCheckWarningBest:SetChecked(false);
		Innervator2.OptionsCheckWarningThreshold:SetChecked(true);
	else
		Innervator2.OptionsCheckWarningBest:SetChecked(true);
		Innervator2.OptionsCheckWarningThreshold:SetChecked(false);
		_G[Innervator2.OptionsSliderWarningThreshold:GetName() .. 'Low']:SetText("");
		_G[Innervator2.OptionsSliderWarningThreshold:GetName() .. 'High']:SetText("");
		Innervator2.OptionsSliderWarningThreshold:Disable();
	end;
	
	--warning threshold
	if CheckVar(Innervator2Config["WarningThreshold"],"number",0,100) then
		Innervator2Config["WarningThreshold"] = 75;
	end;
	Innervator2.OptionsSliderWarningThreshold:SetValue(Innervator2Config["WarningThreshold"]);
	
	--frame flash red
	if CheckVar(Innervator2Config["FFred"],"number",0,1) then
		Innervator2Config["FFred"] = 0;
	end;
	
	--frame flash green
	if CheckVar(Innervator2Config["FFgreen"],"number",0,1) then
		Innervator2Config["FFgreen"] = 1;
	end;
	
	--frame flash blue
	if CheckVar(Innervator2Config["FFblue"],"number",0,1) then
		Innervator2Config["FFblue"] = 0;
	end;

	--frame flash
	Innervator2.OptionsWarningEditFlashcolor:SetText(Innervator2Config["FFred"].." "..Innervator2Config["FFgreen"].." "..Innervator2Config["FFblue"]);
	Innervator2.OptionsWarningEditFlashcolor:SetCursorPosition(0);
	
	CheckVarAndSetCheckBox("Flash","boolean",Innervator2.OptionsCheckFlash,true);
	
	--enable/disable stuff
	CheckVarAndSetCheckBox("EnableDisableArena","boolean",Innervator2.EnableDisableButtonArena,true);
	CheckVarAndSetCheckBox("EnableDisableBattleground","boolean",Innervator2.EnableDisableButtonBattleground,true);
	CheckVarAndSetCheckBox("EnableDisableRaid","boolean",Innervator2.EnableDisableButtonRaid,true);
	CheckVarAndSetCheckBox("EnableDisableParty","boolean",Innervator2.EnableDisableButtonParty,true);
	CheckVarAndSetCheckBox("EnableDisableOutside","boolean",Innervator2.EnableDisableButtonOutside,true);
	CheckVarAndSetCheckBox("IgnoreArena","boolean",Innervator2.IgnoreArena,true);
	CheckVarAndSetCheckBox("IgnoreBattleground","boolean",Innervator2.IgnoreBattleground,true);
	CheckVarAndSetCheckBox("IgnoreRaid","boolean",Innervator2.IgnoreRaid,true);
	CheckVarAndSetCheckBox("IgnoreParty","boolean",Innervator2.IgnoreParty,true);
	CheckVarAndSetCheckBox("IgnoreOutside","boolean",Innervator2.IgnoreOutside,true);
	CheckVarAndSetCheckBox("EnableDisableFeral","boolean",Innervator2.EnableDisableButtonFeral,true);
	CheckVarAndSetCheckBox("EnableDisableMoonkin","boolean",Innervator2.EnableDisableButtonMoonkin,true);
	CheckVarAndSetCheckBox("EnableDisableGuardian","boolean",Innervator2.EnableDisableButtonGuardian,true);
	CheckVarAndSetCheckBox("EnableDisableRestoration","boolean",Innervator2.EnableDisableButtonRestoration,true);
	CheckVarAndSetCheckBox("IgnoreFeral","boolean",Innervator2.IgnoreFeral,true);
	CheckVarAndSetCheckBox("IgnoreMoonkin","boolean",Innervator2.IgnoreMoonkin,true);
	CheckVarAndSetCheckBox("IgnoreGuardian","boolean",Innervator2.IgnoreGuardian,true);
	CheckVarAndSetCheckBox("IgnoreRestoration","boolean",Innervator2.IgnoreRestoration,true);
	
	if CheckVar(Innervator2Config["EnableDisableOnInstance"],"boolean") then
		Innervator2Config["EnableDisableOnInstance"] = true;
	end;
	
	if Innervator2Config["EnableDisableOnInstance"] then
		Innervator2.EnableDisableOnInstance:SetChecked(true);
		Innervator2.EnableDisableOnSpec:SetChecked(false);
		
		Innervator2.EnableDisableButtonFeral:Disable();
		Innervator2.EnableDisableButtonMoonkin:Disable();
		Innervator2.EnableDisableButtonGuardian:Disable();
		Innervator2.EnableDisableButtonRestoration:Disable();
		Innervator2.IgnoreFeral:Disable();
		Innervator2.IgnoreMoonkin:Disable();
		Innervator2.IgnoreGuardian:Disable();
		Innervator2.IgnoreRestoration:Disable();
		
		if Innervator2Config["IgnoreArena"] then
			Innervator2.EnableDisableButtonArena:Disable();
		end;
		if Innervator2Config["IgnoreBattleground"] then
			Innervator2.EnableDisableButtonBattleground:Disable();
		end;
		if Innervator2Config["IgnoreRaid"] then
			Innervator2.EnableDisableButtonRaid:Disable();
		end;
		if Innervator2Config["IgnoreParty"] then
			Innervator2.EnableDisableButtonParty:Disable();
		end;
		if Innervator2Config["IgnoreOutside"] then
			Innervator2.EnableDisableButtonOutside:Disable();
		end;
	else
		Innervator2.EnableDisableOnInstance:SetChecked(false);
		Innervator2.EnableDisableOnSpec:SetChecked(true);
		
		Innervator2.EnableDisableButtonArena:Disable();
		Innervator2.EnableDisableButtonBattleground:Disable();
		Innervator2.EnableDisableButtonRaid:Disable();
		Innervator2.EnableDisableButtonParty:Disable();
		Innervator2.EnableDisableButtonOutside:Disable();
		Innervator2.IgnoreArena:Disable();
		Innervator2.IgnoreBattleground:Disable();
		Innervator2.IgnoreRaid:Disable();
		Innervator2.IgnoreParty:Disable();
		Innervator2.IgnoreOutside:Disable();
		
		if Innervator2Config["IgnoreFeral"] then
			Innervator2.EnableDisableButtonFeral:Disable();
		end;
		if Innervator2Config["IgnoreMoonkin"] then
			Innervator2.EnableDisableButtonMoonkin:Disable();
		end;
		if Innervator2Config["IgnoreGuardian"] then
			Innervator2.EnableDisableButtonGuardian:Disable();
		end;
		if Innervator2Config["IgnoreRestoration"] then
			Innervator2.EnableDisableButtonRestoration:Disable();
		end;
	end;
	
	--chatframe
	if CheckVar(Innervator2Config["Chatframe"],"string") then
		Innervator2.OptionsWarningEditChatframe:SetText(L["OptionsWarningChatframesDefault"]);
		Innervator2Config["Chatframe"] = "Default Chatframe";
	else
		if (Innervator2Config["Chatframe"] == "DBM Frame") then
			Innervator2.OptionsWarningEditChatframe:SetText(L["OptionsWarningChatframesDBM"]);
		elseif (Innervator2Config["Chatframe"] == "Error Frame") then
			Innervator2.OptionsWarningEditChatframe:SetText(L["OptionsWarningChatframesError"]);
		else
			Innervator2.OptionsWarningEditChatframe:SetText(L["OptionsWarningChatframesDefault"]);
			Innervator2Config["Chatframe"] = "Default Chatframe";
		end;
	end;
	Innervator2.OptionsWarningEditChatframe:SetCursorPosition(0);
	
	--icon for warning
	if CheckVar(Innervator2Config["Icon"],"string") then
		Innervator2.OptionsWarningEditIcon:SetText(L["OptionsWarningIconsInnervate"]);
		Innervator2Config["Icon"] = L["OptionsWarningIconsInnervate"];
	else
		Innervator2.OptionsWarningEditIcon:SetText(Innervator2Config["Icon"]);
	end;
	Innervator2.OptionsWarningEditIcon:SetCursorPosition(0);
	
	--line count
	if CheckVar(Innervator2Config["LineCount"],"string") then
		Innervator2Config["LineCount"] = L["OptionsWarningDoubleLine"];
	else
		if (Innervator2Config["LineCount"] ~= L["OptionsWarningSingleLine"]) and (Innervator2Config["LineCount"] ~= L["OptionsWarningSingleLine"]) and (Innervator2Config["LineCount"] ~= L["OptionsWarningSingleLine"]) then
			Innervator2Config["LineCount"] = L["OptionsWarningDoubleLine"];
		end;
	end;
	Innervator2.OptionsWarningEditLineCount:SetText(Innervator2Config["LineCount"]);
	Innervator2.OptionsWarningEditLineCount:SetCursorPosition(0);

	if Innervator2Config["LineCount"] == L["OptionsWarningSingleLine"] then
		Innervator2.LineCounter = 1;
	elseif Innervator2Config["LineCount"] == L["OptionsWarningTripleLine"] then
		Innervator2.LineCounter = 3;
	else
		Innervator2.LineCounter = 2;
	end;
	
	--sound
	CheckVarAndSetCheckBox("Sounds","boolean",Innervator2.OptionsCheckSound,true);
	
	if CheckVar(Innervator2Config["Soundfile1"],"string") then
		Innervator2Config["Soundfile1"] = "Sound\\Spells\\SummonReindeer.ogg";
	end;
	Innervator2.OptionsWarningEditSound1:SetText(Innervator2Config["Soundfile1"]);
	Innervator2.OptionsWarningEditSound1:SetCursorPosition(0);

	if CheckVar(Innervator2Config["Soundfile2"],"string") then
		Innervator2Config["Soundfile2"] = "Sound\\character\\Tauren\\TaurenFemaleErrorMessages\\TaurenFemale_err_outofrange02.ogg";
	end;
	Innervator2.OptionsWarningEditSound2:SetText(Innervator2Config["Soundfile2"]);
	Innervator2.OptionsWarningEditSound2:SetCursorPosition(0);
	
	--saves the (localized) standard macro to the var Innervator2.LocalizedStandardMacro
	function Innervator2.SetLocalizedStandardMacro()
		local LocalizedInnervate = GetSpellInfo(29166);

		Innervator2.LocalizedStandardMacro =	format("%s\n%s\n%s\n%s\n%s",
													"#showtooltip "..LocalizedInnervate,
													"/cast [button:1, nomod] "..LocalizedInnervate,
													"/cast [button:2, @/i2, nomod] "..LocalizedInnervate,
													"/cast [mod:alt,button:1, @player] "..LocalizedInnervate,
													"/cast [mod:alt,button:2, @player] "..LocalizedInnervate);
	end;
	
	--macro
	if (CheckVar(Innervator2InputMacroText,"string")) or (strlenutf8(Innervator2InputMacroText)<10) then
		Innervator2.SetLocalizedStandardMacro();
		Innervator2InputMacroText = Innervator2.LocalizedStandardMacro;
	end;
	
	Innervator2.OptionsMacroInputMacroText:SetText(Innervator2InputMacroText);
end;