require( "ui.uieditor.widgets.MPHudWidgets.cursorhint_image" )

CoD._mg_hintstring_background = InheritFrom( LUI.UIElement )
CoD._mg_hintstring_background.new = function ( menu, controller )

	local self = LUI.UIElement.new()
	
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	
	self:setUseStencil( false )
	self:setClass( CoD._mg_hintstring_background )
	self.id = "_mg_hintstring_background"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 82 )
	self:setTopBottom( true, false, 0, 20 )
	
	local ImageLeft = LUI.UIImage.new()
	ImageLeft:setLeftRight( true, false, -1 - 16, -1 )
	ImageLeft:setTopBottom( true, true, -2, 2 )
	ImageLeft:setImage( RegisterImage( "_mg_hintstring_left" ) )
	self:addElement( ImageLeft )
	self.ImageLeft = ImageLeft
	
	local Image12 = LUI.UIImage.new()
	Image12:setLeftRight( true, true, -1, 1 )
	Image12:setTopBottom( true, true, -2, 2 )
	Image12:setImage( RegisterImage( "_mg_hintstring_middle" ) )
	self:addElement( Image12 )
	self.Image12 = Image12
	
	local ImageRight = LUI.UIImage.new()
	ImageRight:setLeftRight( false, true, 1, 16 )
	ImageRight:setTopBottom( true, true, -2, 2 )
	ImageRight:setImage( RegisterImage( "_mg_hintstring_right" ) )
	self:addElement( ImageRight )
	self.ImageRight = ImageRight
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

CoD._mg_cursorhint = InheritFrom( LUI.UIElement )
CoD._mg_cursorhint.new = function ( menu, controller )

	local self = LUI.UIElement.new()
	
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	
	self:setUseStencil( false )
	self:setClass( CoD._mg_cursorhint )
	self.id = "_mg_cursorhint"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 512 )
	self:setTopBottom( true, false, 0, 20 )
	
	local Background = CoD._mg_hintstring_background.new( menu, controller )
	Background:setLeftRight( true, true, 0, 0 )
	Background:setTopBottom( true, true, -2, 2 )
	self:addElement( Background )
	self.Background = Background
	
	local CursorHintText = LUI.UIText.new()
	CursorHintText:setLeftRight( false, false, -256, 256 )
	CursorHintText:setTopBottom( true, false, 0, 20 )
	CursorHintText:setText( Engine.Localize( "MENU_NEW" ) )
	CursorHintText:setTTF( "fonts/tf2.ttf" )
	CursorHintText:setLetterSpacing( 0.5 )
	CursorHintText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	CursorHintText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_TOP )
	LUI.OverrideFunction_CallOriginalFirst( CursorHintText, "setText", function ( element, controller )
		ScaleWidgetToLabelCenteredWrapped( self, element, 5, 0 )
	end )
	self:addElement( CursorHintText )
	self.CursorHintText = CursorHintText
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Background:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end

CoD._mg_hintstring = InheritFrom( LUI.UIElement )
CoD._mg_hintstring.new = function ( menu, controller )

	local self = LUI.UIHorizontalList.new( 
	{
		left = 0,
		top = 0,
		right = 0,
		bottom = 0,
		leftAnchor = true,
		topAnchor = true,
		rightAnchor = true,
		bottomAnchor = true,
		spacing = 0
	} )
	self:setAlignment( LUI.Alignment.Center )
	
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	
	self:setUseStencil( false )
	self:setClass( CoD.ZMCursorHint )
	self.id = "ZMCursorHint"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 500 )
	self:setTopBottom( true, false, 0, 90 )
	self.anyChildUsesUpdateState = true
	
	local cursorhinttext0 = CoD._mg_cursorhint.new( menu, controller )
	cursorhinttext0:setLeftRight( false, false, -242.5, 120.17 )
	cursorhinttext0:setTopBottom( true, false, 0, 19 )
	
	cursorhinttext0:subscribeToGlobalModel( controller, "HUDItems", "cursorHintText", function ( modelRef )
		local cursorHintText = Engine.GetModelValue( modelRef )
		if cursorHintText then
			cursorhinttext0.CursorHintText:setText( Engine.Localize( cursorHintText ) )
		end
	end )
	self:addElement( cursorhinttext0 )
	self.cursorhinttext0 = cursorhinttext0
	
	local cursorhintimage0 = CoD.cursorhint_image.new( menu, controller )
	cursorhintimage0:setLeftRight( false, false, 134.5, 242.5 )
	cursorhintimage0:setTopBottom( true, false, -17.5, 36.5 )
	cursorhintimage0:subscribeToGlobalModel( controller, "HUDItems", "cursorHintImage", function ( modelRef )
		local cursorHintImage = Engine.GetModelValue( modelRef )
		if cursorHintImage then
			cursorhintimage0.c1x1:setImage( RegisterImage( cursorHintImage ) )
		end
	end )
	cursorhintimage0:subscribeToGlobalModel( controller, "HUDItems", "cursorHintImage", function ( modelRef )
		local cursorHintImage = Engine.GetModelValue( modelRef )
		if cursorHintImage then
			cursorhintimage0.x1x4:setImage( RegisterImage( cursorHintImage ) )
		end
	end )
	cursorhintimage0:subscribeToGlobalModel( controller, "HUDItems", "cursorHintImage", function ( modelRef )
		local cursorHintImage = Engine.GetModelValue( modelRef )
		if cursorHintImage then
			cursorhintimage0.c1x2:setImage( RegisterImage( cursorHintImage ) )
		end
	end )
	
	cursorhintimage0:mergeStateConditions( 
	{
		{
			stateName = "Active_1x1",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.cursorHintIconRatio", 1 )
			end
		},
		{
			stateName = "Active_2x1",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.cursorHintIconRatio", 2 )
			end
		},
		{
			stateName = "Active_4x1",
			condition = function ( menu, element, event )
				return IsModelValueEqualTo( controller, "hudItems.cursorHintIconRatio", 4 )
			end
		}
	} )
	cursorhintimage0:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "hudItems.cursorHintIconRatio" ), function ( modelRef )
		menu:updateElementState( cursorhintimage0, 
		{
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( modelRef ),
			modelName = "hudItems.cursorHintIconRatio"
		} )
	end )
	self:addElement( cursorhintimage0 )
	self.cursorhintimage0 = cursorhintimage0
	
	self.clipsPerState = 
	{
		DefaultState = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				
				cursorhinttext0:completeAnimation()
				self.cursorhinttext0:setAlpha( 0 )
				self.clipFinished( cursorhinttext0, {} )
				cursorhintimage0:completeAnimation()
				self.cursorhintimage0:setLeftRight( false, false, 120.17, 228.17 )
				self.cursorhintimage0:setTopBottom( true, false, -17.5, 36.5 )
				self.cursorhintimage0:setAlpha( 0 )
				self.clipFinished( cursorhintimage0, {} )
			end
		},
		Active_1x1 = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				
				local f11_local0 = function ( f12_arg0, f12_arg1 )
					if not f12_arg1.interrupted then
						f12_arg0:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Bounce )
					end
					f12_arg0:setAlpha( 1 )
					if f12_arg1.interrupted then
						self.clipFinished( f12_arg0, f12_arg1 )
					else
						f12_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhinttext0:completeAnimation()
				self.cursorhinttext0:setAlpha( 0.44 )
				f11_local0( cursorhinttext0, {} )
				local f11_local1 = function ( f13_arg0, f13_arg1 )
					if not f13_arg1.interrupted then
						f13_arg0:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Bounce )
					end
					f13_arg0:setLeftRight( false, false, 120.17, 228.17 )
					f13_arg0:setTopBottom( true, false, -17.5, 36.5 )
					f13_arg0:setAlpha( 1 )
					if f13_arg1.interrupted then
						self.clipFinished( f13_arg0, f13_arg1 )
					else
						f13_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhintimage0:completeAnimation()
				self.cursorhintimage0:setLeftRight( false, false, 120.17, 228.17 )
				self.cursorhintimage0:setTopBottom( true, false, -17.5, 36.5 )
				self.cursorhintimage0:setAlpha( 0.36 )
				f11_local1( cursorhintimage0, {} )
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 2 )
				
				local f14_local0 = function ( f15_arg0, f15_arg1 )
					if not f15_arg1.interrupted then
						f15_arg0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Bounce )
					end
					f15_arg0:setAlpha( 0 )
					if f15_arg1.interrupted then
						self.clipFinished( f15_arg0, f15_arg1 )
					else
						f15_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhinttext0:completeAnimation()
				self.cursorhinttext0:setAlpha( 1 )
				f14_local0( cursorhinttext0, {} )
				local f14_local1 = function ( f16_arg0, f16_arg1 )
					if not f16_arg1.interrupted then
						f16_arg0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Bounce )
					end
					f16_arg0:setAlpha( 0 )
					if f16_arg1.interrupted then
						self.clipFinished( f16_arg0, f16_arg1 )
					else
						f16_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhintimage0:completeAnimation()
				self.cursorhintimage0:setAlpha( 1 )
				f14_local1( cursorhintimage0, {} )
			end
		},
		Active_2x1 = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				
				local f17_local0 = function ( f18_arg0, f18_arg1 )
					if not f18_arg1.interrupted then
						f18_arg0:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Bounce )
					end
					f18_arg0:setAlpha( 1 )
					if f18_arg1.interrupted then
						self.clipFinished( f18_arg0, f18_arg1 )
					else
						f18_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhinttext0:completeAnimation()
				self.cursorhinttext0:setAlpha( 0.41 )
				f17_local0( cursorhinttext0, {} )
				local f17_local1 = function ( f19_arg0, f19_arg1 )
					if not f19_arg1.interrupted then
						f19_arg0:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Bounce )
					end
					f19_arg0:setLeftRight( false, false, 120.17, 228.17 )
					f19_arg0:setTopBottom( true, false, -17.5, 36.5 )
					f19_arg0:setAlpha( 1 )
					if f19_arg1.interrupted then
						self.clipFinished( f19_arg0, f19_arg1 )
					else
						f19_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhintimage0:completeAnimation()
				self.cursorhintimage0:setLeftRight( false, false, 120.17, 228.17 )
				self.cursorhintimage0:setTopBottom( true, false, -17.5, 36.5 )
				self.cursorhintimage0:setAlpha( 0.37 )
				f17_local1( cursorhintimage0, {} )
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 2 )
				
				local f20_local0 = function ( f21_arg0, f21_arg1 )
					if not f21_arg1.interrupted then
						f21_arg0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Bounce )
					end
					f21_arg0:setAlpha( 0 )
					if f21_arg1.interrupted then
						self.clipFinished( f21_arg0, f21_arg1 )
					else
						f21_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhinttext0:completeAnimation()
				self.cursorhinttext0:setAlpha( 1 )
				f20_local0( cursorhinttext0, {} )
				local f20_local1 = function ( f22_arg0, f22_arg1 )
					if not f22_arg1.interrupted then
						f22_arg0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Bounce )
					end
					f22_arg0:setAlpha( 0 )
					if f22_arg1.interrupted then
						self.clipFinished( f22_arg0, f22_arg1 )
					else
						f22_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhintimage0:completeAnimation()
				self.cursorhintimage0:setAlpha( 1 )
				f20_local1( cursorhintimage0, {} )
			end
		},
		Active_4x1 = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				
				local f23_local0 = function ( f24_arg0, f24_arg1 )
					if not f24_arg1.interrupted then
						f24_arg0:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Bounce )
					end
					f24_arg0:setAlpha( 1 )
					if f24_arg1.interrupted then
						self.clipFinished( f24_arg0, f24_arg1 )
					else
						f24_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhinttext0:completeAnimation()
				self.cursorhinttext0:setAlpha( 0.45 )
				f23_local0( cursorhinttext0, {} )
				local f23_local1 = function ( f25_arg0, f25_arg1 )
					if not f25_arg1.interrupted then
						f25_arg0:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Bounce )
					end
					f25_arg0:setLeftRight( false, false, 120.17, 228.17 )
					f25_arg0:setTopBottom( true, false, -17.5, 36.5 )
					f25_arg0:setAlpha( 1 )
					if f25_arg1.interrupted then
						self.clipFinished( f25_arg0, f25_arg1 )
					else
						f25_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhintimage0:completeAnimation()
				self.cursorhintimage0:setLeftRight( false, false, 120.17, 228.17 )
				self.cursorhintimage0:setTopBottom( true, false, -17.5, 36.5 )
				self.cursorhintimage0:setAlpha( 0.32 )
				f23_local1( cursorhintimage0, {} )
			end,
			DefaultState = function ()
				self:setupElementClipCounter( 2 )
				
				local f26_local0 = function ( f27_arg0, f27_arg1 )
					if not f27_arg1.interrupted then
						f27_arg0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Bounce )
					end
					f27_arg0:setAlpha( 0.45 )
					if f27_arg1.interrupted then
						self.clipFinished( f27_arg0, f27_arg1 )
					else
						f27_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhinttext0:completeAnimation()
				self.cursorhinttext0:setAlpha( 1 )
				f26_local0( cursorhinttext0, {} )
				local f26_local1 = function ( f28_arg0, f28_arg1 )
					if not f28_arg1.interrupted then
						f28_arg0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Bounce )
					end
					f28_arg0:setAlpha( 0.32 )
					if f28_arg1.interrupted then
						self.clipFinished( f28_arg0, f28_arg1 )
					else
						f28_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhintimage0:completeAnimation()
				self.cursorhintimage0:setAlpha( 1 )
				f26_local1( cursorhintimage0, {} )
			end
		},
		Active_NoImage = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				
				local f29_local0 = function ( f30_arg0, f30_arg1 )
					if not f30_arg1.interrupted then
						f30_arg0:beginAnimation( "keyframe", 300, false, false, CoD.TweenType.Bounce )
					end
					f30_arg0:setAlpha( 1 )
					if f30_arg1.interrupted then
						self.clipFinished( f30_arg0, f30_arg1 )
					else
						f30_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhinttext0:completeAnimation()
				self.cursorhinttext0:setAlpha( 0.45 )
				f29_local0( cursorhinttext0, {} )
				cursorhintimage0:completeAnimation()
				self.cursorhintimage0:setLeftRight( false, false, 120.17, 120.17 )
				self.cursorhintimage0:setTopBottom( true, false, -17.5, 36.5 )
				self.clipFinished( cursorhintimage0, {} )
			end
		},
		Out = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 2 )
				
				local f31_local0 = function ( f32_arg0, f32_arg1 )
					if not f32_arg1.interrupted then
						f32_arg0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Bounce )
					end
					f32_arg0:setAlpha( 0 )
					if f32_arg1.interrupted then
						self.clipFinished( f32_arg0, f32_arg1 )
					else
						f32_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhinttext0:completeAnimation()
				self.cursorhinttext0:setAlpha( 1 )
				f31_local0( cursorhinttext0, {} )
				local f31_local1 = function ( f33_arg0, f33_arg1 )
					if not f33_arg1.interrupted then
						f33_arg0:beginAnimation( "keyframe", 100, false, false, CoD.TweenType.Bounce )
					end
					f33_arg0:setAlpha( 0 )
					if f33_arg1.interrupted then
						self.clipFinished( f33_arg0, f33_arg1 )
					else
						f33_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				cursorhintimage0:completeAnimation()
				self.cursorhintimage0:setAlpha( 1 )
				f31_local1( cursorhintimage0, {} )
			end
		}
	}
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.cursorhinttext0:close()
		element.cursorhintimage0:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
	
end