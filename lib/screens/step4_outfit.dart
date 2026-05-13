import 'package:flutter/material.dart';
import '../models/photo_options.dart';
import '../widgets/common_widgets.dart';

// ── Datos de trajes por categoría ─────────────────────────────────────────────
const Map<String, List<Map<String, String>>> _outfitData = {
  'Hombre': [
    {'name': 'Traje Negro Clásico',   'description': 'Traje formal negro con corbata negra y camisa blanca'},
    {'name': 'Traje Azul Marino',     'description': 'Traje azul marino con corbata a rayas azul y camisa blanca'},
    {'name': 'Traje Gris Ejecutivo',  'description': 'Traje gris oscuro clásico con corbata plateada y camisa blanca'},
    {'name': 'Traje Café Elegante',   'description': 'Traje café oscuro formal con corbata dorada y camisa blanca'},
    {'name': 'Esmoquin',              'description': 'Esmoquin negro formal con corbatín negro y camisa blanca de pechera'},
    {'name': 'Camisa + Corbata',      'description': 'Camisa formal blanca con corbata azul oscuro, sin saco'},
    {'name': 'Camisa Azul Formal',    'description': 'Camisa formal azul celeste con corbata gris'},
    {'name': 'Chaleco + Camisa',      'description': 'Chaleco negro formal con camisa blanca y corbata'},
  ],
  'Mujer': [
    {'name': 'Blazer Negro Formal',   'description': 'Blazer negro entallado con blusa blanca de cuello'},
    {'name': 'Blazer Azul Marino',    'description': 'Blazer azul marino elegante con blusa blanca'},
    {'name': 'Blazer Gris Ejecutivo', 'description': 'Blazer gris ejecutivo con blusa crema'},
    {'name': 'Traje Sastre Negro',    'description': 'Traje sastre negro completo con blusa blanca'},
    {'name': 'Blusa Blanca Formal',   'description': 'Blusa formal blanca con cuello lazo'},
    {'name': 'Blusa Negra Elegante',  'description': 'Blusa negra elegante de cuello alto'},
    {'name': 'Vestido Formal Negro',  'description': 'Vestido formal negro con cuello redondo'},
    {'name': 'Blazer Rojo Ejecutivo', 'description': 'Blazer rojo vino con blusa blanca'},
  ],
  'Niño': [
    {'name': 'Traje Formal Negro',    'description': 'Traje formal negro infantil con corbata y camisa blanca'},
    {'name': 'Traje Azul Marino',     'description': 'Traje azul marino infantil con corbata a rayas'},
    {'name': 'Camisa + Corbatín',     'description': 'Camisa blanca formal con corbatín negro'},
    {'name': 'Chaleco Formal',        'description': 'Chaleco negro con camisa blanca y corbata infantil'},
    {'name': 'Polo Formal',           'description': 'Polo blanco o celeste formal escolar'},
    {'name': 'Blazer y Camisa',       'description': 'Blazer gris infantil con camisa blanca'},
  ],
  'Niña': [
    {'name': 'Blazer Negro',          'description': 'Blazer negro infantil con blusa blanca'},
    {'name': 'Vestido Formal',        'description': 'Vestido formal blanco con cuello redondo y lazo'},
    {'name': 'Blusa Blanca Formal',   'description': 'Blusa blanca formal con cuello Peter Pan'},
    {'name': 'Camisa Escolar',        'description': 'Camisa blanca o celeste estilo escolar formal'},
    {'name': 'Blazer Azul',           'description': 'Blazer azul marino infantil con blusa blanca'},
    {'name': 'Conjunto Formal',       'description': 'Conjunto formal de falda y blazer gris'},
  ],
};

const _categories = ['Hombre', 'Mujer', 'Niño', 'Niña'];

class Step4Outfit extends StatefulWidget {
  final PhotoOptions options;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step4Outfit({
    super.key,
    required this.options,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step4Outfit> createState() => _Step4OutfitState();
}

class _Step4OutfitState extends State<Step4Outfit> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.options.outfitCategory;
  }

  void _selectCategory(String cat) {
    setState(() {
      _selectedCategory = cat;
      // Limpiar traje si cambia la categoría
      if (widget.options.outfitCategory != cat) {
        widget.options.outfitCategory    = cat;
        widget.options.outfitName        = null;
        widget.options.outfitDescription = null;
      }
    });
  }

  void _selectOutfit(Map<String, String> outfit) {
    setState(() {
      widget.options.outfitCategory    = _selectedCategory;
      widget.options.outfitName        = outfit['name'];
      widget.options.outfitDescription = outfit['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final outfits = _selectedCategory != null
        ? (_outfitData[_selectedCategory] ?? [])
        : <Map<String, String>>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),

        // ── Título centrado ──────────────────────────────────────────────
        const Text(
          'Tipo de traje',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        const Text(
          'Selecciona el tipo de persona y el traje deseado',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // ── Badges de categoría ──────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _categories.map((cat) {
            final isSelected = _selectedCategory == cat;
            return GestureDetector(
              onTap: () => _selectCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? kPurple : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? kPurple : const Color(0xFFD1D5DB),
                    width: isSelected ? 2 : 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: kPurple.withOpacity(0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF374151),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // ── Grid de trajes ───────────────────────────────────────────────
        if (_selectedCategory != null) ...[
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: outfits.length,
            itemBuilder: (context, index) {
              final outfit    = outfits[index];
              final isSelected =
                  widget.options.outfitName == outfit['name'];
              return GestureDetector(
                onTap: () => _selectOutfit(outfit),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? kPurple.withOpacity(0.07)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? kPurple
                          : const Color(0xFFE5E7EB),
                      width: isSelected ? 2 : 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              outfit['name']!,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? kPurple
                                    : const Color(0xFF1A1A2E),
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(Icons.check_circle,
                                  color: kPurple, size: 15),
                            ),
                        ],
                      ),
                      Text(
                        outfit['description']!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                          height: 1.35,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],

        const SizedBox(height: 28),

        PrimaryButton(
          label: 'Generar foto profesional',
          icon: Icons.auto_awesome,
          onPressed:
              widget.options.outfitName != null ? widget.onNext : null,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
