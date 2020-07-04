using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace ConsoleApp1
{
	class Program
	{
		static void Main(string[] args)
		{
			const string root = @"..\..\..\..\..\";
			
			//  Test code since we can't have proper IDE experience in .asl files
			if (false)
			{
				using (var stream = System.IO.File.Open("dd", FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
				using (var reader = new System.IO.StreamReader(stream))
				{
					reader.BaseStream.Seek(0, SeekOrigin.Begin);
				}
			}


			var sourceLines = new Queue<string>(File.ReadAllLines(root + @"samples\warnings\full.log"));

			using (var stream = File.Open(root + @"test\warnings.log", FileMode.Truncate, FileAccess.Write, FileShare.Read))
			using (var writer = new StreamWriter(stream))
			{
				while (sourceLines.Count > 0)
				{
					var line = sourceLines.Dequeue();
					Console.WriteLine($"Press Enter to insert {line}");
					Console.ReadLine();
					writer.WriteLine(line);
					writer.Flush();
				}
			}

			Console.WriteLine("Press enter to exit...");
			Console.ReadLine();

			var p = (Action)(() =>
			{

			});
		}
	}
}
