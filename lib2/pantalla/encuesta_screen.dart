import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';

class EncuestaScreen extends StatefulWidget {
  const EncuestaScreen({super.key});

  @override
  State<EncuestaScreen> createState() => _EncuestaScreenState();
}

class _EncuestaScreenState extends State<EncuestaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _comentarioController = TextEditingController();

  int? _calificacion;
  bool _atencionCliente = false;
  bool _tiempoRespuesta = false;
  bool _facilidadUso = false;
  bool _precioCalidad = false;
  bool _enviado = false;

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  void _enviarFormulario() {
    if (_calificacion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una calificación'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() => _enviado = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Encuesta enviada exitosamente!'),
          backgroundColor: Color(0xFF0F6E56),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _resetFormulario() {
    _formKey.currentState!.reset();
    _comentarioController.clear();
    setState(() {
      _calificacion = null;
      _atencionCliente = false;
      _tiempoRespuesta = false;
      _facilidadUso = false;
      _precioCalidad = false;
      _enviado = false;
    });
  }

  Widget _estrellas(int cantidad) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < cantidad ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 15,
          color: const Color(0xFFF59E0B),
        ),
      ),
    );
  }

  String _etiqueta(int val) {
    const etiquetas = ['', 'Muy malo', 'Malo', 'Regular', 'Bueno', 'Excelente'];
    return etiquetas[val];
  }

  String _caracteristicas() {
    final lista = <String>[];
    if (_atencionCliente) lista.add('Atención al cliente');
    if (_tiempoRespuesta) lista.add('Tiempo de respuesta');
    if (_facilidadUso) lista.add('Facilidad de uso');
    if (_precioCalidad) lista.add('Precio / calidad');
    return lista.isEmpty ? 'Ninguna' : lista.join(', ');
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
              title: 'Encuesta de satisfacción',
              color: Color(0xFF185FA5),
            ),

            // Calificación
            const FieldLabel(label: 'Calificación del servicio *'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _calificacion != null
                      ? const Color(0xFF185FA5)
                      : const Color(0xFFD1D5DB),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: List.generate(5, (i) {
                  final valor = i + 1;
                  final seleccionado = _calificacion == valor;
                  return Column(
                    children: [
                      RadioListTile<int>(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        title: Row(
                          children: [
                            Text(
                              '$valor — ${_etiqueta(valor)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: seleccionado
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: seleccionado
                                    ? const Color(0xFF185FA5)
                                    : const Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _estrellas(valor),
                          ],
                        ),
                        value: valor,
                        groupValue: _calificacion,
                        activeColor: const Color(0xFF185FA5),
                        onChanged: (val) => setState(() => _calificacion = val),
                      ),
                      if (i < 4)
                        const Divider(height: 0, indent: 48, endIndent: 12),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // Características
            const FieldLabel(label: 'Características que te gustaron'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD1D5DB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _checkItem('c1', 'Atención al cliente', _atencionCliente,
                      (v) => setState(() => _atencionCliente = v!)),
                  const Divider(height: 0, indent: 48, endIndent: 12),
                  _checkItem('c2', 'Tiempo de respuesta', _tiempoRespuesta,
                      (v) => setState(() => _tiempoRespuesta = v!)),
                  const Divider(height: 0, indent: 48, endIndent: 12),
                  _checkItem('c3', 'Facilidad de uso', _facilidadUso,
                      (v) => setState(() => _facilidadUso = v!)),
                  const Divider(height: 0, indent: 48, endIndent: 12),
                  _checkItem('c4', 'Precio / calidad', _precioCalidad,
                      (v) => setState(() => _precioCalidad = v!)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Comentarios
            const FieldLabel(label: 'Comentarios adicionales *'),
            TextFormField(
              controller: _comentarioController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Comparte tu opinión sobre el servicio...',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingresa un comentario';
                }
                if (value.trim().length < 10) {
                  return 'Mínimo 10 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),

            // Botón
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _enviarFormulario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF185FA5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Enviar encuesta',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            // Resultado
            if (_enviado && _calificacion != null) ...[
              const SizedBox(height: 24),
              ResultCard(
                title: 'Respuesta registrada',
                color: const Color(0xFF0F6E56),
                icon: Icons.check_circle_outline_rounded,
                children: [
                  ResultRow(
                    label: 'Calificación',
                    value: '$_calificacion / 5 — ${_etiqueta(_calificacion!)}',
                  ),
                  const Divider(height: 16),
                  ResultRow(label: 'Características', value: _caracteristicas()),
                  const Divider(height: 16),
                  ResultRow(
                    label: 'Comentario',
                    value: _comentarioController.text.trim(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: _resetFormulario,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Nueva encuesta'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF185FA5),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _checkItem(
    String key,
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return CheckboxListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: value ? FontWeight.w500 : FontWeight.w400,
          color: value ? const Color(0xFF0F6E56) : const Color(0xFF374151),
        ),
      ),
      value: value,
      activeColor: const Color(0xFF0F6E56),
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      onChanged: onChanged,
    );
  }
}
