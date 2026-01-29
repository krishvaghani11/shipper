import 'package:flutter/material.dart';
import 'add_branch_screen.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen({super.key});

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  /// Stores branches
  List<Map<String, String>> branches = [];

  /// Stores selected branch indexes
  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Branch Management"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ➕ ADD BRANCH
            _actionTile(
              icon: Icons.add_business,
              title: "Add New Branch",
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddBranchScreen(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    branches.add(result);
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            /// 🗑 DELETE BRANCH
            _actionTile(
              icon: Icons.delete,
              title: "Delete Selected Branch",
              color: Colors.red,
              onTap: _deleteSelectedBranches,
            ),

            const SizedBox(height: 20),

            /// SAVED BRANCHES
            if (branches.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Saved Branches",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _toggleSelectAll,
                    child: Text(
                      selectedIndexes.length == branches.length
                          ? "Unselect All"
                          : "Select All",
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 10),

            /// BRANCH LIST
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final branch = branches[index];
                final isSelected = selectedIndexes.contains(index);

                return InkWell(
                  onTap: () => _toggleSelection(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.orange.withOpacity(0.15)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                        isSelected ? Colors.orange : Colors.grey.shade300,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          activeColor: Colors.orange,
                          onChanged: (_) => _toggleSelection(index),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                branch["name"] ?? "",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                branch["designation"] ?? "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (branches.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    "No branches added yet",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  void _toggleSelection(int index) {
    setState(() {
      selectedIndexes.contains(index)
          ? selectedIndexes.remove(index)
          : selectedIndexes.add(index);
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (selectedIndexes.length == branches.length) {
        selectedIndexes.clear();
      } else {
        selectedIndexes =
            Set.from(List.generate(branches.length, (i) => i));
      }
    });
  }

  void _deleteSelectedBranches() {
    if (selectedIndexes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select branch to delete"),
        ),
      );
      return;
    }

    setState(() {
      branches = branches
          .asMap()
          .entries
          .where((e) => !selectedIndexes.contains(e.key))
          .map((e) => e.value)
          .toList();
      selectedIndexes.clear();
    });
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.orange,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

