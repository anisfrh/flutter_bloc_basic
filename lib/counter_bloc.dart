import 'dart:async';

abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}
class DecrementEvent extends CounterEvent {}

class CounterBloc {
  int _value = 0;

  // event stream controller
  final StreamController<CounterEvent> _eventController = StreamController<CounterEvent>();

  StreamSink<CounterEvent> get eventSink => _eventController.sink; //jalur masuk

  Stream<CounterEvent> get streamEvent => _eventController.stream;

  // state stream Controller
  final StreamController<int> stateController = StreamController<int>();

  StreamSink<int> get sinkState => stateController.sink;  // sink state untuk masukin data ke stateController, 

  Stream<int> get streamState => stateController.stream;  // dari state controller ke stream untuk masukin data ke UI

  void mapEventToState(CounterEvent event) {
    if (event is IncrementEvent) {
      _value++;
    } else {
      _value--;
    }
    sinkState.add(_value);
  }

  CounterBloc() {
    streamEvent.listen((event) {
      mapEventToState(event);
    });
  }

  void dispose() {   //biar kalo ga lagi dipake dia gakebaca terus karna bakal bikin berat aplikasi (lgsg ngeclose)
    _eventController.close();
    stateController.close();
  }
}


//bagan alur proses