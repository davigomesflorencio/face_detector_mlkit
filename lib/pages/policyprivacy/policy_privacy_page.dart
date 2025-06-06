import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyPrivacyPage extends StatefulWidget {
  const PolicyPrivacyPage({Key? key}) : super(key: key);

  @override
  State<PolicyPrivacyPage> createState() => _PolicyPrivacyState();
}

class _PolicyPrivacyState extends State<PolicyPrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/icon/icon.png'),
              width: 40,
              height: 40,
            ),
            SizedBox(width: 6,),
            Text('Politica de privacidade')
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Política de Privacidade do Face Detector MLKit',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Última atualização: 07/06/2025',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('1. Introdução'),
              const Text(
                'O Face Detector MLKit é um aplicativo que utiliza o ML Kit do Google para detecção de rostos em tempo real. '
                'Esta política descreve como seus dados são tratados, garantindo transparência e conformidade com as diretrizes do Google.',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('2. Coleta e Processamento de Dados'),
              _buildSubtitle('2.1 Processamento pelo ML Kit'),
              const Text(
                '• A detecção de rostos ocorre inteiramente no dispositivo (on-device)\n'
                '• Nenhuma imagem, vídeo ou dado facial é enviado a servidores externos\n'
                '• Os dados processados não são armazenados após o uso',
              ),
              const SizedBox(height: 12),
              _buildSubtitle('2.2 Permissões Requeridas'),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Permissão')),
                  DataColumn(label: Text('Finalidade')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Câmera')),
                    DataCell(Text('Captura de vídeo em tempo real para detecção facial')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Armazenamento (Opcional)')),
                    DataCell(Text('Salvar imagens processadas (se habilitado pelo usuário)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Internet (Opcional)')),
                    DataCell(Text('Atualizações do app e análises de uso')),
                  ]),
                ],
              ),
              const SizedBox(height: 12),
              _buildSubtitle('2.3 Dados Opcionais'),
              const Text(
                '• Dados de diagnóstico (logs): Coletados apenas com consentimento\n'
                '• Metadados do dispositivo: Usados para otimização de desempenho',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('3. Uso dos Dados'),
              const Text(
                '• Funcionalidade principal: Detecção facial 100% local\n'
                '• Melhorias no app: Análise de erros e desempenho (dados anônimos)\n'
                '• Nenhum dado facial ou imagem é compartilhado ou vendido',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('4. Compartilhamento de Dados'),
              const Text(
                '• Zero compartilhamento de imagens ou dados faciais\n'
                '• Dados agregados podem ser usados para análises estatísticas',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('5. Segurança'),
              const Text(
                '• 🔒 Processamento totalmente offline\n'
                '• Armazenamento local opcional\n'
                '• Sem coleta de dados biométricos identificáveis',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('6. Alterações na Política'),
              const Text(
                'Mudanças serão comunicadas via:\n'
                '• Notificação no app\n'
                '• Aviso nesta página',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('7. Seus Direitos'),
              const Text(
                '• Revogar permissões a qualquer momento\n'
                '• Solicitar exclusão de dados (se aplicável)',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('8. Contato'),
              GestureDetector(
                onTap: () => _launchEmail(),
                child: const Text(
                  'Dúvidas ou solicitações? Entre em contato:\n'
                  '📧 davigomesflorencio@gmail.com',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Observação: Este app não realiza reconhecimento facial biométrico, apenas detecção genérica de rostos.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _launchUrl('https://developers.google.com/ml-kit/terms'),
                child: const Text(
                  'Consulte as Políticas do ML Kit do Google',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'davigomesflorencio@gmail.com',
      queryParameters: {'subject': 'Sobre o Face Detector MLKit'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Não foi possível abrir o cliente de e-mail';
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Não foi possível abrir $url';
    }
  }
}
