/**
 * 2017/01/22 04:26
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
         * @param initMode  初始化模式
         * 0-不启用 1-Event.OnAddedToStage 2-Event.EXIT_FRAME
         */
        public function SpriteHelper(initMode:int = 0) 
        {
            switch(initMode)
            {
                case 0:
                    break;
                case 1:
                    addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
                    break;
                case 2:
                    addEventListener(Event.EXIT_FRAME, OnExitFrame);
                    break;
            }
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
            removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
            Initialize();
        }
        
        private function OnExitFrame(e:Event):void
        {
            removeEventListener(Event.EXIT_FRAME, OnExitFrame);
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