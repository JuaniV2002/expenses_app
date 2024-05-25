import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            minimumYear: DateTime.now().year - 1,
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime newdate) {
              setState(() {
                _selectedDate = newdate;
              });
            },
          ),
        );
      },
    );
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please enter valid title, amount and date'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please enter valid title, amount and date'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _submitData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CupertinoTextField(
                          controller: _titleController,
                          maxLength: 50,
                          placeholder: 'Title',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: CupertinoTextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          placeholder: 'Amount',
                        ),
                      ),
                    ],
                  )
                else
                  CupertinoTextField(
                    controller: _titleController,
                    maxLength: 50,
                    placeholder: 'Title',
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      CupertinoButton(
                        child: Text(_selectedCategory.name.toUpperCase()),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                              title: const Text('Select Category'),
                              actions: Category.values.map((category) {
                                return CupertinoActionSheetAction(
                                  child: Text(category.name.toUpperCase()),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                );
                              }).toList(),
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('Cancel'),
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Icon(CupertinoIcons.calendar_badge_plus),
                              onPressed: _presentDatePicker,
                            )
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoTextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          placeholder: 'Amount',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Icon(CupertinoIcons.calendar_badge_plus),
                              onPressed: _presentDatePicker,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      CupertinoButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoButton.filled(
                        child: const Text('Add expense'),
                        onPressed: _submitData,
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      CupertinoButton(
                        child: Text(_selectedCategory.name.toUpperCase()),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                              title: const Text('Select Category'),
                              actions: Category.values.map((category) {
                                return CupertinoActionSheetAction(
                                  child: Text(category.name.toUpperCase()),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                );
                              }).toList(),
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('Cancel'),
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      CupertinoButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        height: 40, // Set the height to your desired value
                        child: CupertinoButton.filled(
                          padding: EdgeInsets.all(0), // Remove padding to fit in the container
                          child: Padding(
                            padding: const EdgeInsets.all(8.0), // Add padding to the text
                            child: const Text('Add expense'),
                          ),
                          onPressed: _submitData,
                        ),
                      )
                    ],
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
