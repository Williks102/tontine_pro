import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TermsAndReferralSection extends StatelessWidget {
  final bool acceptedTerms;
  final Function(bool?) onTermsChanged;
  final TextEditingController referralCodeController;
  final String? referralCodeError;
  final Function(String) onReferralCodeChanged;

  const TermsAndReferralSection({
    super.key,
    required this.acceptedTerms,
    required this.onTermsChanged,
    required this.referralCodeController,
    this.referralCodeError,
    required this.onReferralCodeChanged,
  });

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 80,
            maxWidth: 90,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Conditions Générales d\'Utilisation',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: Colors.white,
                        size: 5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTermsSection(
                        'Article 1 - Objet',
                        'Les présentes conditions générales d\'utilisation régissent l\'utilisation de l\'application Tontine Pro, plateforme digitale de gestion de tontines et d\'épargne collective.',
                      ),
                      _buildTermsSection(
                        'Article 2 - Inscription et Compte Utilisateur',
                        'L\'inscription nécessite la fourniture d\'informations exactes et complètes. L\'utilisateur s\'engage à maintenir la confidentialité de ses identifiants de connexion.',
                      ),
                      _buildTermsSection(
                        'Article 3 - Services Proposés',
                        'Tontine Pro propose des services de gestion de groupes d\'épargne, de suivi des contributions, de notifications automatiques et de gestion des bénéficiaires selon les formules d\'abonnement.',
                      ),
                      _buildTermsSection(
                        'Article 4 - Obligations de l\'Utilisateur',
                        'L\'utilisateur s\'engage à respecter les règles de fonctionnement des groupes, à effectuer ses contributions dans les délais impartis et à ne pas perturber le bon fonctionnement de la plateforme.',
                      ),
                      _buildTermsSection(
                        'Article 5 - Paiements et Contributions',
                        'Les contributions sont effectuées selon les cycles définis. Les retards de paiement peuvent entraîner des pénalités calculées selon la formule établie dans le règlement du groupe.',
                      ),
                      _buildTermsSection(
                        'Article 6 - Protection des Données',
                        'Tontine Pro s\'engage à protéger les données personnelles conformément à la réglementation en vigueur. Les informations collectées sont utilisées uniquement dans le cadre du service.',
                      ),
                      _buildTermsSection(
                        'Article 7 - Responsabilité',
                        'Tontine Pro facilite la gestion des tontines mais n\'est pas responsable des défaillances individuelles des membres ou des litiges entre participants.',
                      ),
                      _buildTermsSection(
                        'Article 8 - Résiliation',
                        'L\'utilisateur peut résilier son compte à tout moment. La résiliation n\'affecte pas les engagements en cours dans les groupes actifs.',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('J\'ai lu et compris'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1),
        Text(
          content,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            height: 1.4,
          ),
        ),
        SizedBox(height: 2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Finalisation',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 3),

          // Terms and Conditions
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: acceptedTerms
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: acceptedTerms,
                      onChanged: onTermsChanged,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showTermsDialog(context),
                        child: RichText(
                          text: TextSpan(
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                            children: [
                              TextSpan(text: 'J\'accepte les '),
                              TextSpan(
                                text: 'Conditions Générales d\'Utilisation',
                                style: TextStyle(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' de Tontine Pro *'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!acceptedTerms)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 1),
                    child: Text(
                      'Vous devez accepter les conditions pour continuer',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: 3),

          // Referral Code Section
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondaryContainer
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'card_giftcard',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 5,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Code de parrainage (optionnel)',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                TextFormField(
                  controller: referralCodeController,
                  onChanged: onReferralCodeChanged,
                  decoration: InputDecoration(
                    labelText: 'Code de parrainage',
                    hintText: 'Entrez le code si vous en avez un',
                    errorText: referralCodeError,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'confirmation_number',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 5,
                      ),
                    ),
                    suffixIcon: referralCodeController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              referralCodeController.clear();
                              onReferralCodeChanged('');
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 5,
                            ),
                          )
                        : null,
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                SizedBox(height: 1),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 4,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Bénéficiez d\'avantages exclusifs en utilisant un code de parrainage valide',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
