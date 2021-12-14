extends Node2D

var RemotePath = OS.get_user_data_dir().get_base_dir() + "/updater/update"
const LOCAL_PATH = "user://update"
const RES_PATH = "res://src"


func _ready():
	update_file()


func update_file():
	var file = File.new()
	var text_temp = ""
	var json_res = null
	var md5_file_new = RemotePath + "/md5_list.dat"
	if !file.file_exists(md5_file_new):
		print("未找到远程列表文件")
		return
	file.open(md5_file_new, File.READ)
	text_temp = file.get_as_text()
	file.close()
	json_res = JSON.parse(text_temp)
	var md5_dic_new: Dictionary = json_res.result
	var md5_file = LOCAL_PATH + "/md5_list.dat"
	var md5_dic = {}
	if file.file_exists(md5_file):
		print("存在本地列表文件")
		file.open(md5_file, File.READ)
		text_temp = file.get_as_text()
		file.close()
		json_res = JSON.parse(text_temp)
		md5_dic = json_res.result
	var keys = md5_dic_new.keys()
	var dir = Directory.new()
	if !dir.file_exists(LOCAL_PATH):
		dir.make_dir(LOCAL_PATH)
	for k in keys:
		var file_name: String = md5_dic_new[k]["file"]
		var pck_name = md5_dic_new[k]["pck"]
		var dst = LOCAL_PATH + "/" + pck_name
		if !md5_dic.has(k) || md5_dic[k]["md5"] != md5_dic_new[k]["md5"]:
			print("更新文件:" + dst)
			dir.copy(RemotePath + "/" + pck_name, dst)
		print("加载资源文件:" + file_name)
		ProjectSettings.load_resource_pack(dst)
	dir.copy(md5_file_new, md5_file)
	get_tree().change_scene(RES_PATH + "/Node2D.tscn")

