// import 'package:fluentui_system_icons/fluentui_system_icons.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:stmart_home_elte/src/core/functions/functions.dart';
// import 'package:stmart_home_elte/src/core/theme/themes.dart';

// class TopHomeEneryInfoCard extends StatelessWidget {
//   const TopHomeEneryInfoCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map> items = [
//       {
//         'icon': FluentIcons.plug_disconnected_16_filled,
//         'title': 'Today',
//         'subtitle': '00.0 kMh',
//         'color': AppColors.palGreen,
//       },
//       {
//         'icon': FluentIcons.plug_disconnected_16_filled,
//         'title': 'This Month',
//         'subtitle': '00.00 kWh',
//         'color': AppColors.palRed,
//       }
//     ];
//     return DecoratedBox(
//       decoration: AppTheme.primaryDecoration,
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Row(children: [
//                   const Text(
//                     'Energy Usage',
//                     style: TextStyle(
//                       color: AppColors.text,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const Spacer(),
//                   //date selection
//                   const Icon(Icons.date_range, color: AppColors.text, size: 18),
//                   const SizedBox(width: 4),
//                   Text(
//                     formatDate(DateTime.now()),
//                     style: const TextStyle(
//                       color: AppColors.text,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.text, size: 20),
//                 ]),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: items.map((item) {
//                     return _buildStatisticsInfoItem(
//                       item['icon'],
//                       item['title'],
//                       item['subtitle'],
//                       item['color'],
//                     );
//                   }).toList(),
//                 )
//               ],
//             ),
//           ),
//           if (false)
//             Positioned(
//                 top: 0,
//                 right: 0,
//                 left: 0,
//                 bottom: 0,
//                 child: ClipRRect(
//                   borderRadius: AppTheme.primaryDecoration.borderRadius!,
//                   child: ColoredBox(
//                     color: Colors.black.withOpacity(0.7),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           FluentIcons.apps_24_filled,
//                           color: AppColors.white,
//                           size: 30,
//                         ),
//                         Text('Coming Soon',
//                             style: TextStyle(
//                               color: AppColors.white,
//                               fontSize: 16,
//                               background: Paint()..color = AppColors.primaryColor.withOpacity(0.4),
//                               fontWeight: FontWeight.bold,
//                             )),
//                       ],
//                     ),
//                   ),
//                 )),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatisticsInfoItem(IconData icon, String title, String subtitle, Color color) {
//     return Row(
//       children: [
//         DecoratedBox(
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Icon(icon, color: AppColors.white, size: 24),
//             )),
//         const SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 color: AppColors.text,
//                 fontSize: 14,
//               ),
//             ),
//             Text(
//               subtitle,
//               style: const TextStyle(
//                 color: AppColors.text,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
