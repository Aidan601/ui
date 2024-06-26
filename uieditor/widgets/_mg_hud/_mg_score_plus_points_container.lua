require( "ui.uieditor.widgets._mg_hud._mg_score_plus_points" )

CoD._mg_score_plus_points_container = InheritFrom( LUI.UIElement )
CoD._mg_score_plus_points_container.new = function ( menu, controller )

	local self = LUI.UIElement.new()
	
	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end
	
	self:setUseStencil( false )
	self:setClass( CoD._mg_score_plus_points_container )
	self.id = "_mg_score_plus_points_container"
	self.soundSet = "HUD"
	self:setLeftRight( true, false, 0, 85 )
	self:setTopBottom( true, false, 0, 66 )
	self.anyChildUsesUpdateState = true
	
	local ZMScrPlusPoints = CoD._mg_score_plus_points.new( menu, controller )
	ZMScrPlusPoints:setLeftRight( true, false, 68.91, 153.91 )
	ZMScrPlusPoints:setTopBottom( true, false, 46.88, 112.63 )
	ZMScrPlusPoints.Label2:setText( Engine.Localize( "+50" ) )
	ZMScrPlusPoints.Label1:setText( Engine.Localize( "+50" ) )
	self:addElement( ZMScrPlusPoints )
	self.ZMScrPlusPoints = ZMScrPlusPoints
	
	self.clipsPerState = 
	{
		DefaultState = 
		{
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end,
			Anim1 = function ()
				self:setupElementClipCounter( 1 )
				local f3_local0 = function ( f4_arg0, f4_arg1 )
					if not f4_arg1.interrupted then
						f4_arg0:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
					end
					f4_arg0:setLeftRight( true, false, 97.5, 182.5 )
					f4_arg0:setTopBottom( true, false, 0 + 2, 65.75 + 2 )
					if f4_arg1.interrupted then
						self.clipFinished( f4_arg0, f4_arg1 )
					else
						f4_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				ZMScrPlusPoints:completeAnimation()
				self.ZMScrPlusPoints:setLeftRight( true, false, 0, 85 )
				self.ZMScrPlusPoints:setTopBottom( true, false, 0, 65.75 )
				f3_local0( ZMScrPlusPoints, {} )
			end,
			Anim2 = function ()
				self:setupElementClipCounter( 1 )
				local f5_local0 = function ( f6_arg0, f6_arg1 )
					if not f6_arg1.interrupted then
						f6_arg0:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
					end
					f6_arg0:setLeftRight( true, false, 97.97, 182.97 )
					f6_arg0:setTopBottom( true, false, 0 - 2, 65.75 - 2 )
					if f6_arg1.interrupted then
						self.clipFinished( f6_arg0, f6_arg1 )
					else
						f6_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				ZMScrPlusPoints:completeAnimation()
				self.ZMScrPlusPoints:setLeftRight( true, false, 0, 85 )
				self.ZMScrPlusPoints:setTopBottom( true, false, 0, 65.75 )
				f5_local0( ZMScrPlusPoints, {} )
			end,
			Anim3 = function ()
				self:setupElementClipCounter( 1 )
				local f7_local0 = function ( f8_arg0, f8_arg1 )
					if not f8_arg1.interrupted then
						f8_arg0:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
					end
					f8_arg0:setLeftRight( true, false, 77.81, 162.81 )
					f8_arg0:setTopBottom( true, false, 0 + 4, 65.75 + 4 )
					if f8_arg1.interrupted then
						self.clipFinished( f8_arg0, f8_arg1 )
					else
						f8_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				ZMScrPlusPoints:completeAnimation()
				self.ZMScrPlusPoints:setLeftRight( true, false, 0, 85 )
				self.ZMScrPlusPoints:setTopBottom( true, false, 0, 65.75 )
				f7_local0( ZMScrPlusPoints, {} )
			end,
			Anim4 = function ()
				self:setupElementClipCounter( 1 )
				local f9_local0 = function ( f10_arg0, f10_arg1 )
					if not f10_arg1.interrupted then
						f10_arg0:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
					end
					f10_arg0:setLeftRight( true, false, 83.44, 168.44 )
					f10_arg0:setTopBottom( true, false, 0 - 4, 65.75 - 4 )
					if f10_arg1.interrupted then
						self.clipFinished( f10_arg0, f10_arg1 )
					else
						f10_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				ZMScrPlusPoints:completeAnimation()
				self.ZMScrPlusPoints:setLeftRight( true, false, 0, 85 )
				self.ZMScrPlusPoints:setTopBottom( true, false, 0, 65.75 )
				f9_local0( ZMScrPlusPoints, {} )
			end,
			Anim5 = function ()
				self:setupElementClipCounter( 1 )
				local f11_local0 = function ( f12_arg0, f12_arg1 )
					if not f12_arg1.interrupted then
						f12_arg0:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
					end
					f12_arg0:setLeftRight( true, false, 55.78, 140.78 )
					f12_arg0:setTopBottom( true, false, 0 + 6, 65.75 + 6 )
					if f12_arg1.interrupted then
						self.clipFinished( f12_arg0, f12_arg1 )
					else
						f12_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				ZMScrPlusPoints:completeAnimation()
				self.ZMScrPlusPoints:setLeftRight( true, false, 0, 85 )
				self.ZMScrPlusPoints:setTopBottom( true, false, 0, 65.75 )
				f11_local0( ZMScrPlusPoints, {} )
			end,
			Anim6 = function ()
				self:setupElementClipCounter( 1 )
				local f13_local0 = function ( f14_arg0, f14_arg1 )
					if not f14_arg1.interrupted then
						f14_arg0:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
					end
					f14_arg0:setLeftRight( true, false, 82.5, 167.5 )
					f14_arg0:setTopBottom( true, false, 0 - 6, 65.75 - 6 )
					if f14_arg1.interrupted then
						self.clipFinished( f14_arg0, f14_arg1 )
					else
						f14_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				ZMScrPlusPoints:completeAnimation()
				self.ZMScrPlusPoints:setLeftRight( true, false, 0, 85 )
				self.ZMScrPlusPoints:setTopBottom( true, false, 0, 65.75 )
				f13_local0( ZMScrPlusPoints, {} )
			end,
			Anim7 = function ()
				self:setupElementClipCounter( 1 )
				local f15_local0 = function ( f16_arg0, f16_arg1 )
					if not f16_arg1.interrupted then
						f16_arg0:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
					end
					f16_arg0:setLeftRight( true, false, 84.38, 169.38 )
					f16_arg0:setTopBottom( true, false, 0 + 8, 65.75 + 8 )
					if f16_arg1.interrupted then
						self.clipFinished( f16_arg0, f16_arg1 )
					else
						f16_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				ZMScrPlusPoints:completeAnimation()
				self.ZMScrPlusPoints:setLeftRight( true, false, 0, 85 )
				self.ZMScrPlusPoints:setTopBottom( true, false, 0, 65.75 )
				f15_local0( ZMScrPlusPoints, {} )
			end,
			Anim8 = function ()
				self:setupElementClipCounter( 1 )
				local f17_local0 = function ( f18_arg0, f18_arg1 )
					if not f18_arg1.interrupted then
						f18_arg0:beginAnimation( "keyframe", 750, false, false, CoD.TweenType.Linear )
					end
					f18_arg0:setLeftRight( true, false, 68.91, 153.91 )
					f18_arg0:setTopBottom( true, false, 0 - 8, 65.75 - 8 )
					if f18_arg1.interrupted then
						self.clipFinished( f18_arg0, f18_arg1 )
					else
						f18_arg0:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				ZMScrPlusPoints:completeAnimation()
				self.ZMScrPlusPoints:setLeftRight( true, false, 0, 85 )
				self.ZMScrPlusPoints:setTopBottom( true, false, 0, 65.75 )
				f17_local0( ZMScrPlusPoints, {} )
			end
		}
	}
	
	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.ZMScrPlusPoints:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
	
end
