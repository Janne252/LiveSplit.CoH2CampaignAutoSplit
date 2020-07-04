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
		}
	}
}
