import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnd/blocs/blocs.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/lists/lists.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:learnd/screens/upload_post/cubit/upload_post_cubit.dart';

class UploadMeetingScreen extends StatefulWidget {
  static const routeName = '/meetingScreen';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<UploadPostCubit>(
        create: (_) => UploadPostCubit(
          authBloc: context.read<AuthBloc>(),
          storageRepository: context.read<StorageRepository>(),
          postRepository: context.read<PostRepository>(),
        ),
        child: UploadMeetingScreen(),
      ),
    );
  }

  @override
  _UploadMeetingScreenState createState() => _UploadMeetingScreenState();
}

class _UploadMeetingScreenState extends State<UploadMeetingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String _chosenValue;
    return BlocConsumer<UploadPostCubit, UploadPostState>(
        listener: (context, state) {
      if (state.status == UploadPostStatus.loaded) {
        _formKey.currentState.reset();
        context.read<UploadPostCubit>().reset();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
          content: Text("Hoorey. Post created"),
        ));
      }
    }, builder: (context, state) {
      return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: const EdgeInsets.only(
                  left: 26,
                  right: 26,
                  top: 80,
                  bottom: 20,
                ),
                child: SingleChildScrollView(
                          child: Column(
                    children: [
                      
                    Column(
                          children: [
                            if (state.status == UploadPostStatus.loading)
                              const LinearProgressIndicator(),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Text(
                                      "Meeting",
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: ColorPallete.lightTextColor
                                          ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Center(
                                      child: Text(
                                    "fill in fields below in order to find friends)",
                                    style: const TextStyle(fontSize: 16,color: ColorPallete.lightButtonColor),
                                  )),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  TextFormField(
                                    maxLength: 70,
                                    decoration:
                                        InputDecoration(hintText: "Title",),
                                    onChanged: (value) => context
                                        .read<UploadPostCubit>()
                                        .titleChanged(value),
                                    validator: (value) => value.trim().isEmpty
                                        ? 'Please enter your title'
                                        : null,
                                  ),
                                  TextFormField(
                                    decoration:
                                        InputDecoration(hintText: "Description"),
                                    maxLength: 500,
                                    onChanged: (value) => context
                                        .read<UploadPostCubit>()
                                        .descriptionChanged(value),
                                    validator: (value) => value.trim().isEmpty
                                        ? 'Please enter your description'
                                        : null,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "Telegram id or link"),
                                    maxLength: 50,
                                    onChanged: (value) => context
                                        .read<UploadPostCubit>()
                                        .contactInfoChanged(value),
                                    validator: (value) => value.trim().isEmpty
                                        ? 'Enter your contact info'
                                        : null,
                                  ),
                                  DropdownButtonFormField<String>(
                                    validator: (value) => value == null
                                        ? 'Please fill the language field'
                                        : null,
                                    value: _chosenValue,

                                    //elevation: 5,
                                    iconEnabledColor: Colors.white,
                                    items: languages
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Choose language",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        _chosenValue = value;
                                      });
                                      context
                                          .read<UploadPostCubit>()
                                          .dropdownChanged(value);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xffE4E4E4)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(17),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      return _submitForm(
                                          context,
                                          state.status ==
                                              UploadPostStatus.loading);
                                    },
                                    child: const Text(
                                      "Publish",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              )));
    });
  }

  void _submitForm(BuildContext context, bool isLoading) {
    if (_formKey.currentState.validate() && !isLoading) {
      context.read<UploadPostCubit>().uploadMeeting();
    }
  }
}
