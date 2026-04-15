import 'package:flutter/material.dart';

// Encabezado de cada pantalla
class SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const SectionHeader({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}

// Etiqueta de campo
class FieldLabel extends StatelessWidget {
  final String label;

  const FieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF374151),
        ),
      ),
    );
  }
}

// Tarjeta de resultados
class ResultCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final List<Widget> children;

  const ResultCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

// Fila de resultado
class ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool destacado;

  const ResultRow({
    super.key,
    required this.label,
    required this.value,
    this.destacado = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: destacado ? 18 : 14,
                fontWeight: destacado ? FontWeight.w700 : FontWeight.w500,
                color: destacado
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
