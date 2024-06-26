CoD._mg_round_counter = InheritFrom(LUI.UIElement)
function CoD._mg_round_counter.new(menu, controller)
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc(menu, controller)
	end

	self:setClass(CoD._mg_round_counter)
	self.id = "_mg_round_counter"
	self.soundSet = "default"
	self:setLeftRight(true, false, 0, 1280)
	self:setTopBottom(true, false, 0, 720)

	local round_text_bg = LUI.UIText.new()
	round_text_bg:setLeftRight(false, true, -94.5, -27)
	round_text_bg:setTopBottom(true, false, 41.5, 88)
	round_text_bg:setAlignment(LUI.Alignment.Center)
	round_text_bg:setTTF("fonts/tf2build.ttf")
	round_text_bg:setAlpha(1)
	round_text_bg:setRGB(0, 0, 0)
	self:addElement(round_text_bg)
	self.round_text_bg = round_text_bg
	round_text_bg:subscribeToGlobalModel(controller, "GameScore", nil, function(ModelRef)
		round_text_bg:setModel(ModelRef, controller)
	end)

	round_text_bg:linkToElementModel(round_text_bg, "roundsPlayed", true, function(ModelRef)
		if Engine.GetModelValue(ModelRef) then
			local round = Engine.GetModelValue(ModelRef)
			round = round - 1
			if round < 0 then
				round = 0
			end
			round_text_bg:setText(round)
		end
	end)


	local round_text = LUI.UIText.new()
	round_text:setLeftRight(false, true, -94.5, -30)
	round_text:setTopBottom(true, false, 40, 86.5)
	round_text:setAlignment(LUI.Alignment.Center)
	round_text:setTTF("fonts/tf2build.ttf")
	round_text:setAlpha(1)
	round_text:setRGB(0.9254901960784314, 0.8901960784313725, 0.796078431372549)
	self:addElement(round_text)
	self.round_text = round_text
	round_text:subscribeToGlobalModel(controller, "GameScore", nil, function(ModelRef)
		round_text:setModel(ModelRef, controller)
	end)

	round_text:linkToElementModel(round_text, "roundsPlayed", true, function(ModelRef)
		if Engine.GetModelValue(ModelRef) then
			local round = Engine.GetModelValue(ModelRef)
			round = round - 1
			if round < 0 then
				round = 0
			end
			round_text:setText(round)
		end
	end)

	local roundname = LUI.UIText.new()
	roundname:setLeftRight(false, true, -72.6666666666667, -24.0000000000001)
	roundname:setTopBottom(true, false, 78.6666666666667, 104.666666666667)
	roundname:setTTF("fonts/Bebas-Regular.ttf")
	roundname:setRGB(.62, .10, .06)
	roundname:setText("ROUND")
	roundname:setAlpha(1)
	--self:addElement( roundname )
	self.roundname = roundname

	self.clipsPerState =
	{
		DefaultState =
		{
			DefaultClip = function()
				self:setupElementClipCounter(3)

				self.round_text_bg:completeAnimation()
				self.round_text_bg:beginAnimation("keyframe", 250, false, false, CoD.TweenType.Linear)
				self.round_text_bg:setAlpha(1)
				self.clipFinished(self.round_text_bg, {})

				self.round_text:completeAnimation()
				self.round_text:beginAnimation("keyframe", 250, false, false, CoD.TweenType.Linear)
				self.round_text:setAlpha(1)
				self.clipFinished(self.round_text, {})

				self.roundname:completeAnimation()
				self.roundname:beginAnimation("keyframe", 250, false, false, CoD.TweenType.Linear)
				self.roundname:setAlpha(1)
				self.clipFinished(self.roundname, {})
			end
		},
		Invisible =
		{
			DefaultClip = function()
				self:setupElementClipCounter(3)

				self.round_text_bg:completeAnimation()
				self.round_text_bg:beginAnimation("keyframe", 250, false, false, CoD.TweenType.Linear)
				self.round_text_bg:setAlpha(0)
				self.clipFinished(self.round_text_bg, {})

				self.round_text:completeAnimation()
				self.round_text:beginAnimation("keyframe", 250, false, false, CoD.TweenType.Linear)
				self.round_text:setAlpha(0)
				self.clipFinished(self.round_text, {})

				self.roundname:completeAnimation()
				self.roundname:beginAnimation("keyframe", 250, false, false, CoD.TweenType.Linear)
				self.roundname:setAlpha(0)
				self.clipFinished(self.roundname, {})
			end
		}
	}

	self:mergeStateConditions(
		{
			{
				stateName = "Invisible",
				condition = function(menu, element, event)
					local result = IsModelValueTrue(controller, "hudItems.playerSpawned")
					if result then
						if Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_HUD_VISIBLE) and
							Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_HUD_HARDCORE) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_GAME_ENDED) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_DEMO_CAMERA_MODE_MOVIECAM) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_DEMO_ALL_GAME_HUD_HIDDEN) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IN_KILLCAM) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IS_FLASH_BANGED) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_UI_ACTIVE) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IS_SCOPED) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IN_VEHICLE) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IN_GUIDED_MISSILE) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_SCOREBOARD_OPEN) and
							not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_IN_REMOTE_KILLSTREAK_STATIC) then
							result = Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_EMP_ACTIVE)
						else
							result = true
						end
					end
					return result
				end
			}
		})

	self:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller), "hudItems.playerSpawned"),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "hudItems.playerSpawned"
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
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE), function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_WEAPON_HUD_VISIBLE
				})
		end)
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "UIVisibilityBit." .. Enum.UIVisibilityBit
			.BIT_HUD_HARDCORE), function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_HUD_HARDCORE
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
			"UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "UIVisibilityBit." .. Enum.UIVisibilityBit.BIT_IN_KILLCAM
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


	LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
		element.round_text:close()
		element.round_text_bg:close()
		element.roundname:close()
	end)

	return self
end
