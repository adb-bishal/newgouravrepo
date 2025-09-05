import 'package:flutter/material.dart';

class CommonBottomSheet extends StatelessWidget {
  final String title;
  final String? description; // ✅ Optional info text
  final Widget child;
  final VoidCallback onApply;
  final VoidCallback onClear;
  final bool showApplyButton;

  const CommonBottomSheet({
    Key? key,
    required this.title,
    required this.child,
    required this.onApply,
    required this.onClear,
    this.description,
    this.showApplyButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              height: 6,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 12),

            // Title and CLEAR ALL
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3E3E3E),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: onClear,
                    child: const Text(
                      'CLEAR ALL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6464),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Optional Description Text
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Custom content area
            child,

            if (showApplyButton) ...[
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5855F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: onApply,
                  child: const Text(
                    'APPLY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],

            SizedBox(height: bottomPadding > 0 ? bottomPadding : 12),
          ],
        ),
      ),
    );
  }
}
