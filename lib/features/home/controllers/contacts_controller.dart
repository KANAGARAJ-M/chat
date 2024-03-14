import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chat/features/home/data/repositories/contact_repository.dart';
import 'package:chat/shared/models/contact.dart';
import 'package:chat/features/chat/views/chat.dart';
import 'package:chat/shared/models/user.dart';
import 'package:chat/shared/repositories/isar_db.dart';
import 'package:chat/shared/utils/abc.dart';

final contactsProvider = FutureProvider<List<Contact>>((ref) async {
  if (await isConnected()) {
    await IsarDb.refreshContacts();
  }

  return IsarDb.getContacts();
});

final contactPickerControllerProvider =
    StateNotifierProvider.autoDispose<ContactPickerController, List<Contact>>(
  (ref) => ContactPickerController(ref),
);

const shareMsg =
//need to update link
    'Let\'s chat on Chat Up! It\'s a fast, simple, and secure app we can use to message and call each other for free. Get it on Play Store https://play.google.com/store/apps/details?id=chatup.mkrcreation.com';

class ContactPickerController extends StateNotifier<List<Contact>> {
  late List<Contact> _contacts;

  final TextEditingController searchController = TextEditingController();
  final AutoDisposeStateNotifierProviderRef ref;
  bool contactsRefreshing = false;

  ContactPickerController(this.ref) : super([]);

  Future<void> init() async {
    _contacts = await ref.read(contactsProvider.future);
    state = _contacts;

    ref.listen(contactsProvider, (previous, next) {
      next.whenData(
        (value) {
          _contacts = value;
          updateSearchResults(searchController.text);
        },
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openContacts() {
    ref.read(contactsRepositoryProvider).openContacts();
  }

  void refreshContactsList() {
    ref.invalidate(contactsProvider);
  }

  void pickContact(BuildContext context, User sender, Contact contact) async {
    final receiver = await IsarDb.getUserById(contact.userId!);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          self: sender,
          other: receiver!,
          otherUserContactName: contact.displayName,
        ),
        settings: const RouteSettings(name: 'chat'),
      ),
    );
  }

  void createNewContact() {
    ref.read(contactsRepositoryProvider).createNewContact();
  }

  void shareInviteLink(RenderBox? box) {
    Share.share(
      shareMsg,
      subject: 'Chat Up Messenger: Android + iPhone',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  void sendSms(String phoneNumber) {
    launchUrl(Uri.parse('sms:$phoneNumber?body=$shareMsg'));
  }

  void showHelp() {
    launchUrl(
      Uri.parse(
        'https://kanagaraj-m.github.io/',
      ),
    );
  }

  void onCloseBtnPressed() {
    searchController.clear();
    state = _contacts;
  }

  void updateSearchResults(String query) {
    query = query.toLowerCase().trim();

    state = _contacts.where((contact) {
      return contact.displayName.toLowerCase().startsWith(query);
    }).toList();
  }
}
