// calm@endurance:~/flutterproejcts/stockpro/lib/features$ find . -type f -name "*.dart" -print -exec cat {} \;
// ./inventory/presentation/pages/inventory.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';

// class Inventory extends StatefulWidget {
//   const Inventory({Key? key}) : super(key: key);

//   @override
//   _InventoryState createState() => _InventoryState();
// }

// class _InventoryState extends State<Inventory> {
//   // Sample data for inventory items
//   final List<InventoryItem> _inventoryItems = [
//     InventoryItem(name: 'Laptop', quantity: 15, unitPrice: 1200.00),
//     InventoryItem(name: 'Mouse', quantity: 50, unitPrice: 25.50),
//     InventoryItem(name: 'Keyboard', quantity: 30, unitPrice: 75.00),
//     InventoryItem(name: 'Monitor', quantity: 20, unitPrice: 300.00),
//     InventoryItem(name: 'Webcam', quantity: 40, unitPrice: 50.00),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Inventory Management'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.exit_to_app),
//             tooltip: 'Sign Out',
//             onPressed: () {
//               context.read<AuthBloc>().add(SignOutEvent());
//             },
//           ),
//           const SizedBox(width: 8), // Add some spacing
//         ],
//       ),
//       body: _inventoryItems.isEmpty
//           ? const Center(
//               child: Text('Your inventory is currently empty.',
//                   style: TextStyle(fontSize: 16)),
//             )
//           : ListView.builder(
//               itemCount: _inventoryItems.length,
//               itemBuilder: (context, index) {
//                 final item = _inventoryItems[index];
//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.name,
//                           style: const TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Quantity: ${item.quantity}'),
//                             Text(
//                                 'Price: \$${item.unitPrice.toStringAsFixed(2)}'),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                             'Total Value: \$${(item.quantity * item.unitPrice).toStringAsFixed(2)}'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Implement add new item functionality here
//           print('Add new item');
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

// class InventoryItem {
//   final String name;
//   final int quantity;
//   final double unitPrice;

//   InventoryItem({
//     required this.name,
//     required this.quantity,
//     required this.unitPrice,
//   });
// }
// ./auth/presentation/widget/auth_text_field.dart
// import 'package:flutter/material.dart';

// class AuthTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String label;
//   final bool isPassword;
//   final String? Function(String?)? validator;
//   final IconData icon;

//   const AuthTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     required this.icon,
//     this.isPassword = false,
//     this.validator,
//   });

//   @override
//   State<AuthTextField> createState() => _AuthTextFieldState();
// }

// class _AuthTextFieldState extends State<AuthTextField> {
//   bool _obscureText = true;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: widget.controller,
//       obscureText: widget.isPassword ? _obscureText : false,
//       decoration: InputDecoration(
//         labelText: widget.label,
//         prefixIcon: Icon(widget.icon),
//         suffixIcon: widget.isPassword
//             ? IconButton(
//                 icon: Icon(
//                   _obscureText ? Icons.visibility_off : Icons.visibility,
//                 ),
//                 onPressed: () => setState(() => _obscureText = !_obscureText),
//               )
//             : null,
//       ),
//       validator: widget.validator,
//     );
//   }
// }
// ./auth/presentation/widget/auth_button.dart
// import 'package:flutter/material.dart';

// class AuthButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String text;
//   final bool isLoading;

//   const AuthButton({
//     super.key,
//     required this.onPressed,
//     required this.text,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onPressed: isLoading ? null : onPressed,
//         child: isLoading
//             ? const SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                     strokeWidth: 2, color: Colors.white),
//               )
//             : Text(text, style: const TextStyle(fontSize: 16)),
//       ),
//     );
//   }
// }
// ./auth/presentation/pages/login_screen.dart
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
// import 'package:stockpro/features/auth/presentation/pages/signup_screen.dart';
// import 'package:stockpro/features/auth/presentation/widget/auth_button.dart';
// import 'package:stockpro/features/auth/presentation/widget/auth_text_field.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign In')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 24),
//               const Text(
//                 'Welcome Back',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Sign in to continue',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               const SizedBox(height: 32),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     AuthTextField(
//                       controller: _emailController,
//                       label: 'Email',
//                       icon: Icons.email,
//                       validator: (value) => (value == null || value.isEmpty)
//                           ? 'Enter your email'
//                           : null,
//                     ),
//                     const SizedBox(height: 16),
//                     AuthTextField(
//                       controller: _passwordController,
//                       label: 'Password',
//                       icon: Icons.lock,
//                       isPassword: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty)
//                           return 'Enter your password';
//                         if (value.length < 6)
//                           return 'Password must be at least 6 characters';
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     BlocConsumer<AuthBloc, AuthState>(
//                       listener: (context, state) {
//                         print("state: ${state}");
//                         if (state is AuthError) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(state.message)),
//                           );
//                         }
//                       },
//                       builder: (context, state) {
//                         return AuthButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               context.read<AuthBloc>().add(
//                                     SignInRequested(
//                                       _emailController.text,
//                                       _passwordController.text,
//                                     ),
//                                   );
//                             }
//                           },
//                           text: 'Sign In',
//                           isLoading: state is AuthLoading,
//                         );
//                       },
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (_) => const SignUpScreen()),
//                       ),
//                       child: const Text("Don't have an account? Sign Up"),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ./auth/presentation/pages/signup_screen.dart
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
// import 'package:stockpro/features/auth/presentation/pages/login_screen.dart';
// import 'package:stockpro/features/auth/presentation/widget/auth_button.dart';
// import 'package:stockpro/features/auth/presentation/widget/auth_text_field.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 24),
//               const Text(
//                 'Create Account',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Sign up to get started',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               const SizedBox(height: 32),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     AuthTextField(
//                       controller: _emailController,
//                       label: 'Email',
//                       icon: Icons.email,
//                       validator: (value) => (value == null || value.isEmpty)
//                           ? 'Enter your email'
//                           : null,
//                     ),
//                     const SizedBox(height: 16),
//                     AuthTextField(
//                       controller: _passwordController,
//                       label: 'Password',
//                       icon: Icons.lock,
//                       isPassword: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty)
//                           return 'Enter your password';
//                         if (value.length < 6)
//                           return 'Password must be at least 6 characters';
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     BlocConsumer<AuthBloc, AuthState>(
//                       listener: (context, state) {
//                         if (state is AuthError) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(state.message)),
//                           );
//                         }
//                       },
//                       builder: (context, state) {
//                         return AuthButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               context.read<AuthBloc>().add(
//                                     SignUpRequested(
//                                       _emailController.text,
//                                       _passwordController.text,
//                                     ),
//                                   );
//                             }
//                           },
//                           text: 'Sign Up',
//                           isLoading: state is AuthLoading,
//                         );
//                       },
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (_) => const LoginScreen()),
//                       ),
//                       child: const Text('Already have an account? Sign In'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ./auth/presentation/bloc/auth/auth_bloc.dart
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stockpro/features/auth/domain/entities/user_entity.dart';
// import 'package:stockpro/features/auth/domain/usecases/is_signed_in.dart';
// import 'package:stockpro/features/auth/domain/usecases/sign_in.dart';
// import 'package:stockpro/features/auth/domain/usecases/sign_out.dart';
// import 'package:stockpro/features/auth/domain/usecases/sign_up.dart';

// part 'auth_event.dart';
// part 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final SignInWithEmailAndPassword signInWithEmailAndPassword;
//   final SignUpWithEmailAndPassword signUpWithEmailAndPassword;
//   final IsSignedIn isSignedIn;
//   final SignOut signOut;

//   AuthBloc({
//     required this.signInWithEmailAndPassword,
//     required this.signUpWithEmailAndPassword,
//     required this.isSignedIn,
//     required this.signOut,
//   }) : super(AuthInitial()) {
//     on<SignInRequested>(_onSignInRequested);
//     on<SignUpRequested>(_onSignUpRequested);
//     on<CheckAuthenticationStatus>(_isSignedIn);
//     on<SignOutEvent>(_signOut);
//   }

//   Future<void> _onSignInRequested(
//     SignInRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       final user =
//           await signInWithEmailAndPassword(event.email, event.password);
//       if (user != null) {
//         emit(Authenticated(user: user));
//       } else {
//         emit(AuthError(message: "Login failed"));
//       }
//     } catch (e) {
//       emit(AuthError(message: e.toString()));
//     }
//   }

//   Future<void> _onSignUpRequested(
//     SignUpRequested event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       final user =
//           await signUpWithEmailAndPassword(event.email, event.password);
//       if (user != null) {
//         emit(Authenticated(user: user));
//       } else {
//         emit(AuthError(message: "Signup failed"));
//       }
//     } catch (e) {
//       emit(AuthError(message: e.toString()));
//     }
//   }

//   Future<void> _isSignedIn(
//     CheckAuthenticationStatus event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       final isLoggedIn = await isSignedIn();
//       if (isLoggedIn) {
//         emit(Authenticated(
//             user: UserEntity(
//           id: '',
//           email: '',
//           lastLogin: DateTime.now(),
//         ))); // Ideally fetch real user details
//       } else {
//         emit(Unauthenticated());
//       }
//     } catch (e) {
//       emit(AuthError(message: e.toString()));
//     }
//   }

//   Future<void> _signOut(
//     SignOutEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       await signOut();
//       emit(Unauthenticated());
//     } catch (e) {
//       emit(AuthError(message: e.toString()));
//     }
//   }
// }
// ./auth/presentation/bloc/auth/auth_state.dart
// part of 'auth_bloc.dart';

// abstract class AuthState extends Equatable {
//   const AuthState();

//   @override
//   List<Object> get props => [];
// }

// class AuthInitial extends AuthState {}

// class AuthLoading extends AuthState {}

// class Authenticated extends AuthState {
//   final UserEntity user;
//   const Authenticated({required this.user});

//   @override
//   List<Object> get props => [user];
// }

// class Unauthenticated extends AuthState {}

// class AuthError extends AuthState {
//   final String message;
//   const AuthError({required this.message});

//   @override
//   List<Object> get props => [message];
// }
// ./auth/presentation/bloc/auth/auth_event.dart
// part of 'auth_bloc.dart';

// abstract class AuthEvent extends Equatable {
//   const AuthEvent();

//   @override
//   List<Object> get props => [];
// }

// class SignInRequested extends AuthEvent {
//   final String email;
//   final String password;

//   const SignInRequested(this.email, this.password);

//   @override
//   List<Object> get props => [email, password];
// }

// class SignUpRequested extends AuthEvent {
//   final String email;
//   final String password;

//   const SignUpRequested(this.email, this.password);

//   @override
//   List<Object> get props => [email, password];
// }

// class CheckAuthenticationStatus extends AuthEvent {}

// class SignOutEvent extends AuthEvent {}
// ./auth/data/datasource/auth_remote_data_source.dart
// import 'package:firebase_auth/firebase_auth.dart';

// abstract class AuthRemoteDataSource {
//   Future<void> signIn(String email, String password);
//   Future<void> signUp(String email, String password);
//   Future<void> signOut();
//   Future<bool> isSignedIn();
//   Future<String?> getUserId();
// }

// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final FirebaseAuth firebaseAuth;

//   AuthRemoteDataSourceImpl(this.firebaseAuth);

//   @override
//   Future<void> signIn(String email, String password) async {
//     await firebaseAuth.signInWithEmailAndPassword(
//         email: email, password: password);
//   }

//   @override
//   Future<void> signUp(String email, String password) async {
//     await firebaseAuth.createUserWithEmailAndPassword(
//         email: email, password: password);
//   }

//   @override
//   Future<void> signOut() async {
//     await firebaseAuth.signOut();
//   }

//   @override
//   Future<bool> isSignedIn() async {
//     return firebaseAuth.currentUser != null;
//   }

//   @override
//   Future<String?> getUserId() async {
//     return firebaseAuth.currentUser?.uid;
//   }
// }
// ./auth/data/datasource/auth_local_data_source.dart
// import 'package:hive/hive.dart';
// import 'package:stockpro/features/auth/data/model/user_model.dart';

// abstract class AuthLocalDataSource {
//   Future<void> cacheUser(UserModel user);
//   Future<UserModel?> getCachedUser();
//   Future<void> clearCache();
//   Future<bool> isUserCached();
// }

// class AuthLocalDataSourceImpl implements AuthLocalDataSource {
//   final Box<UserModel> userBox;

//   AuthLocalDataSourceImpl(this.userBox);

//   @override
//   Future<void> cacheUser(UserModel user) async {
//     await userBox.put('current_user', user);
//   }

//   @override
//   Future<UserModel?> getCachedUser() async {
//     return userBox.get('current_user');
//   }

//   @override
//   Future<void> clearCache() async {
//     await userBox.clear();
//   }

//   @override
//   Future<bool> isUserCached() async {
//     return userBox.containsKey('current_user');
//   }
// }
// ./auth/data/model/user_model.g.dart
// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'user_model.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class UserModelAdapter extends TypeAdapter<UserModel> {
//   @override
//   final int typeId = 0;

//   @override
//   UserModel read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return UserModel(
//       id: fields[0] as String,
//       email: fields[1] as String,
//       name: fields[2] as String?,
//       photoUrl: fields[3] as String?,
//       lastLogin: fields[4] as DateTime,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, UserModel obj) {
//     writer
//       ..writeByte(5)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.email)
//       ..writeByte(2)
//       ..write(obj.name)
//       ..writeByte(3)
//       ..write(obj.photoUrl)
//       ..writeByte(4)
//       ..write(obj.lastLogin);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is UserModelAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
// ./auth/data/model/user_model.dart
// import 'package:hive/hive.dart';
// import '../../domain/entities/user_entity.dart';

// part 'user_model.g.dart';

// @HiveType(typeId: 0)
// class UserModel {
//   @HiveField(0)
//   final String id;

//   @HiveField(1)
//   final String email;

//   @HiveField(2)
//   final String? name;

//   @HiveField(3)
//   final String? photoUrl;

//   @HiveField(4)
//   final DateTime lastLogin;

//   UserModel({
//     required this.id,
//     required this.email,
//     this.name,
//     this.photoUrl,
//     required this.lastLogin,
//   });

//   // Convert from Entity to Model
//   factory UserModel.fromEntity(UserEntity entity) {
//     return UserModel(
//       id: entity.id,
//       email: entity.email,
//       name: entity.name,
//       photoUrl: entity.photoUrl,
//       lastLogin: entity.lastLogin,
//     );
//   }

//   // Convert to Entity
//   UserEntity toEntity() {
//     return UserEntity(
//       id: id,
//       email: email,
//       name: name,
//       photoUrl: photoUrl,
//       lastLogin: lastLogin,
//     );
//   }
// }
// ./auth/data/repositories/auth_repository_impl.dart
// import 'package:stockpro/features/auth/data/datasource/auth_local_data_source.dart';
// import 'package:stockpro/features/auth/data/datasource/auth_remote_data_source.dart';
// import 'package:stockpro/features/auth/data/model/user_model.dart';
// import 'package:stockpro/features/auth/domain/entities/user_entity.dart';
// import 'package:stockpro/features/auth/domain/repositories/auth_repository.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource remoteDataSource;
//   final AuthLocalDataSource localDataSource;

//   AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

//   @override
//   Future<UserEntity?> signInWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       await remoteDataSource.signIn(email, password);
//       final userId = await remoteDataSource.getUserId();
//       if (userId != null) {
//         final userModel = UserModel(
//           id: userId,
//           email: email,
//           lastLogin: DateTime.now(),
//         );
//         await localDataSource.cacheUser(userModel);
//         return userModel.toEntity();
//       }
//       return null;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<UserEntity?> signUpWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       await remoteDataSource.signUp(email, password);
//       final userId = await remoteDataSource.getUserId();
//       if (userId != null) {
//         final userModel = UserModel(
//           id: userId,
//           email: email,
//           lastLogin: DateTime.now(),
//         );
//         await localDataSource.cacheUser(userModel);
//         return userModel.toEntity();
//       }
//       return null;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<void> signInWithGoogle() {
//     throw UnimplementedError(); // same as before
//   }

//   @override
//   Future<void> signOut() async {
//     await remoteDataSource.signOut();
//     await localDataSource.clearCache();
//   }

//   @override
//   Future<bool> isSignedIn() async {
//     final isCached = await localDataSource.isUserCached();
//     if (!isCached) return false;
//     return remoteDataSource.isSignedIn();
//   }

//   @override
//   Future<String?> getUserId() async {
//     final cachedUser = await localDataSource.getCachedUser();
//     return cachedUser?.id ?? await remoteDataSource.getUserId();
//   }

//   @override
//   Future<UserEntity?> getCurrentUser() async {
//     try {
//       final cachedUser = await localDataSource.getCachedUser();
//       if (cachedUser != null) {
//         return cachedUser.toEntity();
//       }
//       return null;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
// ./auth/domain/usecases/sign_up.dart
// import 'package:stockpro/features/auth/domain/entities/user_entity.dart';
// import 'package:stockpro/features/auth/domain/repositories/auth_repository.dart';

// class SignUpWithEmailAndPassword {
//   final AuthRepository repository;

//   SignUpWithEmailAndPassword(this.repository);

//   Future<UserEntity?> call(String email, String password) {
//     return repository.signUpWithEmailAndPassword(email, password);
//   }
// }
// ./auth/domain/usecases/is_signed_in.dart
// import 'package:stockpro/features/auth/domain/repositories/auth_repository.dart';

// class IsSignedIn {
//   final AuthRepository repository;

//   IsSignedIn(this.repository);

//   Future<bool> call() {
//     return repository.isSignedIn();
//   }
// }
// ./auth/domain/usecases/sign_in.dart
// import 'package:stockpro/features/auth/domain/entities/user_entity.dart';
// import 'package:stockpro/features/auth/domain/repositories/auth_repository.dart';

// class SignInWithEmailAndPassword {
//   final AuthRepository repository;

//   SignInWithEmailAndPassword(this.repository);

//   Future<UserEntity?> call(String email, String password) {
//     return repository.signInWithEmailAndPassword(email, password);
//   }
// }
// ./auth/domain/usecases/sign_out.dart
// import 'package:stockpro/features/auth/domain/repositories/auth_repository.dart';

// class SignOut {
//   final AuthRepository repository;

//   SignOut(this.repository);

//   Future<void> call() {
//     return repository.signOut();
//   }
// }
// ./auth/domain/repositories/auth_repository.dart
// import '../entities/user_entity.dart';

// abstract class AuthRepository {
//   Future<UserEntity?> signInWithEmailAndPassword(String email, String password);
//   Future<UserEntity?> signUpWithEmailAndPassword(String email, String password);
//   Future<void> signOut();
//   Future<UserEntity?> getCurrentUser();
//   Future<bool> isSignedIn();
// }
// ./auth/domain/entities/user_entity.dart
// class UserEntity {
//   final String id;
//   final String email;
//   final String? name;
//   final String? photoUrl;
//   final DateTime lastLogin;

//   UserEntity({
//     required this.id,
//     required this.email,
//     this.name,
//     this.photoUrl,
//     required this.lastLogin,
//   });

//   // Add equality comparison and other domain methods
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is UserEntity &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           email == other.email;

//   @override
//   int get hashCode => id.hashCode ^ email.hashCode;
// }
// calm@endurance:~/flutterproejcts/stockpro/lib/features$ find ../../ -type f -name "main.dart" -print -exec cat {} \;
// ../../lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stockpro/config/routes/routes.dart';
// import 'package:stockpro/config/theme/app_themes.dart';
// import 'package:stockpro/features/auth/presentation/bloc/auth/auth_bloc.dart';
// import 'package:stockpro/root_screen.dart';
// import 'package:stockpro/injection_container.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeDependencies();

//   runApp(
//     MultiBlocProvider(
//       providers: getBlocProviders(),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Trigger initial events after app is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _triggerInitialEvents(context);
//     });

//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: theme(),
//         title: 'Daily News',
//         // onGenerateRoute: AppRoutes.onGenerateRoutes,
//         home: RootScreen());
//   }

//   void _triggerInitialEvents(BuildContext context) {
//     context.read<AuthBloc>().add(CheckAuthenticationStatus());
//   }
// }
// calm@endurance:~/flutterproejcts/stockpro/lib/features$ find ../../ -type f -name "injection*.dart" -print -exec cat {} \;
// ../../lib/injection_container.dart
// import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:get_it/get_it.dart';

// import 'features/auth/data/datasource/auth_remote_data_source.dart';
// import 'features/auth/data/datasource/auth_local_data_source.dart';
// import 'features/auth/data/model/user_model.dart';
// import 'features/auth/data/repositories/auth_repository_impl.dart';
// import 'features/auth/domain/repositories/auth_repository.dart';
// import 'features/auth/domain/usecases/is_signed_in.dart';
// import 'features/auth/domain/usecases/sign_in.dart';
// import 'features/auth/domain/usecases/sign_out.dart';
// import 'features/auth/domain/usecases/sign_up.dart';
// import 'features/auth/presentation/bloc/auth/auth_bloc.dart';

// final sl = GetIt.instance;

// Future<void> initializeDependencies() async {
//   await _initCore();
//   _initAuth();
// }

// Future<void> _initCore() async {
//   // Database
//   final appDocumentDirectory =
//       await path_provider.getApplicationDocumentsDirectory();
//   await Hive.initFlutter(appDocumentDirectory.path);

//   Hive.registerAdapter(UserModelAdapter());
//   await Hive.openBox<UserModel>('user_box');

//   // Firebase
//   await Firebase.initializeApp();
//   sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

//   // Network
//   sl.registerSingleton<Dio>(Dio());
// }

// void _initAuth() {
//   // Data Sources
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(sl<FirebaseAuth>()),
//   );
//   sl.registerLazySingleton<AuthLocalDataSource>(
//     () => AuthLocalDataSourceImpl(Hive.box<UserModel>('user_box')),
//   );

//   // Repository
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(
//         sl<AuthRemoteDataSource>(), sl<AuthLocalDataSource>()),
//   );

//   // Use Cases
//   sl.registerLazySingleton(
//       () => SignInWithEmailAndPassword(sl<AuthRepository>()));
//   sl.registerLazySingleton(
//       () => SignUpWithEmailAndPassword(sl<AuthRepository>()));
//   sl.registerLazySingleton(() => IsSignedIn(sl<AuthRepository>()));
//   sl.registerLazySingleton(() => SignOut(sl<AuthRepository>()));

//   // Bloc
//   sl.registerFactory(
//     () => AuthBloc(
//       signInWithEmailAndPassword: sl<SignInWithEmailAndPassword>(),
//       signUpWithEmailAndPassword: sl<SignUpWithEmailAndPassword>(),
//       isSignedIn: sl<IsSignedIn>(),
//       signOut: sl<SignOut>(),
//     ),
//   );
// }

// List<BlocProvider> getBlocProviders() {
//   return [
//     BlocProvider<AuthBloc>(
//         create: (context) => sl<AuthBloc>()..add(CheckAuthenticationStatus())),
//   ];
// }

