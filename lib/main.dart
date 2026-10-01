import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

Future<void> generateAndPrintPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();
  
  pw.MemoryImage? pdfImage;
  if (data['imagePath'] != null && data['imagePath'].isNotEmpty) {
    final imageFile = File(data['imagePath']);
    if (imageFile.existsSync()) {
      pdfImage = pw.MemoryImage(imageFile.readAsBytesSync());
    }
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Laporan Visit Toko Vape', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                  pw.Text(
                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
            
            // FOTO DI ATAS
            if (pdfImage != null) ...[
              pw.Text('Lampiran Foto', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Container(
                height: 250, // Dibatasi tinggi maksimal agar tidak memakan seluruh kertas
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 2),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.ClipRRect(
                  horizontalRadius: 6,
                  verticalRadius: 6,
                  child: pw.Image(pdfImage, fit: pw.BoxFit.cover),
                ),
              ),
              pw.SizedBox(height: 16),
            ],

            // DATA TOKO
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Informasi Toko', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(color: PdfColors.grey400),
                  pw.SizedBox(height: 4),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Nama Toko:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12))),
                    pw.Expanded(flex: 2, child: pw.Text('${data['storeName'] ?? '-'}', style: const pw.TextStyle(fontSize: 12))),
                  ]),
                  pw.SizedBox(height: 2),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Owner:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12))),
                    pw.Expanded(flex: 2, child: pw.Text('${data['ownerName'] ?? '-'}', style: const pw.TextStyle(fontSize: 12))),
                  ]),
                  pw.SizedBox(height: 2),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('PIC:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12))),
                    pw.Expanded(flex: 2, child: pw.Text('${data['picName'] ?? '-'}', style: const pw.TextStyle(fontSize: 12))),
                  ]),
                  pw.SizedBox(height: 2),
                  pw.Row(children: [
                    pw.Expanded(child: pw.Text('Alamat:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12))),
                    pw.Expanded(flex: 2, child: pw.Text('${data['address'] ?? '-'}', style: const pw.TextStyle(fontSize: 12))),
                  ]),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            // DATA INVENTORY
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Data Produk / Inventory', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Divider(color: PdfColors.blue200),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('VOLX: ${data['volx'] ?? '-'}', style: pw.TextStyle(fontSize: 12)),
                      pw.Text('TAKIS: ${data['takis'] ?? '-'}', style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('TRIBE: ${data['tribe'] ?? '-'}', style: pw.TextStyle(fontSize: 12)),
                      pw.Text('CT: ${data['ct'] ?? '-'}', style: pw.TextStyle(fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            // RINGKASAN
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(12),
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('INSIDE :', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Divider(color: PdfColors.grey300),
                    pw.SizedBox(height: 4),
                    pw.Text('${data['inside'] ?? '-'}', style: const pw.TextStyle(fontSize: 12, lineSpacing: 2)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    name: 'Laporan_Vape_${data['storeName'] ?? 'Toko'}.pdf',
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TVA App',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Biru gelap profesional
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF3B82F6),
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: const DataFormPage(),
    );
  }
}

class DataFormPage extends StatefulWidget {
  const DataFormPage({super.key});

  @override
  State<DataFormPage> createState() => _DataFormPageState();
}

class _DataFormPageState extends State<DataFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _storeNameCtrl = TextEditingController();
  final TextEditingController _ownerNameCtrl = TextEditingController();
  final TextEditingController _picNameCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _volxCtrl = TextEditingController();
  final TextEditingController _takisCtrl = TextEditingController();
  final TextEditingController _tribeCtrl = TextEditingController();
  final TextEditingController _ctCtrl = TextEditingController();
  final TextEditingController _insideCtrl = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Map<String, dynamic> _getFormData() {
    return {
      'storeName': _storeNameCtrl.text,
      'ownerName': _ownerNameCtrl.text,
      'picName': _picNameCtrl.text,
      'address': _addressCtrl.text,
      'volx': _volxCtrl.text,
      'takis': _takisCtrl.text,
      'tribe': _tribeCtrl.text,
      'ct': _ctCtrl.text,
      'inside': _insideCtrl.text,
      'imagePath': _image?.path,
    };
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _storeNameCtrl.clear();
    _ownerNameCtrl.clear();
    _picNameCtrl.clear();
    _addressCtrl.clear();
    _volxCtrl.clear();
    _takisCtrl.clear();
    _tribeCtrl.clear();
    _ctCtrl.clear();
    _insideCtrl.clear();
    setState(() {
      _image = null;
    });
  }

  Future<void> _saveOnly() async {
    if (!_formKey.currentState!.validate()) return;
    
    await DatabaseHelper.instance.insertStore(_getFormData());
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Data berhasil disimpan ke Riwayat!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _clearForm();
    }
  }

  Future<void> _saveAndGeneratePdf() async {
    if (!_formKey.currentState!.validate()) return;
    
    // 1. Ambil data
    final data = _getFormData();
    
    // 2. Simpan ke database
    await DatabaseHelper.instance.insertStore(data);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Data otomatis tersimpan. Membuka PDF...'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _clearForm();
    }

    // 3. Tampilkan PDF (Data menggunakan variabel 'data' yang belum di-clear)
    await generateAndPrintPdf(data);
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Laporan Visit', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_edu, color: Color(0xFF1E3A8A)),
            tooltip: 'Riwayat Laporan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CARD 1: INFORMASI TOKO
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Informasi Toko', Icons.storefront),
                      TextFormField(
                        controller: _storeNameCtrl,
                        decoration: const InputDecoration(labelText: 'Nama Vape Store *', prefixIcon: Icon(Icons.store)),
                        validator: (value) => value!.isEmpty ? 'Nama toko harus diisi' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ownerNameCtrl,
                              decoration: const InputDecoration(labelText: 'Nama Owner *', prefixIcon: Icon(Icons.person)),
                              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _picNameCtrl,
                              decoration: const InputDecoration(labelText: 'Nama PIC *', prefixIcon: Icon(Icons.badge)),
                              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressCtrl,
                        decoration: const InputDecoration(labelText: 'Alamat Toko Lengkap *', prefixIcon: Icon(Icons.location_on)),
                        maxLines: 2,
                        validator: (value) => value!.isEmpty ? 'Alamat harus diisi' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // CARD 2: DATA INVENTORY
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Data Inventory / Status', Icons.inventory),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _volxCtrl,
                              decoration: const InputDecoration(labelText: 'VOLX'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _takisCtrl,
                              decoration: const InputDecoration(labelText: 'TAKIS'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _tribeCtrl,
                              decoration: const InputDecoration(labelText: 'TRIBE'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _ctCtrl,
                              decoration: const InputDecoration(labelText: 'CT'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // CARD 3: INSIDE & FOTO
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Inside & Dokumentasi', Icons.analytics),
                      TextFormField(
                        controller: _insideCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Ringkasan / Apa yang didapat (Inside)',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),
                      
                      Text('Foto Dokumentasi', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      if (_image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, height: 200, width: double.infinity, fit: BoxFit.cover),
                        )
                      else
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                          ),
                          child: Center(
                            child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey.shade400),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Kamera'),
                              onPressed: () => _pickImage(ImageSource.camera),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Galeri'),
                              onPressed: () => _pickImage(ImageSource.gallery),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // BUTTONS
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('SIMPAN & GENERATE PDF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: _saveAndGeneratePdf,
              ),
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _saveOnly,
                child: const Text('Simpan ke Riwayat Saja', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _stores = [];

  @override
  void initState() {
    super.initState();
    _refreshStores();
  }

  Future<void> _refreshStores() async {
    final data = await DatabaseHelper.instance.getAllStores();
    setState(() {
      _stores = data;
    });
  }

  Future<void> _deleteStore(int id) async {
    await DatabaseHelper.instance.deleteStore(id);
    _refreshStores();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dihapus')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Riwayat Kunjungan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: _stores.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('Belum ada data toko', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _stores.length,
              itemBuilder: (context, index) {
                final store = _stores[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    shape: const Border(), // Hilangkan garis saat dibuka
                    leading: (store['imagePath'] != null && store['imagePath'].toString().isNotEmpty)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(store['imagePath']), width: 50, height: 50, fit: BoxFit.cover),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: const Icon(Icons.store, color: Colors.blue),
                          ),
                    title: Text(store['storeName'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(store['address'] ?? 'No Address', maxLines: 1, overflow: TextOverflow.ellipsis),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Owner: ${store['ownerName']} | PIC: ${store['picName']}'),
                            const Divider(),
                            Text('VOLX: ${store['volx']} | TAKIS: ${store['takis']}'),
                            Text('TRIBE: ${store['tribe']} | CT: ${store['ct']}'),
                            const Divider(),
                            const Text('INSIDE:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${store['inside']}', style: const TextStyle(fontStyle: FontStyle.italic)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  label: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                  onPressed: () => _deleteStore(store['id']),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E3A8A),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                                  label: const Text('Cetak PDF'),
                                  onPressed: () {
                                    generateAndPrintPdf(store);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
