import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';

class CurrentUserCubit extends Cubit<User> {
  CurrentUserCubit() : super(User(mobileNumber: '', name: '', role: ''));

  update(User user) {
    emit(
      User(
        mobileNumber: user.mobileNumber,
        name: user.name,
        role: user.role,
      ),
    );
  }
}
