import 'package:flutter/material.dart';
import '../app_state.dart';
import '../db.dart';
import '../theme.dart';
import '../widgets.dart';
import 'admin_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key, required this.onOpenStalls, required this.onOpenAccounts, required this.onOpenReports});

  final VoidCallback onOpenStalls;
  final VoidCallback onOpenAccounts;
  final VoidCallback onOpenReports;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final campus = state.requiredCampus;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final ordersToday = state.ordersBetween(from: today, to: today);
        final salesToday = state.revenueOf(state.paymentsBetween(from: today, to: today));
        final claimed = ordersToday.where((o) => o.status == OrderStatus.claimed).length;
        final released = ordersToday.where((o) => o.status == OrderStatus.released).length;
        final noShow = ordersToday.isEmpty ? 0.0 : released / ordersToday.length * 100;

        final stalls = Database.stalls(campus.id, status: StallStatus.active);
        final salesByStall = <Stall, double>{};
        for (final s in stalls) {
          salesByStall[s] = state.revenueOf(state.paymentsBetween(stallId: s.id, from: today, to: today));
        }
        final maxSale = salesByStall.values.fold<double>(0, (a, b) => b > a ? b : a);
        final selling = salesByStall.entries.where((e) => e.value > 0).toList()..sort((a, b) => b.value.compareTo(a.value));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            actions: [
              IconButton(
                tooltip: 'Log out',
                icon: const Icon(Icons.logout_rounded),
                onPressed: () => AppState.instance.signOut(),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 26),
            children: [
              AdminHero(
                greeting: 'Canteen overview',
                headline: 'Good ${_timeOfDay(now)}, Admin',
                caption: 'A quick look at today’s orders, sales and pickup activity across the campus.',
                dateLabel: 'TODAY · ${shortDateYear(now)}',
              ),
              const SizedBox(height: 18),

              // Stat grid
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 100, crossAxisSpacing: 10, mainAxisSpacing: 10),
                children: [
                  AdminStatTile(label: 'Orders today', value: '${ordersToday.length}', icon: Icons.receipt_long_rounded, tint: AppColors.blueSoft, foreground: const Color(0xFF1D4ED8), subtitle: 'placed so far'),
                  AdminStatTile(label: 'Sales today', value: peso(salesToday), icon: Icons.payments_rounded, tint: AppColors.yellowSoft, foreground: AppColors.yellowOnSoft, subtitle: 'cash collected'),
                  AdminStatTile(label: 'Claimed', value: '$claimed', icon: Icons.verified_rounded, tint: AppColors.greenSoft, foreground: AppColors.greenDark, subtitle: 'handed over'),
                  AdminStatTile(label: 'No-shows', value: '${noShow.toStringAsFixed(0)}%', icon: Icons.event_busy_rounded, tint: noShow > 0 ? AppColors.redSoft : AppColors.pageSoft, foreground: noShow > 0 ? AppColors.redDark : AppColors.muted, subtitle: 'released orders'),
                ],
              ),
              const SizedBox(height: 22),

              // Quick actions
              const AdminSectionTitle(title: 'Quick actions', subtitle: 'Go straight to the tools you need'),
              const SizedBox(height: 10),
              Row(
                children: [
                  AdminQuickCard(label: 'Manage stalls', icon: Icons.storefront_rounded, tint: AppColors.yellowSoft, foreground: AppColors.yellowOnSoft, onTap: onOpenStalls),
                  const SizedBox(width: 8),
                  AdminQuickCard(label: 'Accounts', icon: Icons.group_rounded, tint: AppColors.greenSoft, foreground: AppColors.greenDark, onTap: onOpenAccounts),
                  const SizedBox(width: 8),
                  AdminQuickCard(label: 'Reports', icon: Icons.bar_chart_rounded, tint: AppColors.blueSoft, foreground: const Color(0xFF1D4ED8), onTap: onOpenReports),
                ],
              ),
              const SizedBox(height: 22),

              // Sales today by stall
              const AdminSectionTitle(title: 'Sales today by stall', subtitle: 'Collected cash, ranked by stall'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.line), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4))]),
                child: selling.isEmpty
                    ? const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('No sales yet today.', style: TextStyle(fontSize: 12.5, color: AppColors.muted)))
                    : Column(
                        children: [
                          for (final e in selling) ReportBar(label: e.key.name, valueLabel: peso(e.value), fraction: e.value / (maxSale == 0 ? 1 : maxSale), labelWidth: 120),
                        ],
                      ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.pageSoft, borderRadius: BorderRadius.circular(16)),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 16, color: AppColors.muted),
                    SizedBox(width: 10),
                    Expanded(child: Text('Cash is counted as earnings only when the stall marks an order claimed at pickup.', style: TextStyle(fontSize: 11, color: AppColors.muted, height: 1.4))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _timeOfDay(DateTime now) {
    final h = now.hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }
}
