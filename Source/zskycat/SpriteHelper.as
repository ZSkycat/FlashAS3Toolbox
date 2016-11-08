/**
 * 2016/11/8 10:48
 * @author ZSkycat
 */
package zskycat 
{
	import flash.display.Sprite;
	import flash.events.Event;
    
    public class SpriteHelper extends Sprite 
    {
		private var eventList:Array = [];
		
        /**
         * @param isInit  true为使用初始化，false为不使用初始化
         */
        public function SpriteHelper(isInit:Boolean = false) 
        {
			if (isInit)
				addEventListenerAutoRemove(Event.ADDED_TO_STAGE, OnAddedToStage);
			addEventListenerAutoRemove(Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
        }
		
		/**
		 * 注册当前对象 指定事件 的 侦听器，并且当对象被移出舞台时，自动删除该侦听器
		 * @param type  事件的类型
		 * @param listener  处理事件的侦听器函数
		 * @param useCapture  true为只在捕获阶段处理事件，false为在目标阶段或冒泡阶段处理事件
		 * @param priority  事件的优先级，值越大，优先级越高
		 * @param useWeakReference  true为弱引用，false为强引用
		 */
		public function addEventListenerAutoRemove(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			addEventListener(type, listener, useCapture, priority, useWeakReference);
			eventList.push([type, listener, useCapture]);
		}
		
		private function OnAddedToStage(e:Event):void
		{
			Initialize();
		}
		
		private function OnRemovedFromStage(e:Event):void
		{
			for each (var list:Array in eventList)
			{
				removeEventListener(list[0], list[1], list[2]);
			}
			Dispose();
		}
		
		/**
		 * 当对象添加进舞台时执行，用于覆写 override
		 */
		public function Initialize():void
		{
		}
		
		/**
		 * 当对象被移出舞台时执行，用于覆写 override
		 */
		public function Dispose():void
		{
		}
        
    }

}