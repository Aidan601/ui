require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_BBGumMeterWidget" )
require( "ui.uieditor.widgets._mg_hud._mg_ammo_clip_info_widget" )
require( "ui.uieditor.widgets._mg_hud._mg_ammo_equip_container" )

local PreLoadFunc = function ( self, controller )
	Engine.CreateModel( Engine.GetModelForController( controller ), "currentWeapon.aatIcon" )
end

local PostLoadFunc = function ( self, controller, menu )
	if not Engine.GetModelValue( Engine.CreateModel( Engine.GetModelForController( controller ), "currentWeapon.aatIcon" ) ) then
		self.aat_type:setImage( RegisterImage( "blacktransparent" ) )
	end
end

CoD._mg_ammo_widget = InheritFrom( LUI.UIElement )
CoD._mg_ammo_widget.new = function ( menu, controller )

	local self = LUI.UIElement.new()
	
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	self:setUseStencil( false )
	self:setClass( CoD._mg_ammo_widget )
	self.id = "_mg_ammo_widget"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	local ZmAmmoEquipContainer0 = CoD._mg_ammo_equip_container.new( menu, controller )
	ZmAmmoEquipContainer0:setLeftRight( true, false, 0, 1280 )
	ZmAmmoEquipContainer0:setTopBottom( true, false, 0, 720 )
	self:addElement( ZmAmmoEquipContainer0 )
	self.ZmAmmoEquipContainer0 = ZmAmmoEquipContainer0
	
	local ZmAmmoClipInfo0 = CoD._mg_ammo_clip_info_widget.new( menu, controller )
	ZmAmmoClipInfo0:setLeftRight( true, true, 0, 0 )
	ZmAmmoClipInfo0:setTopBottom( true, true, 0, 0 )
	self:addElement( ZmAmmoClipInfo0 )
	self.ZmAmmoClipInfo0 = ZmAmmoClipInfo0

	local aat_type_bg = LUI.UIImage.new()
	aat_type_bg:setLeftRight(false, true, -234.5+145, -147+145)
	aat_type_bg:setTopBottom(false, true, -84-120, 4.5-90)
	aat_type_bg:setImage(RegisterImage("red_grenade_bg"))
	aat_type_bg:setAlpha(1)
	--self:addElement(aat_type_bg)
	self.aat_type_bg = aat_type_bg
	
	local aat_type = LUI.UIImage.new()
	aat_type:setLeftRight( false, true, -84+5+7+2, -20-5+7-2 )
	aat_type:setTopBottom( false, true, -174.5+7+2-1.5, -110.5-7-2-1.5 )
	aat_type:setImage( RegisterImage( "tf2_aat_brainrot" ) )
	aat_type:setAlpha( 1 )
	self:addElement( aat_type )
	self.aat_type = aat_type
	aat_type:subscribeToGlobalModel( controller, "CurrentWeapon", "aatIcon", function ( modelRef )
		local aatIcon = Engine.GetModelValue( modelRef )
		if aatIcon then
			aat_type:setImage( RegisterImage( aatIcon ) )
		end
	end )


	
	local ZmAmmoBBGumMeterWidget = CoD.ZmAmmo_BBGumMeterWidget.new( menu, controller )
	ZmAmmoBBGumMeterWidget:setLeftRight( true, false, 1058, 373 )
	ZmAmmoBBGumMeterWidget:setTopBottom( true, false, 580, 659 )
	ZmAmmoBBGumMeterWidget:setScale( 1.4 )
	self:addElement( ZmAmmoBBGumMeterWidget )
	self.ZmAmmoBBGumMeterWidget = ZmAmmoBBGumMeterWidget
	
	self.clipsPerState = 
	{
		DefaultState = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				ZmAmmoClipInfo0:completeAnimation()
				ZmAmmoClipInfo0.weaponname:completeAnimation()
				ZmAmmoClipInfo0.Clip:completeAnimation()
				ZmAmmoClipInfo0.ammo_divide:completeAnimation()
				ZmAmmoClipInfo0.TotalAmmo:completeAnimation()
				ZmAmmoClipInfo0.Special:completeAnimation()
				ZmAmmoClipInfo0.CustomSpecialMeterBacking:completeAnimation()
				ZmAmmoClipInfo0.ClipDual:completeAnimation()
				self.ZmAmmoClipInfo0.weaponname:setAlpha( 0 )
				self.ZmAmmoClipInfo0.Clip:setAlpha( 0 )
				self.ZmAmmoClipInfo0.ammo_divide:setAlpha( 0 )
				self.ZmAmmoClipInfo0.TotalAmmo:setAlpha( 0 )
				self.ZmAmmoClipInfo0.Special:setAlpha( 0 )
				self.ZmAmmoClipInfo0.CustomSpecialMeterBacking:setAlpha( 0 )
				self.ZmAmmoClipInfo0.ClipDual:setAlpha( 0 )
				self.clipFinished( ZmAmmoClipInfo0, {} )
				
				ZmAmmoEquipContainer0:completeAnimation()
				ZmAmmoEquipContainer0:setAlpha( 0 )
				self.clipFinished( ZmAmmoEquipContainer0, {} )
				
				aat_type:completeAnimation()
				aat_type:setAlpha( 0 )
				self.clipFinished( aat_type, {} )

				aat_type_bg:completeAnimation()
				aat_type_bg:setAlpha( 0 )
				self.clipFinished( aat_type_bg, {} )
				
				ZmAmmoBBGumMeterWidget:completeAnimation()
				ZmAmmoBBGumMeterWidget:setAlpha( 0 )
				self.clipFinished( ZmAmmoBBGumMeterWidget, {} )
			end
		},
		HudStart = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				ZmAmmoClipInfo0:completeAnimation()
				ZmAmmoClipInfo0.weaponname:completeAnimation()
				ZmAmmoClipInfo0.Clip:completeAnimation()
				ZmAmmoClipInfo0.ammo_divide:completeAnimation()
				ZmAmmoClipInfo0.TotalAmmo:completeAnimation()
				ZmAmmoClipInfo0.Special:completeAnimation()
				ZmAmmoClipInfo0.CustomSpecialMeterBacking:completeAnimation()
				ZmAmmoClipInfo0.ClipDual:completeAnimation()
				self.ZmAmmoClipInfo0.weaponname:setAlpha( 1 )
				self.ZmAmmoClipInfo0.Clip:setAlpha( 1 )
				self.ZmAmmoClipInfo0.ammo_divide:setAlpha( 1 )
				self.ZmAmmoClipInfo0.TotalAmmo:setAlpha( 1 )
				self.ZmAmmoClipInfo0.Special:setAlpha( 1 )
				self.ZmAmmoClipInfo0.CustomSpecialMeterBacking:setAlpha( 1 )
				self.ZmAmmoClipInfo0.ClipDual:setAlpha( 1 )
				self.clipFinished( ZmAmmoClipInfo0, {} )
				
				ZmAmmoEquipContainer0:completeAnimation()
				ZmAmmoEquipContainer0:setAlpha( 1 )
				self.clipFinished( ZmAmmoEquipContainer0, {} )
				
				aat_type:completeAnimation()
				aat_type:setAlpha( 1 )
				self.clipFinished( aat_type, {} )

				aat_type_bg:completeAnimation()
				aat_type_bg:setAlpha( 1 )
				self.clipFinished( aat_type_bg, {} )
				
				ZmAmmoBBGumMeterWidget:completeAnimation()
				ZmAmmoBBGumMeterWidget:setAlpha( 1 )
				self.clipFinished( ZmAmmoBBGumMeterWidget, {} )
			end
		},
		HudStart_NoAmmo = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				ZmAmmoClipInfo0:completeAnimation()
				ZmAmmoClipInfo0.weaponname:completeAnimation()
				ZmAmmoClipInfo0.Clip:completeAnimation()
				ZmAmmoClipInfo0.ammo_divide:completeAnimation()
				ZmAmmoClipInfo0.TotalAmmo:completeAnimation()
				ZmAmmoClipInfo0.Special:completeAnimation()
				ZmAmmoClipInfo0.CustomSpecialMeterBacking:completeAnimation()
				ZmAmmoClipInfo0.ClipDual:completeAnimation()
				self.ZmAmmoClipInfo0.weaponname:setAlpha( 0 )
				self.ZmAmmoClipInfo0.Clip:setAlpha( 0 )
				self.ZmAmmoClipInfo0.ammo_divide:setAlpha( 0 )
				self.ZmAmmoClipInfo0.TotalAmmo:setAlpha( 0 )
				self.ZmAmmoClipInfo0.Special:setAlpha( 1 )
				self.ZmAmmoClipInfo0.CustomSpecialMeterBacking:setAlpha( 1 )
				self.ZmAmmoClipInfo0.ClipDual:setAlpha( 0 )
				self.clipFinished( ZmAmmoClipInfo0, {} )
				
				ZmAmmoEquipContainer0:completeAnimation()
				ZmAmmoEquipContainer0:setAlpha( 1 )
				self.clipFinished( ZmAmmoEquipContainer0, {} )
				
				aat_type:completeAnimation()
				aat_type:setAlpha( 1 )
				self.clipFinished( aat_type, {} )

				aat_type_bg:completeAnimation()
				aat_type_bg:setAlpha( 1 )
				self.clipFinished( aat_type_bg, {} )
				
				ZmAmmoBBGumMeterWidget:completeAnimation()
				ZmAmmoBBGumMeterWidget:setAlpha( 1 )
				self.clipFinished( ZmAmmoBBGumMeterWidget, {} )
			end
		}
	}
	self:mergeStateConditions( 
	{
		{
			stateName = "HudStart_NoAmmo",
			condition = function ( menu, element, event )
				return not WeaponUsesAmmo( controller )
			end
		},
		{
			stateName = "HudStart",
			condition = function ( menu, element, event )
				return true
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.weapon" ), function ( modelRef )
		menu:updateElementState( self, 
		{
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "currentWeapon.weapon"
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentWeapon.equippedWeaponReference" ), function ( modelRef )
		menu:updateElementState( self, 
		{
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "currentWeapon.equippedWeaponReference"
		} )
	end )
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ZmAmmoClipInfo0:close()
		element.ZmAmmoEquipContainer0:close()
		element.ZmAmmoBBGumMeterWidget:close()
		element.aat_type:close()
		element.aat_type_bg:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end