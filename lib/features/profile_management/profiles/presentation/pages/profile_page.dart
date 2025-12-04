import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/enums/status.dart';
import '../../../../../shared/presentation/widgets/drawer_navigation.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfileEvent());
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null && mounted) {
      context.read<ProfileBloc>().add(
            OnImageSelected(imagePath: pickedFile.path),
          );
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) => previous.message != current.message,
      listener: (context, state) {
        if (state.message != null) {
          _showMessage(state.message!);
          context.read<ProfileBloc>().add(const ClearMessageEvent());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Profile"),
            ),
            drawer: const DrawerNavigation(),
            body: state.status == Status.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF4A1B2A),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "User Information",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16.0),
                        _buildProfileImage(state),
                        const SizedBox(height: 32.0),
                        ProfileField(
                          label: 'First Name',
                          value: state.firstName,
                          onValueChange: (value) {
                            context.read<ProfileBloc>().add(
                                  OnFirstNameChanged(firstName: value),
                                );
                          },
                          isEditMode: state.isEditMode,
                          enabled: state.status != Status.loading,
                        ),
                        const SizedBox(height: 16.0),
                        ProfileField(
                          label: 'Last Name',
                          value: state.lastName,
                          onValueChange: (value) {
                            context.read<ProfileBloc>().add(
                                  OnLastNameChanged(lastName: value),
                                );
                          },
                          isEditMode: state.isEditMode,
                          enabled: state.status != Status.loading,
                        ),
                        const SizedBox(height: 16.0),
                        ProfileField(
                          label: 'Phone Number',
                          value: state.phoneNumber,
                          onValueChange: (value) {
                            context.read<ProfileBloc>().add(
                                  OnPhoneNumberChanged(phoneNumber: value),
                                );
                          },
                          isEditMode: state.isEditMode,
                          enabled: state.status != Status.loading,
                        ),
                        const SizedBox(height: 16.0),
                        ProfileField(
                          label: 'Assigned Role',
                          value: state.assignedRole,
                          onValueChange: (value) {
                            context.read<ProfileBloc>().add(
                                  OnAssignedRoleChanged(assignedRole: value),
                                );
                          },
                          isEditMode: state.isEditMode,
                          enabled: state.status != Status.loading,
                        ),
                        const SizedBox(height: 24.0),
                        SizedBox(
                          width: double.infinity,
                          height: 48.0,
                          child: ElevatedButton(
                            onPressed: state.status == Status.loading
                                ? null
                                : () {
                                    if (state.isEditMode) {
                                      context.read<ProfileBloc>().add(
                                            const SaveProfileEvent(),
                                          );
                                    } else {
                                      context.read<ProfileBloc>().add(
                                            const ToggleEditModeEvent(),
                                          );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A1B2A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                            child: state.status == Status.loading
                                ? const SizedBox(
                                    width: 24.0,
                                    height: 24.0,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : Text(
                                    state.isEditMode ? 'Save' : 'Edit Profile',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(ProfileState state) {
    final String? imageToShow = state.isEditMode && state.selectedImageUri != null
        ? state.selectedImageUri
        : state.profilePictureUrl;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (imageToShow == null || imageToShow.isEmpty)
              Container(
                width: 120.0,
                height: 120.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFB8D4E8),
                ),
                child: const Icon(
                  Icons.add_reaction,
                  color: Color(0xFF2196F3),
                  size: 60.0,
                ),
              )
            else
              Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4A1B2A),
                    width: 2.0,
                  ),
                ),
                child: ClipOval(
                  child: imageToShow.startsWith('http')
                      ? Image.network(
                          imageToShow,
                          fit: BoxFit.cover,
                          cacheHeight: 120,
                          cacheWidth: 120,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFB8D4E8),
                              child: const Icon(
                                Icons.add_reaction,
                                color: Color(0xFF2196F3),
                                size: 60.0,
                              ),
                            );
                          },
                        )
                      : Image.file(
                          File(imageToShow),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFB8D4E8),
                              child: const Icon(
                                Icons.add_reaction,
                                color: Color(0xFF2196F3),
                                size: 60.0,
                              ),
                            );
                          },
                        ),
                ),
              ),
          ],
        ),
        if (state.isEditMode)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: 200.0,
              height: 48.0,
              child: ElevatedButton(
                onPressed: state.status == Status.loading ? null : _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A1B2A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                child: Text(
                  state.selectedImageUri != null ? 'Change Image' : 'Select Image',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
