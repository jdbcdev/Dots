--local default_language = "en"

current_language = application:getLanguage()
current_language = "en"

-- Traduction
local en = {
				login = "LOGIN",
				start = "START",
				play = "PLAY",
				shop = "SHOP",
				best_score = "Best score",
				your_score = "Your score",
				resume = "Resume",
				main_menu = "Menu",
				try_again = "Try again",
				time_up = "TIME UP",
				score = "SCORE",
				paused = "PAUSED",
				add_powerup = "ADD MORE POWERUPS",
				diagonal = "DIAGONAL IN SIGHT",
				trash_dot = "TRASH DOT",
				moves_5 = "EXTRA MOVEMENTS",
				quit = "Quit application",
				sure = "Are you sure?",
				cancel = "Cancel",
				yes = "Yes",
				desc1 = "Five Extra movements",
				desc2 = "Removes 1 dot",
				desc3 = "Diagonals are allowed",
				not_enough_dots = "Not Enough Dots!",
				need_more = "You need more Dots for this. Would you like to buy some now?",
				no_thanks = "No Thanks",
				dots_added = " Dots added",
				ok = "OK"
				}

local es = {
				login = "LOGIN",
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
				diagonal = "DIAGONAL A LA VISTA",
				trash_dot = "PUNTO A LA BASURA",
				moves_5 = "MOVIMIENTOS EXTRA",
				quit = "Salir",
				sure = "¿Estás seguro?",
				cancel = "Cancelar",
				yes = "Si",
				desc1 = "5 Movimientos adicionales",
				desc2 = "Elimina 1 punto",
				desc3 = "Diagonales están permitidas",
				not_enough_dots = "No tienes Puntos!",
				need_more = "Necesitas más Puntos. ¿Quieres conseguir algunos ahora?",
				no_thanks = "No gracias",
				dots_added = " Puntos añadidos"
				}

local de = {
				login = "LOGIN",
				play = "SPIELEN",
				best_score = "beste ergebnis",
				your_score = "Ihr ergebnis",
				resume = "Fortsetzen",
				main_menu = "Menu",
				try_again = "Wiederholen",
				time_up = "Zeit bis",
				leaderboards = "Freunde punkten",
				paused = "ANGEHALTEN",
				add_powerup = "ADD MORE POWERUPS",
				diagonal = "DIAGONAL IN SIGHT",
				trash_dot = "TRASH DOT",
				moves_5 = "EXTRA MOVEMENTS",
				quit = "Verlassen",
				sure = "Sicher?",
				cancel = "Stornieren",
				yes = "Ja",
				desc1 = "Stoppt die uhr für 5 sekunden",
				desc2 = "Entfernt zwei arten von edelsteinen",
				desc3 = "Beseitigt eine art von juwel"
				}

local fr = {
				login = "LOGIN",
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
				diagonal = "DIAGONAL IN SIGHT",
				trash_dot = "TRASH DOT",
				moves_5 = "EXTRA MOVEMENTS",
				quit = "QUITTER",
				sure = "Sûr",
				cancel = "ANNULER",
				yes = "OUI",
				desc1 = "Arrête le temps pendant 5 secondes",
				desc2 = "Supprime deux types de bijoux",
				desc3 = "Élimine un type de bijou"
				}

local it = {
				login = "LOGIN",
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
				diagonal = "DIAGONAL IN SIGHT",
				trash_dot = "TRASH DOT",
				moves_5 = "EXTRA MOVEMENTS",
				quit = "SMETTERE",
				sure = "SICURO",
				cancel = "CANCELLARE",
				yes = "SI",
				desc1 = "Fermare il tempo per 5 secondi",
				desc2 = "Rimuove due tipi di gioielli",
				desc3 = "Elimina un tipo di gioiello"
				}
				
local pt = {	
				login = "LOGIN",
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
				diagonal = "DIAGONAL IN SIGHT",
				trash_dot = "TRASH DOT",
				moves_5 = "EXTRA MOVEMENTS",
				quit = "DESISTIR",
				sure = "CERTO",
				cancel = "CANCELAR",
				yes = "SIM",
				desc1 = "Pára o tempo por 5 segundos",
				desc2 = "Retira dois tipos de jóias",
				desc3 = "Elimina um tipo de jóia"
				}
				
local ko = {
				login = "로그인",
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
				diagonal = "DIAGONAL IN SIGHT",
				trash_dot = "TRASH DOT",
				moves_5 = "EXTRA MOVEMENTS",
				quit = "종료",
				sure = "확실한",
				cancel = "취소",
				yes = "예",
				desc1 = "5 초 클록을 정지",
				desc2 = "보석의 두 종류를 삭제",
				desc3 = "보석의 1 가지의 유형을 삭제한다"
				}

local ru = {
				login = "Войти",
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
				diagonal = "DIAGONAL IN SIGHT",
				trash_dot = "TRASH DOT",
				moves_5 = "EXTRA MOVEMENTS",
				quit = "выход",
				sure = "конечно",
				cancel = "отменить",
				yes = "да",
				desc1 = "Остановите часы в течение 5 секунд",
				desc2 = "Удаляет два типа драгоценных камней",
				desc3 = "Устраняет один тип драгоценного камня"
				}

local ja = {

				login = "ログイン",
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
				diagonal = "DIAGONAL IN SIGHT",
				trash_dot = "TRASH DOT",
				moves_5 = "EXTRA MOVEMENTS",
				quit = "やめる",
				sure = "確か",
				cancel = "キャンセル",
				yes = "はい",
				desc1 = "5秒間のクロックを停止します",
				desc2 = "宝石の二種類を削除します",
				desc3 = "宝石の1つのタイプを排除"
				}

local zh = {
				login = "注册",
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
				diagonal = "DIAGONAL IN SIGHT",
				trash_dot = "TRASH DOT",
				moves_5 = "EXTRA MOVEMENTS",
				quit = "退出",
				sure = "肯定",
				cancel = "取消",
				yes = "是的",
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