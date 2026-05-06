import 'package:flutter/material.dart';
import '../models/photo_options.dart';
import '../widgets/common_widgets.dart';
import 'step1_photo.dart';
import 'step2_document.dart';
import 'step3_background.dart';
import 'step4_outfit.dart';
import 'step5_result.dart';

class PhotoWizard extends StatefulWidget {
  const PhotoWizard({super.key});

  @override
  State<PhotoWizard> createState() => _PhotoWizardState();
}

class _PhotoWizardState extends State<PhotoWizard> {
  final _pageController = PageController();
  final _options = PhotoOptions();
  int _currentStep = 0;

  void _goTo(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOut,
    );
  }

  void _next() => _goTo(_currentStep + 1);
  void _back() {
    if (_currentStep > 0) _goTo(_currentStep - 1);
  }

  void _reset() {
    // Limpia las opciones y vuelve al inicio
    setState(() {
      _options.photo          = null;
      _options.documentType   = null;
      _options.backgroundType = null;
      _options.outfitType     = null;
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
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: _currentStep > 0 && _currentStep < 4
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: Color(0xFF374151)),
                onPressed: _back,
              )
            : const SizedBox.shrink(),
        title: const Text(
          'Foto Document AI',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),
          child: Container(
            color: Colors.white,
            child: StepIndicator(currentStep: _currentStep),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // solo navegamos por botones
        children: [
          _Wrapper(child: Step1Photo(options: _options, onNext: _next)),
          _Wrapper(
              child: Step2Document(
                  options: _options, onNext: _next, onBack: _back)),
          _Wrapper(
              child: Step3Background(
                  options: _options, onNext: _next, onBack: _back)),
          _Wrapper(
              child: Step4Outfit(
                  options: _options, onNext: _next, onBack: _back)),
          _Wrapper(
              child: Step5Result(options: _options, onReset: _reset)),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 160,
        ),
        child: IntrinsicHeight(child: child),
      ),
    );
  }
}
