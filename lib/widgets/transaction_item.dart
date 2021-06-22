import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transactionItem;
  final Function deleteTransaction;

  const TransactionItem(this.transactionItem, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '¥${transactionItem.amount}',
              ),
            ),
          ),
        ),
        title: Text(
          transactionItem.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transactionItem.date),
        ),
        trailing: MediaQuery.of(context).size.width > 360
            ? TextButton.icon(
                onPressed: () => deleteTransaction(transactionItem.id),
                icon: Icon(Icons.delete),
                label: Text('Delete'),
              )
            : IconButton(
                color: Theme.of(context).errorColor,
                onPressed: () => deleteTransaction(transactionItem.id),
                icon: Icon(Icons.delete),
              ),
      ),
    );
  }
}
