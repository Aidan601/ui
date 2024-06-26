CoD._mg_ammo_mine_container = InheritFrom( LUI.UIElement )
CoD._mg_ammo_mine_container.new = function ( menu, controller )

	local self = LUI.UIElement.new()
	
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	
	self:setUseStencil( false )
	self:setClass( CoD._mg_ammo_mine_container )
	self.id = "_mg_ammo_mine_container"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true
	
	local mine_icon = LUI.UIImage.new()
	mine_icon:setLeftRight( true, false, 960 + 28 + 28, 960 + 22 + 28 + 28 )
	mine_icon:setTopBottom( true, false, 662, 662 + 22 )
	mine_icon:setImage( RegisterImage( "_mg_mine" ) )
	self:addElement( mine_icon )
	self.mine_icon = mine_icon
	
	local no_mine_indicator = LUI.UIImage.new()
	no_mine_indicator:setLeftRight( true, false, 960 + 28 + 28, 960 + 22 + 28 + 28 )
	no_mine_indicator:setTopBottom( true, false, 662, 662 + 22 )
	no_mine_indicator:setImage( RegisterImage( "_mg_no_gren_indicator" ) )
	no_mine_indicator:setScale( 0.2 )
	self:addElement( no_mine_indicator )
	self.no_mine_indicator = no_mine_indicator
	
	local mine_count = LUI.UIText.new()
	mine_count:setLeftRight( true, false, 960 + 28 + 28, 960 + 22 + 28 + 28 )
	mine_count:setTopBottom( true, false, 658, 668 )
	mine_count:setTTF( "fonts/Bebas-Regular.ttf" )
	mine_count:setText( "" )
	mine_count:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self:addElement( mine_count )
	self.mine_count = mine_count

	mine_count:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot3ammo" ), function( ModelRef )
		local modelValue = Engine.GetModelValue( ModelRef )
		if modelValue then
			mine_count:setText( Engine.Localize( modelValue ) )
		end
	end )
	
	self.clipsPerState = 
	{
		DefaultState = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				mine_icon:completeAnimation()
				self.mine_icon:setAlpha( 1 )
				self.clipFinished( mine_icon, {} )
				
				no_mine_indicator:completeAnimation()
				no_mine_indicator:setAlpha( 0 )
				self.clipFinished( no_mine_indicator, {} )
				
				mine_count:completeAnimation()
				mine_count:setAlpha( 1 )
				self.clipFinished( mine_count, {} )
			end
		},
		Invisible = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )
				
				mine_icon:completeAnimation()
				self.mine_icon:setAlpha( 0 )
				self.clipFinished( mine_icon, {} )
				
				no_mine_indicator:completeAnimation()
				no_mine_indicator:setAlpha( 1 )
				self.clipFinished( no_mine_indicator, {} )
				
				mine_count:completeAnimation()
				mine_count:setAlpha( 1 )
				self.clipFinished( mine_count, {} )
			end
		}
	}
	self:mergeStateConditions( 
	{
		{
			stateName = "Invisible",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.showDpadRight", 0 )
			end
		}
	} )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.actionSlot3ammo" ), function ( modelRef )
		menu:updateElementState( self, 
		{
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "hudItems.actionSlot3ammo"
		} )
	end )
	self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.showDpadRight" ), function ( modelRef )
		menu:updateElementState( self, 
		{
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "hudItems.showDpadRight"
		} )
	end )
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.mine_icon:close()
		element.no_mine_indicator:close()
		element.mine_count:close()
	end )
	
	return self
end