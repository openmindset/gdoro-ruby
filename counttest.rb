require 'green_shoes'

Shoes.app :width => 200, :height => 120 do
  @seconds = 1500
  @paused = true

  def display_time
  @display.clear do
    title "%02d:%02d" % [
      @seconds / 60 % 60,
      @seconds % 60]
    end
  end

  @display = stack :margin => 10 do
    display_time
  end


  button "Start" do
    @paused = !@paused
  end

  animate(1) do
    @seconds -= 1 unless @paused
    display_time
  end
end