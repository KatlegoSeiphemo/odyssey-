import 'package:flutter/foundation.dart';

class ChildService extends ChangeNotifier {
	List children = <dynamic>[];

	Future<void> loadChildren(String userId) async {}
	Future<void> addChild(dynamic child) async {}
}

