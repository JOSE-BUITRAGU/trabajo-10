class _EncuestaScreenState extends State<EncuestaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _comentarioController = TextEditingController();

  int? _servicio;
  int? _precio;
  int? _calidad;
  int? _atencion;

  bool _atencionCliente = false;
  bool _tiempoRespuesta = false;
  bool _facilidadUso = false;
  bool _precioCalidad = false;

  bool _enviado = false;
  String _comentarioGuardado = '';

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  void _enviarFormulario() {
    if (_servicio == null ||
        _precio == null ||
        _calidad == null ||
        _atencion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Califica todos los aspectos'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _enviado = true;
        _comentarioGuardado = _comentarioController.text.trim();
      });

      _comentarioController.clear(); // 🔥 LIMPIA CAMPO

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Encuesta enviada exitosamente!'),
          backgroundColor: Color(0xFF0F6E56),
        ),
      );
    }
  }

  Widget _ratingBlock(String titulo, int? value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: titulo),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: List.generate(5, (i) {
              final val = i + 1;
              return RadioListTile<int>(
                value: val,
                groupValue: value,
                title: Row(
                  children: [
                    Text("$val"),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < val
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                onChanged: (v) => onChanged(v!),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String _caracteristicas() {
    final lista = <String>[];
    if (_atencionCliente) lista.add('Atención');
    if (_tiempoRespuesta) lista.add('Tiempo');
    if (_facilidadUso) lista.add('Facilidad');
    if (_precioCalidad) lista.add('Precio/Calidad');
    return lista.isEmpty ? 'Ninguna' : lista.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SectionHeader(
              title: 'Encuesta avanzada',
              color: Color(0xFF185FA5),
            ),

            _ratingBlock('Servicio *', _servicio, (v) => setState(() => _servicio = v)),
            _ratingBlock('Precio *', _precio, (v) => setState(() => _precio = v)),
            _ratingBlock('Calidad *', _calidad, (v) => setState(() => _calidad = v)),
            _ratingBlock('Atención *', _atencion, (v) => setState(() => _atencion = v)),

            const FieldLabel(label: 'Características que te gustaron'),
            CheckboxListTile(
              title: const Text('Atención al cliente'),
              value: _atencionCliente,
              onChanged: (v) => setState(() => _atencionCliente = v!),
            ),
            CheckboxListTile(
              title: const Text('Tiempo de respuesta'),
              value: _tiempoRespuesta,
              onChanged: (v) => setState(() => _tiempoRespuesta = v!),
            ),
            CheckboxListTile(
              title: const Text('Facilidad de uso'),
              value: _facilidadUso,
              onChanged: (v) => setState(() => _facilidadUso = v!),
            ),
            CheckboxListTile(
              title: const Text('Precio / calidad'),
              value: _precioCalidad,
              onChanged: (v) => setState(() => _precioCalidad = v!),
            ),

            const SizedBox(height: 16),

            const FieldLabel(label: 'Comentario *'),
            TextFormField(
              controller: _comentarioController,
              maxLines: 3,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Escribe un comentario' : null,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _enviarFormulario,
              child: const Text("Enviar encuesta"),
            ),

            if (_enviado)
              ResultCard(
                title: 'Resultado de la encuesta',
                color: const Color(0xFF0F6E56),
                icon: Icons.analytics_rounded,
                children: [
                  ResultRow(label: 'Servicio', value: '$_servicio / 5'),
                  ResultRow(label: 'Precio', value: '$_precio / 5'),
                  ResultRow(label: 'Calidad', value: '$_calidad / 5'),
                  ResultRow(label: 'Atención', value: '$_atencion / 5'),
                  const Divider(),
                  ResultRow(label: 'Características', value: _caracteristicas()),
                  const Divider(),
                  ResultRow(label: 'Comentario', value: _comentarioGuardado),
                ],
              )
          ],
        ),
      ),
    );
  }
}
