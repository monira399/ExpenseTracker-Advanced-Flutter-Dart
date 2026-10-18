Widget _buildTextField({
  required String hintText,
  required IconData prefixIcon,
  String? Function(String?)? validator,
  TextEditingController? controller,
  bool readOnly = false
}) {
  return TextFormField(
    readOnly: readOnly,
    controller: controller,
    validator: validator,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: Colors.grey,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: AppColors.primary,
        size: 21,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.secondary.withOpacity(0.25),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.secondary.withOpacity(0.25),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    ),
  );
}