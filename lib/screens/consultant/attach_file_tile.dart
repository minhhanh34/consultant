// import 'package:flutter/material.dart';

// class AttachFileTile extends StatefulWidget {
//   const AttachFileTile(this.name, {super.key});
//   final String name;
//   @override
//   State<AttachFileTile> createState() => _AttachFileTileState();
// }

// class _AttachFileTileState extends State<AttachFileTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Stack(
//             children: [
//               Chip(
//                 padding: const EdgeInsets.all(12),
//                 label: Text(widget.name),
//               ),
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: InkWell(
//                   onTap: () {
//                     widget.filePickerResult?.files.removeLast();
//                     if (widget.filePickerResult?.count == 0) {
//                       widget.filePickerResult = null;
//                     }
//                     setState(() {});
//                   },
//                   child: const CircleAvatar(
//                     radius: 12,
//                     child: Icon(Icons.close),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
