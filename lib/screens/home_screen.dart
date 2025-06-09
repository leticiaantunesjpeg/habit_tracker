import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/habit_provider.dart';
import '../providers/theme_provider.dart';
import '../models/habit.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_progress_button.dart';
import '../widgets/app_logo.dart';
import './details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _selectedView = 'Diário';
  bool _isInitialized = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    setState(() {
      _isInitialized = true;
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.currentTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.background, theme.surface],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        title: _searchQuery.isEmpty
            ? Row(
                children: [
                  AppLogoWidget(
                    size: 42,
                    primaryColor: theme.primary,
                    backgroundColor: theme.primary,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Rastreador de Hábitos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar hábitos...',
                  hintStyle: const TextStyle(color: AppTheme.textSecondaryColor),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: theme.primary),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: AppTheme.textSecondaryColor),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
        actions: [
          if (_searchQuery.isEmpty)
            IconButton(
              icon: Icon(Icons.search, color: theme.primary),
              onPressed: () {
                setState(() {
                  _searchQuery = ' ';
                  _searchController.text = '';
                });
              },
            ),
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      _selectedView = value;
                    });
                  },
                  icon: Icon(
                    Icons.filter_list, 
                    color: theme.primary,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'Diário', 
                      child: Text('Visão Diária', style: AppTheme.bodyStyle),
                    ),
                    PopupMenuItem(
                      value: 'Semanal', 
                      child: Text('Visão Semanal', style: AppTheme.bodyStyle),
                    ),
                    PopupMenuItem(
                      value: 'Mensal', 
                      child: Text('Visão Mensal', style: AppTheme.bodyStyle),
                    ),
                  ],
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.palette_outlined,
              color: theme.primary,
            ),
            onSelected: (value) {
              ColorScheme newTheme;
              switch (value) {
                case 'Oceano':
                  newTheme = const ColorScheme.dark(
                    primary: Color(0xFF3498DB),
                    secondary: Color(0xFF9B59B6),
                    surface: Color(0xFF2C3E50),
                    background: Color(0xFF1E2A38),
                  );
                  break;
                case 'Floresta':
                  newTheme = const ColorScheme.dark(
                    primary: Color(0xFF2ECC71),
                    secondary: Color(0xFFF1C40F),
                    surface: Color(0xFF27AE60),
                    background: Color(0xFF1E4A2B),
                  );
                  break;
                case 'Pôr do Sol':
                  newTheme = const ColorScheme.dark(
                    primary: Color(0xFFE67E22),
                    secondary: Color(0xFFE74C3C),
                    surface: Color(0xFF34495E),
                    background: Color(0xFF2C3E50),
                  );
                  break;
                default:
                  return;
              }
              themeProvider.setTheme(newTheme);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Oceano',
                child: Row(
                  children: [
                    Icon(Icons.water_outlined, color: Color(0xFF3498DB)),
                    SizedBox(width: 8),
                    Text('Oceano', style: AppTheme.bodyStyle),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Floresta',
                child: Row(
                  children: [
                    Icon(Icons.forest_outlined, color: Color(0xFF2ECC71)),
                    SizedBox(width: 8),
                    Text('Floresta', style: AppTheme.bodyStyle),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'Pôr do Sol',
                child: Row(
                  children: [
                    Icon(Icons.wb_twilight_outlined, color: Color(0xFFE67E22)),
                    SizedBox(width: 8),
                    Text('Pôr do Sol', style: AppTheme.bodyStyle),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppTheme.errorColor),
            onPressed: () {
              _showDeleteConfirmationDialog(context, habitProvider);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.background, theme.surface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _buildHabitsList(habitProvider, theme),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fadeAnimation.value,
            child: FloatingActionButton.extended(
              onPressed: () {
                _showAddHabitDialog(context, habitProvider);
              },
              backgroundColor: theme.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Novo Hábito',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              elevation: 8,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHabitsList(HabitProvider habitProvider, ColorScheme theme) {
    if (habitProvider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Carregando seus hábitos...',
              style: AppTheme.subheadingStyle,
            ),
          ],
        ),
      );
    }
    
    final habits = habitProvider.habits.where((habit) {
      String normalizeFrequency(String freq) {
        return freq.replaceAll('á', 'a')
                  .replaceAll('ário', 'ario')
                  .toLowerCase();
      }

      String habitFreq = normalizeFrequency(habit.frequency);
      String selectedFreq = normalizeFrequency(_selectedView);
      
      bool matchesFrequency = true;
      switch (_selectedView) {
        case 'Diário':
          matchesFrequency = habitFreq.contains('diario') || habitFreq.contains('diaria');
          break;
        case 'Semanal':
          matchesFrequency = habitFreq.contains('semanal');
          break;
        case 'Mensal':
          matchesFrequency = habitFreq.contains('mensal');
          break;
      }

      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        matchesSearch = habit.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }

      return matchesFrequency && matchesSearch;
    }).toList();

    if (habits.isEmpty) {
      return SingleChildScrollView(
        child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        _searchQuery.isEmpty ? Icons.lightbulb_outline : Icons.search_off,
                        size: 60,
                        color: _searchQuery.isEmpty ? theme.primary : AppTheme.warningColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _searchQuery.isEmpty 
                          ? 'Nenhum hábito encontrado'
                          : 'Nenhum hábito corresponde à busca',
                      style: AppTheme.subheadingStyle,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'Que tal criar um novo hábito para melhorar sua rotina?'
                            : 'Tente buscar com outros termos',
                        textAlign: TextAlign.center,
                        style: AppTheme.captionStyle,
                      ),
                    ),
                    if (_searchQuery.isEmpty) ...[
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showAddHabitDialog(context, habitProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 5,
                        ),
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text(
                          'Adicionar Hábito',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    }

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              final isNumericFrequency = int.tryParse(habit.frequency) != null;
              int freqTotal = isNumericFrequency ? int.parse(habit.frequency) : 1;
              int freqDone = habit.isCompleted ? freqTotal : 0;
              
              return Hero(
                tag: 'habit-${habit.id}',
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        0.2 + (index / habits.length) * 0.6,
                        1.0,
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => 
                            DetailsScreen(habit: habit),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: habit.isCompleted 
                                ? AppTheme.successGradient
                                : AppTheme.pendingGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AnimatedProgressButton(
                                    isCompleted: habit.isCompleted,
                                    hasMultipleSteps: habit.total > 1,
                                    progress: habit.progress,
                                    total: habit.total,
                                    onTap: () async {
                                      await habitProvider.toggleHabitCompletion(habit);
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          habit.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            habit.frequency,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (habit.total > 1)
                                        IconButton(
                                          icon: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              habit.isCompleted 
                                                ? Icons.check_circle
                                                : Icons.add_circle_outline,
                                              color: habit.isCompleted 
                                                ? Colors.white.withOpacity(0.7)
                                                : Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          onPressed: () async {
                                            await habitProvider.toggleHabitCompletion(habit);
                                          },
                                        ),
                                      IconButton(
                                        icon: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                        onPressed: () {
                                          _showEditHabitDialog(context, habitProvider, habit);
                                        },
                                      ),
                                      IconButton(
                                        icon: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                        onPressed: () {
                                          _showDeleteHabitDialog(context, habitProvider, habit);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (habit.notes != null && habit.notes!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                const Divider(color: Colors.white24),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.note, color: Colors.white70, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        habit.notes!.length > 80 
                                            ? '${habit.notes!.substring(0, 80)}...' 
                                            : habit.notes!,
                                        style: const TextStyle(
                                          color: Colors.white70, 
                                          fontSize: 13,
                                          fontStyle: FontStyle.italic
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showAddHabitDialog(BuildContext context, HabitProvider habitProvider) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController totalController = TextEditingController();
    final List<String> frequencies = ['Diária', 'Semanal', 'Mensal'];
    String selectedFrequency = 'Diária';
    String? selectedStartTime;
    String? selectedEndTime;

    Future<void> _selectTime(BuildContext context, bool isStartTime) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        cancelText: 'Cancelar',
        confirmText: 'OK',
        helpText: 'Selecione o horário',
        builder: (context, child) {
          // Aplicando tema e localização em português
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: AppTheme.cardColor,
                hourMinuteTextColor: Colors.white,
                dialHandColor: AppTheme.primaryColor,
                dialBackgroundColor: AppTheme.cardColor,
                dialTextColor: Colors.white,
                entryModeIconColor: AppTheme.primaryColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        final timeString = '$hour:$minute';
        
        if (isStartTime) {
          selectedStartTime = timeString;
        } else {
          selectedEndTime = timeString;
        }
      }
    };
    String getFrequencyLabel() {
      switch (selectedFrequency) {
        case 'Diária':
          return 'por dia';
        case 'Semanal':
          return 'por semana';
        case 'Mensal':
          return 'por mês';
        default:
          return '';
      }
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.cardColor, Color(0xFF34495E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add_task,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Criar Novo Hábito',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: AppTheme.textFieldDecoration(
                        'Nome do Hábito',
                        prefixIcon: const Icon(
                          Icons.edit,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedFrequency,
                      dropdownColor: AppTheme.cardColor,
                      style: const TextStyle(color: Colors.white),
                      decoration: AppTheme.textFieldDecoration(
                        'Frequência',
                        prefixIcon: const Icon(
                          Icons.calendar_today,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedFrequency = value!;
                        });
                      },
                      items: frequencies.map((freq) => 
                        DropdownMenuItem(
                          value: freq, 
                          child: Text(freq),
                        )
                      ).toList(),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: totalController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: AppTheme.textFieldDecoration(
                        'Número de vezes ${getFrequencyLabel()}',
                        prefixIcon: const Icon(
                          Icons.repeat,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Janela de Tempo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                selectedStartTime = '${pickedDate.toLocal()}'.split(' ')[0];
                                setState(() {});
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              selectedStartTime ?? 'Início (Dia)',
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.cardColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                selectedEndTime = '${pickedDate.toLocal()}'.split(' ')[0];
                                setState(() {});
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: Text(
                              selectedEndTime ?? 'Fim (Dia)',
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.cardColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.textSecondaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isNotEmpty && totalController.text.isNotEmpty) {
                              try {
                                final total = int.tryParse(totalController.text) ?? 1;
                                await habitProvider.addHabit(
                                  nameController.text,
                                  selectedFrequency,
                                  total,
                                  startTime: selectedStartTime,
                                  endTime: selectedEndTime,
                                );
                                if (mounted) Navigator.pop(context);
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro ao adicionar hábito: $e'),
                                      backgroundColor: AppTheme.errorColor,
                                    ),
                                  );
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Preencha todos os campos obrigatórios'),
                                  backgroundColor: AppTheme.warningColor,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Adicionar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, HabitProvider habitProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: const Text(
            'Confirmar Exclusão',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Tem certeza de que deseja excluir todos os hábitos?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.textSecondaryColor,
              ),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await habitProvider.deleteAllHabits();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.warningColor,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }


  void _showEditHabitDialog(BuildContext context, HabitProvider habitProvider, Habit habit) {
    final TextEditingController nameController = TextEditingController(text: habit.name);
    final TextEditingController totalController = TextEditingController(text: habit.total.toString());
    String? selectedStartTime = habit.startTime;
    String? selectedEndTime = habit.endTime;
    final List<String> frequencies = ['Diária', 'Semanal', 'Mensal'];
    String selectedFrequency = habit.frequency;

    Future<void> _selectTime(BuildContext context, bool isStartTime) async {
      TimeOfDay? initialTime;
      if (isStartTime && selectedStartTime != null) {
        final parts = selectedStartTime?.split(':');
        if (parts != null && parts.length == 2) {
          initialTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
      } else if (!isStartTime && selectedEndTime != null) {
        final parts = selectedEndTime?.split(':');
        if (parts != null && parts.length == 2) {
          initialTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
      }

      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: initialTime ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: AppTheme.cardColor,
                hourMinuteTextColor: Colors.white,
                dialHandColor: AppTheme.primaryColor,
                dialBackgroundColor: AppTheme.cardColor,
                dialTextColor: Colors.white,
                entryModeIconColor: AppTheme.primaryColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        final timeString = '$hour:$minute';
        setState(() {
          if (isStartTime) {
            selectedStartTime = timeString;
          } else {
            selectedEndTime = timeString;
          }
        });
      }
    };

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.cardColor, Color(0xFF34495E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            'Editar Hábito',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: AppTheme.textFieldDecoration(
                          'Nome do Hábito',
                          prefixIcon: const Icon(
                            Icons.edit,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: selectedFrequency,
                        dropdownColor: AppTheme.cardColor,
                        style: const TextStyle(color: Colors.white),
                        decoration: AppTheme.textFieldDecoration(
                          'Frequência',
                          prefixIcon: const Icon(
                            Icons.calendar_today,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedFrequency = value!;
                          });
                        },
                        items: frequencies.map((freq) => 
                          DropdownMenuItem(
                            value: freq, 
                            child: Text(freq),
                          )
                        ).toList(),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: totalController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: AppTheme.textFieldDecoration(
                          'Número de vezes por ${selectedFrequency.toLowerCase()}',
                          prefixIcon: const Icon(
                            Icons.repeat,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Janela de Tempo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  selectedStartTime = '${pickedDate.toLocal()}'.split(' ')[0];
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: Text(
                                selectedStartTime ?? 'Início (Dia)',
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.cardColor,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  selectedEndTime = '${pickedDate.toLocal()}'.split(' ')[0];
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: Text(
                                selectedEndTime ?? 'Fim (Dia)',
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.cardColor,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.textSecondaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              if (nameController.text.isNotEmpty && totalController.text.isNotEmpty) {
                                try {
                                  final total = int.tryParse(totalController.text) ?? 1;
                                  await habitProvider.updateHabit(
                                    habit,
                                    nameController.text,
                                    selectedFrequency,
                                    total,
                                    selectedStartTime,
                                    selectedEndTime,
                                  );
                                  if (context.mounted) Navigator.pop(context);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Erro ao atualizar hábito: $e'),
                                        backgroundColor: AppTheme.errorColor,
                                      ),
                                    );
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Preencha todos os campos obrigatórios'),
                                    backgroundColor: AppTheme.warningColor,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Salvar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteHabitDialog(BuildContext context, HabitProvider habitProvider, Habit habit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: const Text(
            'Confirmar Exclusão',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Tem certeza de que deseja excluir o hábito "${habit.name}"?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.textSecondaryColor,
              ),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await habitProvider.deleteHabit(habit.id!);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.warningColor,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}