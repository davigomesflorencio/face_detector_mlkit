import 'package:face_detector_mlkit/pages/components/face_detector_view.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            SizedBox(
              width: 6,
            ),
            Text('Face Detector'),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.face_2_sharp, color: Colors.greenAccent),
                  title: Text('Face Mesh Detector'),
                  onTap: () {
                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.pushNamed(context, '/faceMesh');
                    });
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.privacy_tip, color: Colors.blue),
                  title: Text('Politica de privacidade'),
                  onTap: () {
                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.pushNamed(context, '/privacy');
                    });
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.email, color: Colors.blue),
                  title: Text('Suporte'),
                  onTap: () async {
                    Navigator.pop(context);
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'davigomesflorencio@gmail.com',
                      queryParameters: {
                        'subject': 'Solicitação de suporte',
                        'body': 'Por favor descreva sua solicitação:\n\n',
                      },
                    );

                    if (await launchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Não foi possível iniciar o cliente de e-mail')),
                      );
                    }
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.star, color: Colors.amber),
                  title: Text('Avaliar o aplicativo'),
                  onTap: () {
                    Navigator.pop(context);
                    _rateApp(context);
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.info, color: Colors.green),
                  title: Text('Sobre'),
                  onTap: () {
                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.pushNamed(context, '/about');
                    });
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.code, color: Colors.grey),
                  title: Text('Versão'),
                  subtitle: Text("6.0.0"),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to privacy policy
                  },
                ),
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FaceDetectorView(),
    );
  }

  Future<void> _rateApp(BuildContext context) async {
    const packageName = 'com.davi.dev.face_detect_scan';

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        await StoreRedirect.redirect(
          androidAppId: packageName,
        );
      }
    } catch (e) {
      final webUrl = Uri.parse(Theme.of(context).platform == TargetPlatform.android
          ? 'https://play.google.com/store/apps/details?id=$packageName'
          : 'https://apps.apple.com/app/idYOUR_APP_ID');

      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível iniciar a loja de aplicativos')),
        );
      }
    }
  }
}
