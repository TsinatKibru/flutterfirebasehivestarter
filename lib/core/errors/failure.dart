abstract class Failure {
  final String message;
  const Failure(this.message);
}

// class ServerFailure extends Failure {
//   ServerFailure(String message) : super(message);
// }
class ServerFailure extends Failure {
  ServerFailure(String rawMessage) : super(_parseMessage(rawMessage));

  static String _parseMessage(String rawMessage) {
    rawMessage = rawMessage.toLowerCase();

    if (rawMessage.contains('network-request-failed') ||
        rawMessage.contains('socketexception') ||
        rawMessage.contains('failed host lookup') ||
        rawMessage.contains('unreachable') ||
        rawMessage.contains('network is unreachable')) {
      return 'No internet connection. Please check your network settings.';
    } else if (rawMessage.contains('permission-denied')) {
      return 'You do not have permission to perform this action.';
    } else if (rawMessage.contains('not-found')) {
      return 'Requested data not found.';
    } else if (rawMessage.contains('unavailable')) {
      return 'Service is temporarily unavailable. Please try again later.';
    } else if (rawMessage.contains('already-exists')) {
      return 'This item already exists.';
    } else if (rawMessage.contains('timeout')) {
      return 'The request timed out. Please try again.';
    }

    return 'Something went wrong. Please try again.';
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}
