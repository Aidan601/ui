CoD._mg_ShieldHealthWidget = InheritFrom( LUI.UIElement )
CoD._mg_ShieldHealthWidget.new = function ( menu, controller )

	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD._mg_ShieldHealthWidget )
	self.id = "_mg_ShieldHealthWidget"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	local shield_icon = LUI.UIImage.new()
    shield_icon:setLeftRight( true, false, 119-90, 169-50+5 )
    shield_icon:setTopBottom( true, false, 614-40, 660+5 )
    shield_icon:setImage( RegisterImage( "red_grenade_bg" ) )
    self:addElement( shield_icon )
	self.shield_icon = shield_icon

	local shield_text = LUI.UIText.new()
    shield_text:setLeftRight( true, false, 119-130, 169 )
    shield_text:setTopBottom( true, false, 614+32-20, 660-22 )
    shield_text:setTTF("fonts/verdana.ttf")
    shield_text:setAlignment(LUI.Alignment.Center)
    shield_text:setText("SHEILD")
    self:addElement( shield_text )
	self.shield_text = shield_text

	local Shieldbacking = LUI.UIImage.new()
    Shieldbacking:setLeftRight( true, false, 53-8, 103+4 )
    Shieldbacking:setTopBottom( true, false, 628-22+7, 633-15+6 )
   	Shieldbacking:setImage( RegisterImage( "_mg_health_bar" ) )
   	Shieldbacking:setAlpha(0.5)
    self:addElement( Shieldbacking )
	self.Shieldbacking = Shieldbacking

    local dpadShieldHealth = LUI.UIImage.new()
    dpadShieldHealth:setLeftRight( true, false, 53-8, 103+4 )
    dpadShieldHealth:setTopBottom( true, false, 628-22+7, 633-15+6 )
    dpadShieldHealth:setImage( RegisterImage( "_mg_health_bar" ) )
    dpadShieldHealth:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
    dpadShieldHealth:setShaderVector( 0, 0, 0, 0, 0 )
    dpadShieldHealth:setShaderVector( 1, 0, 0, 0, 0 )
    dpadShieldHealth:setShaderVector( 2, 1, 0, 0, 0 )
    dpadShieldHealth:setShaderVector( 3, 0, 0, 0, 0 )
    self:addElement( dpadShieldHealth )
    self.Health = dpadShieldHealth

	local shield_ammo = LUI.UIText.new()
	shield_ammo:setLeftRight( true, false, 0,0 )
	shield_ammo:setTopBottom( true, false, 622, 647 )
	shield_ammo:setTTF( "fonts/verdana.ttf" )
	shield_ammo:setRGB( 1, 1, 1 )
	self:addElement( shield_ammo )
	self.shield_ammo = shield_ammo 
	shield_ammo:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot1ammo" ), function( ModelRef )
		local modelValue = Engine.GetModelValue( ModelRef )
		if modelValue ~= nil then
			number = Engine.Localize( modelValue )
			shield_text:setText( "SHIELD (" .. number..")" )
		else
			shield_text:setText( "" ) 
		end
	end )
	
    self:subscribeToGlobalModel( controller, "ZMInventory", "shield_health", function ( ModelRef ) 
        local ModelValue = Engine.GetModelValue( ModelRef )
        if ModelValue then
			local shaderW = CoD.GetVectorComponentFromString( ModelValue, 1 )
			local shaderX = CoD.GetVectorComponentFromString( ModelValue, 2 )
			local shaderY = CoD.GetVectorComponentFromString( ModelValue, 3 )
			local shaderZ = CoD.GetVectorComponentFromString( ModelValue, 4 )
            self.Health:setShaderVector( 0, AdjustStartEnd( 0, 1, shaderW, shaderX, shaderY, shaderZ ) )
        end
    end)
	 
	self.clipsPerState = 
	{
		DefaultState =
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				self.Health:completeAnimation()
				self.Health:setAlpha( 0 )
				self.clipFinished( self.Health, {} )
				
				self.Shieldbacking:completeAnimation()
				self.Shieldbacking:setAlpha( 0 )
				self.clipFinished( self.Shieldbacking, {} )
				
				self.shield_icon:completeAnimation()
				self.shield_icon:setAlpha( 0 )
				self.clipFinished( self.shield_icon, {} )
				
				self.shield_ammo:completeAnimation()
				self.shield_ammo:setAlpha( 0 )
				self.clipFinished( self.shield_ammo, {} )

				self.shield_text:completeAnimation()
				self.shield_text:setAlpha( 0 )
				self.clipFinished(self.shield_text, {} )
			end
		},
		AlmostFull = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				self.Health:completeAnimation()
				self.Health:setAlpha( 1 )
				self.Health:setRGB( 1, 1, 1 )
				self.clipFinished( self.Health, {} )
				
				self.Shieldbacking:completeAnimation()
				self.Shieldbacking:setAlpha( 0.5 )
				self.clipFinished( self.Shieldbacking, {} )
				
				self.shield_icon:completeAnimation()
				self.shield_icon:setAlpha( 1 )
				self.clipFinished( self.shield_icon, {} )
				
				self.shield_ammo:completeAnimation()
				self.shield_ammo:setAlpha( 1 )
				self.clipFinished( self.shield_ammo, {} )

				self.shield_text:completeAnimation()
				self.shield_text:setAlpha( 1 )
				self.clipFinished(self.shield_text, {} )
			end
		},
		Middle = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				self.Health:completeAnimation()
				self.Health:setAlpha( 1 )
				self.Health:setRGB( 1, 1, 1 )
				self.clipFinished( self.Health, {} )
				
				self.Shieldbacking:completeAnimation()
				self.Shieldbacking:setAlpha( 0.5 )
				self.clipFinished( self.Shieldbacking, {} )
				
				self.shield_icon:completeAnimation()
				self.shield_icon:setAlpha( 1 )
				self.clipFinished( self.shield_icon, {} )
				
				self.shield_ammo:completeAnimation()
				self.shield_ammo:setAlpha( 1 )
				self.clipFinished( self.shield_ammo, {} )

				self.shield_text:completeAnimation()
				self.shield_text:setAlpha( 1 )
				self.clipFinished(self.shield_text, {} )
			end
		}, 
		Low = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				self.Health:completeAnimation()
				self.Health:setAlpha( 1 )
				self.Health:setRGB( 1, 1, 1 )
				self.clipFinished( self.Health, {} )
				
				self.Shieldbacking:completeAnimation()
				self.Shieldbacking:setAlpha( 0.5 )
				self.clipFinished( self.Shieldbacking, {} )
				
				self.shield_icon:completeAnimation()
				self.shield_icon:setAlpha( 1 )
				self.clipFinished( self.shield_icon, {} )
				
				self.shield_ammo:completeAnimation()
				self.shield_ammo:setAlpha( 1 )
				self.clipFinished( self.shield_ammo, {} )

				self.shield_text:completeAnimation()
				self.shield_text:setAlpha( 1 )
				self.clipFinished(self.shield_text, {} )
			end
		},
		NoHealth = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 4 )
				
				self.Health:completeAnimation()
				self.Health:setAlpha( 0 )
				self.clipFinished( self.Health, {} )
				
				self.Shieldbacking:completeAnimation()
				self.Shieldbacking:setAlpha( 0 )
				self.clipFinished( self.Shieldbacking, {} )
				
				self.shield_icon:completeAnimation()
				self.shield_icon:setAlpha( 0 )
				self.clipFinished( self.shield_icon, {} )
				
				self.shield_ammo:completeAnimation()
				self.shield_ammo:setAlpha( 0 )
				self.clipFinished( self.shield_ammo, {} )

				self.shield_text:completeAnimation()
				self.shield_text:setAlpha( 0 )
				self.clipFinished(self.shield_text, {} )
			end
		}
	}

	self:mergeStateConditions(
	{
		{
			stateName = "AlmostFull", 
			condition = function ( menu, element, event )
				return IsModelValueGreaterThan( controller, "zmInventory.shield_health", .66 ) and IsModelValueEqualTo(InstanceRef, "hudItems.showDpadDown", 1)
			end
		}, 
		{
			stateName = "Middle", 
			condition = function ( menu, element, event )
				return IsModelValueGreaterThan( controller, "zmInventory.shield_health", .33 )and IsModelValueEqualTo(InstanceRef, "hudItems.showDpadDown", 1)
			end
		}, 
		{
			stateName = "Low", 
			condition = function ( menu, element, event )
				return IsModelValueGreaterThan( controller, "zmInventory.shield_health", 0 )and IsModelValueEqualTo(InstanceRef, "hudItems.showDpadDown", 1)
			end
		}, 
		{
			stateName = "NoHealth", 
			condition = function ( menu, element, event )
				return AlwaysTrue()
			end
		}
	}) 
	
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot1ammo" ), function ( ModelRef )
        menu:updateElementState( self, 
		{
			name = "model_validation", 
			menu = menu, 
			modelValue = Engine.GetModelValue( ModelRef ), 
			modelName = "hudItems.actionSlot1ammo"
		})
    end)
	
    self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "zmInventory.shield_health" ), function ( ModelRef )
        menu:updateElementState( self, 
		{
			name = "model_validation", 
			menu = menu, 
			modelValue = Engine.GetModelValue( ModelRef ), 
			modelName = "zmInventory.shield_health"
		})
    end)
	
	self:subscribeToModel( Engine.GetModel(Engine.GetModelForController( controller ), "hudItems.showDpadDown" ), function ( ModelRef )
		menu:updateElementState( self, 
		{
			name = "model_validation", 
			menu = menu, 
			modelValue = Engine.GetModelValue( ModelRef ), 
			modelName = "hudItems.showDpadDown"
		})
	end)

    LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
        element.Health:close()
        element.Shieldbacking:close()
    end)

    if PostLoadFunc then
        PostLoadFunc( self, controller, menu )
    end

    return self

end