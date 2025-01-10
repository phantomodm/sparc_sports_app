import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';

// Define events
abstract class DatastoreEvent {}

class ReadData extends DatastoreEvent {
  final String key;
  final dynamic defaultValue;
  ReadData(this.key, {this.defaultValue});
}

class SetData extends DatastoreEvent {
  final String key;
  final dynamic value;
  SetData(this.key, this.value);
}

// In datastore_event.dart
class SessionUpdateData extends DatastoreEvent {
  final String name;
  final String key;
  final dynamic value;
  SessionUpdateData(this.name, this.key, this.value);
}

class SessionGetData extends DatastoreEvent {
  final String name;
  final String key;
  SessionGetData(this.name, this.key);
}

class SessionRemoveData extends DatastoreEvent {
  final String name;
  final String key;
  SessionRemoveData(this.name, this.key);
}

class SessionFlushData extends DatastoreEvent {
  final String name;
  SessionFlushData(this.name);
}

class SessionGetAllData extends DatastoreEvent {
  final String name;
  SessionGetAllData(this.name);
}

class ContainsKey extends DatastoreEvent {
  final String key;
  ContainsKey(this.key);
}

class SaveData extends DatastoreEvent {
  final String key;
  final dynamic value;
  SaveData(this.key, this.value);
}

class DeleteData extends DatastoreEvent {
  final String key;
  DeleteData(this.key);
}

class DeleteAllData extends DatastoreEvent {}

class GetAuthData extends DatastoreEvent {
  final String? key;
  GetAuthData({this.key});
}

// ... other events for sessionUpdate, sessionGet, etc. ...

// Define states
abstract class DatastoreState {}

class DatastoreInitial extends DatastoreState {}

class DatastoreLoaded extends DatastoreState {
  final Map<String, dynamic> data;
  DatastoreLoaded(this.data);
}

// Create the Bloc
class DatastoreBloc extends Bloc<DatastoreEvent, DatastoreState> {
  DatastoreBloc() : super(DatastoreInitial()) {
    Map<String, dynamic> _values = {};

    on<ReadData>((event, emit) {
      if (!_values.containsKey(event.key)) {
        emit(DatastoreLoaded(_values));
        return event.defaultValue;
      }
      emit(DatastoreLoaded(_values));
      return _values[event.key];
    });

    on<SetData>((event, emit) {
      _values[event.key] = event.value;
      emit(DatastoreLoaded(_values));
    });

    // In datastore_bloc.dart

    on<SessionUpdateData>((event, emit) {
      if (!_values.containsKey(event.name)) {
        _values[event.name] = {};
      }
      _values[event.name][event.key] = event.value;
      emit(DatastoreLoaded(_values));
    });

    on<SessionGetData>((event, emit) {
      if (!_values.containsKey(event.name)) {
        emit(DatastoreLoaded(_values));
        return null;
      }
      emit(DatastoreLoaded(_values));
      return _values[event.name][event.key];
    });

    on<SessionRemoveData>((event, emit) {
      if (_values.containsKey(event.name)) {
        _values[event.name].remove(event.key);
        emit(DatastoreLoaded(_values));
      }
    });

    on<SessionFlushData>((event, emit) {
      if (_values.containsKey(event.name)) {
        _values.remove(event.name);
        emit(DatastoreLoaded(_values));
      }
    });

    on<SessionGetAllData>((event, emit) {
      if (_values.containsKey(event.name)) {
        emit(DatastoreLoaded(_values));
        return Map<String, dynamic>.from(_values[event.name]);
      }
      emit(DatastoreLoaded(_values));
      return null;
    });

    on<ContainsKey>((event, emit) {
      emit(DatastoreLoaded(_values));
      return _values.containsKey(event.key);
    });

    on<SaveData>((event, emit) {
      _values[event.key] = event.value;
      emit(DatastoreLoaded(_values));
    });

    on<DeleteData>((event, emit) {
      if (_values.containsKey(event.key)) {
        _values.remove(event.key);
        emit(DatastoreLoaded(_values));
      }
    });

    on<DeleteAllData>((event, emit) {
      _values.removeWhere((key, value) => key != 'sparc');
      emit(DatastoreLoaded(_values));
    });

    on<GetAuthData>((event, emit) {
      String storageKey = getEnv('AUTH_USER_KEY', defaultValue: 'AUTH_USER');
      if (event.key != null) {
        storageKey = event.key!;
      }
      if (!_values.containsKey(storageKey)) {
        emit(DatastoreLoaded(_values));
        return null;
      }
      emit(DatastoreLoaded(_values));
      return _values[storageKey];
    });
  }
}
