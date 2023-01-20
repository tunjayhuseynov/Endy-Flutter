
import 'package:endy/Pages/Sign/Register/Register_Bloc.dart';
import 'package:endy/Pages/Sign/Register/Registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationContainer extends StatelessWidget {
  const RegistrationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc()..loadDocLink(),
      child: Registration(),
    );
  }
}