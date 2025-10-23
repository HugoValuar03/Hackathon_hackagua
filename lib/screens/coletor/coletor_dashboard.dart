import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/scaffold_with_nav.dart';

class ColetorDashboard extends StatelessWidget {
  const ColetorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textTheme = GoogleFonts.interTextTheme(theme.textTheme);

    Widget buildSelo({
      required Color cor,
      required IconData icone,
      required String titulo,
      required List<String> publico,
      required List<String> requisitos,
      required List<String> beneficios,
    }) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 10),
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.all(16),
            iconColor: cor,
            collapsedIconColor: cor,
            leading: CircleAvatar(
              radius: 22,
              backgroundColor: cor.withOpacity(0.15),
              child: Icon(icone, color: cor, size: 26),
            ),
            title: Text(
              titulo,
              style: textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      "Público-alvo:",
                      style: textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      publico.join(", "),
                      style: textTheme.bodyMedium!.copyWith(height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Requisitos:",
                      style: textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...requisitos.map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 4, right: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(color: primaryColor)),
                            Expanded(child: Text(r)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Benefícios:",
                      style: textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...beneficios.map(
                      (b) => Padding(
                        padding: const EdgeInsets.only(bottom: 4, right: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(color: primaryColor)),
                            Expanded(child: Text(b)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ScaffoldWithNav(
      title: 'Benefícios',
      currentIndex: 2,
      role: UserRole.coletor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSelo(
              cor: primaryColor,
              icone: Icons.eco,
              titulo: "Selo Verde Oficial – Sustentabilidade Certificada",
              publico: [
                "Empresas",
                "escolas",
                "restaurantes",
                "produtores de fertilizantes",
              ],
              requisitos: [
                "Doar ou processar mínimo de 500 kg de resíduos orgânicos por mês",
                "Ter registro ativo no app por 3 meses ou mais",
                "Participar de 1 ação educativa ou comunitária sobre compostagem",
                "Atender aos critérios da Lei nº 14.260/2021",
              ],
              beneficios: [
                "30% de desconto nas taxas de venda no marketplace do app",
                "Prioridade de destaque nos resultados de busca",
                "Selo digital oficial para redes sociais, sites e embalagens",
                "Acesso a editais e incentivos fiscais",
                "Consultoria gratuita para práticas sustentáveis",
                "Convite para eventos e feiras verdes",
              ],
            ),
            buildSelo(
              cor: Colors.amber.shade700,
              icone: Icons.volunteer_activism,
              titulo: "Selo Orgânico Consciente – Engajamento Comunitário",
              publico: [
                "Escolas",
                "pequenos negócios",
                "produtores locais",
                "pessoas físicas engajadas",
              ],
              requisitos: [
                "Doar mínimo de 100 kg de resíduos orgânicos por mês",
                "Participar de eventos ou campanhas promovidas pelo app",
                "Ter avaliação positiva acima de 80% no perfil (para produtores)",
              ],
              beneficios: [
                "15% de desconto em produtos sustentáveis no app",
                "Acesso a cursos exclusivos sobre compostagem, cultivo e economia circular",
                "Certificado digital de engajamento comunitário",
                "Participação em sorteios mensais de kits ecológicos",
                "Convite para oficinas e palestras locais",
              ],
            ),
            buildSelo(
              cor: Colors.blue.shade700,
              icone: Icons.local_florist,
              titulo: "Selo Semente Sustentável – Iniciantes Engajados",
              publico: [
                "Pessoas físicas",
                "famílias",
                "estudantes",
                "pequenos doadores",
              ],
              requisitos: [
                "Doar mínimo de 20 kg de resíduos orgânicos por mês",
                "Completar o tutorial de compostagem do app",
                "Compartilhar 1 ação sustentável nas redes sociais com hashtag oficial",
              ],
              beneficios: [
                "Kit digital com dicas de jardinagem, hortas caseiras e compostagem doméstica",
                "Pontuação extra no sistema de recompensas",
                "Acesso gratuito a aulas de cultivo urbano e reaproveitamento de alimentos",
                "Medalha digital no perfil e ranking de doadores",
                "Sorteios mensais de mudas, sementes e ecobags",
              ],
            ),
          ],
        ),
      ),
    );
  }
}
