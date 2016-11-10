/**
 * @author ZSkycat
 */
package program
{
	import zskycat.*;
    import flash.display.MovieClip;
	
	public class Root extends MovieClip
	{
		public function Root()
		{
		}
		
		// Demo 发送事件
		private function DispatchUpdata()
		{
			var event:CustomEvent = new CustomEvent(CustomEvent.Updata);
            event.data = {};
			dispatchEvent(event);
		}
	
	}

}