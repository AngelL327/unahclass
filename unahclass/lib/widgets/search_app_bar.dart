import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onTextChanged;
  final ValueChanged<String>? onSubmitted;
  final String Function(String)? getSuggestion;

  const SearchAppBar({
    Key? key,
    required this.onTextChanged,
    this.onSubmitted,
    this.getSuggestion,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final TextEditingController _searchController = TextEditingController();
  String _hintSuggestion = 'Buscar carrera...';

  void _onChanged() {
    final text = _searchController.text;
    widget.onTextChanged(text);

    if (widget.getSuggestion != null) {
      try {
        final suggestion = widget.getSuggestion!(text);
        if (suggestion.isNotEmpty && suggestion != _hintSuggestion) {
          setState(() {
            _hintSuggestion = suggestion;
          });
        }
      } catch (e) {
        // Si getSuggestion lanza un error (por ejemplo por un índice), mantenemos el hint por defecto
        setState(() {
          _hintSuggestion = 'Buscar carrera...';
        });
      }
    }
  }

  void _onSubmitted(String value) {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(value);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onChanged);
    _searchController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: PreferredSize(
      preferredSize: const Size.fromHeight(90), // Aumentamos la altura
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50)),
        child: AppBar(
          backgroundColor: const Color(0xFF1D9FCB),
          elevation: 4,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
        
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => _onChanged(),
                        onTap: () {
                          setState(() {});
                        },
                        onSubmitted: _onSubmitted,
                        decoration: InputDecoration(
                          hintText: _hintSuggestion,
                          hintStyle: const TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          widget.onTextChanged('');
                          setState(() {
                            _hintSuggestion = 'Buscar carrera...';
                          });
                        },
                        child: const Icon(Icons.clear, color: Colors.black),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
