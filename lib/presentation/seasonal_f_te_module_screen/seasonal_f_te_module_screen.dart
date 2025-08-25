import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/enrollment_progress_widget.dart';
import './widgets/gift_package_carousel_widget.dart';
import './widgets/participation_card_widget.dart';
import './widgets/pickup_scheduling_widget.dart';
import './widgets/seasonal_header_widget.dart';
import '../../widgets/tontine_main_drawer.dart';

class SeasonalFTeModuleScreen extends StatefulWidget {
  const SeasonalFTeModuleScreen({Key? key}) : super(key: key);

  @override
  State<SeasonalFTeModuleScreen> createState() =>
      _SeasonalFTeModuleScreenState();
}

class _SeasonalFTeModuleScreenState extends State<SeasonalFTeModuleScreen> {
  bool _isEnrolled = false;
  Map<String, dynamic>? _selectedGiftPackage;
  Map<String, dynamic>? _selectedPickupSlot;

  // Mock data for seasonal module
  final List<Map<String, dynamic>> _giftPackages = [
    {
      "id": 1,
      "name": "Package Tabaski Premium",
      "description":
          "Mouton de qualité supérieure, vêtements traditionnels, et accessoires de fête",
      "image":
          "https://images.pexels.com/photos/5490778/pexels-photo-5490778.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "estimatedValue": "25 000 FCFA",
      "items": ["Mouton", "Boubou", "Chaussures", "Parfum"],
    },
    {
      "id": 2,
      "name": "Package Famille Tabaski",
      "description":
          "Ensemble complet pour toute la famille avec vêtements et accessoires",
      "image":
          "https://images.pexels.com/photos/6069112/pexels-photo-6069112.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "estimatedValue": "18 000 FCFA",
      "items": ["Vêtements famille", "Chaussures", "Bijoux", "Sacs"],
    },
    {
      "id": 3,
      "name": "Package Enfants Tabaski",
      "description":
          "Spécialement conçu pour les enfants avec jouets et vêtements",
      "image":
          "https://images.pexels.com/photos/1620760/pexels-photo-1620760.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "estimatedValue": "12 000 FCFA",
      "items": ["Vêtements enfants", "Jouets", "Chaussures", "Livres"],
    },
  ];

  final List<Map<String, dynamic>> _availableSlots = [
    {
      "id": 1,
      "location": "Centre Commercial Dakar Plaza",
      "date": "15 Juin 2024",
      "timeSlot": "09:00 - 12:00",
      "availableSpots": 25,
      "address": "Avenue Cheikh Anta Diop, Dakar",
    },
    {
      "id": 2,
      "location": "Marché Sandaga",
      "date": "16 Juin 2024",
      "timeSlot": "14:00 - 17:00",
      "availableSpots": 18,
      "address": "Place Sandaga, Dakar",
    },
    {
      "id": 3,
      "location": "Centre Culturel Blaise Senghor",
      "date": "17 Juin 2024",
      "timeSlot": "10:00 - 13:00",
      "availableSpots": 30,
      "address": "Rue Daniel Sorano, Dakar",
    },
  ];

  final List<Map<String, dynamic>> _recentParticipants = [
    {
      "id": 1,
      "name": "Aminata",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": 2,
      "name": "Moussa",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": 3,
      "name": "Fatou",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": 4,
      "name": "Ibrahim",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "id": 5,
      "name": "Aissatou",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
  ];

  void _handleEnrollmentToggle(bool isEnrolled) {
    setState(() {
      _isEnrolled = isEnrolled;
    });

    if (isEnrolled) {
      Fluttertoast.showToast(
        msg: "Participation activée avec succès!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: Colors.white,
      );
    } else {
      setState(() {
        _selectedGiftPackage = null;
        _selectedPickupSlot = null;
      });
      Fluttertoast.showToast(
        msg: "Participation désactivée",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey.shade600,
        textColor: Colors.white,
      );
    }
  }

  void _handlePayment() {
    if (!_isEnrolled) {
      Fluttertoast.showToast(
        msg: "Veuillez d'abord activer la participation",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    _showPaymentDialog();
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'payment',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 25,
              ),
              SizedBox(width: 2.w),
              Text(
                'Paiement Sécurisé',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Column(
                  children: [
                    Text(
                      'Montant à payer',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 1),
                    Text(
                      '4 200 FCFA',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Choisissez votre méthode de paiement:',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              _buildPaymentOption(
                  'Orange Money', 'phone_android', Colors.orange),
              SizedBox(height: 1),
              _buildPaymentOption(
                  'Wave', 'account_balance_wallet', Colors.blue),
              SizedBox(height: 1),
              _buildPaymentOption(
                  'Carte Bancaire', 'credit_card', Colors.green),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Annuler',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOption(String title, String iconName, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        _processPayment(title);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(String paymentMethod) {
    // Simulate payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 2),
              Text(
                'Traitement du paiement...',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
        );
      },
    );

    // Simulate payment delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close loading dialog

      Fluttertoast.showToast(
        msg: "Paiement effectué avec succès via $paymentMethod!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    });
  }

  void _handlePackageSelect(Map<String, dynamic> package) {
    setState(() {
      _selectedGiftPackage = package;
    });

    _showPackageDetailsDialog(package);
  }

  void _showPackageDetailsDialog(Map<String, dynamic> package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            package["name"] as String,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2.w),
                child: CustomImageWidget(
                  imageUrl: package["image"] as String,
                  width: double.infinity,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 2),
              Text(
                package["description"] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2),
              Text(
                'Contenu du package:',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1),
              ...(package["items"] as List).map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 0.5),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: Colors.green,
                          size: 4,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          item as String,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 2),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Text(
                  'Valeur estimée: ${package["estimatedValue"]}',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Fermer',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                  msg: "Package sélectionné: ${package["name"]}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  textColor: Colors.white,
                );
              },
              child: const Text('Sélectionner'),
            ),
          ],
        );
      },
    );
  }

  void _handleSlotSelect(Map<String, dynamic> slot) {
    setState(() {
      _selectedPickupSlot = slot;
    });

    Fluttertoast.showToast(
      msg: "Créneau sélectionné: ${slot["location"]}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deadlineDate = DateTime.now().add(const Duration(days: 12, hours: 8));
    final userProfile = {
    'name': 'Marie Kouassi',
    'id': 'TN-001', 
    'avatar': 'https://via.placeholder.com/150',
    'status': 'active',
  };

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,

  drawer: TontineMainDrawer(
  userProfile: userProfile,
  currentSelectedIndex: 2, // 2 = Groupes, 3 = Parrainages, etc.
),

      appBar: AppBar(
        title: Text(
          'Module Fête Saisonnière',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard-screen');
            },
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 25,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2),
            SeasonalHeaderWidget(
              seasonName: 'Tabaski 2024',
              deadlineDate: deadlineDate,
              enrolledCount: 147,
              totalCapacity: 200,
            ),
            SizedBox(height: 2),
            ParticipationCardWidget(
              isEnrolled: _isEnrolled,
              onEnrollmentToggle: _handleEnrollmentToggle,
              onPayment: _handlePayment,
            ),
            SizedBox(height: 2),
            GiftPackageCarouselWidget(
              giftPackages: _giftPackages,
              onPackageSelect: _handlePackageSelect,
            ),
            SizedBox(height: 2),
            EnrollmentProgressWidget(
              currentEnrollment: 147,
              targetEnrollment: 200,
              recentParticipants: _recentParticipants,
            ),
            SizedBox(height: 2),
            PickupSchedulingWidget(
              availableSlots: _availableSlots,
              onSlotSelect: _handleSlotSelect,
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
      bottomNavigationBar: _isEnrolled &&
              _selectedGiftPackage != null &&
              _selectedPickupSlot != null
          ? Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color: Colors.green,
                                size: 25,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Confirmation',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Votre participation à la Fête Tabaski 2024 est confirmée!',
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 2),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(2.w),
                                  border:
                                      Border.all(color: Colors.green.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Récapitulatif:',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      '• Package: ${_selectedGiftPackage!["name"]}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                    Text(
                                      '• Retrait: ${_selectedPickupSlot!["location"]}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                    Text(
                                      '• Date: ${_selectedPickupSlot!["date"]}',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                  msg:
                                      "Participation confirmée! Vous recevrez des rappels.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                );
                              },
                              child: const Text('Parfait!'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'celebration',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Confirmer ma Participation',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
