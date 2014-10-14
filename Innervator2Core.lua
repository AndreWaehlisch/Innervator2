--Innervator2 by Hoochie@EU-Dethecus
--Build after the old (no longer maintained) Innervator by Nebelmond/vancleef: http://wow.curseforge.com/addons/ivtr/

--define locals
local LISP = LibStub:GetLibrary("LibItemStatsPlus");
local L = Innervator2Locals;
local InnervateSpell = 29166;
local InnervateName = GetSpellInfo(InnervateSpell);
local _;
local CurrentWatchTime, LastWatchTime, CTT = 0, 0, 1;
local InnervatorString = "|cffFF7D0AInnervator2|r: ";
local UnitPowerFrame = CreateFrame("Frame");
local AddonLoaded, AddonActive, CreateMacroAfterCombat, IsMoonkin = false, false, false, false;
local TargetString, TargetStringYellow = "", "";
local MacroIcon = "Spell_Nature_Lightning";

--takeover some Innervator2-table vars
local LocalizedStandardMacro = Innervator2.LocalizedStandardMacro;
local print = Innervator2.print;

--local optimizers
local gsub = gsub;
local strlower = strlower;
local UnitName = UnitName;
local UnitPower = UnitPower;
local UnitPowerMax = UnitPowerMax;
local UnitIsDeadOrGhost = UnitIsDeadOrGhost;
local GetTime = GetTime;
local GetSpellInfo = GetSpellInfo;
local IsAddOnLoaded = IsAddOnLoaded;
local GetSpecialization = GetSpecialization;
local IsLoggedIn = IsLoggedIn;
local UnitAffectingCombat = UnitAffectingCombat;
local IsInInstance = IsInInstance;
local GetNumMacros = GetNumMacros;
local type = type;
local IsSpellKnown = IsSpellKnown;
local strlenutf8 = strlenutf8;
local strupper = strupper;
local IsSpellInRange = IsSpellInRange;
local GetItemCooldown = GetItemCooldown;
local GetMacroIndexByName = GetMacroIndexByName;
local strfind = strfind;
local UnitBuff = UnitBuff;
local LoadAddOn = LoadAddOn;
local PlaySoundFile = PlaySoundFile;
local EditMacro = EditMacro;
local CreateMacro = CreateMacro;
local PickupMacro = PickupMacro;
local DeleteMacro = DeleteMacro;
local GetMacroBody = GetMacroBody;
local GetSpellCooldown = GetSpellCooldown;
local GetGlyphSocketInfo = GetGlyphSocketInfo;
local strbyte = strbyte;
local max = max;
local floor = floor;

--icon list
function Innervator2.Innervator2MsgIcon(TheIcon)
	if TheIcon == L["OptionsWarningIconsInnervate"] then--innervate
		return "|TInterface\\Icons\\Spell_Nature_Lightning:20|t"
	elseif TheIcon == L["OptionsWarningIconsStar"] then--star
		return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:20|t"
	elseif TheIcon == L["OptionsWarningIconsCircle"] then--circle
		return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:20|t"
	elseif TheIcon == L["OptionsWarningIconsDiamond"] then--diamond
		return "|TInterface\\TargetingFrame\\UI-RAIDTARGETINGICON_3:20|t"
	elseif TheIcon == L["OptionsWarningIconsTriangle"] then--triangle
		return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:20|t"
	elseif TheIcon == L["OptionsWarningIconsMoon"] then--moon
		return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:20|t"
	elseif TheIcon == L["OptionsWarningIconsSquare"] then--square
		return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:20|t"
	elseif TheIcon == L["OptionsWarningIconsCross"] then--cross
		return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:20|t"
	elseif TheIcon == L["OptionsWarningIconsSkull"] then--skull
		return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:20|t"
	elseif TheIcon == L["OptionsWarningIconsSkull2"] then--skull2
		return "|TInterface\\TargetingFrame\\TargetDead:20|t"
	elseif TheIcon == L["OptionsWarningIconsTreeOfLife"] then--tree of life
		return "|TInterface\\Icons\\Ability_Druid_TreeofLife:20|t"
	elseif TheIcon == L["OptionsWarningIconsReplenishment"] then--replenishment
		return "|TInterface\\Icons\\Spell_Magic_ManaGain:20|t"
	else
		return ""
	end;
end;

--create frames and flahes them
local CreatedFrames = false;
function Innervator2.Innervator2FrameFlash(MyRed,MyGreen,MyBlue)
	if not CreatedFrames then
		CreatedFrames = true;
		for i=1,4 do
			local TheFlashFrame = CreateFrame("Frame","Innervator2_FlashFrame_"..i,UIParent);
			
			TheFlashFrame:Show();
			TheFlashFrame:SetAlpha(0);
			
			local fader = TheFlashFrame:CreateAnimationGroup("Innervator2_FlashAnimation_"..i);
			
			--flicker fix
			local fade1 = fader:CreateAnimation("Alpha");
			fade1:SetDuration(0);
			fade1:SetChange(-1);
			fade1:SetOrder(1);
			
			--fade in
			local fade2 = fader:CreateAnimation("Alpha");
			fade2:SetDuration(0.5);
			fade2:SetChange(0.5);
			fade2:SetOrder(2);
			
			--fade out
			local fade3 = fader:CreateAnimation("Alpha");
			fade3:SetDuration(0.5);
			fade3:SetChange(-0.5);
			fade3:SetOrder(3);
			
			TheFlashFrame:SetFrameStrata("BACKGROUND");

			if (i == 1) or (i == 2) then
				TheFlashFrame:SetHeight(40);
				TheFlashFrame:SetWidth(UIParent:GetWidth());
			else
				TheFlashFrame:SetWidth(40);
				TheFlashFrame:SetHeight(UIParent:GetHeight());
			end;

			TheFlashFrame.bg = TheFlashFrame:CreateTexture(nil,"CENTER");
			TheFlashFrame.bg:SetTexture(MyRed,MyGreen,MyBlue);
			TheFlashFrame.bg:SetAllPoints(TheFlashFrame);
			
			if i == 1 then
				TheFlashFrame:SetPoint("TOP");
			elseif i == 2 then
				TheFlashFrame:SetPoint("BOTTOM");
			elseif i == 3 then
				TheFlashFrame:SetPoint("LEFT");
			else
				TheFlashFrame:SetPoint("RIGHT");
			end;
		end;
	end;
	
	for i=1,4 do
		_G["Innervator2_FlashFrame_"..i].bg:SetTexture(MyRed,MyGreen,MyBlue);
		
		local k = 0;
		
		_G["Innervator2_FlashAnimation_"..i]:SetScript("OnFinished",function(self)
			k = k + 1;
			if k < 4 then
				self:Play();
			end;
				
			_G["Innervator2_FlashFrame_"..i]:SetAlpha(0);
		end);
		
		_G["Innervator2_FlashAnimation_"..i]:Play();
	end;
end;

--for UTF8sub function below
local function chsize(char)
	if not char then
		return 0
	elseif char>240 then
		return 4
	elseif char>225 then
		return 3
	elseif char>192 then
		return 2
	else
		return 1
	end;
end;

--UTF8 aware strsub function
--taken from http://wowprogramming.com/snippets/UTF-8_aware_stringsub_7
local function utf8sub(str,startChar,numChars)
	local startIndex = 1;
	while startChar>1 do
		local char = strbyte(str,startIndex);
		startIndex = startIndex + chsize(char);
		startChar = startChar - 1;
	end;

	local currentIndex = startIndex;
	while (numChars>0) and (currentIndex<=#str) do
		local char = strbyte(str,currentIndex);
		currentIndex = currentIndex + chsize(char);
		numChars = numChars -1;
	end;

	return str:sub(startIndex,currentIndex - 1)
end;

--taken from http://lua-users.org/wiki/SimpleRound
local function round(num)
   return tonumber(format("%.0f",num));
end

local ManaPotions = {
--http://ptr.wowhead.com/items=0.1?filter=cr=107:82;crs=0:2;crv=Restores:40304
	76098,--Master Mana Potion
	76094,--Alchemist's Rejuvenation
	57192,--Mythical Mana Potion
	57099,--Mysterious Potion
	57194,--Potion of Concentration
};

--check for mana pot
--return: 0(not ready), 1(ready)
local function PlayerCanUsePotion()
	local function CheckPot(startTime,duration,enable)
		if (startTime == 0) and (duration == 0) and (enable == 0) then
			return 0;--not in inventory
		elseif (startTime == 0) and (duration == 0) and (enable == 1) then
			return 1;--ready to use
		else
			return 2;--on cooldown
		end;
	end;
	
	local PotReady = 0;
	
	for _,Id in pairs(ManaPotions) do
		if GetItemCooldown(Id) == 1 then
			PotReady  = 1;
			break;
		end;
	end;
	
	return PotReady;
end;

--check whether TheUnit has buff with the spell Id of BuffID. return true when target has the buff, otherwise return false.
local function Unithasbuff(TheUnit,BuffID)
	local buffname = GetSpellInfo(BuffID);
	if buffname and UnitBuff(TheUnit,buffname) then
		return true;
	else
		return false;
	end;
end;

--localized standard macro
local SetLocalizedStandardMacro = Innervator2.SetLocalizedStandardMacro;

--the Innervate target name
local function SetTargetName()
	TargetString = "|cffFF0000"..Innervator2Target.."|r.";--red
	TargetStringYellow = "|cffFFFF00"..Innervator2Target.."|r.";--yellow
end;

--close/refresh display of macro frame
local function RefreshMacroFrame()
	if IsAddOnLoaded("Blizzard_MacroUI") ~= 1 then
		LoadAddOn("Blizzard_MacroUI");
	end;
	
	if MacroFrame:IsVisible() then
		HideUIPanel(MacroFrame);
	end;
end;

--close (to refresh display) and open the standard macro frame
local function ShowMacroFrame()
	RefreshMacroFrame();
	ShowUIPanel(MacroFrame);
end;

--check if user is moonkin, when:
	--startup
	--talent group changed
	--new target is set (only take moonkin check into account when innervate target is player self)
local function CheckMoonkinMana()
	if AddonLoaded then
		if (GetSpecialization() == 1) and (Innervator2Target == UnitName("Player")) then
			IsMoonkin = true;
		else
			IsMoonkin = false;
		end;
	end;
end;

--flat spirit increases
local SpiritBuffList = {
	[104280] = 1,--Well Fed
	[105685] = 1,--Elixir of Peace
	[105693] = 1,--Flask of Falling Leaves
	[146807] = 1,--Well Fed
	[104279] = 1,--Well Fed
	[104278] = 1,--Well Fed
	[127230] = 500,--Visions of Insanity
};

local doGearUpdate = true;

local GearUpdateFrame = CreateFrame("Frame");
GearUpdateFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
GearUpdateFrame:RegisterEvent("FORGE_MASTER_ITEM_CHANGED");
GearUpdateFrame:SetScript("OnEvent",function()
	doGearUpdate = true;
end);

local function GetSpiritFromLongBuffs()
--http://ptr.wowhead.com/spells?filter=na=spirit;ex=on;cr=21:29;crs=1:29;crv=50300:0

	local Spirit = 0;
	local spellName;
	
	for id, incValue in pairs(SpiritBuffList) do
		spellName = GetSpellInfo(id);
		if (UnitBuff("player",spellName)) and ((select(11,UnitBuff("player",spellName))) == id) then
			local increase;
			if incValue > 1 then
				increase = incValue;
			else
				increase = (select(15,UnitBuff("player",spellName))) or 0;
			end;
			Spirit = Spirit + increase;
		end;
	end;
	
	return Spirit;
end;

local spiritPercentIncreaseTrinkets = {	105474, 105422, 105609, 104478, 104426, 104613, 105225, 105173, 105360, 102299, 102293, 102305, 104727, 104675, 104862, 104976, 104924, 105111,	};

local function CheckIfTrinketEquipped()
	local trinketA = GetInventoryItemID("player",13);
	local trinketB = GetInventoryItemID("player",14);
	
	for _, i in pairs(spiritPercentIncreaseTrinkets) do
		if (i == trinketA) then
			return 13;
		elseif (i == trinketB) then
			return 14;
		end;
	end;
	
	return false;
end;

--sources:
--https://docs.google.com/spreadsheet/ccc?key=0AsDL8HE-bGDVdFFVWlIzbzQ5RFJJZGFyQ25xZmFYa0E#gid=45 (5 decimal)
--http://healiocentric.wordpress.com/2014/05/22/a-brief-amp-trinket-update/ (4 decimal)
--ExpGro1 fit with Origin8 of the values by Keldion (3 decimal)
local spiritPercentIncreasesPerItemLevel = setmetatable({
	--heroic wf
	[588] = 9.7003,-- 4x upgrade = +16 ilvl
	 [584] = 9.337,-- 3x upgrade = +12 ilvl
	[580] = 9.00231,--2x upgrade = +8  ilvl
	[576] = 8.67297,--1x upgrade = +4  ilvl
	[572] = 8.35568,--0x upgrade
	
	--heroic
	[582] = 9.1729,
	 [578] = 8.830,
	[574] = 8.51285,
	[570] = 8.20142,
	[566] = 7.90138,
	
	--normal wf
	[575] = 8.5937,
	 [571] = 8.272,
	[567] = 7.97534,
	[563] = 7.68357,
	[559] = 7.40248,
	
	--normal
	[569] = 8.1264,
	 [565] = 7.822,
	[561] = 7.54172,
	[557] = 7.26581,
	[553] = 7.00000,
	
	--flex
	[556] = 7.1994,
	 [552] = 6.930,
	[548] = 6.68137,
	[544] = 6.43694,
	[540] = 6.20145,

	--LFR
	--[544] =,
	 --[540] =,
	[536] = 5.97458,
	[532] = 5.75600,
	[528] = 5.54543,
	
	[463] = 3.02629,
},{__index = function() return 1 end});

local function GetTrinketIncrease(location)
	local ilvl = LISP:GetUpgradeLevel(GetInventoryItemLink("player",location)) or 1;
	
	return (1+spiritPercentIncreasesPerItemLevel[ilvl]/100);
end;

local function GetAllItemStats(i)
   local statTable =  LISP:GetItemStats(GetInventoryItemLink("player",i));
   if statTable == 0 or not statTable["ITEM_MOD_SPIRIT_SHORT"] then
      return 0;
   else
      return statTable["ITEM_MOD_SPIRIT_SHORT"];
   end;
end;

local SpiritOnGear = 0;
local spiritMultiplicator = 1;
--return spirit without temp. buffs
local function GetSpiritWithoutTempBuffs()
	if doGearUpdate then
		--get spirit from all equipment slots
		SpiritOnGear = 0;
		for i = 1, 19 do
		   SpiritOnGear = SpiritOnGear + GetAllItemStats(i);
		end;
		
		--get spirit increase trinkets
		local trinketLocation = CheckIfTrinketEquipped();
		if trinketLocation then
			spiritMultiplicator = GetTrinketIncrease(trinketLocation);
		else
			spiritMultiplicator = 1;
		end;
		
		doGearUpdate = false;
	end;

	local stat, _, posBuff = UnitStat("player",5);
	local baseSpirit = stat-posBuff;
	
	return ( (SpiritOnGear+baseSpirit+GetSpiritFromLongBuffs())*spiritMultiplicator );
end;

local InnervateGlyph = 54832;
local doCheckForGlyph = true;
local GlyphStatus = false;

local CheckForGlyphFrame = CreateFrame("Frame");
CheckForGlyphFrame:RegisterEvent("GLYPH_UPDATED");
CheckForGlyphFrame:SetScript("OnEvent",function()
	doCheckForGlyph = true;
end);

local function HasGlyph()
	if doCheckForGlyph then
		doCheckForGlyph = false;
		GlyphStatus = false;
		
		for i = 1 , NUM_GLYPH_SLOTS do
			local _,_,_,glyphID = GetGlyphSocketInfo(i);
			if glyphID then
				if (glyphID == InnervateGlyph) then
					GlyphStatus = true;
					return GlyphStatus;
				end;
			end;
		end;
	end;
	
	return GlyphStatus;
end;

local standardManaBonusCache = 0;
local standardManaBonusTimer = GetTime();

local function GetStandardManaBonus()
	if GetTime() - standardManaBonusTimer > 0.3 then
		standardManaBonusCache = (GetSpiritWithoutTempBuffs()*0.5)*10;
		
		standardManaBonusTimer = GetTime();
	end;
	
	return standardManaBonusCache;
end;

local function GetGlyphedManaBonus()
	return GetStandardManaBonus() * 0.6;
end;

local function GetManaBonus(GetStandard)
	if not GetStandard and HasGlyph() then
		return max(GetGlyphedManaBonus(),UnitPowerMax("player",0)*0.08*0.6);
	else
		return max(GetStandardManaBonus(),UnitPowerMax("player",0)*0.08);
	end;
end;

local function DruidColor()
	return 1,0.49,0.04,1,0.49,0.04;
end;

local function AddTooltipHook()
	GameTooltip:HookScript("OnTooltipSetSpell",function()
		if GameTooltip:GetSpell() == InnervateName then
			GameTooltip:AddLine(" ");
			GameTooltip:AddDoubleLine("Innervator2","",DruidColor());
			GameTooltip:AddDoubleLine(SPELL_STAT5_NAME..":",round(GetSpiritWithoutTempBuffs()),DruidColor());
			
			if HasGlyph() then
				local standardManaGain = GetManaBonus(true);
				GameTooltip:AddDoubleLine(MANA.." (cast on you):",round(standardManaGain) .. " [" .. (round(standardManaGain/UnitPowerMax("player",0)*100*10)/10).. "%]",DruidColor());--loc
				GameTooltip:AddDoubleLine(MANA.." (cast on others):","2x"..round(GetManaBonus()).."="..round(GetManaBonus()*2),DruidColor());--loc
				GameTooltip:AddDoubleLine(GetSpellInfo(InnervateGlyph)..":","Enabled",DruidColor());--loc
			else
				local standardManaGain = GetManaBonus(true);
				GameTooltip:AddDoubleLine(MANA..":",round(standardManaGain) .. " [" .. (round(standardManaGain/UnitPowerMax("player",0)*100*10)/10).. "%]",DruidColor());
				GameTooltip:AddDoubleLine(GetSpellInfo(InnervateGlyph)..":","Disabled",DruidColor());--loc
			end;
		end;
	end);
end;

----------------------------------------------------
--	print functions
----------------------------------------------------

local function PrintTarget()
	print(L["PrintTarget"]..TargetString);
end;

local function PrintHelp()
	for i = 1,11 do
		print(L["HELP"..i]);
	end;
end;

local function PrintChatSpam()
	--font in red color (innervate target in yellow)
	local text = Innervator2.Innervator2MsgIcon(Innervator2Config["Icon"])..InnervatorString..L["PrintChatSpam"]..TargetStringYellow..Innervator2.Innervator2MsgIcon(Innervator2Config["Icon"]);
	for i = 1,Innervator2.LineCounter do
		if (Innervator2Config["Chatframe"] == "DBM Frame") then
			RaidNotice_AddMessage(RaidWarningFrame,text,ChatTypeInfo["RAID_WARNING"]);
		elseif (Innervator2Config["Chatframe"] == "Error Frame") then
			UIErrorsFrame:AddMessage(text,1,0,0,53,5);
		else
			DEFAULT_CHAT_FRAME:AddMessage(text);
		end;
	end;
	if Innervator2Config["Flash"] then
		Innervator2.Innervator2FrameFlash(Innervator2Config["FFred"],Innervator2Config["FFgreen"],Innervator2Config["FFblue"]);
	end;
end;

local function PrintChatSpamOutOfRange()
	--font in red color (innervate target in yellow)
	local text = Innervator2.Innervator2MsgIcon(Innervator2Config["Icon"])..InnervatorString..L["PrintChatSpamOutOfRange"]..TargetStringYellow..Innervator2.Innervator2MsgIcon(Innervator2Config["Icon"]);
	for i = 1,Innervator2.LineCounter do
		if (Innervator2Config["Chatframe"] == "DBM Frame") then
			RaidNotice_AddMessage(RaidWarningFrame,text,ChatTypeInfo["RAID_WARNING"]);
		elseif (Innervator2Config["Chatframe"] == "Error Frame") then
			UIErrorsFrame:AddMessage(text,1,0,0,53,5);
		else
			DEFAULT_CHAT_FRAME:AddMessage(text);
		end;
	end;
	if Innervator2Config["Flash"] then
		Innervator2.Innervator2FrameFlash(Innervator2Config["FFred"],Innervator2Config["FFgreen"],Innervator2Config["FFblue"]);
	end;
end;

local function PrintChatSpamManaPot()
	--font in red color
	local ManaPotIcon = "|TInterface\\Icons\\trade_alchemy_potiond2:20|t"
	local text = ManaPotIcon..InnervatorString..L["PrintChatSpamManaPot"]..ManaPotIcon;
	for i = 1,Innervator2.LineCounter do
		if (Innervator2Config["Chatframe"] == "DBM Frame") then
			RaidNotice_AddMessage(RaidWarningFrame,text,ChatTypeInfo["RAID_WARNING"]);
		elseif (Innervator2Config["Chatframe"] == "Error Frame") then
			UIErrorsFrame:AddMessage(text,1,0,0,53,5);
		else
			DEFAULT_CHAT_FRAME:AddMessage(text);
		end;
	end;
	if Innervator2Config["Flash"] then
		Innervator2.Innervator2FrameFlash(Innervator2Config["FFred"],Innervator2Config["FFgreen"],Innervator2Config["FFblue"]);
	end;
end;

----------------------------------------------------
--	print functions end;
----------------------------------------------------

--reminder aka chat spamer
local function ChatSpam()
	LastWatchTime = GetTime();
	PrintChatSpam();
	if Innervator2Config["Sounds"] then
		PlaySoundFile(Innervator2Config["Soundfile1"],"Master");
	end;
end;

--reminder when out of range
local function ChatSpamOutOfRange()
	LastWatchTime = GetTime();
	PrintChatSpamOutOfRange();
	if Innervator2Config["Sounds"] then
		PlaySoundFile(Innervator2Config["Soundfile2"],"Master");
	end;
end;

--reminder to use mana pot
local function ChatSpamManaPot()
	LastWatchTime = GetTime();
	PrintChatSpamManaPot();
	if Innervator2Config["Sounds"] then
		PlaySoundFile(Innervator2Config["SoundfileManaPot"],"Master");
	end;
end;

----------------------------------------------------
--		macro handling
----------------------------------------------------

local function EditTheMacro(MacroIndex)
	if IsAddOnLoaded("Blizzard_MacroUI") ~= 1 then
		LoadAddOn("Blizzard_MacroUI");
	end;
	
	if MacroFrame:IsVisible() then
		HideUIPanel(MacroFrame);
	end;
	
	local SaveMacro, NrOfSubs = gsub(Innervator2InputMacroText,"/i2",Innervator2Target);
	local NewMacroId = EditMacro(MacroIndex,"Innervator2Macro",MacroIcon,SaveMacro);
	if (NewMacroId>0) and (NrOfSubs>0) then
		print(L["PrintMacroCreated"]);
		RefreshMacroFrame();
	else
		if NrOfSubs>0 then
			print(L["PrintEditMacroError"]);
		else
			print(L["PrintEditmacroNoTargetFound"]);
		end;
	end;
end;

local MaxMacros = 36;
if MAX_ACCOUNT_MACROS then
	MaxMacros = MAX_ACCOUNT_MACROS;
end;

local function CreateTheMacro(DontPrint)
	if IsAddOnLoaded("Blizzard_MacroUI") ~= 1 then
		LoadAddOn("Blizzard_MacroUI");
	end;
	
	if UnitAffectingCombat("player") then
		if not DontPrint then
			print(L["PrintMacroPlayerInCombat"]);
		end;
		CreateMacroAfterCombat = true;
	else
		local TheIndex = GetMacroIndexByName("Innervator2Macro");
		if TheIndex ~= 0 then
			EditTheMacro(TheIndex);
		else
			if GetNumMacros()>(MaxMacros-1) then
				print(L["PrintMacroNoSpace"]);
			else
				local SaveMacro,NrOfSubs = gsub(Innervator2InputMacroText,"/i2",Innervator2Target);
				CreateMacro("Innervator2Macro",MacroIcon,SaveMacro,true);
				if NrOfSubs>0 then
					if not DontPrint then
						print(L["PrintMacroCreated"]);
					end;
					
					RefreshMacroFrame();
				else
					if not DontPrint then
						print(L["PrintEditmacroNoTargetFound"]);
					end;
				end;
			end;
		end;
	end;
end;

local function CreateMacroForEdit()
	if IsAddOnLoaded("Blizzard_MacroUI") ~= 1 then
		LoadAddOn("Blizzard_MacroUI");
	end;
	
	if UnitAffectingCombat("player") then
		print(L["PrintMacroPlayerInCombat"]);
	else
		if GetMacroIndexByName("I2InputMacroText") ~= 0 then
			DeleteMacro("I2InputMacroText");
		end;
		if GetNumMacros()>(MaxMacros-1) then
			print(L["PrintMacroNoSpace"]);
		else
			CreateMacro("I2InputMacroText",MacroIcon,Innervator2InputMacroText,true);
			print(L["PrintMacroForEditCreated"]);
			ShowMacroFrame();
			MacroFrameTab2:Click();
		end;
	end;
end;

local function SaveMacroAfterEdit()
	if IsAddOnLoaded("Blizzard_MacroUI") ~= 1 then
		LoadAddOn("Blizzard_MacroUI");
	end;
	
	if UnitAffectingCombat("player") then
		print(L["PrintMacroPlayerInCombat"]);
	else
		RefreshMacroFrame();
		if GetMacroIndexByName("I2InputMacroText") == 0 then
			print(L["PrintEditmacroNotFound"]);
		else
			local CurrentMacroBody = GetMacroBody("I2InputMacroText");
			if (strfind(CurrentMacroBody,"/i2")) or (CurrentMacroBody == "") then
				if CurrentMacroBody == "" then
						SetLocalizedStandardMacro();
						Innervator2InputMacroText = LocalizedStandardMacro;
						Innervator2.OptionsMacroInputMacroText:SetText(Innervator2InputMacroText);
						DeleteMacro("I2InputMacroText");
						print(L["PrintEditmacroCleared"]);
				elseif (type(CurrentMacroBody)~= "string") or (strlenutf8(CurrentMacroBody)<10) then
					print(L["PrintEditmacroNotCorrect"]);
				else
					Innervator2InputMacroText = CurrentMacroBody;
					Innervator2.OptionsMacroInputMacroText:SetText(Innervator2InputMacroText);
					DeleteMacro("I2InputMacroText");
					print(L["PrintEditmacroSaved"]);
					CreateTheMacro();
				end;
			else
				print(L["PrintEditmacroNoTargetFound"]);
			end;
		end;
	end;
end;

--		end macro handling
----------------------------------------------------

local WarnMeTimer = 0;
local function UnitPowerFrameFunction(self,event,arg1,arg2,...)
	if (arg2 == "MANA") and ((Innervator2Target==UnitName("player")) or (not (arg1=="player"))) then
		--start: script for watching innervate target
		local start,duration,enabled = GetSpellCooldown(InnervateSpell);
		duration = duration - 1.5;--subtract GCD, so warning is fired when we are casting some other stuff, too. so "duration<=0" means no CD on innervate
		CurrentWatchTime = GetTime();

		--calc moonkin mana (two times eclipse)
		--when i2target is player and player is moonkin
		local MoonkinMana = 0;
		if IsMoonkin then
			MoonkinMana = UnitPowerMax("player",0)*2*0.35;
		end;

		--calc mana gained through innervate (in %)
		local InnervateMana = GetManaBonus();--mana gained for innervate target
		local OwnInnervateMana = 0;--mana gained for player if he is not innervate target
		local HasInnervateGlyph = HasGlyph();
		
		if (not (Innervator2Target == UnitName("player"))) and HasInnervateGlyph then
			OwnInnervateMana = InnervateMana;
		end;

		local WarnMe = false;

		if (UnitAffectingCombat("player")) and (UnitAffectingCombat(Innervator2Target)) and (duration<=0) and (CurrentWatchTime-LastWatchTime>10) and (not UnitIsDeadOrGhost("player")) and (not UnitIsDeadOrGhost(Innervator2Target)) then
			if Innervator2Config["WarningType"] == "Best" then
				if (Innervator2Target == UnitName("player")) then
					if (
							  UnitPower("player",0)
							+ InnervateMana
							+ MoonkinMana
							< UnitPowerMax("player",0)
						) then
							WarnMe = true;
					end;
				else
					--check for innervate target mana AND (if player is resto) player mana
					if (
							  UnitPower(Innervator2Target,0)
							+ InnervateMana
							< UnitPowerMax(Innervator2Target,0)
						) and (
							(not HasInnervateGlyph) or (CTT ~= 4) or (
								  UnitPower("player",0)
								+ OwnInnervateMana
								< UnitPowerMax("player",0)
							)
						)
					then
							WarnMe = true;
					end;
				end;
			else
				if (
						UnitPower(Innervator2Target,0)
						< UnitPowerMax(Innervator2Target,0) * Innervator2Config["WarningThreshold"]/100
					) then
						WarnMe = true;
				end;
			end;
		end;

		--end: script for innervate

		--start: script for mana potion
		--fire mana pot warning when:
			--we can use mana pot [we will just check if it is "ready" (e.i. return==1)] [supported are: Mythical Mana Potion, Mysterious Potion and Potion of Concentration]
			--player is in combat
			--user has enabled the addon to warn for manapot usage
			--current mana is below setup threshold
			--innervate is on cooldown
			--innervate is not on the player currently
			--last warning was 10s+ ago (innervate OR mana pot)
			--player is alive
		local WarnMeManaPotion = false;

		if 	( PlayerCanUsePotion() == 1 )
			and UnitAffectingCombat("player")
			and Innervator2Config["ManaPotEnabled"]
			and ( CurrentWatchTime - LastWatchTime > 10 )
			and ( UnitPower("player",0) < UnitPowerMax("player",0)*Innervator2Config["ManaPotThreshold"]/100 )
			and ( duration > 0 )
			and ( not Unithasbuff("player",InnervateSpell) )
			and ( not UnitIsDeadOrGhost("player") ) then
				WarnMeManaPotion = true;
		end;
		--end: script for mana pot

		--now the actual warning:
		if (WarnMe) or (WarnMeManaPotion) then
			if WarnMeTimer>0 then
				if (GetTime()-WarnMeTimer>0.2) then--the 0.2 delay is an attempted fix for the issue that the warning could fire when you die
					WarnMeTimer = 0;
					if WarnMe then
						local IsInRange = IsSpellInRange(GetSpellInfo(InnervateSpell),Innervator2Target);
						if IsInRange == 1 then
							ChatSpam();
						elseif IsInRange == 0 then
							ChatSpamOutOfRange();
						end;
					elseif WarnMeManaPotion then
						ChatSpamManaPot();
					end;
				end;
			else
				WarnMeTimer = GetTime();
			end;
		else
			WarnMeTimer = 0;
		end;
	end;
end;

--set up slash commands
SLASH_INNERVATORTWO1, SLASH_INNERVATORTWO2 = '/innervator2', '/i2';
local function Innervator2SlashCmd(msg,IsSlash)
	if AddonLoaded then
		msg = strlower(msg);
		local command,commandrest = msg:match("^(%S*)%s*(.-)$");
		local arg1,arg1rest = commandrest:match("^(%S*)%s*(.-)$");
		local arg2,arg2rest = arg1rest:match("^(%S*)%s*(.-)$");
		-- Any leading non-whitespace is captured into "command".
		-- The rest (minus leading whitespace) is captured into "commandrest".
		-- The leading non-whitespace of "commandrest" is then captured into "arg1".
		-- The remaining rest string is captured into "arg1rest" and so on.
		if ((command == 'enable') or (command == 'on')) and not AddonActive then
			AddonActive = true;
			UnitPowerFrame:RegisterEvent("UNIT_POWER")
			UnitPowerFrame:SetScript("OnEvent",UnitPowerFrameFunction);
			print(L["PrintAddonEnabled"]);
			--if not startup, i.e. the GUI is already created
			if Innervator2.OptionsCheckEnableAddon then
				Innervator2.OptionsCheckEnableAddon:SetChecked(true);
			end;
		elseif ((command == 'enable') or (command == 'on')) and AddonActive then
			if IsSlash then
				print(L["PrintAddonIsAlreadyEnabled"]);
			end;
		elseif ((command == 'disable') or (command == 'off')) and AddonActive then
			AddonActive = false;
			UnitPowerFrame:UnregisterEvent("UNIT_POWER");
			print(L["PrintAddonDisabled"]);
			Innervator2.OptionsCheckEnableAddon:SetChecked(false);
		elseif ((command == 'disable') or (command == 'off')) and not AddonActive then
			if IsSlash then
				print(L["PrintAddonIsAlreadyDisabled"]);
			end;
		elseif command == "set" and commandrest ~= "" then
			if arg1 == "target" then
				if UnitName("target") then
					Innervator2Target = UnitName("target");
				else
					Innervator2Target = UnitName("player");
				end;
			else
				Innervator2Target = strupper(utf8sub(arg1,1,1))..strlower(utf8sub(arg1,2,strlenutf8(arg1)));
			end;
			
			CheckMoonkinMana();
			SetTargetName();
			print(L["PrintSetTarget1"]..TargetString..L["PrintSetTarget2"]);
			CreateTheMacro(true);
		elseif command == "set" and commandrest == "" then
			print(L["PrintNoTarget"]);
		elseif command == "show" or command == "print" or command == "target" then
			SetTargetName();
			PrintTarget();
		elseif command == "test" or command == "who" then
			SendWho(Innervator2Target);
		elseif command == "help" or command == "?" then
			PrintHelp();
		elseif ((command == "sound") or (command == "sounds")) and (commandrest == "")then
			if Innervator2Config["Sounds"] then
				Innervator2Config["Sounds"] = false;
				print(L["PrintSoundsDisabled"]);
			else
				Innervator2Config["Sounds"] = true;
				print(L["PrintSoundsEnabled"]);
			end;
			Innervator2.OptionsCheckSound:SetChecked(Innervator2Config["Sounds"]);
		elseif (command == "opt" or command == "options" or command == "option" or command == "config" or command == "cfg") and commandrest == "" then
			InterfaceOptionsFrame_OpenToCategory(Innervator2Panel);
		--intern used slashcommands
		elseif command == "macro" and commandrest == "edit" then
			CreateMacroForEdit();
		elseif command == "macro" and commandrest == "save" then
			SaveMacroAfterEdit();
		else
			if msg ~= "" then
				print(L["PrintUnknownCommand1"]..msg.."|r");
			end;
			print(L["PrintUnknownCommand2"]);
		end;
	else
		print(L["PrintAddonDidNotLoadup"]);
	end;
end;
SlashCmdList["INNERVATORTWO"] = Innervator2SlashCmd;

--code executed at login
local LoginFrame = CreateFrame("Frame")
LoginFrame:RegisterEvent("PLAYER_LOGIN")
LoginFrame:SetScript("OnEvent",function()
	--activate the addon when player knows Innervate
	if IsSpellKnown(InnervateSpell) then
		AddonLoaded = true;

		CheckMoonkinMana();

		AddTooltipHook();
		
		--create the menu and populate menu stuff
		Innervator2.Innervator2CreateOptionsMenu();

		--deal with saved vars
		Innervator2.SetupSavedVars();
		
		if type(Innervator2Target) ~= "string" then
			Innervator2Target = UnitName("Player");
			print(L["PrintFirstLogin"].."|cffFF7D0A"..UnitName("Player").."|r.");
		else
			SetTargetName();
			PrintTarget();
		end;
		
		Innervator2.OptionsCheckEnableAddon:SetChecked(true);
		
		--create macro if not exists
		if GetMacroIndexByName("Innervator2Macro") == 0 then
			if GetNumMacros() > (MaxMacros-1) then
				print(L["PrintMacroNoSpace"]);
			else
				local SaveMacro,NrOfSubs = gsub(Innervator2InputMacroText,"/i2",Innervator2Target);
				CreateMacro("Innervator2Macro",MacroIcon,SaveMacro,true);
				if NrOfSubs == 0 then
					print(L["PrintEditmacroNoTargetFound"]);
				end;
			end;
		end;
	else
		print(L["PrintAddonDidNotLoadup"]);
	end;
end);

local function ZoneFunction()
	if (IsLoggedIn() == 1) and (AddonLoaded) then
		if Innervator2Config["EnableDisableOnInstance"] then
			local enable = true;
			local isininstance, instancetype = IsInInstance();

			if isininstance then
				if instancetype == "pvp" then
					if Innervator2Config["IgnoreBattleground"] == false then
						enable = Innervator2Config["EnableDisableBattleground"];
					end;
				elseif instancetype == "arena" then
					if Innervator2Config["IgnoreArena"] == false then
						enable = Innervator2Config["EnableDisableArena"];
					end;
				elseif instancetype == "party" then
					if Innervator2Config["IgnoreParty"] == false then
						enable = Innervator2Config["EnableDisableParty"];
					end;
				elseif instancetype == "raid" then
					if Innervator2Config["IgnoreRaid"] == false then
						enable = Innervator2Config["EnableDisableRaid"];
					end;
				else
					if Innervator2Config["IgnoreOutside"] == false then
						enable = Innervator2Config["EnableDisableOutside"];
					end;
				end;
			else
				if Innervator2Config["IgnoreOutside"] == false then
					enable = Innervator2Config["EnableDisableOutside"];
				end;
			end;
			
			if enable and (not AddonActive) then
				Innervator2SlashCmd("on");
			elseif (not enable) and AddonActive then
				Innervator2SlashCmd("off");
			end;
		else
			Innervator2.ZoneChangeFrame:UnregisterAllEvents();
		end;
	end;
end;

--check if addon should be enabled when logging in
local LoginTalentCheck = CreateFrame("Frame");
LoginTalentCheck:RegisterEvent("PLAYER_ALIVE");
LoginTalentCheck:RegisterEvent("PLAYER_LOGIN");
LoginTalentCheck:SetScript("OnEvent",function()
	CTT = GetSpecialization();--current talent tree
	if AddonLoaded then
		if Innervator2Config["EnableDisableOnInstance"] == false then
			if CTT then
				if ((CTT == 1) and (Innervator2Config["EnableDisableMoonkin"])) or ((CTT == 2) and (Innervator2Config["EnableDisableFeral"])) or ((CTT == 3) and (Innervator2Config["EnableDisableGuardian"])) or ((CTT == 4) and (Innervator2Config["EnableDisableRestoration"])) then
					Innervator2SlashCmd('on');
				else
					print(L["PrintAddonDisabled"]);
				end;
				LoginTalentCheck:UnregisterAllEvents();
			end;
		elseif Innervator2Config["EnableDisableOnInstance"] then
			if CTT then
				ZoneFunction();
				LoginTalentCheck:UnregisterAllEvents();
			end;
		else
			LoginTalentCheck:UnregisterAllEvents();
		end;
	end;
end);

--pick up macro to cursor when respective hyperlink was clicked
local function MacroToCursor()
	if not UnitAffectingCombat("player") then
		PickupMacro("Innervator2Macro");
	end;
end;

--hyperlink handling
local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow;
ChatFrame_OnHyperlinkShow = function(self,link,...)
	if link == "Innervator2" then
		return MacroToCursor();
	else
		return origChatFrame_OnHyperlinkShow(self,link,...);
	end;
end;

--watch talent changes (to check when player is moonkin AND to check whether addon should be enabled in this spec)
local TalentChangeFrame = CreateFrame("Frame");
TalentChangeFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
TalentChangeFrame:SetScript("OnEvent",function()
	if (IsLoggedIn() == 1) and (AddonLoaded) then
		CheckMoonkinMana();
		if Innervator2Config["EnableDisableOnInstance"] == false then
			CTT = GetSpecialization();--get current talent tree
			if ((CTT == 1) and (Innervator2Config["EnableDisableMoonkin"])) or ((CTT == 2) and (Innervator2Config["EnableDisableFeral"])) or ((CTT == 3) and (Innervator2Config["EnableDisableGuardian"])) or ((CTT == 4) and (Innervator2Config["EnableDisableRestoration"])) then
				Innervator2SlashCmd("on");
			else
				Innervator2SlashCmd("off");
			end;
		end;
	end;
end);

--watch zone (to check whether addon should be enabled here)
local ZoneChangeFrame = CreateFrame("Frame");
Innervator2.ZoneChangeFrame = ZoneChangeFrame;
ZoneChangeFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
ZoneChangeFrame:SetScript("OnEvent",ZoneFunction);

--watch combat for creating macro when failed previously
local CombatLeftFrame = CreateFrame("Frame")
CombatLeftFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
CombatLeftFrame:SetScript("OnEvent",function()
	if (not UnitAffectingCombat("player")) and (CreateMacroAfterCombat) then
		CreateMacroAfterCombat = false;
		CreateTheMacro();
	end;
end);