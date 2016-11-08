/**
 * 2016/11/8 17:55
 * @author ZSkycat
 */
package zskycat
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 场景切换控制器
	 */
	public class SceneControl
	{
		private var sceneContainer:DisplayObjectContainer;
		private var currentScene:DisplayObjectContainer;
		private var currentSceneName:String;
		
		/**
		 * 获取当前的场景对象
		 */
		public function get CurrentScene():DisplayObjectContainer
		{
			return currentScene;
		}
		
		/**
		 * 获取当前的场景名称
		 */
		public function get CurrentSceneName():String
		{
			return currentSceneName;
		}
		
		/**
		 * 实例化场景切换控制器
		 * @param container  父容器对象
		 */
		public function SceneControl(container:DisplayObjectContainer)
		{
			sceneContainer = container;
		}
		
		/**
		 * 切换到指定的场景
		 * @param sceneName  场景的名称
		 */
		public function ChangeScene(sceneName:String)
		{
			if (currentScene != null)
				sceneContainer.removeChild(currentScene);
			currentSceneName = sceneName;
			switch (sceneName)
			{
                //自定义场景名和场景区域
                case "scene1":
                    currentScene = new DisplayObjectContainer();
                    break;
                default:
                    throw new Error("找不到场景. sceneName=" + sceneName);
			}
			sceneContainer.addChild(currentScene);
		}
		
		/**
		 * 删除当前场景
		 */
		public function RemoveScene()
		{
			if (currentScene != null)
			{
				sceneContainer.removeChild(currentScene);
				currentScene = null;
				currentSceneName = null;
			}
		}
	
	}

}