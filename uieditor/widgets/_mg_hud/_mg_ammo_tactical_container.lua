CoD._mg_ammo_tactical_container = InheritFrom( LUI.UIElement )
CoD._mg_ammo_tactical_container.new = function ( menu, controller )

	local self = LUI.UIElement.new()
	-- 
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	
	self:setUseStencil( false )
	self:setClass( CoD._mg_ammo_tactical_container )
	self.id = "_mg_ammo_tactical_container"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true
	
	local special_grenade = LUI.UIImage.new()
	special_grenade:setLeftRight( true, false, 960, 960 + 22 )
	special_grenade:setTopBottom( true, false, 662, 662 + 22 )
	special_grenade:setImage( RegisterImage( "_mg_monkey_grenade" ) )
	self:addElement( special_grenade )
	self.special_grenade = special_grenade
	special_grenade:subscribeToGlobalModel( controller, "CurrentSecondaryOffhand", "secondaryOffhand", function ( modelRef )
		local secondaryOffhand = Engine.GetModelValue( modelRef )
		if secondaryOffhand then
			if secondaryOffhand == "hud_cymbal_monkey_bo3" then
				special_grenade:setImage( RegisterImage( "_mg_monkey_grenade" ) )
			elseif secondaryOffhand == "uie_t7_zm_hud_inv_icntact" then
				special_grenade:setImage( RegisterImage( "_mg_arnie_grenade" ) )
			elseif secondaryOffhand == "uie_t7_zm_hud_inv_icntactlilarnie" then
				special_grenade:setImage( RegisterImage( "_mg_arnie_grenade" ) )
			else
				special_grenade:setImage( RegisterImage( secondaryOffhand ) )
			end
		end
	end )
	
	local no_gren_indicator = LUI.UIImage.new()
	no_gren_indicator:setLeftRight( true, false, 960, 960 + 22 )
	no_gren_indicator:setTopBottom( true, false, 662, 662 + 22 )
	no_gren_indicator:setImage( RegisterImage("_mg_no_gren_indicator" ) )
	no_gren_indicator:setScale( 0.2 )
	self:addElement( no_gren_indicator )
	self.no_gren_indicator = no_gren_indicator
	
	local special_grenade_count = LUI.UIText.new()
	special_grenade_count:setLeftRight( true, false, 960, 960 + 22 )
	special_grenade_count:setTopBottom( true, false, 658, 668 )
	special_grenade_count:setTTF( "fonts/Bebas-Regular.ttf" )
	special_grenade_count:setText( "" )
	special_grenade_count:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self:addElement( special_grenade_count )
	self.special_grenade_count = special_grenade_count

	special_grenade_count:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "CurrentSecondaryOffhand.secondaryOffhandCount" ), function( ModelRef )
	local modelValue = Engine.GetModelValue( ModelRef )
		if modelValue then
			special_grenade_count:setText( Engine.Localize( modelValue ) )
		end
	end )
	
	self.clipsPerState = 
	{
		DefaultState = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				special_grenade:completeAnimation()
				self.special_grenade:setAlpha( 1 )
				self.clipFinished( special_grenade, {} )
				
				no_gren_indicator:completeAnimation()
				no_gren_indicator:setAlpha( 0 )
				self.clipFinished( no_gren_indicator, {} )
				
				special_grenade_count:completeAnimation()
				special_grenade_count:setAlpha( 1 )
				self.clipFinished( special_grenade_count, {} )
			end
		},
		Invisible = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				special_grenade:completeAnimation()
				self.special_grenade:setAlpha( 0 )
				self.clipFinished( special_grenade, {} )
				
				no_gren_indicator:completeAnimation()
				no_gren_indicator:setAlpha( 1 )
				self.clipFinished( no_gren_indicator, {} )
				
				special_grenade_count:completeAnimation()
				special_grenade_count:setAlpha( 1 )
				self.clipFinished( special_grenade_count, {} )
			end
		}
	}
	self:mergeStateConditions( 
	{
		{
			stateName = "Invisible",
			condition = function ( menu, element, event )
				return not IsModelValueGreaterThan( controller, "currentSecondaryOffhand.secondaryOffhandCount", 0 )
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "currentSecondaryOffhand.secondaryOffhandCount" ), function ( modelRef )
		menu:updateElementState( self, 
		{
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "currentSecondaryOffhand.secondaryOffhandCount"
		} )
	end )
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.special_grenade:close()
		element.no_gren_indicator:close()
		element.special_grenade_count:close()
	end )
	
	return self
end