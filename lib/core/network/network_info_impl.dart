import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:number_trivia_clean_architecture_tdd/core/network/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker? connectionChecker;
  NetworkInfoImpl(this.connectionChecker);
  @override
  Future<bool> get isConnected => connectionChecker!.hasConnection;
}
