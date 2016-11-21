/**
 * @author ZSkycat
 */
package program
{
    import flash.display.MovieClip;
    import flash.external.ExternalInterface;
    import flash.system.fscommand;
    import zskycat.*;
    import zskycat.chart.*;
    
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
        
        // Demo 外部接口，交互方法总结
        private function ExternalInterfaceMethod()
        {
            // 发送 fscommand
            fscommand("command", "args");
            
            // 发送 call，支持任意多参数
            ExternalInterface.call("name", "arg1", "arg2", "...");
            
            // 接收 call，支持任意多参数
            ExternalInterface.addCallback("FunctionName", FunctionName);
        }
        private function FunctionName(arg1:Object, arg2:Object)
        {
        }
    
    }

}