import 'package:expense_tracker/provider/transaction_provider.dart';
import 'package:expense_tracker/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/app_color.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TransactionProvider>().getTransaction();
    });
  }

  int isSelectedFilter = 0;
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    print('ALL TRANSACTIONS: ${provider.transactions.length}');

    final searchedTransactions =
    provider.searchTransactions(searchController.text);

    final today = provider.getTransactionsByDateAndType('today', isSelectedFilter, searchResult: searchedTransactions);
    final yesterday = provider.getTransactionsByDateAndType('yesterday', isSelectedFilter,searchResult: searchedTransactions);
    final older = provider.getTransactionsByDateAndType('older', isSelectedFilter, searchResult: searchedTransactions);


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchBar(
                controller: searchController,
                onChanged: (value) {
                  setState(() {

                  });
                },
                hintText: 'Search transaction...',
                hintStyle: WidgetStatePropertyAll(
                  GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),

                leading: const Icon(
                  Icons.search_rounded,
                  size: 22,
                ),

                trailing: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.tune_rounded,
                    ),
                  ),
                ],

                elevation: const WidgetStatePropertyAll(0),

                backgroundColor: WidgetStatePropertyAll(
                  AppColors.white,
                ),

                surfaceTintColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),

                shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
                  if (states.contains(WidgetState.focused)) {
                    return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    );
                  }

                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  );
                }),

                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),

                textStyle: WidgetStatePropertyAll(
                  GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // ==============Filter========= //

              Row(
                mainAxisSize: MainAxisSize.min,

                //All//
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        isSelectedFilter = 0;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelectedFilter == 0
                            ? AppColors.primary
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'All',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isSelectedFilter == 0
                                  ? AppColors.white
                                  : Colors.black87,
                            ),
                      ),
                    ),
                  ),

                  SizedBox(width: 2),

                  //Income//
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        isSelectedFilter = 1;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelectedFilter == 1
                            ? AppColors.primary
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Income',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isSelectedFilter == 1
                                  ? AppColors.white
                                  : Colors.black87,
                            ),
                      ),
                    ),
                  ),
                  //Expense//
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        isSelectedFilter = 2;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelectedFilter == 2
                            ? AppColors.primary
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Expense',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isSelectedFilter == 2
                                  ? AppColors.white
                                  : Colors.black87,
                            ),
                      ),
                    ),
                  ),

                ],
              ),

              SizedBox(height: 20,),
              //=======Today=====//

              if(today.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                    child: Text('Today', style: Theme.of(context).textTheme.titleMedium,)),

                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: today.length,
                    itemBuilder: (context, index) {
                      final transaction = today[index];
                      return TransactionCard(transaction: transaction);
                    })
              ],


              if(yesterday.isNotEmpty) ...[
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Yesterday',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: yesterday.length,
                    itemBuilder: (context, index) {
                      final transaction = yesterday[index];
                      return TransactionCard(transaction: transaction);
                    })
              ],


              if (older.isNotEmpty) ...[
                const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Older',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: older.length,
                    itemBuilder: (context, index) {
                      final transaction = older[index];
                      return TransactionCard(transaction: transaction);
                    })
              ]


            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
