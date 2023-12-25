import 'package:block_strucuture/Bloc/auth_bloc.dart';
import 'package:block_strucuture/Repository/auth_repository.dart';
import 'package:block_strucuture/Screens/posts_view/posts_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Common/common_function.dart';
import '../../CustomWidgets/custom_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var authBloc = AuthBloc(authRepository: AuthRepository());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => CommonFunction().hideKeyboard(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: CustomWidget.commonText(commonText: "Login"),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Posts(),
                    ));
                  },
                  icon: const Icon(Icons.navigate_next))
            ],
          ),
          body: BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is AuthInitial) {
                CommonFunction().hideKeyboard(context);
              } else if (state is LoginSuccessState) {
                CommonFunction().showCustomSnackBar(context, "$state");
                print("LoginSuccessState_UI $state");
              } else if (state is LoginErrorState) {
                CommonFunction().showCustomSnackBar(context, "$state");
                print("LoginErrorState $state");
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
                bloc: authBloc,
                builder: (context, state) {
                  return Form(
                      key: formKey,
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: CustomWidget.commonTextFormField(
                                context: context,
                                textFieldController: emailController,
                                prefixIcon: const Icon(CupertinoIcons.person,
                                    color: Colors.blue),
                                hintText: "email"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomWidget.commonTextFormField(
                              context: context,
                              textFieldController: passwordController,
                              obscureText: authBloc.isSecure,
                              prefixIcon: const Icon(
                                CupertinoIcons.lock,
                                color: Colors.blue,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  // isSecure = !isSecure;
                                  authBloc.add(ToggleEyeVisibilityEvent());
                                  // authBloc.updateVisibility();
                                  print('isSecure:--> ${authBloc.isSecure}');
                                },
                                child: Icon(
                                    color: Colors.blue,
                                    authBloc.isSecure
                                        ? CupertinoIcons.eye_slash
                                        : CupertinoIcons.eye),
                              ),
                              textInputAction: TextInputAction.done,
                              hintText: "password"),
                          Switch(
                            value: authBloc.switchOn,
                            onChanged: (value) {
                              authBloc.add(ToggleSwitchEvent(switchOn: value));
                              // authBloc.updateSwitch(value);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 50, left: 20, right: 20),
                            child: CustomWidget.commonElevatedButton(
                                context: context,
                                buttonText: "Login",
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    String email = emailController.text.trim();
                                    String password =
                                        passwordController.text.trim();
                                    // authBloc.callLogin();
                                    authBloc.add(LoginEvent(
                                        email: email, password: password));
                                  }
                                }),
                          ),
                        ],
                      ));
                }),
          ),
        ));
  }
}
