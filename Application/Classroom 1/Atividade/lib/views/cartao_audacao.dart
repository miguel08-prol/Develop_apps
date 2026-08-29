import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saudação UNIP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SaudacaoPage(),
    );
  }
}

class SaudacaoPage extends StatefulWidget {
  const SaudacaoPage({super.key});

  @override
  State<SaudacaoPage> createState() => _SaudacaoPageState();
}

class _SaudacaoPageState extends State<SaudacaoPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String _mensagem = '';
  
  // Controlador para a animação do ícone de entrada
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );

    // Inicia a animação quando a página abre
    _animController.forward();
  }

  void _gerarSaudacao() {
    setState(() {
      final nome = _controller.text.trim();
      _mensagem = nome.isEmpty
          ? 'Por favor, digite seu nome para continuar.'
          : 'Olá, $nome! Seja muito bem-vindo(a) à aula de Flutter da UNIP.';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercício 4 - Saudação'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ícone com animação de escala na entrada
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: const Icon(
                    Icons.waving_hand_rounded,
                    size: 64,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Identificação do Aluno',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Digite seu nome abaixo para gerar a saudação personalizada.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // Campo de Texto
                TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Seu nome completo',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botão de Ação com efeito ao pressionar (nativo do ElevatedButton)
                ElevatedButton.icon(
                  onPressed: _gerarSaudacao,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text(
                    'Gerar Saudação',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
                const SizedBox(height: 24),

                // Card de Resultado com AnimatedSwitcher para transição suave de fade
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    );
                  },
                  child: _mensagem.isEmpty
                      ? const SizedBox.shrink()
                      : Card(
                          key: const ValueKey('cardMensagem'),
                          elevation: 4,
                          shadowColor: Colors.teal.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              _mensagem,
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}