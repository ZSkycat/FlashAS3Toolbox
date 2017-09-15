using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections;
using System.Collections.Generic;

namespace ZSkycat.Tests
{
    [TestClass]
    public class FlashApiXmlHandlerTests
    {
        private FlashApiXmlHandler handler;

        [TestMethod]
        public void AddTest()
        {
            handler = new FlashApiXmlHandler("TestFunction");
            handler.Add().Add(true).Add(false).Add("String").Add(12345);

            string[] array = new string[] { "1", "2", "3" };
            IList list = new List<string>() { "1", "2", "3" };
            IDictionary dictionary = new Dictionary<string, string>() { { "1", "1" }, { "2", "2" }, { "3", "3" } };
            handler.Add(array).Add(list).Add(dictionary);

            ArrayList listO = new ArrayList() { true, "true", 0 };
            Hashtable hash = new Hashtable() { { "1", true }, { "2", "true" }, { "3", 0 } };
            handler.Add(listO).Add(hash);
        }

        [TestMethod]
        public void GetXmlString_ParseXmlString_Test()
        {
            AddTest();

            var xmlString = handler.GetXmlString();
            Console.WriteLine($"GetXmlString:\r\n{handler.GetXmlString()}");

            string funcName;
            var args = FlashApiXmlHandler.ParseXmlString(xmlString, out funcName);
            Console.WriteLine($"ParseXmlString: {funcName} -> {args.ToString()}");
        }
    }
}