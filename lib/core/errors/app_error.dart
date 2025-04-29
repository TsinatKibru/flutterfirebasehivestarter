abstract class AppError {
  final String message;
  const AppError(this.message);
}

class AuthError extends AppError {
  const AuthError(super.message);
}

class NetworkError extends AppError {
  const NetworkError(super.message);
}

class CacheError extends AppError {
  const CacheError(super.message);
}
