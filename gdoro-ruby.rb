# gdoro-ruby.rb
# a simple pomodoro timer coded in ruby/green-shoes

require 'green_shoes'

Shoes.app :width => 260, 
          :height => 190, 
          :curve => 10,
          :resizable => false,
          :title => "gdoro" do
  background "#EFC"
  border("#BE8", :strokewidth => 6)

  # initialially set timer to 25:00
  @seconds = 1500
  @paused = true
  @pomo_count = 0

  def display_time
    @timer.clear do
      title("%02d:%02d" % [
        @seconds / 60 % 60,
        @seconds % 60],
        :align => "center")
    end
  end

  def update_pomo_count
  @pomo_text.clear do
    para "pomos completed: #{@pomo_count}", 
          :align => "center", 
          :margin_top => 16
    end
  end

  @title = stack :width => 320, :height => 50 do
    subtitle("gdoro", 
          align: "center",
          margin_top: 10,
          font: "Courier",
          stroke: "#6E1E14")
  end

  @timer = stack :width => 320, :height => 50 do
    title("25:00",
          align: "center")
  end

  @btn_start = button "Start", :margin_left => 86, :margin_top => 7
  
  @btn_start.click{
    @paused = !@paused
    if @btn_start.real.label == "Start"
      @btn_start.real.set_label("Pause")
    else
      @btn_start.real.set_label("Start")
    end
  }
  
  @btn_reset = button "Reset", :margin_left => 5, :margin_top => 7

  @btn_reset.click{
    @seconds = 1500
  }

  @pomo_text = stack :width => 320, :height => 50 do
    para "pomos completed: #{@pomo_count}", 
          :align => "center", 
          :margin_top => 16
  end

  animate(1) do
    if @seconds > 1
      @seconds -= 1 unless @paused
      display_time
    else
      @pomo_count += 1
      @paused = !@paused
      @seconds = 300
      update_pomo_count
      # need to code return to 25:00 minutes after 5:00 break
    end
  end
end