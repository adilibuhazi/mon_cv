import 'package:flutter/material.dart';

void main() {
  runApp(const MonCvApp());
}

const Color bleu = Color(0xFF173B68);
const Color bleuClair = Color(0xFFEAF1FA);

class MonCvApp extends StatelessWidget {
  const MonCvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon CV',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: bleu),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: bleu,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// ================= PAGE CONNEXION =================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final identifiantController = TextEditingController();
  final passwordController = TextEditingController();
  bool cacherMotDePasse = true;

  void connecter() {
    if (identifiantController.text.trim() == 'adili' &&
        passwordController.text == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Identifiant ou mot de passe incorrect !'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    identifiantController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundColor: bleu,
                child: Icon(
                  Icons.person,
                  size: 65,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'BIENVENUE',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: bleu,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connectez-vous pour découvrir mon CV',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              TextField(
                controller: identifiantController,
                decoration: InputDecoration(
                  labelText: 'Identifiant',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: cacherMotDePasse,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      cacherMotDePasse
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        cacherMotDePasse = !cacherMotDePasse;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onSubmitted: (_) => connecter(),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: connecter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bleu,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Mon CV personnel',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= NAVIGATION PRINCIPALE =================
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final List<Widget> pages = const [
    CvPage(),
    FamilyPage(),
    ContactPage(),
  ];

  final List<String> titles = [
    'Mon CV',
    'Ma famille',
    'Mes contacts',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[index]),
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (nouvelIndex) {
          setState(() {
            index = nouvelIndex;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Mon CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_mail_outlined),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

// ================= PAGE CV =================
class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage('assets/images/adili.jpg'),
                ),
                SizedBox(height: 15),
                Text(
                  'ADILI BUHAZI DIVINE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: bleu,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Étudiante en informatique',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const SectionTitle(
            icon: Icons.school,
            title: 'Formation',
          ),
          const InfoCard(
            title: 'Études en informatique',
            description: 'Établissement : ISIG GOMA\n'
                'Promotion : LIC3\n'
                'Diplôme : à saint marc',
          ),
          const SectionTitle(
            icon: Icons.work,
            title: 'Expériences et projets',
          ),
          const InfoCard(
            title: 'Projets académiques',
            description:
                'Réalisation de travaux pratiques en informatique.\n'
                'Développement et apprentissage des applications.',
          ),
          const SectionTitle(
            icon: Icons.computer,
            title: 'Compétences techniques',
          ),
          const InfoCard(
            title: 'Informatique',
            description: '• Initiation à la programmation\n'
                '• Développement mobile avec Flutter (apprentissage)\n'
                '• Utilisation de Visual Studio Code\n'
                '• Notions de bases de données',
          ),
          const SectionTitle(
            icon: Icons.language,
            title: 'Compétences linguistiques',
          ),
          const InfoCard(
            title: 'Langues',
            description: 'Français : bien\n'
                'Autres langues : swahili, anglais',
          ),
          const SectionTitle(
            icon: Icons.favorite,
            title: 'Centres d’intérêt',
          ),
          const InfoCard(
            title: 'Loisirs',
            description:
                'Informatique, apprentissage, lecture et développement personnel.',
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '© 2026 - Adili Buhazi Divine',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PAGE FAMILLE =================
class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final membres = [
      {
        'nom': 'Mburano Buhazi',
        'lien': 'Père',
        'profession': 'Juge',
        'initiales': 'MB',
      },
      {
        'nom': 'Rose Nyirabageni',
        'lien': 'Mère',
        'profession': 'Fermière',
        'initiales': 'RN',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ma famille',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: bleu,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Voici quelques membres de ma famille.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ...membres.map((membre) {
            final estPere = membre['lien'] == 'Père';
            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        estPere
                            ? 'assets/images/papa.jpg'
                            : 'assets/images/maman.jpg',
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            membre['nom']!,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text('Lien : ${membre['lien']}'),
                          Text(
                            'Profession : ${membre['profession']}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 15),
          const Text(
            'D’autres membres pourront être ajoutés.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ================= PAGE CONTACT =================
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Center(
            child: Icon(
              Icons.contact_page,
              size: 90,
              color: bleu,
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              'Mes coordonnées',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: bleu,
              ),
            ),
          ),
          SizedBox(height: 25),
          ContactCard(
            icon: Icons.person,
            titre: 'Nom complet',
            valeur: 'Adili Buhazi Divine',
          ),
          ContactCard(
            icon: Icons.phone,
            titre: 'Téléphone',
            valeur: '+243904634842',
          ),
          ContactCard(
            icon: Icons.email,
            titre: 'Adresse e-mail',
            valeur: 'adilibuhazi0@gmail.com',
          ),
          ContactCard(
            icon: Icons.location_on,
            titre: 'Adresse',
            valeur: 'À compléter',
          ),
          ContactCard(
            icon: Icons.link,
            titre: 'Réseaux sociaux',
            valeur: 'GitHub / LinkedIn',
          ),
          SizedBox(height: 25),
          Center(
            child: Text(
              'Merci de visiter mon profil !',
              style: TextStyle(
                fontSize: 16,
                color: bleu,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= WIDGETS REUTILISABLES =================
class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionTitle({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: bleu),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: bleu,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String description;

  const InfoCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String titre;
  final String valeur;

  const ContactCard({
    super.key,
    required this.icon,
    required this.titre,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bleuClair,
          child: Icon(icon, color: bleu),
        ),
        title: Text(
          titre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: SelectableText(valeur),
      ),
    );
  }
}