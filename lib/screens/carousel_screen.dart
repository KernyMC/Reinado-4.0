import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({super.key});

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  List<Map<String, dynamic>> candidatas = [];
  bool isLoading = true;
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchCandidatas();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _extractFileName(String? filePath) {
    if (filePath == null || filePath.isEmpty) return 'candidate_placeholder.png';
    final normalizedPath = filePath.replaceAll('\\', '/');
    return normalizedPath.split('/').last;
  }

  Widget _buildImage(String? fotoCarruselUrl) {
    if (fotoCarruselUrl == null || fotoCarruselUrl.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    }

    final String fileName = _extractFileName(fotoCarruselUrl);
    return Image.asset(
      'assets/carrusel/$fileName',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image: $fileName - $error');
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchCandidatas() async {
    if (!mounted) return;
    
    try {
      final data = await ApiService.get('/candidatas/carruselCandidatas');
      if (!mounted) return;
      
      setState(() {
        candidatas = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al cargar las candidatas'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error en fetchCandidatas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Candidatas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchCandidatas,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D4F02), Color(0xFF002401)],
          ),
        ),
        child: PageView.builder(
          controller: _pageController,
          itemCount: candidatas.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final candidata = candidatas[index];
            return Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _buildImage(candidata['FOTO_CARRUSEL_URL']),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D4F02),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${candidata['CAND_NOMBRE1']} ${candidata['CAND_APELLIDOPATERNO']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        candidata['CARRERA_NOMBRE'] ?? 'Carrera no especificada',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${candidata['DEPARTMENTO_NOMBRE']} - ${candidata['DEPARTAMENTO_SEDE']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          candidatas.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
} 