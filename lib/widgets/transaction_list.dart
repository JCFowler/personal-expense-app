import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionList;
  final Function deleteTransaction;

  TransactionList(this.transactionList, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transactionList.isEmpty
        ? LayoutBuilder(builder: (ctx, contraints) {
            return Column(
              children: [
                Text(
                  'No Transactions...',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 10),
                Container(
                  height: contraints.maxHeight * 0.8,
                  child: Image.asset(
                    'assets/images/waiting.png',
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(transactionList[index], deleteTransaction);
            },
            itemCount: transactionList.length,
          );
  }
}