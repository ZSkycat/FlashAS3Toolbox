/**
 * 2016/11/21 17:10
 * @author ZSkycat
 * 
 * Demo
 * var pc:PieChart = new PieChart(stage, true, true, true);
 * var cs:Array = [{color: 0xff0000}, {color:  0x00ff00}, {color:  0x0000ff}];
 * var os:Array = [0, 20, 0];
 * pc.SetConfig(200, 200, 100, 270, cs, {thickness: 1,color: 0xffffff}, os);
 * pc.Draw([888, 666, 777]);
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
		private var sectorStartRadian:Array = [];
		private var sectorRadian:Array = [];
		
		/**
		 * 获取图表 Sprite
		 */
		public function get ChartSprite():Sprite
		{
			return chartSprite;
		}
        
        /**
         * 获取或设置填充功能
         */
        public function get IsColor():Boolean 
        {
            return isColor;
        }
        public function set IsColor(value:Boolean):void 
        {
            isColor = value;
        }
        
        /**
         * 获取或设置边框功能
         */
        public function get IsBorder():Boolean 
        {
            return isBorder;
        }
        public function set IsBorder(value:Boolean):void 
        {
            isBorder = value;
        }
        
        /**
         * 获取或设置偏移功能
         */
        public function get IsOffset():Boolean 
        {
            return isOffset;
        }
        public function set IsOffset(value:Boolean):void 
        {
            isOffset = value;
        }
		
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
			borderStyle = value;
		}
		
		/**
		 * 获取或设置绘制扇形往外偏移量的数组，分别对应绘制的数值
		 * 子类型:int  默认值为0
		 */
		public function get Offset():Array
		{
			return offset;
		}
		public function set Offset(value:Array)
		{
			offset = value;
		}
		
		/**
		 * 获取图表数据
		 */
		public function get ChartValue():Array
		{
			return chartValue;
		}
		
		/**
		 * 实例化饼状图绘制器
		 * @param container  容器
		 * @param isColor  是否启用填充功能
		 * @param isBorderColor  是否启用边框功能
		 * @param isOffset  是否启用偏移功能
		 */
		public function PieChart(container:DisplayObjectContainer, isColor:Boolean = true, isBorder:Boolean = false, isOffset:Boolean = false)
		{
			this.container = container;
			this.isColor = isColor;
			this.isBorder = isBorder;
			this.isOffset = isOffset;
            chartSprite = new Sprite();
            this.container.addChild(chartSprite);
		}
		
        /**
         * 配置基本属性，后3个参数使用 null 表示不修改
         * @param centerX  中心点 X 坐标
         * @param centerY  中心点 Y 坐标
         * @param radius  半径
         * @param beginAngle  开始渲染角度
         * @param ColorStyle  填充样式数组
         * @param BorderStyle  边框样式
         * @param Offset  偏移量数组
         */
		public function SetConfig(centerX:Number, centerY:Number, radius:Number, beginAngle:Number = 270, ColorStyle:Array = null, BorderStyle:Object = null, Offset:Array = null)
		{
			this.CenterX = centerX;
			this.CenterY = centerY;
			this.Radius = radius;
			this.BeginRadian = beginAngle * Math.PI / 180;
			this.ColorStyle = colorStyle == null ? ColorStyle : colorStyle;
			this.BorderStyle = borderStyle == null ? BorderStyle : borderStyle;
			this.Offset = offset == null ? Offset : offset;
		}
		
		/**
		 * 绘制图表
		 * @param value  图表数据
		 */
		public function Draw(value:Array)
		{
			this.chartValue = value;
			CalcRadian();
			for (var i:int; i < chartValue.length; i++)
			{
				DrawSector(chartSprite, centerX, centerY, radius, sectorStartRadian[i], sectorRadian[i], colorStyle[i], borderStyle, offset[i]);
			}
		}
		
		/**
		 * 绘制图表，不更新数据
		 */
		public function DrawNoData()
		{
			if (chartValue == null)
				throw new Error("没有输入图表数据.");
			else
			{
				for (var i:int; i < chartValue.length; i++)
				{
					DrawSector(chartSprite, centerX, centerY, radius, sectorStartRadian[i], sectorRadian[i], colorStyle[i], borderStyle, offset[i]);
				}
			}
		}
		
		// 计算弧度
		private function CalcRadian()
		{
			// 统计数值总和
			var valueMax:Number = 0;
			for each (var j:Number in chartValue)
			{
				valueMax += j;
			}
			// 计算 开始弧度 和 弧度
			var currentRadian:Number = beginRadian;
			for (var i:int = 0; i < chartValue.length; i++)
			{
				sectorStartRadian[i] = currentRadian;
				sectorRadian[i] = chartValue[i] / valueMax * 2 * Math.PI;
				currentRadian += sectorRadian[i];
			}
		}
		
		// 绘制扇形
		private function DrawSector(sprite:Sprite, x:Number, y:Number, r:Number, startRadian:Number, radian:Number, colorStyle:Object, borderStyle:Object, offset:int)
		{
			// 初始化画笔
			if (isColor)
				sprite.graphics.beginFill(colorStyle.color, colorStyle.alpha === undefined ? 1 : colorStyle.alpha);
			else
				sprite.graphics.endFill();
			if (isBorder)
				sprite.graphics.lineStyle(borderStyle.thickness, borderStyle.color, borderStyle.alpha === undefined ? 1 : borderStyle.alpha);
			else
				sprite.graphics.lineStyle();
			// 初始化圆心
			if (isOffset)
			{
				if (offset <= 0)
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
			var curveNum:uint = Math.ceil(radian / Math.PI * 4);  // 需要绘制n次贝塞尔曲线 (贝塞尔曲线绘制圆弧最大角度是45°，为减小误差，这里处理成最大22.5°)
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