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
                    'fotografia', 'concurso', 'vestibular', 'faculdade', 'universidade', 'escola',
                    'livro', 'apostila', 'vídeo-aula', 'tutoriais', 'exercícios', 'trabalho',
                    'monografia', 'tese', 'dissertação', 'artigo', 'paper', 'publicação',
                    'periódico', 'revista', 'resumo', 'ficha', 'anotação', 'memorização', 'prova',
                    'teste', 'simulado', 'avaliação', 'formação', 'certificado', 'diploma',
                    'graduação', 'pós-graduação', 'mestrado', 'doutorado', 'especialização',
                    'educacional', 'instrutivo', 'didático', 'pedagógico'},
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
            'Estudar direito',
            'Estudar para vestibular',
            'Resolver problemas matemáticos',
            'Praticar redação',
            'Estudar para o ENEM',
            'Memorizar fórmulas',
            'Realizar experimentos',
            'Aula de reforço escolar',
            'Revisar anotações de aula',
            'Praticar apresentações',
            'Montar grupo de estudos',
            'Aprender edição de vídeos',
            'Estudar economia',
            'Praticar conversação',
            'Estudar para prova',
            'Aula de desenho',
            'Aprender sobre astronomia',
            'Estudar neurociência',
            'Curso de machine learning'
        },
        'frequency': 'Diária'
    },
    'bem-estar': {
        'keywords': {'saúde', 'cuidado', 'relaxar', 'descanso', 'paz', 'mente', 'corpo', 'mental',
                    'emocional', 'físico', 'espiritual', 'meditação', 'relaxamento', 'respiração',
                    'sono', 'tranquilidade', 'estresse', 'ansiedade', 'depressão', 'autocuidado',
                    'autoestima', 'beleza', 'skincare', 'banho', 'massagem', 'spa', 'terapia',
                    'psicologia', 'psiquiatria', 'nutrição', 'hidratação', 'vitamina', 'equilíbrio',
                    'harmonia', 'energia', 'vitalidade', 'calma', 'serenidade', 'conforto',
                    'autoconhecimento', 'introspecção', 'consciência', 'atenção plena', 'presente',
                    'momento', 'aqui e agora', 'desacelerar', 'desconectar', 'silêncio', 'solitude',
                    'recarregar', 'renovar', 'restaurar', 'revigorar', 'nutrir', 'cuidar', 'amar',
                    'aceitar', 'perdoar', 'gratidão', 'felicidade', 'satisfação'},
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
            'Relaxamento muscular',
            'Terapia de som',
            'Aromaterapia',
            'Banho de floresta',
            'Prática de gratidão',
            'Escrita terapêutica',
            'Massagem nos pés',
            'Aplicar máscara facial',
            'Praticar perdão',
            'Tomar banho terapêutico',
            'Cinco minutos de silêncio',
            'Contato com a natureza',
            'Meditação guiada',
            'Exercícios de aterramento',
            'Praticar auto-compaixão',
            'Técnicas de visualização',
            'Respiração 4-7-8',
            'Exercícios de presença',
            'Ritual matinal de bem-estar',
            'Escaneamento corporal',
            'Praticar consciência alimentar'
        },
        'frequency': 'Diária'
    },
    'exercício': {
        'keywords': {'treino', 'exercício', 'academia', 'esporte', 'fitness', 'workout', 'físico',
                    'musculação', 'cardio', 'aeróbico', 'anaeróbico', 'força', 'resistência',
                    'flexibilidade', 'mobilidade', 'alongamento', 'esteira', 'bicicleta', 'natação',
                    'corrida', 'caminhada', 'peso', 'haltere', 'barra', 'jump', 'pilates', 'funcional',
                    'crossfit', 'hiit', 'circuito', 'abdominal', 'glúteo', 'perna', 'braço', 'costas',
                    'peito', 'ombro', 'bíceps', 'tríceps', 'quadríceps', 'panturrilha', 'corpo',
                    'saúde', 'movimento', 'atividade', 'condicionamento', 'aptidão', 'treinamento',
                    'desempenho', 'atlético', 'esportivo', 'ginástica', 'calistenia', 'boxe',
                    'luta', 'artes marciais', 'karatê', 'judô', 'muay thai', 'jiu-jitsu', 'taekwondo',
                    'ritmo', 'atleta', 'competição', 'jogo', 'partida', 'corredor', 'ciclista',
                    'nadador', 'escalador', 'ioga', 'surfe', 'skate', 'patins', 'remo'},
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
            'Stretching',
            'Caminhada na natureza',
            'Aula de boxe',
            'Escalada',
            'Treino pliométrico',
            'Exercícios de equilíbrio',
            'Treino de abdominais',
            'Treinamento com kettlebell',
            'Aula de ioga',
            'Treino em suspensão',
            'Parkour',
            'Slackline',
            'Futebol',
            'Basquete',
            'Vôlei',
            'Patinação',
            'Skate',
            'Surfe',
            'Barra fixa',
            'Flexões diárias',
            'Prancha abdominal',
            'Calistenia'
        },
        'frequency': 'Diária'
    },
    'organização': {
        'keywords': {'organizar', 'planejamento', 'agenda', 'calendário', 'lista', 'tarefas',
                    'produtividade', 'eficiência', 'gestão', 'tempo', 'meta', 'objetivo',
                    'prioridade', 'rotina', 'hábito', 'sistema', 'método', 'estrutura', 'processo',
                    'fluxo', 'verificação', 'revisão', 'controle', 'monitoramento', 'decluttering',
                    'minimalismo', 'simplicidade', 'ordem', 'arrumação', 'limpeza', 'otimização',
                    'automação', 'projeto', 'progresso', 'desempenho', 'resultado', 'checklist',
                    'Kanban', 'Pomodoro', 'GTD', 'workflow', 'pastas', 'arquivos', 'documentos',
                    'papéis', 'digital', 'desktop', 'inbox', 'caixa de entrada', 'gavetas',
                    'armários', 'organização pessoal', 'gerenciamento do lar', 'casa', 'ambiente',
                    'espaço', 'local', 'área', 'agendamento', 'programação', 'cronograma', 'prazo'},
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
            'Revisar hábitos',
            'Organizar fotos digitais',
            'Limpar desktop',
            'Reorganizar aplicativos',
            'Montar sistema de arquivamento',
            'Organizar biblioteca digital',
            'Preparar agenda diária',
            'Organizar ambiente de trabalho',
            'Limpar geladeira',
            'Organizar despensa',
            'Revisar pendências',
            'Criar rotina matinal',
            'Preparar planejamento mensal',
            'Montar lista de compras',
            'Organizar arquivos de trabalho',
            'Atualizar calendário',
            'Montar sistema de lembretes',
            'Organizar roupas por estação',
            'Fazer backup de arquivos',
            'Atualizar senhas'
        },
        'frequency': 'Semanal'
    },
    'finanças': {
        'keywords': {'dinheiro', 'finanças', 'orçamento', 'economia', 'investimento', 'poupança',
                    'gasto', 'despesa', 'receita', 'renda', 'salário', 'lucro', 'juros', 'bolsa',
                    'ação', 'fundo', 'aplicação', 'rendimento', 'imposto', 'taxa', 'financeiro',
                    'banco', 'crédito', 'débito', 'cartão', 'empréstimo', 'financiamento', 'dívida',
                    'educação financeira', 'independência financeira', 'liberdade financeira', 
                    'mercado', 'patrimônio', 'ativos', 'passivos', 'capital', 'inflação', 'deflação',
                    'valorização', 'depreciação', 'liquidez', 'rentabilidade', 'cotação', 'preço',
                    'valor', 'compra', 'venda', 'negociação', 'corretora', 'banco', 'agência',
                    'conta', 'transferência', 'pix', 'ted', 'doc', 'boleto', 'fatura', 'pagamento',
                    'saldo', 'extrato', 'balanço', 'planilha', 'reserva de emergência', 'previdência',
                    'aposentadoria', 'seguro', 'consórcio', 'imóvel', 'aluguel', 'financiamento',
                    'consignado', 'tesouro direto', 'CDB', 'LCI', 'LCA'},
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
            'Aprender sobre economia',
            'Monitorar mercado financeiro',
            'Calcular patrimônio',
            'Reavaliar seguros',
            'Verificar cartões de crédito',
            'Atualizar planilha de gastos',
            'Buscar renda extra',
            'Analisar faturas',
            'Fazer declaração de imposto',
            'Organizar recibos',
            'Revisar contratos financeiros',
            'Conferir cobranças automáticas',
            'Negociar dívidas',
            'Acompanhar investimentos',
            'Estudar novas aplicações',
            'Revisar metas de poupança',
            'Verificar tarifas bancárias',
            'Atualizar orçamento mensal',
            'Planejar grandes compras',
            'Economia para aposentadoria',
            'Revisar previdência privada'
        },
        'frequency': 'Semanal'
    },
    'saúde': {
        'keywords': {'saúde', 'corpo', 'medicina', 'consulta', 'médico', 'exame', 'check-up',
                    'prevenção', 'tratamento', 'doença', 'remédio', 'medicação', 'vitamina',
                    'suplemento', 'alimentação', 'nutrição', 'dieta', 'refeição', 'cardápio',
                    'água', 'hidratação', 'sono', 'descanso', 'imunidade', 'proteção', 'vacina',
                    'imunização', 'alergia', 'sintoma', 'dor', 'inflamação', 'infecção', 'vírus',
                    'bactéria', 'fungo', 'parasita', 'pressão', 'glicemia', 'colesterol',
                    'hormônios', 'sangue', 'circulação', 'coração', 'pulmão', 'fígado', 'rim',
                    'intestino', 'digestão', 'metabolismo', 'postura', 'visão', 'audição',
                    'odontológico', 'dental', 'bucal', 'ortopédico', 'muscular', 'articulação',
                    'dermatológico', 'pele', 'cabelo', 'unhas'},
        'activities': {
            'Beber água',
            'Tomar vitaminas',
            'Consulta médica',
            'Exame de rotina',
            'Check-up anual',
            'Tomar medicação',
            'Refeições balanceadas',
            'Dormir bem',
            'Controlar pressão',
            'Medir glicemia',
            'Consulta odontológica',
            'Vacinação',
            'Suplementos diários',
            'Hidratação da pele',
            'Proteção solar',
            'Higiene bucal',
            'Comprar remedios',
            'Tomar café da manhã',
            'Alimentação regular',
            'Dieta adequada',
            'Preparar comida saudável',
            'Consultar nutricionista',
            'Fisioterapia',
            'Consulta dermatológica',
            'Planejar refeições nutritivas',
            'Verificar postura',
            'Fazer exame de vista',
            'Avaliar exames',
            'Manter carteira de vacinação',
            'Monitorar peso',
            'Descansar adequadamente',
            'Tomar sol matinal',
            'Fazer jejum intermitente',
            'Reduzir açúcar',
            'Controlar colesterol',
            'Visitar ortopedista',
            'Cuidar da saúde mental',
            'Organizar medicamentos',
            'Revisar plano de saúde',
            'Lembrar de medicações'
        },
        'frequency': 'Diária'
    },
    'desenvolvimento pessoal': {
        'keywords': {'crescimento', 'desenvolvimento', 'evolução', 'progresso', 'melhoria', 'avanço',
                    'transformação', 'mudança', 'superação', 'auto-aperfeiçoamento', 'autodesenvolvimento',
                    'autoconsciência', 'autoconhecimento', 'inteligência emocional', 'habilidades sociais',
                    'comunicação', 'liderança', 'motivação', 'inspiração', 'disciplina', 'foco',
                    'resiliência', 'perseverança', 'determinação', 'proatividade', 'iniciativa',
                    'criatividade', 'inovação', 'pensamento crítico', 'resolução de problemas',
                    'tomada de decisão', 'assertividade', 'autoconfiança', 'autoestima', 'autoimagem',
                    'comportamento', 'atitude', 'mentalidade', 'mindset', 'sabedoria', 'conhecimento',
                    'aprendizado', 'leitura', 'reflexão', 'mentoria', 'coaching', 'terapia',
                    'psicoterapia', 'cura', 'reparação', 'renovação', 'ressignificação', 'propósito',
                    'significado', 'valores', 'princípios', 'ética', 'moral'},
        'activities': {
            'Ler livro de desenvolvimento',
            'Praticar autoconhecimento',
            'Mentoria profissional',
            'Definir objetivos pessoais',
            'Refletir sobre o dia',
            'Desenvolver habilidade social',
            'Curso de comunicação',
            'Trabalho voluntário',
            'Praticar gratidão',
            'Fazer terapia',
            'Coaching de vida',
            'Assistir palestras motivacionais',
            'Praticar novos hábitos',
            'Estabelecer rotina matinal',
            'Desenvolver inteligência emocional',
            'Exercitar criatividade',
            'Praticar mindfulness',
            'Aprender nova habilidade',
            'Sair da zona de conforto',
            'Participar de workshop',
            'Fazer diário pessoal',
            'Exercitar empatia',
            'Praticar escuta ativa',
            'Desenvolver resiliência',
            'Criar plano de desenvolvimento',
            'Trabalhar pontos fracos',
            'Celebrar conquistas',
            'Definir valores pessoais',
            'Encontrar propósito',
            'Cultivar pensamento positivo',
            'Praticar autocompaixão',
            'Desenvolver liderança',
            'Construir rede de contatos',
            'Participar de grupo de estudos',
            'Aplicar técnicas de produtividade',
            'Fazer autoavaliação mensal',
            'Buscar feedback construtivo',
            'Pedir orientação de mentor',
            'Definir metas de crescimento',
            'Ler biografia inspiradora'
        },
        'frequency': 'Semanal'
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
    query_lower = query.lower()
    query_words = set(query_lower.split())
    
    # Sistema avançado de pontuação de categorias
    scores = {}
    
    # Inicializa scores para todas as categorias
    for category in HABIT_CATEGORIES.keys():
        scores[category] = 0.0
    
    # Avalia cada categoria
    for category, data in HABIT_CATEGORIES.items():
        # 1. Verificar palavras-chave
        for keyword in data['keywords']:
            keyword_lower = keyword.lower()
            
            # Correspondência exata com a palavra-chave (maior pontuação)
            if query_lower == keyword_lower:
                scores[category] += 10.0
                continue
                
            # Correspondência no início da consulta
            if query_lower.startswith(keyword_lower) or keyword_lower.startswith(query_lower):
                scores[category] += 5.0
                continue
                
            # Correspondência parcial
            if keyword_lower in query_lower:
                scores[category] += 3.0
                continue
                
            # Correspondência de palavra individual
            for word in query_words:
                if len(word) > 2 and word in keyword_lower:
                    scores[category] += 1.0
        
        # 2. Verificar atividades
        for activity in data['activities']:
            activity_lower = activity.lower()
            
            # Correspondência exata com atividade
            if query_lower == activity_lower:
                scores[category] += 15.0
                break
                
            # Correspondência parcial com atividade
            if query_lower in activity_lower or activity_lower in query_lower:
                scores[category] += 7.0
                continue
                
            # Correspondência de palavra individual com atividade
            matching_words = 0
            for word in query_words:
                if len(word) > 2 and word in activity_lower:
                    matching_words += 1
            
            if matching_words > 0:
                scores[category] += matching_words * 0.5
    
    # Encontra a categoria com maior pontuação
    best_category = max(scores.items(), key=lambda x: x[1])[0]
    
    # Retorna a melhor categoria se tiver uma pontuação mínima
    if scores[best_category] > 0:
        return best_category
    
    # Fallback para comportamento anterior se nenhuma correspondência forte for encontrada
    return None

def format_suggestion(activity: str, frequency: str) -> str:
    """Formata a sugestão com a frequência adequada."""
    return f"{activity} ({frequency})"

def update_suggestions():
    """Atualiza o modelo de sugestões no Firestore."""
    print("Iniciando atualização do modelo de sugestões...")
    
    # Busca hábitos existentes
    print("Buscando hábitos existentes...")
    existing_habits = fetch_habit_data()
    print(f"Encontrados {len(existing_habits)} hábitos existentes.")
    
    # Busca inputs dos usuários para enriquecer o modelo
    print("Aprendendo com inputs dos usuários...")
    user_inputs = learn_from_user_inputs()
    print(f"Processados {len(user_inputs)} inputs de usuários.")
    
    # Conjunto para armazenar todas as sugestões formatadas
    all_suggestions = set()
    
    # Adicionar hábitos existentes
    print("Adicionando hábitos existentes ao modelo...")
    for habit in existing_habits:
        if 'name' in habit and 'frequency' in habit:
            all_suggestions.add(format_suggestion(habit['name'], habit['frequency']))
    
    # Adicionar sugestões padrão organizadas por categoria
    print("Adicionando sugestões padrão por categoria...")
    for category, data in HABIT_CATEGORIES.items():
        print(f"  Categoria '{category}': {len(data['activities'])} atividades, {len(data['keywords'])} palavras-chave")
        for activity in data['activities']:
            all_suggestions.add(format_suggestion(activity, data['frequency']))
    
    # Adicionar sugestões aprendidas com os inputs dos usuários
    print("Incorporando sugestões aprendidas...")
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
    print("Atualizando o modelo no Firestore...")
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
    
    print(f"Modelo atualizado com sucesso! Total de {len(all_suggestions)} sugestões.")

if __name__ == "__main__":
    update_suggestions()
