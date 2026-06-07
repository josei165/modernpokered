from PIL import Image
import sys

GRAYS = [0x00, 0x55, 0xaa, 0xff]

def nearest_gray(r, g, b):
    luma = int(0.299 * r + 0.587 * g + 0.114 * b)
    return min(GRAYS, key=lambda g: abs(g - luma))

def convert(path):
    img = Image.open(path).convert("RGBA")
    pixels = img.load()
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, a = pixels[x, y]
            if a == 0:
                pixels[x, y] = (255, 255, 255, 255)
            else:
                gray = nearest_gray(r, g, b)
                pixels[x, y] = (gray, gray, gray, 255)
    img.save(path)
    print(f"Converted {path}")

for path in sys.argv[1:]:
    convert(path)