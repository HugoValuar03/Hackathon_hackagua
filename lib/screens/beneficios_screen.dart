import 'package:flutter/material.dart';

class BeneficiosScreen extends StatelessWidget {
  const BeneficiosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Benefícios')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ExpansionTile(
            leading: Icon(Icons.eco, color: Colors.green.shade700),
            title: const Text('🟢 Selo Verde Oficial – Sustentabilidade Certificada'),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: const [
              Text('Público-alvo:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Empresas, escolas, restaurantes, produtores de fertilizantes'),
              SizedBox(height: 8),
              Text('Requisitos:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('● Doar ou processar mínimo de 500 kg de resíduos orgânicos por mês'),
              Text('● Ter registro ativo no app por 3 meses ou mais'),
              Text('● Participar de 1 ação educativa ou comunitária sobre compostagem'),
              Text('● Atender aos critérios da Lei nº 14.260/2021:'),
              Text('  ○ Transparência na destinação dos resíduos'),
              Text('  ○ Relatórios mensais de impacto ambiental'),
              Text('  ○ Parceria com cooperativas ou projetos de reciclagem'),
              SizedBox(height: 8),
              Text('Benefícios:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('● 30% de desconto nas taxas de venda no marketplace do app'),
              Text('● Prioridade de destaque nos resultados de busca'),
              Text('● Selo digital oficial para redes sociais, sites e embalagens'),
              Text('● Acesso a editais e incentivos fiscais'),
              Text('● Consultoria gratuita para práticas sustentáveis'),
              Text('● Convite para eventos e feiras verdes'),
            ],
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            leading: Icon(Icons.nature_people, color: Colors.amber),
            title: const Text('🟡 Selo Orgânico Consciente – Engajamento Comunitário'),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: const [
              Text('Público-alvo:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Escolas, pequenos negócios, produtores locais, pessoas físicas engajadas'),
              SizedBox(height: 8),
              Text('Requisitos:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('● Doar mínimo de 100 kg de resíduos orgânicos por mês'),
              Text('● Participar de eventos ou campanhas promovidas pelo app'),
              Text('● Ter avaliação positiva acima de 80% no perfil (para produtores)'),
              SizedBox(height: 8),
              Text('Benefícios:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('● 15% de desconto em produtos sustentáveis no app'),
              Text('● Acesso a cursos exclusivos sobre compostagem, cultivo e economia circular'),
              Text('● Certificado digital de engajamento comunitário'),
              Text('● Participação em sorteios mensais de kits ecológicos'),
              Text('● Convite para oficinas e palestras locais'),
            ],
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            leading: Icon(Icons.local_florist, color: Colors.blue),
            title: const Text('🔵 Selo Semente Sustentável – Iniciantes Engajados'),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: const [
              Text('Público-alvo:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Pessoas físicas, famílias, estudantes, pequenos doadores'),
              SizedBox(height: 8),
              Text('Requisitos:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('● Doar mínimo de 20 kg de resíduos orgânicos por mês'),
              Text('● Completar o tutorial de compostagem do app'),
              Text('● Compartilhar 1 ação sustentável nas redes sociais com hashtag oficial'),
              SizedBox(height: 8),
              Text('Benefícios:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('● Kit digital com dicas de jardinagem, hortas caseiras e compostagem doméstica'),
              Text('● Pontuação extra no sistema de recompensas'),
              Text('● Acesso gratuito a aulas de cultivo urbano e reaproveitamento de alimentos'),
              Text('● Medalha digital no perfil e ranking de doadores'),
              Text('● Sorteios mensais de mudas, sementes e ecobags'),
            ],
          ),
        ],
      ),
    );
  }
}