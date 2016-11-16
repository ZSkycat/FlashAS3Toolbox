/**
 *
 * @author ZSkycat
 */
package zskycat.chart
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * 饼状图绘制器
	 */
	public class PieChart
	{
		private var container:DisplayObjectContainer;
		private var chartSprite:Sprite;
		// 状态控制
		private var isColor:Boolean;
		private var isBorder:Boolean;
		private var isOffset:Boolean;
		// 绘图数据
		private var centerX:Number;
		private var centerY:Number;
		private var radius:Number;
		private var beginRadian:Number;
		private var colorStyle:Array;
		private var borderStyle:Object;
		private var offset:Array;
		private var chartValue:Array;
		// 计算数据
		private var sectorStartRadian:Array;
		private var sectorRadian:Array;
		
		/**
		 * 获取或设置中心点 x 坐标
		 */
		public function get CenterX():Number
		{
			return centerX;
		}
		
		public function set CenterX(value:Number)
		{
			centerX = value;
		}
		
		/**
		 * 获取或设置中心点 y 坐标
		 */
		public function get CenterY():Number
		{
			return centerY;
		}
		
		public function set CenterY(value:Number)
		{
			centerY = value;
		}
		
		/**
		 * 获取或设置圆半径
		 */
		public function get Radius():Number
		{
			return radius;
		}
		
		public function set Radius(value:Number)
		{
			if (value <= 0)
				throw new Error("指定的半径不能小于等于0. Radius=" + value);
			else
				radius = value;
		}
		
		/**
		 * 获取或设置开始绘制的弧度，0为x轴右侧，顺时钟增加
		 */
		public function get BeginRadian():Number
		{
			return beginRadian;
		}
		
		public function set BeginRadian(value:Number)
		{
			beginRadian = value;
		}
		
		/**
		 * 获取或设置填充样式的数组，分别对应绘制的数值
		 * 子类型:object {color:uint, alpha:Number}  alpha 默认为 1
		 */
		public function get ColorStyle():Array
		{
			return colorStyle;
		}
		
		public function set ColorStyle(value:Array)
		{
			if (isColor == false)
				throw new Error("填充功能未启用");
			else
				colorStyle = value;
		}
		
		/**
		 * 获取或设置边框样式，全部扇形边框是统一的
		 * {thickness:Number, color:uint, alpha:Number}  alpha 默认为 1
		 */
		public function get BorderStyle():Object
		{
			return borderStyle;
		}
		
		public function set BorderStyle(value:Object)
		{
			if (isBorder == false)
				throw new Error("边框功能未启用");
			else
				borderStyle = value;
		}
		
		/**
		 * 获取或设置绘制扇形往外偏移量的数组，分别对应绘制的数值
		 * 子类型:uint  默认值为0
		 */
		public function get Offset():Array
		{
			return offset;
		}
		
		public function set Offset(value:Array)
		{
			
			if (isOffset == false)
				throw new Error("位移功能未启用");
			else
				offset = value;
		}
		
		/**
		 * 获取数据源
		 */
		public function get ChartValue():Array
		{
			return chartValue;
		}
		
		/**
		 * 实例化饼状图绘制器
		 * @param container
		 * @param isColor
		 * @param isBorderColor
		 * @param isOffset
		 */
		public function PieChart(container:DisplayObjectContainer, isColor:Boolean = true, isBorder:Boolean = false, isOffset:Boolean = false)
		{
			this.container = container;
			this.chartSprite = new Sprite();
			this.isColor = isColor;
			this.isBorder = isBorder;
			this.isOffset = isOffset;
		}
		
		public function Set()
		{
		
		}
		
		public function Draw(value:Array)
		{
			this.chartValue = value;
		}
		
		public function DrawNoCalc()
		{
		}
		
		private function CalcRadian()
		{
			// 统计数值总和
			var valueMax:Number = 0;
			for each (var j:Number in chartValue)
			{
				valueMax += j;
			}
			// 计算 开始弧度 和 弧度
			var currentRadian:Number = 0;
			for (var i:int = 0; i < chartValue.length - 1; i++)
			{
				sectorStartRadian[i] = currentRadian;
				sectorRadian[i] = chartValue[i] / valueMax * 2 * Math.PI;
				currentRadian += sectorRadian[i];
			}
			sectorStartRadian[chartValue.length] = currentRadian;
			sectorRadian[chartValue.length] = 2 * Math.PI - currentRadian;
		}
		
		public function DrawSector(sprite:Sprite, x:Number, y:Number, r:Number, startRadian:Number, radian:Number, colorStyle:Object, borderStyle:Object, offset:uint)
		{
            // 初始化画笔
			if (isColor)
				sprite.graphics.beginFill(colorStyle.color, colorStyle.alpha == undefined ? 1 : colorStyle.alpha);
            else
                sprite.graphics.endFill();
			if (isBorder)
				sprite.graphics.lineStyle(borderStyle.thickness, borderStyle.color, borderStyle.alpha == undefined ? 1 : borderStyle.alpha);
            else
                sprite.graphics.lineStyle();
            // 初始化圆心
			if (isOffset)
			{  //!!!!! 这里判断需要修改
                if (offset == undefined || offset == 0)
                {
                }
                else 
                {
				    x = x + offset * Math.cos(startRadian + radian / 2);
				    y = y + offset * Math.sin(startRadian + radian / 2);
                }
			}
			sprite.graphics.moveTo(x, y);
            
            // 绘制开始半径
			var beginX:Number = x + r * Math.cos(startRadian);
			var beginY:Number = y + r * Math.sin(startRadian);
			sprite.graphics.lineTo(beginX, beginY);
            
            // 绘制圆弧
			var controlX:Number;
			var controlY:Number;
			var anchorX:Number;
			var anchorY:Number;
            var curveNum:uint = Math.ceil(radian / 2 / Math.PI);  // 需要绘制n次贝塞尔曲线
            var curveRadian:Number = radian / curveNum;  // 每次绘制的弧度
			for (var i = 0; i < curveNum; i++)
            {
                controlX = x + r / Math.cos(curveRadian / 2) * Math.cos(startRadian + curveRadian / 2);
                controlY = y + r / Math.cos(curveRadian / 2) * Math.sin(startRadian + curveRadian / 2);
                anchorX = x + r * Math.cos(startRadian + curveRadian);
                anchorY = y + r * Math.sin(startRadian + curveRadian);
                sprite.graphics.curveTo(controlX, controlY, anchorX, anchorY);
                startRadian += curveRadian;
            }
            
            // 绘制结束半径
            if (radian < Math.PI * 2)
            {
                sprite.graphics.lineTo(x, y);
            }
            
            // 清理画笔
			if (isColor)
				sprite.graphics.endFill();
			if (isBorder)
				sprite.graphics.lineStyle();
		}
	
	}

}