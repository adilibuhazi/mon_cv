
import 'package:flutter/material.dart';
import 'services/api_service.dart';

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

// ================= CONNEXION =================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool cacherMotDePasse = true;
  bool chargement = false;

  // CREER UN COMPTE
  Future<void> creerCompte() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Remplissez tous les champs'),
        ),
      );
      return;
    }

    setState(() => chargement = true);

    final resultat = await ApiService.inscrire(
      emailController.text.trim(),
      passwordController.text,
    );

    if (!mounted) return;

    setState(() => chargement = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resultat
              ? 'Compte créé avec succès ! Connectez-vous.'
              : 'Échec de création du compte. Vérifiez les informations.',
        ),
      ),
    );
  }

  // SE CONNECTER
  Future<void> connecter() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Remplissez tous les champs'),
        ),
      );
      return;
    }

    setState(() => chargement = true);

    final resultat = await ApiService.seConnecter(
      emailController.text.trim(),
      passwordController.text,
    );

    if (!mounted) return;

    setState(() => chargement = false);

    if (resultat) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email ou mot de passe incorrect !'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
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

              // CHAMP EMAIL
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Adresse e-mail',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CHAMP MOT DE PASSE
              TextField(
                controller: passwordController,
                obscureText: cacherMotDePasse,
                onSubmitted: (_) => connecter(),
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
              ),

              const SizedBox(height: 30),

              // BOUTON CONNEXION
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: chargement ? null : connecter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bleu,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: chargement
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 17),
                        ),
                ),
              ),

              const SizedBox(height: 10),

              // BOUTON CREATION DE COMPTE
              TextButton(
                onPressed: chargement ? null : creerCompte,
                child: const Text(
                  'Créer un compte',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),
              const Text('Mon CV personnel'),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= NAVIGATION =================

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final List<String> titres = [
    'Mon CV',
    'Ma famille',
    'Mes contacts',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const CvPage(),
      const FamilyPage(),
      const ContactPage(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titres[index])),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (nouvelIndex) {
          setState(() => index = nouvelIndex);
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
              children: [
                const CircleAvatar(
                  radius: 65,
                  backgroundImage:
                      AssetImage('assets/images/adili.jpg'),
                ),
                const SizedBox(height: 15),
                const Text(
                  'ADILI BUHAZI DIVINE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: bleu,
                  ),
                ),
                const SizedBox(height: 5),
                const Text('Étudiante en informatique'),
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
            description: 'Français : bien\nAutres langues : swahili, anglais',
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
            child: Text('© 2026 - Adili Buhazi Divine'),
          ),
        ],
      ),
    );
  }
}

// ================= PAGE FAMILLE =================

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  List<dynamic> membres = [];
  bool chargement = true;

  @override
  void initState() {
    super.initState();
    chargerMembres();
  }

  Future<void> chargerMembres() async {
    setState(() => chargement = true);

    try {
      membres = await ApiService.getFamilyMembers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur de chargement des membres'),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => chargement = false);
    }
  }

  Future<void> afficherFormulaire({
    Map<String, dynamic>? membre,
  }) async {
    final nom = TextEditingController(
      text: membre?['nom'] ?? '',
    );
    final postnom = TextEditingController(
      text: membre?['postnom'] ?? '',
    );
    final prenom = TextEditingController(
      text: membre?['prenom'] ?? '',
    );
    final lieu = TextEditingController(
      text: membre?['lieu_naissance'] ?? '',
    );
    final date = TextEditingController(
      text: membre?['date_naissance'] ?? '',
    );
    final parente = TextEditingController(
      text: membre?['parente'] ?? '',
    );

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            membre == null
                ? 'Ajouter un membre'
                : 'Modifier un membre',
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  champ(nom, 'Nom'),
                  champ(postnom, 'Postnom'),
                  champ(prenom, 'Prénom'),
                  champ(lieu, 'Lieu de naissance'),
                  champ(date, 'Date de naissance (AAAA-MM-JJ)'),
                  champ(parente, 'Lien de parenté'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final donnees = {
                  'nom': nom.text.trim(),
                  'postnom': postnom.text.trim(),
                  'prenom': prenom.text.trim(),
                  'lieu_naissance': lieu.text.trim(),
                  'date_naissance': date.text.trim(),
                  'parente': parente.text.trim(),
                };

                try {
                  if (membre == null) {
                    await ApiService.ajouterMembre(donnees);
                  } else {
                    await ApiService.modifierMembre(
                      int.parse(membre['id'].toString()),
                      donnees,
                    );
                  }

                  if (!dialogContext.mounted) return;

                  Navigator.pop(dialogContext);
                  await chargerMembres();
                } catch (e) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Erreur : $e')),
                  );
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    nom.dispose();
    postnom.dispose();
    prenom.dispose();
    lieu.dispose();
    date.dispose();
    parente.dispose();
  }

  Future<void> supprimerMembre(dynamic id) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text(
          'Voulez-vous supprimer ce membre ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      try {
        await ApiService.supprimerMembre(
          int.parse(id.toString()),
        );
        await chargerMembres();
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }

  Widget champ(
    TextEditingController controller,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Ce champ est obligatoire';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: chargement
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : membres.isEmpty
              ? const Center(
                  child: Text('Aucun membre enregistré'),
                )
              : RefreshIndicator(
                  onRefresh: chargerMembres,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: membres.length,
                    itemBuilder: (context, index) {
                      final membre = membres[index];
                      final imageUrl = membre['image_url'];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: imageUrl != null &&
                                    imageUrl.toString().isNotEmpty
                                ? NetworkImage(imageUrl.toString())
                                : null,
                            child: imageUrl == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(
                            '${membre['nom'] ?? ''} '
                            '${membre['postnom'] ?? ''} '
                            '${membre['prenom'] ?? ''}',
                          ),
                          subtitle: Text(
                            'Lien : ${membre['parente'] ?? ''}\n'
                            'Naissance : ${membre['date_naissance'] ?? ''}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (choix) {
                              if (choix == 'modifier') {
                                afficherFormulaire(
                                  membre:
                                      Map<String, dynamic>.from(membre),
                                );
                              } else if (choix == 'supprimer') {
                                supprimerMembre(membre['id']);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'modifier',
                                child: Text('Modifier'),
                              ),
                              PopupMenuItem(
                                value: 'supprimer',
                                child: Text('Supprimer'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bleu,
        foregroundColor: Colors.white,
        onPressed: () => afficherFormulaire(),
        child: const Icon(Icons.add),
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

// ================= WIDGETS =================

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
