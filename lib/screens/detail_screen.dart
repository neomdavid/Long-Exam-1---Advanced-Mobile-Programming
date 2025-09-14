import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/item_model.dart';
import '../services/item_service.dart';

class DetailScreen extends StatefulWidget {
  final Item item;

  const DetailScreen({
    super.key,
    required this.item,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _photoCtrl;
  late TextEditingController _qtyTotalCtrl;
  late TextEditingController _qtyAvailCtrl;
  late bool _isActive;
  bool _isSaving = false;
  final _svc = ItemService();
  late Item _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _nameCtrl = TextEditingController(text: _item.name);
    _descCtrl = TextEditingController(text: _item.description.join('\n'));
    _photoCtrl = TextEditingController(text: _item.photoUrl);
    _qtyTotalCtrl = TextEditingController(text: _item.qtyTotal);
    _qtyAvailCtrl = TextEditingController(text: _item.qtyAvailable);
    _isActive = _item.isActive;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _photoCtrl.dispose();
    _qtyTotalCtrl.dispose();
    _qtyAvailCtrl.dispose();
    super.dispose();
  }

  List<String> _parseDesc(String raw) {
    return raw
        .split(RegExp(r'[\n,]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  int _toInt(TextEditingController c, {int fallback = 0}) {
    final v = int.tryParse(c.text.trim());
    return (v != null && v >= 0) ? v : fallback;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final total = _toInt(_qtyTotalCtrl, fallback: 0);
    final avail = _toInt(_qtyAvailCtrl, fallback: 0);
    if (avail > total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Qty Available cannot exceed Qty Total')),
      );
      return;
    }
    final payload = {
      'name': _nameCtrl.text.trim(),
      'description': _parseDesc(_descCtrl.text),
      'photoUrl': _photoCtrl.text.trim(),
      'qtyTotal': total,
      'qtyAvailable': avail,
      'isActive': _isActive,
    };
    setState(() => _isSaving = true);
    try {
      final res = await _svc.updateItem(_item.iid, payload);
      final updated = (res['item'] ?? res);
      final updatedItem = Item.fromJson(updated);
      setState(() => _item = updatedItem);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item updated.')),
      );
      Navigator.of(context).pop(updatedItem);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _confirmDelete() async {
    if (_isActive) {
      // Archive active item
      final yes = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Archive Item'),
          content: const Text(
              'Are you sure you want to archive this item? It will be moved to the archive and can be deleted from there.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Archive'),
            ),
          ],
        ),
      );
      if (yes != true) return;
      setState(() => _isSaving = true);
      try {
        // Update item to inactive
        await _svc.updateItem(_item.iid, {
          'name': _item.name,
          'description': _item.description,
          'photoUrl': _item.photoUrl,
          'qtyTotal': _item.qtyTotal,
          'qtyAvailable': _item.qtyAvailable,
          'isActive': false,
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item archived successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop({'archived': true, 'id': _item.iid});
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to archive: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    } else {
      // Delete inactive item permanently
      final yes = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Item'),
          content: const Text(
              'Are you sure you want to permanently delete this archived item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (yes != true) return;
      setState(() => _isSaving = true);
      try {
        await _svc.deleteItem(_item.iid);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item deleted permanently.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop({'deleted': true, 'id': _item.iid});
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Widget _imagePreview() {
    final url = _photoCtrl.text.trim();
    if (url.isEmpty) {
      return Container(
        height: 160.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.inventory_2_outlined, size: 48),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: 160.h,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 160.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
                const SizedBox(height: 8),
                const Text('Loading image...'),
              ],
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          height: 160.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image_outlined, size: 48),
              SizedBox(height: 8),
              Text('Failed to load image'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.name.isEmpty ? 'Item' : _item.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imagePreview(),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _photoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Photo URL',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() {}),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v?.trim().isEmpty ?? true) ? 'Required' : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _descCtrl,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Description (one per line or comma-separated)',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (v) => _parseDesc(v ?? '').isEmpty
                      ? 'Add at least one line'
                      : null,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _qtyTotalCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Qty Total',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          final n = int.tryParse(v?.trim() ?? '');
                          return (n == null || n < 0) ? 'Invalid' : null;
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextFormField(
                        controller: _qtyAvailCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Qty Available',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          final a = int.tryParse(v?.trim() ?? '');
                          final t = int.tryParse(_qtyTotalCtrl.text);
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
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _save,
                    icon: _isSaving
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isSaving ? null : _confirmDelete,
                    icon:
                        Icon(_isActive ? Icons.archive : Icons.delete_outline),
                    label:
                        Text(_isActive ? 'Archive Item' : 'Delete Permanently'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _isActive ? Colors.orange : Colors.red,
                      side: BorderSide(
                        color: _isActive ? Colors.orange : Colors.red,
                      ),
                    ),
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
