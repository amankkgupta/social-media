import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "question": "How do I share a picture with a story?",
        "answer":
            "Go to the Create Post section, upload your image, and add your story in the text box before posting.",
      },
      {
        "question": "Can I edit my post after publishing?",
        "answer":
            "Yes, you can edit your story text, but replacing the image is not supported yet.",
      },
      {
        "question": "How can I reset my password?",
        "answer":
            "Go to the login screen and click on 'Forgot Password'. Follow the instructions sent to your registered email.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Support",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // FAQ Section
            ...faqs.map((faq) {
              return ExpansionTile(
                title: Text(
                  faq["question"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(faq["answer"]!),
                  ),
                ],
              );
            }),

            const SizedBox(height: 32),

            const Text(
              "Still need help?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "If your issue is not listed above, feel free to reach out to our support team.",
            ),
            const SizedBox(height: 16),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.email),
                label: const Text("Contact Support"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
