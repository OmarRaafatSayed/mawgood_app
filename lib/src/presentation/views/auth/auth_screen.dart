import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_bloc/src/config/router/app_route_constants.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/auth_bloc/radio_bloc/radio_bloc.dart';
import 'package:flutter_amazon_clone_bloc/src/logic/blocs/user_cubit/user_cubit.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/custom_elevated_button.dart';
import 'package:flutter_amazon_clone_bloc/src/presentation/widgets/common_widgets/custom_textfield.dart';
import 'package:flutter_amazon_clone_bloc/src/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_amazon_clone_bloc/l10n/generated/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    context.read<RadioBloc>().add(const RadioChangedEvent(auth: Auth.signUp));

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/mawgood/logo.jpg',
                  height: 60,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.welcome,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                BlocBuilder<RadioBloc, RadioState>(
                  builder: (context, state) {
                    if (state is RadioSignUpState) {
                      return Column(
                        children: [
                          _buildAuthContainer(
                            context,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Radio<Auth>(
                                    value: Auth.signUp,
                                    groupValue: state.auth,
                                    onChanged: (Auth? val) {
                                      context.read<RadioBloc>().add(
                                          RadioChangedEvent(auth: val!));
                                    },
                                  ),
                                  title: Text(
                                    l10n.createAccount,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(l10n.newToApp),
                                  onTap: () {
                                    context.read<RadioBloc>().add(
                                        const RadioChangedEvent(auth: Auth.signUp));
                                  },
                                ),
                                Form(
                                  key: _signUpFormKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        CustomTextfield(
                                          controller: _nameController,
                                          hintText: l10n.name,
                                        ),
                                        const SizedBox(height: 8),
                                        CustomTextfield(
                                          controller: _emailController,
                                          hintText: l10n.email,
                                        ),
                                        const SizedBox(height: 8),
                                        CustomTextfield(
                                          controller: _passwordController,
                                          hintText: l10n.setPassword,
                                        ),
                                        const SizedBox(height: 16),
                                        BlocBuilder<AuthBloc, AuthState>(
                                          builder: (context, state) {
                                            if (state is TextFieldErrorState) {
                                              return _buildErrorRow(state.errorString);
                                            }
                                            return const SizedBox();
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        _buildSubmitButton(
                                          context,
                                          text: l10n.createAccount,
                                          onPressed: () {
                                            if (_signUpFormKey.currentState!.validate()) {
                                              context.read<AuthBloc>().add(
                                                CreateAccountPressedEvent(
                                                  _nameController.text,
                                                  _emailController.text,
                                                  _passwordController.text,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInactiveContainer(
                            context,
                            child: ListTile(
                              leading: Radio<Auth>(
                                value: Auth.signIn,
                                groupValue: state.auth,
                                onChanged: (Auth? val) {
                                  context.read<RadioBloc>().add(
                                      RadioChangedEvent(auth: val!));
                                },
                              ),
                              title: Text(l10n.signIn),
                              subtitle: Text(l10n.alreadyACustomer),
                              onTap: () {
                                context.read<RadioBloc>().add(
                                    const RadioChangedEvent(auth: Auth.signIn));
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is RadioSignInState) {
                      return Column(
                        children: [
                          _buildInactiveContainer(
                            context,
                            child: ListTile(
                              leading: Radio<Auth>(
                                value: Auth.signUp,
                                groupValue: state.auth,
                                onChanged: (Auth? val) {
                                  context.read<RadioBloc>().add(
                                      RadioChangedEvent(auth: val!));
                                },
                              ),
                              title: Text(l10n.createAccount),
                              subtitle: Text(l10n.newToApp),
                              onTap: () {
                                context.read<RadioBloc>().add(
                                    const RadioChangedEvent(auth: Auth.signUp));
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildAuthContainer(
                            context,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Radio<Auth>(
                                    value: Auth.signIn,
                                    groupValue: state.auth,
                                    onChanged: (Auth? val) {
                                      context.read<RadioBloc>().add(
                                          RadioChangedEvent(auth: val!));
                                    },
                                  ),
                                  title: Text(
                                    l10n.signIn,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(l10n.alreadyACustomer),
                                  onTap: () {
                                    context.read<RadioBloc>().add(
                                        const RadioChangedEvent(auth: Auth.signIn));
                                  },
                                ),
                                Form(
                                  key: _signInFormKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        CustomTextfield(
                                          controller: _emailController,
                                          hintText: l10n.email,
                                        ),
                                        const SizedBox(height: 8),
                                        CustomTextfield(
                                          controller: _passwordController,
                                          hintText: l10n.password,
                                        ),
                                        const SizedBox(height: 16),
                                        _buildSubmitButton(
                                          context,
                                          text: l10n.continueText,
                                          onPressed: () {
                                            if (_signInFormKey.currentState!.validate()) {
                                              context.read<AuthBloc>().add(
                                                SignInPressedEvent(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                            ),
                                            onPressed: () => context.goNamed(
                                                AppRouteConstants.bottomBarRoute.name),
                                            child: Text(l10n.continueAsGuest),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),

                const SizedBox(height: 32),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterLink(context, l10n.conditionsOfUse),
                    _buildFooterLink(context, l10n.privacyNotice),
                    _buildFooterLink(context, l10n.help),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    l10n.copyright,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthContainer(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInactiveContainer(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }

  Widget _buildErrorRow(String error) {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 16, color: Colors.red),
        const SizedBox(width: 8),
        Expanded(child: Text(error, style: const TextStyle(color: Colors.red, fontSize: 13))),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, {required String text, required VoidCallback onPressed}) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) showSnackBar(context, state.errorString);
        if (state is CreateUserSuccessState) showSnackBar(context, state.userCreatedString);
        if (state is SignInSuccessState) {
          context.read<UserCubit>().getUserData();
          if (state.user.type == 'user') {
            context.goNamed(AppRouteConstants.bottomBarRoute.name);
          } else {
            context.goNamed(AppRouteConstants.adminBottomBarRoute.name);
          }
        }
      },
      builder: (context, state) {
        if (state is AuthLoadingState) return const Center(child: CircularProgressIndicator());
        return CustomElevatedButton(buttonText: text, onPressed: onPressed);
      },
    );
  }

  Widget _buildFooterLink(BuildContext context, String text) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () {},
      child: Text(text, style: TextStyle(color: theme.colorScheme.primary, fontSize: 13)),
    );
  }
}
