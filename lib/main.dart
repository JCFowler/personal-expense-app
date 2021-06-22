import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'widgets/transaction_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.orange,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _showChart = true;
  final List<Transaction> _transactionList = [
    // Transaction(
    //   id: 'id1',
    //   title: 'Shones',
    //   amount: 6900,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 'id2',
    //   title: 'Food',
    //   amount: 3200,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _transactionList.where(
      (tx) {
        return tx.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  void _addTransaction(String title, int amount, DateTime date) {
    setState(() {
      _transactionList.add(
        Transaction(
          id: DateTime.now().toString(),
          title: title,
          amount: amount,
          date: date,
        ),
      );
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactionList.removeWhere((element) => element.id == id);
    });
  }

  void _startAddTrasaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addTransaction);
      },
    );
  }

  void _chartVisibilityTapped() {
    print('Hi');
    print(_showChart);
    setState(() {
      _showChart = !_showChart;
    });
  }

  List<Widget> _buildLandscape(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget transactionListWidget) {
    return [
      if(_showChart) Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: Chart(
          _recentTransactions,
        ),
      ),
      transactionListWidget,
    ];
  }

  List<Widget> _buildProtrait(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget transactionListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      transactionListWidget
    ];
  }

  PreferredSizeWidget _buildIOSAppBar(bool isLandscape) {
    return CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLandscape)
                  GestureDetector(
                    onTap: _chartVisibilityTapped,
                    child: _showChart
                        ? Icon(
                            Icons.visibility,
                          )
                        : Icon(
                            Icons.visibility_off,
                          ),
                  ),
                SizedBox(width: 10),
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddTrasaction(context),
                )
              ],
            ),
          );
  }

  PreferredSizeWidget _buildAndroidAppBar(bool isLandscape) {
    return AppBar(
            title: Text('Personal Expenses'),
            actions: [
              if (isLandscape)
                IconButton(
                  onPressed: _chartVisibilityTapped,
                  icon: _showChart
                      ? Icon(
                          Icons.visibility,
                        )
                      : Icon(
                          Icons.visibility_off,
                        ),
                ),
              IconButton(
                onPressed: () => _startAddTrasaction(context),
                icon: Icon(
                  Icons.add,
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = Platform.isIOS
        ? _buildIOSAppBar(isLandscape)
        : _buildAndroidAppBar(isLandscape);
    final transactionListWidget = Center(
      child: Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_transactionList, _deleteTransaction),
      ),
    );
    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (!isLandscape)
              ..._buildProtrait(mediaQuery, appBar, transactionListWidget),
            if (isLandscape)
              ..._buildLandscape(mediaQuery, appBar, transactionListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddTrasaction(context),
                  ),
          );
  }
}
