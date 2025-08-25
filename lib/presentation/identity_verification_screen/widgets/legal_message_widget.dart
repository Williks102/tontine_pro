import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LegalMessageWidget extends StatefulWidget {
  final Function(bool) onAcknowledgmentChanged;

  const LegalMessageWidget({
    Key? key,
    required this.onAcknowledgmentChanged,
  }) : super(key: key);

  @override
  State<LegalMessageWidget> createState() => _LegalMessageWidgetState();
}

class _LegalMessageWidgetState extends State<LegalMessageWidget> {
  bool _isExpanded = false;
  bool _isAcknowledged = false;
  bool _hasReadFully = false;
  final ScrollController _scrollController = ScrollController();

  final String _legalMessage = """
DÉCLARATION LÉGALE ET CONDITIONS D'UTILISATION

En utilisant l'application Tontine Pro, vous acceptez les conditions suivantes :

1. RESPONSABILITÉ FINANCIÈRE
Vous confirmez être majeur(e) et capable juridiquement de participer à un système de tontine. Vous vous engagez à respecter les échéances de paiement selon le calendrier établi.

2. VÉRIFICATION D'IDENTITÉ
Les documents fournis (CNI/Passeport) sont authentiques et vous appartiennent. Toute falsification entraînera l'exclusion immédiate du système.

3. ENGAGEMENT FINANCIER
Votre participation implique un engagement financier ferme. Les pénalités de retard s'appliquent selon la formule établie dans le règlement.

4. CONFIDENTIALITÉ
Vos données personnelles sont protégées selon notre politique de confidentialité. Elles ne seront partagées qu'avec les partenaires de paiement autorisés.

5. RÈGLES DE GROUPE
Vous acceptez de respecter les règles de fonctionnement du groupe de tontine, incluant l'ordre de bénéficiaires et les modalités de distribution.

6. RÉSOLUTION DE CONFLITS
Tout litige sera résolu selon la législation en vigueur. Le service client est disponible pour médiation.

7. MODIFICATION DES CONDITIONS
Tontine Pro se réserve le droit de modifier ces conditions avec préavis de 30 jours.

En cochant la case ci-dessous, vous confirmez avoir lu, compris et accepté l'intégralité de ces conditions.
""";

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_hasReadFully) {
        setState(() {
          _hasReadFully = true;
        });
      }
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleAcknowledgment(bool? value) {
    if (!_hasReadFully && !_isExpanded) {
      // Show message to read fully first
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez lire l\'intégralité du message légal'),
          backgroundColor: AppTheme.getWarningColor(true),
        ),
      );
      return;
    }

    setState(() {
      _isAcknowledged = value ?? false;
    });
    widget.onAcknowledgmentChanged(_isAcknowledged);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isAcknowledged
              ? AppTheme.getSuccessColor(true)
              : AppTheme.lightTheme.colorScheme.outline,
          width: _isAcknowledged ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'gavel',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Déclaration légale',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _toggleExpanded,
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isExpanded ? 40 : 15,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Text(
                    _legalMessage,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      height: 1.5,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!_isExpanded && !_hasReadFully) ...[
            SizedBox(height: 2),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.getWarningColor(true),
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Cliquez sur "Développer" pour lire l\'intégralité du message légal',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getWarningColor(true),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 3),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _isAcknowledged
                  ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isAcknowledged
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _isAcknowledged,
                  onChanged: _toggleAcknowledgment,
                  activeColor: AppTheme.getSuccessColor(true),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _toggleAcknowledgment(!_isAcknowledged),
                    child: Text(
                      'J\'ai lu et j\'accepte l\'intégralité des conditions légales ci-dessus',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: _isAcknowledged
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_hasReadFully && !_isAcknowledged) ...[
            SizedBox(height: 2),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.getSuccessColor(true),
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Lecture complète effectuée. Vous pouvez maintenant cocher la case d\'acceptation.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getSuccessColor(true),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
