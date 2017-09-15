// 2016.12.23 11:42
// Author: ZSkycat

using System;
using System.Collections;
using System.Xml;

namespace ZSkycat
{
    /// <summary>
    /// Flash 外部API 的 xml 处理类，支持链式调用
    /// </summary>
    public class FlashApiXmlHandler
    {
        // 参数类型常量
        private const string TYPE_null = "null";
        private const string TYPE_true = "true";
        private const string TYPE_false = "false";
        private const string TYPE_string = "string";
        private const string TYPE_number = "number";  // Flash中的 int uint number 互转 .NET 中的 int uint double
        private const string TYPE_array = "array";  // Flash中的 Array 互转 .NET 中的 ArrayList
        private const string TYPE_object = "object";  // Flash中的 Object 互转 .NET 中的 Hashtable

        private XmlDocument xmlDoc;
        private XmlElement xmlArguments;

        /// <summary>
        /// 实例化 FlashApiXmlHandler
        /// </summary>
        /// <param name="funcName">调用的函数名称</param>
        public FlashApiXmlHandler(string funcName)
        {
            xmlDoc = new XmlDocument();
            // 创建节点和属性
            XmlElement invoke = xmlDoc.CreateElement("invoke");
            xmlArguments = xmlDoc.CreateElement("arguments");
            XmlAttribute name = xmlDoc.CreateAttribute("name");
            name.Value = funcName;
            XmlAttribute returntype = xmlDoc.CreateAttribute("returntype");
            returntype.Value = "xml";
            // 添加节点和属性
            xmlDoc.AppendChild(invoke);
            invoke.Attributes.Append(name);
            invoke.Attributes.Append(returntype);
            invoke.AppendChild(xmlArguments);
        }

        /// <summary>
        /// 获取转化后的 xml 数据
        /// </summary>
        public string GetXmlString()
        {
            return xmlDoc.InnerXml;
        }

        #region 添加参数
        /// <summary>
        /// 添加 null 类型参数
        /// </summary>
        public FlashApiXmlHandler Add()
        {
            HandleArgument(TYPE_null);
            return this;
        }

        /// <summary>
        /// 添加 bool 类型参数
        /// </summary>
        public FlashApiXmlHandler Add(bool b)
        {
            if (b)
                HandleArgument(TYPE_true);
            else
                HandleArgument(TYPE_false);
            return this;
        }

        /// <summary>
        /// 添加 string 类型参数，如果值为 null 将处理成 null 类型
        /// </summary>
        public FlashApiXmlHandler Add(string str)
        {
            if (str == null)
                HandleArgument(TYPE_null);
            else
                HandleArgument(TYPE_string, str);
            return this;
        }

        /// <summary>
        /// 添加 int 类型参数
        /// </summary>
        public FlashApiXmlHandler Add(int number)
        {
            HandleArgument(TYPE_number, number.ToString());
            return this;
        }

        /// <summary>
        /// 添加 uint 类型参数
        /// </summary>
        public FlashApiXmlHandler Add(uint number)
        {
            HandleArgument(TYPE_number, number.ToString());
            return this;
        }

        /// <summary>
        /// 添加 double 类型参数
        /// </summary>
        public FlashApiXmlHandler Add(double number)
        {
            HandleArgument(TYPE_number, number.ToString());
            return this;
        }

        /// <summary>
        /// 添加 IList(ArrayList) 类型参数，如果值为 null 将处理成 null 类型
        /// </summary>
        public FlashApiXmlHandler Add(IList arrayList)
        {
            if (arrayList == null)
                HandleArgument(TYPE_null);
            else
                HandleArgument(xmlArguments, arrayList);
            return this;
        }

        /// <summary>
        /// 添加 IDictionary(Hashtable)(key必须为string) 类型参数，如果值为 null 将处理成 null 类型
        /// </summary>
        public FlashApiXmlHandler Add(IDictionary hashtable)
        {
            if (hashtable == null)
                HandleArgument(TYPE_null);
            else
                HandleArgument(xmlArguments, hashtable);
            return this;
        }

        /// <summary>
        /// 处理成 flash.null 或 flash.true 或 flash.false
        /// </summary>
        private void HandleArgument(string type)
        {
            XmlElement arg = xmlDoc.CreateElement(type);
            xmlArguments.AppendChild(arg);
        }


        /// <summary>
        /// 处理成 flash.string 或 flash.number
        /// </summary>
        private void HandleArgument(string type, string value)
        {
            XmlElement arg = xmlDoc.CreateElement(type);
            arg.InnerText = value;
            xmlArguments.AppendChild(arg);
        }

        /// <summary>
        /// 将 IList(ArrayList) 类型处理成 flash.array
        /// </summary>
        private void HandleArgument(XmlElement xml, IList arrayList)
        {
            // 创建 <array></array> 节点
            XmlElement args = xmlDoc.CreateElement(TYPE_array);
            xml.AppendChild(args);
            for (int i = 0; i < arrayList.Count; i++)
            {
                // 创建 <property id="1"></property> 节点
                XmlElement property = xmlDoc.CreateElement("property");
                XmlAttribute pId = xmlDoc.CreateAttribute("id");
                pId.Value = i.ToString();
                property.Attributes.Append(pId);

                // 判断对象类型并处理成 xml
                if (arrayList[i] == null)  // null
                {
                    XmlElement argXml = xmlDoc.CreateElement(TYPE_null);
                    property.AppendChild(argXml);
                }
                else if (arrayList[i] is bool)  // true false
                {
                    XmlElement argXml;
                    if ((bool)arrayList[i])
                        argXml = xmlDoc.CreateElement(TYPE_true);
                    else
                        argXml = xmlDoc.CreateElement(TYPE_false);
                    property.AppendChild(argXml);
                }
                else if (arrayList[i] is string)  // string
                {
                    XmlElement argXml = xmlDoc.CreateElement(TYPE_string);
                    argXml.InnerText = arrayList[i].ToString();
                    property.AppendChild(argXml);
                }
                else if (arrayList[i] is int || arrayList[i] is uint || arrayList[i] is double)  // number
                {
                    XmlElement argXml = xmlDoc.CreateElement(TYPE_number);
                    argXml.InnerText = arrayList[i].ToString();
                    property.AppendChild(argXml);
                }
                else if (arrayList[i] is IList)  // array
                {
                    HandleArgument(property, (IList)arrayList[i]);
                }
                else if (arrayList[i] is IDictionary)  // object
                {
                    HandleArgument(property, (IDictionary)arrayList[i]);
                }
                else
                    throw new ArgumentException("不支持处理该类型", $"{nameof(arrayList)}[{i}]");

                // 添加 <property> 节点
                args.AppendChild(property);
            }
        }

        /// <summary>
        /// 将 IDictionary(Hashtable) 类型处理成 flash.object
        /// </summary>
        private void HandleArgument(XmlElement xml, IDictionary hashtable)
        {
            // 创建 <object></object> 节点
            XmlElement args = xmlDoc.CreateElement(TYPE_object);
            xml.AppendChild(args);
            foreach (DictionaryEntry o in hashtable)
            {
                // 创建 <property id="1"></property> 节点
                XmlElement property = xmlDoc.CreateElement("property");
                XmlAttribute pId = xmlDoc.CreateAttribute("id");
                if (o.Key is string)  // 检测 key 是否为 string 类型
                    pId.Value = o.Key.ToString();
                else
                    throw new ArgumentException("不支持处理 IDictionary(key不是string) 类型", $"{nameof(hashtable)}[{o.Key.ToString()}]");
                property.Attributes.Append(pId);

                // 判断对象类型并处理成 xml
                if (o.Value == null)  // null
                {
                    XmlElement argXml = xmlDoc.CreateElement(TYPE_null);
                    property.AppendChild(argXml);
                }
                else if (o.Value is bool)  // true false
                {
                    XmlElement argXml;
                    if ((bool)o.Value)
                        argXml = xmlDoc.CreateElement(TYPE_true);
                    else
                        argXml = xmlDoc.CreateElement(TYPE_false);
                    property.AppendChild(argXml);
                }
                else if (o.Value is string)  // string
                {
                    XmlElement argXml = xmlDoc.CreateElement(TYPE_string);
                    argXml.InnerText = o.Value.ToString();
                    property.AppendChild(argXml);
                }
                else if (o.Value is int || o.Value is uint || o.Value is double)  // number
                {
                    XmlElement argXml = xmlDoc.CreateElement(TYPE_number);
                    argXml.InnerText = o.Value.ToString();
                    property.AppendChild(argXml);
                }
                else if (o.Value is IList)  // array
                {
                    HandleArgument(property, (IList)o.Value);
                }
                else if (o.Value is IDictionary)  // object
                {
                    HandleArgument(property, (IDictionary)o.Value);
                }
                else
                    throw new ArgumentException("不支持处理该类型", $"{nameof(hashtable)}[{o.Key.ToString()}]");

                // 添加 <property> 节点
                args.AppendChild(property);
            }
        }
        #endregion

        #region 静态解析器
        /// <summary>
        /// 解析 xml 字符串，返回 ArrayList
        /// <param name="xmlString">xml 字符串</param>
        /// <param name="funcName">调用的函数名称</param>
        /// </summary>
        public static ArrayList ParseXmlString(string xmlString, out string funcName)
        {
            // 加载 xml
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(xmlString);
            // 读取 funcName
            funcName = xmlDoc.DocumentElement.Attributes["name"].Value;
            // 读取参数
            XmlNodeList xmlList = xmlDoc.SelectNodes("/invoke/arguments/*");
            ArrayList args = new ArrayList();
            foreach (XmlNode i in xmlList)
            {
                switch (i.Name)
                {
                    case TYPE_null:
                        args.Add(null);
                        break;
                    case TYPE_true:
                        args.Add(true);
                        break;
                    case TYPE_false:
                        args.Add(false);
                        break;
                    case TYPE_string:
                        args.Add(i.InnerText);
                        break;
                    case TYPE_number:
                        args.Add(ParseNumber(i.InnerText));
                        break;
                    case TYPE_array:
                        var arrayList = ParseArray(i.SelectNodes("property"));
                        args.Add(arrayList);
                        break;
                    case TYPE_object:
                        var hashtable = ParseObject(i.SelectNodes("property"));
                        args.Add(hashtable);
                        break;
                    default:
                        throw new ArgumentException("不支持解析该类型", i.OuterXml);
                }
            }
            return args;
        }

        /// <summary>
        /// falsh.number 类型解析器
        /// </summary>
        private static object ParseNumber(string number)
        {
            int i;
            uint ui;
            double d;
            if (int.TryParse(number, out i))
                return i;
            else if (uint.TryParse(number, out ui))
                return ui;
            else if (double.TryParse(number, out d))
                return d;
            throw new ArgumentException("转换成数值类型失败", number);
        }

        /// <summary>
        /// falsh.array 类型解析器
        /// </summary>
        private static ArrayList ParseArray(XmlNodeList xmlList)
        {
            ArrayList args = new ArrayList();
            foreach (XmlNode property in xmlList)
            {
                XmlNode i = property.ChildNodes[0];
                switch (i.Name)
                {
                    case TYPE_null:
                        args.Add(null);
                        break;
                    case TYPE_true:
                        args.Add(true);
                        break;
                    case TYPE_false:
                        args.Add(false);
                        break;
                    case TYPE_string:
                        args.Add(i.InnerText);
                        break;
                    case TYPE_number:
                        args.Add(ParseNumber(i.InnerText));
                        break;
                    case TYPE_array:
                        var arrayList = ParseArray(property.SelectNodes("property"));
                        args.Add(arrayList);
                        break;
                    case TYPE_object:
                        var hashtable = ParseObject(property.SelectNodes("property"));
                        args.Add(hashtable);
                        break;
                    default:
                        throw new ArgumentException("不支持解析该类型", property.OuterXml);
                }
            }
            return args;
        }

        /// <summary>
        /// falsh.object 类型解析器
        /// </summary>
        private static Hashtable ParseObject(XmlNodeList xmlList)
        {
            Hashtable args = new Hashtable();
            foreach (XmlNode property in xmlList)
            {
                string key = property.Attributes["id"].Value;
                XmlNode i = property.ChildNodes[0];
                switch (i.Name)
                {
                    case TYPE_null:
                        args.Add(key, null);
                        break;
                    case TYPE_true:
                        args.Add(key, true);
                        break;
                    case TYPE_false:
                        args.Add(key, false);
                        break;
                    case TYPE_string:
                        args.Add(key, i.InnerText);
                        break;
                    case TYPE_number:
                        args.Add(key, ParseNumber(i.InnerText));
                        break;
                    case TYPE_array:
                        var arrayList = ParseArray(property.SelectNodes("property"));
                        args.Add(key, arrayList);
                        break;
                    case TYPE_object:
                        var hashtable = ParseObject(property.SelectNodes("property"));
                        args.Add(key, hashtable);
                        break;
                    default:
                        throw new ArgumentException("不支持解析该类型", property.OuterXml);
                }
            }
            return args;
        }
        #endregion
    }
}