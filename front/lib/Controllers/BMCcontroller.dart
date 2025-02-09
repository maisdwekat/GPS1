import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ggg_hhh/Controllers/token_controller.dart';
import 'package:ggg_hhh/constants.dart';
import 'package:http/http.dart' as http;
import 'AuthController.dart';

class BMCcontroller {
  final String baseUrl = "http://$ip:4000/api/v1/businessCanva";

  Future<String?> _getToken() async {
    TokenController token = TokenController();
    return await token.getToken();
  }

  Future<Map<String, dynamic>?> addBusinessCanva({
    required String customerSegments,
    required String valuePropositions,
    required String channels,
    required String customerRelationships,
    required String revenueStreams,
    required String keyResources,
    required String keyActivities,
    required String keyPartners,
    required String costStructure,
  }) async {
    final savedToken =await _getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");


    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addBusinessCanva/67a4b85bdbe6cc6fd435b6f7'),
        headers: {'Content-Type': 'application/json',
          'token': tokenWithPrefix,},
        body: json.encode({
          'keyPartners': keyPartners,
          'keyActivities': keyActivities,
          'keyResources': keyResources,
          'valuePropositions': valuePropositions,
          'customerRelationships': customerRelationships,
          'channels': channels,
          'customerSegments': customerSegments,
          'costStructure': costStructure,
          'revenueStreams': revenueStreams,
        }),
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData.containsKey('saveIdea')) {
        return {'success': true, 'message': "BMC added successfully!"};
      } else {
        return {'success': false, 'message': responseData['message'] ?? "Failed to add BMC"};
      }
    } catch (error) {
      print('Error: $error');
      return {'success': false, 'message': "An error occurred"};
    }
    return null;
  }
 //getBusinessCanva
  Future<Map<String, dynamic>?> getBusinessCanva(String id) async {
    final savedToken = await _getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getBusinessCanva/67a4b85bdbe6cc6fd435b6f7'),
        headers: {
          'Content-Type': 'application/json',
          'token': tokenWithPrefix,
        },
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
          'message': "BMC retrieved successfully!",
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? "Failed to retrieve BMC",
        };
      }
    } catch (error) {
      print('Error: $error');
      return {'success': false, 'message': "An error occurred"};
    }
  }
  Future<Map<String, dynamic>?>updateBusinessCanva({
    required String projectId,
    required String customerSegments,
    required String valuePropositions,
    required String channels,
    required String customerRelationships,
    required String revenueStreams,
    required String keyResources,
    required String keyActivities,
    required String keyPartners,
    required String costStructure,
  }) async {
    final savedToken =await _getToken();
    if (savedToken == null || savedToken.isEmpty) {
      print("Error: Token is null or empty");
      return {'success': false, 'message': "Authentication token is missing"};
    }
    String tokenWithPrefix = 'token__$savedToken';
    print("token: ${tokenWithPrefix}");


    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/updateBusinessCanva/$projectId'),
        headers: {'Content-Type': 'application/json',
          'token': tokenWithPrefix,},
        body: json.encode({
          'keyPartners': keyPartners,
          'keyActivities': keyActivities,
          'keyResources': keyResources,
          'valuePropositions': valuePropositions,
          'customerRelationships': customerRelationships,
          'channels': channels,
          'customerSegments': customerSegments,
          'costStructure': costStructure,
          'revenueStreams': revenueStreams,
        }),
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData.containsKey('saveIdea')) {
        return {'success': true, 'message': "BMC added successfully!"};
      } else {
        return {'success': false, 'message': responseData['message'] ?? "Failed to add BMC"};
      }
    } catch (error) {
      print('Error: $error');
      return {'success': false, 'message': "An error occurred"};
    }
    return null;
  }

}