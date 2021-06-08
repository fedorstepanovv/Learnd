import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:learnd/screens/screens.dart';
import 'package:learnd/widgets/widgets.dart';

import 'cubit/signup_cubit.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => BlocProvider<SignupCubit>(
              create: (_) =>
                  SignupCubit(authRepository: context.read<AuthRepository>()),
              child: SignupScreen(),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                        content: state.failure.message,
                      ));
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 80, bottom: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Welcome to\nLearnd",
                              style: TextStyle(
                                  fontSize: 33,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5),
                            ),
                            SizedBox(
                              height: 28,
                            ),
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                  RegExp((r"^[A-Za-z0-9_-]*$")),
                                  allow: true,
                                )
                              ],
                              maxLength: 15,
                              decoration: InputDecoration(
                                hintText: 'username',
                              ),
                              buildCounter: (BuildContext context,
                                      {int currentLength,
                                      int maxLength,
                                      bool isFocused}) =>
                                  null,
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .userNameChanged(value),
                              validator: (value) => value.trim().isEmpty
                                  ? "Please enter a valid username"
                                  : null,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'email'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .emailChanged(value),
                              validator: (value) => !value.contains('@')
                                  ? "Please enter a valid email"
                                  : null,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(hintText: 'password'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value.length < 6
                                  ? "Password must be at least 6 characters"
                                  : null,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            MainButton(
                              onTap: () => _submitForm(context,
                                  state.status == SignupStatus.submitting),
                              text: "Sign up",
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(SigninScreen.routeName);
                              },
                              child: Text("I dont have an account",
                                  style: const TextStyle(
                                    color: Color(0xffE4E4E4),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SvgPicture.asset('assets/svg/lines.svg')
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<SignupCubit>().signupWithCredentials();
    }
  }
}
