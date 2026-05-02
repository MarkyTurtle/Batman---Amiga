using System.IO;

namespace tilemap
{
    internal class Program
    {
        static void Main(string[] args)
        {
            var path = args[0];
            if (!Path.Exists(args[0]))
            {
                path = Path.Combine(Environment.CurrentDirectory, path);
            }

            var tileMapBytes = File.ReadAllBytes(path);

            // output buffer plus 2 words for width & height.
            var flippedTileMapBytes = new byte[tileMapBytes.Length+4];
            
            var width = 192;
            var height = 42;

            // set big endian width word
            flippedTileMapBytes[0] = (byte)(width >> 8);
            flippedTileMapBytes[1] = (byte)(width & 0x00ff);

            // set big endian heght word
            flippedTileMapBytes[2] = (byte)(height >> 8);
            flippedTileMapBytes[3] = (byte)(height & 0x00ff);

            // Flip tilemap y-axis
            var currentDest = 4;
            var currentSrc = (width * height) - width;

            for (int j = 0; j < height; j++)
            {
                // copy one row of tile map
                for (int i = 0; i < width; i++)
                {
                    flippedTileMapBytes[currentDest] = tileMapBytes[currentSrc + i];
                    currentDest += 1;
                }
                currentSrc -= width;
            }

            // Save the Flipped Map File
            var filename = Path.GetFileName(path);
            var filePath = Path.Combine(Environment.CurrentDirectory, filename + ".flipped");
            File.WriteAllBytes(filePath, flippedTileMapBytes);

        }

    }

}