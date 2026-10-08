import 'package:expense_tracker/models/category_model.dart';
import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/provider/category_provider.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:expense_tracker/widgets/custom_button.dart';
import 'package:expense_tracker/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/data/category_icons.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatefulWidget {
  final bool isIncome;
  final CategoryModel? category;
  final TransactionModel? transaction;

  const AddCategoryScreen({
    super.key,
    required this.isIncome,
    this.category,
    this.transaction,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController controller = TextEditingController();

  IconData? selectedIcon;
  Color selectedColor = AppColors.primary;

  @override
  void initState() {
    super.initState();

    // Edit mode old data
    if (widget.category != null) {
      controller.text = widget.category!.name;
      selectedIcon = widget.category!.icon;
      selectedColor = widget.category!.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icons = widget.isIncome ? incomeIcons : expenseIcons;

    final bool isEdit = widget.category != null;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Category' : 'Add Category',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Category Name',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 10),

            CustomTextField(
              controller: controller,
              hintText: 'Enter category name',
              prefixIcon: Icons.category,
              height: 55,
              width: double.infinity,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: icons.length,

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),

                itemBuilder: (context, index) {
                  final icon = icons[index];

                  final bool isSelected = selectedIcon == icon;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.white,

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),

                      child: Icon(
                        icon,
                        size: 30,
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Consumer<CategoryProvider>(
              builder: (context, provider, _) {
                return CustomButton(
                  text: isEdit ? 'Update' : 'Add',
                  isLoading: provider.isLoading,

                  onPressed: () async {
                    // Prevent double click
                    if (provider.isLoading) return;

                    // Name Validation
                    if (controller.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter category name',
                          ),
                        ),
                      );
                      return;
                    }

                    // Icon Validation
                    if (selectedIcon == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select an Icon',
                          ),
                        ),
                      );
                      return;
                    }

                    // ================= ADD =================

                    if (!isEdit) {
                      final category = CategoryModel(
                        id: '',
                        name: controller.text.trim(),
                        icon: selectedIcon!,
                        color: selectedColor,
                        isIncome: widget.isIncome,
                      );

                      final success =
                      await provider.addCategory(category);

                      if (!context.mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Category added successfully',
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      }
                    }

                    // ================= UPDATE =================

                    else {
                      final updatedCategory = CategoryModel(
                        id: widget.category!.id,
                        name: controller.text.trim(),
                        icon: selectedIcon!,
                        color: selectedColor,
                        isIncome: widget.isIncome,
                      );

                      await provider.updateCategory(
                        updatedCategory,
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Category updated successfully',
                          ),
                        ),
                      );

                      Navigator.pop(context, true);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}