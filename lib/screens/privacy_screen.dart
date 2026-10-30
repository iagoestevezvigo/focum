import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focum/l10n/l10n.dart';
import 'package:focum/services/native_focum_service.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  late final Future<String> _policy = rootBundle.loadString('PRIVACY.md');

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.privacyTitle)),
    body: FutureBuilder<String>(
      future: _policy,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: snapshot.hasError
                ? Text(context.l10n.privacyLoadError)
                : const CircularProgressIndicator(),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(context.l10n.privacyLanguageNote),
            const SizedBox(height: 16),
            for (final paragraph
                in snapshot.data!.replaceAll('\r\n', '\n').split('\n\n'))
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SelectableText(
                  paragraph
                      .replaceAll(RegExp(r'^#+\s*'), '')
                      .replaceAll('**', ''),
                  style: paragraph.startsWith('#')
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            OutlinedButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(context.l10n.deleteData),
                    content: Text(context.l10n.deleteDataMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(context.l10n.consentDecline),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(context.l10n.deleteData),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await NativeFocumService().clearLocalData();
                }
              },
              child: Text(context.l10n.deleteData),
            ),
          ],
        );
      },
    ),
  );
}
