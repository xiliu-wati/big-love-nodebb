import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _setLoading(true);
    try {
      final isLoggedIn = await _apiService.isLoggedIn();
      
      if (isLoggedIn) {
        _currentUser = await _apiService.getUserProfile();
        _isAuthenticated = true;
      }
    } catch (e) {
      // Token is invalid, clear storage
      await _apiService.logout();
      _isAuthenticated = false;
      _currentUser = null;
    }
    _setLoading(false);
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.login(email, password);
      
      if (response['success'] == true) {
        _currentUser = User.fromJson(response['user']);
        _isAuthenticated = true;
        _setLoading(false);
        return true;
      } else {
        _setError(response['message'] ?? 'Login failed. Please check your credentials.');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.register(username, email, password);
      
      if (response['success'] == true) {
        // After successful registration, log the user in
        final loginSuccess = await login(email, password);
        return loginSuccess;
      } else {
        _setError(response['message'] ?? 'Registration failed. Please try again.');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _apiService.logout();
      _currentUser = null;
      _isAuthenticated = false;
    } catch (e) {
      // Even if logout fails on server, clear local data
      _currentUser = null;
      _isAuthenticated = false;
    }
    
    _setLoading(false);
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    if (_currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      // For now, just refresh the user profile
      // TODO: Implement profile update endpoint in backend
      _currentUser = await _apiService.getUserProfile();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
