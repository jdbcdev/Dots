
local default_language = "en"

current_language = application:getLanguage()
--current_language = "fr"

-- Traduction
local en = {
			title = "Jelly",
			title2 = "Sky",
			loading = "Loading",
			start = "START",
			tap_drop = "Tap to drop!",
			level = "Level",
			paused = "PAUSED",
			game_over = "Failed",
			quit = "Quit the game",
			yes = "Yes",
			sure = "Are you sure?",
			cancel = "Cancel",
			get_coins = "Get Coins",
			get_lives = "Get Lives",
			Music = "Music",
			Sound_effects = "Sound effects",
			Software_and_Tools = "Software and Tools",
			Contact = "Contact",
			lua_programming = "Lua programming language",
			}

local es = {
			title = "Jelly",
			title2 = "Sky",
			loading = "Cargando",
			start = "JUGAR",
			tap_drop = "Pulsa para jugar",
			level = "Nivel",
			paused = "PAUSA",
			game_over = "Fallaste",
			quit = "Salir del juego",
			yes = "Si",
			sure = "¿Estás seguro?",
			cancel = "Cancelar",
			get_coins = "Obtener Monedas",
			get_lives = "Obtener Vidas",
			Music = "Música",
			Sound_effects = "Efectos de sonido",
			Software_and_Tools = "Programas y herramientas",
			Contact = "Contacto",
			lua_programming = "Lenguaje de programación Lua",
			}

local de = {
			title = "Jelly",
			title2 = "Sky",
			loading = "Laden",
			start = "Spielen",
			tap_drop = "Tippen Sie!",
			level = "Ebene",
			paused = "Pause",
			game_over = "Gescheiterte",
			quit = "Beenden Sie das Spiel",
			yes = "Ja",
			sure = "Sind Sie sicher?",
			cancel = "stornieren",
			get_coins = "Holen Münzen",
			Music = "Musik",
			Sound_effects = "Geräuschkulisse",
			Software_and_Tools = "Software und Werkzeuge",
			Contact = "Kontakt",
			lua_programming = "Programmiersprache Lua",
			}

local fr = {
			title = "Jelly",
			title2 = "Sky",
			loading = "Chargement",
			start = "JOUER",
			tap_drop = "Cliquez ici!",
			level = "Niveau",
			paused = "PAUSE",
			game_over = "Manqué",
			quit = "Quittez le jeu",
			Music = "Musique",
			yes = "Oui",
			sure = "Etes-vous sûr?",
			cancel = "Annuler",
			get_coins = "Obtenir Pièces",
			Sound_effects = "Bruitage",
			Software_and_Tools = "Logiciel et outils",
			Contact = "Contacter",
			lua_programming = "Langage de programmation Lua",
			}

local it = {
			title = "Jelly",
			title2 = "Sky",
			loading = "Caricamento",
			start = "Giocare",
			tap_drop = "Tocca a cadere!",
			level = "Livello",
			paused = "PAUSA",
			game_over = "Mancato",
			quit = "Chiudere il gioco",
			yes = "Si",
			sure = "Are you sure?",
			cancel = "Cancellare",
			get_coins = "Ottenere Monete",
			Music = "Musica",
			Sound_effects = "Effetti sonori",
			Software_and_Tools = "Software e strumenti",
			Contact = "Contatto",
			lua_programming = "Linguaggio programmazione Lua",
			}
				
local pt = {
			title = "Jelly",
			title2 = "Sky",
			loading = "Carregamento",
			start = "Jogar",
			tap_drop = "Toque a cair!",
			level = "Nível",
			paused = "PAUSA",
			game_over = "Fracassado",
			quit = "Sair do jogo",
			yes = "Sim",
			sure = "Você tem certeza?",
			cancel = "Cancelar",
			get_coins = "Obter Moedas",
			Music = "Música",
			Sound_effects = "Efeitos sonoros",
			Software_and_Tools = "Programas e ferramentas",
			Contact = "Contato",
			lua_programming = "Linguagem de programação Lua",
			}
				
local ko = {
			title = "젤리",
			title2 = "하늘",
			loading = "로드",
			start = "놀이",
			tap_drop = "화면에 클릭",
			level = "수평",
			paused = "중지",
			game_over = "실패한",
			quit = "게임을 종료",
			yes = "예",
			sure = "확실 해요",
			cancel = "취소",
			get_coins = "동전을 얻을",
			Music = "음악",
			Sound_effects = "음향 효과",
			Software_and_Tools = "소프트웨어",
			Contact = "접촉",
			lua_programming = "프로그래밍 언어 루아",
			}

local ru = {
			title = "желе",
			title2 = "небо",
			loading = "НАГРУЗКИ",
			start = "играть",
			tap_drop = "Нажмите на экране",
			level = "уровень",
			paused = "пауза",
			game_over = "Не удалось",
			quit = "Выйти из игры",
			yes = "да",
			sure = "Вы уверены",
			cancel = "отменить",
			get_coins = "Получить монеты",
			Music = "музыка",
			Sound_effects = "звуковые эффекты",
			Software_and_Tools = "программное обеспечение",
			Contact = "связаться",
			lua_programming = "язык программирования Lua",
			}

local ja = {
			title = "ゼリー",
			title2 = "スカイ",
			loading = "積載",
			start = "遊ぶ",
			tap_drop = "画面をクリックして",
			level = "レベル",
			paused = "一時停止",
			game_over = "失敗した",
			quit = "ゲームを終了",
			yes = "はい",
			sure = "本気",
			cancel = "キャンセル",
			get_coins = "コインを取得",
			Music = "音楽",
			Sound_effects = "サウンドエフェクト",
			Software_and_Tools = "ソフトウェア",
			Contact = "連絡",
			lua_programming = "Luaのプログラミング言語",
			}

local zh = {
			title = "果冻",
			title2 = "天空",
			loading = "载入中",
			start = "玩",
			tap_drop = "点击屏幕上的",
			level = "级别",
			paused = "暂停",
			game_over = "失败",
			quit = "离开游戏",
			yes = "是的",
			sure = "你确定",
			cancel = "取消",
			get_coins = "得到金币",
			Music = "音乐",
			Sound_effects = "效果",
			Software_and_Tools = "软件和工具",
			Contact = "联系",
			lua_programming = "的Lua编程语言"
			}

local strings = {
	en=en,
	es=es,
	de=de,
	fr=fr,
	it=it,
	pt=pt,
	ko=ko,
	ru=ru,
	ja=ja,
	zh=zh
	}

function getString(key)
	
	local language = strings[current_language]
	if not language then
		language = strings[default_language]
	end
		
	local value = language[key]
	if value then
		return value
	else
		return key
	end
end

-- Return TTFont depending on language
function getTTFont(font, size, size2)

	local option_ttf 
	if (current_language == "ko" 
		or current_language == "ru"
		or current_language == "ja"
		or current_language == "zh") then
		
		local special_size = size2 or size
		option_ttf = TTFont.new("fonts/DroidSansFallback.ttf", special_size)
	else
		option_ttf = TTFont.new(font, size)
	end
	
	return option_ttf
end