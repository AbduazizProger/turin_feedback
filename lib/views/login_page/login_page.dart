import 'package:flutter/material.dart';
import 'package:feedback/const/colors.dart';
import 'package:feedback/const/images.dart';
import 'package:feedback/const/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feedback/const/text_styles.dart';
import 'package:feedback/models/routes_model.dart';
import 'package:feedback/view_model/bloc/auth_bloc.dart';
import 'package:feedback/view_model/repo/auth_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/views/widgets/dialog_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscure = true;
  final login = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignInState) {
          context.read<RoutesModel>().setRoute(Routes.main, context);
        } else if (state is AuthErrorState) {
          showDialog(
            context: context,
            builder: (context) {
              return DialogWidget(
                title: tr('error'),
                content: Text(
                  state.message,
                  style: TextStyles.blackW400S16,
                ),
              );
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            Expanded(
              child: Center(
                child: Image.asset(Images.logo, height: 450),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(72),
                decoration: BoxDecoration(
                  color: AppColors.main,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tr('welcome'), style: TextStyles.whiteW700S28),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tr('login'), style: TextStyles.whiteW500S16),
                              TextField(
                                controller: login,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: tr('enter-login'),
                                  hintStyle: TextStyles.greyW400S14,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  constraints:
                                      const BoxConstraints(minHeight: 56),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                tr('password'),
                                style: TextStyles.whiteW500S16,
                              ),
                              TextField(
                                controller: password,
                                obscureText: obscure,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: tr('enter-password'),
                                  hintStyle: TextStyles.greyW400S14,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  constraints:
                                      const BoxConstraints(minHeight: 56),
                                ),
                              ),
                              const SizedBox(height: 30),
                              InkWell(
                                onTap: () {
                                  if (login.text.isNotEmpty &&
                                      password.text.isNotEmpty) {
                                    context.read<AuthBloc>().add(SignInEvent(
                                          username: login.text,
                                          password: password.text,
                                          authRepo: context.read<AuthRepo>(),
                                        ));
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    tr('enter'),
                                    style: TextStyles.mainW500S16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 66),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DialogWidget(
                              title: tr('how-to-enter'),
                              content: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 635,
                                  maxHeight: 250,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const SingleChildScrollView(
                                  child: Column(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        tr('how-to-enter'),
                        style: TextStyles.whiteW400S14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
