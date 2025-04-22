import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unahclass/widgets/helper.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _dialogAbierto = false;
  final Map<DateTime, List<Map<String, String>>> _eventos = {};

  @override
  void initState() {
    super.initState();
    _cargarEventos();
  }

  DateTime _normalizarFecha(DateTime fecha) =>
      DateTime(fecha.year, fecha.month, fecha.day);

  Future<void> _guardarEventos() async {
    final eventosSerializados = {};

    _eventos.forEach((fecha, eventos) {
      eventosSerializados[fecha.toIso8601String()] = eventos;
    });

    await UserPrefs.setString('eventos', jsonEncode(eventosSerializados));
    print('Eventos guardados: ${_eventos.length}');
  }

  Future<void> _cargarEventos() async {
    final jsonString = await UserPrefs.getString('eventos');

    if (jsonString == null || jsonString.isEmpty) return;

    try {
      final datos = jsonDecode(jsonString) as Map<String, dynamic>;
      final eventosCargados = <DateTime, List<Map<String, String>>>{};

      datos.forEach((fechaStr, eventosList) {
        final fecha = DateTime.parse(fechaStr);
        final eventos =
            (eventosList as List)
                .map((e) => Map<String, String>.from(e))
                .toList();
        eventosCargados[_normalizarFecha(fecha)] = eventos;
      });

      setState(() {
        _eventos.clear();
        _eventos.addAll(eventosCargados);
      });

      print('Eventos cargados: ${_eventos.length}');
    } catch (e) {
      print('Error cargando eventos: $e');
    }
  }

  void _agregarEvento(DateTime fecha, String titulo, String tipo) {
    final fechaNormalizada = _normalizarFecha(fecha);

    setState(() {
      _eventos.putIfAbsent(fechaNormalizada, () => []);
      _eventos[fechaNormalizada]!.add({
        'titulo': titulo,
        'tipo': tipo,
        'fecha': fechaNormalizada.toIso8601String(),
      });
    });

    _guardarEventos();
  }

  void _borrarEvento(DateTime fecha, int index) {
    final fechaNormalizada = _normalizarFecha(fecha);

    setState(() {
      _eventos[fechaNormalizada]?.removeAt(index);
      if (_eventos[fechaNormalizada]?.isEmpty ?? false) {
        _eventos.remove(fechaNormalizada);
      }
    });

    _guardarEventos();
  }

  List<Map<String, String>> _obtenerEventosDelDia(DateTime dia) {
    return _eventos[_normalizarFecha(dia)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final eventosDelDia = _obtenerEventosDelDia(_selectedDay ?? DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendario Académico"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _obtenerEventosDelDia,
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child:
                eventosDelDia.isEmpty
                    ? Center(
                      child: Text(
                        "No hay eventos para este día",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: eventosDelDia.length,
                      itemBuilder: (context, index) {
                        final evento = eventosDelDia[index];
                        return Dismissible(
                          key: Key('${evento['titulo']}$index'),
                          background: Container(color: Colors.red),
                          onDismissed:
                              (_) => _borrarEvento(
                                _selectedDay ?? DateTime.now(),
                                index,
                              ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              evento['titulo']!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton:
          _dialogAbierto
              ? null
              : FloatingActionButton(
                onPressed: () => _mostrarDialogoAgregarEvento(context),
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              ),
    );
  }

  void _mostrarDialogoAgregarEvento(BuildContext context) {
    String titulo = '';
    DateTime? fechaSeleccionada = _selectedDay ?? DateTime.now();

    setState(() => _dialogAbierto = true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setStateBottomSheet) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Nuevo Evento',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Título del evento',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => titulo = value,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            fechaSeleccionada != null
                                ? '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}'
                                : 'Seleccionar fecha',
                          ),

                          onPressed: () async {
                            final nuevaFecha = await showDatePicker(
                              context: context,
                              initialDate: fechaSeleccionada ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (nuevaFecha != null) {
                              setStateBottomSheet(() {
                                fechaSeleccionada = nuevaFecha;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (titulo.isNotEmpty && fechaSeleccionada != null) {
                            _agregarEvento(fechaSeleccionada!, titulo, '');
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        );
      },
    ).then((_) => setState(() => _dialogAbierto = false));
  }
}
