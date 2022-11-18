-------------------------------------
-- B738 Captain's FMC
if PLANE_ICAO == "B738" then

	if not SUPPORTS_FLOATING_WINDOWS then
		-- to make sure the script doesn't stop old FlyWithLua versions
		logMsg("imgui not supported by your FlyWithLua version")
		return
	end

	-- x_on_click = create_dataref_table("B738_FMC_Display/x_on_click" , "Int")
	-- y_on_click = create_dataref_table("B738_FMC_Display/y_on_click" , "Int")

	blank_string = create_dataref_table("B738_fmc_display/blank_line" , "Data" )
	blank_string[0] = "                        "

	fmc_version = create_dataref_table("B738_fmc_display/version" , "Data" )
	fmc_version[0] = "v1.0"

	fmc_vdate = create_dataref_table("B738_fmc_display/version_date" , "Data" )
	fmc_vdate[0] = "2022-11-18"

	local form_width = 498
	local form_height = 778

	-- Store constants for formatting the screen and its position
	local screen_width = 344
	local screen_height = 276
	local screen_left = 86
	local screen_top = 61	

	local screen_bottom = screen_top + screen_height

	local font_scale_large = 2
	local font_scale_small = 1.375

	local column_x_start = 4	
	local column_x_inc = 14
	local line_y_start = 14
	local line_y_inc = 2.175

	-- Get necessary images for the form
	fmc_a1_image_id = float_wnd_load_image(SCRIPT_DIRECTORY .. "/B738_FMC_A1.png")
	fmc_a2_image_id = float_wnd_load_image(SCRIPT_DIRECTORY .. "/B738_FMC_A2.png")

	function fmc_on_build(fmc_wnd, x, y)
	
		local fmc_type = get("laminar/B738/fmc_type")
	
		-- Set background color to black
		imgui.PushStyleColor(imgui.constant.Col.WindowBg, 0xFF000000)
		
		-- Display FMC background image
		if fmc_type == 0 then
			imgui.Image(fmc_a1_image_id, form_width, form_height)
		else
			imgui.Image(fmc_a2_image_id, form_width, form_height)
		end
		
		-- Retrieve all of the necessary datarefs for the text display.  Note: Retrieve a dataref with all spaces to clear the buffer (I guess.)
		-- I attempted to use bound variables first, then a get() alone for each, but the subsequent blank datarefs would return the previous datarefs
		-- value with the current dataref superimposed on top of it.
		--
		-- If "laminar/B738/fmc1/Line00_C" was valued "RTE 1" and "laminar/B738/fmc1/Line00_G" was value " " then the "laminar/B738/fmc1/Line00_G"
		-- read would return " TE 1".
		-- 
		-- Strange behavior....
		local page_label_large_cyan = read_dataref("laminar/B738/fmc1/Line00_C")
		local page_label_large_green = read_dataref("laminar/B738/fmc1/Line00_G")
		local page_label_large = read_dataref("laminar/B738/fmc1/Line00_L")
		local page_label_small = read_dataref("laminar/B738/fmc1/Line00_S")
		local label_line_1_small = read_dataref("laminar/B738/fmc1/Line01_X")
		local label_line_1_large = read_dataref("laminar/B738/fmc1/Line01_LX")
		local line_1_large_green = read_dataref("laminar/B738/fmc1/Line01_G")	
		local line_1_large = read_dataref("laminar/B738/fmc1/Line01_L")
		local line_1_small = read_dataref("laminar/B738/fmc1/Line01_S")
		local label_line_2_small = read_dataref("laminar/B738/fmc1/Line02_X")
		local line_2_large_green = read_dataref("laminar/B738/fmc1/Line02_G")
		local line_2_large = read_dataref("laminar/B738/fmc1/Line02_L")
		local line_2_small = read_dataref("laminar/B738/fmc1/Line02_S")
		local label_line_3_small = read_dataref("laminar/B738/fmc1/Line03_X")
		local line_3_large_green = read_dataref("laminar/B738/fmc1/Line03_G")
		local line_3_large = read_dataref("laminar/B738/fmc1/Line03_L")
		local line_3_small = read_dataref("laminar/B738/fmc1/Line03_S")
		local label_line_4_small = read_dataref("laminar/B738/fmc1/Line04_X")
		local line_4_large_green = read_dataref("laminar/B738/fmc1/Line04_G")
		local line_4_large = read_dataref("laminar/B738/fmc1/Line04_L")
		local line_4_small = read_dataref("laminar/B738/fmc1/Line04_S")
		local label_line_5_small = read_dataref("laminar/B738/fmc1/Line05_X")
		local line_5_large_green = read_dataref("laminar/B738/fmc1/Line05_G")
		local line_5_large = read_dataref("laminar/B738/fmc1/Line05_L")
		local line_5_small = read_dataref("laminar/B738/fmc1/Line05_S")
		local label_line_6_small = read_dataref("laminar/B738/fmc1/Line06_X")
		local label_line_6_large = read_dataref("laminar/B738/fmc1/Line06_LX")
		local line_6_large_green = read_dataref("laminar/B738/fmc1/Line06_G")
		local line_6_large = read_dataref("laminar/B738/fmc1/Line06_L")
		local line_6_small = read_dataref("laminar/B738/fmc1/Line06_S")
		local entry_line_large = read_dataref("laminar/B738/fmc1/Line_entry")
		
		-- Get indicator statuses
		local exec_light = get("laminar/B738/indicators/fmc_exec_lights")
		local fmc_call = get("laminar/B738/fmc/fmc_dspy")
		local fmc_fail = get("laminar/B738/fmc/fmc_fail")
		local fmc_msg = get("laminar/B738/fmc/fmc_message")
		local fmc_offset = get("laminar/B738/fmc/fmc_offset")
		
		-- Draw the lines of text on the display.
		draw_fmc_line(000, string.sub(page_label_large_cyan,1,16), "largec")
		draw_fmc_line(000, page_label_large_green, "largeg")
		draw_fmc_line(000, page_label_large, "large")
		draw_fmc_line(-001, page_label_small, "small")
		draw_fmc_line(007, label_line_1_small, "small")
		draw_fmc_line(008, label_line_1_large, "large")
		draw_fmc_line(016, line_1_small, "small")
		draw_fmc_line(018, line_1_large_green, "largeg")
		draw_fmc_line(018, line_1_large, "large")
		draw_fmc_line(025, label_line_2_small, "small")
		draw_fmc_line(034, line_2_small, "small")
		draw_fmc_line(036, line_2_large_green, "largeg")
		draw_fmc_line(036, line_2_large, "large")
		draw_fmc_line(043, label_line_3_small, "small")
		draw_fmc_line(052, line_3_small, "small")
		draw_fmc_line(054, line_3_large_green, "largeg")
		draw_fmc_line(054, line_3_large, "large")
		draw_fmc_line(061, label_line_4_small, "small")
		draw_fmc_line(070, line_4_small, "small")
		draw_fmc_line(072, line_4_large_green, "largeg")
		draw_fmc_line(072, line_4_large, "large")
		draw_fmc_line(079, label_line_5_small, "small")
		draw_fmc_line(088, line_5_small, "small")
		draw_fmc_line(090, line_5_large_green, "largeg")
		draw_fmc_line(090, line_5_large, "large")
		draw_fmc_line(097, label_line_6_small, "small")
		draw_fmc_line(098, label_line_6_large, "large")
		draw_fmc_line(106, line_6_small, "small")
		draw_fmc_line(108, line_6_large_green, "largeg")	
		draw_fmc_line(108, line_6_large, "large")	
		draw_fmc_line(118, entry_line_large, "large")

		-- Display buttons
		fmc_button_handler("1L", 20, 100, 28, 22, "laminar/B738/button/fmc1_1L")
		fmc_button_handler("2L", 20, 139, 28, 22, "laminar/B738/button/fmc1_2L")
		fmc_button_handler("3L", 20, 177, 28, 24, "laminar/B738/button/fmc1_3L")
		fmc_button_handler("4L", 20, 216, 28, 23, "laminar/B738/button/fmc1_4L")
		fmc_button_handler("5L", 20, 255, 28, 24, "laminar/B738/button/fmc1_5L")
		fmc_button_handler("6L", 20, 294, 28, 23, "laminar/B738/button/fmc1_6L")
		fmc_button_handler("1R", 467, 100, 28, 22, "laminar/B738/button/fmc1_1R")
		fmc_button_handler("2R", 467, 139, 28, 22, "laminar/B738/button/fmc1_2R")
		fmc_button_handler("3R", 467, 177, 28, 24, "laminar/B738/button/fmc1_3R")
		fmc_button_handler("4R", 467, 216, 28, 23, "laminar/B738/button/fmc1_4R")
		fmc_button_handler("5R", 467, 255, 28, 24, "laminar/B738/button/fmc1_5R")
		fmc_button_handler("6R", 467, 294, 28, 23, "laminar/B738/button/fmc1_6R")
		
		-- Action buttons
		fmc_button_handler("init_ref", 66, 397, 51, 37, "laminar/B738/button/fmc1_init_ref")
		fmc_button_handler("rte", 128, 397, 50, 37, "laminar/B738/button/fmc1_rte")
		fmc_button_handler("clb", 189, 397, 50, 37, "laminar/B738/button/fmc1_clb")
		fmc_button_handler("crz", 251, 397, 50, 37, "laminar/B738/button/fmc1_crz")
		fmc_button_handler("des", 312, 397, 51, 37, "laminar/B738/button/fmc1_des")
		fmc_button_handler("menu", 66, 443, 51, 36, "laminar/B738/button/fmc1_menu")
		fmc_button_handler("legs", 128, 443, 50, 36, "laminar/B738/button/fmc1_legs")
		fmc_button_handler("dep_app", 189, 443, 50, 36, "laminar/B738/button/fmc1_dep_app")
		fmc_button_handler("hold", 251, 443, 50, 36, "laminar/B738/button/fmc1_hold")
		fmc_button_handler("prog", 312, 443, 51, 36, "laminar/B738/button/fmc1_prog")
		fmc_button_handler("exec", 395, 452, 45, 27, "laminar/B738/button/fmc1_exec")
		fmc_button_handler("n1_lim", 66, 489, 51, 35, "laminar/B738/button/fmc1_n1_lim")
		fmc_button_handler("fix", 128, 489, 50, 35, "laminar/B738/button/fmc1_fix")
		fmc_button_handler("prev_page", 66, 534, 51, 36, "laminar/B738/button/fmc1_prev_page")
		fmc_button_handler("next_page", 128, 534, 50, 36, "laminar/B738/button/fmc1_next_page")
		
		-- Numeric keypad
		fmc_button_handler("1", 68, 588, 33, 31, "laminar/B738/button/fmc1_1")
		fmc_button_handler("2", 117, 588, 33, 31, "laminar/B738/button/fmc1_2") 
		fmc_button_handler("3", 166, 588, 33, 31, "laminar/B738/button/fmc1_3")
		fmc_button_handler("4", 68, 634, 33, 32, "laminar/B738/button/fmc1_4") 
		fmc_button_handler("5", 117, 634, 33, 32, "laminar/B738/button/fmc1_5") 
		fmc_button_handler("6", 166, 634, 33, 32, "laminar/B738/button/fmc1_6")
		fmc_button_handler("7", 68, 681, 33, 31, "laminar/B738/button/fmc1_7") 
		fmc_button_handler("8", 117, 681, 33, 31, "laminar/B738/button/fmc1_8") 
		fmc_button_handler("9", 166, 681, 33, 31, "laminar/B738/button/fmc1_9")
		fmc_button_handler("period", 68, 727, 33, 32, "laminar/B738/button/fmc1_period")
		fmc_button_handler("0", 117, 727, 33, 32, "laminar/B738/button/fmc1_0")
		fmc_button_handler("minus", 166, 727, 33, 32, "laminar/B738/button/fmc1_minus")

		-- Alpha keypad
		fmc_button_handler("A", 219, 493, 32, 33, "laminar/B738/button/fmc1_A")
		fmc_button_handler("B", 267, 493, 33, 33, "laminar/B738/button/fmc1_B")
		fmc_button_handler("C", 315, 493, 33, 33, "laminar/B738/button/fmc1_C")
		fmc_button_handler("D", 363, 493, 33, 33, "laminar/B738/button/fmc1_D")
		fmc_button_handler("E", 411, 493, 34, 33, "laminar/B738/button/fmc1_E")
		fmc_button_handler("F", 219, 540, 32, 33, "laminar/B738/button/fmc1_F")
		fmc_button_handler("G", 267, 540, 33, 33, "laminar/B738/button/fmc1_G")
		fmc_button_handler("H", 315, 540, 33, 33, "laminar/B738/button/fmc1_H")
		fmc_button_handler("I", 363, 540, 33, 33, "laminar/B738/button/fmc1_I")
		fmc_button_handler("J", 411, 540, 34, 33, "laminar/B738/button/fmc1_J")
		fmc_button_handler("K", 219, 586, 32, 33, "laminar/B738/button/fmc1_K")
		fmc_button_handler("L", 267, 586, 33, 33, "laminar/B738/button/fmc1_L")
		fmc_button_handler("M", 315, 586, 33, 33, "laminar/B738/button/fmc1_M")
		fmc_button_handler("N", 363, 586, 33, 33, "laminar/B738/button/fmc1_N")
		fmc_button_handler("O", 411, 586, 34, 33, "laminar/B738/button/fmc1_O")
		fmc_button_handler("P", 219, 632, 32, 33, "laminar/B738/button/fmc1_P")
		fmc_button_handler("Q", 267, 632, 33, 33, "laminar/B738/button/fmc1_Q")
		fmc_button_handler("R", 315, 632, 33, 33, "laminar/B738/button/fmc1_R")
		fmc_button_handler("S", 363, 632, 33, 33, "laminar/B738/button/fmc1_S")
		fmc_button_handler("T", 411, 632, 34, 33, "laminar/B738/button/fmc1_T")
		fmc_button_handler("U", 219, 679, 32, 33, "laminar/B738/button/fmc1_U")
		fmc_button_handler("V", 267, 679, 33, 33, "laminar/B738/button/fmc1_V")
		fmc_button_handler("W", 315, 679, 33, 33, "laminar/B738/button/fmc1_W")
		fmc_button_handler("X", 363, 679, 33, 33, "laminar/B738/button/fmc1_X")
		fmc_button_handler("Y", 411, 679, 34, 33, "laminar/B738/button/fmc1_Y")
		fmc_button_handler("Z", 219, 725, 32, 33, "laminar/B738/button/fmc1_Z")
		fmc_button_handler("SP", 267, 725, 33, 33, "laminar/B738/button/fmc1_SP")
		fmc_button_handler("del", 315, 725, 33, 33, "laminar/B738/button/fmc1_del")
		fmc_button_handler("slash", 363, 725, 33, 33, "laminar/B738/button/fmc1_slash")
		fmc_button_handler("clr", 411, 725, 34, 33, "laminar/B738/button/fmc1_clr")
	
		-- Check the state of the EXEC indicator draw the appropriate state.
		if exec_light == 1 then
			color_index = 0xFF39C7CE
		else
			color_index = 0xFF363533
		end
		imgui.DrawList_AddCircleFilled(405, 443, 3.5, color_index)
		imgui.DrawList_AddCircleFilled(431, 443, 3.5, color_index)
		imgui.DrawList_AddRectFilled(405, 440 , 431, 446, color_index, 0)
		
		--Check status of CALL indicator
		if fmc_call == 1 then
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF39C7CE)
			imgui.SetWindowFontScale(1)
			imgui.SetCursorPos(39, 555)
			imgui.TextUnformatted("C")
			imgui.SetCursorPos(39, 567)
			imgui.TextUnformatted("A")	
			imgui.SetCursorPos(39, 579)
			imgui.TextUnformatted("L")	
			imgui.SetCursorPos(39, 591)
			imgui.TextUnformatted("L")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
		end
		
		--Check status of FAIL indicator
		if fmc_fail == 1 then
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF39C7CE)
			imgui.SetWindowFontScale(1)
			imgui.SetCursorPos(39.25, 617)
			imgui.TextUnformatted("F")
			imgui.SetCursorPos(39, 629)
			imgui.TextUnformatted("A")	
			imgui.SetCursorPos(39.5, 641)
			imgui.TextUnformatted("I")	
			imgui.SetCursorPos(39, 653)
			imgui.TextUnformatted("L")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
		end

		--Check status of MESSAGE indicator
		if fmc_msg == 1 then
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF39C7CE)
			imgui.SetWindowFontScale(1)
			imgui.SetCursorPos(470, 562)
			imgui.TextUnformatted("M")
			imgui.SetCursorPos(469, 574)
			imgui.TextUnformatted("S")	
			imgui.SetCursorPos(469, 586)
			imgui.TextUnformatted("G")	
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
		end
		
		--Check status of OFFSET indicator
		if fmc_offset == 1 then
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF39C7CE)
			imgui.SetWindowFontScale(1)
			imgui.SetCursorPos(469, 617)
			imgui.TextUnformatted("O")
			imgui.SetCursorPos(469.5, 629)
			imgui.TextUnformatted("F")	
			imgui.SetCursorPos(469, 641)
			imgui.TextUnformatted("S")	
			imgui.SetCursorPos(469, 653)
			imgui.TextUnformatted("T")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
		end
		
	end


	function fmc_fo_on_build(fmc_wnd, x, y)
	
		local fmc_type = get("laminar/B738/fmc_type")
	
		-- Set background color to black
		imgui.PushStyleColor(imgui.constant.Col.WindowBg, 0xFF000000)
		
		-- Display FMC background image
		if fmc_type == 0 then
			imgui.Image(fmc_a1_image_id, form_width, form_height)
		else
			imgui.Image(fmc_a2_image_id, form_width, form_height)
		end
		
		-- Retrieve all of the necessary datarefs for the text display.  Note: Retrieve a dataref with all spaces to clear the buffer (I guess.)
		-- I attempted to use bound variables first, then a get() alone for each, but the subsequent blank datarefs would return the previous datarefs
		-- value with the current dataref superimposed on top of it.
		--
		-- If "laminar/B738/fmc1/Line00_C" was valued "RTE 1" and "laminar/B738/fmc1/Line00_G" was value " " then the "laminar/B738/fmc1/Line00_G"
		-- read would return " TE 1".
		-- 
		-- Strange behavior....
		local page_label_large_cyan = read_dataref("laminar/B738/fmc2/Line00_C")
		local page_label_large_green = read_dataref("laminar/B738/fmc2/Line00_G")
		local page_label_large = read_dataref("laminar/B738/fmc2/Line00_L")
		local page_label_small = read_dataref("laminar/B738/fmc2/Line00_S")
		local label_line_1_small = read_dataref("laminar/B738/fmc2/Line01_X")
		local label_line_1_large = read_dataref("laminar/B738/fmc2/Line01_LX")
		local line_1_large_green = read_dataref("laminar/B738/fmc2/Line01_G")	
		local line_1_large = read_dataref("laminar/B738/fmc2/Line01_L")
		local line_1_small = read_dataref("laminar/B738/fmc2/Line01_S")
		local label_line_2_small = read_dataref("laminar/B738/fmc2/Line02_X")
		local line_2_large_green = read_dataref("laminar/B738/fmc2/Line02_G")
		local line_2_large = read_dataref("laminar/B738/fmc2/Line02_L")
		local line_2_small = read_dataref("laminar/B738/fmc2/Line02_S")
		local label_line_3_small = read_dataref("laminar/B738/fmc2/Line03_X")
		local line_3_large_green = read_dataref("laminar/B738/fmc2/Line03_G")
		local line_3_large = read_dataref("laminar/B738/fmc2/Line03_L")
		local line_3_small = read_dataref("laminar/B738/fmc2/Line03_S")
		local label_line_4_small = read_dataref("laminar/B738/fmc2/Line04_X")
		local line_4_large_green = read_dataref("laminar/B738/fmc2/Line04_G")
		local line_4_large = read_dataref("laminar/B738/fmc2/Line04_L")
		local line_4_small = read_dataref("laminar/B738/fmc2/Line04_S")
		local label_line_5_small = read_dataref("laminar/B738/fmc2/Line05_X")
		local line_5_large_green = read_dataref("laminar/B738/fmc2/Line05_G")
		local line_5_large = read_dataref("laminar/B738/fmc2/Line05_L")
		local line_5_small = read_dataref("laminar/B738/fmc2/Line05_S")
		local label_line_6_small = read_dataref("laminar/B738/fmc2/Line06_X")
		local label_line_6_large = read_dataref("laminar/B738/fmc2/Line06_LX")
		local line_6_large_green = read_dataref("laminar/B738/fmc2/Line06_G")
		local line_6_large = read_dataref("laminar/B738/fmc2/Line06_L")
		local line_6_small = read_dataref("laminar/B738/fmc2/Line06_S")
		local entry_line_large = read_dataref("laminar/B738/fmc2/Line_entry")
		
		-- Get indicator statuses
		local exec_light = get("laminar/B738/indicators/fmc_exec_lights")
		local fmc_call = get("laminar/B738/fmc/fmc_dspy")
		local fmc_fail = get("laminar/B738/fmc/fmc_fail")
		local fmc_msg = get("laminar/B738/fmc/fmc_message")
		local fmc_offset = get("laminar/B738/fmc/fmc_offset")
		
		-- Draw the lines of text on the display.
		draw_fmc_line(000, string.sub(page_label_large_cyan,1,16), "largec")
		draw_fmc_line(000, page_label_large_green, "largeg")
		draw_fmc_line(000, page_label_large, "large")
		draw_fmc_line(-001, page_label_small, "small")
		draw_fmc_line(007, label_line_1_small, "small")
		draw_fmc_line(008, label_line_1_large, "large")
		draw_fmc_line(016, line_1_small, "small")
		draw_fmc_line(018, line_1_large_green, "largeg")
		draw_fmc_line(018, line_1_large, "large")
		draw_fmc_line(025, label_line_2_small, "small")
		draw_fmc_line(034, line_2_small, "small")
		draw_fmc_line(036, line_2_large_green, "largeg")
		draw_fmc_line(036, line_2_large, "large")
		draw_fmc_line(043, label_line_3_small, "small")
		draw_fmc_line(052, line_3_small, "small")
		draw_fmc_line(054, line_3_large_green, "largeg")
		draw_fmc_line(054, line_3_large, "large")
		draw_fmc_line(061, label_line_4_small, "small")
		draw_fmc_line(070, line_4_small, "small")
		draw_fmc_line(072, line_4_large_green, "largeg")
		draw_fmc_line(072, line_4_large, "large")
		draw_fmc_line(079, label_line_5_small, "small")
		draw_fmc_line(088, line_5_small, "small")
		draw_fmc_line(090, line_5_large_green, "largeg")
		draw_fmc_line(090, line_5_large, "large")
		draw_fmc_line(097, label_line_6_small, "small")
		draw_fmc_line(098, label_line_6_large, "large")
		draw_fmc_line(106, line_6_small, "small")
		draw_fmc_line(108, line_6_large_green, "largeg")	
		draw_fmc_line(108, line_6_large, "large")	
		draw_fmc_line(118, entry_line_large, "large")

		-- Display buttons
		fmc_button_handler("1L", 20, 100, 28, 22, "laminar/B738/button/fmc2_1L")
		fmc_button_handler("2L", 20, 139, 28, 22, "laminar/B738/button/fmc2_2L")
		fmc_button_handler("3L", 20, 177, 28, 24, "laminar/B738/button/fmc2_3L")
		fmc_button_handler("4L", 20, 216, 28, 23, "laminar/B738/button/fmc2_4L")
		fmc_button_handler("5L", 20, 255, 28, 24, "laminar/B738/button/fmc2_5L")
		fmc_button_handler("6L", 20, 294, 28, 23, "laminar/B738/button/fmc2_6L")
		fmc_button_handler("1R", 467, 100, 28, 22, "laminar/B738/button/fmc2_1R")
		fmc_button_handler("2R", 467, 139, 28, 22, "laminar/B738/button/fmc2_2R")
		fmc_button_handler("3R", 467, 177, 28, 24, "laminar/B738/button/fmc2_3R")
		fmc_button_handler("4R", 467, 216, 28, 23, "laminar/B738/button/fmc2_4R")
		fmc_button_handler("5R", 467, 255, 28, 24, "laminar/B738/button/fmc2_5R")
		fmc_button_handler("6R", 467, 294, 28, 23, "laminar/B738/button/fmc2_6R")
		
		-- Action buttons
		fmc_button_handler("init_ref", 66, 397, 51, 37, "laminar/B738/button/fmc2_init_ref")
		fmc_button_handler("rte", 128, 397, 50, 37, "laminar/B738/button/fmc2_rte")
		fmc_button_handler("clb", 189, 397, 50, 37, "laminar/B738/button/fmc2_clb")
		fmc_button_handler("crz", 251, 397, 50, 37, "laminar/B738/button/fmc2_crz")
		fmc_button_handler("des", 312, 397, 51, 37, "laminar/B738/button/fmc2_des")
		fmc_button_handler("menu", 66, 443, 51, 36, "laminar/B738/button/fmc2_menu")
		fmc_button_handler("legs", 128, 443, 50, 36, "laminar/B738/button/fmc2_legs")
		fmc_button_handler("dep_app", 189, 443, 50, 36, "laminar/B738/button/fmc2_dep_app")
		fmc_button_handler("hold", 251, 443, 50, 36, "laminar/B738/button/fmc2_hold")
		fmc_button_handler("prog", 312, 443, 51, 36, "laminar/B738/button/fmc2_prog")
		fmc_button_handler("exec", 395, 452, 45, 27, "laminar/B738/button/fmc2_exec")
		fmc_button_handler("n1_lim", 66, 489, 51, 35, "laminar/B738/button/fmc2_n1_lim")
		fmc_button_handler("fix", 128, 489, 50, 35, "laminar/B738/button/fmc2_fix")
		fmc_button_handler("prev_page", 66, 534, 51, 36, "laminar/B738/button/fmc2_prev_page")
		fmc_button_handler("next_page", 128, 534, 50, 36, "laminar/B738/button/fmc2_next_page")
		
		-- Numeric keypad
		fmc_button_handler("1", 68, 588, 33, 31, "laminar/B738/button/fmc2_1")
		fmc_button_handler("2", 117, 588, 33, 31, "laminar/B738/button/fmc2_2") 
		fmc_button_handler("3", 166, 588, 33, 31, "laminar/B738/button/fmc2_3")
		fmc_button_handler("4", 68, 634, 33, 32, "laminar/B738/button/fmc2_4") 
		fmc_button_handler("5", 117, 634, 33, 32, "laminar/B738/button/fmc2_5") 
		fmc_button_handler("6", 166, 634, 33, 32, "laminar/B738/button/fmc2_6")
		fmc_button_handler("7", 68, 681, 33, 31, "laminar/B738/button/fmc2_7") 
		fmc_button_handler("8", 117, 681, 33, 31, "laminar/B738/button/fmc2_8") 
		fmc_button_handler("9", 166, 681, 33, 31, "laminar/B738/button/fmc2_9")
		fmc_button_handler("period", 68, 727, 33, 32, "laminar/B738/button/fmc2_period")
		fmc_button_handler("0", 117, 727, 33, 32, "laminar/B738/button/fmc2_0")
		fmc_button_handler("minus", 166, 727, 33, 32, "laminar/B738/button/fmc2_minus")

		-- Alpha keypad
		fmc_button_handler("A", 219, 493, 32, 33, "laminar/B738/button/fmc2_A")
		fmc_button_handler("B", 267, 493, 33, 33, "laminar/B738/button/fmc2_B")
		fmc_button_handler("C", 315, 493, 33, 33, "laminar/B738/button/fmc2_C")
		fmc_button_handler("D", 363, 493, 33, 33, "laminar/B738/button/fmc2_D")
		fmc_button_handler("E", 411, 493, 34, 33, "laminar/B738/button/fmc2_E")
		fmc_button_handler("F", 219, 540, 32, 33, "laminar/B738/button/fmc2_F")
		fmc_button_handler("G", 267, 540, 33, 33, "laminar/B738/button/fmc2_G")
		fmc_button_handler("H", 315, 540, 33, 33, "laminar/B738/button/fmc2_H")
		fmc_button_handler("I", 363, 540, 33, 33, "laminar/B738/button/fmc2_I")
		fmc_button_handler("J", 411, 540, 34, 33, "laminar/B738/button/fmc2_J")
		fmc_button_handler("K", 219, 586, 32, 33, "laminar/B738/button/fmc2_K")
		fmc_button_handler("L", 267, 586, 33, 33, "laminar/B738/button/fmc2_L")
		fmc_button_handler("M", 315, 586, 33, 33, "laminar/B738/button/fmc2_M")
		fmc_button_handler("N", 363, 586, 33, 33, "laminar/B738/button/fmc2_N")
		fmc_button_handler("O", 411, 586, 34, 33, "laminar/B738/button/fmc2_O")
		fmc_button_handler("P", 219, 632, 32, 33, "laminar/B738/button/fmc2_P")
		fmc_button_handler("Q", 267, 632, 33, 33, "laminar/B738/button/fmc2_Q")
		fmc_button_handler("R", 315, 632, 33, 33, "laminar/B738/button/fmc2_R")
		fmc_button_handler("S", 363, 632, 33, 33, "laminar/B738/button/fmc2_S")
		fmc_button_handler("T", 411, 632, 34, 33, "laminar/B738/button/fmc2_T")
		fmc_button_handler("U", 219, 679, 32, 33, "laminar/B738/button/fmc2_U")
		fmc_button_handler("V", 267, 679, 33, 33, "laminar/B738/button/fmc2_V")
		fmc_button_handler("W", 315, 679, 33, 33, "laminar/B738/button/fmc2_W")
		fmc_button_handler("X", 363, 679, 33, 33, "laminar/B738/button/fmc2_X")
		fmc_button_handler("Y", 411, 679, 34, 33, "laminar/B738/button/fmc2_Y")
		fmc_button_handler("Z", 219, 725, 32, 33, "laminar/B738/button/fmc2_Z")
		fmc_button_handler("SP", 267, 725, 33, 33, "laminar/B738/button/fmc2_SP")
		fmc_button_handler("del", 315, 725, 33, 33, "laminar/B738/button/fmc2_del")
		fmc_button_handler("slash", 363, 725, 33, 33, "laminar/B738/button/fmc2_slash")
		fmc_button_handler("clr", 411, 725, 34, 33, "laminar/B738/button/fmc2_clr")
	
		-- Check the state of the EXEC indicator draw the appropriate state.
		if exec_light == 1 then
			color_index = 0xFF39C7CE
		else
			color_index = 0xFF363533
		end
		imgui.DrawList_AddCircleFilled(405, 443, 3.5, color_index)
		imgui.DrawList_AddCircleFilled(431, 443, 3.5, color_index)
		imgui.DrawList_AddRectFilled(405, 440 , 431, 446, color_index, 0)
		
		--Check status of CALL indicator
		if fmc_call == 1 then
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF39C7CE)
			imgui.SetWindowFontScale(1)
			imgui.SetCursorPos(39, 555)
			imgui.TextUnformatted("C")
			imgui.SetCursorPos(39, 567)
			imgui.TextUnformatted("A")	
			imgui.SetCursorPos(39, 579)
			imgui.TextUnformatted("L")	
			imgui.SetCursorPos(39, 591)
			imgui.TextUnformatted("L")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
		end
		
		--Check status of FAIL indicator
		if fmc_fail == 1 then
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF39C7CE)
			imgui.SetWindowFontScale(1)
			imgui.SetCursorPos(39.25, 617)
			imgui.TextUnformatted("F")
			imgui.SetCursorPos(39, 629)
			imgui.TextUnformatted("A")	
			imgui.SetCursorPos(39.5, 641)
			imgui.TextUnformatted("I")	
			imgui.SetCursorPos(39, 653)
			imgui.TextUnformatted("L")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
		end

		--Check status of MESSAGE indicator
		if fmc_msg == 1 then
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF39C7CE)
			imgui.SetWindowFontScale(1)
			imgui.SetCursorPos(470, 562)
			imgui.TextUnformatted("M")
			imgui.SetCursorPos(469, 574)
			imgui.TextUnformatted("S")	
			imgui.SetCursorPos(469, 586)
			imgui.TextUnformatted("G")	
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
		end
		
		--Check status of OFFSET indicator
		if fmc_offset == 1 then
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF39C7CE)
			imgui.SetWindowFontScale(1)
			imgui.SetCursorPos(469, 617)
			imgui.TextUnformatted("O")
			imgui.SetCursorPos(469.5, 629)
			imgui.TextUnformatted("F")	
			imgui.SetCursorPos(469, 641)
			imgui.TextUnformatted("S")	
			imgui.SetCursorPos(469, 653)
			imgui.TextUnformatted("T")
			imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
		end
		
	end


	-- This function simplifies the creation and handling of buttons
	function fmc_button_handler(fmc_button, pos_x, pos_y, size_x, size_y, cmd)
	
		-- Set the button text color to white, but also transparent
		imgui.PushStyleColor(imgui.constant.Col.Text, 0x00FFFFFF)
		-- Set the normal button color to dark grey, but also transparent
		imgui.PushStyleColor(imgui.constant.Col.Button, 0x00404040)
		-- Set the button mouse over color to dark grey and 75% transparent
		imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0x40404040)
		-- Set the button clicked color to dark grey and 50% transparent
		imgui.PushStyleColor(imgui.constant.Col.ButtonActive, 0x80404040)
		-- Set the cursor position for the button's top-left corner
		imgui.SetCursorPos(pos_x, pos_y)
		-- Create the button and check its state
		if imgui.Button(fmc_button, size_x, size_y) then
			command_once(cmd)
		end
		-- Reset the text color to white and non-transparent
		imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
	end


	-- Retrieve the passed dataref, upcase, and then return it.
	function read_dataref(dataref_name)
		temp = get("B738_fmc_display/blank_line")
		return string.upper(get(dataref_name))
	end


	function draw_fmc_line(offset, text, style)
		local color_index = 0xFFFFFFFF
		if string.len(text) > 0 then
			for i=1, string.len(text) do
				if i < 25 then
					local display_text = string.sub(text,i,i)
					if style == "large" then
						-- Set text color to white
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
						
						-- Set the font scale
						imgui.SetWindowFontScale(font_scale_large)

					elseif style == "largec" then
						-- Set text color to cyan
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFC0C000)
						
						-- Set the font scale
						imgui.SetWindowFontScale(font_scale_large)

					elseif style == "largeg" then
						-- Set text color to green
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF00FF00)
						
						-- Set the font scale
						imgui.SetWindowFontScale(font_scale_large)				

					else
						-- Set text color to white
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
						
						-- Set the font scale
						imgui.SetWindowFontScale(font_scale_small)

					end
					if display_text == "*" then
						if style == "largec" then
							color_index = 0xFFC0C000
						elseif style == "largeg" then
							color_index = 0xFF00FF00
						else
							color_index = 0xFFFFFFFF
						end
						text_width, text_height = imgui.CalcTextSize("L")
						x_left = screen_left + column_x_start + (column_x_inc * (i - 1)) + (column_x_inc - text_width) / 2 + 2
						y_top = screen_top + line_y_start + (line_y_inc * (offset + 4)) - 5
						x_right = x_left + text_width - 2
						y_bottom = y_top - text_height + 11
						imgui.DrawList_AddRect(x_left, y_top, x_right, y_bottom, color_index, 0)
					elseif display_text == "`" then
						text_width, text_height = imgui.CalcTextSize("L")
						x_center = screen_left + column_x_start + (column_x_inc * (i - 1)) + column_x_inc / 2 - 3
						if string.sub(style,1,5) == "large" then
							y_center = screen_top + line_y_start + (line_y_inc * offset) - 8
							deg_rad = 3
						else
							y_center = screen_top + line_y_start + (line_y_inc * offset) - 3
							deg_rad = 2
						end
						imgui.DrawList_AddCircle(x_center, y_center, deg_rad, color_index, 20, 1.5)
					else
						-- Get char height and width
						text_width, text_height = imgui.CalcTextSize(display_text)
						
						-- Calculate the position for the text
						imgui.SetCursorPos(screen_left + column_x_start + (column_x_inc * (i - 1)) + ((column_x_inc - text_width) / 2), screen_top + line_y_start + (line_y_inc * (offset + 4)) - text_height)
						
						-- Display the text
						imgui.TextUnformatted(display_text)
					end
				end
			end
		end
		-- Reset the font properties
		imgui.SetWindowFontScale(1.0)
		imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFFFF)
	end


	fmc_wnd = nil
    fmc_show_window = false		
	fmc_show_only_once = 0
	fmc_hide_only_once = 0

	
	function fmc_show_wnd()
		fmc_wnd = float_wnd_create(form_width+16, form_height+16, 1, true)
		float_wnd_set_title(fmc_wnd, "Captain - B738 FMC " .. fmc_version[0])
		float_wnd_set_imgui_builder(fmc_wnd, "fmc_on_build")
		float_wnd_set_resizing_limits(fmc_wnd, form_width+16, form_height+16, form_width+16, form_height+16)
	end


	function fmc_hide_wnd()
		if fmc_wnd then
			float_wnd_destroy(fmc_wnd)
		end
	end

	
	function toggle_fmc_display()
		fmc_show_window = not fmc_show_window
		if fmc_show_window then
			if fmc_show_only_once == 0 then
				fmc_show_wnd()
				fmc_show_only_once = 1
				fmc_hide_only_once = 0
			end
		else
			if fmc_hide_only_once == 0 then
				fmc_hide_wnd()
				fmc_hide_only_once = 1
				fmc_show_only_once = 0
			end
		end
	end


	fmc_fo_wnd = nil	
	fmc_fo_show_window = false
	fmc_fo_show_only_once = 0
	fmc_fo_hide_only_once = 0	

	
	function fmc_fo_show_wnd()
		fmc_fo_wnd = float_wnd_create(form_width+16, form_height+16, 1, true)
		float_wnd_set_title(fmc_fo_wnd, "First Officer - B738 FMC " .. fmc_version[0])
		float_wnd_set_imgui_builder(fmc_fo_wnd, "fmc_fo_on_build")
		float_wnd_set_resizing_limits(fmc_fo_wnd, form_width+16, form_height+16, form_width+16, form_height+16)
	end

	
	function fmc_fo_hide_wnd()
		if fmc_fo_wnd then
			float_fo_wnd_destroy(fmc_fo_wnd)
		end
	end
	
	
	function toggle_fmc_fo_display()
		fmc_fo_show_window = not fmc_fo_show_window
		if fmc_fo_show_window then
			if fmc_fo_show_only_once == 0 then
				fmc_fo_show_wnd()
				fmc_fo_show_only_once = 1
				fmc_fo_hide_only_once = 0
			end
		else
			if fmc_fo_hide_only_once == 0 then
				fmc_fo_hide_wnd()
				fmc_fo_hide_only_once = 1
				fmc_fo_show_only_once = 0
			end
		end
	end

	
	function fmc_on_keystroke()
		if CKEY == "c" and OPTION_KEY == true and KEY_ACTION == "pressed" then
			toggle_fmc_display()
		elseif CKEY == "f" and OPTION_KEY == true and KEY_ACTION == "pressed" then
			toggle_fmc_fo_display()
		end
		
	end
	
	do_on_keystroke("fmc_on_keystroke()")
	
end
