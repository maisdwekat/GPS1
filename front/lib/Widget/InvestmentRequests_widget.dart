import 'package:flutter/material.dart';

import '../Investments/UserInvestmentRequests.dart';

class InvestmentRequest {
  final String investorName;
  final String requestTitle;

  InvestmentRequest(this.investorName, this.requestTitle);
}

class InvestmentRequestsWidget extends StatefulWidget {
  @override
  State<InvestmentRequestsWidget> createState() => _InvestmentRequestsWidgetState();
}

class _InvestmentRequestsWidgetState extends State<InvestmentRequestsWidget> {
  final List<dynamic> investmentRequests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _buildInvestmentRequestsContent(context),
    );
  }

  Widget _buildInvestmentRequestsContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'طلبات الاستثمار',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey, width: 1),
            ),
            columnWidths: {
              0: FractionColumnWidth(0.4),
              1: FractionColumnWidth(0.4),
              2: FractionColumnWidth(0.2),
            },
            children: [
              _buildHeaderInvestmentRequestsRow(),
              ...investmentRequests
                  .map((request) => buildInvestmentRequestsRow(request, context))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderInvestmentRequestsRow() {
    return TableRow(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              Text(
                'الإجراءات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                'نموذج الطلب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              Text(
                'اسم المستثمر',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  TableRow buildInvestmentRequestsRow(InvestmentRequest request, BuildContext context) {
    return TableRow(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // تنفيذ عملية الحذف هنا
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              SizedBox(
                width: 180,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserInvestmentRequestsScreen(),
                      ),
                    );
                  },
                  child: Text('نموذج الطلب'),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              Text(
                request.investorName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}