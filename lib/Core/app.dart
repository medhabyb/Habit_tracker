// flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
import 'package:stacked/stacked_annotations.dart';

import '../UI/views/start_up/start_up_view.dart';

@StackedApp(
  routes: [MaterialRoute(page: StartUpView, initial: true)],
  dependencies: [/*Singleton(classType: )*/],
  logger: StackedLogger(),
)
class App {
  /** This class has no puporse besides housing the annotation that generates the required functionality **/
}
