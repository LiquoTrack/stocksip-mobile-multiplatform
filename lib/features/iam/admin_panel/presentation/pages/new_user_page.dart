import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksip/core/interceptor/auth_http_cliente.dart';
import 'package:stocksip/core/storage/token_storage.dart';
import 'package:stocksip/features/iam/admin_panel/data/remote/services/adminpanel_service.dart';
import 'package:stocksip/features/iam/admin_panel/data/repositories/adminpanel_repository_impl.dart';
import 'package:stocksip/features/iam/admin_panel/domain/models/sub_user.dart';
import 'package:stocksip/features/iam/admin_panel/domain/repositories/adminpanel_repository.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/blocs/adminpanel_bloc.dart';
import 'package:stocksip/features/iam/admin_panel/presentation/blocs/adminpanel_event.dart';

class NewUserPage extends StatelessWidget {
  final AdminPanelRepository? repository;
  final String? accountId;
  final BuildContext parentContext;

  const NewUserPage({super.key, this.repository, this.accountId, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final textStyleLabel = const TextStyle(
      color: Color(0xFF2B000D),
      fontWeight: FontWeight.w600,
    );

    String? systemRole;
    String? assignedRole;
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF4ECEC),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border.all(color: const Color(0xFFE0D4D4)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: StatefulBuilder(
                builder: (context, setSt) {

                  Future<void> pickOption({
                    required List<String> options,
                    required ValueChanged<String> onSelected,
                    String? initial,
                  }) async {
                    final selected = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) => SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: options
                                .map((item) => ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                      title: Text(
                                        item,
                                        style: const TextStyle(
                                            color: Color(0xFF2B000D), fontWeight: FontWeight.w600),
                                      ),
                                      trailing: initial == item
                                          ? const Icon(Icons.check, color: Color(0xFF4C1F24))
                                          : null,
                                      onTap: () => Navigator.pop(context, item),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    );
                    if (selected != null) onSelected(selected);
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Color(0xFF2B000D)),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          const Text('New User',
                              style: TextStyle(
                                  color: Color(0xFF2B000D), fontWeight: FontWeight.w600)),
                          IconButton(
                            icon: const Icon(Icons.check, color: Color(0xFF2B000D)),
                            onPressed: () async {
                              final name = nameCtrl.text.trim();
                              final email = emailCtrl.text.trim();
                              final password = passwordCtrl.text;
                              final phone = phoneCtrl.text.trim();
                              final role = systemRole ?? 'Employee';
                              final profileRole = assignedRole ?? 'Seller';

                              if (name.isEmpty ||
                                  email.isEmpty ||
                                  password.isEmpty ||
                                  phone.isEmpty ||
                                  role.isEmpty ||
                                  profileRole.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Complete all fields and roles')),
                                );
                                return;
                              }

                              final accId = accountId ?? await TokenStorage().readAccountId();
                              if (accId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No account id available')),
                                );
                                return;
                              }

                              final repo = repository ?? AdminPanelRepositoryImpl(
                                    service: AdminPanelService(client: AuthHttpClient()),
                                    tokenStorage: TokenStorage(),
                                  );
                              try {
                                await repo.registerSubUser(
                                  accId,
                                  SubUserCreate(
                                    name: name,
                                    email: email,
                                    password: password,
                                    role: role,
                                    phoneNumber: phone,
                                    profileRole: profileRole,
                                  ),
                                );
                                final currentRole =
                                    parentContext.read<AdminPanelBloc>().state.selectedRole;
                                parentContext
                                    .read<AdminPanelBloc>()
                                    .add(LoadSubUsers(currentRole));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(parentContext).showSnackBar(
                                    const SnackBar(content: Text('Sub user registered')),
                                  );
                                  Navigator.of(context).maybePop();
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(parentContext).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Text('User Info', style: textStyleLabel),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: const TextStyle(color: Color(0xFF6C6C6C)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE0D4D4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE0D4D4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF4C1F24)),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        style: const TextStyle(color: Color(0xFF2B000D)),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Color(0xFF6C6C6C)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE0D4D4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE0D4D4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF4C1F24)),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        style: const TextStyle(color: Color(0xFF2B000D)),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passwordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Color(0xFF6C6C6C)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE0D4D4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE0D4D4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF4C1F24)),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        style: const TextStyle(color: Color(0xFF2B000D)),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Phone number',
                          hintStyle: const TextStyle(color: Color(0xFF6C6C6C)),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE0D4D4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE0D4D4)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFF4C1F24)),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        style: const TextStyle(color: Color(0xFF2B000D)),
                      ),
                      const SizedBox(height: 20),
                      Text('Role (system)', style: textStyleLabel),
                      const SizedBox(height: 8),
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          await pickOption(
                            options: const ['Admin', 'Employee'],
                            initial: systemRole,
                            onSelected: (val) => setSt(() => systemRole = val),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE0D4D4)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  systemRole ?? 'Select role',
                                  style: const TextStyle(color: Color(0xFF6C6C6C)),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, color: Color(0xFF6C6C6C)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Role assigned', style: textStyleLabel),
                      const SizedBox(height: 8),
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          await pickOption(
                            options: const ['Seller', 'Buyer', 'WarehouseWorker', 'Admin'],
                            initial: assignedRole,
                            onSelected: (val) => setSt(() => assignedRole = val),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE0D4D4)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  assignedRole ?? 'Select assignment',
                                  style: const TextStyle(color: Color(0xFF6C6C6C)),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, color: Color(0xFF6C6C6C)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

