sealed class Resource<T> {
  final T? data;
  final String? message;

  const Resource({this.data, this.message});
}

class Success<T> extends Resource<T> {
  const Success({super.data});
}

class Error<T> extends Resource<T> {
  const Error({super.message, super.data});
}

class Loading<T> extends Resource<T> {
  const Loading({super.data});
}