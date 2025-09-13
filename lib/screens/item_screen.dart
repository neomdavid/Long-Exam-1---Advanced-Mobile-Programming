import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/item_model.dart';
import '../services/item_service.dart';
import '../widgets/custom_text.dart';
import 'detail_screen.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final _svc = ItemService();
  final List<Item> _items = [];
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadItems();
  }

  Future<void> _loadItems() async {
    final res = await _svc.getAllItem();
    // Support both items:[...] and [...]
    final list = (res['items'] ?? res) as dynamic;
    final List data = list is List ? list : (list['data'] ?? []);
    setState(() {
      _items.clear();
      _items.addAll(data.map((e) => Item.fromJson(e)));
    });
  }

  Future<void> _openAddItemDialog() async {
    // ---- Add Item Dialog ----
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final photoCtrl = TextEditingController();
    final qtyTotalCtrl = TextEditingController();
    final qtyAvailCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;
    bool isActive = true;

    List<String> _parseDesc(String raw) {
      return raw
          .split(RegExp(r'[\n,]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    String? _req(String? v) {
      return (v?.trim().isEmpty ?? true) ? 'Required' : null;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: !isSaving,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            Future<void> _save() async {
              if (isSaving) return;
              if (!formKey.currentState!.validate()) return;
              setLocal(() => isSaving = true);
              try {
                final payload = {
                  'name': nameCtrl.text.trim(),
                  'description': _parseDesc(descCtrl.text),
                  'photoUrl': photoCtrl.text.trim(),
                  'qtyTotal': int.parse(qtyTotalCtrl.text.trim()),
                  'qtyAvailable': int.parse(qtyAvailCtrl.text.trim()),
                  'isActive': isActive,
                };
                final res = await _svc.createItem(payload);
                final created = (res['item'] ?? res);
                final newItem = Item.fromJson(created);
                setState(() => _items.insert(0, newItem));
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item added.')),
                  );
                }
              } catch (e) {
                setLocal(() => isSaving = false);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add: $e')),
                  );
                }
              }
            }

            return AlertDialog(
              title: const Text('Add Item'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: _req,
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: descCtrl,
                        minLines: 2,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Description (one per line or comma-sep)',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        validator: (v) => _parseDesc(v ?? '').isEmpty
                            ? 'Add at least one line'
                            : null,
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        controller: photoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Photo URL (optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: qtyTotalCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Qty Total',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                final n = int.tryParse((v ?? '').trim());
                                if (n == null || n < 0) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: TextFormField(
                              controller: qtyAvailCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Qty Available',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                final a = int.tryParse((v ?? '').trim());
                                final t =
                                    int.tryParse(qtyTotalCtrl.text.trim());
                                if (a == null || a < 0) return 'Invalid';
                                if (t != null && a > t) return '> total';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Active'),
                        value: isActive,
                        onChanged: (v) => setLocal(() => isActive = v),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton.icon(
                  onPressed: isSaving ? null : _save,
                  icon: isSaving
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(isSaving ? 'Saving...' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _leadingThumb(Item item) {
    if (item.photoUrl.isEmpty) {
      return Container(
        width: 72.sp,
        height: 72.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Icon(Icons.inventory_2_outlined),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        item.photoUrl,
        width: 72.sp,
        height: 72.sp,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 72.sp,
          height: 72.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddItemDialog,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<void>(
        future: _loadFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator.adaptive(strokeWidth: 3.sp),
                    SizedBox(height: 20.h),
                    const CustomText('Loading items...'),
                  ],
                ),
              ),
            );
          }

          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: CustomText('Failed to load items: ${snap.error}'),
              ),
            );
          }

          if (_items.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: const CustomText('No items to display...'),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            itemCount: _items.length,
            itemBuilder: (_, index) {
              final item = _items[index];
              final subtitleText = item.description.isNotEmpty
                  ? item.description.join(', ')
                  : '-';

              return Card(
                margin: EdgeInsets.only(bottom: 12.h),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: InkWell(
                  onTap: () async {
                    debugPrint('Open item ${item.iid}');
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailScreen(item: item)),
                    );

                    // If deleted:
                    if (result is Map && result['deleted'] == true) {
                      final id = result['id'] as String;
                      setState(() {
                        _items.removeWhere((e) => e.iid == id);
                      });
                    }
                    // If updated:
                    else if (result is Item) {
                      setState(() {
                        final i = _items.indexWhere((e) => e.iid == result.iid);
                        if (i != -1) {
                          _items[i] = result;
                        }
                      });
                    }
                  },
                  child: ListTile(
                    leading: _leadingThumb(item),
                    title: CustomText(
                      item.name.isEmpty ? 'Untitled' : item.name,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: CustomText(
                      subtitleText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: SizedBox(
                      height: double.infinity,
                      child: GestureDetector(
                        onTap: () => debugPrint('More ${item.iid}'),
                        child: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
