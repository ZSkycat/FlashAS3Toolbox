/**
 * 2016/11/23 14:29
 * @author ZSkycat
 */
package zskycat
{
    import adobe.utils.CustomActions;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    /**
     * Debug 输出框，支持滚轮滑动。
     */
    public class DebugText
    {
        private static var instance:DebugText;
        private var txt:TextField;
        private var sprite:Sprite;
        private var container:DisplayObjectContainer;
        private var separator:String = ", ";
        
        /**
         * 获取最后创建的实例
         */
        public static function get Instance():DebugText
        {
            return instance;
        }
        
        /**
         * 获取文本框对象 TextField
         */
        public function get TextFieldObject():TextField
        {
            return txt;
        }
        
        /**
         * 获取或设置分隔符，用于多参数输出的分隔符，默认为 ", "
         */
        public function get Separator():String
        {
            return separator;
        }
        public function set Separator(value:String)
        {
            separator = value;
        }
        
        /**
         * 实例化 Debug 输出框，请使用 Instance 单例对象输出
         * @param cont  父容器对象，请使用顶层容器如 stage root
         * @param h  输出框高度
         * @param fontSize  字体大小
         */
        public function DebugText(cont:DisplayObjectContainer, h:Number = 100, fontSize = 15)
        {
            // 设置容器 宽度 高度
            container = cont;
            var width:Number = container.stage.stageWidth - 4;  // -4 是去掉边框大小
            var height:Number = h - 4;  // -4 是去掉边框大小
            // 定义 Sprite 背景
            sprite = new Sprite();
            sprite.name = "DebugText";
            sprite.graphics.lineStyle(2, 0x00BBBB);
            sprite.graphics.beginFill(0x008080, 0.5);
            sprite.graphics.drawRect(2, 2, width, height);
            // 定义文本默认样式
            var txtFormat:TextFormat = new TextFormat();
            txtFormat.color = 0xFF0000;
            txtFormat.size = fontSize;
            // 定义文本
            txt = new TextField();
            txt.multiline = true;
            txt.wordWrap = true;
            txt.mouseWheelEnabled = true;
            txt.x = 2;
            txt.y = 2;
            txt.width = width;
            txt.height = height;
            txt.defaultTextFormat = txtFormat;
            txt.setTextFormat(txtFormat);
            Clear();
            
            sprite.addChild(txt);
            container.addChild(sprite);
            instance = this;
        }
        
        /**
         * 释放资源
         */
        public function Dispose()
        {
            container.removeChild(sprite);
            instance = null;
        }
        
        /**
         * 输出文本到屏幕
         */
        public function Trace(... rest:Array)
        {
            var first:Boolean = true;
            txt.appendText("\n");
            for each (var obj in rest)
            {
                if (first)
                {
                    txt.appendText("> " + obj.toString());
                    first = false;
                }
                else
                    txt.appendText(separator + obj.toString());
            }
            // 置顶输出框
            container.setChildIndex(sprite, container.numChildren - 1);
            // 滚动到最底
            txt.scrollV = txt.numLines;
        }
        
        /**
         * 清空并重置输出框
         */
        public function Clear()
        {
            txt.text = "[Debug]";
        }
    
    }

}