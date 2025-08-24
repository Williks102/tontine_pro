import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

// Couleurs TONTINE PRO
class TontineColors {
  static const Color primaryPurple = Color(0xFF6B3AA0);
  static const Color lightPurple = Color(0xFF9C27B0);
  static const Color goldGradientStart = Color(0xFFFFD700);
  static const Color goldGradientMiddle = Color(0xFFFFA500);
  static const Color goldGradientEnd = Color(0xFFFF8C00);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color background = Color(0xFFF8F9FA);
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  
  // État
  File? _selectedImage;
  DateTime? _selectedDate;
  bool _accepteConditions = false;
  bool _isLoading = false;
  
  // Services
  final ImagePicker _picker = ImagePicker();
  
  // Animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _phoneController.dispose();
    _dateNaissanceController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Fonction pour prendre une photo
  Future<void> _showImageSourceDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Photo de profil',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: TontineColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                _buildImageOption(
                  icon: Icons.camera_alt,
                  title: 'Prendre un selfie',
                  subtitle: 'Utilisez la caméra',
                  color: TontineColors.primaryPurple,
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto(ImageSource.camera);
                  },
                ),
                SizedBox(height: 2.h),
                _buildImageOption(
                  icon: Icons.photo_library,
                  title: 'Choisir depuis la galerie',
                  subtitle: 'Sélectionner une photo existante',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto(ImageSource.gallery);
                  },
                ),
                if (_selectedImage != null) ...[
                  SizedBox(height: 2.h),
                  _buildImageOption(
                    icon: Icons.delete,
                    title: 'Supprimer la photo',
                    subtitle: 'Retirer la photo actuelle',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                  ),
                ],
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 6.w),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: TontineColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 4.w, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // Prendre une photo
  Future<void> _takePhoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.front, // Selfie par défaut
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        _showSuccessSnackBar('Photo ajoutée avec succès !');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de la prise de photo: $e');
    }
  }

  // Sélectionner la date de naissance
  Future<void> _selectDateNaissance() async {
    final DateTime now = DateTime.now();
    final DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
    final DateTime eightyYearsAgo = DateTime(now.year - 80, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: eighteenYearsAgo,
      firstDate: eightyYearsAgo,
      lastDate: eighteenYearsAgo,
      locale: const Locale('fr', 'FR'),
      helpText: 'Sélectionner votre date de naissance',
      fieldLabelText: 'Date de naissance',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TontineColors.primaryPurple,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateNaissanceController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Validation du formulaire
  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_selectedImage == null) {
      _showErrorSnackBar('Veuillez prendre une photo de profil (selfie)');
      return false;
    }

    if (_selectedDate == null) {
      _showErrorSnackBar('Veuillez sélectionner votre date de naissance');
      return false;
    }

    if (!_accepteConditions) {
      _showErrorSnackBar('Vous devez accepter les conditions générales');
      return false;
    }

    return true;
  }

  // Soumettre le formulaire
  Future<void> _submitForm() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulation de l'envoi des données
      await Future.delayed(const Duration(seconds: 3));

      // Création de l'objet inscription
      final inscriptionData = {
        'nom': _nomController.text.trim(),
        'prenom': _prenomController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dateNaissance': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'photo': _selectedImage!.path,
        'accepteConditions': _accepteConditions,
      };

      debugPrint('Données d\'inscription: $inscriptionData');

      if (mounted) {
        _showSuccessSnackBar('Inscription réussie ! Vérification OTP...');
        
        // Navigation vers la vérification d'identité (qui inclut OTP)
        await Future.delayed(const Duration(milliseconds: 1500));
        Navigator.pushReplacementNamed(
          context,
          '/identity-verification-screen',
        );
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'inscription: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 2.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 2.w),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: TontineColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: TontineColors.primaryPurple,
        ),
        child: SafeArea(
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // AppBar personnalisée
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Expanded(
                          child: Text(
                            'Inscription TONTINE PRO',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 12.w), // Pour centrer le titre
                      ],
                    ),
                  ),

                  // Contenu principal
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Note d'information
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      TontineColors.primaryPurple.withOpacity(0.1),
                                      TontineColors.lightPurple.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border(
                                    left: BorderSide(
                                      color: TontineColors.primaryPurple,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '📝 Après l\'inscription, vous pourrez choisir votre bulle de tontine selon vos préférences',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: TontineColors.primaryPurple,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),

                              // Photo de profil
                              Center(
                                child: GestureDetector(
                                  onTap: _showImageSourceDialog,
                                  child: Container(
                                    width: 28.w,
                                    height: 28.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _selectedImage != null 
                                          ? TontineColors.primaryPurple 
                                          : Colors.grey[300]!,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: TontineColors.primaryPurple.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: _selectedImage != null
                                      ? ClipOval(
                                          child: Image.file(
                                            _selectedImage!,
                                            width: 28.w,
                                            height: 28.w,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[100],
                                          ),
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 8.w,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),

                              // Bouton photo
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        TontineColors.goldGradientStart,
                                        TontineColors.goldGradientMiddle,
                                        TontineColors.goldGradientEnd,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: TontineColors.goldGradientMiddle.withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _showImageSourceDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: Text(
                                      _selectedImage != null ? 'Modifier la photo' : 'Prendre un selfie',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),

                              // Nom et Prénom
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _nomController,
                                      label: 'Nom',
                                      hint: 'Votre nom',
                                      icon: Icons.person_outline,
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Le nom est requis';
                                        }
                                        if (value.trim().length < 2) {
                                          return 'Le nom doit contenir au moins 2 caractères';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _prenomController,
                                      label: 'Prénom',
                                      hint: 'Votre prénom',
                                      icon: Icons.person_outline,
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'Le prénom est requis';
                                        }
                                        if (value.trim().length < 2) {
                                          return 'Le prénom doit contenir au moins 2 caractères';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3.h),

                              // Numéro de téléphone
                              _buildTextField(
                                controller: _phoneController,
                                label: 'Numéro de téléphone',
                                hint: '+225 XX XX XX XX XX',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[\d+\s-]')),
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Le numéro de téléphone est requis';
                                  }
                                  if (!RegExp(r'^(\+225|225)?[0-9\s-]{8,}$').hasMatch(value.trim())) {
                                    return 'Numéro de téléphone invalide';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  // Auto-formatage du numéro
                                  if (value.isNotEmpty && !value.startsWith('+225') && !value.startsWith('225')) {
                                    if (!value.startsWith('+')) {
                                      final newValue = '+225 $value';
                                      _phoneController.value = _phoneController.value.copyWith(
                                        text: newValue,
                                        selection: TextSelection.collapsed(offset: newValue.length),
                                      );
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 3.h),

                              // Date de naissance
                              _buildTextField(
                                controller: _dateNaissanceController,
                                label: 'Date de naissance',
                                hint: 'JJ/MM/AAAA',
                                icon: Icons.calendar_today_outlined,
                                readOnly: true,
                                onTap: _selectDateNaissance,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'La date de naissance est requise';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 4.h),

                              // Checkbox conditions
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Transform.scale(
                                    scale: 1.3,
                                    child: Checkbox(
                                      value: _accepteConditions,
                                      activeColor: TontineColors.primaryPurple,
                                      onChanged: (value) {
                                        setState(() {
                                          _accepteConditions = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _accepteConditions = !_accepteConditions;
                                        });
                                      },
                                      child: Text(
                                        'J\'ai lu et j\'accepte les Conditions Générales d\'utilisation de TONTINE PRO et je certifie que les informations fournies sont exactes.',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: TontineColors.textSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),

                              // Loading indicator
                              if (_isLoading) ...[
                                Center(
                                  child: Column(
                                    children: [
                                      const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          TontineColors.primaryPurple,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Inscription en cours...',
                                        style: TextStyle(
                                          color: TontineColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4.h),
                              ],

                              // Bouton d'inscription
                              Container(
                                height: 6.h,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      TontineColors.goldGradientStart,
                                      TontineColors.goldGradientMiddle,
                                      TontineColors.goldGradientEnd,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: TontineColors.goldGradientMiddle.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    _isLoading ? 'INSCRIPTION...' : 'S\'INSCRIRE',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label *',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: TontineColors.textPrimary,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: TontineColors.primaryPurple),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: TontineColors.primaryPurple,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
          style: TextStyle(
            fontSize: 14.sp,
            color: TontineColors.textPrimary,
          ),
        ),
      ],
    );
  }
}