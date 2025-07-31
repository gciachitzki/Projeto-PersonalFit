# PersonalFit 🏋️‍♀️

Aplicativo Flutter para conectar usuários com personal trainers, permitindo visualização de perfis, agendamento de sessões e sistema de avaliações.

## 🚀 Como Executar

### 1. **Configuração Inicial**
```bash
# Clone o repositório
git clone https://github.com/gciachitzki/Projeto-PersonalFit.git
cd personal-fit

# Instale as dependências
flutter pub get
```

### 2. **Executar no Chrome (Web)**
```bash
# Execute no navegador
flutter run -d chrome
```

### 3. **Executar no Android**
```bash
# Liste os dispositivos disponíveis
flutter devices

# Para emulador Android (via Android Studio)

# Execute no emulador/dispositivo Android
flutter run -d android
```

### 4. **Executar no iOS** 
```bash
# confire se ele está disponivel
flutter devices

# Execute no simulador/dispositivo iOS
flutter run -d ios
```

### 5. **Comandos Úteis**
```bash
# Verificar configuração
flutter doctor

# Limpar cache (se necessário)
flutter clean
flutter pub get

# Build para produção
flutter build apk --release           # Android
flutter build ios --simulator         # iOS
```

## 🏗️ Arquitetura

O projeto segue **Clean Architecture** com separação em camadas:

- **Presentation**: Controllers (Riverpod) e Pages
- **Domain**: Entities e Repository interfaces
- **Data**: Models, DataSources e Repository implementations
- **Core**: Services, Widgets reutilizáveis e Providers

**Tecnologias**: Flutter, Riverpod (state management), Dio (HTTP), Google Fonts

## ✨ Funcionalidades

### 📋 **Listagem de Personais**
- Visualização de todos os personais disponíveis
- Filtros por especialidade
- Busca por nome
- Cards com informações principais (nome, especialidades, avaliação, cidade)

### 👤 **Perfil do Personal**
- Detalhes completos do personal
- Especialidades e bio
- Avaliação média e número de reviews
- Preço por sessão
- Localização (cidade/estado)

### 💬 **Contato e Contratação**
- Botão WhatsApp direto
- Formulário de interesse de contratação
- Envio de dados para API (nome, modalidade, frequência, preço estimado)

### ⭐ **Sistema de Avaliações**
- Visualização de todas as avaliações do personal
- Adicionar nova avaliação (rating + comentário)
- Exclusão de avaliações próprias
- Cálculo automático de média de avaliações


### 📅 **Agendamento de Sessões**
- Agendar sessões com personais
- Seleção de data e horário
- Escolha de modalidade (presencial/online)
- Definição de duração da sessão
- Cálculo automático de preço
- Visualização de agendamentos do usuário


## 🌐 Mock Server

### 🔗 **Link do Mock Server**
**Base URL**: `https://6889f6f24c55d5c7395460c4.mockapi.io/api/v1`

### 📋 **Endpoints Disponíveis**

#### GET /Personal
Retorna lista de personais.
```json
[
  {
    "id": "1",
    "name": "Amanda Costa",
    "bio": "Especialista em emagrecimento feminino.",
    "specialties": ["Emagrecimento", "Funcional"],
    "rating": 4.8,
    "city": "Goiânia",
    "state": "GO",
    "photoUrl": "https://randomuser.me/api/portraits/women/1.jpg",
    "whatsapp": "62988888888",
    "price": 100
  }
]
```

#### POST /contact-interest
Envia interesse de contratação.
```json
{
  "personalId": "1",
  "modality": "online",
  "frequency": "2x",
  "userName": "João",
  "estimatedPrice": 200
}
```

### ⚙️ **Configuração da API**
Para alternar entre mock local e API, edite:
```dart
// lib/core/constants/app_config.dart
static const bool useRealApi = false;  // true = mockapi.io, false = mock local
```

## 🛠️ Dependências Principais

- `flutter_riverpod`: Gerenciamento de estado
- `dio`: Cliente HTTP
- `cached_network_image`: Cache de imagens
- `url_launcher`: Abertura de links externos
- `google_fonts`: Tipografia Poppins
- `flutter_animate`: Animações

## 📁 Estrutura do Projeto

```
lib/
├── core/                          # Infraestrutura
│   ├── constants/                 # Constantes
│   ├── providers/                 # Providers Riverpod
│   ├── services/                  # Serviços (API, Mock)
│   └── widgets/                   # Widgets reutilizáveis
│   
├── modules/
│   └── personals/                 # Módulo principal
│       ├── data/                  # Camada de dados
│       ├── domain/                # Camada de domínio
│       └── presentation/          # Camada de apresentação
└── main.dart                      # Ponto de entrada
```

## 🚨 Observações Importantes

- **Dados Mock**: Incluídos no projeto para demonstração
- **Responsividade**: Testado em diferentes tamanhos de tela: web, android e ios
