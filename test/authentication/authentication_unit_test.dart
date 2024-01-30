import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mindplex/features/authentication/api_service/auth_service.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/authentication/models/auth_model.dart';
import 'package:mindplex/features/local_data_storage/local_storage.dart';
import 'package:mindplex/utils/network/connection-info.dart';
import 'package:mocktail/mocktail.dart';



class MockAuthService extends Mock implements AuthService {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockConnectionInfoImpl extends Mock implements ConnectionInfoImpl {}

class MockGet extends Mock implements GetInterface {}
class MockContext extends Mock implements BuildContext {}


void main() {
  group('AuthController', () {
    late AuthController authController;
    late MockAuthService mockAuthService;
    late MockLocalStorage mockLocalStorage;
    late MockConnectionInfoImpl mockInternetConnectionChecker;

    setUp(() {
      Get.reset();
      WidgetsFlutterBinding.ensureInitialized();
      Get.testMode = true;
      mockInternetConnectionChecker = MockConnectionInfoImpl();
      Get.put<ConnectionInfoImpl>(mockInternetConnectionChecker);
      mockAuthService = MockAuthService();
      mockLocalStorage = MockLocalStorage();
      authController = AuthController();
            
      // Inject mocks
      authController.authService.value = mockAuthService;
      authController.localStorage.value = mockLocalStorage;      
    });

    test('checkAuthentication - no token, should set isAuthenticated to false', 
    () async {
       when(() => authController.localStorage.value.readFromStorage('Token')).thenAnswer((_) async => "");
      expect(authController.isAuthenticated.value, false);
      expect(authController.checkingTokenValidity.value, false);
    });

    test('checkAuthentication - has token, not connected, should set isAuthenticated to true', () async {
      when(() => authController.localStorage.value.readFromStorage('Token')).thenAnswer((_) async => "token");
      when(() => mockInternetConnectionChecker.isConnected).thenAnswer((_) async => false);

      await authController.checkAuthentication();

      expect(authController.isAuthenticated.value, true);
      expect(authController.checkingTokenValidity.value, false);
    });

    test('checkAuthentication - has token, connected, refreshTokenIfNeeded returns true, should set isAuthenticated to true', () async {
      when(() => authController.localStorage.value.readFromStorage('Token')).thenAnswer((_) async => "token");
      when(() => mockInternetConnectionChecker.isConnected).thenAnswer((_) async => true);
      when(() => authController.authService.value.refreshToken("token")).thenAnswer((_) async => "newToken");
      when(() => authController.localStorage.value.writeToStorage('Token', "newToken")).thenAnswer((_) async => null);
      
      await authController.checkAuthentication();

      expect(authController.isAuthenticated.value, true);
      expect(authController.checkingTokenValidity.value, false);
    });

    test('checkAuthentication - has token, connected, refreshTokenIfNeeded throws exception, should set isAuthenticated to false', () async {
      when(() => authController.localStorage.value.readFromStorage('Token')).thenAnswer((_) async => "token");
      when(() => mockInternetConnectionChecker.isConnected).thenAnswer((_) async => true);
      when(() => authController.authService.value.refreshToken("token")).thenThrow(Exception());

      await authController.checkAuthentication();

      expect(authController.isAuthenticated.value, false);
      expect(authController.checkingTokenValidity.value, false);
    });

    test('loginUser - successful login', () async {
      // Mocking successful login response from AuthService
      final userData = AuthModel(
                token: 'token',
                userEmail: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNicename: 'user_nicename',
                followers: 0,
                followings: 0,
                friends: 0,
              );
      when(() => mockInternetConnectionChecker.isConnected).thenAnswer((_) async => true);            
      when(() => mockAuthService.loginUser(
              email: any(named: 'email'),
              password: any(named: 'password'),
              loginType: any(named: 'loginType')))
          .thenAnswer((_) async => userData);

      when(() => authController.localStorage.value.writeToStorage("Token",'token')).thenAnswer((_) async => null);
      when(() => authController.localStorage.value.storeUserInfo(
                email: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNiceName: 'user_nicename',
                followers: "0",
                followings:"0",
                friends: "0",)).thenAnswer((_) async => null);
                
      await authController.loginUser(
          email: 'user@example.com',
          password: 'password',
          loginType: 'email');

      expect(authController.isAuthenticated.value, true);
    });
    test('loginUser - successful login', () async {
      // Mocking successful login response from AuthService
      final userData = AuthModel(
                token: 'token',
                userEmail: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNicename: 'user_nicename',
                followers: 0,
                followings: 0,
                friends: 0,
              );
      when(() => mockInternetConnectionChecker.isConnected).thenAnswer((_) async => true);            
      when(() => mockAuthService.loginUser(
              email: any(named: 'email'),
              password: any(named: 'password'),
              loginType: any(named: 'loginType')))
          .thenAnswer((_) async => userData);

      when(() => authController.localStorage.value.writeToStorage("Token",'token')).thenAnswer((_) async => null);
      when(() => authController.localStorage.value.storeUserInfo(
                email: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNiceName: 'user_nicename',
                followers: "0",
                followings:"0",
                friends: "0",)).thenAnswer((_) async => null);
                
      await authController.loginUser(
          email: 'user@example.com',
          password: 'password',
          loginType: 'email');

      expect(authController.isAuthenticated.value, true);
    });
    test('loginUser - un successful login', () async {
      // Mocking successful login response from AuthService
      final userData = AuthModel(
                token: 'token',
                userEmail: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNicename: 'user_nicename',
                followers: 0,
                followings: 0,
                friends: 0,
              );
      when(() => mockInternetConnectionChecker.isConnected).thenAnswer((_) async => true);            
      when(() => mockAuthService.loginUser(
              email: any(named: 'email'),
              password: any(named: 'password'),
              loginType: any(named: 'loginType')))
          .thenThrow(Exception());

      when(() => authController.localStorage.value.writeToStorage("Token",'token')).thenAnswer((_) async => null);
      when(() => authController.localStorage.value.storeUserInfo(
                email: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNiceName: 'user_nicename',
                followers: "0",
                followings:"0",
                friends: "0",)).thenAnswer((_) async => null);
                
      await authController.loginUser(
          email: 'user@example.com',
          password: 'password',
          loginType: 'email');

      expect(authController.isAuthenticated.value, false);
    });

      test('register - successful registration', () async {
      // Mocking un successful registration response from AuthService
      when(() => mockInternetConnectionChecker.isConnected).thenAnswer((_) async => true);
      when(() => mockAuthService.register(
              email: any(named: 'email'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password')))
          .thenAnswer((_) async => '200');

      await authController.register(
          email: 'user@example.com',
          firstName: 'First',
          lastName: 'Last',
          password: 'password');

      expect(authController.isRegistered.value, true);
    });
      test('register - un successful registration', () async {
      when(() => mockInternetConnectionChecker.isConnected).thenAnswer((_) async => true);
      when(() => mockAuthService.register(
              email: any(named: 'email'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName'),
              password: any(named: 'password')))
          .thenAnswer((_) async => '400');

      await authController.register(
          email: 'user@example.com',
          firstName: 'First',
          lastName: 'Last',
          password: 'password');

      expect(authController.isRegistered.value, false);
    });

    test('loginUserWithGoogle - successful login with Google', () async {
      // Mocking successful login with Google response from AuthService
      final userData = AuthModel(
                token: 'token',
                userEmail: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNicename: 'user_nicename',
                followers: 0,
                followings: 0,
                friends: 0,
              );
      when(() => mockAuthService.registerWithGoogle(
              email: any(named: 'email'),
              googleId: any(named: 'googleId'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName')))
          .thenAnswer((_) async =>userData);

      
      when(() => authController.localStorage.value.writeToStorage("Token",'token')).thenAnswer((_) async => null);
      when(() => authController.localStorage.value.storeUserInfo(
                email: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNiceName: 'user_nicename',
                followers: "0",
                followings:"0",
                friends: "0",)).thenAnswer((_) async => null);

      await authController.loginUserWithGoogle(
          email: 'user@example.com',
          firstName: 'First',
          lastName: 'Last',
          googleId: 'googleId');

      expect(authController.isAuthenticated.value, true);
    });

    test('loginUserWithGoogle - un successful login with Google', () async {
      final userData = AuthModel(
                token: 'token',
                userEmail: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNicename: 'user_nicename',
                followers: 0,
                followings: 0,
                friends: 0,
              );
      when(() => mockAuthService.registerWithGoogle(
              email: any(named: 'email'),
              googleId: any(named: 'googleId'),
              firstName: any(named: 'firstName'),
              lastName: any(named: 'lastName')
              ))
          .thenThrow(Exception());      
      when(() => authController.localStorage.value.writeToStorage("Token",'token')).thenAnswer((_) async => null);
      when(() => authController.localStorage.value.storeUserInfo(
                email: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNiceName: 'user_nicename',
                followers: "0",
                followings:"0",
                friends: "0",)).thenAnswer((_) async => null);

      await authController.loginUserWithGoogle(
          email: 'user@example.com',
          firstName: 'First',
          lastName: 'Last',
          googleId: 'googleId');

      expect(authController.isAuthenticated.value, false);
    });

    test('storeUserInformation - storing user information', () async {
       final userData = AuthModel(
        token: 'token',
        userEmail: 'user@example.com',
        image: 'user_image_url',
        userDisplayName: 'User',
        username: 'username',
        firstName: 'First',
        lastName: 'Last',
        userNicename: 'user_nicename',
        followers: 0,
        followings: 0,
        friends: 0,
      );

      when(() => authController.localStorage.value.writeToStorage("Token",'token')).thenAnswer((_) async => null);
      when(() => authController.localStorage.value.storeUserInfo(
                email: 'user@example.com',
                image: 'user_image_url',
                userDisplayName: 'User',
                username: 'username',
                firstName: 'First',
                lastName: 'Last',
                userNiceName: 'user_nicename',
                followers: "0",
                followings:"0",
                friends: "0",)).thenAnswer((_) async => null);

     
      await authController.storeUserInformation(userData: userData);
    });

    test('checkUserPrivellege - user has privilege', () async {
      authController.isGuestUser.value = false;
      final result = authController.checkUserPrivellege(requiresPrivilege: true);
      expect(result, true);
    });

    test('checkUserPrivellege - no privilege required', () async {
      authController.isGuestUser.value = true;
      final result = authController.checkUserPrivellege(requiresPrivilege: false);
      expect(result, true);
    });

    test('Logout should delete token', () async {
      when(() => mockLocalStorage.deleteFromStorage("Token")).thenAnswer((_) async => null);
      authController.logout();
      verify(() => mockLocalStorage.deleteFromStorage("Token")).called(1);
      expect(authController.isAuthenticated.value, false);
  });
});
}
