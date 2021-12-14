extends Node2D

const SRC_PATH = "res://src"
const UPDATE_PATH = "user://update"

var Md5File = File.new()
var Md5Dic = {}

#const FILTER_DIR = [".import", "addons", "updater"]
#const FILTER_FILE = ["default_env.tres", "icon.png"]

const FILTER_DIR = []
const FILTER_FILE = []


func _ready():
	list_file()


func list_file():
	var dir = Directory.new()
	if !dir.file_exists(UPDATE_PATH):
		dir.make_dir(UPDATE_PATH)
	dir_list(SRC_PATH)
	Md5File.open(UPDATE_PATH + "/md5_list.dat", File.WRITE)
	Md5File.store_string(JSON.print(Md5Dic))
	Md5File.close()


func dir_list(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			var file_path = path + "/" + file_name
			if dir.current_is_dir():
				if !FILTER_DIR.has(file_name):
					dir_list(file_path)
			else:
				if !FILTER_FILE.has(file_name):
					if ResourceLoader.exists(file_path):
						var file = File.new()
						var md5 = file.get_md5(file_path)
						var key = String(file_path.hash())
						var pck_name = key + ".pck"
						var pck_path = UPDATE_PATH + "/" + pck_name
						Md5Dic[key] = {}
						Md5Dic[key]["md5"] = md5
						Md5Dic[key]["file"] = file_name
						Md5Dic[key]["pck"] = pck_name
						print("打包文件:" + file_path + "," + key)
						var packer = PCKPacker.new()
						packer.pck_start(pck_path)
						var import = path + "/" + file_name + ".import"
						if file.file_exists(import):
							var conf = ConfigFile.new()
							conf.load(import)
							var cache: String = conf.get_value("remap", "path")
							packer.add_file(cache, cache)
							packer.add_file(import, import)
						else:
							packer.add_file(file_path, file_path)
						packer.flush()
			file_name = dir.get_next()
		dir.list_dir_end()
