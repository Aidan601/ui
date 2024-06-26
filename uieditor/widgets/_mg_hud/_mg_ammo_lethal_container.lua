CoD._mg_ammo_lethal_container = InheritFrom(LUI.UIElement)
CoD._mg_ammo_lethal_container.new = function(menu, controller)
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc(self, controller)
	end

	self:setUseStencil(false)
	self:setClass(CoD._mg_ammo_lethal_container)
	self.id = "_mg_ammo_lethal_container"
	self.soundSet = "HUD"
	self:setLeftRight(true, false, 0, 1280)
	self:setTopBottom(true, false, 0, 720)
	self.anyChildUsesUpdateState = true

	local frag_grenade = LUI.UIImage.new()
	frag_grenade:setLeftRight(false, true, -216.5+15-1, -190.5+15+1)
	frag_grenade:setTopBottom(false, true, -55+2-1, -29.5+2+1)
	frag_grenade:setImage(RegisterImage("grenade"))
	self:addElement(frag_grenade)
	self.frag_grenade = frag_grenade

	local no_gren_indicatorfrag = LUI.UIImage.new()
	no_gren_indicatorfrag:setLeftRight(true, false, 960 + 28, 960 + 22 + 28)
	no_gren_indicatorfrag:setTopBottom(true, false, 662, 662 + 22)
	no_gren_indicatorfrag:setImage(RegisterImage("_mg_no_gren_indicator"))
	no_gren_indicatorfrag:setScale(0.2)
	--self:addElement( no_gren_indicatorfrag )
	self.no_gren_indicatorfrag = no_gren_indicatorfrag

	local frag_count_bg = LUI.UIText.new()
	frag_count_bg:setLeftRight(false, true, -182.5+3+15, -166+3+15)
	frag_count_bg:setTopBottom(false, true, -60+6, -20+6)
	frag_count_bg:setTTF("fonts/TF2.ttf")
	frag_count_bg:setAlignment(LUI.Alignment.Center)
	frag_count_bg:setText("")
	frag_count_bg:setRGB(0, 0, 0)
	self:addElement(frag_count_bg)
	self.frag_count = frag_count_bg

	frag_count_bg:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "CurrentPrimaryOffhand.primaryOffhandCount"),
		function(ModelRef)
			local modelValue = Engine.GetModelValue(ModelRef)
			if modelValue then
				frag_count_bg:setText(Engine.Localize(modelValue))
			end
		end)

	local frag_count = LUI.UIText.new()
	frag_count:setLeftRight(false, true, -182.5+2+15, -167+2+15)
	frag_count:setTopBottom(false, true, -61+6, -21+6)
	frag_count:setTTF("fonts/TF2.ttf")
	frag_count:setAlignment(LUI.Alignment.Center)
	frag_count:setText("")
	frag_count:setRGB(0.9254901960784314, 0.8901960784313725, 0.796078431372549)
	self:addElement(frag_count)
	self.frag_count = frag_count

	frag_count:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "CurrentPrimaryOffhand.primaryOffhandCount"),
		function(ModelRef)
			local modelValue = Engine.GetModelValue(ModelRef)
			if modelValue then
				frag_count:setText(Engine.Localize(modelValue))
			end
		end)

	self.clipsPerState =
	{
		DefaultState =
		{
			DefaultClip = function()
				self:setupElementClipCounter(3)

				frag_grenade:completeAnimation()
				self.frag_grenade:setAlpha(1)
				self.clipFinished(frag_grenade, {})

				no_gren_indicatorfrag:completeAnimation()
				no_gren_indicatorfrag:setAlpha(0)
				self.clipFinished(no_gren_indicatorfrag, {})

				frag_count:completeAnimation()
				frag_count:setAlpha(1)
				self.clipFinished(frag_count, {})
			end
		},
		Invisible =
		{
			DefaultClip = function()
				self:setupElementClipCounter(3)

				frag_grenade:completeAnimation()
				self.frag_grenade:setAlpha(0.5)
				self.clipFinished(frag_grenade, {})

				no_gren_indicatorfrag:completeAnimation()
				no_gren_indicatorfrag:setAlpha(1)
				self.clipFinished(no_gren_indicatorfrag, {})

				frag_count:completeAnimation()
				frag_count:setAlpha(1)
				self.clipFinished(frag_count, {})
			end
		}
	}
	self:mergeStateConditions(
		{
			{
				stateName = "Invisible",
				condition = function(menu, element, event)
					return not IsModelValueGreaterThan(controller, "currentPrimaryOffhand.primaryOffhandCount", 0)
				end
			}
		})
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "currentPrimaryOffhand.primaryOffhandCount"),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "currentPrimaryOffhand.primaryOffhandCount"
				})
		end)

	LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
		element.frag_grenade:close()
		element.no_gren_indicatorfrag:close()
		element.frag_count:close()
	end)

	return self
end
