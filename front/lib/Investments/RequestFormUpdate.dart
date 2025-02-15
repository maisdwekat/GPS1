import 'package:flutter/material.dart';

import '../constants.dart';

class RequestFormUpdateScreen extends StatelessWidget {
  // Controllers for the text fields
  final TextEditingController investorNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController investmentAmountController = TextEditingController();
  final TextEditingController investmentTypeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController investmentPercentageController = TextEditingController();
  final TextEditingController investmentDurationController = TextEditingController();

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
                    'تعديل نموذج الطلب ',
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
                  _buildLabeledTextField(investorNameController, 'اسم المستثمر'),
                  SizedBox(height: 10),
                  _buildLabeledTextField(emailController, 'البريد الإلكتروني'),
                  SizedBox(height: 20),
                  Text(
                    ' تفاصيل الاستثمار -',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                  _buildLabeledTextField(projectNameController, 'اسم المشروع'),
                  SizedBox(height: 10),
                  _buildLabeledTextField(investmentAmountController, 'مبلغ الاستثمار'),
                  SizedBox(height: 10),
                  _buildLabeledTextField(investmentTypeController, 'نوع الاستثمار'),
                  SizedBox(height: 10),
                  _buildLabeledTextField(startDateController, 'تاريخ البدء بالاستثمار'),
                  SizedBox(height: 10),
                  _buildLabeledTextField(dueDateController, 'تاريخ الاستحقاق'),
                  SizedBox(height: 10),
                  _buildLabeledTextField(investmentPercentageController, 'نسبة الاستثمار'),
                  SizedBox(height: 10),
                  _buildLabeledTextField(investmentDurationController, 'مدة الاستثمار'),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        print('تم حفظ التعديلات');
                      },
                      child: Text('حفظ التعديلات واعادة الارسال '),
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

  Widget _buildLabeledTextField(TextEditingController controller, String label, {int maxLines = 1}) {
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