import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/provider/transaction_provider.dart';
import 'package:expense_tracker/screens/categories_list_screen.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:expense_tracker/widgets/custom_button.dart';
import 'package:expense_tracker/widgets/custom_data/custom_selector_tile.dart';
import 'package:expense_tracker/widgets/custom_textfield.dart';
import 'package:expense_tracker/widgets/expense_income_toggle_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import 'package:provider/provider.dart';
import '../provider/category_provider.dart';
import '../utils/app_snackbar.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {

  TextEditingController _amountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSaving = false;

  bool isIncome = true;
  CategoryModel? selectedCategory;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    if( widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _noteController.text = widget.transaction!.note;

      isIncome = widget.transaction!.isIncome;
      selectedDate = widget.transaction!.date;

      Future.microtask((){
        final categoryProvider = context.read<CategoryProvider>();

        setState(() {
          selectedCategory = categoryProvider.getCategoryById(widget.transaction!.categoryId);
        });
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.transaction != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text(isEdit ?'Edit Transaction' : 'Add Transaction', style: Theme.of(context).textTheme.titleLarge)),
        
                  SizedBox(height: 20,),
        
                  ExpenseIncomeToggleBar(
                    onChanged: (value) {
                      setState(() {
                        isIncome = value;
                      });
                    },
                  ),
        
                  SizedBox(height: 20,),
        
                  Text('Amount'),
                  SizedBox(height: 10,),
                  CustomTextField(
                      keyboardType: TextInputType.number,
                      controller: _amountController,
                      hintText: 'Enter Amount',
                      prefixIcon: Icons.money,
                      height: 55,
                      width: double.infinity,
                      validator:(value) {
                        if(value == null || value.trim().isEmpty){
                          return 'Please enter amount';
                        }
                        return null;
                      },),
        
                  SizedBox(height: 20,),
        
                  Text('Title'),
                  SizedBox(height: 10,),
                  CustomTextField(
                      controller: _titleController,
                      hintText: 'Enter Title',
                      prefixIcon: Icons.title_outlined,
                      height: 55,
                      width: double.infinity,
                    validator:(value) {
                      if(value == null || value.trim().isEmpty){
                        return 'Please enter amount';
                      }
                      return null;
                    },),
        
                  SizedBox(height: 10,),
        
                  Text('Category'),
                  SizedBox(height: 10,),
                  CustomSelectorTile(
                      title: selectedCategory?.name ?? 'Category',
                      leadingIcon: selectedCategory?.icon ?? Icons.category_outlined,
                      trailingIcon: Icons.arrow_forward_ios_outlined,
                      onTap: () async{
                        final result = await Navigator.push<CategoryModel>(context, MaterialPageRoute(builder: (context) => CategoriesListScreen(isIncome: isIncome,),
                        ),
                        );
        
                        if(result != null) {
                          setState(() {
                            selectedCategory = result;
                          });
                        }
                      }
                  ),
        
                  SizedBox(height: 20,),
        
                  Text('Date'),
                  SizedBox(height: 10,),
                  CustomSelectorTile(
                      title: selectedDate == null
                      ? 'Select Date'
                      :DateFormat('dd MMM, yyyy'). format(selectedDate!),
        
                      leadingIcon: Icons.calendar_today_outlined,
                      trailingIcon: Icons.arrow_forward_ios_outlined,
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                            context: context,
                            initialDate:selectedDate ??  DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035));
        
                        if(pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      }
                  ),
        
                  SizedBox(height: 20,),
        
                  Text('Note (Optional)'),
                  SizedBox(height: 10,),
                 CustomTextField(
                     controller: _noteController,
                     maxLines: 4,
                     hintText: 'Write a note...',
                     height: 150,
                     width: double.infinity),
        
                  SizedBox(height: 20,),
        
                  Consumer<TransactionProvider>(
                    builder: (context, provider, _) {
                      return CustomButton(text:isEdit ? 'Update' : 'Save Transaction',
                          isLoading: provider.isLoading,
                          onPressed: () async {
                            if (provider.isLoading) return;

                            //Update
                            if (isEdit) {
                              final updateTransaction = TransactionModel(
                                id: widget.transaction!.id,
                                title: _titleController.text.trim(),
                                date: selectedDate!,
                                amount: double.parse(_amountController.text),
                                isIncome: isIncome,
                                categoryId: selectedCategory!.id,
                                note: _noteController.text.trim(),
                              );

                              final success = await provider.updateTransaction(
                                  updateTransaction);


                              if (!context.mounted) return;

                              if (success) {
                                showAppSnackBar(context: context,
                                    message: 'Transaction updated successfully');

                                Navigator.pop(context, true);
                              }
                            } else {
                              final transaction = TransactionModel(
                                id: '',
                                title: _titleController.text.trim(),
                                date: selectedDate!,
                                amount: double.parse(_amountController.text),
                                isIncome: isIncome,
                                categoryId: selectedCategory!.id,
                                note: _noteController.text.trim(),
                              );

                              final success = await provider.addTransaction(
                                  transaction);


                              if (!context.mounted) return;

                              if (success) {
                                showAppSnackBar(context: context,
                                    message: 'Transaction added successfully');

                                Navigator.pop(context);
                              }
                            }


                          }
                      );
                    }
                  ),
        
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }



  Future<void> _saveTransaction() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
        ),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final transaction = TransactionModel(
        id: widget.transaction?.id ?? '',
        title: _titleController.text.trim(),
        date: selectedDate!,
        amount: double.parse(
          _amountController.text.trim(),
        ),
        isIncome: isIncome,
        categoryId: selectedCategory!.id,
        note: _noteController.text.trim(),
      );

      if (widget.transaction != null) {
        await context
            .read<TransactionProvider>()
            .updateTransaction(transaction);
      } else {
        await context
            .read<TransactionProvider>()
            .addTransaction(transaction);
      }

      if (!mounted) return;

      showAppSnackBar(
        context: context,
        message: widget.transaction != null
            ? 'Transaction updated successfully!'
            : 'Transaction saved successfully!',
      );

      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;

      showAppSnackBar(
        context: context,
        message: 'Something went wrong: $e',
      );

      print('SAVE TRANSACTION ERROR: $e');

    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}


