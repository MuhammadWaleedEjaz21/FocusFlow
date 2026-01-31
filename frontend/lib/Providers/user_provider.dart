import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontend/Models/user_model.dart';
import 'package:frontend/Providers/task_provider.dart';
import 'package:frontend/Services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final prefProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

final tokenProvider = FutureProvider<String>((ref) async {
  final prefs = await ref.watch(prefProvider.future);
  return prefs.getString('authToken') ?? '';
});

final isLoggedInProvider = StateProvider<bool>((ref) => false);

final userServiceProvider = Provider((ref) => UserService());

final fetchuserProvider = FutureProvider.family<UserModel, String>((
  ref,
  userEmail,
) async {
  final token = await ref.read(tokenProvider.future);
  final userService = ref.watch(userServiceProvider);
  return userService.fetchUserData(userEmail, token);
});

final userProvider = FutureProvider<UserController>((ref) async {
  final token = await ref.watch(tokenProvider.future);
  return UserController(ref, token);
});

class UserController {
  final Ref ref;
  final String token;

  UserController(this.ref, this.token);

  Future<void> updateUser(UserModel user) async {
    final userService = ref.watch(userServiceProvider);
    await userService.updateUserData(user, token);
    ref.invalidate(fetchuserProvider.call(user.email));
  }

  Future<void> deleteUser(String email) async {
    final userService = ref.watch(userServiceProvider);
    await userService.deleteUser(email, token);
    ref.invalidate(fetchuserProvider.call(email));
  }

  Future<void> registerUser(UserModel user) async {
    final userService = ref.watch(userServiceProvider);
    await userService.registerUser(user);
  }

  Future<String> loginUser(String email, String password) async {
    final userService = ref.watch(userServiceProvider);
    final token = await userService.loginUser(email, password);

    final prefs = await ref.watch(prefProvider.future);
    await prefs.setString('authToken', token);
    await prefs.setString('userEmail', email);
    await prefs.setBool('isLoggedIn', true);

    ref.read(isLoggedInProvider.notifier).state = true;
    ref.invalidate(prefProvider);
    ref.invalidate(tokenProvider);
    ref.invalidate(fetchuserProvider.call(email));
    ref.invalidate(tasksListProvider);

    return token;
  }

  Future<void> logoutUser() async {
    final prefs = await ref.watch(prefProvider.future);
    await prefs.clear();
    ref.read(isLoggedInProvider.notifier).state = false;
    ref.invalidate(prefProvider);
    ref.invalidate(fetchuserProvider);
    ref.invalidate(tasksListProvider);
    ref.invalidate(tokenProvider);
  }

  Future<void> sendOTP(String email) async {
    final userService = ref.watch(userServiceProvider);
    await userService.sendOTP(email);
  }

  Future<void> verifyOTP(String email, String otp) async {
    final userService = ref.watch(userServiceProvider);
    await userService.verifyOTP(email, otp);
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final userService = ref.watch(userServiceProvider);
    await userService.resetPassword(email, newPassword);
  }
}
