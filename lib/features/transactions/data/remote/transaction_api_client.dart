import 'package:dio/dio.dart';
import 'transaction_models.dart';

class TransactionApiClient {
  final Dio _dio;
  final String deviceId;

  TransactionApiClient(this._dio, {required this.deviceId});

  Future<TransactionResponse> createTransaction(CreateTransactionRequest req) async {
    final res = await _dio.post(
      '/api/v1/transactions',
      data: req.toJson(),
      options: Options(headers: {'X-Device-ID': deviceId}),
    );
    return TransactionResponse.fromJson(res.data);
  }
}
