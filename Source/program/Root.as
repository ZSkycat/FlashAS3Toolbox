/**
 * @author ZSkycat
 */

package program
{
    import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import zskycat.*;
	import flash.system.fscommand;
	
	public class Root extends Sprite
	{
		
		public function Root()
		{
		}
		
		//代码碎片
		private function Code()
		{
			//全屏
			fscommand("fullscreen", "true");
		}
		
		//Demo 发送事件
		private function DispatchUpdata()
		{
			var event:CustomEvent = new CustomEvent(CustomEvent.Updata);
			dispatchEvent(event);
		}
		
		/**
		 * 获取指定帧标签的帧数，支持偏移功能
		 * @param movieClip 影片剪辑对象
		 * @param label 帧标签
		 * @param offset 偏移
		 */
		public static function GetLabelIndex(movieClip:MovieClip, label:String, offset:int = 0):int
		{
            if (movieClip == null)
                throw new Error("指定的影片剪辑对象不能为 null!");
            if (label == null)
                throw new Error("指定的帧标签不能为 null!");
			for each (var i:FrameLabel in movieClip.currentLabels)
			{
				if (label == i.name)
					return i.frame + offset;
			}
			throw new Error("指定的帧标签找不到!");
		}
	
	}

}