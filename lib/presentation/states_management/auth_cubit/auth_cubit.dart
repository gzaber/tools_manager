import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';
import '../../../domain/use_cases/auth_use_cases/check_persisted_auth_state_use_case.dart';
import '../../../domain/use_cases/auth_use_cases/sign_in_with_credential_use_case.dart';
import '../../../domain/use_cases/auth_use_cases/verify_mobile_number_use_case.dart';
import '../../../domain/use_cases/user_use_cases/get_user_by_mobile_number_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final CheckPersistedAuthStateUseCase _checkPersistedAuthStateUseCase;
  final VerifyMobileNumberUseCase _verifyMobileNumberUseCase;
  final SignInWithCredentialUseCase _signInWithCredentialUseCase;
  final GetUserByMobileNumberUseCase _getUserByMobileNumberUseCase;

  AuthCubit(
    this._checkPersistedAuthStateUseCase,
    this._verifyMobileNumberUseCase,
    this._signInWithCredentialUseCase,
    this._getUserByMobileNumberUseCase,
  ) : super(AuthInitial());

  //================================================================================================
  checkPersistedAuthState() async {
    emit(AuthLoading());
    var result = await _checkPersistedAuthStateUseCase();
    if (result.asError != null) {
      emit(AuthPersistenceFailure(result.asError!.error.toString()));
    } else {
      emit(AuthSignInSuccess(result.asValue!.value));
    }
  }

  //================================================================================================
  verifyMobileNumber(String mobileNumber) async {
    emit(AuthLoading());
    var result = await _verifyMobileNumberUseCase(mobileNumber);
    if (result.asError != null) {
      emit(AuthFailure(result.asError!.error.toString()));
    } else {
      emit(AuthVerificationSucces(result.asValue!.value));
    }
  }

  //================================================================================================
  signInWithCredential(String verificationId, String smsCode, String mobileNumber) async {
    emit(AuthLoading());
    var signInResult = await _signInWithCredentialUseCase(verificationId, smsCode);
    if (signInResult.asError != null) {
      emit(AuthFailure(signInResult.asError!.error.toString()));
      return;
    }
    var getUserResult = await _getUserByMobileNumberUseCase(mobileNumber);
    if (getUserResult.asError != null) {
      emit(AuthFailure(getUserResult.asError!.error.toString()));
    }

    emit(AuthSignInSuccess(getUserResult.asValue!.value));
  }
  //================================================================================================
}
