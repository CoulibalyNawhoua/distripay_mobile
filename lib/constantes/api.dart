class Api {
  static const url = 'https://pay.distriforce.shop/api';
  // static const url = 'http://192.168.1.72:8000/api';
  // static const urlImage = 'http://192.168.1.69:8000/storage/';

  static const login = '$url/login-mobile';

  static const listTransaction = '$url/list-transactions-all-mobile';
  static const transactionRecente = '$url/list-transactions-user-today-mobile';
  static const transactionTotal = '$url/sum-transactions-mobile';

  static String transactionDetails(String transactionId) {
    return '$url/view-transaction-code/$transactionId';
  }

  static const createUser = '$url/create-point-of-sale';
  static const listUser = '$url/point-of-sale-uses-list';

  static const payment = '$url/distriforce-check/v2/payment';


}