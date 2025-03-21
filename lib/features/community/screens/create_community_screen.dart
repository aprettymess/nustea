import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Community name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: communityNameController,
              decoration: const InputDecoration(
                hintText: 'n/community_name',
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18.0),
              ),
              maxLength: 21,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              child: Text(
                'Create Community',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
