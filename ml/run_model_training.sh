#!/bin/bash

echo "Iniciando o treinamento do modelo de sugestão de hábitos..."

cd "$(dirname "$0")"

if [ -d "venv" ]; then
    echo "Ativando ambiente virtual..."
    source venv/bin/activate
else
    echo "Ambiente virtual não encontrado! Criando um novo..."
    python3 -m venv venv
    source venv/bin/activate
    pip install firebase-admin
fi

echo "Executando o script de treinamento atualizado..."
python train_habit_model_updated.py

echo "Treinamento do modelo concluído!"
echo "O modelo foi atualizado com novas categorias e sugestões!"
