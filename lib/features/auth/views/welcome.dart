import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat/features/auth/views/login.dart';
import 'package:chat/shared/widgets/buttons.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _navigateToLoginPage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (builder) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).custom.colorTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
          systemNavigationBarColor: colorTheme.navigationBarColor,
        ),
        actions: [
          Icon(
            Icons.more_vert_rounded,
            color: colorTheme.greyColor,
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/images/landing_img.png',
            //   color: colorTheme.greenColor,
            //   width: MediaQuery.of(context).size.width * 0.70,
            //   height: MediaQuery.of(context).size.height * 0.4,
            // ),
            const SizedBox(height: 50),
            Text(
              'Welcome to Chat UP',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: colorTheme.textColor2,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: colorTheme.greyColor),
                  children: [
                    const TextSpan(text: 'Read our '),
                    TextSpan(
                      text: 'Privacy Policy. ',
                      style: TextStyle(color: colorTheme.blueColor),
                    ),
                    const TextSpan(
                        text: 'Tap "Agree and Continue" to accept the'),
                    TextSpan(
                      text: ' Terms of Service.',
                      style: TextStyle(color: colorTheme.blueColor),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 52,
                vertical: 25,
              ),
              child: GreenElevatedButton(
                onPressed: () => _navigateToLoginPage(context),
                text: 'Agree and continue',
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () async {
                const url =
                    // "https://www.freeprivacypolicy.com/live/e15981b9-1e73-4e8e-bd56-cbc5dc25025a";
                    "https://www.privacypolicies.com/live/1b4cb033-60cd-476a-9a09-c87b250e656d";
                final Uri _url = Uri.parse(url);
                await launchUrl(
                  _url,
                  mode: LaunchMode.inAppBrowserView,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromARGB(255, 23, 36, 44)
                      : const Color.fromARGB(171, 235, 235, 235),
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(
                    //   Icons.map_rounded,
                    //   color: colorTheme.greenColor,
                    // ),
                    const SizedBox(width: 12),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(color: colorTheme.greenColor),
                    ),
                    const SizedBox(width: 12),
                    // Icon(
                    //   Icons.keyboard_arrow_down,
                    //   color: colorTheme.greenColor,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
