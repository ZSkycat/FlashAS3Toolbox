/**
 * 2016/11/8 17:54
 * @author ZSkycat
 */
package zskycat
{
    import flash.display.FrameLabel;
    import flash.display.MovieClip;
    import flash.display.Stage;
    import flash.display.StageDisplayState;
    import flash.display.StageScaleMode;
	import flash.system.fscommand;
	
	public class CommonTool
	{
        /**
         * 退出Flash，以发送命令的方式
         */
        public static function ExitCommand()
        {
            fscommand("quit");
        }
        
        /**
         * 全屏控制，以发送命令的方式
         * @param isEnable  是否全屏
         */
		public static function FullscreenCommand(isEnable:Boolean)
		{
			fscommand("fullscreen", isEnable.toString());
		}
        
        /**
         * 全屏控制，以设置舞台的方式
         * @param stage  舞台对象
         * @param isEnable  是否全屏
         * @param isInteractive  是否启用键盘交互性操作的全屏模式，默认启用
         */
        public static function FullscreenSetStage(stage:Stage, isEnable:Boolean, isInteractive:Boolean = true)
        {
            if (isEnable)
            {
                if (isInteractive)
                    stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
                else
                    stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            else
                stage.displayState = StageDisplayState.NORMAL;
        }
        
        /**
         * 缩放模式控制，以设置舞台的方式
         * @param stage  舞台对象
         * @param mode  模式索引: 0-固定不变, 1-保持比例完全可见, 2-保持比例超出裁剪, 3-不按比例填充屏幕
         */
        public static function ScaleModeSetStage(stage:Stage, mode:int)
        {
            switch(mode)
            {
                case 0:
                    stage.scaleMode = StageScaleMode.NO_SCALE;
                    break;
                case 1:
                    stage.scaleMode = StageScaleMode.SHOW_ALL;
                    break;
                case 2:
                    stage.scaleMode = StageScaleMode.NO_BORDER
                    break;
                case 3:
                    stage.scaleMode = StageScaleMode.EXACT_FIT;
                    break;
                default:
                    throw new Error("指定的缩放模式索引不存在. mode=" + mode);
                    break;
            }
        }
		
		/**
		 * 获取指定帧标签名的帧数，支持偏移量
		 * @param movieClip 影片剪辑对象
		 * @param label 帧标签
		 * @param offset 偏移，0为帧标签名的所在帧
		 */
		public static function GetLabelIndex(movieClip:MovieClip, label:String, offset:int = 0):int
		{
            if (movieClip == null)
                throw new Error("指定的 movieClip 不能为 null.");
            if (label == null)
                throw new Error("指定的 label 不能为 null.");
			for each (var i:FrameLabel in movieClip.currentLabels)
			{
				if (label == i.name)
					return i.frame + offset;
			}
			throw new Error("指定的 label 找不到. label=" + label);
		}
	}

}