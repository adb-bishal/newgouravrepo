// import 'package:flutter/material.dart';
//
// class DropDownData {
//   final String id;
//   final String optionName;
//
//   DropDownData({required this.id, required this.optionName});
// }
//
// class PastFilterScreen extends StatefulWidget {
//   final List<DropDownData> categories;
//   final List<DropDownData> selectedCategories;
//   final Function(List<DropDownData>) onApply;
//
//   const PastFilterScreen({
//     Key? key,
//     required this.categories,
//     required this.selectedCategories,
//     required this.onApply,
//   }) : super(key: key);
//
//   @override
//   State<PastFilterScreen> createState() => _PastFilterScreenState();
// }
//
// class _PastFilterScreenState extends State<PastFilterScreen> {
//   late List<DropDownData> _selectedCategories;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedCategories = List.from(widget.selectedCategories);
//   }
//
//   void _onCategoryTap(DropDownData category) {
//     setState(() {
//       if (_selectedCategories.any((c) => c.id == category.id)) {
//         _selectedCategories.removeWhere((c) => c.id == category.id);
//       } else {
//         _selectedCategories.add(category);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Filter by Category'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _selectedCategories.clear();
//               });
//             },
//             child: const Text(
//               'Clear All',
//               style: TextStyle(color: Colors.white),
//             ),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.categories.length,
//               itemBuilder: (context, index) {
//                 final category = widget.categories[index];
//                 final isSelected = _selectedCategories.any((c) => c.id == category.id);
//                 return ListTile(
//                   title: Text(category.optionName),
//                   trailing: isSelected
//                       ? const Icon(Icons.check_box, color: Colors.blue)
//                       : const Icon(Icons.check_box_outline_blank),
//                   onTap: () => _onCategoryTap(category),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: ElevatedButton(
//               onPressed: () {
//                 widget.onApply(_selectedCategories);
//                 Navigator.pop(context);
//               },
//               child: const Text('Apply'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
