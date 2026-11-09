extends Control

const QUALITY_CHAINS := ["unfiltered", "hqx/hq4x", "eagle/super-eagle", "xbr/super-xbr-2p"]
const SETTINGS_PATH := "user://launcher.cfg"

var root_dir: String
var emulator: String
var rom_dir: String
var runtime_dir: String
var play: Button
var quality: OptionButton
var status: Label
var process_id := -1
var launch_time := 0
var smoke_test := false

func _ready() -> void:
	root_dir = ProjectSettings.globalize_path("res://").path_join("..").simplify_path()
	emulator = root_dir.path_join("tools/mame/mame.exe")
	rom_dir = root_dir.path_join("rom")
	runtime_dir = ProjectSettings.globalize_path("user://mame")
	build_ui()
	get_tree().auto_accept_quit = false

	smoke_test = "--smoke-test" in OS.get_cmdline_user_args()
	if smoke_test:
		start_game()
		if process_id < 0:
			printerr(status.text)
			get_tree().quit(1)

func build_ui() -> void:
	var backdrop := ColorRect.new()
	backdrop.color = Color("#12141d")
	add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var margin := MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 36)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 15)
	margin.add_child(column)
	add_text(column, "THE KING OF FIGHTERS ’97", 34, Color("#f4f0e9"))

	play = Button.new()
	play.text = "Start Game"
	play.custom_minimum_size = Vector2(180, 50)
	play.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	play.add_theme_font_size_override("font_size", 22)
	play.pressed.connect(start_game)
	column.add_child(play)
	play.grab_focus()

	var quality_row := HBoxContainer.new()
	quality_row.add_theme_constant_override("separation", 12)
	column.add_child(quality_row)
	var quality_label := add_text(quality_row, "Picture quality", 17, Color("#b5bbce"))
	quality_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	quality_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	quality = OptionButton.new()
	quality.custom_minimum_size = Vector2(160, 38)
	for label in ["Original pixels", "HQ4x", "Super Eagle", "Super xBR"]:
		quality.add_item(label)
	quality_row.add_child(quality)
	var settings := ConfigFile.new()
	settings.load(SETTINGS_PATH)
	var chain: Variant = settings.get_value("video", "chain", QUALITY_CHAINS[0])
	quality.select(maxi(0, QUALITY_CHAINS.find(chain)))
	quality.item_selected.connect(save_quality)

	add_text(column, "In the game window:\n5 / 6  Insert coin     |     1 / 2  Start player\nTab  Set keys     |     Esc  Return here", 17, Color("#b5bbce"))
	status = add_text(column, "", 17, Color("#f4f0e9"))

func add_text(parent: Container, value: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(label)
	return label

func save_quality(index: int) -> void:
	var settings := ConfigFile.new()
	settings.load(SETTINGS_PATH)
	settings.set_value("video", "chain", QUALITY_CHAINS[index])
	if settings.save(SETTINGS_PATH) != OK:
		status.text = "Could not save picture quality."

func game_args() -> PackedStringArray:
	return PackedStringArray([
		"kof97", "-bios", "euro", "-rompath", rom_dir,
		"-noreadconfig", "-cfg_directory", runtime_dir.path_join("cfg"),
		"-nvram_directory", runtime_dir.path_join("nvram"),
		"-snapshot_directory", runtime_dir.path_join("snap"),
		"-state_directory", runtime_dir.path_join("sta"),
		"-window", "-skip_gameinfo", "-video", "bgfx",
		"-bgfx_path", emulator.get_base_dir().path_join("bgfx"),
		"-artpath", emulator.get_base_dir().path_join("artwork"),
		# MAME resolves the chain by its file name and discovers subdirectories itself.
		"-bgfx_screen_chains", QUALITY_CHAINS[quality.selected].get_file()
	])

func start_game() -> void:
	for path in [emulator, rom_dir.path_join("kof97.zip"), rom_dir.path_join("neogeo.zip")]:
		if not FileAccess.file_exists(path):
			status.text = "Required file missing: " + path.get_file()
			return
	var args := game_args()
	if smoke_test:
		args.append_array(PackedStringArray([
			"-video", "none", "-sound", "none", "-seconds_to_run", "4"
		]))
	process_id = OS.create_process(emulator, args)
	if process_id < 0:
		status.text = "Could not start MAME."
		return
	launch_time = Time.get_ticks_msec()
	play.disabled = true
	quality.disabled = true
	status.text = "Game running. Press Esc in the game window to return."

func _process(_delta: float) -> void:
	if process_id < 0 or OS.is_process_running(process_id):
		return
	var exit_code := OS.get_process_exit_code(process_id)

	process_id = -1
	play.disabled = false
	quality.disabled = false
	play.grab_focus()
	if exit_code > 0:
		status.text = "MAME exited with code %d. Check the arcade files and BIOS." % exit_code
	elif exit_code < 0 and Time.get_ticks_msec() - launch_time < 2000:
		status.text = "MAME closed during startup. Check the arcade files and BIOS."
	else:
		status.text = ""
	if smoke_test:
		print("MAME exit code: ", exit_code)
		get_tree().quit(0 if exit_code == 0 and not play.disabled else 1)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if process_id >= 0 and OS.is_process_running(process_id):
			status.text = "Close the arcade window first so MAME can save your controls."
			return
		get_tree().quit()
