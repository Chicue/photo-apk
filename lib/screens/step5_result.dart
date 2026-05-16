import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/photo_options.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';

class Step5Result extends StatefulWidget {
  final PhotoOptions options;
  final VoidCallback onReset;

  const Step5Result({super.key, required this.options, required this.onReset});

  @override
  State<Step5Result> createState() => _Step5ResultState();
}

class _Step5ResultState extends State<Step5Result> {
  final _api = ApiService();
  String? _resultUrl;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _process();
  }

  Future<void> _process() async {
    setState(() {
      _loading = true;
      _error = null;
      _resultUrl = null;
    });
    try {
      final url = await _api.processPhoto(widget.options);
      setState(() {
        _resultUrl = url;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Resultado',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _loading
              ? 'La IA está generando tu foto profesional…'
              : _error != null
              ? 'Ocurrió un error al procesar la imagen'
              : 'Tu foto está lista. Desliza para comparar',
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 20),

        // ── Área de resultado ────────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 420,
          child: _loading
              ? _buildLoading()
              : _error != null
              ? _buildError()
              : _buildResult(),
        ),

        const SizedBox(height: 12),

        // ── Acciones ─────────────────────────────────────────────────────
        if (!_loading && _error == null) ...[
          PrimaryButton(
            label: 'Descargar foto',
            icon: Icons.download_rounded,
            onPressed: () {
              // TODO: implementar descarga
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Descarga próximamente…')),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
        if (!_loading && _error != null) ...[
          PrimaryButton(
            label: 'Reintentar',
            icon: Icons.refresh,
            onPressed: _process,
          ),
          const SizedBox(height: 8),
        ],
        TextButton(
          onPressed: widget.onReset,
          child: const Text(
            'Empezar de nuevo',
            style: TextStyle(color: kPurple, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // ── Loading ──────────────────────────────────────────────────────────────
  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: Lottie.asset(
              'assets/images/loading.json', // Cambiado a archivo local
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Si aún no has descargado el archivo, mostrará el círculo morado
                return Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      valueColor: AlwaysStoppedAnimation<Color>(kPurple),
                      backgroundColor: kPurple.withOpacity(0.15),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Procesando con IA…',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Esto puede tardar entre 20 y 60 segundos',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 32),
          // Info de opciones seleccionadas
          _OptionsChip(widget.options),
        ],
      ),
    );
  }

  // ── Error ────────────────────────────────────────────────────────────────
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 36,
              color: Colors.red.shade400,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No pudimos procesar la foto',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Resultado ────────────────────────────────────────────────────────────
  Widget _buildResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OptionsChip(widget.options),
        const SizedBox(height: 14),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: _BeforeAfterSlider(
              before: Image.file(
                widget.options.photo!,
                //fit: BoxFit.cover,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
              after: Image.network(
                _resultUrl!,
                //fit: BoxFit.cover,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Comparador antes/después personalizado ────────────────────────────────────
class _BeforeAfterSlider extends StatefulWidget {
  final Widget before;
  final Widget after;
  const _BeforeAfterSlider({required this.before, required this.after});

  @override
  State<_BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<_BeforeAfterSlider> {
  double _position = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final divX = w * _position;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (d) {
            setState(() {
              _position = (_position + d.delta.dx / w).clamp(0.0, 1.0);
            });
          },
          child: Stack(
            children: [
              // Imagen resultado (fondo completo)
              SizedBox(width: w, height: h, child: widget.after),
              // Imagen original (recortada a la izquierda)
              ClipRect(
                clipper: _SideClipper(divX, h),
                child: SizedBox(width: w, height: h, child: widget.before),
              ),
              // Línea divisoria
              Positioned(
                left: divX - 1,
                top: 0,
                bottom: 0,
                width: 2,
                child: Container(color: kPurple),
              ),
              // Handle circular
              Positioned(
                left: divX - 20,
                top: h / 2 - 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kPurple,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.compare_arrows_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              // Etiqueta "Antes"
              Positioned(left: 10, bottom: 10, child: _SliderLabel('Antes')),
              // Etiqueta "Después"
              Positioned(right: 10, bottom: 10, child: _SliderLabel('Después')),
            ],
          ),
        );
      },
    );
  }
}

class _SideClipper extends CustomClipper<Rect> {
  final double width;
  final double height;
  const _SideClipper(this.width, this.height);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, width, height);

  @override
  bool shouldReclip(_SideClipper old) =>
      old.width != width || old.height != height;
}

class _SliderLabel extends StatelessWidget {
  final String text;
  const _SliderLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Mini widget de chips de opciones ────────────────────────────────────────
class _OptionsChip extends StatelessWidget {
  final PhotoOptions opts;
  const _OptionsChip(this.opts);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: [
        if (opts.documentType != null)
          _Chip(opts.documentType!.label, Icons.badge_outlined),
        if (opts.backgroundType != null)
          _Chip(opts.backgroundType!.label, Icons.palette_outlined),
        if (opts.outfitName != null)
          _Chip(opts.outfitName!, Icons.checkroom_outlined),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _Chip(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: kPurple),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: kPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
