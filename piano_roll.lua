local NTSC_CPU_FREQUENCY = 1.789773 * 1024.0 * 1024.0
local LOWEST_NOTE_FREQ = 55.0 -- ~A0
local HIGHEST_NOTE_FREQ = 4434.922 -- ~C#8
local PIANO_ROLL_WIDTH = 240
local PIANO_ROLL_KEYS = 76
local PIANO_ROLL_KEY_HEIGHT = 2
local PIANO_ROLL_HEIGHT = PIANO_ROLL_KEYS * PIANO_ROLL_KEY_HEIGHT
local NOISE_KEY_HEIGHT = 2
local NOISE_ROLL_HEIGHT = NOISE_KEY_HEIGHT * 16
local NOISE_ROLL_OFFSET = 200
local SQUARE1_COLOR = 0xFF4040
local SQUARE2_COLOR = 0xFFC040
local TRIANGLE_COLOR = 0x40FF40
local NOISE_COLOR = 0x4040FF
local DMC_COLOR = 0x8040FF

function frequency_to_coordinate(note_frequency, lowest_freq, highest_freq, viewport_height)
  local highest_log = math.log(highest_freq)
  local lowest_log = math.log(lowest_freq)
  local range = highest_log - lowest_log
  local note_log = math.log(note_frequency)

  local coordinate = (note_log - lowest_log) * viewport_height / range
  if coordinate >= 0 and coordinate < viewport_height then
    return coordinate
  else
    return nil
  end
end

function pulse_frequency(pulse_period)
  return NTSC_CPU_FREQUENCY / (16.0 * (pulse_period + 1.0))
end

function triangle_frequency(triangle_period)
  return NTSC_CPU_FREQUENCY / (32.0 * (triangle_period + 1.0))
end

function unpack_argb(color)
  return ((color & 0xFF000000) >> 24), ((color & 0xFF0000) >> 16), ((color & 0xFF00) >> 8), (color & 0xFF)
end

function pack_argb(a, r, g, b)
  return (a << 24) | (r << 16) | (g << 8) | (b)
end

function apply_brightness(color, brightness)
  local a, r, g, b = unpack_argb(color)
  r = math.floor(r * brightness)
  g = math.floor(g * brightness)
  b = math.floor(b * brightness)
  return pack_argb(a, r, g, b)
end

function apply_transparency(color, alpha)
  local a, r, g, b = unpack_argb(color)
  a = math.floor(0xFF * (1.0 - alpha))
  return pack_argb(a, r, g, b)
end

local square1_roll = {}
local square2_roll = {}
local triangle_roll = {}
local noise_roll = {}
local dmc_roll = {}

function update_piano_roll(channel, state_table)
  local channel_state = {}
  local coordinate = frequency_to_coordinate(channel.frequency, LOWEST_NOTE_FREQ, HIGHEST_NOTE_FREQ, PIANO_ROLL_HEIGHT)
  if coordinate then
    channel_state.y = PIANO_ROLL_HEIGHT - coordinate
  end
  if channel.envelope then
    -- pulse channels
    channel_state.volume = channel.envelope.volume
    channel_state.enabled = channel.envelope.volume ~= 0 and channel.lengthCounter.counter > 0
  else
    -- triangle channels
    channel_state.volume = 6
    channel_state.enabled = 
      channel.lengthCounter.counter > 0 and
      channel.period > 2 and
      channel.enabled
  end
  
  table.insert(state_table, channel_state)
  if #state_table > PIANO_ROLL_WIDTH then
    table.remove(state_table, 1)
  end
end

local noise_period_table = {}
noise_period_table[4]    =  0 
noise_period_table[8]    =  1
noise_period_table[16]   =  2
noise_period_table[32]   =  3
noise_period_table[64]   =  4
noise_period_table[96]   =  5
noise_period_table[128]  =  6
noise_period_table[160]  =  7
noise_period_table[202]  =  8
noise_period_table[254]  =  9
noise_period_table[380]  =  10
noise_period_table[508]  =  11
noise_period_table[762]  =  12
noise_period_table[1016] =  13
noise_period_table[2034] =  14
noise_period_table[4068] =  15

function update_noise_roll(channel, state_table)
  local channel_state = {}
  if noise_period_table[channel.period + 1] then
    channel_state.y = noise_period_table[channel.period + 1] * NOISE_KEY_HEIGHT
  end
  channel_state.volume = channel.envelope.volume
  channel_state.enabled = channel.envelope.volume ~= 0 and channel.lengthCounter.counter > 0
  table.insert(state_table, channel_state)
  if #state_table > PIANO_ROLL_WIDTH then
    table.remove(state_table, 1)
  end
end

function draw_piano_roll(emu, state_table, base_color)  
  for x = 1, #state_table do
    if state_table[x].enabled and state_table[x].y then
      local volume = state_table[x].volume
      local y = state_table[x].y - 2
      local foreground = base_color
      --local background = apply_brightness(base_color, 0.2)
      --emu.drawLine(x, y-2, x, y+2, background)
      -- outer lines, drawn at brightness dependant on volume
      local outermost_volume = math.max(0, volume - 8) / 8
      local outermost_brightness = math.min(1.0, outermost_volume)
      emu.drawLine(x - 1, y-2, x - 1, y+2, apply_transparency(base_color, outermost_brightness))
      local innermost_volume = volume / 8
      local innermost_brightness = math.min(1.0, innermost_volume)
      emu.drawLine(x - 1, y-1, x - 1, y+1, apply_transparency(base_color, innermost_brightness))
      -- center line, always drawn at full brightness when playing
      emu.drawPixel(x - 1, y, foreground)
    end
  end
end

function draw_noise_roll(emu, state_table, base_color)  
  for x = 1, #state_table do
    if state_table[x].enabled and state_table[x].y then
      local volume = state_table[x].volume
      local y = state_table[x].y - 2
      local foreground = base_color
      --local background = apply_brightness(base_color, 0.2)
      --emu.drawLine(x, y-2, x, y+2, background)
      -- outer lines, drawn at brightness dependant on volume
      local outermost_volume = math.max(0, volume - 8) / 8
      local outermost_brightness = math.min(1.0, outermost_volume)
      emu.drawLine(x - 1, NOISE_ROLL_OFFSET + y-2, x - 1, NOISE_ROLL_OFFSET + y+2, apply_transparency(base_color, outermost_brightness))
      local innermost_volume = volume / 8
      local innermost_brightness = math.min(1.0, innermost_volume)
      emu.drawLine(x - 1, NOISE_ROLL_OFFSET + y-1, x - 1, NOISE_ROLL_OFFSET + y+1, apply_transparency(base_color, innermost_brightness))
      -- center line, always drawn at full brightness when playing
      emu.drawPixel(x - 1, NOISE_ROLL_OFFSET + y, foreground)
    end
  end
end

function draw_piano_background()
   emu.drawRectangle(0, 0, 256, 240, 0x000000, true)
end

function draw_piano_strings()
  local black_string = 0x101010
  local white_string = 0x060606
  local string_colors = {
    white_string, --C
    white_string, --B
    black_string, --Bb
    white_string, --A
    black_string, --Ab
    white_string, --G
    black_string, --Gb
    white_string, --F
    white_string, --E
    black_string, --Eb
    white_string, --D
    black_string, --Db
  }
  
  for i = 0, PIANO_ROLL_KEYS do
    local string_color = string_colors[i%12 + 1]
    local y = i*PIANO_ROLL_KEY_HEIGHT
    emu.drawLine(0, y, PIANO_ROLL_WIDTH, y, string_color)
  end
end

local white_key_border = 0x404040
local white_key = 0x505050
local black_key = 0x000000
local black_key_border = 0x181818
local upper_key_pixels = {
  white_key, -- C
  white_key_border, 
  white_key, -- B
  black_key, black_key, black_key, -- Bb
  white_key, -- A
  black_key, black_key, black_key, -- Ab
  white_key, -- G
  black_key, black_key, black_key, -- Gb
  white_key, -- F
  white_key_border,
  white_key, -- E
  black_key, black_key, black_key, -- Eb
  white_key, -- D
  black_key, black_key, black_key, -- Db
}
  
local lower_key_pixels = {
  white_key, -- C (bottom half)
  white_key_border,
  white_key, white_key, -- B
  white_key_border, 
  white_key, white_key, white_key, -- A
  white_key_border, 
  white_key, white_key, white_key, -- G
  white_key_border,
  white_key, white_key, -- F
  white_key_border,
  white_key, white_key, -- E
  white_key_border, 
  white_key, white_key, white_key, -- D
  white_key_border,
  white_key, -- C (top half)
}

function draw_piano_keys()
  -- first, draw the keys themselves
  for y = 0, PIANO_ROLL_KEYS * PIANO_ROLL_KEY_HEIGHT do
    local upper_key_color = upper_key_pixels[y % #upper_key_pixels + 1]
    local lower_key_color = lower_key_pixels[y % #lower_key_pixels + 1]
    emu.drawLine(240, y, 248, y, upper_key_color)
    emu.drawLine(248, y, 256, y, lower_key_color)
  end
  
  -- now clean up the border between the key and the piano roll
  emu.drawLine(240, 0, 240, PIANO_ROLL_HEIGHT, black_key_border)
end

function draw_right_white_key(y, color)  
  emu.drawLine(248, y + 1, 256, y + 1, color)
  emu.drawLine(240, y, 256, y, color)
end

function draw_center_white_key(y, color)
  emu.drawLine(248, y - 1, 256, y - 1, color)
  emu.drawLine(240, y, 256, y, color)
  emu.drawLine(248, y + 1, 256, y + 1, color)
end

function draw_left_white_key(y, color)
  emu.drawLine(240, y, 256, y, color)
  emu.drawLine(248, y - 1, 256, y - 1, color)
end

function draw_black_key(y, color)
  emu.drawLine(241, y - 1, 247, y - 1, color)
  emu.drawLine(241, y, 247, y, color)
  emu.drawLine(241, y + 1, 247, y + 1, color)
end

function draw_key_spot(note, base_color)
  if (note.y == nil or note.enabled == false) then
    return
  end
  local key_drawing_functions = {
    draw_left_white_key,  --C
    draw_right_white_key, --B
    draw_black_key,       --Bb
    draw_center_white_key,--A
    draw_black_key,       --Ab
    draw_center_white_key,--G
    draw_black_key,       --Gb
    draw_left_white_key,  --F
    draw_right_white_key, --E
    draw_black_key,       --Eb
    draw_center_white_key,--D
    draw_black_key,       --Db
  }
  
  local note_key = (note.y - 2) / PIANO_ROLL_KEY_HEIGHT
  local base_key = math.floor(note_key)
  local base_percent = 1.0 - (note_key % 1)
  local adjacent_key = math.ceil(note_key)
  local adjacent_percent = note_key % 1
  
  local base_y = base_key * PIANO_ROLL_KEY_HEIGHT
  local base_key_color = apply_transparency(base_color, base_percent)
  key_drawing_functions[base_key % 12 + 1](base_y, base_key_color)
  
  local adjacent_y = adjacent_key * PIANO_ROLL_KEY_HEIGHT
  local adjacent_key_color = apply_transparency(base_color, adjacent_percent)
  key_drawing_functions[adjacent_key % 12 + 1](adjacent_y, adjacent_key_color)
end

function mesen_draw()
  local state = emu.getState()
  local apu = state.apu

  --             x   y   str            fore: argb  back: argb 
  --emu.drawString(10, 10, "Hello Mesen",   0x80ff0000, 0x80FFFFFF)
  --emu.drawString(10, 20, "P1: "..apu.square1.period,   0xff0000, 0xFFFFFF)

  draw_piano_background()
  draw_piano_strings()
  draw_piano_keys()
  
  update_piano_roll(apu.square1, square1_roll)
  update_piano_roll(apu.square2, square2_roll)
  update_piano_roll(apu.triangle, triangle_roll)
  update_noise_roll(apu.noise, noise_roll)
  draw_piano_roll(emu, square1_roll, SQUARE1_COLOR) 
  draw_piano_roll(emu, square2_roll, SQUARE2_COLOR) 
  draw_piano_roll(emu, triangle_roll, TRIANGLE_COLOR)
  draw_noise_roll(emu, noise_roll, NOISE_COLOR)
  draw_key_spot(square1_roll[#square1_roll], SQUARE1_COLOR)
  draw_key_spot(square2_roll[#square2_roll], SQUARE2_COLOR)
  draw_key_spot(triangle_roll[#square1_roll], TRIANGLE_COLOR)
end

emu.addEventCallback(mesen_draw, emu.eventType.endFrame);