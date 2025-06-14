# Sistema de Sugestão de Hábitos

Este sistema de sugestão de hábitos implementa um modelo de aprendizado de máquina simples que:

1. Categoriza hábitos em grupos semânticos (social, lazer, aprendizado, etc.)
2. Aprende com os inputs e seleções dos usuários
3. Sugere hábitos relevantes baseados na entrada do usuário

## Como funciona

### Modelo de treinamento (`ml/train_habit_model.py`)

- O modelo é inicializado com categorias predefinidas e palavras-chave
- Aprende com os hábitos existentes no banco de dados
- Aprende com as entradas dos usuários armazenadas na coleção `user_inputs`
- Atualiza o documento `habit_suggestion_model` no Firestore com as sugestões aprendidas

### Interface do usuário (`lib/screens/home_screen.dart`)

- O componente `TypeAheadField` consulta as sugestões do modelo armazenadas no Firestore
- Quando o usuário seleciona uma sugestão, essa informação é armazenada na coleção `user_inputs` 
- O modelo usa esses dados para aprender e melhorar as sugestões futuras

### Execução do treinamento

- Execute manualmente: `./ml/run_model_training.sh`
- Configure uma tarefa programada: `./ml/setup_cron.sh` (executa diariamente à meia-noite)

## Fluxo de dados

1. **Entrada do usuário**: O usuário digita texto no campo de hábito
2. **Sugestões**: O sistema busca sugestões do modelo treinado no Firestore
3. **Seleção**: O usuário seleciona uma sugestão
4. **Aprendizado**: O input e a seleção são salvos no Firestore
5. **Treinamento**: O modelo é retreinado periodicamente, incorporando os novos dados
6. **Melhoria**: As sugestões futuras se tornam mais relevantes e personalizadas

O sistema continuará a melhorar com o tempo à medida que mais usuários interagirem com ele.
