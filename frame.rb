require 'sdl'

WAIT_SECS = 60

class ImageRenderer
  PIC_PATTERN = "pics/*.{jpg,JPG}"
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600
  SCREEN_DEPTH = 24
  BLACK = [0,0,0]

  def initialize
    SDL.init(SDL::INIT_VIDEO)
    SDL::Mouse.hide
    @screen = SDL::Screen.open(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_DEPTH, SDL::SWSURFACE)
    @files = []
  end

  def render
    image = SDL::Surface.load(file)

    scale, x_offset, y_offset = scale_and_offset(image.w, image.h, SCREEN_WIDTH, SCREEN_HEIGHT)

    @screen.fill_rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, BLACK)
    SDL::Surface.transform_draw(image, @screen, 0, scale, scale, 0, 0, x_offset.to_i, y_offset.to_i, 0)
    image.destroy
    @screen.update_rect(0, 0, 0, 0)
  end

  private

  def file
    @files = Dir[PIC_PATTERN].shuffle if @files.empty?
    @files.pop
  end

  def scale_and_offset(orig_width, orig_height, max_width, max_height)
    x_scale = max_width / orig_width.to_f
    y_scale = max_height / orig_height.to_f
    scale = [x_scale, y_scale].min

    x_offset = orig_width * (x_scale - scale) / 2
    y_offset = orig_height * (y_scale - scale) / 2

    [scale, x_offset, y_offset]
  end
end


def main
  renderer = ImageRenderer.new

  while true
    renderer.render

    (1..WAIT_SECS).each do
      event = SDL::Event2.poll
      while SDL::Event2.poll; end #clear extra events

      if event.class == SDL::Event2::KeyDown
        renderer.render
      end

      sleep 1
    end
  end
end

main()
