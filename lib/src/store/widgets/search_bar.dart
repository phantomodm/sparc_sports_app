import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key, required this.onSearch, required this.hintText});

  final Function(String) onSearch; // Callback function to handle search queries
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300, // Adjust color as needed
            blurRadius: 5,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Search $hintText...',
            hintStyle: Theme.of(context).textTheme.bodySmall,
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
          ),
          onSubmitted: (text) {
            onSearch(text);
          },
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Neumorphic(
  //     style: NeumorphicStyle(
  //       color: Theme.of(context).primaryColor, // Match your primary color
  //       boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       child: TextField(
  //         style: Theme.of(context).textTheme.bodyMedium, // Text color for contrast
  //         decoration: InputDecoration(
  //           hintText: 'Search $hintText...',
  //           hintStyle: Theme.of(context).textTheme.bodySmall, // Hint text color
  //           border: InputBorder.none,
  //           icon: Icon(Icons.search, color:Theme.of(context).iconTheme.color),
  //         ),
  //         onSubmitted: (text) {
  //           onSearch(text); // Call the onSearch callback with the search query
  //         },
  //       ),
  //     ),
  //   );
  // }
}
