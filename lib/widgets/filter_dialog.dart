import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Function(Map<String, List<String>>) onApplyFilters;
  final Map<String, List<String>> currentFilters;

  const FilterDialog({
    Key? key,
    required this.onApplyFilters,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late Map<String, List<String>> selectedFilters;

  // Predefined filter options
  final Map<String, List<String>> filterOptions = {
    'Yaş Grubu': ['3-6 yaş', '6-9 yaş', '9-12 yaş', '12+ yaş'],
    'Konular': ['Arkadaşlık', 'Aile', 'Doğa', 'Macera', 'Eğitim'],
    'Hayvanlar': ['Aslan', 'Tavşan', 'Kurt', 'Tilki', 'Kuş'],
    'Temalar': ['Dostluk', 'Yardımlaşma', 'Cesaret', 'Dürüstlük', 'Sevgi'],
  };

  @override
  void initState() {
    super.initState();
    selectedFilters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtreleme Seçenekleri'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: filterOptions.entries.map((entry) {
            return ExpansionTile(
              title: Text(entry.key),
              children: [
                Wrap(
                  spacing: 8.0,
                  children: entry.value.map((option) {
                    final isSelected = selectedFilters[entry.key]?.contains(option) ?? false;
                    return FilterChip(
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedFilters.putIfAbsent(entry.key, () => []).add(option);
                          } else {
                            selectedFilters[entry.key]?.remove(option);
                            if (selectedFilters[entry.key]?.isEmpty ?? false) {
                              selectedFilters.remove(entry.key);
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApplyFilters(selectedFilters);
            Navigator.pop(context);
          },
          child: const Text('Uygula'),
        ),
      ],
    );
  }
} 