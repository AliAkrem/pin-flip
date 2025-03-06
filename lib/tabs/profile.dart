import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pin_flip/shared/adaptive.dart';

import 'package:pin_flip/shared/settingsItems.dart';
import 'package:pin_flip/tabs/sidebar.dart';
import "package:flutter_gen/gen_l10n/gallery_localizations.dart";

class PrifileView extends StatefulWidget {
  const PrifileView({super.key});

  @override
  _PrifileViewState createState() => _PrifileViewState();
}

class _PrifileViewState extends State<PrifileView> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return TabWithSidebar(
      restorationId: "profile_view",
      mainView: Stack(
        children: [
          if (!isDesktop)
            Positioned(
                top: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Icons.menu),
                  ),
                )),
          Center(
              child: ProfileWidget(
            imageUrl: 'assets/images/profile_image.png',
            userName: 'John Doe',
            dateOfBirth: DateTime(1990, 5, 15),
            placeOfBirth: 'New York, USA',
          ))
        ],
      ),
      sidebarItems: const [Settingsitems()],
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final DateTime dateOfBirth;
  final String placeOfBirth;

  const ProfileWidget({
    super.key,
    required this.imageUrl,
    required this.userName,
    required this.dateOfBirth,
    required this.placeOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(imageUrl),
          ),
          const SizedBox(height: 12),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            Icons.cake,
            '${GalleryLocalizations.of(context)!.pinFlipBirthDate}: ${DateFormat('MMMM d, yyyy').format(dateOfBirth)}',
          ),
          const SizedBox(height: 4),
          _buildInfoRow(
            context,
            Icons.location_on,
            '${GalleryLocalizations.of(context)!.pinFlipPlaceBirth}: $placeOfBirth',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodyMedium)
      ],
    );
  }
}
