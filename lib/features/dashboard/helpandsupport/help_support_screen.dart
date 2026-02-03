
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const supportNumber = "6565656565";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Help & Support"),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _showCallPopup(context),
          ),
        ],
      ),

      // 🔹 BODY
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _videoTile(
            context,
            title: "How to book truck",
            subtitle:
            "Create your request and get an instant truck match for your shipment.",
            videoId: "dQw4w9WgXcQ", // demo
          ),
          _videoTile(
            context,
            title: "How to confirm booking?",
            subtitle:
            "Watch this quick guide on how to confirm your booking.",
            videoId: "dQw4w9WgXcQ",
          ),
          _videoTile(
            context,
            title: "Make Payment in Easy Steps!",
            subtitle:
            "Quickly pay for your bookings with secure methods.",
            videoId: "dQw4w9WgXcQ",
          ),
          _videoTile(
            context,
            title: "Check Live Market Rates",
            subtitle:
            "Stay updated with live truck rates in the app.",
            videoId: "dQw4w9WgXcQ",
          ),
          _videoTile(
            context,
            title: "How to Track your Shipment?",
            subtitle:
            "Monitor shipment journey in real-time.",
            videoId: "dQw4w9WgXcQ",
          ),
        ],
      ),
    );
  }

  // ================= CALL POPUP =================

  void _showCallPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: const Text("May I help you?"),
        content: Text(
          supportNumber,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () async {
              final Uri phoneUri = Uri(
                scheme: 'tel',
                path: supportNumber,
              );

              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Unable to open dialer"),
                  ),
                );
              }
            },
            child: const Text("Call Now"),
          ),

        ],
      ),
    );
  }

  // ================= VIDEO TILE =================

  Widget _videoTile(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String videoId,
      }) {
    return InkWell(
      onTap: () => _openVideoSheet(context, videoId, title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= VIDEO BOTTOM SHEET =================

  void _openVideoSheet(
      BuildContext context, String videoId, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
