import 'package:monke_app/preview/preview.dart';
import 'package:monke_app/bills/bills.dart';
import 'package:monke_app/bills/bill_details.dart';

var appRoutes = {
  '/preview': (context) => Preview(),
  '/bills': (context) => Bills(),
  '/bill_details': (context) => BillDetails(),
};
