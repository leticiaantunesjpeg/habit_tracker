#!/bin/bash

SCRIPT_PATH="$( cd "$(dirname "$0")" && pwd )/run_model_training.sh"

if [ ! -f "$HOME/.crontab" ]; then
    touch "$HOME/.crontab"
fi

(crontab -l 2>/dev/null; echo "0 0 * * * $SCRIPT_PATH") | sort - | uniq - | crontab -

echo "Tarefa cron configurada para executar o treinamento do modelo diariamente à meia-noite."
echo "Execute 'crontab -l' para visualizar as tarefas programadas."
