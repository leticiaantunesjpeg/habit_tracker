# Rastreador de Hábitos

Aplicativo Flutter para rastrear hábitos diários e semanais. Este projeto foi desenvolvido para ajudar os usuários a monitorar e manter seus hábitos de forma eficiente.

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma.
- **Provider**: Gerenciamento de estado.
- **Firebase**: Backend para autenticação e armazenamento de dados.

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
