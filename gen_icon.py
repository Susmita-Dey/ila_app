from PIL import Image, ImageDraw

def generate():
    size = 1024
    # Warm Cream canvas
    img = Image.new('RGBA', (size, size), '#FAF8F5')
    draw = ImageDraw.Draw(img)

    # 1. Organic Dusty Blush Watercolor Spot Wash (Oval at 572, 472, w=420, h=420)
    # 20% opacity of #DCAE9F is #DCAE9F33 (in RGBA: 220, 174, 159, 51)
    blush_color = (220, 174, 159, 51)
    # Bounding box: 572 - 210 = 362, 472 - 210 = 262 to 782, 682
    draw.ellipse([362, 262, 782, 682], fill=blush_color)

    # 2. Organic Washed Sage Accent Wash (Oval at 442, 592, w=300, h=300)
    # 20% opacity of #8A9A86 is #8A9A8633 (in RGBA: 138, 154, 134, 51)
    sage_color = (138, 154, 134, 51)
    # Bounding box: 442 - 150 = 292, 592 - 150 = 442 to 592, 742
    draw.ellipse([292, 442, 592, 742], fill=sage_color)

    # 3. Charcoal Line Art Monogram Arch
    ink = '#1E242B'
    stroke = 46

    # Floating Dot (Clarity Seed) at 512, 312, radius 48
    draw.ellipse([512 - 48, 312 - 48, 512 + 48, 312 + 48], fill=ink)

    # Arch Stem
    # Left stem: 392, 732 to 392, 502
    draw.line([392, 732, 392, 502], fill=ink, width=stroke)
    # Right stem: 632, 732 to 632, 502
    draw.line([632, 732, 632, 502], fill=ink, width=stroke)
    
    # Semi-circle on top from 392 to 632. Center is 512, 502. Radius is 120.
    # Bounding box: 512 - 120 = 392, 502 - 120 = 382 to 632, 622
    draw.arc([392, 382, 632, 622], start=180, end=0, fill=ink, width=stroke)

    # Fix round caps at the bottom of the stems
    r = stroke // 2
    draw.ellipse([392 - r, 732 - r, 392 + r, 732 + r], fill=ink)
    draw.ellipse([632 - r, 732 - r, 632 + r, 732 + r], fill=ink)

    img.save('assets/branding/ila_icon.png')
    img.save('assets/branding/ila_splash.png')
    img.save('assets/branding/ila_icon_foreground.png')
    print('Generated new Editorial Notion-style PNG assets!')

if __name__ == '__main__':
    generate()
