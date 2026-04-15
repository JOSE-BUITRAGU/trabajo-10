import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';

class CilindroScreen extends StatefulWidget {
  const CilindroScreen({super.key});

  @override
  State<CilindroScreen> createState() => _CilindroScreenState();
}

class _CilindroScreenState extends State<CilindroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _radioController = TextEditingController();
  final _alturaController = TextEditingController();

  double? _areaLateral;
  double? _areaTotal;
  double? _volumen;

  @override
  void dispose() {
    _radioController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  void _calcular() {
    if (_formKey.currentState!.validate()) {
      final r = double.parse(_radioController.text.trim());
      final h = double.parse(_alturaController.text.trim());
      setState(() {
        _areaLateral = 2 * pi * r * h;
        _areaTotal = 2 * pi * r * (r + h);
        _volumen = pi * pow(r, 2) * h;
      });
    }
  }

  void _limpiar() {
    _formKey.currentState!.reset();
    _radioController.clear();
    _alturaController.clear();
    setState(() {
      _areaLateral = null;
      _areaTotal = null;
      _volumen = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Cálculo del cilindro',
              color: Color(0xFF854F0B),
            ),

            // Radio
            const FieldLabel(label: 'Radio (r) en centímetros *'),
            TextFormField(
              controller: _radioController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: '0.0',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                suffixText: 'cm',
                prefixIcon: Icon(Icons.straighten_rounded, color: Color(0xFF854F0B)),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa el radio';
                }
                final n = double.tryParse(value.trim());
                if (n == null) return 'Número inválido';
                if (n <= 0) return 'Debe ser mayor que 0';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Altura
            const FieldLabel(label: 'Altura (h) en centímetros *'),
            TextFormField(
              controller: _alturaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: '0.0',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                suffixText: 'cm',
                prefixIcon: Icon(Icons.height_rounded, color: Color(0xFF854F0B)),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa la altura';
                }
                final n = double.tryParse(value.trim());
                if (n == null) return 'Número inválido';
                if (n <= 0) return 'Debe ser mayor que 0';
                return null;
              },
            ),
            const SizedBox(height: 28),

            // Botones
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _calcular,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF854F0B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Calcular',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 52,
                  width: 52,
                  child: OutlinedButton(
                    onPressed: _limpiar,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.refresh_rounded, color: Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),

            // Resultados
            if (_areaLateral != null) ...[
              const SizedBox(height: 24),
              ResultCard(
                title: 'Resultados',
                color: const Color(0xFF854F0B),
                icon: Icons.calculate_rounded,
                children: [
                  ResultRow(
                    label: 'Radio',
                    value: '${double.parse(_radioController.text).toStringAsFixed(2)} cm',
                  ),
                  const Divider(height: 16),
                  ResultRow(
                    label: 'Altura',
                    value: '${double.parse(_alturaController.text).toStringAsFixed(2)} cm',
                  ),
                  const Divider(height: 16),
                  ResultRow(
                    label: 'Área lateral',
                    value: '${_areaLateral!.toStringAsFixed(4)} cm²',
                  ),
                  const Divider(height: 16),
                  ResultRow(
                    label: 'Área total',
                    value: '${_areaTotal!.toStringAsFixed(4)} cm²',
                  ),
                  const Divider(height: 16),
                  ResultRow(
                    label: 'Volumen',
                    value: '${_volumen!.toStringAsFixed(4)} cm³',
                    destacado: true,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
