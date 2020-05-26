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
local DMC_OFFSET = 178
local DMC_HEIGHT = 19
local BACKGROUND_COLOR = 0x80000000
local PIANO_STRING_BLACK_COLOR = 0x80101010
local PIANO_STRING_WHITE_COLOR = 0x80060606
local NOISE_STRING_BLACK_COLOR = 0x80060606
local NOISE_STRING_WHITE_COLOR = 0x800A0A0A

local settings = {
  background="transparent"
}

function toggle_background()
  if settings.background == "clear" then
    settings.background = "transparent"
    BACKGROUND_COLOR = 0xFF000000
    PIANO_STRING_BLACK_COLOR = 0xFF000000
    PIANO_STRING_WHITE_COLOR = 0xFF000000
    NOISE_STRING_BLACK_COLOR = 0xFF060606
    NOISE_STRING_WHITE_COLOR = 0xFF0A0A0A
  elseif settings.background == "transparent" then
    settings.background = "solid"
    BACKGROUND_COLOR = 0x80000000
    PIANO_STRING_BLACK_COLOR = 0x80101010
    PIANO_STRING_WHITE_COLOR = 0x80060606
    NOISE_STRING_BLACK_COLOR = 0x80060606
    NOISE_STRING_WHITE_COLOR = 0x800A0A0A
  elseif settings.background == "solid" then
    settings.background = "clear"
    BACKGROUND_COLOR = 0x000000
    PIANO_STRING_BLACK_COLOR = 0x101010
    PIANO_STRING_WHITE_COLOR = 0x060606
    NOISE_STRING_BLACK_COLOR = 0x060606
    NOISE_STRING_WHITE_COLOR = 0x0A0A0A
  end
end

function tiny_a(x, y, color)
  emu.drawLine(x,y+1,x, y+4, color)
  emu.drawLine(x+2,y+1,x+2, y+4, color)
  emu.drawPixel(x+1,y,color)
  emu.drawPixel(x+1,y+2,color)
end

function tiny_b(x, y, color)
  emu.drawLine(x, y, x, y+4, color)
  emu.drawPixel(x+1, y, color)
  emu.drawPixel(x+1, y+2, color)
  emu.drawPixel(x+1, y+4, color)
  emu.drawPixel(x+2, y+1, color)
  emu.drawPixel(x+2, y+3, color)
end

function tiny_c(x, y, color)
  emu.drawLine(x, y+1, x, y+3, color)
  emu.drawLine(x+1, y, x+2, y, color)
  emu.drawLine(x+1, y+4, x+2, y+4, color)
end

function tiny_d(x, y, color)
  emu.drawLine(x, y, x, y+4, color)
  emu.drawPixel(x+1, y, color)
  emu.drawPixel(x+1, y+4, color)
  emu.drawLine(x+2, y+1, x+2, y+3,color)
end

function tiny_e(x, y, color)
  emu.drawLine(x, y, x, y+4, color)
  emu.drawLine(x+1, y, x+2, y, color)
  emu.drawPixel(x+1, y+2, color)
  emu.drawLine(x+1, y+4, x+2, y+4, color)
end

function tiny_f(x, y, color)
  emu.drawLine(x, y, x, y+4, color)
  emu.drawLine(x+1, y, x+2, y, color)
  emu.drawPixel(x+1, y+2, color)
end

function tiny_0(x, y, color)
  emu.drawLine(x, y, x, y+4, color)
  emu.drawLine(x+2, y, x+2, y+4, color)
  emu.drawPixel(x+1, y, color)
  emu.drawPixel(x+1, y+4, color)
end

function tiny_1(x, y, color)
  emu.drawLine(x+1, y, x+1, y+4, color)
  emu.drawLine(x, y+4, x+2, y+4, color)
  emu.drawPixel(x, y+1,color)
end

function tiny_2(x, y, color)
  emu.drawLine(x, y, x+1, y, color)
  emu.drawLine(x+2,y+1,x,y+3, color)
  emu.drawLine(x,y+4,x+2,y+4, color)
end

function tiny_3(x, y, color)
  emu.drawLine(x+2, y, x+2, y+4, color)
  emu.drawLine(x, y, x+1, y, color)
  emu.drawPixel(x+1, y+2, color)
  emu.drawLine(x, y+4, x+1, y+4, color)
end

function tiny_4(x, y, color)
  emu.drawLine(x+2, y, x+2, y+4, color)
  emu.drawLine(x, y, x, y+2, color)
  emu.drawPixel(x+1, y+2, color)
end

function tiny_5(x, y, color)
  emu.drawLine(x, y, x+2, y, color)
  emu.drawLine(x, y+1, x, y+2, color)
  emu.drawPixel(x+1, y+2, color)
  emu.drawPixel(x+2, y+3, color)
  emu.drawLine(x,y+4,x+1,y+4, color)
end

function tiny_6(x, y, color)
  emu.drawLine(x, y, x, y+4, color)
  emu.drawLine(x+1, y, x+2, y, color)
  emu.drawLine(x+1, y+2, x+2, y+2, color)
  emu.drawLine(x+1, y+4, x+2, y+4, color)
  emu.drawPixel(x+2, y+3, color)
end

function tiny_7(x, y, color)
  emu.drawLine(x+2, y, x+2, y+4, color)
  emu.drawLine(x, y, x+1, y, color)
end

function tiny_8(x, y, color)
  emu.drawLine(x, y, x, y+4, color)
  emu.drawLine(x+2, y, x+2, y+4, color)
  emu.drawPixel(x+1, y, color)
  emu.drawPixel(x+1, y+2, color)
  emu.drawPixel(x+1, y+4, color)
end

function tiny_9(x, y, color)
  emu.drawLine(x+2, y, x+2, y+4, color)
  emu.drawLine(x, y, x+1, y, color)
  emu.drawLine(x, y+2, x+1, y+2, color)
  emu.drawLine(x, y+4, x+1, y+4, color)
  emu.drawPixel(x, y+1, color)
end

function tiny_hex_char(x, y, value, color)
  local hex_functions = {
    tiny_0,
    tiny_1,
    tiny_2,
    tiny_3,
    tiny_4,
    tiny_5,
    tiny_6,
    tiny_7,
    tiny_8,
    tiny_9,
    tiny_a,
    tiny_b,
    tiny_c,
    tiny_d,
    tiny_e,
    tiny_f
  }
  if hex_functions[value+1] then
    hex_functions[value+1](x,y,color)
  end
end

function tiny_hex(x, y, value, color, width)
  while width > 0 do
    width = width - 1
    tiny_hex_char(x + width * 4, y, value & 0xF, color)
    value = value >> 4
  end
end

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
    channel_state.period = noise_period_table[channel.period + 1]
  end
  channel_state.volume = channel.envelope.volume
  channel_state.enabled = channel.envelope.volume ~= 0 and channel.lengthCounter.counter > 0
  table.insert(state_table, channel_state)
  if #state_table > PIANO_ROLL_WIDTH then
    table.remove(state_table, 1)
  end
end

local old_dmc_level = 0

local dmc_period_table = {}
dmc_period_table[428] = 0
dmc_period_table[380] = 1
dmc_period_table[340] = 2
dmc_period_table[320] = 3
dmc_period_table[286] = 4
dmc_period_table[254] = 5
dmc_period_table[226] = 6
dmc_period_table[214] = 7
dmc_period_table[190] = 8
dmc_period_table[160] = 9
dmc_period_table[142] = 10
dmc_period_table[128] = 11
dmc_period_table[106] = 12
dmc_period_table[84]  = 13
dmc_period_table[72]  = 14
dmc_period_table[54]  = 15

function update_dmc_roll(channel, state_table)
  local channel_state = {}
  local dmc_playing = channel.bytesRemaining > 0
  local delta = math.abs(channel.outputVolume - old_dmc_level)
  channel_state.playing = dmc_playing
  channel_state.delta = delta
  channel_state.address = channel.sampleAddr
  
  if dmc_period_table[channel.period + 1] then
    channel_state.rate = dmc_period_table[channel.period + 1]
  end
  table.insert(state_table, channel_state)
  if #state_table > PIANO_ROLL_WIDTH then
    table.remove(state_table, 1)
  end
  old_dmc_level = channel.outputVolume
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
      local y = state_table[x].y
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
   emu.drawRectangle(0, 0, 256, 240, BACKGROUND_COLOR, true)
end

function draw_piano_strings()
  local black_string = PIANO_STRING_BLACK_COLOR
  local white_string = PIANO_STRING_WHITE_COLOR
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

function draw_noise_strings()
  local noise_string_colors = {
    NOISE_STRING_BLACK_COLOR,
    NOISE_STRING_WHITE_COLOR
  }
  for i = 0, 15 do
    local y = i * NOISE_KEY_HEIGHT
    emu.drawLine(0, NOISE_ROLL_OFFSET + y, PIANO_ROLL_WIDTH, NOISE_ROLL_OFFSET + y, noise_string_colors[(i%2)+1])
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

function draw_pad(x, y, value, foreground, background)
  emu.drawRectangle(x, y-1, 4, 9, background, true)
  emu.drawLine(x+4, y, x+4, y+6, background)
  tiny_hex_char(x+1,y+1,value,foreground)
end

function draw_noise_pads(active_note)
  local pad_colors = {
    0x101010,
    0x121212,
    0x141414,
    0x161616,
    0x181818,
    0x1A1A1A,
    0x1C1C1C,
    0x1E1E1E,
    0x202020,
    0x222222,
    0x242424,
    0x262626,
    0x282828,
    0x2A2A2A,
    0x2C2C2C,
    0x2E2E2E,
  }

  for i = 0, 15 do
    local x = 240 + ((i % 4) * 4) 
    local y = i * 2 + NOISE_ROLL_OFFSET - 3
    local color = pad_colors[(0xF - i) + 1]
    local hex_value = 0xF - i;
    if (active_note.y and active_note.enabled and active_note.period == i) then
      color = NOISE_COLOR
    end
    draw_pad(x, y, hex_value, apply_brightness(color, 1.8), color)
  end

  emu.drawLine(240, NOISE_ROLL_OFFSET - 4, 240, NOISE_ROLL_OFFSET + 30, 0x101010)
  emu.drawLine(241, NOISE_ROLL_OFFSET + 30, 243, NOISE_ROLL_OFFSET + 30, 0x303030)
end

function draw_dmc_roll(emu, state_table, base_color)
  for x = 1, #state_table do
    local y = DMC_OFFSET
    local color = base_color
    if not state_table[x].playing then
      color = apply_brightness(base_color, 0.5)
    end
    -- width of "sample" based on delta, maximum is 127
    local sample_offset = math.floor((state_table[x].delta / 127) * DMC_HEIGHT)
    emu.drawLine(x - 1, y - sample_offset, x - 1, y + sample_offset, color)
  end
end

function draw_dmc_head(note, base_color)
  local foreground = 0x404040
  local background = 0x202020
  if note.playing then
    foreground = base_color
    background = apply_brightness(base_color, 0.5)
  end
  emu.drawRectangle(242, DMC_OFFSET - 6, 13, 13, background, true)
  emu.drawRectangle(241, DMC_OFFSET - 5, 15, 11, background, true)
  emu.drawLine(240, DMC_OFFSET - 3, 240, DMC_OFFSET + 3, 0x101010)
  --emu.drawString(243, DMC_OFFSET - 11, string.format("%02X", (note.address & 0xFF00) >> 8), foreground, background)
  --emu.drawString(243, DMC_OFFSET - 3, string.format("%02X", note.address & 0xFF), foreground, background)
  --emu.drawString(246, DMC_OFFSET + 5, string.format("%01X", note.rate), foreground, background)
  tiny_hex(241, DMC_OFFSET - 2, note.address, foreground, 4)
end

local old_mouse_state = {}

function is_region_clicked(x ,y, width, height, mouse_state)
  if mouse_state.left and not old_mouse_state.left then
    if mouse_state.x >= x and mouse_state.x < x + width and mouse_state.y >= y and mouse_state.y < y + height then
      return true
    end
  end
  return false
end

function handle_input()
  local mouse_state = emu.getMouseState()
  if is_region_clicked(0, 0, 256, 240, mouse_state) then
    toggle_background()
  end
  old_mouse_state = mouse_state
end

function mesen_draw()
  local state = emu.getState()
  local apu = state.apu

  --             x   y   str            fore: argb  back: argb 
  --emu.drawString(10, 10, "Hello Mesen",   0x80ff0000, 0x80FFFFFF)
  --emu.drawString(10, 20, "P1: "..apu.square1.period,   0xff0000, 0xFFFFFF)

  update_piano_roll(apu.square1, square1_roll)
  update_piano_roll(apu.square2, square2_roll)
  update_piano_roll(apu.triangle, triangle_roll)
  update_noise_roll(apu.noise, noise_roll)
  update_dmc_roll(apu.dmc, dmc_roll)

  draw_piano_background()
  draw_piano_strings()
  draw_piano_keys()
  draw_noise_strings()
  draw_noise_pads(noise_roll[#noise_roll])
  
  draw_piano_roll(emu, square1_roll, SQUARE1_COLOR) 
  draw_piano_roll(emu, square2_roll, SQUARE2_COLOR) 
  draw_piano_roll(emu, triangle_roll, TRIANGLE_COLOR)
  draw_noise_roll(emu, noise_roll, NOISE_COLOR)
  draw_dmc_roll(emu, dmc_roll, DMC_COLOR)
  draw_key_spot(square1_roll[#square1_roll], SQUARE1_COLOR)
  draw_key_spot(square2_roll[#square2_roll], SQUARE2_COLOR)
  draw_key_spot(triangle_roll[#square1_roll], TRIANGLE_COLOR)
  draw_dmc_head(dmc_roll[#dmc_roll], DMC_COLOR)

  handle_input()
end

emu.addEventCallback(mesen_draw, emu.eventType.endFrame);