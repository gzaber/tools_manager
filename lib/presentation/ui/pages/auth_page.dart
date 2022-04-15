import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tools_manager/presentation/helpers/helpers.dart';
import 'package:tools_manager/presentation/states_management/auth_cubit/auth_cubit.dart';
import 'package:tools_manager/presentation/ui/widgets/custom_elevated_button.dart';
import 'package:tools_manager/presentation/ui/widgets/custom_text_field.dart';

import '../../../composition_root.dart';
import '../../../domain/use_cases/failure_codes.dart';
import '../../states_management/current_user_cubit/current_user_cubit.dart';
import '../widgets/dialogs/dialogs.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late AuthCubit _authCubit;
  late String _verificationId;
  late String _mobileNumber;
  late String _smsCode;
  late PageController _pageController;

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _verificationId = '';
    _mobileNumber = '';
    _smsCode = '';
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _authCubit.checkPersistedAuthState();
    bool isLoading = false;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  kAppTitle,
                  style: Theme.of(context).textTheme.headline3!.copyWith(color: kOrange),
                ),
              ),
              const SizedBox(height: 30.0),
              BlocConsumer<AuthCubit, AuthState>(
                builder: (_, state) {
                  return _buildUI(context);
                },
                listener: (_, state) {
                  if (state is AuthLoading) {
                    _showLoader(context);
                    isLoading = true;
                  }
                  if (state is AuthVerificationSucces) {
                    _verificationId = state.verificationId;
                    _hideLoader(context);
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 500), curve: Curves.linear);
                  }
                  if (state is AuthSignInSuccess) {
                    _hideLoader(context);
                    BlocProvider.of<CurrentUserCubit>(context).update(state.user);
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) => CompositionRoot.composeHomePage(),
                          ),
                        )
                        .then((value) => _authCubit.checkPersistedAuthState());
                  }
                  if (state is AuthFailure) {
                    String failureMessage = state.message;
                    if (state.message == failureMobileNumberEmpty) {
                      failureMessage = AppLocalizations.of(context)!.failureMobileNumberEmpty;
                    }
                    if (state.message == failureMobileNumberNotAllowed) {
                      failureMessage = AppLocalizations.of(context)!.failureMobileNumberNotAllowed;
                    }
                    _hideLoader(context);
                    _showErrorDialog(
                        context, AppLocalizations.of(context)!.titleError, failureMessage);
                  }
                  if (state is AuthPersistenceFailure) {
                    String failureMessage = state.message;
                    if (state.message == failureNoUsersFound) {
                      failureMessage = AppLocalizations.of(context)!.failureNoUsersFound;
                    }
                    if (isLoading) _hideLoader(context);
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text(failureMessage)));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) => SizedBox(
        height: 400.0,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _verifyMobileNumber(context),
            _signInWithCredential(context),
          ],
        ),
      );

  Widget _verifyMobileNumber(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Column(
        children: [
          CustomTextField(
            hintText: AppLocalizations.of(context)!.hintEnterMobileNumber,
            textInputType: TextInputType.phone,
            textEditingController:
                TextEditingController(text: AppLocalizations.of(context)!.countryCode),
            maxLength: kMobileNumberMaxLength,
            onChanged: (val) {
              _mobileNumber = val;
            },
          ),
          const SizedBox(height: 20.0),
          CustomElevatedButton(
            text: AppLocalizations.of(context)!.submit,
            onPressed: () {
              _authCubit.verifyMobileNumber(_mobileNumber.replaceAll(' ', ''));
            },
          ),
        ],
      ),
    );
  }

  Widget _signInWithCredential(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Column(
        children: [
          CustomTextField(
            hintText: AppLocalizations.of(context)!.hintEnterSmsCode,
            textInputType: TextInputType.number,
            textEditingController: TextEditingController(),
            maxLength: kSmsCodeMaxLength,
            onChanged: (val) {
              _smsCode = val;
            },
          ),
          const SizedBox(height: 20.0),
          CustomElevatedButton(
              text: AppLocalizations.of(context)!.submit,
              onPressed: () {
                _authCubit.signInWithCredential(
                  _verificationId,
                  _smsCode.replaceAll(' ', ''),
                  _mobileNumber.replaceAll(' ', ''),
                );
              }),
        ],
      ),
    );
  }

  _showLoader(BuildContext context) {
    var alert = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      content: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white70,
        ),
      ),
    );

    showDialog(context: context, barrierDismissible: true, builder: (_) => alert);
  }

  _hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  _showErrorDialog(BuildContext context, String title, String content) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => InfoDialog(title: title, content: content),
    );
  }
}
