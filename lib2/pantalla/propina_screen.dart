import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';

class PropinaScreen extends StatefulWidget {
  const PropinaScreen({super.key});

  @override
  State<PropinaScreen> createState() => _PropinaScreenState();
}

class _PropinaScreenState extends State<PropinaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cuentaController = TextEditingController();

  int? _porcentajePropina;
  double? _montoPropina;
  double? _totalFinal;

  @override
  void dispose() {
    _cuentaController.dispose();
    super.dispose();
  }

  void _calcularPropina() {
    if (!_formKey.currentState!.validate()) return;

    if (_porcentajePropina == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un porcentaje de propina'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    final total = double.parse(_cuentaController.text.trim());
    setState(() {
      _montoPropina = total * (_porcentajePropina! / 100);
      _totalFinal = total + _montoPropina!;
    });
  }

  void _limpiar() {
    _formKey.currentState!.reset();
    _cuentaController.clear();
    setState(() {
      _porcentajePropina = null;
      _montoPropina = null;
      _totalFinal = null;
    });
  }

  String _formatCOP(double value) {
    return '\$${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
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
              title: 'Calculadora de propina',
              color: Color(0xFF0F6E56),
            ),

            // Total de la cuenta
            const FieldLabel(label: 'Total de la cuenta *'),
            TextFormField(
              controller: _cuentaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                prefixText: '$ ',
                prefixIcon: Icon(Icons.attach_money_rounded, color: Color(0xFF0F6E56)),
              ),
              onChanged: (_) {
                if (_montoPropina != null) {
                  setState(() {
                    _montoPropina = null;
                    _totalFinal = null;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa el total de la cuenta';
                }
                final n = double.tryParse(value.trim());
                if (n == null) return 'Número inválido';
                if (n <= 0) return 'Debe ser mayor que \$0';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Porcentaje de propina
            const FieldLabel(label: 'Porcentaje de propina *'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _porcentajePropina != null
                      ? const Color(0xFF0F6E56)
                      : const Color(0xFFD1D5DB),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _radioTip(10, 'Estándar', 'Para servicios normales'),
                  const Divider(height: 0, indent: 48, endIndent: 12),
                  _radioTip(15, 'Recomendada', 'Para buen servicio'),
                  const Divider(height: 0, indent: 48, endIndent: 12),
                  _radioTip(20, 'Excelente', 'Para servicio excepcional'),
                ],
              ),
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
                      onPressed: _calcularPropina,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F6E56),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Calcular propina',
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
            if (_montoPropina != null) ...[
              const SizedBox(height: 24),
              ResultCard(
                title: 'Resumen de pago',
                color: const Color(0xFF0F6E56),
                icon: Icons.receipt_long_rounded,
                children: [
                  ResultRow(
                    label: 'Total cuenta',
                    value: _formatCOP(double.parse(_cuentaController.text.trim())),
                  ),
                  const Divider(height: 16),
                  ResultRow(
                    label: 'Propina ($_porcentajePropina%)',
                    value: _formatCOP(_montoPropina!),
                  ),
                  const Divider(height: 16),
                  ResultRow(
                    label: 'Total a pagar',
                    value: _formatCOP(_totalFinal!),
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

  Widget _radioTip(int pct, String titulo, String subtitulo) {
    final sel = _porcentajePropina == pct;
    return RadioListTile<int>(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      title: Text(
        '$pct% — $titulo',
        style: TextStyle(
          fontSize: 14,
          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
          color: sel ? const Color(0xFF0F6E56) : const Color(0xFF374151),
        ),
      ),
      subtitle: Text(
        subtitulo,
        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
      ),
      value: pct,
      groupValue: _porcentajePropina,
      activeColor: const Color(0xFF0F6E56),
      onChanged: (val) {
        setState(() {
          _porcentajePropina = val;
          _montoPropina = null;
          _totalFinal = null;
        });
      },
    );
  }
}
