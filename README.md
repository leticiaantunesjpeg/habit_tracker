# Rastreador de Hábitos

Aplicativo Flutter para rastrear hábitos diários e semanais. Este projeto foi desenvolvido para ajudar os usuários a monitorar e manter seus hábitos de forma eficiente.

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma.
- **Provider**: Gerenciamento de estado.
- **Firebase**: Backend para autenticação e armazenamento de dados.
- **Machine Learning**: Sistema de sugestão de hábitos baseado em aprendizado de máquina.

## Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas:

- Flutter SDK: [Instruções de instalação](https://docs.flutter.dev/get-started/install)
- Android Studio ou Xcode (para emuladores ou dispositivos físicos)

## Instalação

1. Clone o repositório:
   ```
   git clone https://github.com/seuusuario/habit_tracker.git
   ```
2. Navegue até o diretório do projeto:
   ```
   cd habit_tracker
   ```
3. Instale as dependências:
   ```
   flutter pub get
   ```

## Como Rodar o App

1. Conecte um dispositivo físico ou inicie um emulador.
2. Execute o comando:
   ```
   flutter run
   ```
3. Para rodar em um ambiente específico (Android, iOS, Web, etc.), utilize:
   ```
   flutter run -d <plataforma>
   ```
   Substitua `<plataforma>` por `android`, `ios`, `web`, etc.

## Funcionalidades

- **Adicionar hábitos**: Permite que os usuários criem novos hábitos, definindo um nome e uma descrição para cada um.
- **Definir dias da semana para cada hábito**: Os usuários podem selecionar os dias específicos em que desejam realizar cada hábito.
- **Rastreamento diário, semanal e mensal**: Visualize o progresso dos hábitos em diferentes períodos de tempo, ajudando a identificar padrões e consistência. A visão mensal permite uma análise mais ampla do desempenho ao longo de um mês inteiro.
- **Alternar entre visão diária, semanal e mensal**: Oferece flexibilidade para visualizar os hábitos de acordo com a preferência do usuário.
- **Sincronização com Firebase**: Todos os dados são armazenados na nuvem, permitindo acesso em múltiplos dispositivos.
- **Sistema de sugestão de hábitos**: Utiliza machine learning para recomendar hábitos personalizados com base na entrada do usuário e categorias de interesse.

## Sistema de Machine Learning

Este aplicativo possui um sistema avançado de sugestão de hábitos baseado em machine learning que:

### Características do Sistema

- **Categorização Semântica**: Organiza os hábitos em categorias semânticas como saúde, fitness, produtividade, etc.
- **Aprendizado Contínuo**: Aprende com as entradas e escolhas dos usuários para melhorar as sugestões ao longo do tempo.
- **Correspondência Contextual**: Sugere hábitos relevantes baseados na entrada do usuário e no contexto da categoria.
- **Sistema de Pontuação**: Implementa um algoritmo sofisticado para avaliar a relevância das sugestões.

### Como Funciona

1. O modelo é treinado com dados iniciais de hábitos categorizados.
2. Quando o usuário digita uma palavra-chave ao criar um novo hábito, o sistema busca por correspondências relevantes.
3. As sugestões são apresentadas ao usuário com base na pontuação de relevância.
4. Quando o usuário seleciona uma sugestão, essa informação é usada para melhorar o modelo.

## Como Usar o Modelo de Machine Learning para Sugestões de Hábitos

O sistema de sugestões utiliza um modelo de machine learning para recomendar hábitos personalizados. Para utilizar as sugestões:

1. Ao criar um novo hábito no aplicativo, digite uma palavra-chave relacionada ao hábito desejado.
2. O sistema irá automaticamente buscar e exibir sugestões relevantes baseadas na sua entrada.
3. Selecione uma das sugestões apresentadas para adicionar rapidamente um hábito recomendado.
4. As sugestões são continuamente aprimoradas conforme o uso, tornando-se mais personalizadas ao longo do tempo.

### Como Treinar o Modelo

O modelo de sugestões pode ser treinado ou atualizado para melhorar a qualidade das recomendações. O treinamento utiliza dados categorizados de hábitos e as escolhas dos usuários para ajustar o sistema de pontuação e relevância. Para treinar o modelo:

1. Navegue até o diretório `ml` do projeto:
   ```bash
   cd ml
   ```
2. Execute o script de treinamento:
   ```bash
   ./run_model_training.sh
   ```
3. O script irá preparar o ambiente, instalar dependências, treinar o modelo e atualizar as sugestões no Firebase.

Se desejar, configure uma tarefa automática para treinar o modelo periodicamente usando o script `setup_cron.sh`.

Se desejar atualizar ou treinar novamente o modelo de sugestões, siga as instruções da seção ["Manutenção e Atualização do Modelo"](#manutenção-e-atualização-do-modelo).

## Manutenção e Atualização do Modelo

Para treinar ou atualizar o modelo de sugestão de hábitos:

1. Navegue até o diretório do projeto e execute:
   ```bash
   cd ml
   ./run_model_training.sh
   ```

2. O script irá:
   - Criar ou ativar um ambiente virtual Python
   - Instalar as dependências necessárias
   - Executar o script de treinamento
   - Atualizar o modelo no Firebase

Também é possível configurar uma tarefa cron para treinar o modelo diariamente:
```bash
cd ml
./setup_cron.sh
```
