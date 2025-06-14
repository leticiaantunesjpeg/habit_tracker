import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from typing import List, Dict, Set

# Initialize Firebase Admin
import os

# Obter o caminho absoluto para o diretório raiz do projeto
project_root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
cred = credentials.Certificate(os.path.join(project_root, 'habit-tracker-a2222-firebase-adminsdk-fbsvc-4dad4095e6.json'))
firebase_admin.initialize_app(cred)
db = firestore.client()

# Categorias e seus contextos semânticos
HABIT_CATEGORIES = {
    'social': {
        'keywords': {'amigos', 'jantar', 'encontro', 'reunião', 'conversa', 'grupo', 'família', 
                    'social', 'pessoas', 'comunidade', 'festa', 'confraternização', 'networking',
                    'parentesco', 'relacionamento', 'interação', 'conexão', 'proximidade', 
                    'companhia', 'convívio', 'interagir', 'socializar', 'conversar', 'comunicar', 
                    'contato', 'parentes', 'colegas', 'vizinhos', 'conhecidos', 'amizade', 'carinho', 
                    'amor', 'comemoração', 'celebração', 'união', 'conjunto', 'coletivo', 'familiar',
                    'companherismo', 'amigável', 'intimidade', 'aproximação', 'confraternizar',
                    'comunidade', 'roda', 'círculo', 'grupo', 'reunir', 'visitar', 'ligar', 'telefonar',
                    'videochamada', 'café', 'chá', 'happy hour', 'almoço', 'jantar'},
        'activities': {
            'Jantar com amigos',
            'Encontro com família',
            'Café com amigos',
            'Ligação para amigos',
            'Reunião social',
            'Happy hour',
            'Almoço em grupo',
            'Videochamada família',
            'Encontro com colegas',
            'Reunião com parentes',
            'Festa de aniversário',
            'Almoço familiar',
            'Networking profissional',
            'Passeio com amigos',
            'Visitar parentes',
            'Brunch com amigas',
            'Confraternização',
            'Viagem em grupo',
            'Evento social',
            'Conversas ao vivo',
            'Reunião de família',
            'Encontro com velhos amigos',
            'Telefonema para os pais',
            'Videoconferência com avós',
            'Encontro de colegas de trabalho',
            'Café com os vizinhos',
            'Jogo com amigos',
            'Reunião de boas-vindas',
            'Chá da tarde em grupo',
            'Projeto voluntário em grupo',
            'Celebração de datas especiais',
            'Reunião com comunidade',
            'Clube do livro com amigos',
            'Assistir filme em grupo',
            'Organizar evento social'
        },
        'frequency': 'Semanal'
    },
    'lazer': {
        'keywords': {'diversão', 'hobby', 'jogar', 'assistir', 'música', 'arte', 'criativo',
                    'entretenimento', 'filme', 'série', 'desenhar', 'pintar', 'ler', 'livro',
                    'escrever', 'passatempo', 'relaxar', 'brincar', 'jogo', 'dançar', 'cantar',
                    'televisão', 'teatro', 'cinema', 'concerto', 'show', 'espetáculo', 'vídeo',
                    'desenho', 'literatura', 'leitura', 'coleção', 'colecionador', 'podcast',
                    'divertido', 'prazer', 'descansar', 'descontrair', 'recreação', 'distração',
                    'entretenimento', 'divertimento', 'brincadeira', 'aventura', 'experiência',
                    'exploração', 'criatividade', 'imaginação', 'hobbie', 'tempo livre', 'lazer',
                    'relaxamento', 'streaming', 'Netflix', 'Disney', 'Prime', 'YouTube', 'Twitch',
                    'videogame', 'console', 'computador', 'dispositivo', 'instrumento', 'violão',
                    'piano', 'teclado', 'guitarra', 'bateria', 'ukulele', 'flauta'},
        'activities': {
            'Jogar videogame',
            'Assistir série',
            'Tocar instrumento',
            'Hobby criativo',
            'Jardinagem',
            'Fazer quebra-cabeça',
            'Leitura por prazer',
            'Desenhar ou pintar',
            'Assistir filme',
            'Ouvir podcast',
            'Ouvir música',
            'Dançar por diversão',
            'Visitar museu online',
            'Jogos de tabuleiro',
            'Escrever histórias',
            'Fotografar paisagens',
            'Colecionar itens',
            'Fazer origami',
            'Caça-palavras',
            'Palavras cruzadas',
            'Tocar violão',
            'Tocar piano',
            'Pintura em aquarela',
            'Bordado criativo',
            'Escultura em argila',
            'Jogar xadrez',
            'Montar cubo mágico',
            'Montar LEGO',
            'Criar conteúdo para redes',
            'Assistir documentários',
            'Ler quadrinhos',
            'Cosplay',
            'Ver vídeos no YouTube',
            'Assistir concertos online',
            'Resolver sudoku',
            'Assistir campeonatos de e-sports',
            'Ler mangá',
            'Assistir anime',
            'Jogar jogos de cartas',
            'Praticar karaokê'
        },
        'frequency': 'Semanal'
    },
    'culinária': {
        'keywords': {'cozinhar', 'receita', 'comida', 'jantar', 'almoço', 'culinária', 'gastronomia',
                    'cozinha', 'preparo', 'ingrediente', 'tempero', 'assar', 'fritar', 'grelhar',
                    'cortar', 'picar', 'misturar', 'bater', 'liquidificar', 'panela', 'forno',
                    'frigideira', 'alimentação', 'refeição', 'prato', 'sobremesa', 'entrada', 
                    'confeitaria', 'padaria', 'doce', 'salgado', 'sobremesa', 'massa', 'pão', 'bolo',
                    'torta', 'salada', 'sopa', 'molho', 'condimento', 'especiaria', 'fruta', 'legume',
                    'verdura', 'grão', 'carne', 'peixe', 'frango', 'porco', 'vegetariano', 'vegano',
                    'orgânico', 'natural', 'saudável', 'nutrientes', 'sabores', 'degustação',
                    'marmita', 'lancheira', 'menu', 'cardápio', 'planejamento'},
        'activities': {
            'Cozinhar nova receita',
            'Preparar marmitas',
            'Experimentar culinária',
            'Planejar refeições',
            'Aula de culinária',
            'Fazer pão caseiro',
            'Preparar sobremesa',
            'Experimentar receita',
            'Cozinhar refeição saudável',
            'Preparar café da manhã',
            'Fazer comida regional',
            'Experimentar temperos',
            'Preparar jantar especial',
            'Fazer doce caseiro',
            'Preparar petiscos',
            'Montar tábua de frios',
            'Fazer suco natural',
            'Preparar smoothies',
            'Organizar despensa',
            'Planejar cardápio semanal',
            'Fazer massa caseira',
            'Assar bolo',
            'Preparar salada especial',
            'Fazer molhos caseiros',
            'Fermentar alimentos',
            'Preparar conservas',
            'Cozinhar para congelar',
            'Fazer granola caseira',
            'Preparar lanches saudáveis',
            'Montar marmitas fitness',
            'Cozinhar low carb',
            'Experimentar cozinha internacional',
            'Preparar brunch',
            'Fazer iogurte caseiro',
            'Assar cookies',
            'Preparar caldos',
            'Fazer chás especiais',
            'Fazer kombucha caseira',
            'Preparar guacamole',
            'Fazer sorvete caseiro'
        },
        'frequency': 'Semanal'
    },
    'aprendizado': {
        'keywords': {'estudar', 'aprender', 'curso', 'aula', 'praticar', 'conhecimento', 'educação',
                    'desenvolvimento', 'habilidade', 'capacitação', 'treinamento', 'leitura', 
                    'idioma', 'língua', 'inglês', 'espanhol', 'francês', 'alemão', 'italiano',
                    'programação', 'código', 'software', 'hardware', 'tecnologia', 'ciência',
                    'matemática', 'história', 'geografia', 'biologia', 'física', 'química',
                    'literatura', 'filosofia', 'psicologia', 'economia', 'direito', 'medicina',
                    'engenharia', 'arquitetura', 'artes', 'música', 'desenho', 'pintura',
                    'fotografia', 'concurso', 'vestibular', 'faculdade', 'universidade', 'escola'},
        'activities': {
            'Curso online',
            'Aula de idiomas', 
            'Tutorial novo',
            'Praticar habilidade',
            'Workshop virtual',
            'Estudar programação',
            'Estudar para concurso',
            'Ler livro técnico',
            'Aprender nova tecnologia',
            'Praticar idioma',
            'Desenvolver projeto pessoal',
            'Assistir documentário educativo',
            'Estudar matemática',
            'Aprender sobre finanças',
            'Estudar história',
            'Praticar escrita',
            'Aprender instrumento musical',
            'Estudar para certificação',
            'Resolver exercícios',
            'Ler artigos científicos',
            'Aprender fotografia',
            'Estudar física',
            'Aprender desenho',
            'Estudar literatura',
            'Aprender marketing digital',
            'Estudar psicologia',
            'Aprender sobre ciência de dados',
            'Estudar geografia',
            'Aprender sobre sustentabilidade',
            'Estudar direito'
        },
        'frequency': 'Diária'
    },
    'bem-estar': {
        'keywords': {'saúde', 'cuidado', 'relaxar', 'descanso', 'paz', 'mente', 'corpo', 'mental',
                    'emocional', 'físico', 'espiritual', 'meditação', 'relaxamento', 'respiração',
                    'sono', 'tranquilidade', 'estresse', 'ansiedade', 'depressão', 'autocuidado',
                    'autoestima', 'beleza', 'skincare', 'banho', 'massagem', 'spa', 'terapia',
                    'psicologia', 'psiquiatria', 'nutrição', 'hidratação', 'vitamina'},
        'activities': {
            'Momento mindfulness',
            'Rotina skincare',
            'Momento relax',
            'Auto-cuidado',
            'Pausa para descanso',
            'Meditação',
            'Yoga',
            'Respiração consciente',
            'Alongamento relaxante',
            'Banho relaxante',
            'Automassagem',
            'Sessão de skincare',
            'Diário de gratidão',
            'Técnicas de respiração',
            'Afirmações positivas',
            'Praticar silêncio',
            'Ritual noturno',
            'Hidratação do corpo',
            'Descanso mental',
            'Reflexão pessoal',
            'Tomar chá calmante',
            'Ler livro de autoajuda',
            'Escutar música relaxante',
            'Desconexão digital',
            'Relaxamento muscular'
        },
        'frequency': 'Diária'
    },
    'exercício': {
        'keywords': {'treino', 'exercício', 'academia', 'esporte', 'fitness', 'workout', 'físico',
                    'musculação', 'cardio', 'aeróbico', 'anaeróbico', 'força', 'resistência',
                    'flexibilidade', 'mobilidade', 'alongamento', 'esteira', 'bicicleta', 'natação',
                    'corrida', 'caminhada', 'peso', 'haltere', 'barra', 'jump', 'pilates', 'funcional',
                    'crossfit', 'hiit', 'circuito', 'abdominal', 'glúteo', 'perna', 'braço', 'costas',
                    'peito', 'ombro', 'bíceps', 'tríceps', 'quadríceps', 'panturrilha'},
        'activities': {
            'Academia',
            'Exercício em casa',
            'Caminhada',
            'Corrida',
            'Alongamento',
            'Treino funcional',
            'Yoga fitness',
            'Pilates',
            'Musculação',
            'Treino HIIT',
            'Treino de força',
            'Exercícios aeróbicos',
            'Natação',
            'Ciclismo',
            'Treino de pernas',
            'Treino de core',
            'Cardio em casa',
            'Treino de braços',
            'Treino de costas',
            'Treino de flexibilidade',
            'Jump',
            'Crossfit',
            'Dança fitness',
            'Aula de spinning',
            'Circuito funcional',
            'Treino intervalado',
            'Exercícios de mobilidade',
            'Treino ao ar livre',
            'Exercícios com peso',
            'Stretching'
        },
        'frequency': 'Diária'
    },
    'organização': {
        'keywords': {'organizar', 'planejamento', 'agenda', 'calendário', 'lista', 'tarefas',
                    'produtividade', 'eficiência', 'gestão', 'tempo', 'meta', 'objetivo',
                    'prioridade', 'rotina', 'hábito', 'sistema', 'método', 'estrutura', 'processo',
                    'fluxo', 'verificação', 'revisão', 'controle', 'monitoramento', 'decluttering',
                    'minimalismo', 'simplicidade', 'ordem', 'arrumação', 'limpeza'},
        'activities': {
            'Planejar a semana',
            'Organizar ambiente',
            'Limpar a casa',
            'Fazer lista de tarefas',
            'Definir metas',
            'Revisar objetivos',
            'Organizar armário',
            'Decluttering',
            'Planejar refeições',
            'Organizar arquivos',
            'Revisar finanças',
            'Montar rotina',
            'Organizar e-mails',
            'Gerenciar projetos',
            'Revisão semanal',
            'Planejar próximo mês',
            'Organizar gavetas',
            'Limpar celular',
            'Organizar agenda',
            'Revisar hábitos'
        ],
        'frequency': 'Semanal'
    },
    'finanças': {
        'keywords': {'dinheiro', 'finanças', 'orçamento', 'economia', 'investimento', 'poupança',
                    'gasto', 'despesa', 'receita', 'renda', 'salário', 'lucro', 'juros', 'bolsa',
                    'ação', 'fundo', 'aplicação', 'rendimento', 'imposto', 'taxa', 'financeiro',
                    'banco', 'crédito', 'débito', 'cartão', 'empréstimo', 'financiamento', 'dívida',
                    'educação financeira', 'independência financeira', 'liberdade financeira'},
        'activities': {
            'Revisar orçamento',
            'Controlar gastos',
            'Estudar investimentos',
            'Planejar economias',
            'Fazer planilha financeira',
            'Revisar despesas',
            'Organizar contas',
            'Aprender sobre finanças',
            'Pagar contas',
            'Analisar extrato bancário',
            'Definir metas financeiras',
            'Planejar aposentadoria',
            'Revisar investimentos',
            'Organizar documentos financeiros',
            'Pesquisar descontos',
            'Economizar para objetivo',
            'Revisar assinaturas',
            'Comparar preços',
            'Fazer compras conscientes',
            'Aprender sobre economia'
        ],
        'frequency': 'Semanal'
    }
}
}

def fetch_habit_data() -> List[Dict[str, str]]:
    """Busca os hábitos existentes do Firestore."""
    habits_ref = db.collection('habits')
    docs = habits_ref.stream()
    habits = []
    
    for doc in docs:
        data = doc.to_dict()
        name = data.get('name', '')
        frequency = data.get('frequency', '')
        if name:
            habits.append({'name': name, 'frequency': frequency})
    
    return habits

def learn_from_user_inputs() -> List[Dict[str, str]]:
    """Aprende com os inputs do usuário para melhorar as sugestões."""
    user_inputs = []
    
    # 1. Busca as entradas dos usuários na coleção user_inputs
    inputs_ref = db.collection('user_inputs')
    docs = inputs_ref.stream()
    
    for doc in docs:
        data = doc.to_dict()
        query = data.get('query', '')
        selected_suggestion = data.get('selected_suggestion', '')
        timestamp = data.get('timestamp')
        
        if query and selected_suggestion:
            # Identifica qual categoria melhor se encaixa com a entrada do usuário
            category = identify_category(query)
            
            if category:
                # Se já temos uma categoria, podemos adicionar esta entrada às atividades
                if selected_suggestion not in HABIT_CATEGORIES[category]['activities']:
                    frequency = data.get('frequency', HABIT_CATEGORIES[category]['frequency'])
                    user_inputs.append({
                        'name': selected_suggestion,
                        'frequency': frequency,
                        'category': category,
                        'query': query
                    })
    
    # 2. Busca consultas não correspondidas para criar novas categorias e palavras-chave
    unmatched_ref = db.collection('unmatched_queries')
    unmatched_docs = unmatched_ref.stream()
    
    for doc in unmatched_docs:
        data = doc.to_dict()
        query = data.get('query', '')
        frequency = data.get('frequency', '')
        
        if query and frequency:
            # Tenta identificar uma categoria, mesmo que não tenha correspondência perfeita
            category = identify_category(query)
            
            if category:
                # Adiciona as palavras do query como keywords para esta categoria
                words = set(query.lower().split())
                for word in words:
                    if len(word) > 3:  # palavras com mais de 3 letras são provavelmente relevantes
                        HABIT_CATEGORIES[category]['keywords'].add(word)
    
    return user_inputs

def identify_category(query: str) -> str:
    """Identifica a categoria mais apropriada para uma query."""
    query_words = set(query.lower().split())
    
    max_matches = 0
    best_category = None
    
    for category, data in HABIT_CATEGORIES.items():
        matches = len(query_words & data['keywords'])
        if matches > max_matches:
            max_matches = matches
            best_category = category
            
    return best_category

def format_suggestion(activity: str, frequency: str) -> str:
    """Formata a sugestão com a frequência adequada."""
    return f"{activity} ({frequency})"

def update_suggestions():
    """Atualiza o modelo de sugestões no Firestore."""
    # Busca hábitos existentes
    existing_habits = fetch_habit_data()
    
    # Busca inputs dos usuários para enriquecer o modelo
    user_inputs = learn_from_user_inputs()
    
    # Conjunto para armazenar todas as sugestões formatadas
    all_suggestions = set()
    
    # Adicionar hábitos existentes
    for habit in existing_habits:
        if 'name' in habit and 'frequency' in habit:
            all_suggestions.add(format_suggestion(habit['name'], habit['frequency']))
    
    # Adicionar sugestões padrão organizadas por categoria
    for category, data in HABIT_CATEGORIES.items():
        for activity in data['activities']:
            all_suggestions.add(format_suggestion(activity, data['frequency']))
    
    # Adicionar sugestões aprendidas com os inputs dos usuários
    for input_data in user_inputs:
        name = input_data.get('name')
        frequency = input_data.get('frequency')
        category = input_data.get('category')
        
        if name and frequency:
            all_suggestions.add(format_suggestion(name, frequency))
            
            # Adiciona esta atividade à categoria relevante se ainda não existir
            if category and name not in HABIT_CATEGORIES[category]['activities']:
                HABIT_CATEGORIES[category]['activities'].add(name)
                
                # Extrai palavras-chave da consulta para enriquecer o conjunto de keywords
                query = input_data.get('query', '')
                if query:
                    words = set(query.lower().split())
                    # Adiciona palavras relevantes que não sejam stopwords
                    for word in words:
                        if len(word) > 3:  # palavras com mais de 3 letras são provavelmente relevantes
                            HABIT_CATEGORIES[category]['keywords'].add(word)
    
    # Atualiza as sugestões no Firestore
    doc_ref = db.collection('ml_models').document('habit_suggestion_model')
    doc_ref.set({
        'suggestions': list(all_suggestions),
        'categories': {k: {
            'keywords': list(v['keywords']), 
            'frequency': v['frequency'],
            'activities': list(v['activities'])
        } for k, v in HABIT_CATEGORIES.items()},
        'last_updated': firestore.SERVER_TIMESTAMP
    })
    
    print(f"Updated {len(all_suggestions)} suggestions")
    print("Model updated successfully!")

if __name__ == "__main__":
    update_suggestions()
