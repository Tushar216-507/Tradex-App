import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  final double totalValue = 15234.56;
  final double todaysPL = 213.45;
  final double investedAmount = 13000.00;

  final List<Map<String, dynamic>> watchlist = [
    {"name": "Apple", "ticker": "AAPL", "price": 189.21, "change": 1.25},
    {"name": "Tesla", "ticker": "TSLA", "price": 712.34, "change": -2.13},
    {"name": "Amazon", "ticker": "AMZN", "price": 128.95, "change": 0.76},
    {"name": "Google", "ticker": "GOOGL", "price": 2741.96, "change": -1.58},
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPortfolioCard(),
          const SizedBox(height: 24),
          Text(
            "Watchlist",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children:
                watchlist.map((stock) => _buildWatchlistTile(stock)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF1E1E2E),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Portfolio Summary",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Value", style: _labelStyle()),
                Text(
                  "\$${totalValue.toStringAsFixed(2)}",
                  style: _valueStyle(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's P&L", style: _labelStyle()),
                Text(
                  "+\$${todaysPL.toStringAsFixed(2)}",
                  style: _valueStyle(color: Colors.greenAccent),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Invested Amount", style: _labelStyle()),
                Text(
                  "\$${investedAmount.toStringAsFixed(2)}",
                  style: _valueStyle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchlistTile(Map<String, dynamic> stock) {
    bool isUp = stock["change"] >= 0;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isUp ? Colors.green : Colors.red,
            radius: 6,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock["name"],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  stock["ticker"],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${stock["price"].toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${isUp ? "+" : ""}${stock["change"].toStringAsFixed(2)}%",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: isUp ? Colors.greenAccent : Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() {
    return GoogleFonts.poppins(fontSize: 14, color: Colors.white70);
  }

  TextStyle _valueStyle({Color color = Colors.white}) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}
