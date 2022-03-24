import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';

class CurrentUserCubit extends Cubit<UserModel> {
  CurrentUserCubit() : super(UserModel(mobileNumber: '', name: '', role: ''));

  update(UserModel userModel) {
    emit(
      UserModel(
        mobileNumber: userModel.mobileNumber,
        name: userModel.name,
        role: userModel.role,
      ),
    );
  }
}
