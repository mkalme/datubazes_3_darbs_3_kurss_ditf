namespace Sql
{
    internal class Program
    {
        private static readonly Random Random = new();

        static void Main(string[] args)
        {
            GenerateVariant1(8000, 400000, "C:\\Users\\tawle\\Desktop\\sql_variant_1_insertions.sql");

            Console.WriteLine("Done");
        }

        private static DateTime GenerateRandomDate(DateTime from, DateTime to) 
        {
            TimeSpan span = to - from;
            return from.AddTicks(Random.NextInt64(span.Ticks));
        }

        private static void GenerateVariant1(int issuerSize, int bondSize, string file)
        {
            using StreamWriter writer = new(file);

            string[] creditRatings = ["AAA", "AA", "A", "BBB", "BB", "B", "CCC", "CC", "C", "D"];

            for (int i = 0; i < issuerSize; i++) 
            {
                writer.WriteLine("INSERT INTO EMITENTI_1 ");
                writer.WriteLine($"VALUES ({i}, 'Emitents {(char)Random.Next('A', 'Z' + 1)}{(char)Random.Next('A', 'Z' + 1)}{(char)Random.Next('A', 'Z' + 1)}', '{creditRatings[Random.Next(creditRatings.Length)]}');");
                writer.WriteLine("");
            }

            for (int i = 0; i < bondSize; i++) 
            {
                writer.WriteLine("INSERT INTO OBLIGACIJAS_1");
                writer.WriteLine($"VALUES ({i}, {Random.Next(10000)}.00, {Random.Next(10)}, '{GenerateRandomDate(new DateTime(2000, 1, 1), new DateTime(2024, 1, 1)):yyyy-M-d}', {Random.Next(issuerSize)});");
                writer.WriteLine("");
            }
        }
    }
}
