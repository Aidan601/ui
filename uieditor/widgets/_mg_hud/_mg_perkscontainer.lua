require("ui.uieditor.widgets.HUD.ZM_Perks.perklistitemfactory")

local PerkTable =
{
	quick_revive              = "tf2_perk_quick_revive", -- Quick Revive
	doubletap2                = "tf2_perk_double_tap",   -- Double Tap
	juggernaut                = "tf2_perk_juggernog",    -- Jugg
	sleight_of_hand           = "tf2_perk_speed_cola",   -- Speed Cola
	dead_shot                 = "tf2_perk_deadshot",     -- Dead Shot
	phdflopper                = "tf2_perk_phd_flopper",  -- PhD Flopper
	marathon                  = "tf2_perk_staminup",     -- Staminup
	additional_primary_weapon = "tf2_perk_mule_kick",    -- Mule Kick
	electric_cherry           = "tf2_perk_electric_cherry", -- Electric Cherry
	widows_wine               = "tf2_perk_widows_wine",  -- Widows
	tombstone                 = "tf2_perk_tombstone",    -- Tombstone
	vultureaid                = "tf2_perk_vulture",      -- Vulture Aid
	whoswho                   = "tf2_perk_who",          -- Whos Who
	directionalfire           = "tf2_perk_vigor_rush",   -- Vigor Rush                   -- KhelMho
	madgaz_moonshine          = "tf2_perk_moonshine",    -- Madgaz Moonshine             -- Madgaz
	banana_colada             = "tf2_perk_banana",       -- Banana Colada                    -- Madgaz
	bull_ice_blast            = "tf2_perk_bull_ice",     -- Bull Ice Blast                   -- Madgaz
	crusaders_ale             = "tf2_perk_perk_ale",     -- Crusaders Ale                -- Madgaz
	power_aid                 = "tf2_perk_punch",        --Poweraid Punch        -- Madgaz
	ffyl                      = "tf2_perk_ffyl",         -- Fighters Fizz                -- Logical
	icu                       = "tf2_perk_icu",          -- I.C.U.                       -- Logical
	Tactiquilla               = "tf2_perk_taq"           -- Tactiquilla                  -- Logical
}

local GetPerkIndex = function(tableref, key)
	if tableref ~= nil then
		for index = 1, #tableref, 1 do
			if tableref[index].properties.key == key then
				return index
			end
		end
	end
	return nil
end

local GetPerkNewState = function(tableref, key, status)
	if tableref ~= nil then
		for index = 1, #tableref, 1 do
			if tableref[index].properties.key == key and tableref[index].models.status ~= status then
				return index
			end
		end
	end
	return -1
end

local UpdatePerkList = function(menu, controller)
	if not menu.perksList then
		menu.perksList = {}
	end

	local perkTableChanged = false
	local perkListModel = Engine.GetModel(Engine.GetModelForController(controller), "hudItems.perks")

	for perkKey, perkImage in pairs(PerkTable) do
		local perkStatus = Engine.GetModelValue(Engine.GetModel(perkListModel, perkKey))
		if perkStatus ~= nil and perkStatus > 0 then
			if not GetPerkIndex(menu.perksList, perkKey) then
				table.insert(menu.perksList,
					{
						models =
						{
							image = perkImage,
							status = perkStatus,
							newPerk = false,
							perkid = perkKey
						},
						properties = {
							key = perkKey
						}
					})
				perkTableChanged = true
			end
			local perkNewStatus = GetPerkNewState(menu.perksList, perkKey, perkStatus)
			if perkNewStatus > 0 then
				menu.perksList[perkNewStatus].models.status = perkStatus
				Engine.SetModelValue(
					Engine.GetModel(Engine.GetModel(Engine.GetModelForController(controller), "ZMPerksFactory"),
						tostring(perkNewStatus) .. ".status"), perkStatus)
			end
		else
			local perkNewStatus = GetPerkIndex(menu.perksList, perkKey)
			if perkNewStatus then
				table.remove(menu.perksList, perkNewStatus)
				perkTableChanged = true
			end
		end
	end
	if perkTableChanged then
		for index = 1, #menu.perksList, 1 do
			menu.perksList[index].models.newPerk = index == #menu.perksList
		end
		return true
	end
	for index = 1, #menu.perksList, 1 do
		Engine.SetModelValue(Engine.GetModel(perkListModel, menu.perksList[index].properties.key),
			menu.perksList[index].models.status)
	end
	return false
end

DataSources.ZMPerksFactory = DataSourceHelpers.ListSetup("ZMPerksFactory", function(controller, tableref)
	UpdatePerkList(tableref, controller)
	return tableref.perksList
end, true)

local PreLoadFunc = function(self, controller)
	local perkListModel = Engine.CreateModel(Engine.GetModelForController(controller), "hudItems.perks")
	for perkKey, perkImage in pairs(PerkTable) do
		self:subscribeToModel(Engine.CreateModel(perkListModel, perkKey), function(modelRef)
			if UpdatePerkList(self.PerkList, controller) then
				self.PerkList:updateDataSource()
			end
		end, false)
	end
end

CoD._mg_perkscontainer = InheritFrom(LUI.UIElement)
CoD._mg_perkscontainer.new = function(menu, controller)
	local self = LUI.UIElement.new()
	if PreLoadFunc then
		PreLoadFunc(self, controller)
	end
	self:setUseStencil(false)
	self:setClass(CoD._mg_perkscontainer)
	self.id = "_mg_perkscontainer"
	self.soundSet = "default"
	self:setLeftRight(true, false, 0, 151)
	self:setTopBottom(true, false, 0, 36)
	self.anyChildUsesUpdateState = true

	local PerkList = LUI.UIList.new(menu, controller, 2, 0, nil, false, false, 0, 0, false, false)
	PerkList:makeFocusable()
	PerkList:setLeftRight(true, false, 80, 90)
	PerkList:setTopBottom(false, true, -70, -13)
	PerkList:setWidgetType(CoD.PerkListItemFactory)

	PerkList:setHorizontalCount(8)
	PerkList:setVerticalCount(3)

	PerkList:setDataSource("ZMPerksFactory")
	self:addElement(PerkList)
	self.PerkList = PerkList

	self.clipsPerState =
	{
		DefaultState =
		{
			DefaultClip = function()
				self:setupElementClipCounter(1)
				PerkList:completeAnimation()
				self.PerkList:setAlpha(1)
				self.clipFinished(PerkList, {})
			end
		},
		Hidden =
		{
			DefaultClip = function()
				self:setupElementClipCounter(1)
				PerkList:completeAnimation()
				self.PerkList:setAlpha(0)
				self.clipFinished(PerkList, {})
			end
		}
	}

	self:mergeStateConditions(
		{
			{
				stateName = "Hidden",
				condition = function(menu, element, event)
					if not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_AMMO_COUNTER_HIDE) and
						not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN) and
						not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM) and
						not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE) and
						not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_GAME_ENDED) and
						Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) then
						if not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IN_VEHICLE) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IS_SCOPED) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE) then
							return false
						end
					else
						return true
					end
					return false
				end
			}
		})

	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_AMMO_COUNTER_HIDE), function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_AMMO_COUNTER_HIDE
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN), function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM), function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_EMP_ACTIVE
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_GAME_ENDED
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_VISIBLE
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE), function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC), function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_VEHICLE
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED), function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE), function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_PLAYER_IN_AFTERLIFE
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IS_SCOPED
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN), function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller),
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_UI_ACTIVE
				})
		end)
	PerkList.id = "PerkList"

	LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
		element.PerkList:close()
	end)

	if PostLoadFunc then
		PostLoadFunc(self, controller, menu)
	end

	return self
end
