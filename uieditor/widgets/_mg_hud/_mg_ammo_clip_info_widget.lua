CoD._mg_ammo_clip_info_widget = InheritFrom(LUI.UIElement)
function CoD._mg_ammo_clip_info_widget.new(menu, controller)
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc(menu, controller)
	end

	self:setClass(CoD._mg_ammo_widget)
	self.id = "_mg_ammo_widget"
	self.soundSet = "default"
	self:setLeftRight(true, false, 0, 1280)
	self:setTopBottom(true, false, 0, 720)
	self.anyChildUsesUpdateState = true

	local weaponname_bg = LUI.UIText.new()
	weaponname_bg:setLeftRight(false, true, -600+1, -10+1)
	weaponname_bg:setTopBottom(false, true, -109+3.5, -82+3.5)
	weaponname_bg:setAlignment(LUI.Alignment.Right)
	weaponname_bg:setTTF("fonts/TF2.ttf")
	weaponname_bg:setText("")
	weaponname_bg:setAlpha(1)
	weaponname_bg:setRGB(0, 0, 0)
	self:addElement(weaponname_bg)
	weaponname_bg:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller), "CurrentWeapon.weaponname"),
		function(ModelRef)
			local modelValue = Engine.GetModelValue(ModelRef)
			if modelValue then
				weaponname_bg:setText(Engine.Localize(modelValue))
			end
		end)

	local weaponname = LUI.UIText.new()
	weaponname:setLeftRight(false, true, -600, -11)
	weaponname:setTopBottom(false, true, -110+3, -83+3)
	weaponname:setAlignment(LUI.Alignment.Right)
	weaponname:setTTF("fonts/TF2.ttf")
	weaponname:setText("")
	weaponname:setAlpha(1)
	weaponname:setRGB(0.9254901960784314, 0.8901960784313725, 0.796078431372549)
	self:addElement(weaponname)
	self.weaponname = weaponname
	weaponname:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller), "CurrentWeapon.weaponname"),
		function(ModelRef)
			local modelValue = Engine.GetModelValue(ModelRef)
			if modelValue then
				weaponname:setText(Engine.Localize(modelValue))
			end
		end)

	local ammo_clip_bg = LUI.UIText.new()
	ammo_clip_bg:setLeftRight(false, true, -90.5, -63.5+5)
	ammo_clip_bg:setTopBottom(false, true, -73-3, -13-3)
	ammo_clip_bg:setTTF("fonts/tf2build.ttf")
	ammo_clip_bg:setAlpha(1)
	ammo_clip_bg:setRGB(0, 0, 0)
	self:addElement(ammo_clip_bg)
	self.ammo_clip_bg = ammo_clip_bg

	local ammo_clip = LUI.UIText.new()
	ammo_clip:setLeftRight(false, true, -90.5, -64.5+5)
	ammo_clip:setTopBottom(false, true, -74-3, -14.5-3)
	ammo_clip:setTTF("fonts/tf2build.ttf")
	ammo_clip:setText("")
	ammo_clip:setAlpha(1)
	ammo_clip:setRGB(0.9254901960784314, 0.8901960784313725, 0.796078431372549)
	self:addElement(ammo_clip)
	self.Clip = ammo_clip

	ammo_clip:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller), "CurrentWeapon.ammoInClip"),
		function(ModelRef)
			local modelValue = Engine.GetModelValue(ModelRef)
			if modelValue then
				ammo_clip:setText(Engine.Localize(modelValue))
				ammo_clip_bg:setText(Engine.Localize(modelValue))
			end
		end)

	local dual_clip = LUI.UIText.new()
	dual_clip:setLeftRight(false, true, -203.3, -171.3)
	dual_clip:setTopBottom(true, false, 657, 682.6)
	dual_clip:setTTF("fonts/Bebas-Regular.ttf")
	dual_clip:setText("")
	dual_clip:setAlpha(1)
	--self:addElement( dual_clip )
	self.ClipDual = dual_clip

	dual_clip:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "CurrentWeapon.ammoInDWClip"), function(ModelRef)
			local modelValue = Engine.GetModelValue(ModelRef)
			if modelValue ~= nil and modelValue > -1 then
				dual_clip:setAlpha(1)
				dual_clip:setText(Engine.Localize(modelValue))
			else
				dual_clip:setAlpha(0)
			end
		end)

	local ammo_reserve_bg = LUI.UIText.new()
	ammo_reserve_bg:setLeftRight(false, true, -60.5+3, -26+5)
	ammo_reserve_bg:setTopBottom(false, true, -60+5, -28.5+5)
	ammo_reserve_bg:setTTF("fonts/TF2.ttf")
	ammo_reserve_bg:setText("")
	ammo_reserve_bg:setAlignment(LUI.Alignment.Left)
	ammo_reserve_bg:setAlpha(1)
	ammo_reserve_bg:setRGB(0, 0, 0)
	self:addElement(ammo_reserve_bg)
	self.ammo_reserve_bg = ammo_reserve_bg

	ammo_reserve_bg:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "CurrentWeapon.ammoStock"), function(ModelRef)
			local modelValue = Engine.GetModelValue(ModelRef)
			if modelValue then
				ammo_reserve_bg:setText(Engine.Localize(modelValue))
			end
		end)

	local ammo_reserve = LUI.UIText.new()
	ammo_reserve:setLeftRight(false, true, -60.5+2, -27+5)
	ammo_reserve:setTopBottom(false, true, -61+5, -29.5+5)
	ammo_reserve:setTTF("fonts/TF2.ttf")
	ammo_reserve:setText("")
	ammo_reserve:setAlignment(LUI.Alignment.Left)
	ammo_reserve:setAlpha(1)
	ammo_reserve:setRGB(0.9254901960784314, 0.8901960784313725, 0.796078431372549)
	self:addElement(ammo_reserve)
	self.TotalAmmo = ammo_reserve

	ammo_reserve:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "CurrentWeapon.ammoStock"), function(ModelRef)
			local modelValue = Engine.GetModelValue(ModelRef)
			if modelValue then
				ammo_reserve:setText(Engine.Localize(modelValue))
			end
		end)

	local ammo_divide = LUI.UIText.new()
	ammo_divide:setLeftRight(false, true, -124.6, -116)
	ammo_divide:setTopBottom(true, false, 661.3, 682)
	ammo_divide:setTTF("fonts/Bebas-Regular.ttf")
	ammo_divide:setText("/")
	ammo_divide:setAlpha(1)
	--self:addElement( ammo_divide )
	self.ammo_divide = ammo_divide

	local dual_divide = LUI.UIText.new()
	dual_divide:setLeftRight(true, false, 1110, 1110 + 50)
	dual_divide:setTopBottom(true, false, 658, 658 + 25)
	dual_divide:setTTF("fonts/Bebas-Regular.ttf")
	dual_divide:setText("|")
	dual_divide:setAlpha(1)
	--self:addElement( dual_divide )
	self.dual_divide = dual_divide

	local CustomSpecialMeter = LUI.UIImage.new()
	CustomSpecialMeter:setLeftRight(false, true, -71, -26)
	CustomSpecialMeter:setTopBottom(false, true, -82, -37)
	CustomSpecialMeter:setRGB(0, .61, 1)
	CustomSpecialMeter:setAlpha(1)
	CustomSpecialMeter:setImage(RegisterImage("_mg_special_bar"))
	CustomSpecialMeter:setMaterial(RegisterMaterial("hud_objective_circle_meter"))
	CustomSpecialMeter:setShaderVector(1, 0, 0, 0, 0)
	CustomSpecialMeter:setShaderVector(2, 1, 0, 0, 0)
	CustomSpecialMeter:setShaderVector(3, 0, 0, 0, 0)

	CustomSpecialMeter:subscribeToGlobalModel(controller, "PerController", "zmhud.swordEnergy", function(ModelRef)
		local modelValue = Engine.GetModelValue(ModelRef)
		if modelValue then
			local shaderW = CoD.GetVectorComponentFromString(modelValue, 1)
			local shaderX = CoD.GetVectorComponentFromString(modelValue, 2)
			local shaderY = CoD.GetVectorComponentFromString(modelValue, 3)
			local shaderZ = CoD.GetVectorComponentFromString(modelValue, 4)
			CustomSpecialMeter:setShaderVector(0, AdjustStartEnd(0, 1, shaderW, shaderX, shaderY, shaderZ))
		end
	end)
	--self:addElement( CustomSpecialMeter )
	self.Special = CustomSpecialMeter

	local CustomSpecialMeterBacking = LUI.UIImage.new()
	CustomSpecialMeterBacking:setLeftRight(false, true, -72.5, -25)
	CustomSpecialMeterBacking:setTopBottom(false, true, -83, -35.5)
	CustomSpecialMeterBacking:setImage(RegisterImage("_mg_special_bar_backing"))
	CustomSpecialMeterBacking:setAlpha(1)
	--self:addElement( CustomSpecialMeterBacking )
	self.CustomSpecialMeterBacking = CustomSpecialMeterBacking

	self.clipsPerState =
	{
		DefaultState =
		{
			DefaultClip = function()
				self:setupElementClipCounter(8)

				self.weaponname:completeAnimation()
				self.weaponname:setAlpha(1)
				self.clipFinished(self.weaponname, {})

				self.Clip:completeAnimation()
				self.Clip:setAlpha(1)
				self.clipFinished(self.Clip, {})

				self.ammo_clip_bg:completeAnimation()
				self.ammo_clip_bg:setAlpha(1)
				self.clipFinished(self.ammo_clip_bg, {})

				self.ClipDual:completeAnimation()
				self.ClipDual:setAlpha(0)
				self.clipFinished(self.ClipDual, {})

				self.ammo_divide:completeAnimation()
				self.ammo_divide:setAlpha(1)
				self.clipFinished(self.ammo_divide, {})

				self.dual_divide:completeAnimation()
				self.dual_divide:setAlpha(0)
				self.clipFinished(self.dual_divide, {})

				self.TotalAmmo:completeAnimation()
				self.TotalAmmo:setAlpha(1)
				self.clipFinished(self.TotalAmmo, {})

				self.ammo_reserve_bg:completeAnimation()
				self.ammo_reserve_bg:setAlpha(1)
				self.clipFinished(self.ammo_reserve_bg, {})

				self.Special:completeAnimation()
				self.Special:setAlpha(1)
				self.clipFinished(self.Special, {})

				self.CustomSpecialMeterBacking:completeAnimation()
				self.CustomSpecialMeterBacking:setAlpha(1)
				self.clipFinished(self.CustomSpecialMeterBacking, {})
			end
		},
		ElectricSword =
		{
			DefaultClip = function()
				self:setupElementClipCounter(8)

				self.weaponname:completeAnimation()
				self.weaponname:setAlpha(1)
				self.clipFinished(self.weaponname, {})

				self.Clip:completeAnimation()
				self.Clip:setAlpha(0)
				self.clipFinished(self.Clip, {})

				self.ammo_clip_bg:completeAnimation()
				self.ammo_clip_bg:setAlpha(0)
				self.clipFinished(self.ammo_clip_bg, {})

				self.ClipDual:completeAnimation()
				self.ClipDual:setAlpha(0)
				self.clipFinished(self.ClipDual, {})

				self.ammo_divide:completeAnimation()
				self.ammo_divide:setAlpha(0)
				self.clipFinished(self.ammo_divide, {})

				self.dual_divide:completeAnimation()
				self.dual_divide:setAlpha(0)
				self.clipFinished(self.dual_divide, {})

				self.TotalAmmo:completeAnimation()
				self.TotalAmmo:setAlpha(1)
				self.clipFinished(self.TotalAmmo, {})

				self.ammo_reserve_bg:completeAnimation()
				self.ammo_reserve_bg:setAlpha(1)
				self.clipFinished(self.ammo_reserve_bg, {})

				self.Special:completeAnimation()
				self.Special:setAlpha(1)
				self.clipFinished(self.Special, {})

				self.CustomSpecialMeterBacking:completeAnimation()
				self.CustomSpecialMeterBacking:setAlpha(1)
				self.clipFinished(self.CustomSpecialMeterBacking, {})
			end
		},
		Sword =
		{
			DefaultClip = function()
				self:setupElementClipCounter(8)

				self.weaponname:completeAnimation()
				self.weaponname:setAlpha(1)
				self.clipFinished(self.weaponname, {})

				self.Clip:completeAnimation()
				self.Clip:setAlpha(0)
				self.clipFinished(self.Clip, {})

				self.ammo_clip_bg:completeAnimation()
				self.ammo_clip_bg:setAlpha(0)
				self.clipFinished(self.ammo_clip_bg, {})

				self.ClipDual:completeAnimation()
				self.ClipDual:setAlpha(0)
				self.clipFinished(self.ClipDual, {})

				self.ammo_divide:completeAnimation()
				self.ammo_divide:setAlpha(0)
				self.clipFinished(self.ammo_divide, {})

				self.dual_divide:completeAnimation()
				self.dual_divide:setAlpha(0)
				self.clipFinished(self.dual_divide, {})

				self.TotalAmmo:completeAnimation()
				self.TotalAmmo:setAlpha(1)
				self.clipFinished(self.TotalAmmo, {})

				self.ammo_reserve_bg:completeAnimation()
				self.ammo_reserve_bg:setAlpha(1)
				self.clipFinished(self.ammo_reserve_bg, {})

				self.Special:completeAnimation()
				self.Special:setAlpha(1)
				self.clipFinished(self.Special, {})

				self.CustomSpecialMeterBacking:completeAnimation()
				self.CustomSpecialMeterBacking:setAlpha(1)
				self.clipFinished(self.CustomSpecialMeterBacking, {})
			end
		},
		HeroWeapon =
		{
			DefaultClip = function()
				self:setupElementClipCounter(8)

				self.weaponname:completeAnimation()
				self.weaponname:setAlpha(1)
				self.clipFinished(self.weaponname, {})

				self.Clip:completeAnimation()
				self.Clip:setAlpha(0)
				self.clipFinished(self.Clip, {})

				self.ammo_clip_bg:completeAnimation()
				self.ammo_clip_bg:setAlpha(0)
				self.clipFinished(self.ammo_clip_bg, {})

				self.ClipDual:completeAnimation()
				self.ClipDual:setAlpha(0)
				self.clipFinished(self.ClipDual, {})

				self.ammo_divide:completeAnimation()
				self.ammo_divide:setAlpha(0)
				self.clipFinished(self.ammo_divide, {})

				self.dual_divide:completeAnimation()
				self.dual_divide:setAlpha(0)
				self.clipFinished(self.dual_divide, {})

				self.TotalAmmo:completeAnimation()
				self.TotalAmmo:setAlpha(1)
				self.clipFinished(self.TotalAmmo, {})

				self.ammo_reserve_bg:completeAnimation()
				self.ammo_reserve_bg:setAlpha(1)
				self.clipFinished(self.ammo_reserve_bg, {})

				self.Special:completeAnimation()
				self.Special:setAlpha(1)
				self.clipFinished(self.Special, {})

				self.CustomSpecialMeterBacking:completeAnimation()
				self.CustomSpecialMeterBacking:setAlpha(1)
				self.clipFinished(self.CustomSpecialMeterBacking, {})
			end
		},
		WeaponDoesNotUseAmmo =
		{
			DefaultClip = function()
				self:setupElementClipCounter(8)

				self.weaponname:completeAnimation()
				self.weaponname:setAlpha(1)
				self.clipFinished(self.weaponname, {})

				self.Clip:completeAnimation()
				self.Clip:setAlpha(0)
				self.clipFinished(self.Clip, {})

				self.ammo_clip_bg:completeAnimation()
				self.ammo_clip_bg:setAlpha(0)
				self.clipFinished(self.ammo_clip_bg, {})

				self.ClipDual:completeAnimation()
				self.ClipDual:setAlpha(0)
				self.clipFinished(self.ClipDual, {})

				self.ammo_divide:completeAnimation()
				self.ammo_divide:setAlpha(0)
				self.clipFinished(self.ammo_divide, {})

				self.dual_divide:completeAnimation()
				self.dual_divide:setAlpha(0)
				self.clipFinished(self.dual_divide, {})

				self.TotalAmmo:completeAnimation()
				self.TotalAmmo:setAlpha(0)
				self.clipFinished(self.TotalAmmo, {})

				self.ammo_reserve_bg:completeAnimation()
				self.ammo_reserve_bg:setAlpha(0)
				self.clipFinished(self.ammo_reserve_bg, {})

				self.Special:completeAnimation()
				self.Special:setAlpha(1)
				self.clipFinished(self.Special, {})

				self.CustomSpecialMeterBacking:completeAnimation()
				self.CustomSpecialMeterBacking:setAlpha(1)
				self.clipFinished(self.CustomSpecialMeterBacking, {})
			end
		},
		WeaponDual =
		{
			DefaultClip = function()
				self:setupElementClipCounter(8)

				self.weaponname:completeAnimation()
				self.weaponname:setAlpha(1)
				self.clipFinished(self.weaponname, {})

				self.Clip:completeAnimation()
				self.Clip:setAlpha(1)
				self.clipFinished(self.Clip, {})

				self.ammo_clip_bg:completeAnimation()
				self.ammo_clip_bg:setAlpha(1)
				self.clipFinished(self.ammo_clip_bg, {})

				self.ClipDual:completeAnimation()
				self.ClipDual:setAlpha(1)
				self.clipFinished(self.ClipDual, {})

				self.ammo_divide:completeAnimation()
				self.ammo_divide:setAlpha(1)
				self.clipFinished(self.ammo_divide, {})

				self.dual_divide:completeAnimation()
				self.dual_divide:setAlpha(1)
				self.clipFinished(self.dual_divide, {})

				self.TotalAmmo:completeAnimation()
				self.TotalAmmo:setAlpha(1)
				self.clipFinished(self.TotalAmmo, {})

				self.ammo_reserve_bg:completeAnimation()
				self.ammo_reserve_bg:setAlpha(1)
				self.clipFinished(self.ammo_reserve_bg, {})

				self.Special:completeAnimation()
				self.Special:setAlpha(1)
				self.clipFinished(self.Special, {})

				self.CustomSpecialMeterBacking:completeAnimation()
				self.CustomSpecialMeterBacking:setAlpha(1)
				self.clipFinished(self.CustomSpecialMeterBacking, {})
			end
		},
		Weapon =
		{
			DefaultClip = function()
				self:setupElementClipCounter(8)

				self.weaponname:completeAnimation()
				self.weaponname:setAlpha(1)
				self.clipFinished(self.weaponname, {})

				self.Clip:completeAnimation()
				self.Clip:setAlpha(1)
				self.clipFinished(self.Clip, {})

				self.ammo_clip_bg:completeAnimation()
				self.ammo_clip_bg:setAlpha(1)
				self.clipFinished(self.ammo_clip_bg, {})

				self.ClipDual:completeAnimation()
				self.ClipDual:setAlpha(0)
				self.clipFinished(self.ClipDual, {})

				self.ammo_divide:completeAnimation()
				self.ammo_divide:setAlpha(1)
				self.clipFinished(self.ammo_divide, {})

				self.dual_divide:completeAnimation()
				self.dual_divide:setAlpha(0)
				self.clipFinished(self.dual_divide, {})

				self.TotalAmmo:completeAnimation()
				self.TotalAmmo:setAlpha(1)
				self.clipFinished(self.TotalAmmo, {})

				self.ammo_reserve_bg:completeAnimation()
				self.ammo_reserve_bg:setAlpha(1)
				self.clipFinished(self.ammo_reserve_bg, {})

				self.Special:completeAnimation()
				self.Special:setAlpha(1)
				self.clipFinished(self.Special, {})

				self.CustomSpecialMeterBacking:completeAnimation()
				self.CustomSpecialMeterBacking:setAlpha(1)
				self.clipFinished(self.CustomSpecialMeterBacking, {})
			end
		}
	}
	self:mergeStateConditions(
		{
			{
				stateName = "ElectricSword",
				condition = function(menu, element, event)
					if ModelValueStartsWith(controller, "currentWeapon.viewmodelWeaponName", "glaive_apothicon_") and
						IsModelValueGreaterThanOrEqualTo(controller, "zmhud.swordState", 5) then
						return not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_GAME_ENDED)
					end
					return false
				end
			},
			{
				stateName = "Sword",
				condition = function(menu, element, event)
					if ModelValueStartsWith(controller, "currentWeapon.viewmodelWeaponName", "glaive_") then
						return not Engine.IsVisibilityBitSet(controller, Enum.UIVisibilityBit.BIT_GAME_ENDED)
					end
					return false
				end
			},
			{
				stateName = "HeroWeapon",
				condition = function(menu, element, event)
					return IsModelValueEqualTo(controller, "currentWeapon.viewmodelWeaponName", "zod_riotshield_zm")
				end
			},
			{
				stateName = "WeaponDoesNotUseAmmo",
				condition = function(menu, element, event)
					return not WeaponUsesAmmo(controller)
				end
			},
			{
				stateName = "WeaponDual",
				condition = function(menu, element, event)
					if WeaponUsesAmmo(controller) then
						return IsModelValueGreaterThanOrEqualTo(controller, "currentWeapon.ammoInDWClip", 0)
					end
					return false
				end
			},
			{
				stateName = "Weapon",
				condition = function(menu, element, event)
					return WeaponUsesAmmo(controller)
				end
			}
		})
	self:subscribeToModel(
		Engine.GetModel(Engine.GetModelForController(controller), "currentWeapon.viewmodelWeaponName"),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "currentWeapon.viewmodelWeaponName"
				})
		end)
	self:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller), "zmhud.swordState"),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "zmhud.swordState"
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
	self:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller), "currentWeapon.weapon"),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "currentWeapon.weapon"
				})
		end)
	self:subscribeToModel(Engine.GetModel(Engine.GetModelForController(controller), "currentWeapon.ammoInDWClip"),
		function(modelRef)
			menu:updateElementState(self,
				{
					name = "model_validation",
					menu = menu,
					modelValue = Engine.GetModelValue(modelRef),
					modelName = "currentWeapon.ammoInDWClip"
				})
		end)

	LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
		element.weaponname:close()
		element.Clip:close()
		element.ClipDual:close()
		element.TotalAmmo:close()
		element.ammo_divide:close()
		element.Special:close()
		element.CustomSpecialMeterBacking:close()
	end)

	return self
end
