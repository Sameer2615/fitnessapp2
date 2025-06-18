// import 'package:flutter/material.dart';

// class ContactUsPage extends StatelessWidget {
//   const ContactUsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFD4F5D2), // Light green background
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const BackButton(color: Colors.black),
//         title: const Text(
//           'Menu',
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Contact Us',
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "Don’t hesitate to contact us whether you have a suggestion on our improvement, a complain to discuss or an issue to solve.",
//               style: TextStyle(fontSize: 15),
//             ),
//             const SizedBox(height: 28),

//             // Row of contact options
//             Row(
//               children: [
//                 // Call us
//                 Expanded(
//                   child: ContactCard(
//                     icon: Icons.phone,
//                     title: "Call us",
//                     subtitle: "Our team is on the line",
//                     timing: "Mon-Fri · 9-17",
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 // Email us
//                 Expanded(
//                   child: ContactCard(
//                     icon: Icons.email,
//                     title: "Email us",
//                     subtitle: "Our team is online",
//                     timing: "Mon-Fri · 9-17",
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 28),

//             // Social Media Text
//             const Center(
//               child: Text(
//                 "Contact us in Social Media",
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ContactCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final String timing;

//   const ContactCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.timing,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 22),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, size: 36, color: Colors.black),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             subtitle,
//             style: const TextStyle(fontSize: 13, color: Colors.black54),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             timing,
//             style: const TextStyle(fontSize: 13, color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }
// }
