import 'package:flutter/material.dart';
import '../theme.dart';

/// Polished admin-only building blocks. Pure UI — no app logic.

/// Navy gradient welcome banner with a soft decorative motif and a date pill.
class AdminHero extends StatelessWidget {
  const AdminHero({super.key, required this.greeting, required this.headline, required this.caption, required this.dateLabel, this.icon = Icons.dashboard_rounded});
  final String greeting;
  final String headline;
  final String caption;
  final String dateLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(colors: [Color(0xFF2A2850), Color(0xFF1B1A33)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: const [BoxShadow(color: Color(0x2A201E3A), blurRadius: 18, offset: Offset(0, 8))],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -34,
            top: -42,
            child: Container(width: 170, height: 170, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05))),
          ),
          Positioned(
            right: 22,
            bottom: -46,
            child: Container(width: 110, height: 110, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.yellow.withValues(alpha: 0.10))),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.yellow.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(999)),
                      child: Text(dateLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.yellow, letterSpacing: 0.4)),
                    ),
                    const SizedBox(height: 10),
                    Text(greeting, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFB9B7D6))),
                    const SizedBox(height: 2),
                    Text(headline, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.6, height: 1.1)),
                    const SizedBox(height: 6),
                    Text(caption, style: const TextStyle(fontSize: 11.5, color: Color(0xFFB9B7D6), height: 1.4)),
                  ],
                ),
              ),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
                alignment: Alignment.center,
                child: Icon(icon, size: 22, color: AppColors.yellow),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Colorful stat tile with a tinted background and a small icon badge.
class AdminStatTile extends StatelessWidget {
  const AdminStatTile({super.key, required this.label, required this.value, required this.icon, required this.tint, required this.foreground, this.subtitle});
  final String label;
  final String value;
  final IconData icon;
  final Color tint;
  final Color foreground;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(18), border: Border.all(color: foreground.withValues(alpha: 0.12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: foreground),
              const SizedBox(width: 6),
              Expanded(child: Text(label.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1, color: foreground.withValues(alpha: 0.85)), overflow: TextOverflow.ellipsis)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, letterSpacing: -0.7, color: foreground), maxLines: 1, overflow: TextOverflow.ellipsis),
              if (subtitle != null) Text(subtitle!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: foreground.withValues(alpha: 0.75)), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tinted quick-action card with icon tile and arrow.
class AdminQuickCard extends StatelessWidget {
  const AdminQuickCard({super.key, required this.label, required this.icon, required this.tint, required this.foreground, required this.onTap});
  final String label;
  final IconData icon;
  final Color tint;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: tint,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(9)), alignment: Alignment.center, child: Icon(icon, size: 16, color: foreground)),
                const SizedBox(height: 12),
                Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: foreground), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Icon(Icons.arrow_upward_rounded, size: 13, color: foreground.withValues(alpha: 0.7)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Section header with a colored accent bar.
class AdminSectionTitle extends StatelessWidget {
  const AdminSectionTitle({super.key, required this.title, this.subtitle, this.action});
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 30, decoration: BoxDecoration(color: AppColors.yellowDeep, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: -0.2)),
              if (subtitle != null) Text(subtitle!, style: const TextStyle(fontSize: 11, color: AppColors.muted, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}
