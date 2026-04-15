import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myminiblog/viewmodals/createpost_viewmodel.dart';
import 'package:provider/provider.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_title.text.isEmpty || _description.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields including image are required")),
      );
      return;
    }

    final viewModel = Provider.of<CreatePostViewModel>(context, listen: false);
    final success = await viewModel.createPost(
      title: _title.text,
      description: _description.text,
      image: _selectedImage!,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New post created successfully!"),
          backgroundColor: Colors.deepPurple,
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? "Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CreatePostViewModel>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(209, 237, 229, 229),
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Create Post",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        elevation: 10,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("Share your thoughts with the community"),

            // Title
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: InputBorder.none,
                ),
              ),
            ),

            // Description
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _description,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: InputBorder.none,
                ),
              ),
            ),

            // Image Upload
            const SizedBox(height: 20),
            (_selectedImage == null)
                ? Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_file_outlined),
                  const SizedBox(width: 8),
                  const Text("Upload image"),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text("Upload",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            )
                : Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    _selectedImage!,
                    height: 100,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: -20,
                  right: -20,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    icon: const Icon(Icons.cancel_outlined,
                        color: Colors.red),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Submit button
            viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color.fromARGB(255, 58, 49, 231),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Create Post",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
