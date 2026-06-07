import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model.dart';
import '../../controllers/provider.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Car car;
  const ServiceDetailsScreen({Key? key, required this.car}) : super(key: key);

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadServices(widget.car.id!);
    });
  }

  void _showServiceForm(BuildContext context, {ServiceRecord? existingService}) {
    final isEditing = existingService != null;
    final descController = TextEditingController(text: existingService?.description ?? '');
    final costController = TextEditingController(text: existingService?.cost.toString() ?? '');
    final oilController = TextEditingController(text: existingService?.oilUsed ?? '');
    final mileageController = TextEditingController(text: existingService?.mileage.toString() ?? '');
    
    DateTime selectedDate = isEditing 
        ? DateTime.parse(existingService.date) 
        : DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isEditing ? 'Servis Kaydını Düzenle' : 'Yeni Servis Kaydı Ekle',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Yapılan İşlem (Açıklama)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.build),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: costController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Ücret (TL)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: mileageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Kilometre',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.speed),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: oilController,
                      decoration: const InputDecoration(
                        labelText: 'Kullanılan Yağ (Marka/Vizkozite)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.water_drop),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Tarih: ${selectedDate.toIso8601String().substring(0, 10)}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setModalState(() => selectedDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        if (descController.text.isEmpty || costController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Lütfen gerekli alanları doldurun.')),
                          );
                          return;
                        }

                        final dateStr = selectedDate.toIso8601String().substring(0, 10);
                        final cost = double.tryParse(costController.text) ?? 0.0;
                        final mileage = int.tryParse(mileageController.text) ?? 0;

                        if (isEditing) {
                          context.read<AppProvider>().updateService(ServiceRecord(
                                id: existingService.id,
                                carId: existingService.carId,
                                description: descController.text,
                                date: dateStr,
                                cost: cost,
                                oilUsed: oilController.text,
                                mileage: mileage,
                              ));
                        } else {
                          context.read<AppProvider>().addService(
                                carId: widget.car.id!,
                                description: descController.text,
                                date: dateStr,
                                cost: cost,
                                oilUsed: oilController.text,
                                mileage: mileage,
                              );
                        }
                        Navigator.pop(ctx);
                      },
                      child: Text(isEditing ? 'Güncelle' : 'Kaydet'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, AppProvider provider, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kaydı Sil'),
        content: const Text('Bu servis kaydını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteService(id);
              Navigator.pop(ctx);
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.car.brand} ${widget.car.model} Servisleri'),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.currentServices.isEmpty) {
            return const Center(child: Text('Henüz servis kaydı bulunmuyor.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.currentServices.length,
            itemBuilder: (context, index) {
              final service = provider.currentServices[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              service.description,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blueGrey, size: 20),
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(4),
                                onPressed: () => _showServiceForm(context, existingService: service),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(4),
                                onPressed: () => _confirmDelete(context, provider, service.id!),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      _infoRow(Icons.calendar_today, 'Tarih:', service.date),
                      const SizedBox(height: 4),
                      _infoRow(Icons.speed, 'Kilometre:', '${service.mileage} km'),
                      const SizedBox(height: 4),
                      _infoRow(Icons.water_drop, 'Kullanılan Yağ:', service.oilUsed.isNotEmpty ? service.oilUsed : 'Belirtilmedi'),
                      const SizedBox(height: 4),
                      _infoRow(Icons.attach_money, 'Tutar:', '${service.cost.toStringAsFixed(2)} TL', color: Colors.green[700]),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () => _showServiceForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[800]),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(color: color ?? Colors.black87, fontWeight: color != null ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}