local LSM = LibStub("LibSharedMedia-3.0")
local AceConfig = LibStub("AceConfigDialog-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local addon_name = "hagakure_config"
local main_addon_name = "Hagakure"

local L = LibStub("AceLocale-3.0"):GetLocale(addon_name, false)
local addon = LibStub("AceAddon-3.0"):NewAddon(addon_name)

function addon:GenerateOptions()
	local step = 10

	local function getCount()
		local count = 0
		return function (s)
				s = s or 1
				count = count+s
				return count
			end
	end

	local function debug_(inp,level)
		local out,out_l = "",""
		level = level or 0
		for i=1, level do out_l=out_l.."  " end
		if type(inp)=="table" then
			for i,v in pairs(inp) do
				out=string.format("%s\n%s%s -> %s",out,out_l,debug_(i,level),debug_(v,level+1))
			end
		end
		if type(inp)=="string" then out=string.format("%s%s",out_l,inp) end
		if type(inp)=="number" then out=string.format("%s%s",out_l,inp) end
		if inp == nil then out="nil" end
		return out
	end

	do -- забиваем текстуры в SharedMedia
		do -- register fonts
			local folder = [[hagakure_config\fonts\]]

			LSM:Register("font", "Liberation Sans (U)",		[[Interface\Addons\]] .. folder .. [[LiberationSans-Regular.ttf]],LSM.LOCALE_BIT_ruRU)
			LSM:Register("font", "FSEX300 (U)",				[[Interface\Addons\]] .. folder .. [[FSEX300.ttf]],LSM.LOCALE_BIT_ruRU)
			LSM:Register("font", "DejaVu (U)",				[[Interface\Addons\]] .. folder .. [[DejaVuSansMono.ttf]],LSM.LOCALE_BIT_ruRU)
			LSM:Register("font", "Anonymous Pro Bold (U)",	[[Interface\Addons\]] .. folder .. [[AnonymousPro-Bold.ttf]],LSM.LOCALE_BIT_ruRU)
		end
		
		do -- additionals fonts from 01.02.2012
			local folder = [[hagakure_config\fonts\]]
			
			LSM:Register("font", "Impact",	[[Interface\Addons\]] .. folder .. [[impact.ttf]],LSM.LOCALE_BIT_ruRU)
			LSM:Register("font", "Liberation Serif",	[[Interface\Addons\]] .. folder .. [[LiberationSerif-Regular.ttf]],LSM.LOCALE_BIT_ruRU)
			LSM:Register("font", "X360",	[[Interface\Addons\]] .. folder .. [[X360.ttf]],LSM.LOCALE_BIT_ruRU)
			LSM:Register("font", "Ubuntu Condensed",	[[Interface\Addons\]] .. folder .. [[Ubuntu-C.ttf]],LSM.LOCALE_BIT_ruRU)
			LSM:Register("font", "Ubuntu Light",	[[Interface\Addons\]] .. folder .. [[Ubuntu-L.ttf]],LSM.LOCALE_BIT_ruRU)
			LSM:Register("font", "M+ 1c",	[[Interface\Addons\]] .. folder .. [[MPlus 1c.ttf]],LSM.LOCALE_BIT_ruRU)
			LSM:Register("font", "M+ 1c Bold",	[[Interface\Addons\]] .. folder .. [[MPlus 1c Bold.ttf]],LSM.LOCALE_BIT_ruRU)
			LSM:Register("font", "Expressway",	[[Interface\Addons\]] .. folder .. [[exprswy free.ttf]],LSM.LOCALE_BIT_ruRU)
		end
		
		do -- register borders
			local folder = [[hagakure\second\]]

			LSM:Register("border", "Quokka border 1",		[[Interface\Addons\]] .. folder .. [[UI-DialogBox-Border]])
			LSM:Register("border", "Quokka border 2",		[[Interface\Addons\]] .. folder .. [[UI-Tooltip-Border]])
		end
		
		do -- register background
			local folder = [[hagakure\second\]]
			
			LSM:Register("background", "Quokka background 1",		[[Interface\Addons\]] .. folder .. [[UI-DialogBox-Background]])
		end
	end

	local options = {
		type = "group",
		get = getProfileOption,
		set = setProfileOptionAndClearCache,
		args = {
			config = {
				type = "execute",
				name = "config",
				guiHidden = true,
				desc = "launch config window",
				order = 1,
				func = function () addon:ShowOptions() end,
			},
		},
	}

	do -- создание меню по модификации интерфейса
		local testFrame=nil
		local count = getCount()
		local conf = Hagakure.frame_configurations

		local function drawTestWindow()
			if testFrame then testFrame:Destroy() end
			
			local f = Hagakure.Window:CreateTradeWindow()

			f:SetDKPInfo(L["List of user."]) -- устанавливает значения надписи с дкп информацией
			f:SetLink(L["Test window itemLink"])
			f:SetSliderValues(10,60,1) -- установить значения слайдера
			f.CloseFunction = function() -- функция обработки кнопки закрытия окна
				f:Destroy()
			end
			f:SetOnChatSend(function() -- функция обработки отправки сообщения в чате
				local txt = f:GetActiveMSG()
				f:AddChatMSG(Hagakure:our_name(), txt)
			end)
			
			testFrame = f
		end

		local function getPos(val)
			local values={"TOP","TOPLEFT","TOPRIGHT","LEFT","RIGHT","BOTTOM","BOTTOMRIGHT","BOTTOMLEFT"}
			if val == nil then return values end
			if values[val] then return values[val] end
			for i,v in pairs (values) do if v==val then return i end end
		end

		local function getTitleType(inp)
			local w={}
			wipe(w)
			for v,_ in pairs (conf.title_styles) do table.insert(w,v) end
			table.sort(w)
			if inp==nil then return w end
			if w[inp] then return w[inp] end
			for i,v in pairs(w) do if v==inp then return i end end
		end

		local function getButtonType(inp)
			local w={}
			wipe(w)
			for v,_ in pairs (conf.button_styles) do table.insert(w,v) end
			table.sort(w)
			if inp==nil then return w end
			if w[inp] then return w[inp] end
			for i,v in pairs(w) do if v==inp then return i end end
		end

		local function getSizerType(inp)
			local w={}
			wipe(w)
			for v,_ in pairs (conf.sizer_styles) do table.insert(w,v) end
			table.sort(w)
			if inp==nil then return w end
			if w[inp] then return w[inp] end
			for i,v in pairs(w) do if v==inp then return i end end
			Hagakure:Print("fdsf")
		end

		local function getCloseType(inp)
			local w={}
			wipe(w)
			for v,_ in pairs (conf.close_styles) do table.insert(w,v) end
			table.sort(w)
			if inp==nil then return w end
			if w[inp] then return w[inp] end
			for i,v in pairs(w) do if v==inp then return i end end
		end

		options.args.frame = { -- создание меню по модификации интерфейса
			name = L["interface"],
			desc = L["description of interface"],
			type = "group",
			order = 2,
			args = {
				border = {
					type = "select",
					name = L["Border"],
					style = "dropdown",
					order = count(),
					values = LSM:HashTable("border"),
					dialogControl = "LSM30_Border",
					set = function (info,val) 
						Hagakure.db.profile.frame.border=val
						return val 
					end,
					get = function (info) return Hagakure.db.profile.frame.border end,
				},
				background = {
					type = "select",
					name = L["Background"],
					style = "dropdown",
					order = count(),
					values = LSM:HashTable("background"),
					dialogControl = "LSM30_Background",
					set = function (info,val) 
						Hagakure.db.profile.frame.background=val
						return val 
					end,
					get = function (info) return Hagakure.db.profile.frame.background end,
				},
				font = {
					type = "select",
					name = L["Font"],
					style = "dropdown",
					--width = "full",
					order = count(),
					values = LSM:HashTable("font"),
					dialogControl = "LSM30_Font",
					set = function (info,val) 
						Hagakure.db.profile.font.name=val
						return val 
					end,
					get = function (info) return Hagakure.db.profile.font.name end,
				},
				test = {
					type = "execute",
					name = L["Test"],
					order = -1,
					desc = "Open test window to see changes",
					func = drawTestWindow,
				},
				font_size_big = {
					type = "input",
					name = L["Font big size"],
					desc = L["desc big font"],
					width = "half",
					order = count(),
					set = function (info,val)
						local big_size = tonumber(val) or 18
						Hagakure.db.profile.font.big_size = big_size
						return big_size
					end,
					get = function () return tostring(Hagakure.db.profile.font.big_size) end,
				},
				font_size_small = {
					type = "input",
					name = L["Font small size"],
					desc = L["desc small font"],
					width = "half",
					order = count(),
					set = function (info,val)
						local small_size = tonumber(val) or 12
						Hagakure.db.profile.font.small_size = small_size
						return small_size
					end,
					get = function () return tostring(Hagakure.db.profile.font.small_size) end,
				},
				header1 = {
					name = L["Frame close button"],
					order = count(step),
					type = "header",
				},
				close_butt_pos = {
					name = L["Poisition of close button"],
					desc = L["desc position of close button"],
					type = "select",
					order = count(),
					values = getPos(),
					set = function (info,val) Hagakure.db.profile.frame.close.pos=getPos(val);return val end,
					get = function () return getPos(Hagakure.db.profile.frame.close.pos) end,
				},
				close_butt_x = {
					name = L["x offset"],
					desc = L["offset x desc"],
					type = "input",
					width = "half",
					order = count(),
					set = function (info, val)
						Hagakure.db.profile.frame.close.x = tonumber(val) or 0
						return tostring(Hagakure.db.profile.frame.close.x)
					end,
					get = function () return tostring(Hagakure.db.profile.frame.close.x) end,
				},
				close_butt_y = {
					name = L["y offset"],
					desc = L["offset y desc"],
					type = "input",
					width = "half",
					order = count(),
					set = function (info, val)
						Hagakure.db.profile.frame.close.y = tonumber(val) or 0
						return tostring(Hagakure.db.profile.frame.close.y)
					end,
					get = function () return tostring(Hagakure.db.profile.frame.close.y) end,
				},
				close_butt_type = {
					name = L["button type"],
					desc = L["type of close button"],
					type = "select",
					width = "half",
					order = count(),
					values = getCloseType(),
					set = function (info,val)
						Hagakure.db.profile.frame.close.type = getCloseType(val)
						return val
					end,
					get = function () return getCloseType(Hagakure.db.profile.frame.close.type) end,
				},
				header3 = {
					name = L["Misc frame's options"],
					order = count(step),
					type = "header",
				},
				title_type = {
					name = L["Title variant"],
					type = "select",
					desc = L["desc window's title style"],
					order = count(),
					width = "half",
					values = getTitleType(),
					set = function (info,val) Hagakure.db.profile.frame.title=getTitleType(val); return val end,
					get = function () return getTitleType(Hagakure.db.profile.frame.title) end,
				},
				button_type = {
					name = L["Button type"],
					type = "select",
					desc = L["button type desc"],
					order = count(),
					width = "half",
					values = getButtonType(),
					set = function (info,val) Hagakure.db.profile.frame.button=getButtonType(val); return val end,
					get = function () return getButtonType(Hagakure.db.profile.frame.button) end,
				},
				sizer_type = {
					name = L["Sizer type"],
					type = "select",
					desc = L["sizer type desc"],
					order = count(),
					width = "half",
					values = getSizerType(),
					set = function (info,val) Hagakure.db.profile.frame.sizer=getSizerType(val); return val end,
					get = function () return getSizerType(Hagakure.db.profile.frame.sizer) end,
				},
				header4 = {
					name = L["Chat options"],
					order = count(step),
					type = "header",
				},
				chat_butt_pos = {
					name = L["Poisition of chat button"],
					desc = L["desc position of chat button"],
					type = "select",
					order = count(),
					values = getPos(),
					set = function (info,val) Hagakure.db.profile.chat.butt.point = getPos(val);return val end,
					get = function () return getPos(Hagakure.db.profile.chat.butt.point) end,
				},
				chat_butt_x = {
					name = L["chat x offset"],
					desc = L["desc chat x offset"],
					type = "input",
					width = "half",
					order = count(),
					set = function (info, val)
						Hagakure.db.profile.chat.butt.x = tonumber(val) or 0
						return tostring(Hagakure.db.profile.chat.butt.x)
					end,
					get = function () return tostring(Hagakure.db.profile.chat.butt.x) end,
				},
				chat_butt_y = {
					name = L["chat y offset"],
					desc = L["desc chat y offset"],
					type = "input",
					width = "half",
					order = count(),
					set = function (info, val)
						Hagakure.db.profile.chat.butt.y = tonumber(val) or 0
						return tostring(Hagakure.db.profile.chat.butt.y)
					end,
					get = function () return tostring(Hagakure.db.profile.chat.butt.y) end,
				},
				header5 = {
					name = L["just beatyfull line"],
					type = "header",
					order = count(step),
				},
			},
		}
	end

	if Hagakure.db.char.raidLeader then -- создание меню с общими функциями
		local function DKPPool(inp)
			local w = Hagakure.Admin:DKPPoolActions("guiGetPools")
			if inp == nil then return w end
			if w[inp] then return w[inp] end
			for i,k in pairs(w) do if k==inp then return i end end
		end

		local function DownloadDKP()
			--AceConfig:Close(Hagakure.name)
			--GameTooltip:Hide()
			Hagakure.Admin:DownloadDKP()
		end
		
		local count = getCount()
		options.args.setup = { 
			name = L["setup"],
			desc = L["setup desc"],
			type = "group",
			order = 1,
			args = {
				header1 = {
					name = L["not common settings"],
					type = "header",
					order = count(step),
				},
				write_log = {
					name = L["logging"],
					desc = L["logging desc"],
					type = "toggle",
					order = count(),
					set = function () return Hagakure:TurnOnoffLogging() end,
					get = function () return Hagakure.db.char.is_logging end,
				},
				header2 = {
					name = L["functions"],
					type = "header",
					order = count(step),
				},
				delete_log = {
					name = L["delete log"],
					type = "execute",
					desc = L["delete log desc"],
					order = count(),
					confirm = true,
					func = function () Hagakure.Admin:DeleteLog() end,
				},
				clear_adj = {
					name = L["clear adj"],
					type = "execute",
					desc = L["clear adj desc"],
					order = count(),
					confirm = true,
					func = function () Hagakure.Admin:ClearAdj() end,
				},
				synhronize = {
					name = L["synhronize adj"],
					type = "execute",
					desc = L["synhronize adj desc"],
					order = count(),
					func = function () Hagakure.Admin:Synhronize() end,
				},
				header3 = {
					name = L["dkp pool"],
					type = "header",
					order = count(step),
				},
				pool = {
					type = "select",
					name = L["DKP pool"],
					desc = L["DKP pool desc"],
					order = count(),
					values = DKPPool(),
					set = function(info,val) Hagakure.Admin:DKPPoolActions("guiSetDKPpool",DKPPool(val));return val end,
					get = function() return DKPPool(Hagakure.Admin:DKPPoolActions("guiPool")) end,
				},
				dkp_list = {
					type = "execute",
					name = L["full list"],
					desc = L["full list desc"],
					order = count(),
					--width = "half",
					func = function() Hagakure:ShowInfo("DKP list",{[1]={header="DKP",text=Hagakure.Admin:ShowDKPList(true)}}) end,
				},
				dkp_raid = {
					type = "execute",
					name = L["raid list"],
					desc = L["raid list desc"],
					order = count(),
					--width = "half",
					func = function() Hagakure:ShowInfo("DKP list",{[1]={header="Raid DKP",text=Hagakure.Admin:ShowRaidDKP(true)}}) end,
				},
				get_dkp = {
					type = "execute",
					name = L["get dkp"],
					desc = L["get dkp desc"],
					order = count(),
					width = "half",
					func = DownloadDKP,
				},
				clear_dkp = {
					type = "execute",
					name = L["clear dkp"],
					desc = L["clear dkp desc"],
					order = count(),
					width = "half",
					confirm = true,
					func = function() Hagakure.Admin:ClearDownloadDKP() end,
				},
				alts = {
					type = "execute",
					name = L["alts"],
					desc = L["alts desc"],
					order = count(),
					width = "half",
					func = function() Hagakure:ShowInfo("Alt's list",{[1]={header="Alts:",text=Hagakure.Admin:ShowAlts(true)}}) end,
				},
				alts2 = {
					type = "execute",
					name = L["alts2"],
					desc = L["alts2 desc"],
					order = count(),
					--width = "half",
					func = function() Hagakure.Admin:AltsManage() end,
				},
				manage_adj = {
					type = "execute",
					name = L["manage adj"],
					desc = L["manage adj desc"],
					order = count(),
					--width = "half",
					func = function() Hagakure.Admin:ManageAdj() end,
				},
				header4 = {
					type = "header",
					name = L["just beatyfull line"],
					order = count(step),
				},
			},
		}
	end

	do -- создание меню по работе с профайлами
		options.args.profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(Hagakure.db)
		options.args.profiles.order = -1
		options.args.profiles.disabled = false
	end
	
	do -- создание титульной страницы
		local count = getCount()
		options.args.main = {
			name = L["main"],
			desc = L["main desc"],
			type = "group",
			order = 1,
			args = {
				header0 = {
					name = L["common settings"],
					order = count(step),
					type = "header",
				},
				second_trade_window = {
					name = L["second trade"],
					desc = L["second trade desc"],
					type = "toggle",
					order = count(),
					set = function () Hagakure.db.char.newTrade = not Hagakure.db.char.newTrade; return Hagakure.db.char.newTrade end,
					get = function () return Hagakure.db.char.newTrade end,
				},
				minimap_button = {
					name = L["minimap"],
					desc = L["minimap desc"],
					type = "toggle",
					order = count(),
					set = function () return not Hagakure:TurnOnoffMinimap() end,
					get = function () return not Hagakure.db.char.minimap.hide end,
				},
				loot_master_functions = {
					name = L["loot master"],
					desc = L["loot master desc"],
					type = "toggle",
					confirm = true,
					order = count(),
					set = function () return Hagakure:TurnOnoffLootmaster() end,
					get = function () return Hagakure.db.char.raidLeader end,
				},
				header1 = {
					name = L["just beatyfull line"],
					order = count(step),
					type = "header",
				},
				version = {
					name = L["show version"],
					type = "execute",
					desc = L["show version desc"],
					order = count(),
					func = function () Hagakure:ShowVersion() end,
				},
			},
		}
	end

	return options
end

function addon:ShowOptions()
	AceConfig:SetDefaultSize(Hagakure.name,Hagakure.db.profile.config_frame.width,Hagakure.db.profile.config_frame.height)
	AceConfig:Open(Hagakure.name)
end

function addon:RegisterOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable(Hagakure.name, addon:GenerateOptions(), "haga")
	--AceConfig:AddToBlizOptions(Hagakure.name)
	Hagakure.guiOptions={}
	Hagakure.guiOptions.main = AceConfig:AddToBlizOptions(Hagakure.name,Hagakure.name,nil,"main")
	Hagakure.guiOptions.common = AceConfig:AddToBlizOptions(Hagakure.name,L["setup"],Hagakure.name,"setup")
	Hagakure.guiOptions.frame = AceConfig:AddToBlizOptions(Hagakure.name,L["interface"],Hagakure.name,"frame")
	-- Hagakure.guiOptions.help = AceConfig:AddToBlizOptions(Hagakure.name,L["help"],Hagakure.name,"help")
	Hagakure.guiOptions.profiles = AceConfig:AddToBlizOptions(Hagakure.name,L["profiles"],Hagakure.name,"profiles")
	--Hagakure.guiOptions. = AceConfig:AddToBlizOptions(Hagakure.name,L[""],Hagakure.name,"")
end

function addon:OnInitialize()
	local main_addon = LibStub("AceAddon-3.0"):GetAddon(main_addon_name)
	if main_addon then main_addon.Config = addon end
	addon.version = GetAddOnMetadata(addon_name,"Version")
end

function addon:OnEnable()
end

function addon:OnDisable()
end
