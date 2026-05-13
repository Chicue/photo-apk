import 'package:flutter/material.dart';
import 'package:image_compare_slider/image_compare_slider.dart';
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
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(kPurple),
              backgroundColor: kPurple.withOpacity(0.15),
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
      children: [
        // Badges de opciones seleccionadas
        _OptionsChip(widget.options),
        const SizedBox(height: 16),
        // Comparador deslizable
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: ImageCompareSlider(
              itemOne: Image.file(
                widget.options.photo!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              itemTwo: Image.network(
                _resultUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              handleSize: const Size(40, 40),
              dividerColor: kPurple,
            ),
          ),
        ),
      ],
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
        if (opts.outfitType != null)
          _Chip(opts.outfitType!.label, Icons.checkroom_outlined),
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
