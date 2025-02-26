import 'package:flutter/material.dart';

import '../constants.dart';

class InvestmentRequestFormScreen extends StatefulWidget {
  @override
  _InvestmentRequestFormScreenState createState() => _InvestmentRequestFormScreenState();
}

class _InvestmentRequestFormScreenState extends State<InvestmentRequestFormScreen> {
  final TextEditingController _investmentAmountController = TextEditingController();
  final TextEditingController _investmentTypeController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _investmentPercentageController = TextEditingController();
  final TextEditingController _investmentDurationController = TextEditingController();

  @override
  void dispose() {
    _investmentAmountController.dispose();
    _investmentTypeController.dispose();
    _dueDateController.dispose();
    _investmentPercentageController.dispose();
    _investmentDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نموذج طلب الاستثمار'),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 700,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'تقديم طلب استثمار',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                  Text(
                    ' تفاصيل الاستثمار -',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 10),
                  _buildLabeledTextField('مبلغ الاستثمار', _investmentAmountController),
                  SizedBox(height: 10),
                  _buildLabeledTextField('نوع الاستثمار', _investmentTypeController),
                  SizedBox(height: 10),
                  _buildLabeledTextField('تاريخ الاستحقاق', _dueDateController),
                  SizedBox(height: 10),
                  _buildLabeledTextField('نسبة الاستثمار', _investmentPercentageController),
                  SizedBox(height: 10),
                  _buildLabeledTextField('مدة الاستثمار', _investmentDurationController),
                  SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        print('تم إرسال طلب الاستثمار!');
                      },
                      child: Text('أرسل الطلب'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          width: 300,
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '',
            ),
          ),
        ),
      ],
    );
  }
}