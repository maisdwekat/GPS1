import 'package:flutter/material.dart';

import '../Investments/Request_form.dart';

class DeletionAndModificationRequestsWidget extends StatefulWidget {
  @override
  State<DeletionAndModificationRequestsWidget> createState() => _DeletionAndModificationRequestsWidgetState();
}

class _DeletionAndModificationRequestsWidgetState extends State<DeletionAndModificationRequestsWidget> {
  final List<String> investors = [
    'حذف ',
    ' تعديل ',
    ' تعديل',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildDeletionAndModificationRequestsContent(context),
    );
  }

  Widget _buildDeletionAndModificationRequestsContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'طلبات الحذف والتعديل',
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
              _buildHeaderRow(),
              ...investors.map((name) => _buildInvestorRow(name, context)).toList(),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: 8),
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
              SizedBox(height: 8),
              Text(
                'نوع الطلب ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _buildInvestorRow(String name, BuildContext context) {
    return TableRow(
      children: [
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
                        builder: (context) => RequestFormScreen(), // استبدل بـ RequestForm()
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
                name,
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