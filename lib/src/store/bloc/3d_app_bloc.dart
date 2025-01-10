// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// Define events
abstract class ThreeDAppEvent {}

class UpdateMaterialIndices extends ThreeDAppEvent {
  final Map<String, int> meshMap;

  UpdateMaterialIndices(this.meshMap);
}

class ChangeMaterialColor extends ThreeDAppEvent {
  final String materialName;
  final Color newColor;
  ChangeMaterialColor(this.materialName, this.newColor);

  List<Object> get props => [materialName, newColor];
}

// Define states
class ThreeDAppState extends Equatable {
  final Map<String, int> materialIndices;

  const ThreeDAppState({this.materialIndices = const {}});

  @override
  List<Object> get props =>
      [materialIndices]; // Include materialIndices in props
}

class ThreeDAppInitial extends ThreeDAppState {
  ThreeDAppInitial({super.materialIndices});
}

class ThreeDAppCustomizing extends ThreeDAppState {
  ThreeDAppCustomizing({required super.materialIndices});
}

class ThreeDAppBloc extends Bloc<ThreeDAppEvent, ThreeDAppState> {
  ThreeDAppBloc() : super(ThreeDAppInitial()) {
    on<ChangeMaterialColor>((event, emit) {
      // TODO: Implement logic to change material color in the 3D model
      // You might need to access the 3D model and its materials here
    });

    on<UpdateMaterialIndices>((event, emit) {
      if (state is ThreeDAppInitial) {
        emit(ThreeDAppInitial(materialIndices: event.meshMap));
      } else if (state is ThreeDAppCustomizing) {
        emit(ThreeDAppCustomizing(materialIndices: event.meshMap));
      }
    });
  }
}
