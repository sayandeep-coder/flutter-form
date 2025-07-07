// score_card_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScoreCardScreen extends ConsumerStatefulWidget {
  const ScoreCardScreen({super.key});

  @override
  ConsumerState<ScoreCardScreen> createState() => _ScoreCardScreenState();
}

class _ScoreCardScreenState extends ConsumerState<ScoreCardScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> coachLabels = [
    for (int i = 1; i <= 13; i++) 'C$i',
  ];

  final List<Map<String, dynamic>> activities = [
    {
      'desc':
          'Toilet cleaning complete including pan with High Pressure Jet machine, cleaning/wiping of wash basin, mirror & shelves, Spraying of Air Freshener & Mosquito Repellant',
      'subs': ['T1', 'T2', 'T3', 'T4'],
    },
    {
      'desc':
          'Cleaning & wiping of outside washbasin, mirror & shelves in door way area',
      'subs': ['D1', 'D2'],
    },
    {
      'desc': 'Vestibule area',
      'subs': ['B1', 'B2'],
    },
    {
      'desc': 'Doorway area, between two toilets and footsteps.',
      'subs': ['D1', 'D2'],
    },
    {
      'desc': 'Disposal of collected waste from Coaches & AC Bins.',
      'subs': ['AC Bin'],
    },
  ];

  final List<String> tableColumns = ["T'let", ...List.generate(13, (i) => 'C${i + 1}')];

  final Map<String, Map<String, Map<String, int?>>> _scores = {};
  final Map<String, String?> _meta = {
    'workOrderNo': '',
    'date': '',
    'nameOfWork': '',
    'contractor': '',
    'supervisor': '',
    'designation': '',
    'inspectionDate': '',
    'trainNo': '',
    'arrivalTime': '',
    'departureTime': '',
    'coachesAttended': '',
    'totalCoaches': '',
  };
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    for (var activity in activities) {
      _scores[activity['desc']] = {};
      for (var sub in activity['subs'] as List<dynamic>) {
        _scores[activity['desc']]![sub] = {};
        for (var col in tableColumns) {
          _scores[activity['desc']]![sub]![col] = null;
        }
      }
    }
  }

  Widget _metaFieldInline(String label, String key, double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold)),
        SizedBox(
          width: width,
          child: TextFormField(
            style: const TextStyle(fontSize: 7),
            initialValue: _meta[key],
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 0),
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 1.2, color: Colors.black)),
            ),
            onChanged: (v) => _meta[key] = v,
          ),
        ),
      ],
    );
  }

  Widget _buildMetaFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _metaFieldInline('W.O.No:', 'workOrderNo', 80),
            const SizedBox(width: 16),
            _metaFieldInline('Date:', 'date', 80),
          ],
        ),
        const SizedBox(height: 4),
        _metaFieldInline('Name of Work:', 'nameOfWork', 120),
        const SizedBox(height: 4),
        _metaFieldInline('Name of Contractor:', 'contractor', 120),
        const SizedBox(height: 4),
        Row(
          children: [
            _metaFieldInline('Name of Supervisor:', 'supervisor', 80),
            const SizedBox(width: 16),
            _metaFieldInline('Designation:', 'designation', 80),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _metaFieldInline('Train No.:', 'trainNo', 60),
            const SizedBox(width: 16),
            _metaFieldInline('Arrival Time:', 'arrivalTime', 60),
            const SizedBox(width: 16),
            _metaFieldInline('Dep.Time:', 'departureTime', 60),
          ],
        ),
        const SizedBox(height: 4),
        _metaFieldInline('No. of Coaches attended by contractor:', 'coachesAttended', 120),
        const SizedBox(height: 4),
        _metaFieldInline('Total No. of Coaches in the train:', 'totalCoaches', 120),
      ],
    );
  }

  Widget _tableHeaderCell(String text, {double height = 40}) {
    return Container(
      height: height,
      width: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 0.7, color: Colors.black),
      ),
      child: FittedBox(
        child: Text(
          text,
          style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _scoreTableCell(String activity, String sub, String col) {
    var val = _scores[activity]?[sub]?[col];
    return Container(
      height: 28,
      width: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 0.7, color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: val,
          isDense: true,
          icon: const Icon(Icons.arrow_drop_down, size: 10),
          style: const TextStyle(fontSize: 10, color: Colors.black),
          dropdownColor: Colors.white,
          items: [null, ...List.generate(11, (i) => i)]
              .map((v) => DropdownMenuItem<int>(
                    value: v,
                    child: Center(
                      child: Text(
                        v?.toString() ?? '',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (v) {
            setState(() {
              _scores[activity]![sub]![col] = v;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTable() {
    List<TableRow> rows = [];

    rows.add(TableRow(
      decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
      children: [
        _tableHeaderCell('S\nN\nO'),
        _tableHeaderCell('Itemized Description\nof work', height: 40),
        ...tableColumns.map((c) => _tableHeaderCell(c)),
      ],
    ));

    int sn = 1;
    for (var activity in activities) {
      final subs = activity['subs'] as List<dynamic>;
      final desc = activity['desc'] as String;
      for (int i = 0; i < subs.length; i++) {
        List<Widget> rowCells = [];
        rowCells.add(i == 0
            ? Container(
                height: 28.0 * subs.length,
                width: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(width: 0.7, color: Colors.black)),
                child: Text(sn.toString(), style: const TextStyle(fontSize: 7), textAlign: TextAlign.center),
              )
            : Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(border: Border.all(width: 0.7, color: Colors.black)),
              ));
        rowCells.add(i == 0
            ? Container(
                height: 28.0 * subs.length,
                width: 120,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(border: Border.all(width: 0.7, color: Colors.black)),
                child: Text(desc, style: const TextStyle(fontSize: 7)),
              )
            : Container(
                height: 28,
                width: 120,
                decoration: BoxDecoration(border: Border.all(width: 0.7, color: Colors.black)),
              ));
        for (var col in tableColumns) {
          rowCells.add(_scoreTableCell(desc, subs[i], col));
        }
        rows.add(TableRow(children: rowCells));
      }
      sn++;
    }
    return Table(
      border: TableBorder.all(width: 0.7, color: Colors.black),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const FixedColumnWidth(28),
        1: const FixedColumnWidth(120),
        for (int i = 2; i < 16; i++) i: const FixedColumnWidth(28),
      },
      children: rows,
    );
  }

  void _submit() async {
    setState(() => _submitting = true);

    // Prepare the data
    final data = {
      'meta': _meta,
      'scores': _scores,
    };

    // Send POST request
    final response = await http.post(
      Uri.parse(''), // your api
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    setState(() => _submitting = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: \\${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Card', style: TextStyle(fontSize: 13)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 32,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('Annexure-09 of ITT', style: TextStyle(fontSize: 10)),
                        Text('"CLEAN TRAIN STATION"', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('FOR THROUGH PASSED TRAINS', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 1.2),
                const SizedBox(height: 2),
                const Center(
                  child: Text(
                    '... RAILWAY ...',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(height: 2),
                const Center(
                  child: Text(
                    'SCORE CARD (TO BE FILLED BY THE RAILWAY SUPERVISOR / CTS INSPECTOR)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const Divider(thickness: 1.2, height: 12),
                const SizedBox(height: 4),
                _buildMetaFields(),
                const SizedBox(height: 8),
                const Text('CLEAN TRAIN STATION ACTIVITIES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildTable(),
                ),
                const SizedBox(height: 8),
                // Footer notes and signature lines
                Row(children: [
                  Expanded(child: Text('Total Scores obtained: %', style: TextStyle(fontSize: 10))),
                  Expanded(child: Text('Inaccessible: x', style: TextStyle(fontSize: 10))),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: Divider(thickness: 1)),
                  Expanded(child: Divider(thickness: 1)),
                ]),
                Row(children: [
                  Expanded(child: Text('Signature of Contractor’s Supervisor', style: TextStyle(fontSize: 10))),
                  Expanded(child: Text('Signature of Railway Supervisor', style: TextStyle(fontSize: 10))),
                ]),
                const SizedBox(height: 8),
                const Text(
                  'Note:  Please give marks for each item on a scale 0 or 1.  All items as above which are inaccessible should be marked “X” and shall not be counted in total score.  No column should be left blank.',
                  style: TextStyle(fontSize: 8, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8),
                const Text(
                  'N.B.- The above scorecard is indicative only. Original scorecard format will be circulated by Railway Administration before commencement of the work.',
                  style: TextStyle(fontSize: 8, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8),
                const Center(child: Text('Page 31 of 31', style: TextStyle(fontSize: 8))),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Submit', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
