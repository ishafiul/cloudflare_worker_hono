import 'package:envied/envied.dart';

part 'env.g.dart';

/// env variables of this project
@Envied()
class EnvProd {
  @EnviedField(varName: 'HOST_API')

  /// this will return `HOST_API` value form `.env` file
  static const String host = _EnvProd.host;
  @EnviedField(varName: 'HOST_API_WS')
  static const String hostWs = _EnvProd.hostWs;
}
