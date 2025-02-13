import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';



import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static Future<void> sendOrderEmail(Map<String, dynamic> orderData) async {
    String username = "praveenso776@gmail.com"; // Your Email
    String password = "embt vyjh rela ltmr"; // App Password if 2FA is enabled

    final smtpServer = gmail(username, password);

    // Extract order details
    String orderId = orderData['orderId'];
    String totalAmount = orderData['totalAmount'];
    String userEmail = orderData['userEmail'];
    String userName = orderData['userName'];
    String userPhone = orderData['userPhone'];
    String payementID = orderData['payementID'];
    List<Map<String, dynamic>> orderItems = List<Map<String, dynamic>>.from(orderData['order_item']);

    // Build order items table in HTML format
    String orderItemsTable = '''
    <table border="0" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%; max-width: 600px; margin: 0 auto; font-family: Arial, sans-serif;">
      <tr>
        <th style="background-color: #f8f9fa; padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Image</th>
        <th style="background-color: #f8f9fa; padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Title</th>
        <th style="background-color: #f8f9fa; padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Quantity</th>
        <th style="background-color: #f8f9fa; padding: 12px; text-align: left; border-bottom: 2px solid #ddd;">Price</th>
      </tr>
    ''';

    for (var item in orderItems) {
      orderItemsTable += '''
      <tr>
        <td style="padding: 12px; text-align: left; border-bottom: 1px solid #ddd;"><img src="${item['image']}" alt="${item['title']}" width="50" height="50" style="border-radius: 4px;"></td>
        <td style="padding: 12px; text-align: left; border-bottom: 1px solid #ddd;">${item['title']}</td>
        <td style="padding: 12px; text-align: left; border-bottom: 1px solid #ddd;">${item['quantity']}</td>
        <td style="padding: 12px; text-align: left; border-bottom: 1px solid #ddd;">\$${item['price']}</td>
      </tr>
      ''';
    }

    orderItemsTable += '</table>';

    final message = Message()
      ..from = Address(username, 'HALAL EMPIRE')
      ..recipients.add("praveenso776@gmail.com") // Send email to user
      ..bccRecipients.add("praveenso776@gmail.com") // BCC for record
      ..subject = 'Order Confirmation - $orderId'
      ..html = '''
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Order Confirmation</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              background-color: #f8f9fa;
              margin: 0;
              padding: 0;
            }
            .email-container {
              max-width: 600px;
              margin: 0 auto;
              background-color: #ffffff;
              border-radius: 8px;
              overflow: hidden;
              box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .email-header {
              background-color: #007bff;
              color: #ffffff;
              padding: 20px;
              text-align: center;
            }
            .email-body {
              padding: 20px;
              color: #333333;
            }
            .email-footer {
              background-color: #f8f9fa;
              padding: 20px;
              text-align: center;
              font-size: 14px;
              color: #666666;
            }
            .order-details {
              margin-bottom: 20px;
            }
            .order-details h3 {
              margin-top: 0;
              color: #007bff;
            }
            .order-details p {
              margin: 5px 0;
            }
            .order-items {
              margin-top: 20px;
            }
          </style>
        </head>
        <body>
          <div class="email-container">
            <div class="email-header">
              <h1>Order Confirmation</h1>
            </div>
            <div class="email-body">
              <div class="order-details">
                <p>Dear $userName,</p>
                <p>Thank you for your order! Here are your order details:</p>
                <h3>Order ID: <b>$orderId</b></h3>
                <p><b>Total Amount:</b> \$${totalAmount}</p>
                <p><b>Phone:</b> $userPhone</p> 
                <p><b>PaymentID:</b> $payementID</p>
              </div>
              <div class="order-items">
                <h3>Items Ordered:</h3>
                $orderItemsTable
              </div>
              <p>We appreciate your business and will notify you once your order is shipped.</p>
              <p>Thank you!</p>
            </div>
            <div class="email-footer">
              <p>&copy; 2023 HALAL EMPIRE. All rights reserved.</p>
            </div>
          </div>
        </body>
        </html>
      ''';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}




