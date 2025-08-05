// taxes_page.dart
import 'package:flutter/material.dart';

class TaxesPage extends StatelessWidget {
  const TaxesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();

  bool _askedIncome = false;
  bool _askedEmployerNPS = false;
  bool _askedDisabilityAllowance = false;
  double _income = 0;
  double _employerNPS = 0;
  bool _hasDisabilityAllowance = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      "👋 Welcome! I’ll help calculate your income tax under the *New Regime (FY 2024–25)*.\n\nPlease enter your *annual gross income* (in ₹).",
    );
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: false));
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });
  }

  void _handleSubmit(String text) {
    if (text.trim().isEmpty) return;

    _addUserMessage(text);

    if (!_askedIncome) {
      _income = double.tryParse(text.replaceAll(',', '')) ?? 0;
      _askedIncome = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        _addBotMessage(
          "🏢 Does your employer contribute to NPS? If yes, enter the annual amount. If not, reply 0.",
        );
      });
    } else if (!_askedEmployerNPS) {
      _employerNPS = double.tryParse(text.replaceAll(',', '')) ?? 0;
      _askedEmployerNPS = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        _addBotMessage(
          "♿ Do you receive a disability or transport allowance for a disability? (yes/no)",
        );
      });
    } else if (!_askedDisabilityAllowance) {
      _hasDisabilityAllowance = text.toLowerCase().contains("yes");
      _askedDisabilityAllowance = true;
      _showCalculation();
    } else {
      _addBotMessage("🔁 Restart the app to enter new values.");
    }

    _controller.clear();
  }

  void _showCalculation() {
    const double standardDeduction = 50000;
    double taxableIncome = _income - standardDeduction - _employerNPS;
    if (taxableIncome < 0) taxableIncome = 0;

    double baseTax = _calculateNewRegimeTax(taxableIncome);
    double cess = baseTax * 0.04;
    double totalTax = baseTax + cess;

    _addBotMessage("📊 Summary:");
    _addBotMessage("- Gross Income: ₹${_income.toStringAsFixed(0)}");
    _addBotMessage(
      "- Standard Deduction: ₹${standardDeduction.toStringAsFixed(0)}",
    );
    if (_employerNPS > 0) {
      _addBotMessage(
        "- Employer NPS Contribution: ₹${_employerNPS.toStringAsFixed(0)}",
      );
    }
    if (_hasDisabilityAllowance) {
      _addBotMessage(
        "- Transport/Disability Allowance: Exempted as per limits",
      );
    }
    _addBotMessage("- Taxable Income: ₹${taxableIncome.toStringAsFixed(0)}");

    _addBotMessage(
      _getDetailedSlabBreakdown(taxableIncome, baseTax, cess, totalTax),
    );

    if (_income <= 700000) {
      _addBotMessage(
        "🎉 You qualify for *Section 87A Rebate*! Final tax = ₹0.",
      );
    }
  }

  String _getDetailedSlabBreakdown(
    double income,
    double baseTax,
    double cess,
    double totalTax,
  ) {
    List<Map<String, dynamic>> slabs = [
      {'from': 0.0, 'to': 300000.0, 'rate': 0.0},
      {'from': 300000.0, 'to': 600000.0, 'rate': 0.05},
      {'from': 600000.0, 'to': 900000.0, 'rate': 0.10},
      {'from': 900000.0, 'to': 1200000.0, 'rate': 0.15},
      {'from': 1200000.0, 'to': 1500000.0, 'rate': 0.20},
      {'from': 1500000.0, 'to': double.infinity, 'rate': 0.30},
    ];

    String breakdown = "📉 Detailed Slab-wise Tax:\n";
    double total = 0;

    for (var slab in slabs) {
      double from = slab['from'];
      double to = slab['to'];
      double rate = slab['rate'];

      if (income <= from) break;

      double slabTax = ((income > to ? to : income) - from) * rate;
      total += slabTax;

      breakdown +=
          "- ₹${from.toInt()} to ₹${(income > to ? to : income).toInt()} @ ${(rate * 100).toInt()}% → ₹${slabTax.toStringAsFixed(0)}\n";
    }

    breakdown += "\nSubtotal Tax: ₹${baseTax.toStringAsFixed(0)}";
    breakdown += "\n+ 4% Cess: ₹${cess.toStringAsFixed(0)}";
    breakdown += "\n💰 Total Tax Payable: ₹${totalTax.toStringAsFixed(0)}";

    return breakdown;
  }

  double _calculateNewRegimeTax(double income) {
    double tax = 0;
    List<Map<String, dynamic>> slabs = [
      {'limit': 300000, 'rate': 0.0},
      {'limit': 600000, 'rate': 0.05},
      {'limit': 900000, 'rate': 0.10},
      {'limit': 1200000, 'rate': 0.15},
      {'limit': 1500000, 'rate': 0.20},
      {'limit': double.infinity, 'rate': 0.30},
    ];

    double lastLimit = 0;
    for (var slab in slabs) {
      double slabLimit = slab['limit'];
      double rate = slab['rate'];

      if (income <= lastLimit) break;

      double taxableInSlab =
          (income > slabLimit ? slabLimit : income) - lastLimit;
      tax += taxableInSlab * rate;
      lastLimit = slabLimit;
    }

    if (income <= 700000) return 0;
    return tax;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.blueAccent : Colors.grey[850],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _handleSubmit,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enter your response...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () => _handleSubmit(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}
