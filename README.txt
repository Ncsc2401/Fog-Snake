------ Sobre a complexidade do projeto ------

Esse projeto foi feito, inicialmente, apenas para a segunda fase do PSEL da FOG.
Entretanto, me diverti muito fazendo isso e acabou ficando bem grande.

Para a alma infortunada que vai ter que analisar isso, pra facilitar sua vida, você tem 2 opções:
a) Analisar o código do primeiro commit ("Snake base")
b) Seguir o mapa abaixo de onde cada ponto do projeto pode ser encontrado

------ Pontos Obrigatórios ------

"Deve ser um jogo digital, codificado a mão ou com auxílio de uma engine."
Acredito que esse ponto seja óbvio que foi satisfeito

"Devemos ser capazes de jogar o seu jogo."
Espero que isso também tenha sido satisfeito

"A cabeça se movimenta pela tela automaticamente, e sua direção é alterada quando uma seta for apertada."
Isso pode ser visto em qualquer fase do jogo (ao menos no momento que eu escrevo isso).
O código para a mecanica está distribuído em:
	res://Globals/global_signals.gd
	res://Scripts/Level/level_manager.gd
	res://Scripts/Snakes/snake.gd
	res://Scripts/Snakes/SnakeComponents/base_snake_component.gd
	res://Scripts/Snakes/SnakeComponents/MovementComponents/base_snake_movement_component.gd
	res://Scripts/Snakes/SnakeComponents/MovementComponents/normal_snake_movement_component.gd
	res://Scripts/Snakes/SnakeComponents/InputComponents/base_snake_input_component.gd
	res://Scripts/Snakes/SnakeComponents/InputComponents/normal_snake_input_component.gd

"O corpo deve seguir a cabeça."
Isso pode ser visto em qualquer fase do jogo.
O código para a mecanica está distribuído em:
	res://Scripts/Snakes/snake.gd
	res://Scripts/Snakes/SnakeComponents/base_snake_component.gd
	res://Scripts/Snakes/SnakeComponents/MovementComponents/base_snake_movement_component.gd
	res://Scripts/Snakes/SnakeComponents/MovementComponents/normal_snake_movement_component.gd

"Movimento restrito pelo tamanho da tela."
Isso pode ser visto nas primeiras fases do jogo.
O código para a mecanica está distribuído em:
	res://Scripts/Level/level_manager.gd
	res://Scripts/Snakes/snake.gd
	res://Scripts/Snakes/SnakeComponents/base_snake_component.gd
	res://Scripts/Snakes/SnakeComponents/DeathComponents/base_snake_death_component.gd
	res://Scripts/Snakes/SnakeComponents/DeathComponents/normal_snake_death_component.gd

"Comida deve ser gerada aleatoriamente na tela."
Isso pode ser visto nas primeiras fases do jogo.
O código para a mecanica está distribuído em:
	res://Scripts/Level/level_manager.gd
	res://Scripts/Actors/actor
	res://Scripts/Actors/Fruit/fruit
	res://Scripts/Actors/Fruit/FruitEatComponents/spawn_random_fruit_eat_component.gd
	res://Scripts/Actors/Fruit/fruit_spawner.gd

"O jogador pode pegar a comida e isso faz o corpo da cobra aumentar."
Isso pode ser visto nas primeiras fases do jogo.
O código para a mecanica está distribuído em:
	res://Scripts/Level/level_manager.gd
	res://Scripts/Snakes/snake.gd
	res://Scripts/Snakes/SnakeComponents/base_snake_component.gd
	res://Scripts/Snakes/SnakeComponents/EatComponents/base_snake_eat_component.gd
	res://Scripts/Snakes/SnakeComponents/EatComponents/normal_snake_eat_component.gd
	res://Scripts/Snakes/SnakeComponents/GrowComponents/base_grow_eat_component.gd
	res://Scripts/Snakes/SnakeComponents/GrowComponents/normal_grow_eat_component.gd
	res://Scripts/Actors/actor
	res://Scripts/Actors/Fruit/fruit
	res://Scripts/Actors/Fruit/fruit_resource

"O jogador perde se encostar no próprio corpo."
Isso pode ser visto em qualquer fase do jogo
O código para a mecanica está distribuído em:
	res://Scripts/Level/level_manager.gd
	res://Scripts/Snakes/snake.gd
	res://Scripts/Snakes/SnakeComponents/base_snake_component.gd
	res://Scripts/Snakes/SnakeComponents/DeathComponents/base_snake_death_component.gd
	res://Scripts/Snakes/SnakeComponents/DeathComponents/normal_snake_death_component.gd

------ Pontos Adicionais ------
"Fazer um menu inicial."
Isso pode ser visto iniciando o jogo.
O código e demais elementos para a mecanica estão distribuídos em:
	res://Scripts/Globals/game_state.gd
	res://Scripts/Menu/main_menu.gd
	res://Scenes/main_menu.tscn
	res://Assets/Sprites/MenuArtNoText.png

"Poder pausar o jogo."
Isso pode ser visto em qualquer fase do jogo.
O código e demais elemento para a mecanica estão distribuídos em:
	res://Scripts/Globals/game_state.gd
	res://Scripts/Menu/in_game_menu.gd
	res://Scenes/UI/in_game_menu.tscn

"Aumento da velocidade com o aumento do tamanho do corpo."
Isso pode servisto em qualquer fase com a fruta "Café", a exemplo, o level 11, "Coffee and Pills"
O código e demais elementos para a mecanica estão distribuídos em:
	res://Scripts/Globals/global_signals.gd
	res://Scripts/Level/level_manager.gd
	res://Scripts/Actors/actor
	res://Scripts/Actors/Fruit/fruit
	res://Scripts/Actors/Fruit/FruitEatComponents/change_game_speed_eat_component.gd
	res://Scenes/Fruits/coffee.tscn

"Tocar uma música durante o jogo e permitir o jogador desabilitar ela se quiser."
Implementei todo o sistema pra fazer isso acontecer, mas sou péssimo em fazer músicas então não tem nenhuma tocando. 
Obs: A fase "Maze" tem música
O código para a mecanica está distribuído em:
	res://Scripts/Globals/save_manager.gd
	res://Scripts/Settings/settings_data.gd
	res://Scripts/Settings/settings_ui.gd
	res://Scenes/UI/settings.tscn
	res://Scripts/Music/music_player.gd
	res://Scripts/Music/music_player_api_node.gd
	res://Scripts/Music/MusicPlayerActions
	res://Scenes/Music/music_player.tscn

"Criar um ranking das X melhores pontuações."
Isso pode ser visto no mapa depois de vencer uma fase
O código para a mecanica está distribuído em:
	res://Scripts/Globals/save_manager.gd
	res://Scripts/Level/level_manager.gd
	res://Scripts/Map/map.gd
	res://Scripts/Map/map_level_saveable.gd

"Itens que dão pontos bônus (e podem nascer em posições mais difíceis de alcançar)."
Isso pode ser visto em qualquer fase que não tenha só maçã
O código e demais elementos para a mecanica estão distribuídos em:
	res://Scripts/Level/level_manager.gd
	res://Scripts/Actors/actor
	res://Scripts/Actors/Fruit/fruit
	res://Scripts/Actors/Fruit/fruit_resource
	res://Scenes/Fruits/*.tscn (-apple.tscn)

"Opção de continuar o movimento da cobra em volta da tela (ex: quando a cobra
passa pelo limite direito ela sai na mesma altura pelo lado esquerdo)."
Não feito.

------ Como o projeto é estruturado ------

Todo level deve ter no mínimo um level manager e uma cobra
O level manager responde ao sinal Tick do global signals, o qual é emitido a cada x segundos (podendo variar).
O level manager tem uma referencia ao board data do level, lá os limites da fase são definidos em um dicionario na forma Vector2i -> CellType, sendo o CellType um vestigio do protótipo.
A board data não é feita manualmente, eu utilizo um tool script para gera-los a partir de um tilemap
O level manager ordena tudo para que tudo seja executado em ordem e sem uso de dados inválidos, sendo tudo controlado no tick_logic().
A cobra é desenhada em um tilemap.
A cobra e formada por componentes, cada componente especializado herda de um componente base e define o comportamento da cobra. Isso permite que componentes sejam trocados durante a execução do jogo sem problemas.
A cobra também tem componentes genericos, misc_components, que definem multiplas coisas, e agem como modificadores especiais e que diferentemente dos especializados, podem haver vários ao mesmo tempo.
Frutas e inimigos são classes que herdam de ator.
Um ator possui ações de ator (actor_actions), basicamente uma programação em blocos.
As actor actions possuem varios tipos, como Find, Choose, Move, SetMemory, etc, cada actor action costuma ter um componente interno para ações mais especificas.
Um ator também possui um cérebro (actor_brain), o cérebro guarda informações num dicionário utilizando chaves.
O contéudo do cérebro pode ser usado e alterado por diferentes actor actions.
Esse sistema de atores, possibilita a construção modular de inimigos e frutas.
Como exemplo, tomemos o knight. A programação dele é a seguinte:
	Tick 0 Prioridade 0 -> Encontra espaços livres em L
	Tick 0 Prioridade 1 -> Encontra todas as cobras vivas
	Tick 0 Prioridade 2 -> Escolhe uma cobra aleatória
	Tick 0 Prioridade 3 -> Encontra a posição da cabeça da cobra
	Tick 0 Prioridade 4 -> Escolhe o espaço livre mais perto da posição da cabeça da cobra
	Tick 4 Prioridade 0 -> Telegrafa a inteção de se movimentar
	Tick 7 Prioridade 0 -> Limpa os avisos de movimento
	Tick 7 Prioridade 1 -> Move para o espaço escolhido (ou não caso ele tenha sido ocupado)
O tick máximo dele é 7, o que significa que depois disso ele volta para o tick 0. Entretanto há actor action que agem como um goto, alterando o fluxo lógico
Além disso, como pode ser visto, as prioridades são executadas do menor para o maior.
Além disso, todo ator tem um alive component, que diz quando ele esta vivo.
O knight, por exemplo, morre quando não encontra espaços livres para se mover.
Quando um inimigo morre, ele chama o seu death component.
Quando uma fruta morre, nada acontece porque frutas, apesar de também possuir um alive component, não são checadas se estão vivas (ao menos por enquanto)
Por fim cada level possui um map level data, gerados manualmente, que contém dados para a navegação e desbloqueio de fase.
Para cada map level data é gerado um map level saveable data, que é o save da fase, contendo as estatísticas da fase.
O mapa precisa ser gerado sempre que fases são criadas, para isso uso um tool script que lê as map level datas e gera o mapa.

------ Cheat Codes ------

Para facilitar o debug do jogo, e pela piada, eu fiz um sistema de cheat code, quando estiver no mapa de seleção de fases, basta escrever o cheat code que ele será ativo.
Os cheat codes são:
	Código Konami (wwssadadba) -> Desbloqueia todas as fases
	White mode (whitemode) -> Faz o fundo ficar branco (facilita ver fases secretas e caminhos não desbloqueados)
	Speed up (speedup) -> Aumenta a velocidade do jogo (é stackavel)
	Slow up (slowup) -> Diminui a velocidade do jogo (é stackavel)
	Normal up (normalup) -> Reset a velocidade do jogo para o padrão

------ Fases ------

Toda fase é colorida para dizer seu tipo.
Os tipos são:
	Branco -> Fase comum ("campanha")
	Amarelo -> Fase extra
	Azul -> Fase especial
	Vermelho -> Fase desafio
	Preto -> Fase secreta
Fases comuns apresentam o jogo e as mecanicas de forma balanceada
Fases especiais constumam possuir mecanicas únicas e/ou muito diferentes
Fases amarelas são fases extras (Obviamente)
Fases desafio são fases difíceis (não garanto que sejam vencíveis).
Para navegar entre as fases, basta usar o WASD no mapa.
Para selecionar uma fase, basta clicar no botão "Play" ou apertar espaço.
Toda fase tem um título e um objetivo, os títulos, em sua maioria são piadas e/ou referencias, mas as vezes podem ser úteis por darem dicas de como faz o objetivo.
