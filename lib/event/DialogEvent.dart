import 'package:event_bus/event_bus.dart';

/// 创建EventBus
EventBus eventBus = EventBus();

class DialogEvent {
  int message;

  DialogEvent(this.message);
}
