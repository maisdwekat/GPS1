import 'package:flutter/material.dart';

import '../constants.dart';

class RequestFormScreen extends StatelessWidget {
  // Controllers for the text fields
  final TextEditingController investorNameController = TextEditingController(text: "اسم المستثمر");
  final TextEditingController emailController = TextEditingController(text: "البريد الإلكتروني");
  final TextEditingController projectNameController = TextEditingController(text: "اسم المشروع");
  final TextEditingController investmentAmountController = TextEditingController(text: "مبلغ الاستثمار");
  final TextEditingController investmentTypeController = TextEditingController(text: "نوع الاستثمار");
  final TextEditingController startDateController = TextEditingController(text: "تاريخ البدء بالاستثمار");
  final TextEditingController dueDateController = TextEditingController(text: "تاريخ الاستحقاق");
  final TextEditingController investmentPercentageController = TextEditingController(text: "نسبة الاستثمار");
  final TextEditingController investmentDurationController = TextEditingController(text: "مدة الاستثمار");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
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
                    'نموذج الطلب ',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'معلومات المستثمر-',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                  _buildLabeledReadOnlyField(investorNameController),
                  SizedBox(height: 10),
                  _buildLabeledReadOnlyField(emailController),
                  SizedBox(height: 20),
                  Text(
                    ' تفاصيل الاستثمار -',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                  _buildLabeledReadOnlyField(projectNameController),
                  SizedBox(height: 10),
                  _buildLabeledReadOnlyField(investmentAmountController),
                  SizedBox(height: 10),
                  _buildLabeledReadOnlyField(investmentTypeController),
                  SizedBox(height: 10),
                  _buildLabeledReadOnlyField(startDateController),
                  SizedBox(height: 10),
                  _buildLabeledReadOnlyField(dueDateController),
                  SizedBox(height: 10),
                  _buildLabeledReadOnlyField(investmentPercentageController),
                  SizedBox(height: 10),
                  _buildLabeledReadOnlyField(investmentDurationController),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledReadOnlyField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 8),
        Container(
          width: 300,
          child: TextField(
            controller: controller,
            readOnly: true, // يجعله للقراءة فقط
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