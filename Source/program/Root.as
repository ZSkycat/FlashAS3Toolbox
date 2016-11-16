/**
 * @author ZSkycat
 */
package program
{
    import zskycat.*;
    import zskycat.chart.*;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.external.ExternalInterface;
    import flash.system.fscommand;
    
    public class Root extends MovieClip
    {
        public function Root()
        {
            DrawSector(this);
            DrawSector(this, 200, 200, 100, 27, 299, 0x00ff00);
            var a = [];
            a[5] = 5;
            trace(a[0] as uint);
            var pc:PieChart = new PieChart(null,true,false,true);
            pc.DrawSector(this, 300, 300, 100, 0, 1, {color: 0xff0000}, null, 0);
            pc.DrawSector(this, 300, 300, 100, 1, 1, {color: 0xff0000}, null, 10);
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
        
        
        
        private function DrawSector(mc:Sprite, x:Number = 200, y:Number = 200, r:Number = 100, angle:Number = 27, startFrom:Number = 270, color:Number = 0xff0000)
		{
			mc.graphics.beginFill(color, 50);
			//remove this line to unfill the sector
			/* the border of the secetor with color 0xff0000 (red) , you could replace it with any color
			 * you want like 0x00ff00(green) or 0x0000ff (blue).
			 */
			// mc.graphics.lineStyle(0,0xff0000);  //自定义颜色
			mc.graphics.lineStyle(0, color);   //使用传递进来的颜色
			mc.graphics.moveTo(x, y);
			angle = (Math.abs(angle) > 360) ? 360 : angle;
			var n:Number = Math.ceil(Math.abs(angle) / 45);
			var angleA:Number = angle / n;
			angleA = angleA * Math.PI / 180;
			startFrom = startFrom * Math.PI / 180;
			mc.graphics.lineTo(x + r * Math.cos(startFrom), y + r * Math.sin(startFrom));
			for (var i = 1; i <= n; i++)
			{
				startFrom += angleA;
				var angleMid = startFrom - angleA / 2;
				var bx = x + r / Math.cos(angleA / 2) * Math.cos(angleMid);
				var by = y + r / Math.cos(angleA / 2) * Math.sin(angleMid);
				var cx = x + r * Math.cos(startFrom);
				var cy = y + r * Math.sin(startFrom);
				mc.graphics.curveTo(bx, by, cx, cy);
			}
			if (angle != 360)
			{
				mc.graphics.lineTo(x, y);
			}
			mc.graphics.endFill();
		}
    
    }

}