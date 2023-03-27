import 'package:base_code/src/blocs/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloC extends BaseBloC {
  final BehaviorSubject<bool> _homeController = BehaviorSubject<bool>();
  Stream<bool> get homeStream => _homeController.stream;

  void changeSeeMore(){
    _homeController.add(true);
    print("DATA1 == ${homeStream}");
  }
  @override
  void dispose() {}
}
