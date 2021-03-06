/**
 * 2017/01/22 02:55
 * @author ZSkycat
 */
package zskycat
{
    import flash.display.FrameLabel;
    import flash.display.MovieClip;
    import flash.events.Event;
    
    /**
     * 时间轴播放控制器
     */
    public class TimelinePlayControl
    {
        // 枚举常量
        private static const PlayStatus_Stop = 0;
        private static const PlayStatus_Play = 1;
        private static const PlayStatus_PrevPlay = -1;
        
        private var movieClipObject:MovieClip;
        private var playStatus:int;
        private var endFrame:int;
        
        public function get MovieClipObject():MovieClip 
        {
            return movieClipObject;
        }
        
        /**
         * 实例化时间轴播放控制器
         * @param movieClip 电影剪辑对象
         */
        public function TimelinePlayControl(movieClip:MovieClip)
        {
            this.movieClipObject = movieClip;
            playStatus = PlayStatus_Stop;
            endFrame = 0;
        }
        
        /**
         * 从当前帧顺序播放到指定帧
         * @param frame
         */
        public function PlayTo(frame:Object)
        {
            if (playStatus == PlayStatus_Stop)
                movieClipObject.addEventListener(Event.ENTER_FRAME, OnEnterFrame);
            playStatus = PlayStatus_Play;
            endFrame = GetFrame(frame);
            CheckEndFrame();
        }
        
        /**
         * 从当前帧倒序播放到指定帧
         * @param frame
         */
        public function PrevPlayTo(frame:Object)
        {
            if (playStatus == PlayStatus_Stop)
                movieClipObject.addEventListener(Event.ENTER_FRAME, OnEnterFrame);
            playStatus = PlayStatus_PrevPlay;
            endFrame = GetFrame(frame);
            CheckEndFrame();
        }
        
        /**
         * 从当前帧快跳播放到指定帧
         * @param status  播放速度，单位帧数，正数为顺播，负数为倒播
         * @param frame
         */
        public function FastPlayTo(status:int, frame:Object)
        {
            if (playStatus == PlayStatus_Stop)
                movieClipObject.addEventListener(Event.ENTER_FRAME, OnEnterFrame);
            playStatus = status;
            endFrame = GetFrame(frame);
            CheckEndFrame();
        }
        
        /**
         * 停止播放
         */
        public function Stop()
        {
            playStatus = PlayStatus_Stop;
        }
        
        private function OnEnterFrame(e:Event)
        {
            switch (playStatus)
            {
                case PlayStatus_Stop: 
                    movieClipObject.removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
                    break;
                case PlayStatus_Play: 
                    movieClipObject.nextFrame();
                    break;
                case PlayStatus_PrevPlay: 
                    movieClipObject.prevFrame();
                    break;
                default:
                    var gotoFrame:int = movieClipObject.currentFrame + playStatus;
                    if (playStatus > 0)
                    {
                        if(gotoFrame < endFrame)
                            movieClipObject.gotoAndStop(gotoFrame);
                        else
                            movieClipObject.gotoAndStop(endFrame);
                    }
                    else
                    {
                        if(gotoFrame > endFrame)
                            movieClipObject.gotoAndStop(gotoFrame);
                        else
                            movieClipObject.gotoAndStop(endFrame);
                    }
                    break;
            }
            
            if (movieClipObject.currentFrame == endFrame)
            {
                movieClipObject.removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
                playStatus = PlayStatus_Stop;
            }
        }
        
        // 获取帧数
        private function GetFrame(frame:Object):int
        {
            if (frame is int)
            {
                var frameInt:int = int(frame);
                if (frameInt > 0 && frameInt <= movieClipObject.totalFrames)
                    return frameInt;
                else
                    throw new Error("指定的 frame 超出范围. frame=" + frame)
            }
            else if (frame is String)
            {
                for each (var i:FrameLabel in movieClipObject.currentLabels)
                {
                    if (i.name == frame)
                        return i.frame;
                }
                throw new Error("指定的 frame 标签名找不到. frame=" + frame)
            }
            else
            {
                throw new Error("指定的 frame 类型错误. frame=" + frame)
            }
        }
        
        // 检查结束帧是否正常
        private function CheckEndFrame()
        {
            if (playStatus > 0)
            {
                if (movieClipObject.currentFrame > endFrame)
                {
                    trace("指定的 endFrame 无法到达，现已恢复. currentFrame=" + movieClipObject.currentFrame + ",endFrame=" + endFrame + ",playStatus=" + playStatus);
                    movieClipObject.gotoAndStop(endFrame);
                }
            }
            else if(playStatus < 0)
            {
                if (movieClipObject.currentFrame < endFrame)
                {
                    trace("指定的 EndFrame 无法到达，现已恢复. currentFrame=" + movieClipObject.currentFrame + ",endFrame=" + endFrame + ",playStatus=" + playStatus);
                    movieClipObject.gotoAndStop(endFrame);
                }
            }
        }
    
    }

}