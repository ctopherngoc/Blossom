extends Node

var monsterTable
var itemTable
var equipmentTable

# Called when the node enters the scene tree for the first time.
func _ready():
	var data_file = File.new()
	data_file.open("res://data/GameDataTable.json", File.READ)
	var gamedata_json = JSON.parse(data_file.get_as_text())
	
	monsterTable = gamedata_json.result["MonsterTable"]
	itemTable = gamedata_json.result["ItemTable"]
	equipmentTable = gamedata_json.result["EquipmentTable"]
	
	data_file.close()

onready var bgm_dict = {
	'menu': preload("res://resources/sounds/bgm/menu_bgm.mp3"),
	'Remy': preload("res://resources/sounds/bgm/game_bgm.mp3"),
}

onready var menu_sound_dict = {
	'click': preload("res://resources/sounds/menu/button_click.mp3"),
	'hover': preload("res://resources/sounds/menu/button_hover.mp3"),
}

onready var region_dict = {
	'0001': "Remy",
}

onready var map_dict = {
	"100000": {"name": "Grassy Road 1 Test", "path": "res://scenes/maps/100000/100000.tscn", "region": "Remy", "bgm": "Remy"},
	"100001": {"name": "Grassy Road 1", "path": "res://scenes/maps/100001/100001.tscn", "region": "Remy", "bgm": "Remy"},
	"100002": {"name": "Grassy Road 2", "path": "res://scenes/maps/100002/100002.tscn", "region": "Remy", "bgm": "Remy"},
	"100003": {"name": "Grassy Road 3", "path": "res://scenes/maps/100003/100003.tscn", "region": "Remy", "bgm": "Remy"},
}

onready var job_dict = {
	"0": "Beginner",
	"1": "Warrior",
	"2": "Mage",
	"3": "Archer",
	"4": "Thief",
}

# no rfinger
onready var avatar_sprite = {
	"body": "res://assets/character/spritesheet/body/",
	"brow" : "res://assets/character/spritesheet/brow/",
	"earc" : "res://assets/character/spritesheet/earc/",
	"eye" : "res://assets/character/spritesheet/eye/",
	"hair": "res://assets/character/spritesheet/hair/",
	"head" : "res://assets/character/spritesheet/head/",
	"larm" : "res://assets/character/spritesheet/larm/",
	"lear" : "res://assets/character/spritesheet/lear/",
	"lfinger" : "res://assets/character/spritesheet/lfinger/",
	"lhand" : "res://assets/character/spritesheet/lhand/",
	"lleg" : "res://assets/character/spritesheet/lleg/",
	"mouth" : "res://assets/character/spritesheet/mouth/",
	"rarm" : "res://assets/character/spritesheet/rarm/",
	"rear" : "res://assets/character/spritesheet/rear/",
	"rhand" : "res://assets/character/spritesheet/rhand/",
	"rleg" : "res://assets/character/spritesheet/rleg/",
	}
	
onready var equipment_sprite = {
	"headgear" : "res://assets/character/spritesheet/headgear/",
	"bottom" : "res://assets/character/spritesheet/bottom/",
	"default" : "res://assets/character/spritesheet/default/",
	"earring" : "res://assets/character/spritesheet/earring/",
	"eyeacc" : "res://assets/character/spritesheet/eyeacc/",
	"faceacc" : "res://assets/character/spritesheet/faceacc/",
	"glove" : "res://assets/character/spritesheet/glove/",
	"lweapon" : "res://assets/character/spritesheet/lweapon/",
	"rweapon" : "res://assets/character/spritesheet/rweapon/",
	"tattoo" : "res://assets/character/spritesheet/tattoo/",
	"top" : "res://assets/character/spritesheet/top/",
}

onready var test_player = {
	"displayname": "test",
	"map": "100000",
	"avatar" : {
			"head": "1",
			"hair": "1",
			"hcolor": "1",
			"body": "1",
			"bcolor": "1",
			"brow": "1",
			"ear": "1",
			"mouth": "1",
			"eye": "1",
			"ecolor": "1",
		},
	"equipment": {
		"rweapon": {
			"id": 200005,
			"uniqueID":14333321,
			"job": 0,
			"type": "1h_sword",
			"name": "temp sword",
			"speed": 5,
			"slot": 7,
			"attack": 15,
			"magic": 0,
			"maxHealth": 0,
			"maxMana": 0,
			"strength": 5,
			"wisdom": 5,
			"dexterity": 5,
			"luck": 5,
			"movementSpeed": 0,
			"jumpSpeed": 0,
			"avoidability": 0,
			"defense": 0,
			"magicDefense": 0,
			"accuracy": 0,
			"bossPercent": 0,
			"damagePercent": 0,
			"critRate": 0,
			},# rwep
		#"lweapon": null,
	},#equip
	"stats": 
	{
		"base": {
			"maxRange": 50,
			"minRange": 0,
			"health": 50,
			"mana": 50,
			"maxHealth": 50,
			"maxMana": 50,
			"level": 1,
			"experience": 0,
			"class": 0,
			"job": 0,
			"sp": 0,
			"ap": 0,
			"strength": 4,
			"wisdom": 4,
			"dexterity": 4,
			"luck": 4,
			"movementSpeed": 100,
			"jumpSpeed": 200,
			"avoidability": 4,
			"defense": 0,
			"magicDefense": 0,
			"accuracy": 10,
			"bossPercent": 1,
			"damagePercent": 1,
			"critRate": 5,
		},
		"equipment": {
			"attack": 0,
			"magic": 0,
			"maxHealth": 0,
			"maxMana": 0,
			"strength": 0,
			"wisdom": 0,
			"dexterity": 0,
			"luck": 0,
			"movementSpeed": 0,
			"jumpSpeed": 0,
			"avoidability": 0,
			"defense": 0,
			"magicDefense": 0,
			"accuracy": 0,
			"bossPercent": 0,
			"damagePercent": 0,
			"critRate": 0,
		},
	},
	"inventory" : {
			"100000": 0,
	},
}

onready var weapon_speed = {
	"1" : null,
	"2" : null,
	"3" : null,
	"4" : 2.0,
	"5" : 2.2,
	"6" : null,
}

onready var string_validation = [
	"4r5e",
	"5h1t",
	"5hit",
	"a55",
	"anal",
	"anus",
	"ar5e",
	"arrse",
	"arse",
	"ass",
	"ass-fucker",
	"asses",
	"assfucker",
	"assfukka",
	"asshole",
	"assholes",
	"asswhole",
	"a_s_s",
	"b!tch",
	"b00bs",
	"b17ch",
	"b1tch",
	"ballbag",
	"balls",
	"ballsack",
	"bastard",
	"beastial",
	"beastiality",
	"bellend",
	"bestial",
	"bestiality",
	"bi+ch",
	"biatch",
	"bitch",
	"bitcher",
	"bitchers",
	"bitches",
	"bitchin",
	"bitching",
	"bloody",
	"blow job",
	"blowjob",
	"blowjobs",
	"boiolas",
	"bollock",
	"bollok",
	"boner",
	"boob",
	"boobs",
	"booobs",
	"boooobs",
	"booooobs",
	"booooooobs",
	"breasts",
	"buceta",
	"bugger",
	"bum",
	"bunny fucker",
	"butt",
	"butthole",
	"buttmuch",
	"buttplug",
	"c0ck",
	"c0cksucker",
	"carpet muncher",
	"cawk",
	"chink",
	"cipa",
	"cl1t",
	"clit",
	"clitoris",
	"clits",
	"cnut",
	"cock",
	"cock-sucker",
	"cockface",
	"cockhead",
	"cockmunch",
	"cockmuncher",
	"cocks",
	"cocksuck",
	"cocksucked",
	"cocksucker",
	"cocksucking",
	"cocksucks",
	"cocksuka",
	"cocksukka",
	"cok",
	"cokmuncher",
	"coksucka",
	"coon",
	"cox",
	"crap",
	"cum",
	"cummer",
	"cumming",
	"cums",
	"cumshot",
	"cunilingus",
	"cunillingus",
	"cunnilingus",
	"cunt",
	"cuntlick",
	"cuntlicker",
	"cuntlicking",
	"cunts",
	"cyalis",
	"cyberfuc",
	"cyberfuck",
	"cyberfucked",
	"cyberfucker",
	"cyberfuckers",
	"cyberfucking",
	"d1ck",
	"damn",
	"dick",
	"dickhead",
	"dildo",
	"dildos",
	"dink",
	"dinks",
	"dirsa",
	"dlck",
	"dog-fucker",
	"doggin",
	"dogging",
	"donkeyribber",
	"doosh",
	"duche",
	"dyke",
	"ejaculate",
	"ejaculated",
	"ejaculates",
	"ejaculating",
	"ejaculatings",
	"ejaculation",
	"ejakulate",
	"f u c k",
	"f u c k e r",
	"f4nny",
	"fag",
	"fagging",
	"faggitt",
	"faggot",
	"faggs",
	"fagot",
	"fagots",
	"fags",
	"fanny",
	"fannyflaps",
	"fannyfucker",
	"fanyy",
	"fatass",
	"fcuk",
	"fcuker",
	"fcuking",
	"feck",
	"fecker",
	"felching",
	"fellate",
	"fellatio",
	"fingerfuck",
	"fingerfucked",
	"fingerfucker",
	"fingerfuckers",
	"fingerfucking",
	"fingerfucks",
	"fistfuck",
	"fistfucked",
	"fistfucker",
	"fistfuckers",
	"fistfucking",
	"fistfuckings",
	"fistfucks",
	"flange",
	"fook",
	"fooker",
	"fuck",
	"fucka",
	"fucked",
	"fucker",
	"fuckers",
	"fuckhead",
	"fuckheads",
	"fuckin",
	"fucking",
	"fuckings",
	"fuckingshitmotherfucker",
	"fuckme",
	"fucks",
	"fuckwhit",
	"fuckwit",
	"fudge packer",
	"fudgepacker",
	"fuk",
	"fuker",
	"fukker",
	"fukkin",
	"fuks",
	"fukwhit",
	"fukwit",
	"fux",
	"fux0r",
	"f_u_c_k",
	"gangbang",
	"gangbanged",
	"gangbangs",
	"gaylord",
	"gaysex",
	"goatse",
	"God",
	"god-dam",
	"god-damned",
	"goddamn",
	"goddamned",
	"hardcoresex",
	"hell",
	"heshe",
	"hoar",
	"hoare",
	"hoer",
	"homo",
	"hore",
	"horniest",
	"horny",
	"hotsex",
	"jack-off",
	"jackoff",
	"jap",
	"jerk-off",
	"jism",
	"jiz",
	"jizm",
	"jizz",
	"kawk",
	"knob",
	"knobead",
	"knobed",
	"knobend",
	"knobhead",
	"knobjocky",
	"knobjokey",
	"kock",
	"kondum",
	"kondums",
	"kum",
	"kummer",
	"kumming",
	"kums",
	"kunilingus",
	"l3i+ch",
	"l3itch",
	"labia",
	"lmfao",
	"lust",
	"lusting",
	"m0f0",
	"m0fo",
	"m45terbate",
	"ma5terb8",
	"ma5terbate",
	"masochist",
	"master-bate",
	"masterb8",
	"masterbat*",
	"masterbat3",
	"masterbate",
	"masterbation",
	"masterbations",
	"masturbate",
	"mo-fo",
	"mof0",
	"mofo",
	"mothafuck",
	"mothafucka",
	"mothafuckas",
	"mothafuckaz",
	"mothafucked",
	"mothafucker",
	"mothafuckers",
	"mothafuckin",
	"mothafucking",
	"mothafuckings",
	"mothafucks",
	"mother fucker",
	"motherfuck",
	"motherfucked",
	"motherfucker",
	"motherfuckers",
	"motherfuckin",
	"motherfucking",
	"motherfuckings",
	"motherfuckka",
	"motherfucks",
	"muff",
	"mutha",
	"muthafecker",
	"muthafuckker",
	"muther",
	"mutherfucker",
	"n1gga",
	"n1gger",
	"nazi",
	"nigg3r",
	"nigg4h",
	"nigga",
	"niggah",
	"niggas",
	"niggaz",
	"nigger",
	"niggers",
	"nob",
	"nob jokey",
	"nobhead",
	"nobjocky",
	"nobjokey",
	"numbnuts",
	"nutsack",
	"orgasim",
	"orgasims",
	"orgasm",
	"orgasms",
	"p0rn",
	"pawn",
	"pecker",
	"penis",
	"penisfucker",
	"phonesex",
	"phuck",
	"phuk",
	"phuked",
	"phuking",
	"phukked",
	"phukking",
	"phuks",
	"phuq",
	"pigfucker",
	"pimpis",
	"piss",
	"pissed",
	"pisser",
	"pissers",
	"pisses",
	"pissflaps",
	"pissin",
	"pissing",
	"pissoff",
	"poop",
	"porn",
	"porno",
	"pornography",
	"pornos",
	"prick",
	"pricks",
	"pron",
	"pube",
	"pusse",
	"pussi",
	"pussies",
	"pussy",
	"pussys",
	"retard",
	"rimjaw",
	"rimming",
	"s hit",
	"s.o.b.",
	"semen",
	"sex",
	"sh!+",
	"sh!t",
	"sh1t",
	"shi+",
	"shit",
	"shitdick",
	"shite",
	"shited",
	"shitey",
	"shitfuck",
	"shitfull",
	"shithead",
	"shiting",
	"shitings",
	"shits",
	"shitted",
	"shitter",
	"shitters",
	"shitting",
	"shittings",
	"shitty",
	"skank",
	"slut",
	"sluts",
	"smegma",
	"smut",
	"snatch",
	"son-of-a-bitch",
	"s_h_i_t",
	"t1tt1e5",
	"t1tties",
	"teets",
	"testical",
	"testicle",
	"tit",
	"titfuck",
	"tits",
	"tittie5",
	"tittiefucker",
	"titties",
	"tittyfuck",
	"tittywank",
	"titwank",
	"tw4t",
	"twat",
	"twathead",
	"twatty",
	"twunt",
	"twunter",
	"v14gra",
	"v1gra",
	"vagina",
	"viagra",
	"vulva",
	"wanker",
	"whoar",
	"whore",
  ]

onready var experience_table = {
	'1': 20,
	'2': 38,
	'3': 72,
	'4': 137,
	'5': 260,
	'6': 364,
	'7': 510,
	'8': 714,
	'9': 1000,
	'10': 1400,
	'11': 1820,
	'12': 2366,
	'13': 3076,
	'14': 3999,
	'15': 5199,
	'16': 6759,
	'17': 8787,
	'18': 11423,
	'19': 14850,
	'20': 17820,
	'21': 21384,
	'22': 25661,
	'23': 30793,
	'24': 36952,
	'25': 40647,
	'26': 44712,
	'27': 49183,
	'28': 54101,
	'29': 59511,
	'30': 65462,
}

onready var item_preload = {
	"100000": preload("res://scenes/itemObjects/100000.tscn"),
	"item": preload("res://scenes/itemObjects/item.tscn"),
}
