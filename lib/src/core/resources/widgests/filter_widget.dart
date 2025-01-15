// filter_widget.dart

import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final Map<String, List<String>> filterOptions; // Use a map for dynamic filter options
  final Function(Map<String, dynamic>) onFilterChanged;

  const FilterWidget({
    Key? key,
    required this.filterOptions,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final Map<String, dynamic> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    // Initialize selected filters with default values (e.g., 'all' or null)
    for (var key in widget.filterOptions.keys) {
      _selectedFilters[key] = widget.filterOptions[key]!.isNotEmpty
          ? widget.filterOptions[key]!.first
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Filter Options'),
        ...widget.filterOptions.entries.map((entry) {
          final filterName = entry.key;
          final filterValues = entry.value;
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: filterName),
            value: _selectedFilters[filterName],
            items: filterValues.map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedFilters[filterName] = value;
              });
            },
          );
        }).toList(),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Keywords'),
          onChanged: (value) {
            _selectedFilters['keywords'] = value;
          },
        ),
        ElevatedButton(
          onPressed: () {
            widget.onFilterChanged(_selectedFilters);
          },
          child: const Text('Apply Filters'),
        ),
      ],
    );
  }
}