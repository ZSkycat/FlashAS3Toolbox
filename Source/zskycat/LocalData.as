/**
 * 2016/11/29 16:06
 * @author ZSkycat
 */
package zskycat 
{
    import flash.net.SharedObject;
    
    /**
     * 本地数据的保存和读取
     */
    public class LocalData 
    {
        private var shareObject:SharedObject;
        private var localDataName:String;
        private var localPath:String;
        private var dataSize:int;
        
        /**
         * 获取 SharedObject
         */
        public function get ShareObject():SharedObject
        {
            return shareObject;
        }
        
        /**
         * 获取或设置 数据对象的大小
         */
        public function get DataSize():int
        {
            return dataSize;
        }
        public function set DataSize(value:int)
        {
            if(value > 0)
                dataSize = value;
            else
                throw new Error("指定的大小不能小于0. dataSize=" + value);
        }
        
        /**
         * 获取 数据对象的名称
         */
        public function get LocalDataName():String
        {
            return localDataName;
        }
        
        /**
         * 获取 数据对象的储存路径，用于共享访问
         */
        public function get LocalPath():String
        {
            return localPath;
        }
        
        /**
         * 获取 数据对象，该对象不能被直接覆盖
         */
        public function get Data():Object
        {
            return shareObject.data;
        }
        
        /**
         * 实例化 本地数据
         * @param dataSize  数据对象的大小
         * @param localDataName  数据对象的名称
         * @param localPath  数据对象的储存路径
         */
        public function LocalData(dataSize:int = 128, localDataName:String = "local", localPath:String = null)
        {
            DataSize = dataSize;
            this.localDataName = localDataName;
            this.localPath = localPath;
            shareObject = SharedObject.getLocal(localDataName);
        }
        
        /**
         * 读取数据辅助工具，支持设置默认值
         * @param data  数据
         * @param defaultData  当数据不存在时使用的默认数据
         * @param writeDefault  是否将默认值写入数据
         */
        public function GetData(data:Object, defaultData:Object, writeDefault:Boolean = false):Object
        {
            if (data == null)
            {
                if (writeDefault)
                    data = defaultData;
                return defaultData;
            }
            else
                return data;
        }
        
        /**
         * 将数据保存到本地文件，指定需要的空间大小，单位字节
         */
        public function Save()
        {
            shareObject.flush(dataSize);
        }
        
        /**
         * 清除数据
         */
        public function Clear()
        {
            shareObject.clear();
        }
        
    }

}