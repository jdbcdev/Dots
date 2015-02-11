--local default_language = "en"

current_language = application:getLanguage()
--current_language = "en"

-- Traduction
local en = {
				start = "START",
				play = "PLAY",
				shop = "SHOP",
				best_score = "Best score",
				your_score = "Your score",
				resume = "Resume",
				main_menu = "Menu",
				try_again = "Try again",
				time_up = "TIME UP",
				leaderboards = "LEADERBOARDS",
				paused = "PAUSED",
				add_powerup = "ADD MORE POWERUPS",
				jewels = "JEWELS:",
				one_dagger = "ONE DAGGER",
				two_daggers = "TWO DAGGERS",
				moves_5 = "Five extra moves",
				quit = "Quit application",
				sure = "Are you sure?",
				cancel = "Cancel",
				yes = "Yes",
				add_more_jewels = "ADD MORE JEWELS",
				you_have = "You have",
				desc1 = "Stops the clock for 5 seconds",
				desc2 = "Removes two types of jewels",
				desc3 = "Eliminates one type of jewel",
				not_enough_jewels = "Not Enough Jewels!",
				need_more = "You need more Jewels for this. Would you like to buy some now?",
				no_thanks = "No Thanks"
				}

local es = {
				start = "EMPEZAR",
				play = "JUGAR",
				shop = "TIENDA",
				best_score = "Mejor puntuación",
				your_score = "Puntuación",
				resume = "Continuar",
				main_menu = "Menu",
				try_again = "Reintentar",
				time_up = "TIEMPO",
				leaderboards = "PUNTUACIONES",
				paused = "PAUSA",
				add_powerup = "CONSIGUE EXTRAS",
				jewels = "JOYAS:",
				one_dagger = "UNA DAGA",
				two_daggers = "DOS DAGAS",
				moves_5 = "Five extra moves",
				quit = "Salir",
				sure = "¿Estás seguro?",
				cancel = "Cancelar",
				yes = "Si",
				add_more_jewels = "CONSEGUIR JOYAS",
				you_have = "Tienes",
				desc1 = "Para el tiempo 5 segundos",
				desc2 = "Elimina 2 tipos de joyas",
				desc3 = "Elimina 1 tipo de joya"
				}

local de = {
				play = "SPIELEN",
				best_score = "beste ergebnis",
				your_score = "Ihr ergebnis",
				resume = "Fortsetzen",
				main_menu = "Menu",
				try_again = "Wiederholen",
				time_up = "Zeit bis",
				leaderboards = "Freunde punkten",
				paused = "ANGEHALTEN",
				add_powerup = "FÜGEN SIE POWER-UPS",
				jewels = "JUWELEN:",
				one_dagger = "EIN DOLCH",
				two_daggers = "ZWEI DOLCHE",
				moves_5 = "Five extra moves",
				quit = "Verlassen",
				sure = "Sicher?",
				cancel = "Stornieren",
				yes = "Ja",
				add_more_jewels = "FÜGEN SIE MEHR JUWELEN",
				you_have = "Sie haben",
				desc1 = "Stoppt die uhr für 5 sekunden",
				desc2 = "Entfernt zwei arten von edelsteinen",
				desc3 = "Beseitigt eine art von juwel"
				}

local fr = {
				play = "JOUER",
				best_score = "Meilleur score",
				your_score = "Votre score",
				resume = "Reprendre",
				main_menu = "Menu",
				try_again = "Rejouer",
				time_up = "Temps",
				friends_score = "Le score amis",
				paused = "PAUSE",
				add_powerup = "AJOUTER DES POWER-UPS",
				jewels = "BIJOUX:",
				one_dagger = "UN POIGNARD",
				two_daggers = "DEUX POIGNARDS",
				moves_5 = "Five extra moves",
				quit = "QUITTER",
				sure = "Sûr",
				cancel = "ANNULER",
				yes = "OUI",
				add_more_jewels = "AJOUTER D'AUTRES BIJOUX",
				you_have = "Vous avez",
				desc1 = "Arrête le temps pendant 5 secondes",
				desc2 = "Supprime deux types de bijoux",
				desc3 = "Élimine un type de bijou"
				}

local it = {
				loading = "CARICAMENTO",
				play = "GIOCARE",
				best_score = "Miglior punteggio",
				your_score = "Il tuo punteggio",
				resume = "Riprendere",
				main_menu = "Menu",
				try_again = "Riprovare",
				time_up = "Tempo",
				leaderboards = "Amici punteggio",
				paused = "PAUSA",
				add_powerup = "AGGIUNGERE PIU POWER-UP",
				jewels = "GIOIE:",
				one_dagger = "UN PUGNALE",
				two_daggers = "DUE PUGNALI",
				moves_5 = "Five extra moves",
				quit = "SMETTERE",
				sure = "SICURO",
				cancel = "CANCELLARE",
				yes = "SI",
				add_more_jewels = "AGGIUNGERE PIU GIOIELLI",
				you_have = "Avete",
				desc1 = "Fermare il tempo per 5 secondi",
				desc2 = "Rimuove due tipi di gioielli",
				desc3 = "Elimina un tipo di gioiello"
				}
				
local pt = {	
				loading = "CARREGAMENTO",
				play = "JOGAR",
				best_score = "Melhor contagem",
				your_score = "Sua contagem",
				resume = "Retomar",
				main_menu = "Menu",
				try_again = "Reprise",
				time_up = "Tempo",
				leaderboards ="Amigos contagem",
				paused = "PAUSADA",
				add_powerup = "ADICIONAR MAIS POWER-UP",
				jewels = "JOIAS:",
				one_dagger = "UM PUNHAL",
				two_daggers = "DOIS PUNHAIS",
				moves_5 = "Five extra moves",
				quit = "DESISTIR",
				sure = "CERTO",
				cancel = "CANCELAR",
				yes = "SIM",
				add_more_jewels = "ADICIONAR MAIS JÓIAS",
				you_have = "Você tem",
				desc1 = "Pára o tempo por 5 segundos",
				desc2 = "Retira dois tipos de jóias",
				desc3 = "Elimina um tipo de jóia"
				}
				
local ko = {
				loading = "로딩",
				play = "놀이",
				best_score = "최고 점수",
				your_score = "점수",
				resume = "계속",
				main_menu = "메뉴",
				try_again = "다시 시도",
				time_up = "시간",
				leaderboards = "친구 득점",
				paused = "일시 정지",
				add_powerup = "더 파워 업을 추가",
				jewels = "보석:",
				one_dagger = "하나의 단검",
				two_daggers = "두 개의 단검",
				moves_5 = "Five extra moves",
				quit = "종료",
				sure = "확실한",
				cancel = "취소",
				yes = "예",
				add_more_jewels = "더 많은 보석을 추가",
				you_have = "당신은이",
				desc1 = "5 초 클록을 정지",
				desc2 = "보석의 두 종류를 삭제",
				desc3 = "보석의 1 가지의 유형을 삭제한다"
				}

local ru = {
				loading = "загрузка",
				play = "играть",
				best_score = "Лучший балл",
				your_score = "Ваша оценка",
				resume = "продолжать",
				main_menu = "меню",
				try_again = "Повторить",
				time_up = "время",
				leaderboards = "друзья забить",
				paused = "остановился",
				add_powerup = "добавить больше бонусы",
				jewels = "драгоценности:",
				one_dagger = "один кинжал",
				two_daggers = "два кинжала",
				moves_5 = "Five extra moves",
				quit = "выход",
				sure = "конечно",
				cancel = "отменить",
				yes = "да",
				add_more_jewels = "добавить больше драгоценностей",
				you_have = "у вас есть",
				desc1 = "Остановите часы в течение 5 секунд",
				desc2 = "Удаляет два типа драгоценных камней",
				desc3 = "Устраняет один тип драгоценного камня"
				}

local ja = {
				loading = "荷重",
				play = "遊ぶ",
				best_score = "最高のスコア",
				your_score = "あなたのスコア",
				resume = "再開する",
				main_menu = "メニュー",
				try_again = "リトライ",
				time_up = "時間",
				leaderboards = "友人はスコア",
				paused = "一時停止",
				add_powerup = "よりパワーアップを追加",
				jewels = "宝石:",
				one_dagger = "1短剣",
				two_daggers = "2短剣",
				moves_5 = "Five extra moves",
				quit = "やめる",
				sure = "確か",
				cancel = "キャンセル",
				yes = "はい",
				add_more_jewels = "より多くの宝石を追加",
				you_have = "あなたの宝石",
				desc1 = "5秒間のクロックを停止します",
				desc2 = "宝石の二種類を削除します",
				desc3 = "宝石の1つのタイプを排除"
				}

local zh = {
				loading = "载入中",
				play ="玩",
				best_score = "最好成绩",
				your_score = "你的分数",
				resume = "继续",
				main_menu = "菜单",
				try_again = "再试一次",
				time_up = "时间",
				leaderboards = "朋友进球",
				paused = "暂停",
				add_powerup = "添加更多的电",
				jewels = "珠宝:",
				one_dagger = "1匕首",
				two_daggers = "两把匕首",
				moves_5 = "Five extra moves",
				quit = "退出",
				sure = "肯定",
				cancel = "取消",
				yes = "是的",
				add_more_jewels = "添加更多的宝石",
				you_have = "你有",
				desc1 = "停止时钟5秒",
				desc2 = "删除两种类型的宝石",
				desc3 = "消除一种类型的宝石"
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
		option_ttf = TTFont.new("fonts/DroidSansFallBack.ttf", special_size)
	else
		option_ttf = TTFont.new(font, size)
	end
	
	return option_ttf
end