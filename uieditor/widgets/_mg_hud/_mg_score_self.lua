require("ui.uieditor.widgets._mg_hud._mg_ShieldHealthWidget")

local health_over_flash = function(self, element, event)
	if not event.interrupted then
		element:beginAnimation("keyframe", 100, false, false, CoD.TweenType.Linear)
	end

	element:setAlpha(.7)

	if event.interrupted then
		self.clipFinished(element, event)
	else
		--element:setAlpha(0)
		element:registerEventHandler("transition_complete_keyframe", self.clipFinished)
	end
end

local setScaleToHealth = function(health)
	if not health then return end

	if health > 0.5 then
		return .65
	elseif health > 0.4 then
		return .75
	elseif health > 0.3 then
		return .85
	elseif health > 0.2 then
		return .95
	else
		return 1.05
	end
end

local PreLoadFunc = function(self, controller)
	Engine.CreateModel(Engine.GetModelForController(controller), "zmhud.playerHealth")
end

CoD._mg_score_self = InheritFrom(LUI.UIElement)
CoD._mg_score_self.new = function(menu, controller)
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc(self, controller)
	end

	self:setUseStencil(false)
	self:setClass(CoD._mg_score_self)
	self.id = "_mg_score_self"
	self.soundSet = "HUD"
	self.anyChildUsesUpdateState = true
	self:setLeftRight(true, false, 0, 1280)
	self:setTopBottom(true, false, 0, 720)

	local PlayerName = LUI.UIText.new()
	PlayerName:setLeftRight(true, false, 3, 90)
	PlayerName:setTopBottom(false, true, -85, -65)
	PlayerName:setTTF("fonts/Bebas-Regular.ttf")
	PlayerName:linkToElementModel(self, "playerName", true, function(ModelRef)
		if Engine.GetModelValue(ModelRef) then
			PlayerName:setText(Engine.Localize(Engine.GetModelValue(ModelRef)))
		end
	end)
	--self:addElement( PlayerName )
	self.PlayerName = PlayerName

	local class_bg = LUI.UIImage.new()
	class_bg:setLeftRight(true, false, -36.5, 152)
	class_bg:setTopBottom(false, true, -128.5, 75)
	class_bg:setImage(RegisterImage("red_class_bg"))

	local round_bg = LUI.UIImage.new()
	round_bg:setLeftRight(false, true, -113 + 4 + 2, -9.5 - 4 + 2)
	round_bg:setTopBottom(true, false, 7.5 + 4 + 32, 111 - 4 + 32)
	round_bg:setImage(RegisterImage("red_color_panel"))
	round_bg:setAlpha(1)
	self:addElement(round_bg)
	self.round_bg = round_bg

	local weapon_border = LUI.UIImage.new()
	weapon_border:setLeftRight(false, true, -138.5 + 2, 1 + 2)
	weapon_border:setTopBottom(false, true, -117.5 + 32, 21 + 32)
	weapon_border:setImage(RegisterImage("red_ammo_bg"))
	self:addElement(weapon_border)
	self.weapon_border = weapon_border

	self.grenade_bg = LUI.UIImage.new()
	self.grenade_bg:setLeftRight(false, true, -234.5 + 15 + 2, -147 + 15 + 2)
	self.grenade_bg:setTopBottom(false, true, -84 + 32, 4.5 + 32)
	self.grenade_bg:setImage(RegisterImage("red_grenade_bg"))
	self.grenade_bg:setAlpha(1)
	self:addElement(self.grenade_bg)

	self.class_soldierred = LUI.UIImage.new()
	self.class_soldierred:setLeftRight(true, false, 30.5, 132)
	self.class_soldierred:setTopBottom(false, true, -100, 11)
	self.class_soldierred:setImage(RegisterImage("blacktransparent"))
	self.class_soldierred:linkToElementModel(self, "zombiePlayerIcon", true, function(model)
		local zombiePlayerIcon = Engine.GetModelValue(model)

		if zombiePlayerIcon then
			if zombiePlayerIcon == "hudmercblue" then
				class_bg:setImage(RegisterImage("blue_class_bg"))
				round_bg:setImage(RegisterImage("blue_color_panel"))
				weapon_border:setImage(RegisterImage("blue_ammo_bg"))
				self.grenade_bg:setImage(RegisterImage("blue_grenade_bg"))
			elseif zombiePlayerIcon == "hudmercgreen" then
				class_bg:setImage(RegisterImage("green_class_bg"))
				round_bg:setImage(RegisterImage("green_color_panel"))
				weapon_border:setImage(RegisterImage("green_ammo_bg"))
				self.grenade_bg:setImage(RegisterImage("green_grenade_bg"))
			elseif zombiePlayerIcon == "hudmercyellow" then
				class_bg:setImage(RegisterImage("yellow_class_bg"))
				round_bg:setImage(RegisterImage("yellow_color_panel"))
				weapon_border:setImage(RegisterImage("yellow_ammo_bg"))
				self.grenade_bg:setImage(RegisterImage("yellow_grenade_bg"))
			else
				class_bg:setImage(RegisterImage("red_class_bg"))
				round_bg:setImage(RegisterImage("red_color_panel"))
				weapon_border:setImage(RegisterImage("red_ammo_bg"))
				self.grenade_bg:setImage(RegisterImage("red_grenade_bg"))
			end

			if zombiePlayerIcon == "hudssoldierred" then
				self.class_soldierred:setImage(RegisterImage("class_soldierred"))
			elseif zombiePlayerIcon == "hudheavyred" then
				self.class_soldierred:setImage(RegisterImage("class_heavyred"))
			elseif zombiePlayerIcon == "hudsniperred" then
				self.class_soldierred:setImage(RegisterImage("class_sniperred"))
			elseif zombiePlayerIcon == "huddemored" then
				self.class_soldierred:setImage(RegisterImage("class_demored"))
			elseif zombiePlayerIcon == "hudmercred" then
				self.class_soldierred:setImage(RegisterImage("class_mercenaryred"))
			elseif zombiePlayerIcon == "hudmercblue" then
				self.class_soldierred:setImage(RegisterImage("class_mercenaryblue"))
			elseif zombiePlayerIcon == "hudmercyellow" then
				self.class_soldierred:setImage(RegisterImage("class_mercenaryyellow"))
			elseif zombiePlayerIcon == "hudmercgreen" then
				self.class_soldierred:setImage(RegisterImage("class_mercenarygreen"))
			end
		end
	end)
	self:addElement(class_bg)
	self:addElement(self.class_soldierred)
	self.class_bg = class_bg

	self.health_over_bg = LUI.UIImage.new()
	self.health_over_bg:setLeftRight(true, false, 106.5 - 10, 195 + 10)
	self.health_over_bg:setTopBottom(false, true, -103.5 - 10, -15.5 + 10)
	self.health_over_bg:setRGB(1, 0, 0)
	self.health_over_bg:setAlpha(0)
	self.health_over_bg:setImage(RegisterImage("health_over_bg"))
	self.health_over_bg:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller), "flash_health"),
		function(model)
			local value = Engine.GetModelValue(model)
			if value == 1 then
				self.health_over_bg:completeAnimation()
				self.health_over_bg:setAlpha(0)
				health_over_flash(self, self.health_over_bg, {})
				--self.health_over_bg:setAlpha(0)
			elseif value == 0 then
				self.health_over_bg:setAlpha(0)
			end
		end)

	self.health_over_bg:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "zmhud.playerHealth"), function(model)
			local health = Engine.GetModelValue(model)
			if health then
				self.health_over_bg:setScale(setScaleToHealth(health))
			end
		end)
	self:addElement(self.health_over_bg)

	local health_bg = LUI.UIImage.new()
	health_bg:setLeftRight(true, false, 110, 191.5)
	health_bg:setTopBottom(false, true, -100, -19)
	health_bg:setImage(RegisterImage("health_bg"))
	self:addElement(health_bg)
	self.health_bg = health_bg

	local health_color = LUI.UIImage.new()
	health_color:setLeftRight(true, false, 113, 188.5)
	health_color:setTopBottom(false, true, -97, -22)
	health_color:setImage(RegisterImage("health_color"))
	health_color:setMaterial(LUI.UIImage.GetCachedMaterial("uie_wipe_normal"))
	health_color:setShaderVector(0, 1, 0, 0, 0)
	health_color:setShaderVector(1, 0, 0, 0, 0)
	health_color:setShaderVector(2, 1, 0, 0, 0)
	health_color:setShaderVector(3, 0, 0, 0, 0)
	health_color:setShaderVector(3, 0, 0, 0, 0)
	health_color:setZRot(90)
	self:addElement(health_color)
	self.HealthBar = health_color

	--local health_max_text = LUI.UIText.new(HudRef, InstanceRef)
	--health_max_text:setLeftRight(true, false, 136-1, 167.5+1)
	--health_max_text:setTopBottom(false, true, -110.5-1, -100.5+1)
	--health_max_text:setAlignment(LUI.Alignment.Center)
	--health_max_text:setTTF("fonts/verdana.ttf")
	--health_max_text:setAlpha(0)
	--health_max_text:setRGB(0.36470588235294116, 0.36470588235294116, 0.36470588235294116)

	local health_text = LUI.UIText.new(HudRef, InstanceRef)
	health_text:setLeftRight(true, false, 136, 167.5)
	health_text:setTopBottom(false, true, -70, -46)
	health_text:setAlignment(LUI.Alignment.Center)
	health_text:setTTF("fonts/TF2.ttf")
	health_text:setText("")
	health_text:setAlpha(1)
	health_text:setRGB(0.36470588235294116, 0.36470588235294116, 0.36470588235294116)
	health_text:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "max_health"), function(model)
			local healthint = Engine.GetModelValue(model)
			if healthint then
				if tonumber(healthint) == 0 then
					health_text:setText("")
				else
					health_text:setText(tonumber(healthint))
				end
			end
		end)
	self:addElement(health_text)
	--self:addElement(health_max_text)

	-- Functions NEED to be definde before use!
	local function UpdatePlayerHealth(ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef) --Get health number

		if ModelValue then
			display_health = math.floor(ModelValue * 150)
			health_color:completeAnimation() --Complete any animation
			--health_color:beginAnimation("keyframe", 1500, true, true, CoD.TweenType.Linear) --Scroll bar in 150ms
			if ModelValue == -1 then
				health_color:setShaderVector(0, 0, 0, 0, 0) -- If value is not valid then just hide the health bar
			else
				if ModelValue > 0.5 then
					health_color:setRGB(1, 1, 1) -- Set the colour to "normal"
					--health_over_bg:setLeftRight(true, false, 106.5 + 6, 195 - 6)
					--health_over_bg:setTopBottom(false, true, -103.5 + 6, -15.5 - 6)
				else
					health_color:setRGB(1, 0, 0) -- Set the colour to red
					--health_over_bg:setRGB(1, 0, 0)
					--health_over_bg:setLeftRight(true, false, 106.5 - 10, 195 + 10)
					--health_over_bg:setTopBottom(false, true, -103.5 - 10, -15.5 + 10)
				end
				--if ModelValue < 1 then
				--health_max_text:setText("100")
				--health_max_text:setAlpha(1)
				--else
				--health_max_text:setAlpha(0)
				--end
				--	health_color:beginAnimation("keyframe", 150, true, true, CoD.TweenType.Linear)
				health_color:setShaderVector(0, ModelValue, 0, 0, 0)
			end
		end
	end

	self:subscribeToGlobalModel(controller, "PerController", "zmhud.playerHealth", UpdatePlayerHealth)

	local player_points_bg = LUI.UIImage.new()
	player_points_bg:setLeftRight(true, false, 20.5, 148)
	player_points_bg:setTopBottom(false, true, -64, 63.5)
	player_points_bg:setImage(RegisterImage("player_points_bg"))
	self:addElement(player_points_bg)
	self.player_points_bg = player_points_bg

	local ScoreText_bg = LUI.UIText.new()
	ScoreText_bg:setLeftRight(true, false, 42, 132)
	ScoreText_bg:setTopBottom(false, true, -7, 11)
	ScoreText_bg:setRGB(0, 0, 0);
	ScoreText_bg:setAlignment(LUI.Alignment.Center)
	ScoreText_bg:setTTF("fonts/tf2build.ttf")
	ScoreText_bg:setScale(1)
	ScoreText_bg:linkToElementModel(self, "clientNum", true, function(modelRef)
		local clientNum = Engine.GetModelValue(modelRef)
		if clientNum then
			--ScoreText_bg:setRGB( ZombieClientScoreboardColor( clientNum ) )
		end
	end)
	ScoreText_bg:linkToElementModel(self, "playerScore", true, function(ModelRef)
		if Engine.GetModelValue(ModelRef) then
			ScoreText_bg:setText('$' .. Engine.Localize(Engine.GetModelValue(ModelRef)))
		end
	end)
	ScoreText_bg:setAlignment(LUI.Alignment.Center)
	self:addElement(ScoreText_bg)
	self.ScoreText = ScoreText_bg

	local ScoreText = LUI.UIText.new()
	ScoreText:setLeftRight(true, false, 42, 130)
	ScoreText:setTopBottom(false, true, -7.5, 10.5)
	ScoreText:setAlignment(LUI.Alignment.Center)
	ScoreText:setTTF("fonts/tf2build.ttf")
	ScoreText:setScale(1)
	ScoreText:linkToElementModel(self, "clientNum", true, function(modelRef)
		local clientNum = Engine.GetModelValue(modelRef)
		if clientNum then
			--ScoreText:setRGB( ZombieClientScoreboardColor( clientNum ) )
		end
	end)
	ScoreText:linkToElementModel(self, "playerScore", true, function(ModelRef)
		if Engine.GetModelValue(ModelRef) then
			ScoreText:setText('$' .. Engine.Localize(Engine.GetModelValue(ModelRef)))
		end
	end)
	ScoreText:setAlignment(LUI.Alignment.Center)
	self:addElement(ScoreText)
	self.ScoreText = ScoreText

	local ShieldHealth = CoD._mg_ShieldHealthWidget.new(menu, controller)
	ShieldHealth:setLeftRight(true, true, 0 + 920, 0)
	ShieldHealth:setTopBottom(true, true, 92, 0)
	self:addElement(ShieldHealth)
	self.ShieldHealth = ShieldHealth

	local PlayerRank = LUI.UIText.new()
	PlayerRank:setLeftRight(true, false, 3 + 100, 90 + 100)
	PlayerRank:setTopBottom(false, true, -85, -65)
	PlayerRank:setTTF("fonts/Bebas-Regular.ttf")
	PlayerRank:linkToElementModel(self, nil, false, function(ModelRef)
		PlayerRank:setModel(ModelRef, controller)
	end)
	PlayerRank:linkToElementModel(self, "position", true, function(ModelRef)
		local position = Engine.GetModelValue(ModelRef)
		if position then
			if position == 0 then
				PlayerRank:setText("")
			elseif position == 1 then
				PlayerRank:setText("1st")
			elseif position == 2 then
				PlayerRank:setText("2nd")
			elseif position == 3 then
				PlayerRank:setText("3rd")
			elseif position == 4 then
				PlayerRank:setText("4th")
			end
		end
	end)
	self:linkToElementModel(self, "position", true, function(ModelRef)
		menu:updateElementState(self,
			{
				name = "model_validation",
				menu = menu,
				modelValue = Engine.GetModelValue(ModelRef),
				modelName = "position"
			})
	end)
	self:addElement(PlayerRank)
	self.PlayerRank = PlayerRank

	self.clipsPerState =
	{
		DefaultState =
		{
			DefaultClip = function()
				self:setupElementClipCounter(8)

				self.ScoreText:completeAnimation()
				self.ScoreText:setAlpha(0)
				self.clipFinished(self.ScoreText, {})

				self.player_points_bg:completeAnimation()
				self.player_points_bg:setAlpha(0)
				self.clipFinished(self.player_points_bg, {})

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha(0)
				self.clipFinished(self.PlayerName, {})

				self.class_bg:completeAnimation()
				self.class_bg:setAlpha(0)
				self.clipFinished(self.class_bg, {})

				health_color:completeAnimation()
				health_color:setAlpha(0)
				self.clipFinished(health_color, {})

				self.health_bg:completeAnimation()
				self.health_bg:setAlpha(0)
				self.clipFinished(self.health_bg, {})

				self.ShieldHealth:completeAnimation()
				self.ShieldHealth:setAlpha(0)
				self.clipFinished(self.ShieldHealth, {})

				self.PlayerRank:completeAnimation()
				self.PlayerRank:setAlpha(0)
				self.clipFinished(self.PlayerRank, {})
			end
		},
		Visible =
		{
			DefaultClip = function()
				self:setupElementClipCounter(8)

				self.ScoreText:completeAnimation()
				self.ScoreText:setAlpha(1)
				self.clipFinished(self.ScoreText, {})

				self.player_points_bg:completeAnimation()
				self.player_points_bg:setAlpha(1)
				self.clipFinished(self.player_points_bg, {})

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha(1)
				self.clipFinished(self.PlayerName, {})

				self.class_bg:completeAnimation()
				self.class_bg:setAlpha(1)
				self.clipFinished(self.class_bg, {})

				health_color:completeAnimation()
				health_color:setAlpha(1)
				self.clipFinished(health_color, {})

				self.health_bg:completeAnimation()
				self.health_bg:setAlpha(1)
				self.clipFinished(self.health_bg, {})

				self.ShieldHealth:completeAnimation()
				self.ShieldHealth:setAlpha(1)
				self.clipFinished(self.ShieldHealth, {})

				self.PlayerRank:completeAnimation()
				self.PlayerRank:setAlpha(1)
				self.clipFinished(self.PlayerRank, {})
			end
		}
	}

	local function ChangeColor(ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			--self.PlayerName:setRGB( ZombieClientScoreboardColor( ModelValue ) )
			--self.ScoreText:setRGB( ZombieClientScoreboardColor( ModelValue ) )
			--self.PlayerRank:setRGB( ZombieClientScoreboardColor( ModelValue ) )
		end
	end

	self.ScoreText:linkToElementModel(self, "clientNum", true, ChangeColor)

	self:mergeStateConditions(
		{
			{
				stateName = "Visible",
				condition = function(menu, ItemRef, UpdateTable)
					return not IsSelfModelValueEqualTo(ItemRef, controller, "playerScoreShown", 0)
				end
			}
		})

	self:linkToElementModel(self, "playerScoreShown", true, function(ModelRef)
		menu:updateElementState(self,
			{
				name = "model_validation",
				menu = menu,
				modelValue = Engine.GetModelValue(ModelRef),
				modelName = "playerScoreShown"
			})
	end)

	LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
		element.ScoreText:close()
		element.player_points_bg:close()
		element.ShieldHealth:close()
		element.PlayerName:close()
		element.class_bg:close()
		element.HealthBar:close()
		element.health_bg:close()
		element.PlayerRank:close()
	end)

	if PostLoadFunc then
		PostLoadFunc(self, controller, menu)
	end

	return self
end
