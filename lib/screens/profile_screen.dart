import 'package:expense_tracker/provider/profile_provider.dart';
import 'package:expense_tracker/services/auth_service.dart';
import 'package:expense_tracker/utils/app_color.dart';
import 'package:expense_tracker/widgets/custom_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/transaction_provider.dart';
import '../provider/category_provider.dart';
import '../models/profile_model.dart';
import '../provider/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  Widget build(BuildContext context) {
    final user = AuthService().getCurrentUser();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:Text('Profile', style: Theme.of(context).textTheme.titleLarge)),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.15),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Consumer<ProfileProvider>(
                          builder: (context, provider, _) {
                            return CircleAvatar(
                              radius: 45,
                              backgroundImage: provider.selectedImage != null ? FileImage(provider.selectedImage!) : null,
                              backgroundColor:
                              AppColors.secondary.withOpacity(.7),
                              child: provider.selectedImage == null ?
                              const Icon(
                                Icons.person_outline,
                                size: 45,
                              )
                              : null
                            );
                          }
                        ),

                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            height: 28,
                            width: 28,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white,
                              width: 2)
                            ),
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){
                              context.read<ProfileProvider>().pickProfileImage();
                            } ,
                                icon: Icon(Icons.camera_alt, size: 15,color: Colors.white,)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Text(
                      user?.displayName ?? 'User',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      user?.email ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 18),

                    Container(
                      height: 45,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.green
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.green, ),
                            SizedBox(width: 10,),
                            Text('Edit Profile', style: TextStyle(
                              color: Colors.green
                            ),)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.08),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: profileMenuList.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: 72,
                    endIndent: 20,
                    color: AppColors.secondary.withOpacity(.15),
                  ),
                  itemBuilder: (context, index) {
                    final profileMenu = profileMenuList[index];

                    return ListTile(

                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: profileMenu.iconColor != null
                       ? profileMenu.iconColor!.withOpacity(0.1)
                        : AppColors.secondary.withOpacity(.1),
                        child: Icon(
                          profileMenu.icon,
                          color:profileMenu.iconColor ?? AppColors.primary,
                          size: 22,
                        ),
                      ),
                      title:
                      Text(
                        profileMenu.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: profileMenu.iconColor ?? Colors.black
                        ),
                      ),
                      subtitle:profileMenu.subTitle == null
                      ? null :
                      Text(profileMenu.subTitle!,style: GoogleFonts.poppins(
                        fontSize: 13
                      ),),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      onTap: () {
                        _onTapProfileMenu(profileMenu);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapProfileMenu(ProfileUserModel profileMenu) {
    if(profileMenu.isLogOut) {
      _showLogoutDialog();
      return;
    }
  }
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return CustomConfirmationDialog(
            title: 'LogOut',
            message: 'Do you want to logout?',
            confirmText: 'Logout',
            onConfirm: () async {
              await context.read<AuthProvider>().logOut();

              if(!mounted) return;

              context.read<TransactionProvider>().clearData();
              context.read<CategoryProvider>().clearData();

              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (predicate) => false);
            });
      },
    );
  }

}
