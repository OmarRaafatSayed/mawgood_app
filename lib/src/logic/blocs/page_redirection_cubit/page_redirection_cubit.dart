import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_amazon_clone_bloc/src/data/repositories/auth_repository.dart';

part 'page_redirection_state.dart';

class PageRedirectionCubit extends Cubit<PageRedirectionState> {
  final AuthRepository authRepository;
  PageRedirectionCubit(this.authRepository) : super(PageRedirectionInitial());

  void redirectUser() {
    // ── TEMPORARY: backend disconnected ──────────────────────────────────────
    // Future.microtask defers the emit to after the current build frame so the
    // BlocConsumer listener fires correctly (avoids "setState during build").
    Future.microtask(
        () => emit(PageRedirectionInvalid(isValid: false, userType: 'invalid')));

    // ── ORIGINAL backend flow (restore when backend is back) ─────────────────
    // Delete the Future.microtask line above and un-comment the block below:
    //
    // bool isValid;
    // String userType;
    // try {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String? token = prefs.getString('x-auth-token');
    //   if (token == null) {
    //     prefs.setString('x-auth-token', '');
    //     token = '';
    //   }
    //   isValid = await authRepository.isTokenValid(token: token);
    //   if (isValid == true) {
    //     User user = await userRepository.getUserDataInitial(token);
    //     userType = user.type;
    //     emit(PageRedirectionSuccess(isValid: isValid, userType: userType));
    //   } else {
    //     emit(PageRedirectionInvalid(isValid: isValid, userType: 'invalid'));
    //   }
    // } catch (e) {
    //   emit(PageRedirectionError());
    // }
  }
}
