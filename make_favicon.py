import PIL.Image

def make_square_favicon(input_path, output_path, size=192):
    img = PIL.Image.open(input_path)
    
    # Calculate aspect ratio
    width, height = img.size
    max_dim = max(width, height)
    
    # Create a new square image with a transparent background
    square_img = PIL.Image.new('RGBA', (max_dim, max_dim), (0, 0, 0, 0))
    
    # Paste the original image into the center of the square image
    offset = ((max_dim - width) // 2, (max_dim - height) // 2)
    square_img.paste(img, offset)
    
    # Resize to the target size
    square_img = square_img.resize((size, size), PIL.Image.Resampling.LANCZOS)
    
    square_img.save(output_path, format="PNG")

make_square_favicon("assets/logo.png", "assets/favicon.png", size=192)
print("Created square favicon!")
