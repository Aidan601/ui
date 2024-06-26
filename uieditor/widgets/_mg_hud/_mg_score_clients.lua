CoD._mg_score_clients = InheritFrom(LUI.UIElement)
CoD._mg_score_clients.new = function(menu, controller)
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc(self, controller)
	end

	self:setUseStencil(false)
	self:setClass(CoD._mg_score_clients)
	self.id = "_mg_score_clients"
	self.soundSet = "HUD"
	self:setLeftRight(true, false, 0, 1280)
	self:setTopBottom(true, false, 0, 720)
	self.anyChildUsesUpdateState = true

	DataSources.ZMPlayerList = {
		getModel = function(f1_arg0)
			return Engine.CreateModel(Engine.GetModelForController(f1_arg0), "PlayerList")
		end
	}

	self.OtherPlayerBG = LUI.UIImage.new()
	self.OtherPlayerBG:setLeftRight(true, false, 2, 35)
	self.OtherPlayerBG:setTopBottom(false, true, -168, -134)
	self.OtherPlayerBG:setScale(0.87)
	self.OtherPlayerBG:setImage(RegisterImage("blacktransparent"))
	self.OtherPlayerBG:linkToElementModel(self, "zombiePlayerIcon", true, function(model)
		local zombiePlayerIcon = Engine.GetModelValue(model)
		if zombiePlayerIcon then
			self.OtherPlayerBG:setImage(RegisterImage(zombiePlayerIcon))
		end
	end)
	self:addElement(self.OtherPlayerBG)

	local ScoreText = LUI.UIText.new()
	ScoreText:setLeftRight(true, false, 40, 130)
	ScoreText:setTopBottom(false, true, -160, -140)
	ScoreText:setTTF("fonts/tf2build.ttf")
	ScoreText:setAlignment(LUI.Alignment.Left)
	ScoreText:linkToElementModel(self, "playerScore", true, function(ModelRef)
		if Engine.GetModelValue(ModelRef) then
			ScoreText:setText(Engine.Localize('$' .. Engine.GetModelValue(ModelRef)))
		end
	end)
	self:addElement(ScoreText)
	self.ScoreText = ScoreText

	local PlayerName = LUI.UIText.new()
	PlayerName:setLeftRight(true, false, 1, 46)
	PlayerName:setTopBottom(false, true, -209, -189)
	PlayerName:setTTF("fonts/Bebas-Regular.ttf")
	PlayerName:linkToElementModel(self, "playerName", true, function(ModelRef)
		if Engine.GetModelValue(ModelRef) then
			PlayerName:setText(Engine.Localize(Engine.GetModelValue(ModelRef)))
		end
	end)
	--self:addElement( PlayerName )
	self.PlayerName = PlayerName

	local PlayerRank = LUI.UIText.new()
	PlayerRank:setLeftRight(true, false, 1 + 100, 46 + 100)
	PlayerRank:setTopBottom(false, true, -209, -189)
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
				self:setupElementClipCounter(4)

				self.ScoreText:completeAnimation()
				self.ScoreText:setAlpha(0)
				self.clipFinished(self.ScoreText, {})

				self.OtherPlayerBG:completeAnimation()
				self.OtherPlayerBG:setAlpha(0)
				self.clipFinished(self.OtherPlayerBG, {})

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha(0)
				self.clipFinished(self.PlayerName, {})

				self.PlayerRank:completeAnimation()
				self.PlayerRank:setAlpha(0)
				self.clipFinished(self.PlayerRank, {})
			end
		},
		Visible =
		{
			DefaultClip = function()
				self:setupElementClipCounter(4)

				self.ScoreText:completeAnimation()
				self.ScoreText:setAlpha(.75)
				self.clipFinished(self.ScoreText, {})

				self.OtherPlayerBG:completeAnimation()
				self.OtherPlayerBG:setAlpha(1)
				self.clipFinished(self.OtherPlayerBG, {})

				self.PlayerName:completeAnimation()
				self.PlayerName:setAlpha(1)
				self.clipFinished(self.PlayerName, {})

				self.PlayerRank:completeAnimation()
				self.PlayerRank:setAlpha(1)
				self.clipFinished(self.PlayerRank, {})
			end
		}
	}

	self.ScoreText:linkToElementModel(self, "clientNum", true, function(ModelRef)
		local ModelValue = Engine.GetModelValue(ModelRef)
		if ModelValue then
			--self.PlayerName:setRGB(ZombieClientScoreboardColor( ModelValue ) )
			--self.ScoreText:setRGB(ZombieClientScoreboardColor( ModelValue ) )
			--self.OtherPlayerBG:setRGB(ZombieClientScoreboardColor( ModelValue ) )
			--self.PlayerRank:setRGB(ZombieClientScoreboardColor( ModelValue ) )
		end
	end)

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

	self:linkToElementModel(self, "position", true, function(ModelRef)
		menu:updateElementState(self,
			{
				name = "model_validation",
				menu = menu,
				modelValue = Engine.GetModelValue(ModelRef),
				modelName = "position"
			})
	end)

	LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
		element.ScoreText:close()
		element.OtherPlayerBG:close()
		element.PlayerName:close()
		element.PlayerRank:close()
	end)

	if PostLoadFunc then
		PostLoadFunc(self, controller, menu)
	end

	return self
end
