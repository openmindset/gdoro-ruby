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

  # Seconds is our timer variable. It will decrement to 0.
  @seconds = 1500
  # We need a placeholder to detect what the last timer cycle value was.
  # This will initially be set to 1500 (25:00) as all work begins with that
  # cycle as a default.
  @seconds_previous = 1500
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
      if @pomo_count > 3
        para "Break Time!",
            :align => "center", 
            :margin_top => 16
        @pomo_count = 0
        @seconds = 1500
        @seconds_previous = 1500
      else
        para "pomos completed: #{@pomo_count}", 
            :align => "center", 
            :margin_top => 16
      end
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
    title("#{display_time}",
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

  if @paused # don't loop the block if paused is true, otherwise it's buggy
    animate(1) do
      if @seconds > 1
        @seconds -= 1 unless @paused
        display_time
      else
        # detect if the last pomo completed was a 25 cycle or a 5 break
        # also, when pomo complete count is 4, notify to take break
        case @seconds_previous
        when 1500
          alert("Pomodoro complete!")
          @pomo_count += 1
          @paused = !@paused
          @seconds = 300
          @seconds_previous = 300
          @btn_start.real.set_label("Start")
          update_pomo_count
        when 300
          alert("Break's over!")
          @paused = !@paused
          @seconds = 1500
          @seconds_previous = 1500
          puts @seconds_previous
          @btn_start.real.set_label("Start")
        else
          alert("The timer broke!")  
        end       
      end
    end  
  end
end