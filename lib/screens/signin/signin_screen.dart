import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learnd/repositories/repositories.dart';
import 'package:learnd/screens/screens.dart';
import 'package:learnd/screens/signin/cubit/signin_cubit.dart';
import 'package:learnd/widgets/widgets.dart';

class SigninScreen extends StatelessWidget {
  static const String routeName = '/signin';
  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, _, __) => BlocProvider<SigninCubit>(
              create: (_) =>
                  SigninCubit(authRepository: context.read<AuthRepository>()),
              child: SigninScreen(),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SigninCubit, SigninState>(
          listener: (context, state) {
            if (state.status == SigninStatus.error) {
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 80, bottom: 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Glad to see you\nhere again",
                              style: TextStyle(
                                  fontSize: 33,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5),
                            ),
                            SizedBox(
                              height: 28,
                            ),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'email'),
                              onChanged: (value) => context
                                  .read<SigninCubit>()
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
                                  .read<SigninCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value.length < 6
                                  ? "Password must be at least 6 characters"
                                  : null,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            MainButton(
                              text: "Sign in",
                              onTap: () {
                                return _submitForm(context,
                                  state.status == SigninStatus.submitting);
                              }
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(SignupScreen.routeName);
                              },
                              child: Text("I dont have an account",
                                  style: const TextStyle(
                                    color: Colors.white,
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
      context.read<SigninCubit>().signInWithCredentials();
    }
  }
}
