import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  /// send email
  Future<void> _sendEmail(String email) async {
    print('clicked email');
    final Uri emailLauncher = Uri(scheme: "mailto", path: email, query: " ");
    await launchUrl(emailLauncher);
  }

  /// call
  Future<void> _call(String phoneNumber) async {
    print('clicked call');
    final Uri emailLauncher = Uri(
      scheme: "tel",
      path: phoneNumber,
    );
    await launchUrl(emailLauncher);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).primaryColorDark, // Light green background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 22),
              const Text(
                " Contact us whether you have a suggestion on our improvement, a complain to discuss or an issue to solve. FEEL FREE",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 28),

              // Row of contact options
              Row(
                children: [
                  // Call us///////////////////////////////////////
                  Expanded(
                    child: InkWell(
                      onTap: () => _call('9864463468'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.call, size: 36, color: Colors.black),
                            SizedBox(height: 10),
                            Text(
                              'Call Us',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '9864463468',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),
                  // Email us///////////////////////////////////////////////////////////////
                  Expanded(
                    child: InkWell(
                      onTap: () => _sendEmail('shrezana2060@gmail.com'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.email, size: 36, color: Colors.black),
                            const SizedBox(height: 10),
                            Text(
                              'Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'shrezana2060@gmail.com',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '..........',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 48),

              const Center(
                child: Text('FEEL FREE TO CONTACT US ',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          )),
    );
  }
}

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String timing;
  final Color cardColor;
  final VoidCallback onTap;
  const ContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timing,
    required this.cardColor,
    required this.onTap, // default if not passed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: Colors.black),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            timing,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
