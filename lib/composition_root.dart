import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tools_manager/domain/use_cases/auth_use_cases/check_persisted_auth_state_use_case.dart';

import 'data/datasources/datasources.dart';
import 'data/models/user_model.dart';
import 'data/repositories/tool_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/services/firebase_auth/firebase_auth_service.dart';
import 'domain/repositories/i_tool_repository.dart';
import 'domain/repositories/i_user_repository.dart';
import 'domain/services/i_auth_service.dart';
import 'domain/use_cases/auth_use_cases/sign_in_with_credential_use_case.dart';
import 'domain/use_cases/auth_use_cases/sign_out_use_case.dart';
import 'domain/use_cases/auth_use_cases/verify_mobile_number_use_case.dart';
import 'domain/use_cases/common_use_cases/common_use_cases.dart';
import 'domain/use_cases/tool_use_cases/tool_use_cases.dart';
import 'domain/use_cases/user_use_cases/user_use_cases.dart';
import 'firebase_options.dart';
import 'presentation/states_management/auth_cubit/auth_cubit.dart';
import 'presentation/states_management/home_cubit/home_cubit.dart';
import 'presentation/states_management/search_tools_cubit/search_tools_cubit.dart';
import 'presentation/states_management/tool_details_cubit/tool_details_cubit.dart';
import 'presentation/states_management/tool_room_cubit/tool_room_cubit.dart';
import 'presentation/states_management/toolbox_cubit/toolbox_cubit.dart';
import 'presentation/states_management/transfer_tool_cubit/transfer_tool_cubit.dart';
import 'presentation/states_management/user_details_cubit/user_details_cubit.dart';
import 'presentation/states_management/users_cubit/users_cubit.dart';
import 'presentation/ui/pages/auth_page.dart';
import 'presentation/ui/pages/pages.dart';

class CompositionRoot {
  static late FirebaseFirestore _firebaseFirestore;
  static late FirebaseAuth _firebaseAuth;
  static late IUserDataSource _userDataSource;
  static late IToolDataSource _toolDataSource;
  static late IUserRepository _userRepository;
  static late IToolRepository _toolRepository;
  static late IAuthService _authService;

  //================================================================================================
  static configure() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    _firebaseAuth = FirebaseAuth.instance;
    _firebaseFirestore = FirebaseFirestore.instance;
    _authService = FirebaseAuthService(_firebaseAuth);
    _userDataSource = FirestoreUserDataSource(_firebaseFirestore.collection('users'));
    _toolDataSource = FirestoreToolDataSource(_firebaseFirestore.collection('tools'));
    _userRepository = UserRepository(_userDataSource);
    _toolRepository = ToolRepository(_toolDataSource);
  }

  //================================================================================================
  static Widget composeAuthPage() {
    CheckPersistedAuthStateUseCase _checkPersistedAuthStateUseCase =
        CheckPersistedAuthStateUseCase(_authService, _userRepository);
    VerifyMobileNumberUseCase _verifyMobileNumberUseCase =
        VerifyMobileNumberUseCase(_authService, _userRepository);
    SignInWithCredentialUseCase _signInWithCredentialUseCase =
        SignInWithCredentialUseCase(_authService);
    GetUserByMobileNumberUseCase _getUserByMobileNumberUseCase =
        GetUserByMobileNumberUseCase(_userRepository);

    AuthCubit _authCubit = AuthCubit(
      _checkPersistedAuthStateUseCase,
      _verifyMobileNumberUseCase,
      _signInWithCredentialUseCase,
      _getUserByMobileNumberUseCase,
    );

    return BlocProvider(
      create: (BuildContext context) => _authCubit,
      child: const AuthPage(),
    );
  }

  //================================================================================================
  static Widget composeHomePage() {
    SignOutUseCase _signOutUseCase = SignOutUseCase(_authService);
    CountToolsInStockByUserUseCase _countToolsInStockByUserUseCase =
        CountToolsInStockByUserUseCase(_toolRepository);
    CountTransferredToolsByUserUseCase _countTransferredToolsByUserUseCase =
        CountTransferredToolsByUserUseCase(_toolRepository);
    CountReceivedToolsByUserUseCase _countReceivedToolsByUserUseCase =
        CountReceivedToolsByUserUseCase(_toolRepository);
    CountToolsInToolRoomUseCase _countToolsInToolRoomUseCase =
        CountToolsInToolRoomUseCase(_toolRepository, _userRepository);
    CountToolsAtUsersUseCase _countToolsAtUsersUseCase =
        CountToolsAtUsersUseCase(_toolRepository, _userRepository);
    CountAllPendingToolsUseCase _countPendingToolsUseCase =
        CountAllPendingToolsUseCase(_toolRepository);

    CountUsersByRoleUseCase _countUsersByRoleUseCase = CountUsersByRoleUseCase(_userRepository);

    HomeCubit _homeCubit = HomeCubit(
      _signOutUseCase,
      _countToolsInStockByUserUseCase,
      _countTransferredToolsByUserUseCase,
      _countReceivedToolsByUserUseCase,
      _countToolsInToolRoomUseCase,
      _countToolsAtUsersUseCase,
      _countPendingToolsUseCase,
      _countUsersByRoleUseCase,
    );

    return BlocProvider(
      create: (BuildContext context) => _homeCubit,
      child: const HomePage(),
    );
  }

  //================================================================================================
  static Widget composeToolboxPage() {
    GetToolsByUserUseCase _getToolsByUserUseCase = GetToolsByUserUseCase(_toolRepository);
    AddToolUseCase _addToolUseCase = AddToolUseCase(_toolRepository);
    UpdateToolUseCase _updateToolUseCase = UpdateToolUseCase(_toolRepository);
    DeleteToolUseCase _deleteToolUseCase = DeleteToolUseCase(_toolRepository);

    ToolboxCubit _toolboxCubit = ToolboxCubit(
      _getToolsByUserUseCase,
      _addToolUseCase,
      _updateToolUseCase,
      _deleteToolUseCase,
    );

    return BlocProvider(
      create: (BuildContext context) => _toolboxCubit,
      child: const ToolboxPage(),
    );
  }

  //==============================================================================================
  static Widget composeToolDetailsPage(String id) {
    GetToolByIdUseCase _getToolByIdUseCase = GetToolByIdUseCase(_toolRepository);
    UpdateToolUseCase _updateToolUseCase = UpdateToolUseCase(_toolRepository);

    ToolDetailsCubit _toolDetailsCubit = ToolDetailsCubit(
      _getToolByIdUseCase,
      _updateToolUseCase,
    );
    GetAllUsersUseCase _getAllUsersUseCase = GetAllUsersUseCase(_userRepository);
    TransferToolCubit _transferToolCubit = TransferToolCubit(_getAllUsersUseCase);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => _toolDetailsCubit),
        BlocProvider(create: (BuildContext context) => _transferToolCubit),
      ],
      child: ToolDetailsPage(toolId: id),
    );
  }

  //================================================================================================
  static Widget composeToolRoomPage() {
    final GetToolsInToolRoomUseCase _getToolsInToolRoomUseCase =
        GetToolsInToolRoomUseCase(_toolRepository, _userRepository);
    final GetToolsAtUsersUseCase _getToolsAtUsersUseCase =
        GetToolsAtUsersUseCase(_toolRepository, _userRepository);
    final GetAllPendingToolsUseCase _getAllPendingToolsUseCase =
        GetAllPendingToolsUseCase(_toolRepository);

    ToolRoomCubit _toolRoomCubit = ToolRoomCubit(
      _getToolsInToolRoomUseCase,
      _getToolsAtUsersUseCase,
      _getAllPendingToolsUseCase,
    );

    return BlocProvider(
      create: (BuildContext context) => _toolRoomCubit,
      child: const ToolRoomPage(),
    );
  }

  //================================================================================================
  static Widget composeUsersPage() {
    GetAllUsersUseCase _getAllUsersUserCase = GetAllUsersUseCase(_userRepository);
    CountToolsInStockByUserUseCase _countToolsInStockByUserUseCase =
        CountToolsInStockByUserUseCase(_toolRepository);
    CountTransferredToolsByUserUseCase _countTransferredToolsByUserUseCase =
        CountTransferredToolsByUserUseCase(_toolRepository);
    CountReceivedToolsByUserUseCase _countReceivedToolsByUserUseCase =
        CountReceivedToolsByUserUseCase(_toolRepository);
    AddUserUseCase _addUserUseCase = AddUserUseCase(_userRepository);
    UpdateUserUseCase _updateUserUseCase = UpdateUserUseCase(_userRepository);
    DeleteUserUseCase _deleteUserUseCase = DeleteUserUseCase(_userRepository);
    UpdateToolsByUserIdUseCase _updateToolsByUserIdUseCase =
        UpdateToolsByUserIdUseCase(_toolRepository, _userRepository);
    MoveDeletedUserToolsUseCase _moveDeletedUserToolsUseCase =
        MoveDeletedUserToolsUseCase(_toolRepository, _userRepository);

    UsersCubit _usersCubit = UsersCubit(
      _getAllUsersUserCase,
      _countToolsInStockByUserUseCase,
      _countTransferredToolsByUserUseCase,
      _countReceivedToolsByUserUseCase,
      _addUserUseCase,
      _updateUserUseCase,
      _deleteUserUseCase,
      _updateToolsByUserIdUseCase,
      _moveDeletedUserToolsUseCase,
    );

    return BlocProvider(
      create: (BuildContext context) => _usersCubit,
      child: const UsersPage(),
    );
  }

  //================================================================================================
  static Widget composeUserDetailsPage(UserModel userModel, int numberOfToolsInStock,
      int numberOfTransferredTools, int numberOfReceivedTools) {
    GetToolsByUserUseCase _getToolsByHolderUseCase = GetToolsByUserUseCase(_toolRepository);
    UserDetailsCubit _userDetailsCubit = UserDetailsCubit(_getToolsByHolderUseCase);

    return BlocProvider(
      create: (BuildContext context) => _userDetailsCubit,
      child: UserDetailsPage(
        userModel: userModel,
        numberOfToolsInStock: numberOfToolsInStock,
        numberOfTransferredTools: numberOfTransferredTools,
        numberOfReceivedTools: numberOfReceivedTools,
      ),
    );
  }

  //================================================================================================
  static Widget composeSearchPage() {
    SearchToolsUseCase _searchToolsUseCase = SearchToolsUseCase(_toolRepository);
    SearchToolsCubit _searchToolsCubit = SearchToolsCubit(_searchToolsUseCase);

    return BlocProvider(
      create: (BuildContext context) => _searchToolsCubit,
      child: const SearchToolsPage(),
    );
  }

  //================================================================================================
  //================================================================================================
  static populateFakeFirestore() async {
    var users = _firebaseFirestore.collection('users');
    var tools = _firebaseFirestore.collection('tools');
    await users.add({
      'name': 'Grzesiek',
      'mobileNumber': '+48691795588',
      'role': 'admin',
    });
    await users.add({
      'name': 'Darek',
      'mobileNumber': '111111111',
      'role': 'master',
    });
    await users.add({
      'name': 'Wojtek',
      'mobileNumber': '222222222',
      'role': 'admin',
    });
    await users.add({
      'name': 'Kotlet',
      'mobileNumber': '333333333',
      'role': 'user',
    });
    await users.add({
      'name': 'Konrad',
      'mobileNumber': '777777777',
      'role': 'user',
    });
    //====================================================
    //====================================================
    await tools.add({
      'name': 'wiertarka udarowa bezprzewodowa Milwaukee całkiem nowa sztuka',
      'date': '2022',
      'giver': null,
      'holder': 'Darek',
      'receiver': null,
    });
    await tools.add({
      'name': 'chochla Florina Professional nierdzewna',
      'date': '2022',
      'giver': null,
      'holder': 'Darek',
      'receiver': null,
    });
    await tools.add({
      'name': 'mikrofalówka',
      'date': '2022',
      'giver': null,
      'holder': 'Darek',
      'receiver': null,
    });
    await tools.add({
      'name': 'drabina 7-szczeblowa aluminiowa Drabest całkiem nowa sztuka',
      'date': '2022',
      'giver': null,
      'holder': 'Darek',
      'receiver': null,
    });
    await tools.add({
      'name': 'nożyk',
      'date': '2022',
      'giver': null,
      'holder': 'Darek',
      'receiver': null,
    });
    await tools.add({
      'name': 'wkrętarka Parkside',
      'date': '2022',
      'giver': null,
      'holder': 'Darek',
      'receiver': null,
    });
    await tools.add({
      'name': 'odkurzacz Karcher',
      'date': '2022',
      'giver': null,
      'holder': 'Darek',
      'receiver': null,
    });
    await tools.add({
      'name': 'patelnia naleśnikowa everest 25cm używana',
      'date': '2022',
      'giver': null,
      'holder': 'Darek',
      'receiver': null,
    });
    await tools.add({
      'name': 'wiertarka Hilti',
      'date': '2022',
      'giver': null,
      'holder': 'Darek',
      'receiver': null,
    });
    await tools.add({
      'name': 'drabina 8-szczeblowa aluminiowa Drabest całkiem nowa sztuka',
      'date': '2022',
      'giver': null,
      'holder': 'Darek',
      'receiver': null,
    });
    await tools.add({
      'name': 'wiertarka Milwaukee',
      'date': '2022',
      'giver': null,
      'holder': 'Wojtek',
      'receiver': null,
    });
    await tools.add({
      'name': 'zestaw wkrętaków Neo',
      'date': '2022',
      'giver': null,
      'holder': 'Wojtek',
      'receiver': null,
    });
    await tools.add({
      'name': 'miernik elektryczny Fluke',
      'date': '2022',
      'giver': null,
      'holder': 'Wojtek',
      'receiver': null,
    });
    await tools.add({
      'name': 'motyka Fiskars',
      'date': '2022',
      'giver': null,
      'holder': 'Wojtek',
      'receiver': null,
    });
  }
}
