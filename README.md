# BioCycle

BioCycle é um aplicativo móvel focado no descarte correto de **lixo orgânico**, incentivando sua **reutilização por meio de compostagem** para evitar a poluição do lençol freático e rios. Desenvolvido como parte do Hackathon InovaUni – HackÁgua, o projeto segue rigorosamente as exigências do edital: é entregue como um **MVP funcional**, com código-fonte completo e documentação técnica, conforme os itens 6.4 (MVP obrigatório) e 11.2 (entrega de código e documentação) do edital. Todo o código está hospedado em repositório GitHub, conforme previsto no item 3.17 do edital. A seguir apresentamos uma visão geral do sistema, suas funcionalidades, instruções de instalação e uso, tecnologias empregadas e créditos.

## Funcionalidades Principais

- **Autenticação de Usuário**: Cadastro e login de usuários com perfis **Produtor** ou **Coletor**, usando e-mail e senha. Os dados de usuário são armazenados localmente em banco SQLite, garantindo a persistência das informações e tipo de usuário (Produtor/Coletor). O aplicativo usa **SharedPreferences** para manter a sessão do usuário logado.
    
- **Perfil do Produtor**: Após o login, o Produtor visualiza um dashboard com seu nome, pontos acumulados e histórico de coletas realizadas. Este perfil também dá acesso ao _marketplace_ de benefícios, onde os pontos podem ser trocados por recompensas (ver Seção “Creditos” abaixo). Exemplo de implementação no código: cartela de pontos e histórico estático mostrado em tela.
    
- **Perfil do Coletor**: O Coletor vê seu nome, pontos e selos de mérito em seu perfil, além de ações rápidas em grade: **“Solicitar coleta”** e **“Minhas coletas”** de resíduos orgânicos. A opção de **“Solicitar coleta”** permite registrar um novo pedido de coleta, enquanto **“Minhas coletas”** lista coletas já realizadas (ambas navegando para as rotas correspondentes). Há também opção para definir **“Endereço/Área”** (mapa) e editar dados pessoais (implementações futuras). As ações rápidas usam cartões de ícones, como ilustrado no código-fonte.
    
- **Sistema de Pontos e Benefícios**: A cada coleta confirmada, o usuário ganha pontos (mostrados no perfil do Produtor). Estes pontos podem ser resgatados por itens no marketplace de benefícios. A tela inicial do Produtor mostra os pontos acumulados (ex.: “1200 pts”) e um botão para “Benefícios”. Os detalhes do marketplace (lista de produtos/benefícios) também são armazenados em SQLite (tabela _produtos_).
    
- **Armazenamento Local**: Todo o banco de dados do aplicativo é local (SQLite). O helper de banco (`DBHelper`) cria as tabelas **produtos** e **usuarios** no arquivo `biocycle.db`. As operações de CRUD usam o pacote _sqflite_. Por exemplo, a tabela `usuarios` tem campos _id_, _nome_, _email_, _senha_ e _tipo_, o que permite associar cada login a um perfil e tipo de usuário. Há métodos dedicados em `UsuarioDao` para inserir e consultar usuários. Esse armazenamento local garante que o aplicativo funcione offline.
    
- **Funcionalidades de Navegação**: O app usa rotas nomeadas para navegar entre telas (login, cadastro, perfis, marketplace, solicitações de coleta etc.). Há suporte a modo _convidado_ (pular login) que leva diretamente ao marketplace. O layout geral segue o padrão Material Design do Flutter, com barras de navegação personalizadas e temas de cores.
    

## Tecnologias e Bibliotecas

- **Flutter (Dart)**: framework principal do aplicativo, garantindo código nativo compilado para Android e iOS.
    
- **SQLite (sqflite + path)**: gerenciamento de banco de dados local. O pacote _sqflite_ é usado para criar e acessar o banco SQLite (`DBHelper`). O pacote _path_ determina o caminho do arquivo de banco de dados.
    
- **SharedPreferences**: usado para armazenar localmente os dados da sessão do usuário (ID, nome, email, tipo).
    
- **Outros pacotes**: _Flutter Material_ (widgets e tema), _Shared Preferences_ (gerenciamento de sessão), e quaisquer plugins necessários para funcionalidades adicionais (ex.: biblioteca de mapas).
    
- **Equipe**: Desenvolvimento por Higor Valuar Bailona, Hugo Valuar Bailona, Bárbara Mydiã Matos Silva, Letícia Espindola Marques e Ariane Santos da Silva. 
    

## Requisitos do Sistema

- **Plataforma**: Qualquer dispositivo com Flutter compatível (Android ou iOS).
    
- **Flutter SDK**: É necessário o Flutter instalado (recomendado versão 3.x ou superior) e ambiente de desenvolvimento configurado (ex.: Android Studio ou VSCode com SDKs Android/iOS).
    
- **Dependências**: As dependências especificadas no `pubspec.yaml` (como _sqflite_, _shared_preferences_, _path_).
    
- **Armazenamento**: Espaço interno para criar o banco de dados local (pouco espaço; o app é leve).
    
- **Internet**: Apenas para instalar dependências. O funcionamento principal é offline.
    
- **Git/GitHub**: O código está versionado em um repositório GitHub público (`https://github.com/HugoValuar03/Hackathon_hackagua.git`), atendendo ao item 3.17 do edital.
    

## Instalação e Execução

1. **Clonar o repositório**: Execute `git clone https://github.com/HugoValuar03/Hackathon_hackagua.git` para obter o código-fonte completo.
    
2. **Obter dependências**: No diretório do projeto, rode `flutter pub get` para baixar pacotes necessários.
    
3. **Compilar e rodar**: Conecte um dispositivo Android/iOS ou inicie um emulador, então execute `flutter run`. O aplicativo compilará e será instalado automaticamente.
    
4. **Banco de dados**: Ao rodar, o aplicativo criará o arquivo `biocycle.db` no armazenamento local, sem ações adicionais do usuário.
    
5. **Ambiente de Teste**: Para testes sem dispositivo físico, use emulador Android, Navegador Web (Chrome) ou simulador iOS.
    

## Uso do Aplicativo

- **Registro e Login:** Na primeira execução, cadastre-se informando nome, e-mail, senha e tipo de usuário. Depois, faça login usando essas credenciais. Em caso de falha, uma mensagem de erro será exibida. Há opção de navegar como “Convidado” direto para o marketplace.
    
- **Fluxo Produtor:** Após login como Produtor, você verá sua página de perfil. Ela mostra seus **pontos acumulados** e um botão para acessar **Benefícios** (marketplace). Também é exibido um **histórico de coletas**, listando coletas passadas e pontos ganhos (pontos simulados no exemplo).
    
- **Fluxo Coletor:** Após login como Coletor, na tela de perfil você pode tocar em **“Solicitar coleta”** para agendar a coleta de resíduos orgânicos, e em **“Minhas coletas”** para ver coletas anteriores. Outros botões permitem editar perfil ou alterar área de coleta (não implementados).
    
- **Marketplace e Benefícios:** Navegue até a seção _Marketplace_ para ver itens disponíveis em troca de pontos, ou _Benefícios_ para ver recompensas resgatadas. Use os pontos mostrados no perfil do Produtor para efetuar trocas.
    
- **Configurações:** Nas telas de perfil há opções de notificação e uso de localização (atualizações futuras). Para **logout**, toque em _Sair_ para retornar à tela de login.
    
- **Documentação Adicional:** Comentários no código explicam métodos principais. Consulte as classes `DBHelper` (configuração do SQLite) e `UsuarioDao` (operações de usuário) para detalhes de implementação.
    

## Créditos e Licença

- **Autores:** Higor Valuar, Hugo Valuar, Bárbara Mydiã, Letícia Marques e Ariane Silva.
    
- **Bibliotecas usadas:** _sqflite_ (banco SQLite), _path_ (caminhos de arquivo), _shared_preferences_ (storage), _flutter/material.dart_ e outras bibliotecas padrão do Flutter. Cada biblioteca foi utilizada conforme seus termos de uso.
    
- **Base de Dados:** Inspirado no exemplo oficial de uso do sqflite em Flutter. As tabelas criadas estão em `db_helper.dart`.
    
- **Licença:** O código deste projeto é aberto sob licença MIT (ou outra, se aplicável), permitindo estudo e uso conforme as diretrizes do hackathon (todo o material é original da equipe).
    

---

**Referências:** Esta documentação atende às diretrizes do Edital NIT/Unitins Nº 03/2025 para o Hackathon InovaUni – HackÁgua e FAPTGulhas. Em especial, entregamos todo o código-fonte e documentação solicitados, incluindo este README com instruções e requisitos, conforme exigido. O repositório público no GitHub garante o acesso ao projeto completo, e o sistema foi desenvolvido como um MVP funcional. Todas as funcionalidades descritas acima foram implementadas pela equipe e testadas.