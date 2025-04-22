import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Evento {
  final String titulo;
  final String tipo;

  Evento(this.titulo, this.tipo);

  Map<String, dynamic> toJson() => {'titulo': titulo, 'tipo': tipo};

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(json['titulo'], json['tipo']);
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Evento>> _eventos = {};

  List<Evento> _getEventosParaDia(DateTime dia) {
    final normalizedDate = DateTime(dia.year, dia.month, dia.day);
    return _eventos[normalizedDate] ?? [];
  }

  Future<void> _guardarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _eventos.map(
      (key, value) => MapEntry(
        key.toIso8601String(),
        value.map((e) => e.toJson()).toList(),
      ),
    );
    await prefs.setString('eventos', json.encode(data));
  }

  Future<void> _cargarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('eventos');
    if (data != null) {
      final decoded = json.decode(data) as Map<String, dynamic>;
      setState(() {
        _eventos.clear();
        decoded.forEach((key, value) {
          final date = DateTime.parse(key);
          final eventosList =
              (value as List).map((e) => Evento.fromJson(e)).toList();
          _eventos[date] = eventosList;
        });
      });
    }
  }

  void _agregarEvento(DateTime fecha, Evento evento) {
    final normalizedDate = DateTime(fecha.year, fecha.month, fecha.day);
    setState(() {
      if (_eventos[normalizedDate] != null) {
        _eventos[normalizedDate]!.add(evento);
      } else {
        _eventos[normalizedDate] = [evento];
      }
    });
    _guardarEventos();
  }

  void _mostrarDialogoAgregarEvento() {
    String titulo = '';
    String tipo = 'Clase';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nueva asignación"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Título"),
                onChanged: (value) => titulo = value,
              ),
              DropdownButton<String>(
                value: tipo,
                onChanged: (value) {
                  if (value != null) setState(() => tipo = value);
                },
                items:
                    ["Clase", "Tarea", "Examen"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titulo.isNotEmpty && _selectedDay != null) {
                  _agregarEvento(_selectedDay!, Evento(titulo, tipo));
                }
                Navigator.pop(context);
              },
              child: Text("Guardar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoEliminarEvento(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("¿Eliminar evento?"),
            content: Text("¿Estás seguro de eliminar esta asignación?"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    final normalizedDate = DateTime(
                      _selectedDay!.year,
                      _selectedDay!.month,
                      _selectedDay!.day,
                    );
                    final eventosDelDia = _eventos[normalizedDate]!;
                    eventosDelDia.removeAt(index);
                    if (eventosDelDia.isEmpty) {
                      _eventos.remove(normalizedDate);
                    }
                  });
                  _guardarEventos();
                  Navigator.pop(context);
                },
                child: Text("Eliminar", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _cargarEventos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendario Académico")),
      body: Column(
        children: [
          TableCalendar<Evento>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2070, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventosParaDia,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children:
                  _getEventosParaDia(_selectedDay!).asMap().entries.map((
                    entry,
                  ) {
                    final index = entry.key;
                    final evento = entry.value;
                    return ListTile(
                      title: Text(evento.titulo),
                      subtitle: Text(evento.tipo),
                      leading: Icon(
                        evento.tipo == "Examen"
                            ? Icons.assignment
                            : evento.tipo == "Tarea"
                            ? Icons.task
                            : Icons.school,
                      ),
                      onLongPress: () => _mostrarDialogoEliminarEvento(index),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 56,
        child: FloatingActionButton.extended(
          onPressed: _mostrarDialogoAgregarEvento,
          backgroundColor: Colors.blue,
          label: Text(
            'Añadir evento',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
