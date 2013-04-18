require 'sdl'

PIC_PATTERN = "pics/*.{jpg,JPG}"
WAIT_SECS = 60
SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
SCREEN_DEPTH = 24
BLACK = [0,0,0]

def scale_and_offset(orig_width, orig_height, max_width, max_height)
  x_scale = max_width / orig_width.to_f
  y_scale = max_height / orig_height.to_f
  scale = [x_scale, y_scale].min

  x_offset = orig_width * (x_scale - scale) / 2
  y_offset = orig_height * (y_scale - scale) / 2

  [scale, x_offset, y_offset]
end

SDL.init(SDL::INIT_VIDEO)
SDL::Mouse.hide
screen = SDL::Screen.open(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_DEPTH, SDL::SWSURFACE)

while true
  Dir[PIC_PATTERN].shuffle.each do |file|
    image = SDL::Surface.load(file)

    scale, x_offset, y_offset = scale_and_offset(image.w, image.h, SCREEN_WIDTH, SCREEN_HEIGHT)

    screen.fill_rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, BLACK)
    SDL::Surface.transform_draw(image, screen, 0, scale, scale, 0, 0, x_offset.to_i, y_offset.to_i, 0)
    image.destroy
    screen.update_rect(0, 0, 0, 0)

    (1..WAIT_SECS).each do
      while event = SDL::Event2.poll
        case event
        when SDL::Event2::KeyDown, SDL::Event2::Quit
          exit
        end
      end
      sleep 1
    end
  end
end
