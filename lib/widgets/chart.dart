import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupTransactions {
    return List.generate(
      7,
      (index) {
        final day = DateTime.now().subtract(Duration(days: index));
        int totalAmount = 0;

        for (var i = 0; i < recentTransactions.length; i++) {
          if (day.day == recentTransactions[i].date.day &&
              day.month == recentTransactions[i].date.month &&
              day.year == recentTransactions[i].date.year) {
            totalAmount += recentTransactions[i].amount;
          }
        }

        return {
          'day': DateFormat.E().format(day).substring(0, 1),
          'amount': totalAmount
        };
      },
    ).reversed.toList();
  }

  int get totalSpending {
    return groupTransactions.fold(
      0,
      (previousValue, element) {
        return previousValue + (element['amount'] as int);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupTransactions.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'] as String,
                data['amount'] as int,
                totalSpending == 0 ? 0 : (data['amount'] as int) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
