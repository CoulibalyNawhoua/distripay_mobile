class Transaction  {
    int montantInitial;
    String customerPays;
    String transactionId;
    DateTime dateTrans;
    DateTime createdAt;
    String channels;
    String devise;
    String telPayment;
    String statusPayment;
    String customerId;
    String customerName;
    String? customerSurname;
    String operateur;

    Transaction ({
      required this.montantInitial,
      required this.customerPays,
      required this.transactionId,
      required this.dateTrans,
      required this.createdAt,
      required this.channels,
      required this.devise,
      required this.telPayment,
      required this.statusPayment,
      required this.customerId,
      required this.customerName,
      this.customerSurname,
      required this.operateur,
    });

    factory Transaction .fromJson(Map<String, dynamic> json) => Transaction (
      montantInitial: json["montant_initial"],
      customerPays: json["customer_pays"],
      transactionId: json["transaction_id"],
      dateTrans: DateTime.parse(json["date_trans"]),
      createdAt: DateTime.parse(json["created_at"]),
      channels: json["channels"],
      devise: json["devise"],
      telPayment: json["tel_payment"],
      statusPayment: json["status_payment"],
      customerId: json["customer_id"],
      customerName: json["customer_name"],
      customerSurname: json["customer_surname"],
      operateur: json["operateur"],
    );

    Map<String, dynamic> toJson() => {
      "montant_initial": montantInitial,
      "customer_pays": customerPays,
      "transaction_id": transactionId,
      "date_trans": dateTrans.toIso8601String(),
      "created_at": createdAt.toIso8601String(),
      "channels": channels,
      "devise": devise,
      "tel_payment": telPayment,
      "status_payment": statusPayment,
      "customer_id": customerId,
      "customer_name": customerName,
      "customer_surname": customerSurname,
      "operateur": operateur,
    };
}
