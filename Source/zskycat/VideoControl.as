/**
 * 2016/11/7 16:21
 * @author ZSkycat
 */
package zskycat
{
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
    import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
    /**
     * 本地视频播放控制器
     */
	public class VideoControl
	{
		private var netCon:NetConnection;
		private var netStr:NetStream;
		private var video:Video;
		
		private var isPlay:Boolean;		
		private var isLoop:Boolean;
		
        /**
         * 获取对象 NetConnection
         */
        public function get NetConnectionObject():NetConnection
        {
            return netCon;
        }
        
		/**
		 * 获取视频流对象 NetStream
		 */
		public function get NetStreamObject():NetStream
		{
			return netStr;
		}
        
		/**
		 * 获取视频对象 Video，用于添加进舞台
		 */
		public function get VideoObject():Video
		{
			return video;
		}
		
		/**
		 * 获取视频文件路径
		 */
		public function get FilePath():String
		{
			return netStr.info.resourceName;
		}
		
		/**
		 * 获取视频总长度，单位秒
		 */
		public function get TimeTotal():Number
		{
			return netStr.info.metaData.duration;
		}
		
		/**
		 * 获取当前播放时间位置，单位秒
		 */
		public function get TimeCurrent():Number
		{
			return netStr.time;
		}
		
		/**
		 * 获取是否正在播放
		 */
		public function get IsPlay():Boolean
		{
			return isPlay;
		}
        
        /**
         * 获取或设置是否循环播放
         */
        public function get IsLoop():Boolean
        {
            return isLoop;
        }
        public function set IsLoop(value:Boolean)
        {
            isLoop = value;
        }
		
		/**
		 * 实例化本地视频播放控制器
		 * @param width  宽度
		 * @param height  高度
		 * @param smoothing  平滑化，true是启用，false是禁用
		 */
		public function VideoControl(width:int = 320, height:int = 240, smoothing:Boolean = true)
		{
			netCon = new NetConnection();
			netCon.connect(null);
			netStr = new NetStream(netCon);
            netStr.client = {};  //client 对象不能为 null
			video = new Video(width, height);
			video.smoothing = smoothing;
			video.attachNetStream(netStr);
			
			netStr.addEventListener(NetStatusEvent.NET_STATUS, OnNetStatus);
		}
		
		/**
		 * 释放资源
		 */
		public function Dispose()
		{
			video.clear();
			netStr.removeEventListener(NetStatusEvent.NET_STATUS, OnNetStatus);
			netStr.dispose();
			netCon.close();
		}
		
		/**
		 * 开始播放指定的文件
		 * @param path  文件路径
		 */
		public function Play(path:String)
		{
			netStr.play(path);
            isPlay = true;
		}
		
		/**
		 * 暂停
		 */
		public function Pause()
		{
			netStr.pause();
            isPlay = false;
		}
		
		/**
		 * 恢复
		 */
		public function Resume()
		{
			netStr.resume();
            isPlay = true;
		}
		
		/**
		 * 暂停或恢复
		 */
		public function PauseToggle()
		{
			netStr.togglePause();
            isPlay = !isPlay;
		}
		
		/**
		 * 重播
		 */
		public function Replay()
		{
			netStr.seek(0);
		}
		
		/**
		 * 快进或快退
		 * @param time  单位是秒，正数是快进，负数是快退
		 */
		public function JumpAtCurrent(time:Number)
		{
			netStr.seek(netStr.time + time);
		}
		
		/**
		 * 跳转到指定时间
		 * @param time  单位是秒
		 */
		public function JumpToTime(time:Number)
		{
			netStr.seek(time);
		}
		
		/**
		 * 清除 Video 对象当前显示的图像
		 */
		public function Clear()
		{
			video.clear();
		}
        
        /**
         * 音量增加或减小
         * @param volume  标准值范围0-1，正数增加，负数减小
         * @param volumeMax  音量最大值，默认为1
         */
        public function VolumeUpOrDown(volume:Number, volumeMax:Number = 1)
        {
            var currentVolume:Number = netStr.soundTransform.volume + volume;
            if (currentVolume < 0)
                netStr.soundTransform = new SoundTransform(0);
            else if(currentVolume > volumeMax)
                netStr.soundTransform = new SoundTransform(volumeMax);
            else
                netStr.soundTransform = new SoundTransform(currentVolume);
        }
        
        /**
         * 音量设置为指定值
         * @param volume  标准值范围0-1
         * @param volumeMax  音量最大值，默认为1
         */
        public function VolumeTo(volume:Number, volumeMax:Number = 1)
        {
            if(volume < 0)
                netStr.soundTransform = new SoundTransform(0);
            else if(volume > volumeMax)
                netStr.soundTransform = new SoundTransform(volumeMax);
            else
                netStr.soundTransform = new SoundTransform(volume);
        }
		
		// 状态变化事件
		private function OnNetStatus(e:NetStatusEvent)
		{
			switch (e.info.code)
			{
			case "NetStream.Play.Stop":  //播放结束
				if (isLoop)
					Replay();
				break;
			case "NetStream.Play.StreamNotFound":  //路径错误
                trace("找不到文件 " + netStr.info.resourceName);
				break;
            case "NetStream.Play.Failed":  //未知错误
                trace("未知错误，可能是没有读取权限");
                break;
			}
		}
	
	}

}