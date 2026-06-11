import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../cubit/drawing_cubit.dart';
import 'drawing_screen.dart';

class MindPage extends StatelessWidget {
  const MindPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<DrawingCubit>(),
      child: const DrawingScreen(),
    );
  }
}
