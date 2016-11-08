/**
 * 2016/8/25 17:48
 * @author ZSkycat
 */
package zskycat
{
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
        //事件类型
        public static const Updata:String = "Updata";
        
        //事件数据
        public var data:Object = {};
		
        /**
         * 实例化自定义事件
         * @param type  CustomEvent 事件的类型
         * @param bubbles  true为冒泡事件，false为不冒泡
         * @param cancelable  true为可以阻止默认行为，false为不可以
         */
		public function CustomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var e:CustomEvent = new CustomEvent(type, bubbles, cancelable);
			e.data = this.data;
			return e;
		}
		
		public override function toString():String
		{
			return formatToString("CustomEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	
	}

}