/**
 * 2016/11/9 16:17
 * @author ZSkycat
 */
package zskycat
{
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.ui.Mouse;
    import flash.utils.Timer;
    
    /**
     * 鼠标自动隐藏控制器
     */
    public class MouseControl
    {
        private var stage:Stage;
        private var delayMax:int;
        private var timer:Timer;
        
        private var delay:int;
        private var isShow:Boolean;
        
        /**
         * 鼠标静止经过的时间，单位秒，到达 delayMax 时触发鼠标隐藏
         */
        public function get Delay():int
        {
            return delay;
        }
        public function set Delay(value:int)
        {
            delay = value;
        }
        
        /**
         * 鼠标状态，true为显示，false为隐藏
         */
        public function get IsShow():Boolean
        {
            return isShow;
        }
        
        /**
         * 实例化鼠标自动隐藏控制器，移动或点击鼠标时显示，经过指定时间后隐藏
         * @param stage  舞台对象
         * @param delayMax  自动隐藏的时间，单位秒
         * @param isShow  当前鼠标状态
         */
        public function MouseControl(stage:Stage, delayMax:int, isShow:Boolean = true)
        {
            this.stage = stage;
            this.delayMax = delayMax;
            this.isShow = isShow;
            timer = new Timer(1000);
            
            stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouse);
            stage.addEventListener(MouseEvent.CLICK, OnMouse);
            timer.addEventListener(TimerEvent.TIMER, OnTimer);
            timer.start();
        }
        
        /**
         * 释放资源，不影响鼠标状态
         */
        public function Dispose()
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouse);
            stage.removeEventListener(MouseEvent.CLICK, OnMouse);
            timer.removeEventListener(TimerEvent.TIMER, OnTimer);
            stage = null;
        }
        
        /**
         * 显示鼠标
         */
        public function Show()
        {
            if (isShow)
            {
            }
            else
            {
                Mouse.show();
                timer.addEventListener(TimerEvent.TIMER, OnTimer);
                timer.start();
                isShow = true;
            }
            delay = 0;
        }
        
        /**
         * 隐藏鼠标
         */
        public function Hide()
        {
            if (isShow)
            {
                Mouse.hide();
                timer.removeEventListener(TimerEvent.TIMER, OnTimer);
                timer.reset();
                isShow = false;
            }
            else
            {
            }
        }
        
        private function OnMouse(e:MouseEvent)
        {
            Show();
        }
        
        private function OnTimer(e:TimerEvent)
        {
            delay++;
            if (delay >= delayMax)
                Hide();
        }
    
    }

}