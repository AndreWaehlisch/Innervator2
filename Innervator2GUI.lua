--define global table
Innervator2 = {};

--define locals
local L = Innervator2Locals;

Innervator2.print = function(msg,...)
	local IsDebug = false;
	for i=2, select("#",...) do
		if select(i,...) then
			IsDebug = true;
		end;
	end;
	
	if (type(msg) == "string") and (not IsDebug) then
		print("|cffFF7D0AInnervator2|r: " .. msg);
	else
		print(msg,...);
	end;
end;

local print = Innervator2.print;

--the optionsmenu create function
function Innervator2.Innervator2CreateOptionsMenu()
	--create Checkbutton (Checkbox)
	local CheckbuttonCount = 0;
	local function CreateCheckButton(x_loc,y_loc,displayname,thetooltip,panel)
		CheckbuttonCount = CheckbuttonCount + 1;

		local MyCheckbutton = CreateFrame("CheckButton","Innervator2_Checkbutton_" .. CheckbuttonCount,panel,"ChatConfigCheckButtonTemplate");
		MyCheckbutton:SetPoint("TOPLEFT",x_loc,y_loc);
		_G[MyCheckbutton:GetName() .. "Text"]:SetText(displayname);
		MyCheckbutton.tooltip = thetooltip;
		return MyCheckbutton;
	end

	--create Editbox (Edit)
	local EditBoxCount = 0;
	local function CreateEditBox(Width,x_loc,y_loc,panel)
		EditBoxCount = EditBoxCount + 1;

		local MyEditBox = CreateFrame("EditBox","Innervator2_EditBox_"..EditBoxCount,panel,"InputBoxTemplate");
		MyEditBox:SetWidth(Width);
		MyEditBox:SetHeight(20);
		MyEditBox:SetPoint("TOPLEFT",x_loc,y_loc);
		MyEditBox:SetAutoFocus(nil);
		MyEditBox:SetFontObject("GameFontHighlight");
		return MyEditBox;
	end

	--create Button
	local ButtonCount = 0;
	local function CreateButton(Width,Height,x_loc,y_loc,MyText,panel)
		ButtonCount = ButtonCount + 1;

		local MyButton = CreateFrame("BUTTON","Innervator2_Button_"..ButtonCount,panel,"UIPanelButtonTemplate");
		MyButton:SetWidth(Width);
		MyButton:SetHeight(Height);
		MyButton:SetText(MyText);
		MyButton:SetPoint("TOPLEFT",x_loc,y_loc);
		MyButton:Show();
		return MyButton;
	end

	--create Fontstring (Label)
	local FontStringCount = 0;
	local function CreateFontString(Width,Height,x_loc,y_loc,MyText,panel)
		FontStringCount = FontStringCount + 1;

		local MyFontString = panel:CreateFontString("Innervator2_FontString_"..FontStringCount,"ARTWORK","GameFontNormal");
		MyFontString:SetWidth(Width);
		MyFontString:SetHeight(Height);
		MyFontString:SetText(MyText);
		MyFontString:SetPoint("TOPLEFT",x_loc,y_loc);
		MyFontString:Show();
		return MyFontString;
	end

	--create Slider
	local SliderCount = 0;
	local function CreateSlider(x_loc,y_loc,MyText,minval,maxval,step,panel)
		SliderCount = SliderCount + 1;

		local MySlider = CreateFrame("Slider","Innervator2_Slider_"..SliderCount,panel,"OptionsSliderTemplate");
		MySlider:ClearAllPoints();
		MySlider:SetPoint("TOPLEFT",x_loc,y_loc);
		MySlider:SetMinMaxValues(minval,maxval);
		MySlider:SetValue(0);
		MySlider:SetStepsPerPage(maxval/4);
		MySlider:SetValueStep(step);
		_G[MySlider:GetName() .. "Low"]:SetText(minval);
		_G[MySlider:GetName() .. "High"]:SetText(maxval);
		_G[MySlider:GetName() .. "Text"]:SetText(MyText);
		MySlider:Show();

		return MySlider;
	end

	--create horizontal line
	local HLineCount = 0;
	local function CreateHLine(y_loc,panel)
		HLineCount = HLineCount + 1;

		local MyTexture = panel:CreateTexture("Innervator2_HLine_"..HLineCount);
		MyTexture:SetTexture("Interface\\MailFrame\\UI-MailFrame-InvoiceLine");
		MyTexture:SetPoint("TOPLEFT",10,y_loc);
		MyTexture:SetHeight(60);
		MyTexture:SetWidth(500);
		MyTexture:SetVertexColor(1,1,0.5);
	end

	--add tooltip to button
	local function AddTooltip(MyFrameWhoWantsTooltip,text)
		MyFrameWhoWantsTooltip:SetScript("OnEnter",function(self)
			GameTooltip:SetOwner(MyFrameWhoWantsTooltip,"ANCHOR_CURSOR");
			GameTooltip:SetText(MyFrameWhoWantsTooltip:GetText());

			local LineCount = 0;
			local mytext;
			if type(text) == "string" then
				mytext = {text,"XYZ_NOTHING_XYZ"};
				LineCount = -1;
			else
				mytext = text;
			end

			for _,_ in pairs(mytext) do
				LineCount = LineCount + 1;
			end
			for i=1,LineCount do
				GameTooltip:AddLine(mytext[i],1,1,1,1);
			end

			GameTooltip:Show();
		end);

		MyFrameWhoWantsTooltip:SetScript("OnLeave",function(self)
			GameTooltip:Hide();
		end);
	end;

	--add a changing tooltip, use GameTooltip:SetText() and GameTooltip:AddLine()
	local function AddTooltipFunc(MyFrameWhoWantsTooltip,TextFunction)
		MyFrameWhoWantsTooltip:SetScript("OnEnter",function()
			GameTooltip:SetOwner(MyFrameWhoWantsTooltip,"ANCHOR_CURSOR");

			TextFunction();

			GameTooltip:Show();
		end);

		MyFrameWhoWantsTooltip:SetScript("OnLeave",function()
			GameTooltip:Hide();
		end);
	end;

	--Begin actual optionsmenu
		local CurrentPanel = CreateFrame("Frame","Innervator2Panel",UIParent);
		CurrentPanel.name = "Innervator2";
		Innervator2.Innervator2Panel = CurrentPanel;
		-----------------------------------------------------------
		--------------MAIN PANEL-----------------------------------
		-----------------------------------------------------------
		local StartHeight = -70;

		CreateFontString(350,40,20,StartHeight+50,"|cffFF7D0AInnervator2|r (v"..GetAddOnMetadata("Innervator2","Version")..")"..L["OptionsStringInfo"],CurrentPanel);

		Innervator2.OptionsCheckEnableAddon = CreateCheckButton(20,StartHeight,L["OptionsCheckEnableAddon_LABEL"],L["OptionsCheckEnableAddon_HINT"],CurrentPanel);

		Innervator2.OptionsCheckEnableAddon:SetScript("OnClick",
			function()
				if Innervator2.OptionsCheckEnableAddon:GetChecked() == 1 then
					SlashCmdList["INNERVATORTWO"]("on");
				else
					SlashCmdList["INNERVATORTWO"]("off");
				end
			end
		);

		Innervator2.OptionsCheckEnableAddon:SetChecked(true);

		CreateFontString(200,15,20,StartHeight-40,L["OptionsStringSetTarget"],CurrentPanel);

		local OptionsEditSetTarget = CreateEditBox(150,20+200,StartHeight-40,CurrentPanel);

		local OptionsButtonSetTarget = CreateButton(30,20,20+200+150+5,StartHeight-40,L["OptionsButtonSetTarget"],CurrentPanel);

		OptionsButtonSetTarget:SetScript("OnClick",function()
			SlashCmdList["INNERVATORTWO"]('set '..OptionsEditSetTarget:GetText());
			OptionsEditSetTarget:SetText("");
		end);

		OptionsEditSetTarget:SetScript("OnEnterPressed",function()
			SlashCmdList["INNERVATORTWO"]('set '..OptionsEditSetTarget:GetText());
			OptionsEditSetTarget:SetText("");
		end);

		CreateHLine(StartHeight-50,CurrentPanel);

		--Enable/disable when... [show/hide means enable/disable here!]

		CreateFontString(230,50,30,StartHeight-80,"Enable/disable when entering...",CurrentPanel);--loc
		
		local LocDummy = "Status of Innervator2 in |cffFFFFFF";--loc
		local LocDummy2 = "Status will not change in |cffFFFFFF";--loc
		local LocDummy3 = "Check this box to not change status when entering |cffFFFFFF";--loc
		local function GenerateToolTip(Location,IsShown)
			return LocDummy .. Location .. "|r: " .. IsShown .. "."
		end;
		
		--ARENA SHOW/HIDE
		Innervator2.EnableDisableButtonArena 			=	CreateCheckButton(60,StartHeight-80-45,		"Arena",			"",CurrentPanel);--loc
		Innervator2.EnableDisableButtonArena:SetScript("OnClick",function()
			if Innervator2.EnableDisableButtonArena:GetChecked() == 1 then
				Innervator2Config["EnableDisableArena"] = true;
			else
				Innervator2Config["EnableDisableArena"] = false;
			end
			GameTooltip:Hide();
		end);
		
		local function EnableDisableArenaTTFunc()
			if Innervator2.EnableDisableButtonArena:GetChecked() == 1 then 
				GameTooltip:SetText(GenerateToolTip("Arena","Enabled"));--loc
			else
				GameTooltip:SetText(GenerateToolTip("Arena","Disabled"));--loc
			end;
		end;
		AddTooltipFunc(Innervator2.EnableDisableButtonArena,EnableDisableArenaTTFunc);
		
		--ARENA IGNORE
		Innervator2.IgnoreArena 					=	CreateCheckButton(35,StartHeight-80-45,"","",CurrentPanel);
		Innervator2.IgnoreArena:SetScript("OnClick",function()
			if Innervator2.IgnoreArena:GetChecked() == 1 then
				Innervator2Config["IgnoreArena"] = true;
				Innervator2.EnableDisableButtonArena:Disable();
			else
				Innervator2Config["IgnoreArena"] = false;
				Innervator2.EnableDisableButtonArena:Enable();
			end;
			GameTooltip:Hide();
		end);
		
		local function IgnoreArenaTTFunc()
			if Innervator2.IgnoreArena:GetChecked() == 1 then 
				GameTooltip:SetText(LocDummy2 .. "Arena" .. "|r.");--loc
			else
				GameTooltip:SetText(LocDummy3 .. "Arena" .. "|r.");--loc
			end;
		end;
		AddTooltipFunc(Innervator2.IgnoreArena,IgnoreArenaTTFunc);
		
		--BATTLEGROUND SHOW/HIDE
		Innervator2.EnableDisableButtonBattleground	=	CreateCheckButton(60,StartHeight-80-45-25,"Battleground","",CurrentPanel);--loc
		Innervator2.EnableDisableButtonBattleground:SetScript("OnClick",function()
			if Innervator2.EnableDisableButtonBattleground:GetChecked() == 1 then
				Innervator2Config["EnableDisableBattleground"] = true;
			else
				Innervator2Config["EnableDisableBattleground"] = false;
			end
			GameTooltip:Hide();
		end);
		
		local function EnableDisableBattlegroundTTFunc()
			if Innervator2.EnableDisableButtonBattleground:GetChecked() == 1 then 
				GameTooltip:SetText(GenerateToolTip("Battleground","Enabled"));--loc
			else
				GameTooltip:SetText(GenerateToolTip("Battleground","Disabled"));--loc
			end;
		end;
		AddTooltipFunc(Innervator2.EnableDisableButtonBattleground,EnableDisableBattlegroundTTFunc);
		
		--BATTLEGROUND IGNORE
		Innervator2.IgnoreBattleground			= 	CreateCheckButton(35,StartHeight-80-45-25,"","",CurrentPanel);
		Innervator2.IgnoreBattleground:SetScript("OnClick",function()
			if Innervator2.IgnoreBattleground:GetChecked() == 1 then
				Innervator2Config["IgnoreBattleground"] = true;
				Innervator2.EnableDisableButtonBattleground:Disable();
			else
				Innervator2Config["IgnoreBattleground"] = false;
				Innervator2.EnableDisableButtonBattleground:Enable();
			end;
			GameTooltip:Hide();
		end);
		
		local function IgnoreBattlegroundTTFunc()
			if Innervator2.IgnoreBattleground:GetChecked() == 1 then 
				GameTooltip:SetText(LocDummy2 .. "Battleground" .. "|r.");--loc
			else
				GameTooltip:SetText(LocDummy3 .. "Battleground" .. "|r.");--loc
			end;
		end;
		AddTooltipFunc(Innervator2.IgnoreBattleground,IgnoreBattlegroundTTFunc);
		
		--RAID SHOW/HIDE
		Innervator2.EnableDisableButtonRaid 			=	CreateCheckButton(60,StartHeight-80-45-50,"Raid instance","",CurrentPanel);--loc
		Innervator2.EnableDisableButtonRaid:SetScript("OnClick",function()
			if Innervator2.EnableDisableButtonRaid:GetChecked() == 1 then
				Innervator2Config["EnableDisableRaid"] = true;
			else
				Innervator2Config["EnableDisableRaid"] = false;
			end
			GameTooltip:Hide();
		end);
		
		local function EnableDisableRaidTTFunc()
			if Innervator2.EnableDisableButtonRaid:GetChecked() == 1 then 
				GameTooltip:SetText(GenerateToolTip("Raid","Enabled"));--loc
			else
				GameTooltip:SetText(GenerateToolTip("Raid","Disabled"));--loc
			end;
		end;
		AddTooltipFunc(Innervator2.EnableDisableButtonRaid,EnableDisableRaidTTFunc);
		
		--RAID IGNORE
		Innervator2.IgnoreRaid 					= 	CreateCheckButton(35,StartHeight-80-45-50,"","",CurrentPanel);
		Innervator2.IgnoreRaid:SetScript("OnClick",function()
			if Innervator2.IgnoreRaid:GetChecked() == 1 then
				Innervator2Config["IgnoreRaid"] = true;
				Innervator2.EnableDisableButtonRaid:Disable();
			else
				Innervator2Config["IgnoreRaid"] = false;
				Innervator2.EnableDisableButtonRaid:Enable();
			end;
			GameTooltip:Hide();
		end);
		
		local function IgnoreRaidTTFunc()
			if Innervator2.IgnoreRaid:GetChecked() == 1 then 
				GameTooltip:SetText(LocDummy2 .. "Raid" .. "|r.");--loc
			else
				GameTooltip:SetText(LocDummy3 .. "Raid" .. "|r.");--loc
			end;
		end;
		AddTooltipFunc(Innervator2.IgnoreRaid,IgnoreRaidTTFunc);
		
		--PARTY SHOW/HIDE
		Innervator2.EnableDisableButtonParty 			=	CreateCheckButton(60,StartHeight-80-45-75,"Party instance","",CurrentPanel);--loc
		Innervator2.EnableDisableButtonParty:SetScript("OnClick",function()
			if Innervator2.EnableDisableButtonParty:GetChecked() == 1 then
				Innervator2Config["EnableDisableParty"] = true;
			else
				Innervator2Config["EnableDisableParty"] = false;
			end
			GameTooltip:Hide();
		end);
		
		local function EnableDisablePartyTTFunc()
			if Innervator2.EnableDisableButtonParty:GetChecked() == 1 then 
				GameTooltip:SetText(GenerateToolTip("Party","Enabled"));--loc
			else
				GameTooltip:SetText(GenerateToolTip("Party","Disabled"));--loc
			end;
		end;
		AddTooltipFunc(Innervator2.EnableDisableButtonParty,EnableDisablePartyTTFunc);
		
		--PARTY IGNORE
		Innervator2.IgnoreParty					= 	CreateCheckButton(35,StartHeight-80-45-75,"","",CurrentPanel);
		Innervator2.IgnoreParty:SetScript("OnClick",function()
			if Innervator2.IgnoreParty:GetChecked() == 1 then
				Innervator2Config["IgnoreParty"] = true;
				Innervator2.EnableDisableButtonParty:Disable();
			else
				Innervator2Config["IgnoreParty"] = false;
				Innervator2.EnableDisableButtonParty:Enable();
			end;
			GameTooltip:Hide();
		end);
		
		local function IgnorePartyTTFunc()
			if Innervator2.IgnoreParty:GetChecked() == 1 then 
				GameTooltip:SetText(LocDummy2 .. "Party" .. "|r.");--loc
			else
				GameTooltip:SetText(LocDummy3 .. "Party" .. "|r.");--loc
			end;
		end;
		AddTooltipFunc(Innervator2.IgnoreParty,IgnorePartyTTFunc);
		
		--OUTSIDE SHOW/HIDE
		Innervator2.EnableDisableButtonOutside			=	CreateCheckButton(60,StartHeight-80-45-100,"Outside","",CurrentPanel);--loc
		Innervator2.EnableDisableButtonOutside:SetScript("OnClick",function()
			if Innervator2.EnableDisableButtonOutside:GetChecked() == 1 then
				Innervator2Config["EnableDisableOutside"] = true;
			else
				Innervator2Config["EnableDisableOutside"] = false;
			end
			GameTooltip:Hide();
		end);
		
		local function EnableDisableOutsideTTFunc()
			if Innervator2.EnableDisableButtonOutside:GetChecked() == 1 then 
				GameTooltip:SetText(GenerateToolTip("Outside","Enabled"));--loc
			else
				GameTooltip:SetText(GenerateToolTip("Outside","Disabled"));--loc
			end;
			GameTooltip:AddLine("Everything non instanced is considered 'outside'.",1,1,1);--loc
		end;
		AddTooltipFunc(Innervator2.EnableDisableButtonOutside,EnableDisableOutsideTTFunc);
		
		--OUTSIDE IGNORE
		Innervator2.IgnoreOutside 				= 	CreateCheckButton(35,StartHeight-80-45-100,"","",CurrentPanel);
		Innervator2.IgnoreOutside:SetScript("OnClick",function()
			if Innervator2.IgnoreOutside:GetChecked() == 1 then
				Innervator2Config["IgnoreOutside"] = true;
				Innervator2.EnableDisableButtonOutside:Disable();
			else
				Innervator2Config["IgnoreOutside"] = false;
				Innervator2.EnableDisableButtonOutside:Enable();
			end;
			GameTooltip:Hide();
		end);
		
		local function IgnoreOutsideTTFunc()
			if Innervator2.IgnoreOutside:GetChecked() == 1 then 
				GameTooltip:SetText(LocDummy2 .. "Outside" .. "|r.");--loc
			else
				GameTooltip:SetText(LocDummy3 .. "Outside" .. "|r.");--loc
			end;
		end;
		AddTooltipFunc(Innervator2.IgnoreOutside,IgnoreOutsideTTFunc);
		
		--SHOW/HIDE WHEN SPECING...
		CreateFontString(230,50,270,StartHeight-80,"Enable/disable when specing...",CurrentPanel);--loc

		local LocDummy4 = "Status of Innervator2 when you spec |cffFFFFFF";--loc
		local LocDummy5 = "Status will not change when you spec |cffFFFFFF";--loc
		local LocDummy6 = "Check this box to not change status when you spec |cffFFFFFF";--loc
		local function GenerateToolTip(Location,IsShown)
			return LocDummy4 .. Location .. "|r: " .. IsShown .. "."
		end;
		
		--FERAL SHOW/HIDE
		Innervator2.EnableDisableButtonFeral 			=	CreateCheckButton(270+30,StartHeight-80-45,		"Feral",			"",CurrentPanel);--loc
		Innervator2.EnableDisableButtonFeral:SetScript("OnClick",function()
			if Innervator2.EnableDisableButtonFeral:GetChecked() == 1 then
				Innervator2Config["EnableDisableFeral"] = true;
			else
				Innervator2Config["EnableDisableFeral"] = false;
			end
			GameTooltip:Hide();
		end);
		
		local function EnableDisableFeralTTFunc()
			if Innervator2.EnableDisableButtonFeral:GetChecked() == 1 then 
				GameTooltip:SetText(GenerateToolTip("Feral","Enabled"));--loc
			else
				GameTooltip:SetText(GenerateToolTip("Feral","Disabled"));--loc
			end;
		end;
		AddTooltipFunc(Innervator2.EnableDisableButtonFeral,EnableDisableFeralTTFunc);
		
		--FERAL IGNORE
		Innervator2.IgnoreFeral 					=	CreateCheckButton(270+5,StartHeight-80-45,"","",CurrentPanel);
		Innervator2.IgnoreFeral:SetScript("OnClick",function()
			if Innervator2.IgnoreFeral:GetChecked() == 1 then
				Innervator2Config["IgnoreFeral"] = true;
				Innervator2.EnableDisableButtonFeral:Disable();
			else
				Innervator2Config["IgnoreFeral"] = false;
				Innervator2.EnableDisableButtonFeral:Enable();
			end;
			GameTooltip:Hide();
		end);
		
		local function IgnoreFeralTTFunc()
			if Innervator2.IgnoreFeral:GetChecked() == 1 then 
				GameTooltip:SetText(LocDummy5 .. "Feral" .. "|r.");--loc
			else
				GameTooltip:SetText(LocDummy6 .. "Feral" .. "|r.");--loc
			end;
		end;
		AddTooltipFunc(Innervator2.IgnoreFeral,IgnoreFeralTTFunc);

		--MOONKIN SHOW/HIDE
		Innervator2.EnableDisableButtonMoonkin 			=	CreateCheckButton(270+30,StartHeight-80-45-25,		"Moonkin",			"",CurrentPanel);--loc
		Innervator2.EnableDisableButtonMoonkin:SetScript("OnClick",function()
			if Innervator2.EnableDisableButtonMoonkin:GetChecked() == 1 then
				Innervator2Config["EnableDisableMoonkin"] = true;
			else
				Innervator2Config["EnableDisableMoonkin"] = false;
			end
			GameTooltip:Hide();
		end);
		
		local function EnableDisableMoonkinTTFunc()
			if Innervator2.EnableDisableButtonMoonkin:GetChecked() == 1 then 
				GameTooltip:SetText(GenerateToolTip("Moonkin","Enabled"));--loc
			else
				GameTooltip:SetText(GenerateToolTip("Moonkin","Disabled"));--loc
			end;
		end;
		AddTooltipFunc(Innervator2.EnableDisableButtonMoonkin,EnableDisableMoonkinTTFunc);
		
		--MOONKIN IGNORE
		Innervator2.IgnoreMoonkin 					=	CreateCheckButton(270+5,StartHeight-80-45-25,"","",CurrentPanel);
		Innervator2.IgnoreMoonkin:SetScript("OnClick",function()
			if Innervator2.IgnoreMoonkin:GetChecked() == 1 then
				Innervator2Config["IgnoreMoonkin"] = true;
				Innervator2.EnableDisableButtonMoonkin:Disable();
			else
				Innervator2Config["IgnoreMoonkin"] = false;
				Innervator2.EnableDisableButtonMoonkin:Enable();
			end;
			GameTooltip:Hide();
		end);
		
		local function IgnoreMoonkinTTFunc()
			if Innervator2.IgnoreMoonkin:GetChecked() == 1 then 
				GameTooltip:SetText(LocDummy5 .. "Moonkin" .. "|r.");--loc
			else
				GameTooltip:SetText(LocDummy6 .. "Moonkin" .. "|r.");--loc
			end;
		end;
		AddTooltipFunc(Innervator2.IgnoreMoonkin,IgnoreMoonkinTTFunc);
		
		--GUARDIAN SHOW/HIDE
		Innervator2.EnableDisableButtonGuardian 			=	CreateCheckButton(270+30,StartHeight-80-45-50,		"Guardian",			"",CurrentPanel);--loc
		Innervator2.EnableDisableButtonGuardian:SetScript("OnClick",function()
			if Innervator2.EnableDisableButtonGuardian:GetChecked() == 1 then
				Innervator2Config["EnableDisableGuardian"] = true;
			else
				Innervator2Config["EnableDisableGuardian"] = false;
			end
			GameTooltip:Hide();
		end);
		
		local function EnableDisableGuardianTTFunc()
			if Innervator2.EnableDisableButtonGuardian:GetChecked() == 1 then 
				GameTooltip:SetText(GenerateToolTip("Guardian","Enabled"));--loc
			else
				GameTooltip:SetText(GenerateToolTip("Guardian","Disabled"));--loc
			end;
		end;
		AddTooltipFunc(Innervator2.EnableDisableButtonGuardian,EnableDisableGuardianTTFunc);
		
		--GUARDIAN IGNORE
		Innervator2.IgnoreGuardian 					=	CreateCheckButton(270+5,StartHeight-80-45-50,"","",CurrentPanel);
		Innervator2.IgnoreGuardian:SetScript("OnClick",function()
			if Innervator2.IgnoreGuardian:GetChecked() == 1 then
				Innervator2Config["IgnoreGuardian"] = true;
				Innervator2.EnableDisableButtonGuardian:Disable();
			else
				Innervator2Config["IgnoreGuardian"] = false;
				Innervator2.EnableDisableButtonGuardian:Enable();
			end;
			GameTooltip:Hide();
		end);
		
		local function IgnoreGuardianTTFunc()
			if Innervator2.IgnoreGuardian:GetChecked() == 1 then 
				GameTooltip:SetText(LocDummy5 .. "Guardian" .. "|r.");--loc
			else
				GameTooltip:SetText(LocDummy6 .. "Guardian" .. "|r.");--loc
			end;
		end;
		AddTooltipFunc(Innervator2.IgnoreGuardian,IgnoreGuardianTTFunc);
		
		--RESTO SHOW/HIDE
		Innervator2.EnableDisableButtonRestoration 			=	CreateCheckButton(270+30,StartHeight-80-45-75,		"Restoration",			"",CurrentPanel);--loc
		Innervator2.EnableDisableButtonRestoration:SetScript("OnClick",function()
			if Innervator2.EnableDisableButtonRestoration:GetChecked() == 1 then
				Innervator2Config["EnableDisableRestoration"] = true;
			else
				Innervator2Config["EnableDisableRestoration"] = false;
			end
			GameTooltip:Hide();
		end);
		
		local function EnableDisableRestorationTTFunc()
			if Innervator2.EnableDisableButtonRestoration:GetChecked() == 1 then 
				GameTooltip:SetText(GenerateToolTip("Restoration","Enabled"));--loc
			else
				GameTooltip:SetText(GenerateToolTip("Restoration","Disabled"));--loc
			end;
		end;
		AddTooltipFunc(Innervator2.EnableDisableButtonRestoration,EnableDisableRestorationTTFunc);
		
		--RESTO IGNORE
		Innervator2.IgnoreRestoration 					=	CreateCheckButton(270+5,StartHeight-80-45-75,"","",CurrentPanel);
		Innervator2.IgnoreRestoration:SetScript("OnClick",function()
			if Innervator2.IgnoreRestoration:GetChecked() == 1 then
				Innervator2Config["IgnoreRestoration"] = true;
				Innervator2.EnableDisableButtonRestoration:Disable();
			else
				Innervator2Config["IgnoreRestoration"] = false;
				Innervator2.EnableDisableButtonRestoration:Enable();
			end;
			GameTooltip:Hide();
		end);
		
		local function IgnoreRestorationTTFunc()
			if Innervator2.IgnoreRestoration:GetChecked() == 1 then 
				GameTooltip:SetText(LocDummy5 .. "Restoration" .. "|r.");--loc
			else
				GameTooltip:SetText(LocDummy6 .. "Restoration" .. "|r.");--loc
			end;
		end;
		AddTooltipFunc(Innervator2.IgnoreRestoration,IgnoreRestorationTTFunc);
		
		--OPTION TO ENABLE/DISABLE SHOW&HIDE_WHEN...
		Innervator2.EnableDisableOnInstance = CreateCheckButton(20,StartHeight-94,"","",CurrentPanel);
		Innervator2.EnableDisableOnSpec = CreateCheckButton(261,StartHeight-94,"","",CurrentPanel);
		
		function Innervator2.ToggleAllEnableDisableButtons(IsInstance)
			Innervator2Config["EnableDisableOnInstance"] = IsInstance;
			--true: instance
			if IsInstance then				
				Innervator2.ZoneChangeFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
				
				--enable instance buttons
				if not (Innervator2.IgnoreArena:GetChecked() == 1) then
					Innervator2.EnableDisableButtonArena:Enable();
				end;
				
				if not (Innervator2.IgnoreBattleground:GetChecked() == 1) then
					Innervator2.EnableDisableButtonBattleground:Enable();
				end;
				
				if not (Innervator2.IgnoreRaid:GetChecked() == 1) then
					Innervator2.EnableDisableButtonRaid:Enable();
				end;
				
				if not (Innervator2.IgnoreParty:GetChecked() == 1) then
					Innervator2.EnableDisableButtonParty:Enable();
				end;
				
				if not (Innervator2.IgnoreOutside:GetChecked() == 1) then
					Innervator2.EnableDisableButtonOutside:Enable();
				end;
				
				Innervator2.IgnoreArena:Enable();
				Innervator2.IgnoreBattleground:Enable();
				Innervator2.IgnoreRaid:Enable();
				Innervator2.IgnoreParty:Enable();
				Innervator2.IgnoreOutside:Enable();
				
				--disable spec buttons
				Innervator2.EnableDisableButtonFeral:Disable();
				Innervator2.EnableDisableButtonMoonkin:Disable();
				Innervator2.EnableDisableButtonGuardian:Disable();
				Innervator2.EnableDisableButtonRestoration:Disable();
				Innervator2.IgnoreFeral:Disable();
				Innervator2.IgnoreMoonkin:Disable();
				Innervator2.IgnoreGuardian:Disable();
				Innervator2.IgnoreRestoration:Disable();
			else
			--false: spec		
				Innervator2.ZoneChangeFrame:UnregisterAllEvents();
				
				--enable spec buttons
				if not (Innervator2.IgnoreFeral:GetChecked() == 1) then
					Innervator2.EnableDisableButtonFeral:Enable();
				end;
				
				if not (Innervator2.IgnoreMoonkin:GetChecked() == 1) then
					Innervator2.EnableDisableButtonMoonkin:Enable();
				end;
				
				if not (Innervator2.IgnoreGuardian:GetChecked() == 1) then
					Innervator2.EnableDisableButtonGuardian:Enable();
				end;
				
				if not (Innervator2.IgnoreRestoration:GetChecked() == 1) then
					Innervator2.EnableDisableButtonRestoration:Enable();
				end;
				
				Innervator2.IgnoreFeral:Enable();
				Innervator2.IgnoreMoonkin:Enable();
				Innervator2.IgnoreGuardian:Enable();
				Innervator2.IgnoreRestoration:Enable();
				
				--disable instance buttons
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
			end;
		end;
		
		Innervator2.EnableDisableOnInstance:SetScript("OnClick",function()
			if Innervator2.EnableDisableOnInstance:GetChecked() == 1 then
				Innervator2.EnableDisableOnSpec:SetChecked(0);
				Innervator2.ToggleAllEnableDisableButtons(true);
			else
				Innervator2.EnableDisableOnSpec:SetChecked(1);
				Innervator2.ToggleAllEnableDisableButtons(false);
			end;
		end);
		
		Innervator2.EnableDisableOnSpec:SetScript("OnClick",function()
			if Innervator2.EnableDisableOnSpec:GetChecked() == 1 then
				Innervator2.EnableDisableOnInstance:SetChecked(0);
				Innervator2.ToggleAllEnableDisableButtons(false)
			else
				Innervator2.EnableDisableOnInstance:SetChecked(1);
				Innervator2.ToggleAllEnableDisableButtons(true);
			end;
		end);

		StartHeight = StartHeight - 50;
		CreateHLine(StartHeight-180,CurrentPanel);

		Innervator2.OptionsSliderWarningThreshold = CreateSlider(20,StartHeight-280,L["OptionsSliderThresholdLabel"],0,100,1,CurrentPanel);

		Innervator2.OptionsSliderWarningThreshold:SetScript("OnValueChanged",function()
			Innervator2Config["WarningThreshold"] = Innervator2.OptionsSliderWarningThreshold:GetValue();
			_G[Innervator2.OptionsSliderWarningThreshold:GetName()..'Text']:SetText(L["OptionsSliderThresholdLabel"]..Innervator2.OptionsSliderWarningThreshold:GetValue().."%");
		end);

		Innervator2.OptionsCheckWarningBest = CreateCheckButton(220,StartHeight-230,L["OptionsWarningByBest_LABEL"],L["OptionsWarningByBest_HINT"],CurrentPanel);

		Innervator2.OptionsCheckWarningBest:SetScript("OnClick",
			function()
				if Innervator2.OptionsCheckWarningBest:GetChecked() == 1 then
					Innervator2.OptionsCheckWarningThreshold:SetChecked(false);
					Innervator2Config["WarningType"] = "Best";
					_G[Innervator2.OptionsSliderWarningThreshold:GetName() .. 'Low']:SetText("");
					_G[Innervator2.OptionsSliderWarningThreshold:GetName() .. 'High']:SetText("");
					Innervator2.OptionsSliderWarningThreshold:Disable();
				else
					Innervator2.OptionsCheckWarningThreshold:SetChecked(true);
					Innervator2Config["WarningType"] = "Threshold";
					_G[Innervator2.OptionsSliderWarningThreshold:GetName() .. 'Low']:SetText(0);
					_G[Innervator2.OptionsSliderWarningThreshold:GetName() .. 'High']:SetText(100);
					Innervator2.OptionsSliderWarningThreshold:Enable();
				end
			end
		);

		Innervator2.OptionsCheckWarningThreshold = CreateCheckButton(20,StartHeight-230,L["OptionsWarningByThreshold_LABEL"],L["OptionsWarningByThreshold_HINT"],CurrentPanel);

		Innervator2.OptionsCheckWarningThreshold:SetScript("OnClick",
			function()
				if Innervator2.OptionsCheckWarningThreshold:GetChecked() == 1 then
					Innervator2.OptionsCheckWarningBest:SetChecked(false);
					Innervator2Config["WarningType"] = "Threshold";
					_G[Innervator2.OptionsSliderWarningThreshold:GetName() .. 'Low']:SetText(0);
					_G[Innervator2.OptionsSliderWarningThreshold:GetName() .. 'High']:SetText(100);
					Innervator2.OptionsSliderWarningThreshold:Enable();
				else
					Innervator2.OptionsCheckWarningBest:SetChecked(true);
					Innervator2Config["WarningType"] = "Best";
					_G[Innervator2.OptionsSliderWarningThreshold:GetName() .. 'Low']:SetText("");
					_G[Innervator2.OptionsSliderWarningThreshold:GetName() .. 'High']:SetText("");
					Innervator2.OptionsSliderWarningThreshold:Disable();
				end
			end
		);

		local OptionsButtonHELP1 = CreateButton(60,20,540,StartHeight,L["OptionsButtonHelp"],CurrentPanel);

		OptionsButtonHELP1:SetScript("OnClick",function()
			print(L["OptionsBH1_1"]);
			print(L["OptionsBH1_2"]);
		end);

		local OptionsButtonHELP2 = CreateButton(60,20,540,StartHeight-120,L["OptionsButtonHelp"],CurrentPanel);

		OptionsButtonHELP2:SetScript("OnClick",function()
			print(L["OptionsBH2"]);
		end);

		local OptionsButtonHELP3 = CreateButton(60,20,540,StartHeight-230,L["OptionsButtonHelp"],CurrentPanel);

		OptionsButtonHELP3:SetScript("OnClick",function()
			print(L["OptionsBH3"]);
		end);

		StartHeight = StartHeight + 50;

		InterfaceOptions_AddCategory(Innervator2Panel);
		----------------------------------------------------------
		--------------main panel end------------------------------
		----------------------------------------------------------

		--------------WARNING1 PANEL-------------------------------
		local Innervator2WarningPanel = CreateFrame("Frame","Innervator2Warning1Panel",Innervator2Panel);
		Innervator2WarningPanel.name = L["Innervator2Warning1Panel_NAME"];
		Innervator2WarningPanel.parent = Innervator2Panel.name;

		CurrentPanel = Innervator2WarningPanel;

		CreateFontString(350,40,20,StartHeight+50,"|cffFF7D0AInnervator2|r (v"..GetAddOnMetadata("Innervator2","Version")..")"..L["OptionsWarning1StringInfo"],CurrentPanel);

		Innervator2.OptionsCheckSound = CreateCheckButton(20,StartHeight,L["OptionsCheckSound_LABEL"],L["OptionsCheckSound_HINT"],CurrentPanel);

		Innervator2.OptionsCheckSound:SetScript("OnClick",function()
			SlashCmdList["INNERVATORTWO"]("sound");
		end);

		local OptionsWarningStringSound1 = CreateFontString(150,15,20,StartHeight-30,L["OptionsWarningStringSound1"],CurrentPanel);
		OptionsWarningStringSound1:SetJustifyH("LEFT");

		Innervator2.OptionsWarningEditSound1 = CreateEditBox(350,20,StartHeight-50,CurrentPanel);

		--setup of dropdown menu for sound1 (innervate warning)
		local WarngingSelectDrop1 = CreateFrame("Frame","WarngingSelectDrop1",CurrentPanel);
		WarngingSelectDrop1.displayMode = "MENU";
		local info = {}
		WarngingSelectDrop1.initialize = function(self,level)
			if not level then
				return
			end
			wipe(info);
			if level == 1 then
				--title of the menu
				info.isTitle = 1;
				info.text = L["OptionsWarningSelectSounds"];
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info,1);

				--sounds
				info.disabled = nil;
				info.isTitle = nil;

				--innervate warning
				local SoundList1 = {};
				SoundList1[L["OptionsWarningSoundsReindeer"]] = "Sound\\Spells\\SummonReindeer.ogg";
				SoundList1[L["OptionsWarningSoundsPVPWarningAlliance"]] = "Sound\\Spells\\PVPWarningAlliance.ogg";
				SoundList1[L["OptionsWarningSoundsPVPWarningHorde"]] = "Sound\\Spells\\PVPWarningHorde.ogg";
				SoundList1[L["OptionsWarningSoundsTimeForFun"]] = "Sound\\creature\\BlackheartTheInciter\\Auch_Blckhrt01_Aggro02.ogg";
				SoundList1[L["OptionsWarningSoundsThekal"]] = "Sound\\creature\\Patch1.7_VO_Lines\\HighPriestThekalTransform.ogg";
				SoundList1[L["OptionsWarningSoundsLevelUp"]] = "Sound\\INTERFACE\\LevelUp.ogg";
				SoundList1[L["OptionsWarningSoundsSimonGame"]] = "Sound\\Spells\\SimonGame_Visual_GameStart.ogg";

				for key,value in pairs(SoundList1) do
					info.text = key;
					info.func = function()
						Innervator2.OptionsWarningEditSound1:SetText(value);
					end
					UIDropDownMenu_AddButton(info,1);
				end

				-- close button
				info.text = L["SelectDrop_CLOSE_INFO_TEXT"];
				info.func = function() end
				UIDropDownMenu_AddButton(info,1);
			end
		end

		local OptionsWarningButtonSet1 = CreateButton(20,20,350+20+5,StartHeight-50,"!",CurrentPanel);

		OptionsWarningButtonSet1:SetScript("OnClick",function(self)
			ToggleDropDownMenu(1,nil,WarngingSelectDrop1,self,-20,0);
		end);

		local OptionsWarningButtonSave1 = CreateButton(60,30,30,StartHeight-80,L["OptionsWarningButtonSave"],CurrentPanel);

		OptionsWarningButtonSave1:SetScript("OnClick",function(self)
			Innervator2Config["Soundfile1"] = Innervator2.OptionsWarningEditSound1:GetText();
			print(L["OptionsWarningSound1Saved"].."'"..Innervator2.OptionsWarningEditSound1:GetText().."'");
		end);

		local OptionsWarningButtonTest1 = CreateButton(60,30,30+70,StartHeight-80,L["OptionsWarningButtonTest"],CurrentPanel);

		OptionsWarningButtonTest1:SetScript("OnClick",function(self)
			if Innervator2Config["Sounds"] then
				PlaySoundFile(Innervator2.OptionsWarningEditSound1:GetText(),"Master");
				print("'"..Innervator2.OptionsWarningEditSound1:GetText()..L["OptionsWarningSoundtestPlayed"]);
			else
				print(L["PrintSoundsDisabled"]);
			end
		end);

		local OptionsWarningStringSound2 = CreateFontString(200,15,20,StartHeight-130,L["OptionsWarningStringSound2"],CurrentPanel);
		OptionsWarningStringSound2:SetJustifyH("LEFT");

		Innervator2.OptionsWarningEditSound2 = CreateEditBox(350,20,StartHeight-150,CurrentPanel);

		--setup of dropdown menu for sound2 (out of range)
		local WarngingSelectDrop2 = CreateFrame("Frame","WarngingSelectDrop2",CurrentPanel);
		WarngingSelectDrop2.displayMode = "MENU";
		local info = {}
		WarngingSelectDrop2.initialize = function(self,level)
			if not level then
				return
			end
			wipe(info);
			if level == 1 then
				--title of the menu
				info.isTitle = 1;
				info.text = L["OptionsWarningSelectSounds"];
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info,1);

				--sounds

				info.disabled = nil;
				info.isTitle = nil;

				--out of range warning
				local SoundList2 = {};
				SoundList2["TaurenFemale"] = "Sound\\character\\Tauren\\TaurenFemaleErrorMessages\\TaurenFemale_err_outofrange02.ogg";
				SoundList2["TaurenMale"] = "Sound\\character\\Tauren\\TaurenMaleErrorMessages\\TaurenMale_err_outofrange02.ogg";
				SoundList2["TrollFemale"] = "Sound\\character\\Troll\\TrollFemaleErrorMessages\\TrollFemale_err_outofrange02.ogg";
				SoundList2["TrollMale"] = "Sound\\character\\Troll\\TrollMaleErrorMessages\\TrollMale_err_outofrange02.ogg";
				SoundList2["NightElfFemale"] = "Sound\\character\\NightElf\\NightElfFemaleErrorMessages\\NightElfFemale_err_outofrange02.ogg";
				SoundList2["NightElfMale"] = "Sound\\character\\NightElf\\NightElfMaleErrorMessages\\NightElfMale_err_outofrange02.ogg";
				SoundList2["WorgenFemale"] = "Sound\\character\\PCWorgenFemale\\VO_PCWorgenFemale_ErrOutOfRange01.ogg";
				SoundList2["WorgenMale"] = "Sound\\character\\PCWorgenMale\\VO_PCWorgenMale_ErrOutOfRange01.ogg";

				for key,value in pairs(SoundList2) do
					info.text = key;
					info.func = function()
						Innervator2.OptionsWarningEditSound2:SetText(value);
					end
					UIDropDownMenu_AddButton(info,1);
				end

				-- close button
				info.text = L["SelectDrop_CLOSE_INFO_TEXT"];
				info.func = function() end
				UIDropDownMenu_AddButton(info,1);
			end
		end

		local OptionsWarningButtonSet2 = CreateButton(20,20,350+20+5,StartHeight-150,"!",CurrentPanel);

		OptionsWarningButtonSet2:SetScript("OnClick",function(self)
			ToggleDropDownMenu(1,nil,WarngingSelectDrop2,self,-20,0);
		end);

		local OptionsWarningButtonSave2 = CreateButton(60,30,30,StartHeight-180,L["OptionsWarningButtonSave"],CurrentPanel);

		OptionsWarningButtonSave2:SetScript("OnClick",function(self)
			Innervator2Config["Soundfile2"] = Innervator2.OptionsWarningEditSound2:GetText();
			print(L["OptionsWarningSound2Saved"].."'"..Innervator2.OptionsWarningEditSound2:GetText().."'");
		end);

		local OptionsWarningButtonTest2 = CreateButton(60,30,30+70,StartHeight-180,L["OptionsWarningButtonTest"],CurrentPanel);

		OptionsWarningButtonTest2:SetScript("OnClick",function(self)
			if Innervator2Config["Sounds"] then
				PlaySoundFile(Innervator2.OptionsWarningEditSound2:GetText(),"Master");
				print("'"..Innervator2.OptionsWarningEditSound2:GetText()..L["OptionsWarningSoundtestPlayed"]);
			else
				print(L["PrintSoundsDisabled"]);
			end
		end);

		local OptionsWarning1ButtonHELP = CreateButton(60,20,540,StartHeight-460,L["OptionsButtonHelp"],CurrentPanel);

		OptionsWarning1ButtonHELP:SetScript("OnClick",function()
			print(L["OptionsWarning1BH"]);
		end);

		InterfaceOptions_AddCategory(Innervator2WarningPanel);
		--------------WARNING1 PANEL end---------------------------
		--------------WARNING2 PANEL-------------------------------
		local function FrameColorInput()
			local function IsCorrectFrameFlashColor(input)
				if type(input) == "number" then
					if (input>=0) and (input<=1) then
						return true;
					else
						return false;
					end
				else
					return false;
				end
			end;

			local red,redrest = Innervator2.OptionsWarningEditFlashcolor:GetText():match("^(%S*)%s*(.-)$");
			local green,greenrest = redrest:match("^(%S*)%s*(.-)$");
			local blue,bluerest = greenrest:match("^(%S*)%s*(.-)$");

			local red,green,blue = tonumber(red),tonumber(green),tonumber(blue);

			if (IsCorrectFrameFlashColor(red)) and (IsCorrectFrameFlashColor(green)) and (IsCorrectFrameFlashColor(blue)) and (bluerest == "") then
				return red,green,blue;
			else
				return false;
			end
		end

		local Innervator2WarningPanel = CreateFrame("Frame","Innervator2Warning2Panel",Innervator2Panel);
		Innervator2WarningPanel.name = L["Innervator2Warning2Panel_NAME"];
		Innervator2WarningPanel.parent = Innervator2Panel.name;

		CurrentPanel = Innervator2WarningPanel;

		CreateFontString(350,40,20,StartHeight+50,"|cffFF7D0AInnervator2|r (v"..GetAddOnMetadata("Innervator2","Version")..")"..L["OptionsWarning2StringInfo"],CurrentPanel);

		Innervator2.OptionsCheckFlash = CreateCheckButton(20,StartHeight,L["OptionsWarningFrameflash_NAME"],L["OptionsWarningFrameflash_LABEL"],CurrentPanel);

		Innervator2.OptionsCheckFlash:SetScript("OnClick",function()
			if Innervator2.OptionsCheckFlash:GetChecked() == 1 then
				Innervator2Config["Flash"] = true;
			else
				Innervator2Config["Flash"] = false;
			end
		end);

		local OptionsWarningStringFlash = CreateFontString(80,15,20,StartHeight-30,L["OptionsWarningFlashColor"],CurrentPanel);
		OptionsWarningStringFlash:SetJustifyH("LEFT");

		local OptionsWarningButtonTestFlash = CreateButton(60,30,30+70,StartHeight-80,L["OptionsWarningButtonTest"],CurrentPanel);

		OptionsWarningButtonTestFlash:SetScript("OnClick",function(self)
			if FrameColorInput() then
				OptionsWarningButtonTestFlash:Disable();
				Innervator2.Innervator2FrameFlash(FrameColorInput());
			else
				print(L["OptionsWarningWrongInputColor"]);
			end
		end);

		CreateFontString(80,15,200,StartHeight-90,L["OptionsWarningColorPreview"],CurrentPanel);

		local ColorTestFrame = CreateFrame("Frame","Innervator2_ColorTestFrame",CurrentPanel);
		ColorTestFrame:SetPoint("TOPLEFT",CurrentPanel,"TOPLEFT",300,StartHeight-80);
		ColorTestFrame:SetWidth(50);
		ColorTestFrame:SetHeight(50);
		ColorTestFrame.bg = ColorTestFrame:CreateTexture(nil,"CENTER");
		ColorTestFrame.bg:SetTexture(0,0,0,0.5);
		ColorTestFrame.bg:SetAllPoints(ColorTestFrame);

		Innervator2.OptionsWarningEditFlashcolor = CreateEditBox(400,20,StartHeight-50,CurrentPanel);

		Innervator2.OptionsWarningEditFlashcolor:SetScript("OnTextChanged",function(self,isUser)
			OptionsWarningButtonTestFlash:Enable();
			if FrameColorInput() then
				local r,g,b = FrameColorInput();
				ColorTestFrame.bg:SetTexture(r,g,b,0.5);
			else
				ColorTestFrame.bg:SetTexture("Interface\\Icons\\inv_misc_questionmark");
			end
		end);

		local OptionsWarningButtonSetFlash = CreateButton(20,20,400+20+5,StartHeight-50,"!",CurrentPanel);

		OptionsWarningButtonSetFlash:SetScript("OnClick",function(self)
			local function ShowColorPicker(rOLD,gOLD,bOLD)
				ColorPickerFrame:SetColorRGB(rOLD,gOLD,bOLD);
				ColorPickerFrame.hasOpacity = false;
				ColorPickerFrame.func = function()
					local r,g,b = ColorPickerFrame:GetColorRGB();
					Innervator2.OptionsWarningEditFlashcolor:SetText(r.." "..g.." "..b);
				end
				ColorPickerFrame.cancelFunc = function(...)
					Innervator2.OptionsWarningEditFlashcolor:SetText(rOLD.." "..gOLD.." "..bOLD);
				end
				ColorPickerFrame:Hide();
				ColorPickerFrame:Show();
			end
			local r,g,b = 1,1,1;
			if FrameColorInput() then
				r,g,b = FrameColorInput();
			end
			if ColorPickerFrame:IsShown() then
				print(L["OptionsWarningErrorColorpickerShown"]);
			else
				ShowColorPicker(r,g,b);
			end
		end);

		local OptionsWarningButtonSaveFlash = CreateButton(60,30,30,StartHeight-80,L["OptionsWarningButtonSave"],CurrentPanel);

		OptionsWarningButtonSaveFlash:SetScript("OnClick",function(self)
			if FrameColorInput() then
				Innervator2Config["FFred"],Innervator2Config["FFgreen"],Innervator2Config["FFblue"] = FrameColorInput();
				print(L["OptionsWarningFrameflashColorSaved"]);
			else
				print(L["OptionsWarningWrongInputColor"]);
			end
		end);

		AddTooltip(OptionsWarningButtonSaveFlash,L["OptionsWarningFrameflashSave_TOOLTIP"]);

		CreateHLine(StartHeight-130,CurrentPanel);

		local OptionsWarningStringChatframe = CreateFontString(120,15,20,StartHeight-180-50,L["OptionsWarningStringChatframe"],CurrentPanel);
		OptionsWarningStringChatframe:SetJustifyH("LEFT");

		Innervator2.OptionsWarningEditChatframe = CreateEditBox(150,20,StartHeight-180-50-20,CurrentPanel);
		Innervator2.OptionsWarningEditChatframe:Disable();

		local OptionsWarningButtonSet3 = CreateButton(20,20,150+20+5,StartHeight-180-50-20,"!",CurrentPanel);

		--setup of dropdown menu for chat frames
		local WarngingSelectDrop3 = CreateFrame("Frame","WarngingSelectDrop3",CurrentPanel);
		WarngingSelectDrop3.displayMode = "MENU";
		local info = {}
		WarngingSelectDrop3.initialize = function(self,level)
			if not level then
				return
			end
			wipe(info);
			if level == 1 then
				--title of the menu
				info.isTitle = 1;
				info.text = L["OptionsWarningStringChatframe"];
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info,1);

				info.disabled = nil;
				info.isTitle = nil;

				--chat frame list
				local ChatframeList = {};
				ChatframeList[1] = L["OptionsWarningChatframesDefault"];
				ChatframeList[2] = L["OptionsWarningChatframesError"];
				ChatframeList[3] = L["OptionsWarningChatframesDBM"];

				for key,value in pairs(ChatframeList) do
					info.text = value;
					info.func = function()
						Innervator2.OptionsWarningEditChatframe:SetText(value);
					end
					UIDropDownMenu_AddButton(info,1);
				end

				-- close button
				info.text = L["SelectDrop_CLOSE_INFO_TEXT"];
				info.func = function() end
				UIDropDownMenu_AddButton(info,1);
			end
		end

		OptionsWarningButtonSet3:SetScript("OnClick",function(self)
			ToggleDropDownMenu(1,nil,WarngingSelectDrop3,self,-20,0);
		end);

		local OptionsWarningStringIcon = CreateFontString(80,15,220,StartHeight-180-50,L["OptionsWarningIcon"],CurrentPanel);
		OptionsWarningStringIcon:SetJustifyH("LEFT");

		Innervator2.OptionsWarningEditIcon = CreateEditBox(150,220,StartHeight-180-50-20,CurrentPanel);
		Innervator2.OptionsWarningEditIcon:Disable();

		local OptionsWarningButtonSet4 = CreateButton(20,20,150+220+5,StartHeight-180-50-20,"!",CurrentPanel);

		--setup of dropdown menu for icons
		local WarngingSelectDrop4 = CreateFrame("Frame","WarngingSelectDrop4",CurrentPanel);
		WarngingSelectDrop4.displayMode = "MENU";
		local info = {}
		WarngingSelectDrop4.initialize = function(self,level)
			if not level then
				return
			end
			wipe(info);
			if level == 1 then
				--title of the menu
				info.isTitle = 1;
				info.text = L["OptionsWarningIcon"];
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info,1);

				info.disabled = nil;
				info.isTitle = nil;

				--icon list
				local Icon = {};
				Icon[L["OptionsWarningIconsInnervate"]] = "";
				Icon[L["OptionsWarningIconsStar"]] = "";
				Icon[L["OptionsWarningIconsCircle"]] = "";
				Icon[L["OptionsWarningIconsDiamond"]] = "";
				Icon[L["OptionsWarningIconsTriangle"]] = "";
				Icon[L["OptionsWarningIconsMoon"]] = "";
				Icon[L["OptionsWarningIconsSquare"]] = "";
				Icon[L["OptionsWarningIconsCross"]] = "";
				Icon[L["OptionsWarningIconsSkull"]] = "";
				Icon[L["OptionsWarningIconsSkull2"]] = "";
				Icon[L["OptionsWarningIconsTreeOfLife"]] = "";
				Icon[L["OptionsWarningIconsReplenishment"]] = "";
				Icon[L["OptionsWarningIconsNone"]] = "";


				for key,value in pairs(Icon) do
					info.text = key;
					info.func = function()
						Innervator2.OptionsWarningEditIcon:SetText(key);
					end
					UIDropDownMenu_AddButton(info,1);
				end

				-- close button
				info.text = L["SelectDrop_CLOSE_INFO_TEXT"];
				info.func = function() end;
				UIDropDownMenu_AddButton(info,1);
			end
		end

		OptionsWarningButtonSet4:SetScript("OnClick",function(self)
			ToggleDropDownMenu(1,nil,WarngingSelectDrop4,self,-20,0);
		end);

		local OptionsWarningButtonSave3 = CreateButton(60,30,25,StartHeight-280,L["OptionsWarningButtonSave"],CurrentPanel);

		--set new Chatframe
		OptionsWarningButtonSave3:SetScript("OnClick",function(self)
			local msg = Innervator2.OptionsWarningEditChatframe:GetText();
			if msg == L["OptionsWarningChatframesError"] then
				Innervator2Config["Chatframe"] = "Error Frame";
			elseif msg == L["OptionsWarningChatframesDBM"] then
				Innervator2Config["Chatframe"] = "DBM Frame";
			else
				Innervator2Config["Chatframe"] = "Default Chatframe";
			end
			print(L["OptionsWarningChatframeSaved"]..msg..".");
		end);

		local OptionsWarningButtonTest3 = CreateButton(60,30,90,StartHeight-280,L["OptionsWarningButtonTest"],CurrentPanel);

		--test chatframe
		OptionsWarningButtonTest3:SetScript("OnClick",function(self)
			local text = L["OptionsWarningTestMessage"];
			local msg = Innervator2.OptionsWarningEditChatframe:GetText();
			if msg == L["OptionsWarningChatframesError"] then
				UIErrorsFrame:AddMessage(text,1,0,0,53,5);
			elseif msg == L["OptionsWarningChatframesDBM"] then
				RaidNotice_AddMessage(RaidWarningFrame,text,ChatTypeInfo["RAID_WARNING"]);
			else
				DEFAULT_CHAT_FRAME:AddMessage(text);
			end
		end);

		local OptionsWarningButtonSave4 = CreateButton(60,30,225,StartHeight-280,L["OptionsWarningButtonSave"],CurrentPanel);

		--set new icon
		OptionsWarningButtonSave4:SetScript("OnClick",function(self)
			local msg = Innervator2.OptionsWarningEditIcon:GetText();
			Innervator2Config["Icon"] = msg;
			print(L["OptionsWarningIconSaved"]..msg..".");
		end);

		local OptionsWarningButtonTest4 = CreateButton(60,30,290,StartHeight-280,L["OptionsWarningButtonTest"],CurrentPanel);

		--test icon
		OptionsWarningButtonTest4:SetScript("OnClick",function(self)
			local msg = Innervator2.OptionsWarningEditIcon:GetText();
			local text = Innervator2.Innervator2MsgIcon(msg)..L["OptionsWarningTestMessage"]..Innervator2.Innervator2MsgIcon(msg);
			if Innervator2Config["Chatframe"] == "Error Frame" then
				UIErrorsFrame:AddMessage(text,1,0,0,53,5);
			elseif Innervator2Config["Chatframe"] == "DBM Frame" then
				RaidNotice_AddMessage(RaidWarningFrame,text,ChatTypeInfo["RAID_WARNING"]);
			else
				DEFAULT_CHAT_FRAME:AddMessage(text);
			end
		end);

		--Line Count:
		local OptionsWarningStringLineCount = CreateFontString(120,15,20,StartHeight-180-50-100,L["OptionsWarningLineCount"],CurrentPanel);
		OptionsWarningStringLineCount:SetJustifyH("LEFT");

		Innervator2.OptionsWarningEditLineCount = CreateEditBox(150,20,StartHeight-180-50-20-100,CurrentPanel);
		Innervator2.OptionsWarningEditLineCount:Disable();
		
		local OptionsWarningButtonSet5 = CreateButton(20,20,150+20+5,StartHeight-180-50-20-100,"!",CurrentPanel);

		--setup of dropdown menu for line count
		local WarngingSelectDrop5 = CreateFrame("Frame","WarngingSelectDrop5",CurrentPanel);
		WarngingSelectDrop5.displayMode = "MENU";
		local info = {}
		WarngingSelectDrop5.initialize = function(self,level)
			if not level then
				return
			end
			wipe(info);
			if level == 1 then
				--title of the menu
				info.isTitle = 1;
				info.text = L["OptionsWarningLineCount"];
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info,1);

				info.disabled = nil;
				info.isTitle = nil;

				--linecount list
				local LineCount = {};
				LineCount[L["OptionsWarningSingleLine"]] = "";
				LineCount[L["OptionsWarningDoubleLine"]] = "";
				LineCount[L["OptionsWarningTripleLine"]] = "";


				for key,value in pairs(LineCount) do
					info.text = key;
					info.func = function()
						Innervator2.OptionsWarningEditLineCount:SetText(key);
					end
					UIDropDownMenu_AddButton(info,1);
				end

				-- close button
				info.text = L["SelectDrop_CLOSE_INFO_TEXT"];
				info.func = function() end;
				UIDropDownMenu_AddButton(info,1);
			end
		end

		OptionsWarningButtonSet5:SetScript("OnClick",function(self)
			ToggleDropDownMenu(1,nil,WarngingSelectDrop5,self,-20,0);
		end);

		local OptionsWarningButtonSave5 = CreateButton(60,30,25,StartHeight-280-100,L["OptionsWarningButtonSave"],CurrentPanel);

		OptionsWarningButtonSave5:SetScript("OnClick",function()
			Innervator2Config["LineCount"] = Innervator2.OptionsWarningEditLineCount:GetText();
			if Innervator2Config["LineCount"] == L["OptionsWarningSingleLine"] then
				Innervator2.LineCounter = 1;
			elseif Innervator2Config["LineCount"] == L["OptionsWarningTripleLine"] then
				Innervator2.LineCounter = 3;
			else
				Innervator2.LineCounter = 2;
			end;
			print(L["OptionsWarningLineCountSaved"]..Innervator2.OptionsWarningEditLineCount:GetText());
		end);

		AddTooltip(OptionsWarningButtonSave5,L["OptionsWarningLineCount_TOOLTIP"]);

		local OptionsWarningButtonTest5 = CreateButton(60,30,90,StartHeight-280-100,L["OptionsWarningButtonTest"],CurrentPanel);
		
		OptionsWarningButtonTest5:SetScript("OnClick",function()
			local LineCount;
			if Innervator2.OptionsWarningEditLineCount:GetText() == L["OptionsWarningSingleLine"] then
				LineCount = 1;
			elseif Innervator2.OptionsWarningEditLineCount:GetText() == L["OptionsWarningTripleLine"] then
				LineCount = 3;
			else
				LineCount = 2;
			end

			for i=1,LineCount do
				local text = Innervator2.Innervator2MsgIcon(Innervator2Config["Icon"])..L["OptionsWarningTestMessage"]..Innervator2.Innervator2MsgIcon(Innervator2Config["Icon"]);
				if (Innervator2Config["Chatframe"] == "DBM Frame") then
					RaidNotice_AddMessage(RaidWarningFrame,text,ChatTypeInfo["RAID_WARNING"]);
				elseif (Innervator2Config["Chatframe"] == "Error Frame") then
					UIErrorsFrame:AddMessage(text,1,0,0,53,5);
				else
					DEFAULT_CHAT_FRAME:AddMessage(text);
				end
			end
		end);

		local OptionsWarning2ButtonHELP1 = CreateButton(60,20,540,StartHeight-120,L["OptionsButtonHelp"],CurrentPanel);

		OptionsWarning2ButtonHELP1:SetScript("OnClick",function()
			print(L["OptionsWarning2BH1"]);
		end);

		local OptionsWarning2ButtonHELP2 = CreateButton(60,20,540,StartHeight-300,L["OptionsButtonHelp"],CurrentPanel);

		OptionsWarning2ButtonHELP2:SetScript("OnClick",function()
			print(L["OptionsWarning2BH2"]);
		end);

		InterfaceOptions_AddCategory(Innervator2WarningPanel);
		--------------WARNING2 PANEL end---------------------------
		--------------MACRO PANEL----------------------------------
		local Innervator2MacroPanel = CreateFrame("Frame","Innervator2MacroPanel",Innervator2Panel);
		Innervator2MacroPanel.name = L["Innervator2MacroPanel_NAME"];
		Innervator2MacroPanel.parent = Innervator2Panel.name;

		CurrentPanel = Innervator2MacroPanel;

		CreateFontString(350,40,20,StartHeight+50,"|cffFF7D0AInnervator2|r (v"..GetAddOnMetadata("Innervator2","Version")..")"..L["OptionsMacroStringInfo"],CurrentPanel);

		CreateFontString(370,40,20,StartHeight-10,L["OptionsMacroInputMacroTextInfo"],CurrentPanel);

		Innervator2.OptionsMacroInputMacroText = CreateFontString(370,(-StartHeight+250)-(-StartHeight+20)-20,20,StartHeight-40,"",CurrentPanel);
		Innervator2.OptionsMacroInputMacroText:SetJustifyH("LEFT");

		local OptionsMacroPrintHyperlinkMacro = CreateButton(100,30,20,StartHeight-270,L["OptionsMacroPrintHyperlinkMacro"],CurrentPanel);

		OptionsMacroPrintHyperlinkMacro:SetScript("OnClick",function()
			print(L["OptionsMacroPrintHyperlink"]);
		end);

		local OptionsMacroEditTheMacro = CreateButton(100,30,130,StartHeight-270,L["OptionsMacroEditTheMacro"],CurrentPanel);

		OptionsMacroEditTheMacro:SetScript("OnClick",function()
			InterfaceOptionsFrame:Hide();
			SlashCmdList["INNERVATORTWO"]('macro edit');
		end);

		local OptionsMacroSaveTheMacro = CreateButton(100,30,240,StartHeight-270,L["OptionsMacroSaveTheMacro"],CurrentPanel);

		OptionsMacroSaveTheMacro:SetScript("OnClick",function()
			SlashCmdList["INNERVATORTWO"]('macro save');
		end);

		local OptionsMacroButtonHELP = CreateButton(60,20,540,StartHeight-460,L["OptionsButtonHelp"],CurrentPanel);

		OptionsMacroButtonHELP:SetScript("OnClick",function()
			print(L["OptionsMacroBH"]);
		end);

		InterfaceOptions_AddCategory(Innervator2MacroPanel);

		--------------MACRO PANEL end------------------------------

		--------------MANAPOT PANEL-------------------------------
		StartHeight = -70;

		local Innervator2ManaPotPanel = CreateFrame("Frame","Innervator2ManaPotPanel",Innervator2Panel);
		Innervator2ManaPotPanel.name = L["Innervator2ManaPotPanel_NAME"];
		Innervator2ManaPotPanel.parent = Innervator2Panel.name;

		CurrentPanel = Innervator2ManaPotPanel;

		CreateFontString(350,40,20,StartHeight+50,"|cffFF7D0AInnervator2|r (v"..GetAddOnMetadata("Innervator2","Version")..")"..L["OptionsManaPotStringInfo"],CurrentPanel);

		Innervator2.OptionsSliderManaPotThreshold = CreateSlider(20,StartHeight-50,L["OptionsSliderThresholdLabel"],0,100,1,CurrentPanel);

		Innervator2.OptionsSliderManaPotThreshold:SetScript("OnValueChanged",function()
			Innervator2Config["ManaPotThreshold"] = Innervator2.OptionsSliderManaPotThreshold:GetValue();
			_G[Innervator2.OptionsSliderManaPotThreshold:GetName() .. 'Text']:SetText(L["OptionsSliderThresholdLabel"]..Innervator2.OptionsSliderManaPotThreshold:GetValue().."%");
		end);

		Innervator2.OptionsCheckManaPot = CreateCheckButton(20,StartHeight,L["OptionsCheckManaPot_LABEL"],L["OptionsCheckManaPot_HINT"],CurrentPanel);

		Innervator2.OptionsCheckManaPot:SetScript("OnClick",function()
			if Innervator2.OptionsCheckManaPot:GetChecked() == 1 then
				Innervator2Config["ManaPotEnabled"] = true;
				_G[Innervator2.OptionsSliderManaPotThreshold:GetName() .. 'Low']:SetText(0);
				_G[Innervator2.OptionsSliderManaPotThreshold:GetName() .. 'High']:SetText(100);
				Innervator2.OptionsSliderManaPotThreshold:Enable();
			else
				Innervator2Config["ManaPotEnabled"] = false;
				_G[Innervator2.OptionsSliderManaPotThreshold:GetName() .. 'Low']:SetText("");
				_G[Innervator2.OptionsSliderManaPotThreshold:GetName() .. 'High']:SetText("");
				Innervator2.OptionsSliderManaPotThreshold:Disable();
			end
		end);

		local OptionsManaPotStringSound = CreateFontString(150,15,20,StartHeight-100,L["OptionsWarningStringSound1"],CurrentPanel);
		OptionsManaPotStringSound:SetJustifyH("LEFT");

		Innervator2.OptionsManaPotEditSound = CreateEditBox(350,20,StartHeight-120,CurrentPanel);

		--setup of dropdown menu for manapot sound
		local ManaPotSelectDrop = CreateFrame("Frame","ManaPotSelectDrop",CurrentPanel);
		ManaPotSelectDrop.displayMode = "MENU";
		local info = {}
		ManaPotSelectDrop.initialize = function(self,level)
			if not level then
				return
			end
			wipe(info);
			if level == 1 then
				--title of the menu
				info.isTitle = 1;
				info.text = L["OptionsWarningSelectSounds"];
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info,1);

				--sounds
				info.disabled = nil;
				info.isTitle = nil;

				--manapot warning
				local SoundList3 = {};
				SoundList3["TaurenFemale"] = "Sound\\character\\Tauren\\TaurenVocalFemale\\TaurenFemaleOutOfMana01.ogg";
				SoundList3["TaurenMale"] = "Sound\\character\\Tauren\\TaurenVocalMale\\TaurenMaleOutOfMana01.ogg";
				SoundList3["TrollFemale"] = "Sound\\character\\Troll\\TrollVocalFemale\\TrollFemaleOutOfMana01.ogg";
				SoundList3["TrollMale"] = "Sound\\character\\Troll\\TrollVocalMale\\TrollMaleOutOfMana01.ogg";
				SoundList3["NightElfFemale"] = "Sound\\character\\NightElf\\NightElfVocalFemale\\NightElfFemaleOutOfMana01.ogg";
				SoundList3["NightElfMale"] = "Sound\\character\\NightElf\\NightElfVocalMale\\NightElfMaleOutOfMana01.ogg";
				SoundList3["WorgenFemale"] = "Sound\\character\\PCWorgenFemale\\VO_PCWorgenFemale_OutofMana01.ogg";
				SoundList3["WorgenMale"] = "Sound\\character\\PCWorgenMale\\VO_PCWorgenMale_OutofMana01.ogg";

				for key,value in pairs(SoundList3) do
					info.text = key;
					info.func = function()
						Innervator2.OptionsManaPotEditSound:SetText(value);
					end
					UIDropDownMenu_AddButton(info,1);
				end

				-- close button
				info.text = L["SelectDrop_CLOSE_INFO_TEXT"];
				info.func = function() end
				UIDropDownMenu_AddButton(info,1);
			end
		end

		local OptionsManaPotButtonSet = CreateButton(20,20,350+20+5,StartHeight-120,"!",CurrentPanel);

		OptionsManaPotButtonSet:SetScript("OnClick",function(self)
			ToggleDropDownMenu(1,nil,ManaPotSelectDrop,self,-20,0);
		end);

		local OptionsManaPotButtonSave = CreateButton(60,30,30,StartHeight-150,L["OptionsWarningButtonSave"],CurrentPanel);

		OptionsManaPotButtonSave:SetScript("OnClick",function(self)
			Innervator2Config["SoundfileManaPot"] = Innervator2.OptionsManaPotEditSound:GetText();
			print(L["OptionsManaPotSoundSaved"].." '"..Innervator2.OptionsManaPotEditSound:GetText().."'");
		end);

		local OptionsManaPotButtonTest = CreateButton(60,30,30+70,StartHeight-150,L["OptionsWarningButtonTest"],CurrentPanel);

		OptionsManaPotButtonTest:SetScript("OnClick",function(self)
			if Innervator2Config["Sounds"] then
				PlaySoundFile(Innervator2.OptionsManaPotEditSound:GetText(),"Master");
				print("'"..Innervator2.OptionsManaPotEditSound:GetText()..L["OptionsWarningSoundtestPlayed"]);
			else
				print(L["PrintSoundsDisabled"]);
			end
		end);

		local OptionsManaPotButtonHELP = CreateButton(60,20,540,StartHeight-455,L["OptionsButtonHelp"],CurrentPanel);

		OptionsManaPotButtonHELP:SetScript("OnClick",function()
			print(L["OptionsManaPotBH"]);
		end);

		InterfaceOptions_AddCategory(Innervator2ManaPotPanel);
		--------------MANAPOT PANEL end---------------------------

	--end optionsmenu
	-------------------------------------------------------------
	-------------------------------------------------------------
	-------------------------------------------------------------
end