import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formularios Flutter ',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final screens = const [
    EncuestaScreen(),
    CilindroScreen(),
    PropinaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Formularios ")),
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.poll), label: "Encuesta"),
          NavigationDestination(icon: Icon(Icons.circle), label: "Cilindro"),
          NavigationDestination(icon: Icon(Icons.money), label: "Propina"),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// WIDGETS REUTILIZABLES
////////////////////////////////////////////////////////////

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
  }
}

class ResultCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ResultCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          ...children
        ]),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// ENCUESTA (MEJORADA)
////////////////////////////////////////////////////////////

class EncuestaScreen extends StatefulWidget {
  const EncuestaScreen({super.key});

  @override
  State<EncuestaScreen> createState() => _EncuestaScreenState();
}

class _EncuestaScreenState extends State<EncuestaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _comentario = TextEditingController();

  int? servicio;
  int? precio;
  int? calidad;
  int? atencion;

  bool enviado = false;

  Widget estrellas(int value) {
    return Row(
      children: List.generate(
        5,
        (i) => Icon(
          i < value ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 18,
        ),
      ),
    );
  }

  Widget pregunta(String titulo, int? valor, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo),
        ...List.generate(5, (i) {
          int val = i + 1;
          return RadioListTile(
            value: val,
            groupValue: valor,
            title: Row(
              children: [
                Text("$val"),
                const SizedBox(width: 10),
                estrellas(val),
              ],
            ),
            onChanged: (v) => onChanged(v as int),
          );
        })
      ],
    );
  }

  void enviar() {
    if (!_formKey.currentState!.validate()) return;

    if (servicio == null ||
        precio == null ||
        calidad == null ||
        atencion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Responde todas las preguntas")),
      );
      return;
    }

    setState(() => enviado = true);

    _comentario.clear(); // 🔥 LIMPIA EL CAMPO

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Encuesta enviada correctamente")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(children: [
          const SectionHeader("Encuesta"),

          pregunta("Servicio", servicio, (v) => setState(() => servicio = v)),
          pregunta("Precio", precio, (v) => setState(() => precio = v)),
          pregunta("Calidad", calidad, (v) => setState(() => calidad = v)),
          pregunta("Atención", atencion, (v) => setState(() => atencion = v)),

          TextFormField(
            controller: _comentario,
            decoration: const InputDecoration(labelText: "Comentario"),
            validator: (v) =>
                v == null || v.isEmpty ? "Escribe un comentario" : null,
          ),

          const SizedBox(height: 20),

          ElevatedButton(onPressed: enviar, child: const Text("Enviar")),

          if (enviado)
            ResultCard(
              title: "Resultado",
              children: [
                Text("Servicio: $servicio"),
                Text("Precio: $precio"),
                Text("Calidad: $calidad"),
                Text("Atención: $atencion"),
                Text("Comentario enviado correctamente"),
              ],
            )
        ]),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// CILINDRO (CON SELECTOR)
////////////////////////////////////////////////////////////

class CilindroScreen extends StatefulWidget {
  const CilindroScreen({super.key});

  @override
  State<CilindroScreen> createState() => _CilindroScreenState();
}

class _CilindroScreenState extends State<CilindroScreen> {
  final rCtrl = TextEditingController();
  final hCtrl = TextEditingController();

  String opcion = "Volumen";
  double? resultado;

  void calcular() {
    double r = double.parse(rCtrl.text);
    double h = double.parse(hCtrl.text);

    setState(() {
      if (opcion == "Volumen") {
        resultado = pi * r * r * h;
      } else if (opcion == "Área lateral") {
        resultado = 2 * pi * r * h;
      } else {
        resultado = 2 * pi * r * (r + h);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const SectionHeader("Cilindro"),
        TextField(controller: rCtrl, decoration: const InputDecoration(labelText: "Radio")),
        TextField(controller: hCtrl, decoration: const InputDecoration(labelText: "Altura")),

        DropdownButton<String>(
          value: opcion,
          items: ["Volumen", "Área lateral", "Área total"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => opcion = v!),
        ),

        ElevatedButton(onPressed: calcular, child: const Text("Calcular")),

        if (resultado != null)
          ResultCard(
            title: opcion,
            children: [Text(resultado!.toStringAsFixed(2))],
          )
      ]),
    );
  }
}

////////////////////////////////////////////////////////////
/// PROPINA
////////////////////////////////////////////////////////////

class PropinaScreen extends StatefulWidget {
  const PropinaScreen({super.key});

  @override
  State<PropinaScreen> createState() => _PropinaScreenState();
}

class _PropinaScreenState extends State<PropinaScreen> {
  final ctrl = TextEditingController();
  int porcentaje = 10;
  double? total;

  void calcular() {
    double cuenta = double.parse(ctrl.text);
    setState(() {
      total = cuenta + (cuenta * porcentaje / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const SectionHeader("Propina"),
        TextField(controller: ctrl, decoration: const InputDecoration(labelText: "Cuenta")),

        DropdownButton<int>(
          value: porcentaje,
          items: [10, 15, 20]
              .map((e) => DropdownMenuItem(value: e, child: Text("$e%")))
              .toList(),
          onChanged: (v) => setState(() => porcentaje = v!),
        ),

        ElevatedButton(onPressed: calcular, child: const Text("Calcular")),

        if (total != null)
          ResultCard(
            title: "Total a pagar",
            children: [Text("\$${total!.toStringAsFixed(0)}")],
          )
      ]),
    );
  }
}
