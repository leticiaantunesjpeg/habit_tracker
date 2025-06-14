#!/usr/bin/env python3
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os
import sys
from termcolor import colored

# Inicializar o Firebase
project_root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
cred = credentials.Certificate(os.path.join(project_root, 'habit-tracker-a2222-firebase-adminsdk-fbsvc-4dad4095e6.json'))
firebase_admin.initialize_app(cred)
db = firestore.client()

def get_suggestions(query, frequency=None, limit=10):
    """Simulação da função getSuggestions do serviço Dart."""
    try:
        # Busca o modelo no Firestore
        model_doc = db.collection('ml_models').document('habit_suggestion_model').get()
        
        if not model_doc.exists:
            print("Modelo não encontrado! Execute primeiro o treinamento do modelo.")
            return []
        
        # Obtém dados do modelo
        suggestions = list(model_doc.get('suggestions') or [])
        categories_data = model_doc.get('categories') or {}
        query_lower = query.lower()
        query_words = query_lower.split(' ')
        
        # Lista para resultados
        result = []
        
        # 1. Correspondências exatas
        exact_matches = [s for s in suggestions if query_lower in s.lower()]
        
        # 2. Busca contextual se poucos resultados exatos
        if len(exact_matches) < 7 and categories_data:
            # Sistema de pontuação por categoria
            category_scores = {}
            
            # Inicializa pontuações
            for category in categories_data:
                category_scores[category] = 0
                
            # Analisa cada categoria
            for category_name, category_info in categories_data.items():
                # Pontuação por keywords
                keywords = category_info.get('keywords', [])
                for keyword in keywords:
                    keyword_lower = keyword.lower()
                    
                    # Correspondência exata de keyword
                    if query_lower == keyword_lower:
                        category_scores[category_name] += 8
                        continue
                        
                    # Correspondência de início
                    if keyword_lower.startswith(query_lower) or query_lower.startswith(keyword_lower):
                        category_scores[category_name] += 5
                        continue
                        
                    # Correspondência parcial
                    if keyword_lower in query_lower or query_lower in keyword_lower:
                        category_scores[category_name] += 3
                        continue
                        
                    # Por palavra
                    for word in query_words:
                        if len(word) > 2 and (word in keyword_lower or keyword_lower in word):
                            category_scores[category_name] += 2
                
                # Pontuação por atividades
                activities = category_info.get('activities', [])
                for activity in activities:
                    activity_lower = activity.lower()
                    
                    # Verificações de atividade
                    if activity_lower.startswith(query_lower):
                        category_scores[category_name] += 4
                    elif query_lower in activity_lower:
                        category_scores[category_name] += 3
            
            # Categorias relevantes
            relevant_categories = [(k, v) for k, v in category_scores.items() if v > 0]
            relevant_categories.sort(key=lambda x: x[1], reverse=True)
            top_categories = relevant_categories[:3]
            
            # Adiciona sugestões das categorias relevantes
            for category_name, _ in top_categories:
                category_frequency = categories_data[category_name].get('frequency', 'Semanal')
                activities = categories_data[category_name].get('activities', [])
                
                for activity in activities:
                    formatted = f"{activity} ({category_frequency})"
                    if formatted not in exact_matches and formatted not in result:
                        result.append(formatted)
        
        # Combina resultados
        result = exact_matches + result
        
        # Filtra por frequência
        if frequency:
            result = [s for s in result if frequency.lower() in s.lower()]
        
        # Limita resultados
        if len(result) > limit:
            result = result[:limit]
            
        return result
    except Exception as e:
        print(f"Erro: {e}")
        return []

def test_suggestions():
    """Testa diferentes consultas e exibe resultados."""
    # Lista de testes: (query, frequency, label)
    tests = [
        ("estudar", None, "Aprendizado - Palavra-chave direta"),
        ("pro", None, "Aprendizado - Prefixo incompleto para 'programação'"),
        ("cozinhar", None, "Culinária - Palavra-chave direta"),
        ("receita", None, "Culinária - Palavra-chave relacionada"),
        ("exercício", None, "Exercício - Palavra-chave direta"),
        ("treino", None, "Exercício - Palavra-chave alternativa"),
        ("organizar", "Semanal", "Organização - Com filtro de frequência"),
        ("café", None, "Social/Culinária - Palavra ambígua"),
        ("meditar", None, "Bem-estar - Prática específica"),
        ("finance", None, "Finanças - Palavra incompleta"),
        ("computador", None, "Tecnologia - Palavra sem categoria direta"),
        ("xyz123", None, "Consulta sem correspondência")
    ]
    
    print(colored("\n=== TESTE DO SISTEMA DE SUGESTÕES DE HÁBITOS ===\n", "cyan", attrs=["bold"]))
    
    for query, frequency, label in tests:
        freq_display = f" (frequência: {frequency})" if frequency else ""
        print(colored(f"\n>> Teste: {label}", "yellow", attrs=["bold"]))
        print(colored(f"   Consulta: '{query}'{freq_display}\n", "yellow"))
        
        suggestions = get_suggestions(query, frequency)
        
        if suggestions:
            print(colored(f"   {len(suggestions)} sugestões encontradas:", "green"))
            for idx, suggestion in enumerate(suggestions, 1):
                print(f"   {idx}. {suggestion}")
        else:
            print(colored("   Nenhuma sugestão encontrada.", "red"))
            
    print(colored("\n=== TESTE CONCLUÍDO ===\n", "cyan", attrs=["bold"]))

if __name__ == "__main__":
    if len(sys.argv) > 1:
        # Modo interativo
        query = sys.argv[1]
        frequency = sys.argv[2] if len(sys.argv) > 2 else None
        
        print(colored(f"\nConsulta: '{query}'", "cyan"))
        if frequency:
            print(colored(f"Frequência: {frequency}", "cyan"))
            
        suggestions = get_suggestions(query, frequency)
        
        if suggestions:
            print(colored(f"\n{len(suggestions)} sugestões encontradas:", "green"))
            for idx, suggestion in enumerate(suggestions, 1):
                print(f"{idx}. {suggestion}")
        else:
            print(colored("\nNenhuma sugestão encontrada.", "red"))
    else:
        # Executa todos os testes
        test_suggestions()
