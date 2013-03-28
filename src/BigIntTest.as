package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	[swf(width="760", height="300")]
	public class BigIntTest extends Sprite
	{
		public function BigIntTest()
		{
			stage.align = StageAlign.BOTTOM;
			stage.quality = StageQuality.BEST;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.scaleX = this.scaleY = 0.95;
			addChild( new BigIntDemo );
		}
	}
}