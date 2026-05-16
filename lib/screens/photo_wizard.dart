import 'package:flutter/material.dart';
import '../models/photo_options.dart';
import '../widgets/common_widgets.dart';
import 'step1_photo.dart';
import 'step2_document.dart';
import 'step3_background.dart';
import 'step4_outfit.dart';
import 'step5_result.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class PhotoWizard extends StatefulWidget {
  const PhotoWizard({super.key});

  @override
  State<PhotoWizard> createState() => _PhotoWizardState();
}

class _PhotoWizardState extends State<PhotoWizard> {
  final _pageController = PageController();
  final _options = PhotoOptions();
  final _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentStep = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final loggedIn = await _authService.isLoggedIn();
    if (mounted) {
      setState(() => _isLoggedIn = loggedIn);
    }
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    _checkAuthStatus();
    _reset(); // Regresa al paso 1 y limpia las opciones
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada correctamente')),
      );
    }
  }

  Widget _buildEndDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF6C3CE1),
            ),
            accountName: const Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: const Text('Bienvenido a IDify'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium, color: Colors.amber, size: 28),
            title: const Text('Comprar Paquetes', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Obtén más fotos sin marcas'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navegar a pantalla de pagos
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Próximamente: Tienda')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF6C3CE1)),
            title: const Text('Mis Fotos Anteriores'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navegar a historial
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Color(0xFF6C3CE1)),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer primero
              _handleLogout();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _goTo(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOut,
    );
  }

  void _next() async {
    final targetStep = _currentStep + 1;

    if (targetStep == 4) {
      if (!_isLoggedIn && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              onLoginSuccess: () {
                Navigator.pop(context);
                _checkAuthStatus(); // Actualiza el estado del menú
                _goTo(targetStep);
              },
            ),
          ),
        );
        return;
      }
    }

    _goTo(targetStep);
  }
  void _back() {
    if (_currentStep > 0) _goTo(_currentStep - 1);
  }

  void _reset() {
    // Limpia las opciones y vuelve al inicio
    setState(() {
      _options.photo = null;
      _options.documentType = null;
      _options.backgroundType = null;
      _options.outfitCategory = null;
      _options.outfitName = null;
      _options.outfitDescription = null;
    });
    _goTo(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: _currentStep > 0 && _currentStep < 4
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF374151),
                ),
                onPressed: _back,
              )
            : const SizedBox.shrink(),
        title: const Text(
          'IDify',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Color(0xFF1A1A2E), size: 30),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: Container(
            color: Colors.white,
            child: StepIndicator(currentStep: _currentStep),
          ),
        ),
      ),
      endDrawer: _isLoggedIn ? _buildEndDrawer() : null,
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // solo navegamos por botones
        children: [
          _Wrapper(
            child: Step1Photo(options: _options, onNext: _next),
          ),
          _Wrapper(
            child: Step2Document(
              options: _options,
              onNext: _next,
              onBack: _back,
            ),
          ),
          _Wrapper(
            child: Step3Background(
              options: _options,
              onNext: _next,
              onBack: _back,
            ),
          ),
          _Wrapper(
            child: Step4Outfit(options: _options, onNext: _next, onBack: _back),
          ),
          _Wrapper(
            child: Step5Result(options: _options, onReset: _reset),
          ),
        ],
      ),
    );
  }
}

/// Agrega padding lateral y scroll para que cada paso se vea bien
class _Wrapper extends StatelessWidget {
  final Widget child;
  const _Wrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 60),
        child: child,
      ),
    );
  }
}
