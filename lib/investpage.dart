import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class Prediction {
  final String stock;
  final String recommendation;
  final double confidence;

  Prediction({
    required this.stock,
    required this.recommendation,
    required this.confidence,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      stock: json['stock'],
      recommendation: json['recommendation'],
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}

class InvestPage extends StatefulWidget {
  const InvestPage({super.key});

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  List<Prediction> predictions = [];
  bool isLoading = true;
  bool hasError = false;

  final String baseUrl = "http://192.168.1.105:8000"; // Update for real backend

  @override
  void initState() {
    super.initState();
    fetchPredictions();
  }

  Future<void> fetchPredictions() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/predictions'));
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        setState(() {
          predictions = data.map((e) => Prediction.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        title: Text("AI-Based Stock Predictions", style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                ? Center(
                  child: Text(
                    "❌ Failed to fetch predictions.",
                    style: GoogleFonts.poppins(color: Colors.redAccent),
                  ),
                )
                : predictions.isEmpty
                ? Center(
                  child: Text(
                    "No predictions available.",
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                )
                : ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    final p = predictions[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A3D),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            color:
                                p.recommendation == "BUY"
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.stock,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  p.recommendation,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color:
                                        p.recommendation == "BUY"
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Conf: ${p.confidence.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
