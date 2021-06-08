import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/helpers/image_helper.dart';
import 'package:learnd/models/models.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:learnd/screens/profile/bloc/profile_bloc.dart';
import 'package:learnd/widgets/widgets.dart';

import 'cubit/edit_profile_cubit.dart';

class EditProfileScreenArgs {
  final BuildContext context;
  const EditProfileScreenArgs({@required this.context});
}

class EditProfileScreen extends StatelessWidget {
  static const routeName = '/editProfile';

  static Route route({@required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditProfileCubit>(
        create: (_) => EditProfileCubit(
          userRepository: context.read<UserRepository>(),
          storageRepository: context.read<StorageRepository>(),
          profileBloc: args.context.read<ProfileBloc>(),
        ),
        child: EditProfileScreen(
          user: args.context.read<ProfileBloc>().state.user,
        ),
      ),
    );
  }

  EditProfileScreen({Key key, this.user}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User user;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state.status == EditProfileStatus.error) {
          showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                    content: state.failure.message,
                  ));
        } else if (state.status == EditProfileStatus.success) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0, 
            backgroundColor: ColorPallete.backgroundColor,
          ),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 26.0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.status == EditProfileStatus.loading)
                    Center(child: const CircularProgressIndicator()),
                  Text("What exactly do you want\nto edit?",style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        //selecxt profile image
                        _selectProfileImage(context);
                      },
                      child: UserProfileImage(
                        radius: 70,
                        profileImageUrl: user.profileImageUrl,
                        profileImage: state.profileImage,
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          initialValue: user.username,
                          decoration: InputDecoration(hintText: "Username"),
                          onChanged: (value) => context
                              .read<EditProfileCubit>()
                              .usernameChanged(value),
                          validator: (value) => value.trim().isEmpty
                              ? 'Please enter your username'
                              : null,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: user.bio,
                          decoration: InputDecoration(hintText: "Bio"),
                          onChanged: (value) => context
                              .read<EditProfileCubit>()
                              .bioChanged(value),
                          validator: (value) => value.trim().isEmpty
                              ? 'Please enter your bio'
                              : null,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MainButton(
                          onTap: () => _updateProfile(context,
                              state.status == EditProfileStatus.loading),
                          text: "Save",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateProfile(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<EditProfileCubit>().updateProfile();
    }
  }

  Future<void> _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
        context: context, cropStyle: CropStyle.circle, title: 'Profile image');
    if (pickedFile != null) {
      context.read<EditProfileCubit>().profileImageChanged(pickedFile);
    }
  }
}
